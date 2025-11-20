Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 207C72F6922
	for <mm-commits@vger.kernel.org>; Thu, 20 Nov 2025 21:45:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763675120; cv=none; b=korAaPViyeGs8k1551QiQoOfgc9ADcg/3j9/iLowRlkUbHnvYkID2DBedSz7MShOFhUojFzjdIpD8vGuYT4ZZ6mAY/xMnQ48cgy1duDbdhLbJGdMuHNimHavTupep+MEjECGLxWg/8Qv00scz6bPDWCNkyyLpRcCiH+C5V2LKD0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763675120; c=relaxed/simple;
	bh=9mDhhr40BMimng1k62tgjtTk+3seSB9wXdz4ytUbFL8=;
	h=Date:To:From:Subject:Message-Id; b=iQiMAChVH0XcxFtqAfR6R+ibTxvpAY4YeNHgc8s3GoO7SDxk4OPUBXK+jAasprbvcXfuH2itbAChMSTEXDoE0BjFKL1qHQIjcCNdG+BDDbKGsbOfdzG692qQhEaQ3n8TBZIfWbr6YbZU6gbkKbcmSw5LTYIyBNdDz8DR9JA8Xws=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=UCfhpRsn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="UCfhpRsn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A93E9C4CEF1;
	Thu, 20 Nov 2025 21:45:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1763675119;
	bh=9mDhhr40BMimng1k62tgjtTk+3seSB9wXdz4ytUbFL8=;
	h=Date:To:From:Subject:From;
	b=UCfhpRsn5ksjLwWiCK3WLi20ooBH7u8q/d2Fs7JlJtkuPmTsJp42iS6ZPNSSwMyjK
	 PmK+hWOBRkcf5BAoi3SXCcX7vHNiIjGL3eacMk3fUmr9IXCdEtdkpF7JNbv0hGXORK
	 DA/SNiuH6t4mcpSwrAskMTH4N+AVVdQ2icc8kt6I=
Date: Thu, 20 Nov 2025 13:45:19 -0800
To: mm-commits@vger.kernel.org,vbabka@suse.cz,surenb@google.com,shuah@kernel.org,rppt@kernel.org,ojeda@kernel.org,nathan@kernel.org,morbo@google.com,mhocko@suse.com,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,justinstitt@google.com,hughd@google.com,david@kernel.org,davidgow@google.com,corbet@lwn.net,brendan.higgins@linux.dev,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-damon-rename-damos-filters-to-damos-core_filters.patch removed from -mm tree
Message-Id: <20251120214519.A93E9C4CEF1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/damon: rename damos->filters to damos->core_filters
has been removed from the -mm tree.  Its filename was
     mm-damon-rename-damos-filters-to-damos-core_filters.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: mm/damon: rename damos->filters to damos->core_filters
Date: Wed, 12 Nov 2025 07:41:05 -0800

DAMOS filters that are handled by the ops layer are linked to
damos->ops_filters.  Owing to the ops_ prefix on the name, it is easy to
understand it is for ops layer handled filters.  The other types of
filters, which are handled by the core layer, are linked to
damos->filters.  Because of the name, it is easy to confuse the list is
there for not only core layer handled ones but all filters.  Avoid such
confusions by renaming the field to core_filters.

Link: https://lkml.kernel.org/r/20251112154114.66053-3-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Bill Wendling <morbo@google.com>
Cc: Brendan Higgins <brendan.higgins@linux.dev>
Cc: David Gow <davidgow@google.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: Hugh Dickins <hughd@google.com>
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
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/damon.h                                   |   10 +++++-----
 mm/damon/core.c                                         |    6 +++---
 mm/damon/tests/core-kunit.h                             |    4 ++--
 tools/testing/selftests/damon/drgn_dump_damon_status.py |    8 ++++----
 tools/testing/selftests/damon/sysfs.py                  |    2 +-
 5 files changed, 15 insertions(+), 15 deletions(-)

