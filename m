Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26C12158DBA
	for <mm-commits@vger.kernel.org>; Tue, 18 Jun 2024 19:36:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718739402; cv=none; b=K6OCDw491BG9Kw4t9rjwTa3gS/x79L9J7mH8hit+ApbD3Bv43mqHp8lVOvXK2oHG24PtHlJk/cdVa2yNluEQeQj+BzMqwl8ZjgR/SWYriAUVNlStDOyXXfCu8PEtpe65653Ms+nqDwRc2xp4xa4qnC0PdhizGSzt+NTxbDeBVzw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718739402; c=relaxed/simple;
	bh=dks/AhpcB2t4gloJC4WNPZPXwNRtEdpZQFy3cSUfARU=;
	h=Date:To:From:Subject:Message-Id; b=lqRzHC9nwnSB7XQ052o/9WyWL1v+mknzTj+/ddxjoH/2gSMpiqJTwt8B8iFRPcnv+XK5ExzG5+NMxw045SefBtD0FE1uJnJA+zUyVzX+uq0Hqdsd6Las+sUcKEtyZSc0d9LSS+pEGOM8pIme+F0hb14t/ZzxdLKkNYFVaEhRM/s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=GkNiNMHG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="GkNiNMHG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9DEE9C3277B;
	Tue, 18 Jun 2024 19:36:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1718739401;
	bh=dks/AhpcB2t4gloJC4WNPZPXwNRtEdpZQFy3cSUfARU=;
	h=Date:To:From:Subject:From;
	b=GkNiNMHGup2FphqiVKIbISPnkxkLVx6vdmFX4gbkgi0tAjOZpYv7wP9BybKpELEHS
	 0V9WBZCKk48fjMky8LON2BUDWmDBcYA62qqm88qhE5Ms1hsY2sN4txnfBAUHFrUr3T
	 64Lrx35bre4oSbY0IYAr7Mmz1mNpa55Z2ssTTBXE=
Date: Tue, 18 Jun 2024 12:36:41 -0700
To: mm-commits@vger.kernel.org,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-damon-sysfs-schemes-rename-_set_schemesscheme_filtersquota_scoreschemes.patch added to mm-unstable branch
Message-Id: <20240618193641.9DEE9C3277B@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/damon/sysfs-schemes: rename *_set_{schemes,scheme_filters,quota_score,schemes}()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-damon-sysfs-schemes-rename-_set_schemesscheme_filtersquota_scoreschemes.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-damon-sysfs-schemes-rename-_set_schemesscheme_filtersquota_scoreschemes.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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

mm-damon-core-implement-damos-quota-goals-online-commit-function.patch
mm-damon-core-implement-damon-context-commit-function.patch
mm-damon-sysfs-use-damon_commit_ctx.patch
mm-damon-sysfs-schemes-use-damos_commit_quota_goals.patch
mm-damon-sysfs-remove-unnecessary-online-tuning-handling-code.patch
mm-damon-sysfs-rename-damon_sysfs_set_targets-to-add_targets.patch
mm-damon-sysfs-schemes-remove-unnecessary-online-tuning-handling-code.patch
mm-damon-sysfs-schemes-rename-_set_schemesscheme_filtersquota_scoreschemes.patch
mm-damon-reclaim-use-damon_commit_ctx.patch
mm-damon-reclaim-remove-unnecessary-code-for-online-tuning.patch
mm-damon-lru_sort-use-damon_commit_ctx.patch
mm-damon-lru_sort-remove-unnecessary-online-tuning-handling-code.patch

