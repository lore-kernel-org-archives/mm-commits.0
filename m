Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 96189C433DB
	for <mm-commits@archiver.kernel.org>; Wed, 31 Mar 2021 04:51:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 58E78619A7
	for <mm-commits@archiver.kernel.org>; Wed, 31 Mar 2021 04:51:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229959AbhCaEvU (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 31 Mar 2021 00:51:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:35768 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233558AbhCaEu6 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 31 Mar 2021 00:50:58 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9C78161952;
        Wed, 31 Mar 2021 04:50:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1617166257;
        bh=r2jSE1ibzYWl1jIvwtLU2GmDG9Rcb8+2aPEfWymK2jQ=;
        h=Date:From:To:Subject:From;
        b=ucCeZG0jm2UCT/wK5qkAA4XZ4T57GAKxJpl8WuU7G0QDtJk15rik5SsvMEJXMXl0i
         PeW6TI4ZLe1vWiYZfwU146CJwG11mMjafc5VPbwCOe8n6L2PmGVCrDrkiaIuIW9hVi
         eCAlx/adJ7FB7O5WslM2Ea3Hv619hI6DAXXYQZ+Y=
Date:   Tue, 30 Mar 2021 21:50:57 -0700
From:   akpm@linux-foundation.org
To:     cy.fan@huawei.com, hughd@google.com, mm-commits@vger.kernel.org
Subject:  +
 mm-ksm-remove-unused-parameter-from-remove_trailing_rmap_items.patch added
 to -mm tree
Message-ID: <20210331045057.ypyuHg4lB%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/ksm: remove unused parameter from remove_trailing_rmap_items()
has been added to the -mm tree.  Its filename is
     mm-ksm-remove-unused-parameter-from-remove_trailing_rmap_items.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-ksm-remove-unused-parameter-from-remove_trailing_rmap_items.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-ksm-remove-unused-parameter-from-remove_trailing_rmap_items.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Chengyang Fan <cy.fan@huawei.com>
Subject: mm/ksm: remove unused parameter from remove_trailing_rmap_items()

Since commit 6514d511dbe5 ("ksm: singly-linked rmap_list") was merged,
remove_trailing_rmap_items() doesn't use the 'mm_slot' parameter.  So
remove it, and update caller accordingly.

Link: https://lkml.kernel.org/r/20210330121320.1693474-1-cy.fan@huawei.com
Signed-off-by: Chengyang Fan <cy.fan@huawei.com>
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

mm-ksm-remove-unused-parameter-from-remove_trailing_rmap_items.patch

