Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 43E79C38A2D
	for <mm-commits@archiver.kernel.org>; Wed, 26 Oct 2022 20:45:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233745AbiJZUp3 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 26 Oct 2022 16:45:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44828 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234015AbiJZUp2 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 26 Oct 2022 16:45:28 -0400
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2073.outbound.protection.outlook.com [40.107.223.73])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 950104DB45
        for <mm-commits@vger.kernel.org>; Wed, 26 Oct 2022 13:45:25 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bMyRvf8c+AH3rZ44wNCERcI/Bjn+fC6Lzk8w/r5P+LYlnh//LwJdBbUNGWSW7jz78TcsBtO9zou/EktBEXRUTOi+ldZMaTXBdxMd/gs8M7cOrYjgbArAfigttNoxBUYr/3j5l4NIqSlicnluE0gA08m3703Y8WRMGdr1lotUSFUsXnS3CSHG/IPUjNRBq/hkM/4Zod9r6PBmduQ8WNWFtysu4ylRKQZo2zqqgTHmGCFyj5XqrCjwxX5SrJ5kaoKWicFjpoEt4rAawn32i6bYq4gKI/RpWX4eUSeEVPo8WXmj6BujaKwNCY+ROzUZNOLhqhEj2Fsf2FT0tW8RUku5zg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=S+XHbIBlnz6mLyej9z0gfVvP3ujji1cyYd6wzilAPFk=;
 b=fn1/5gYYcs0ALs0kv1nE0tOH/CYFX+cHskvLkCtJUV4ijxYwXm08tnbs6xZVr0QI52IjHeNztKiRp3C5+dHldrDwCgwNeZ+PYslGqCcl9sj60xUKcsZxf6ehWp5HJ+2WdR0P79BP8B79B7hjPq1UGRSs9STYpEacMwADmzgd63QnQUnFN9UV2poCqIiKLKcpy5gSSjmnWGoBI86+bBoffaKc7BsoPjEyZwI+4mWaSvZjsLvDHJpY24/UWc1MbfpK1qmFzjjqYX9MvVglMb+9p5a3kOKJR4IohRAS2ZQEGn8LR7OwvCpBxn2NhK8/bCCqMDuR2D7XWurjDkHzxIYzCw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=S+XHbIBlnz6mLyej9z0gfVvP3ujji1cyYd6wzilAPFk=;
 b=wQ0sUozHclvqAB+X5+EslvoldWDC4LXCc4brF2dw0nNs05ms/IUOVOydO5aUMciGDm1tw8bE6+lrTC/mm8fRQyLsk5uNfsegDUW5aNA4HSTZ0RvMO8tw5r5LEpZSBXyf4MHuGp1B9C6/HVVWaRbgMqPDWhZ7yzsLC7NiRtb++LI=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from BN9PR12MB5115.namprd12.prod.outlook.com (2603:10b6:408:118::14)
 by DS7PR12MB5864.namprd12.prod.outlook.com (2603:10b6:8:7b::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5746.26; Wed, 26 Oct
 2022 20:45:23 +0000
Received: from BN9PR12MB5115.namprd12.prod.outlook.com
 ([fe80::7e91:f457:9ec5:33be]) by BN9PR12MB5115.namprd12.prod.outlook.com
 ([fe80::7e91:f457:9ec5:33be%6]) with mapi id 15.20.5746.026; Wed, 26 Oct 2022
 20:45:22 +0000
Message-ID: <7e9571a8-b5cc-cffe-fe6f-53cf8fc7c32c@amd.com>
Date:   Wed, 26 Oct 2022 16:45:19 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.2
Subject: Re: +
 mm-memremap-introduce-pgmap_request_folio-using-pgmap-offsets.patch added to
 mm-unstable branch
Content-Language: en-US
To:     Dan Williams <dan.j.williams@intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        mm-commits@vger.kernel.org, Xinhui.Pan@amd.com,
        willy@infradead.org, lyude@redhat.com, kherbst@redhat.com,
        jhubbard@nvidia.com, jglisse@redhat.com, jgg@nvidia.com,
        jack@suse.cz, hch@lst.de, djwong@kernel.org, daniel@ffwll.ch,
        christian.koenig@amd.com, bskeggs@redhat.com, apopple@nvidia.com,
        alexander.deucher@amd.com, airlied@linux.ie,
        Yang Li <yang.lee@linux.alibaba.com>
References: <20221021192639.3FDBBC433C1@smtp.kernel.org>
 <3a35bcc0-71df-c302-081d-990c5e5ed096@amd.com>
 <6359995d2415_4da329482@dwillia2-xfh.jf.intel.com.notmuch>
From:   Felix Kuehling <felix.kuehling@amd.com>
Organization: AMD Inc.
In-Reply-To: <6359995d2415_4da329482@dwillia2-xfh.jf.intel.com.notmuch>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: CH2PR04CA0011.namprd04.prod.outlook.com
 (2603:10b6:610:52::21) To BN9PR12MB5115.namprd12.prod.outlook.com
 (2603:10b6:408:118::14)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN9PR12MB5115:EE_|DS7PR12MB5864:EE_
X-MS-Office365-Filtering-Correlation-Id: 648d17b9-0089-4ccc-2f55-08dab7930091
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: E7ryOCGWcY3bfoylUgRTFO43KpjYhuuvjiLvhT8WqwPgsY4iStDOWYz2RYv1S3o70z9okqhTo1oWrMH2YqoMy3aa204SF6z6i/7pLOy9t7LHirBydtQe16S+qYXaFalsChqzys+evktquiU/+J2zADDVnPwcQCsVzsYXxBWxOlv7HJBB4Pmet7KQZ8l3dGm84OA9wuZOu/MyG2+ZTVJlsfRXRE/TzKl/I6Z3Re9F97hXAAAKhdE7iltx5IGi3Q/BSfyWPhW7NMkMTZgHKoJ01O210fdRTa/NxSpQ0yR3ER4Bwn2NDk5V8fyYHWyy+YiHH80rSQfXcwSsMJ1E21DUDmaYSF/ew4crTws6aaEPbakfPmOCESDLVVvM9jjfZH6t7LUJD8URF/hLL7iIcun3HqPHYIZoeJFcYKg3eUkGLluCVIJ8Wt8zokYa1tb3/YzkulVkrfTEhkJ953gqUGicOkSdve5BsLqAgMVib7TEEVbbGZIU7/LO0JCb3EMzLjaUW+l25poJ/Ko9EeEF1c+oB8RLal/Ttf/EN3QkyANz/5emG1MdXso8q4OGY+Ry5jyyuJAiERo+KqR9hq6+mWMkq7+FBX0dRj3y+G4rEl3zNutDZHF7UNsSQno5XY6lAq3/K0Y84NOBZt7Mt9XXobTnKb5HyOZadRsWfTnDEcrqHFXWTpWOWP5OJAi7aL8XrcMld0qeyxj07ig7f1xIw8UagU/xgjCWtP0Z0IZYlZzf3MWL2ugf+YNhSDW5oIyxh5Svdhxlw8U/W879EMWWjMiGpaBWuS3Ow+6G8vmSZcKh/+bKI0DUFCNsb/TPkWLeIGKAoLtSO0RH8E4C3gsj3quPbJj/u4qGL2kisIHp48gVfSo=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR12MB5115.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(136003)(396003)(366004)(346002)(376002)(39860400002)(451199015)(66899015)(66476007)(36756003)(41300700001)(316002)(36916002)(6506007)(66556008)(8676002)(53546011)(6666004)(66574015)(110136005)(66946007)(921005)(86362001)(83380400001)(31696002)(5660300002)(8936002)(6512007)(26005)(7416002)(2616005)(4001150100001)(186003)(2906002)(478600001)(44832011)(966005)(38100700002)(31686004)(6486002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?ckVTVkxrRUtEeFRoQUsxRGFFaFdRVEw3Y1pzN0haVlRFTSs1VHJuVlkybEVW?=
 =?utf-8?B?TnN0ZFhIMlQ2ZHI2Tm96ZUV3TmhVM01yWnVidElrUlo3eURZdzdaUWJnd0Z4?=
 =?utf-8?B?a3VnTzAwMG1GUU9nRjVjS29WcWxVdmZ2UDlrblR2d1QwNmVxMWlNMTZTNm01?=
 =?utf-8?B?RDc4bk80clFHcGhhMzB1SDBCWWZ1dzdQWlNORU1QU2o1elZQd2EvdFhQSUFB?=
 =?utf-8?B?ZExHQ3BwOEtxLzlhREwzR21JUVNsajJoOXRmdDFWanpNdHhtKzBxcGdZZFBT?=
 =?utf-8?B?cXZqckxyYzA0d3NkVENFZjNJTmtFZjB4ZzlGT2tjSWtsUDAyQkRkbTMyRERp?=
 =?utf-8?B?Y2hwUVYzYVVkTlFhWmZhYVV0VlFDcUpMWFhYaW1taTFRZjJxMWxnSGRRTk9R?=
 =?utf-8?B?Wnc0ZkJ0M1g3VDU4NTdLejNxK1k0TjFsdHBjNTFEb3UrVFZmMlBQSzIzaldk?=
 =?utf-8?B?SEpzbHl5ckFBSGpXOEtNUTFWdnBxU2NTOGlPQitkUkpOTE4xZUZZY1I1dnNN?=
 =?utf-8?B?SjZ0aFBqamljR1oxcGpFbDVlbkFPOUhjNzM1MnhnZ0xNSXBHUXBVYzJWNFdh?=
 =?utf-8?B?Y2kyeXJCRzVhQmxQb2lmTytyTkxLS1hWV3Brdy9lOE1uKzI4U1ZTb2NlL1J4?=
 =?utf-8?B?elowQ0pyVW13RkxUTXU0cVQ3OXExSVpJRXhudldIY0RMakk2YU1xN0J1dGF4?=
 =?utf-8?B?a3g1dm1aRkpNUG0vamZRQndDVnl6MDZ6Y2JuV1Y5ZHBjd0JrQkhLMFlOZlEz?=
 =?utf-8?B?a0NUdmRtQWticXU5UG5BL3Y2d2k1WVUvcXBUL3dYUzFFMW1YekUwVWFyemFR?=
 =?utf-8?B?MnNST2Q4YUdsSXBHbjVGajQ5ZVNaWU1GKzBPdFpHVGpoblBkeFNjdzkvbHBJ?=
 =?utf-8?B?aG9zQlB1a1pQWUU1cU9iRUt6TVNqZ1RMNm55VXRLSXNoNzRXQXN1MGR5ZjVl?=
 =?utf-8?B?YkhiZXYrTktiWU1Nc29wb2w1bUc0NEQ1SmlxdkEwd2ZuQzhxYjZDVzV6Ymhi?=
 =?utf-8?B?cXpaMnBLTndYOWZTNWZaZFZ4eVdPSElQakdVU3hTbGh2ajM1ZE1jczVaUDEz?=
 =?utf-8?B?S1VBS3ZkUmJKUWtqcWs2T3Nld3RPWDJmRDQ2ckdDSFZLZHRlNmxiSkc4MEpp?=
 =?utf-8?B?WW9XUDBXQkpwMUU3VjdsU1Q3ckNTN2lrc2g1T1JhQlVOMFRYQVRKMTRYUlpo?=
 =?utf-8?B?U1pQWFNUMy9GMHFJeFZpM3JEQ3lRM0VNa3BIUWZyR29vcDM1L1A2blNmOHFu?=
 =?utf-8?B?blNWcFNKZENFdmkwTFcvVFRNK2lDL0YvbXIxNFRjWGJ4VmQ5WXB1SG1TazlL?=
 =?utf-8?B?TWIwTUU0b00waGk3WkJReDVQSXQxYnRKbzcydDFFUFV2RVFwcnZGeFZxT3Jp?=
 =?utf-8?B?NzRzVlZEaGgwc1BKZDEzOXBwdmtJeUZOWUNvSDZ5VUJQY1ZKK29vc0haMlFB?=
 =?utf-8?B?cWM3K2Z6ekFtSkxlUzdkOUUwU09kaE1lQ2l3K3lVeVU2V2p6MjZyV2tqNnE0?=
 =?utf-8?B?RGx0VGtUbjlrcXhNK1dOWFVUY2hURThzS0hGM0JtQWZhUkJ5NnR5ZWtDSE9y?=
 =?utf-8?B?bytOWldsT3JLY0FLdkU5WjlFZTdiM1pPUFN3VkM1S2NHUVpuQnpSR1FhR1ZC?=
 =?utf-8?B?b2pKcmdUK1NqVzZPUkFad0FNaDJCR2RueXVraGo5MEV1L3g0MEg1YjJWVnBt?=
 =?utf-8?B?Z3l6TzdyMnFnOTl0T2pkOGp4TExYM3dTdU1VaWt4SURHNFBDalkwWmI5VU1T?=
 =?utf-8?B?eXpEVXhqdHRmZ3Fkd2xwdjhoMEJwTHhsKzBDREFQNWFwM3F0VXdXQ1ZWTTJ6?=
 =?utf-8?B?YmozQWxXMk0vUzluRzlZZ004K1hwUU9ITGhFanlwWDJVWVJ2dFR2WmRWRTJq?=
 =?utf-8?B?aUJMOHROUURZT1dFYlRIT3VsYmxReDFOUHIvQ0RMdUdHVDRqMHlYTk1Mb0tu?=
 =?utf-8?B?dk9SektobjZPQmpYazdaTDUwR3ViTy81cGFUZzRRQXVVU0NnUUY2N0x1TFlC?=
 =?utf-8?B?bDNYbyt6SEhMYnpRMk1pY2xWVmU2d3NZaVpWLzNyMzhsVEZEWlFlcldNTmxx?=
 =?utf-8?B?TGRkeU9RbnAyRjRMUlA2RjlyWTZSWlVHam4zK1B1Z1orbEJzdmhndW9ERU1q?=
 =?utf-8?Q?8N/FCN/Eogc9wkhz+Ru71T96Q?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 648d17b9-0089-4ccc-2f55-08dab7930091
X-MS-Exchange-CrossTenant-AuthSource: BN9PR12MB5115.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Oct 2022 20:45:22.5342
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: SOrwlZK/haKcxnGXisLOrZGz9mRc3b7zKOIvZJ5zSd+49950plmWDP3/xdcgxW9PiVXUYqO6ayHVI+UJhMxI7g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR12MB5864
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

On 2022-10-26 16:32, Dan Williams wrote:
> Felix Kuehling wrote:
>> [+Yang.Lee <yang.lee@linux.alibaba.com>]
>>
>> On 2022-10-21 15:26, Andrew Morton wrote:
>>
>>> The patch titled
>>>        Subject: mm/memremap: Introduce pgmap_request_folio() using pgmap offsets
>>> has been added to the -mm mm-unstable branch.  Its filename is
>>>        mm-memremap-introduce-pgmap_request_folio-using-pgmap-offsets.patch
>>>
>>> This patch will shortly appear at
>>>        https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-memremap-introduce-pgmap_request_folio-using-pgmap-offsets.patch
>>>
>>> This patch will later appear in the mm-unstable branch at
>>>       git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
>>>
>>> Before you just go and hit "reply", please:
>>>      a) Consider who else should be cc'ed
>>>      b) Prefer to cc a suitable mailing list as well
>>>      c) Ideally: find the original patch on the mailing list and do a
>>>         reply-to-all to that, adding suitable additional cc's
>>>
>>> *** Remember to use Documentation/process/submit-checklist.rst when testing your code ***
>>>
>>> The -mm tree is included into linux-next via the mm-everything
>>> branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
>>> and is updated there every 2-3 working days
>>>
>>> ------------------------------------------------------
>>> From: Dan Williams <dan.j.williams@intel.com>
>>> Subject: mm/memremap: Introduce pgmap_request_folio() using pgmap offsets
>>> Date: Thu, 20 Oct 2022 14:56:39 -0700
>>>
>>> A 'struct dev_pagemap' (pgmap) represents a collection of ZONE_DEVICE
>>> pages. The pgmap is a reference counted object that serves a similar
>>> role as a 'struct request_queue'. Live references are obtained for each
>>> in flight request / page, and once a page's reference count drops to
>>> zero the associated pin of the pgmap is dropped as well. While a page is
>>> idle nothing should be accessing it because that is effectively a
>>> use-after-free situation. Unfortunately, all current ZONE_DEVICE
>>> implementations deploy a layering violation to manage requests to
>>> activate pages owned by a pgmap. Specifically, they take steps like walk
>>> the pfns that were previously assigned at memremap_pages() time and use
>>> pfn_to_page() to recall metadata like page->pgmap, or make use of other
>>> data like page->zone_device_data.
>>>
>>> The first step towards correcting that situation is to provide a
>>> API to get access to a pgmap page that does not require the caller to
>>> know the pfn, nor access any fields of an idle page. Ideally this API
>>> would be able to support dynamic page creation instead of the current
>>> status quo of pre-allocating and initializing pages.
>>>
>>> On a prompt from Jason, introduce pgmap_request_folio() that operates on
>>> an offset into a pgmap. It replaces the shortlived
>>> pgmap_request_folios() that was continuing the layering violation of
>>> assuming pages are available to be consulted before asking the pgmap to
>>> make them available.
>>>
>>> For now this only converts the callers to lookup the pgmap and generate
>>> the pgmap offset, but it does not do the deeper cleanup of teaching
>>> those call sites to generate those arguments without walking the page
>>> metadata. For next steps it appears the DEVICE_PRIVATE implementations
>>> could plumb the pgmap into the necessary callsites and switch to using
>>> gen_pool_alloc() to track which offsets of a pgmap are allocated. For
>>> DAX, dax_direct_access() could switch from returning pfns to returning
>>> the associated @pgmap and @pgmap_offset. Those changes are saved for
>>> follow-on work.
>>>
>>> Link: https://lkml.kernel.org/r/166630293549.1017198.3833687373550679565.stgit@dwillia2-xfh.jf.intel.com
>>> Signed-off-by: Dan Williams <dan.j.williams@intel.com>
>>> Suggested-by: Jason Gunthorpe <jgg@nvidia.com>
>>> Acked-by: Felix Kuehling <Felix.Kuehling@amd.com>
>>> Cc: Matthew Wilcox <willy@infradead.org>
>>> Cc: Jan Kara <jack@suse.cz>
>>> Cc: "Darrick J. Wong" <djwong@kernel.org>
>>> Cc: Christoph Hellwig <hch@lst.de>
>>> Cc: John Hubbard <jhubbard@nvidia.com>
>>> Cc: Alistair Popple <apopple@nvidia.com>
>>> Cc: Alex Deucher <alexander.deucher@amd.com>
>>> Cc: "Christian König" <christian.koenig@amd.com>
>>> Cc: "Pan, Xinhui" <Xinhui.Pan@amd.com>
>>> Cc: David Airlie <airlied@linux.ie>
>>> Cc: Daniel Vetter <daniel@ffwll.ch>
>>> Cc: Ben Skeggs <bskeggs@redhat.com>
>>> Cc: Karol Herbst <kherbst@redhat.com>
>>> Cc: Lyude Paul <lyude@redhat.com>
>>> Cc: "Jérôme Glisse" <jglisse@redhat.com>
>>> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
>> [snip]
>>> --- a/drivers/gpu/drm/amd/amdkfd/kfd_migrate.c~mm-memremap-introduce-pgmap_request_folio-using-pgmap-offsets
>>> +++ a/drivers/gpu/drm/amd/amdkfd/kfd_migrate.c
>> [snip]
>>> @@ -325,7 +328,8 @@ svm_migrate_copy_to_vram(struct amdgpu_d
>>>    
>>>    		dst[i] = cursor.start + (j << PAGE_SHIFT);
>>>    		migrate->dst[i] = svm_migrate_addr_to_pfn(adev, dst[i]);
>>> -		svm_migrate_get_vram_page(prange, migrate->dst[i]);
>>> +			svm_migrate_get_vram_page(&kfddev->pgmap, prange,
>>> +						  migrate->dst[i]);
>> Yang Lee pointed out that the indentation was broken here. I don't know
>> what to do with his patch because it doesn't apply to the branches I
>> work on. What's the best way to fix this before it goes to Linus' master
>> branch?
> Send a patch relative to mm-unstable, like a typical Fixes: patch, and
> Andrew will roll it in / squash it when it is time for this work to roll
> from mm-unstable to mm-stable.

OK. Hi Yang Lee, do you want to add a Fixes: tag to your patch and send 
it to linux-mm, CC Andrew Morton, Dan Williams and myself?


>
> ...and apologies for the whitespace corruption, I missed that mistake.

It wasn't in the version of the patch I reviewed earlier. Maybe 
something went wrong with a rebase and it's easy enough to miss.

Regards,
   Felix


