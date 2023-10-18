Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 67AF3CDB485
	for <mm-commits@archiver.kernel.org>; Wed, 18 Oct 2023 21:36:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231254AbjJRVgc (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 18 Oct 2023 17:36:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46878 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235253AbjJRVgG (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 18 Oct 2023 17:36:06 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 648AE181
        for <mm-commits@vger.kernel.org>; Wed, 18 Oct 2023 14:35:34 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2173FC43142;
        Wed, 18 Oct 2023 21:35:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1697664919;
        bh=I+sHppw9iGN6ZuTC8DgrNJ1lN5JEc7WwVdwnWQM1gj8=;
        h=Date:To:From:Subject:From;
        b=brx6IewlbuLd0lmU/0qBmlkMmhrkxb1mIQVrcGwyavsiQZsqd/n3L/xnY88n1RvZ+
         jqwCBMOyxAhmXeljSZpy1q1ZJmgoF5vGSmIDqO0IYrdBAhT/EE/HIebW7VyWF6+wLc
         dL5uQoWlagYpPVgKwZCLTZ4ofAHkGL/agTQ/d+1g=
Date:   Wed, 18 Oct 2023 14:35:18 -0700
To:     mm-commits@vger.kernel.org, Jonathan.Cameron@huawei.com,
        gregory.price@memverge.com, arnd@arndb.de,
        gourry.memverge@gmail.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-migrate-remove-unused-mm-argument-from-do_move_pages_to_node.patch removed from -mm tree
Message-Id: <20231018213519.2173FC43142@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/migrate: remove unused mm argument from do_move_pages_to_node
has been removed from the -mm tree.  Its filename was
     mm-migrate-remove-unused-mm-argument-from-do_move_pages_to_node.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Gregory Price <gourry.memverge@gmail.com>
Subject: mm/migrate: remove unused mm argument from do_move_pages_to_node
Date: Tue, 3 Oct 2023 10:48:57 -0400

This function does not actively use the mm_struct, it can be removed.

Link: https://lkml.kernel.org/r/20231003144857.752952-2-gregory.price@memverge.com
Signed-off-by: Gregory Price <gregory.price@memverge.com>
Reviewed-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Gregory Price <gregory.price@memverge.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/migrate.c |   13 ++++++-------
 1 file changed, 6 insertions(+), 7 deletions(-)

--- a/mm/migrate.c~mm-migrate-remove-unused-mm-argument-from-do_move_pages_to_node
+++ a/mm/migrate.c
@@ -2029,8 +2029,7 @@ static int store_status(int __user *stat
 	return 0;
 }
 
-static int do_move_pages_to_node(struct mm_struct *mm,
-		struct list_head *pagelist, int node)
+static int do_move_pages_to_node(struct list_head *pagelist, int node)
 {
 	int err;
 	struct migration_target_control mtc = {
@@ -2119,7 +2118,7 @@ out:
 	return err;
 }
 
-static int move_pages_and_store_status(struct mm_struct *mm, int node,
+static int move_pages_and_store_status(int node,
 		struct list_head *pagelist, int __user *status,
 		int start, int i, unsigned long nr_pages)
 {
@@ -2128,7 +2127,7 @@ static int move_pages_and_store_status(s
 	if (list_empty(pagelist))
 		return 0;
 
-	err = do_move_pages_to_node(mm, pagelist, node);
+	err = do_move_pages_to_node(pagelist, node);
 	if (err) {
 		/*
 		 * Positive err means the number of failed
@@ -2196,7 +2195,7 @@ static int do_pages_move(struct mm_struc
 			current_node = node;
 			start = i;
 		} else if (node != current_node) {
-			err = move_pages_and_store_status(mm, current_node,
+			err = move_pages_and_store_status(current_node,
 					&pagelist, status, start, i, nr_pages);
 			if (err)
 				goto out;
@@ -2231,7 +2230,7 @@ static int do_pages_move(struct mm_struc
 		if (err)
 			goto out_flush;
 
-		err = move_pages_and_store_status(mm, current_node, &pagelist,
+		err = move_pages_and_store_status(current_node, &pagelist,
 				status, start, i, nr_pages);
 		if (err) {
 			/* We have accounted for page i */
@@ -2243,7 +2242,7 @@ static int do_pages_move(struct mm_struc
 	}
 out_flush:
 	/* Make sure we do not overwrite the existing error */
-	err1 = move_pages_and_store_status(mm, current_node, &pagelist,
+	err1 = move_pages_and_store_status(current_node, &pagelist,
 				status, start, i, nr_pages);
 	if (err >= 0)
 		err = err1;
_

Patches currently in -mm which might be from gourry.memverge@gmail.com are


