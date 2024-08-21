Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E246C17BB26
	for <mm-commits@vger.kernel.org>; Wed, 21 Aug 2024 22:26:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724279165; cv=none; b=HecAUd197UbmqUgMZmm71ps2jRp6/6vxKL/4IUrwzLg7rga8rc+ZjYzGdYCOG0LYs2Plw/OuA7ngfs2PVYbmIV1RGb2XpKTnjhuao5B1Moh9LGWF03001se6MawU4S/gpXVcsmo35oBmai39haRHWKTM8tTv2ImT+EHyliczqiw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724279165; c=relaxed/simple;
	bh=tk0oLYXoxEc6p8GX5hT/aWZ6tk9gYMtdu5VencarrAQ=;
	h=Date:To:From:Subject:Message-Id; b=gdwSirrIxtLNCyD+zKrXjZW1wUCCa3MQio18G5w7uuFHfwrLEv7X7CdOC4CxLpyfmZxZaJyFezYedCD5JuieVyIXrdqi7C3UW4HwZtYjcdK7KFj08gf6g9c2bCV9fnWLduxaNz2bs7/+b7tqbkMqWHOmBDvAdOlX2xW+hJLUuC4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=hUA9THk4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="hUA9THk4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4041DC32781;
	Wed, 21 Aug 2024 22:26:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1724279164;
	bh=tk0oLYXoxEc6p8GX5hT/aWZ6tk9gYMtdu5VencarrAQ=;
	h=Date:To:From:Subject:From;
	b=hUA9THk4j9TTOYJpgTAMkIH6NPs45M1Ibg1S+rO2ey8fWJljBwfjECNoLhI5vgsDl
	 Lwa67rSkuUjhvSBWh/3FIqnAfcGDldKYSK0AjK70hZOTtIefoJUfVJigsSymXJnIzI
	 wIb2IW1Sr56frKR5O1yIqGm8dtgJQizL7h+Opbqs=
Date: Wed, 21 Aug 2024 15:26:03 -0700
To: mm-commits@vger.kernel.org,osalvador@suse.de,nao.horiguchi@gmail.com,linmiaohe@huawei.com,Jonathan.Cameron@Huawei.com,david@redhat.com,wangkefeng.wang@huawei.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-migrate-add-isolate_folio_to_list-fix.patch added to mm-unstable branch
Message-Id: <20240821222604.4041DC32781@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm-migrate-add-isolate_folio_to_list-fix
has been added to the -mm mm-unstable branch.  Its filename is
     mm-migrate-add-isolate_folio_to_list-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-migrate-add-isolate_folio_to_list-fix.patch

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
From: Kefeng Wang <wangkefeng.wang@huawei.com>
Subject: mm-migrate-add-isolate_folio_to_list-fix
Date: Tue, 20 Aug 2024 17:46:41 +0800

updates per Miaohe Lin

Link: https://lkml.kernel.org/r/927205ab-bd83-4765-b2bb-3fd311f5ac6d@huawei.com
Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Jonathan Cameron <Jonathan.Cameron@Huawei.com>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: Naoya Horiguchi <nao.horiguchi@gmail.com>
Cc: Oscar Salvador <osalvador@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory-failure.c |   23 +++++++++++++----------
 1 file changed, 13 insertions(+), 10 deletions(-)

--- a/mm/memory-failure.c~mm-migrate-add-isolate_folio_to_list-fix
+++ a/mm/memory-failure.c
@@ -2664,6 +2664,7 @@ static int soft_offline_in_use_page(stru
 	struct folio *folio = page_folio(page);
 	char const *msg_page[] = {"page", "hugepage"};
 	bool huge = folio_test_hugetlb(folio);
+	bool isolated;
 	LIST_HEAD(pagelist);
 	struct migration_target_control mtc = {
 		.nid = NUMA_NO_NODE,
@@ -2703,7 +2704,18 @@ static int soft_offline_in_use_page(stru
 		return 0;
 	}
 
-	if (isolate_folio_to_list(folio, &pagelist)) {
+       isolated = isolate_folio_to_list(folio, &pagelist);
+
+	/*
+	 * If we succeed to isolate the folio, we grabbed another refcount on
+	 * the folio, so we can safely drop the one we got from get_any_page().
+	 * If we failed to isolate the folio, it means that we cannot go further
+	 * and we will return an error, so drop the reference we got from
+	 * get_any_page() as well.
+	 */
+	folio_put(folio);
+
+	if (isolated) {
 		ret = migrate_pages(&pagelist, alloc_migration_target, NULL,
 			(unsigned long)&mtc, MIGRATE_SYNC, MR_MEMORY_FAILURE, NULL);
 		if (!ret) {
@@ -2726,15 +2738,6 @@ static int soft_offline_in_use_page(stru
 		ret = -EBUSY;
 	}
 
-	/*
-	 * If we succeed to isolate the folio, we grabbed another refcount on
-	 * the folio, so we can safely drop the one we got from get_any_page().
-	 * If we failed to isolate the folio, it means that we cannot go further
-	 * and we will return an error, so drop the reference we got from
-	 * get_any_page() as well.
-	 */
-	folio_put(folio);
-
 	return ret;
 }
 
_

Patches currently in -mm which might be from wangkefeng.wang@huawei.com are

mm-hugetlb-remove-left-over-comment-about-follow_huge_foo.patch
mm-memory_hotplug-remove-head-variable-in-do_migrate_range.patch
mm-memory-failure-add-unmap_posioned_folio.patch
mm-memory_hotplug-check-hwpoisoned-page-firstly-in-do_migrate_range.patch
mm-migrate-add-isolate_folio_to_list.patch
mm-migrate-add-isolate_folio_to_list-fix.patch
mm-memory_hotplug-unify-huge-lru-non-lru-movable-folio-isolation.patch
mm-remove-migration-for-hugepage-in-isolate_single_pageblock.patch

