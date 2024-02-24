Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC8F079C5
	for <mm-commits@vger.kernel.org>; Sat, 24 Feb 2024 01:50:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708739412; cv=none; b=Fc48ezTjtTm3NEkvisJvJuJMAeqMv4iZQLIhZNTbtOvsmUrHPKOAPjO/80B0JstzzHeLYFbAY4uFxlF3/m3L2/WU9tUTePVTEIAxB5nxs60TxFgVt0UlbwHTd72cuf8NmM4v8YjR2XXy1m5kjiz1W+saeRke/77nGh5tl+LeHTo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708739412; c=relaxed/simple;
	bh=gZUiBUn/tLTrw1+iE30KTMK4H6pham/6rRzCpCefPvU=;
	h=Date:To:From:Subject:Message-Id; b=jYcQpPmINZKNwFQu1aR+WJln38W5rGc4ZJcJkfVppNUoeX7h31XdnCVjK02U5DkgOLA3b8HyTwrkFtqTbQUhMgz4yj8JG8PMR9dF/t3n3nFlRWW7r53FKhrnWlFurXYf4LxPg4nZqvaVhopQqsTObBM/BUpvffpauj8mP0kvchg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=2fgInk8s; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="2fgInk8s"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BFB20C433C7;
	Sat, 24 Feb 2024 01:50:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1708739411;
	bh=gZUiBUn/tLTrw1+iE30KTMK4H6pham/6rRzCpCefPvU=;
	h=Date:To:From:Subject:From;
	b=2fgInk8sbm1XhK9e4FIcmfpfgtO2fbBv4WjTzcdnx2ceEMeMj/NAUqHNnlrX0zGZ6
	 oNI4ydQZCzgc6LJDdf916EAgEiC1NSIQevq0TG/+d6gX3ZmyHqTemrxz2bRPtFNd3q
	 PhTCMughBiL8jVa575AtMwgwoco5rY0yt/cSPuqc=
Date: Fri, 23 Feb 2024 17:50:11 -0800
To: mm-commits@vger.kernel.org,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-damon-core-set-damos_quota-esz-as-public-field-and-document.patch removed from -mm tree
Message-Id: <20240224015011.BFB20C433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/damon/core: set damos_quota->esz as public field and document
has been removed from the -mm tree.  Its filename was
     mm-damon-core-set-damos_quota-esz-as-public-field-and-document.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: mm/damon/core: set damos_quota->esz as public field and document
Date: Mon, 19 Feb 2024 11:44:12 -0800

Patch series "mm/damon: let DAMOS feeds and tame/auto-tune itself".

