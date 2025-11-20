Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 669BE1C84A6
	for <mm-commits@vger.kernel.org>; Thu, 20 Nov 2025 21:45:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763675113; cv=none; b=jn0qsQeyzhE7tILOy2jbBH8bJQl8Qm/OVg/tmFHmhiI4SJRVrI8YDjOQrnM9uSijeaSAmvnCl6C9yj76tZTlT1wt1YhTk+8Ub3IitdLeXsCe3h0o5jhTUFsFyK9v7l9vK28K5B9scr14I4XX95srWq/PJevcoYzjDthlcE6hnqU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763675113; c=relaxed/simple;
	bh=RLS2hZQAbX42Pag6uoaHs5wweFYzs5Y2Rqtc0CBDq6I=;
	h=Date:To:From:Subject:Message-Id; b=u4y3apoANJDUJnR0SU97Muk9DOMX7JFHqzmrBXwW0rJfOrkFxJF6H5EWrb7Yr/vZ34Wbt57mRJ9t8UHRVKiWgDECGlSHUfrjwUhGA5lQs0n8E7lxqiuKPEGGYJ2xC1389iORnV1vWGmL74YgND8RJTeVJo9Hefd1xCjTAqshfGo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Hz3dCzWg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Hz3dCzWg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B2C9C4CEF1;
	Thu, 20 Nov 2025 21:45:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1763675113;
	bh=RLS2hZQAbX42Pag6uoaHs5wweFYzs5Y2Rqtc0CBDq6I=;
	h=Date:To:From:Subject:From;
	b=Hz3dCzWgjR++baZGRewJRXBzbWjpSMOhZ8Inu17pc//gQi3ToGT69fc5ZA0XXcY89
	 lrY/ZuvM9alhVlfUds8PADmvxVCjfC1KV0K0C1xam3R2Cu6CUs6BjT8vTVL4EPptH3
	 peY2/kh+XZp8mdAslVsBAhhRseMP6byB6S2Ul7ME=
Date: Thu, 20 Nov 2025 13:45:12 -0800
To: mm-commits@vger.kernel.org,davidgow@google.com,brendan.higgins@linux.dev,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-damon-core-pass-migrate_dests-to-damos_commit_dests.patch removed from -mm tree
Message-Id: <20251120214513.3B2C9C4CEF1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/damon/core: pass migrate_dests to damos_commit_dests()
has been removed from the -mm tree.  Its filename was
     mm-damon-core-pass-migrate_dests-to-damos_commit_dests.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: mm/damon/core: pass migrate_dests to damos_commit_dests()
Date: Tue, 11 Nov 2025 10:44:07 -0800

damos_commit_dests() receives 'struct damos' pointers, while it uses only
their ->migrate_dests fields.  This makes code unnecessarily difficult to
read.  It also makes unit tests writing complicated.  Refactor the
function to receive pointers to the ->migrate_dests fields.

Link: https://lkml.kernel.org/r/20251111184415.141757-9-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Brendan Higgins <brendan.higgins@linux.dev>
Cc: David Gow <davidgow@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/core.c |   40 ++++++++++++++++++----------------------
 1 file changed, 18 insertions(+), 22 deletions(-)

--- a/mm/damon/core.c~mm-damon-core-pass-migrate_dests-to-damos_commit_dests
+++ a/mm/damon/core.c
@@ -1000,36 +1000,32 @@ static void damos_set_filters_default_re
 		damos_filters_default_reject(&s->ops_filters);
 }
 
-static int damos_commit_dests(struct damos *dst, struct damos *src)
+static int damos_commit_dests(struct damos_migrate_dests *dst,
+		struct damos_migrate_dests *src)
 {
-	struct damos_migrate_dests *dst_dests, *src_dests;
-
-	dst_dests = &dst->migrate_dests;
-	src_dests = &src->migrate_dests;
-
-	if (dst_dests->nr_dests != src_dests->nr_dests) {
-		kfree(dst_dests->node_id_arr);
-		kfree(dst_dests->weight_arr);
-
-		dst_dests->node_id_arr = kmalloc_array(src_dests->nr_dests,
-			sizeof(*dst_dests->node_id_arr), GFP_KERNEL);
-		if (!dst_dests->node_id_arr) {
-			dst_dests->weight_arr = NULL;
+	if (dst->nr_dests != src->nr_dests) {
+		kfree(dst->node_id_arr);
+		kfree(dst->weight_arr);
+
+		dst->node_id_arr = kmalloc_array(src->nr_dests,
+			sizeof(*dst->node_id_arr), GFP_KERNEL);
+		if (!dst->node_id_arr) {
+			dst->weight_arr = NULL;
 			return -ENOMEM;
 		}
 
-		dst_dests->weight_arr = kmalloc_array(src_dests->nr_dests,
-			sizeof(*dst_dests->weight_arr), GFP_KERNEL);
-		if (!dst_dests->weight_arr) {
+		dst->weight_arr = kmalloc_array(src->nr_dests,
+			sizeof(*dst->weight_arr), GFP_KERNEL);
+		if (!dst->weight_arr) {
 			/* ->node_id_arr will be freed by scheme destruction */
 			return -ENOMEM;
 		}
 	}
 
-	dst_dests->nr_dests = src_dests->nr_dests;
-	for (int i = 0; i < src_dests->nr_dests; i++) {
-		dst_dests->node_id_arr[i] = src_dests->node_id_arr[i];
-		dst_dests->weight_arr[i] = src_dests->weight_arr[i];
+	dst->nr_dests = src->nr_dests;
+	for (int i = 0; i < src->nr_dests; i++) {
+		dst->node_id_arr[i] = src->node_id_arr[i];
+		dst->weight_arr[i] = src->weight_arr[i];
 	}
 
 	return 0;
@@ -1076,7 +1072,7 @@ static int damos_commit(struct damos *ds
 	dst->wmarks = src->wmarks;
 	dst->target_nid = src->target_nid;
 
-	err = damos_commit_dests(dst, src);
+	err = damos_commit_dests(&dst->migrate_dests, &src->migrate_dests);
 	if (err)
 		return err;
 
_

Patches currently in -mm which might be from sj@kernel.org are


