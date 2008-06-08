From: akpm@linux-foundation.org
Subject: + fs-check-for-statfs-overflow.patch added to -mm tree
Date: Sun, 08 Jun 2008 12:15:02 -0700
Message-ID: <200806081915.m58JF2Xm016362@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53746 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754019AbYFHTQf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Sun, 8 Jun 2008 15:16:35 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: npiggin@suse.de, kniht@linux.vnet.ibm.com, nacc@us.ibm.com


The patch titled
     fs: check for statfs overflow
has been added to the -mm tree.  Its filename is
     fs-check-for-statfs-overflow.patch

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
Subject: fs: check for statfs overflow
From: Nick Piggin <npiggin@suse.de>

Adds a check for an overflow in the filesystem size so if someone is
checking with statfs() on a 16G hugetlbfs in a 32bit binary that it will
report back EOVERFLOW instead of a size of 0.

Acked-by: Nishanth Aravamudan <nacc@us.ibm.com>
Signed-off-by: Jon Tollefson <kniht@linux.vnet.ibm.com>
Signed-off-by: Nick Piggin <npiggin@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/compat.c |    8 ++++----
 fs/open.c   |    3 ++-
 2 files changed, 6 insertions(+), 5 deletions(-)

diff -puN fs/compat.c~fs-check-for-statfs-overflow fs/compat.c
--- a/fs/compat.c~fs-check-for-statfs-overflow
+++ a/fs/compat.c
@@ -197,8 +197,8 @@ static int put_compat_statfs(struct comp
 {
 	
 	if (sizeof ubuf->f_blocks == 4) {
-		if ((kbuf->f_blocks | kbuf->f_bfree | kbuf->f_bavail) &
-		    0xffffffff00000000ULL)
+		if ((kbuf->f_blocks | kbuf->f_bfree | kbuf->f_bavail |
+		     kbuf->f_bsize | kbuf->f_frsize) & 0xffffffff00000000ULL)
 			return -EOVERFLOW;
 		/* f_files and f_ffree may be -1; it's okay
 		 * to stuff that into 32 bits */
@@ -271,8 +271,8 @@ out:
 static int put_compat_statfs64(struct compat_statfs64 __user *ubuf, struct kstatfs *kbuf)
 {
 	if (sizeof ubuf->f_blocks == 4) {
-		if ((kbuf->f_blocks | kbuf->f_bfree | kbuf->f_bavail) &
-		    0xffffffff00000000ULL)
+		if ((kbuf->f_blocks | kbuf->f_bfree | kbuf->f_bavail |
+		     kbuf->f_bsize | kbuf->f_frsize) & 0xffffffff00000000ULL)
 			return -EOVERFLOW;
 		/* f_files and f_ffree may be -1; it's okay
 		 * to stuff that into 32 bits */
diff -puN fs/open.c~fs-check-for-statfs-overflow fs/open.c
--- a/fs/open.c~fs-check-for-statfs-overflow
+++ a/fs/open.c
@@ -63,7 +63,8 @@ static int vfs_statfs_native(struct dent
 		memcpy(buf, &st, sizeof(st));
 	else {
 		if (sizeof buf->f_blocks == 4) {
-			if ((st.f_blocks | st.f_bfree | st.f_bavail) &
+			if ((st.f_blocks | st.f_bfree | st.f_bavail |
+			     st.f_bsize | st.f_frsize) &
 			    0xffffffff00000000ULL)
 				return -EOVERFLOW;
 			/*
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

