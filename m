Return-Path: <SRS0=1kGn=B5=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 05B16C433E1
	for <mm-commits@archiver.kernel.org>; Wed, 19 Aug 2020 03:39:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DB3252063A
	for <mm-commits@archiver.kernel.org>; Wed, 19 Aug 2020 03:39:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1597808389;
	bh=RqEBK9mZg1Iy8pbgPMXGj4mhQci6VFML79/j/Fx0+gI=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=XxDhJASt0PQPFAeWlZtx++eY04CyPwwAxzGcufxrBeVLNnIr8xbJz4YTbt/rd3G7O
	 0xkzIxZRvMB0eD9cW1rida/vIzlIDT90wCSMdIwpIZ7lCcZz06ZMptG8FLrmkNVuLm
	 5OrNvXjAYDDBYbkc5pxHwyn11go9YgNeSFZZ0UUY=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726636AbgHSDjt (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 18 Aug 2020 23:39:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:44816 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726495AbgHSDjr (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 18 Aug 2020 23:39:47 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B3F842078B;
        Wed, 19 Aug 2020 03:39:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597808387;
        bh=RqEBK9mZg1Iy8pbgPMXGj4mhQci6VFML79/j/Fx0+gI=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=RNCwY/mD+uVQgcG3CKL8P+vALsUoW8EgJTs9cV78CiY4bj86X2xGBcjBuYpzt2B7K
         AvPVM2IuVYGYdOH0ySX1smerz3MmC7abYcYtwWuwSV91rFIUxIeR3jdr7pYNFdtQxf
         Z8gEE2ZB4DFpjMgiHIzya1aCEQ27e9UIboLuyTn4=
Date:   Tue, 18 Aug 2020 20:39:46 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     cl@linux.com, david@redhat.com, ego@linux.vnet.ibm.com,
        kirill@shutemov.name, mgorman@suse.de, mhocko@suse.com,
        mm-commits@vger.kernel.org, mpe@ellerman.id.au,
        sathnaga@linux.vnet.ibm.com, srikar@linux.vnet.ibm.com,
        vbabka@suse.cz
Subject:  [to-be-updated]
 powerpc-numa-prefer-node-id-queried-from-vphn.patch removed from -mm tree
Message-ID: <20200819033946.WBoxLc-_6%akpm@linux-foundation.org>
In-Reply-To: <20200814172939.55d6d80b6e21e4241f1ee1f3@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: powerpc/numa: prefer node id queried from vphn
has been removed from the -mm tree.  Its filename was
     powerpc-numa-prefer-node-id-queried-from-vphn.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Subject: powerpc/numa: prefer node id queried from vphn

Node id queried from the static device tree may not be correct.  For
example: it may always show 0 on a shared processor.  Hence prefer the
node id queried from vphn and fallback on the device tree based node id if
vphn query fails.

Link: http://lkml.kernel.org/r/20200624092846.9194-3-srikar@linux.vnet.ibm.com
Signed-off-by: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Reviewed-by: Gautham R. Shenoy <ego@linux.vnet.ibm.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: "Kirill A. Shutemov" <kirill@shutemov.name>
Cc: Christopher Lameter <cl@linux.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Satheesh Rajendran <sathnaga@linux.vnet.ibm.com>
Cc: David Hildenbrand <david@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/mm/numa.c |   19 ++++++++++---------
 1 file changed, 10 insertions(+), 9 deletions(-)

--- a/arch/powerpc/mm/numa.c~powerpc-numa-prefer-node-id-queried-from-vphn
+++ a/arch/powerpc/mm/numa.c
@@ -724,21 +724,22 @@ static int __init parse_numa_properties(
 	 */
 	for_each_present_cpu(i) {
 		struct device_node *cpu;
-		int nid;
-
-		cpu = of_get_cpu_node(i, NULL);
-		BUG_ON(!cpu);
-		nid = of_node_to_nid_single(cpu);
-		of_node_put(cpu);
+		int nid = vphn_get_nid(i);
 
 		/*
 		 * Don't fall back to default_nid yet -- we will plug
 		 * cpus into nodes once the memory scan has discovered
 		 * the topology.
 		 */
-		if (nid < 0)
-			continue;
-		node_set_online(nid);
+		if (nid == NUMA_NO_NODE) {
+			cpu = of_get_cpu_node(i, NULL);
+			BUG_ON(!cpu);
+			nid = of_node_to_nid_single(cpu);
+			of_node_put(cpu);
+		}
+
+		if (likely(nid > 0))
+			node_set_online(nid);
 	}
 
 	get_n_mem_cells(&n_mem_addr_cells, &n_mem_size_cells);
_

Patches currently in -mm which might be from srikar@linux.vnet.ibm.com are


