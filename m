Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B202DC433DB
	for <mm-commits@archiver.kernel.org>; Wed, 24 Feb 2021 04:29:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5E13564E6F
	for <mm-commits@archiver.kernel.org>; Wed, 24 Feb 2021 04:29:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232761AbhBXE3k (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 23 Feb 2021 23:29:40 -0500
Received: from mail.kernel.org ([198.145.29.99]:54948 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232446AbhBXE3j (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 23 Feb 2021 23:29:39 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id E33F464E60;
        Wed, 24 Feb 2021 04:28:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1614140939;
        bh=9DsVTzTqUapN/iE5DG8PBWMsADvZ8Llz/q4wlcO87A0=;
        h=Date:From:To:Subject:From;
        b=G64OmbGV6z+vkbw2ZlCH0zsOerPKW5gvfq4ro0t2yBqBfJJY/Nv5fx5PJJWoHeQF3
         FidmPN8n5eVHPsPbWuf/EpObXBcqCFwd4bc9kihYC45V6RF5S1bsPN9/BlS1sOXcU8
         tzujQWgjv2USXKWAtCKhzFHJvFnIJWQ3n4cIhC6o=
Date:   Tue, 23 Feb 2021 20:28:58 -0800
From:   akpm@linux-foundation.org
To:     mhocko@suse.com, mike.kravetz@oracle.com,
        mm-commits@vger.kernel.org, osalvador@suse.de,
        songmuchun@bytedance.com
Subject:  +
 hugetlb-use-pageprivate-for-hugetlb-specific-page-flags-fix-2.patch added
 to -mm tree
Message-ID: <20210224042858.x12k3SMNe%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: hugetlb: document the new location of page subpool pointer
has been added to the -mm tree.  Its filename is
     hugetlb-use-pageprivate-for-hugetlb-specific-page-flags-fix-2.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/hugetlb-use-pageprivate-for-hugetlb-specific-page-flags-fix-2.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/hugetlb-use-pageprivate-for-hugetlb-specific-page-flags-fix-2.patch

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
Subject: hugetlb: document the new location of page subpool pointer

Expand comments, no functional change.

Link: https://lkml.kernel.org/r/20210224040439.351882-1-mike.kravetz@oracle.com
Signed-off-by: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Muchun Song <songmuchun@bytedance.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/hugetlb.h |    3 +++
 1 file changed, 3 insertions(+)

--- a/include/linux/hugetlb.h~hugetlb-use-pageprivate-for-hugetlb-specific-page-flags-fix-2
+++ a/include/linux/hugetlb.h
@@ -476,6 +476,9 @@ unsigned long hugetlb_get_unmapped_area(
  * huegtlb page specific state flags.  These flags are located in page.private
  * of the hugetlb head page.  Functions created via the below macros should be
  * used to manipulate these flags.
+ * Note: The hugetlb page subpool pointer previously located at page.private
+ * was moved to page[1].private to make room for flags in the head page.  See
+ * hugetlb_page_subpool().
  *
  * HPG_restore_reserve - Set when a hugetlb page consumes a reservation at
  *	allocation time.  Cleared when page is fully instantiated.  Free
_

Patches currently in -mm which might be from mike.kravetz@oracle.com are

hugetlb-fix-update_and_free_page-contig-page-struct-assumption.patch
hugetlb-fix-copy_huge_page_from_user-contig-page-struct-assumption.patch
hugetlb-use-pageprivate-for-hugetlb-specific-page-flags.patch
hugetlb-use-pageprivate-for-hugetlb-specific-page-flags-fix.patch
hugetlb-use-pageprivate-for-hugetlb-specific-page-flags-fix-2.patch
hugetlb-convert-page_huge_active-hpagemigratable-flag.patch
hugetlb-convert-pagehugetemporary-to-hpagetemporary-flag.patch
hugetlb-convert-pagehugefreed-to-hpagefreed-flag.patch
include-linux-hugetlbh-add-synchronization-information-for-new-hugetlb-specific-flags.patch
mm-hugetlb-change-hugetlb_reserve_pages-to-type-bool.patch
hugetlbfs-remove-special-hugetlbfs_set_page_dirty.patch

