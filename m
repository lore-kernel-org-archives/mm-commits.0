From: akpm@linux-foundation.org
Subject: + s390-use-kbuildh-instead-of-defining-macros-in-asm-offsetsc-update.patch added to -mm tree
Date: Wed, 16 Apr 2008 11:08:36 -0700
Message-ID: <200804161808.m3GI8aW6028908@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40215 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752859AbYDPSIw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 16 Apr 2008 14:08:52 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: clameter@sgi.com, heiko.carstens@de.ibm.com, schwidefsky@de.ibm.com


The patch titled
     s390-use-kbuildh-instead-of-defining-macros-in-asm-offsetsc update
has been added to the -mm tree.  Its filename is
     s390-use-kbuildh-instead-of-defining-macros-in-asm-offsetsc-update.patch

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
Subject: s390-use-kbuildh-instead-of-defining-macros-in-asm-offsetsc update
From: Christoph Lameter <clameter@sgi.com>

New version that does not preserve the marker. Arch maintainers indicate
that the marker functionality is is not needed anymore.

Note you may simplify the s390 asm-offsets.c code further if you use the
OFFSET() macro instead of the DEFINE. See kbuild.h

Subject: Use kbuild.h instead of defining macros in asm-offsets.c

Signed-off-by: Christoph Lameter <clameter@sgi.com>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/s390/kernel/asm-offsets.c |   51 +++++++++++++------------------
 1 file changed, 23 insertions(+), 28 deletions(-)

diff -puN arch/s390/kernel/asm-offsets.c~s390-use-kbuildh-instead-of-defining-macros-in-asm-offsetsc-update arch/s390/kernel/asm-offsets.c
--- a/arch/s390/kernel/asm-offsets.c~s390-use-kbuildh-instead-of-defining-macros-in-asm-offsetsc-update
+++ a/arch/s390/kernel/asm-offsets.c
@@ -7,41 +7,36 @@
 #include <linux/sched.h>
 #include <linux/kbuild.h>
 
-/* Use marker if you need to separate the values later */
-#undef DEFINE
-#define DEFINE(sym, val, marker) \
-	asm volatile("\n->" #sym " %0 " #val " " #marker : : "i" (val))
-
 int main(void)
 {
-	DEFINE(__THREAD_info, offsetof(struct task_struct, stack),);
-	DEFINE(__THREAD_ksp, offsetof(struct task_struct, thread.ksp),);
-	DEFINE(__THREAD_per, offsetof(struct task_struct, thread.per_info),);
+	DEFINE(__THREAD_info, offsetof(struct task_struct, stack));
+	DEFINE(__THREAD_ksp, offsetof(struct task_struct, thread.ksp));
+	DEFINE(__THREAD_per, offsetof(struct task_struct, thread.per_info));
 	DEFINE(__THREAD_mm_segment,
-	       offsetof(struct task_struct, thread.mm_segment),);
+	       offsetof(struct task_struct, thread.mm_segment));
 	BLANK();
-	DEFINE(__TASK_pid, offsetof(struct task_struct, pid),);
+	DEFINE(__TASK_pid, offsetof(struct task_struct, pid));
 	BLANK();
-	DEFINE(__PER_atmid, offsetof(per_struct, lowcore.words.perc_atmid),);
-	DEFINE(__PER_address, offsetof(per_struct, lowcore.words.address),);
-	DEFINE(__PER_access_id, offsetof(per_struct, lowcore.words.access_id),);
+	DEFINE(__PER_atmid, offsetof(per_struct, lowcore.words.perc_atmid));
+	DEFINE(__PER_address, offsetof(per_struct, lowcore.words.address));
+	DEFINE(__PER_access_id, offsetof(per_struct, lowcore.words.access_id));
 	BLANK();
-	DEFINE(__TI_task, offsetof(struct thread_info, task),);
-	DEFINE(__TI_domain, offsetof(struct thread_info, exec_domain),);
-	DEFINE(__TI_flags, offsetof(struct thread_info, flags),);
-	DEFINE(__TI_cpu, offsetof(struct thread_info, cpu),);
-	DEFINE(__TI_precount, offsetof(struct thread_info, preempt_count),);
+	DEFINE(__TI_task, offsetof(struct thread_info, task));
+	DEFINE(__TI_domain, offsetof(struct thread_info, exec_domain));
+	DEFINE(__TI_flags, offsetof(struct thread_info, flags));
+	DEFINE(__TI_cpu, offsetof(struct thread_info, cpu));
+	DEFINE(__TI_precount, offsetof(struct thread_info, preempt_count));
 	BLANK();
-	DEFINE(__PT_ARGS, offsetof(struct pt_regs, args),);
-	DEFINE(__PT_PSW, offsetof(struct pt_regs, psw),);
-	DEFINE(__PT_GPRS, offsetof(struct pt_regs, gprs),);
-	DEFINE(__PT_ORIG_GPR2, offsetof(struct pt_regs, orig_gpr2),);
-	DEFINE(__PT_ILC, offsetof(struct pt_regs, ilc),);
-	DEFINE(__PT_TRAP, offsetof(struct pt_regs, trap),);
-	DEFINE(__PT_SIZE, sizeof(struct pt_regs),);
+	DEFINE(__PT_ARGS, offsetof(struct pt_regs, args));
+	DEFINE(__PT_PSW, offsetof(struct pt_regs, psw));
+	DEFINE(__PT_GPRS, offsetof(struct pt_regs, gprs));
+	DEFINE(__PT_ORIG_GPR2, offsetof(struct pt_regs, orig_gpr2));
+	DEFINE(__PT_ILC, offsetof(struct pt_regs, ilc));
+	DEFINE(__PT_TRAP, offsetof(struct pt_regs, trap));
+	DEFINE(__PT_SIZE, sizeof(struct pt_regs));
 	BLANK();
-	DEFINE(__SF_BACKCHAIN, offsetof(struct stack_frame, back_chain),);
-	DEFINE(__SF_GPRS, offsetof(struct stack_frame, gprs),);
-	DEFINE(__SF_EMPTY, offsetof(struct stack_frame, empty1),);
+	DEFINE(__SF_BACKCHAIN, offsetof(struct stack_frame, back_chain));
+	DEFINE(__SF_GPRS, offsetof(struct stack_frame, gprs));
+	DEFINE(__SF_EMPTY, offsetof(struct stack_frame, empty1));
 	return 0;
 }
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
mm-fix-broken-gfp_zone-with-__gfp_thisnode.patch
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
s390-use-kbuildh-instead-of-defining-macros-in-asm-offsetsc-update.patch
sh-use-kbuildh-instead-of-defining-macros-in-asm-offsetsc.patch
v850-use-kbuildh-instead-of-defining-macros-in-asm-offsetsc.patch
reiser4.patch
reiser4-portion-of-zero_user-cleanup-patch.patch
page-owner-tracking-leak-detector.patch

