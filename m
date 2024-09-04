Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07A1E4D8A7
	for <mm-commits@vger.kernel.org>; Wed,  4 Sep 2024 03:59:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725422372; cv=none; b=leTg49InfO2dCYYQcxaSO1VR1DymeNmn4RwX/jndVEoG6PJDD62QP73Snz1AaOeSkv4XA2M7VW5Yg7g8p8doJgdJUBTqytRc+L3KTRevSynbGMDc0phwE055TILKapjce0CkNfbFFDBkKnYQSo//1T0pbrMjSMXR21qXMyfKmA8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725422372; c=relaxed/simple;
	bh=rakV/x9blhBoyRHQhEH+PRmLcJ8M+h+Xh1u2DwCWTR0=;
	h=Date:To:From:Subject:Message-Id; b=ZqQE1Kgfqb+wRmRb2dGvOCXHs3lO9STrnOYDLvuvG88ew4rKaZzE0A7Ew0OIgn7fAOc7S64QHbkUaoFdb97/5RuqtUd6GA8U92NqooGvueEYs3QrzDmYy+y1JpK/VNGcMekl1vaKNKAe+tS0SE4bgmuaz2xeTe4mJi3eoYm1FP0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=QnYE/T5z; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="QnYE/T5z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD480C4CEC2;
	Wed,  4 Sep 2024 03:59:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1725422371;
	bh=rakV/x9blhBoyRHQhEH+PRmLcJ8M+h+Xh1u2DwCWTR0=;
	h=Date:To:From:Subject:From;
	b=QnYE/T5zdDBrMfoBYneGO8Y8tOf9g7heCsWIk7Dfrp/ONGuFCVzpAneeYZh9yuFbS
	 ZVsDs475YwtZ6qWIeby+94klG6NhgAw7r4AcGy0jMbxxz9WgOCc41HSTfc4jOkmB0B
	 CvbdfQaeQ7mAakOAK8Pw9kC5lrj4hqyR4U0ClnjY=
Date: Tue, 03 Sep 2024 20:59:31 -0700
To: mm-commits@vger.kernel.org,yosryahmed@google.com,shakeel.butt@linux.dev,roman.gushchin@linux.dev,nphamcs@gmail.com,muchun.song@linux.dev,mkoutny@suse.com,mhocko@kernel.org,me@yhndnzj.com,hannes@cmpxchg.org,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] documentation-cgroup-v2-clarify-that-zswapwriteback-is-ignored-if-zswap-is-disabled-fix.patch removed from -mm tree
Message-Id: <20240904035931.CD480C4CEC2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: selftests-test_zswap-add-test-for-hierarchical-zswapwriteback-fix
has been removed from the -mm tree.  Its filename was
     documentation-cgroup-v2-clarify-that-zswapwriteback-is-ignored-if-zswap-is-disabled-fix.patch

This patch was dropped because it was folded into documentation-cgroup-v2-clarify-that-zswapwriteback-is-ignored-if-zswap-is-disabled.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: selftests-test_zswap-add-test-for-hierarchical-zswapwriteback-fix
Date: Fri Aug 23 10:25:10 PM PDT 2024

fix/simplify text

Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Michal Koutný <mkoutny@suse.com>
Cc: Mike Yuan <me@yhndnzj.com>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Nhat Pham <nphamcs@gmail.com>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Yosry Ahmed <yosryahmed@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/admin-guide/cgroup-v2.rst |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/Documentation/admin-guide/cgroup-v2.rst~documentation-cgroup-v2-clarify-that-zswapwriteback-is-ignored-if-zswap-is-disabled-fix
+++ a/Documentation/admin-guide/cgroup-v2.rst
@@ -1757,7 +1757,7 @@ The following nested keys are defined.
 	Note that this is subtly different from setting memory.swap.max to
 	0, as it still allows for pages to be written to the zswap pool.
 	This setting has no effect if zswap is disabled, and swapping
-	would be allowed unless memory.swap.max is set to 0.
+	is allowed unless memory.swap.max is set to 0.
 
   memory.pressure
 	A read-only nested-keyed file.
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

documentation-cgroup-v2-clarify-that-zswapwriteback-is-ignored-if-zswap-is-disabled.patch
mm-count-the-number-of-anonymous-thps-per-size-fix.patch
mm-memory-failure-add-unmap_poisoned_folio-fix.patch
mm-shmem-extend-shmem_unused_huge_shrink-to-all-sizes-fix.patch
mm-hugetlb-sort-out-global-lock-annotations-fix.patch
mm-hugetlb-sort-out-global-lock-annotations-fix-fix.patch
mmtmpfs-consider-end-of-file-write-in-shmem_is_huge-checkpatch-fixes.patch

