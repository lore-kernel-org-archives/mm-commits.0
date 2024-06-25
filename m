Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0B9F748F
	for <mm-commits@vger.kernel.org>; Tue, 25 Jun 2024 05:02:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719291741; cv=none; b=qL79iK1g8zLKrxir0IqrnD9QIp+4eRgDI4RMBZSlr211XjIbq0Ew+lbo6IeSp1AxzQhil0ypxEFegfE9llzOOodmUTP4nYlHaTftjn7VAR8L1dP7uhyKA4csGs5oQqQUNmkJsaCOxNrKOLaokQ19fjtqHNUPWaTq6x0OwIctvWo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719291741; c=relaxed/simple;
	bh=SaYGldQd+3wCn0oRtoAclbI0AF6dQqTq9HXPK+AW31o=;
	h=Date:To:From:Subject:Message-Id; b=dFokoXTmAvxLZIbRBKKPj/UmhZ0DdTS3+noMr4qNVxt6EmLa/mE9ELScd258IFUC0YUI6Zwd6yo5092g8+kt5xBzejYfU6GhREJUl0U8hu0yDeZeYIUPdQWB2p6sj95K8p43yd/mn2m7a6+XgHA6JkhWHswTfZ92YN4ySJ8hLxE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=FeiYGpY1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="FeiYGpY1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 75BF8C32789;
	Tue, 25 Jun 2024 05:02:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1719291741;
	bh=SaYGldQd+3wCn0oRtoAclbI0AF6dQqTq9HXPK+AW31o=;
	h=Date:To:From:Subject:From;
	b=FeiYGpY1WgxTt2tji/321hViUCISnCC40ikm0QYNaEoW9gZrSu4MtLmdJLhLh7nE3
	 FcvHvVlqOHir9nXesMVuCW4VZRTDBM/6WyJNhCVGscYqs5EWl81/s0QEJp0UE27Ijd
	 bFsfDCmyOQO7bJR1AgD04NR3TtQCp1XnQ1DMRbxM=
Date: Mon, 24 Jun 2024 22:02:20 -0700
To: mm-commits@vger.kernel.org,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-damon-sysfs-schemes-rename-_set_schemesscheme_filtersquota_scoreschemes.patch removed from -mm tree
Message-Id: <20240625050221.75BF8C32789@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/damon/sysfs-schemes: rename *_set_{schemes,scheme_filters,quota_score,schemes}()
has been removed from the -mm tree.  Its filename was
     mm-damon-sysfs-schemes-rename-_set_schemesscheme_filtersquota_scoreschemes.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: mm/damon/sysfs-schemes: rename *_set_{schemes,scheme_filters,quota_score,schemes}()
Date: Tue, 18 Jun 2024 11:18:05 -0700

The functions were for updating DAMON structs that may or may not be
partially populated.  Hence it was not for only adding items, but also
removing unnecessary items and updating items in-place.  A previous commit
has changed the functions to assume the structs are not partially
populated, and do only adding items.  Make the names better explain the
behavior.

Link: https://lkml.kernel.org/r/20240618181809.82078-9-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/sysfs-common.h  |    2 +-
 mm/damon/sysfs-schemes.c |   12 ++++++------
 mm/damon/sysfs.c         |    2 +-
 3 files changed, 8 insertions(+), 8 deletions(-)

--- a/mm/damon/sysfs.c~mm-damon-sysfs-schemes-rename-_set_schemesscheme_filtersquota_scoreschemes
+++ a/mm/damon/sysfs.c
@@ -1286,7 +1286,7 @@ static int damon_sysfs_apply_inputs(stru
 	err = damon_sysfs_add_targets(ctx, sys_ctx->targets);
 	if (err)
 		return err;
-	return damon_sysfs_set_schemes(ctx, sys_ctx->schemes);
+	return damon_sysfs_add_schemes(ctx, sys_ctx->schemes);
 }
 
 static struct damon_ctx *damon_sysfs_build_ctx(
--- a/mm/damon/sysfs-common.h~mm-damon-sysfs-schemes-rename-_set_schemesscheme_filtersquota_scoreschemes
+++ a/mm/damon/sysfs-common.h
@@ -38,7 +38,7 @@ void damon_sysfs_schemes_rm_dirs(struct
 
 extern const struct kobj_type damon_sysfs_schemes_ktype;
 
-int damon_sysfs_set_schemes(struct damon_ctx *ctx,
+int damon_sysfs_add_schemes(struct damon_ctx *ctx,
 		struct damon_sysfs_schemes *sysfs_schemes);
 
 void damon_sysfs_schemes_update_stats(
--- a/mm/damon/sysfs-schemes.c~mm-damon-sysfs-schemes-rename-_set_schemesscheme_filtersquota_scoreschemes
+++ a/mm/damon/sysfs-schemes.c
@@ -1908,7 +1908,7 @@ static int damon_sysfs_memcg_path_to_id(
 	return found ? 0 : -EINVAL;
 }
 
-static int damon_sysfs_set_scheme_filters(struct damos *scheme,
+static int damon_sysfs_add_scheme_filters(struct damos *scheme,
 		struct damon_sysfs_scheme_filters *sysfs_filters)
 {
 	int i;
@@ -1947,7 +1947,7 @@ static int damon_sysfs_set_scheme_filter
 	return 0;
 }
 
-static int damos_sysfs_set_quota_score(
+static int damos_sysfs_add_quota_score(
 		struct damos_sysfs_quota_goals *sysfs_goals,
 		struct damos_quota *quota)
 {
@@ -1990,7 +1990,7 @@ int damos_sysfs_set_quota_scores(struct
 			break;
 
 		sysfs_scheme = sysfs_schemes->schemes_arr[i];
-		err = damos_sysfs_set_quota_score(sysfs_scheme->quotas->goals,
+		err = damos_sysfs_add_quota_score(sysfs_scheme->quotas->goals,
 				&quota);
 		if (err) {
 			damos_for_each_quota_goal_safe(g, g_next, &quota)
@@ -2070,13 +2070,13 @@ static struct damos *damon_sysfs_mk_sche
 	if (!scheme)
 		return NULL;
 
-	err = damos_sysfs_set_quota_score(sysfs_quotas->goals, &scheme->quota);
+	err = damos_sysfs_add_quota_score(sysfs_quotas->goals, &scheme->quota);
 	if (err) {
 		damon_destroy_scheme(scheme);
 		return NULL;
 	}
 
-	err = damon_sysfs_set_scheme_filters(scheme, sysfs_filters);
+	err = damon_sysfs_add_scheme_filters(scheme, sysfs_filters);
 	if (err) {
 		damon_destroy_scheme(scheme);
 		return NULL;
@@ -2084,7 +2084,7 @@ static struct damos *damon_sysfs_mk_sche
 	return scheme;
 }
 
-int damon_sysfs_set_schemes(struct damon_ctx *ctx,
+int damon_sysfs_add_schemes(struct damon_ctx *ctx,
 		struct damon_sysfs_schemes *sysfs_schemes)
 {
 	int i;
_

Patches currently in -mm which might be from sj@kernel.org are

mm-damon-core-merge-regions-aggressively-when-max_nr_regions-is-unmet.patch
docs-mm-damon-maintainer-profile-introduce-hackermail.patch
docs-mm-damon-maintainer-profile-document-damon-community-meetups.patch

