Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 54A89C433ED
	for <mm-commits@archiver.kernel.org>; Fri, 14 May 2021 15:41:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 309D6613DF
	for <mm-commits@archiver.kernel.org>; Fri, 14 May 2021 15:41:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233095AbhENPnJ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 14 May 2021 11:43:09 -0400
Received: from mx2.suse.de ([195.135.220.15]:51746 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232426AbhENPnI (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 14 May 2021 11:43:08 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 59C55B0D7;
        Fri, 14 May 2021 15:41:56 +0000 (UTC)
Date:   Fri, 14 May 2021 16:41:53 +0100
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
Message-ID: <20210514154153.GQ3672@suse.de>
References: <20210513124605.GA3263@pc638.lan>
 <20210513132418.GA1425@pc638.lan>
 <20210513141858.GM3672@suse.de>
 <CA+KHdyXwdkosDYk4bKtRLVodrwUJnq3NN39xuRQzKJSPTn7+bQ@mail.gmail.com>
 <20210513155133.GN3672@suse.de>
 <20210513201851.GA55390@pc638.lan>
 <20210514101920.GO3672@suse.de>
 <20210514114543.GA7022@pc638.lan>
 <20210514134530.GP3672@suse.de>
 <20210514145026.GA7183@pc638.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <20210514145026.GA7183@pc638.lan>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

On Fri, May 14, 2021 at 04:50:26PM +0200, Uladzislau Rezki wrote:
> > > > However, the high-order path also looks suspicious. area->nr_pages is
> > > > advanced before the allocation attempt so in the event alloc_pages_node()
> > > > returns NULL prematurely, area->nr_pages does not reflect the number of
> > > > pages allocated so that needs examination.
> > > > 
> > > <snip>
> > >     for (area->nr_pages = 0; area->nr_pages < nr_small_pages;
> > >         area->nr_pages += 1U << page_order) {
> > > <snip>
> > > 
> > > if alloc_pages_node() fails we break the loop. area->nr_pages is initialized
> > > inside the for(...) loop, thus it will be zero if the single page allocator
> > > fails on a first iteration.
> > > 
> > > Or i miss your point?
> > > 
> > 
> > At the time of the break, area->nr_pages += 1U << page_order happened
> > before the allocation failure happens. That looks very suspicious.
> > 
> The "for" loop does not work that way. If you break the loop the
> "area->nr_pages += 1U << page_order" or an "increment" is not increased.
> It is increased only after the body of the "for" loop executes and it
> goes to next iteration.
> 

Yeah, I don't know what I was thinking -- not properly anyway.

> > > As for workloads. Most of them which are critical to time and latency. For
> > > example audio/video, especially in the mobile area. I did a big rework of
> > > the KVA allocator because i found it not optimal to allocation time.
> > > 
> > 
> > Can you give an example benchmark that triggers it or is it somewhat
> > specific to mobile platforms with drivers that use vmalloc heavily?
> > 
>
> See below an example of audio glitches. That was related to our phones
> and audio workloads:
> 
> # Explanation is here
> wget ftp://vps418301.ovh.net/incoming/analysis_audio_glitches.txt
> 
> # Audio 10 seconds sample is here.
> # The drop occurs at 00:09.295 you can hear it
> wget ftp://vps418301.ovh.net/incoming/tst_440_HZ_tmp_1.wav
> 
> Apart of that a slow allocation can course two type of issues. First one
> is direct. When for example a high-priority RT thread does some allocation
> to bypass data to DSP. Long latency courses a delay of data to be passed to
> DSP. This is drivers area.
> 
> Another example is when a task is doing an allocation and the RT task is
> placed onto a same CPU. In that case a long preemption-off(milliseconds)
> section can lead the RT task for starvation. For mobile devices it is UI
> stack where RT tasks are used. As a result we face frame drops.
> 
> All such issues have been solved after a rework:
> 
> wget ftp://vps418301.ovh.net/incoming/Reworking_of_KVA_allocator_in_Linux_kernel.pdf
> 

Thanks. That was enough for me to search to see what sort of general
workload would be affected. Mostly it's driver specific. A lot of the users
that would be potentially hot are already using kvmalloc so probably not
worth the effort so test_vmalloc.sh makes sense.

-- 
Mel Gorman
SUSE Labs
