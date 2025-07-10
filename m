Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19AD51DD9AC
	for <mm-commits@vger.kernel.org>; Thu, 10 Jul 2025 05:45:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752126316; cv=none; b=n0exw0QTLrcglViyI24g4JB2tF6BrqBUDnc3CAnvrn9W6q8QaQYIFRLdvZO3Jd2xz0sGLyCSvluQ90ONj8VC6tgVHIc2t9Prle8uFgi1mUCSQzo3fCywVch49BbcvfciEGCeMFvg01cAeZoWyoLl71vvH/s+OYjZEZ6sG8lLIBk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752126316; c=relaxed/simple;
	bh=72IvygtTHq/bHPjztNFZ90h3WkqfgZ7Sd87Cv4Bwi24=;
	h=Date:To:From:Subject:Message-Id; b=Aut6m46ZlkE4jwoC5XgCT0mQs/TsUzlT9m3rwHeSj7F7gil2+o6Ox16cRRvnQg8TEJhaNj5JuM0sogT8EJeUoq431YP+UKJ+RVSBFwFdNt6ziesrOAhpLf3JZ8yoYrjP+xS/IfCniLWoyiNFAm2xGTeVjs6qJ0/AS+zkfWpeoUE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=wbvWdjQ/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="wbvWdjQ/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E35F3C4CEF4;
	Thu, 10 Jul 2025 05:45:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1752126316;
	bh=72IvygtTHq/bHPjztNFZ90h3WkqfgZ7Sd87Cv4Bwi24=;
	h=Date:To:From:Subject:From;
	b=wbvWdjQ/bdANZZa/G/x7Kc3wuBDWfcSdS9ZzPg40NXMGcqw+k0MvnKAKKJL0BQbJA
	 kKKKoDGwZS3OreuixGeLOYkA7amIcwuYVEsXzftxt7Id0u1MdCUwmn1yLAV8UUM16E
	 d/ajjVUd81r679op7fEQlh8z5aWQnCgiXnqMVoVw=
Date: Wed, 09 Jul 2025 22:45:15 -0700
To: mm-commits@vger.kernel.org,zhengqi.arch@bytedance.com,shakeel.butt@linux.dev,mhocko@kernel.org,lorenzo.stoakes@oracle.com,joshua.hahnjy@gmail.com,honggyu.kim@sk.com,hannes@cmpxchg.org,david@redhat.com,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] revert-mm-rename-alloc_demote_folio-to-alloc_migrate_folio.patch removed from -mm tree
Message-Id: <20250710054515.E35F3C4CEF4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: Revert "mm: rename alloc_demote_folio to alloc_migrate_folio"
has been removed from the -mm tree.  Its filename was
     revert-mm-rename-alloc_demote_folio-to-alloc_migrate_folio.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: Revert "mm: rename alloc_demote_folio to alloc_migrate_folio"
Date: Mon, 16 Jun 2025 10:23:45 -0700

This reverts commit 8f75267d22bdf8e3baf70f2fa7092d8c2f58da71.

Commit 8f75267d22bd ("mm: rename alloc_demote_folio to
alloc_migrate_folio") was to reflect the fact the function is called for
not only demotion, but also general migrations from
DAMOS_MIGRATE_{HOT,COLD}.  The previous commit made the DAMOS actions to
not use alloc_migrate_folio(), though.  So, demote_folio_list() is the
only caller of alloc_migrate_folio(), and the name could now be rather
confusing.  Revert the renaming commit.

Link: https://lkml.kernel.org/r/20250616172346.67659-3-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Reviewed-by: Joshua Hahn <joshua.hahnjy@gmail.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Honggyu Kim <honggyu.kim@sk.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Qi Zheng <zhengqi.arch@bytedance.com>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/internal.h |    2 +-
 mm/vmscan.c   |    4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

--- a/mm/internal.h~revert-mm-rename-alloc_demote_folio-to-alloc_migrate_folio
+++ a/mm/internal.h
@@ -1226,7 +1226,7 @@ extern unsigned long  __must_check vm_mm
         unsigned long, unsigned long);
 
 extern void set_pageblock_order(void);
-struct folio *alloc_migrate_folio(struct folio *src, unsigned long private);
+struct folio *alloc_demote_folio(struct folio *src, unsigned long private);
 unsigned long reclaim_pages(struct list_head *folio_list);
 unsigned int reclaim_clean_pages_from_list(struct zone *zone,
 					    struct list_head *folio_list);
--- a/mm/vmscan.c~revert-mm-rename-alloc_demote_folio-to-alloc_migrate_folio
+++ a/mm/vmscan.c
@@ -1006,7 +1006,7 @@ static void folio_check_dirty_writeback(
 		mapping->a_ops->is_dirty_writeback(folio, dirty, writeback);
 }
 
-struct folio *alloc_migrate_folio(struct folio *src, unsigned long private)
+struct folio *alloc_demote_folio(struct folio *src, unsigned long private)
 {
 	struct folio *dst;
 	nodemask_t *allowed_mask;
@@ -1069,7 +1069,7 @@ static unsigned int demote_folio_list(st
 	node_get_allowed_targets(pgdat, &allowed_mask);
 
 	/* Demotion ignores all cpuset and mempolicy settings */
-	migrate_pages(demote_folios, alloc_migrate_folio, NULL,
+	migrate_pages(demote_folios, alloc_demote_folio, NULL,
 		      (unsigned long)&mtc, MIGRATE_ASYNC, MR_DEMOTION,
 		      &nr_succeeded);
 
_

Patches currently in -mm which might be from sj@kernel.org are

selftests-damon-add-drgn-script-for-extracting-damon-status.patch
selftests-damon-_damon_sysfs-set-kdamondpid-in-start.patch
selftests-damon-add-python-and-drgn-based-damon-sysfs-test.patch
selftests-damon-sysfspy-test-monitoring-attribute-parameters.patch
selftests-damon-sysfspy-test-adaptive-targets-parameter.patch
selftests-damon-sysfspy-test-damos-schemes-parameters-setup.patch
mm-damon-add-trace-event-for-auto-tuned-monitoring-intervals.patch
mm-damon-add-trace-event-for-effective-size-quota.patch
mm-damon-add-trace-event-for-effective-size-quota-fix.patch
mm-damon-add-trace-event-for-effective-size-quota-fix-2.patch
samples-damon-wsse-fix-boot-time-enable-handling.patch
samples-damon-prcl-fix-boot-time-enable-crash.patch
samples-damon-mtier-support-boot-time-enable-setup.patch
mm-damon-reclaim-reset-enabled-when-damon-start-failed.patch
mm-damon-lru_sort-reset-enabled-when-damon-start-failed.patch
mm-damon-reclaim-use-parameter-context-correctly.patch
samples-damon-wsse-rename-to-have-damon_sample_-prefix.patch
samples-damon-prcl-rename-to-have-damon_sample_-prefix.patch
samples-damon-mtier-rename-to-have-damon_sample_-prefix.patch
mm-damon-sysfs-use-damon-core-api-damon_is_running.patch
mm-damon-sysfs-dont-hold-kdamond_lock-in-before_terminate.patch
docs-mm-damon-maintainer-profile-update-for-mm-new-tree.patch
mm-damon-add-struct-damos_migrate_dests.patch
mm-damon-core-add-damos-migrate_dests-field.patch
mm-damon-sysfs-schemes-implement-damos-action-destinations-directory.patch
mm-damon-sysfs-schemes-set-damos-migrate_dests.patch
docs-abi-damon-document-schemes-dests-directory.patch
docs-admin-guide-mm-damon-usage-document-dests-directory.patch

