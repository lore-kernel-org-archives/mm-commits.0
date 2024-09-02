Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5F7423BE
	for <mm-commits@vger.kernel.org>; Mon,  2 Sep 2024 03:46:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725248806; cv=none; b=LdBvkmV2kUXX0zxypq2/rfW8MddCkF50lU/tbYWyxYhPOBk6wA+tlBhNOoVqfDMjwGKc4Wf34EXtqNNQF0qz39WQAGAyuv+yu7fplTxs3ugcAQNX7gDParECAjB+15ZinEQpd1SqJ9s2qAQTrOYMQTq2G0Nfv7mbsydvW1d+0Sk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725248806; c=relaxed/simple;
	bh=9McFxPPA6PlJbVYB1X9UEax2kJ2K8qdODQZwSJPgySc=;
	h=Date:To:From:Subject:Message-Id; b=e4EURXIDudSsQLGfurnqNzPN2dRhgG7Z1yn5Hr0R287b1MBTrmqdPsSaq1RaSo/t1jcNyhF+1F9WuKOFxI3RN3I48HxbURpttygsCTI9tKnEzyYOrz+NJE0AT5VSzo9h+S7ibY+RMAVFQstGZtk8fULzgRIRywTBYZ60CA8ZKsc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=t0OBzeEe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="t0OBzeEe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA823C4CEC7;
	Mon,  2 Sep 2024 03:46:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1725248806;
	bh=9McFxPPA6PlJbVYB1X9UEax2kJ2K8qdODQZwSJPgySc=;
	h=Date:To:From:Subject:From;
	b=t0OBzeEer8DkhIrVkLtj/gu3USrD88O9Oplz9BlSQTpyIDCKVLLE4MdDNpjUlFoAo
	 63+FjIprkanK/sBT0KSRCAfX4gtowY5rVhB0c3Ign9WIbAkQSpoO2+xc5tDnZgfFmI
	 sLItsxytxP1LWMvmATH+A6EvPbS5VDlJSBVQcCsA=
Date: Sun, 01 Sep 2024 20:46:46 -0700
To: mm-commits@vger.kernel.org,mhocko@suse.com,herbert@gondor.apana.org.au,dave@stgolabs.net,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] lib-rhashtable-cleanup-fallback-check-in-bucket_table_alloc.patch removed from -mm tree
Message-Id: <20240902034646.AA823C4CEC7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: lib/rhashtable: cleanup fallback check in bucket_table_alloc()
has been removed from the -mm tree.  Its filename was
     lib-rhashtable-cleanup-fallback-check-in-bucket_table_alloc.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Davidlohr Bueso <dave@stgolabs.net>
Subject: lib/rhashtable: cleanup fallback check in bucket_table_alloc()
Date: Tue, 6 Aug 2024 08:39:27 -0700

Upon allocation failure, the current check with the nofail bits is
unnecessary, and further stands in the way of discouraging direct use of
__GFP_NOFAIL.  Remove this and replace with the proper way of determining
if doing a non-blocking allocation for the nested table case.

Link: https://lkml.kernel.org/r/20240806153927.184515-1-dave@stgolabs.net
Signed-off-by: Davidlohr Bueso <dave@stgolabs.net>
Suggested-by: Michal Hocko <mhocko@suse.com>
Cc: Davidlohr Bueso <dave@stgolabs.net>
Cc: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/rhashtable.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/lib/rhashtable.c~lib-rhashtable-cleanup-fallback-check-in-bucket_table_alloc
+++ a/lib/rhashtable.c
@@ -189,7 +189,7 @@ static struct bucket_table *bucket_table
 
 	size = nbuckets;
 
-	if (tbl == NULL && (gfp & ~__GFP_NOFAIL) != GFP_KERNEL) {
+	if (tbl == NULL && !gfpflags_allow_blocking(gfp)) {
 		tbl = nested_bucket_table_alloc(ht, nbuckets, gfp);
 		nbuckets = 0;
 	}
_

Patches currently in -mm which might be from dave@stgolabs.net are


