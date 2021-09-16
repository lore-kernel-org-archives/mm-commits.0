Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D0224C433F5
	for <mm-commits@archiver.kernel.org>; Thu, 16 Sep 2021 03:47:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B14CB6112E
	for <mm-commits@archiver.kernel.org>; Thu, 16 Sep 2021 03:47:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234241AbhIPDsr (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 15 Sep 2021 23:48:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:51638 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234251AbhIPDsr (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 15 Sep 2021 23:48:47 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id F2745601FC;
        Thu, 16 Sep 2021 03:47:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1631764047;
        bh=ME0aV/m35le/OhyBlHoBqUDYH86e7hZspA5j69nGCjk=;
        h=Date:From:To:Subject:From;
        b=ic9OpsMruUm4+FZLkAjnYxf/1xAN5t52WE5tBL6spbeTMO/fJAoBjBP4nge8kLmty
         s7KtrOBrEcOTmg0ZQhnBSXodYt/ebjEuTYN7IKNhWDpPNYjpBnSW4AC/shURJdBXJs
         BuoOtwxZBikAHy329K0c8VRVfeizZjDn33n1/cco=
Date:   Wed, 15 Sep 2021 20:47:26 -0700
From:   akpm@linux-foundation.org
To:     anshuman.khandual@arm.com, bharata@amd.com,
        kamezawa.hiroyu@jp.fujitsu.com, krupa.ramakrishnan@amd.com,
        lee.schermerhorn@hp.com, mgorman@suse.de,
        mm-commits@vger.kernel.org, Sadagopan.Srinivasan@amd.com
Subject:  + mm-page_alloc-print-node-fallback-order.patch added to
 -mm tree
Message-ID: <20210916034726.B1NXIPUlC%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/page_alloc: print node fallback order
has been added to the -mm tree.  Its filename is
     mm-page_alloc-print-node-fallback-order.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-page_alloc-print-node-fallback-order.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-page_alloc-print-node-fallback-order.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Bharata B Rao <bharata@amd.com>
Subject: mm/page_alloc: print node fallback order

Patch series "Fix NUMA nodes fallback list ordering".

For a NUMA system that has multiple nodes at same distance from other
nodes, the fallback list generation prefers same node order for them
instead of round-robin thereby penalizing one node over others.  This
series fixes it.

More description of the problem and the fix is present in the patch
description.


This patch (of 2):

Print information message about the allocation fallback order for each
NUMA node during boot.

No functional changes here.  This makes it easier to illustrate the
problem in the node fallback list generation, which the next patch fixes.

Link: https://lkml.kernel.org/r/20210830121603.1081-1-bharata@amd.com
Link: https://lkml.kernel.org/r/20210830121603.1081-2-bharata@amd.com
Signed-off-by: Bharata B Rao <bharata@amd.com>
Acked-by: Mel Gorman <mgorman@suse.de>
Reviewed-by: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Lee Schermerhorn <lee.schermerhorn@hp.com>
Cc: Krupa Ramakrishnan <krupa.ramakrishnan@amd.com>
Cc: Sadagopan Srinivasan <Sadagopan.Srinivasan@amd.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/mm/page_alloc.c~mm-page_alloc-print-node-fallback-order
+++ a/mm/page_alloc.c
@@ -6256,6 +6256,10 @@ static void build_zonelists(pg_data_t *p
 
 	build_zonelists_in_node_order(pgdat, node_order, nr_nodes);
 	build_thisnode_zonelists(pgdat);
+	pr_info("Fallback order for Node %d: ", local_node);
+	for (node = 0; node < nr_nodes; node++)
+		pr_cont("%d ", node_order[node]);
+	pr_cont("\n");
 }
 
 #ifdef CONFIG_HAVE_MEMORYLESS_NODES
_

Patches currently in -mm which might be from bharata@amd.com are

mm-page_alloc-print-node-fallback-order.patch

