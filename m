Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792832295;
	b=C+dfD2FJa/BEsjf9ZYpadXxJ+lE8r1rFt3wnhzVK/eqOAP6DfABcm8iJLS2+VBH7VL3j
	 j71aOkFIJqbg7HhDQSasD88dcJu4Q0NnnaqXjIuUlbtB/dibs74mDMifXEhPtjbk4CUp1
	 dNKlo0wySVoE493zW12nCl+g4hMbD1lIdutIIln67qXTdGyRulbKW8OJLDIftNBDQhveD
	 6bBpPcR3Yv4RpBpo4cN3/BwicVwyS6bRFJlkfyFVqCyhrpbCErgI2RJcTPO2oeRhOBzSJ
	 PACVF4R/XRHyslRYJSm1LkFgMzhkLfRJzoWl9c7UEEhuBpolfbpR1DipXI3HDjazPTw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792832295;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=Wo/DMeKubXo7l+8oEnRMzuSOVoV/x1+EMkQ2/fto2VA=;
	b=H7HyS2iJ1d3mkJ2x7P+zLQafdB5MgDlkgtR3OkE9QZucxbaQ4eRBrhJ3ljYWidQLwRMc
	 6ME08YZpTJo3nRrQK3Q+F64vjiOXSVBfQFPSptzkYkXCF5U21SgAT/Y+q6kywUR6GkTjE
	 1RO+8aK2Be5oFyBLuSUWyewUrXLxhylYVWlBpJ5t9IMKXr7T2fu6VWAFj/oclzZV3XIoO
	 GmlU9zu2quemPFI22QVx9hNXTVrsJn3M0nFJBdDTPxvAtuJbB51bPc30G/f6uw45nUNsi
	 T+b+DC7hEPPNNnpDus8OMCEAxgXoaH2GJ66aSHe3D5RNalFMkur0XbeAauvL5O82/8w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=C81v0lF2;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24F43606A31D
	for <mm-commits@vger.kernel.org>; Sat, 24 Oct 2026 08:58:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=C81v0lF2
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E37021F01825;
	Sat, 24 Oct 2026 08:58:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1792832295;
	bh=Wo/DMeKubXo7l+8oEnRMzuSOVoV/x1+EMkQ2/fto2VA=;
	h=Date:To:From:Subject;
	b=C81v0lF2UNw5NB4ae+PPzwiGHYhTZw56eRYHqVATn/9bs8dpdAJhNBFGzEArY8plx
	 tyOa4VrhX1EIQkIODlU4ECbDjCOFEuxc/pxOYXZHU6k64nQsdzhXVvQu0TvQwonYnP
	 IVGJohgVWq2U7n0f8i4yEmHhA0eqitqZzJSM54TM=
Date: Sat, 24 Oct 2026 01:58:14 -0700
To: mm-commits@vger.kernel.org,sj@kernel.org,zenghui.yu@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-damon-api-remove-unused-nr_damos_-enumerators.patch removed from -mm tree
Message-Id: <20261024085814.E37021F01825@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The quilt patch titled
     Subject: mm/damon/api: remove unused NR_DAMOS_* enumerators
has been removed from the -mm tree.  Its filename was
     mm-damon-api-remove-unused-nr_damos_-enumerators.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Zenghui Yu (Huawei)" <zenghui.yu@linux.dev>
Subject: mm/damon/api: remove unused NR_DAMOS_* enumerators
Date: Mon, 28 Sep 2026 01:39:55 -0700

Patch series "mm/damon/core: cleanup code, reduce stack usage, and add
kunit".

Three various improvements.  Patch 1 from Zenghui Yu (Huawei) cleans up
unused enums.  Patch 2 from Arnd Bergmann reduces kdamond's stack usage. 
Patch 3 from Karl Mehltretter adds a kunit test for uninitialized PSI
quota goal stage logic.


This patch (of 3):

NR_DAMOS_ACTIONS, NR_DAMOS_QUOTA_GOAL_METRICS, and NR_DAMOS_WMARK_METRICS
are not referenced by any code.  Remove them.

They can be reintroduced if a real user comes up.

Link: https://lore.kernel.org/20260928083959.4030-1-sj@kernel.org
Link: https://lore.kernel.org/20260928083959.4030-2-sj@kernel.org
Signed-off-by: Zenghui Yu (Huawei) <zenghui.yu@linux.dev>
Signed-off-by: SJ Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: SJ Park <sj@kernel.org>
---

 include/linux/damon.h |    8 --------
 1 file changed, 8 deletions(-)

--- a/include/linux/damon.h~mm-damon-api-remove-unused-nr_damos_-enumerators
+++ a/include/linux/damon.h
@@ -117,7 +117,6 @@ struct damon_target {
  * @DAMOS_MIGRATE_HOT:  Migrate the regions prioritizing warmer regions.
  * @DAMOS_MIGRATE_COLD:	Migrate the regions prioritizing colder regions.
  * @DAMOS_STAT:		Do nothing but count the stat.
- * @NR_DAMOS_ACTIONS:	Total number of DAMOS actions
  *
  * The support of each action is up to running &struct damon_operations.
  * Refer to 'Operation Action' section of Documentation/mm/damon/design.rst for
@@ -137,7 +136,6 @@ enum damos_action {
 	DAMOS_MIGRATE_HOT,
 	DAMOS_MIGRATE_COLD,
 	DAMOS_STAT,		/* Do nothing but only record the stat */
-	NR_DAMOS_ACTIONS,
 };
 
 /**
@@ -154,9 +152,6 @@ enum damos_action {
  * @DAMOS_QUOTA_NODE_ELIGIBLE_MEM_BP:	Scheme-eligible memory ratio of a
  *					node in basis points (0-10000).
  * @DAMOS_QUOTA_HUGEPAGE_MEM_BP:	Huge page to total used memory ratio.
- * @NR_DAMOS_QUOTA_GOAL_METRICS:	Number of DAMOS quota goal metrics.
- *
- * Metrics equal to larger than @NR_DAMOS_QUOTA_GOAL_METRICS are unsupported.
  */
 enum damos_quota_goal_metric {
 	DAMOS_QUOTA_USER_INPUT,
@@ -169,7 +164,6 @@ enum damos_quota_goal_metric {
 	DAMOS_QUOTA_INACTIVE_MEM_BP,
 	DAMOS_QUOTA_NODE_ELIGIBLE_MEM_BP,
 	DAMOS_QUOTA_HUGEPAGE_MEM_BP,
-	NR_DAMOS_QUOTA_GOAL_METRICS,
 };
 
 /**
@@ -313,12 +307,10 @@ struct damos_quota {
  *
  * @DAMOS_WMARK_NONE:		Ignore the watermarks of the given scheme.
  * @DAMOS_WMARK_FREE_MEM_RATE:	Free memory rate of the system in [0,1000].
- * @NR_DAMOS_WMARK_METRICS:	Total number of DAMOS watermark metrics
  */
 enum damos_wmark_metric {
 	DAMOS_WMARK_NONE,
 	DAMOS_WMARK_FREE_MEM_RATE,
-	NR_DAMOS_WMARK_METRICS,
 };
 
 /**
_

Patches currently in -mm which might be from zenghui.yu@linux.dev are

mm-page_alloc-mark-pages-freed-by-__free_pages_core-as-not-tagged.patch

