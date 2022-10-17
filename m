Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3BBB3C433FE
	for <mm-commits@archiver.kernel.org>; Mon, 17 Oct 2022 20:41:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231528AbiJQUlI (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 17 Oct 2022 16:41:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42762 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231556AbiJQUkc (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 17 Oct 2022 16:40:32 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F28AF80BC7
        for <mm-commits@vger.kernel.org>; Mon, 17 Oct 2022 13:37:35 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 636F7B81A76
        for <mm-commits@vger.kernel.org>; Mon, 17 Oct 2022 20:36:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 06584C433C1;
        Mon, 17 Oct 2022 20:36:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1666039016;
        bh=dcOBN3WMACPHs7nTvElhpb30rJzvxp0l+aI6uQ5i6X0=;
        h=Date:To:From:Subject:From;
        b=l4fAcEVgFvFpoZ2L1v2ELEgIAULJVGEMSEnoJ6RRrB41Lndr2f2ZhwIocFswUfSBZ
         /gbWENJsZeEPINuXRKLlXQXLii1sASCOwmH7MdW52y/nU5HIW8EYLpv7iKy9ft+Q2s
         RkjK8h5AWWlGbQhyxfYMptjM4FVLKC2iMn/dPpak=
Date:   Mon, 17 Oct 2022 13:36:55 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        william.kucharski@oracle.com, vbabka@suse.cz,
        songmuchun@bytedance.com, peterx@redhat.com,
        mike.kravetz@oracle.com, lkp@intel.com, hughd@google.com,
        ebiederm@xmission.com, dhowells@redhat.com, ccross@google.com,
        arnd@arndb.de, sidhartha.kumar@oracle.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-hugetlb-add-hugetlb_folio_subpool-helpers.patch added to mm-unstable branch
Message-Id: <20221017203656.06584C433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/hugetlb: add hugetlb_folio_subpool() helpers
has been added to the -mm mm-unstable branch.  Its filename is
     mm-hugetlb-add-hugetlb_folio_subpool-helpers.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-hugetlb-add-hugetlb_folio_subpool-helpers.patch

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
Subject: mm/hugetlb: add hugetlb_folio_subpool() helpers
Date: Thu, 22 Sep 2022 10:42:05 -0500

Allow hugetlbfs_migrate_folio to check and read subpool information by
passing in a folio.

Link: https://lkml.kernel.org/r/20220922154207.1575343-4-sidhartha.kumar@oracle.com
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

 fs/hugetlbfs/inode.c    |    8 ++++----
 include/linux/hugetlb.h |   15 +++++++++++++--
 2 files changed, 17 insertions(+), 6 deletions(-)

--- a/fs/hugetlbfs/inode.c~mm-hugetlb-add-hugetlb_folio_subpool-helpers
+++ a/fs/hugetlbfs/inode.c
@@ -1091,10 +1091,10 @@ static int hugetlbfs_migrate_folio(struc
 	if (rc != MIGRATEPAGE_SUCCESS)
 		return rc;
 
-	if (hugetlb_page_subpool(&src->page)) {
-		hugetlb_set_page_subpool(&dst->page,
-					hugetlb_page_subpool(&src->page));
-		hugetlb_set_page_subpool(&src->page, NULL);
+	if (hugetlb_folio_subpool(src)) {
+		hugetlb_set_folio_subpool(dst,
+					hugetlb_folio_subpool(src));
+		hugetlb_set_folio_subpool(src, NULL);
 	}
 
 	if (mode != MIGRATE_SYNC_NO_COPY)
--- a/include/linux/hugetlb.h~mm-hugetlb-add-hugetlb_folio_subpool-helpers
+++ a/include/linux/hugetlb.h
@@ -718,18 +718,29 @@ extern unsigned int default_hstate_idx;
 
 #define default_hstate (hstates[default_hstate_idx])
 
+static inline struct hugepage_subpool *hugetlb_folio_subpool(struct folio *folio)
+{
+	return (void *)folio_get_private_1(folio);
+}
+
 /*
  * hugetlb page subpool pointer located in hpage[1].private
  */
 static inline struct hugepage_subpool *hugetlb_page_subpool(struct page *hpage)
 {
-	return (void *)page_private(hpage + SUBPAGE_INDEX_SUBPOOL);
+	return hugetlb_folio_subpool(page_folio(hpage));
+}
+
+static inline void hugetlb_set_folio_subpool(struct folio *folio,
+					struct hugepage_subpool *subpool)
+{
+	folio_set_private_1(folio, (unsigned long)subpool);
 }
 
 static inline void hugetlb_set_page_subpool(struct page *hpage,
 					struct hugepage_subpool *subpool)
 {
-	set_page_private(hpage + SUBPAGE_INDEX_SUBPOOL, (unsigned long)subpool);
+	hugetlb_set_folio_subpool(page_folio(hpage), subpool);
 }
 
 static inline struct hstate *hstate_file(struct file *f)
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

