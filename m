From: akpm@linux-foundation.org
Subject: + fix-faulty-logic-in-the-case-of-recursive-printk.patch added to -mm tree
Date: Tue, 26 Aug 2014 15:26:16 -0700
Message-ID: <53fd0988.NWryFeLeKKWoctxt%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-oi0-f74.google.com ([209.85.218.74]:40029 "EHLO
	mail-oi0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754346AbaHZW0R (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 26 Aug 2014 18:26:17 -0400
Received: by mail-oi0-f74.google.com with SMTP id a141so3012023oig.1
        for <mm-commits@vger.kernel.org>; Tue, 26 Aug 2014 15:26:16 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: patrick@parcs.ath.cx, jack@suse.cz, pmladek@suse.cz, rostedt@goodmis.org, stable@vger.kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: kernel/printk/printk.c: fix faulty logic in the case of recursive printk
has been added to the -mm tree.  Its filename is
     fix-faulty-logic-in-the-case-of-recursive-printk.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/fix-faulty-logic-in-the-case-of-recursive-printk.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/fix-faulty-logic-in-the-case-of-recursive-printk.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Patrick Palka <patrick@parcs.ath.cx>
Subject: kernel/printk/printk.c: fix faulty logic in the case of recursive printk

We shouldn't set text_len in the code path that detects printk recursion
because text_len corresponds to the length of the string inside textbuf. 
A few lines down from the line

    text_len = strlen(recursion_msg);

is the line

    text_len += vscnprintf(text + text_len, ...);

So if printk detects recursion, it sets text_len to 29 (the length of
recursion_msg) and logs an error.  Then the message supplied by the caller
of printk is stored inside textbuf but offset by 29 bytes.  This means
that the output of the recursive call to printk will contain 29 bytes of
garbage in front of it.

This defect is caused by commit 458df9fd ("printk: remove separate
printk_sched buffers and use printk buf instead") which turned the line

    text_len = vscnprintf(text, ...);

into

    text_len += vscnprintf(text + text_len, ...);

To fix this, this patch avoids setting text_len when logging the printk
recursion error.  This patch also marks unlikely() the branch leading up
to this code.

Fixes: 458df9fd4815b478 ("printk: remove separate printk_sched buffers and use printk buf instead")
Signed-off-by: Patrick Palka <patrick@parcs.ath.cx>
Cc: Petr Mladek <pmladek@suse.cz>
Reviewed-by: Jan Kara <jack@suse.cz>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/printk/printk.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN kernel/printk/printk.c~fix-faulty-logic-in-the-case-of-recursive-printk kernel/printk/printk.c
--- a/kernel/printk/printk.c~fix-faulty-logic-in-the-case-of-recursive-printk
+++ a/kernel/printk/printk.c
@@ -1665,15 +1665,15 @@ asmlinkage int vprintk_emit(int facility
 	raw_spin_lock(&logbuf_lock);
 	logbuf_cpu = this_cpu;
 
-	if (recursion_bug) {
+	if (unlikely(recursion_bug)) {
 		static const char recursion_msg[] =
 			"BUG: recent printk recursion!";
 
 		recursion_bug = 0;
-		text_len = strlen(recursion_msg);
 		/* emit KERN_CRIT message */
 		printed_len += log_store(0, 2, LOG_PREFIX|LOG_NEWLINE, 0,
-					 NULL, 0, recursion_msg, text_len);
+					 NULL, 0, recursion_msg,
+					 strlen(recursion_msg));
 	}
 
 	/*
_

Patches currently in -mm which might be from patrick@parcs.ath.cx are

fix-faulty-logic-in-the-case-of-recursive-printk.patch

