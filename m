Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 47662C433DB
	for <mm-commits@archiver.kernel.org>; Thu, 25 Feb 2021 19:35:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F423664F2A
	for <mm-commits@archiver.kernel.org>; Thu, 25 Feb 2021 19:35:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234017AbhBYTfW (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 25 Feb 2021 14:35:22 -0500
Received: from mail.kernel.org ([198.145.29.99]:41334 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235080AbhBYTc7 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 25 Feb 2021 14:32:59 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8C23A64FB2;
        Thu, 25 Feb 2021 19:18:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1614280704;
        bh=xJOD53YWy5SwCMmBQ9TUpk+3XwZAvauJV8lPJ2XEv2c=;
        h=Date:From:To:Subject:From;
        b=0mSy4qKABPpLm5e0rbbL3KnaNMRfi695TS9q9MArU9VI2fDi2UX2a56wAT+1XeBhe
         kaLgKq8NZkqZ/QhrMJB/cAG+8rEox5Dl1qviQOhJ5rjvJ1igvKvsbItNU/Lm7DCLAJ
         gak3IxX0Dv0hh28sX4GyiAJSEsbLzq8R4p8sDSnc=
Date:   Thu, 25 Feb 2021 11:18:24 -0800
From:   akpm@linux-foundation.org
To:     mhocko@suse.com, mike.kravetz@oracle.com,
        mm-commits@vger.kernel.org
Subject:  [merged]
 =?US-ASCII?Q?include-linux-hugetlbh-add-synchronization-information-for-?=
 =?US-ASCII?Q?new-hugetlb-specific-flags.patch?= removed from -mm tree
Message-ID: <20210225191824.RG8ns5lS_%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: include/linux/hugetlb.h: add synchronization information for new hugetlb specific flags
has been removed from the -mm tree.  Its filename was
     include-linux-hugetlbh-add-synchronization-information-for-new-hugetlb-specific-flags.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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


