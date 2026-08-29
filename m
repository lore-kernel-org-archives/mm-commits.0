Received: from CY3PR05CU001.outbound.protection.outlook.com (mail-westcentralusazon11013001.outbound.protection.outlook.com [40.93.201.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5A16239E7F
	for <mm-commits@vger.kernel.org>; Sat, 29 Aug 2026 14:07:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.201.1
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788012455; cv=fail; b=WzAZ70qP071NmkuHMxRtvwOe6GKV/9lDI4LFfiZ1gMD6j2oq4kcjfl5f0e4RxDVbRdg/r53niJpkG1pzypyhlqJnIlwBKqDk59XXkLmINgynmRUKH0vQKAkElIqqbZI5Tw4nJ3n0EOSbxc0VdwzYPphQ6G3+07ulPyYVpYPUzH0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788012455; c=relaxed/simple;
	bh=TfHGmsDleUMUKWB/gznGha3vwkc9gNtCZ5aeNzkoqeg=;
	h=Content-Type:Date:Message-Id:To:From:Subject:References:
	 In-Reply-To:MIME-Version; b=oB3b6PeJupTQYW/wDsJvdmwt2OREpUiCHo2+9FYLOaGYNVgfNPRFFu1nQaWNSB/7GssSN+rMbfld60wt7etqrOkddGx0Fe5NdBOT1dJHkzO8klFZ439c6LrplLP3l08N/aF4pGrJ5S1vOYAC4U1kEsEDMP7fZhMKkxDAGH9xnsA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=Zv0sVSEs; arc=fail smtp.client-ip=40.93.201.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="Zv0sVSEs"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=BWe5dLr80JGMkDmHYywdnf/y+AtHKWGrGwCP/XzAC7DenC7a2K8i+u7bU2iWv8dKOZDb/M6WoJMav6W+0McsLgx4wVoFso44gT5jwhZH94Csfnaq8rNYxGVJvjRHxpRKbHbPNCAuDcC8LgP3iUOWc9/q53YppcthsOjUZ5tmrrs0oxUw8Nrk+cig7OCNcK9HROWQ/eBZIfyJZIfSQb72gKQKwgBfnvwR1DYJOB592tZEehyWlWF50MU2BrEPyV73kzMVutIKAs+3VPgYD6gecgBbYKP7P0OZMt6InXjFF6vN2qIlCerKVhkvVbU+RWdgThVurMUxJvf3BjVBWRPkTg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PeWt2/XoLhilJFHYhPQFXhKjVkAVxKo++si8ng6OYxE=;
 b=iFgLMhI/BO+h0WtrKOjQJrwkjBV2CeD886NpirPk58lnRI6Wt4VJolb9zlQT7NrGb0TTW91u0K/xxHIYOArfGT8XETswDy3MGnz1Joh5K6T6EwkbiiU9dyg76ReAUwso4eVaAhY88YjGUUpvKu+eTvz4p8NOyYlYII2M6ZIG25L/+TOGcT2DV37j36B5jMsD9WFCnd2HOIfJW4ndn1PDLMeRVdMoG5hZUlQo7kUJO6pTHDR6wtmUhaR/pBweXYqXvw4aKpvHmiewmfvM2zh1lfzdMIHvIS/Ri8mpgJ+VeJViIrBUQWVD6tJJ1snko6XSvjUJWowqIqZ1HfDfZyW3Dw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PeWt2/XoLhilJFHYhPQFXhKjVkAVxKo++si8ng6OYxE=;
 b=Zv0sVSEssWXyMbBp4yNf9EQt9KQvhG4pOHeqyW5+INImRnGpG3TA93ygkPMN7R/Gnj0YJJwb1G1uXhdelbRPJGkVGiwJbveiyM0RfLraCwi0C+Pm7AeHVhFLmRxoE1MENh/1ff3eWm/XTQAiGZoxyZs7KAlmgAoZWnfjJ6/4NhM/SDqAyUKWpI9Qb+7RVPc+V7IzQWrWI2VeFWF6OkTeUje/+MbmwP48iVswAP2ZI7kXRVKbfi5GvCshQDcbkFx9k1y20XeZDpldf8JLZ8Ht3haFKRg+AuHpXJWd8rycQawgDuc4hOY2FNz2k5Wm7+a3bvyHNdF63jsgnIfi3hPWJw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from IA0PR12MB8374.namprd12.prod.outlook.com (2603:10b6:208:40e::7)
 by SA3PR12MB9107.namprd12.prod.outlook.com (2603:10b6:806:381::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.360.12; Sat, 29 Aug
 2026 14:07:27 +0000
Received: from IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16]) by IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16%5]) with mapi id 15.21.0360.008; Sat, 29 Aug 2026
 14:07:26 +0000
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Sat, 29 Aug 2026 10:07:25 -0400
Message-Id: <DL1HIHWYJ7TB.1CY76SJS0V03L@nvidia.com>
To: "Andrew Morton" <akpm@linux-foundation.org>,
 <mm-commits@vger.kernel.org>, <saravanand@crusoe.ai>,
 <ryan.roberts@arm.com>, <peterx@redhat.com>, <ljs@kernel.org>,
 <liam@infradead.org>, <lance.yang@linux.dev>, <jgg@ziepe.ca>,
 <dev.jain@arm.com>, <david@kernel.org>, <clg@redhat.com>,
 <baolin.wang@linux.alibaba.com>, <baohua@kernel.org>
