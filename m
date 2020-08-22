Return-Path: <SRS0=1ZdY=CA=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8EC2EC433E3
	for <mm-commits@archiver.kernel.org>; Sat, 22 Aug 2020 17:30:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 72AB4207DA
	for <mm-commits@archiver.kernel.org>; Sat, 22 Aug 2020 17:30:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1598117416;
	bh=elCfwKD63LtrrZCV7YkE1z0OdQ3yq9adXZbbT7ILSbA=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=Kt0CEVC8e5/sd0rgUa0RtWR65jdjLB1NnUYB/uwFzmT8m6Vf2GZ9Tj+qXQOW8Hbtz
	 SV/HqG0P2Ter7wRM4BEG2JGv2A0nPGYFMH5upQUfn7ek5uurdZqikhZRz4/ROYaNLu
	 OHj5E9DTjUB3YLpfcivkh5MOQZ4Okc4T8cRRuA2M=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728400AbgHVRaQ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 22 Aug 2020 13:30:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:54074 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728417AbgHVRaG (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sat, 22 Aug 2020 13:30:06 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6BC26214F1;
        Sat, 22 Aug 2020 17:30:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598117405;
        bh=elCfwKD63LtrrZCV7YkE1z0OdQ3yq9adXZbbT7ILSbA=;
        h=Date:From:To:Subject:From;
        b=EyirHYcNcgB6sayNe3Qp0mCJnv5eASOcaAlzKEYSYN9TUO/qlqXmwqdkmTNtBg6tC
         ZvFIWvNZG9Q6R7Ed2Lkmn2CKqdVjddKCJyRE1liDiF0UXGg8nUJHdyPvmlUramG4JO
         Zh3PqpMjKM+Q+NmKbOPdZQAoLQaq5a/wfdLz1PJU=
Date:   Sat, 22 Aug 2020 10:30:05 -0700
From:   akpm@linux-foundation.org
To:     charante@codeaurora.org, david@redhat.com, mhocko@suse.com,
        mm-commits@vger.kernel.org, rientjes@google.com,
        stable@vger.kernel.org, vbabka@suse.cz, vinmenon@codeaurora.org
Subject:  [merged]
 mm-page_alloc-fix-core-hung-in-free_pcppages_bulk.patch removed from -mm
 tree
Message-ID: <20200822173005.iUjGe5PXk%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm, page_alloc: fix core hung in free_pcppages_bulk()
has been removed from the -mm tree.  Its filename was
     mm-page_alloc-fix-core-hung-in-free_pcppages_bulk.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Charan Teja Reddy <charante@codeaurora.org>
Subject: mm, page_alloc: fix core hung in free_pcppages_bulk()

The following race is observed with the repeated online, offline and a
delay between two successive online of memory blocks of movable zone.

P1						P2

Online the first memory block in
the movable zone. The pcp struct
values are initialized to default
values,i.e., pcp->high = 0 &
pcp->batch = 1.

					Allocate the pages from the
					movable zone.

Try to Online the second memory
block in the movable zone thus it
entered the online_pages() but yet
to call zone_pcp_update().
					This process is entered into
					the exit path thus it tries
					to release the order-0 pages
					to pcp lists through
					free_unref_page_commit().
					As pcp->high = 0, pcp->count = 1
					proceed to call the function
					free_pcppages_bulk().
Update the pcp values thus the
new pcp values are like, say,
pcp->high = 378, pcp->batch = 63.
					Read the pcp's batch value using
					READ_ONCE() and pass the same to
					free_pcppages_bulk(), pcp values
					passed here are, batch = 63,
					count = 1.

					Since num of pages in the pcp
					lists are less than ->batch,
					then it will stuck in
					while(list_empty(list)) loop
					with interrupts disabled thus
					a core hung.

Avoid this by ensuring free_pcppages_bulk() is called with proper count of
pcp list pages.

The mentioned race is some what easily reproducible without [1] because
pcp's are not updated for the first memory block online and thus there is
a enough race window for P2 between alloc+free and pcp struct values
update through onlining of second memory block.

With [1], the race still exists but it is very narrow as we update the pcp
struct values for the first memory block online itself.

This is not limited to the movable zone, it could also happen in cases
with the normal zone (e.g., hotplug to a node that only has DMA memory, or
no other memory yet).

[1]: https://patchwork.kernel.org/patch/11696389/

Link: http://lkml.kernel.org/r/1597150703-19003-1-git-send-email-charante@codeaurora.org
Fixes: 5f8dcc21211a ("page-allocator: split per-cpu list into one-list-per-migrate-type")
Signed-off-by: Charan Teja Reddy <charante@codeaurora.org>
Acked-by: David Hildenbrand <david@redhat.com>
Acked-by: David Rientjes <rientjes@google.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Vinayak Menon <vinmenon@codeaurora.org>
Cc: <stable@vger.kernel.org> [2.6+]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/mm/page_alloc.c~mm-page_alloc-fix-core-hung-in-free_pcppages_bulk
+++ a/mm/page_alloc.c
@@ -1302,6 +1302,11 @@ static void free_pcppages_bulk(struct zo
 	struct page *page, *tmp;
 	LIST_HEAD(head);
 
+	/*
+	 * Ensure proper count is passed which otherwise would stuck in the
+	 * below while (list_empty(list)) loop.
+	 */
+	count = min(pcp->count, count);
 	while (count) {
 		struct list_head *list;
 
_

Patches currently in -mm which might be from charante@codeaurora.org are


