Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.2 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E6BEBC4361B
	for <mm-commits@archiver.kernel.org>; Tue, 15 Dec 2020 14:31:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9F2EE2251E
	for <mm-commits@archiver.kernel.org>; Tue, 15 Dec 2020 14:31:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729218AbgLOObs (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 15 Dec 2020 09:31:48 -0500
Received: from mail-bn8nam11on2072.outbound.protection.outlook.com ([40.107.236.72]:12608
        "EHLO NAM11-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729034AbgLOObs (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 15 Dec 2020 09:31:48 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RH/GhnzkK0m097dHHIzz+uhENIVUUK0JvhErWI2Hc4Q/jI+yxO48MoOwrZ4QH9oLJDV/CuIDkgUNbjNNxEbFPsFe/lIujl9p8CfkSZttbQ0ZW2jfO3aXtFjjiMEWfLIhXHgtEEmOGcD271zC7fNGMrsiDtQ+MykbrGMCAhXLZkkJtLmvUIEivFhUGJ3IqNV5YuD9+ixsj2AyqOUgHqw2L+lQMh2/lZ7ZuCVSRrwHmXexMWaI05QxlOTumoR09YUIBKwSoflXOCtvmzyx6qmGbt5Ia78q/xdvSkvPkUxX3uyHapKA+mG+up17bQGi8N6esoHZ0mW2dnEUR1/yyTvCRw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fErc55MiAAtiHOm2ZidMYmh6QnNF1Z6d6ElZP+yvCC4=;
 b=GDzR7XLxJyqfPh4WFUmUoV6FfKYM4llyjUI8Y+0iwVqKEVqrsRYWJOcSENHR7ohZpj3M6H26FVAEej+OLAQXy/1Z6W5d0jn+E5/m/XxTWX0qA4XlJM115J2nBuZolpS33vEL6WIptdwd0uqpoGrfzifn6a8lRFmeo2PyrptqpIwNICWSmhrdiz7kubvRHp0e3QzXqeiJSIJKe07Ji3eTdJ77Cv8kI6lrdRXae9Nr7WcaWiwO8N1Iunbkas4FVxF12ljmkRaAd7gttI86rbBeZWNH0jhu++C3qKr98u99fPstZn0iyW0KXdYlWU5ZXvfMDRVNr69nsSREwtlo8GBSZA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fErc55MiAAtiHOm2ZidMYmh6QnNF1Z6d6ElZP+yvCC4=;
 b=1KMl5D0G4Ubz60s3jSMVnEhytjYCaObj68jTTDXWWRJoL3BTjCm++Vf9OLKnlf9QTeVutcaa2O7EXA4rS0T12SGGb6WYWaDWD3HE2VYV5IYE5EigYhzT/QN2IZb0lOVCwFxUkMANGC83KNaQ5mQGOwUfW1y0Zh1rflzyz7Xf+rA=
Authentication-Results: suse.cz; dkim=none (message not signed)
 header.d=none;suse.cz; dmarc=none action=none header.from=amd.com;
Received: from MN2PR12MB3775.namprd12.prod.outlook.com (2603:10b6:208:159::19)
 by MN2PR12MB4391.namprd12.prod.outlook.com (2603:10b6:208:269::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3654.14; Tue, 15 Dec
 2020 14:30:53 +0000
Received: from MN2PR12MB3775.namprd12.prod.outlook.com
 ([fe80::44f:9f01:ece7:f0e5]) by MN2PR12MB3775.namprd12.prod.outlook.com
 ([fe80::44f:9f01:ece7:f0e5%3]) with mapi id 15.20.3654.025; Tue, 15 Dec 2020
 14:30:53 +0000
Subject: Re: [patch 012/200] mm: slab: clarify krealloc()'s behavior with
 __GFP_ZERO
To:     Andrew Morton <akpm@linux-foundation.org>, airlied@linux.ie,
        alexander.shishkin@linux.intel.com,
        andriy.shevchenko@linux.intel.com, bgolaszewski@baylibre.com,
        bp@alien8.de, bp@suse.de, cl@linux.com, daniel.vetter@ffwll.ch,
        daniel@ffwll.ch, gustavo@padovan.org, iamjoonsoo.kim@lge.com,
        james.morse@arm.com, jasowang@redhat.com, linus.walleij@linaro.org,
        linux-mm@kvack.org, maarten.lankhorst@linux.intel.com,
        mchehab@kernel.org, mm-commits@vger.kernel.org, mripard@kernel.org,
        mst@redhat.com, penberg@kernel.org, perex@perex.cz,
        rientjes@google.com, rric@kernel.org, sumit.semwal@linaro.org,
        tiwai@suse.com, tiwai@suse.de, tony.luck@intel.com,
        torvalds@linux-foundation.org, tzimmermann@suse.de, vbabka@suse.cz
References: <20201215030350.xC0HoDUgG%akpm@linux-foundation.org>
From:   =?UTF-8?Q?Christian_K=c3=b6nig?= <christian.koenig@amd.com>
Message-ID: <2172e342-e73f-a759-fce5-8b94daafd506@amd.com>
Date:   Tue, 15 Dec 2020 15:30:44 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
In-Reply-To: <20201215030350.xC0HoDUgG%akpm@linux-foundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Originating-IP: [2a02:908:1252:fb60:be8a:bd56:1f94:86e7]
X-ClientProxiedBy: AM0PR10CA0019.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:208:17c::29) To MN2PR12MB3775.namprd12.prod.outlook.com
 (2603:10b6:208:159::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [IPv6:2a02:908:1252:fb60:be8a:bd56:1f94:86e7] (2a02:908:1252:fb60:be8a:bd56:1f94:86e7) by AM0PR10CA0019.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:208:17c::29) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3654.12 via Frontend Transport; Tue, 15 Dec 2020 14:30:49 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: d99ce09a-4c04-4238-96ef-08d8a106071e
X-MS-TrafficTypeDiagnostic: MN2PR12MB4391:
X-Microsoft-Antispam-PRVS: <MN2PR12MB4391550AF01F8193FC960C6383C60@MN2PR12MB4391.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: FxyCcK0ZYqmYG1HeymGtmlsRsEb6yiHWGjAbp9LN42YG8+Jm9Ifn6MaX04S9o4y1iTYGVsgf+HnQNJ32YAqlIt2LQS5FW7HtIQFDcBkUtGPNHaDJA+R5vaXWlOSgMZTRolay5o1bj+RpdexczBLTmnKuKca49xpK+IjE1A1zKvKf/ib9HW5os0CG4KQ4JowBO0eRw7b66Rok17U6MpY/1uEGo3oJGN+1snPfHfaBm7WRI4qBDCHBVvBtmE359ymqkE/nxBhRc1+yML23A2fSCS5r4Nc9civPOU3GMUPzOoNkpzG361AOu8tHcYXAqNVF+HHLFbX1Mca4MtaOPZZeDyBKOwamAL7R5qWjOKLOv0F2S0dSKsu9neGBpZzBiXrBhhhnrsgZ+oFHBZ4hZP6ah5D1GEpU98yUCJxkAjJIYQGJ/VI3wC4NiJ2tuKjQc4pcEcDIt+88K3YtCjwEsxI4li3xJdCkqlx93bn7YvUYRAehDIp/CvJAFuma2hGv4/3ei24i/x6/ZZOmRXlfBAeGCEvi6RZWlPIUmmMMhV1tXsk=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB3775.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(346002)(366004)(136003)(31686004)(66476007)(66556008)(66946007)(508600001)(921005)(7406005)(7416002)(8936002)(2616005)(8676002)(5660300002)(86362001)(6666004)(31696002)(6486002)(52116002)(2906002)(16526019)(83380400001)(186003)(36756003)(966005)(34490700003)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?MHZja1lvdlI1cEVpUndzUTZmb2FDM3EyYTQ4MkZLeDFLRHlyRmVreHc3eDFp?=
 =?utf-8?B?dCtkcVVvQ2hwWFI3WkJyajdPMm5lbkFQQ3Y1SWwrRHJEQUx5ckR3c3lVK1Z6?=
 =?utf-8?B?dS9lQkVqbysyOEFNNzUwQ1YrRUhTblVxNkF5VWdXZ0hLaUVEa1JEbE1NZGoy?=
 =?utf-8?B?emN0SXY2ZmR0QWZoK29FYnVBZUYxNHJETXpRM3FaTHNUcGNicXlYY2pZNG1T?=
 =?utf-8?B?SUZJeE5wSmNHVzB0c3pxaXNHYTdpdFVCS0tPcGhIaU9mYjhidmlweFFlRksw?=
 =?utf-8?B?MzJSUEQ5RFhaNWNOOXJ3d2R1bHVVcWI5ZFBpTkd2UlovTUFrWEdWY2NrYWJt?=
 =?utf-8?B?Y2I5TEI1a0Q4TlQ3dWZLbGpMcm1ZdnF2VmZYUGoxUSs1Q2VJYTZvZTZQVFhx?=
 =?utf-8?B?bTR6aGh2MlFPNUtFSkNpaEFybmRaZEV2RjhibVAweW14YzM1ZHdwUGNuNlRu?=
 =?utf-8?B?WW5jSndGeG9jSGY3amRGVm5FT0dYUEdCWmR3cGxyUjQ5TTVTd2FCblFUcmUx?=
 =?utf-8?B?d1cwN1J4ZDJpSkhRWittOWo5RXV6SHUxSHVLaGpxaHlSdHRzbldjQXptdlNL?=
 =?utf-8?B?K1JVMkhyOG42NHFQODErTXZtb3UxaFErL1BYbFR0SUhOWGUrcTcxOUNYbm1h?=
 =?utf-8?B?UkpwMHBwTEpVNHlOa0tpRG9jZzNHZDVRVnRoS0crbjVCV1JscWdlb2RsNUdw?=
 =?utf-8?B?S1pQOGFrRWI2YnM0aEhZR2l1dXV0aGcvNEdLcWQwb21PRnJXeVBYeS9NSi9E?=
 =?utf-8?B?NnVveGZoS0hhQkpsZ29lZTZSWmFsMkFZMi9QMUJaMlc3cVBPcmlDbjhWbGt3?=
 =?utf-8?B?SXlrbjJyWHhHaitSSlVBcGJ5RkhLNzc1MUlCbnFhMGJ0dzFWTEYxZGV6cjNn?=
 =?utf-8?B?ODdDTFNIbFhZWVNXRFQ4ZVpiN2R5YWV2dmhpTGVDOUxCS3dSbVI1aGlhUjZl?=
 =?utf-8?B?cGtOWEp0Q3NVT0liWXUyRFVTQjdBdmVKUHAvTjd2QnhUbVZ4WFRSa0VBcUVm?=
 =?utf-8?B?cDVHdFdaWXZPL0xoMTVWS25zU080YUR0M2h3ektoMEVJNE1xUWlJQlhtQzl6?=
 =?utf-8?B?VkhFUEZGMEpGZ0QvSnRRend6ZDA0UXExSE4yU0xTZURJbXhVMzF3Y0syZ3Zs?=
 =?utf-8?B?dFdXblBpNDBYeENpMjVDOUxjamVEZzlWcGtmY2VPTVN6SENyN3dYNmlqVjYy?=
 =?utf-8?B?UnZiWEZZZHlhaXpXKzNyZ0tsYTBuSW5sMzBwdnQ2ZGlsb2p0OUFlMkh6Q1JY?=
 =?utf-8?B?aHpPYUY1OEY4d01zRUZNRGZmWUlSMXFhZHRaOW15cHlwVTZKaHg0Y3JoS3Bp?=
 =?utf-8?B?YXYrYnhYVTI1dzFGMXVGNGpxUzZoc3ZiUFp6NnRmeFc1MEpDSmZRa0RkTDNU?=
 =?utf-8?B?b0g2TjF3dC9VWXJsTnZRdyttNXNlMVlBVjRUSkpvSU56a0NZeEhveW01YTVU?=
 =?utf-8?Q?cXjT7Sc2?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB3775.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Dec 2020 14:30:53.1607
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-Network-Message-Id: d99ce09a-4c04-4238-96ef-08d8a106071e
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Wg6cZ7OoKvxIDHZnQhI0MsAeEwFb3z/oiSzmjz243GUVu2L46ISpGGTcIhmwte0m
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB4391
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

Am 15.12.20 um 04:03 schrieb Andrew Morton:
> From: Bartosz Golaszewski <bgolaszewski@baylibre.com>
> Subject: mm: slab: clarify krealloc()'s behavior with __GFP_ZERO
>
> Patch series "slab: provide and use krealloc_array()", v3.
>
> Andy brought to my attention the fact that users allocating an array of
> equally sized elements should check if the size multiplication doesn't
> overflow.  This is why we have helpers like kmalloc_array().
>
> However we don't have krealloc_array() equivalent and there are many users
> who do their own multiplication when calling krealloc() for arrays.
>
> This series provides krealloc_array() and uses it in a couple places.
>
> A separate series will follow adding devm_krealloc_array() which is needed
> in the xilinx adc driver.
>
>
> This patch (of 9):
>
> __GFP_ZERO is ignored by krealloc() (unless we fall-back to kmalloc()
> path, in which case it's honored).  Point that out in the kerneldoc.
>
> Link: https://lkml.kernel.org/r/20201109110654.12547-1-brgl@bgdev.pl
> Link: https://lkml.kernel.org/r/20201109110654.12547-2-brgl@bgdev.pl
> Signed-off-by: Bartosz Golaszewski <bgolaszewski@baylibre.com>
> Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
> Cc: Sumit Semwal <sumit.semwal@linaro.org>
> Cc: Gustavo Padovan <gustavo@padovan.org>
> Cc: Christian Knig <christian.koenig@amd.com>
> Cc: Mauro Carvalho Chehab <mchehab@kernel.org>
> Cc: Borislav Petkov <bp@alien8.de>
> Cc: Tony Luck <tony.luck@intel.com>
> Cc: James Morse <james.morse@arm.com>
> Cc: Robert Richter <rric@kernel.org>
> Cc: Maarten Lankhorst <maarten.lankhorst@linux.intel.com>
> Cc: Maxime Ripard <mripard@kernel.org>
> Cc: Thomas Zimmermann <tzimmermann@suse.de>
> Cc: David Airlie <airlied@linux.ie>
> Cc: Daniel Vetter <daniel@ffwll.ch>
> Cc: Alexander Shishkin <alexander.shishkin@linux.intel.com>
> Cc: Linus Walleij <linus.walleij@linaro.org>
> Cc: "Michael S . Tsirkin" <mst@redhat.com>
> Cc: Jason Wang <jasowang@redhat.com>
> Cc: Christoph Lameter <cl@linux.com>
> Cc: Pekka Enberg <penberg@kernel.org>
> Cc: David Rientjes <rientjes@google.com>
> Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
> Cc: Jaroslav Kysela <perex@perex.cz>
> Cc: Takashi Iwai <tiwai@suse.com>
> Cc: Borislav Petkov <bp@suse.de>
> Cc: Daniel Vetter <daniel.vetter@ffwll.ch>
> Cc: Takashi Iwai <tiwai@suse.de>
> Cc: Vlastimil Babka <vbabka@suse.cz>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> ---
>
>   mm/slab_common.c |    6 +++---
>   1 file changed, 3 insertions(+), 3 deletions(-)
>
> --- a/mm/slab_common.c~mm-slab-clarify-kreallocs-behavior-with-__gfp_zero
> +++ a/mm/slab_common.c
> @@ -1091,9 +1091,9 @@ static __always_inline void *__do_kreall
>    * @flags: the type of memory to allocate.
>    *
>    * The contents of the object pointed to are preserved up to the
> - * lesser of the new and old sizes.  If @p is %NULL, krealloc()
> - * behaves exactly like kmalloc().  If @new_size is 0 and @p is not a
> - * %NULL pointer, the object pointed to is freed.
> + * lesser of the new and old sizes (__GFP_ZERO flag is effectively ignored).
> + * If @p is %NULL, krealloc() behaves exactly like kmalloc().  If @new_size
> + * is 0 and @p is not a %NULL pointer, the object pointed to is freed.

Question: Can the fact that __GFP_ZERO is effectively ignored cause an 
information leak if new size is larger than old size and the array is 
somehow copied to user space?

I think the answer is no, but just wanted to double check. Maybe we 
should note that here.

Thanks,
Christian.

>    *
>    * Return: pointer to the allocated memory or %NULL in case of error
>    */
> _

