Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF64D17D2
	for <mm-commits@vger.kernel.org>; Wed, 18 Jun 2025 23:52:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750290779; cv=none; b=kMtNSPebCIGk5H0jDaSAx9CH0CH4v1b187Dm+VbaI/O+uaRB7UTXguEmXRWfB4qf9QH5xnjivwJsiLjJWWUHehmhnMSpzdl6kKB6ezOym3HT6Jr5Fg/3nJAC3H3CcESG0zamemZifIHMQXCGX67Gdw2GKf5jpVo/3l1JDIoLucE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750290779; c=relaxed/simple;
	bh=FgsrDRQv9/g7AcezM3sRUn62jRr0ZK4BP9mGHVZYSoE=;
	h=Date:To:From:Subject:Message-Id; b=E3iVwtHDOOOz4FsuvGl3QCZjiC56psUTOrOOI/vQurYptqMWKhcAfRjneVUQpSl9qLGraT5ODeYwJzxLLggsePmAqCFfcK+VynLJQCmc3kD6Czy44sAjgfTB7vrf/az9t8aTIcWfBGH5fhzBgetiNejAB9Z46uoleQuzSV9Er44=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=uinjCnVC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="uinjCnVC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E841C4CEE7;
	Wed, 18 Jun 2025 23:52:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1750290778;
	bh=FgsrDRQv9/g7AcezM3sRUn62jRr0ZK4BP9mGHVZYSoE=;
	h=Date:To:From:Subject:From;
	b=uinjCnVCW7exhY/x+Z+We8X5Iz7HYt/TZX0rfOKL8vKkSBQOzqhkKyWyVwDCU+YYO
	 /tnmw9qUEvh/dFDdCCIvt4+AXhI5552pFEVAGhCDKuvdYuW9v7AyHUa/IKJfgMg2RC
	 TcQ0AaweeBTRXWg4MKOh5qb5rUJxioBVVL0JJIi0=
Date: Wed, 18 Jun 2025 16:52:57 -0700
To: mm-commits@vger.kernel.org,steven.sistare@oracle.com,osalvador@suse.de,muchun.song@linux.dev,kraxel@redhat.com,david@redhat.com,vivek.kasireddy@intel.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-hugetlb-make-hugetlb_reserve_pages-return-nr-of-entries-updated.patch added to mm-new branch
Message-Id: <20250618235258.4E841C4CEE7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/hugetlb: make hugetlb_reserve_pages() return nr of entries updated
has been added to the -mm mm-new branch.  Its filename is
     mm-hugetlb-make-hugetlb_reserve_pages-return-nr-of-entries-updated.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-hugetlb-make-hugetlb_reserve_pages-return-nr-of-entries-updated.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

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
From: Vivek Kasireddy <vivek.kasireddy@intel.com>
Subject: mm/hugetlb: make hugetlb_reserve_pages() return nr of entries updated
Date: Tue, 17 Jun 2025 22:30:53 -0700

Patch series "mm/memfd: Reserve hugetlb folios before allocation", v4.

There are cases when we try to pin a folio but discover that it has not
been faulted-in.  So, we try to allocate it in memfd_alloc_folio() but the
allocation request may not succeed if there are no active reservations in
the system at that instant.

Therefore, making a reservation (by calling hugetlb_reserve_pages())
associated with the allocation will ensure that our request would not fail
due to lack of reservations.  This will also ensure that proper
region/subpool accounting is done with our allocation.


This patch (of 3):

Currently, hugetlb_reserve_pages() returns a bool to indicate whether the
reservation map update for the range [from, to] was successful or not. 
This is not sufficient for the case where the caller needs to determine
how many entries were updated for the range.

Therefore, have hugetlb_reserve_pages() return the number of entries
updated in the reservation map associated with the range [from, to]. 
Also, update the callers of hugetlb_reserve_pages() to handle the new
return value.

Link: https://lkml.kernel.org/r/20250618053415.1036185-1-vivek.kasireddy@intel.com
Link: https://lkml.kernel.org/r/20250618053415.1036185-2-vivek.kasireddy@intel.com
Signed-off-by: Vivek Kasireddy <vivek.kasireddy@intel.com>
Cc: Steve Sistare <steven.sistare@oracle.com>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: David Hildenbrand <david@redhat.com>
Cc: Gerd Hoffmann <kraxel@redhat.com>
Cc: Oscar Salvador <osalvador@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/hugetlbfs/inode.c    |    8 ++++----
 include/linux/hugetlb.h |    2 +-
 mm/hugetlb.c            |   19 +++++++++++++------
 3 files changed, 18 insertions(+), 11 deletions(-)

