Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C562143748
	for <mm-commits@vger.kernel.org>; Thu,  7 Aug 2025 03:34:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754537682; cv=none; b=ErPTwNTIFSe7XeKo9L1OcW+7rHh7dpjK4c4qhR6yTCs17YoXfMMd698iW8PpgA0AujYwb60jpH93qqTDUuxduZlyqD/V3+xE4ah/6rLVbaJLsPxG5yzUfGtQI/clljUrvRy78h6FsHCwKTRJ3iEIgA+AitXJIHu62fOrYNyA/E8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754537682; c=relaxed/simple;
	bh=7m4+8J2PiQK5714MsUTGyytZenam6Iz2dQ6LMbsVFoA=;
	h=Date:To:From:Subject:Message-Id; b=qqEko8TXZjd1HEK4WYUQGPzuNM1TMUILeKxE9Ucqa/dPlMCi7fLXDgFRkzMg7Pte+X+XUDMve63KBW1AE/Zi+kYueDtlqXmZ1DioCukUGX81NtN6lyqjydMrZfIt89OZTMNwLh+c7Gg0GaePYvYV5RX2Ai+oBw/nBYUH6l2km04=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=oyX3F6Mj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="oyX3F6Mj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE0C9C4CEEB;
	Thu,  7 Aug 2025 03:34:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1754537681;
	bh=7m4+8J2PiQK5714MsUTGyytZenam6Iz2dQ6LMbsVFoA=;
	h=Date:To:From:Subject:From;
	b=oyX3F6MjUVwke8uWqN0sFdr0LhtTW0ZiUbuc2Q1iANnYhhEORwjVluv3dJqAOobTf
	 6E4c6lawXxi8DjDTmgL599sNTu2auUuvwmdVS/p0jBpOK1PtxgPKKhQl3KFM9wUODL
	 epb9W/HK42mbR+QtyQOfQj82tentLWoZYyeizuME=
Date: Wed, 06 Aug 2025 20:34:41 -0700
To: mm-commits@vger.kernel.org,sj@kernel.org,bijan311@gmail.com,bijantabatab@micron.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-damon-core-skip-needless-update-of-damon_attrs-in-damon_commit_ctx.patch added to mm-new branch
Message-Id: <20250807033441.BE0C9C4CEEB@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/damon/core: skip needless update of damon_attrs in damon_commit_ctx()
has been added to the -mm mm-new branch.  Its filename is
     mm-damon-core-skip-needless-update-of-damon_attrs-in-damon_commit_ctx.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-damon-core-skip-needless-update-of-damon_attrs-in-damon_commit_ctx.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

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
From: Bijan Tabatabai <bijantabatab@micron.com>
Subject: mm/damon/core: skip needless update of damon_attrs in damon_commit_ctx()
Date: Wed, 6 Aug 2025 18:42:54 -0500

Currently, damon_commit_ctx() always calls damon_set_attrs() even if the
attributes have not been changed.  This can be problematic when the DAMON
state is committed relatively frequently because damon_set_attrs() resets
ctx->next_{aggregation,ops_update}_sis, causing aggregation and ops update
operations to be needlessly delayed.

This patch avoids this by only calling damon_set_attrs() in
damon_commit_ctx when the attributes have been changed.

Link: https://lkml.kernel.org/r/20250806234254.10572-1-bijan311@gmail.com
Signed-off-by: Bijan Tabatabai <bijantabatab@micron.com>
Reviewed-by: SeongJae Park <sj@kernel.org>
Cc: Bijan Tabatabai <bijan311@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/core.c |   26 +++++++++++++++++++++++---
 1 file changed, 23 insertions(+), 3 deletions(-)

--- a/mm/damon/core.c~mm-damon-core-skip-needless-update-of-damon_attrs-in-damon_commit_ctx
+++ a/mm/damon/core.c
@@ -570,6 +570,24 @@ void damon_destroy_ctx(struct damon_ctx
 	kfree(ctx);
 }
 
+static bool damon_attrs_equals(const struct damon_attrs *attrs1,
+		const struct damon_attrs *attrs2)
+{
+	const struct damon_intervals_goal *ig1 = &attrs1->intervals_goal;
+	const struct damon_intervals_goal *ig2 = &attrs2->intervals_goal;
+
+	return attrs1->sample_interval == attrs2->sample_interval &&
+		attrs1->aggr_interval == attrs2->aggr_interval &&
+		attrs1->ops_update_interval == attrs2->ops_update_interval &&
+		attrs1->min_nr_regions == attrs2->min_nr_regions &&
+		attrs1->max_nr_regions == attrs2->max_nr_regions &&
+		ig1->access_bp == ig2->access_bp &&
+		ig1->aggrs == ig2->aggrs &&
+		ig1->min_sample_us == ig2->min_sample_us &&
+		ig1->max_sample_us == ig2->max_sample_us;
+
+}
+
 static unsigned int damon_age_for_new_attrs(unsigned int age,
 		struct damon_attrs *old_attrs, struct damon_attrs *new_attrs)
 {
@@ -1209,9 +1227,11 @@ int damon_commit_ctx(struct damon_ctx *d
 	 * 2. ops update should be done after pid handling is done (target
 	 *    committing require putting pids).
 	 */
-	err = damon_set_attrs(dst, &src->attrs);
-	if (err)
-		return err;
+	if (!damon_attrs_equals(&dst->attrs, &src->attrs)) {
+		err = damon_set_attrs(dst, &src->attrs);
+		if (err)
+			return err;
+	}
 	dst->ops = src->ops;
 
 	return 0;
_

Patches currently in -mm which might be from bijantabatab@micron.com are

mm-damon-core-skip-needless-update-of-damon_attrs-in-damon_commit_ctx.patch

