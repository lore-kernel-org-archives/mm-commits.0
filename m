Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 634B8C433F5
	for <mm-commits@archiver.kernel.org>; Tue, 22 Mar 2022 21:47:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233987AbiCVVtS (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 22 Mar 2022 17:49:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35246 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236754AbiCVVsz (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 22 Mar 2022 17:48:55 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A5F8D606CE
        for <mm-commits@vger.kernel.org>; Tue, 22 Mar 2022 14:47:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 428B26104C
        for <mm-commits@vger.kernel.org>; Tue, 22 Mar 2022 21:47:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A78BC340EC;
        Tue, 22 Mar 2022 21:47:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1647985642;
        bh=PpEsN8mcG7GQQNSB7nA/+rtCMUs7PJFXq1LdZYof+Gw=;
        h=Date:To:From:In-Reply-To:Subject:From;
        b=0zKe3ATtNLBpqmeRaR7IDapsKUnpR85jVv5gwvkEEC9qncwhmFWxJLcEQGz7aEodb
         EgsUCZEvPwzf3gm+mc2T5bqrPHcR/r5rc3qaFB3HZzfHUzHdcceqKJzTb3p/d8KzM+
         LQyUAqIDgBNFF8Bi6JfxDiWofzDHSTEhEsDfd4m8=
Date:   Tue, 22 Mar 2022 14:47:22 -0700
To:     osalvador@suse.de, david@redhat.com, linmiaohe@huawei.com,
        akpm@linux-foundation.org, patches@lists.linux.dev,
        linux-mm@kvack.org, mm-commits@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20220322143803.04a5e59a07e48284f196a2f9@linux-foundation.org>
Subject: [patch 174/227] mm/memory_hotplug: clean up try_offline_node
Message-Id: <20220322214722.9A78BC340EC@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
