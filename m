From: akpm@linux-foundation.org
Subject: - softlockup-fix-invalid-proc_handler-for-softlockup_panic.patch removed from -mm tree
Date: Tue, 22 Jul 2008 14:32:36 -0700
Message-ID: <200807222132.m6MLWab3018733@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45995 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753778AbYGVVhn (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 22 Jul 2008 17:37:43 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: h-shimamoto@ct.jp.nec.com, mm-commits@vger.kernel.org


The patch titled
     From: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
has been removed from the -mm tree.  Its filename was
     softlockup-fix-invalid-proc_handler-for-softlockup_panic.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

origin.patch
linux-next.patch
per-task-delay-accounting-update-taskstats-for-memory-reclaim-delay.patch
unevictable-lru-page-statistics-fix-printk-in-show_free_areas.patch

