Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9BD5E36403C
	for <mm-commits@vger.kernel.org>; Tue, 25 Aug 2026 01:56:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787622980; cv=none; b=kvy5Sw1csCFf5z1jBB/0F9vGFQsq8TN+feSaihqcoV8e2j+B/yHTuRIAV2oXm2gIUGy4PrcJmki1BdoW1QALI67VXTOUUe6EOqnr8UrH2h7AgHZp4Np7ZIShplk4kmFep1VCdeDfkrQa7Vp+Bd2QbjTZjg6+pRYGI2qsBBTiCJI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787622980; c=relaxed/simple;
	bh=JPpwrp1La3Tx4eFtAUECPsjf54DNnXiGDgzw8Gon7W4=;
	h=Date:To:From:Subject:Message-Id; b=A47AYlgsJRtZg7M/ta1MMhU0/uY+EneepbJ5nHHUUzkvC+k4A3oIvF1eTre1OFEbHD4N2VJkG6m1ZPxsX3xewS9bWTEDaSRrXCWpxYt7Fngz2kHfpld0I/w47OaxbyaSOtKycVfXgB7LeX9D/PiAkDvAEP8GQ7P3qhRjbH3WVhE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=0fuD36qp; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="0fuD36qp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E68E1F00A3A;
	Tue, 25 Aug 2026 01:56:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1787622979;
	bh=t38kj81CyuOKK1WqGQxWL3fjeT5VXPmPv/SVNsl81Es=;
	h=Date:To:From:Subject;
	b=0fuD36qpZ/aIB2JW3jZE0rMOpO24f9NHcHB2kYLrt8mTelx0fpx+AC92ED5pLrdNM
	 vnYhnuNdTmDlR6ANRRorinviy/NsrgYGjZ/jBhrzIFsFjKfKaOcriHIcQ3WFqU4znI
	 /VWxKKV83CHOvFAVP2rILlYOtnF3Sv9y4N8B45Eg=
Date: Mon, 24 Aug 2026 18:56:18 -0700
To: mm-commits@vger.kernel.org,will@kernel.org,riel@surriel.com,peterz@infradead.org,mingo@redhat.com,longman@redhat.com,leitao@debian.org,joe@perches.com,jgg@ziepe.ca,clm@meta.com,cel@kernel.org,boqun.feng@gmail.com,liam@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] maple_tree-catch-race-in-mas_alloc_cyclic.patch removed from -mm tree
Message-Id: <20260825015619.1E68E1F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: maple_tree: catch race in mas_alloc_cyclic()
has been removed from the -mm tree.  Its filename was
     maple_tree-catch-race-in-mas_alloc_cyclic.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Liam R. Howlett (Oracle)" <liam@infradead.org>
Subject: maple_tree: catch race in mas_alloc_cyclic()
Date: Fri, 21 Aug 2026 15:26:20 -0400

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

Link: https://lore.kernel.org/20260821192627.4085470-13-liam@infradead.org
Fixes: 9b6713cc7522 ("maple_tree: Add mtree_alloc_cyclic()")
Signed-off-by: Liam R. Howlett (Oracle) <liam@infradead.org>
Reported-by: Chris Mason <clm@meta.com>
Reviewed-by: Chuck Lever <cel@kernel.org>
Cc: Boqun Feng <boqun.feng@gmail.com>
Cc: Breno Leitao <leitao@debian.org>
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


