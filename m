Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A5FEDC07E96
	for <mm-commits@archiver.kernel.org>; Tue,  6 Jul 2021 19:13:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9371E60FEE
	for <mm-commits@archiver.kernel.org>; Tue,  6 Jul 2021 19:13:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230031AbhGFTPz (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 6 Jul 2021 15:15:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:50288 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230052AbhGFTPy (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 6 Jul 2021 15:15:54 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9A76A60FE3;
        Tue,  6 Jul 2021 19:13:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1625598794;
        bh=TZy1CAcZ3nlQce5siKOTn+UFJALyXX0XDPZ4OGQso7s=;
        h=Date:From:To:Subject:From;
        b=TNLuOESJORyMg5R1xtF5XIRNByQyOmfoDfKKAm2flkq/ONo9Yt5IUC0VnduJcxfqN
         Knu53oQpxdsGJJUGZOqOhZf7grrkcoLW0EeKaWJTiAMLhqqi4POC/5KZnt46GjZEBo
         L+g9Af/9qRtPZ33u8iNM4zDYA2Zki0e8YOe5+Mjc=
Date:   Tue, 06 Jul 2021 12:13:14 -0700
From:   akpm@linux-foundation.org
To:     hdanton@sina.com, mgorman@suse.de, mhocko@suse.com,
        mm-commits@vger.kernel.org, npiggin@gmail.com,
        oleksiy.avramchenko@sonymobile.com, rostedt@goodmis.org,
        urezki@gmail.com, willy@infradead.org
Subject:  [merged]
 mm-page_alloc-add-an-alloc_pages_bulk_array_node-helper.patch removed from
 -mm tree
Message-ID: <20210706191314._H44K0lzV%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/page_alloc: add an alloc_pages_bulk_array_node() helper
has been removed from the -mm tree.  Its filename was
     mm-page_alloc-add-an-alloc_pages_bulk_array_node-helper.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: "Uladzislau Rezki (Sony)" <urezki@gmail.com>
Subject: mm/page_alloc: add an alloc_pages_bulk_array_node() helper

Patch series "vmalloc() vs bulk allocator", v2.


This patch (of 3):

Add a "node" variant of the alloc_pages_bulk_array() function.  The helper
guarantees that a __alloc_pages_bulk() is invoked with a valid NUMA node
ID.

Link: https://lkml.kernel.org/r/20210516202056.2120-1-urezki@gmail.com
Link: https://lkml.kernel.org/r/20210516202056.2120-2-urezki@gmail.com
Signed-off-by: Uladzislau Rezki (Sony) <urezki@gmail.com>
Acked-by: Mel Gorman <mgorman@suse.de>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: Hillf Danton <hdanton@sina.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Oleksiy Avramchenko <oleksiy.avramchenko@sonymobile.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/gfp.h |    9 +++++++++
 1 file changed, 9 insertions(+)

--- a/include/linux/gfp.h~mm-page_alloc-add-an-alloc_pages_bulk_array_node-helper
+++ a/include/linux/gfp.h
@@ -536,6 +536,15 @@ alloc_pages_bulk_array(gfp_t gfp, unsign
 	return __alloc_pages_bulk(gfp, numa_mem_id(), NULL, nr_pages, NULL, page_array);
 }
 
+static inline unsigned long
+alloc_pages_bulk_array_node(gfp_t gfp, int nid, unsigned long nr_pages, struct page **page_array)
+{
+	if (nid == NUMA_NO_NODE)
+		nid = numa_mem_id();
+
+	return __alloc_pages_bulk(gfp, nid, NULL, nr_pages, NULL, page_array);
+}
+
 /*
  * Allocate pages, preferring the node given as nid. The node must be valid and
  * online. For more general interface, see alloc_pages_node().
_

Patches currently in -mm which might be from urezki@gmail.com are


