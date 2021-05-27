Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A2947C4707F
	for <mm-commits@archiver.kernel.org>; Thu, 27 May 2021 06:42:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7597F613CC
	for <mm-commits@archiver.kernel.org>; Thu, 27 May 2021 06:42:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229709AbhE0GoN (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 27 May 2021 02:44:13 -0400
Received: from szxga01-in.huawei.com ([45.249.212.187]:2062 "EHLO
        szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229740AbhE0GoM (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 27 May 2021 02:44:12 -0400
Received: from dggeme756-chm.china.huawei.com (unknown [172.30.72.54])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4FrJ6L3QlfzWnsW;
        Thu, 27 May 2021 14:38:02 +0800 (CST)
Received: from [127.0.0.1] (10.40.193.166) by dggeme756-chm.china.huawei.com
 (10.3.19.102) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2176.2; Thu, 27
 May 2021 14:42:37 +0800
Subject: Re: [PATCH] mm,kmemleak-test: add the dependency on CONFIG_SAMPLES
To:     Catalin Marinas <catalin.marinas@arm.com>
References: <1621995008-116893-1-git-send-email-chenxiang66@hisilicon.com>
 <20210526093047.GC19992@arm.com>
CC:     <sh_def@163.com>, <mm-commits@vger.kernel.org>,
        <linuxarm@openeuler.org>, <linuxarm@huawei.com>,
        Andrew Morton <akpm@linux-foundation.org>
From:   "chenxiang (M)" <chenxiang66@hisilicon.com>
Message-ID: <ab78b4fc-af91-e67e-2dbd-04d054ae80fc@hisilicon.com>
Date:   Thu, 27 May 2021 14:42:36 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:45.0) Gecko/20100101
 Thunderbird/45.2.0
MIME-Version: 1.0
In-Reply-To: <20210526093047.GC19992@arm.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.40.193.166]
X-ClientProxiedBy: dggems701-chm.china.huawei.com (10.3.19.178) To
 dggeme756-chm.china.huawei.com (10.3.19.102)
X-CFilter-Loop: Reflected
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

Hi Catalin,


在 2021/5/26 17:30, Catalin Marinas 写道:
> On Wed, May 26, 2021 at 10:10:08AM +0800, chenxiang wrote:
>> From: Xiang Chen <chenxiang66@hisilicon.com>
>>
>> As kmemleak-test.c is moved to samples dir, it is not compiled if just
>> setting CONFIG_DEBUG_KMEMLEAK_TEST as module and enabling
>> CONFIG_DEBUG_KMEMLEAK. Because it depends on CONFIG_SAMPLES after it is
>> moved to samples dir.
>> So the dependency on CONFIG_SAMPLES is added.
>>
>> Fixes: 1abbef4f5172 ("mm,kmemleak-test.c: move kmemleak-test.c to samples dir")
>> Signed-off-by: Xiang Chen <chenxiang66@hisilicon.com>
>> ---
>>   lib/Kconfig.debug | 2 +-
>>   1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
>> index 2779c29..9950542 100644
>> --- a/lib/Kconfig.debug
>> +++ b/lib/Kconfig.debug
>> @@ -716,7 +716,7 @@ config DEBUG_KMEMLEAK_MEM_POOL_SIZE
>>   
>>   config DEBUG_KMEMLEAK_TEST
>>   	tristate "Simple test for the kernel memory leak detector"
>> -	depends on DEBUG_KMEMLEAK && m
>> +	depends on DEBUG_KMEMLEAK && SAMPLES && m
>>   	help
>>   	  This option enables a module that explicitly leaks memory.
> Would it make more sense to move the DEBUG_KMEMLEAK_TEST option to
> samples as well and maybe rename it to SAMPLES_KMEMLEAK?

Right, it seems be better to move the option to samples dir and rename it.
I will change it in next verison.

>


