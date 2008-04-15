From: akpm@linux-foundation.org
Subject: + h8300-use-kbuildh-instead-of-defining-macros-in-asm-offsetsc.patch added to -mm tree
Date: Tue, 15 Apr 2008 15:37:39 -0700
Message-ID: <200804152237.m3FMbdOw019425@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33057 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752917AbYDOWl0 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 15 Apr 2008 18:41:26 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: clameter@sgi.com, ysato@users.sourceforge.jp


The patch titled
     h8300: use kbuild.h instead of defining macros in asm-offsets.c
has been added to the -mm tree.  Its filename is
     h8300-use-kbuildh-instead-of-defining-macros-in-asm-offsetsc.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: h8300: use kbuild.h instead of defining macros in asm-offsets.c
From: Christoph Lameter <clameter@sgi.com>

Signed-off-by: Christoph Lameter <clameter@sgi.com>
Cc: Yoshinori Sato <ysato@users.sourceforge.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/h8300/kernel/asm-offsets.c |    6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff -puN arch/h8300/kernel/asm-offsets.c~h8300-use-kbuildh-instead-of-defining-macros-in-asm-offsetsc arch/h8300/kernel/asm-offsets.c
--- a/arch/h8300/kernel/asm-offsets.c~h8300-use-kbuildh-instead-of-defining-macros-in-asm-offsetsc
+++ a/arch/h8300/kernel/asm-offsets.c
@@ -13,15 +13,11 @@
 #include <linux/kernel_stat.h>
 #include <linux/ptrace.h>
 #include <linux/hardirq.h>
+#include <linux/kbuild.h>
 #include <asm/bootinfo.h>
 #include <asm/irq.h>
 #include <asm/ptrace.h>
 
