Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 91FBBC433ED
	for <mm-commits@archiver.kernel.org>; Wed,  5 May 2021 01:37:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7801861421
	for <mm-commits@archiver.kernel.org>; Wed,  5 May 2021 01:37:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232089AbhEEBip (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 4 May 2021 21:38:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:41712 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231680AbhEEBio (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 4 May 2021 21:38:44 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id EB47E610A1;
        Wed,  5 May 2021 01:37:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1620178669;
        bh=EEu1Nzq+63IfnjCRqDwwzLxLUhd4iQT/p1zYPZc1J+Q=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=T04C/0Q0S4nGiooKiJKc+JTmHUrWv4E/+6NOqh6mScj6Q/L+SjPBplTvQMcWXWvrK
         yUENkbB1Lmt9lx6VyrteEVOHwvMY8LzEp54YWrV8nTp/EP9VXPlfVaE2aDyE2+Lpz9
         bcvLNAIE/T4IxoKePNtRWa2JKsSwYm3dvCYngn9g=
Date:   Tue, 04 May 2021 18:37:48 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, cy.fan@huawei.com, david@redhat.com,
        hughd@google.com, linux-mm@kvack.org, mm-commits@vger.kernel.org,
        torvalds@linux-foundation.org
Subject:  [patch 095/143] mm/ksm: remove unused parameter from
 remove_trailing_rmap_items()
Message-ID: <20210505013748.zN1AXF6bd%akpm@linux-foundation.org>
In-Reply-To: <20210504183219.a3cc46aee4013d77402276c5@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Chengyang Fan <cy.fan@huawei.com>
Subject: mm/ksm: remove unused parameter from remove_trailing_rmap_items()

Since commit 6514d511dbe5 ("ksm: singly-linked rmap_list") was merged,
remove_trailing_rmap_items() doesn't use the 'mm_slot' parameter.  So
remove it, and update caller accordingly.

Link: https://lkml.kernel.org/r/20210330121320.1693474-1-cy.fan@huawei.com
Signed-off-by: Chengyang Fan <cy.fan@huawei.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Cc: Hugh Dickins <hughd@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/ksm.c |    7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

--- a/mm/ksm.c~mm-ksm-remove-unused-parameter-from-remove_trailing_rmap_items
+++ a/mm/ksm.c
@@ -815,8 +815,7 @@ out:
 	cond_resched();		/* we're called from many long loops */
 }
 
-static void remove_trailing_rmap_items(struct mm_slot *mm_slot,
-				       struct rmap_item **rmap_list)
+static void remove_trailing_rmap_items(struct rmap_item **rmap_list)
 {
 	while (*rmap_list) {
 		struct rmap_item *rmap_item = *rmap_list;
@@ -987,7 +986,7 @@ static int unmerge_and_remove_all_rmap_i
 				goto error;
 		}
 
-		remove_trailing_rmap_items(mm_slot, &mm_slot->rmap_list);
+		remove_trailing_rmap_items(&mm_slot->rmap_list);
 		mmap_read_unlock(mm);
 
 		spin_lock(&ksm_mmlist_lock);
@@ -2333,7 +2332,7 @@ next_mm:
 	 * Nuke all the rmap_items that are above this current rmap:
 	 * because there were no VM_MERGEABLE vmas with such addresses.
 	 */
-	remove_trailing_rmap_items(slot, ksm_scan.rmap_list);
+	remove_trailing_rmap_items(ksm_scan.rmap_list);
 
 	spin_lock(&ksm_mmlist_lock);
 	ksm_scan.mm_slot = list_entry(slot->mm_list.next,
_
