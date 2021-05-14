Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B26F2C43460
	for <mm-commits@archiver.kernel.org>; Fri, 14 May 2021 11:45:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7E1E76145B
	for <mm-commits@archiver.kernel.org>; Fri, 14 May 2021 11:45:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232178AbhENLq7 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 14 May 2021 07:46:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43882 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230525AbhENLq6 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 14 May 2021 07:46:58 -0400
Received: from mail-lf1-x12e.google.com (mail-lf1-x12e.google.com [IPv6:2a00:1450:4864:20::12e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 70C69C061574
        for <mm-commits@vger.kernel.org>; Fri, 14 May 2021 04:45:47 -0700 (PDT)
Received: by mail-lf1-x12e.google.com with SMTP id r5so25492002lfr.5
        for <mm-commits@vger.kernel.org>; Fri, 14 May 2021 04:45:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:date:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=/mnLt4SXf/pP4UdnREEHSIA7uEyHGPqXKUkaKgMdrQY=;
        b=ChpLxvdjWujy4T5zXS6d8Zu7TKVrmHwTpMc9dmL3UfKYpeXH7eizhKoAGIp7SaO8D4
         ppzxsnIksm/Am6lpdMO9PrxwqQ/+3vC56omm0nJYVMTEWR/haW4nqQrAeWMUy32mWeok
         5+o+VP6Z7c4N1l3/0ik/wq1CM6bM0iEf0BoTl+hWiuh6v6/6nH0wW92pAZS0xgXOxSXP
         FpnrBc3UNJ420Ttclg8msvahEf0E4yQP/llJ6EdKjbj/wszPLN+lI8x6qVts/IXeJa70
         /p6JkYj+QPQAa3NFa/t56U3rGLw5QC1lvqN0spx6e/XPCLoGuxuESSN7rH6S6HmuogO1
         +8uA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:date:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=/mnLt4SXf/pP4UdnREEHSIA7uEyHGPqXKUkaKgMdrQY=;
        b=FdOKYOF4xKxywpC3LG6/Ome/xpYe5eLnHq0b5Pq8zywKdTTPYOlotc/Bi5CCDMFaEx
         u1RzPx1gox5aiV83IRGpS+QtUj6O4B/g/Ekpsv4Hw+NJSIj6EqpgG/DHpV4gzCJoWfFh
         1JIX73sqBxH7ZhQb/8N9z3aaxHd1sX0LG8sdJSWGL6phYlf+mgHlPhDUMjkKAh16Sfu0
         Y4ZESD3/OmyzA4MG9Ugg6f+TiR0+be/gvpXtO6RM1khjgu699KsrtHCXIYhKX871CH+3
         wNePgM1hOstWn1tW16wO6bhPjQGQPqvIbd4WQKWvk6qHgJbcR0sHEbKLK+VNGx6TygBg
         C8rg==
X-Gm-Message-State: AOAM531djgoZIwKd7ARGGx8wDTSecY6wUgwMifrvETQS0Vv/ogjeYyCe
        BiimViFkz1tyitQyjzPkUqA=
X-Google-Smtp-Source: ABdhPJza7cv2UCpTDJMsD/31IPnjxJenqvh3E4vHlQZX/6CJuEiXHhpmyKBCU+SduWYxCAVN+XqhcA==
X-Received: by 2002:a05:6512:3090:: with SMTP id z16mr30381173lfd.402.1620992745918;
        Fri, 14 May 2021 04:45:45 -0700 (PDT)
Received: from pc638.lan (h5ef52e3d.seluork.dyn.perspektivbredband.net. [94.245.46.61])
        by smtp.gmail.com with ESMTPSA id 8sm1028049ljj.138.2021.05.14.04.45.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 May 2021 04:45:45 -0700 (PDT)
From:   Uladzislau Rezki <urezki@gmail.com>
X-Google-Original-From: Uladzislau Rezki <urezki@pc638.lan>
Date:   Fri, 14 May 2021 13:45:43 +0200
To:     Mel Gorman <mgorman@suse.de>
Cc:     Uladzislau Rezki <urezki@gmail.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
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
Message-ID: <20210514114543.GA7022@pc638.lan>
References: <20210513085602.6d3f9d63@canb.auug.org.au>
 <20210513103156.GA1856@pc638.lan>
 <20210513111153.GL3672@suse.de>
 <20210513124605.GA3263@pc638.lan>
 <20210513132418.GA1425@pc638.lan>
 <20210513141858.GM3672@suse.de>
 <CA+KHdyXwdkosDYk4bKtRLVodrwUJnq3NN39xuRQzKJSPTn7+bQ@mail.gmail.com>
 <20210513155133.GN3672@suse.de>
 <20210513201851.GA55390@pc638.lan>
 <20210514101920.GO3672@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210514101920.GO3672@suse.de>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

On Fri, May 14, 2021 at 11:19:20AM +0100, Mel Gorman wrote:
> On Thu, May 13, 2021 at 10:18:51PM +0200, Uladzislau Rezki wrote:
> > <SNIP>
> >
> > From the trace i get:
> > 
> > <snip>
> > [    0.243916] RIP: 0010:__alloc_pages+0x11e/0x310
> > [    0.243916] Code: 84 c0 0f 85 02 01 00 00 89 d8 48 8b 54 24 08 8b 74 24 1c c1 e8 0c 83 e0 01 88 44 24 20 48 8b 04 24 48 85 d2 0f 85 71 01 00 00 <3b> 70 08 0f 82 68 01 00 00 48 89 44 24 10 48 8b 00 89 da 81 e2 00
> > [    0.243916] RSP: 0000:ffffffffae803c38 EFLAGS: 00010246
> > [    0.243916] RAX: 0000000000001cc0 RBX: 0000000000002102 RCX: 0000000000000004
> > [    0.243916] RDX: 0000000000000000 RSI: 0000000000000002 RDI: 0000000000002102
> > [    0.243916] RBP: 0000000000000000 R08: 0000000000000000 R09: c0000000ffffdfff
> > [    0.243916] R10: 0000000000000001 R11: ffffffffae803ac0 R12: 0000000000000000
> > [    0.243916] R13: 0000000000002102 R14: 0000000000000001 R15: ffffa0938000d000
> > [    0.243916] FS:  0000000000000000(0000) GS:ffff893ab7c00000(0000) knlGS:0000000000000000
> > [    0.243916] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> > [    0.243916] CR2: 0000000000001cc8 CR3: 0000000176e10000 CR4: 00000000000006b0
> > [    0.243916] Call Trace:
> > [    0.243916]  __alloc_pages_bulk+0xaa1/0xb50
> > <snip>
> > 
> > (gdb) l *__alloc_pages+0x11e
> > 0xffffffff8129d87e is in __alloc_pages (./include/linux/mmzone.h:1095).
> > 1090            return zoneref->zone;
> > 1091    }
> > 1092
> > 1093    static inline int zonelist_zone_idx(struct zoneref *zoneref)
> > 1094    {
> > 1095            return zoneref->zone_idx;
> > 1096    }
> > 1097
> > 1098    static inline int zonelist_node_idx(struct zoneref *zoneref)
> > 1099    {
> > (gdb)
> > 
> > Seems like "zoneref" refers to invalid address.
> > 
> > Thoughts?
> 
> I have not previously read the patch but there are a few concerns and it's
> probably just as well this blew up early. The bulk allocator assumes a
> valid node but the patch can send in NUMA_NO_NODE (-1). 
>
Should the bulk-allocator handle the NUMA_NO_NODE on its own? I mean instead
of handling by user the allocator itself fixes it if NUMA_NO_NODE is passed.

>
> On the high-order path alloc_pages_node is used which checks nid == NUMA_NO_NODE.
> Also, area->pages is not necessarily initialised so that could be interpreted
> as a partially populated array so minmally you need.
>
area->pages are zeroed, because __GFP_ZERO is sued during allocating an array.

> 
> diff --git a/mm/vmalloc.c b/mm/vmalloc.c
> index f3c5dd4ccc5b9..b638ff31b07e1 100644
> --- a/mm/vmalloc.c
> +++ b/mm/vmalloc.c
> @@ -2792,6 +2792,9 @@ static void *__vmalloc_area_node(struct vm_struct *area, gfp_t gfp_mask,
>  	page_order = vm_area_page_order(area);
>  
>  	if (!page_order) {
> +		memset(area->pages, 0, array_size);
This memset is not needed as explained above.

> +		if (node == NUMA_NO_NODE)
> +			node = numa_mem_id();
This patch works. Again should it be processed by allocator?

>  		area->nr_pages = __alloc_pages_bulk(gfp_mask, node,
>  			NULL, nr_small_pages, NULL, area->pages);
>  	} else {
> 
> However, the high-order path also looks suspicious. area->nr_pages is
> advanced before the allocation attempt so in the event alloc_pages_node()
> returns NULL prematurely, area->nr_pages does not reflect the number of
> pages allocated so that needs examination.
> 
<snip>
    for (area->nr_pages = 0; area->nr_pages < nr_small_pages;
        area->nr_pages += 1U << page_order) {
<snip>

if alloc_pages_node() fails we break the loop. area->nr_pages is initialized
inside the for(...) loop, thus it will be zero if the single page allocator
fails on a first iteration.

Or i miss your point?

> As an aside, where or what is test_vmalloc.sh? It appears to have been
> used a few times but it's not clear it's representative so are you aware
> of workloads that are vmalloc-intensive? It does not matter for the
> patch as such but it would be nice to know examples of vmalloc-intensive
> workloads because I cannot recall a time during the last few years where
> I saw vmalloc.c high in profiles.
> 
test_vmalloc.sh is a shell script that is used for stressing and testing a
vmalloc subsystem as well as performance evaluation. You can find it here:

./tools/testing/selftests/vm/test_vmalloc.sh

As for workloads. Most of them which are critical to time and latency. For
example audio/video, especially in the mobile area. I did a big rework of
the KVA allocator because i found it not optimal to allocation time.

To be more specific, a high resolution audio playback was suffering from
the glitches due to a long allocation time and preemption issues.

--
Vlad Rezki
