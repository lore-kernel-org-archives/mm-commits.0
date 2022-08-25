Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 68931C04AA5
	for <mm-commits@archiver.kernel.org>; Thu, 25 Aug 2022 00:32:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229437AbiHYAc2 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 24 Aug 2022 20:32:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35018 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229772AbiHYAcY (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 24 Aug 2022 20:32:24 -0400
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (mail-bn8nam04on2064.outbound.protection.outlook.com [40.107.100.64])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 523228C474
        for <mm-commits@vger.kernel.org>; Wed, 24 Aug 2022 17:32:23 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HQfAynyhBGx89Law/INncbvoO24NdZu+EMzuYV9poppo3eiotE4zbKZ+AMn6UAE3LzYuVLNqMNS5ryuV/FhGZ3VEX62lp23TQNElSABYtN4ZM6T0rQsHwMgzMIUg27DULSSgxXiMBKSIwnGKM/GO0X7iZtssDp/91uoyxKDM/ikSUQ1waTk754HxSgk1h7QISqhxApwf7sogeYuS9yCx4CuJXsN9Tx+ph+Xp6vu1fAmxqsjOWnXEWYpCsYvTYzxmpaf4h6lEnMu902wTaZY3wPgHCEeFNa+7RZw2aOmN/iURveFYrkX8W/B9iFMfSZdQZpdqkGOn0D3DQ4ldEYNJsQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=GwnAgd+3Hz3N8yFf5uHb9ceggzyORvL7oDpq/42rwGU=;
 b=P16PaikQ+GVeERiTz77wPU5ZYdJ3+w8UPquluFbzB8v+/kJICnQyjPJPT+H0XMDnvff91gD3i0mnyzm1JjJB2NNGxuR3iWbyLB29NRaQymvg/qoUNUCkZr+KoThN2ejGofVoKeFmDZNwGl7P2AP4wU3a4LQiuyOgBB97ziLW40dwsH8tyZ5vZeUQd7LmUoYwvqQLt5h/Gq4G/KT3LdA25ZhO2u52WZOm8xlBkZtdIeEpyWtAY90dhYccmTBYv3PzR45j7HWanvwgAnL92Uu6n5KUoTlc2pmN1V8uaWvG+3iaZpi4YrGD497e62KFS5HPxYNvh1qYkvQbXehHd0b3RQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GwnAgd+3Hz3N8yFf5uHb9ceggzyORvL7oDpq/42rwGU=;
 b=UT5CnbjvqxYQ8khnnI7m6sWDTqgVYmDoD9ZjCDRwNDlpmUE/bXiPWpvBLc3qZpsWRen6hwf7Xt+ErYfiWhcLildkzySI1LI8wtY4Vl+Lnr/+k7Ny8bduwgGGhG8na9Lin80ju+lHPOIRvCiYfrUfcAzb7Z0OaPdVTquFMK8lDCHNeoSa3Mr5+MjW352hidseuRwm3psBx/pnXbxG5qrFSWDvJLF5zOvcejI/1+RopN2GrI24mEyVS1t9daGhKNx+d/cT8n89hWdIjxJ5TRE8OvhvzeICy7gsgswxEuV8WifzXgW4g7q36Ouz1DY1k73LkHfwElNoPV7DAGqwXuvqWA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from BYAPR12MB3176.namprd12.prod.outlook.com (2603:10b6:a03:134::26)
 by BN9PR12MB5258.namprd12.prod.outlook.com (2603:10b6:408:11f::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5566.15; Thu, 25 Aug
 2022 00:32:21 +0000
Received: from BYAPR12MB3176.namprd12.prod.outlook.com
 ([fe80::7432:2749:aa27:722c]) by BYAPR12MB3176.namprd12.prod.outlook.com
 ([fe80::7432:2749:aa27:722c%7]) with mapi id 15.20.5546.022; Thu, 25 Aug 2022
 00:32:21 +0000
References: <20220824211152.ECB61C433C1@smtp.kernel.org>
User-agent: mu4e 1.6.9; emacs 27.1
From:   Alistair Popple <apopple@nvidia.com>
To:     Andrew Morton <akpm@linux-foundation.org>
Cc:     mm-commits@vger.kernel.org
Subject: Re: + mm-gupc-refactor-check_and_migrate_movable_pages-fix.patch
 added to mm-unstable branch
Date:   Thu, 25 Aug 2022 10:29:56 +1000
In-reply-to: <20220824211152.ECB61C433C1@smtp.kernel.org>
Message-ID: <87sfllf9il.fsf@nvdebian.thelocal>
Content-Type: text/plain
X-ClientProxiedBy: BY3PR05CA0002.namprd05.prod.outlook.com
 (2603:10b6:a03:254::7) To BYAPR12MB3176.namprd12.prod.outlook.com
 (2603:10b6:a03:134::26)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a5014c27-561a-46a7-44bd-08da863145fe
X-MS-TrafficTypeDiagnostic: BN9PR12MB5258:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 1Dnh2TGfz9TdmH+9SAMiEYpsK7tzJkJNp1wfR5dXLpTX5odvwzQbQnKRTn+FxN8ms+Cc25UZtDaujfuOaRNcMP0840GsR/A2gTwlGASWLldgtuZTEThXLl5LJNYFEN/SQ9LorLtsJMZpSIPg1ngdoZuMIC0O+r1m3XBQeoqVY3jaMFicKVcIrJINCsNI6s+lpVEK53Tt2S3r2xgDxmF2/z1CNxOGVLhNaMzLFmpLIJIxLudUFCUJBoV+BYczqjR3SY0um4hGXnTeCJtxPTZTqizMAxfBzlyEqnRnc2VwGBGr3MLV2TdAFsMBlSaf4UDIUyEAuJ2MAoQHgzg9sanR6VuTglYGPAJD7bbaT6StDs7jaYVPA8VquM+A06tfuhzugW7WcYoRltdzKmPuuQYLVVfCBv+3cFqYSrRr7I1Rv4ScZ/UjfpnFpsjZk0+6NskLcCTU7dXZBwZpgwNXnnWWfG1RQxGRafhlsBODudK6SBpLKiAvKYfl95FFt9Ra/irAVApj+/hTicZgrZQe8afnXWFLhYGKcBgHhJ9RKWc2ggx7cv+bYLkwgah+aFVzELfQhWSmCwjxwOwHifxwOZyllxzB+MSjaDYgP3vZ6jErRVsRqnSAKwFfIdSn0woIDS460Uu/XBYZYKhoehyD0riw4n/XS+hp7B6tpevSVVmACEDvwHcFGZ+Hevr7ZZJ12xV4qCD9Y0JrH6TN1m8LkEMqMU3t13umkZ/JCDnuwgwmehEzRzq1hLB0uoThTUnS3fXTQJnV1/lnaziEys+GEZ2nYLG/ZdKBWgGKzM7r8bH69f8=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR12MB3176.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(366004)(346002)(39860400002)(396003)(376002)(136003)(86362001)(66946007)(4326008)(66476007)(8676002)(66556008)(316002)(6916009)(83380400001)(6486002)(186003)(38100700002)(478600001)(6506007)(966005)(6512007)(26005)(9686003)(41300700001)(2906002)(5660300002)(6666004)(8936002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?T8m6Qh+NVv6p8PJgKOEzqTNkKhOdAE8BzX1nGAIU7T9Vz4vGeeoGPSKYSr1Q?=
 =?us-ascii?Q?yOVwmiPcFtxNk1sISXZrjIqEAkUig6LpaMtiXrzPpNuKphqDc6xy6pKn5kb4?=
 =?us-ascii?Q?ZQR5+S/1iWEbsBTrO9ZZb3NYjHZOnK8kXq67IVp2i1Xl8E13vTFVvh4wnw8r?=
 =?us-ascii?Q?uidOGtuueTx+d9Ao6TKfvByuaRKygwCVC8zodALpYUaeCYj2o+YH5mfZgPsr?=
 =?us-ascii?Q?NEOGjMUMAY71hHJUFTOQzVWOp17qdt60SK98p8jSEZFPK9ggoUynM3kAIfYT?=
 =?us-ascii?Q?mOtN1KL+vJb/5qKysOPUM/G+2kQRPI/xRTAhvH4LzCBkI7kOIc/64DNmNsfu?=
 =?us-ascii?Q?e8wIOoN3eAEoRE2CFn0rPHHCTWx1KLIlCVkwqH482TDJqf3ymi+3VmPxujLR?=
 =?us-ascii?Q?lhoMQY7cjXteXH5VNQeyxjjNd+Ps1Rg0/vOXOX18ejkEGwUlLCqXPnR8eUgU?=
 =?us-ascii?Q?QOoLjJZAAix4ugK/tOw2TMIiB78ZeJ9xEsyZ0f9UOY/u7yZGGRAbkQnGTT7V?=
 =?us-ascii?Q?b3x3NVFAas0a+QiA+gZVIYGcXfxoXMER3nFtvOJ47XY+PxEyTS0aFM8R4q5l?=
 =?us-ascii?Q?AUun/IUSPacz5ag8c8HX6CWs2yPrrzdEq+Y0kaGM2YRZWcgZKOPp9gLawkZV?=
 =?us-ascii?Q?0ii0cRSJcnwi0Oa1pI7b4QgI+co3/1j/N1UXaDqXXQd3GxJAnc8PLtIvuW54?=
 =?us-ascii?Q?+NQ7HTsnDejZH5d9JLZxLaAStZ2u/QNBdq95C9r4cM5P3vSe0xf2Iqkk+R1L?=
 =?us-ascii?Q?GM3ce9yJTurKoFap1f7RAGJTM8TfsDy/rbchkVNEGtWzFcA6jYU8ZzD/iJQg?=
 =?us-ascii?Q?Mbpnhs7YdjZFhNXm9k+jYLNVafs199RCRw5B0yBAPtAbcosAu+3G4M34kHia?=
 =?us-ascii?Q?SvU3w4B4dmOmOVhMCi7mwJ5cprVxxmXXxOdc3Az3sIT6m0ViJu9JuhCZUNIc?=
 =?us-ascii?Q?oEn/T++qwAdYdYSEpsB0WxFgtVcU2km+rl8YM9prnOd3kNcNfQDjxRaYR9zf?=
 =?us-ascii?Q?5CzsIv/sfjuwBFhGl5Ffw0dtA/C8HOzk5XSZB2EuflhN1NTnW8951CDJvBex?=
 =?us-ascii?Q?l5K7nGI7LxiLZ8coRDJ5praOHzhcAc3MCEQoqboZlxSgtGJ8aVU4R2UHJja1?=
 =?us-ascii?Q?7UyAmiq6sJoFiURBypzyMs9cbP1oEzM6kP+KJFlNNG8HXQPgMlUzSHQoDbQM?=
 =?us-ascii?Q?XxeLVK2QaBPecZMMXzPHHOdPoorQK8X3PG9g3epNj7fVmSumYNXwY9yb1Lk9?=
 =?us-ascii?Q?/hGteKOFlgpb1UFs1T8hpvT5Zlk+8NXCx1xvC9O0SpxExUTfySdMO8m5jAPH?=
 =?us-ascii?Q?PSdbyBPTsmpZCpqZI4HKDqzuNt3DtKCQ4KoeHIafGBU+51rvHGLEVcsnYNGG?=
 =?us-ascii?Q?K6UlF1Z12tY9LSymP2Cge6KQ3tVDzxVwo80WKqWQBRJsbmcV7FCBxsQrvl0L?=
 =?us-ascii?Q?Gtt30vC2z2z5vCtxGOR/8GMuC5TIc0SpYzYno1ox1Av5Py5BuQO/TXNohHp/?=
 =?us-ascii?Q?8encaxf8JhFRZTLFrlYRAE0VYVMYtkcNGUUath44cSDKWwYd0gNCqqRg5MWu?=
 =?us-ascii?Q?8jMcVn0w+y049bwqXcYt4IqHsHAA21MGxmm/7Dji?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a5014c27-561a-46a7-44bd-08da863145fe
X-MS-Exchange-CrossTenant-AuthSource: BYAPR12MB3176.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Aug 2022 00:32:21.4188
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: dVvPtUr4FG/oCUyvFS9MB/pQoHXEy1dadyv8A3RydSw2vr2CMyamf6Uh98f9dB/G8vHpkmewnvzOY+aOuGW+9w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN9PR12MB5258
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


Ugh. Thanks Andrew, and sorry for missing this. As this is mm-unstable
is the expected process that I should send a new version of the original
series with this fix?

 - Alistair

Andrew Morton <akpm@linux-foundation.org> writes:

> The patch titled
>      Subject: mm-gupc-refactor-check_and_migrate_movable_pages-fix
> has been added to the -mm mm-unstable branch.  Its filename is
>      mm-gupc-refactor-check_and_migrate_movable_pages-fix.patch
>
> This patch will shortly appear at
>      https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-gupc-refactor-check_and_migrate_movable_pages-fix.patch
>
> This patch will later appear in the mm-unstable branch at
>     git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
>
> Before you just go and hit "reply", please:
>    a) Consider who else should be cc'ed
>    b) Prefer to cc a suitable mailing list as well
>    c) Ideally: find the original patch on the mailing list and do a
>       reply-to-all to that, adding suitable additional cc's
>
> *** Remember to use Documentation/process/submit-checklist.rst when testing your code ***
>
> The -mm tree is included into linux-next via the mm-everything
> branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
> and is updated there every 2-3 working days
>
> ------------------------------------------------------
> From: Andrew Morton <akpm@linux-foundation.org>
> Subject: mm-gupc-refactor-check_and_migrate_movable_pages-fix
> Date: Wed Aug 24 02:10:22 PM PDT 2022
>
> mm/gup.c: In function 'check_and_migrate_movable_pages':
> mm/gup.c:2045:13: error: unused variable 'ret' [-Werror=unused-variable]
>  2045 |         int ret;
>       |             ^~~
>
> Cc: Alistair Popple <apopple@nvidia.com>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> ---
>
>  mm/gup.c |    1 -
>  1 file changed, 1 deletion(-)
>
> --- a/mm/gup.c~mm-gupc-refactor-check_and_migrate_movable_pages-fix
> +++ a/mm/gup.c
> @@ -2042,7 +2042,6 @@ err:
>  static long check_and_migrate_movable_pages(unsigned long nr_pages,
>  					    struct page **pages)
>  {
> -	int ret;
>  	unsigned long collected;
>  	LIST_HEAD(movable_page_list);
>
> _
>
> Patches currently in -mm which might be from akpm@linux-foundation.org are
>
> asm-generic-sections-refactor-memory_intersects-fix.patch
> mm-page_alloc-fix-race-condition-between-build_all_zonelists-and-page-allocation-fix.patch
> procfs-add-path-to-proc-pid-fdinfo-fix.patch
> zsmalloc-zs_object_copy-add-clarifying-comment-fix.patch
> mm-gupc-simplify-and-fix-check_and_migrate_movable_pages-return-codes-fix-fix.patch
> mm-oom_kill-add-trace-logs-in-process_mrelease-system-call-fix.patch
> zsmalloc-zs_object_copy-replace-email-link-to-doc-checkpatch-fixes.patch
> mm-demotion-add-support-for-explicit-memory-tiers-fix.patch
> mm-demotion-update-node_is_toptier-to-work-with-memory-tiers-fix-2.patch
> mm-drop-oom-code-from-exit_mmap-fix-fix.patch
> mm-delete-unused-mmf_oom_victim-flag-vs-mglru.patch
> mm-add-merging-after-mremap-resize-checkpatch-fixes.patch
> mm-gupc-refactor-check_and_migrate_movable_pages-fix.patch
> ia64-fix-clock_getresclock_monotonic-to-report-itc-frequency-checkpatch-fixes.patch
