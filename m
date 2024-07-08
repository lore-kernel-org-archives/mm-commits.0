Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9056F2D058
	for <mm-commits@vger.kernel.org>; Mon,  8 Jul 2024 22:18:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720477103; cv=none; b=Gv9ZtIhxb2zIEHTfMC1tjC7TcAk3Plz4eIxdGAa8/oMuq/iv6nEuuv0JHOCqIORPvbsxTwXMOsTW03YZ0sSzNJL9lwt2pAS2FNmAG9FLHK4k+BL42EUwQiSXvLloHTG49WTCh/it2HHDw+wu8M9ovD1rIeeNdyvs486sRu9rxNA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720477103; c=relaxed/simple;
	bh=qFT9e5vHv0Aw0S+wooYf1Jjjl+55UEHcTjDC/anuJ04=;
	h=Date:To:From:Subject:Message-Id; b=K5rStZ88Aofg01ZeguVSy+1eabsFYB5M19AeSSgncoIip/JYMn1LN6FcZopyF/Y3BNUhS6vb8fg4qlNTxes7mCa8syzORIvEOxH9mBcEq7rR3oZwxlHnWpY27VGnYcRBTAkckBeoahm7WvRMhs1qNx6tLoOuB22ZzfTsa4Xi4GQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=p9ICFtNW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="p9ICFtNW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 14ACFC116B1;
	Mon,  8 Jul 2024 22:18:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1720477103;
	bh=qFT9e5vHv0Aw0S+wooYf1Jjjl+55UEHcTjDC/anuJ04=;
	h=Date:To:From:Subject:From;
	b=p9ICFtNW9lQF9RzmLw+mtbhwNb0Es+w3aL6rnDE1v21EdOeOWXpXL0+wQtwVMxzSV
	 JOtk/Uw1YnMpCd49OZuu46xJlkC4njuoAzNxNiNVUYUA9RmFzWtQ8qmcGpUxWCCh0M
	 8egvw2T0UF35Lt1LY/L6NzjN5g9gxPA7uZGb6ZKs=
Date: Mon, 08 Jul 2024 15:18:22 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,ying.huang@intel.com,shy828301@gmail.com,hughd@google.com,david@redhat.com,baolin.wang@linux.alibaba.com,peterx@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-migrate-putback-split-folios-when-numa-hint-migration-fails.patch added to mm-unstable branch
Message-Id: <20240708221823.14ACFC116B1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/migrate: putback split folios when numa hint migration fails
has been added to the -mm mm-unstable branch.  Its filename is
     mm-migrate-putback-split-folios-when-numa-hint-migration-fails.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-migrate-putback-split-folios-when-numa-hint-migration-fails.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

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

Link: https://lkml.kernel.org/r/20240708215537.2630610-1-peterx@redhat.com
Fixes: 7262f208ca68 ("mm/migrate: split source folio if it is on deferred split list")
Signed-off-by: Peter Xu <peterx@redhat.com>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Cc: Yang Shi <shy828301@gmail.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Huang Ying <ying.huang@intel.com>
Cc: David Hildenbrand <david@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/migrate.c |   10 ++--------
 1 file changed, 2 insertions(+), 8 deletions(-)

--- a/mm/migrate.c~mm-migrate-putback-split-folios-when-numa-hint-migration-fails
+++ a/mm/migrate.c
@@ -2627,14 +2627,8 @@ int migrate_misplaced_folio(struct folio
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

mm-migrate-putback-split-folios-when-numa-hint-migration-fails.patch

