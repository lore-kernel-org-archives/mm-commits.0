From: akpm@linux-foundation.org
Subject: + hugetlb-override-default-huge-page-size.patch added to -mm tree
Date: Sun, 08 Jun 2008 12:12:05 -0700
Message-ID: <200806081912.m58JC5wv016195@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44506 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754484AbYFHTMK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Sun, 8 Jun 2008 15:12:10 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: npiggin@suse.de


The patch titled
     hugetlb: override default huge page size
has been added to the -mm tree.  Its filename is
     hugetlb-override-default-huge-page-size.patch

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
Subject: hugetlb: override default huge page size
From: Nick Piggin <npiggin@suse.de>

Allow configurations with the default huge page size which is different to
the traditional HPAGE_SIZE size.  The default huge page size is the one
represented in the legacy /proc ABIs, SHM, and which is defaulted to when
mounting hugetlbfs filesystems.

This is implemented with a new kernel option default_hugepagesz=, which
defaults to HPAGE_SIZE if not specified.

Signed-off-by: Nick Piggin <npiggin@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/kernel-parameters.txt |    7 +++++++
 mm/hugetlb.c                        |   24 +++++++++++++++++-------
 2 files changed, 24 insertions(+), 7 deletions(-)

diff -puN Documentation/kernel-parameters.txt~hugetlb-override-default-huge-page-size Documentation/kernel-parameters.txt
--- a/Documentation/kernel-parameters.txt~hugetlb-override-default-huge-page-size
+++ a/Documentation/kernel-parameters.txt
@@ -766,6 +766,13 @@ and is between 256 and 4096 characters. 
 			CPU supports the "pdpe1gb" cpuinfo flag)
 			Note that 1GB pages can only be allocated at boot time
 			using hugepages= and not freed afterwards.
+	default_hugepagesz=
+			[same as hugepagesz=] The size of the default
+			HugeTLB page size. This is the size represented by
+			the legacy /proc/ hugepages APIs, used for SHM, and
+			default size when mounting hugetlbfs filesystems.
+			Defaults to the default architecture's huge page size
+			if not specified.
 
 	i8042.direct	[HW] Put keyboard port into non-translated mode
 	i8042.dumbkbd	[HW] Pretend that controller can only read data from
diff -puN mm/hugetlb.c~hugetlb-override-default-huge-page-size mm/hugetlb.c
--- a/mm/hugetlb.c~hugetlb-override-default-huge-page-size
+++ a/mm/hugetlb.c
@@ -1207,11 +1207,14 @@ static int __init hugetlb_init(void)
 {
 	BUILD_BUG_ON(HPAGE_SHIFT == 0);
 
-	if (!size_to_hstate(HPAGE_SIZE)) {
-		hugetlb_add_hstate(HUGETLB_PAGE_ORDER);
-		parsed_hstate->max_huge_pages = default_hstate_max_huge_pages;
-	}
-	default_hstate_idx = size_to_hstate(HPAGE_SIZE) - hstates;
+	if (!size_to_hstate(default_hstate_size)) {
+		default_hstate_size = HPAGE_SIZE;
+		if (!size_to_hstate(default_hstate_size))
+			hugetlb_add_hstate(HUGETLB_PAGE_ORDER);
+	}
+	default_hstate_idx = size_to_hstate(default_hstate_size) - hstates;
+	if (default_hstate_max_huge_pages)
+		default_hstate.max_huge_pages = default_hstate_max_huge_pages;
 
 	hugetlb_init_hstates();
 
@@ -1263,7 +1266,7 @@ void __init hugetlb_add_hstate(unsigned 
 	parsed_hstate = h;
 }
 
-static int __init hugetlb_setup(char *s)
+static int __init hugetlb_nrpages_setup(char *s)
 {
 	unsigned long *mhp;
 	static unsigned long *last_mhp;
@@ -1298,7 +1301,14 @@ static int __init hugetlb_setup(char *s)
 
 	return 1;
 }
-__setup("hugepages=", hugetlb_setup);
+__setup("hugepages=", hugetlb_nrpages_setup);
+
+static int __init hugetlb_default_setup(char *s)
+{
+	default_hstate_size = memparse(s, &s);
+	return 1;
+}
+__setup("default_hugepagesz=", hugetlb_default_setup);
 
 static unsigned int cpuset_mems_nr(unsigned int *array)
 {
_

Patches currently in -mm which might be from npiggin@suse.de are

hugetlb-fix-lockdep-error.patch
vt-fix-vc_resize-locking.patch
linux-next.patch
spufs-convert-nopfn-to-fault.patch
mspec-convert-nopfn-to-fault.patch
mspec-convert-nopfn-to-fault-fix.patch
mm-remove-nopfn.patch
mm-remove-double-indirection-on-tlb-parameter-to-free_pgd_range-co.patch
hugetlb-guarantee-that-cow-faults-for-a-process-that-called-mmapmap_private-on-hugetlbfs-will-succeed-build-fix.patch
hugetlb-factor-out-prep_new_huge_page.patch
hugetlb-modular-state-for-hugetlb-page-size.patch
hugetlb-modular-state-for-hugetlb-page-size-checkpatch-fixes.patch
hugetlb-multiple-hstates-for-multiple-page-sizes.patch
hugetlb-multiple-hstates-for-multiple-page-sizes-checkpatch-fixes.patch
hugetlbfs-per-mount-huge-page-sizes.patch
hugetlb-new-sysfs-interface.patch
hugetlb-abstract-numa-round-robin-selection.patch
mm-introduce-non-panic-alloc_bootmem.patch
mm-export-prep_compound_page-to-mm.patch
hugetlb-support-larger-than-max_order.patch
hugetlb-support-boot-allocate-different-sizes.patch
hugetlb-printk-cleanup.patch
hugetlb-introduce-pud_huge.patch
x86-support-gb-hugepages-on-64-bit.patch
x86-add-hugepagesz-option-on-64-bit.patch
hugetlb-override-default-huge-page-size.patch
hugetlb-allow-arch-overried-hugepage-allocation.patch
powerpc-function-to-allocate-gigantic-hugepages.patch
powerpc-scan-device-tree-for-gigantic-pages.patch
powerpc-define-support-for-16g-hugepages.patch
fs-check-for-statfs-overflow.patch
powerpc-support-multiple-hugepage-sizes.patch
x86-implement-pte_special.patch
mm-introduce-get_user_pages_fast.patch
mm-introduce-get_user_pages_fast-checkpatch-fixes.patch
x86-lockless-get_user_pages_fast.patch
x86-lockless-get_user_pages_fast-checkpatch-fixes.patch
x86-lockless-get_user_pages_fast-fix.patch
x86-lockless-get_user_pages_fast-fix-warning.patch
dio-use-get_user_pages_fast.patch
splice-use-get_user_pages_fast.patch
mm-readahead-scan-lockless.patch
radix-tree-add-gang_lookup_slot-gang_lookup_slot_tag.patch
mm-speculative-page-references.patch
mm-lockless-pagecache.patch
mm-spinlock-tree_lock.patch
powerpc-implement-pte_special.patch
powerpc-lockless-get_user_pages_fast.patch
vmscan-move-isolate_lru_page-to-vmscanc.patch
vmscan-mlocked-pages-are-non-reclaimable.patch
vmscan-handle-mlocked-pages-during-map-remap-unmap.patch
vmscan-mlocked-pages-statistics.patch
reiser4.patch
likeliness-accounting-change-and-cleanup.patch

