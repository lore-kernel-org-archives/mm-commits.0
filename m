Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B8971B14FD
	for <mm-commits@vger.kernel.org>; Wed, 31 Jul 2024 15:22:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722439369; cv=none; b=qibs65YOZhZ1hScFsdRRXmUsqT9s6F+jW8Ruce8oo9JornvDLJw0Ls06ogcdV+0lreZcGtNkJU2OcGuwn2ucdBcN89vB6SmAIch82nvDzopeu59rZK0v8zbW5ivFtezS9CdQezl+0j+CMw5V7MmTx7qv5/mQRQ32exXFDh+9fuQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722439369; c=relaxed/simple;
	bh=ttBumW8miJZ5MCVTkMOC5W3D9UZ2TWyWgJ0ACKfbLq0=;
	h=Date:To:From:Subject:Message-Id; b=bMudAPgyXLf9R2GnX93K8p1apMIFv0JoxMc7pUTOJ84yThNqudxlt7UjxeZYec820bhrao50yNuxpuhFjunGXjbnIyfu9szJYiAZa17yDOg12AJrrIKJF795usUlukzufPuF+jCCEzA8HRO5OqBMXjuRgEWNO+bYPkSqkZuJjCE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=xkWpzunj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="xkWpzunj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 047F2C4AF0B;
	Wed, 31 Jul 2024 15:22:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1722439369;
	bh=ttBumW8miJZ5MCVTkMOC5W3D9UZ2TWyWgJ0ACKfbLq0=;
	h=Date:To:From:Subject:From;
	b=xkWpzunjlP636DRHJcF+AFNWamozFFZZ8QotlXx+nUoEx8V2QVAfJlqwaT7n/Hd52
	 IeM5fylC7sl/ER70opgKjQno9ppqXzypYLTxT15dZJZJzh2uMPdfZnldwPI9kDa4Om
	 vTa+9ooiYz2pdLYb2v6qsqm0d12txpVmM0tT/KG0=
Date: Wed, 31 Jul 2024 08:22:48 -0700
To: mm-commits@vger.kernel.org,viro@zeniv.linux.org.uk,peterx@redhat.com,muchun.song@linux.dev,jack@suse.cz,brauner@kernel.org,david@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-hugetlb-remove-hugetlb_follow_page_mask-leftover.patch added to mm-unstable branch
Message-Id: <20240731152249.047F2C4AF0B@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/hugetlb: remove hugetlb_follow_page_mask() leftover
has been added to the -mm mm-unstable branch.  Its filename is
     mm-hugetlb-remove-hugetlb_follow_page_mask-leftover.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-hugetlb-remove-hugetlb_follow_page_mask-leftover.patch

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
From: David Hildenbrand <david@redhat.com>
Subject: mm/hugetlb: remove hugetlb_follow_page_mask() leftover
Date: Wed, 31 Jul 2024 16:20:00 +0200

We removed hugetlb_follow_page_mask() in commit 9cb28da54643 ("mm/gup:
handle hugetlb in the generic follow_page_mask code") but forgot to
cleanup some leftovers.

While at it, simplify the hugetlb comment, it's overly detailed and rather
confusing.  Stating that we may end up in there during coredumping is
sufficient to explain the PF_DUMPCORE usage.

Link: https://lkml.kernel.org/r/20240731142000.625044-1-david@redhat.com
Signed-off-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Peter Xu <peterx@redhat.com>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Christian Brauner <brauner@kernel.org>
Cc: Jan Kara <jack@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/userfaultfd.c        |   11 ++---------
 include/linux/hugetlb.h |    3 ---
 2 files changed, 2 insertions(+), 12 deletions(-)

--- a/fs/userfaultfd.c~mm-hugetlb-remove-hugetlb_follow_page_mask-leftover
+++ a/fs/userfaultfd.c
@@ -371,15 +371,8 @@ vm_fault_t handle_userfault(struct vm_fa
 	unsigned int blocking_state;
 
 	/*
-	 * We don't do userfault handling for the final child pid update.
-	 *
-	 * We also don't do userfault handling during
-	 * coredumping. hugetlbfs has the special
-	 * hugetlb_follow_page_mask() to skip missing pages in the
-	 * FOLL_DUMP case, anon memory also checks for FOLL_DUMP with
-	 * the no_page_table() helper in follow_page_mask(), but the
-	 * shmem_vm_ops->fault method is invoked even during
-	 * coredumping and it ends up here.
+	 * We don't do userfault handling for the final child pid update
+	 * and when coredumping (faults triggered by get_dump_page()).
 	 */
 	if (current->flags & (PF_EXITING|PF_DUMPCORE))
 		goto out;
--- a/include/linux/hugetlb.h~mm-hugetlb-remove-hugetlb_follow_page_mask-leftover
+++ a/include/linux/hugetlb.h
@@ -127,9 +127,6 @@ int move_hugetlb_page_tables(struct vm_a
 			     unsigned long len);
 int copy_hugetlb_page_range(struct mm_struct *, struct mm_struct *,
 			    struct vm_area_struct *, struct vm_area_struct *);
-struct page *hugetlb_follow_page_mask(struct vm_area_struct *vma,
-				      unsigned long address, unsigned int flags,
-				      unsigned int *page_mask);
 void unmap_hugepage_range(struct vm_area_struct *,
 			  unsigned long, unsigned long, struct page *,
 			  zap_flags_t);
_

Patches currently in -mm which might be from david@redhat.com are

mm-turn-use_split_pte_ptlocks-use_split_pte_ptlocks-into-kconfig-options.patch
mm-hugetlb-enforce-that-pmd-pt-sharing-has-split-pmd-pt-locks.patch
powerpc-8xx-document-and-enforce-that-split-pt-locks-are-not-used.patch
mm-simplify-arch_make_folio_accessible.patch
mm-gup-convert-to-arch_make_folio_accessible.patch
s390-uv-drop-arch_make_page_accessible.patch
mm-hugetlb-remove-hugetlb_follow_page_mask-leftover.patch

