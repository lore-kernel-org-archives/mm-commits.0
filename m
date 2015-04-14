From: akpm@linux-foundation.org
Subject: [folded-merged] mm-cma-release-trigger-fixpatch.patch removed
 from -mm tree
Date: Tue, 14 Apr 2015 15:13:08 -0700
Message-ID: <552d90f4.W795VWOv5fc4ft0f%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:54277 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932141AbbDNWNJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 14 Apr 2015 18:13:09 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mhocko@suse.cz, fengguang.wu@gmail.com, sasha.levin@oracle.com, sfr@canb.auug.org.au, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-cma-release-trigger-fix
has been removed from the -mm tree.  Its filename was
     mm-cma-release-trigger-fixpatch.patch

This patch was dropped because it was folded into mm-cma-release-trigger.patch

------------------------------------------------------
From: Michal Hocko <mhocko@suse.cz>
Subject: mm-cma-release-trigger-fix

allmodconfig fails with
mm/cma_debug.c: In function `cma_free_mem':
mm/cma_debug.c:71:4: error: invalid use of undefined type `struct page'
    mem->p += count;

Fix it by including mm_types.h

Signed-off-by: Michal Hocko <mhocko@suse.cz>
Cc: Sasha Levin <sasha.levin@oracle.com>
Cc: Fengguang Wu <fengguang.wu@gmail.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/cma_debug.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN mm/cma_debug.c~mm-cma-release-trigger-fixpatch mm/cma_debug.c
--- a/mm/cma_debug.c~mm-cma-release-trigger-fixpatch
+++ a/mm/cma_debug.c
@@ -10,6 +10,7 @@
 #include <linux/list.h>
 #include <linux/kernel.h>
 #include <linux/slab.h>
+#include <linux/mm_types.h>
 
 #include "cma.h"
 
_

Patches currently in -mm which might be from mhocko@suse.cz are

mm-hugetlb-use-pmd_page-in-follow_huge_pmd.patch
mm-memcontrol-update-copyright-notice.patch
mm-cma-release-trigger.patch
mm-hide-per-cpu-lists-in-output-of-show_mem.patch
mm-completely-remove-dumping-per-cpu-lists-from-show_mem.patch
mm-refactor-do_wp_page-extract-the-reuse-case.patch
mm-refactor-do_wp_page-rewrite-the-unlock-flow.patch
mm-refactor-do_wp_page-extract-the-page-copy-flow.patch
mm-refactor-do_wp_page-handling-of-shared-vma-into-a-function.patch
mm-clarify-__gfp_nofail-deprecation-status.patch
mm-clarify-__gfp_nofail-deprecation-status-checkpatch-fixes.patch
sparc-clarify-__gfp_nofail-allocation.patch
mm-memcontrol-let-mem_cgroup_move_account-have-effect-only-if-mmu-enabled.patch
memcg-print-cgroup-information-when-system-panics-due-to-panic_on_oom.patch

