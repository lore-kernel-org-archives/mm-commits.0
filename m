Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9A5F2512DE
	for <mm-commits@vger.kernel.org>; Thu, 20 Nov 2025 21:45:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763675118; cv=none; b=aAZAwFCipiQlgnB9RdLChE2AcgzoASOfvHdBwVnXWVop5LmK45mkC66ElqkmqCSo1Hgm/9PhAOwgLZxHJ0hepAKVJ0x6+YfggdEWmw8HBMDZYrCRVbykzWG/VZeB8r2m8ldICNOSSr+YsZPyacsLAEOKD/MjCnh2X/aCTzAsz1c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763675118; c=relaxed/simple;
	bh=8HULPA5ROmTOZuQWqACR/TPg1PEv/4Xr2DISzaDoUg0=;
	h=Date:To:From:Subject:Message-Id; b=pgR63LwNHX+kEcCiGirqMuS0KaKdFOJM3SdPoPxS4pR0BEBwzJHgZhLWGZrzNR5ST4/a2FmCLL9JSudRJzSGNTGt09WmOXTpzDZT19QkYlSkEL6lh6142doZneIOxFOna9rLQ4VrnGxaT/RxhSebxy9unU49b0K9L7ifgZQ3Dhc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=uMvuTCIh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="uMvuTCIh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ACE2DC4CEF1;
	Thu, 20 Nov 2025 21:45:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1763675118;
	bh=8HULPA5ROmTOZuQWqACR/TPg1PEv/4Xr2DISzaDoUg0=;
	h=Date:To:From:Subject:From;
	b=uMvuTCIhJSyHJYpn1cn24n5GMJDu5asHfzzh0JT4viC2Jh9hsGjyH4A8AvoCIOYun
	 tnelI8Rfev1TtXH6H3Fs0TryAF+O6x9Y9r8yjCxGIiOI8/fD3IvmbPvAK+dF2s6UYl
	 xcEYbaDtTynuSkcCMpJ1VKKcF7lCyX4gg3Y8F8KM=
Date: Thu, 20 Nov 2025 13:45:18 -0800
To: mm-commits@vger.kernel.org,vbabka@suse.cz,surenb@google.com,shuah@kernel.org,rppt@kernel.org,ojeda@kernel.org,nathan@kernel.org,morbo@google.com,mhocko@suse.com,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,justinstitt@google.com,hughd@google.com,david@kernel.org,davidgow@google.com,corbet@lwn.net,brendan.higgins@linux.dev,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-damon-rename-damos-core-filter-helpers-to-have-word-core.patch removed from -mm tree
Message-Id: <20251120214518.ACE2DC4CEF1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/damon: rename damos core filter helpers to have word core
has been removed from the -mm tree.  Its filename was
     mm-damon-rename-damos-core-filter-helpers-to-have-word-core.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: mm/damon: rename damos core filter helpers to have word core
Date: Wed, 12 Nov 2025 07:41:04 -0800

Patch series "mm/damon: misc cleanups".

Yet another batch of misc cleanups and refactoring for DAMON code, tests,
and documents.

First two patches (1and 2) rename DAMOS core filters related code for
readability.

Three following patches (3-5) refactor page table walk callback functions
in DAMON, as suggested by Hugh and David, and I promised.

Next two patches (6 and 7) refactor DAMON core layer kunit test and sysfs
interface selftest to be simple and deduplicated.

Final two patches (8 and 9) fix up sphinx and grammatical errors on
documents.


This patch (of 9):

DAMOS filters handled by the core layer are called core filters, while
those handled by the ops layer are called ops filters.  They share the
same type but are managed in different places since core filters are
evaluated before the ops filters.  They also have different helper
functions that depend on their managed places.

The helper functions for ops filters have '_ops_' keyword on their name,
so it is easy to know they are for ops filters.  Meanwhile, the helper
functions for core filters are not having the 'core' keyword on their
name.  This makes it easy to be mistakenly used for ops filters.  Actually
there was such a bug.

To avoid future mistakes from similar confusions, rename DAMOS core
filters helper functions to have a keyword 'core' on their names.

