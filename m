Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CBAD53C26
	for <mm-commits@vger.kernel.org>; Sun, 22 Jun 2025 22:52:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750632777; cv=none; b=igpl5WeqsZ8ZmE2Rzyj9oHw/HC80imXOQJEfqz4A1QL8LmUTXglKPucZ7zRg7TbLj2NJWQclmNAef2qicF5U7Tt4bmVSx9nvYY0QJsgAepN6og7a07piwpjAjJ6xSKRsqC8HPfaNTS7J8JdkUoicJvsIfK2EiUStdZEjh3lie0k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750632777; c=relaxed/simple;
	bh=saxmPRBF3WOXASJwLIG7eZVJx0K+qdUIqEBGYd5RiuI=;
	h=Date:To:From:Subject:Message-Id; b=drQSvzCEMDdYPmlq/TUa5kVmWYo8QgwVeFnLlw02QPMFaAMKyIpkE7NN1RMESJstgAjxB+9Wzct2l0TtBmJj/s4ni+OWUvgEGU3ZQSg6lRyWm0yIr715kZeCFth1Ew0JCHf97eb1JTJniyLL7Up4udHnLfINw/oTSJQybYWIkn8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=epvQLM0P; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="epvQLM0P"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 41ADCC4CEE3;
	Sun, 22 Jun 2025 22:52:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1750632777;
	bh=saxmPRBF3WOXASJwLIG7eZVJx0K+qdUIqEBGYd5RiuI=;
	h=Date:To:From:Subject:From;
	b=epvQLM0PUI2gI6GuIGclt8vRzSRyizniJ2y7DtJwVilU3HPWv/Q75oKC/h4VVM2B2
	 gAjQJ6Jk+LRwTZ7mEuSeJS26gteepfoLLLlyZjQ1a/4KSBBKt+7Bc9uQE55bmDZPDB
	 N45Y2tDX/UwnBiTkJ9ez4FV40DHZvmCq8edgk9M4=
Date: Sun, 22 Jun 2025 15:52:56 -0700
To: mm-commits@vger.kernel.org,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-damon-sysfs-schemes-decouple-from-damos_filter_type.patch added to mm-new branch
Message-Id: <20250622225257.41ADCC4CEE3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/damon/sysfs-schemes: decouple from damos_filter_type
has been added to the -mm mm-new branch.  Its filename is
     mm-damon-sysfs-schemes-decouple-from-damos_filter_type.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-damon-sysfs-schemes-decouple-from-damos_filter_type.patch

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
From: SeongJae Park <sj@kernel.org>
Subject: mm/damon/sysfs-schemes: decouple from damos_filter_type
Date: Sun, 22 Jun 2025 14:37:58 -0700

Decouple DAMOS sysfs interface from damos_filter_type.  For this, define
and use new sysfs-schemes internal data structure that maps the user-space
keywords and damos_filter_type, instead of having the implicit and
unflexible array index rule.

Link: https://lkml.kernel.org/r/20250622213759.50930-5-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/sysfs-schemes.c |   75 ++++++++++++++++++++++++++++---------
 1 file changed, 57 insertions(+), 18 deletions(-)

--- a/mm/damon/sysfs-schemes.c~mm-damon-sysfs-schemes-decouple-from-damos_filter_type
+++ a/mm/damon/sysfs-schemes.c
@@ -341,16 +341,45 @@ static struct damon_sysfs_scheme_filter
 	return filter;
 }
 
