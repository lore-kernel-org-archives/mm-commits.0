Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 68D40CE7A8C
	for <mm-commits@archiver.kernel.org>; Mon, 25 Sep 2023 15:26:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232972AbjIYP0p (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 25 Sep 2023 11:26:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44286 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232934AbjIYP0b (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 25 Sep 2023 11:26:31 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6EBCBCF3
        for <mm-commits@vger.kernel.org>; Mon, 25 Sep 2023 08:26:09 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E29DCC433C7;
        Mon, 25 Sep 2023 15:26:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1695655569;
        bh=Eu93Y1QeLVcCeElsEP6d2snx0Vh4Rrl6UKgezeYXgkk=;
        h=Date:To:From:Subject:From;
        b=Lw0qaQMXp5WewrPIJUR7q2Gh3Q48lRCrFDza8uP+yowAEM++3U7Mlv8hZMGFw98kE
         Rpq5sATlAg4KP6yzEras4Jbg3oR1QN33+9tTtUxP0Fwa/twr06uN71a8yw+Gv0Ucru
         94N0EkPQXKYC+tABLI3a9sXDDHkRvenp7enwhECs=
Date:   Mon, 25 Sep 2023 08:26:08 -0700
To:     mm-commits@vger.kernel.org, zhangpeng.00@bytedance.com,
        willy@infradead.org, surenb@google.com, Liam.Howlett@oracle.com,
        jason.sim@samsung.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [failures] maple_tree-use-mas_node_count_gfp-on-mas_expected_entries.patch removed from -mm tree
Message-Id: <20230925152608.E29DCC433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: maple_tree: use mas_node_count_gfp() in mas_expected_entries()
has been removed from the -mm tree.  Its filename was
     maple_tree-use-mas_node_count_gfp-on-mas_expected_entries.patch

This patch was dropped because it had testing failures

------------------------------------------------------
From: Jaeseon Sim <jason.sim@samsung.com>
Subject: maple_tree: use mas_node_count_gfp() in mas_expected_entries()
Date: Fri, 15 Sep 2023 18:32:43 +0900

Use mas_node_count_gfp with GFP_KERNEL instead of
GFP_NOWAIT | __GFP_NOWARN on mas_expected_entries
in order to allow memory reclaim.

Currently, fork errors occur on low free memory as follows:

 Zygote  : Failed to fork child process: Out of memory (12)

-ENOMEM was returned as following path:

 mas_node_count
 mas_expected_entries
 dup_mmap
 dup_mm
 copy_mm
 copy_process

Link: https://lkml.kernel.org/r/20230915093243epcms1p46fa00bbac1ab7b7dca94acb66c44c456@epcms1p4
Signed-off-by: Jaeseon Sim <jason.sim@samsung.com>
Cc: "Liam R. Howlett" <Liam.Howlett@oracle.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Peng Zhang <zhangpeng.00@bytedance.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/maple_tree.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/lib/maple_tree.c~maple_tree-use-mas_node_count_gfp-on-mas_expected_entries
+++ a/lib/maple_tree.c
@@ -5574,7 +5574,7 @@ int mas_expected_entries(struct ma_state
 	/* Internal nodes */
 	nr_nodes += DIV_ROUND_UP(nr_nodes, nonleaf_cap);
 	/* Add working room for split (2 nodes) + new parents */
-	mas_node_count(mas, nr_nodes + 3);
+	mas_node_count_gfp(mas, nr_nodes + 3, GFP_KERNEL);
 
 	/* Detect if allocations run out */
 	mas->mas_flags |= MA_STATE_PREALLOC;
_

Patches currently in -mm which might be from jason.sim@samsung.com are


