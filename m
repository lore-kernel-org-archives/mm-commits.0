From: akpm@linux-foundation.org
Subject: [withdrawn]
 x86-numa-setup_node_data-drop-dead-code-and-rename-function-checkpatch-fixes.patch removed from -mm tree
Date: Mon, 07 Jul 2014 16:50:25 -0700
Message-ID: <53bb3241.a9Qi8Z4vkZpoMBV0%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qc0-f202.google.com ([209.85.216.202]:62663 "EHLO
	mail-qc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751236AbaGGXu1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 7 Jul 2014 19:50:27 -0400
Received: by mail-qc0-f202.google.com with SMTP id x13so728208qcv.1
        for <mm-commits@vger.kernel.org>; Mon, 07 Jul 2014 16:50:26 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, andi@firstfloor.org, hpa@zytor.com, isimatu.yasuaki@jp.fujitsu.com, lcapitulino@redhat.com, mingo@elte.hu, riel@redhat.com, rientjes@google.com, tglx@linutronix.de, yinghai@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: x86-numa-setup_node_data-drop-dead-code-and-rename-function-checkpatch-fixes
has been removed from the -mm tree.  Its filename was
     x86-numa-setup_node_data-drop-dead-code-and-rename-function-checkpatch-fixes.patch

This patch was dropped because it was withdrawn

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: x86-numa-setup_node_data-drop-dead-code-and-rename-function-checkpatch-fixes

WARNING: Prefer [subsystem eg: netdev]_info([subsystem]dev, ... then dev_info(dev, ... then pr_info(...  to printk(KERN_INFO ...
#174: FILE: arch/x86/mm/numa.c:213:
+	printk(KERN_INFO "NODE_DATA(%d) allocated [mem %#010Lx-%#010Lx]\n", nid,

WARNING: Prefer [subsystem eg: netdev]_info([subsystem]dev, ... then dev_info(dev, ... then pr_info(...  to printk(KERN_INFO ...
#215: FILE: mm/page_alloc.c:4972:
+	printk(KERN_INFO "Node %d memory range %#010Lx-%#010Lx\n", nid,

WARNING: line over 80 characters
#216: FILE: mm/page_alloc.c:4973:
+			(u64) start_pfn << PAGE_SHIFT, (u64) (end_pfn << PAGE_SHIFT) - 1);

total: 0 errors, 3 warnings, 79 lines checked

./patches/x86-numa-setup_node_data-drop-dead-code-and-rename-function.patch has style problems, please review.

If any of these errors are false positives, please report
them to the maintainer, see CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: Andi Kleen <andi@firstfloor.org>
Cc: David Rientjes <rientjes@google.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Luiz Capitulino <lcapitulino@redhat.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
Cc: Yinghai Lu <yinghai@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN mm/page_alloc.c~x86-numa-setup_node_data-drop-dead-code-and-rename-function-checkpatch-fixes mm/page_alloc.c
--- a/mm/page_alloc.c~x86-numa-setup_node_data-drop-dead-code-and-rename-function-checkpatch-fixes
+++ a/mm/page_alloc.c
@@ -4969,8 +4969,8 @@ void __paginginit free_area_init_node(in
 	pgdat->node_start_pfn = node_start_pfn;
 #ifdef CONFIG_HAVE_MEMBLOCK_NODE_MAP
 	get_pfn_range_for_nid(nid, &start_pfn, &end_pfn);
-	printk(KERN_INFO "Node %d memory range %#010Lx-%#010Lx\n", nid,
-			(u64) start_pfn << PAGE_SHIFT, (u64) (end_pfn << PAGE_SHIFT) - 1);
+	pr_info("Node %d memory range %#010Lx-%#010Lx\n", nid,
+		(u64)start_pfn << PAGE_SHIFT, (u64)(end_pfn << PAGE_SHIFT) - 1);
 #endif
 	calculate_node_totalpages(pgdat, start_pfn, end_pfn,
 				  zones_size, zholes_size);
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
maintainers-akpm-maintenance.patch
input-route-kbd-leds-through-the-generic-leds-layer.patch
kbuild-explain-stack-protector-strong-config-logic.patch
ocfs2-free-inode-when-i_count-becomes-zero-checkpatch-fixes.patch
mm.patch
slub-use-new-node-functions-checkpatch-fixes.patch
slab-use-get_node-and-kmem_cache_node-functions-fix-2.patch
slab-use-get_node-and-kmem_cache_node-functions-fix-2-fix.patch
slab-change-int-to-size_t-for-representing-allocation-size.patch
mm-page_allocc-unexport-alloc_pages_exact_nid.patch
dma-cma-support-arbitrary-bitmap-granularity-fix.patch
mm-vmallocc-add-a-schedule-point-to-vmalloc-fix.patch
include-linux-mmdebugh-add-vm_warn_once.patch
mm-catch-memory-commitment-underflow-fix.patch
mm-introduce-do_shared_fault-and-drop-do_fault-fix-fix.patch
mm-compactionc-isolate_freepages_block-small-tuneup.patch
mm-zpool-implement-common-zpool-api-to-zbud-zsmalloc-fix.patch
mm-zpool-prevent-zbud-zsmalloc-from-unloading-when-used-checkpatch-fixes.patch
do_shared_fault-check-that-mmap_sem-is-held.patch
list-fix-order-of-arguments-for-hlist_add_after_rcu-checkpatch-fixes.patch
add-lib-globc-fix.patch
lib-list_sortc-convert-to-pr_foo.patch
lib-list_sortc-convert-to-pr_foo-fix.patch
checkpatch-add-test-for-commit-id-formatting-style-in-commit-log.patch
binfmt_elfc-use-get_random_int-to-fix-entropy-depleting-fix.patch
fs-isofs-logging-clean-up-fix.patch
documentation-fix-typo-in-docbook-mtdnandtmpl-checkpatch-fixes.patch
kexec-implementation-of-new-syscall-kexec_file_load-checkpatch-fixes.patch
kexec-support-kexec-kdump-on-efi-systems-fix.patch
panic-add-taint_softlockup-fix.patch
linux-next.patch
drivers-gpio-gpio-zevioc-fix-build.patch
drivers-staging-emxx_udc-emxx_udcc-replace-strict_strto-with-kstrto.patch
kernel-posix-timersc-code-clean-up-checkpatch-fixes.patch
mm-replace-remap_file_pages-syscall-with-emulation-fix.patch
memcg-deprecate-memoryforce_empty-knob-fix.patch
debugging-keep-track-of-page-owners.patch
journal_add_journal_head-debug.patch
journal_add_journal_head-debug-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mutex-subsystem-synchro-test-module.patch
slab-leaks3-default-y.patch
put_bh-debug.patch