--- a/fs/hugetlbfs/inode.c~mm-hugetlb-make-hugetlb_reserve_pages-return-nr-of-entries-updated
+++ a/fs/hugetlbfs/inode.c
@@ -150,10 +150,10 @@ static int hugetlbfs_file_mmap(struct fi
 	if (inode->i_flags & S_PRIVATE)
 		vm_flags |= VM_NORESERVE;
 
-	if (!hugetlb_reserve_pages(inode,
+	if (hugetlb_reserve_pages(inode,
 				vma->vm_pgoff >> huge_page_order(h),
 				len >> huge_page_shift(h), vma,
-				vm_flags))
+				vm_flags) < 0)
 		goto out;
 
 	ret = 0;
@@ -1561,9 +1561,9 @@ struct file *hugetlb_file_setup(const ch
 	inode->i_size = size;
 	clear_nlink(inode);
 
-	if (!hugetlb_reserve_pages(inode, 0,
+	if (hugetlb_reserve_pages(inode, 0,
 			size >> huge_page_shift(hstate_inode(inode)), NULL,
-			acctflag))
+			acctflag) < 0)
 		file = ERR_PTR(-ENOMEM);
 	else
 		file = alloc_file_pseudo(inode, mnt, name, O_RDWR,
--- a/include/linux/hugetlb.h~mm-hugetlb-make-hugetlb_reserve_pages-return-nr-of-entries-updated
+++ a/include/linux/hugetlb.h
@@ -149,7 +149,7 @@ int hugetlb_mfill_atomic_pte(pte_t *dst_
 			     uffd_flags_t flags,
 			     struct folio **foliop);
 #endif /* CONFIG_USERFAULTFD */
-bool hugetlb_reserve_pages(struct inode *inode, long from, long to,
+long hugetlb_reserve_pages(struct inode *inode, long from, long to,
 						struct vm_area_struct *vma,
 						vm_flags_t vm_flags);
 long hugetlb_unreserve_pages(struct inode *inode, long start, long end,
--- a/mm/hugetlb.c~mm-hugetlb-make-hugetlb_reserve_pages-return-nr-of-entries-updated
+++ a/mm/hugetlb.c
@@ -7244,8 +7244,15 @@ long hugetlb_change_protection(struct vm
 	return pages > 0 ? (pages << h->order) : pages;
 }
 
-/* Return true if reservation was successful, false otherwise.  */
-bool hugetlb_reserve_pages(struct inode *inode,
+/*
+ * Update the reservation map for the range [from, to].
+ *
+ * Returns the number of entries that would be added to the reservation map
+ * associated with the range [from, to].  This number is greater or equal to
+ * zero. -EINVAL or -ENOMEM is returned in case of any errors.
+ */
+
+long hugetlb_reserve_pages(struct inode *inode,
 					long from, long to,
 					struct vm_area_struct *vma,
 					vm_flags_t vm_flags)
@@ -7260,7 +7267,7 @@ bool hugetlb_reserve_pages(struct inode
 	/* This should never happen */
 	if (from > to) {
 		VM_WARN(1, "%s called with a negative range\n", __func__);
-		return false;
+		return -EINVAL;
 	}
 
 	/*
@@ -7275,7 +7282,7 @@ bool hugetlb_reserve_pages(struct inode
 	 * without using reserves
 	 */
 	if (vm_flags & VM_NORESERVE)
-		return true;
+		return 0;
 
 	/*
 	 * Shared mappings base their reservation on the number of pages that
@@ -7382,7 +7389,7 @@ bool hugetlb_reserve_pages(struct inode
 			hugetlb_cgroup_put_rsvd_cgroup(h_cg);
 		}
 	}
-	return true;
+	return chg;
 
 out_put_pages:
 	spool_resv = chg - gbl_reserve;
@@ -7410,7 +7417,7 @@ out_err:
 		kref_put(&resv_map->refs, resv_map_release);
 		set_vma_resv_map(vma, NULL);
 	}
-	return false;
+	return chg < 0 ? chg : add < 0 ? add : -EINVAL;
 }
 
 long hugetlb_unreserve_pages(struct inode *inode, long start, long end,
_

Patches currently in -mm which might be from vivek.kasireddy@intel.com are

mm-hugetlb-make-hugetlb_reserve_pages-return-nr-of-entries-updated.patch
mm-memfd-reserve-hugetlb-folios-before-allocation.patch
selftests-udmabuf-add-a-test-to-pin-first-before-writing-to-memfd.patch

