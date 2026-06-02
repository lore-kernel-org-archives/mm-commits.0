Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D62943C3782
	for <mm-commits@vger.kernel.org>; Tue,  2 Jun 2026 22:24:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780439092; cv=none; b=sAqK9NgKoIASAz2ZkOWJbevtrGrl3MBLwyOKZUVpDiO8EtZv9HBPELyRLLM5Nqf4B6HQ49soypXoocYB5M9WUoUFF1Xn1wCMDx5q5R1xPCh+0OjM9VcJO84IwAkIFzQBQk2XppXc7WwUoQtZSQQKzSl6ZHPCbwgAs0a36jTpgzU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780439092; c=relaxed/simple;
	bh=x2itvzX9LoenzFSOx0UlC/BE5pe7zTvenc1JaAOBgLI=;
	h=Date:To:From:Subject:Message-Id; b=VghkBJGh/4xGhREIRhnJr4DKizEj9ChJm/bBEDTuk6PFBMmA+bujB2Y0ZJxt/2+3VOQUR4HrK+aowpB5r0CMC9jFMxCBpSNdxDN4MHtT0xpoK4pMyRGM9iONHA8lSw1u0BcBj3iNn+P9ljkYvQwIllty71L4A2pU4EDTgAGVdOY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=1APIVxDy; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="1APIVxDy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D5121F00893;
	Tue,  2 Jun 2026 22:24:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1780439090;
	bh=SXYXlTxXnEzDd/Zzncew6d24I9LsbBvwatPqSTQDsoU=;
	h=Date:To:From:Subject;
	b=1APIVxDyIkLLUDPoath/kvs223/0uc4tNyU1YrawZ0i650015+kFkEtJ0yaY06zwL
	 Dyn71auSRkcvu9An7f2jeqv9fbJ199C8BA1MgLSBLVQ0EeWezVEkGkocukwYEmDv5u
	 pbwchRcdCsoye7K4S48/JGcc3FRmjILvz5nIeAto=
Date: Tue, 02 Jun 2026 15:24:50 -0700
To: mm-commits@vger.kernel.org,vbabka@kernel.org,surenb@google.com,shuah@kernel.org,rppt@kernel.org,rostedt@goodmis.org,mhocko@suse.com,mhiramat@kernel.org,mathieu.desnoyers@efficios.com,ljs@kernel.org,liam@infradead.org,david@kernel.org,corbet@lwn.net,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-damon-core-introduce-damon_ops-apply_probes.patch removed from -mm tree
Message-Id: <20260602222450.7D5121F00893@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/damon/core: introduce damon_ops->apply_probes
has been removed from the -mm tree.  Its filename was
     mm-damon-core-introduce-damon_ops-apply_probes.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: mm/damon/core: introduce damon_ops->apply_probes
Date: Mon, 18 May 2026 16:40:54 -0700

Extend damon_operations struct with a new callback, namely apply_probes. 
The callback will be invoked for data attributes monitoring.  More
specifically, the callback will apply damon_probe objects to each region
and update the per-region per-probe counters for the number of encountered
probe-positive samples.

Link: https://lore.kernel.org/20260518234119.97569-7-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: "Masami Hiramatsu (Google)" <mhiramat@kernel.org>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/damon.h |    4 ++++
 1 file changed, 4 insertions(+)

--- a/include/linux/damon.h~mm-damon-core-introduce-damon_ops-apply_probes
+++ a/include/linux/damon.h
@@ -630,6 +630,7 @@ enum damon_ops_id {
  * @update:			Update operations-related data structures.
  * @prepare_access_checks:	Prepare next access check of target regions.
  * @check_accesses:		Check the accesses to target regions.
+ * @apply_probes:		Apply probes for each region.
  * @get_scheme_score:		Get the score of a region for a scheme.
  * @apply_scheme:		Apply a DAMON-based operation scheme.
  * @target_valid:		Determine if the target is valid.
@@ -656,6 +657,8 @@ enum damon_ops_id {
  * last preparation and update the number of observed accesses of each region.
  * It should also return max number of observed accesses that made as a result
  * of its update.  The value will be used for regions adjustment threshold.
+ * @apply_probes should apply the data attribute probes to each region and
+ * accordingly update the probe hits counter of the region.
  * @get_scheme_score should return the priority score of a region for a scheme
  * as an integer in [0, &DAMOS_MAX_SCORE].
  * @apply_scheme is called from @kdamond when a region for user provided
@@ -673,6 +676,7 @@ struct damon_operations {
 	void (*update)(struct damon_ctx *context);
 	void (*prepare_access_checks)(struct damon_ctx *context);
 	unsigned int (*check_accesses)(struct damon_ctx *context);
+	void (*apply_probes)(struct damon_ctx *context);
 	int (*get_scheme_score)(struct damon_ctx *context,
 			struct damon_region *r, struct damos *scheme);
 	unsigned long (*apply_scheme)(struct damon_ctx *context,
_

Patches currently in -mm which might be from sj@kernel.org are

mm-damon-reclaim-handle-ctx-allocation-failure.patch
mm-damonn-lru_sort-handle-ctx-allocation-failure.patch
maintainers-add-testing-abi-documents-for-mm.patch

