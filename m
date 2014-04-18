From: akpm@linux-foundation.org
Subject: + printk-return-really-stored-message-length.patch added to -mm
 tree
Date: Fri, 18 Apr 2014 12:03:51 -0700
Message-ID: <53517717.evMsNcBUMAUek/PR%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:41823 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752461AbaDRTDw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 18 Apr 2014 15:03:52 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, kay@vrfy.org, jkosina@suse.cz, jack@suse.cz, pmladek@suse.cz

Subject: + printk-return-really-stored-message-length.patch added to -mm tree
To: pmladek@suse.cz,jack@suse.cz,jkosina@suse.cz,kay@vrfy.org
From: akpm@linux-foundation.org
Date: Fri, 18 Apr 2014 12:03:51 -0700


The patch titled
     Subject: printk: return really stored message length
has been added to the -mm tree.  Its filename is
     printk-return-really-stored-message-length.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/printk-return-really-stored-message-length.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/printk-return-really-stored-message-length.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Petr Mladek <pmladek@suse.cz>
Subject: printk: return really stored message length

I wonder if anyone uses printk return value but it is there and should be
counted correctly.

This patch modifies log_store() to return the number of really stored
bytes from the 'text' part.  Also it handles the return value in
vprintk_emit().

Note that log_store() is used also in cont_flush() but we could ignore the
return value there.  The function works with characters that were already
counted earlier.  In addition, the store could newer fail here because the
length of the printed text is limited by the "cont" buffer and "dict" is
NULL.

Signed-off-by: Petr Mladek <pmladek@suse.cz>
Cc: Jan Kara <jack@suse.cz>
Cc: Jiri Kosina <jkosina@suse.cz>
Cc: Kay Sievers <kay@vrfy.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/printk/printk.c |   36 +++++++++++++++++++++---------------
 1 file changed, 21 insertions(+), 15 deletions(-)

diff -puN kernel/printk/printk.c~printk-return-really-stored-message-length kernel/printk/printk.c
--- a/kernel/printk/printk.c~printk-return-really-stored-message-length
+++ a/kernel/printk/printk.c
@@ -378,10 +378,10 @@ static u32 truncate_msg(u16 *text_len, u
 }
 
 /* insert record into the buffer, discard old ones, update heads */
-static void log_store(int facility, int level,
-		      enum log_flags flags, u64 ts_nsec,
-		      const char *dict, u16 dict_len,
-		      const char *text, u16 text_len)
+static int log_store(int facility, int level,
+		     enum log_flags flags, u64 ts_nsec,
+		     const char *dict, u16 dict_len,
+		     const char *text, u16 text_len)
 {
 	struct printk_log *msg;
 	u32 size, pad_len;
@@ -396,7 +396,7 @@ static void log_store(int facility, int
 				    &dict_len, &pad_len);
 		/* survive when the log buffer is too small for trunc_msg */
 		if (log_make_free_space(size))
-			return;
+			return 0;
 	}
 
 	if (log_next_idx + size + sizeof(struct printk_log) > log_buf_len) {
@@ -432,6 +432,8 @@ static void log_store(int facility, int
 	/* insert message */
 	log_next_idx += msg->len;
 	log_next_seq++;
+
+	return msg->text_len;
 }
 
 #ifdef CONFIG_SECURITY_DMESG_RESTRICT
@@ -1606,10 +1608,10 @@ asmlinkage int vprintk_emit(int facility
 			"BUG: recent printk recursion!";
 
 		recursion_bug = 0;
-		printed_len += strlen(recursion_msg);
+		text_len = strlen(recursion_msg);
 		/* emit KERN_CRIT message */
-		log_store(0, 2, LOG_PREFIX|LOG_NEWLINE, 0,
-			  NULL, 0, recursion_msg, printed_len);
+		printed_len += log_store(0, 2, LOG_PREFIX|LOG_NEWLINE, 0,
+					 NULL, 0, recursion_msg, text_len);
 	}
 
 	/*
@@ -1662,9 +1664,12 @@ asmlinkage int vprintk_emit(int facility
 			cont_flush(LOG_NEWLINE);
 
 		/* buffer line if possible, otherwise store it right away */
-		if (!cont_add(facility, level, text, text_len))
-			log_store(facility, level, lflags | LOG_CONT, 0,
-				  dict, dictlen, text, text_len);
+		if (cont_add(facility, level, text, text_len))
+			printed_len += text_len;
+		else
+			printed_len += log_store(facility, level,
+						 lflags | LOG_CONT, 0,
+						 dict, dictlen, text, text_len);
 	} else {
 		bool stored = false;
 
@@ -1683,11 +1688,12 @@ asmlinkage int vprintk_emit(int facility
 			cont_flush(LOG_NEWLINE);
 		}
 
-		if (!stored)
-			log_store(facility, level, lflags, 0,
-				  dict, dictlen, text, text_len);
+		if (stored)
+			printed_len += text_len;
+		else
+			printed_len += log_store(facility, level, lflags, 0,
+						 dict, dictlen, text, text_len);
 	}
-	printed_len += text_len;
 
 	/*
 	 * Try to acquire and then immediately release the console semaphore.
_

Patches currently in -mm which might be from pmladek@suse.cz are

printk-split-code-for-making-free-space-in-the-log-buffer.patch
printk-ignore-too-long-messages.patch
printk-split-message-size-computation.patch
printk-shrink-too-long-messages.patch
printk-return-really-stored-message-length.patch

