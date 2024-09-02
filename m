Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C47BA47A5C
	for <mm-commits@vger.kernel.org>; Mon,  2 Sep 2024 03:28:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725247728; cv=none; b=MAcX/dzhsJg+VuhkdLQNHQlEJ5tG3WdCR/zyRjnTDhFk7bT6EMA5ivkR5kl/ztnQFgMPqr99pYqji251Rgicc7JtChPjJOvZ5qqNaHcWh9guBwU6+8F0BPa/lawZfkrb/fXM6f5WbY+zBZnn2nUOwCemab80LJAzYm16z/+AkBw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725247728; c=relaxed/simple;
	bh=yu7C8DgsbrybH5Wa9gfiHUGmk9iqHNekoHDk30YL88M=;
	h=Date:To:From:Subject:Message-Id; b=DO5k+SLDbVjHL7OVlstoQTySuCoESMQ79BHje/nGiIMj5dt0Cj0+B+9JnWE7Nc4szmRccsaT7Ii2SAybz/gtAsWmdYje5gI5kiArqpFF81so2rTrshI632HxkXvSEoQ7TZXrsiTQGaT8EO1spnH/jbZNClKmYGq/ymCqHJkIpD0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=DoN9r9gI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="DoN9r9gI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9AABFC4CEC2;
	Mon,  2 Sep 2024 03:28:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1725247728;
	bh=yu7C8DgsbrybH5Wa9gfiHUGmk9iqHNekoHDk30YL88M=;
	h=Date:To:From:Subject:From;
	b=DoN9r9gImb/Vu0IE5kNwlIFPLm/GiwOVYhV6cXNbkO3H3G/gCzFBJRU1wOahXDR/9
	 i27KXB2OgZ1hrBTKfaK7mhYEeWwFOvw3SodkCE1ILaQvKgGGB+v+DG7Pc5Em0WU8Ap
	 LgyHSjo20elQ2ZCMy3picu78R8GILXdShtAsTcDY=
Date: Sun, 01 Sep 2024 20:28:48 -0700
To: mm-commits@vger.kernel.org,viro@zeniv.linux.org.uk,peterx@redhat.com,muchun.song@linux.dev,jack@suse.cz,brauner@kernel.org,david@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-hugetlb-remove-hugetlb_follow_page_mask-leftover.patch removed from -mm tree
Message-Id: <20240902032848.9AABFC4CEC2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/hugetlb: remove hugetlb_follow_page_mask() leftover
has been removed from the -mm tree.  Its filename was
     mm-hugetlb-remove-hugetlb_follow_page_mask-leftover.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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

mm-rmap-use-folio-_mapcount-for-small-folios.patch
mm-always-inline-_compound_head-with-config_hugetlb_page_optimize_vmemmap=y.patch
selftests-mm-fix-charge_reserved_hugetlbsh-test.patch

