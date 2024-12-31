Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90E7B84D02;
	Tue, 31 Dec 2024 02:00:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735610411; cv=none; b=TnRydwKk007PLsYtleAigBiKeV8n5qpry5lDOS7Vgxddro8C6xgnU7oRH5gqY5GZ6SEbj3h8C+HUiDS4FCGZme9C6xNs3xo4zZilC9odChwRwNLQ3c3KVvJIUAvblQwrljrZ4LzkBw9NsPtkfdKlxtuG7Jj22c+HguSYsDjzauM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735610411; c=relaxed/simple;
	bh=Yz99mR1tpPFG0uGLH2TZHKu8pVVKjhR2/+MftsDIaSw=;
	h=Date:To:From:Subject:Message-Id; b=PT0bSZGchHn4uTqv0pbmbYs6oXyNXQA0eue14b+rUVBJOtB/4H1XpwFmx14C95Enbb5JZR7HUwQmDAH4G1dKzjio75p2dGvRsFki9evor3oxGYFXr3Na9LJdXRAAgD6FCwB4M37exGfQ/P3V2449H7o8VRl0CivqEbv1VWREWfA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=v36D4WX/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="v36D4WX/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F06FC4CED0;
	Tue, 31 Dec 2024 02:00:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1735610411;
	bh=Yz99mR1tpPFG0uGLH2TZHKu8pVVKjhR2/+MftsDIaSw=;
	h=Date:To:From:Subject:From;
	b=v36D4WX/WlxQpwVH/8o4Cqj1YH2hSrm+7sqCgnuwIKSTRe/45lwa1eFF5nhQ4Duci
	 tlW0RA6uT9LXIbOa5Hzcmvqxc2RBeQPeRtmnJPJNYD1xr/HJjtlOsIBujMoreV3DZW
	 7CWPuGQmRtZa/ArBtOYVd+pQCdJHBvKqUQKlSTP8=
Date: Mon, 30 Dec 2024 18:00:10 -0800
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,hughd@google.com,david@redhat.com,baolin.wang@linux.alibaba.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mm-shmem-fix-incorrect-index-alignment-for-within_size-policy.patch removed from -mm tree
Message-Id: <20241231020011.4F06FC4CED0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: shmem: fix incorrect index alignment for within_size policy
has been removed from the -mm tree.  Its filename was
     mm-shmem-fix-incorrect-index-alignment-for-within_size-policy.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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

mm-factor-out-the-order-calculation-into-a-new-helper.patch
mm-shmem-change-shmem_huge_global_enabled-to-return-huge-order-bitmap.patch
mm-shmem-add-large-folio-support-for-tmpfs.patch
mm-shmem-add-a-kernel-command-line-to-change-the-default-huge-policy-for-tmpfs.patch
docs-tmpfs-drop-fadvise-from-the-documentation.patch

