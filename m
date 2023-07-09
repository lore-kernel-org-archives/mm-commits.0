Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 22853EB64DA
	for <mm-commits@archiver.kernel.org>; Sun,  9 Jul 2023 00:55:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229666AbjGIAzU (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 8 Jul 2023 20:55:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55384 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229436AbjGIAzS (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sat, 8 Jul 2023 20:55:18 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D70C41B1
        for <mm-commits@vger.kernel.org>; Sat,  8 Jul 2023 17:55:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6187560B5E
        for <mm-commits@vger.kernel.org>; Sun,  9 Jul 2023 00:55:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 886AEC433C8;
        Sun,  9 Jul 2023 00:55:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1688864115;
        bh=fGFUvCASS3Q2RrKK8z3QTjTl05H8NNrYm5X24aCTgGQ=;
        h=Date:To:From:Subject:From;
        b=AT9R25p8TXm7hdX+8iQp5oWgSteyrihQsRTNvlIO02VYrVeKtgtfEolmUW0TqJ+DN
         Z3bayTzVkGCbCJr2BmDBRYKma0R6TGmhJzqXE0LSs6lhZUx7TO806MkrTxfqv61YjT
         6lD86H3g2SQK0WxkY7aThM660gOvuIxd0kvxZ7HQ=
Date:   Sat, 08 Jul 2023 17:55:14 -0700
To:     mm-commits@vger.kernel.org, zhangpeng362@huawei.com,
        yuzhao@google.com, ying.huang@intel.com,
        wangkefeng.wang@huawei.com, viro@zeniv.linux.org.uk,
        talumbau@google.com, surenb@google.com, suleiman@google.com,
        shuah@kernel.org, ryan.roberts@arm.com, rppt@kernel.org,
        peterx@redhat.com, naoya.horiguchi@nec.com, namit@vmware.com,
        muchun.song@linux.dev, mike.kravetz@oracle.com,
        linmiaohe@huawei.com, Liam.Howlett@oracle.com,
        jthoughton@google.com, jiaqiyan@google.com, hughd@google.com,
        heftig@archlinux.org, david@redhat.com, cuigaosheng1@huawei.com,
        corbet@lwn.net, brauner@kernel.org, bgeffon@google.com,
        axelrasmussen@google.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-make-pte_marker_swapin_error-more-general.patch added to mm-unstable branch
Message-Id: <20230709005515.886AEC433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: make PTE_MARKER_SWAPIN_ERROR more general
has been added to the -mm mm-unstable branch.  Its filename is
     mm-make-pte_marker_swapin_error-more-general.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-make-pte_marker_swapin_error-more-general.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Axel Rasmussen <axelrasmussen@google.com>
Subject: mm: make PTE_MARKER_SWAPIN_ERROR more general
Date: Fri, 7 Jul 2023 14:55:33 -0700

Patch series "add UFFDIO_POISON to simulate memory poisoning with UFFD",
v4.

This series adds a new userfaultfd feature, UFFDIO_POISON. See commit 4
for a detailed description of the feature.


This patch (of 8):

Future patches will reuse PTE_MARKER_SWAPIN_ERROR to implement
UFFDIO_POISON, so make some various preparations for that:

First, rename it to just PTE_MARKER_POISONED.  The "SWAPIN" can be
confusing since we're going to re-use it for something not really related
to swap.  This can be particularly confusing for things like hugetlbfs,
which doesn't support swap whatsoever.  Also rename some various helper
functions.

Next, fix pte marker copying for hugetlbfs.  Previously, it would WARN on
seeing a PTE_MARKER_SWAPIN_ERROR, since hugetlbfs doesn't support swap. 
But, since we're going to re-use it, we want it to go ahead and copy it
just like non-hugetlbfs memory does today.  Since the code to do this is
more complicated now, pull it out into a helper which can be re-used in
both places.  While we're at it, also make it slightly more explicit in
its handling of e.g.  uffd wp markers.

For non-hugetlbfs page faults, instead of returning VM_FAULT_SIGBUS for an
error entry, return VM_FAULT_HWPOISON.  For most cases this change doesn't
matter, e.g.  a userspace program would receive a SIGBUS either way.  But
for UFFDIO_POISON, this change will let KVM guests get an MCE out of the
box, instead of giving a SIGBUS to the hypervisor and requiring it to
somehow inject an MCE.

Finally, for hugetlbfs faults, handle PTE_MARKER_POISONED, and return
VM_FAULT_HWPOISON_LARGE in such cases.  Note that this can't happen today
because the lack of swap support means we'll never end up with such a PTE
anyway, but this behavior will be needed once such entries *can* show up
via UFFDIO_POISON.

Link: https://lkml.kernel.org/r/20230707215540.2324998-1-axelrasmussen@google.com
Link: https://lkml.kernel.org/r/20230707215540.2324998-2-axelrasmussen@google.com
Signed-off-by: Axel Rasmussen <axelrasmussen@google.com>
Acked-by: Peter Xu <peterx@redhat.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Brian Geffon <bgeffon@google.com>
Cc: Christian Brauner <brauner@kernel.org>
Cc: David Hildenbrand <david@redhat.com>
Cc: Gaosheng Cui <cuigaosheng1@huawei.com>
Cc: Huang, Ying <ying.huang@intel.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: James Houghton <jthoughton@google.com>
Cc: Jan Alexander Steffens (heftig) <heftig@archlinux.org>
Cc: Jiaqi Yan <jiaqiyan@google.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Liam R. Howlett <Liam.Howlett@oracle.com>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Mike Rapoport (IBM) <rppt@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Nadav Amit <namit@vmware.com>
Cc: Naoya Horiguchi <naoya.horiguchi@nec.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Suleiman Souhlal <suleiman@google.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: T.J. Alumbaugh <talumbau@google.com>
Cc: Yu Zhao <yuzhao@google.com>
Cc: ZhangPeng <zhangpeng362@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm_inline.h |   19 +++++++++++++++++++
 include/linux/swapops.h   |   15 ++++++++++-----
 mm/hugetlb.c              |   32 +++++++++++++++++++++-----------
 mm/madvise.c              |    2 +-
 mm/memory.c               |   15 +++++++++------
 mm/mprotect.c             |    4 ++--
 mm/shmem.c                |    4 ++--
 mm/swapfile.c             |    2 +-
 8 files changed, 65 insertions(+), 28 deletions(-)

--- a/include/linux/mm_inline.h~mm-make-pte_marker_swapin_error-more-general
+++ a/include/linux/mm_inline.h
@@ -524,6 +524,25 @@ static inline bool mm_tlb_flush_nested(s
 }
 
 /*
+ * Computes the pte marker to copy from the given source entry into dst_vma.
+ * If no marker should be copied, returns 0.
+ * The caller should insert a new pte created with make_pte_marker().
+ */
+static inline pte_marker copy_pte_marker(
+		swp_entry_t entry, struct vm_area_struct *dst_vma)
+{
+	pte_marker srcm = pte_marker_get(entry);
+	/* Always copy error entries. */
+	pte_marker dstm = srcm & PTE_MARKER_POISONED;
+
+	/* Only copy PTE markers if UFFD register matches. */
+	if ((srcm & PTE_MARKER_UFFD_WP) && userfaultfd_wp(dst_vma))
+		dstm |= PTE_MARKER_UFFD_WP;
+
+	return dstm;
+}
+
+/*
  * If this pte is wr-protected by uffd-wp in any form, arm the special pte to
  * replace a none pte.  NOTE!  This should only be called when *pte is already
  * cleared so we will never accidentally replace something valuable.  Meanwhile
--- a/include/linux/swapops.h~mm-make-pte_marker_swapin_error-more-general
+++ a/include/linux/swapops.h
@@ -393,7 +393,12 @@ static inline bool is_migration_entry_di
 typedef unsigned long pte_marker;
 
 #define  PTE_MARKER_UFFD_WP			BIT(0)
-#define  PTE_MARKER_SWAPIN_ERROR		BIT(1)
+/*
+ * "Poisoned" here is meant in the very general sense of "future accesses are
+ * invalid", instead of referring very specifically to hardware memory errors.
+ * This marker is meant to represent any of various different causes of this.
+ */
+#define  PTE_MARKER_POISONED			BIT(1)
 #define  PTE_MARKER_MASK			(BIT(2) - 1)
 
 static inline swp_entry_t make_pte_marker_entry(pte_marker marker)
@@ -421,15 +426,15 @@ static inline pte_t make_pte_marker(pte_
 	return swp_entry_to_pte(make_pte_marker_entry(marker));
 }
 
-static inline swp_entry_t make_swapin_error_entry(void)
+static inline swp_entry_t make_poisoned_swp_entry(void)
 {
-	return make_pte_marker_entry(PTE_MARKER_SWAPIN_ERROR);
+	return make_pte_marker_entry(PTE_MARKER_POISONED);
 }
 
-static inline int is_swapin_error_entry(swp_entry_t entry)
+static inline int is_poisoned_swp_entry(swp_entry_t entry)
 {
 	return is_pte_marker_entry(entry) &&
-	    (pte_marker_get(entry) & PTE_MARKER_SWAPIN_ERROR);
+	    (pte_marker_get(entry) & PTE_MARKER_POISONED);
 }
 
 /*
--- a/mm/hugetlb.c~mm-make-pte_marker_swapin_error-more-general
+++ a/mm/hugetlb.c
@@ -34,6 +34,7 @@
 #include <linux/nospec.h>
 #include <linux/delayacct.h>
 #include <linux/memory.h>
+#include <linux/mm_inline.h>
 
 #include <asm/page.h>
 #include <asm/pgalloc.h>
@@ -5101,15 +5102,12 @@ again:
 				entry = huge_pte_clear_uffd_wp(entry);
 			set_huge_pte_at(dst, addr, dst_pte, entry);
 		} else if (unlikely(is_pte_marker(entry))) {
-			/* No swap on hugetlb */
-			WARN_ON_ONCE(
-			    is_swapin_error_entry(pte_to_swp_entry(entry)));
-			/*
-			 * We copy the pte marker only if the dst vma has
-			 * uffd-wp enabled.
-			 */
-			if (userfaultfd_wp(dst_vma))
-				set_huge_pte_at(dst, addr, dst_pte, entry);
+			pte_marker marker = copy_pte_marker(
+				pte_to_swp_entry(entry), dst_vma);
+
+			if (marker)
+				set_huge_pte_at(dst, addr, dst_pte,
+						make_pte_marker(marker));
 		} else {
 			entry = huge_ptep_get(src_pte);
 			pte_folio = page_folio(pte_page(entry));
@@ -6089,14 +6087,26 @@ vm_fault_t hugetlb_fault(struct mm_struc
 	}
 
 	entry = huge_ptep_get(ptep);
-	/* PTE markers should be handled the same way as none pte */
-	if (huge_pte_none_mostly(entry))
+	if (huge_pte_none_mostly(entry)) {
+		if (is_pte_marker(entry)) {
+			pte_marker marker =
+				pte_marker_get(pte_to_swp_entry(entry));
+
+			if (marker & PTE_MARKER_POISONED) {
+				ret = VM_FAULT_HWPOISON_LARGE;
+				goto out_mutex;
+			}
+		}
+
 		/*
+		 * Other PTE markers should be handled the same way as none PTE.
+		 *
 		 * hugetlb_no_page will drop vma lock and hugetlb fault
 		 * mutex internally, which make us return immediately.
 		 */
 		return hugetlb_no_page(mm, vma, mapping, idx, address, ptep,
 				      entry, flags);
+	}
 
 	ret = 0;
 
--- a/mm/madvise.c~mm-make-pte_marker_swapin_error-more-general
+++ a/mm/madvise.c
@@ -664,7 +664,7 @@ static int madvise_free_pte_range(pmd_t
 				free_swap_and_cache(entry);
 				pte_clear_not_present_full(mm, addr, pte, tlb->fullmm);
 			} else if (is_hwpoison_entry(entry) ||
-				   is_swapin_error_entry(entry)) {
+				   is_poisoned_swp_entry(entry)) {
 				pte_clear_not_present_full(mm, addr, pte, tlb->fullmm);
 			}
 			continue;
--- a/mm/memory.c~mm-make-pte_marker_swapin_error-more-general
+++ a/mm/memory.c
@@ -860,8 +860,11 @@ copy_nonpresent_pte(struct mm_struct *ds
 			return -EBUSY;
 		return -ENOENT;
 	} else if (is_pte_marker_entry(entry)) {
-		if (is_swapin_error_entry(entry) || userfaultfd_wp(dst_vma))
-			set_pte_at(dst_mm, addr, dst_pte, pte);
+		pte_marker marker = copy_pte_marker(entry, dst_vma);
+
+		if (marker)
+			set_pte_at(dst_mm, addr, dst_pte,
+				   make_pte_marker(marker));
 		return 0;
 	}
 	if (!userfaultfd_wp(dst_vma))
@@ -1502,7 +1505,7 @@ static unsigned long zap_pte_range(struc
 			    !zap_drop_file_uffd_wp(details))
 				continue;
 		} else if (is_hwpoison_entry(entry) ||
-			   is_swapin_error_entry(entry)) {
+			   is_poisoned_swp_entry(entry)) {
 			if (!should_zap_cows(details))
 				continue;
 		} else {
@@ -3656,7 +3659,7 @@ static vm_fault_t pte_marker_clear(struc
 	 * none pte.  Otherwise it means the pte could have changed, so retry.
 	 *
 	 * This should also cover the case where e.g. the pte changed
-	 * quickly from a PTE_MARKER_UFFD_WP into PTE_MARKER_SWAPIN_ERROR.
+	 * quickly from a PTE_MARKER_UFFD_WP into PTE_MARKER_POISONED.
 	 * So is_pte_marker() check is not enough to safely drop the pte.
 	 */
 	if (pte_same(vmf->orig_pte, ptep_get(vmf->pte)))
@@ -3702,8 +3705,8 @@ static vm_fault_t handle_pte_marker(stru
 		return VM_FAULT_SIGBUS;
 
 	/* Higher priority than uffd-wp when data corrupted */
-	if (marker & PTE_MARKER_SWAPIN_ERROR)
-		return VM_FAULT_SIGBUS;
+	if (marker & PTE_MARKER_POISONED)
+		return VM_FAULT_HWPOISON;
 
 	if (pte_marker_entry_uffd_wp(entry))
 		return pte_marker_handle_uffd_wp(vmf);
--- a/mm/mprotect.c~mm-make-pte_marker_swapin_error-more-general
+++ a/mm/mprotect.c
@@ -230,10 +230,10 @@ static long change_pte_range(struct mmu_
 					newpte = pte_swp_mkuffd_wp(newpte);
 			} else if (is_pte_marker_entry(entry)) {
 				/*
-				 * Ignore swapin errors unconditionally,
+				 * Ignore error swap entries unconditionally,
 				 * because any access should sigbus anyway.
 				 */
-				if (is_swapin_error_entry(entry))
+				if (is_poisoned_swp_entry(entry))
 					continue;
 				/*
 				 * If this is uffd-wp pte marker and we'd like
--- a/mm/shmem.c~mm-make-pte_marker_swapin_error-more-general
+++ a/mm/shmem.c
@@ -1724,7 +1724,7 @@ static void shmem_set_folio_swapin_error
 	swp_entry_t swapin_error;
 	void *old;
 
-	swapin_error = make_swapin_error_entry();
+	swapin_error = make_poisoned_swp_entry();
 	old = xa_cmpxchg_irq(&mapping->i_pages, index,
 			     swp_to_radix_entry(swap),
 			     swp_to_radix_entry(swapin_error), 0);
@@ -1769,7 +1769,7 @@ static int shmem_swapin_folio(struct ino
 	swap = radix_to_swp_entry(*foliop);
 	*foliop = NULL;
 
-	if (is_swapin_error_entry(swap))
+	if (is_poisoned_swp_entry(swap))
 		return -EIO;
 
 	si = get_swap_device(swap);
--- a/mm/swapfile.c~mm-make-pte_marker_swapin_error-more-general
+++ a/mm/swapfile.c
@@ -1771,7 +1771,7 @@ static int unuse_pte(struct vm_area_stru
 			swp_entry = make_hwpoison_entry(swapcache);
 			page = swapcache;
 		} else {
-			swp_entry = make_swapin_error_entry();
+			swp_entry = make_poisoned_swp_entry();
 		}
 		new_pte = swp_entry_to_pte(swp_entry);
 		ret = 0;
_

Patches currently in -mm which might be from axelrasmussen@google.com are

mm-make-pte_marker_swapin_error-more-general.patch
mm-userfaultfd-check-for-start-len-overflow-in-validate_range.patch
mm-userfaultfd-extract-file-size-check-out-into-a-helper.patch
mm-userfaultfd-add-new-uffdio_poison-ioctl.patch
mm-userfaultfd-support-uffdio_poison-for-hugetlbfs.patch
mm-userfaultfd-document-and-enable-new-uffdio_poison-feature.patch
selftests-mm-refactor-uffd_poll_thread-to-allow-custom-fault-handlers.patch
selftests-mm-add-uffd-unit-test-for-uffdio_poison.patch

