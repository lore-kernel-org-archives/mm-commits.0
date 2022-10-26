Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 36735C38A2D
	for <mm-commits@archiver.kernel.org>; Wed, 26 Oct 2022 20:23:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234273AbiJZUXa (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 26 Oct 2022 16:23:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46716 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234439AbiJZUX3 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 26 Oct 2022 16:23:29 -0400
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2046.outbound.protection.outlook.com [40.107.94.46])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D56AE147D37
        for <mm-commits@vger.kernel.org>; Wed, 26 Oct 2022 13:23:27 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GyS45wAe6anF4X9m5aAAURqHoAQS/7dJyHnk9WaqhorRkgRZfn2xG6nOQmcIAvlxrw6Bp9N5CGMSrWARgLl3sRSln4irB//c4EC+kjfdPhQC7eDYEp/RFxnJjQtNdsQ/5SDlp2TA8XrG/4TYNYR4kciKnVYsJlxHzYm7DHMCUJy2Dj34bTK9yi1lYUCS9xjmYBMJSpcUnQRt3q3ugaRkCN6V9A7C1OBPLzW1p98AFWJYAIGBMJ/AyCf1Tk2wjLFvPqxVetcU3mF5+fqUOmbVbj7SH+ZDJcYZYU+E2bBGxGuVVpntQ2vTuuo23ylhGe2r3sNaxm75ZX1ZeTLqCgKVKw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7p1vfbt44Y+JvHjYoPhxzTmXixtKP9mi3ADxOCeSj2k=;
 b=S8cHQRmDmKJ5SWbreNFF4sNX6Z+NZOJyVuHjAa5Oo/1X8ppCiXGdAXiFmdMtyhW/Wj/efwQ8mYimB374/l6vuYPH/BEb8DbAkYyfCIZ5kvWRFvnxVUtzipCvj1Jb/KqAYt1FxPrq9E1jp0N4nhiroxSNl1JqIgrecMelQXpc3G3DbmirUqf3hE1vY5jxSbLBputSbsF9UUAQX7jpAZpSXR+vxxlGalUuNihI+DISpktIO6dqdZonl9XIbOrPPGu4mWW5Q/Ma/OiBJFkPpd/GtNbR4AehCisFgA1DBzAw0DcFb3TQSpQvNQ65poJPd7Lguu6c6m+GD1qInHjwRFZBDQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7p1vfbt44Y+JvHjYoPhxzTmXixtKP9mi3ADxOCeSj2k=;
 b=cBlx+dC/MjJKGgWKBryoD+hqazBRippbA5GlwCoeSnYZgsnjOdhxMZ9pWrrCTwMTT1WbiMFqpvOYyp3XoYV5BuquzZQfCrPYKx2GuDDh+8iCutOc57Or9aMUKiKcFTfJ4EBeL3c17wlMR9Huaq36FgWWcs+ZlXP/V0PODrSqx/Q=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from BN9PR12MB5115.namprd12.prod.outlook.com (2603:10b6:408:118::14)
 by PH0PR12MB5468.namprd12.prod.outlook.com (2603:10b6:510:ea::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5746.21; Wed, 26 Oct
 2022 20:23:25 +0000
Received: from BN9PR12MB5115.namprd12.prod.outlook.com
 ([fe80::7e91:f457:9ec5:33be]) by BN9PR12MB5115.namprd12.prod.outlook.com
 ([fe80::7e91:f457:9ec5:33be%6]) with mapi id 15.20.5746.026; Wed, 26 Oct 2022
 20:23:25 +0000
Message-ID: <3a35bcc0-71df-c302-081d-990c5e5ed096@amd.com>
Date:   Wed, 26 Oct 2022 16:23:22 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.2
Subject: Re: +
 mm-memremap-introduce-pgmap_request_folio-using-pgmap-offsets.patch added to
 mm-unstable branch
Content-Language: en-US
To:     Andrew Morton <akpm@linux-foundation.org>,
        mm-commits@vger.kernel.org, Xinhui.Pan@amd.com,
        willy@infradead.org, lyude@redhat.com, kherbst@redhat.com,
        jhubbard@nvidia.com, jglisse@redhat.com, jgg@nvidia.com,
        jack@suse.cz, hch@lst.de, djwong@kernel.org, daniel@ffwll.ch,
        christian.koenig@amd.com, bskeggs@redhat.com, apopple@nvidia.com,
        alexander.deucher@amd.com, airlied@linux.ie,
        dan.j.williams@intel.com, Yang Li <yang.lee@linux.alibaba.com>
References: <20221021192639.3FDBBC433C1@smtp.kernel.org>
From:   Felix Kuehling <felix.kuehling@amd.com>
Organization: AMD Inc.
In-Reply-To: <20221021192639.3FDBBC433C1@smtp.kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: CH0PR03CA0327.namprd03.prod.outlook.com
 (2603:10b6:610:118::20) To BN9PR12MB5115.namprd12.prod.outlook.com
 (2603:10b6:408:118::14)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN9PR12MB5115:EE_|PH0PR12MB5468:EE_
X-MS-Office365-Filtering-Correlation-Id: 905bf502-856b-4998-ea51-08dab78fef63
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: mHNrtBUKn3a0uUs3O6HEfvzeVtfMkmyKjuXfCuCjPKpZJR/loWsBYL93tRE8TWaVB6p3AVylg69l2G4H2XnxtdbRJpkFFTGUVgNEQf6cx23CDSe/C6/2DY3ORWE3Ghhc4FlMEKoStuBToXp+geQadI8n4A+ckQkZfMzAuPYKzz7i4RawaShk/yV0jQKARGdPBCe3A7EJC862PF1r2auUTFBQps9oXtR8+hAg1AgSMpoLL21h+Y9lGWIoyyQTbjDHyMerD2M7fn9MtsZqB9ZRD7e2cqmCINtvl0jNx32d204g9UWhOWq534sSkdwSDbCVaQGRycOK6a27Xg2nmycx9jTLmlGYQfoZ25hIjiJmvwUgsurSYQaYswHr+l43647vDD/2ZGTJ51dX9i2T129YOF+PZk9HyWGW/OK7rNFUu/MfWJWDvLWXnLAbdHQJ/RpEReLvMnRWWHHUwWPeyRoVrDC4Hhi+haTK0zm7yxy2nLYn9Y9SY3l5LS8eAL3kESkM5E5Fj52igeAqHY/h+68eWsUuyN7YL2ThZ5viDXuaJSfRYpHTz0AoHcSjhdAOitSDIkZTiZGqiaJ0/1W8YsifUK5kXIfXlDjOS4YGmbEt91aGaKY/KMq4pjRtG/+WeRKJ2nI8HpHQfGVK3O7clxuL9Xaj6Oz1UYDiH0tF8P+TwLfp1XmzhwfFV1bCgVA66k760+QUSyDIk45eMX3gueRAlv9Y/vIxwmQlTY7tqKuxcs2ckVm4GMm86Ue5eXmzJ9yoIZ/g3i2EjIEazWINoaiiUUna1gnXZ7/qrhrR6/fXfIvUnBthB1L0c8b1YvISRxPs7yIfoRkO2vNGvifUZ/P62RMO1jfw1SDEAgEKHojHVKo=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR12MB5115.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(39860400002)(366004)(136003)(376002)(396003)(346002)(451199015)(66946007)(66476007)(110136005)(8936002)(66556008)(6506007)(41300700001)(8676002)(26005)(7416002)(5660300002)(36916002)(53546011)(6512007)(316002)(186003)(36756003)(38100700002)(921005)(66574015)(44832011)(4001150100001)(2616005)(2906002)(31696002)(86362001)(83380400001)(66899015)(478600001)(966005)(6486002)(6666004)(31686004)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?TXp2UXZWL3FkSUtiQi9SLzZZWFRYekFHNU5vaEdvZXZ6dDh4SWpNQUVFTlMv?=
 =?utf-8?B?NUxCNHAwNmFPeHJMTjEvYWdVdVorVktFV1dWMzVwbW14YWlHQWh0Q0p1Zk0w?=
 =?utf-8?B?S25XTVdQWnllVEtYL1JOOURKV3dtZnhTelY2L0dOODZmaWdMenViZ2RiTWFi?=
 =?utf-8?B?emJranU1U0NzSmlObWNYMFhlc1lHVGxYVGtwNjVOcDZ6TmtTdVNtWlFpUHRW?=
 =?utf-8?B?NWM4NmhBV3dvV2lxTVJhNDhjaXFERHlycmQzWExaeHNZY2dOQzI0NkFLMVFu?=
 =?utf-8?B?N0s1VHVzSVQ2cVhlaTZRN2dFeHY3b3lkem8yM1hldCsvM2hERUZZamxUcGh1?=
 =?utf-8?B?ZVJBM2ZNbGt1cDlId1RwZWNqbkRBYVFUV1p0QVEydUxySmRxM3h1SlVYQ21O?=
 =?utf-8?B?Q0lDanhvZlcydlQyWVRLbC83UDREM0lRREM5UDBjMjVuU05ldjBiRmw2Snh6?=
 =?utf-8?B?K0JIcHdnTXM3MWVId3BzaGl4eTFUSlM3SS9rUzZrZURsSHZ4M1VkVXB2MGpv?=
 =?utf-8?B?SHU0enhQeU1NTHppUVo5aTlaL05qTlJReDNVODRwdWtHdlplUnVHKzhDWlJX?=
 =?utf-8?B?TER3V2c4bHU0dHRnYlQ5ZW9va1BRajZKZGNUUktucEZPVEtndVJHUVE5b1M2?=
 =?utf-8?B?b3F2ZzhiVDdPKytSWGJHRTR6L2JBUkNQbHN0VXAwa1FScjIxb3Ryemw3aE5P?=
 =?utf-8?B?M05GOW1YbjArVkxNTnZsYW9ZSFVKQ1pRYjR1TTRnNWlhaWpsUVV1eUJVZzhm?=
 =?utf-8?B?ZEdvK2VDYy9ZK0pDT1lvbVRkSmRPd0NaRmFrVXVuODd2RXl0Qk5EditzMmRT?=
 =?utf-8?B?UFVIdVMwejU2SDUvRDRoYnVNVzRHZkNvQ24yMmxUTC8zSE9xbjhRcVdUZzZG?=
 =?utf-8?B?cFY2cnVzK0lORWZSZktGNzVWV3hFSEthQUJSYnlFNmFOWmRWOVR3V1kwWU9h?=
 =?utf-8?B?cUFHRSs4amx5dlhYR0FIYkhxd3ZtcnVJVkRLMkgzSU9qdGpFeTVYaWh2U3cz?=
 =?utf-8?B?V0cvcjZIYldHRGJLWExjRTBPcjFETlNTVzJES3UxY29ocWpEa2tIYTJWQ25s?=
 =?utf-8?B?dUlFdE96aVY0bXFsTlJ2NkhuSmZoeDAzc281YVFuOUtsaTQ5Q1NROGFNdHNX?=
 =?utf-8?B?Y2t4UnQ3SGRKMzk4ZWFZSjRuUGZ6TThVT2RCK0w1ZHUxM3VmMGdNU1VXRm1Y?=
 =?utf-8?B?ZThWaVFNMFpOdkdXT3k4NGRSU1VSeXFsWnpkUFlhNGd2V3Nkdm45N0hkZHN6?=
 =?utf-8?B?RWtpZ2lUNStQZ0JXaEhBNmlEaHVpT1lMZmliakd0aWo3YzFDUkJ2NE45b1pm?=
 =?utf-8?B?d2VRMDlRc3NmQ3hRZ3hQUmU0b2o3UVByYXRWRGJOQng2TlpqaTNiRnhHeU5K?=
 =?utf-8?B?K2J4R2tWbmxLekdESGxIMzlvTkRrRGdhdUh1eHR2UUFEV21URzQ2dUprVVAx?=
 =?utf-8?B?MlRtWFA2UWw2NkJuU3h6UkRUYlVDSmZUTktneEVkck41RHNxbzkyYUJwbDRR?=
 =?utf-8?B?MEkxZ2hVNnFXZEU3ODJDangzcExOS1MzWmpmRnBNcVZ2V0lWQnhlS01lWjNY?=
 =?utf-8?B?Y2pnY29lY1pQVitCaTZ5S0NyMXJPY2ZZcHJDeWdmd0xjTHRHbHVxU1hleDJG?=
 =?utf-8?B?eENZSHh4bkRpcEUrOFBWRW9RT1AwQ05kZVAvWW5pWWhmNHcxU2hEUVdWemZZ?=
 =?utf-8?B?UFZCTWh3VGhuZFMvVEVsLzVoUzhoL2g3ZmU4VzYvNDZoRG1UT0pHWEtSS0Nw?=
 =?utf-8?B?N3NaSE12QlFHT2REZ2NrSVE5SEdRbkRZVUlERjB4ZHgvKzVUWlM5WWIxS0ZP?=
 =?utf-8?B?UUI1NnhmbmNkVDI0L3ZxRmVhVmF2VzUwNTlBUGVKQ3FSaXFVVUlBVUg5RjIv?=
 =?utf-8?B?eVh5R2lxREc2TlNRNUw2Skd1bDhndjU4ZmN5WjV2UEUrbzhxdjA0THlCUnY1?=
 =?utf-8?B?MGppWGd0Qk5yRUhqVks4bTJEM1lKSHdmRTVCdHNZVDdzY0VmeThSQkZHMjVj?=
 =?utf-8?B?M0RUelFZUlRidEdpd25ZZXQ4Q3diV2NodlpES3RieXlIbjBWaFhpU2lRcVJ0?=
 =?utf-8?B?MWx1bGdYZytuOElFbDBqRE0vWlBzOXR5bTYweVJ0L1JXMlAxZ3ViNkkzZjBI?=
 =?utf-8?Q?A2wHeQudDxyModDr9sLypaZyf?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 905bf502-856b-4998-ea51-08dab78fef63
X-MS-Exchange-CrossTenant-AuthSource: BN9PR12MB5115.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Oct 2022 20:23:25.3042
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: tcWZ9IQYf05Fns8Kdnf4gTI1q9xsF354bSdHVrp8JedqaJcL+1TBAEt+7RL7+BkU0SFHSUZYGeLNQHO7CT5drA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR12MB5468
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

[+Yang.Lee <yang.lee@linux.alibaba.com>]

On 2022-10-21 15:26, Andrew Morton wrote:

> The patch titled
>       Subject: mm/memremap: Introduce pgmap_request_folio() using pgmap offsets
> has been added to the -mm mm-unstable branch.  Its filename is
>       mm-memremap-introduce-pgmap_request_folio-using-pgmap-offsets.patch
>
> This patch will shortly appear at
>       https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-memremap-introduce-pgmap_request_folio-using-pgmap-offsets.patch
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
> From: Dan Williams <dan.j.williams@intel.com>
> Subject: mm/memremap: Introduce pgmap_request_folio() using pgmap offsets
> Date: Thu, 20 Oct 2022 14:56:39 -0700
>
> A 'struct dev_pagemap' (pgmap) represents a collection of ZONE_DEVICE
> pages. The pgmap is a reference counted object that serves a similar
> role as a 'struct request_queue'. Live references are obtained for each
> in flight request / page, and once a page's reference count drops to
> zero the associated pin of the pgmap is dropped as well. While a page is
> idle nothing should be accessing it because that is effectively a
> use-after-free situation. Unfortunately, all current ZONE_DEVICE
> implementations deploy a layering violation to manage requests to
> activate pages owned by a pgmap. Specifically, they take steps like walk
> the pfns that were previously assigned at memremap_pages() time and use
> pfn_to_page() to recall metadata like page->pgmap, or make use of other
> data like page->zone_device_data.
>
> The first step towards correcting that situation is to provide a
> API to get access to a pgmap page that does not require the caller to
> know the pfn, nor access any fields of an idle page. Ideally this API
> would be able to support dynamic page creation instead of the current
> status quo of pre-allocating and initializing pages.
>
> On a prompt from Jason, introduce pgmap_request_folio() that operates on
> an offset into a pgmap. It replaces the shortlived
> pgmap_request_folios() that was continuing the layering violation of
> assuming pages are available to be consulted before asking the pgmap to
> make them available.
>
> For now this only converts the callers to lookup the pgmap and generate
> the pgmap offset, but it does not do the deeper cleanup of teaching
> those call sites to generate those arguments without walking the page
> metadata. For next steps it appears the DEVICE_PRIVATE implementations
> could plumb the pgmap into the necessary callsites and switch to using
> gen_pool_alloc() to track which offsets of a pgmap are allocated. For
> DAX, dax_direct_access() could switch from returning pfns to returning
> the associated @pgmap and @pgmap_offset. Those changes are saved for
> follow-on work.
>
> Link: https://lkml.kernel.org/r/166630293549.1017198.3833687373550679565.stgit@dwillia2-xfh.jf.intel.com
> Signed-off-by: Dan Williams <dan.j.williams@intel.com>
> Suggested-by: Jason Gunthorpe <jgg@nvidia.com>
> Acked-by: Felix Kuehling <Felix.Kuehling@amd.com>
> Cc: Matthew Wilcox <willy@infradead.org>
> Cc: Jan Kara <jack@suse.cz>
> Cc: "Darrick J. Wong" <djwong@kernel.org>
> Cc: Christoph Hellwig <hch@lst.de>
> Cc: John Hubbard <jhubbard@nvidia.com>
> Cc: Alistair Popple <apopple@nvidia.com>
> Cc: Alex Deucher <alexander.deucher@amd.com>
> Cc: "Christian König" <christian.koenig@amd.com>
> Cc: "Pan, Xinhui" <Xinhui.Pan@amd.com>
> Cc: David Airlie <airlied@linux.ie>
> Cc: Daniel Vetter <daniel@ffwll.ch>
> Cc: Ben Skeggs <bskeggs@redhat.com>
> Cc: Karol Herbst <kherbst@redhat.com>
> Cc: Lyude Paul <lyude@redhat.com>
> Cc: "Jérôme Glisse" <jglisse@redhat.com>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
[snip]
> --- a/drivers/gpu/drm/amd/amdkfd/kfd_migrate.c~mm-memremap-introduce-pgmap_request_folio-using-pgmap-offsets
> +++ a/drivers/gpu/drm/amd/amdkfd/kfd_migrate.c
[snip]
> @@ -325,7 +328,8 @@ svm_migrate_copy_to_vram(struct amdgpu_d
>   
>   		dst[i] = cursor.start + (j << PAGE_SHIFT);
>   		migrate->dst[i] = svm_migrate_addr_to_pfn(adev, dst[i]);
> -		svm_migrate_get_vram_page(prange, migrate->dst[i]);
> +			svm_migrate_get_vram_page(&kfddev->pgmap, prange,
> +						  migrate->dst[i]);

Yang Lee pointed out that the indentation was broken here. I don't know 
what to do with his patch because it doesn't apply to the branches I 
work on. What's the best way to fix this before it goes to Linus' master 
branch?

Thanks,
   Felix



>   		migrate->dst[i] = migrate_pfn(migrate->dst[i]);
>   
>   		spage = migrate_pfn_to_page(migrate->src[i]);
[snip]

