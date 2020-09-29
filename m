Return-Path: <SRS0=qjDH=DG=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.5 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C1E99C52D1C
	for <mm-commits@archiver.kernel.org>; Tue, 29 Sep 2020 20:38:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6689F2076B
	for <mm-commits@archiver.kernel.org>; Tue, 29 Sep 2020 20:38:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1601411883;
	bh=pej3i8Fp7E4wdyC/Wsu1e32Vb/B4fkkFtoSxRH29jkA=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:Reply-To:List-ID:
	 From;
	b=gAzKTXArbMXTjoNtJqFLvgAUeChZugPq9rkhrpHicuSaSKM3oeiIwPfQpc6m3VVHW
	 MPrJJpSerLrXK0dFD20MiNqbqp/Q7Q0nAd2YRBn9DxAPou0/9wfj73bNWOy8XWjFnj
	 MQpey4OqW0p3zPMoU1B5esNkwtaymQnT6+lT3mIE=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729232AbgI2UiB (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 29 Sep 2020 16:38:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:47862 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729382AbgI2Uhk (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 29 Sep 2020 16:37:40 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AA7E92076B;
        Tue, 29 Sep 2020 20:37:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601411859;
        bh=pej3i8Fp7E4wdyC/Wsu1e32Vb/B4fkkFtoSxRH29jkA=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=jXNQVeZZouWXXlbfeSRSyRiwNK7N07QFHzgKhujNIRSSyy9wM8u3U9ltZVTEhhPG7
         NJuO/2ENgiQFiYzJpLnVhKQvkQV9BaIEv/058+0a4kuT1pjxAnOE3yrziUfRzGLnKe
         oyj7DatEcLFV2OEAYaQNK3VUZq2sJslV7SYVYD0Q=
Date:   Tue, 29 Sep 2020 13:37:37 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     cheloha@linux.ibm.com, David Hildenbrand <david@redhat.com>,
        Fenghua Yu <fenghua.yu@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        ldufour@linux.ibm.com, Linux-MM <linux-mm@kvack.org>,
        Michal Hocko <mhocko@suse.com>, mm-commits@vger.kernel.org,
        nathanl@linux.ibm.com, Oscar Salvador <osalvador@suse.de>,
        Rafael Wysocki <rafael@kernel.org>,
        stable <stable@vger.kernel.org>, Tony Luck <tony.luck@intel.com>
Subject: Re: [patch 8/9] mm: replace memmap_context by meminit_context
Message-Id: <20200929133737.99427221b858425e5ddff706@linux-foundation.org>
In-Reply-To: <CAHk-=wjcg4ni8_zhGDS9vTQQYM-3ZBg4hGF7Ot9MzW5F2o7mpA@mail.gmail.com>
References: <20200925211725.0fea54be9e9715486efea21f@linux-foundation.org>
        <20200926041928.9xJHGgkah%akpm@linux-foundation.org>
        <CAHk-=wjcg4ni8_zhGDS9vTQQYM-3ZBg4hGF7Ot9MzW5F2o7mpA@mail.gmail.com>
X-Mailer: Sylpheed 3.5.1 (GTK+ 2.24.31; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

On Sat, 26 Sep 2020 10:32:15 -0700 Linus Torvalds <torvalds@linux-foundation.org> wrote:

> The explanations here do not make sense.
> 
> On Fri, Sep 25, 2020 at 9:19 PM Andrew Morton <akpm@linux-foundation.org> wrote:
> >
> >
> > There are 2 issues here:
> >
> > a. The sysfs memory and node's layouts are broken due to these multiple
> >    links
> >
> > b. The link errors in link_mem_sections() should not lead to a system
> >    panic.
> >
> > To address a. register_mem_sect_under_node should not rely on the system
> > state to detect whether the link operation is triggered by a hot plug
> > operation or not. This is addressed by the patches 1 and 2 of this series.
> >
> > The patch 3 is addressing the point b.
> >
> > This patch (of 2):
> >
> > The memmap_context enum is used to detect whether a memory operation is due
> > to a hot-add operation or happening at boot time.
> >
> > Make it general to the hotplug operation and rename it as meminit_context.
> >
> > There is no functional change introduced by this patch
> 
> So far so good.
> 
> But there is no "patch 3" that addresses point (b) in this series.
> 
> I see it on lore, but it's not part of what actually got sent to me,
> so the commit message for patch 1 now makes no sense any more.
> 

1/3 and 2/3 were cc:stable and 3/3 was not.  As far as I can tell, 3/3
is rather theoretical once 2/3 has done its work, so I held it off for
the next merge window.

