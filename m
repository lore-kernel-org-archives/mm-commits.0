Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7044622D79F
	for <mm-commits@vger.kernel.org>; Wed, 21 May 2025 16:57:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747846650; cv=none; b=fH5qsOcgqu8HbXcaY37p1rpToPC8dE4CZi+EbQ0kNKJVibh3zszOR/bhkA1iFKaOY3GVk0AWMxV4ucIMOO72a7WKF/MRNzRlwp4M81vhxL5ibcUTPvATqwGO8Scw4VETXfBBOVAsudCqGp2NE5rGcN2Ikx+wsNSJS3MxFM9UotY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747846650; c=relaxed/simple;
	bh=kvUsNqOrk85Tv6XQ6JTgHMqL7JmwKMfekZkUjIzRVkE=;
	h=Date:To:From:Subject:Message-Id; b=I3/VUNQ+983DjyqpRSEiEEkpVQW6aw4j/Nu4Vjk3GUMsMPvg3bE6kZWp83yYveozTE2f+pMBZOkyzmOlvVJhsF8+bQlRaXg9KozyUI/RyCnQ+0uOrzlB3z/eu7OfMUUUGht66CnZ42HunOkOjNxxBPVB/0MP7bL2onbqSCVMhqo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Oz88zSqv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Oz88zSqv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC270C4CEE4;
	Wed, 21 May 2025 16:57:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1747846649;
	bh=kvUsNqOrk85Tv6XQ6JTgHMqL7JmwKMfekZkUjIzRVkE=;
	h=Date:To:From:Subject:From;
	b=Oz88zSqv3edGdmTmPlccaEEgPy0SpAYwXmdoZBiYup7M4fFQvIUuffhLkwgan/BpE
	 AxmZVRKCLXlKsJHA0WMkRU1whBEHZXaR5Gfq88gf0NmpFUzy4D2p3BWDNkMHB1GeF0
	 0jrnwPi/FHVi+TfbuN9vZnHoXAkIGp6AhNuzqxrk=
Date: Wed, 21 May 2025 09:57:29 -0700
To: mm-commits@vger.kernel.org,shuah@kernel.org,davidgow@google.com,corbet@lwn.net,brendan.higgins@linux.dev,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-damon-core-warn-and-fix-nr_accesses-corruption.patch removed from -mm tree
Message-Id: <20250521165729.CC270C4CEE4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/damon/core: warn and fix nr_accesses[_bp] corruption
has been removed from the -mm tree.  Its filename was
     mm-damon-core-warn-and-fix-nr_accesses-corruption.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: mm/damon/core: warn and fix nr_accesses[_bp] corruption
Date: Mon, 12 May 2025 17:27:10 -0700

Patch series "mm/damon: minor fixups and improvements for code, tests, and
documents".

Yet another batch of miscellaneous DAMON changes.  Fix and improve minor
problems in code, tests and documents.


This patch (of 6):

For a bug such as double aggregation reset[1], ->nr_accesses and/or
->nr_accesses_bp of damon_region could be corrupted.  Such corruption can
make monitoring results pretty inaccurate, so the root causing bug should
be investigated.  Meanwhile, the corruption itself can easily be fixed but
silently fixing it will hide the bug.

Fix the corruption as soon as found, but WARN_ONCE() so that we can be
aware of the existence of the bug while keeping the system running in a
more sane way.

Link: https://lkml.kernel.org/r/20250513002715.40126-1-sj@kernel.org
Link: https://lkml.kernel.org/r/20250513002715.40126-2-sj@kernel.org
Link: https://lore.kernel.org/20250302214145.356806-1-sj@kernel.org [1]
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Brendan Higgins <brendan.higgins@linux.dev>
Cc: David Gow <davidgow@google.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/core.c |   14 ++++++++++++++
 1 file changed, 14 insertions(+)

--- a/mm/damon/core.c~mm-damon-core-warn-and-fix-nr_accesses-corruption
+++ a/mm/damon/core.c
@@ -1392,6 +1392,19 @@ int damos_walk(struct damon_ctx *ctx, st
 }
 
 /*
+ * Warn and fix corrupted ->nr_accesses[_bp] for investigations and preventing
+ * the problem being propagated.
+ */
+static void damon_warn_fix_nr_accesses_corruption(struct damon_region *r)
+{
+	if (r->nr_accesses_bp == r->nr_accesses * 10000)
+		return;
+	WARN_ONCE(true, "invalid nr_accesses_bp at reset: %u %u\n",
+			r->nr_accesses_bp, r->nr_accesses);
+	r->nr_accesses_bp = r->nr_accesses * 10000;
+}
+
+/*
  * Reset the aggregated monitoring results ('nr_accesses' of each region).
  */
 static void kdamond_reset_aggregated(struct damon_ctx *c)
@@ -1404,6 +1417,7 @@ static void kdamond_reset_aggregated(str
 
 		damon_for_each_region(r, t) {
 			trace_damon_aggregated(ti, r, damon_nr_regions(t));
+			damon_warn_fix_nr_accesses_corruption(r);
 			r->last_nr_accesses = r->nr_accesses;
 			r->nr_accesses = 0;
 		}
_

Patches currently in -mm which might be from sj@kernel.org are


