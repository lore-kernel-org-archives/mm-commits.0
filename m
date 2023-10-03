Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0E5CEE7AD77
	for <mm-commits@archiver.kernel.org>; Tue,  3 Oct 2023 16:52:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240064AbjJCQwF (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 3 Oct 2023 12:52:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49478 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231620AbjJCQwD (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 3 Oct 2023 12:52:03 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 576D19B
        for <mm-commits@vger.kernel.org>; Tue,  3 Oct 2023 09:52:00 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E4172C433C8;
        Tue,  3 Oct 2023 16:51:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1696351920;
        bh=0zESQocjAj7BK45KKL5F7AKEnG9aqPjD+MUt7mBAaHI=;
        h=Date:To:From:Subject:From;
        b=Cu9IhWcST+uShDgySGDsf/LWKfACp6WI/8JHYnj5icmBLtKkEwrnXq2RxUzCa+v4e
         n4DBfYw3aCWTbTCAcJ3MbluV4kvuOw8L6dloaxryEVpf5f8b6EWLukv963YGPfbGz4
         WWa1W1adn++OzClgZN/K4JPr/Dp4aS3kXgmo3VwY=
Date:   Tue, 03 Oct 2023 09:51:59 -0700
To:     mm-commits@vger.kernel.org, Jonathan.Cameron@huawei.com,
        gregory.price@memverge.com, arnd@arndb.de,
        gourry.memverge@gmail.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-migrate-remove-unused-mm-argument-from-do_move_pages_to_node.patch added to mm-unstable branch
Message-Id: <20231003165159.E4172C433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/migrate: remove unused mm argument from do_move_pages_to_node
has been added to the -mm mm-unstable branch.  Its filename is
     mm-migrate-remove-unused-mm-argument-from-do_move_pages_to_node.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-migrate-remove-unused-mm-argument-from-do_move_pages_to_node.patch

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

mm-migrate-fix-do_pages_move-for-compat-pointers.patch
mm-migrate-remove-unused-mm-argument-from-do_move_pages_to_node.patch

