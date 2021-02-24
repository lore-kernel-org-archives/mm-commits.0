Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1DF41C433E6
	for <mm-commits@archiver.kernel.org>; Wed, 24 Feb 2021 20:11:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CE93964E09
	for <mm-commits@archiver.kernel.org>; Wed, 24 Feb 2021 20:11:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235483AbhBXUKf (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 24 Feb 2021 15:10:35 -0500
Received: from mail.kernel.org ([198.145.29.99]:33332 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235382AbhBXUJw (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 24 Feb 2021 15:09:52 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9430364EC3;
        Wed, 24 Feb 2021 20:09:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1614197348;
        bh=lFbVt0vxQbWNFTZr7by1YJiXlS0bmT0HIfAulncMONc=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=aGXKVx2Wg9YzDKxelFFWD46mA357KjNkd3juLoGxhhEqalEYruJ+2yEz/52154tsz
         EyVIEW3Wp1o6alN8tKLgsdXmZ9s5t4HSyjAzJVF+j2y5Ct5AaVstTg41U7MbBGQj2m
         jpuwO20J7RhMAkp4pJ0SJ9SCrGVe5eFIJ0w3R81U=
Date:   Wed, 24 Feb 2021 12:09:08 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, linux-mm@kvack.org, mhocko@suse.com,
        mike.kravetz@oracle.com, mm-commits@vger.kernel.org,
        torvalds@linux-foundation.org
Subject:  [patch 150/173] include/linux/hugetlb.h: add
 synchronization information for new hugetlb specific flags
Message-ID: <20210224200908.vZa9u-els%akpm@linux-foundation.org>
In-Reply-To: <20210224115824.1e289a6895087f10c41dd8d6@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
