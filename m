Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6433208CA
	for <mm-commits@vger.kernel.org>; Sun, 20 Jul 2025 02:01:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752976895; cv=none; b=tyhsrnl1Ob9YpuFK3uyQwxDPYK8XhXw01ZDvaMzo2v0PofOBsBfqi77SZKGx/SXjyyKdjZ+T4XR8r3kkeAbJxBrWmz5Xn4U7H/3ov91obiw+aiM/yjfXDEgHTFz7RRiwfQrA8CWC3+5/2uazZCOpyjtTn67n4O8gYQSt7Pod2Bw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752976895; c=relaxed/simple;
	bh=HgUh6WYCzGvr1gknroa2qfeWYHlEzhzl25xbq/MBoxc=;
	h=Date:To:From:Subject:Message-Id; b=sz30E6muIMBl6B7lUMcjJOyvgxsBk1D/dYfDtCfSZgSVSorSVsaj5BE4+btkffUKfn4MpGwa+lNBcpGD08ad//aXDz/svaxrifZmFfxc3Cx5lHUwzYoX2wXQUFHoS4OCbU4lUnl0KV+J27qm80ojib3au21Ii84g3kB80KVdQSE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=TTCERl5q; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="TTCERl5q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ABC8AC4CEE3;
	Sun, 20 Jul 2025 02:01:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1752976895;
	bh=HgUh6WYCzGvr1gknroa2qfeWYHlEzhzl25xbq/MBoxc=;
	h=Date:To:From:Subject:From;
	b=TTCERl5qXh5C+21JEglmh+yvSkyq0us7m0Xmo3eRaS0rlD+JvZdcD2V3Ndy/tlCO7
	 XJOGlukszezVjsw93a/aIbUw0VNpjpRLPZ0hLaKnv29sFnitQrMifnqdzTUa/tuAHM
	 l0SgHAZyYgE3J+EqD/wQkd433BpGkpqZjIxkq7nE=
Date: Sat, 19 Jul 2025 19:01:35 -0700
To: mm-commits@vger.kernel.org,ravis.opensrc@micron.com,corbet@lwn.net,bijantabatab@micron.com,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-damon-core-add-damos-migrate_dests-field.patch removed from -mm tree
Message-Id: <20250720020135.ABC8AC4CEE3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/damon/core: add damos->migrate_dests field
has been removed from the -mm tree.  Its filename was
     mm-damon-core-add-damos-migrate_dests-field.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: mm/damon/core: add damos->migrate_dests field
Date: Tue, 8 Jul 2025 19:59:32 -0500

Add a new field to 'struct damos', namely migrate_dests, to allow DAMON
API callers specify multiple migration destination nodes and their
weights.  Also update 'struct damos' creation and destruction functions
accordingly to initialize the new field and free up the API
caller-allocated buffers on those, respectively.

Link: https://lkml.kernel.org/r/20250709005952.17776-3-bijan311@gmail.com
Signed-off-by: SeongJae Park <sj@kernel.org>
Signed-off-by: Bijan Tabatabai <bijantabatab@micron.com>
Reviewed-by: SeongJae Park <sj@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Ravi Shankar Jonnalagadda <ravis.opensrc@micron.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/damon.h |   13 ++++++++++---
 mm/damon/core.c       |    4 ++++
 2 files changed, 14 insertions(+), 3 deletions(-)

--- a/include/linux/damon.h~mm-damon-core-add-damos-migrate_dests-field
+++ a/include/linux/damon.h
@@ -470,6 +470,7 @@ struct damos_migrate_dests {
  * @apply_interval_us:	The time between applying the @action.
  * @quota:		Control the aggressiveness of this scheme.
  * @wmarks:		Watermarks for automated (in)activation of this scheme.
+ * @migrate_dests:	Destination nodes if @action is "migrate_{hot,cold}".
  * @target_nid:		Destination node if @action is "migrate_{hot,cold}".
  * @filters:		Additional set of &struct damos_filter for &action.
  * @ops_filters:	ops layer handling &struct damos_filter objects list.
@@ -488,9 +489,12 @@ struct damos_migrate_dests {
  * monitoring context are inactive, DAMON stops monitoring either, and just
  * repeatedly checks the watermarks.
  *
+ * @migrate_dests specifies multiple migration target nodes with different
+ * weights for migrate_hot or migrate_cold actions.  @target_nid is ignored if
+ * this is set.
+ *
  * @target_nid is used to set the migration target node for migrate_hot or
- * migrate_cold actions, which means it's only meaningful when @action is either
- * "migrate_hot" or "migrate_cold".
+ * migrate_cold actions, and @migrate_dests is unset.
  *
  * Before applying the &action to a memory region, &struct damon_operations
  * implementation could check pages of the region and skip &action to respect
@@ -533,7 +537,10 @@ struct damos {
 	struct damos_quota quota;
 	struct damos_watermarks wmarks;
 	union {
-		int target_nid;
+		struct {
+			int target_nid;
+			struct damos_migrate_dests migrate_dests;
+		};
 	};
 	struct list_head filters;
 	struct list_head ops_filters;
--- a/mm/damon/core.c~mm-damon-core-add-damos-migrate_dests-field
+++ a/mm/damon/core.c
@@ -407,6 +407,7 @@ struct damos *damon_new_scheme(struct da
 	scheme->wmarks = *wmarks;
 	scheme->wmarks.activated = true;
 
+	scheme->migrate_dests = (struct damos_migrate_dests){};
 	scheme->target_nid = target_nid;
 
 	return scheme;
@@ -449,6 +450,9 @@ void damon_destroy_scheme(struct damos *
 
 	damos_for_each_filter_safe(f, next, s)
 		damos_destroy_filter(f);
+
+	kfree(s->migrate_dests.node_id_arr);
+	kfree(s->migrate_dests.weight_arr);
 	damon_del_scheme(s);
 	damon_free_scheme(s);
 }
_

Patches currently in -mm which might be from sj@kernel.org are

mm-damon-core-commit-damos_quota_goal-nid.patch
mm-damon-sysfs-implement-refresh_ms-file-under-kdamond-directory.patch
mm-damon-sysfs-implement-refresh_ms-file-internal-work.patch
docs-admin-guide-mm-damon-usage-document-refresh_ms-file.patch
docs-abi-damon-update-for-refresh_ms.patch

