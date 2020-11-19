Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,UNPARSEABLE_RELAY,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6D8EAC388F9
	for <mm-commits@archiver.kernel.org>; Thu, 19 Nov 2020 06:28:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 206EB246AD
	for <mm-commits@archiver.kernel.org>; Thu, 19 Nov 2020 06:28:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725915AbgKSG20 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 19 Nov 2020 01:28:26 -0500
Received: from out30-133.freemail.mail.aliyun.com ([115.124.30.133]:55120 "EHLO
        out30-133.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725907AbgKSG20 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>);
        Thu, 19 Nov 2020 01:28:26 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R671e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04407;MF=alex.shi@linux.alibaba.com;NM=1;PH=DS;RN=28;SR=0;TI=SMTPD_---0UFsdp9c_1605767299;
Received: from IT-FVFX43SYHV2H.local(mailfrom:alex.shi@linux.alibaba.com fp:SMTPD_---0UFsdp9c_1605767299)
          by smtp.aliyun-inc.com(127.0.0.1);
          Thu, 19 Nov 2020 14:28:20 +0800
Subject: Re: + mm-lru-replace-pgdat-lru_lock-with-lruvec-lock.patch added to
 -mm tree
To:     akpm@linux-foundation.org, aarcange@redhat.com,
        alexander.duyck@gmail.com, aryabinin@virtuozzo.com,
        daniel.m.jordan@oracle.com, hannes@cmpxchg.org, hughd@google.com,
        iamjoonsoo.kim@lge.com, jannh@google.com,
        khlebnikov@yandex-team.ru, kirill.shutemov@linux.intel.com,
        kirill@shutemov.name, mgorman@techsingularity.net,
        mhocko@kernel.org, mhocko@suse.com, mika.penttila@nextfour.com,
        minchan@kernel.org, mm-commits@vger.kernel.org,
        richard.weiyang@gmail.com, rong.a.chen@intel.com,
        shakeelb@google.com, tglx@linutronix.de, tj@kernel.org,
        vbabka@suse.cz, vdavydov.dev@gmail.com, willy@infradead.org,
        yang.shi@linux.alibaba.com, ying.huang@intel.com
References: <20201116215748.Yk38422l-%akpm@linux-foundation.org>
From:   Alex Shi <alex.shi@linux.alibaba.com>
Message-ID: <2ecb6ce8-f0ae-04a7-c6dd-b1b0968a217c@linux.alibaba.com>
Date:   Thu, 19 Nov 2020 14:26:46 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <20201116215748.Yk38422l-%akpm@linux-foundation.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org



在 2020/11/17 上午5:57, akpm@linux-foundation.org 写道:
> On a large machine with memcg enabled but not used, the page's lruvec
> seeking pass a few pointers, that may lead to lru_lock holding time
> increase and a bit regression.

Hi Andrew,

Few pointer walking actually has no clear impact in above mentioned
situation, so could you please remove above section? when you merge the
3 'replace lru pgdat lru_lock' patches linux-next/akpm or master branch.

3d0d6a8434e1 mm-lru-replace-pgdat-lru_lock-with-lruvec-lock-fix-2
6bffb6674742 mm-lru-replace-pgdat-lru_lock-with-lruvec-lock-fix
7c3520054e02 mm/lru: replace pgdat lru_lock with lruvec lock


Also thanks a lot for couple commit log polish on whole series!

Thanks again!
Alex
