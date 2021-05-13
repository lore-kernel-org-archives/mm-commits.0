Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 26FB6C433ED
	for <mm-commits@archiver.kernel.org>; Thu, 13 May 2021 14:19:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 074D761438
	for <mm-commits@archiver.kernel.org>; Thu, 13 May 2021 14:19:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234412AbhEMOUZ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 13 May 2021 10:20:25 -0400
Received: from mx2.suse.de ([195.135.220.15]:56368 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234435AbhEMOUM (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 13 May 2021 10:20:12 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 7FF55AE27;
        Thu, 13 May 2021 14:19:01 +0000 (UTC)
Date:   Thu, 13 May 2021 15:18:58 +0100
From:   Mel Gorman <mgorman@suse.de>
To:     Uladzislau Rezki <urezki@gmail.com>
Cc:     Stephen Rothwell <sfr@canb.auug.org.au>, akpm@linux-foundation.org,
        hdanton@sina.com, mhocko@suse.com, mm-commits@vger.kernel.org,
        npiggin@gmail.com, oleksiy.avramchenko@sonymobile.com,
        rostedt@goodmis.org, willy@infradead.org
Subject: Re: [failures]
 mm-vmalloc-print-a-warning-message-first-on-failure.patch removed from -mm
 tree
Message-ID: <20210513141858.GM3672@suse.de>
References: <20210512202952.PRR7JClh8%akpm@linux-foundation.org>
 <20210513085602.6d3f9d63@canb.auug.org.au>
 <20210513103156.GA1856@pc638.lan>
 <20210513111153.GL3672@suse.de>
 <20210513124605.GA3263@pc638.lan>
 <20210513132418.GA1425@pc638.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <20210513132418.GA1425@pc638.lan>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

On Thu, May 13, 2021 at 03:24:18PM +0200, Uladzislau Rezki wrote:
> > > > What can of testing failures does it trigger? Where can i find the
> > > > details, logs or tracers of it?
> > > 
> > > https://lore.kernel.org/linux-next/20210512175359.17793d34@canb.auug.org.au/
> > > 
> > Thanks, Mel.
> > 
> > OK. Now i see. The problem is with this patch:
> > 
> > mm/vmalloc: switch to bulk allocator in __vmalloc_area_node()
> > 
> > <SNIP>
> > 
> > So during the boot process when the module is about to be loaded, the vmalloc allocation
> > gets failed in the __alloc_pages_bulk(). 
> > 
> > Will try to reproduce. It would be good to get a kernel config.
> > Appreciate for any thoughts about it?
> > 
> 
> I see that on the target machine when the problem occurs the PAGE_SIZE is 64K. 
> 
> Can it be somehow connected to it? Also one question, just guessing, the crash
> happens during the boot, therefore the question is: is __alloc_pages_bulk()
> fully initialized by that time? 
> 

A boot test on KVM using my distribution config (openSUSE Leap 15.2)
failed on x86-64 so it's not related to PAGE_SIZE.

-- 
Mel Gorman
SUSE Labs
