Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E7D94C6379F
	for <mm-commits@archiver.kernel.org>; Wed, 15 Feb 2023 20:59:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230157AbjBOU7V (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 15 Feb 2023 15:59:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52970 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230368AbjBOU6x (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 15 Feb 2023 15:58:53 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB66F55A5
        for <mm-commits@vger.kernel.org>; Wed, 15 Feb 2023 12:56:28 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 66187B823BA
        for <mm-commits@vger.kernel.org>; Wed, 15 Feb 2023 20:55:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F2B71C433D2;
        Wed, 15 Feb 2023 20:55:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1676494534;
        bh=+IsG8UdO8Co8lWlzsCgpA+mtZNRClV+nYbfw+w4W1DE=;
        h=Date:To:From:Subject:From;
        b=VS5XGsuT0kOfXxJekPjhY4GDXuHeubEmtFPmcL6xE3NMeaRw0FIgwB9Iai8P1U/5I
         qstkiRNJCE0G46QnN+JYcZ4B9+EuCYbKJ9gUvjWe+LudDIqAbkcbZtBouQBMnSitKk
         3Q+orQZaaEM+ar14GwrMaw34oKCAWFIQjFz/CsWg=
Date:   Wed, 15 Feb 2023 12:55:33 -0800
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        torvalds@linux-foundation.org, sj@kernel.org,
        mike.kravetz@oracle.com, david@redhat.com,
        baolin.wang@linux.alibaba.com, akpm@linux-foundation.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-hugetlb-change-to-return-bool-for-isolate_hugetlb-fix.patch added to mm-unstable branch
Message-Id: <20230215205533.F2B71C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm-hugetlb-change-to-return-bool-for-isolate_hugetlb-fix
has been added to the -mm mm-unstable branch.  Its filename is
     mm-hugetlb-change-to-return-bool-for-isolate_hugetlb-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-hugetlb-change-to-return-bool-for-isolate_hugetlb-fix.patch

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
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-hugetlb-change-to-return-bool-for-isolate_hugetlb-fix
Date: Wed Feb 15 12:53:56 PM PST 2023

shorten locked section, per SeongJae Park

Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: SeongJae Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/hugetlb.c~mm-hugetlb-change-to-return-bool-for-isolate_hugetlb-fix
+++ a/mm/hugetlb.c
@@ -2933,8 +2933,8 @@ retry:
 		 */
 		spin_unlock_irq(&hugetlb_lock);
 		isolated = isolate_hugetlb(old_folio, list);
-		spin_lock_irq(&hugetlb_lock);
 		ret = isolated ? 0 : -EBUSY;
+		spin_lock_irq(&hugetlb_lock);
 		goto free_new;
 	} else if (!folio_test_hugetlb_freed(old_folio)) {
 		/*
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

lib-stackdepot-mm-rename-stack_depot_want_early_init-fix.patch
lib-stackdepot-move-documentation-comments-to-stackdepoth-fix.patch
mm-hugetlb-change-to-return-bool-for-isolate_hugetlb-fix.patch

