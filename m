From: akpm@linux-foundation.org
Subject: + printk-split-message-size-computation.patch added to -mm tree
Date: Fri, 18 Apr 2014 12:03:49 -0700
Message-ID: <53517715.a08P9gHsEk46euqv%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:41817 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751885AbaDRTDu (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 18 Apr 2014 15:03:50 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, kay@vrfy.org, jkosina@suse.cz, jack@suse.cz, pmladek@suse.cz

Subject: + printk-split-message-size-computation.patch added to -mm tree
To: pmladek@suse.cz,jack@suse.cz,jkosina@suse.cz,kay@vrfy.org
From: akpm@linux-foundation.org
Date: Fri, 18 Apr 2014 12:03:49 -0700


The patch titled
     Subject: printk: split message size computation
has been added to the -mm tree.  Its filename is
     printk-split-message-size-computation.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/printk-split-message-size-computation.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/printk-split-message-size-computation.patch

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
Subject: printk: split message size computation

We will want to recompute the message size when shrinking too long
messages.  Let's put the code into separate function.

The side effect of setting "pad_len" is not nice but it is worth removing
the code duplication.  Note that I will probably have one more usage for
this function when handling messages safe way in NMI context.

This patch does not change the existing behavior.

Signed-off-by: Petr Mladek <pmladek@suse.cz>
Cc: Jan Kara <jack@suse.cz>
Cc: Jiri Kosina <jkosina@suse.cz>
Cc: Kay Sievers <kay@vrfy.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/printk/printk.c |   16 +++++++++++++---
 1 file changed, 13 insertions(+), 3 deletions(-)

diff -puN kernel/printk/printk.c~printk-split-message-size-computation kernel/printk/printk.c
--- a/kernel/printk/printk.c~printk-split-message-size-computation
+++ a/kernel/printk/printk.c
@@ -339,6 +339,18 @@ static int log_make_free_space(u32 msg_s
 	return -ENOMEM;
 }
 
+/* compute the message size including the padding bytes */
+static u32 msg_used_size(u16 text_len, u16 dict_len, u32 *pad_len)
+{
+	u32 size;
+
+	size = sizeof(struct printk_log) + text_len + dict_len;
+	*pad_len = (-size) & (LOG_ALIGN - 1);
+	size += *pad_len;
+
+	return size;
+}
+
 /* insert record into the buffer, discard old ones, update heads */
 static void log_store(int facility, int level,
 		      enum log_flags flags, u64 ts_nsec,
@@ -349,9 +361,7 @@ static void log_store(int facility, int
 	u32 size, pad_len;
 
 	/* number of '\0' padding bytes to next message */
-	size = sizeof(struct printk_log) + text_len + dict_len;
-	pad_len = (-size) & (LOG_ALIGN - 1);
-	size += pad_len;
+	size = msg_used_size(text_len, dict_len, &pad_len);
 
 	/* if message does not fit empty log buffer, ignore it */
 	if (log_make_free_space(size))
_

Patches currently in -mm which might be from pmladek@suse.cz are

printk-split-code-for-making-free-space-in-the-log-buffer.patch
printk-ignore-too-long-messages.patch
printk-split-message-size-computation.patch
printk-shrink-too-long-messages.patch
printk-return-really-stored-message-length.patch

