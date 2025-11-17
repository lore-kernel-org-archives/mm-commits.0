Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED31E20B212
	for <mm-commits@vger.kernel.org>; Mon, 17 Nov 2025 01:31:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763343102; cv=none; b=Axq6FgRDEYdPXYbhwCYne7UTl0iDsR/2DByPd7UOVlUrQlExm7RP6m7/dHb3DSFR0eDmlDJbATOG7q6jpDbQWEfC7usXkiPWru3STPn4Y9ggudHbCRQMxNHCq6EFzLrFWx6e2l38W/LBCsDRYe0h+Td6dgIApjuLITJ6D5STfKU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763343102; c=relaxed/simple;
	bh=B/J3YbdcmR/I1FUp5R2RTcutNTbmgv1SyM4IgvfQ95k=;
	h=Date:To:From:Subject:Message-Id; b=cHp7LD03iCsWXqoLa4jUf37UjM2dFHjk99BHjgkgnrmLAB+sNWatYAgACrxi/zIa4aGVML5wfXIJy478h1oghotAKG9XjbaME5GZhY49vspJ8Dcj9VLcqKh+w5mzqCdAa+zonizepkV8QF9/0liROywAbSQNulu76nsxmbb4Ydo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=1DAidskX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="1DAidskX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B08D6C19422;
	Mon, 17 Nov 2025 01:31:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1763343101;
	bh=B/J3YbdcmR/I1FUp5R2RTcutNTbmgv1SyM4IgvfQ95k=;
	h=Date:To:From:Subject:From;
	b=1DAidskX94Z0SvOi38byPoilog4KQawqW1bmhKQLD0aP23A9HZZgoYU8JaS1h+2Z/
	 Vy8Zns9XufZIdTYjwEADM5ZL5p142umqItJLfSCBflVlFtIPfxKqY+r44zniQIT32s
	 LBohX9oJJUfNqREla80mUTsSMFGl214hefxSh0Ks=
Date: Sun, 16 Nov 2025 17:31:40 -0800
To: mm-commits@vger.kernel.org,yosry.ahmed@linux.dev,vbabka@suse.cz,surenb@google.com,shakeel.butt@linux.dev,rppt@kernel.org,roman.gushchin@linux.dev,nphamcs@gmail.com,muchun.song@linux.dev,mhocko@kernel.org,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,hannes@cmpxchg.org,david@redhat.com,corbet@lwn.net,chrisl@kernel.org,chengming.zhou@linux.dev,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-zswap-s-red-black-tree-xarray.patch removed from -mm tree
Message-Id: <20251117013141.B08D6C19422@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/zswap: s/red-black tree/xarray/
has been removed from the -mm tree.  Its filename was
     mm-zswap-s-red-black-tree-xarray.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: mm/zswap: s/red-black tree/xarray/
Date: Fri, 3 Oct 2025 13:38:50 -0700

Changes made by commit 796c2c23e14e ("zswap: replace RB tree with xarray")
are not reflected on a comment.  Update the comment.

Link: https://lkml.kernel.org/r/20251003203851.43128-4-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Acked-by: Yosry Ahmed <yosry.ahmed@linux.dev>
Acked-by: Nhat Pham <nphamcs@gmail.com>
Reviewed-by: Chengming Zhou <chengming.zhou@linux.dev>
Cc: Chris Li <chrisl@kernel.org>
Cc: David Hildenbrand <david@redhat.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/zswap.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/zswap.c~mm-zswap-s-red-black-tree-xarray
+++ a/mm/zswap.c
@@ -175,7 +175,7 @@ static struct shrinker *zswap_shrinker;
  * This structure contains the metadata for tracking a single compressed
  * page within zswap.
  *
- * swpentry - associated swap entry, the offset indexes into the red-black tree
+ * swpentry - associated swap entry, the offset indexes into the xarray
  * length - the length in bytes of the compressed page data.  Needed during
  *          decompression.
  * referenced - true if the entry recently entered the zswap pool. Unset by the
_

Patches currently in -mm which might be from sj@kernel.org are

mm-damon-tests-core-kunit-remove-dynamic-allocs-on-damos_test_commit_filter.patch
mm-damon-tests-core-kunit-split-out-damos_test_commit_filter-core-logic.patch
mm-damon-tests-core-kunit-extend-damos_test_commit_filter_for-for-union-fields.patch
mm-damon-tests-core-kunit-add-test-cases-to-damos_test_commit_filter.patch
mm-damon-tests-core-kunit-add-damos_commit_quota_goal-test.patch
mm-damon-tests-core-kunit-add-damos_commit_quota_goals-test.patch
mm-damon-tests-core-kunit-add-damos_commit_quota-test.patch
mm-damon-core-pass-migrate_dests-to-damos_commit_dests.patch
mm-damon-tests-core-kunit-add-damos_commit_dests-test.patch
mm-damon-tests-core-kunit-add-damos_commit-test.patch
mm-damon-tests-core-kunit-add-damon_commit_target_regions-test.patch
mm-damon-rename-damos-core-filter-helpers-to-have-word-core.patch
mm-damon-rename-damos-filters-to-damos-core_filters.patch
mm-damon-vaddr-cleanup-using-pmd_trans_huge_lock.patch
mm-damon-vaddr-use-vm_normal_folio_pmd-instead-of-damon_get_folio.patch
mm-damon-vaddr-consistently-use-only-pmd_entry-for-damos_migrate.patch
mm-damon-tests-core-kunit-remove-damon_min_region-redefinition.patch
selftests-damon-sysfspy-merge-damon-status-dumping-into-commitment-assertion.patch
docs-mm-damon-maintainer-profile-fix-a-typo-on-mm-untable-link.patch
docs-mm-damon-maintainer-profile-fix-grammartical-errors.patch