Link: https://lkml.kernel.org/r/20251112154114.66053-1-sj@kernel.org
Link: https://lkml.kernel.org/r/20251112154114.66053-2-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Bill Wendling <morbo@google.com>
Cc: Brendan Higgins <brendan.higgins@linux.dev>
Cc: David Gow <davidgow@google.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Justin Stitt <justinstitt@google.com>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Miguel Ojeda <ojeda@kernel.org>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Nathan Chancellor <nathan@kernel.org>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: David Hildenbrand <david@kernel.org>
Cc: Hugh Dickins <hughd@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 .clang-format         |    4 ++--
 include/linux/damon.h |    4 ++--
 mm/damon/core.c       |   14 +++++++-------
 3 files changed, 11 insertions(+), 11 deletions(-)

--- a/.clang-format~mm-damon-rename-damos-core-filter-helpers-to-have-word-core
+++ a/.clang-format
@@ -140,8 +140,8 @@ ForEachMacros:
   - 'damon_for_each_scheme_safe'
   - 'damon_for_each_target'
   - 'damon_for_each_target_safe'
-  - 'damos_for_each_filter'
-  - 'damos_for_each_filter_safe'
+  - 'damos_for_each_core_filter'
+  - 'damos_for_each_core_filter_safe'
   - 'damos_for_each_ops_filter'
   - 'damos_for_each_ops_filter_safe'
   - 'damos_for_each_quota_goal'
--- a/include/linux/damon.h~mm-damon-rename-damos-core-filter-helpers-to-have-word-core
+++ a/include/linux/damon.h
@@ -871,10 +871,10 @@ static inline unsigned long damon_sz_reg
 #define damos_for_each_quota_goal_safe(goal, next, quota) \
 	list_for_each_entry_safe(goal, next, &(quota)->goals, list)
 
-#define damos_for_each_filter(f, scheme) \
+#define damos_for_each_core_filter(f, scheme) \
 	list_for_each_entry(f, &(scheme)->filters, list)
 
-#define damos_for_each_filter_safe(f, next, scheme) \
+#define damos_for_each_core_filter_safe(f, next, scheme) \
 	list_for_each_entry_safe(f, next, &(scheme)->filters, list)
 
 #define damos_for_each_ops_filter(f, scheme) \
--- a/mm/damon/core.c~mm-damon-rename-damos-core-filter-helpers-to-have-word-core
+++ a/mm/damon/core.c
@@ -450,7 +450,7 @@ void damon_destroy_scheme(struct damos *
 	damos_for_each_quota_goal_safe(g, g_next, &s->quota)
 		damos_destroy_quota_goal(g);
 
-	damos_for_each_filter_safe(f, next, s)
+	damos_for_each_core_filter_safe(f, next, s)
 		damos_destroy_filter(f);
 
 	damos_for_each_ops_filter_safe(f, next, s)
@@ -864,12 +864,12 @@ static int damos_commit_quota(struct dam
 	return 0;
 }
 
-static struct damos_filter *damos_nth_filter(int n, struct damos *s)
+static struct damos_filter *damos_nth_core_filter(int n, struct damos *s)
 {
 	struct damos_filter *filter;
 	int i = 0;
 
-	damos_for_each_filter(filter, s) {
+	damos_for_each_core_filter(filter, s) {
 		if (i++ == n)
 			return filter;
 	}
@@ -923,15 +923,15 @@ static int damos_commit_core_filters(str
 	struct damos_filter *dst_filter, *next, *src_filter, *new_filter;
 	int i = 0, j = 0;
 
-	damos_for_each_filter_safe(dst_filter, next, dst) {
-		src_filter = damos_nth_filter(i++, src);
+	damos_for_each_core_filter_safe(dst_filter, next, dst) {
+		src_filter = damos_nth_core_filter(i++, src);
 		if (src_filter)
 			damos_commit_filter(dst_filter, src_filter);
 		else
 			damos_destroy_filter(dst_filter);
 	}
 
-	damos_for_each_filter_safe(src_filter, next, src) {
+	damos_for_each_core_filter_safe(src_filter, next, src) {
 		if (j++ < i)
 			continue;
 
@@ -1767,7 +1767,7 @@ static bool damos_filter_out(struct damo
 	struct damos_filter *filter;
 
 	s->core_filters_allowed = false;
-	damos_for_each_filter(filter, s) {
+	damos_for_each_core_filter(filter, s) {
 		if (damos_filter_match(ctx, t, r, filter, ctx->min_sz_region)) {
 			if (filter->allow)
 				s->core_filters_allowed = true;
_

Patches currently in -mm which might be from sj@kernel.org are