The Aim-oriented Feedback-driven DAMOS Aggressiveness Auto-tuning
patchset[1] which has merged since commit 9294a037c015 ("mm/damon/core:
implement goal-oriented feedback-driven quota auto-tuning") made the
mechanism and the policy separated.  That is, users can set a part of
DAMOS control policies without a deep understanding of the mechanism but
just their demands such as SLA.

However, users are still required to do some additional work of manually
collecting their target metric and feeding it to DAMOS.  In the case of
end-users who use DAMON sysfs interface, the context switches between
user-space and kernel-space could also make it inefficient.  The overhead
is supposed to be only trivial in common cases, though.  Meanwhile, in
simple use cases, the target metric could be common system metrics that
the kernel can efficiently self-retrieve, such as memory pressure stall
time (PSI).

Extend DAMOS quota auto-tuning to support multiple types of metrics
including the DAMOS self-retrievable ones, and add support for memory
pressure stall time metric.  Different types of metrics can be supported
in future.  The auto-tuning capability is currently supported for only
users of DAMOS kernel API and DAMON sysfs interface.  Extend the support
to DAMON_RECLAIM.

Patches Sequence
================

First five patches are for helping debugging and fine-tuning existing
quota control features.  The first one (patch 1) exposes the effective
quota that is made with given user inputs to DAMOS kernel API users and
kernel-doc documents.  Following four patches implement (patches 1, 2 and
3) and document (patches 4 and 5) a new DAMON sysfs file that exposes the
value.

Following six patches cleanup and simplify the existing DAMOS quota
auto-tuning code by improving layout of comments and data structures
(patches 6 and 7), supporting common use cases, namely multiple goals
(patches 8, 9 and 10), and simplifying the interface (patch 11).

Then six patches for the main purpose of this patchset follow.  The first
three changes extend the core logic for various target metrics (patch 12),
implement memory pressure stall time-based target metric support (patch
13), and update DAMON sysfs interface to support the new target metric
(patch 14).  Then, documentation updates for the features on design (patch
15), ABI (patch 16), and usage (patch 17) follow.

Last three patches add auto-tuning support on DAMON_RECLAIM.  The patches
implement DAMON_RECLAIM parameters for user-feedback driven quota
auto-tuning (patch 18), memory pressure stall time-driven quota
self-tuning (patch 19), and finally update the DAMON_RECLAIM usage
document for the new parameters (patch 20).

[1] https://lore.kernel.org/all/20231130023652.50284-1-sj@kernel.org/


This patch (of 20):

DAMOS allow users to specify the quota as they want in multiple ways
including time quota, size quota, and feedback-based auto-tuning.  DAMOS
makes one effective quota out of the inputs and use it at the end. 
Knowing the current effective quota helps understanding DAMOS' internal
mechanism and fine-tuning quotas.  DAMON kernel API users can get the
information from ->esz field of damos_quota struct, but the field is
marked as private purpose, and not kernel-doc documented.  Make it public
and document.

Link: https://lkml.kernel.org/r/20240219194431.159606-1-sj@kernel.org
Link: https://lkml.kernel.org/r/20240219194431.159606-2-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/damon.h |    6 ++++--
 mm/damon/core.c       |    8 ++++----
 2 files changed, 8 insertions(+), 6 deletions(-)

--- a/include/linux/damon.h~mm-damon-core-set-damos_quota-esz-as-public-field-and-document
+++ a/include/linux/damon.h
@@ -138,6 +138,7 @@ enum damos_action {
  *
  * @get_score:		Feedback function for self-tuning quota.
  * @get_score_arg:	Parameter for @get_score
+ * @esz:		Effective size quota in bytes.
  *
  * To avoid consuming too much CPU time or IO resources for applying the
  * &struct damos->action to large memory, DAMON allows users to set time and/or
@@ -167,6 +168,8 @@ enum damos_action {
  * tuning is getting the feedback screo value of 10,000.  If @ms and/or @sz are
  * set together, those work as a hard limit quota.  If neither @ms nor @sz are
  * set, the mechanism starts from the quota of one byte.
+ *
+ * The resulting effective size quota in bytes is set to @esz.
  */
 struct damos_quota {
 	unsigned long ms;
@@ -179,14 +182,13 @@ struct damos_quota {
 
 	unsigned long (*get_score)(void *arg);
 	void *get_score_arg;
+	unsigned long esz;
 
 /* private: */
 	/* For throughput estimation */
 	unsigned long total_charged_sz;
 	unsigned long total_charged_ns;
 
-	unsigned long esz;	/* Effective size quota in bytes */
-
 	/* For charging the quota */
 	unsigned long charged_sz;
 	unsigned long charged_from;
--- a/mm/damon/core.c~mm-damon-core-set-damos_quota-esz-as-public-field-and-document
+++ a/mm/damon/core.c
@@ -299,12 +299,12 @@ void damos_destroy_filter(struct damos_f
 	damos_free_filter(f);
 }
 
-/* initialize private fields of damos_quota and return the pointer */
-static struct damos_quota *damos_quota_init_priv(struct damos_quota *quota)
+/* initialize fields of @quota that normally API users wouldn't set */
+static struct damos_quota *damos_quota_init(struct damos_quota *quota)
 {
+	quota->esz = 0;
 	quota->total_charged_sz = 0;
 	quota->total_charged_ns = 0;
-	quota->esz = 0;
 	quota->charged_sz = 0;
 	quota->charged_from = 0;
 	quota->charge_target_from = NULL;
@@ -336,7 +336,7 @@ struct damos *damon_new_scheme(struct da
 	scheme->stat = (struct damos_stat){};
 	INIT_LIST_HEAD(&scheme->list);
 
-	scheme->quota = *(damos_quota_init_priv(quota));
+	scheme->quota = *(damos_quota_init(quota));
 
 	scheme->wmarks = *wmarks;
 	scheme->wmarks.activated = true;
_

Patches currently in -mm which might be from sj@kernel.org are


