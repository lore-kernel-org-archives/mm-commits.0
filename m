From: akpm@linux-foundation.org
Subject: +
 mm-slab_common-move-kmem_cache-definition-to-internal-header-fix.patch
 added to -mm tree
Date: Fri, 29 Aug 2014 13:40:49 -0700
Message-ID: <5400e551.0aQXLKTzgiw5HX1g%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:46224 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750796AbaH2Uku (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 29 Aug 2014 16:40:50 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, cl@linux.com, iamjoonsoo.kim@lge.com, penberg@kernel.org, rientjes@google.com, zhangyanfei@cn.fujitsu.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-slab_common-move-kmem_cache-definition-to-internal-header-fix
has been added to the -mm tree.  Its filename is
     mm-slab_common-move-kmem_cache-definition-to-internal-header-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-slab_common-move-kmem_cache-definition-to-internal-header-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-slab_common-move-kmem_cache-definition-to-internal-header-fix.patch

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
Subject: mm-slab_common-move-kmem_cache-definition-to-internal-header-fix

export kmem_cache_size() to modules

ERROR: "kmem_cache_size" [lib/lru_cache.ko] undefined!                          

Cc: Christoph Lameter <cl@linux.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slab_common.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN mm/slab_common.c~mm-slab_common-move-kmem_cache-definition-to-internal-header-fix mm/slab_common.c
--- a/mm/slab_common.c~mm-slab_common-move-kmem_cache-definition-to-internal-header-fix
+++ a/mm/slab_common.c
@@ -37,6 +37,7 @@ unsigned int kmem_cache_size(struct kmem
 {
 	return s->object_size;
 }
+EXPORT_SYMBOL(kmem_cache_size);
 
 #ifdef CONFIG_DEBUG_VM
 static int kmem_cache_sanity_check(const char *name, size_t size)
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
maintainers-akpm-maintenance.patch
mem-hotplug-let-memblock-skip-the-hotpluggable-memory-regions-in-__next_mem_range-fix.patch
mm-slab_commonc-suppress-warning.patch
mem-hotplug-fix-boot-failed-in-case-all-the-nodes-are-hotpluggable-checkpatch-fixes.patch
kernel-posix-timersc-code-clean-up-checkpatch-fixes.patch
input-route-kbd-leds-through-the-generic-leds-layer.patch
fs-ocfs2-stack_userc-fix-typo-in-ocfs2_control_release.patch
o2dlm-fix-null-pointer-dereference-in-o2dlm_blocking_ast_wrapper-checkpatch-fixes.patch
ocfs2-free-inode-when-i_count-becomes-zero.patch
mm.patch
mm-slab_common-move-kmem_cache-definition-to-internal-header-fix.patch
memory-hotplug-add-sysfs-zones_online_to-attribute-fix.patch
memory-hotplug-add-sysfs-zones_online_to-attribute-fix-2.patch
mm-compaction-defer-each-zone-individually-instead-of-preferred-zone-fix.patch
mm-compaction-khugepaged-should-not-give-up-due-to-need_resched-fix.patch
prctl-pr_set_mm-introduce-pr_set_mm_map-operation-v4.patch
prctl-pr_set_mm-introduce-pr_set_mm_map-operation-v3-fix.patch
mm-balloon_compaction-general-cleanup-checkpatch-fixes.patch
introduce-dump_vma-fix.patch
convert-a-few-vm_bug_on-callers-to-vm_bug_on_vma-checkpatch-fixes.patch
mm-introduce-do_shared_fault-and-drop-do_fault-fix-fix.patch
zram-zram-memory-size-limitation-fix.patch
zram-zram-memory-size-limitation-fix-fix.patch
do_shared_fault-check-that-mmap_sem-is-held.patch
acct-eliminate-compile-warning-fix.patch
checkpatch-fix-spello.patch
fs-proc-task_mmuc-shift-mm_access-from-m_start-to-proc_maps_open-checkpatch-fixes.patch
fs-proc-task_mmuc-simplify-the-vma_stop-logic-checkpatch-fixes.patch
fs-proc-task_nommuc-shift-mm_access-from-m_start-to-proc_maps_open-checkpatch-fixes.patch
not-adding-modules-range-to-kcore-if-its-equal-to-vmcore-range-checkpatch-fixes.patch
x86-optimize-resource-lookups-for-ioremap-fix.patch
init-resolve-shadow-warnings-checkpatch-fixes.patch
linux-next.patch
drivers-gpio-gpio-zevioc-fix-build.patch
lib-vsprintf-add-%pe-format-specifier-fix.patch
watchdog-control-hard-lockup-detection-default-fix.patch
mm-replace-remap_file_pages-syscall-with-emulation.patch
debugging-keep-track-of-page-owners.patch
debugging-keep-track-of-page-owners-fix.patch
journal_add_journal_head-debug.patch
journal_add_journal_head-debug-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mutex-subsystem-synchro-test-module.patch
slab-leaks3-default-y.patch

