Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18E1F28DB3
	for <mm-commits@vger.kernel.org>; Sun, 21 Sep 2025 21:23:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758489825; cv=none; b=CqOVW6Egt6d/XKnQXBK9J6hpoWlJUcAwF5VabJqp1adFaWXzAzq9ndQgjTzRTHmsEfsa6tUpxaMvPMKfElqjV9LzLRWFO3r914D13j5Taa7RCulc8Z3n65C26c4FF+SmpZ6GxnAyUvfNC+Lr4uYvvWgAKB+48kXIKt7Ql0Q6PF4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758489825; c=relaxed/simple;
	bh=j8SfglipqrReVSDnPplvJgZqPFfIc8h26XNXo+B8XpU=;
	h=Date:To:From:Subject:Message-Id; b=PO85kS0gUFteIR58tWmUTqGM2dU+jgN4J0EbdCzimU0wjwOjAX8K1WVt2Jq2rlH3B6kqyjwtTvP4oQyo7Te7upgtlLOvCIA7grd2kSUVF593Fp2A1xk7go/FQdSVLXI9Z5S/U3sgBXZCFYfiUecubGrucu63i4J6BIGKMH4jYVE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=VHA+1WfI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="VHA+1WfI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E2D76C4CEE7;
	Sun, 21 Sep 2025 21:23:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1758489825;
	bh=j8SfglipqrReVSDnPplvJgZqPFfIc8h26XNXo+B8XpU=;
	h=Date:To:From:Subject:From;
	b=VHA+1WfIVt4gFQLW6P6cdKBINLoCsTOdnaC06W3VQ12L5fsMEoNgwav0ZThpUtG4A
	 Nc3/2fB8D7KyzVBD6f48tA9AbZuPCcz1wHX72RCpJza8G3vDznFzmTgKXXn1S4+3lU
	 ud3+oGTgn8w5zT7pCvoEJ+Ynq7YZR5Dqxzyw6IJo=
Date: Sun, 21 Sep 2025 14:23:44 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,lorenzo.stoakes@oracle.com,david@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] fs-hugetlbfs-remove-nth_page-usage-within-folio-in-adjust_range_hwpoison.patch removed from -mm tree
Message-Id: <20250921212344.E2D76C4CEE7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: fs: hugetlbfs: remove nth_page() usage within folio in adjust_range_hwpoison()
has been removed from the -mm tree.  Its filename was
     fs-hugetlbfs-remove-nth_page-usage-within-folio-in-adjust_range_hwpoison.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: David Hildenbrand <david@redhat.com>
Subject: fs: hugetlbfs: remove nth_page() usage within folio in adjust_range_hwpoison()
Date: Mon, 1 Sep 2025 17:03:36 +0200

The nth_page() is not really required anymore, so let's remove it.

Link: https://lkml.kernel.org/r/20250901150359.867252-16-david@redhat.com
Signed-off-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/hugetlbfs/inode.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/hugetlbfs/inode.c~fs-hugetlbfs-remove-nth_page-usage-within-folio-in-adjust_range_hwpoison
+++ a/fs/hugetlbfs/inode.c
@@ -217,7 +217,7 @@ static size_t adjust_range_hwpoison(stru
 			break;
 		offset += n;
 		if (offset == PAGE_SIZE) {
-			page = nth_page(page, 1);
+			page++;
 			offset = 0;
 		}
 	}
_

Patches currently in -mm which might be from david@redhat.com are


