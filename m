From: akpm@linux-foundation.org
Subject: [folded-merged] mm-debug-mm-introduce-vm_bug_on_mm-fixpatch.patch removed from -mm tree
Date: Thu, 09 Oct 2014 13:42:45 -0700
Message-ID: <5436f345.+Mh3GXV1q0y7nKC8%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:35650 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750815AbaJIUmp (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 9 Oct 2014 16:42:45 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mhocko@suse.cz, Valdis.Kletnieks@vt.edu, davej@redhat.com, sasha.levin@oracle.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm, debug: mm-introduce-vm_bug_on_mm-fix.patch
has been removed from the -mm tree.  Its filename was
     mm-debug-mm-introduce-vm_bug_on_mm-fixpatch.patch

This patch was dropped because it was folded into mm-introduce-vm_bug_on_mm.patch

------------------------------------------------------
From: Michal Hocko <mhocko@suse.cz>
Subject: mm, debug: mm-introduce-vm_bug_on_mm-fix.patch

dump_mm wants to dump mm->owner even when CONFIG_MEMCG is not defined
which leads to a compilation error:
mm/debug.c: In function `dump_mm':
mm/debug.c:212:5: error: `const struct mm_struct' has no member named `owner'
   mm->owner, mm->exe_file,

Signed-off-by: Michal Hocko <mhocko@suse.cz>
Cc: Sasha Levin <sasha.levin@oracle.com>
Cc: Valdis Kletnieks <Valdis.Kletnieks@vt.edu>
Cc: Dave Jones <davej@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/debug.c |   10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff -puN mm/debug.c~mm-debug-mm-introduce-vm_bug_on_mm-fixpatch mm/debug.c
--- a/mm/debug.c~mm-debug-mm-introduce-vm_bug_on_mm-fixpatch
+++ a/mm/debug.c
@@ -184,7 +184,10 @@ void dump_mm(const struct mm_struct *mm)
 #ifdef CONFIG_AIO
 		"ioctx_table %p\n"
 #endif
-		"owner %p exe_file %p\n"
+#ifdef CONFIG_MEMCG
+		"owner %p "
+#endif
+		"exe_file %p\n"
 #ifdef CONFIG_MMU_NOTIFIER
 		"mmu_notifier_mm %p\n"
 #endif
@@ -212,7 +215,10 @@ void dump_mm(const struct mm_struct *mm)
 #ifdef CONFIG_AIO
 		mm->ioctx_table,
 #endif
-		mm->owner, mm->exe_file,
+#ifdef CONFIG_MEMCG
+		mm->owner,
+#endif
+		mm->exe_file,
 #ifdef CONFIG_MMU_NOTIFIER
 		mm->mmu_notifier_mm,
 #endif
_

Patches currently in -mm which might be from mhocko@suse.cz are

introduce-dump_vma.patch
introduce-vm_bug_on_vma.patch
convert-a-few-vm_bug_on-callers-to-vm_bug_on_vma.patch
mm-introduce-vm_bug_on_mm.patch
mm-debug-mm-introduce-vm_bug_on_mm-fix-fixpatch.patch
mm-debug-mm-introduce-vm_bug_on_mm-fix-fixpatch-fix.patch
memcg-move-memcg_allocfree_cache_params-to-slab_commonc.patch
memcg-dont-call-memcg_update_all_caches-if-new-cache-id-fits.patch
memcg-move-memcg_update_cache_size-to-slab_commonc.patch
mm-memcontrol-do-not-kill-uncharge-batching-in-free_pages_and_swap_cache.patch
mm-memcontrol-do-not-kill-uncharge-batching-in-free_pages_and_swap_cache-fix.patch
mm-memcontrol-simplify-detecting-when-the-memoryswap-limit-is-hit.patch
mm-memcontrol-fix-transparent-huge-page-allocations-under-pressure.patch
memcg-zap-memcg_can_account_kmem.patch

