Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,UNPARSEABLE_RELAY,URIBL_RED,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 97F02C432C3
	for <mm-commits@archiver.kernel.org>; Sat, 13 Mar 2021 03:36:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6FF0A64F5B
	for <mm-commits@archiver.kernel.org>; Sat, 13 Mar 2021 03:36:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233205AbhCMDgO (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 12 Mar 2021 22:36:14 -0500
Received: from out4436.biz.mail.alibaba.com ([47.88.44.36]:29585 "EHLO
        out4436.biz.mail.alibaba.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233235AbhCMDf7 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>);
        Fri, 12 Mar 2021 22:35:59 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R781e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04394;MF=xlpang@linux.alibaba.com;NM=1;PH=DS;RN=13;SR=0;TI=SMTPD_---0URjPtuo_1615606545;
Received: from xunleideMacBook-Pro.local(mailfrom:xlpang@linux.alibaba.com fp:SMTPD_---0URjPtuo_1615606545)
          by smtp.aliyun-inc.com(127.0.0.1);
          Sat, 13 Mar 2021 11:35:46 +0800
Subject: Re: + mm-slub-introduce-two-counters-for-partial-objects.patch added
 to -mm tree
To:     Christoph Lameter <cl@gentwo.de>, akpm@linux-foundation.org
Cc:     guro@fb.com, iamjoonsoo.kim@lge.com, jnwang@linux.alibaba.com,
        khlebnikov@yandex-team.ru, mm-commits@vger.kernel.org,
        penberg@kernel.org, rientjes@google.com, sming56@gmail.com,
        vbabka@suse.cz, wenyang@linux.alibaba.com, willy@infradead.org
References: <20210311221459.k6DMM1FqH%akpm@linux-foundation.org>
 <alpine.DEB.2.22.394.2103120856290.207966@gentwo.de>
From:   Xunlei Pang <xlpang@linux.alibaba.com>
Message-ID: <74683920-d8f8-8900-06ed-8ccb2464f115@linux.alibaba.com>
Date:   Sat, 13 Mar 2021 11:35:45 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.12; rv:78.0)
 Gecko/20100101 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.22.394.2103120856290.207966@gentwo.de>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

On 3/12/21 4:01 PM, Christoph Lameter wrote:
> On Thu, 11 Mar 2021, akpm@linux-foundation.org wrote:
> 
>> This patch introduces two counters to maintain the actual number of
>> partial objects dynamically instead of iterating the partial page lists
>> with list_lock held.
> 
> Well these counters have to be maintained in the fast paths of the
> allocator. This approach increases the cache footprint, increases the
> complexity of fastpaths even more. It reduces performance (which may not
> be that visible in benchmarks that can keep the entire processing logic in
> l1 or so) and causes a future maintenance headache.
> 
> The only reason to use this counter that was given is to retrieve the
> current number of partial objects via sysfs. This is not a critical
> operation and the use of that sysfs file could be avoided.
> 
> Or we can simply remove the ability to retrieve the number of partial
> objects from sysfs?
> 

Not only sysfs, /proc/slabinfo is another user to calculate the
"active_objs", I'm afraid it's hard to change the ABI of this
commonly-used interface.
