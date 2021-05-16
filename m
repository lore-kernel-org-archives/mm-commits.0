Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.2 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7A28CC433ED
	for <mm-commits@archiver.kernel.org>; Sun, 16 May 2021 20:31:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4CB9060C3E
	for <mm-commits@archiver.kernel.org>; Sun, 16 May 2021 20:31:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233548AbhEPUdL (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 16 May 2021 16:33:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54692 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231491AbhEPUdK (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 16 May 2021 16:33:10 -0400
Received: from mail-lf1-x134.google.com (mail-lf1-x134.google.com [IPv6:2a00:1450:4864:20::134])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B0EAC061573
        for <mm-commits@vger.kernel.org>; Sun, 16 May 2021 13:31:54 -0700 (PDT)
Received: by mail-lf1-x134.google.com with SMTP id h4so5822744lfv.0
        for <mm-commits@vger.kernel.org>; Sun, 16 May 2021 13:31:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:date:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=PKtg9DoOG8FHazWAqL6GXaGKpIwRoq8OYG6RH0MXmnI=;
        b=fx8Fl+9fBNVhvIDDktQRFqAQqkEd0/R7+f9s3r+YxEGosUx8RNLNWu4YYm0P0kqxg0
         r8d91zU8JjXMuOPNox2rJ2Gj5yC51K1fB600ItodWYDfMX8snbcVXX9RV4q00SE9DOSi
         3dxjypd8w3WQHHswByRbgJ0ct/NoIv1DiFQRjHotYvZjLr02dqkxmQ5rk3LauiPhOrp+
         moj0Ye1uXFdvstQICk2JdmhF72YoSm5XgpmPaW/mlzPuj1Qft0+dzfgV/2zISWYjYs1U
         lVMm+rHLBEudqTWMvFLl9yxON3IUNl7fNzqDCYvlUTmUaOAWETPpPKJxe/+fS+pmIbIB
         vkWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:date:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=PKtg9DoOG8FHazWAqL6GXaGKpIwRoq8OYG6RH0MXmnI=;
        b=e1A495HFGtEnQqtVQwrog4o763KzrR2E9rAFAsEfwtth2NeuW5T7v8GKiewDmG3jJv
         gdTF08YQBOC766q/1HfG2Md0Jtqn6RAn3ZshjufKC+MMIjfmKss9MnhEvmzSBcD7NKqp
         8waJO4YsrX5/SD48MYnIzjvwwFZxKStXCGuPKqfqxLNo+Ds4kQspe/ef+Dgh6mjrL4NG
         S/DjAhpZmR62ZLqi+SFavqpEYGrdQ3rftLQVmCNjzgCDRJo75NWShcp7XlgklWfbFzMz
         /P38k/mR6sYggFnyqLgPvmxYbyU7JbDTJy7xHXkSdu6ErlErubudMlQ9yXmZAz1WZJrT
         fwRw==
X-Gm-Message-State: AOAM530hmH885A9S4gVBtQqQJbV1kT4DXqMR2q5/soZuS4Bqg7o9GeJL
        8OhoiNYViAnnl3rGFhHweEM=
X-Google-Smtp-Source: ABdhPJz8L/5uzOLTkm+ULzVLHoBeqy9amvED5fR7eqRbh5JfAs2FOuW/zjIOUyRdN/VeCMxAZEXChQ==
X-Received: by 2002:a19:6a06:: with SMTP id u6mr5428541lfu.626.1621197112976;
        Sun, 16 May 2021 13:31:52 -0700 (PDT)
Received: from pc638.lan (h5ef52e3d.seluork.dyn.perspektivbredband.net. [94.245.46.61])
        by smtp.gmail.com with ESMTPSA id d7sm1753395lfg.253.2021.05.16.13.31.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 16 May 2021 13:31:52 -0700 (PDT)
From:   Uladzislau Rezki <urezki@gmail.com>
X-Google-Original-From: Uladzislau Rezki <urezki@pc638.lan>
Date:   Sun, 16 May 2021 22:31:50 +0200
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
Message-ID: <20210516203150.GA2200@pc638.lan>
References: <CA+KHdyXwdkosDYk4bKtRLVodrwUJnq3NN39xuRQzKJSPTn7+bQ@mail.gmail.com>
 <20210513155133.GN3672@suse.de>
 <20210513201851.GA55390@pc638.lan>
 <20210514101920.GO3672@suse.de>
 <20210514114543.GA7022@pc638.lan>
 <20210514134530.GP3672@suse.de>
 <20210514145026.GA7183@pc638.lan>
 <20210514154153.GQ3672@suse.de>
 <20210514171623.GA33527@pc638.lan>
 <20210516171738.GR3672@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210516171738.GR3672@suse.de>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

On Sun, May 16, 2021 at 06:17:38PM +0100, Mel Gorman wrote:
> On Fri, May 14, 2021 at 07:16:23PM +0200, Uladzislau Rezki wrote:
> > > > See below an example of audio glitches. That was related to our phones
> > > > and audio workloads:
> > > > 
> > > > # Explanation is here
> > > > wget ftp://vps418301.ovh.net/incoming/analysis_audio_glitches.txt
> > > > 
> > > > # Audio 10 seconds sample is here.
> > > > # The drop occurs at 00:09.295 you can hear it
> > > > wget ftp://vps418301.ovh.net/incoming/tst_440_HZ_tmp_1.wav
> > > > 
> > > > Apart of that a slow allocation can course two type of issues. First one
> > > > is direct. When for example a high-priority RT thread does some allocation
> > > > to bypass data to DSP. Long latency courses a delay of data to be passed to
> > > > DSP. This is drivers area.
> > > > 
> > > > Another example is when a task is doing an allocation and the RT task is
> > > > placed onto a same CPU. In that case a long preemption-off(milliseconds)
> > > > section can lead the RT task for starvation. For mobile devices it is UI
> > > > stack where RT tasks are used. As a result we face frame drops.
> > > > 
> > > > All such issues have been solved after a rework:
> > > > 
> > > > wget ftp://vps418301.ovh.net/incoming/Reworking_of_KVA_allocator_in_Linux_kernel.pdf
> > > > 
> > > 
> > > Thanks. That was enough for me to search to see what sort of general
> > > workload would be affected. Mostly it's driver specific. A lot of the users
> > > that would be potentially hot are already using kvmalloc so probably not
> > > worth the effort so test_vmalloc.sh makes sense.
> > > 
> > You are welcome.
> > 
> > As for a helper. Does it sound good for you? BTW, once upon a time i had
> > asked for it :)
> > 
> 
> The intent was that instead of guessing in advance what APIs would be
> needed that users would add an API helper where appropriate.
> 
> > From b4b0de2990defd43453ddcd2839521d117cb3bd9 Mon Sep 17 00:00:00 2001
> > From: "Uladzislau Rezki (Sony)" <urezki@gmail.com>
> > Date: Fri, 14 May 2021 18:39:08 +0200
> > Subject: [PATCH] mm/page_alloc: Add an alloc_pages_bulk_array_node() helper
> > 
> > Add a "node" variant of the alloc_pages_bulk_array() function.
> > The helper guarantees that a __alloc_pages_bulk() is invoked
> > with a valid NUMA node id.
> > 
> > Signed-off-by: Uladzislau Rezki (Sony) <urezki@gmail.com>
> 
> Acked-by: Mel Gorman <mgorman@suse.de>
> 
Thanks!

--
Vlad Rezki
