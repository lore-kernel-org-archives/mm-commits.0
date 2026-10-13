Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60A60449B2E
	for <mm-commits@vger.kernel.org>; Tue, 13 Oct 2026 04:32:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791865931; cv=none; b=fEWgxzKlkzdyav//ODUB4/hLf8ljEBD1GHV8ahtRqC5A79dKRXIa8HAbuIPXZ3z5/X6UTawN/GJHQn+s5/WUMpQaYN0gMBGC7yYPyL+B5Nz7pqB6pP+w2UlXQ4seN/1ZMmYjsQIvY03u2FeBHK6rE/VivEWBazH0jLZleCVAKds=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791865931; c=relaxed/simple;
	bh=91ECDZU3mlbPky2wdLnL0FFk4D9QO33h6sno7WeK90M=;
	h=Date:To:From:Subject:Message-Id; b=KU7XBp53jGA0zoqct/QZnU2Vcg9SJkHCaTLJavy1OGXYtePqCpEeuBnOffKOIUh8mqvFuzWKOMavkP48oDYQ65f18NGo/93GGeCo7hHB5LakaI09VxJFwDqPbqKsD3l0FzWxMSzm3mZo3dj/eHk2MGohn9cv+ESnmXWGTohd5YI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=hx9QxZwX; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="hx9QxZwX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3728E1F000FF;
	Tue, 13 Oct 2026 04:32:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1791865928;
	bh=eq09u67P5ZEMVTQNX6Nn6WRktNPQrDVpHqPUqwo7EBI=;
	h=Date:To:From:Subject;
	b=hx9QxZwXUKp8CSHLf47aouG3w1yOSHahLjhAcLWTwIYrRiG0tG2lI1wbBP0pB0ZtN
	 eMch0bO93NcxaVyEfgxgdjjt7M1BUIZkiM2SSAk/6k7VcUKxGCvA8bC0RT8fYyloOx
	 o0PS/O2urznrphlRW2yR4Jguak8p8nP4ldfDcqhk=
Date: Mon, 12 Oct 2026 21:32:07 -0700
To: mm-commits@vger.kernel.org,vbabka@kernel.org,surenb@google.com,rppt@kernel.org,mhocko@suse.com,ljs@kernel.org,liam@infradead.org,david@kernel.org,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-damon-api-introduce-damon_filter_type_hugepage_size.patch removed from -mm tree
Message-Id: <20261013043208.3728E1F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/damon/api: introduce DAMON_FILTER_TYPE_HUGEPAGE_SIZE
has been removed from the -mm tree.  Its filename was
     mm-damon-api-introduce-damon_filter_type_hugepage_size.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SJ Park <sj@kernel.org>
Subject: mm/damon/api: introduce DAMON_FILTER_TYPE_HUGEPAGE_SIZE
Date: Tue, 15 Sep 2026 07:33:50 -0700

Patch series "mm/damon: introduce hugepage_size probe filter".

Knowing whether a given memory is backed by a hugepage of specific size
is useful for efficient utilization of hugepages.  For easy monitoring
of the information, introduce a new data attribute probe filter type,
hugepage_size.  It works similar to the DAMOS filter of the same name.
It works for memory that is backed by a hugepage of a given size range.

Patch 1 introduces the new probe filter type to DAMON API and extends
related data structures.  Patch 2 updates probe filter commit logic to
handle the size range.  Patch 3 Updates the filtering logic to support
the new type.  Patch 4 adds new DAMON sysfs files for the size range.
Patch 5 updates DAMON sysfs interface to fully support the new filter
type.  Patches 6-8 updates design, usage and ABI documents for the new
feature.


This patch (of 8):

Introduce a new data attribute probe filter type, hugepage_size.  It will
work for memory that is backed by a hugepage of a given size range.  Add a
new damon_filter_type enum DAMON_FILTER_TYPE_HUGEPAGE_SIZE to identify the
type.  Add two new fields in the damon_filter struct for saving the size
range.

Link: https://lore.kernel.org/20260915143359.91472-1-sj@kernel.org
Link: https://lore.kernel.org/20260915143359.91472-2-sj@kernel.org
Signed-off-by: SJ Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
---

 include/linux/damon.h |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/include/linux/damon.h~mm-damon-api-introduce-damon_filter_type_hugepage_size
+++ a/include/linux/damon.h
@@ -783,12 +783,14 @@ struct damon_prep {
  * @DAMON_FILTER_TYPE_MEMCG:		Specific memcg's pages.
  * @DAMON_FILTER_TYPE_PGIDLE_UNSET:	Pgidle is unset.
  * @DAMON_FILTER_TYPE_PGIDLE_SET:	Pgidle is set.
+ * @DAMON_FILTER_TYPE_HUGEPAGE_SIZE:	Page is part of a hugepage.
  */
 enum damon_filter_type {
 	DAMON_FILTER_TYPE_ANON,
 	DAMON_FILTER_TYPE_MEMCG,
 	DAMON_FILTER_TYPE_PGIDLE_UNSET,
 	DAMON_FILTER_TYPE_PGIDLE_SET,
+	DAMON_FILTER_TYPE_HUGEPAGE_SIZE,
 };
 
 /**
@@ -798,6 +800,8 @@ enum damon_filter_type {
  * @matching:	Whether this filter is for the type-matching ones.
  * @allow:	Whether the @type-@matching ones should pass this filter.
  * @memcg_id:	Memcg id of the question if @type is DAMON_FILTER_MEMCG.
+ * @range_min:	Minimum value of range arguments.
+ * @range_max:	Maximum value of range arguments.
  */
 struct damon_filter {
 	enum damon_filter_type type;
@@ -805,6 +809,10 @@ struct damon_filter {
 	bool allow;
 	union {
 		u64 memcg_id;
+		struct {
+			unsigned long range_min;
+			unsigned long range_max;
+		};
 	};
 /* private: */
 	/* Siblings list. */
_

Patches currently in -mm which might be from sj@kernel.org are

mm-damon-core-introduce-damos_quota_goal-complement.patch
mm-damon-core-add-complement-argument-to-damos_new_quota_goal.patch
mm-damon-sysfs-schemes-support-quota-goal-complement-flag.patch
mm-damon-tests-core-kunit-test-quota_goal-complement-commit.patch
selftests-damon-sysfssh-test-quota-goal-complement-flag-file.patch
docs-mm-damon-design-document-damos-quota-goal-complement-flag.patch
docs-admin-guide-mm-damon-usage-update-for-quota-goal-complement-file.patch
docs-abi-damon-update-for-quota-goal-metric-complement-sysfs-file.patch

