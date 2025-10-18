Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23E72B672
	for <mm-commits@vger.kernel.org>; Sat, 18 Oct 2025 00:19:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760746789; cv=none; b=OQjy5qViCWgrSOC64uA4CC2qaRc04ZjXFK8rm0AXFOvmUPQSBZuylNMpMy2jIR34Wu+Y64s9azniLGoo+NxYJiCRmTc6XP+tNja/UxDMK5e+pfvkcwI0Dp7cQOXgUDwxiBBFocBXoPcZe8pmy2fHbtoEibe7v3djtnXEU7AlCkM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760746789; c=relaxed/simple;
	bh=j0PzzoHm9TScD6VPM1V5o0pFc9p5xmJ67UK9/CnScUg=;
	h=Date:To:From:Subject:Message-Id; b=mh3gojOEqdgayMeq9sb3hEsJuvb+IrBqK87mT2oMf9jcivc0jw5m4RFF8RCkCk8YqrQzvsrecy0XxU/ASD/JWV0D4db0hlVS852NbE2YlDcpildochZUBNYXJE/jwy+xL+pBI8iEHf4umAyJx7XvYMfBRXSFQCKKLa740mL8NHA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=PjCGvKJ8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="PjCGvKJ8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D4275C4CEE7;
	Sat, 18 Oct 2025 00:19:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1760746788;
	bh=j0PzzoHm9TScD6VPM1V5o0pFc9p5xmJ67UK9/CnScUg=;
	h=Date:To:From:Subject:From;
	b=PjCGvKJ8XU7gHv0xN6Ft6gHS9Q4T3N04lCfjZI+RnWtrAy1dv9EQNNOtrNJ6KiOLy
	 QwyFqj5Mgv2PRoHINKXnzIwknBQj9/QMSzfqPAICBuqJZIzs2R+JoI99ACKROlxqt0
	 fI5HqAUfkyn9BOc4yWXvCieEeATTq/1zxuzaSqRI=
Date: Fri, 17 Oct 2025 17:19:48 -0700
To: mm-commits@vger.kernel.org,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-damon-core-add-damos-quota-gaol-metric-for-per-memcg-per-numa-free-memory.patch added to mm-new branch
Message-Id: <20251018001948.D4275C4CEE7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/damon/core: add DAMOS quota gaol metric for per-memcg per-numa free memory
has been added to the -mm mm-new branch.  Its filename is
     mm-damon-core-add-damos-quota-gaol-metric-for-per-memcg-per-numa-free-memory.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-damon-core-add-damos-quota-gaol-metric-for-per-memcg-per-numa-free-memory.patch

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
Subject: mm/damon/core: add DAMOS quota gaol metric for per-memcg per-numa free memory
Date: Fri, 17 Oct 2025 14:26:58 -0700

Add a variant of DAMOS_QUOTA_NODE_MEMCG_USED_BP, for the free memory
portion.  The value of the metric is implemented as the entire memory of
the given NUMA node subtracted by the given cgroup's usage.  So from a
perspective, "unused" could be a better term than "free".  But arguably it
is not very clear what is better, so use the term "free".

Link: https://lkml.kernel.org/r/20251017212706.183502-7-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/damon.h |    6 ++++--
 mm/damon/core.c       |   10 ++++++++--
 2 files changed, 12 insertions(+), 4 deletions(-)

