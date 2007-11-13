From: akpm@linux-foundation.org
Subject: - s390-cmm-remove-unused-binary-sysctls.patch removed from -mm tree
Date: Mon, 12 Nov 2007 20:07:19 -0800
Message-ID: <200711130407.lAD47I1A025225@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:40922 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755190AbXKMEHX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 12 Nov 2007 23:07:23 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: heiko.carstens@de.ibm.com, borntraeger@de.ibm.com, ebiederm@xmission.com, schwidefsky@de.ibm.com, mm-commits@vger.kernel.org


The patch titled
     s390: cmm: remove unused binary sysctls
has been removed from the -mm tree.  Its filename was
     s390-cmm-remove-unused-binary-sysctls.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: s390: cmm: remove unused binary sysctls
From: Heiko Carstens <heiko.carstens@de.ibm.com>

Remove binary sysctls that never worked due to missing strategy functions.

Cc: Christian Borntraeger <borntraeger@de.ibm.com>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/s390/mm/cmm.c     |    3 ---
 include/linux/sysctl.h |    5 -----
 kernel/sysctl_check.c  |    3 ---
 3 files changed, 11 deletions(-)

diff -puN arch/s390/mm/cmm.c~s390-cmm-remove-unused-binary-sysctls arch/s390/mm/cmm.c
--- a/arch/s390/mm/cmm.c~s390-cmm-remove-unused-binary-sysctls
+++ a/arch/s390/mm/cmm.c
@@ -341,19 +341,16 @@ cmm_timeout_handler(ctl_table *ctl, int 
 
 static struct ctl_table cmm_table[] = {
 	{
-		.ctl_name	= VM_CMM_PAGES,
 		.procname	= "cmm_pages",
 		.mode		= 0644,
 		.proc_handler	= &cmm_pages_handler,
 	},
 	{
-		.ctl_name	= VM_CMM_TIMED_PAGES,
 		.procname	= "cmm_timed_pages",
 		.mode		= 0644,
 		.proc_handler	= &cmm_pages_handler,
 	},
 	{
-		.ctl_name	= VM_CMM_TIMEOUT,
 		.procname	= "cmm_timeout",
 		.mode		= 0644,
 		.proc_handler	= &cmm_timeout_handler,
diff -puN include/linux/sysctl.h~s390-cmm-remove-unused-binary-sysctls include/linux/sysctl.h
--- a/include/linux/sysctl.h~s390-cmm-remove-unused-binary-sysctls
+++ a/include/linux/sysctl.h
@@ -207,11 +207,6 @@ enum
 	VM_PANIC_ON_OOM=33,	/* panic at out-of-memory */
 	VM_VDSO_ENABLED=34,	/* map VDSO into new processes? */
 	VM_MIN_SLAB=35,		 /* Percent pages ignored by zone reclaim */
-
-	/* s390 vm cmm sysctls */
-	VM_CMM_PAGES=1111,
-	VM_CMM_TIMED_PAGES=1112,
-	VM_CMM_TIMEOUT=1113,
 };
 
 
diff -puN kernel/sysctl_check.c~s390-cmm-remove-unused-binary-sysctls kernel/sysctl_check.c
--- a/kernel/sysctl_check.c~s390-cmm-remove-unused-binary-sysctls
+++ a/kernel/sysctl_check.c
@@ -140,9 +140,6 @@ static struct trans_ctl_table trans_vm_t
 	{ VM_PANIC_ON_OOM,		"panic_on_oom" },
 	{ VM_VDSO_ENABLED,		"vdso_enabled" },
 	{ VM_MIN_SLAB,			"min_slab_ratio" },
-	{ VM_CMM_PAGES,			"cmm_pages" },
-	{ VM_CMM_TIMED_PAGES,		"cmm_timed_pages" },
-	{ VM_CMM_TIMEOUT,		"cmm_timeout" },
 
 	{}
 };
_

Patches currently in -mm which might be from heiko.carstens@de.ibm.com are

git-s390.patch
taskstats-scaled-time-cleanup.patch
unexport-asm-pageh.patch
sanitize-the-type-of-struct-useru_ar0.patch
add-cmpxchg_local-to-s390.patch
