Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D2F4CC43219
	for <mm-commits@archiver.kernel.org>; Wed,  9 Nov 2022 01:38:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229951AbiKIBie (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 8 Nov 2022 20:38:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34798 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229926AbiKIBiU (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 8 Nov 2022 20:38:20 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 741106316D
        for <mm-commits@vger.kernel.org>; Tue,  8 Nov 2022 17:38:17 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2FEA3B81CC8
        for <mm-commits@vger.kernel.org>; Wed,  9 Nov 2022 01:38:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CEE0AC433D6;
        Wed,  9 Nov 2022 01:38:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1667957894;
        bh=Qg5s82cKe/8A2VeaL33NG9Z4s40a39fhlKkWbXXsDVE=;
        h=Date:To:From:Subject:From;
        b=Ji9S/vAQGiG06w8NPvt18fBBu+IF3GSdVaYzq1Xyep5PvSZ1RhHHC4aY5BbUSDrN+
         nF7NtFgk0cUvvAnTTmLcEC7exPPWizg3WsM8Mfj2wgPoZa5Exv3TD0PKv9+YqWIr5M
         ieZLi5DRYqDL1SvtbLR/egPG1+Q96dEw+yM6aaVU=
Date:   Tue, 08 Nov 2022 17:38:14 -0800
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        william.kucharski@oracle.com, vbabka@suse.cz,
        songmuchun@bytedance.com, peterx@redhat.com,
        mike.kravetz@oracle.com, hughd@google.com, ebiederm@xmission.com,
        dhowells@redhat.com, ccross@google.com, arnd@arndb.de,
        sidhartha.kumar@oracle.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] hugetlbfs-convert-hugetlb_delete_from_page_cache-to-use-folios.patch removed from -mm tree
Message-Id: <20221109013814.CEE0AC433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: hugetlbfs: convert hugetlb_delete_from_page_cache() to use folios
has been removed from the -mm tree.  Its filename was
     hugetlbfs-convert-hugetlb_delete_from_page_cache-to-use-folios.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Sidhartha Kumar <sidhartha.kumar@oracle.com>
Subject: hugetlbfs: convert hugetlb_delete_from_page_cache() to use folios
Date: Thu, 22 Sep 2022 10:42:06 -0500

Remove the last caller of delete_from_page_cache() by converting the code
to its folio equivalent.

Link: https://lkml.kernel.org/r/20220922154207.1575343-5-sidhartha.kumar@oracle.com
Signed-off-by: Sidhartha Kumar <sidhartha.kumar@oracle.com>
Reviewed-by: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Colin Cross <ccross@google.com>
Cc: David Howells <dhowells@redhat.com>
Cc: "Eric W . Biederman" <ebiederm@xmission.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Muchun Song <songmuchun@bytedance.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: William Kucharski <william.kucharski@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/hugetlbfs/inode.c    |   12 ++++++------
 include/linux/pagemap.h |    1 -
 mm/folio-compat.c       |    5 -----
 3 files changed, 6 insertions(+), 12 deletions(-)

--- a/fs/hugetlbfs/inode.c~hugetlbfs-convert-hugetlb_delete_from_page_cache-to-use-folios
+++ a/fs/hugetlbfs/inode.c
@@ -364,11 +364,11 @@ static int hugetlbfs_write_end(struct fi
 	return -EINVAL;
 }
 
-static void hugetlb_delete_from_page_cache(struct page *page)
+static void hugetlb_delete_from_page_cache(struct folio *folio)
 {
-	ClearPageDirty(page);
-	ClearPageUptodate(page);
-	delete_from_page_cache(page);
+	folio_clear_dirty(folio);
+	folio_clear_uptodate(folio);
+	filemap_remove_folio(folio);
 }
 
 /*
@@ -574,8 +574,8 @@ static bool remove_inode_single_folio(st
 	 * map could fail.  Correspondingly, the subpool and global
 	 * reserve usage count can need to be adjusted.
 	 */
-	VM_BUG_ON(HPageRestoreReserve(&folio->page));
-	hugetlb_delete_from_page_cache(&folio->page);
+	VM_BUG_ON_FOLIO(folio_test_hugetlb_restore_reserve(folio), folio);
+	hugetlb_delete_from_page_cache(folio);
 	ret = true;
 	if (!truncate_op) {
 		if (unlikely(hugetlb_unreserve_pages(inode, index,
--- a/include/linux/pagemap.h~hugetlbfs-convert-hugetlb_delete_from_page_cache-to-use-folios
+++ a/include/linux/pagemap.h
@@ -1102,7 +1102,6 @@ int add_to_page_cache_lru(struct page *p
 int filemap_add_folio(struct address_space *mapping, struct folio *folio,
 		pgoff_t index, gfp_t gfp);
 void filemap_remove_folio(struct folio *folio);
-void delete_from_page_cache(struct page *page);
 void __filemap_remove_folio(struct folio *folio, void *shadow);
 void replace_page_cache_page(struct page *old, struct page *new);
 void delete_from_page_cache_batch(struct address_space *mapping,
--- a/mm/folio-compat.c~hugetlbfs-convert-hugetlb_delete_from_page_cache-to-use-folios
+++ a/mm/folio-compat.c
@@ -124,11 +124,6 @@ struct page *grab_cache_page_write_begin
 }
 EXPORT_SYMBOL(grab_cache_page_write_begin);
 
-void delete_from_page_cache(struct page *page)
-{
-	return filemap_remove_folio(page_folio(page));
-}
-
 int try_to_release_page(struct page *page, gfp_t gfp)
 {
 	return filemap_release_folio(page_folio(page), gfp);
_

Patches currently in -mm which might be from sidhartha.kumar@oracle.com are

mm-hugetlb_cgroup-convert-__set_hugetlb_cgroup-to-folios.patch
mm-hugetlb_cgroup-convert-hugetlb_cgroup_from_page-to-folios.patch
mm-hugetlb_cgroup-convert-set_hugetlb_cgroup-to-folios.patch
mm-hugetlb_cgroup-convert-hugetlb_cgroup_migrate-to-folios.patch
mm-hugetlb-convert-isolate_or_dissolve_huge_page-to-folios.patch
mm-hugetlb-convert-free_huge_page-to-folios.patch
mm-hugetlb_cgroup-convert-hugetlb_cgroup_uncharge_page-to-folios.patch
mm-hugeltb_cgroup-convert-hugetlb_cgroup_commit_charge-to-folios.patch
mm-hugetlb-convert-move_hugetlb_state-to-folios.patch

