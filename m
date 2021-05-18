Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_RED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3420BC433B4
	for <mm-commits@archiver.kernel.org>; Tue, 18 May 2021 23:40:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0F65360FF0
	for <mm-commits@archiver.kernel.org>; Tue, 18 May 2021 23:40:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235575AbhERXlg (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 18 May 2021 19:41:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:45784 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229518AbhERXlf (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 18 May 2021 19:41:35 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0B78E610CB;
        Tue, 18 May 2021 23:40:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1621381216;
        bh=Cer769jMGixfTvWm8ZmSC6NsycR+Wg3KutC58ZTc5BM=;
        h=Date:From:To:Subject:From;
        b=MUOfS09TpVSnwntIrrhc3ZmuaJCkx/WIgl1urQAhpGiAN14PnHNBmwYErl/Npm1eL
         Sn+bpxnX0vtYZvRPyf6edhCIi79MAmDrQos66HimmqXtzhzafbA/pEhzGl3fpYWPhl
         xYVBn2M6unbjZ8R/JNMZFIW03rcg0OmcRzBEBPzs=
Date:   Tue, 18 May 2021 16:40:15 -0700
From:   akpm@linux-foundation.org
To:     hdanton@sina.com, mgorman@suse.de, mhocko@suse.com,
        mm-commits@vger.kernel.org, npiggin@gmail.com,
        oleksiy.avramchenko@sonymobile.com, rostedt@goodmis.org,
        urezki@gmail.com, willy@infradead.org
Subject:  +
 mm-page_alloc-add-an-alloc_pages_bulk_array_node-helper.patch added to -mm
 tree
Message-ID: <20210518234015.yNjEQqDEy%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/page_alloc: add an alloc_pages_bulk_array_node() helper
has been added to the -mm tree.  Its filename is
     mm-page_alloc-add-an-alloc_pages_bulk_array_node-helper.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-page_alloc-add-an-alloc_pages_bulk_array_node-helper.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-page_alloc-add-an-alloc_pages_bulk_array_node-helper.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

mm-page_alloc-add-an-alloc_pages_bulk_array_node-helper.patch
mm-vmalloc-switch-to-bulk-allocator-in-__vmalloc_area_node.patch
mm-vmalloc-print-a-warning-message-first-on-failure.patch

