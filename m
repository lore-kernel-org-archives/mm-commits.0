Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 67EEFC433B4
	for <mm-commits@archiver.kernel.org>; Sun, 16 May 2021 17:17:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 37A996113C
	for <mm-commits@archiver.kernel.org>; Sun, 16 May 2021 17:17:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229628AbhEPRS6 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 16 May 2021 13:18:58 -0400
Received: from mx2.suse.de ([195.135.220.15]:33470 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229459AbhEPRS5 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sun, 16 May 2021 13:18:57 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id D826CB18F;
        Sun, 16 May 2021 17:17:41 +0000 (UTC)
Date:   Sun, 16 May 2021 18:17:38 +0100
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
Message-ID: <20210516171738.GR3672@suse.de>
References: <20210513141858.GM3672@suse.de>
 <CA+KHdyXwdkosDYk4bKtRLVodrwUJnq3NN39xuRQzKJSPTn7+bQ@mail.gmail.com>
 <20210513155133.GN3672@suse.de>
 <20210513201851.GA55390@pc638.lan>
 <20210514101920.GO3672@suse.de>
 <20210514114543.GA7022@pc638.lan>
 <20210514134530.GP3672@suse.de>
 <20210514145026.GA7183@pc638.lan>
 <20210514154153.GQ3672@suse.de>
 <20210514171623.GA33527@pc638.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <20210514171623.GA33527@pc638.lan>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

On Fri, May 14, 2021 at 07:16:23PM +0200, Uladzislau Rezki wrote:
> > > See below an example of audio glitches. That was related to our phones
> > > and audio workloads:
> > > 
> > > # Explanation is here
> > > wget ftp://vps418301.ovh.net/incoming/analysis_audio_glitches.txt
> > > 
> > > # Audio 10 seconds sample is here.
> > > # The drop occurs at 00:09.295 you can hear it
> > > wget ftp://vps418301.ovh.net/incoming/tst_440_HZ_tmp_1.wav
> > > 
> > > Apart of that a slow allocation can course two type of issues. First one
> > > is direct. When for example a high-priority RT thread does some allocation
> > > to bypass data to DSP. Long latency courses a delay of data to be passed to
> > > DSP. This is drivers area.
> > > 
> > > Another example is when a task is doing an allocation and the RT task is
> > > placed onto a same CPU. In that case a long preemption-off(milliseconds)
> > > section can lead the RT task for starvation. For mobile devices it is UI
> > > stack where RT tasks are used. As a result we face frame drops.
> > > 
> > > All such issues have been solved after a rework:
> > > 
> > > wget ftp://vps418301.ovh.net/incoming/Reworking_of_KVA_allocator_in_Linux_kernel.pdf
> > > 
> > 
> > Thanks. That was enough for me to search to see what sort of general
> > workload would be affected. Mostly it's driver specific. A lot of the users
> > that would be potentially hot are already using kvmalloc so probably not
> > worth the effort so test_vmalloc.sh makes sense.
> > 
> You are welcome.
> 
> As for a helper. Does it sound good for you? BTW, once upon a time i had
> asked for it :)
> 

The intent was that instead of guessing in advance what APIs would be
needed that users would add an API helper where appropriate.

> From b4b0de2990defd43453ddcd2839521d117cb3bd9 Mon Sep 17 00:00:00 2001
> From: "Uladzislau Rezki (Sony)" <urezki@gmail.com>
> Date: Fri, 14 May 2021 18:39:08 +0200
> Subject: [PATCH] mm/page_alloc: Add an alloc_pages_bulk_array_node() helper
> 
> Add a "node" variant of the alloc_pages_bulk_array() function.
> The helper guarantees that a __alloc_pages_bulk() is invoked
> with a valid NUMA node id.
> 
> Signed-off-by: Uladzislau Rezki (Sony) <urezki@gmail.com>

Acked-by: Mel Gorman <mgorman@suse.de>

Include it as part of your series adding the vmalloc user.

-- 
Mel Gorman
SUSE Labs
