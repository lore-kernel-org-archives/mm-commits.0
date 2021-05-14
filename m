Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7AAEEC433B4
	for <mm-commits@archiver.kernel.org>; Fri, 14 May 2021 17:19:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 523CF6144B
	for <mm-commits@archiver.kernel.org>; Fri, 14 May 2021 17:19:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230146AbhENRRl (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 14 May 2021 13:17:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33556 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230063AbhENRRk (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 14 May 2021 13:17:40 -0400
Received: from mail-lj1-x22a.google.com (mail-lj1-x22a.google.com [IPv6:2a00:1450:4864:20::22a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 06E7AC061574
        for <mm-commits@vger.kernel.org>; Fri, 14 May 2021 10:16:27 -0700 (PDT)
Received: by mail-lj1-x22a.google.com with SMTP id c15so24167764ljr.7
        for <mm-commits@vger.kernel.org>; Fri, 14 May 2021 10:16:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:date:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=FGBuPJRZ3E7Amz176/HhFBIVfu2aWu7JfR6bdOx9tXg=;
        b=fOX6iR+ExP8yOCqaK+/ZwZiH7wGu0MsLffTwty7E7aVzSXDBIvxHHxiiYGr4PZP+cM
         iXPouztpK13Fxs0NVgVfnMjH+TwviLSjpiEjANYlaPekj5wANxBNoG+LctjuPCjnu0qr
         m5vWWDwFiBQn3adrKH/TrDIsjGNNfB3fh8mQALb7bAQWIHHU2CMND7+fZUmWwwMW4eNX
         bYaFCyJfZGix9eF8QA+dDqU6JhrCAYHzqdLV6K9Rbl0HcmqqAliLHB1+FZ6K5rw/YRfi
         npnwzc4u0WEBnbeYxejA/iYEL7ego1DZnb++jD7sA2xxXnGkfaHOiHDK8m/9rX0Rd6FK
         syrQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:date:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=FGBuPJRZ3E7Amz176/HhFBIVfu2aWu7JfR6bdOx9tXg=;
        b=cI0i4CCMt0liPa0uSmQ2kPtbrZm3/iD0y8+oRsE9RH39Qvh2TBlEdNZ3GqGjk6lNrV
         dQUfeEL18CyifEFrTsGyTYYeocH9EYsMxMP/4PEoCqYgtAoSKognuLDq9BbPnWlxB5yQ
         2W3pU+DJG1+71WHYRJ8G+DCfxbeabL86dvpDbJabh6f8IWgnRel/U/t4ZDCQmRn593qV
         zmkWNsyv/1cDWjK3XKOkp3UTRsiDjN5gyGGzb1REy5JMlZP3RUboma0VCO+ik2/dYCHh
         CyeNqF8PST0z+32HMqUblDOewPzmIcD7+pLBz/n+v2C00goW6vfk9LZaRwp2QQdO4C++
         8GyQ==
X-Gm-Message-State: AOAM532Sj4qyGcTB3tDANkBLe03KGU0W6AwxIY/bo2X6V6VYRQbg695U
        T4YsMthBh5SatbLcKKoDz14=
X-Google-Smtp-Source: ABdhPJx8NJwODl/M8E6B1wgD4mFaMCwva6OrkFxvfLfWsTCD+PL55cMGWtFvl3b1CPa0aMjTfyEI3A==
X-Received: by 2002:a2e:5342:: with SMTP id t2mr32082674ljd.321.1621012586196;
        Fri, 14 May 2021 10:16:26 -0700 (PDT)
Received: from pc638.lan (h5ef52e3d.seluork.dyn.perspektivbredband.net. [94.245.46.61])
        by smtp.gmail.com with ESMTPSA id b6sm841705lff.15.2021.05.14.10.16.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 May 2021 10:16:25 -0700 (PDT)
From:   Uladzislau Rezki <urezki@gmail.com>
X-Google-Original-From: Uladzislau Rezki <urezki@pc638.lan>
Date:   Fri, 14 May 2021 19:16:23 +0200
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
Message-ID: <20210514171623.GA33527@pc638.lan>
References: <20210513132418.GA1425@pc638.lan>
 <20210513141858.GM3672@suse.de>
 <CA+KHdyXwdkosDYk4bKtRLVodrwUJnq3NN39xuRQzKJSPTn7+bQ@mail.gmail.com>
 <20210513155133.GN3672@suse.de>
 <20210513201851.GA55390@pc638.lan>
 <20210514101920.GO3672@suse.de>
 <20210514114543.GA7022@pc638.lan>
 <20210514134530.GP3672@suse.de>
 <20210514145026.GA7183@pc638.lan>
 <20210514154153.GQ3672@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210514154153.GQ3672@suse.de>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

On Fri, May 14, 2021 at 04:41:53PM +0100, Mel Gorman wrote:
> On Fri, May 14, 2021 at 04:50:26PM +0200, Uladzislau Rezki wrote:
> > > > > However, the high-order path also looks suspicious. area->nr_pages is
> > > > > advanced before the allocation attempt so in the event alloc_pages_node()
> > > > > returns NULL prematurely, area->nr_pages does not reflect the number of
> > > > > pages allocated so that needs examination.
> > > > > 
> > > > <snip>
> > > >     for (area->nr_pages = 0; area->nr_pages < nr_small_pages;
> > > >         area->nr_pages += 1U << page_order) {
> > > > <snip>
> > > > 
> > > > if alloc_pages_node() fails we break the loop. area->nr_pages is initialized
> > > > inside the for(...) loop, thus it will be zero if the single page allocator
> > > > fails on a first iteration.
> > > > 
> > > > Or i miss your point?
> > > > 
> > > 
> > > At the time of the break, area->nr_pages += 1U << page_order happened
> > > before the allocation failure happens. That looks very suspicious.
> > > 
> > The "for" loop does not work that way. If you break the loop the
> > "area->nr_pages += 1U << page_order" or an "increment" is not increased.
> > It is increased only after the body of the "for" loop executes and it
> > goes to next iteration.
> > 
> 
> Yeah, I don't know what I was thinking -- not properly anyway.
> 
Hm.. To me it looks properly enough. Will see what i can do with it.

> > > > As for workloads. Most of them which are critical to time and latency. For
> > > > example audio/video, especially in the mobile area. I did a big rework of
> > > > the KVA allocator because i found it not optimal to allocation time.
> > > > 
> > > 
> > > Can you give an example benchmark that triggers it or is it somewhat
> > > specific to mobile platforms with drivers that use vmalloc heavily?
> > > 
> >
> > See below an example of audio glitches. That was related to our phones
> > and audio workloads:
> > 
> > # Explanation is here
> > wget ftp://vps418301.ovh.net/incoming/analysis_audio_glitches.txt
> > 
> > # Audio 10 seconds sample is here.
> > # The drop occurs at 00:09.295 you can hear it
> > wget ftp://vps418301.ovh.net/incoming/tst_440_HZ_tmp_1.wav
> > 
> > Apart of that a slow allocation can course two type of issues. First one
> > is direct. When for example a high-priority RT thread does some allocation
> > to bypass data to DSP. Long latency courses a delay of data to be passed to
> > DSP. This is drivers area.
> > 
> > Another example is when a task is doing an allocation and the RT task is
> > placed onto a same CPU. In that case a long preemption-off(milliseconds)
> > section can lead the RT task for starvation. For mobile devices it is UI
> > stack where RT tasks are used. As a result we face frame drops.
> > 
> > All such issues have been solved after a rework:
> > 
> > wget ftp://vps418301.ovh.net/incoming/Reworking_of_KVA_allocator_in_Linux_kernel.pdf
> > 
> 
> Thanks. That was enough for me to search to see what sort of general
> workload would be affected. Mostly it's driver specific. A lot of the users
> that would be potentially hot are already using kvmalloc so probably not
> worth the effort so test_vmalloc.sh makes sense.
> 
You are welcome.

As for a helper. Does it sound good for you? BTW, once upon a time i had
asked for it :)

From b4b0de2990defd43453ddcd2839521d117cb3bd9 Mon Sep 17 00:00:00 2001
From: "Uladzislau Rezki (Sony)" <urezki@gmail.com>
Date: Fri, 14 May 2021 18:39:08 +0200
Subject: [PATCH] mm/page_alloc: Add an alloc_pages_bulk_array_node() helper

Add a "node" variant of the alloc_pages_bulk_array() function.
The helper guarantees that a __alloc_pages_bulk() is invoked
with a valid NUMA node id.

Signed-off-by: Uladzislau Rezki (Sony) <urezki@gmail.com>
---
 include/linux/gfp.h | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/include/linux/gfp.h b/include/linux/gfp.h
index 11da8af06704..94f0b8b1cb55 100644
--- a/include/linux/gfp.h
+++ b/include/linux/gfp.h
@@ -536,6 +536,15 @@ alloc_pages_bulk_array(gfp_t gfp, unsigned long nr_pages, struct page **page_arr
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
-- 
2.20.1

--
Vlad Rezki
