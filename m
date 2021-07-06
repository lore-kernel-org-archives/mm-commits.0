Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 72D48C07E96
	for <mm-commits@archiver.kernel.org>; Tue,  6 Jul 2021 19:18:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5D5D361C97
	for <mm-commits@archiver.kernel.org>; Tue,  6 Jul 2021 19:18:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231701AbhGFTVc (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 6 Jul 2021 15:21:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:55322 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230031AbhGFTVc (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 6 Jul 2021 15:21:32 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7BC1B61C91;
        Tue,  6 Jul 2021 19:18:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1625599132;
        bh=SfQcr9UgNW2dtUJlvM0Q46tUaC5WD28EAH7lZVvQY6k=;
        h=Date:From:To:Subject:From;
        b=C7/cEx77Y4Sn4Nbs3eE6guDysQhojkwZVrQUBEvUDjIWN8D5bVGtYBiOJXE87BJqo
         ZlWfC9s1+CQviyZIt053sXRWs3+fBNFZBcO0omAVNUsFuX4OFf4KpJjNQzG1KKuFks
         uxwptqSOjGaOL7g02B0djBua8meHuufAGPG/iFjE=
Date:   Tue, 06 Jul 2021 12:18:52 -0700
From:   akpm@linux-foundation.org
To:     david@redhat.com, liu.xiang@zlingsmart.com,
        mm-commits@vger.kernel.org
Subject:  [merged]
 mm-compaction-remove-duplicate-list_emptysublist-check.patch removed from
 -mm tree
Message-ID: <20210706191852.sk8HEFMLc%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: compaction: remove duplicate !list_empty(&sublist) check
has been removed from the -mm tree.  Its filename was
     mm-compaction-remove-duplicate-list_emptysublist-check.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Liu Xiang <liu.xiang@zlingsmart.com>
Subject: mm: compaction: remove duplicate !list_empty(&sublist) check

The list_splice_tail(&sublist, freelist) also do !list_empty(&sublist)
check, so remove the duplicate call.

Link: https://lkml.kernel.org/r/20210609095409.19920-1-liu.xiang@zlingsmart.com
Signed-off-by: Liu Xiang <liu.xiang@zlingsmart.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/compaction.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

--- a/mm/compaction.c~mm-compaction-remove-duplicate-list_emptysublist-check
+++ a/mm/compaction.c
@@ -1297,8 +1297,7 @@ move_freelist_head(struct list_head *fre
 
 	if (!list_is_last(freelist, &freepage->lru)) {
 		list_cut_before(&sublist, freelist, &freepage->lru);
-		if (!list_empty(&sublist))
-			list_splice_tail(&sublist, freelist);
+		list_splice_tail(&sublist, freelist);
 	}
 }
 
@@ -1315,8 +1314,7 @@ move_freelist_tail(struct list_head *fre
 
 	if (!list_is_first(freelist, &freepage->lru)) {
 		list_cut_position(&sublist, freelist, &freepage->lru);
-		if (!list_empty(&sublist))
-			list_splice_tail(&sublist, freelist);
+		list_splice_tail(&sublist, freelist);
 	}
 }
 
_

Patches currently in -mm which might be from liu.xiang@zlingsmart.com are


