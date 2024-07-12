Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1FDA9127E0F;
	Fri, 12 Jul 2024 22:55:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720824903; cv=none; b=c+0anuQ0c1M2IwJ3F9KiorjXGIyhlM7d45CCdMjqESogrZdbL0Je1ol2l3AHGVgg1/5fFrhoT4quYyFMGV/lNkShj4X+vhYiVybNqvoJl/9GdIvlE5ZajqdTd2J4e76LvbNV9QGkyV+Lvpuh00HNCtgFKObcA7WPQR5bMqbL63Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720824903; c=relaxed/simple;
	bh=me+RpU4IpmNm71LAW4xsAqTyote1EVLX6VMCszl10vg=;
	h=Date:To:From:Subject:Message-Id; b=BBgN27nqtduER6Z7Kww7nWHF3UP/ysUXDDkv8g5US3arLJw0qDGtqj+EJSPbPkDTL8TB/l9rNoZHidRN0SC1VnUpGMZM44/NyhP8kW8cxdPTBaUOprGTqzZfPU9sRCeDQKKmsjoBK30FtrrkNIlVW9hgkFQgtCYagVEKMP/5uqk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=1HFKG3MX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="1HFKG3MX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E0772C32782;
	Fri, 12 Jul 2024 22:55:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1720824903;
	bh=me+RpU4IpmNm71LAW4xsAqTyote1EVLX6VMCszl10vg=;
	h=Date:To:From:Subject:From;
	b=1HFKG3MXoXvqWuSBOKy1SqI9rDGe9sQdYlio11Z43M8XICzFQAgQyu3IxOsSFbrdg
	 5v2nE+0F5hyY+ycDVmHPeZj9WIo5s3zTQq2NkeMZiCdbYCftpZtZ8+wv2YdauarRTV
	 byjpi2FSzSstUeT7+HXC6EJ7G48ovGaXZsp1MaR8=
Date: Fri, 12 Jul 2024 15:55:02 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,ying.huang@intel.com,stable@vger.kernel.org,shy828301@gmail.com,hughd@google.com,david@redhat.com,baolin.wang@linux.alibaba.com,peterx@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-migrate-putback-split-folios-when-numa-hint-migration-fails.patch removed from -mm tree
Message-Id: <20240712225502.E0772C32782@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/migrate: putback split folios when numa hint migration fails
has been removed from the -mm tree.  Its filename was
     mm-migrate-putback-split-folios-when-numa-hint-migration-fails.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Peter Xu <peterx@redhat.com>
Subject: mm/migrate: putback split folios when numa hint migration fails
Date: Mon, 8 Jul 2024 17:55:37 -0400

This issue is not from any report yet, but by code observation only.

This is yet another fix besides Hugh's patch [1] but on relevant code
path, where eager split of folio can happen if the folio is already on
deferred list during a folio migration.

Here the issue is NUMA path (migrate_misplaced_folio()) may start to
encounter such folio split now even with MR_NUMA_MISPLACED hint applied. 
Then when migrate_pages() didn't migrate all the folios, it's possible the
split small folios be put onto the list instead of the original folio. 
Then putting back only the head page won't be enough.

Fix it by putting back all the folios on the list.

[1] https://lore.kernel.org/all/46c948b4-4dd8-6e03-4c7b-ce4e81cfa536@google.com/

[akpm@linux-foundation.org: remove now unused local `nr_pages']
Link: https://lkml.kernel.org/r/20240708215537.2630610-1-peterx@redhat.com
Fixes: 7262f208ca68 ("mm/migrate: split source folio if it is on deferred split list")
Signed-off-by: Peter Xu <peterx@redhat.com>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Yang Shi <shy828301@gmail.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Huang Ying <ying.huang@intel.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/migrate.c |   11 ++---------
 1 file changed, 2 insertions(+), 9 deletions(-)

--- a/mm/migrate.c~mm-migrate-putback-split-folios-when-numa-hint-migration-fails
+++ a/mm/migrate.c
@@ -2621,20 +2621,13 @@ int migrate_misplaced_folio(struct folio
 	int nr_remaining;
 	unsigned int nr_succeeded;
 	LIST_HEAD(migratepages);
-	int nr_pages = folio_nr_pages(folio);
 
 	list_add(&folio->lru, &migratepages);
 	nr_remaining = migrate_pages(&migratepages, alloc_misplaced_dst_folio,
 				     NULL, node, MIGRATE_ASYNC,
 				     MR_NUMA_MISPLACED, &nr_succeeded);
-	if (nr_remaining) {
-		if (!list_empty(&migratepages)) {
-			list_del(&folio->lru);
-			node_stat_mod_folio(folio, NR_ISOLATED_ANON +
-					folio_is_file_lru(folio), -nr_pages);
-			folio_putback_lru(folio);
-		}
-	}
+	if (nr_remaining && !list_empty(&migratepages))
+		putback_movable_pages(&migratepages);
 	if (nr_succeeded) {
 		count_vm_numa_events(NUMA_PAGE_MIGRATE, nr_succeeded);
 		if (!node_is_toptier(folio_nid(folio)) && node_is_toptier(node))
_

Patches currently in -mm which might be from peterx@redhat.com are


