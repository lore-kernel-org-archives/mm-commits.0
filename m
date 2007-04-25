From: akpm@linux-foundation.org
Subject: - i386-sysenter-arch-pages-fix.patch removed from -mm tree
Date: Wed, 25 Apr 2007 13:39:46 -0700
Message-ID: <200704252039.l3PKdkjl012339@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:42205 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S2993142AbXDYUkI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 25 Apr 2007 16:40:08 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: zach@vmware.com, ak@suse.de, mm-commits@vger.kernel.org


The patch titled
     i386 sysenter arch pages fix
has been removed from the -mm tree.  Its filename was
     i386-sysenter-arch-pages-fix.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: i386 sysenter arch pages fix
From: Zachary Amsden <zach@vmware.com>

In compat mode, the return value here was uninitialized.

Signed-off-by: Zachary Amsden <zach@vmware.com>
Cc: Andi Kleen <ak@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/i386/kernel/sysenter.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN arch/i386/kernel/sysenter.c~i386-sysenter-arch-pages-fix arch/i386/kernel/sysenter.c
--- a/arch/i386/kernel/sysenter.c~i386-sysenter-arch-pages-fix
+++ a/arch/i386/kernel/sysenter.c
@@ -268,7 +268,7 @@ int arch_setup_additional_pages(struct l
 {
 	struct mm_struct *mm = current->mm;
 	unsigned long addr;
-	int ret;
+	int ret = 0;
 	bool compat;
 
 	down_write(&mm->mmap_sem);
_

Patches currently in -mm which might be from zach@vmware.com are

fix-buslogic-to-stop-using-check_region.patch
i386-pte-clear-optimization.patch
i386-pte-xchg-optimization.patch
i386-pte-simplify-ops.patch
i386-map-enough-initial-memory-to-create-lowmem-mappings-fix.patch
i386-use-pte_update_defer-in-ptep_test_and_clear_dirtyyoung.patch
i386-use-pte_update_defer-in-ptep_test_and_clear_dirtyyoung-fix.patch
ignore-stolen-time-in-the-softlockup-watchdog.patch
ignore-stolen-time-in-the-softlockup-watchdog-fix.patch