--- a/include/linux/damon.h~mm-damon-core-add-damos-quota-gaol-metric-for-per-memcg-per-numa-free-memory
+++ a/include/linux/damon.h
@@ -148,6 +148,7 @@ enum damos_action {
  * @DAMOS_QUOTA_NODE_MEM_USED_BP:	MemUsed ratio of a node.
  * @DAMOS_QUOTA_NODE_MEM_FREE_BP:	MemFree ratio of a node.
  * @DAMOS_QUOTA_NODE_MEMCG_USED_BP:	MemUsed ratio of a node for a cgroup.
+ * @DAMOS_QUOTA_NODE_MEMCG_FREE_BP:	MemFree ratio of a node for a cgroup.
  * @NR_DAMOS_QUOTA_GOAL_METRICS:	Number of DAMOS quota goal metrics.
  *
  * Metrics equal to larger than @NR_DAMOS_QUOTA_GOAL_METRICS are unsupported.
@@ -158,6 +159,7 @@ enum damos_quota_goal_metric {
 	DAMOS_QUOTA_NODE_MEM_USED_BP,
 	DAMOS_QUOTA_NODE_MEM_FREE_BP,
 	DAMOS_QUOTA_NODE_MEMCG_USED_BP,
+	DAMOS_QUOTA_NODE_MEMCG_FREE_BP,
 	NR_DAMOS_QUOTA_GOAL_METRICS,
 };
 
@@ -183,8 +185,8 @@ enum damos_quota_goal_metric {
  * If @metric is DAMOS_QUOTA_NODE_MEM_{USED,FREE}_BP, @nid represents the node
  * id of the target node to account the used/free memory.
  *
- * If @metric is DAMOS_QUOTA_NODE_MEMCG_USED_BP, @nid and @memcg_id represents
- * the node id and the cgroup to account the used memory for.
+ * If @metric is DAMOS_QUOTA_NODE_MEMCG_{USED,FREE}_BP, @nid and @memcg_id
+ * represents the node id and the cgroup to account the used memory for.
  */
 struct damos_quota_goal {
 	enum damos_quota_goal_metric metric;
--- a/mm/damon/core.c~mm-damon-core-add-damos-quota-gaol-metric-for-per-memcg-per-numa-free-memory
+++ a/mm/damon/core.c
@@ -790,6 +790,7 @@ static void damos_commit_quota_goal_unio
 		dst->nid = src->nid;
 		break;
 	case DAMOS_QUOTA_NODE_MEMCG_USED_BP:
+	case DAMOS_QUOTA_NODE_MEMCG_FREE_BP:
 		dst->nid = src->nid;
 		dst->memcg_id = src->memcg_id;
 		break;
@@ -2046,7 +2047,7 @@ static unsigned long damos_get_node_memc
 {
 	struct mem_cgroup *memcg;
 	struct lruvec *lruvec;
-	unsigned long used_pages;
+	unsigned long used_pages, numerator;
 	struct sysinfo i;
 
 	rcu_read_lock();
@@ -2066,7 +2067,11 @@ static unsigned long damos_get_node_memc
 	used_pages += lruvec_page_state(lruvec, NR_INACTIVE_FILE);
 
 	si_meminfo_node(&i, goal->nid);
-	return used_pages * 10000 / i.totalram;
+	if (goal->metric == DAMOS_QUOTA_NODE_MEMCG_USED_BP)
+		numerator = used_pages;
+	else	/* DAMOS_QUOTA_NODE_MEMCG_FREE_BP */
+		numerator = i.totalram - used_pages;
+	return numerator * 10000 / i.totalram;
 }
 #else
 static __kernel_ulong_t damos_get_node_mem_bp(
@@ -2101,6 +2106,7 @@ static void damos_set_quota_goal_current
 		goal->current_value = damos_get_node_mem_bp(goal);
 		break;
 	case DAMOS_QUOTA_NODE_MEMCG_USED_BP:
+	case DAMOS_QUOTA_NODE_MEMCG_FREE_BP:
 		goal->current_value = damos_get_node_memcg_used_bp(goal);
 		break;
 	default:
_

Patches currently in -mm which might be from sj@kernel.org are

mm-damon-core-fix-list_add_tail-call-on-damon_call.patch
mm-damon-core-use-damos_commit_quota_goal-for-new-goal-commit.patch
mm-zswap-remove-unnecessary-dlen-writes-for-incompressible-pages.patch
mm-zswap-fix-typos-s-zwap-zswap.patch
mm-zswap-s-red-black-tree-xarray.patch
docs-admin-guide-mm-zswap-s-red-black-tree-xarray.patch
mm-damon-document-damos_quota_goal-nid-use-case.patch
mm-damon-add-damos-quota-goal-type-for-per-memcg-per-node-memory-usage.patch
mm-damon-core-implement-damos_quota_node_memcg_used_bp.patch
mm-damon-sysfs-schemes-implement-path-file-under-quota-goal-directory.patch
mm-damon-sysfs-schemes-support-damos_quota_node_memcg_used_bp.patch
mm-damon-core-add-damos-quota-gaol-metric-for-per-memcg-per-numa-free-memory.patch
mm-damon-sysfs-schemes-support-damos_quota_node_memcg_free_bp.patch
docs-mm-damon-design-document-damos_quota_node_memcg_usedfree_bp.patch
docs-admin-guide-mm-damon-usage-document-damos-quota-goal-path-file.patch
docs-abi-damon-document-damos-quota-goal-path-file.patch

