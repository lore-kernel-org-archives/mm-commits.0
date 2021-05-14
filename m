Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5FCCAC433B4
	for <mm-commits@archiver.kernel.org>; Fri, 14 May 2021 10:19:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3B1C7613E6
	for <mm-commits@archiver.kernel.org>; Fri, 14 May 2021 10:19:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230487AbhENKUg (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 14 May 2021 06:20:36 -0400
Received: from mx2.suse.de ([195.135.220.15]:36184 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230063AbhENKUg (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 14 May 2021 06:20:36 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id CF2ECAFD0;
        Fri, 14 May 2021 10:19:23 +0000 (UTC)
Date:   Fri, 14 May 2021 11:19:20 +0100
From:   Mel Gorman <mgorman@suse.de>
To:     Uladzislau Rezki <urezki@gmail.com>
Cc:     Stephen Rothwell <sfr@canb.auug.org.au>,
        Andrew Morton <akpm@linux-foundation.org>,
        Hillf Danton <hdanton@sina.com>,
        Michal Hocko <mhocko@suse.com>, mm-commits@vger.kernel.org,
        Nicholas Piggin <npiggin@gmail.com>,
        Oleksiy Avramchenko <oleksiy.avramchenko@sonymobile.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Matthew Wilcox <willy@infradead.org>
Subject: Re: [failures]
 mm-vmalloc-print-a-warning-message-first-on-failure.patch removed from -mm
 tree
Message-ID: <20210514101920.GO3672@suse.de>
References: <20210512202952.PRR7JClh8%akpm@linux-foundation.org>
 <20210513085602.6d3f9d63@canb.auug.org.au>
 <20210513103156.GA1856@pc638.lan>
 <20210513111153.GL3672@suse.de>
 <20210513124605.GA3263@pc638.lan>
 <20210513132418.GA1425@pc638.lan>
 <20210513141858.GM3672@suse.de>
 <CA+KHdyXwdkosDYk4bKtRLVodrwUJnq3NN39xuRQzKJSPTn7+bQ@mail.gmail.com>
 <20210513155133.GN3672@suse.de>
 <20210513201851.GA55390@pc638.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <20210513201851.GA55390@pc638.lan>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

On Thu, May 13, 2021 at 10:18:51PM +0200, Uladzislau Rezki wrote:
> <SNIP>
>
> From the trace i get:
> 
> <snip>
> [    0.243916] RIP: 0010:__alloc_pages+0x11e/0x310
> [    0.243916] Code: 84 c0 0f 85 02 01 00 00 89 d8 48 8b 54 24 08 8b 74 24 1c c1 e8 0c 83 e0 01 88 44 24 20 48 8b 04 24 48 85 d2 0f 85 71 01 00 00 <3b> 70 08 0f 82 68 01 00 00 48 89 44 24 10 48 8b 00 89 da 81 e2 00
> [    0.243916] RSP: 0000:ffffffffae803c38 EFLAGS: 00010246
> [    0.243916] RAX: 0000000000001cc0 RBX: 0000000000002102 RCX: 0000000000000004
> [    0.243916] RDX: 0000000000000000 RSI: 0000000000000002 RDI: 0000000000002102
> [    0.243916] RBP: 0000000000000000 R08: 0000000000000000 R09: c0000000ffffdfff
> [    0.243916] R10: 0000000000000001 R11: ffffffffae803ac0 R12: 0000000000000000
> [    0.243916] R13: 0000000000002102 R14: 0000000000000001 R15: ffffa0938000d000
> [    0.243916] FS:  0000000000000000(0000) GS:ffff893ab7c00000(0000) knlGS:0000000000000000
> [    0.243916] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [    0.243916] CR2: 0000000000001cc8 CR3: 0000000176e10000 CR4: 00000000000006b0
> [    0.243916] Call Trace:
> [    0.243916]  __alloc_pages_bulk+0xaa1/0xb50
> <snip>
> 
> (gdb) l *__alloc_pages+0x11e
> 0xffffffff8129d87e is in __alloc_pages (./include/linux/mmzone.h:1095).
> 1090            return zoneref->zone;
> 1091    }
> 1092
> 1093    static inline int zonelist_zone_idx(struct zoneref *zoneref)
> 1094    {
> 1095            return zoneref->zone_idx;
> 1096    }
> 1097
> 1098    static inline int zonelist_node_idx(struct zoneref *zoneref)
> 1099    {
> (gdb)
> 
> Seems like "zoneref" refers to invalid address.
> 
> Thoughts?

I have not previously read the patch but there are a few concerns and it's
probably just as well this blew up early. The bulk allocator assumes a
valid node but the patch can send in NUMA_NO_NODE (-1). On the high-order
path alloc_pages_node is used which checks nid == NUMA_NO_NODE. Also,
area->pages is not necessarily initialised so that could be interpreted
as a partially populated array so minmally you need.

diff --git a/mm/vmalloc.c b/mm/vmalloc.c
index f3c5dd4ccc5b9..b638ff31b07e1 100644
--- a/mm/vmalloc.c
+++ b/mm/vmalloc.c
@@ -2792,6 +2792,9 @@ static void *__vmalloc_area_node(struct vm_struct *area, gfp_t gfp_mask,
 	page_order = vm_area_page_order(area);
 
 	if (!page_order) {
+		memset(area->pages, 0, array_size);
+		if (node == NUMA_NO_NODE)
+			node = numa_mem_id();
 		area->nr_pages = __alloc_pages_bulk(gfp_mask, node,
 			NULL, nr_small_pages, NULL, area->pages);
 	} else {

However, the high-order path also looks suspicious. area->nr_pages is
advanced before the allocation attempt so in the event alloc_pages_node()
returns NULL prematurely, area->nr_pages does not reflect the number of
pages allocated so that needs examination.

As an aside, where or what is test_vmalloc.sh? It appears to have been
used a few times but it's not clear it's representative so are you aware
of workloads that are vmalloc-intensive? It does not matter for the
patch as such but it would be nice to know examples of vmalloc-intensive
workloads because I cannot recall a time during the last few years where
I saw vmalloc.c high in profiles.

-- 
Mel Gorman
SUSE Labs
