Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F1A43C433FE
	for <mm-commits@archiver.kernel.org>; Tue,  4 Oct 2022 19:41:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229436AbiJDTls (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 4 Oct 2022 15:41:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35710 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229565AbiJDTlr (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 4 Oct 2022 15:41:47 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B952659E5
        for <mm-commits@vger.kernel.org>; Tue,  4 Oct 2022 12:41:46 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 010B3614FF
        for <mm-commits@vger.kernel.org>; Tue,  4 Oct 2022 19:41:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 50CA2C433C1;
        Tue,  4 Oct 2022 19:41:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1664912505;
        bh=n+Z/egqRQkIKuPmtncz2xoOk+kpzQNGTg7aOQXWfGNE=;
        h=Date:To:From:Subject:From;
        b=Aqi5xUs/uBAWvmPzWoH9V9HJqP2QvUFrBOTcWeD22wYmpHmTBx4hQYTJzb9f+RgQe
         rgZ+UeQrm7x25x9Gf5zkHAVu4IZZE/xQOoo5wmnitmmC8DvVBMDRIHTXd1g0uH4xF2
         AKnbwryAgTCrbTH+jeNA6+8Zk8C6Ugd5j+5cP+e0=
Date:   Tue, 04 Oct 2022 12:41:44 -0700
To:     mm-commits@vger.kernel.org, rppt@linux.vnet.ibm.com,
        nadav.amit@gmail.com, mike.kravetz@oracle.com, david@redhat.com,
        axelrasmussen@google.com, aarcange@redhat.com, peterx@redhat.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-hugetlb-fix-race-condition-of-uffd-missing-minor-handling.patch added to mm-unstable branch
Message-Id: <20221004194145.50CA2C433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/hugetlb: fix race condition of uffd missing/minor handling
has been added to the -mm mm-unstable branch.  Its filename is
     mm-hugetlb-fix-race-condition-of-uffd-missing-minor-handling.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-hugetlb-fix-race-condition-of-uffd-missing-minor-handling.patch

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
From: Peter Xu <peterx@redhat.com>
Subject: mm/hugetlb: fix race condition of uffd missing/minor handling
Date: Tue, 4 Oct 2022 15:33:58 -0400

Patch series "mm/hugetlb: Fix selftest failures with write check", v3.

Currently akpm mm-unstable fails with uffd hugetlb private mapping test
randomly on a write check.

The initial bisection of that points to the recent pmd unshare series, but
it turns out there's no direction relationship with the series but only
some timing change caused the race to start trigger.

The race should be fixed in patch 1.  Patch 2 is a trivial cleanup on the
similar race with hugetlb migrations, patch 3 comment on the write check
so when anyone read it again it'll be clear why it's there.


This patch (of 3):

After the recent rework patchset of hugetlb locking on pmd sharing,
kselftest for userfaultfd sometimes fails on hugetlb private tests with
unexpected write fault checks.

It turns out there's nothing wrong within the locking series regarding
this matter, but it could have changed the timing of threads so it can
trigger an old bug.

The real bug is when we call hugetlb_no_page() we're not with the pgtable
lock.  It means we're reading the pte values lockless.  It's perfectly
fine in most cases because before we do normal page allocations we'll take
the lock and check pte_same() again.  However before that, there are
actually two paths on userfaultfd missing/minor handling that may directly
move on with the fault process without checking the pte values.

It means for these two paths we may be generating an uffd message based on
an unstable pte, while an unstable pte can legally be anything as long as
the modifier holds the pgtable lock.

One example, which is also what happened in the failing kselftest and
caused the test failure, is that for private mappings wr-protection
changes can happen on one page.  While hugetlb_change_protection()
generally requires pte being cleared before being changed, then there can
be a race condition like:

        thread 1                              thread 2
        --------                              --------

      UFFDIO_WRITEPROTECT                     hugetlb_fault
        hugetlb_change_protection
          pgtable_lock()
          huge_ptep_modify_prot_start
                                              pte==NULL
                                              hugetlb_no_page
                                                generate uffd missing event
                                                even if page existed!!
          huge_ptep_modify_prot_commit
          pgtable_unlock()

Fix this by rechecking the pte after pgtable lock for both userfaultfd
missing & minor fault paths.

This bug should have been around starting from uffd hugetlb introduced, so
attaching a Fixes to the commit.  Also attach another Fixes to the minor
support commit for easier tracking.

Note that userfaultfd is actually fine with false positives (e.g.  caused
by pte changed), but not wrong logical events (e.g.  caused by reading a
pte during changing).  The latter can confuse the userspace, so the
strictness is very much preferred.  E.g., MISSING event should never
happen on the page after UFFDIO_COPY has correctly installed the page and
returned.

Link: https://lkml.kernel.org/r/20221004193400.110155-1-peterx@redhat.com
Link: https://lkml.kernel.org/r/20221004193400.110155-2-peterx@redhat.com
Fixes: 1a1aad8a9b7b ("userfaultfd: hugetlbfs: add userfaultfd hugetlb hook")
Fixes: 7677f7fd8be7 ("userfaultfd: add minor fault registration mode")
Signed-off-by: Peter Xu <peterx@redhat.com>
Co-developed-by: Mike Kravetz <mike.kravetz@oracle.com>
Reviewed-by: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: Nadav Amit <nadav.amit@gmail.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Mike Rapoport <rppt@linux.vnet.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |   59 +++++++++++++++++++++++++++++++++++++++++++------
 1 file changed, 52 insertions(+), 7 deletions(-)

--- a/mm/hugetlb.c~mm-hugetlb-fix-race-condition-of-uffd-missing-minor-handling
+++ a/mm/hugetlb.c
@@ -5524,6 +5524,23 @@ static inline vm_fault_t hugetlb_handle_
 	return handle_userfault(&vmf, reason);
 }
 
+/*
+ * Recheck pte with pgtable lock.  Returns true if pte didn't change, or
+ * false if pte changed or is changing.
+ */
+static bool hugetlb_pte_stable(struct hstate *h, struct mm_struct *mm,
+			       pte_t *ptep, pte_t old_pte)
+{
+	spinlock_t *ptl;
+	bool same;
+
+	ptl = huge_pte_lock(h, mm, ptep);
+	same = pte_same(huge_ptep_get(ptep), old_pte);
+	spin_unlock(ptl);
+
+	return same;
+}
+
 static vm_fault_t hugetlb_no_page(struct mm_struct *mm,
 			struct vm_area_struct *vma,
 			struct address_space *mapping, pgoff_t idx,
@@ -5564,10 +5581,33 @@ static vm_fault_t hugetlb_no_page(struct
 		if (idx >= size)
 			goto out;
 		/* Check for page in userfault range */
-		if (userfaultfd_missing(vma))
-			return hugetlb_handle_userfault(vma, mapping, idx,
-						       flags, haddr, address,
-						       VM_UFFD_MISSING);
+		if (userfaultfd_missing(vma)) {
+			/*
+			 * Since hugetlb_no_page() was examining pte
+			 * without pgtable lock, we need to re-test under
+			 * lock because the pte may not be stable and could
+			 * have changed from under us.  Try to detect
+			 * either changed or during-changing ptes and retry
+			 * properly when needed.
+			 *
+			 * Note that userfaultfd is actually fine with
+			 * false positives (e.g. caused by pte changed),
+			 * but not wrong logical events (e.g. caused by
+			 * reading a pte during changing).  The latter can
+			 * confuse the userspace, so the strictness is very
+			 * much preferred.  E.g., MISSING event should
+			 * never happen on the page after UFFDIO_COPY has
+			 * correctly installed the page and returned.
+			 */
+			if (!hugetlb_pte_stable(h, mm, ptep, old_pte)) {
+				ret = 0;
+				goto out;
+			}
+
+			return hugetlb_handle_userfault(vma, mapping, idx, flags,
+							haddr, address,
+							VM_UFFD_MISSING);
+		}
 
 		page = alloc_huge_page(vma, haddr, 0);
 		if (IS_ERR(page)) {
@@ -5633,9 +5673,14 @@ static vm_fault_t hugetlb_no_page(struct
 		if (userfaultfd_minor(vma)) {
 			unlock_page(page);
 			put_page(page);
-			return hugetlb_handle_userfault(vma, mapping, idx,
-						       flags, haddr, address,
-						       VM_UFFD_MINOR);
+			/* See comment in userfaultfd_missing() block above */
+			if (!hugetlb_pte_stable(h, mm, ptep, old_pte)) {
+				ret = 0;
+				goto out;
+			}
+			return hugetlb_handle_userfault(vma, mapping, idx, flags,
+							haddr, address,
+							VM_UFFD_MINOR);
 		}
 	}
 
_

Patches currently in -mm which might be from peterx@redhat.com are

mm-uffd-fix-warning-without-pte_marker_uffd_wp-compiled-in.patch
mm-hugetlb-fix-race-condition-of-uffd-missing-minor-handling.patch
mm-hugetlb-use-hugetlb_pte_stable-in-migration-race-check.patch
mm-selftest-uffd-explain-the-write-missing-fault-check.patch

