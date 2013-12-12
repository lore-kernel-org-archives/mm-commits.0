From: akpm@linux-foundation.org
Subject: +
 vmcore-copy-fractional-pages-into-buffers-in-the-kdump-2nd-kernel-fix.patch added to -mm tree
Date: Wed, 11 Dec 2013 16:20:43 -0800
Message-ID: <52a9015b.gGO1krOOkNUdpBaN%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50660 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751377Ab3LLAUo (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 11 Dec 2013 19:20:44 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, vgoyal@redhat.com, kumagai-atsushi@mxc.nes.nec.co.jp, ebiederm@xmission.com, d.hatayama@jp.fujitsu.com, akpm@linux-foundation.org

Subject: + vmcore-copy-fractional-pages-into-buffers-in-the-kdump-2nd-kernel-fix.patch added to -mm tree
To: akpm@linux-foundation.org,d.hatayama@jp.fujitsu.com,ebiederm@xmission.com,kumagai-atsushi@mxc.nes.nec.co.jp,vgoyal@redhat.com
From: akpm@linux-foundation.org
Date: Wed, 11 Dec 2013 16:20:43 -0800


The patch titled
     Subject: vmcore-copy-fractional-pages-into-buffers-in-the-kdump-2nd-kernel-fix
has been added to the -mm tree.  Its filename is
     vmcore-copy-fractional-pages-into-buffers-in-the-kdump-2nd-kernel-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/vmcore-copy-fractional-pages-into-buffers-in-the-kdump-2nd-kernel-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/vmcore-copy-fractional-pages-into-buffers-in-the-kdump-2nd-kernel-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: vmcore-copy-fractional-pages-into-buffers-in-the-kdump-2nd-kernel-fix

remove unneeded assignment of `paddr'

Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Atsushi Kumagai <kumagai-atsushi@mxc.nes.nec.co.jp>
Cc: HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>
Cc: Vivek Goyal <vgoyal@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/vmcore.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/proc/vmcore.c~vmcore-copy-fractional-pages-into-buffers-in-the-kdump-2nd-kernel-fix fs/proc/vmcore.c
--- a/fs/proc/vmcore.c~vmcore-copy-fractional-pages-into-buffers-in-the-kdump-2nd-kernel-fix
+++ a/fs/proc/vmcore.c
@@ -401,7 +401,7 @@ static int mmap_vmcore(struct file *file
 								kaddr, tsz))
 					goto fail;
 			} else {
-				u64 paddr = paddr = m->paddr+start-m->offset;
+				u64 paddr = m->paddr + start - m->offset;
 
 				if (remap_oldmem_pfn_range(vma,
 							   vma->vm_start + len,
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
i-need-old-gcc.patch
procfs-also-fix-proc_reg_get_unmapped_area-for-mmu-case-fix.patch
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
debugging-keep-track-of-page-owners.patch
journal_add_journal_head-debug.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mutex-subsystem-synchro-test-module.patch
slab-leaks3-default-y.patch
put_bh-debug.patch

