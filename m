Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CC32EC433B4
	for <mm-commits@archiver.kernel.org>; Fri, 14 May 2021 13:45:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AE07A6145A
	for <mm-commits@archiver.kernel.org>; Fri, 14 May 2021 13:45:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231409AbhENNqq (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 14 May 2021 09:46:46 -0400
Received: from mx2.suse.de ([195.135.220.15]:44798 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230363AbhENNqq (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 14 May 2021 09:46:46 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id F006FADDD;
        Fri, 14 May 2021 13:45:33 +0000 (UTC)
Date:   Fri, 14 May 2021 14:45:30 +0100
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
Message-ID: <20210514134530.GP3672@suse.de>
References: <20210513103156.GA1856@pc638.lan>
 <20210513111153.GL3672@suse.de>
 <20210513124605.GA3263@pc638.lan>
 <20210513132418.GA1425@pc638.lan>
 <20210513141858.GM3672@suse.de>
 <CA+KHdyXwdkosDYk4bKtRLVodrwUJnq3NN39xuRQzKJSPTn7+bQ@mail.gmail.com>
 <20210513155133.GN3672@suse.de>
 <20210513201851.GA55390@pc638.lan>
 <20210514101920.GO3672@suse.de>
 <20210514114543.GA7022@pc638.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <20210514114543.GA7022@pc638.lan>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

On Fri, May 14, 2021 at 01:45:43PM +0200, Uladzislau Rezki wrote:
> > > Seems like "zoneref" refers to invalid address.
> > > 
> > > Thoughts?
> > 
> > I have not previously read the patch but there are a few concerns and it's
> > probably just as well this blew up early. The bulk allocator assumes a
> > valid node but the patch can send in NUMA_NO_NODE (-1). 
> >
>
> Should the bulk-allocator handle the NUMA_NO_NODE on its own? I mean instead
> of handling by user the allocator itself fixes it if NUMA_NO_NODE is passed.
> 

No for API similarity reasons. __alloc_pages_bulk is the API bulk
equivalent to __alloc_pages() and both expect valid node IDs. vmalloc
is using alloc_pages_node for high-order pages which first checks
the node ID so your options are to check it within vmalloc.c or add a
alloc_pages_node_bulk helper that is API equivalent to alloc_pages_node
as a prerequisite to your patch.

> >
> > On the high-order path alloc_pages_node is used which checks nid == NUMA_NO_NODE.
> > Also, area->pages is not necessarily initialised so that could be interpreted
> > as a partially populated array so minmally you need.
> >
>
> area->pages are zeroed, because __GFP_ZERO is sued during allocating an array.
> 

Ah, yes.

> > However, the high-order path also looks suspicious. area->nr_pages is
> > advanced before the allocation attempt so in the event alloc_pages_node()
> > returns NULL prematurely, area->nr_pages does not reflect the number of
> > pages allocated so that needs examination.
> > 
> <snip>
>     for (area->nr_pages = 0; area->nr_pages < nr_small_pages;
>         area->nr_pages += 1U << page_order) {
> <snip>
> 
> if alloc_pages_node() fails we break the loop. area->nr_pages is initialized
> inside the for(...) loop, thus it will be zero if the single page allocator
> fails on a first iteration.
> 
> Or i miss your point?
> 

At the time of the break, area->nr_pages += 1U << page_order happened
before the allocation failure happens. That looks very suspicious.

> > As an aside, where or what is test_vmalloc.sh? It appears to have been
> > used a few times but it's not clear it's representative so are you aware
> > of workloads that are vmalloc-intensive? It does not matter for the
> > patch as such but it would be nice to know examples of vmalloc-intensive
> > workloads because I cannot recall a time during the last few years where
> > I saw vmalloc.c high in profiles.
> > 
> test_vmalloc.sh is a shell script that is used for stressing and testing a
> vmalloc subsystem as well as performance evaluation. You can find it here:
> 
> ./tools/testing/selftests/vm/test_vmalloc.sh
> 

Thanks.

> As for workloads. Most of them which are critical to time and latency. For
> example audio/video, especially in the mobile area. I did a big rework of
> the KVA allocator because i found it not optimal to allocation time.
> 

Can you give an example benchmark that triggers it or is it somewhat
specific to mobile platforms with drivers that use vmalloc heavily?

-- 
Mel Gorman
SUSE Labs
