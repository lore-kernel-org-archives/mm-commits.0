From: akpm@linux-foundation.org
Subject: - pm-include-eio-from-errno-baseh.patch removed from -mm tree
Date: Thu, 03 May 2007 12:30:31 -0700
Message-ID: <200705031930.l43JUVFx018192@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:55473 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1767789AbXECTcl (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 3 May 2007 15:32:41 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rientjes@google.com, david-b@pacbell.net, rdunlap@xenotime.net, mm-commits@vger.kernel.org


The patch titled
     pm: include EIO from errno-base.h
has been removed from the -mm tree.  Its filename was
     pm-include-eio-from-errno-baseh.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: pm: include EIO from errno-base.h
From: David Rientjes <rientjes@google.com>

For backwards compatibility, call_platform_enable_wakeup() can return 0
instead of -EIO since we aren't guaranteed to have errno defined.

Cc: David Brownell <david-b@pacbell.net>
Signed-off-by: David Rientjes <rientjes@google.com>
Cc: "Randy.Dunlap" <rdunlap@xenotime.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/pm.h |    2 +-
 1 files changed, 1 insertion(+), 1 deletion(-)

diff -puN include/linux/pm.h~pm-include-eio-from-errno-baseh include/linux/pm.h
--- a/include/linux/pm.h~pm-include-eio-from-errno-baseh
+++ a/include/linux/pm.h
@@ -332,7 +332,7 @@ static inline void dpm_runtime_resume(st
 
 static inline int call_platform_enable_wakeup(struct device *dev, int is_on)
 {
-	return -EIO;
+	return 0;
 }
 
 #endif
_

Patches currently in -mm which might be from rientjes@google.com are

origin.patch
i386-add-ptep_test_and_clear_dirtyyoung.patch
i386-use-pte_update_defer-in-ptep_test_and_clear_dirtyyoung.patch
smaps-extract-pmd-walker-from-smaps-code.patch
smaps-add-pages-referenced-count-to-smaps.patch
smaps-add-clear_refs-file-to-clear-reference.patch
cpusets-allow-tif_memdie-threads-to-allocate-anywhere.patch
mm-fix-handling-of-panic_on_oom-when-cpusets-are-in-use.patch
oom-fix-constraint-deadlock.patch
git-cpufreq.patch
maps2-uninline-some-functions-in-the-page-walker.patch
maps2-eliminate-the-pmd_walker-struct-in-the-page-walker.patch
maps2-remove-vma-from-args-in-the-page-walker.patch
maps2-propagate-errors-from-callback-in-page-walker.patch
maps2-add-callbacks-for-each-level-to-page-walker.patch
maps2-move-the-page-walker-code-to-lib.patch
maps2-simplify-interdependence-of-proc-pid-maps-and-smaps.patch
maps2-move-clear_refs-code-to-task_mmuc.patch
maps2-regroup-task_mmu-by-interface.patch
maps2-make-proc-pid-smaps-optional-under-config_embedded.patch
maps2-make-proc-pid-clear_refs-option-under-config_embedded.patch
maps2-add-proc-pid-pagemap-interface.patch
maps2-add-proc-kpagemap-interface.patch
cpusets-allow-empty-cpusmems_allowed-to-be-set-for.patch
cpusets-allow-empty-cpusmems_allowed-to-be-set-for-fix.patch
