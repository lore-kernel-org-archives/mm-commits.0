Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A93E28DB3
	for <mm-commits@vger.kernel.org>; Sun, 21 Sep 2025 21:24:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758489850; cv=none; b=lG8mfyksCCG/i9+hX1ZhpsdFNnDYceQij3ErZhIejVowPkuTlNCn5RzoHRdB8vAWbjp8UFZ7REZdxpzBT930DLW1bybrgcXCm0UtyPbVd9NIOHmA/M7J4mqT69gVxiB5Fg+S9xYvOJ+QTg/0BMI6sWaLx72NpYvXE4uMn/LOjCw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758489850; c=relaxed/simple;
	bh=LqFhRQOXSixBrm3TdhkGuA4t2gz/GB9hyeXoESQXxOE=;
	h=Date:To:From:Subject:Message-Id; b=TW+CJMkXwuoISrlsDuBYo5x/phAGzJzcXb5CIDK+touXm146dFc8FzLwdtxqzrjgDBmzRJJdl2rOSLCH2mmb3nc13LwMczKz5c2b2mCBqBZJ6ZTA1WUWRe1H7han0lcPT9Tbb0h60T6n2ev2NmkYu4RoowQyQqrRoG8mSqyTuEk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=LJa3q6xs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="LJa3q6xs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E471DC4CEE7;
	Sun, 21 Sep 2025 21:24:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1758489850;
	bh=LqFhRQOXSixBrm3TdhkGuA4t2gz/GB9hyeXoESQXxOE=;
	h=Date:To:From:Subject:From;
	b=LJa3q6xsPg4BhHpRMtKNo7TwqmRjegdfog3VcBEJFbIHIF4pUKcNaVT+wMpD/2GE2
	 7kZwCxu+P316xrkx7EkArC7F8GclRy8307dLE5cOVvc8zeblHcLI/b2EVGeEhyP3t/
	 dQx4HgEG4SoI7FSi/Yq7awJTeQItMehlue4A+FMQ=
Date: Sun, 21 Sep 2025 14:24:09 -0700
To: mm-commits@vger.kernel.org,lorenzo.stoakes@oracle.com,david@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] block-update-comment-of-struct-bio_vec-regarding-nth_page.patch removed from -mm tree
Message-Id: <20250921212409.E471DC4CEE7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: block: update comment of "struct bio_vec" regarding nth_page()
has been removed from the -mm tree.  Its filename was
     block-update-comment-of-struct-bio_vec-regarding-nth_page.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: David Hildenbrand <david@redhat.com>
Subject: block: update comment of "struct bio_vec" regarding nth_page()
Date: Mon, 1 Sep 2025 17:03:57 +0200

Ever since commit 858c708d9efb ("block: move the bi_size update out of
__bio_try_merge_page"), page_is_mergeable() no longer exists, and the
logic in bvec_try_merge_page() is now a simple page pointer comparison.

Link: https://lkml.kernel.org/r/20250901150359.867252-37-david@redhat.com
Signed-off-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/bvec.h |    7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

--- a/include/linux/bvec.h~block-update-comment-of-struct-bio_vec-regarding-nth_page
+++ a/include/linux/bvec.h
@@ -22,11 +22,8 @@ struct page;
  * @bv_len:    Number of bytes in the address range.
  * @bv_offset: Start of the address range relative to the start of @bv_page.
  *
- * The following holds for a bvec if n * PAGE_SIZE < bv_offset + bv_len:
- *
- *   nth_page(@bv_page, n) == @bv_page + n
- *
- * This holds because page_is_mergeable() checks the above property.
+ * All pages within a bio_vec starting from @bv_page are contiguous and
+ * can simply be iterated (see bvec_advance()).
  */
 struct bio_vec {
 	struct page	*bv_page;
_

Patches currently in -mm which might be from david@redhat.com are


