Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CC8CCC433E0
	for <mm-commits@archiver.kernel.org>; Mon, 15 Mar 2021 18:30:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 98D8C64E4D
	for <mm-commits@archiver.kernel.org>; Mon, 15 Mar 2021 18:30:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232438AbhCOSaQ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 15 Mar 2021 14:30:16 -0400
Received: from mx2.suse.de ([195.135.220.15]:37090 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231931AbhCOS3w (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 15 Mar 2021 14:29:52 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 826BAAE44;
        Mon, 15 Mar 2021 18:29:51 +0000 (UTC)
Subject: Re: + mm-slub-introduce-two-counters-for-partial-objects.patch added
 to -mm tree
To:     Christoph Lameter <cl@gentwo.de>,
        Xunlei Pang <xlpang@linux.alibaba.com>
Cc:     akpm@linux-foundation.org, guro@fb.com, iamjoonsoo.kim@lge.com,
        jnwang@linux.alibaba.com, khlebnikov@yandex-team.ru,
        mm-commits@vger.kernel.org, penberg@kernel.org,
        rientjes@google.com, sming56@gmail.com, wenyang@linux.alibaba.com,
        willy@infradead.org, Thomas Gleixner <tglx@linutronix.de>
References: <20210311221459.k6DMM1FqH%akpm@linux-foundation.org>
 <alpine.DEB.2.22.394.2103120856290.207966@gentwo.de>
 <74683920-d8f8-8900-06ed-8ccb2464f115@linux.alibaba.com>
 <alpine.DEB.2.22.394.2103151512400.313667@gentwo.de>
From:   Vlastimil Babka <vbabka@suse.cz>
Message-ID: <ef56efe0-4e08-da62-2275-750f9a9b071c@suse.cz>
Date:   Mon, 15 Mar 2021 19:29:47 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.0
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.22.394.2103151512400.313667@gentwo.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

On 3/15/21 3:19 PM, Christoph Lameter wrote:
> On Sat, 13 Mar 2021, Xunlei Pang wrote:
> 
>> > Or we can simply remove the ability to retrieve the number of partial
>> > objects from sysfs?
>> >
>>
>> Not only sysfs, /proc/slabinfo is another user to calculate the
>> "active_objs", I'm afraid it's hard to change the ABI of this
>> commonly-used interface.
> 
> Well the field is there but is is used for any real purpose?

Well, some people would like to know how many objects are allocated.
But this patch series won't help them either, as besides the per-node partial
list, we have per-cpu slabs and per-cpu partial lists, and they all show up as
active in slabinfo, IIRC.

But let's move the discussion to the original patch posting thread on linux-mm,
not this mm-commits notification.

> Could potentially be replaced by the total objects possible in the slab
> cache.


