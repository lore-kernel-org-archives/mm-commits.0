Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7E80FC433EF
	for <mm-commits@archiver.kernel.org>; Thu, 28 Apr 2022 01:59:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241024AbiD1CC2 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 27 Apr 2022 22:02:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53056 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229972AbiD1CC1 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 27 Apr 2022 22:02:27 -0400
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E38706D97F
        for <mm-commits@vger.kernel.org>; Wed, 27 Apr 2022 18:59:13 -0700 (PDT)
Received: from canpemm500002.china.huawei.com (unknown [172.30.72.57])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4Kpf0T0nx0zfbCB;
        Thu, 28 Apr 2022 09:58:17 +0800 (CST)
Received: from [10.174.177.76] (10.174.177.76) by
 canpemm500002.china.huawei.com (7.192.104.244) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Thu, 28 Apr 2022 09:59:11 +0800
Subject: Re: [nacked]
 mm-vmscan-activate-swap-backed-executable-folios-after-first-usage.patch
 removed from -mm tree
To:     Andrew Morton <akpm@linux-foundation.org>
CC:     <mm-commits@vger.kernel.org>, <ying.huang@intel.com>,
        <osalvador@suse.de>, <iamjoonsoo.kim@lge.com>, <hch@lst.de>
References: <20220427062533.80485C385A7@smtp.kernel.org>
 <2e567a92-171e-26d5-2830-927c7f2f68a9@huawei.com>
 <20220427071601.d18f105d4934f0362f33472c@linux-foundation.org>
From:   Miaohe Lin <linmiaohe@huawei.com>
Message-ID: <b0f275e4-08df-74cc-3b8c-4e4e25949e35@huawei.com>
Date:   Thu, 28 Apr 2022 09:59:11 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <20220427071601.d18f105d4934f0362f33472c@linux-foundation.org>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.174.177.76]
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
 canpemm500002.china.huawei.com (7.192.104.244)
X-CFilter-Loop: Reflected
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

On 2022/4/27 22:16, Andrew Morton wrote:
> On Wed, 27 Apr 2022 14:41:30 +0800 Miaohe Lin <linmiaohe@huawei.com> wrote:
> 
>> On 2022/4/27 14:25, Andrew Morton wrote:
>>>
>>> The patch titled
>>>      Subject: mm/vmscan: activate swap-backed executable folios after first usage
>>> has been removed from the -mm tree.  Its filename was
>>>      mm-vmscan-activate-swap-backed-executable-folios-after-first-usage.patch
>>>
>>> This patch was dropped because it was nacked
>>
>> Hi Andrew,
>>
>> Since this patch is nacked, should I resend the whole series with this patch dropped?
>> And I'd like to change this patch to use the helper folio_is_file_lru too, something like below:
>>
>> diff --git a/mm/vmscan.c b/mm/vmscan.c
>> index ed484a0e9cd0..60ccbebec4c8 100644
>> --- a/mm/vmscan.c
>> +++ b/mm/vmscan.c
>> @@ -1412,9 +1412,9 @@ static enum page_references folio_check_references(struct folio *folio,
>>                         return PAGEREF_ACTIVATE;
>>
>>                 /*
>> -                * Activate executable folios after first usage.
>> +                * Activate file-backed executable folios after first usage.
>>                  */
>> -               if (vm_flags & VM_EXEC)
>> +               if ((vm_flags & VM_EXEC) && folio_is_file_lru(folio))
>>                         return PAGEREF_ACTIVATE;
>>
>>                 return PAGEREF_KEEP;
>>
>> Should I send this patch separately or resend the whole series with this new change attached?
>>
> 
> I dropped this patch individually, so there's no need to resend the others.

I see. Thanks!

> .
> 

