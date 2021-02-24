Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 01986C433DB
	for <mm-commits@archiver.kernel.org>; Wed, 24 Feb 2021 02:08:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9CBA264EB6
	for <mm-commits@archiver.kernel.org>; Wed, 24 Feb 2021 02:08:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230386AbhBXCIO (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 23 Feb 2021 21:08:14 -0500
Received: from mail.kernel.org ([198.145.29.99]:53940 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229954AbhBXCIN (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 23 Feb 2021 21:08:13 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id EC0FB64DB1;
        Wed, 24 Feb 2021 02:07:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1614132453;
        bh=ukZplcxbswyb34ZZYRrtXX5eGDARK5/51aHW/vv0ygM=;
        h=Date:From:To:Subject:From;
        b=ZDM6e3spIoXDa/W+hnqMuRQCqP8Wb5Ach6hwDfGtDIRvX/rFMqcE9XKFRee77EATk
         poAShbbZun0jdz5oqct7+BJlN3O2fXMWgTiC2IUmNnt5crNrB/FQosbyDH1xX+Ya+H
         BwDdjIcLHzTNfIn/qEqj/fj4BAHuNLSk89Mv6SOU=
Date:   Tue, 23 Feb 2021 18:07:32 -0800
From:   akpm@linux-foundation.org
To:     mhocko@suse.com, mike.kravetz@oracle.com,
        mm-commits@vger.kernel.org
Subject:  +
 =?US-ASCII?Q?include-linux-hugetlbh-add-synchronization-information-for-?=
 =?US-ASCII?Q?new-hugetlb-specific-flags.patch?= added to -mm tree
Message-ID: <20210224020732.48u3n5zSi%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: include/linux/hugetlb.h: add synchronization information for new hugetlb specific flags
has been added to the -mm tree.  Its filename is
     include-linux-hugetlbh-add-synchronization-information-for-new-hugetlb-specific-flags.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/include-linux-hugetlbh-add-synchronization-information-for-new-hugetlb-specific-flags.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/include-linux-hugetlbh-add-synchronization-information-for-new-hugetlb-specific-flags.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Mike Kravetz <mike.kravetz@oracle.com>
Subject: include/linux/hugetlb.h: add synchronization information for new hugetlb specific flags

Add comments, no functional change.

Link: https://lkml.kernel.org/r/62a80585-2a73-10cc-4a2d-5721540d4ad2@oracle.com
Signed-off-by: Mike Kravetz <mike.kravetz@oracle.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/hugetlb.h |   10 ++++++++++
 1 file changed, 10 insertions(+)

--- a/include/linux/hugetlb.h~include-linux-hugetlbh-add-synchronization-information-for-new-hugetlb-specific-flags
+++ a/include/linux/hugetlb.h
@@ -480,14 +480,24 @@ unsigned long hugetlb_get_unmapped_area(
  * HPG_restore_reserve - Set when a hugetlb page consumes a reservation at
  *	allocation time.  Cleared when page is fully instantiated.  Free
  *	routine checks flag to restore a reservation on error paths.
+ *	Synchronization:  Examined or modified by code that knows it has
+ *	the only reference to page.  i.e. After allocation but before use
+ *	or when the page is being freed.
  * HPG_migratable  - Set after a newly allocated page is added to the page
  *	cache and/or page tables.  Indicates the page is a candidate for
  *	migration.
+ *	Synchronization:  Initially set after new page allocation with no
+ *	locking.  When examined and modified during migration processing
+ *	(isolate, migrate, putback) the hugetlb_lock is held.
  * HPG_temporary - - Set on a page that is temporarily allocated from the buddy
  *	allocator.  Typically used for migration target pages when no pages
  *	are available in the pool.  The hugetlb free page path will
  *	immediately free pages with this flag set to the buddy allocator.
+ *	Synchronization: Can be set after huge page allocation from buddy when
+ *	code knows it has only reference.  All other examinations and
+ *	modifications require hugetlb_lock.
  * HPG_freed - Set when page is on the free lists.
+ *	Synchronization: hugetlb_lock held for examination and modification.
  */
 enum hugetlb_page_flags {
 	HPG_restore_reserve = 0,
_

Patches currently in -mm which might be from mike.kravetz@oracle.com are

hugetlb-fix-update_and_free_page-contig-page-struct-assumption.patch
hugetlb-fix-copy_huge_page_from_user-contig-page-struct-assumption.patch
hugetlb-use-pageprivate-for-hugetlb-specific-page-flags.patch
hugetlb-use-pageprivate-for-hugetlb-specific-page-flags-fix.patch
hugetlb-convert-page_huge_active-hpagemigratable-flag.patch
hugetlb-convert-pagehugetemporary-to-hpagetemporary-flag.patch
hugetlb-convert-pagehugefreed-to-hpagefreed-flag.patch
include-linux-hugetlbh-add-synchronization-information-for-new-hugetlb-specific-flags.patch
mm-hugetlb-change-hugetlb_reserve_pages-to-type-bool.patch
hugetlbfs-remove-special-hugetlbfs_set_page_dirty.patch

