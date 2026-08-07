Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0D953B6363
	for <mm-commits@vger.kernel.org>; Fri,  7 Aug 2026 02:01:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786068072; cv=none; b=U5ix6vi082vdYosoSM2d+MhI9DqbsD9bKtnFbrb8oVlTOIy8i/wgvIUPhV9+/nMTsxCGdrXrmz4RZoOf5YrFNRFEyvkU0pZ1PIroZSdYrOlNoQ/Qc6KtRSfARssdFflmDHmxIPv9ubl15YsCkIpttqq+jLyxAnmvleLR26DnWkw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786068072; c=relaxed/simple;
	bh=KXYjsY3zoEnhO9CNJObHcmykcyZ0gr+MmBrPsXxq1xA=;
	h=Date:To:From:Subject:Message-Id; b=CfCRxUjF3N9NOyVUeo3rtL4/YV4RagD6V6V+KKdG5taCbsH6TrXhzthbqNUGHdQbH37zLfssW2mTeeeP0yXCZVnnhRyJ7bS7TgKwn0s6327EX3Qaqc+N8KT6J4wIkhTZSxD6/pHOgD1QfVmV/7S0jn37oi2A7YD2kpPNVWRDupc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=wyZbXBSk; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="wyZbXBSk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D6F7E1F00A3E;
	Fri,  7 Aug 2026 02:01:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1786068068;
	bh=HsAEfHRJqaaJ5CAAQBc4MS39CwTf7oMmND5H7WjT9LE=;
	h=Date:To:From:Subject;
	b=wyZbXBSkzL6TfUNQsV0qktABQpXleqszkOa0NtOrXyCE9YkrEijLNB5J8sEswWbSq
	 teqnpQDRrVILVVLrhCip02NvLNIHU63+3utY/30DK1TyAjcV8ik0ezX8wnizm6z7BX
	 4DJAYbgATe/7AfuZGHh4ZE/PtQS3OA4xcTCVw1H0=
Date: Thu, 06 Aug 2026 19:01:07 -0700
To: mm-commits@vger.kernel.org,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-damon-core-hide-private-damos-fields.patch removed from -mm tree
Message-Id: <20260807020107.D6F7E1F00A3E@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/damon/core: hide private damos fields
has been removed from the -mm tree.  Its filename was
     mm-damon-core-hide-private-damos-fields.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SJ Park <sj@kernel.org>
Subject: mm/damon/core: hide private damos fields
Date: Tue, 14 Jul 2026 07:35:39 -0700

'core_filters', 'ops_filters', 'last_applied' and 'list' fields of damos
are intended to be used by only the DAMON core layer.  However, those are
mistakenly not marked as private.  Mark as private.

Link: https://lore.kernel.org/20260714143544.101305-7-sj@kernel.org
Signed-off-by: SJ Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/damon.h |   52 ++++++++++++++++++++--------------------
 1 file changed, 27 insertions(+), 25 deletions(-)

--- a/include/linux/damon.h~mm-damon-core-hide-private-damos-fields
+++ a/include/linux/damon.h
@@ -522,12 +522,8 @@ struct damos_migrate_dests {
  * @wmarks:		Watermarks for automated (in)activation of this scheme.
  * @migrate_dests:	Destination nodes if @action is "migrate_{hot,cold}".
  * @target_nid:		Destination node if @action is "migrate_{hot,cold}".
- * @core_filters:	Additional set of &struct damos_filter for &action.
- * @ops_filters:	ops layer handling &struct damos_filter objects list.
- * @last_applied:	Last @action applied ops-managing entity.
  * @stat:		Statistics of this scheme.
  * @max_nr_snapshots:	Upper limit of nr_snapshots stat.
- * @list:		List head for siblings.
  *
  * For each @apply_interval_us, DAMON finds regions which fit in the
  * &pattern and applies &action to those. To avoid consuming too much
@@ -549,16 +545,7 @@ struct damos_migrate_dests {
  *
  * Before applying the &action to a memory region, &struct damon_operations
  * implementation could check pages of the region and skip &action to respect
- * &core_filters
- *
- * The minimum entity that @action can be applied depends on the underlying
- * &struct damon_operations.  Since it may not be aligned with the core layer
- * abstract, namely &struct damon_region, &struct damon_operations could apply
- * @action to same entity multiple times.  Large folios that underlying on
- * multiple &struct damon region objects could be such examples.  The &struct
- * damon_operations can use @last_applied to avoid that.  DAMOS core logic
- * unsets @last_applied when each regions walking for applying the scheme is
- * finished.
+ * &struct damos_filter.
  *
  * After applying the &action to each region, &stat is updated.
  *
@@ -569,6 +556,16 @@ struct damos {
 	struct damos_access_pattern pattern;
 	enum damos_action action;
 	unsigned long apply_interval_us;
+	struct damos_quota quota;
+	struct damos_watermarks wmarks;
+	union {
+		struct {
+			int target_nid;
+			struct damos_migrate_dests migrate_dests;
+		};
+	};
+	struct damos_stat stat;
+	unsigned long max_nr_snapshots;
 /* private: internal use only */
 	/*
 	 * number of sample intervals that should be passed before applying
@@ -585,20 +582,25 @@ struct damos {
 	/* whether to reject core/ops filters umatched regions */
 	bool core_filters_default_reject;
 	bool ops_filters_default_reject;
-/* public: */
-	struct damos_quota quota;
-	struct damos_watermarks wmarks;
-	union {
-		struct {
-			int target_nid;
-			struct damos_migrate_dests migrate_dests;
-		};
-	};
+	/* Additional set of &struct damos_filter for &action. */
 	struct list_head core_filters;
+	/* ops layer handling &struct damos_filter objects list. */
 	struct list_head ops_filters;
+	/*
+	 * Last @action applied ops-managing entity.
+	 *
+	 * The minimum entity that @action can be applied depends on the
+	 * underlying &struct damon_operations.  Since it may not be aligned
+	 * with the core layer abstract, namely &struct damon_region, &struct
+	 * damon_operations could apply @action to same entity multiple times.
+	 * Large folios that underlying on multiple &struct damon region
+	 * objects could be such examples.  The &struct damon_operations can
+	 * use @last_applied to avoid that.  DAMOS core logic unsets
+	 * @last_applied when each regions walking for applying the scheme is
+	 * finished.
+	 */
 	void *last_applied;
-	struct damos_stat stat;
-	unsigned long max_nr_snapshots;
+	/* List head for siblings. */
 	struct list_head list;
 };
 
_

Patches currently in -mm which might be from sj@kernel.org are


