Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE28B272E5C
	for <mm-commits@vger.kernel.org>; Fri, 27 Jun 2025 21:23:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751059409; cv=none; b=Mu3dS1faGiNXFFNarFtLqlhnefaECAOodXrpdsmDjWEMa5gqRj0ZXlLTgH47tw7op/9UkZZ6jKrNgBVSosWNu+S6kxJlAFUS0VNQiIiVn97BKLaMXJmnBLMCCXEVz3JlrtXmoBYIumpA2VMcXsuNECGJqWEXfjAexTUFEG0EGS0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751059409; c=relaxed/simple;
	bh=qVnPSIz3jxT9lsd8Z7620W/27QLESJLu5+yqPgnBN+M=;
	h=Date:To:From:Subject:Message-Id; b=r3Vh6jHWARhlYem6Si8AZlPfW9F7E8tLp+8HwCCKoKPJXGU0b0PDbO26MwuFKyI/SReAy+fYC2loTedbExDAANugt57ZCCNmySHmmU5kILSEMgy/bl/y4yUDNpWCKvVnDWrq5SdqNMpAlcEBoS4NlWjOLqsg0kh5dRjT8rHo6Cw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=iF8wNdxn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="iF8wNdxn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5C8E5C4CEE3;
	Fri, 27 Jun 2025 21:23:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1751059408;
	bh=qVnPSIz3jxT9lsd8Z7620W/27QLESJLu5+yqPgnBN+M=;
	h=Date:To:From:Subject:From;
	b=iF8wNdxnSsdGHIB/BoTzydEmeDFDMaus9dqlmMvKIdBIdjjnD/ZSJAe6UEl6XDzye
	 HXRueDvnSR/mJ5u7c4+edgFTF4a8sGo05ndGP1bFdPatXoLXziEtmnqFN4OOSwRQQV
	 XbicEbs2OJgo2H3cMgJmQdtJetB6/AkjJbpUpPL8=
Date: Fri, 27 Jun 2025 14:23:27 -0700
To: mm-commits@vger.kernel.org,vbabka@suse.cz,surenb@google.com,rppt@kernel.org,osalvador@suse.de,muchun.song@linux.dev,mhocko@suse.com,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,jthoughton@google.com,hughd@google.com,david@redhat.com,axelrasmussen@google.com,aarcange@redhat.com,peterx@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-hugetlb-support-vm_uffd_ops-api.patch added to mm-new branch
Message-Id: <20250627212328.5C8E5C4CEE3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/hugetlb: support vm_uffd_ops API
has been added to the -mm mm-new branch.  Its filename is
     mm-hugetlb-support-vm_uffd_ops-api.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-hugetlb-support-vm_uffd_ops-api.patch

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
From: Peter Xu <peterx@redhat.com>
Subject: mm/hugetlb: support vm_uffd_ops API
Date: Fri, 27 Jun 2025 11:46:54 -0400

Add support for the new vm_uffd_ops API for hugetlb.  Note that this only
introduces the support, the API is not yet used by core mm.

Due to legacy reasons, it's still not trivial to move hugetlb completely
to the API (like shmem).  But it will still use uffd_features and
uffd_ioctls properly on the API because that's pretty general.

Link: https://lkml.kernel.org/r/20250627154655.2085903-4-peterx@redhat.com
Signed-off-by: Peter Xu <peterx@redhat.com>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: James Houghton <jthoughton@google.com>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |   19 +++++++++++++++++++
 1 file changed, 19 insertions(+)

--- a/mm/hugetlb.c~mm-hugetlb-support-vm_uffd_ops-api
+++ a/mm/hugetlb.c
@@ -5457,6 +5457,22 @@ static vm_fault_t hugetlb_vm_op_fault(st
 	return 0;
 }
 
+#ifdef CONFIG_USERFAULTFD
+static const vm_uffd_ops hugetlb_uffd_ops = {
+	.uffd_features	= 	__VM_UFFD_FLAGS,
+	/* _UFFDIO_ZEROPAGE not supported */
+	.uffd_ioctls	= 	BIT(_UFFDIO_COPY) |
+				BIT(_UFFDIO_WRITEPROTECT) |
+				BIT(_UFFDIO_CONTINUE) |
+				BIT(_UFFDIO_POISON),
+	/*
+	 * Hugetlbfs still has its own hard-coded handler in userfaultfd,
+	 * due to limitations similar to vm_operations_struct.fault().
+	 * TODO: generalize it to use the API functions.
+	 */
+};
+#endif
+
 /*
  * When a new function is introduced to vm_operations_struct and added
  * to hugetlb_vm_ops, please consider adding the function to shm_vm_ops.
@@ -5470,6 +5486,9 @@ const struct vm_operations_struct hugetl
 	.close = hugetlb_vm_op_close,
 	.may_split = hugetlb_vm_op_split,
 	.pagesize = hugetlb_vm_op_pagesize,
+#ifdef CONFIG_USERFAULTFD
+	.userfaultfd_ops = &hugetlb_uffd_ops,
+#endif
 };
 
 static pte_t make_huge_pte(struct vm_area_struct *vma, struct folio *folio,
_

Patches currently in -mm which might be from peterx@redhat.com are

selftests-mm-reduce-uffd-unit-test-poison-test-to-minimum.patch
selftests-mm-reduce-uffd-unit-test-poison-test-to-minimum-fix.patch
mm-hugetlb-remove-prepare_hugepage_range.patch
mm-deduplicate-mm_get_unmapped_area.patch
mm-introduce-vm_uffd_ops-api.patch
mm-shmem-support-vm_uffd_ops-api.patch
mm-hugetlb-support-vm_uffd_ops-api.patch
mm-apply-vm_uffd_ops-api-to-core-mm.patch