-/* Should match with enum damos_filter_type */
-static const char * const damon_sysfs_scheme_filter_type_strs[] = {
-	"anon",
-	"active",
-	"memcg",
-	"young",
-	"hugepage_size",
-	"unmapped",
-	"addr",
-	"target",
+struct damos_sysfs_filter_type_name {
+	enum damos_filter_type type;
+	char *name;
+};
+
+static const struct damos_sysfs_filter_type_name
+damos_sysfs_filter_type_names[] = {
+	{
+		.type = DAMOS_FILTER_TYPE_ANON,
+		.name = "anon",
+	},
+	{
+		.type = DAMOS_FILTER_TYPE_ACTIVE,
+		.name = "active",
+	},
+	{
+		.type = DAMOS_FILTER_TYPE_MEMCG,
+		.name = "memcg",
+	},
+	{
+		.type = DAMOS_FILTER_TYPE_YOUNG,
+		.name = "young",
+	},
+	{
+		.type = DAMOS_FILTER_TYPE_HUGEPAGE_SIZE,
+		.name = "hugepage_size",
+	},
+	{
+		.type = DAMOS_FILTER_TYPE_UNMAPPED,
+		.name = "unmapped",
+	},
+	{
+		.type = DAMOS_FILTER_TYPE_ADDR,
+		.name = "addr",
+	},
+	{
+		.type = DAMOS_FILTER_TYPE_TARGET,
+		.name = "target",
+	},
 };
 
 static ssize_t type_show(struct kobject *kobj,
@@ -358,9 +387,16 @@ static ssize_t type_show(struct kobject
 {
 	struct damon_sysfs_scheme_filter *filter = container_of(kobj,
 			struct damon_sysfs_scheme_filter, kobj);
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(damos_sysfs_filter_type_names); i++) {
+		const struct damos_sysfs_filter_type_name *type_name;
 
-	return sysfs_emit(buf, "%s\n",
-			damon_sysfs_scheme_filter_type_strs[filter->type]);
+		type_name = &damos_sysfs_filter_type_names[i];
+		if (type_name->type == filter->type)
+			return sysfs_emit(buf, "%s\n", type_name->name);
+	}
+	return -EINVAL;
 }
 
 static bool damos_sysfs_scheme_filter_valid_type(
@@ -385,16 +421,19 @@ static ssize_t type_store(struct kobject
 {
 	struct damon_sysfs_scheme_filter *filter = container_of(kobj,
 			struct damon_sysfs_scheme_filter, kobj);
-	enum damos_filter_type type;
 	ssize_t ret = -EINVAL;
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(damos_sysfs_filter_type_names); i++) {
+		const struct damos_sysfs_filter_type_name *type_name;
 
-	for (type = 0; type < NR_DAMOS_FILTER_TYPES; type++) {
-		if (sysfs_streq(buf, damon_sysfs_scheme_filter_type_strs[
-					type])) {
+		type_name = &damos_sysfs_filter_type_names[i];
+		if (sysfs_streq(buf, type_name->name)) {
 			if (!damos_sysfs_scheme_filter_valid_type(
-						filter->handle_layer, type))
+						filter->handle_layer,
+						type_name->type))
 				break;
-			filter->type = type;
+			filter->type = type_name->type;
 			ret = count;
 			break;
 		}
_

Patches currently in -mm which might be from sj@kernel.org are

mm-damon-sysfs-schemes-free-old-damon_sysfs_scheme_filter-memcg_path-on-write.patch
mm-damon-introduce-damon_stat-module.patch
mm-damon-introduce-damon_stat-module-fix.patch
mm-damon-stat-calculate-and-expose-estimated-memory-bandwidth.patch
mm-damon-stat-calculate-and-expose-idle-time-percentiles.patch
docs-admin-guide-mm-damon-add-damon_stat-usage-document.patch
mm-damon-paddr-use-alloc_migartion_target-with-no-migration-fallback-nodemask.patch
revert-mm-rename-alloc_demote_folio-to-alloc_migrate_folio.patch
revert-mm-make-alloc_demote_folio-externally-invokable-for-migration.patch
selftets-damon-add-a-test-for-memcg_path-leak.patch
mm-damon-sysfs-schemes-decouple-from-damos_quota_goal_metric.patch
mm-damon-sysfs-schemes-decouple-from-damos_action.patch
mm-damon-sysfs-schemes-decouple-from-damos_wmark_metric.patch
mm-damon-sysfs-schemes-decouple-from-damos_filter_type.patch
mm-damon-sysfs-decouple-from-damon_ops_id.patch

