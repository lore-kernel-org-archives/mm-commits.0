Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AF9A0C433EF
	for <mm-commits@archiver.kernel.org>; Tue, 25 Jan 2022 01:58:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S3411717AbiAYAed (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 24 Jan 2022 19:34:33 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:58316 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1389146AbiAYAS4 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 24 Jan 2022 19:18:56 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9D26BB815E0
        for <mm-commits@vger.kernel.org>; Tue, 25 Jan 2022 00:17:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D5D4C340E5;
        Tue, 25 Jan 2022 00:17:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1643069865;
        bh=DIuWc1HRSTxq5oNna8ZpZk4b9AAX60ODMW2hPOgwDUo=;
        h=Date:From:To:Subject:From;
        b=NulUyQ9iofw/8nTAnPTPS+a3hTfgzipG18DHwBl6BmEVfMauGD4kFPxEgSaUPk0EU
         JF0270l0Ap3hDp/hYewbLKXMxZvRFpjZA3FT1VzAZS7PvFwE5giMHZkrYcHMqX429C
         Oaq2b9sD12EMuOBKY8o3pXzvFoNu9yhQ72Gc7SHA=
Date:   Mon, 24 Jan 2022 16:17:44 -0800
From:   akpm@linux-foundation.org
To:     kamezawa.hiroyu@jp.fujitsu.com, krupa.ramakrishnan@amd.com,
        mhocko@suse.com, mm-commits@vger.kernel.org,
        richard.weiyang@gmail.com, rientjes@google.com
Subject:  + mm-page_alloc-add-penalty-to-local_node.patch added to
 -mm tree
Message-ID: <20220125001744.Da2lu3w8b%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/page_alloc: add penalty to local_node
has been added to the -mm tree.  Its filename is
     mm-page_alloc-add-penalty-to-local_node.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-page_alloc-add-penalty-to-local_node.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-page_alloc-add-penalty-to-local_node.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Wei Yang <richard.weiyang@gmail.com>
Subject: mm/page_alloc: add penalty to local_node

Commit 54d032ced983 ("mm/page_alloc: use accumulated load when building
node fallback list") fixed a bug on zonelist order.  This made me think
about what would happen if we have a node system with the following
distance matrix.

   Node 0  1  2  3  4  5  6  7
   ----------------------------
   0    10 12 12 12 32 32 32 32
   1    12 10 12 12 32 32 32 32
   2    12 12 10 12 32 32 32 32
   3    12 12 12 10 32 32 32 32
   4    32 32 32 32 10 12 12 12
   5    32 32 32 32 12 10 12 12
   6    32 32 32 32 12 12 10 12
   7    32 32 32 32 12 12 12 10

Unfortunately for this case, the node fallback list gets built like this:

   Node Fallback list
   ---------------------
    0:   0  1  2  3  4  5  6  7
    1:   1  0  2  3  5  6  7  4
    2:   2  3  0  1  6  7  4  5
    3:   3  2  0  1  7  4  5  6
    4:   4  5  6  7  0  1  2  3
    5:   5  4  6  7  1  2  3  0
    6:   6  7  4  5  2  3  0  1
    7:   7  6  4  5  3  0  1  2

We found the order in diagonal block is not expected.  The reason is we
don't penaltize local node.

After penalizing local node, the node fallback list gets built like this:

   Node Fallback list
   ---------------------
   0:   0  1  2  3  4  5  6  7
   1:   1  2  3  0  5  6  7  4
   2:   2  3  0  1  6  7  4  5
   3:   3  0  1  2  7  4  5  6
   4:   4  5  6  7  0  1  2  3
   5:   5  6  7  4  1  2  3  0
   6:   6  7  4  5  2  3  0  1
   7:   7  4  5  6  3  0  1  2

Now the fallback list is in round-robin order.

I am not very familiar with the node distance pattern, while I tried the
following distance matrix.  Both of them works with this change.

   Node 0  1  2  3
   ----------------
   0    10 10 10 10
   1    10 10 10 10
   2    10 10 10 10
   3    10 10 10 10

   Node 0  1  2  3  4  5  6  7
   ----------------------------
   0    10 10 10 10 32 32 32 32
   1    10 10 10 10 32 32 32 32
   2    10 10 10 10 32 32 32 32
   3    10 10 10 10 32 32 32 32
   4    32 32 32 32 10 10 10 10
   5    32 32 32 32 10 10 10 10
   6    32 32 32 32 10 10 10 10
   7    32 32 32 32 10 10 10 10

Link: https://lkml.kernel.org/r/20220123013537.20491-2-richard.weiyang@gmail.com
Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
Cc: Krupa Ramakrishnan <krupa.ramakrishnan@amd.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/mm/page_alloc.c~mm-page_alloc-add-penalty-to-local_node
+++ a/mm/page_alloc.c
@@ -6334,8 +6334,9 @@ static void build_zonelists(pg_data_t *p
 		 * So adding penalty to the first node in same
 		 * distance group to make it round-robin.
 		 */
-		if (node_distance(local_node, node) !=
-		    node_distance(local_node, prev_node))
+		if ((node_distance(local_node, node) !=
+		    node_distance(local_node, prev_node)) ||
+		    node == local_node)
 			node_load[node] += nr_online_nodes;
 
 		node_order[nr_nodes++] = node;
_

Patches currently in -mm which might be from richard.weiyang@gmail.com are

mm-page-mapping-folio-mapping-should-have-the-same-offset.patch
mm-page_alloc-add-same-penalty-is-enough-to-get-round-robin-order.patch
mm-page_alloc-add-penalty-to-local_node.patch

