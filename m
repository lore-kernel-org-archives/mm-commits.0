Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 86D8AC4332F
	for <mm-commits@archiver.kernel.org>; Fri, 25 Mar 2022 01:34:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345845AbiCYBf7 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 24 Mar 2022 21:35:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39720 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357460AbiCYBew (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 24 Mar 2022 21:34:52 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED235C12D5
        for <mm-commits@vger.kernel.org>; Thu, 24 Mar 2022 18:32:45 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8A07260909
        for <mm-commits@vger.kernel.org>; Fri, 25 Mar 2022 01:32:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E5FE9C340ED;
        Fri, 25 Mar 2022 01:32:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1648171965;
        bh=MiOIftS487hpHmx1KN1R7ZCNiy4yO+4KKrayqCBKUlA=;
        h=Date:To:From:Subject:From;
        b=bi1/H+NxzITowWU24JWFn/x/ePVZtclLi4LtkIaxqGtXhkQKRfDCDTxc0R1vjeW8d
         6JKieoPYcesyvGrxcFhHONQnbxZP2qDUSX2moI1tzoRbEn1r9dXWyWwBtld82JK9Iz
         WjGvqz6V3sbB8PL9kHuTm86J1NnZKLBj9d+jSPDk=
Date:   Thu, 24 Mar 2022 18:32:44 -0700
To:     mm-commits@vger.kernel.org, osalvador@suse.de, david@redhat.com,
        linmiaohe@huawei.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged] mm-memory_hotplug-clean-up-try_offline_node.patch removed from -mm tree
Message-Id: <20220325013244.E5FE9C340ED@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/memory_hotplug: clean up try_offline_node
has been removed from the -mm tree.  Its filename was
     mm-memory_hotplug-clean-up-try_offline_node.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Miaohe Lin <linmiaohe@huawei.com>
Subject: mm/memory_hotplug: clean up try_offline_node

We can use helper macro node_spanned_pages to check whether node spans
pages.  And we can change the parameter of check_cpu_on_node to nid as
that's what it really cares.  Thus we can further get rid of the local
variable pgdat and improve the readability a bit.

Link: https://lkml.kernel.org/r/20220207133643.23427-4-linmiaohe@huawei.com
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Oscar Salvador <osalvador@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory_hotplug.c |    9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

--- a/mm/memory_hotplug.c~mm-memory_hotplug-clean-up-try_offline_node
+++ a/mm/memory_hotplug.c
@@ -2005,12 +2005,12 @@ static int get_nr_vmemmap_pages_cb(struc
 	return mem->nr_vmemmap_pages;
 }
 
-static int check_cpu_on_node(pg_data_t *pgdat)
+static int check_cpu_on_node(int nid)
 {
 	int cpu;
 
 	for_each_present_cpu(cpu) {
-		if (cpu_to_node(cpu) == pgdat->node_id)
+		if (cpu_to_node(cpu) == nid)
 			/*
 			 * the cpu on this node isn't removed, and we can't
 			 * offline this node.
@@ -2044,7 +2044,6 @@ static int check_no_memblock_for_node_cb
  */
 void try_offline_node(int nid)
 {
-	pg_data_t *pgdat = NODE_DATA(nid);
 	int rc;
 
 	/*
@@ -2052,7 +2051,7 @@ void try_offline_node(int nid)
 	 * offline it. A node spans memory after move_pfn_range_to_zone(),
 	 * e.g., after the memory block was onlined.
 	 */
-	if (pgdat->node_spanned_pages)
+	if (node_spanned_pages(nid))
 		return;
 
 	/*
@@ -2064,7 +2063,7 @@ void try_offline_node(int nid)
 	if (rc)
 		return;
 
-	if (check_cpu_on_node(pgdat))
+	if (check_cpu_on_node(nid))
 		return;
 
 	/*
_

Patches currently in -mm which might be from linmiaohe@huawei.com are

mm-huge_memory-make-is_transparent_hugepage-static.patch