From: "Zi Yan" <ziy@nvidia.com>
Subject: Re: +
 mm-huge_memory-bypass-thp-tuneables-for-huge-pfnmap-mappings-fix.patch
 added to mm-hotfixes-unstable branch
X-Mailer: aerc 0.22.0
References: <20260828173805.4CDF11F000E9@smtp.kernel.org>
In-Reply-To: <20260828173805.4CDF11F000E9@smtp.kernel.org>
X-ClientProxiedBy: MN2PR16CA0059.namprd16.prod.outlook.com
 (2603:10b6:208:234::28) To IA0PR12MB8374.namprd12.prod.outlook.com
 (2603:10b6:208:40e::7)
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PR12MB8374:EE_|SA3PR12MB9107:EE_
X-MS-Office365-Filtering-Correlation-Id: 67bedce0-8fc4-413a-ffe5-08df05d6dafa
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|23010399003|7416014|376014|10067099003|11063799006|56012099006|22082099003|18002099003|921020;
X-Microsoft-Antispam-Message-Info:
	+qPnYJbry8qjn51CwNpOw+tw+a5XoNcG8EcWvbXuOZ0M0btYZmwMaArq2hH1L7wHzKK/X9idvju2X7H7LUgq1ZiGhWw5YmdsBFo8A3QLzTLPG6vxfjvxe9GDqYjxY2f4QB9+Sui5vnLTH2YCOppJWetf6uhT6MJxVNPdNf5bs7J04MxnsKrMSZT8Swg4XDKwVaQOKUz+87sNeyj+8Vi1xLbN6O6N8JZmtWRjp5/FHbOo6HfZ+rkEZ6z2pcxEi1CNtzghz43Xr5taCnspxt8N1Ahtc7gG+fSIWWi876o7ighGIlWDmAUQjxPET7k4SOUj1RvIbZoDhqwDYb8lt+uYnqfNmycvZDb3wK1ZOh9V8PPCnMEOHYsbJ2+2nM5LCpDt4LQB6cLD6teWYo0AimXoB+JlE/t86vRLd1nzjWoP6wphoekenOcHH52k33Ki2LSuCrWmQPDFgA8l9r0iAwjGXp3iF9UI1ak9uqkmS6gNXMwt7Csmvbt41N2GPPcadM5o+SGU+/DfwAFtdALP7PEaiVgcVYt+54JJmdKhqOUFABf3cLY02IqPr7ZKH6BRDZDb7vJw3BMjks1OBknn/T17LTWhNXp0w29N5YNHhEs9Rws/uUtv1OPIX31CAmOhleHoEIGK8VDU6TFztuOcWcxgzkJAIz6rq1ZCiA/p5d+cXuTsliiLsiKu+BVsVw2KfWcQ3LPpYoLVddJt8+EVjgGFjw==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PR12MB8374.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(23010399003)(7416014)(376014)(10067099003)(11063799006)(56012099006)(22082099003)(18002099003)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?YTVacnIrTXBwS2p1NC9iN0lzN2txQjRTaVN4c3BWNXFjWEx4aFg1MHBrQnlr?=
 =?utf-8?B?WnFlaXJwdkRlUjJFUnVYdFNISzg5U3lDaThQQS8yYkFiTmtmbzJxd3haQlJi?=
 =?utf-8?B?RHVYVlBnUHJ4dTAxNVhlcUl3L0NlR3V4QzF2ZVRVSXBFQWtGSmdCS1RSb3gw?=
 =?utf-8?B?bnI4TzhLT2JFa3Q5MmRCWGlLUnk3MTJGSmtHSHJGdG8xbS9zOFpmcnFyQW1E?=
 =?utf-8?B?V2s3VHNaaUZHQXVhb1lGdWhsWWlUcnNJaWNtbjdRcytmMk13NUpsVEFpQmZk?=
 =?utf-8?B?R0lIdlgvSDVpM2hsN0tTZmg3eEJnRjJVVVVqOTZSVkV6L2hqTGNhb3pwRldS?=
 =?utf-8?B?d3VnUTA2eFVDQ0JhVktXNHlBQlRNQnZaMlJUWVFUTW1sTTBFcGUvZmhwVXQv?=
 =?utf-8?B?bHdyd0pldXNxL0lma1FFcjI1R1BRbVFlemIwc09VNWhiRG83aGFFZFZmelRB?=
 =?utf-8?B?OVk0V0xNNnZtRFZOU0JPeVdPckVzZGhpZ0lqZXU1YVIvdGNQemZVV0F5VEVB?=
 =?utf-8?B?UHdGQ2wwR1pxdEIvME5ZMElmWFpzMFBxRXp5dHZFUThtWEZ1cGdhWW5MWU5T?=
 =?utf-8?B?NmlHM0dHRVkvR2NTcTR5NnJ4cFd5T04vNmswUGpxSFl6WU1BMENzNjd3MlZo?=
 =?utf-8?B?WUl5RnZGMkowWjU5c3MyV1Z6Z1RkTnNvSVFRK1F6OTNFa2RmSVNETGFmRlVw?=
 =?utf-8?B?dy9yeVM2SU02WStSODNpT29GRmI3dU9zYW00cEpUb2RmaHdaN2p3ck1GSnFx?=
 =?utf-8?B?R3FBbHQ5QkwvbUw5UVFHT2t0aXlsV25meUFjOStCTVdhMThpZlZ3WXpQRmZ4?=
 =?utf-8?B?bW9NbXFIQWRYVXRJcUZPKys1WGNLenlXV0Y2YkVRMUwrZ28wWk1GYmthSHRP?=
 =?utf-8?B?VnBtMGpmM0ttQUsranhRbEwyVHQ3SHREczc5bkpvY1lWOFFveDRqN0FWR09M?=
 =?utf-8?B?TVY2WTdwSUczcStoVHVFK29JakJOK3FIUHZ3NjBKanZ5UVNST1R5Z1hhMzdQ?=
 =?utf-8?B?RHo3Yi85TGUyTlJQd0dDUGQ1U0ZKMjFVRWFlbnlhMmltODk2ZHJzQjlYRTFQ?=
 =?utf-8?B?ZkdhdFN3ZTJ3SWxXdUhta2h0S0VyRERUTDJQc3Z2N1dyejd3N29TZjBMQ2FV?=
 =?utf-8?B?VFE3UFBCRUtaNFh1WTR5QW5ITHAwTVV0NEM4QitPbTlhWHhFTjBKU2wvTTFQ?=
 =?utf-8?B?QWYvNmRWM0lQcGdHVytRTTVxbnpwcUxNV29ZVCtmQkVpSGNXOWZhSFBvdElV?=
 =?utf-8?B?M1pjZEhlSmNOTEJsdUl6MHVBOXo3K0ZUVnFibVVMR3lGbUJBUjlyeW1MTWEx?=
 =?utf-8?B?VHo5LzNTQU11ZGo3djNFL3kvMEhsUWxUL21LRU56R2liOVBLN2hSMTVFcFRq?=
 =?utf-8?B?NHNiTDhDOEtXVFd1QS9jREt1eUhnOE1wTW9ZK2ZlR3JoUGVsajlBM2p2TmRF?=
 =?utf-8?B?QUExcFlwUmFIK2gwS1JHSFdyZm0weXhsa3VPaklrVXJSYklWa2RUczEvSXky?=
 =?utf-8?B?NTQzcjNQcmJibGRvU1ZGUU9YemI3RkJWaEQzb0lkSWJnb1MxL0loREJ5UWFm?=
 =?utf-8?B?d1lVeUpGdXQwK1Rqclpub014RmIvdjNFbFdqbk5qaGhGTEZ3WGRZK0JFeUpx?=
 =?utf-8?B?OTFvRnBaT0xCcFlERFJabVZpaVoybXdaWTM1UGJmYnEybUEwNWhhVy9ZSytE?=
 =?utf-8?B?WFB1ZjFJTUk5c1h5YlVLYzdKRURPUnBpMVExbVZOcU0ra0VlRmcwZjZ1YUxC?=
 =?utf-8?B?YUV5TDlQL3BGd01rOFY4em5CZW9TNkhKbitabXIwcnZiWDB1UGdURUVWUG92?=
 =?utf-8?B?ei9XZ2pJaGxtR3BYL1B3QTlWR0NBcXI3V0R3ZE1rcDg4elVQOXE4RmFSNkNl?=
 =?utf-8?B?c1RkM0NBeW9teXJxaERTekx2Szl1Ly9lekUxMGlsL1BKNzRaQ05sZXFRU3NV?=
 =?utf-8?B?WkNUTXN1ZHRIQklkUWQwZHlpV0NHSGlYdjl1enVGSERxckgzdG83dko4L1E1?=
 =?utf-8?B?bU8wdkZRNDRMaWV4eERJZk9LVkszTHBZaU5CbHBkMUhlb0FUYVBnci83a1Jj?=
 =?utf-8?B?aVYrQVUzYndmSkZoNTJyemF0ZFdXS2dEcFhxeEY4bEczQVg0bWlCMjNoYVBw?=
 =?utf-8?B?UFg1dWRrcTZBK25QL3piYWVJY044NHFQRlJMUmsweHpRYWNaYS9SMnphTG0r?=
 =?utf-8?B?VHJZbG9CWDZsTTVncm8yVFZZTGFoRVRvRjJVTXdwT1RDdXVHUWd1YU5raFEr?=
 =?utf-8?B?M1JVOUs4ZDNnUW50TEg2aUFhQnF6VVdxUXRNaWFNbGpCSmFFcjliYXdqWWV2?=
 =?utf-8?Q?dzy/oxwn9qJbcsnr3V?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 67bedce0-8fc4-413a-ffe5-08df05d6dafa
