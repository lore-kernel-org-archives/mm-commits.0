Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 601FF3C26
	for <mm-commits@vger.kernel.org>; Sun, 22 Jun 2025 22:52:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750632779; cv=none; b=or3Yq6KvvU/BrdErCbuYwTZPpGzNzHeP2Eu3JnSuTuW+ufJg2ZIDetbkAeBPhQ9pDm80aUiR0GOkjzLb3HfFzUi5yBZqvHD885xNCDf/kYWQHeM2Gl+F2/gydWfogrBG64Dwb+f0f5lyQ9njEu/UoJIDV0vBA3+1P2QczNRZu/8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750632779; c=relaxed/simple;
	bh=L+VVKNerFPa0hU3vvSt11tLV/qRKw6kCqITKMDf6vyI=;
	h=Date:To:From:Subject:Message-Id; b=hKN+SIkvltCONZG2pBG/8KWpZwjRhKzcr+/7z3PSdxZE80swGD2KcXYpZaOGsF2BRILkngDAkJHEfWYq3pFipM2BQYgp0dSttn0HsO67EWd65gpeGRJDzTgVRVHNNyibf7zoWMtvWnul/77ef+fHFuoXh9vLtu1FdDldRriNZPA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=UKlof+3S; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="UKlof+3S"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3281AC4CEE3;
	Sun, 22 Jun 2025 22:52:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1750632779;
	bh=L+VVKNerFPa0hU3vvSt11tLV/qRKw6kCqITKMDf6vyI=;
	h=Date:To:From:Subject:From;
	b=UKlof+3SnX00tbJDUzfzR9pQ62DGlLAIbc/zMWKtNVQpxv4liCS6K86iNvB/I8oKz
	 w/fKKVLHjOoFyi3XgJV4E1USzj429xlxgWKk25hnuEaFwaDiTo7FzUwtAdM8fXnkwG
	 B3Qtbn/4kC5WhZeE16Wkd1knKaeZ6AXjYh45/5Uw=
Date: Sun, 22 Jun 2025 15:52:58 -0700
To: mm-commits@vger.kernel.org,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-damon-sysfs-decouple-from-damon_ops_id.patch added to mm-new branch
Message-Id: <20250622225259.3281AC4CEE3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/damon/sysfs: decouple from damon_ops_id
has been added to the -mm mm-new branch.  Its filename is
     mm-damon-sysfs-decouple-from-damon_ops_id.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-damon-sysfs-decouple-from-damon_ops_id.patch

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
Subject: mm/damon/sysfs: decouple from damon_ops_id
Date: Sun, 22 Jun 2025 14:37:59 -0700

Decouple DAMON sysfs interface from damon_ops_id.  For this, define and
use new mm/damon/sysfs.c internal data structure that maps the user-space
keywords and damon_ops_id, instead of having the implicit and unflexible
array index rule.

Link: https://lkml.kernel.org/r/20250622213759.50930-6-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/sysfs.c |   56 ++++++++++++++++++++++++++++++++-------------
 1 file changed, 41 insertions(+), 15 deletions(-)

--- a/mm/damon/sysfs.c~mm-damon-sysfs-decouple-from-damon_ops_id
+++ a/mm/damon/sysfs.c
@@ -811,11 +811,24 @@ static const struct kobj_type damon_sysf
  * context directory
  */
 
-/* This should match with enum damon_ops_id */
-static const char * const damon_sysfs_ops_strs[] = {
-	"vaddr",
-	"fvaddr",
-	"paddr",
+struct damon_sysfs_ops_name {
+	enum damon_ops_id ops_id;
+	char *name;
+};
+
+static const struct damon_sysfs_ops_name damon_sysfs_ops_names[] = {
+	{
+		.ops_id = DAMON_OPS_VADDR,
+		.name = "vaddr",
+	},
+	{
+		.ops_id = DAMON_OPS_FVADDR,
+		.name = "fvaddr",
+	},
+	{
+		.ops_id = DAMON_OPS_PADDR,
+		.name = "paddr",
+	},
 };
 
 struct damon_sysfs_context {
@@ -934,14 +947,16 @@ static void damon_sysfs_context_rm_dirs(
 static ssize_t avail_operations_show(struct kobject *kobj,
 		struct kobj_attribute *attr, char *buf)
 {
-	enum damon_ops_id id;
 	int len = 0;
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(damon_sysfs_ops_names); i++) {
+		const struct damon_sysfs_ops_name *ops_name;
 
-	for (id = 0; id < NR_DAMON_OPS; id++) {
-		if (!damon_is_registered_ops(id))
+		ops_name = &damon_sysfs_ops_names[i];
+		if (!damon_is_registered_ops(ops_name->ops_id))
 			continue;
-		len += sysfs_emit_at(buf, len, "%s\n",
-				damon_sysfs_ops_strs[id]);
+		len += sysfs_emit_at(buf, len, "%s\n", ops_name->name);
 	}
 	return len;
 }
@@ -951,8 +966,16 @@ static ssize_t operations_show(struct ko
 {
 	struct damon_sysfs_context *context = container_of(kobj,
 			struct damon_sysfs_context, kobj);
+	int i;
 
-	return sysfs_emit(buf, "%s\n", damon_sysfs_ops_strs[context->ops_id]);
+	for (i = 0; i < ARRAY_SIZE(damon_sysfs_ops_names); i++) {
+		const struct damon_sysfs_ops_name *ops_name;
+
+		ops_name = &damon_sysfs_ops_names[i];
+		if (ops_name->ops_id == context->ops_id)
+			return sysfs_emit(buf, "%s\n", ops_name->name);
+	}
+	return -EINVAL;
 }
 
 static ssize_t operations_store(struct kobject *kobj,
@@ -960,11 +983,14 @@ static ssize_t operations_store(struct k
 {
 	struct damon_sysfs_context *context = container_of(kobj,
 			struct damon_sysfs_context, kobj);
-	enum damon_ops_id id;
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(damon_sysfs_ops_names); i++) {
+		const struct damon_sysfs_ops_name *ops_name;
 
-	for (id = 0; id < NR_DAMON_OPS; id++) {
-		if (sysfs_streq(buf, damon_sysfs_ops_strs[id])) {
-			context->ops_id = id;
+		ops_name = &damon_sysfs_ops_names[i];
+		if (sysfs_streq(buf, ops_name->name)) {
+			context->ops_id = ops_name->ops_id;
 			return count;
 		}
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

