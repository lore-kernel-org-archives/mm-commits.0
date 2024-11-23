Received: from NAM02-BN1-obe.outbound.protection.outlook.com (mail-bn1nam02on2081.outbound.protection.outlook.com [40.107.212.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 185F21A0AFB;
	Sat, 23 Nov 2024 20:30:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.212.81
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732393810; cv=fail; b=ncUZSBainrJm1MjTF95Mi2RrMeazbZkcqdiL/gKWGP9fgNUOZn06oi96gU0j7I4HcZNF/6tsHhGN4YNe+6xCn4o8oYbdYPgtrFoPRIfGr/UtPVBG4/pMfvoG5oEwB7b7jPoCcgbl0NbG6HiAkMOEkzaA96/IwCA/XvTh+VCJS1Y=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732393810; c=relaxed/simple;
	bh=Ba+0sRxD+XPPm3SNWaclRhk80NQbFSBplYZr27CU+ew=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=Dh7hgbPWptEU3QlWG/KAhKoAcGRC9dT62jNpk+g+T4rz2DDiwooxhMjSWlWSSW1R/PwS/5LYEd9gNz0PtsYR4by7VppuPOMReoXNEGY9V3BpkSg1Sun/4l2n4q7bhiFKFJ99uv/bN+gwro1fyTmpiuW2Te3PL4gnr0weT9Mc8PA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=oNiT+SXd; arc=fail smtp.client-ip=40.107.212.81
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="oNiT+SXd"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=oHcolLlfNisQxLWkG3Okaj2CwUO40OtlU5Ot9quKJ+KIx+Fj+e5li3fSlrbcueRMpF44Qlfs8gCsOU0fXVL+s4nukmao5uImsWV+U9zRZM1onKMzeszM0N0tvI6mJPTvAYj6oVovojF95Manpx/FMjPXTkDlz4RzxIWR96RZVEbE586jAK1eS7NcV/mBKk/EGfceaD4R5TEIhaZZyn6Dq1NLQxxi7jX55FZnVrdHNv2nt54I2Nmzv40/zpqJe5mpGxiXVCcZAhWc33iXfDZZ/qb/uwqO8KebV6QM5InbJm+4U3FmB63v0giAxZKVByl7+mld85yB7PiYcLBeYNZK1A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=UwboSAd2Zuuu6TxQO79b2o8YLz34aqR3qcrS6QCzkcw=;
 b=qktM9pyYv70acX/r+GAhsZ/zMFyclqW3kEDKGbgEFIFL/g51exGukwSK1uVWErUEQ4aCrRYHVrEP8//XesKeqQF2O8sFZD/0hllDHkoDEQPqBXd6QwcP9UynoPFQqJ1RmU+9mUGjzjkw4CZ26NbqDMUdn7ktYjbtZG5R89BIj7S8bqM1hME8Cil7eZpsDaAiD2smhi5stgmppgfZK4YDKAj7ILri61Qkr5WTh1/NKRjjXHVwlUYjo1fuTROCFKm/pf6YJ0r1GLHaNpjckA3yvx0eKkPqh5y8uCWV/1loqsHjFCPoB+WZb+OHpJkKYNQPTUE2x714jowYNDvUTNPkGw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UwboSAd2Zuuu6TxQO79b2o8YLz34aqR3qcrS6QCzkcw=;
 b=oNiT+SXdnh+/7gaFn/izfpT2I6sWAQin6io23RnJmB/NN8xNf1CTqAuqu5x2ga1mr5PP0dnkfgt9Om2l4l2bE/T4MWbySn8hY5SiXWFgV/dYjyw+vThxSq37hpoPr4h8bBqmeR3BQBtFPURcfihHg/rBSwQYAe9eKol8la+pFpgxrC1uAM7e7DjrMYapGnd4nEQ5k+qWYHimeWBq5oti1fpwTPqJ3L1ZhabQnSbj6UY7cum115MayJq3kZHW3fBbNT0DzOQwsRDyUHsYsrjL90ibjPsCXMThggEX4p6gmZs0DeLlbJJm8s+epVoOD15/IuZ7Q186FjyeXpoMDrMypg==
Received: from PH8PR07CA0029.namprd07.prod.outlook.com (2603:10b6:510:2cf::27)
 by DM6PR12MB4057.namprd12.prod.outlook.com (2603:10b6:5:213::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8182.19; Sat, 23 Nov
 2024 20:30:04 +0000
Received: from SN1PEPF000252A0.namprd05.prod.outlook.com
 (2603:10b6:510:2cf:cafe::92) by PH8PR07CA0029.outlook.office365.com
 (2603:10b6:510:2cf::27) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8158.25 via Frontend
 Transport; Sat, 23 Nov 2024 20:30:04 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 SN1PEPF000252A0.mail.protection.outlook.com (10.167.242.7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8182.16 via Frontend Transport; Sat, 23 Nov 2024 20:30:04 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Sat, 23 Nov
 2024 12:30:01 -0800
Received: from [10.110.48.28] (10.126.231.35) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Sat, 23 Nov
 2024 12:30:00 -0800
Message-ID: <17c5420c-a89a-411b-9ecd-2e868195f0d1@nvidia.com>
Date: Sat, 23 Nov 2024 12:30:00 -0800
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [GIT PULL] MM updates for 6.13-rc1
To: David Hildenbrand <david@redhat.com>, Andrew Morton
	<akpm@linux-foundation.org>, Matthew Wilcox <willy@infradead.org>
CC: Linus Torvalds <torvalds@linux-foundation.org>, <linux-mm@kvack.org>,
	<mm-commits@vger.kernel.org>, <linux-kernel@vger.kernel.org>
References: <20241118193001.6aefcadd7426feafedf824e1@linux-foundation.org>
 <ZzwVo0ZbuG37pHdR@casper.infradead.org>
 <20241121214229.8fe091954f9bf0d26f54ed88@linux-foundation.org>
 <fa398c31-7135-457e-b97d-366c12685688@redhat.com>
Content-Language: en-US
From: John Hubbard <jhubbard@nvidia.com>
In-Reply-To: <fa398c31-7135-457e-b97d-366c12685688@redhat.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: rnnvmail203.nvidia.com (10.129.68.9) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN1PEPF000252A0:EE_|DM6PR12MB4057:EE_
X-MS-Office365-Filtering-Correlation-Id: 1b32f84a-75eb-454d-a1cd-08dd0bfd9d00
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|36860700013|376014|82310400026;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?NHEvTjVmck5lb1crZzRhbWdaNVVkRFdOeHdFMGVCR1JuOHFnU25pRUlNZkxM?=
 =?utf-8?B?U01vM0dxNE1Ldm95TUpPYzRlaVlBNk81dkpuWkNXVHZhbmw5cHMxSDc2aXEy?=
 =?utf-8?B?b2h2amQxeEtPczc0bUo2UXFvM1BndXh0aVM4b0I0d3grT3FBS1Zja1RYUWwr?=
 =?utf-8?B?bWFqcjROUURuUG45Qk9IS0pTRGU3eDFudkFwOXBBN1FNK29tS2Z6NnJYTnkw?=
 =?utf-8?B?MCtjWUg4eVp4L1VCb1JEUlZFaHpsdk9SbDVyczh0Q0JRbUx1MVRVZG1tOTJ0?=
 =?utf-8?B?ZFdldDVlZXNrVzZqeDFrNFduSFNsZzVSMVF3UlpsV2FIS1EzNUdyRlhRV29w?=
 =?utf-8?B?ZU5CUFBpbWc0ekJleWU2aGpKbHlDbFhtU01BamRUdVRFR1A2K1lzR3BQZXAw?=
 =?utf-8?B?RTFUUWlPaEVLbmdmRHA4ZS83b2NibS92L3ZmMExnc3ROdVdjZkMrNFRJSFRG?=
 =?utf-8?B?bVlVUWtRNWFIUHg0Z1VEM2NPOXJDV1hGYU5oSXgyUVljWWl5UjNOWXFTNE9h?=
 =?utf-8?B?MXhRd3lVSUIwUkQrR2cxVmZTQ3d2cE5oeU9WYXA4UzMvY21PRXk4dTFiWSsw?=
 =?utf-8?B?dHVwb29qREFINnVEVXRSSkJONHBxWExwc3UxbDdVbXloUGw0dEFhMk0yTUJ4?=
 =?utf-8?B?WnN5bzRsdnRtV3M3Z3NRMHBwNThFMWZBdUF5UU05d0VOYkhQVGkzQmN5S09M?=
 =?utf-8?B?OUNNZjNFVVFFeUtIQmxQQ1pzOE1GZkszd2t1Wkd6bkdNbXFjRm9xQUFLN0RL?=
 =?utf-8?B?V2dtei96cXI5VGthTkhvSjkxSjRseG9tMWl2S0xIWEp3c0Myc1dha2pDM1pl?=
 =?utf-8?B?ZnNBeUh1eDNmQzdQRWlrZEx5MWNYRU84Q09IcXZwbjJqbURmVW5XdHRJNTlZ?=
 =?utf-8?B?cWl4czhLb3pWRkxtWU13UThJWlNzdSt6c0FtczlkRkNwQ1ROVUpvQ044TXla?=
 =?utf-8?B?NmNtaUxsRkQzdTRmQjVTd1UrdGd6bVRvcnJ5OW52UnB4cEpWWTYwVWN1amVs?=
 =?utf-8?B?UCtER1pHK0hYL1A3ZEFlL3JJeTRCV204TGNJUXVtNTQyL2E1QmdLbGs2TCtp?=
 =?utf-8?B?OUQyWVlBdURGZ1VQTjMwRWs2cDNhUWh6YkR1QkdYSnJ5aDZvRHp5Q1JYSFll?=
 =?utf-8?B?SFhsL3RJdENPZ1dhWDNDbUNScUoySmJqSkNkYmtCOTU2c1NGaEc4OERBb1Y2?=
 =?utf-8?B?bmlrQTRwdGgxbzdQbk5IR09rUmNTRjFEeW5GVk14bVBaek5Ia1QxcjlMR241?=
 =?utf-8?B?eWhtSVdCdkN0ODM0Z1l4WEIxWFVyRytmNVlNQWFZMWlZellGblMrZVZkVWZj?=
 =?utf-8?B?dUxPQWswTHdaLzdQVWNCakUrcWxNcVB2MnlJQkthS1FsZHFxWWVJVDJLbE5Z?=
 =?utf-8?B?cnAxeHpQMDZvNDRpaGJhL3lFZWtDcTR0bkZQRGJ5SnFoT2IvU1RQU3JKMjAy?=
 =?utf-8?B?cnpMVDlDcVBneEFzUFFhWU1MVHBraTVoYXVKT2M5V1Zsb2lPczF4bnoyaUxH?=
 =?utf-8?B?V0ZtbHdPaW9uamtlVmpNTmhXUllkVG5xaytySUtDaXFMeWZxc2lGYjdUelgw?=
 =?utf-8?B?aFNiVlVvZHFIK01xU2RUaEM5ZFJteHFyS3Z1REpCNno1d0VpVTZ5VWc0Q045?=
 =?utf-8?B?Q3REZ2h6c2IrMkY4ekthcmhKd3dMaElYNThuNFMxaElTWW40ODRKQzI1Vy9t?=
 =?utf-8?B?WmRaTzBWZmNtWnFyKzVzWVFUMVUvM2J2ZUZRYlE1YU9lTS9tZHdiU1d1U0w5?=
 =?utf-8?B?QXB4dlkvZnJIcDU0ZWJhUk5RbjUrcEJqa09tMC9nQU1peVBIdzdmaXl6eUlh?=
 =?utf-8?B?MWpJN3RTTjZuUjloRGV0K3AyTHJtZ1FhOHVQYWlWeUxYSW52NzVJRE9jNTZ6?=
 =?utf-8?B?eDB0aFBXVWk0dTVSZ3FDZmJnZ0gralNJcWtQOVF1UUhYZXhSV1NFbllVTWlZ?=
 =?utf-8?Q?MW7DF9rSkv4Wmnkc+ILlabXSasBLVDLd?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230040)(1800799024)(36860700013)(376014)(82310400026);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Nov 2024 20:30:04.3924
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 1b32f84a-75eb-454d-a1cd-08dd0bfd9d00
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SN1PEPF000252A0.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4057

On 11/22/24 3:23 AM, David Hildenbrand wrote:
> On 22.11.24 06:42, Andrew Morton wrote:
>> On Tue, 19 Nov 2024 04:35:47 +0000 Matthew Wilcox <willy@infradead.org> wrote:
>>
>>> On Mon, Nov 18, 2024 at 07:30:01PM -0800, Andrew Morton wrote:
>>>> Matthew Wilcox (Oracle) (13):
>>>>        ksm: use a folio in try_to_merge_one_page()
>>>>        ksm: convert cmp_and_merge_page() to use a folio
>>>
>>> Unfortunately you left the crap patch in from Gaosheng.  Linus, can you
>>> apply this fixup?
>>>
>>> >From 3d7e7319bbb3ced1dfb9c82bb7e8c7386380799b Mon Sep 17 00:00:00 2001
>>> From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
>>> Date: Mon, 18 Nov 2024 23:32:25 -0500
>>> Subject: [PATCH] mm: Revert IS_ERR_OR_NULL check
>>>
>>> &foo->bar is address arithmetic, not a dereference of foo.
>>> Huawei engineers seem particularly prone to not knowing this.
>>
>> It isn't only Huawai people.  David acked Gaosheng's patch and it snuck
>> past me (again).  People keep on getting tricked by this idiom and I
>> think we'd be better off with some nicely named wrapper to help
>> readers understand what's going on.
> 
> The helper we have is "folio_page(folio, 0)" ... and we do have a bunch of that usage in the kernel.
> 
> Likely we, want a more catchy helper that simply gives us the first (and for small folios the only) page.
> 
> ... not able to come up with good names though. folio_page0(), folio_first_page(), ... :(

Eh? You're doing great at coming up with good names, IMHO. Either of the
above would work nicely!

I'll put my vote in for folio_page0(), it's concise and yet crystal clear.


thanks,
-- 
John Hubbard

