Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 23D43C6379F
	for <mm-commits@archiver.kernel.org>; Mon, 20 Feb 2023 20:45:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229535AbjBTUpn (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 20 Feb 2023 15:45:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37382 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231396AbjBTUpU (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 20 Feb 2023 15:45:20 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2221F55B2
        for <mm-commits@vger.kernel.org>; Mon, 20 Feb 2023 12:44:47 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C78A2B80DC8
        for <mm-commits@vger.kernel.org>; Mon, 20 Feb 2023 20:44:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6688FC433EF;
        Mon, 20 Feb 2023 20:44:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1676925884;
        bh=VxEVxxv+J0LbiIZWYlOfLZjl5ZvxcWvKuJwcvC7Vt6M=;
        h=Date:To:From:Subject:From;
        b=GNV9EeOy3R1YXuHaL18+u9rWrJs9u3/8s74iEBJCFZXRpX/3/D5rRpAKb5ozrAvlF
         wFJnoHQY91RRzF93s8876QG0D6x2oSsIo6lCI7h2OYcqpPCzl9aJGvqDTCFIJMBxPE
         Dmfmooej0Td1DcAGYIHPSkfVowaxNyHnABu9NoNw=
Date:   Mon, 20 Feb 2023 12:44:43 -0800
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        torvalds@linux-foundation.org, sj@kernel.org,
        mike.kravetz@oracle.com, david@redhat.com,
        baolin.wang@linux.alibaba.com, akpm@linux-foundation.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-hugetlb-change-to-return-bool-for-isolate_hugetlb-fix.patch removed from -mm tree
Message-Id: <20230220204444.6688FC433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm-hugetlb-change-to-return-bool-for-isolate_hugetlb-fix
has been removed from the -mm tree.  Its filename was
     mm-hugetlb-change-to-return-bool-for-isolate_hugetlb-fix.patch

This patch was dropped because it was folded into mm-hugetlb-change-to-return-bool-for-isolate_hugetlb.patch

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

mm-hugetlb-change-to-return-bool-for-isolate_hugetlb.patch
mm-change-to-return-bool-for-isolate_movable_page-fix.patch
include-linux-migrateh-remove-unneeded-externs.patch

