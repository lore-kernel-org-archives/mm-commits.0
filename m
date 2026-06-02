Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5471B3BFE31
	for <mm-commits@vger.kernel.org>; Tue,  2 Jun 2026 22:25:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780439155; cv=none; b=Qn+NCFTRmDz5yOlW6fNWi6fuoqShB6byuvwR2+HlcNMa39wcGRKXQ0aV9AYrhLdXfvIeai3V8H0ZJnbg0LE8QJJSDa2E0Fz4ePz7Bm7/YplMjHuey27NoaEfGH96Gg9UZdjI+Fbj/U0FObw76cawbuEJUibbrFHqq1ErjAiga8A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780439155; c=relaxed/simple;
	bh=7aLIToTK7ORgkjY7R+71qVbDO/qYNfQXEZNDit9T34Q=;
	h=Date:To:From:Subject:Message-Id; b=h991ftBrgV/0BJithHWHIiaWwxUH9PDM1PY5AAsuH7AvPv91sR9xpICEJts3xjPcwK3vs+DvjNWN4qgQ1VzvFz1ll6pTSbmumDGH+3fsEuFPLa5Nkw1qvQB/sQD2oK0oH5q4VU2umh9OrcL+FsSqix7zy5Fbsau+YlnFFzbHr1M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=apPKapKB; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="apPKapKB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 211E41F00893;
	Tue,  2 Jun 2026 22:25:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1780439154;
	bh=trq85SNbDL0c6UEo4FNxCb4kVi/94CrQewA8SxNzFg0=;
	h=Date:To:From:Subject;
	b=apPKapKBUNiti30RFpJh20eS/Cyy+cPxMuB4q8PEnPfmf7ZNdzQM1/Bp7QYgbDtL3
	 glgsxgVGUlvPf7BEZ5vkz1c/HCj2jOvuN97Of6nQUim/HJZmJgIFoDWLRcdLvTAUKI
	 TP7Vd1bODiuehjD28UaCqiG89nwliZ5TglWRcGnI=
Date: Tue, 02 Jun 2026 15:25:53 -0700
To: mm-commits@vger.kernel.org,shuah@kernel.org,brendan.higgins@linux.dev,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-damon-core-add-kdamond_call-debug_sanity-check.patch removed from -mm tree
Message-Id: <20260602222554.211E41F00893@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/damon/core: add kdamond_call() debug_sanity check
has been removed from the -mm tree.  Its filename was
     mm-damon-core-add-kdamond_call-debug_sanity-check.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: mm/damon/core: add kdamond_call() debug_sanity check
Date: Fri, 22 May 2026 08:40:19 -0700

kdamond_call() is the place where DAMON API callers are allowed to access
the DAMON context's public internal state including the monitoring
results.  Hence it is important to ensure it is called with the expected
DAMON context state.  Do the check under DAMON_DEBUG_SANITY.

Link: https://lore.kernel.org/20260522154026.80546-9-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Brendan Higgins <brendan.higgins@linux.dev>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/core.c |   33 +++++++++++++++++++++++++++++++++
 1 file changed, 33 insertions(+)

--- a/mm/damon/core.c~mm-damon-core-add-kdamond_call-debug_sanity-check
+++ a/mm/damon/core.c
@@ -3329,6 +3329,37 @@ static void kdamond_usleep(unsigned long
 		usleep_range_idle(usecs, usecs + 1);
 }
 
+#ifdef CONFIG_DAMON_DEBUG_SANITY
+static void damon_verify_ctx(struct damon_ctx *c)
+{
+	struct damon_target *t;
+	struct damon_region *r;
+
+	damon_for_each_target(t, c) {
+		struct damon_region *prev_r = NULL;
+		unsigned int nr_regions = 0;
+
+		damon_for_each_region(r, t) {
+			WARN_ONCE(r->ar.start >= r->ar.end,
+					"region start (%lu) >= end (%lu)\n",
+					r->ar.start, r->ar.end);
+			WARN_ONCE(prev_r && prev_r->ar.end > r->ar.start,
+					"region overlap (%lu > %lu)\n",
+					prev_r->ar.end, r->ar.start);
+			prev_r = r;
+			nr_regions++;
+		}
+		WARN_ONCE(damon_nr_regions(t) != nr_regions,
+				"nr_regions mismatch: %u != %u\n",
+				damon_nr_regions(t), nr_regions);
+	}
+}
+#else
+static void damon_verify_ctx(struct damon_ctx *c)
+{
+}
+#endif
+
 /*
  * kdamond_call() - handle damon_call_control objects.
  * @ctx:	The &struct damon_ctx of the kdamond.
@@ -3344,6 +3375,8 @@ static void kdamond_call(struct damon_ct
 	struct damon_call_control *control, *next;
 	LIST_HEAD(controls);
 
+	damon_verify_ctx(ctx);
+
 	mutex_lock(&ctx->call_controls_lock);
 	list_splice_tail_init(&ctx->call_controls, &controls);
 	mutex_unlock(&ctx->call_controls_lock);
_

Patches currently in -mm which might be from sj@kernel.org are

mm-damon-reclaim-handle-ctx-allocation-failure.patch
mm-damonn-lru_sort-handle-ctx-allocation-failure.patch
maintainers-add-testing-abi-documents-for-mm.patch

