Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B8321D7E4F
	for <mm-commits@vger.kernel.org>; Tue, 18 Mar 2025 05:10:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742274645; cv=none; b=Ht41VGkuKBWpFsJplP+shVfc0nH9qkDykCDrZEs7/Hbio8YABTGZDVe3fZul+5ihyQGyNAlpWHvb3CuRaLWUVZD8nBsm0uLJUhNVGlap49IYMgx3GZbe8Qxz8th99DxMwcIGC8Y3WbGwQgvixOLISXc2JUwzEf63iyUGbat4YA8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742274645; c=relaxed/simple;
	bh=3+Z6H5bFFG5NA6NJxwztCmW4ajwPmTqw09ZoUeQ0kxw=;
	h=Date:To:From:Subject:Message-Id; b=j15OZqAdNxSr2XtixKYvEux2hNvwLTwXN94WYgnbhugQtbtr7y7bcXCTsWNpc0syhUMtxyCjyO/RBaaYspl36zlyXSzxTd6+5lcXBtadXl5vpJlGl9GH85MhXGHgtZu1KYnau/HJfIzj4C8aaEzQAW2bNDcbFUB+KfYPewLN5Ww=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Uz4t5zXj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Uz4t5zXj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F85EC4CEDD;
	Tue, 18 Mar 2025 05:10:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1742274645;
	bh=3+Z6H5bFFG5NA6NJxwztCmW4ajwPmTqw09ZoUeQ0kxw=;
	h=Date:To:From:Subject:From;
	b=Uz4t5zXjzZ7u6Osj5apxsL3nbSgkg8ENtbINuo1rrxfszhceCk34X2Nh9WLEhH0wd
	 WQmL5ryDNjkh4MGOnq2khL2lMB5+lQAmpSjSPcx6Y/LVHNlnzs00O2S2JvN1unvxa+
	 Gizk67IadGQxUiSEaEl4sFO4mOa6BMC7RnOmZlL4=
Date: Mon, 17 Mar 2025 22:10:44 -0700
To: mm-commits@vger.kernel.org,vbabka@suse.cz,shakeel.butt@linux.dev,lorenzo.stoakes@oracle.com,howlett@gmail.com,david@redhat.com,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-madvise-split-out-populate-behavior-check-logic.patch removed from -mm tree
Message-Id: <20250318051045.3F85EC4CEDD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/madvise: split out populate behavior check logic
has been removed from the -mm tree.  Its filename was
     mm-madvise-split-out-populate-behavior-check-logic.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: mm/madvise: split out populate behavior check logic
Date: Wed, 12 Mar 2025 09:47:48 -0700

madvise_do_behavior() has a long open-coded 'behavior' check for
MADV_POPULATE_{READ,WRITE}.  It adds multiple layers[1] and make the code
arguably take longer time to read.  Like is_memory_failure(), split out
the check to a separate function.  This is not technically removing the
additional layer but discourage further extending the switch-case.  Also
it makes madvise_do_behavior() code shorter and therefore easier to read.

[1] https://lore.kernel.org/bd6d0bf1-c79e-46bd-a810-9791efb9ad73@lucifer.local

Link: https://lkml.kernel.org/r/20250312164750.59215-3-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Reviewed-by: Shakeel Butt <shakeel.butt@linux.dev>
Cc: David Hildenbrand <david@redhat.com>
Cc: Liam R. Howlett <howlett@gmail.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/madvise.c |   20 +++++++++++++-------
 1 file changed, 13 insertions(+), 7 deletions(-)

--- a/mm/madvise.c~mm-madvise-split-out-populate-behavior-check-logic
+++ a/mm/madvise.c
@@ -1640,6 +1640,17 @@ static bool is_valid_madvise(unsigned lo
 	return true;
 }
 
+static bool is_madvise_populate(int behavior)
+{
+	switch (behavior) {
+	case MADV_POPULATE_READ:
+	case MADV_POPULATE_WRITE:
+		return true;
+	default:
+		return false;
+	}
+}
+
 static int madvise_do_behavior(struct mm_struct *mm,
 		unsigned long start, size_t len_in, size_t len, int behavior)
 {
@@ -1653,16 +1664,11 @@ static int madvise_do_behavior(struct mm
 	end = start + len;
 
 	blk_start_plug(&plug);
-	switch (behavior) {
-	case MADV_POPULATE_READ:
-	case MADV_POPULATE_WRITE:
+	if (is_madvise_populate(behavior))
 		error = madvise_populate(mm, start, end, behavior);
-		break;
-	default:
+	else
 		error = madvise_walk_vmas(mm, start, end, behavior,
 					  madvise_vma_behavior);
-		break;
-	}
 	blk_finish_plug(&plug);
 	return error;
 }
_

Patches currently in -mm which might be from sj@kernel.org are


