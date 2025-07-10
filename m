Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C07E283FE4
	for <mm-commits@vger.kernel.org>; Thu, 10 Jul 2025 05:45:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752126317; cv=none; b=sL8YbfymY9gSQAbHAELTnvHciV3XzLkso5YXS2YPxa/znAUY2zBvzNTQ+TCgNQtA+hwjYXmXZgmXo/NpF5M4PWxN+TVqn8tXBDoo9JalygTRYESi/SX9SSiRQQ3sptbrjRO10jepW3lYc+3TufgRsDfBX5+++dQrqegITujXdfg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752126317; c=relaxed/simple;
	bh=WUbNn1ETPjUPS3n3Zm91s6NOlz3zjCdUQq0gGRiSva4=;
	h=Date:To:From:Subject:Message-Id; b=IVbeoIQhQtdSl7bmklNiChIxzNfCJWxEhFP1/gbDXWh894n/aewR2xH2YICw0CHcN0lSV0lj/ARXgmUmj0zos/XjDEmEoZd0FHKEaxRF++nzq8ZCaNO7hV8rcBSnG/OEeOOhwPcEEXxkgdRjhOH5xNz9exHHguIcj1UlV1Gi4L8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=xEhX4zgp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="xEhX4zgp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 21E53C4CEF4;
	Thu, 10 Jul 2025 05:45:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1752126317;
	bh=WUbNn1ETPjUPS3n3Zm91s6NOlz3zjCdUQq0gGRiSva4=;
	h=Date:To:From:Subject:From;
	b=xEhX4zgpe9zfO0wVj8LBcpBq32987ltTlzqZ3BBVFLxH9/0TGetX0fZbmJImSTlnk
	 KTK+5NUSO5nQXnxWk27jRKF320SWDvXQ0DMeqVNAtgNn2K9l/bjpLs3tZiPKeD5b0j
	 piX07bqA7zANsbae6mpYiBV5nuWWuuTesMhwdKy0=
Date: Wed, 09 Jul 2025 22:45:16 -0700
To: mm-commits@vger.kernel.org,zhengqi.arch@bytedance.com,shakeel.butt@linux.dev,mhocko@kernel.org,lorenzo.stoakes@oracle.com,joshua.hahnjy@gmail.com,honggyu.kim@sk.com,hannes@cmpxchg.org,david@redhat.com,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] revert-mm-make-alloc_demote_folio-externally-invokable-for-migration.patch removed from -mm tree
Message-Id: <20250710054517.21E53C4CEF4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: Revert "mm: make alloc_demote_folio externally invokable for migration"
has been removed from the -mm tree.  Its filename was
     revert-mm-make-alloc_demote_folio-externally-invokable-for-migration.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: Revert "mm: make alloc_demote_folio externally invokable for migration"
Date: Mon, 16 Jun 2025 10:23:46 -0700

This reverts commit a00ce85af2a1be494d3b0c9457e8e81cdcce2a89.

Commit a00ce85af2a1 ("mm: make alloc_demote_folio externally invokable for
migration") was made to let DAMOS_MIGRATE_{HOT,COLD} call the function. 
But a previous commit made DAMOS_MIGRATE_{HOT,COLD} call
alloc_migration_target() instead.  Hence there are no more callers of the
function outside of vmscan.c.  Revert the commit to make the function
static again.

Link: https://lkml.kernel.org/r/20250616172346.67659-4-sj@kernel.org
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

 mm/internal.h |    1 -
 mm/vmscan.c   |    3 ++-
 2 files changed, 2 insertions(+), 2 deletions(-)

--- a/mm/internal.h~revert-mm-make-alloc_demote_folio-externally-invokable-for-migration
+++ a/mm/internal.h
@@ -1226,7 +1226,6 @@ extern unsigned long  __must_check vm_mm
         unsigned long, unsigned long);
 
 extern void set_pageblock_order(void);
-struct folio *alloc_demote_folio(struct folio *src, unsigned long private);
 unsigned long reclaim_pages(struct list_head *folio_list);
 unsigned int reclaim_clean_pages_from_list(struct zone *zone,
 					    struct list_head *folio_list);
--- a/mm/vmscan.c~revert-mm-make-alloc_demote_folio-externally-invokable-for-migration
+++ a/mm/vmscan.c
@@ -1006,7 +1006,8 @@ static void folio_check_dirty_writeback(
 		mapping->a_ops->is_dirty_writeback(folio, dirty, writeback);
 }
 
-struct folio *alloc_demote_folio(struct folio *src, unsigned long private)
+static struct folio *alloc_demote_folio(struct folio *src,
+		unsigned long private)
 {
 	struct folio *dst;
 	nodemask_t *allowed_mask;
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

