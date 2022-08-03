Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1B563C19F28
	for <mm-commits@archiver.kernel.org>; Wed,  3 Aug 2022 04:02:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229457AbiHCECh (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 3 Aug 2022 00:02:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40566 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229448AbiHCECg (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 3 Aug 2022 00:02:36 -0400
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2050.outbound.protection.outlook.com [40.107.94.50])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 541E43CBD2
        for <mm-commits@vger.kernel.org>; Tue,  2 Aug 2022 21:02:35 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=llbHYnGjMA3BjxzUj7jhoOAmjH3utwIuMx75gjTWnh7wz52c4rQkf4wzIZVfxrjOA21u/AeiWOItAYLc8h5C7u4K739ShH9YsEz88GFPl58iro0tym8Z1OM1ec0IIqK/NdN09YfmEfbi67p4O3rMdzBJazLUh+L6WAK/4iBx12wWdJI6/W6PRa1VVZq9ffHwp/xOo9QSEe8SWHZj/p6jpbt9u2vSC96Pk0eqJ/TCNB1382yx8xUTl1YptOmOiJqPnWtwqVkhHrEUpoRKkYYp2mmIcOPFzDw8FZxnswKMHr9IHpd/KjbZGaEOPmSMHqnP4CYe7vS6LGMrhHLTxlLGAQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YE7YoTDj2Fu7NYNxbNKev/SxEzVi0Rrro5ZSmfLgh28=;
 b=KMjBqCtAQN0YT511Nix+Au9nMzTpoWxaBAAZonh0oGic404L5UjjdZspjXpnuIH4R2MZ+a4HiO7vna2LWZA1nEfovZ5AL3poDgXbEsRTfXP8Sl/UrCzwJjY5gYNJ9PkOmHHm9vm0kiLvgfl42fbKkum13snwhESlv8eWpiUzjxLLoLocYJ7w9lvsXHZypaZXTbqqwcG88TbnP9y4tl91rqAgvE8FMBSlEJDaZZbLKiboy1rlT55eIQPvoGEocCz3rJwG6uEIJw2Y4XRm393siQwLTXYY5XNJw51+djcORaSUGf0zyxY9aIMMD+VhZ9lCxcgzdIOrTALq6hcdZ4+n7A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YE7YoTDj2Fu7NYNxbNKev/SxEzVi0Rrro5ZSmfLgh28=;
 b=AKap6wJhTuVgD6jJiqHRd+oAWX/FuhukfW3wrt5LJai+qH2R4JvwWUdAKkaM5woKA7Y07RPu57dt/LdFsKmqSmblWmbeHEAUO7F6RmHgOZODybJaucQDRX5p6S3xIehkRtCtDahdZHIQTFCrFyQBGHdfvn/skqnA/Uy/JeqfivYtArRtNR8RoSwgG/+FLw/1RRj9WZeoy/wFaIZWFOCIGAz0FpSBd5lRmWDSFRRYR9GpEB5gnJfoZaU28CKOaVxyLGkmuzdYCBRoowtfpBQYAXIn06ma4m6mR1pB492dVe9HYQL6dSbhTVXRr5qW2E7k/SNG1kXzez+o8tAtI018xA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN0PR12MB6150.namprd12.prod.outlook.com (2603:10b6:208:3c6::11)
 by MWHPR12MB1901.namprd12.prod.outlook.com (2603:10b6:300:113::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5482.11; Wed, 3 Aug
 2022 04:02:33 +0000
Received: from MN0PR12MB6150.namprd12.prod.outlook.com
 ([fe80::48c5:439:da78:af8]) by MN0PR12MB6150.namprd12.prod.outlook.com
 ([fe80::48c5:439:da78:af8%7]) with mapi id 15.20.5504.014; Wed, 3 Aug 2022
 04:02:32 +0000
Message-ID: <994d3e32-88d7-1ae5-d2d9-f0bcd66ebce0@nvidia.com>
Date:   Tue, 2 Aug 2022 21:02:29 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.12.0
Subject: Re: + tools-testing-selftests-vm-hmm-testsc-fix-build.patch added to
 mm-unstable branch
Content-Language: en-US
To:     Andrew Morton <akpm@linux-foundation.org>,
        mm-commits@vger.kernel.org, lkp@intel.com, apopple@nvidia.com
References: <20220803011001.8B70EC433D6@smtp.kernel.org>
From:   Ralph Campbell <rcampbell@nvidia.com>
In-Reply-To: <20220803011001.8B70EC433D6@smtp.kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR13CA0044.namprd13.prod.outlook.com
 (2603:10b6:a03:2c2::19) To MN0PR12MB6150.namprd12.prod.outlook.com
 (2603:10b6:208:3c6::11)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: da4c6b98-71b9-4bb1-2cb3-08da7504fde2
X-MS-TrafficTypeDiagnostic: MWHPR12MB1901:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: JaxKL48KLldRVLIG5ovZ/lOUEswoDWk9PoVeukoM8nezw0roQBuHCTISlDcyRadp30Uy02ptfR7AkZxGf5PXeiWTLBh8OmwUgXjBa3JMYk9oft8pnCNCGQ7O9/oTwUepz0/j5oYg6cKlGBF9dWf1gFcMJDmnCgEY7+xEPiOp9tlYt7FCkmHiGR8HJkGXSKBrPYTgjkPAv9pi/TUjbTwvcbUqYiI/rlrv1rB2JtPPT6hCay8AsjCSMotFp2A3rcwSHWnfCTITruCOfY0xGKwZAioVJfLi14fWTnwUjz5yq4vGhVWqML825ggz6mewW1BEKLFHNsXjs/93LzDj81KfDBZF2YEoh6EBD8QBV5McUKcKPeC2YF8Hy6mbZ7jgLH+hGbqMF9Plu4P/YfTNrPVBGDaZk2gX6x835OEZ1E5NFV3tyE1mcOAupA+NjlAuA7sFZUDNRC/japDwlCq8U8FkMw7lc/LGwpY4V1Nw6XK/BeTwnP7HRaq4jVNt2NuzQZVtwiX+n4rJEtlGk+21SrQmgY+y7+80uHtbHy+6dibFeTnA6rZ/Q811j0RHbh0XNO1zSL3yFC7k79hJxrBYX7nIC87HcgYv924JbTWD+ShlpkUeo+LOO+6xFvINUMJIC3nBvgSSDTrlZxTetHJFvarIUcfFeKQY+pRcqkPPAGN+dKC96isbcqUxZtfgXAFMX+O3QX2qBCFJLAktqYE4lHWkGSbzZxyodSd9M+tzJe/f87Mac6Yp+BFoJt0FLYNHeofXyK8BVkQS2XW8hTVl1Sd2JsuvMgJuRINuTgjdY14LKX32VKxUlQAm3WgnLuoglW5xTy2TIkGrwntgEZk/DQU0BMMyaLDB/cDXvxfSaV6JYbX+9fzD3yCVRy9fopQSilAHOLDoRlqLeduDwRKzOwqyIOb4L3+aPl4BhwZCMs1rrOw=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR12MB6150.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(346002)(376002)(39860400002)(396003)(366004)(136003)(6666004)(38100700002)(41300700001)(83380400001)(186003)(2906002)(6512007)(6506007)(6486002)(966005)(31686004)(36756003)(478600001)(316002)(66476007)(31696002)(66556008)(8676002)(6636002)(8936002)(2616005)(53546011)(66946007)(5660300002)(86362001)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?L2ZDLzdFMHFYWFR4L1ZWdXEzZ3cwZjFKazROYTRZUHFteis2dTZUTmd4MTQ0?=
 =?utf-8?B?c0ZKMlJ1azdaYXg5MjdaSVZGSmFQTWRHUWh5SXRhVEYwMGNCMTdOQjQ0bWMv?=
 =?utf-8?B?M0Vjd1VUZDhkaW9DTDVwd0xIYURxUlUrUHZINEE3Y2pXbFp4SlZET0tFMlE0?=
 =?utf-8?B?c3JKeHRpUzl3OXQ3OGJ6UVhpQUhKaklsVkI4eHRDVndmblBIaFFOeThnWitp?=
 =?utf-8?B?dDFyL3ZLcFpwU3VHQi9tRHRrSXNyVU9iR0xIUVFHbjFPQ2ZWdmtvMlVWQ3lj?=
 =?utf-8?B?VTE5bEVUa3RzaXJCM243QVFFUTBQejhKV3hHZ0FHMWNGWWo3VEpVYnJFcXpQ?=
 =?utf-8?B?VUNlYXV2ZE1yZjAxVEJ5U2RlQ0RTYXdodm5tMFZZeEpKSEErekJ0dGNLb2tK?=
 =?utf-8?B?RzloWjF0aDAyRUh5UmFncDArSEVDbllyNy96ME1wSEgrTGFCUzNsMXJkQnJ2?=
 =?utf-8?B?SFhOSjZlVkJiN3lJRmhsZWNTdnFqMVhIVEswTkdFOVJmSURSbmo2N0Fzbk5F?=
 =?utf-8?B?Zkhac3hjeGlrOG9selFTd3NDOERmeXNPY3pYcTByNTdGMit2aEcvclJaQ0N5?=
 =?utf-8?B?Z3lPTDJkaXVVaXpWSFkxYVg0aFFUZW9IbDIyOEZONVJxSmFuTWR5QThTa0dp?=
 =?utf-8?B?YjFoM2N6aXpvRDZhNVZIQitnNjF2Mjd1V21IVTlkYUlOYVVlUkQ2enVqR3Rs?=
 =?utf-8?B?cURqdDNsdzdpcDJEb1UzK3ltZ1JXOGdnMHhOMjJGc2VvS3BycElpZFZKcm1P?=
 =?utf-8?B?NUlEejhXY2pHR0pRNXFvTVlmOWNOVXhKYTVMU3NyZmhEb3IvVUprK1EyU3dW?=
 =?utf-8?B?NDRvSHNUOUZPL3haa2V3NVJiK0gxOEl2eWUxVm5oM2R5N0RBTUZyTmtjNmVK?=
 =?utf-8?B?alpVT0tCMzhhQ0UvQU83OFNBZE1yRUNyN3lIUkpLSGNscVNrd2YwdnhnZ3di?=
 =?utf-8?B?dk11N2tLZExQQ0RRcmdIZ3psOWdQSEdqUW91MUxkN0lFTytNRGlyd053Wkkr?=
 =?utf-8?B?TE1FOGtkTFFodkJVeUNHMzJnYTVMc0lvS1U5TmxzUjJSelhBRDRUVUhLWFFj?=
 =?utf-8?B?UzYvOVpJbjVZSCthaysxR2VLVEs2b3hUc2c0WUh3R3Y0VHVhRDc0dDB0eHNz?=
 =?utf-8?B?RWV6T1VKUmF4Snc3K1lQYmNUMmo0U09oQnExeFg2MlRWcjM4SzV2bzhidkdW?=
 =?utf-8?B?aFg1ZjlSaGZ4V0tFb1gxbzBUdkJnTzBjenQ5RGVrK3hSQTI0a090RUtrK1F1?=
 =?utf-8?B?MTZkeGFOSEdNeFlIQXl1Qk41Sk0vc2hyaXNRWWhxcllVOXcvTnAyR2lCUHVR?=
 =?utf-8?B?eWJxdERic2ovTHNrYUJUMUxXZDlhTXFJWkhPbG9Ycy9rRElQa1BaL2dWQWJN?=
 =?utf-8?B?WVMyVUFWYmJEeEM1bnB6K3REK1A1UmpEcFZndDVTNlJDaFFIN3N2K2ZkSmNl?=
 =?utf-8?B?cDZCTEJWcG9NbUVpQ1o4TGVPNzZkOG9RdWU2dFFycmwzejRwVWkrVnY2YkxD?=
 =?utf-8?B?bmRWNTF5UlZvNTRlaFh0V21OeHU5N2plUU5WK3doS0ExSlBnMzBhZHVYVlVF?=
 =?utf-8?B?QzBPSEVwZXMxSnZOWkhVVGl6VVdyZWs3N3VVYUFzaVFFRnF4MTI5NnlOSnl0?=
 =?utf-8?B?YjJPYzNWWU94OUEyNzhUaWNJbTgxbEI3VkNaOGRYZ3QycVducnlQVUJLdjBr?=
 =?utf-8?B?THlmSFdQdUxMWHYvNmVBN1NxODk0emg1UXpnT040UGxCVUxvaUFEUG1RQnQy?=
 =?utf-8?B?K3dpb1pLTlFYYVFLMTQ1Q3hEZU52TFBxU2FrL2ROT0FoNWxmeXY5UWZkMFNp?=
 =?utf-8?B?eGZxK25IUEVHMWNiMUdsZCs4NkRpMWlHL1FKeUplZERocTVuM3RrVlcxcERz?=
 =?utf-8?B?aUJxb1kyMVpydkttd1NzRjB5S2FuSWZQZkl5c3NLTkg1V0FydEZaS1k0OC91?=
 =?utf-8?B?dnZZTk9CSXNRL1hjdnJmb05BWnVCbHBtZzVUeHVVQUljYitNalB3NmhmZysy?=
 =?utf-8?B?QTVWbHRDMlZoOHRLL1hvYU1hQit4N3hTRDhrbFBIRmxaQWFkOEx3bERDVDRQ?=
 =?utf-8?B?T3NXWUpwWXYzSHc3czZacnVFc2tBKzhmZDZ6UjFWZjI0SFkreCt6a01hTHpr?=
 =?utf-8?B?dllWYk1yenpXaEZQbGZQeCt5dGF2U0FsRDRQbnFmeklYRkJPZWo0SUVCZnNa?=
 =?utf-8?Q?m8dyGuAhK2hS/hly6S/QLUU=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: da4c6b98-71b9-4bb1-2cb3-08da7504fde2
X-MS-Exchange-CrossTenant-AuthSource: MN0PR12MB6150.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Aug 2022 04:02:32.7841
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: vJtARmZsGwaidH10bHa8MNb6wjD9ZtlLN/SMXBBh21h2IBKO8lPASJL9EeXAJdtXxEU+V0+0Xr1/cbdFtx6sYA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR12MB1901
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


On 8/2/22 18:10, Andrew Morton wrote:
> The patch titled
>       Subject: tools/testing/selftests/vm/hmm-tests.c: fix build
> has been added to the -mm mm-unstable branch.  Its filename is
>       tools-testing-selftests-vm-hmm-testsc-fix-build.patch
>
> This patch will shortly appear at
>       https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/tools-testing-selftests-vm-hmm-testsc-fix-build.patch
>
> This patch will later appear in the mm-unstable branch at
>      git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
>
> Before you just go and hit "reply", please:
>     a) Consider who else should be cc'ed
>     b) Prefer to cc a suitable mailing list as well
>     c) Ideally: find the original patch on the mailing list and do a
>        reply-to-all to that, adding suitable additional cc's
>
> *** Remember to use Documentation/process/submit-checklist.rst when testing your code ***
>
> The -mm tree is included into linux-next via the mm-everything
> branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
> and is updated there every 2-3 working days
>
> ------------------------------------------------------
> From: Andrew Morton <akpm@linux-foundation.org>
> Subject: tools/testing/selftests/vm/hmm-tests.c: fix build
> Date: Tue Aug  2 06:03:03 PM PDT 2022
>
> hmm-tests.c:1607:42: error: 'HMM_DMIRROR_MIGRATE' undeclared (first use in this function); did you mean 'HMM_DMIRROR_WRITE'?
>
> Fixes: f6c3e1ae0114cd0 ("mm/hmm: add a test for cross device private faults")
> Reported-by: kernel test robot <lkp@intel.com>
> Cc: Ralph Campbell <rcampbell@nvidia.com>
> Cc: Alistair Popple <apopple@nvidia.com>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> ---
>
>   tools/testing/selftests/vm/hmm-tests.c |    2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
>
> --- a/tools/testing/selftests/vm/hmm-tests.c~tools-testing-selftests-vm-hmm-testsc-fix-build
> +++ a/tools/testing/selftests/vm/hmm-tests.c
> @@ -1604,7 +1604,7 @@ TEST_F(hmm2, double_map)
>   		ASSERT_EQ(ptr[i], i);
>   
>   	/* Migrate pages to device 1 and try to read from device 0. */
> -	ret = hmm_dmirror_cmd(self->fd1, HMM_DMIRROR_MIGRATE, buffer, npages);
> +	ret = hmm_migrate_sys_to_dev(self->fd1, buffer, npages);
>   	ASSERT_EQ(ret, 0);
>   	ASSERT_EQ(buffer->cpages, npages);
>   

The original patch was based on 5.19.0. This is the right change for 5.20.
Thanks for fixing this. You can add:
Reviewed-by: Ralph Campbell <rcampbell@nvidia.com>

