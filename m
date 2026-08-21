Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44B2B361977
	for <mm-commits@vger.kernel.org>; Fri, 21 Aug 2026 22:21:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787350914; cv=none; b=ebvA0iOTP3KB9jeEhPscUVoII8LOcaPGYAlTlruB/l3juPnQcW0bslH4SEaQuroUPz/5RY1QPhJEZ1ArZGCSK1QZze4Ryon8sN4X29tD3yZp6cEFKXGVzrulMMq90oex4UkfxBqB03BxMMxOBYarowg1mjt7AOYNtKpnO/JQ0KI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787350914; c=relaxed/simple;
	bh=c/DXRE2vIRjCWhXmvh4qbGaMxwpIH9FPkz0+NVlo5tw=;
	h=Date:To:From:Subject:Message-Id; b=cbNaVz9zm2VFtiHkbxkqy3n/2ssmoGSkv501lOIvkCgSKmR1aZ/gx6wyilHT95D9QbwYPMX6ATTpHnUSeOMkIgzjI2t1Xh21+uqpdIhStAQSmGyaCQBHtGdTkFtBZGs9oR3ErcPnsR3tj7sOcQNPchB8IsAYHW1Xx/tPQq4acmA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=N7TobD0C; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="N7TobD0C"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 19A351F00A3D;
	Fri, 21 Aug 2026 22:21:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1787350913;
	bh=JdJBkXoRNX9JpGACmrp3y3KHCAJLRulQB2V8hkIJVMo=;
	h=Date:To:From:Subject;
	b=N7TobD0CZeXS/G5YUjZtvnA7qiU3NZ9V5ypJNhEL7ZZEYZYFIN7AGj+BdlZ3VHLo5
	 cfL9PNj3/QqTHY3RKsSOdheGjzeTZJO/hA5P2OklI5wo+ou2+ir9zxfFkiQ1JBJFll
	 SAFLey13QR9ivaghJiLbKBO17mJMTvZmgKelFEvs=
Date: Fri, 21 Aug 2026 15:21:52 -0700
To: mm-commits@vger.kernel.org,liam@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] maple_tree-catch-race-in-mas_alloc_cyclic.patch removed from -mm tree
Message-Id: <20260821222153.19A351F00A3D@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: maple_tree: catch race in mas_alloc_cyclic()
has been removed from the -mm tree.  Its filename was
     maple_tree-catch-race-in-mas_alloc_cyclic.patch

This patch was dropped because an updated version will be issued

------------------------------------------------------
From: "Liam R. Howlett (Oracle)" <liam@infradead.org>
Subject: maple_tree: catch race in mas_alloc_cyclic()
Date: Tue, 30 Jun 2026 15:08:36 -0400

If mas_alloc_cyclic() is called during a low memory situation, it is
possible the lock may be dropped so reclaim can occur.  There is a window
where some other task may allocate the same id and cause the mas_insert()
to fail with -EEXIST.  In this scenario the function will return -EEXIST,
which is not expected.

Modifying the retry on mas_nomem() to re-search for a slot means that any
race with other writes will not matter as the lock will be held between
finding the index and writing the index.

Moving the flag logic avoids cases where the flag is modified on drop
lock/reacquire or when the write fails after clearing the flag.

No existing users are exposed to this issue.

Link: https://lore.kernel.org/20260630190843.3563858-13-liam@infradead.org
Fixes: 9b6713cc7522 ("maple_tree: Add mtree_alloc_cyclic()")
Signed-off-by: Liam R. Howlett (Oracle) <liam@infradead.org>
Reported-by: Chris Mason <clm@meta.com>
Reviewed-by: Chuck Lever <cel@kernel.org>
Cc: Boqun Feng <boqun.feng@gmail.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Joe Perches <joe@perches.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Rik van Riel <riel@surriel.com>
Cc: Waiman Long <longman@redhat.com>
Cc: Will Deacon <will@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/maple_tree.c |   43 ++++++++++++++++++++++++-------------------
 1 file changed, 24 insertions(+), 19 deletions(-)

--- a/lib/maple_tree.c~maple_tree-catch-race-in-mas_alloc_cyclic
+++ a/lib/maple_tree.c
@@ -3868,35 +3868,40 @@ int mas_alloc_cyclic(struct ma_state *ma
 		void *entry, unsigned long range_lo, unsigned long range_hi,
 		unsigned long *next, gfp_t gfp)
 {
-	unsigned long min = range_lo;
-	int ret = 0;
-
-	range_lo = max(min, *next);
-	ret = mas_empty_area(mas, range_lo, range_hi, 1);
-	if ((mas->tree->ma_flags & MT_FLAGS_ALLOC_WRAPPED) && ret == 0) {
-		mas->tree->ma_flags &= ~MT_FLAGS_ALLOC_WRAPPED;
-		ret = 1;
-	}
-	if (ret < 0 && range_lo > min) {
-		mas_reset(mas);
-		ret = mas_empty_area(mas, min, range_hi, 1);
-		if (ret == 0)
-			ret = 1;
-	}
-	if (ret < 0)
-		return ret;
+	int ret;
+	unsigned long min;
 
+	min = range_lo;
 	do {
+		range_lo = max(min, *next);
+		ret = mas_empty_area(mas, range_lo, range_hi, 1);
+		if (ret < 0 && range_lo > min) {
+			mas_reset(mas);
+			ret = mas_empty_area(mas, min, range_hi, 1);
+			if (ret == 0)
+				ret = 1;
+		}
+		if (ret < 0)
+			goto out;
+
 		mas_insert(mas, entry);
 	} while (mas_nomem(mas, gfp));
-	if (mas_is_err(mas))
-		return xa_err(mas->node);
 
+	if (mas_is_err(mas)) {
+		ret = xa_err(mas->node);
+		goto out;
+	}
+
+	if ((mas->tree->ma_flags & MT_FLAGS_ALLOC_WRAPPED) && ret == 0) {
+		mas->tree->ma_flags &= ~MT_FLAGS_ALLOC_WRAPPED;
+		ret = 1;
+	}
 	*startp = mas->index;
 	*next = *startp + 1;
 	if (*next == 0)
 		mas->tree->ma_flags |= MT_FLAGS_ALLOC_WRAPPED;
 
+out:
 	mas_destroy(mas);
 	return ret;
 }
_

Patches currently in -mm which might be from liam@infradead.org are

maple_tree-document-that-erase-may-use-gfp_kernel-for-allocations.patch
maple_tree-warn_on_once-when-allocations-fail.patch
maple_tree-document-erase-and-allocations-better.patch
maple_tree-change-two-gfp-flags-in-tests.patch
maple_tree-fix-argument-name-in-header.patch
maple_tree-avoid-extra-gap-calculation.patch
maple_tree-add-helper-mas_make_walkable.patch

