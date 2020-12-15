Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0B699C47438
	for <mm-commits@archiver.kernel.org>; Tue, 15 Dec 2020 23:59:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D358422D2B
	for <mm-commits@archiver.kernel.org>; Tue, 15 Dec 2020 23:59:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726598AbgLOX7c (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 15 Dec 2020 18:59:32 -0500
Received: from mail.kernel.org ([198.145.29.99]:60886 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729044AbgLOXZG (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 15 Dec 2020 18:25:06 -0500
Date:   Tue, 15 Dec 2020 15:22:39 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1608074559;
        bh=K9BOsS8W1cVU+ZiXeuRir1uVdCjlqbs6QYQvf566/Nk=;
        h=From:To:Subject:From;
        b=ViBr7N0VLhfTH70vAY38o3S+B9IY9Vc1LHxpJkUwiPcIkTYNHVCrfVRyy0SmoqyLn
         Dk/1DWN7lJqwdKQ+LILqG77m/S6WBX3WWe9pVEZrYqNWZ1CvaZC8RRv8GI7ysLm/K+
         3k+5SVS0NXxnT65p3hC8dBYLO8HTgtNDoCX8bYI8=
From:   akpm@linux-foundation.org
To:     david@redhat.com, mike.kravetz@oracle.com,
        mm-commits@vger.kernel.org, osalvador@suse.de
Subject:  [merged] mmhugetlb-remove-unneded-initialization.patch
 removed from -mm tree
Message-ID: <20201215232239.iDO0v2WdN%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm,hugetlb: remove unneeded initialization
has been removed from the -mm tree.  Its filename was
     mmhugetlb-remove-unneded-initialization.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Oscar Salvador <osalvador@suse.de>
Subject: mm,hugetlb: remove unneeded initialization

hugetlb_add_hstate initializes nr_huge_pages and free_huge_pages to 0, but
since hstates[] is a global variable, all its fields are defined to 0
already.

Link: https://lkml.kernel.org/r/20201119112141.6452-1-osalvador@suse.de
Signed-off-by: Oscar Salvador <osalvador@suse.de>
Reviewed-by: Mike Kravetz <mike.kravetz@oracle.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |    2 --
 1 file changed, 2 deletions(-)

--- a/mm/hugetlb.c~mmhugetlb-remove-unneded-initialization
+++ a/mm/hugetlb.c
@@ -3198,8 +3198,6 @@ void __init hugetlb_add_hstate(unsigned
 	h = &hstates[hugetlb_max_hstate++];
 	h->order = order;
 	h->mask = ~((1ULL << (order + PAGE_SHIFT)) - 1);
-	h->nr_huge_pages = 0;
-	h->free_huge_pages = 0;
 	for (i = 0; i < MAX_NUMNODES; ++i)
 		INIT_LIST_HEAD(&h->hugepage_freelists[i]);
 	INIT_LIST_HEAD(&h->hugepage_activelist);
_

Patches currently in -mm which might be from osalvador@suse.de are


