Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D62BB1BC9E2;
	Thu, 19 Dec 2024 23:25:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734650720; cv=none; b=WTWw9D6HNlbqmxFAhNL5tS3WRwR8FTS1gwl15L+1uE+dp5Pl63AxED5YypJ+NmzzryFCCgnBv4fwBeyqXe9aAw5hI8vllkpoEedLZ0g4DBi4tdSHU9zqvQv83b2CuIPgpUo77S59h+B4wM4/yzuXW8PZa1ACYHSicFSbIYBym4s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734650720; c=relaxed/simple;
	bh=0DWWopS3PYjj0w1IdbHxOelfoXCiWsfZuLZRjJEiOVo=;
	h=Date:To:From:Subject:Message-Id; b=Va07vsRzJ+SQ1TUdYOiBBwresQslqSpcOKjk2sZfuvP54AJJo/+MfmQwl/EB47pATqg4p/5M5OzC/HHvJTebDG/5PD4I7gvAPBKzgT/0e2Kgswal0FYkSOWkIkV4BhSDGpc2KMdQg265BJ5RgTRbilXh3c0CLR12k3WRKusuFqw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=D2MKnVv6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="D2MKnVv6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 62F29C4CECE;
	Thu, 19 Dec 2024 23:25:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1734650719;
	bh=0DWWopS3PYjj0w1IdbHxOelfoXCiWsfZuLZRjJEiOVo=;
	h=Date:To:From:Subject:From;
	b=D2MKnVv65/OWk4OpZbg7HJTJbS1lhuXZcyucdJNsfyEV+GBui044TP20FOewj4Gfu
	 TwD6XhlCyd/DhsJ47+PVwnEqK3gbI1E+XXbr+uFC5938UXuc1n0y+1/Fawns4WQF7s
	 d7tivnH7t2af7yBV9BuJ35LdarlD8E2kw8C6bhrA=
Date: Thu, 19 Dec 2024 15:25:18 -0800
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,hughd@google.com,david@redhat.com,baolin.wang@linux.alibaba.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-shmem-fix-incorrect-index-alignment-for-within_size-policy.patch added to mm-hotfixes-unstable branch
Message-Id: <20241219232519.62F29C4CECE@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: shmem: fix incorrect index alignment for within_size policy
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-shmem-fix-incorrect-index-alignment-for-within_size-policy.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-shmem-fix-incorrect-index-alignment-for-within_size-policy.patch

This patch will later appear in the mm-hotfixes-unstable branch at
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
From: Baolin Wang <baolin.wang@linux.alibaba.com>
Subject: mm: shmem: fix incorrect index alignment for within_size policy
Date: Thu, 19 Dec 2024 15:30:08 +0800

With enabling the shmem per-size within_size policy, using an incorrect
'order' size to round_up() the index can lead to incorrect i_size checks,
resulting in an inappropriate large orders being returned.

Changing to use '1 << order' to round_up() the index to fix this issue. 
Additionally, adding an 'aligned_index' variable to avoid affecting the
index checks.

Link: https://lkml.kernel.org/r/77d8ef76a7d3d646e9225e9af88a76549a68aab1.1734593154.git.baolin.wang@linux.alibaba.com
Fixes: e7a2ab7b3bb5 ("mm: shmem: add mTHP support for anonymous shmem")
Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Acked-by: David Hildenbrand <david@redhat.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/shmem.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/mm/shmem.c~mm-shmem-fix-incorrect-index-alignment-for-within_size-policy
+++ a/mm/shmem.c
@@ -1689,6 +1689,7 @@ unsigned long shmem_allowable_huge_order
 	unsigned long mask = READ_ONCE(huge_shmem_orders_always);
 	unsigned long within_size_orders = READ_ONCE(huge_shmem_orders_within_size);
 	unsigned long vm_flags = vma ? vma->vm_flags : 0;
+	pgoff_t aligned_index;
 	bool global_huge;
 	loff_t i_size;
 	int order;
@@ -1723,9 +1724,9 @@ unsigned long shmem_allowable_huge_order
 	/* Allow mTHP that will be fully within i_size. */
 	order = highest_order(within_size_orders);
 	while (within_size_orders) {
-		index = round_up(index + 1, order);
+		aligned_index = round_up(index + 1, 1 << order);
 		i_size = round_up(i_size_read(inode), PAGE_SIZE);
-		if (i_size >> PAGE_SHIFT >= index) {
+		if (i_size >> PAGE_SHIFT >= aligned_index) {
 			mask |= within_size_orders;
 			break;
 		}
_

Patches currently in -mm which might be from baolin.wang@linux.alibaba.com are

docs-mm-fix-the-incorrect-filehugemapped-field.patch
mm-shmem-fix-incorrect-index-alignment-for-within_size-policy.patch
mm-shmem-fix-the-update-of-shmem_falloc-nr_unswapped.patch
mm-factor-out-the-order-calculation-into-a-new-helper.patch
mm-shmem-change-shmem_huge_global_enabled-to-return-huge-order-bitmap.patch
mm-shmem-add-large-folio-support-for-tmpfs.patch
mm-shmem-add-a-kernel-command-line-to-change-the-default-huge-policy-for-tmpfs.patch
docs-tmpfs-drop-fadvise-from-the-documentation.patch

