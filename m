Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DAF01C433B4
	for <mm-commits@archiver.kernel.org>; Sat,  8 May 2021 22:49:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C1F346101D
	for <mm-commits@archiver.kernel.org>; Sat,  8 May 2021 22:49:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229647AbhEHWum (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 8 May 2021 18:50:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:35920 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229577AbhEHWul (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sat, 8 May 2021 18:50:41 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 69E776100C;
        Sat,  8 May 2021 22:49:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1620514179;
        bh=NrCTsx/im2TwHZkHZKPtZ372dit6+JdZ43CtTZ9bFAc=;
        h=Date:From:To:Subject:From;
        b=OTTiFwHy+tADaTSyX7F/0OBBLS1ZuE4ivBGIsenKoxCnOmu9WkIRaGAqbvwGRYGRb
         F2TWfxzUZHG7ZLQm6Nhh0JDkwucEwfJ+5nlic8VJaBDCe+TJdQMu3kuhIu3U9xKrJm
         8GK9haFYfhATktUbpt8VGQktuOIObPQjliSr1mVw=
Date:   Sat, 08 May 2021 15:49:39 -0700
From:   akpm@linux-foundation.org
To:     cy.fan@huawei.com, david@redhat.com, hughd@google.com,
        mm-commits@vger.kernel.org
Subject:  [merged]
 mm-ksm-remove-unused-parameter-from-remove_trailing_rmap_items.patch
 removed from -mm tree
Message-ID: <20210508224939.ts7ToOPfl%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/ksm: remove unused parameter from remove_trailing_rmap_items()
has been removed from the -mm tree.  Its filename was
     mm-ksm-remove-unused-parameter-from-remove_trailing_rmap_items.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
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

Patches currently in -mm which might be from cy.fan@huawei.com are


