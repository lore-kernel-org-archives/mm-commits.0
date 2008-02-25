From: akpm@linux-foundation.org
Subject: + printk-fix-possible-printk-overrun.patch added to -mm tree
Date: Mon, 25 Feb 2008 10:30:11 -0800
Message-ID: <200802251831.m1PIV27G013206@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:40291 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754132AbYBYSbz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 25 Feb 2008 13:31:55 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: htejun@gmail.com, mingo@elte.hu


The patch titled
     printk: fix possible printk overrun
has been added to the -mm tree.  Its filename is
     printk-fix-possible-printk-overrun.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: printk: fix possible printk overrun
From: Tejun Heo <htejun@gmail.com>

printk recursion detection prepends message to printk_buf and offsets
printk_buf when actual message is printed but it forgets to trim buffer
length accordingly. This can result in overrun in extreme cases. Fix it.

[ mingo@elte.hu:

  bug was introduced by me via:

   commit 32a76006683f7b28ae3cc491da37716e002f198e
   Author: Ingo Molnar <mingo@elte.hu>
   Date:   Fri Jan 25 21:07:58 2008 +0100

       printk: make printk more robust by not allowing recursion
]

Signed-off-by: Tejun Heo <htejun@gmail.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/printk.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN kernel/printk.c~printk-fix-possible-printk-overrun kernel/printk.c
--- a/kernel/printk.c~printk-fix-possible-printk-overrun
+++ a/kernel/printk.c
@@ -666,7 +666,7 @@ asmlinkage int vprintk(const char *fmt, 
 	}
 	/* Emit the output into the temporary buffer */
 	printed_len += vscnprintf(printk_buf + printed_len,
-				  sizeof(printk_buf), fmt, args);
+				  sizeof(printk_buf) - printed_len, fmt, args);
 
 	/*
 	 * Copy the output into log_buf.  If the caller didn't provide
_

Patches currently in -mm which might be from htejun@gmail.com are

printk-fix-possible-printk-overrun.patch
git-sched.patch
