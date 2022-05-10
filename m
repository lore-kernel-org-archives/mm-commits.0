Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4FA75C433EF
	for <mm-commits@archiver.kernel.org>; Tue, 10 May 2022 01:11:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234019AbiEJBP3 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 9 May 2022 21:15:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55566 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234112AbiEJBPX (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 9 May 2022 21:15:23 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 769635403A
        for <mm-commits@vger.kernel.org>; Mon,  9 May 2022 18:11:27 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0FB6B61590
        for <mm-commits@vger.kernel.org>; Tue, 10 May 2022 01:11:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 635A2C385C2;
        Tue, 10 May 2022 01:11:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1652145086;
        bh=1QVqlVdODpZ/w4IggzlDh/OU5ydo/sN5txzKiUwairA=;
        h=Date:To:From:Subject:From;
        b=qj8KbU0tMsTeRZIjsu+/aDuQOxJ5DZl3AzI+RhEI3Cp8AkFTBVQhz82/1Xtkg6tw6
         36qYO8DZSPFv3Di7ZejEuOM12de/6e6cB4nVbyyH61jIYXgUfo71o5g71FtDjrl/7Y
         O5K158yLqCvnF1zAFrR5fzgfFOViYESXVZI5F+wY=
Date:   Mon, 09 May 2022 18:11:25 -0700
To:     mm-commits@vger.kernel.org, richard.weiyang@gmail.com,
        akpm@linux-foundation.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-vmscan-not-necessary-to-re-init-the-list-for-each-iteration-fix.patch removed from -mm tree
Message-Id: <20220510011126.635A2C385C2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm-vmscan-not-necessary-to-re-init-the-list-for-each-iteration-fix
has been removed from the -mm tree.  Its filename was
     mm-vmscan-not-necessary-to-re-init-the-list-for-each-iteration-fix.patch

This patch was dropped because it was folded into mm-vmscan-not-necessary-to-re-init-the-list-for-each-iteration.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-vmscan-not-necessary-to-re-init-the-list-for-each-iteration-fix

remove unneeded braces

Cc: Wei Yang <richard.weiyang@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/mm/vmscan.c~mm-vmscan-not-necessary-to-re-init-the-list-for-each-iteration-fix
+++ a/mm/vmscan.c
@@ -2572,9 +2572,8 @@ unsigned long reclaim_pages(struct list_
 
 	while (!list_empty(page_list)) {
 		page = lru_to_page(page_list);
-		if (nid == NUMA_NO_NODE) {
+		if (nid == NUMA_NO_NODE)
 			nid = page_to_nid(page);
-		}
 
 		if (nid == page_to_nid(page)) {
 			ClearPageActive(page);
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-check-against-orig_pte-for-finish_fault-fix-checkpatch-fixes.patch
mm-hugetlb-only-drop-uffd-wp-special-pte-if-required-fix-fix.patch
lib-kstrtoxc-add-false-true-support-to-kstrtobool-fix.patch
mm-vmscan-not-necessary-to-re-init-the-list-for-each-iteration.patch
mm-make-minimum-slab-alignment-a-runtime-property-fix.patch
proc-fix-dentry-inode-overinstantiating-under-proc-pid-net-checkpatch-fixes.patch
linux-next-rejects.patch
linux-next-git-rejects.patch
mm-oom_killc-fix-vm_oom_kill_table-ifdeffery.patch

