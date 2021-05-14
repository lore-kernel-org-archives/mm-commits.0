Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E3810C433ED
	for <mm-commits@archiver.kernel.org>; Fri, 14 May 2021 14:50:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B87D161480
	for <mm-commits@archiver.kernel.org>; Fri, 14 May 2021 14:50:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232956AbhENOvp (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 14 May 2021 10:51:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57380 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232509AbhENOvn (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 14 May 2021 10:51:43 -0400
Received: from mail-lf1-x12f.google.com (mail-lf1-x12f.google.com [IPv6:2a00:1450:4864:20::12f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8DDABC061574
        for <mm-commits@vger.kernel.org>; Fri, 14 May 2021 07:50:30 -0700 (PDT)
Received: by mail-lf1-x12f.google.com with SMTP id j10so43418640lfb.12
        for <mm-commits@vger.kernel.org>; Fri, 14 May 2021 07:50:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:date:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=2blpGc37g0BN3J79MfP+W42IEMaswWBDJu6Gtj1gxdg=;
        b=YI3ioRxxsKnIOpjTCSBfq42W8KmgKqjgkvwS2K3D+ym3lpKMjtZGD87d4N/vyyoxBg
         MI8aOr0/eIzYWkJRn0nHGpXOJfg8/hSSlq7E/jyGt5eL3Qvgr74cwHzjc5tsePFnm1zc
         FQLdsmqc0Pw6DddNyZah+Rwl5LkCo94I1z7nxyPQiCeK6jP4I22iqkTmJOSv1hc822pH
         nZx856VgaO95N0w175xj43ygq3SUpGF/Zcn2Y7yS9fpA2qO2FIH4YTzlzde5usxKaGb1
         fNwqmKvSvwxyibVOGQVi4j+U+74qClg7uyBR+vAB5pfwRatB5DMPbTktnKEZc08gwc+G
         g7jQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:date:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=2blpGc37g0BN3J79MfP+W42IEMaswWBDJu6Gtj1gxdg=;
        b=I8GGoe5dv3HhUGBPBYwEzzfIRsXz/87OeuzRr9jmbWBGDNYIlVJe3usjzeV6vpIe7w
         sL/qKm+Ps0YTE+fSrb3l7SG3NttZQy0sG6OkpsJ9N75O13NKknDM+4CAG9JfHQvK6IKg
         IoTVS2cg9JkGjXXFZFMFPVrtgz2QconaBcFTeBVsj/c3preU4r0zrx08O4Kwpvp7tGKT
         pRfWHErNokYHhQMsfDTuIRPVY/BEFmZX8OfkKS28lC50T3MiZEF2oFKQDGMBmS6riwz7
         nEykVg2zo+DdsL3J1Z3dVUbugj9xq1d0WcUpVqJ9qXiP+mts424+0mICX+Ka/rbMVfa/
         BMyw==
X-Gm-Message-State: AOAM532WNozJ3biqT2MHoANPdaCPYSqEtA+17nKIzXP+mAO3nCJeHGJu
        PSKIxNzVaU8g1yZXT8rg3OS7B7yk7MY=
X-Google-Smtp-Source: ABdhPJw1wv+4okb8jmmAOQ52dgYHTt8mvGogOfdG5T4BWn+imsO0JdLbu2ivJBKaUhm74Y8z7mtocA==
X-Received: by 2002:a05:6512:3b27:: with SMTP id f39mr10878781lfv.425.1621003828994;
        Fri, 14 May 2021 07:50:28 -0700 (PDT)
Received: from pc638.lan (h5ef52e3d.seluork.dyn.perspektivbredband.net. [94.245.46.61])
        by smtp.gmail.com with ESMTPSA id q66sm1174398ljb.3.2021.05.14.07.50.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 May 2021 07:50:28 -0700 (PDT)
From:   Uladzislau Rezki <urezki@gmail.com>
X-Google-Original-From: Uladzislau Rezki <urezki@pc638.lan>
Date:   Fri, 14 May 2021 16:50:26 +0200
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
Message-ID: <20210514145026.GA7183@pc638.lan>
References: <20210513111153.GL3672@suse.de>
 <20210513124605.GA3263@pc638.lan>
 <20210513132418.GA1425@pc638.lan>
 <20210513141858.GM3672@suse.de>
 <CA+KHdyXwdkosDYk4bKtRLVodrwUJnq3NN39xuRQzKJSPTn7+bQ@mail.gmail.com>
 <20210513155133.GN3672@suse.de>
 <20210513201851.GA55390@pc638.lan>
 <20210514101920.GO3672@suse.de>
 <20210514114543.GA7022@pc638.lan>
 <20210514134530.GP3672@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210514134530.GP3672@suse.de>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

> On Fri, May 14, 2021 at 01:45:43PM +0200, Uladzislau Rezki wrote:
> > > > Seems like "zoneref" refers to invalid address.
> > > > 
> > > > Thoughts?
> > > 
> > > I have not previously read the patch but there are a few concerns and it's
> > > probably just as well this blew up early. The bulk allocator assumes a
> > > valid node but the patch can send in NUMA_NO_NODE (-1). 
> > >
> >
> > Should the bulk-allocator handle the NUMA_NO_NODE on its own? I mean instead
> > of handling by user the allocator itself fixes it if NUMA_NO_NODE is passed.
> > 
> 
> No for API similarity reasons. __alloc_pages_bulk is the API bulk
> equivalent to __alloc_pages() and both expect valid node IDs. vmalloc
> is using alloc_pages_node for high-order pages which first checks
> the node ID so your options are to check it within vmalloc.c or add a
> alloc_pages_node_bulk helper that is API equivalent to alloc_pages_node
> as a prerequisite to your patch.
> 
OK. Thanks.

> > > On the high-order path alloc_pages_node is used which checks nid == NUMA_NO_NODE.
> > > Also, area->pages is not necessarily initialised so that could be interpreted
> > > as a partially populated array so minmally you need.
> > >
> >
> > area->pages are zeroed, because __GFP_ZERO is sued during allocating an array.
> > 
> 
> Ah, yes.
> 
> > > However, the high-order path also looks suspicious. area->nr_pages is
> > > advanced before the allocation attempt so in the event alloc_pages_node()
> > > returns NULL prematurely, area->nr_pages does not reflect the number of
> > > pages allocated so that needs examination.
> > > 
> > <snip>
> >     for (area->nr_pages = 0; area->nr_pages < nr_small_pages;
> >         area->nr_pages += 1U << page_order) {
> > <snip>
> > 
> > if alloc_pages_node() fails we break the loop. area->nr_pages is initialized
> > inside the for(...) loop, thus it will be zero if the single page allocator
> > fails on a first iteration.
> > 
> > Or i miss your point?
> > 
> 
> At the time of the break, area->nr_pages += 1U << page_order happened
> before the allocation failure happens. That looks very suspicious.
> 
The "for" loop does not work that way. If you break the loop the
"area->nr_pages += 1U << page_order" or an "increment" is not increased.
It is increased only after the body of the "for" loop executes and it
goes to next iteration.

> > > As an aside, where or what is test_vmalloc.sh? It appears to have been
> > > used a few times but it's not clear it's representative so are you aware
> > > of workloads that are vmalloc-intensive? It does not matter for the
> > > patch as such but it would be nice to know examples of vmalloc-intensive
> > > workloads because I cannot recall a time during the last few years where
> > > I saw vmalloc.c high in profiles.
> > > 
> > test_vmalloc.sh is a shell script that is used for stressing and testing a
> > vmalloc subsystem as well as performance evaluation. You can find it here:
> > 
> > ./tools/testing/selftests/vm/test_vmalloc.sh
> > 
> 
> Thanks.
> 
> > As for workloads. Most of them which are critical to time and latency. For
> > example audio/video, especially in the mobile area. I did a big rework of
> > the KVA allocator because i found it not optimal to allocation time.
> > 
> 
> Can you give an example benchmark that triggers it or is it somewhat
> specific to mobile platforms with drivers that use vmalloc heavily?
> 
See below an example of audio glitches. That was related to our phones
and audio workloads:

# Explanation is here
wget ftp://vps418301.ovh.net/incoming/analysis_audio_glitches.txt

# Audio 10 seconds sample is here.
# The drop occurs at 00:09.295 you can hear it
wget ftp://vps418301.ovh.net/incoming/tst_440_HZ_tmp_1.wav

Apart of that a slow allocation can course two type of issues. First one
is direct. When for example a high-priority RT thread does some allocation
to bypass data to DSP. Long latency courses a delay of data to be passed to
DSP. This is drivers area.

Another example is when a task is doing an allocation and the RT task is
placed onto a same CPU. In that case a long preemption-off(milliseconds)
section can lead the RT task for starvation. For mobile devices it is UI
stack where RT tasks are used. As a result we face frame drops.

All such issues have been solved after a rework:

wget ftp://vps418301.ovh.net/incoming/Reworking_of_KVA_allocator_in_Linux_kernel.pdf

--
Vlad Rezki
