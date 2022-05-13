Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9EF6CC433EF
	for <mm-commits@archiver.kernel.org>; Fri, 13 May 2022 19:22:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1383607AbiEMTWY (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 13 May 2022 15:22:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42564 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1383653AbiEMTWM (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 13 May 2022 15:22:12 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 13DB3369D8
        for <mm-commits@vger.kernel.org>; Fri, 13 May 2022 12:21:33 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A5D6E6225A
        for <mm-commits@vger.kernel.org>; Fri, 13 May 2022 19:21:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C1F8C34100;
        Fri, 13 May 2022 19:21:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1652469692;
        bh=fBVMb3OTWLjmqhd+ZjwHOsF18kEvG7pzAIDsL/WdZ1Y=;
        h=Date:To:From:Subject:From;
        b=AC9jFd8WzAsJXEEUgMs4J/5YIoAjOKnssCknGEFs0irGnwsiQZlhpNVYOUfH58yE9
         MU+M6ipVTPDATAQ6mK7OPr6ljRV//3m+UfsgOXbI71fyOGhwuFRcrrhAWHna9eUuXe
         AjfIknWe2Rvr8DCczzSWLW4lOVcFARq2Xvd8zogE=
Date:   Fri, 13 May 2022 12:21:31 -0700
To:     mm-commits@vger.kernel.org, richard.weiyang@gmail.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-vmscan-not-necessary-to-re-init-the-list-for-each-iteration.patch removed from -mm tree
Message-Id: <20220513192132.0C1F8C34100@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/vmscan: not necessary to re-init the list for each iteration
has been removed from the -mm tree.  Its filename was
     mm-vmscan-not-necessary-to-re-init-the-list-for-each-iteration.patch

This patch was dropped because it was merged into the mm-stable branch\nof git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Wei Yang <richard.weiyang@gmail.com>
Subject: mm/vmscan: not necessary to re-init the list for each iteration

node_page_list is defined with LIST_HEAD and be cleaned until
list_empty.

So it is not necessary to re-init it again.

[akpm@linux-foundation.org: remove unneeded braces]
Link: https://lkml.kernel.org/r/20220426021743.21007-1-richard.weiyang@gmail.com
Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

--- a/mm/vmscan.c~mm-vmscan-not-necessary-to-re-init-the-list-for-each-iteration
+++ a/mm/vmscan.c
@@ -2553,10 +2553,8 @@ unsigned long reclaim_pages(struct list_
 
 	while (!list_empty(page_list)) {
 		page = lru_to_page(page_list);
-		if (nid == NUMA_NO_NODE) {
+		if (nid == NUMA_NO_NODE)
 			nid = page_to_nid(page);
-			INIT_LIST_HEAD(&node_page_list);
-		}
 
 		if (nid == page_to_nid(page)) {
 			ClearPageActive(page);
_

Patches currently in -mm which might be from richard.weiyang@gmail.com are


