Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 04B55C433EF
	for <mm-commits@archiver.kernel.org>; Fri, 17 Jun 2022 07:15:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1380515AbiFQHPH convert rfc822-to-8bit (ORCPT
        <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 17 Jun 2022 03:15:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55286 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1380462AbiFQHPG (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 17 Jun 2022 03:15:06 -0400
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C01BD64D30
        for <mm-commits@vger.kernel.org>; Fri, 17 Jun 2022 00:15:03 -0700 (PDT)
Received: from dggpemm500024.china.huawei.com (unknown [172.30.72.56])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4LPVb13rVHzSgxx;
        Fri, 17 Jun 2022 15:11:41 +0800 (CST)
Received: from dggpemm500007.china.huawei.com (7.185.36.183) by
 dggpemm500024.china.huawei.com (7.185.36.203) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Fri, 17 Jun 2022 15:14:47 +0800
Received: from dggpemm500006.china.huawei.com (7.185.36.236) by
 dggpemm500007.china.huawei.com (7.185.36.183) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Fri, 17 Jun 2022 15:14:45 +0800
Received: from dggpemm500006.china.huawei.com ([7.185.36.236]) by
 dggpemm500006.china.huawei.com ([7.185.36.236]) with mapi id 15.01.2375.024;
 Fri, 17 Jun 2022 15:14:45 +0800
From:   "chenjun (AM)" <chenjun102@huawei.com>
To:     Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
CC:     "mm-commits@vger.kernel.org" <mm-commits@vger.kernel.org>,
        "peterz@infradead.org" <peterz@infradead.org>
Subject: Re: + lockdep-make-prove_raw_lock_nesting-depend-on-preempt_rt.patch
 added to mm-nonmm-unstable branch
Thread-Topic: + lockdep-make-prove_raw_lock_nesting-depend-on-preempt_rt.patch
 added to mm-nonmm-unstable branch
Thread-Index: AQHYgbkgh7IedBkp6UKu4ssMM03ZDA==
Date:   Fri, 17 Jun 2022 07:14:45 +0000
Message-ID: <3c8068a1a2be4e94b41c5906a47ecf9e@huawei.com>
References: <20220616194128.A66B3C34114@smtp.kernel.org>
 <YqwX+ppqtMz6O5Y+@linutronix.de>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.174.178.43]
Content-Type: text/plain; charset="iso-2022-jp"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-CFilter-Loop: Reflected
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

在 2022/6/17 13:59, Sebastian Andrzej Siewior 写道:
> On 2022-06-16 12:41:27 [-0700], Andrew Morton wrote:
>> ------------------------------------------------------
>> From: Chen Jun <chenjun102@huawei.com>
>> Subject: lockdep: make PROVE_RAW_LOCK_NESTING depend on PREEMPT_RT
>> Date: Thu, 16 Jun 2022 02:29:11 +0000
>>
>> CONFIG_PROVE_RAW_LOCK_NESTING is used to check two things.
>> 1. calling spin_lock in hardirq.
>> 2. raw_spinlock - spinlock nesting.
>> The error messages like below:
>> [   13.485711] [ BUG: Invalid wait context ]
>>
>> However there is no problem on non-PREEMPT_RT kernel. The messages may be
>> confusing and disturbing.
>>
>> Therefore, do not check raw_spinlock - spinlock nesting
>> on non-PREEMPT_RT kernel.
> 
> This is not correct. The annotation is used to detect problems on
> non-PREEMPT_RT kernels which occur on PREEMPT_RT. This is documented in
> Kconfig. Letting this option depend on PREEMPT_RT renders it pointless
> because warning are spit on PREEMPT_RT even without that option enabled.
> 
> Please drop that patch.

Maybe we can add some obvious description that the error messages have 
no effect on non-PREEMPT_RT kernel?

Printing can be confusing to people who are not clear about the option.

> 
>> Link: https://lkml.kernel.org/r/20220616022911.35826-1-chenjun102@huawei.com
>> Signed-off-by: Chen Jun <chenjun102@huawei.com>
>> Cc: Peter Zijlstra <peterz@infradead.org>
>> Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
>> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> 
> Sebastian
> 


-- 
Regards
Chen Jun
