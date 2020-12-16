Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F3535C2BBCF
	for <mm-commits@archiver.kernel.org>; Wed, 16 Dec 2020 07:48:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BCE4F23356
	for <mm-commits@archiver.kernel.org>; Wed, 16 Dec 2020 07:48:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725788AbgLPHsb (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 16 Dec 2020 02:48:31 -0500
Received: from mail-bn7nam10on2078.outbound.protection.outlook.com ([40.107.92.78]:13216
        "EHLO NAM10-BN7-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725905AbgLPHsa (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 16 Dec 2020 02:48:30 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bS4guLTOBg/Qm5wT9gQzTWXoEh1l4evMl4H60gG/++oAPKg82wrO2/BeTPa2hCcakgU1UkUdAAXVuLZQUqFxLz2rGiwUtDjFaYK4Qk1UohfETiYBxYatuAgPWrcFP+k40ftgBUIH4N/D1+OvCSsP2P/WzNzM4RS2Lhzj+dknRPzBHMn4WpaIh4BxEFdeAvt6+aN4FwmlFv7cilTxTOubzkfvDTbGLMOA9uhd8ptInefI8LylQdUgKkahruozQMge5TVgXgGRYNEXFMwRpifzkMx7zbpgFPjCbumSbnX+xEUX/wsXecTO/SHVz5BgkB6+8JL0ydEtbVaxALKoh65KsA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nILseBcQRR2loMQVzWY0cu4fcNbOgtexjYOhsfOPOqU=;
 b=MzJZk7zw0CQHWzVdFPBlJZ8EPXCpb1NV/gS+9cW/ewjrtkgjWmgBbJyDLfryQ1gr3GSONjmhqSybaFJxfqIhaFJ6lKNu9G0BN6qoFkwumnmzSx2AaBlNhmOBmxQ02f/hNjZOGx6nY+LaqoewDeREf7bQKtjHZw97mj8TAWQ67Frrky8O2pMuv0VRH4lEbN9KqOronABt+XLLA4AQBaAhFaIoRAYnZWNWCJtuZYxdzDfF+/2CwA8kux1QORpdB6VLTUCk/vm6Pbhcled2RiDw73WrQRDZ8baU3zh+/c7mM0/W+IPFO1xamoNc1QQ1AztaaAxgVJoaP2U/XxIHKwN8dg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nILseBcQRR2loMQVzWY0cu4fcNbOgtexjYOhsfOPOqU=;
 b=c7J2Saqde+uNLL/6KfySc2n4IqrBgQLrHhsnhY5F+F2Q77cqO8ofGO9kYpCORt8mttBlRDE9mtdEFtGwqrYKYP6Wux/IR3v9uRMO6qm9tSapSy838HUoi4MLrFOEVWZ30xn+b6HdAp0TK9UHzk4/un2/QXqasRzybd8QN4yRHvs=
Authentication-Results: suse.cz; dkim=none (message not signed)
 header.d=none;suse.cz; dmarc=none action=none header.from=amd.com;
Received: from MN2PR12MB3775.namprd12.prod.outlook.com (2603:10b6:208:159::19)
 by MN2PR12MB4237.namprd12.prod.outlook.com (2603:10b6:208:1d6::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3654.13; Wed, 16 Dec
 2020 07:47:35 +0000
Received: from MN2PR12MB3775.namprd12.prod.outlook.com
 ([fe80::44f:9f01:ece7:f0e5]) by MN2PR12MB3775.namprd12.prod.outlook.com
 ([fe80::44f:9f01:ece7:f0e5%3]) with mapi id 15.20.3654.025; Wed, 16 Dec 2020
 07:47:35 +0000
Subject: Re: [patch 012/200] mm: slab: clarify krealloc()'s behavior with
 __GFP_ZERO
To:     Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc:     Andrew Morton <akpm@linux-foundation.org>, airlied@linux.ie,
        alexander.shishkin@linux.intel.com, bgolaszewski@baylibre.com,
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
 <2172e342-e73f-a759-fce5-8b94daafd506@amd.com>
 <20201215190840.GU4077@smile.fi.intel.com>
From:   =?UTF-8?Q?Christian_K=c3=b6nig?= <christian.koenig@amd.com>
Message-ID: <14a1a889-fc99-47df-c336-1727e8e22b42@amd.com>
Date:   Wed, 16 Dec 2020 08:47:25 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
In-Reply-To: <20201215190840.GU4077@smile.fi.intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Originating-IP: [2a02:908:1252:fb60:be8a:bd56:1f94:86e7]
X-ClientProxiedBy: AM0PR07CA0024.eurprd07.prod.outlook.com
 (2603:10a6:208:ac::37) To MN2PR12MB3775.namprd12.prod.outlook.com
 (2603:10b6:208:159::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [IPv6:2a02:908:1252:fb60:be8a:bd56:1f94:86e7] (2a02:908:1252:fb60:be8a:bd56:1f94:86e7) by AM0PR07CA0024.eurprd07.prod.outlook.com (2603:10a6:208:ac::37) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3676.9 via Frontend Transport; Wed, 16 Dec 2020 07:47:31 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: d69d337f-4f27-4520-2101-08d8a196da64
X-MS-TrafficTypeDiagnostic: MN2PR12MB4237:
X-Microsoft-Antispam-PRVS: <MN2PR12MB42372F270B4A44055CDCFF0C83C50@MN2PR12MB4237.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: KkLKf5mbInLbNRvqohpMtQzNJwkzeD1iKq4O3HJXPHz+fZwIp3XweKTmM71ekQ2Wurk4rX3s7fDDtscuJpux49KpTcNMWx0eUUAl4msaRfU9rnhir0v8jwflisk7gjvXdG74HEnsNSDjWHp7jrN1r3imnRExZxiaCjyKHXqtAM1FOaMOcvg2pp8xSHd/KU/1pj45fbupbM9IEPs/Lbd1hi8b8I1ju6Gm8R50wlkrKKPHB7eBpG3DaRf5zW4OwNOEV54vjW9oic12IKpD95F1n8U9FZvLwSwEf0T74wQMUl7O7D/FMcmghsNr4f5bD8TZjVE20T5FOlTu93YYMXt0yr5lQIWtTI98Fqwi03CY1X4codrAkW8k5rUz2YUW5WKWFmkD8Xh9hmehXBIoJqo2mscN6rgWf09GqgNPFITljiE=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB3775.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(366004)(376002)(136003)(39860400002)(346002)(7406005)(478600001)(52116002)(2906002)(186003)(8676002)(66946007)(6916009)(8936002)(16526019)(6666004)(7416002)(66476007)(86362001)(66556008)(316002)(36756003)(2616005)(5660300002)(31686004)(4744005)(31696002)(6486002)(4326008)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?RnppbjBhNUZvZnFZTUwrbEM4d3hsK0NiWnE3VDVJWmpZR3QrK296Vm9hUVFD?=
 =?utf-8?B?bllaZEJWNXhCVTBNREg1Uyt0aUtqeGtLaHdUdFZOaU1STHREM1FnOXlzSFRu?=
 =?utf-8?B?RlE1TkRXMG9WWWVacDVrN1h6ZmhDd2VUVVlnL3RwT1VWelAzYW9UQkJUY21i?=
 =?utf-8?B?RGorVFNUYXYxbzBxNmxqM0pCOVlsUFNTQ2FNbGt6bHdxaWRLNmg4UC9aZ0xB?=
 =?utf-8?B?ZSt1WHlPRGYrT0NubkJHRTFRN2FDMGlRZUpzQlp3ejVQS2d0OUlXeExtc3Bp?=
 =?utf-8?B?UEpzbmRhcnV4bmRKMkhqL0NqbGxnc3lkblFVVlBMd3RZaFVVYU5GRkk1R0ov?=
 =?utf-8?B?bTZOS2lxTktOaTFvekdHd241YytlVnM4Y2hNUk51anh0Z0NNUEMyekVKbzAv?=
 =?utf-8?B?dGtEWUVLRVlQcFFJN2dNdzJXUzlUcWlDRUwrWlk1b0gvYUNDZUkweExtSllI?=
 =?utf-8?B?eGhoZFhkMVJtSUk0eVNJc1h1Y1QrNzE3N251WVMrcVJLRTQ5TWFvMzhsdlp0?=
 =?utf-8?B?Smh6UUU3TVBXbWJLeC9vRENVZUtIcUZma3hhRE9IZUVmSExhOE5MaEVUa2dv?=
 =?utf-8?B?SkpMR3VuVlRIVmRMOGd2Z0ZyN3RhK1lKQ2hOdTdxYVJCdmZ1WWNrZjVnVVoz?=
 =?utf-8?B?SWdaekpjTFRlMTZMYjdLeDl4cHE0QjVWdUlNWHhTdzd1enFwMWZ0d05yb3ZU?=
 =?utf-8?B?dWVGYXhxdjlMK3YrTW5SK2FvbmxBdmhrbXl0VWptUGFhZnNtdHBteTdiUENS?=
 =?utf-8?B?UXpWSVh4Mmt3WGZQR1J2dk9FVU5HckZ2RVo3bk1KcTZqbUxEalJxNjBQTjI0?=
 =?utf-8?B?amgwa01GajBMQkIzeFp4dXNjUVIyYWI1SFp1WEIzWmYzYlNPcWI0NjFMOHps?=
 =?utf-8?B?YTNwREtlMEZqa0Y3cWZBK05OVGVvaCtVSFBUcm16SHc1WGhXb1NQNTZVZUxx?=
 =?utf-8?B?K2VpVWpRNWxHR3VpZmxEbXZZOXA3ZGR5R2I1ZzJOaVU1TUtmQ3M5YVRzUFlQ?=
 =?utf-8?B?T1pkVDdoa21aNHpLQlp2bjFySzBabFU5U3BQc2VVOTlBWkMyUm1icEwyMHVH?=
 =?utf-8?B?RWxtSHU5M21lYVl3OUN2WUdUVU90endlVTdrVmFpdHFzbS9mNGFWNEdvckJm?=
 =?utf-8?B?Yjk3TTk2aEFxSkk3Z0YycjhLRHJRNzV6clhJdUFOMlNCM1dSVFQ5cTUxRGs3?=
 =?utf-8?B?bTZjaUpXWjAyMW44dHh3YnFkbDBQSEtaQWROUjNMbGNYL0QyMGtMVWZ3TjJu?=
 =?utf-8?B?V2d4UWIrUmFnV0tnMWg0MzRSSVBzTGpWdEozSkdPRjdNbng2VWNSSmx5QXRY?=
 =?utf-8?B?VmhENTREcHpjWUxJay9XYUkwUkdwWUZpWHpVRWZlakh1b29PT2FLcFlyTWxo?=
 =?utf-8?B?bXZWRTZ2YjRoYUtJTFMxbUkyN3FRN0lhYUFtVEtYVzlIdHhCM0E5c0V5NEZM?=
 =?utf-8?Q?x/jfEi9s?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB3775.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Dec 2020 07:47:35.2537
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-Network-Message-Id: d69d337f-4f27-4520-2101-08d8a196da64
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: jktsZvl+N7Y/kWK+9QHsMwUMJ+NsJbAnKB4JMUbPEqlX1XhMHEi2qTO3C8Y4fbnF
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB4237
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

Am 15.12.20 um 20:08 schrieb Andy Shevchenko:
> On Tue, Dec 15, 2020 at 03:30:44PM +0100, Christian König wrote:
>> Am 15.12.20 um 04:03 schrieb Andrew Morton:
> ...
>
>> Question: Can the fact that __GFP_ZERO is effectively ignored cause an
>> information leak if new size is larger than old size and the array is
>> somehow copied to user space?
>>
>> I think the answer is no, but just wanted to double check. Maybe we should
>> note that here.
> kmalloc()/kmalloc_array()/etc has the same. Should it be mentioned there as well?

No, they don't. If kmalloc()/kmalloc_array() would ignore __GFP_ZERO we 
would have quite a problem.

It is only krealloc()/krealloc_array() which ignore __GFP_ZERO when they 
don't reallocate memory because newsize is smaller than oldsize. In 
other words the freed up space is not cleared in any way.

Christian.
