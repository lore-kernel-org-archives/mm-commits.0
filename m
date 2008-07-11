From: akpm@linux-foundation.org
Subject: + softlockup-fix-invalid-proc_handler-for-softlockup_panic.patch added to -mm tree
Date: Fri, 11 Jul 2008 11:38:28 -0700
Message-ID: <200807111844.m6BIi9Tq030849@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39865 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756399AbYGKSoM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 11 Jul 2008 14:44:12 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: h-shimamoto@ct.jp.nec.com


The patch titled
     From: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
has been added to the -mm tree.  Its filename is
     softlockup-fix-invalid-proc_handler-for-softlockup_panic.patch

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
Subject: From: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
From: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>


The type of softlockup_panic is int, but the proc_handler is
proc_doulongvec_minmax(). This handler is for unsigned long.

This handler should be proc_dointvec_minmax().

Signed-off-by: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
---

index 683986d..5b8b4c1 100644
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/sysctl.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN kernel/sysctl.c~softlockup-fix-invalid-proc_handler-for-softlockup_panic kernel/sysctl.c
--- a/kernel/sysctl.c~softlockup-fix-invalid-proc_handler-for-softlockup_panic
+++ a/kernel/sysctl.c
@@ -745,7 +745,7 @@ static struct ctl_table kern_table[] = {
 		.data		= &softlockup_panic,
 		.maxlen		= sizeof(int),
 		.mode		= 0644,
-		.proc_handler	= &proc_doulongvec_minmax,
+		.proc_handler	= &proc_dointvec_minmax,
 		.strategy	= &sysctl_intvec,
 		.extra1		= &zero,
 		.extra2		= &one,
_

Patches currently in -mm which might be from h-shimamoto@ct.jp.nec.com are

linux-next.patch
softlockup-fix-invalid-proc_handler-for-softlockup_panic.patch
per-task-delay-accounting-update-taskstats-for-memory-reclaim-delay.patch
unevictable-lru-page-statistics-fix-printk-in-show_free_areas.patch

