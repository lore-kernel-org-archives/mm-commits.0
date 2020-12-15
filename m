Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.2 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 11ECAC4361B
	for <mm-commits@archiver.kernel.org>; Tue, 15 Dec 2020 07:44:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C539722273
	for <mm-commits@archiver.kernel.org>; Tue, 15 Dec 2020 07:44:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726644AbgLOHnp (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 15 Dec 2020 02:43:45 -0500
Received: from mail-mw2nam10on2078.outbound.protection.outlook.com ([40.107.94.78]:61345
        "EHLO NAM10-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726699AbgLOHnl (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 15 Dec 2020 02:43:41 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gwfkzNWyJc/N8nXtk1ZmL0sWJE1YGczci+DNx8bHEZ1w/t9ootH3pIjh3g9ItDRBCvqOahZW1rft2o84Nd17yNPz3gepbe/PLSd4pgm7nF0yAPqag/iLOySctTZigq6Cf6hIvDMRim6up2z2RztZYL6nkYQoWyNlW78/runqx0KsboH1f0Tt/iMDx/tIvvXv5lGI1i5o76BDu9MwI/evfoCHKby4V7SIaVTffQASNEZgdBz4e99rBe8HH5hqcEWSVwVyVzpcUMzzxdHePFrnpcnus/4pGdkMxoo8o2KIFHXPwHELUk7xdELLkNY4Gs36EGwdUYG2a2FYQPKaI+Ckiw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Nt1ehcL80sXloBrokcD1K73j0jIrbH0AufX5vFBlW+M=;
 b=f7XEyHbIn6Rxu4XJFnH02HlpyD7TGAlxDBT5dMOWOIToScnbW53zDON3UAwiu0lERgTNv1GGYat5bAIhESjfG/882QDeGI1jEnnW6IYKNRQ8PimgOn3n6/zXBkykd1DQ0DOBywnNduRuzoskhcCQI6ojUfSJnO9fYYUhEKpgUsgki+D/6KW0lf5odPy4nuthKG1b8HVPXi30r0LhrB48zRJetF5l0mZgbwh/zshUXD0NHyE8SaGRFpDSNk+yhdbsU6WojIG/OLx5kk8sLsyPvRMt7AWY7ogepd2JrfnrteFhGKU617PvCOT3FKCjLVADZViizUrnp0OESLlFg6n0lA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Nt1ehcL80sXloBrokcD1K73j0jIrbH0AufX5vFBlW+M=;
 b=z1nLEPM42ciTHh5fJ6MDRBJI04D8SuBH5OEMXucPeCYlv/UjPpkGTNY7ghcFR0zWw7HWp969FLfhZ27hxwtmaiIQ0/TGxFVe/5pHYmE+ERqhmIPF9zTIn8U3znFMwS7wd4lIHS9oqzAraHLmdu9JeXMp/PuppLcPAy6b/5im7KY=
Authentication-Results: suse.cz; dkim=none (message not signed)
 header.d=none;suse.cz; dmarc=none action=none header.from=amd.com;
Received: from MN2PR12MB3775.namprd12.prod.outlook.com (2603:10b6:208:159::19)
 by MN2PR12MB4391.namprd12.prod.outlook.com (2603:10b6:208:269::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3654.14; Tue, 15 Dec
 2020 07:42:46 +0000
Received: from MN2PR12MB3775.namprd12.prod.outlook.com
 ([fe80::44f:9f01:ece7:f0e5]) by MN2PR12MB3775.namprd12.prod.outlook.com
 ([fe80::44f:9f01:ece7:f0e5%3]) with mapi id 15.20.3654.025; Tue, 15 Dec 2020
 07:42:45 +0000
Subject: Re: [patch 020/200] dma-buf: use krealloc_array()
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
References: <20201215030425.glaMg3ez3%akpm@linux-foundation.org>
From:   =?UTF-8?Q?Christian_K=c3=b6nig?= <christian.koenig@amd.com>
Message-ID: <27d288c0-3677-8714-41ee-ec054be61961@amd.com>
Date:   Tue, 15 Dec 2020 08:42:35 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
In-Reply-To: <20201215030425.glaMg3ez3%akpm@linux-foundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Originating-IP: [2a02:908:1252:fb60:be8a:bd56:1f94:86e7]
X-ClientProxiedBy: AM0PR04CA0138.eurprd04.prod.outlook.com
 (2603:10a6:208:55::43) To MN2PR12MB3775.namprd12.prod.outlook.com
 (2603:10b6:208:159::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [IPv6:2a02:908:1252:fb60:be8a:bd56:1f94:86e7] (2a02:908:1252:fb60:be8a:bd56:1f94:86e7) by AM0PR04CA0138.eurprd04.prod.outlook.com (2603:10a6:208:55::43) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3654.12 via Frontend Transport; Tue, 15 Dec 2020 07:42:40 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 115da328-a336-4ce2-d8fc-08d8a0cd0367
X-MS-TrafficTypeDiagnostic: MN2PR12MB4391:
X-Microsoft-Antispam-PRVS: <MN2PR12MB4391EA4A41EC6F289F810BA483C60@MN2PR12MB4391.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3513;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: spymOFEyQLTT+9qxViJVv/S9lmmr4M6NZ8dsIkKB0LGZGvhUjoU4IueLxAWa2SsxUZe7DviHfTvwNjoLyrmWkjinn+VD5wi8elOe1OqUECcrShSRrZYOvUDfvigY48oN1FiRWOiZNdX6woQHVIoqUxuxP8g3kZ3aBVAtHyqrKvQqMIBG7dREeQD4WewPAxyPsytzn6ukpM0KUbTS0qSrgMOvpYC9L6Ti8COgzmwVZXtWu+zNAMXUzMB5qWFVj8Wf6EGFuceWNel5KgSeFZb15qREFpzOigE8PnhR3jtW9YeTeqzklxP3EafGcXk/OdCHqZxLcTWyAZ6C4Iz3Jgkgkpg4FgL9sbel+EqzwP9IXSskVGVxx3uaJAIY/HLhOseiqZ6nyFj7RyDF6qg1XzqIv2XVnhqNJEh1kOXtymqzjTKYKitill76rJS3mQJVpJex/uippGChCUZya30TJyL6uBvrBylhw+yVk/AMTSgxArG23sNjZS88Dnvew1j8XRL4QXFEbUJgAqDlYkVg+dO1pyQVJcjzD/2uD70opNIhByk=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB3775.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(376002)(366004)(346002)(2906002)(6486002)(31696002)(52116002)(966005)(83380400001)(36756003)(34490700003)(508600001)(16526019)(186003)(7416002)(921005)(7406005)(45080400002)(66476007)(31686004)(66556008)(66946007)(8936002)(5660300002)(86362001)(6666004)(2616005)(8676002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?cVB3aEY0cDIrdFVxQ1llaTQ0SUJpTjRIVGxuTU5OdWdvTnh6VWUxYXd4SCty?=
 =?utf-8?B?dVc3bkZZR2VRckJvcFRaSzk3T3R5ajhHb0RXWmt4bnBuYnd0L1BFU1kzZklC?=
 =?utf-8?B?dnVmQzgrSm1rclpIcmx0VzZ1ckg2MXlYY0cxVmwxSTJDREVVdWl1TENLaDUw?=
 =?utf-8?B?MHdsUGtHSXVqMUsxVVpVeHhGanRSVThLMGQrTllaMndROXFIWVJaZWFGMU5v?=
 =?utf-8?B?QmtNOHFUclVBbmd4ZXh1M2FNRzg3eCtPZStGdjZJa3ByZXlYQ0xNYkVGMkov?=
 =?utf-8?B?NFlMMXpsQjh6WkFJSmpnNk5kT3RhUi9ra3FNcmJTMVJYTU1YcjJqdkRYbmFB?=
 =?utf-8?B?TGw0YmhEN2N6bWJaRTU5Vm1iaFVwTjJOL3lFaGVlaGZMeHhrbXhCUVJQcVg0?=
 =?utf-8?B?V0x4eGJidHlnMElmVVFWejEvT2xHd3I0RkVmT2tIcU1NT0xGMHlTbDNQb3Jt?=
 =?utf-8?B?WktLVTFOdmxsT25ESDRCZUFGakN0MUNwYlN1SWxYbk9XcXRjZkwxN25aNCtn?=
 =?utf-8?B?azNaRGJjQzNZNVQ0UmJ3TWtrZFIwcnFvRVIzak0yek0wcnkveW1YMm9EODFw?=
 =?utf-8?B?WGZGd1VvcUJ2b1NzR1BjZmxGNUJHZWpGclkrWXhzY0JTdVduYWt6ZzlwUFRx?=
 =?utf-8?B?ZUxCNkpDWmhQTlQ5b0pSam1qSjQ3cEhMV2FwbjdoSG9WRXZnTnU1enM4S2JF?=
 =?utf-8?B?TDVnTVV1ZVZyVEQrMU5ITG5wTzQ3VmZScTNkOVpMeTY3NFN4QkplNDl6UHEy?=
 =?utf-8?B?TVQ0QlArV2tDR0dSZkJjQXF2TTYzOVkwOXdzcndTb2JrSU43Y0ZzVmI5bFE4?=
 =?utf-8?B?aXFtOW50SmFZekgwSUpUOTlrN3BFakordmVjbjlDVExNVXh3cEI0eGRadVcy?=
 =?utf-8?B?amxmM1RnSWdEdUJ3NmZxQlEycXhpZmluQlZXRW9ucE0zemNxdU5lRG4yVnp2?=
 =?utf-8?B?Y3BjN25IOWlFVVV4c2dkVXFGNkhZVDQ2VUFMM0VGTitqSm1Uakw2ZXdDWFVJ?=
 =?utf-8?B?ejB4M2pGS2thWjJ4SUJ5K3hCK3Z5UlBuMHVyVnJpY0FXTlJjMTdiczVrZFpo?=
 =?utf-8?B?WEhCUFVOcG02TkpDbHdYWFNtSUlvZ1dZWlVwUzBHSGxEaFRZTVdUazM1V05M?=
 =?utf-8?B?aUJTZ2h6ZWNOMmJaTVVLb0tLdTdaTnRpU1JxRDNwNWdYK2t5UzNRN09NYWVV?=
 =?utf-8?B?dWVhNVpxUnJpZ2t6R2hJWXBRbDh6OFBUTWZibWk1T3VpbFY0UjNTZ0Q0cDNZ?=
 =?utf-8?B?OWZrS3pPN3dUQ1ZlQU9oR0UwcDE0MEZteGJnZ3IrRTRrVGxhQ1lSMmFRdkFp?=
 =?utf-8?B?Rm94S05KMERrc210TUx1U3ZBVFRkYjNFTmd0NytkUmREZGl0ZGxHMmoxQmRG?=
 =?utf-8?B?VmFkWFlrQWlKSC92TkNrWHF3SFFuc0svcHg0Q2ZSamNiS0cvcTVJS1dma1dq?=
 =?utf-8?Q?7BB9+/ED?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB3775.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Dec 2020 07:42:45.7423
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-Network-Message-Id: 115da328-a336-4ce2-d8fc-08d8a0cd0367
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: xn/JgahCNdiGVSER4Vc6A0gYQ/oJk4HkMEytZhPtSgGHOLIyVV7mmB4iwHr1KzVo
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB4391
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

Am 15.12.20 um 04:04 schrieb Andrew Morton:
> From: Bartosz Golaszewski <bgolaszewski@baylibre.com>
> Subject: dma-buf: use krealloc_array()
>
> Use the helper that checks for overflows internally instead of manually
> calculating the size of the new array.
>
> Link: https://nam11.safelinks.protection.outlook.com/?url=https%3A%2F%2Flkml.kernel.org%2Fr%2F20201109110654.12547-10-brgl%40bgdev.pl&amp;data=04%7C01%7Cchristian.koenig%40amd.com%7C6b47239993c14bae4a2608d8a0a622ec%7C3dd8961fe4884e608e11a82d994e183d%7C0%7C0%7C637435982788605958%7CUnknown%7CTWFpbGZsb3d8eyJWIjoiMC4wLjAwMDAiLCJQIjoiV2luMzIiLCJBTiI6Ik1haWwiLCJXVCI6Mn0%3D%7C1000&amp;sdata=nXA6nN0XwBzItUWV8izu5MEsUboZ8dSJUr88geKWsuY%3D&amp;reserved=0
> Signed-off-by: Bartosz Golaszewski <bgolaszewski@baylibre.com>
> Acked-by: Christian König <christian.koenig@amd.com>
> Cc: Alexander Shishkin <alexander.shishkin@linux.intel.com>
> Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
> Cc: Borislav Petkov <bp@alien8.de>
> Cc: Borislav Petkov <bp@suse.de>
> Cc: Christoph Lameter <cl@linux.com>
> Cc: Daniel Vetter <daniel@ffwll.ch>
> Cc: Daniel Vetter <daniel.vetter@ffwll.ch>
> Cc: David Airlie <airlied@linux.ie>
> Cc: David Rientjes <rientjes@google.com>
> Cc: Gustavo Padovan <gustavo@padovan.org>
> Cc: James Morse <james.morse@arm.com>
> Cc: Jaroslav Kysela <perex@perex.cz>
> Cc: Jason Wang <jasowang@redhat.com>
> Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
> Cc: Linus Walleij <linus.walleij@linaro.org>
> Cc: Maarten Lankhorst <maarten.lankhorst@linux.intel.com>
> Cc: Mauro Carvalho Chehab <mchehab@kernel.org>
> Cc: Maxime Ripard <mripard@kernel.org>
> Cc: "Michael S . Tsirkin" <mst@redhat.com>
> Cc: Pekka Enberg <penberg@kernel.org>
> Cc: Robert Richter <rric@kernel.org>
> Cc: Sumit Semwal <sumit.semwal@linaro.org>
> Cc: Takashi Iwai <tiwai@suse.com>
> Cc: Takashi Iwai <tiwai@suse.de>
> Cc: Thomas Zimmermann <tzimmermann@suse.de>
> Cc: Tony Luck <tony.luck@intel.com>
> Cc: Vlastimil Babka <vbabka@suse.cz>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>

Reviewed-by: Christian König <christian.koenig@amd.com>

> ---
>
>   drivers/dma-buf/sync_file.c |    3 +--
>   1 file changed, 1 insertion(+), 2 deletions(-)
>
> --- a/drivers/dma-buf/sync_file.c~dma-buf-use-krealloc_array
> +++ a/drivers/dma-buf/sync_file.c
> @@ -270,8 +270,7 @@ static struct sync_file *sync_file_merge
>   		fences[i++] = dma_fence_get(a_fences[0]);
>   
>   	if (num_fences > i) {
> -		nfences = krealloc(fences, i * sizeof(*fences),
> -				  GFP_KERNEL);
> +		nfences = krealloc_array(fences, i, sizeof(*fences), GFP_KERNEL);
>   		if (!nfences)
>   			goto err;
>   
> _

