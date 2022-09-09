Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A5FC5ECAAD3
	for <mm-commits@archiver.kernel.org>; Fri,  9 Sep 2022 19:00:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230094AbiIITAv (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 9 Sep 2022 15:00:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48836 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229755AbiIITAp (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 9 Sep 2022 15:00:45 -0400
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2074.outbound.protection.outlook.com [40.107.220.74])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E1FD70E62
        for <mm-commits@vger.kernel.org>; Fri,  9 Sep 2022 12:00:42 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=b8GBvTOCgLlM06V2UL8mbv5H7WbE2hlJ/ctV2z+56rP3hAQXQ+/e26kTCAEhwK1T+8no1SwGl+z6GJpYlI9Fg5uI9N8rISJwGMk37ZurUnCVM9L14lqt0orkSH8sD80d1iQHeX9vqi7yvf8ufJDLyFLlvWl0hf/i4X43DI+yBtuSLvvFigNtMiZUHaamgqCuHFrW28iB8IAazoBS5nsbJHcr5VL1l4VpfJMMeknpc7vX2QYeSZvAjLbStaBXY1abtrWlDO8B1OomBvmsk5MeeR0ETZUjvsMoqWHPIZE+93jFh4gX61E336Xwhpmqo61n3J/UvRlG9RffWCHAFc+3Nw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0L47mm30iV1aXpidcI6EkO2DM27BqWNzU3UIA2m0R7c=;
 b=B8ot2xfRkmK9d4B+PnTw0gfMwSwgUPJTyE6sBRl7dfigAisMFLkwg95BGMIe/E1GOWU25FQOqMSRCk7w946HYMt291R5k/5iVT6A7ACyJCovGHN1s5WEsYIlmHwl1ud9GpMcPe90zIL6JDBbq3jFyL8OieO3+j34kCaoLbzRugKZ9DVs3ElL501eYaxvPpBWRIcw87+pMUVdXZbRXOcPrD5IC12IkGhRcTb3jJiDpLlVqBKWgzJcnheh7Xr1TrZ2ZUfwToEvocYO+L9ISElpXcsrywWv2eCo84+obYMbqXVUaNiYW9wXNtJJTSzPVb2skobAa/Cq1cRuRwa+PKC3tg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0L47mm30iV1aXpidcI6EkO2DM27BqWNzU3UIA2m0R7c=;
 b=NUXqsC1qHxGoHD8JFnUZja8INyE+3hNe/vEI54iQAj2GwDzbDYr27+aKjXyh6YoDqBeOTC6vR18QTD84D21ais4G9+mH7BqgyEl81vmni35TCN7mm9MdR18mPt4e3KqJIfZXUNc60Cfx6z9DNyASqYt/ZamjG+6CjGdOyioBllbxkwXjpEwdKRSxitW/KT1u5K61IwGQNrSR27KIPXijJJYiWBCGqq/6rTNWH0Qz2eT9fLn9sGFcSN+YcQNp7dpox9s28MYvgQUWcX5AP/migUmefSltj1jSpxH+g4VRklQyiHbADT6ukk/AAhKaf/ZJ0A/jSmvFlC+WqyucMhaeqQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from BY5PR12MB4130.namprd12.prod.outlook.com (2603:10b6:a03:20b::16)
 by CH2PR12MB4039.namprd12.prod.outlook.com (2603:10b6:610:a8::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5588.10; Fri, 9 Sep
 2022 19:00:40 +0000
Received: from BY5PR12MB4130.namprd12.prod.outlook.com
 ([fe80::a4df:917d:22d6:6ea1]) by BY5PR12MB4130.namprd12.prod.outlook.com
 ([fe80::a4df:917d:22d6:6ea1%6]) with mapi id 15.20.5612.020; Fri, 9 Sep 2022
 19:00:40 +0000
Message-ID: <668df15f-1d04-822c-58aa-e892b9f187b1@nvidia.com>
Date:   Fri, 9 Sep 2022 12:00:37 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.0
Subject: Re: + mm-avoid-unnecessary-page-table-walk-for-__get_user_pages.patch
 added to mm-unstable branch
Content-Language: en-US
To:     David Hildenbrand <david@redhat.com>, Peter Xu <peterx@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>
Cc:     mm-commits@vger.kernel.org, jgg@nvidia.com, apopple@nvidia.com,
        chenwandun@huawei.com
References: <20220907233412.27BC6C433D6@smtp.kernel.org>
 <YxtJr0kyV1v6kx3N@xz-m1.local>
 <2da116d1-6dac-ae35-b37e-27d58840e233@redhat.com>
From:   John Hubbard <jhubbard@nvidia.com>
In-Reply-To: <2da116d1-6dac-ae35-b37e-27d58840e233@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BYAPR02CA0010.namprd02.prod.outlook.com
 (2603:10b6:a02:ee::23) To BY5PR12MB4130.namprd12.prod.outlook.com
 (2603:10b6:a03:20b::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BY5PR12MB4130:EE_|CH2PR12MB4039:EE_
X-MS-Office365-Filtering-Correlation-Id: 065feafd-d1fd-4201-e3fd-08da9295968d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 0v9ef8vOC2pwckvW3TORJYloxCRzONXHIHugFJo+iI7syeliEfkpskXOlM9f57axzwXAQwJlVz2xB5v2+h+yWlSMecy1rCuZo6QS+W/2sonh67DUSwbeuYeCIMnwu6DDRmGCyIJ1/ksMys1MO2LiANf0h0TXb18Jqx3snTyh+xPbkvM4t6sgDw1lcYOG9199qtnsEWp5hlE07ZlD/kHg7TwMbqCHBe1nRAuogUiBZipbz4Zj7dUjf+e2jd/cLQy9s7dy6QorFpolbbchiYiuBdJFWFmc1LwA6u/F5S0oRPbaPeCzcJ8Fd0FJ27dZ6v1Ic8GsW06KxTWf0We0YSwuJHsyGgTBZroH+tqjgrCXfNsTlDAPNg5bAxGMf1B8sEGAcGnwF2ss6Ew8O970psPJ/0SBQvNcb5HxxAnmlc0fW8qFpTy/PcmFaQjBr+3Y2V2AnLLv7ukEqeetL4mitQeKLSZ14U9ZC3hv6iUZpdWtou+S7NVWNijO+dM7yUClmGXEwvbGhnMxtx1ZEoMG0uQBu5cxMroaY/yeqNmwYB3/VGSfbza47pCQGlsTD1FruyErOZwoojDNMXfmBn6PxEOMGep4AjJ8gNoYoRnu1nsua/u8OVdU19YEy5iNjDUN7xG1agqmf9n84nYgG4PEJv7ixNnAihzP9f9uuujto024uDsbljYz4eOQisXI+WTFjFJQcLITJDySm9Sq5pnqNpllWduDbIPG/F2iXO4Yj7mb/7Ex+vNiZVhdr6dpCarj7M5R10+Y9qkz69VXsBojyAp7003rOQ21Tzo8x6oC5W8pWhM=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR12MB4130.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(366004)(39860400002)(346002)(396003)(136003)(376002)(53546011)(26005)(6512007)(110136005)(31696002)(6666004)(41300700001)(6506007)(478600001)(6486002)(86362001)(2616005)(186003)(4744005)(8936002)(38100700002)(66556008)(8676002)(4326008)(66476007)(36756003)(31686004)(2906002)(66946007)(5660300002)(316002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?WkQ5Z1NCd1htR1hsdlQ1Ykk2bE94KzZGdERCY05UQVN5ZVpWUEI1WWZwaG11?=
 =?utf-8?B?VkdEOTdxcnBCUFNWeWIzZzB4MzJQcFM3QmEySDVqcldxWi9oMmxRZVY3VlBt?=
 =?utf-8?B?aEg2SHdwSTMrZFpmTHlvTGxNV1hVMEdGTGd6VDFmM0hydVVScnNqSzZYZWY3?=
 =?utf-8?B?ZUp4ZGZhSFdmQklJTHRoeXI0Wm1uVkd1ZldocTFyUzQ0WUpxbURpS1kwY1FM?=
 =?utf-8?B?dENBNXhQR0JncGtwRGxuM3VteGNnYVJ0YUtYaUQvZGZSUlo4bVhBR3N1cmZU?=
 =?utf-8?B?THJVdFFIV2VRK0xEaEx4V2d5TEdjQUN0TEpLaVlLMVdlK2dTYnIyNnhDc1JQ?=
 =?utf-8?B?WVkzdWhUNjhmUy9ac2lSNW1qVTY0VFB4bE84NTVZZTk2UldzNXZJUDNjMXRL?=
 =?utf-8?B?Z2w1NGFUVG9oZDlSTWtGZy85bWliK0c0L3dXNyswZTE5c1ZVWENZVUFtTVg2?=
 =?utf-8?B?eUZNajUrUjd2bWRIQnVWa3FCNTBrN1NxRDNtbkN3ekdMOWxUTFZXUU8vRkl0?=
 =?utf-8?B?Nm0wQkRadmhDZ2dPdUUwalFWdmhPblYzeHZpZVJMSU53TldsTldNU3RNM0hW?=
 =?utf-8?B?K2J0WGlZYjErWGkyampXZWpDYlZPQjMrYUk4TCsrVk03RnJReVFrOUs0VWJO?=
 =?utf-8?B?QnZLSlBYOHhoOUpUa1k3UWYvbmpVQmdDdnRVb2dJTFJNaTRJNFVWdzNxZkFU?=
 =?utf-8?B?b0sxazRmakl4dDhPU09VSDIrS0ptMGYxckx4dUpZN24rTzJ1Q1RmK29EV1lz?=
 =?utf-8?B?RlZkZG1TckVBMVNXSGtMSDlEQTNsbjNURGtZcXordSt4RW5YdmZKMnIwc2Nh?=
 =?utf-8?B?OUVDcGdWV1JjUlB4TGxlU2RQb3NiUndRclRhRTBRMEE5dnhLd0o5OUxDU1Mx?=
 =?utf-8?B?TFFBbWJaNTViUzczcVdmcy8zYi9wbG5kRzRZcXY5ZGRrNWtOTWtWYXJQNHh5?=
 =?utf-8?B?TVROTFNOVDU4ZC9GbGtjaDVjM1oyUHZlZkdhaVZjMHZXS1BLb3lHYmpyY1M1?=
 =?utf-8?B?eitOakhVUlVPU0dzelM3VTVEWG5MdG5oZ2loQWN3TlJIUnR2dXUrVmdCYWov?=
 =?utf-8?B?MGVRWHhBdjRMalFPVVlGbkRvRitMQTc5ai9FUWp2eWtnV2VKWHFPazBDV2JR?=
 =?utf-8?B?dzBRYkJGSDRCbUt3S1hpajh2L3ZvaVFjVFNDY2dZY3d6V3VZVTNCMmxoT0ly?=
 =?utf-8?B?d3Z5WGk4SXNNRUZMS2E2SDlyc1ljTTltc0ZHZGxqWFIyM2tabHlyMXQrUWxX?=
 =?utf-8?B?Q2RnOTcvVzBma3VSeTg5bUVzeVhDVnBKdjZCbm5yT1pBbGpLTlpNbjVKM2RG?=
 =?utf-8?B?cXdTNTRwSDdyaXNVcVFjc0VvdEJnYW9Sc3RtTGd6TENtbStpeUo1WERmTG5X?=
 =?utf-8?B?UHBRUmVIRm5iWVgrNmNZbDVuSml0dlUwQlN4VnlNNUM3clA5U3V4WDhpWmFl?=
 =?utf-8?B?dVAyYXJsNVBEUHJiMFhxZnpiZXhOM1k1azRvV1hPb3dJbnFLelN0dnBXNGlO?=
 =?utf-8?B?T0x0WWZ4VjhVcXNVaDY0SHE5U0k3Ti9KNXZEY3NUVm4wVlJ5aVNydWVGbkh1?=
 =?utf-8?B?UTBCYjY3ejNoblp5U2lyUUZ6ZE80b1VMSG9jcGxkTXBWbVJUNWtDSGRFRUJy?=
 =?utf-8?B?cVpUQ01TQUVtYmM2MWkwNWRUWVVleExIQXFxNTZRUy9iVXJIK0FuYjlqMUlS?=
 =?utf-8?B?eTMycEhoWmY4NEFBaTZzbzJETGpiNFlTbkJzRDBCRmxTU3dmdG5yNys2MFg2?=
 =?utf-8?B?SHMvaGhtZ3ZHOXBUWm8xdFBsT2orYnU2Znl4TkJwMTRJaDhZQytPc1JkUTFX?=
 =?utf-8?B?Z3p6OFI1NnRwdHBIS2N5a3NiY2R6RDdEUzFHdVNiK2IvakhGTmxxTVR5N1hO?=
 =?utf-8?B?YitVTkQxc3RzRy84ZVliR2MwQXpyTVFPYTJremFuckdpTmtUNG1qQXdEalR1?=
 =?utf-8?B?bXNWWUxPZ2NubkhjcERGdGYxdFV4anJQc0NPc3FaL3RRVHdjUUhEN3FrTHpT?=
 =?utf-8?B?NGJnRkR5cG1BaFRmOVl3ajRQNTNhQm1qL0xpT1hiVGxycnd4MjJjdGV3ei9r?=
 =?utf-8?B?cDY5THNZZG9uY2l1QUpDdStaNHVRSFVoM1dZOTNLMkRnR1pLeDNMWmsza3JU?=
 =?utf-8?Q?IyXWnWihBS0Vrp8ropQG1OPL9?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 065feafd-d1fd-4201-e3fd-08da9295968d
X-MS-Exchange-CrossTenant-AuthSource: BY5PR12MB4130.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Sep 2022 19:00:40.1572
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: rq/upCuHUUrC2C8WCfh4Tx29SbsVxSPzLJjoour0yX5FGJ5aHK9OlxWaAiJuqSaZGprwH8yNAC6un6UavvdhKA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB4039
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

On 9/9/22 09:42, David Hildenbrand wrote:
...
>>> +				if (pages)
>>> +					goto retry;
>>> +				else
>>> +					goto next_page;
>>>   			case -EBUSY:
>>>   			case -EAGAIN:
>>>   				ret = 0;
>>
>> Will this mess up the refcounts already?  afaict follow_page_mask() is the
>> only place to grab the pages, and GUP should need to take refcounts on
>> pages even without pages** being passed in.
>>

My mistake for overlooking that super-important point, in review!


thanks,

-- 
John Hubbard
NVIDIA

