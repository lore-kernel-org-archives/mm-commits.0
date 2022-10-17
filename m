Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2DDF5C433FE
	for <mm-commits@archiver.kernel.org>; Mon, 17 Oct 2022 20:41:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230290AbiJQUlM (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 17 Oct 2022 16:41:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43002 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230209AbiJQUkg (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 17 Oct 2022 16:40:36 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C106F81696
        for <mm-commits@vger.kernel.org>; Mon, 17 Oct 2022 13:37:05 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D5E55B81AD2
        for <mm-commits@vger.kernel.org>; Mon, 17 Oct 2022 20:36:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C06EC433C1;
        Mon, 17 Oct 2022 20:36:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1666039018;
        bh=oy5NBAB6w3TLtTvWChumg2Wz4SNxk/+eeuVurIU2rLo=;
        h=Date:To:From:Subject:From;
        b=jY8ubXSiTqVYxPzoslRYLxPw1TRD5bcFKRnkr92uwqesaieOiBmCzfurnOo5jrPKM
         73+8wlYFV7UOSfpjHyG/Iqwguah76J/DQ0ErJzLkXjPLnFWvjlfxgQv6Ch0hDhEss2
         0xrT8uJ0nijVkLyj9fBylxXFciMJNQKHCUd8iFSs=
Date:   Mon, 17 Oct 2022 13:36:57 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        william.kucharski@oracle.com, vbabka@suse.cz,
        songmuchun@bytedance.com, peterx@redhat.com,
        mike.kravetz@oracle.com, lkp@intel.com, hughd@google.com,
        ebiederm@xmission.com, dhowells@redhat.com, ccross@google.com,
        arnd@arndb.de, sidhartha.kumar@oracle.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + hugetlbfs-convert-hugetlb_delete_from_page_cache-to-use-folios.patch added to mm-unstable branch
Message-Id: <20221017203658.8C06EC433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: hugetlbfs: convert hugetlb_delete_from_page_cache() to use folios
has been added to the -mm mm-unstable branch.  Its filename is
     hugetlbfs-convert-hugetlb_delete_from_page_cache-to-use-folios.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/hugetlbfs-convert-hugetlb_delete_from_page_cache-to-use-folios.patch

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
Cc: kernel test robot <lkp@intel.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Muchun Song <songmuchun@bytedance.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: William Kucharski <william.kucharski@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/hugetlbfs/inode.c    |   14 +++++++-------
 include/linux/pagemap.h |    1 -
 mm/folio-compat.c       |    5 -----
 3 files changed, 7 insertions(+), 13 deletions(-)

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
@@ -1114,7 +1114,7 @@ static int hugetlbfs_error_remove_page(s
 	struct inode *inode = mapping->host;
 	pgoff_t index = page->index;
 
-	hugetlb_delete_from_page_cache(page);
+	hugetlb_delete_from_page_cache(page_folio(page));
 	if (unlikely(hugetlb_unreserve_pages(inode, index, index + 1, 1)))
 		hugetlb_fix_reserve_counts(inode);
 
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

mm-hugetlb-add-folio-support-to-hugetlb-specific-flag-macros.patch
mm-add-private-field-of-first-tail-to-struct-page-and-struct-folio.patch
mm-hugetlb-add-hugetlb_folio_subpool-helpers.patch
hugetlbfs-convert-hugetlb_delete_from_page_cache-to-use-folios.patch
mm-hugetlb-add-folio_hstate.patch
mm-hugetlb_cgroup-convert-__set_hugetlb_cgroup-to-folios.patch
mm-hugetlb_cgroup-convert-hugetlb_cgroup_from_page-to-folios.patch
mm-hugetlb_cgroup-convert-set_hugetlb_cgroup-to-folios.patch
mm-hugetlb_cgroup-convert-hugetlb_cgroup_migrate-to-folios.patch
mm-hugetlb-convert-isolate_or_dissolve_huge_page-to-folios.patch
mm-hugetlb-convert-free_huge_page-to-folios.patch
mm-hugetlb_cgroup-convert-hugetlb_cgroup_uncharge_page-to-folios.patch
mm-hugeltb_cgroup-convert-hugetlb_cgroup_commit_charge-to-folios.patch
mm-hugetlb-convert-move_hugetlb_state-to-folios.patch