-#define DEFINE(sym, val) \
-        asm volatile("\n->" #sym " %0 " #val : : "i" (val))
-
-#define BLANK() asm volatile("\n->" : : )
-
 int main(void)
 {
 	/* offsets into the task struct */
_

Patches currently in -mm which might be from clameter@sgi.com are

hotplug-memory-make-online_page-common.patch
hotplug-memory-make-online_page-common-fix.patch
git-x86.patch
git-ia64.patch
git-unionfs.patch
git-pekka.patch
remove-set_migrateflags.patch
mm-use-zonelists-instead-of-zones-when-direct-reclaiming-pages.patch
mm-introduce-node_zonelist-for-accessing-the-zonelist-for-a-gfp-mask.patch
mm-remember-what-the-preferred-zone-is-for-zone_statistics.patch
mm-use-two-zonelist-that-are-filtered-by-gfp-mask.patch
mm-have-zonelist-contains-structs-with-both-a-zone-pointer-and-zone_idx.patch
mm-have-zonelist-contains-structs-with-both-a-zone-pointer-and-zone_idx-fix-memcg-ooms.patch
mm-have-zonelist-contains-structs-with-both-a-zone-pointer-and-zone_idx-just-return-do_try_to_free_pages.patch
mm-have-zonelist-contains-structs-with-both-a-zone-pointer-and-zone_idx-just-return-do_try_to_free_pages-do_try_to_free_pages-gfp_mask-redundant.patch
mm-filter-based-on-a-nodemask-as-well-as-a-gfp_mask.patch
mm-filter-based-on-a-nodemask-as-well-as-a-gfp_mask-doc-fixes.patch
mm-filter-based-on-a-nodemask-as-well-as-a-gfp_mask-make-dequeue_huge_page_vma-obey-mpol_bind-nodemask.patch
mm-filter-based-on-a-nodemask-as-well-as-a-gfp_mask-make-dequeue_huge_page_vma-obey-mpol_bind-nodemask-rework.patch
mm-filter-based-on-a-nodemask-as-well-as-a-gfp_mask-deporkify.patch
mm-move-cache_line_size-to-linux-cacheh.patch
mempolicy-convert-mpol-constants-to-enum.patch
mempolicy-support-optional-mode-flags.patch
mempolicy-support-optional-mode-flags-fix.patch
mempolicy-add-mpol_f_static_nodes-flag.patch
mempolicy-add-bitmap_onto-and-bitmap_fold-operations.patch
mempolicy-add-mpol_f_relative_nodes-flag.patch
mempolicy-update-numa-memory-policy-documentation.patch
mempolicy-move-rebind-functions.patch
mempolicy-create-mempolicy_operations-structure.patch
mempolicy-create-mempolicy_operations-structure-fix.patch
mempolicy-small-header-file-cleanup.patch
mempolicy-disallow-static-or-relative-flags-for-local-preferred-mode.patch
mempolicy-fix-parsing-of-tmpfs-mpol-mount-option.patch
mm-make-mem_map-allocation-continuous-v2.patch
mm-fix-alloc_bootmem_core-to-use-fast-searching-for-all-nodes.patch
mm-offset-align-in-alloc_bootmem.patch
mm-make-reserve_bootmem-can-crossed-the-nodes.patch
mm-make-early_pfn_to_nid-a-c-function.patch
vmalloc-show-vmalloced-areas-via-proc-vmallocinfo.patch
vmalloc-show-vmalloced-areas-via-proc-vmallocinfo-checkpatch-fixes.patch
vmalloc-show-vmalloced-areas-via-proc-vmallocinfo-fix.patch
vmalloc-show-vmalloced-areas-via-proc-vmallocinfo-fix-2.patch
vmallocinfo-add-caller-information.patch
vmallocinfo-add-caller-information-checkpatch-fixes.patch
sparsemem-vmemmap-does-not-need-section-bits.patch
kbuild-create-a-way-to-create-preprocessor-constants-from-c-expressions.patch
page_mapping-add-ifdef-around-reference-to-swapper_space.patch
pageflags-standardize-comment-inclusion-in-asm-offsetsh-and-fix-mips.patch
pageflags-use-an-enum-for-the-flags.patch
pageflags-get-rid-of-flags_reserved.patch
pageflags-get-rid-of-flags_reserved-sparc64-fix.patch
pageflags-introduce-macros-to-generate-page-flag-functions.patch
pageflags-convert-to-the-use-of-new-macros.patch
pageflags-use-proper-page-flag-functions-in-xen.patch
pageflags-eliminate-pg_xxx-aliases.patch
page-flags-handle-pg_uncached-like-all-other-flags.patch
page-flags-add-pageflags_false-for-flags-that-are-always-false.patch
mm-get-rid-of-__zone_count.patch
pageflags_extended-and-separate-page-flags-for-head-and-tail.patch
mm-remove-unused-max_nodes_shift.patch
vmcoreinfo-add-page-flags-values.patch
mempolicy-rename-mpol_free-to-mpol_put.patch
mempolicy-rename-mpol_copy-to-mpol_dup.patch
mempolicy-write-lock-mmap_sem-while-changing-task-mempolicy.patch
mempolicy-fixup-fallback-for-default-shmem-policy.patch
mempolicy-rename-struct-mempolicy-policy-member-to-mode.patch
mempolicy-mark-shared-policies-for-unref.patch
mempolicy-document-setget_policy-vm_ops-apis.patch
mempolicy-rework-mempolicy-reference-counting.patch
mempolicy-use-mpol_preferred-for-system-wide-default-policy.patch
mempolicy-mpol_preferred-cleanups-for-local-allocation.patch
mempolicy-use-mpol_f_local-to-indicate-preferred-local-policy.patch
mempolicy-clean-up-mpol-to-str-mempolicy-formatting.patch
mempolicy-rework-shmem-mpol-parsing-and-display.patch
mempolicy-support-mpol=local-tmpfs-mount-option.patch
mempolicy-use-struct-mempolicy-pointer-in-shmem_sb_info.patch
mempolicy-use-struct-mempolicy-pointer-in-shmem_sb_info-fix.patch
mempolicy-use-struct-mempolicy-pointer-in-shmem_sb_info-fix-fix.patch
mempolicy-use-struct-mempolicy-pointer-in-shmem_sb_info-fix-fix-fix.patch
page-allcoator-smarter-retry-of-costly-order-allocations.patch
page-allocator-explicitly-retry-hugepage-allocations.patch
ipc-add-definitions-of-ushort_max-and-others.patch
mm-add-nr_writeback_temp-counter.patch
remove-div_long_long_rem.patch
slab-add-a-flag-to-prevent-debug_free-checks-on-a-kmem_cache.patch
add-kbuildh-that-contains-common-definitions-for-kbuild-users.patch
x86-use-kbuildh.patch
mips-use-kbuildh-instead-of-macros-in-asm-offsetsc.patch
alpha-use-kbuildh-instead-of-macros-in-asm-offsetsc.patch
ia64-use-kbuildh-macros-instead-of-defining-macros-in-asm-offsetsc.patch
arm-use-kbuildh-instead-of-macros-in-asm-offsetsc.patch
xtensa-use-kbuildh-macros-instead-of-defining-them-in-asm-offsetsc.patch
sparc-use-kbuildh-instead-of-defining-macros-in-asm-offsetsc.patch
avr32-use-kbuildh-macros-instead-of-defining-macros-in-asm-offsetsc.patch
blackfin-use-kbuildh-instead-of-defining-macros-in-asm-macrosc.patch
frv-use-kbuildh-instead-of-defining-macros-in-asm-offsetsc.patch
h8300-use-kbuildh-instead-of-defining-macros-in-asm-offsetsc.patch
m68k-m68kmmu-use-kbuildh-instead-of-defining-macros-in-asm-offsetsc.patch
mn10300-use-kbuildh-instead-of-defining-macros-in-asm-offsetsc.patch
parisc-use-kbuildh-instead-of-defining-macros-in-asm-offsetsc.patch
ppc-powerpc-use-kbuildh-instead-of-defining-macros-in-asm-offsetsc.patch
s390-use-kbuildh-instead-of-defining-macros-in-asm-offsetsc.patch
sh-use-kbuildh-instead-of-defining-macros-in-asm-offsetsc.patch
v850-use-kbuildh-instead-of-defining-macros-in-asm-offsetsc.patch
reiser4.patch
reiser4-portion-of-zero_user-cleanup-patch.patch
page-owner-tracking-leak-detector.patch

