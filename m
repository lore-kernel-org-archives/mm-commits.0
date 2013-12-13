From: akpm@linux-foundation.org
Subject: [folded-merged]
 procfs-also-fix-proc_reg_get_unmapped_area-for-mmu-case-fix.patch removed
 from -mm tree
Date: Thu, 12 Dec 2013 17:09:53 -0800
Message-ID: <52aa5e61.1XJ8cpJc1SBFSb2l%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:60180 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751056Ab3LMBJy (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 12 Dec 2013 20:09:54 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, jbeulich@suse.com, davem@davemloft.net, d.hatayama@jp.fujitsu.com, adobriyan@gmail.com, akpm@linux-foundation.org

Subject: [folded-merged] procfs-also-fix-proc_reg_get_unmapped_area-for-mmu-case-fix.patch removed from -mm tree
To: akpm@linux-foundation.org,adobriyan@gmail.com,d.hatayama@jp.fujitsu.com,davem@davemloft.net,jbeulich@suse.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Thu, 12 Dec 2013 17:09:53 -0800


The patch titled
     Subject: procfs-also-fix-proc_reg_get_unmapped_area-for-mmu-case-fix
has been removed from the -mm tree.  Its filename was
     procfs-also-fix-proc_reg_get_unmapped_area-for-mmu-case-fix.patch

This patch was dropped because it was folded into procfs-also-fix-proc_reg_get_unmapped_area-for-mmu-case.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: procfs-also-fix-proc_reg_get_unmapped_area-for-mmu-case-fix

Cc: Alexey Dobriyan <adobriyan@gmail.com>
Cc: David S. Miller <davem@davemloft.net>
Cc: HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>
Cc: Jan Beulich <jbeulich@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/inode.c |   17 +++++++++--------
 1 file changed, 9 insertions(+), 8 deletions(-)

diff -puN fs/proc/inode.c~procfs-also-fix-proc_reg_get_unmapped_area-for-mmu-case-fix fs/proc/inode.c
--- a/fs/proc/inode.c~procfs-also-fix-proc_reg_get_unmapped_area-for-mmu-case-fix
+++ a/fs/proc/inode.c
@@ -294,17 +294,18 @@ proc_reg_get_unmapped_area(struct file *
 	unsigned long rv = -EIO;
 
 	if (use_pde(pde)) {
-		typeof(proc_reg_get_unmapped_area) *get_area
+		typeof(proc_reg_get_unmapped_area) *get_area;
+
+		get_area = pde->proc_fops->get_unmapped_area;
 #ifdef CONFIG_MMU
-			= pde->proc_fops->get_unmapped_area
-			  ?: current->mm->get_unmapped_area;
-#else
-			= pde->proc_fops->get_unmapped_area;
+		if (!get_area)
+			get_area = current->mm->get_unmapped_area;
 #endif
 
-		rv = get_area
-		     ? get_area(file, orig_addr, len, pgoff, flags)
-		     : orig_addr;
+		if (get_area)
+			rv = get_area(file, orig_addr, len, pgoff, flags);
+		else
+			rv = orig_addr;
 		unuse_pde(pde);
 	}
 	return rv;
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
i-need-old-gcc.patch
procfs-also-fix-proc_reg_get_unmapped_area-for-mmu-case.patch
dma-debug-enhance-dma_debug_device_change-to-check-for-mapping-errors-fix.patch
input-route-kbd-leds-through-the-generic-leds-layer-fix.patch
drivers-block-ccissc-cciss_init_one-use-proper-errnos.patch
block-blk-mq-cpuc-use-hotcpu_notifier.patch
mtd-cmdlinepart-use-cmdline-partition-parser-lib-fix-fix.patch
posix_acl-uninlining.patch
mm.patch
mm-hugetlbc-simplify-pageheadhuge-and-pagehuge.patch
mm-swapc-reorganize-put_compound_page.patch
mm-get-rid-of-unnecessary-pageblock-scanning-in-setup_zone_migrate_reserve-fix.patch
mm-memory-failure-fix-the-typo-in-me_pagecache_dirty-fix.patch
mm-add-overcommit_kbytes-sysctl-variable-checkpatch-fixes.patch
mm-add-overcommit_kbytes-sysctl-variable-fix.patch
memblock-mem_hotplug-introduce-memblock_hotplug-flag-to-mark-hotpluggable-regions-checkpatch-fixes.patch
acpi-numa-mem_hotplug-mark-hotpluggable-memory-in-memblock-checkpatch-fixes.patch
memblock-mem_hotplug-make-memblock-skip-hotpluggable-regions-if-needed-checkpatch-fixes.patch
mm-memblock-add-memblock-memory-allocation-apis-fix.patch
sched-add-tracepoints-related-to-numa-task-migration-fix.patch
mm-page_alloc-warn-for-non-blockable-__gfp_nofail-allocation-failure.patch
lib-parserc-put-export_symbols-in-the-conventional-place.patch
kmod-run-usermodehelpers-only-on-cpus-allowed-for-kthreadd-v2-fix.patch
kmod-run-usermodehelpers-only-on-cpus-allowed-for-kthreadd-v2-checkpatch-fixes.patch
vmcore-copy-fractional-pages-into-buffers-in-the-kdump-2nd-kernel-fix.patch
fs-ext3-use-rbtree-postorder-iteration-helper-instead-of-opencoding-fix.patch
ipc-semc-avoid-overflow-of-semop-undo-semadj-value-fix.patch
linux-next.patch
linux-next-git-rejects.patch
debugging-keep-track-of-page-owners.patch
journal_add_journal_head-debug.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mutex-subsystem-synchro-test-module.patch
slab-leaks3-default-y.patch
put_bh-debug.patch