X-MS-Exchange-CrossTenant-AuthSource: IA0PR12MB8374.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Aug 2026 14:07:26.6485
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: PC19M7iXLyDY3+0jYfC94EyXKpTGeNSQOcm+VcW/5DDxEJkFAj79uL/lg+u9XmKV
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA3PR12MB9107

On Fri Aug 28, 2026 at 1:38 PM EDT, Andrew Morton wrote:
>
> The patch titled
>      Subject: mm-huge_memory-bypass-thp-tuneables-for-huge-pfnmap-mapping=
s-fix
> has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
>      mm-huge_memory-bypass-thp-tuneables-for-huge-pfnmap-mappings-fix.pat=
ch
>
> This patch will shortly appear at
>      https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree=
/patches/mm-huge_memory-bypass-thp-tuneables-for-huge-pfnmap-mappings-fix.p=
atch
>
> This patch will later appear in the mm-hotfixes-unstable branch at
>     git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
>
> Before you just go and hit "reply", please:
>    a) Consider who else should be cc'ed
>    b) Prefer to cc a suitable mailing list as well
>    c) Ideally: find the original patch on the mailing list and do a
>       reply-to-all to that, adding suitable additional cc's
>
> *** Remember to use Documentation/process/submit-checklist.rst when testi=
ng your code ***
>
> The -mm tree is included into linux-next via various
> branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
> and is updated there most days
>
Hi Andrew,

