Received: from APC01-PSA-obe.outbound.protection.outlook.com (mail-psaapc01on2042.outbound.protection.outlook.com [40.107.255.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 594532943F;
	Sun,  2 Jun 2024 22:24:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.255.42
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717367059; cv=fail; b=Arpw/JeTmVB2g2na/JDJJPUud9sMRK2CcAGoEZx+sh5FSgHeCnyL3fllC20MlJOsDq/mMaxdFuGpgi3/PBA1vcKfNrHGekJJzwatsYZcVrtDeSqy72hwjnLJofFOTFRe6fiuAQuIMjwZWp3r+bNqGb6tr961vsQjLkk+ANroy2o=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717367059; c=relaxed/simple;
	bh=hAZOM05fz3zop5ASpRxbeitqx2y+TBpEOm3Cp2bw5uA=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=HXxkJU4zKhlVRNTbj3BDryJjSjw41+PfaS/L6BQRHOlrKwYco0awCSeSYNWb96OfpR0UGcs5uX+xIqrlcOT7H2V+1BhLaGwtTAefIRfREOPgarIx/cjGjubDyIgBSQ8pK/7QQMzHLIjVY+QqTOy35eMcBYwKeymTMM5hVtiW9iE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oppo.com; spf=pass smtp.mailfrom=oppo.com; dkim=pass (1024-bit key) header.d=oppo.com header.i=@oppo.com header.b=AVB/tb0Y; arc=fail smtp.client-ip=40.107.255.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oppo.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oppo.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=oppo.com header.i=@oppo.com header.b="AVB/tb0Y"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UCP3IvvHiGb+CQmz/il0HSxDHVlmm1CXoHZ2UcV6FVbOc2Mg/wK4p7zuX6dcEQiAQhjj6WhmItzcEc5EwxENIC5o45LOk2+It91v9XP/J8UqC1U3b0I6uN6zj9Rsawjup1NSf5MQn3V7pv/0Y2hDO1f4uLSIw+HdcML12CVidJBvLx6SkwexEHeJG19VJ7NjyCCK8P8t65BJSUTizYW9hPnGZdfBes8m6x9ZkzbLC3l8OkAEs/4IOhwLikPCoPEVcrophG8zigHIr4q8Ui1i8TcYGhMI0GQOZUvyfdSUFiusv71npKAOxA3swOqYGIBU0QQWmCLaW+LHSmNuDBLVVA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=OY3RLYy3zaYL2RJU9CChfmpYDAXgzT7SOkeAEMxKNTk=;
 b=QzV/AbEiZhMjgCov/ovDxv8KeqZcKP1A/AIt/OwESOXoonfjDyDFmTpUNcEZHfZrzW5w7MPRLGh0vbKJM5fbPAsLE7GXxjwSUDEbkiO3/kihuCRv/FYtAGxPWByu6IcQtxotgmEBao1IoWQcfKthQxQq9KZOtogShWrujo5dCMv11MCP3cXkkpGPzgZZ4etvk/tYYlHT9jYL5r7RKpgLXG5roPDwqm1bsjLodwl/smhxf8iFCcHMImxXPjz6IMEBXZIhPLERMzM/1UCw5LLSSWBjsOrT/UQo44ojddiUuhv4Rpj6ohUYo9skEpnvbw+m2TUDNK4LjJ3A27ofhJenwA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 58.252.5.68) smtp.rcpttodomain=gmail.com smtp.mailfrom=oppo.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=oppo.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oppo.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OY3RLYy3zaYL2RJU9CChfmpYDAXgzT7SOkeAEMxKNTk=;
 b=AVB/tb0YPv9MHGQ7VsOAMav93yhqYuVh1meRgRQaTfnUFiP1Jujgt20ANhJ9KmzX/u7OT+eUI2A9OmBQqfaV3LhWie7dnWwqPKiAScqd/fUvIbwpdetHk6dMbHTg1N4LkAPNd+cX+z8X84JP14ylgNS/LWy/S8AzcNM6OaoP2bU=
Received: from PUZP153CA0008.APCP153.PROD.OUTLOOK.COM (2603:1096:301:c2::23)
 by TYZPR02MB5762.apcprd02.prod.outlook.com (2603:1096:400:1d2::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7633.25; Sun, 2 Jun
 2024 22:24:14 +0000
Received: from HK3PEPF0000021B.apcprd03.prod.outlook.com
 (2603:1096:301:c2:cafe::75) by PUZP153CA0008.outlook.office365.com
 (2603:1096:301:c2::23) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7677.3 via Frontend
 Transport; Sun, 2 Jun 2024 22:24:14 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 58.252.5.68)
 smtp.mailfrom=oppo.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=oppo.com;
Received-SPF: Pass (protection.outlook.com: domain of oppo.com designates
 58.252.5.68 as permitted sender) receiver=protection.outlook.com;
 client-ip=58.252.5.68; helo=mail.oppo.com; pr=C
Received: from mail.oppo.com (58.252.5.68) by
 HK3PEPF0000021B.mail.protection.outlook.com (10.167.8.37) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7633.15 via Frontend Transport; Sun, 2 Jun 2024 22:24:11 +0000
Received: from [127.0.0.1] (172.16.40.118) by mailappw31.adc.com
 (172.16.56.198) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Mon, 3 Jun
 2024 06:24:10 +0800
Message-ID: <fa0174ad-ba01-40bf-b6e9-72792b0b9f70@oppo.com>
Date: Mon, 3 Jun 2024 06:24:09 +0800
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: + mm-vmalloc-fix-vbq-free-breakage.patch added to
 mm-hotfixes-unstable branch
To: Zhaoyang Huang <huangzhaoyang@gmail.com>, Andrew Morton
	<akpm@linux-foundation.org>
CC: <mm-commits@vger.kernel.org>, <zhaoyang.huang@unisoc.com>,
	<xiang@kernel.org>, <urezki@gmail.com>, <stable@vger.kernel.org>,
	<lstoakes@gmail.com>, <liuhailong@oppo.com>, <hch@infradead.org>,
	<guangye.yang@mediatek.com>, <21cnbao@gmail.com>
References: <20240530200551.354DFC2BBFC@smtp.kernel.org>
 <CAGWkznHXyyfnu4eo4CdRyDO-Tvo+4eRASvkVyAHqFQ_i6W102Q@mail.gmail.com>
Content-Language: en-US
From: Hailong Liu <hailong.liu@oppo.com>
In-Reply-To: <CAGWkznHXyyfnu4eo4CdRyDO-Tvo+4eRASvkVyAHqFQ_i6W102Q@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: mailappw31.adc.com (172.16.56.198) To mailappw31.adc.com
 (172.16.56.198)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: HK3PEPF0000021B:EE_|TYZPR02MB5762:EE_
X-MS-Office365-Filtering-Correlation-Id: a84f10c4-48e4-4a4f-4b3f-08dc8352ba95
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230031|376005|82310400017|36860700004|1800799015|7416005;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?MW9rSUhHRWhqMWRjWk5tUE5wYWtpdmMwUGRURDdWRzJkOTlaY3Bkck1YV1F4?=
 =?utf-8?B?RlRQTlo5VWtQeWd2UGtTdS9OV1AraUdyZ2RQdFk2UVFpaEVXOTJDOVZMLzdM?=
 =?utf-8?B?TzFxdkR6UEpGYk5QOXhGdkNLNUlaY2ZBbVFHZTVyUDF5S3h3aGJUekVpZUR6?=
 =?utf-8?B?N0hDWXYxSFZBTXg2TE13cWRYM1RtSkFGWk5rMEdleXRQaVpJWTFpOGJwc0Y3?=
 =?utf-8?B?QitpUE80bEdyOGN6QlBIemlvODJzSW41VjdlNXlXZW1TMGVMQTkwbjJha0ZZ?=
 =?utf-8?B?aUx1aXJmS1FjWnVzZGRURHR4T0J2QmtINVlPUEhTOUZYRVhFK21hSHJTRDJa?=
 =?utf-8?B?MXdocFU4WWREZGhTTnI3WXVLWEJzS0FmdEdpTElRVng5YzArOUlBYk8zRldC?=
 =?utf-8?B?Q0lBcm9JTXZJN0lHclZpRnRpL3hwNHYwK21NbVluUWR6UVpWNGhKVmVYc3FS?=
 =?utf-8?B?cURHbENqUkx6TlE2NW5udHRtU0ZlQVNxU3hkMHQ0SmdLOUFHbm4vSWtQVGlS?=
 =?utf-8?B?aFhQRk9oakFZNGFvVklLMVlsaGhhM0F4UlplNHMrQnZmUHYvcldXaGZLNXQ4?=
 =?utf-8?B?YS8yc1dzMHlrQmZmR2ZOeUFsV0w0QmVHdFdKRTIrRnA5ZDFYUWt2L2dNK3dR?=
 =?utf-8?B?T0hlN3NqR2o2Wk5CYzRDY0h5MHBGTG9JYlpLYm5QUDhKcWtlSzEwclc4Q1Za?=
 =?utf-8?B?R0RlV0VsR1VhUTNsaFdpZ1c4eGZvNXBhZGphMTRWdkNRSEFoaXUvSGJXbkNO?=
 =?utf-8?B?cS9QSlErQUx5b0RUTmc4K2lKK0pMNVl2K3h6UG9mR1RIeGRHN2VpclMrSHhM?=
 =?utf-8?B?SlBES3ZSclgwZEsyL290UHprSmR5RGRpSTNEYVZhcE5uVmZaQkR1SlU3VUsz?=
 =?utf-8?B?cVFuYXVPMUZYUGNyNU9PcmtYYXRaYmtzNEpKRVNrVEd4VjFaZHpGSnJpN2lx?=
 =?utf-8?B?cDFRR2xjWnF2U0xWYkVQUTBVN0lUV09SWHlaRytJcDRkVVdVbEd5L3ViZXlU?=
 =?utf-8?B?elV4VDY0MGRKNnBwRDE1RmdWSTJLekdXaFU2bzdkOVowQlltaEhURndYbUZh?=
 =?utf-8?B?Vm1maXhzZ2wwd0N5RFE4VzFvRzJyT3lacVRhQUgxWStqQW5NZHIxTC92TTZ3?=
 =?utf-8?B?Y2xZRTBEYWNaa3JzWVRQNCtIZ2tIMzdjR05qMkdTb3F4bGxQVzNXWG96V1c5?=
 =?utf-8?B?NWsxb09XODlONzk1R092SDFyS3FrV2dseEtWTFJ6MHpNTGFCVUxvcXljOEZX?=
 =?utf-8?B?bGRaTVVyWUNSamNQeG1ubGNVQWZmcWsxNUMwRnIwOU04dTRFMElqNWJvN1dt?=
 =?utf-8?B?SkhlbHduRlBjbTVRUFNrM3pCdityaWd6QjFYT2tlZ21kb1BESytub2tSTUo5?=
 =?utf-8?B?Z1FzcEdycFhEdVRUS0xuOVZFQ2ovN1FHTjZtanBiMWdJNFZwREx2SXhmeTFm?=
 =?utf-8?B?Z3AzTURjc1h4K1FYMUw2a1pVWnlNYjBvRTlkdHZwcXpsekVObUVuZVMvbWJJ?=
 =?utf-8?B?OU9wNjhRZ3U3eG90WHllLzJmOFB5SU14MzRwTXZDRm1kUXI5VmRmOTJuc2RD?=
 =?utf-8?B?VmczUXpNS0xXSGpBRkttVGN1bG1yaktUM095MTYwZ1VySDZOVXMxY244TmE0?=
 =?utf-8?B?d0ZJYUJxUHVCdEMydHVGTlExc0JQdzU4N0hIT3JlUEYxQkZsWXhyNnJ3ajZJ?=
 =?utf-8?B?OWdYMGVVRXNneDVrajRueGhnRWVOUXF1ZkJqM0pnRmcvWVgrT2swZGc5WXRu?=
 =?utf-8?Q?EVRlTRZIvJ5XeYPFCzy3GMH22iCLUPn4Pkd7U5w?=
X-Forefront-Antispam-Report:
	CIP:58.252.5.68;CTRY:CN;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.oppo.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(376005)(82310400017)(36860700004)(1800799015)(7416005);DIR:OUT;SFP:1101;
X-OriginatorOrg: oppo.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Jun 2024 22:24:11.9108
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: a84f10c4-48e4-4a4f-4b3f-08dc8352ba95
X-MS-Exchange-CrossTenant-Id: f1905eb1-c353-41c5-9516-62b4a54b5ee6
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f1905eb1-c353-41c5-9516-62b4a54b5ee6;Ip=[58.252.5.68];Helo=[mail.oppo.com]
X-MS-Exchange-CrossTenant-AuthSource:
	HK3PEPF0000021B.apcprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TYZPR02MB5762

On 5/31/2024 8:51 AM, Zhaoyang Huang wrote:
> On Fri, May 31, 2024 at 4:12 AM Andrew Morton <akpm@linux-foundation.org> wrote:
>>
>>
>> The patch titled
>>      Subject: mm/vmalloc: fix vbq->free breakage
>> has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
>>      mm-vmalloc-fix-vbq-free-breakage.patch
>>
>> This patch will shortly appear at
>>      https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-vmalloc-fix-vbq-free-breakage.patch
>>
>> This patch will later appear in the mm-hotfixes-unstable branch at
>>     git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
>>
>> Before you just go and hit "reply", please:
>>    a) Consider who else should be cc'ed
>>    b) Prefer to cc a suitable mailing list as well
>>    c) Ideally: find the original patch on the mailing list and do a
>>       reply-to-all to that, adding suitable additional cc's
>>
>> *** Remember to use Documentation/process/submit-checklist.rst when testing your code ***
>>
>> The -mm tree is included into linux-next via the mm-everything
>> branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
>> and is updated there every 2-3 working days
>>
>> ------------------------------------------------------
>> From: "hailong.liu" <hailong.liu@oppo.com>
>> Subject: mm/vmalloc: fix vbq->free breakage
>> Date: Thu, 30 May 2024 17:31:08 +0800
>>
>> The function xa_for_each() in _vm_unmap_aliases() loops through all vbs.
>> However, since commit 062eacf57ad9 ("mm: vmalloc: remove a global
>> vmap_blocks xarray") the vb from xarray may not be on the corresponding
>> CPU vmap_block_queue.  Consequently, purge_fragmented_block() might use
>> the wrong vbq->lock to protect the free list, leading to vbq->free
>> breakage.
>>
>> Link: https://lkml.kernel.org/r/20240530093108.4512-1-hailong.liu@oppo.com
>> Fixes: fc1e0d980037 ("mm/vmalloc: prevent stale TLBs in fully utilized blocks")
>> Signed-off-by: Hailong.Liu <liuhailong@oppo.com>
>> Reported-by: Guangye Yang <guangye.yang@mediatek.com>
>> Cc: Barry Song <21cnbao@gmail.com>
>> Cc: Christoph Hellwig <hch@infradead.org>
>> Cc: Gao Xiang <xiang@kernel.org>
>> Cc: Guangye Yang <guangye.yang@mediatek.com>
>> Cc: liuhailong <liuhailong@oppo.com>
>> Cc: Lorenzo Stoakes <lstoakes@gmail.com>
>> Cc: Uladzislau Rezki (Sony) <urezki@gmail.com>
>> Cc: Zhaoyang Huang <zhaoyang.huang@unisoc.com>
>> Cc: <stable@vger.kernel.org>
>> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
>> ---
>>
>>  mm/vmalloc.c |    3 +--
>>  1 file changed, 1 insertion(+), 2 deletions(-)
>>
>> --- a/mm/vmalloc.c~mm-vmalloc-fix-vbq-free-breakage
>> +++ a/mm/vmalloc.c
>> @@ -2830,10 +2830,9 @@ static void _vm_unmap_aliases(unsigned l
>>         for_each_possible_cpu(cpu) {
>>                 struct vmap_block_queue *vbq = &per_cpu(vmap_block_queue, cpu);
>>                 struct vmap_block *vb;
>> -               unsigned long idx;
>>
>>                 rcu_read_lock();
>> -               xa_for_each(&vbq->vmap_blocks, idx, vb) {
>> +               list_for_each_entry_rcu(vb, &vbq->free, free_list) {
> No, this is wrong as the fully used vb's TLB will be kept since they
> are not on the vbq->free. I have sent Patchv2 out.
>>                         spin_lock(&vb->lock);
>>
>>                         /*
>> _
>>
>> Patches currently in -mm which might be from hailong.liu@oppo.com are
>>
>> mm-vmalloc-fix-vbq-free-breakage.patch
>>
>>
My bad, I should see the context why use xa_for_each.
https://lore.kernel.org/linux-mm/20230523140002.634591885@linutronix.de/

waiting for the Zhaoyang's patch. 

Brs,
Hailong.