--- a/include/linux/damon.h~mm-damon-rename-damos-filters-to-damos-core_filters
+++ a/include/linux/damon.h
@@ -492,7 +492,7 @@ struct damos_migrate_dests {
  * @wmarks:		Watermarks for automated (in)activation of this scheme.
  * @migrate_dests:	Destination nodes if @action is "migrate_{hot,cold}".
  * @target_nid:		Destination node if @action is "migrate_{hot,cold}".
- * @filters:		Additional set of &struct damos_filter for &action.
+ * @core_filters:	Additional set of &struct damos_filter for &action.
  * @ops_filters:	ops layer handling &struct damos_filter objects list.
  * @last_applied:	Last @action applied ops-managing entity.
  * @stat:		Statistics of this scheme.
@@ -518,7 +518,7 @@ struct damos_migrate_dests {
  *
  * Before applying the &action to a memory region, &struct damon_operations
  * implementation could check pages of the region and skip &action to respect
- * &filters
+ * &core_filters
  *
  * The minimum entity that @action can be applied depends on the underlying
  * &struct damon_operations.  Since it may not be aligned with the core layer
@@ -562,7 +562,7 @@ struct damos {
 			struct damos_migrate_dests migrate_dests;
 		};
 	};
-	struct list_head filters;
+	struct list_head core_filters;
 	struct list_head ops_filters;
 	void *last_applied;
 	struct damos_stat stat;
@@ -872,10 +872,10 @@ static inline unsigned long damon_sz_reg
 	list_for_each_entry_safe(goal, next, &(quota)->goals, list)
 
 #define damos_for_each_core_filter(f, scheme) \
-	list_for_each_entry(f, &(scheme)->filters, list)
+	list_for_each_entry(f, &(scheme)->core_filters, list)
 
 #define damos_for_each_core_filter_safe(f, next, scheme) \
-	list_for_each_entry_safe(f, next, &(scheme)->filters, list)
+	list_for_each_entry_safe(f, next, &(scheme)->core_filters, list)
 
 #define damos_for_each_ops_filter(f, scheme) \
 	list_for_each_entry(f, &(scheme)->ops_filters, list)
--- a/mm/damon/core.c~mm-damon-rename-damos-filters-to-damos-core_filters
+++ a/mm/damon/core.c
@@ -306,7 +306,7 @@ void damos_add_filter(struct damos *s, s
 	if (damos_filter_for_ops(f->type))
 		list_add_tail(&f->list, &s->ops_filters);
 	else
-		list_add_tail(&f->list, &s->filters);
+		list_add_tail(&f->list, &s->core_filters);
 }
 
 static void damos_del_filter(struct damos_filter *f)
@@ -397,7 +397,7 @@ struct damos *damon_new_scheme(struct da
 	 */
 	scheme->next_apply_sis = 0;
 	scheme->walk_completed = false;
-	INIT_LIST_HEAD(&scheme->filters);
+	INIT_LIST_HEAD(&scheme->core_filters);
 	INIT_LIST_HEAD(&scheme->ops_filters);
 	scheme->stat = (struct damos_stat){};
 	INIT_LIST_HEAD(&scheme->list);
@@ -995,7 +995,7 @@ static void damos_set_filters_default_re
 		s->core_filters_default_reject = false;
 	else
 		s->core_filters_default_reject =
-			damos_filters_default_reject(&s->filters);
+			damos_filters_default_reject(&s->core_filters);
 	s->ops_filters_default_reject =
 		damos_filters_default_reject(&s->ops_filters);
 }
--- a/mm/damon/tests/core-kunit.h~mm-damon-rename-damos-filters-to-damos-core_filters
+++ a/mm/damon/tests/core-kunit.h
@@ -876,7 +876,7 @@ static void damos_test_commit_filter(str
 static void damos_test_help_initailize_scheme(struct damos *scheme)
 {
 	INIT_LIST_HEAD(&scheme->quota.goals);
-	INIT_LIST_HEAD(&scheme->filters);
+	INIT_LIST_HEAD(&scheme->core_filters);
 	INIT_LIST_HEAD(&scheme->ops_filters);
 }
 
@@ -1140,7 +1140,7 @@ static void damon_test_set_filters_defau
 	struct damos scheme;
 	struct damos_filter *target_filter, *anon_filter;
 
-	INIT_LIST_HEAD(&scheme.filters);
+	INIT_LIST_HEAD(&scheme.core_filters);
 	INIT_LIST_HEAD(&scheme.ops_filters);
 
 	damos_set_filters_default_reject(&scheme);
--- a/tools/testing/selftests/damon/drgn_dump_damon_status.py~mm-damon-rename-damos-filters-to-damos-core_filters
+++ a/tools/testing/selftests/damon/drgn_dump_damon_status.py
@@ -175,11 +175,11 @@ def scheme_to_dict(scheme):
         ['target_nid', int],
         ['migrate_dests', damos_migrate_dests_to_dict],
         ])
-    filters = []
+    core_filters = []
     for f in list_for_each_entry(
-            'struct damos_filter', scheme.filters.address_of_(), 'list'):
-        filters.append(damos_filter_to_dict(f))
-    dict_['filters'] = filters
+            'struct damos_filter', scheme.core_filters.address_of_(), 'list'):
+        core_filters.append(damos_filter_to_dict(f))
+    dict_['core_filters'] = core_filters
     ops_filters = []
     for f in list_for_each_entry(
             'struct damos_filter', scheme.ops_filters.address_of_(), 'list'):
--- a/tools/testing/selftests/damon/sysfs.py~mm-damon-rename-damos-filters-to-damos-core_filters
+++ a/tools/testing/selftests/damon/sysfs.py
@@ -132,7 +132,7 @@ def assert_scheme_committed(scheme, dump
     assert_watermarks_committed(scheme.watermarks, dump['wmarks'])
     # TODO: test filters directory
     for idx, f in enumerate(scheme.core_filters.filters):
-        assert_filter_committed(f, dump['filters'][idx])
+        assert_filter_committed(f, dump['core_filters'][idx])
     for idx, f in enumerate(scheme.ops_filters.filters):
         assert_filter_committed(f, dump['ops_filters'][idx])
 
_

Patches currently in -mm which might be from sj@kernel.org are