The patch below is what I suggested. Lorenzo, could you let me know if
you are OK with it. Thanks.

From 94d78f3d6ba2c1acb841535f934eeef4053c531c Mon Sep 17 00:00:00 2001
From: Zi Yan <ziy@nvidia.com>
Date: Sat, 29 Aug 2026 10:02:02 -0400
Subject: [PATCH] renames for Lorenzo's
 mm-huge_memory-bypass-thp-tuneables-for-huge-pfnmap-mappings patch

Signed-off-by: Zi Yan <ziy@nvidia.com>
---
 mm/huge_memory.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 4bf7b670586df..1e5d68acf62a5 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -118,7 +118,7 @@ static bool vma_is_special_huge(const struct vm_area_st=
ruct *vma)
 	return vma_test_any(vma, VMA_PFNMAP_BIT, VMA_MIXEDMAP_BIT);
 }
=20
-static bool vma_bypass_thp_tuneables_file(const struct vm_area_struct *vma=
,
+static bool vma_file_bypass_thp_tuneables(const struct vm_area_struct *vma=
,
 		enum tva_type type)
 {
 	const bool has_huge_fault =3D vma->vm_ops->huge_fault;
@@ -132,7 +132,7 @@ static bool vma_bypass_thp_tuneables_file(const struct =
vm_area_struct *vma,
 	return false;
 }
=20
-static bool vma_thp_tuneables_allow_file(vm_flags_t vm_flags)
+static bool vma_file_allow_thp_tuneables(vm_flags_t vm_flags)
 {
 	/* THP=3Dalways? */
 	if (hugepage_global_always())
@@ -143,11 +143,11 @@ static bool vma_thp_tuneables_allow_file(vm_flags_t v=
m_flags)
 	return false;
 }
=20
-static bool vma_check_thp_tuneables_file(const struct vm_area_struct *vma,
+static bool vma_file_check_thp_tuneables(const struct vm_area_struct *vma,
 		vm_flags_t vm_flags, enum tva_type type)
 {
-	return vma_bypass_thp_tuneables_file(vma, type) ||
-		vma_thp_tuneables_allow_file(vm_flags);
+	return vma_file_bypass_thp_tuneables(vma, type) ||
+		vma_file_allow_thp_tuneables(vm_flags);
 }
=20
 static bool vma_can_map_huge_file(const struct vm_area_struct *vma,
@@ -159,7 +159,7 @@ static bool vma_can_map_huge_file(const struct vm_area_=
struct *vma,
 	 * Enforce THP collapse requirements as necessary. Anonymous vmas
 	 * were already handled in thp_vma_allowable_orders().
 	 */
-	if (!vma_check_thp_tuneables_file(vma, vm_flags, type))
+	if (!vma_file_check_thp_tuneables(vma, vm_flags, type))
 		return false;
=20
 	switch (type) {
--=20
2.53.0


> ------------------------------------------------------
> From: Andrew Morton <akpm@linux-foundation.org>
> Subject: mm-huge_memory-bypass-thp-tuneables-for-huge-pfnmap-mappings-fix
> Date: Fri Aug 28 10:35:55 AM PDT 2026
>
> s/vma_check_thp_tuneables_file/vma_file_check_thp_tuneables/, per Zi Yan
>
> Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
> Cc: Barry Song <baohua@kernel.org>
> Cc: Cedric Le Goater <clg@redhat.com>
> Cc: David Hildenbrand <david@kernel.org>
> Cc: Dev Jain <dev.jain@arm.com>
> Cc: Jason Gunthorpe <jgg@ziepe.ca>
> Cc: Lance Yang <lance.yang@linux.dev>
> Cc: Liam R. Howlett <liam@infradead.org>
> Cc: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
> Cc: Peter Xu <peterx@redhat.com>
> Cc: Ryan Roberts <ryan.roberts@arm.com>
> Cc: Saravanan D <saravanand@crusoe.ai>
> Cc: Zi Yan <ziy@nvidia.com>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> ---
>
>  mm/huge_memory.c |    4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>
> --- a/mm/huge_memory.c~mm-huge_memory-bypass-thp-tuneables-for-huge-pfnma=
p-mappings-fix
> +++ a/mm/huge_memory.c
> @@ -143,7 +143,7 @@ static bool vma_thp_tuneables_allow_file
>  	return false;
>  }
> =20
> -static bool vma_check_thp_tuneables_file(const struct vm_area_struct *vm=
a,
> +static bool vma_file_check_thp_tuneables(const struct vm_area_struct *vm=
a,
>  		vm_flags_t vm_flags, enum tva_type type)
>  {
>  	return vma_bypass_thp_tuneables_file(vma, type) ||
> @@ -159,7 +159,7 @@ static bool vma_can_map_huge_file(const
>  	 * Enforce THP collapse requirements as necessary. Anonymous vmas
>  	 * were already handled in thp_vma_allowable_orders().
>  	 */
> -	if (!vma_check_thp_tuneables_file(vma, vm_flags, type))
> +	if (!vma_file_check_thp_tuneables(vma, vm_flags, type))
>  		return false;
> =20
>  	switch (type) {
> _
>
> Patches currently in -mm which might be from akpm@linux-foundation.org ar=
e
>
> mm-huge_memory-bypass-thp-tuneables-for-huge-pfnmap-mappings-fix.patch
> drivers-media-v4l2-core-v4l2-vp9c-reduce-inlining.patch




--=20
Best Regards,
Yan, Zi

