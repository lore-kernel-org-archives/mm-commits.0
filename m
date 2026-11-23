Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.48.49
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795413144;
	b=e6BiZtjQGDceXsGhQXqCpe2OYA9sVi1Jx+1wvn9yvlUJMPfvNwkoItcCOhv38bp/UCKj
	 67MGpojcpyFMzYEtdn9G9RWV5VGzpr1eyQbrM1hWY1MG6K0i94cCvxW48dJAb72ClGUvJ
	 JQNtVS1YWTQrxBgYrwgxTrUfCGuUCd3BzobrczuD7fGfw/Rci5WvV+A6jVMyAWKjQA7YZ
	 RzZQpnQ/FaQ90cm8/vO7kM6VPuvpaMNhEulsUrxvT5dtdhdhm/GYy1r/OKT5cM8Or4UHB
	 9kJM9NXXOg7xaHIQmtgHEiiXFiggUtfB9fuNFwMsBndTwkyBIAnPKK18G/dzsJnwzSg==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795413144;
	h=DMARC-Filter:DKIM-Signature:Received:Received:Date:From:To:Cc:
	 Subject:Message-ID:References:Content-Type:Content-Disposition:
	 In-Reply-To:X-ClientProxiedBy:MIME-Version:X-MS-PublicTrafficType:
	 X-MS-TrafficTypeDiagnostic:X-MS-Office365-Filtering-Correlation-Id:
	 X-MS-Exchange-SenderADCheck:X-MS-Exchange-AntiSpam-Relay:
	 X-Microsoft-Antispam:X-Microsoft-Antispam-Message-Info:
	 X-Forefront-Antispam-Report:
	 X-MS-Exchange-AntiSpam-MessageData-ChunkCount:
	 X-MS-Exchange-AntiSpam-MessageData-0:
	 X-MS-Exchange-AntiSpam-MessageData-1:X-OriginatorOrg:
	 X-MS-Exchange-CrossTenant-Network-Message-Id:
	 X-MS-Exchange-CrossTenant-AuthSource:X-MS-Exchange-CrossTenant-AuthAs:
	 X-MS-Exchange-CrossTenant-OriginalArrivalTime:
	 X-MS-Exchange-CrossTenant-FromEntityHeader:
	 X-MS-Exchange-CrossTenant-Id:X-MS-Exchange-CrossTenant-MailboxType:
	 X-MS-Exchange-CrossTenant-UserPrincipalName:
	 X-MS-Exchange-Transport-CrossTenantHeadersStamped;
	bh=MrqRTHNK2gC+Cpux2diFWuleGl1Gko1WQhJIOUlu2bY=;
	b=yc52u2ZYXq87g5hNZ5k2VPq7Rv9wFdVQwepS089EGnWP3HjobDVDA+D4l9tGViXRL9kz
	 GlLsLre2XthsE8m88qPUUz5lOuTQaFlkVbJbvVPTKJ3HEADbwNoCFpQpjZbug4drScB0p
	 OLBDT1iDU/aeTQjHpmkI7GJWI17nwo1sPLpl54GXdJqg8NV1H0MhbgQk5kW9uP0itAu7A
	 RdEJjk+lUiyqE0iLo39tk/zC4rPomwivjJeS4QGS3I/D4rXj8/zNhE2EuQP2FGYNAKB2l
	 NpzyZjrPqoZgVTGq/1UUtTTTxuXpkVvjFu2aTMRxuXLezS6owcug7d6YG9r7Z02TsYg==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=ubRqVjdo;
	arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.48.49
Received: from MW6PR02CU001.outbound.protection.outlook.com (mail-westus2azon11012049.outbound.protection.outlook.com [52.101.48.49])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2144606A32E;
	Mon, 23 Nov 2026 05:52:23 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org F2144606A32E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=ubRqVjdo
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=T1n2fGlgOtQsEszQrmh9cUR+98GLJnj71Ub3DJiThqAi7Pgh3q6SOtRgzgycJFGtJz0J0xvA6m6iYj6bQW9827z/oYbVMCXSPUjUju68sa1UeohjUoxwnqeHxMzG3dhVsz2CvpEDZyboY3RBDbcFQKPwgYrr9EZ7zIrZz3/5/r8xb371kZtSi02yqkxGbuA8o5DhimW3Xzkgjh5ALSKxAjRbdnwMPa2LWCcjq0ILAYc2SIPp1/bwaKHGUTYLZDwTBa1lp9AsSrkjU9MOZvBVIjBhf6hQqr/llUQ9m+DyXgVFhpjTSr62i56++xg0PKDsZxyNlQhB+/Y3ffvm4/TvAQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=MrqRTHNK2gC+Cpux2diFWuleGl1Gko1WQhJIOUlu2bY=;
 b=j2B3dQIMNlL/wdiD6jwSTAfmC1b52Fi/+EUlgvM4Hv8ZrIB/N1xsIc2R/PiBaUOSCKJPsg+ad3m9Y668n/WBhSmHVyDrztKMk524tT6GIAmeP0JwZapItyXUDKOJYQ9iI/CmJ8VEGI+pi9V45t5ZuD/ERM+WZ4yQFWyLor5BeW5dZwyqFSMpngiOur5u+t3sxeqLjUvEr3YFskm4oTql0QwwQK18pcQDw8WhrgKuUEn3Kv0t6KlKqDxHIyweX+FrxkQckszVu0Tc9RM6EbIwCikhuWhOrYbm9NfxbIIm0IVDCOOVXpvuvwZ7d3DDtxx1nQBNDAovvGbZcBeYGqHCDA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MrqRTHNK2gC+Cpux2diFWuleGl1Gko1WQhJIOUlu2bY=;
 b=ubRqVjdoo3J9fTuGm5zosNiKdgTkhWzxGnKoqcq58NfJNuri82M9ViUGt97NvIMdBswIeTCzHTefbZzvzNiYxAsQwIZB7YrZDZTvgagbvc+Z0gLR7nDO1keVZio0YAYxkxIP6oLBJi111wW/7PC38FqsWH31HFQmRMx5aQyu3w+FVWPMZjkLUnt4kgZj83/CDxCnSJawJ8qroozpSwO+MLMB1P8Ey4l9JYos8hqrwdrkoCTak2Gs3j1uWoA5eWb8/3hnUyzV3O7C7e6r+9AAXRsgXnfMUB6AVgsxTlZi0+3vpDqtpCsZq16TxTwGfBcCoJS4vg/2CU96gxexAKwJ3w==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH3PR12MB9730.namprd12.prod.outlook.com (2603:10b6:610:253::9)
 by DS7PR12MB6238.namprd12.prod.outlook.com (2603:10b6:8:96::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.639.13; Mon, 23 Nov
 2026 05:52:16 +0000
Received: from CH3PR12MB9730.namprd12.prod.outlook.com
 ([fe80::843d:c1f0:b2ed:4128]) by CH3PR12MB9730.namprd12.prod.outlook.com
 ([fe80::843d:c1f0:b2ed:4128%4]) with mapi id 15.21.0639.012; Mon, 23 Nov 2026
 05:52:15 +0000
Date: Mon, 23 Nov 2026 16:52:10 +1100
From: Balbir Singh <balbirs@nvidia.com>
To: Aveline Noir <jm5905938@gmail.com>
Cc: jgg@nvidia.com, leonro@nvidia.com, akpm@linux-foundation.org, 
	airlied@gmail.com, apopple@nvidia.com, christian.koenig@amd.com, 
	dri-devel@lists.freedesktop.org, Francois Dugast <francois.dugast@intel.com>, 
	intel-xe@lists.freedesktop.org, jgg@ziepe.ca, leon@kernel.org, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
	Matthew Brost <matthew.brost@intel.com>, mm-commits@vger.kernel.org, mpenttil@redhat.com, 
	Patchwork <patchwork@emeril.freedesktop.org>, SeongJae Park <sj@kernel.org>, thomas.hellstrom@linux.intel.com, 
	Vlastimil Babka <vbabka@suse.cz>, ziy@nvidia.com
Subject: Re: [PATCH] mm/hmm: account for subpage offsets in device-private
 PMDs
Message-ID: <awObsp2ugvQZ1JQV@parvat>
References: <179342234355.4.16705453209886955762@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <179342234355.4.16705453209886955762@gmail.com>
X-ClientProxiedBy: MEVP282CA0075.AUSP282.PROD.OUTLOOK.COM
 (2603:10c6:220:202::15) To CH3PR12MB9730.namprd12.prod.outlook.com
 (2603:10b6:610:253::9)
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB9730:EE_|DS7PR12MB6238:EE_
X-MS-Office365-Filtering-Correlation-Id: de5e7853-6e43-4473-a3af-08df4925ed60
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|7416014|376014|10070799003|1800799024|23010399003|6133799003|22082099003|18002099003|11063799006|56012099006|261028144727099003|261026121527099003|261026140227099003|261102123227099003|261022075727099003|261022105027099003|261021123027099003|261021121427099003|261009223027099003|10067099003;
X-Microsoft-Antispam-Message-Info:
	QpiQoDrXu5FqpZCcFbs71ZJDka7HDyCHkU/2wVusAIG45zHOdR6nNYRsThgpBjRQjED1DgiR6jo4Sqw9LEFh06v/GR5tCtKjRhZL2K0mQ7f93ER4hvMhZe1ffsf1ahVw7x2YQmfZbLT8SSqA9v3X/ys9DaUhcWs0EhA9/BZKMmLdEm8S71IAIlP+QO52uf9HFah4fma1BMxH3TYDu28TSGi03ozeKorMu5nsI+RiLqsEY0MznUnuMd9kVNfIZbi/l0UXstBTK3dlcWWO29C4JmXZLUlGF1JXi0u4RknnzVaawb7AkSkyYdIQ99xuAprRm1SLrkqTfz6D98ma/WZCyKste1kGYG4KFClOjBmrZerEhucv0GIiFhb0fQGi4qwcKIyIgOe/1i/npmqJIDmigWxODZnk/WFZlVJ91sUuRLYSq3RPJo8uqDaaJkIBxyGvtpNPTvKzkTW7qBYm6hNycBkUvmm+GnSLAuUjeYrB02zRCDFdqXjxDX14Igntq+ZpuRYxqFflGjvImSw4tNOGMmmZ+8ROC3teXSQBbpN8FhU7vt6lm9k65Bjx1qbsSgrE7L7ZzlwyIZFXOebT+tMdo1m7K7dS7yNup+DAO9N085RI75eQ83KR+WtlHAZlwWYYzj0weB2pGzaZGIvvtjjhaaXMZ/I7Yj/5wZhlwUsY9AY=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB9730.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(376014)(10070799003)(1800799024)(23010399003)(6133799003)(22082099003)(18002099003)(11063799006)(56012099006)(261028144727099003)(261026121527099003)(261026140227099003)(261102123227099003)(261022075727099003)(261022105027099003)(261021123027099003)(261021121427099003)(261009223027099003)(10067099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?aWc0UWJWMjltT016SDVxT1dVQlpZMFJxVHZQQndtU0NqckJreUNMeUFQK0FD?=
 =?utf-8?B?bHh2Mzd4RWFVUDVFQ0N1R3NUTDl5bzNBbkc3TkhDSHBKS1l1aWZpbDBuaEt5?=
 =?utf-8?B?bVZkR0JzQWJuMm5WVlVFdmZhSDFScDBod25OK2gwUEJXNzJoa2wrb2hWVWlB?=
 =?utf-8?B?MHJ6UUhyK2czd1NOVlBKM2Jobjh1UE0rV3JxTUFpekEwRWxjbis2OGlaWTE4?=
 =?utf-8?B?SllJeUJpNkdVS1RPWnltTXdHV0pOVmJ1RmxlZlRFQTF2ODZKRHV2YVNyMEty?=
 =?utf-8?B?N3VCdmRINDFpOXVKcnZFdlQ3bXk2eU9QMENrMk42K0pWaEJ3ekd4amxndDRL?=
 =?utf-8?B?T0NkMFRuVUlxL1JsblNoeHJUVkxFOEg4ZFdMU1FCRzJOalFHMjR0clpXMnZh?=
 =?utf-8?B?QVpHTjY0OEUvMEY1Rkg4bzl0OERrVFZJRTFyaDNDNmlLUU1BK0ZmT3FlMENj?=
 =?utf-8?B?QnVTMkpRQzlNbFhuQ1laaG5aVHpMeWJNbkRWR2hzK0dQSEtBN1ZQWk90MUlW?=
 =?utf-8?B?NS9xN1ZuQytYOEVkYWpoSnR0MmU5eXZnVVVwRVF3OFoybUN3THRzT29RdUtu?=
 =?utf-8?B?N1JpWTJhd1Rtc2hZUkRTb0NFZXVaQ21DcXNqK0JTVDNWVERFdzFnTTNDUXM3?=
 =?utf-8?B?Ly9ZUEFEcmlyVXFJRjZPS2kvUVljcUZUT3ArL1AyOFVhSlNzRUhuVk1Yamo0?=
 =?utf-8?B?T0lrcG54c2dORCtoTzNiSG9FMjNHV3NtOVd5cU1oQjkzQ0NDTmdnK0RQVkt2?=
 =?utf-8?B?RFhtSWs0Y3kyTmFaUHA4UVVqN2JKaHlETVhFRzRNWWovZmp2b0tDNFkvSjVP?=
 =?utf-8?B?VmxmK0tDV0lOVVhBdW16eW5JcHNjNnBlUjlBdjg2NkJpaU5rbzZXZ2d0Rm9i?=
 =?utf-8?B?c2sxNGJ6V2NkSE5xUTJuZTNUK3V0emFVQzd2L1o1b3A5Z3BaK3ZmcjZOdktW?=
 =?utf-8?B?bU4xZGZXMXo3bWh6V0FHbmVXbkxJVjJtRmRTVlhGRm9UbmZ1UGg1dUlLOG1T?=
 =?utf-8?B?cmRicmtlWTRURVVQVHlQc0NNNkU3SWdhRnVadHRvUzhmSzJuQkNRUEZJWC9I?=
 =?utf-8?B?Ykt1bWlXV1l0YmNEenhFaXpJZ2FEUE5KZ3MyZU8vaFZFS3h1UVgya3VQejBW?=
 =?utf-8?B?cEFrekJvTFdxaDlWNTBacjVsVkZOSEhSUWpSM3dOdnRlaEo3enhWWEt2akRx?=
 =?utf-8?B?UldqUFZNYlJsOTI1SGdlQUJqT0d5YmJPRGozalVhQ3hpNlRqd0trNEhPb0Fl?=
 =?utf-8?B?ODlqUm1DVjQzYTJuazJ1T2MyTmpCR1dBM2ROMmllQzdWTmZOU2s1Q0hYWnBw?=
 =?utf-8?B?dk5NWTFhWmxoR0grU0RVd2ljVyt4UG0xV2xhaGdXekVXL09qWGt1ZnBYQUxH?=
 =?utf-8?B?Q055cFhRV043NWx6SFJ6MTVpMVlZV2hCTHpmd0prNVh5cERlS01QaGg4c2c4?=
 =?utf-8?B?cE05Y0Fxc3JXUlFCdHBjcC9KT2VWdUVuK2dOSGhnVEVhMGV1Z24yUVJvR25H?=
 =?utf-8?B?b20yK2VSSGsxeDVXcmR0UGpvbURpV3l4REVpVDZndkxBbU5vL2t2WENWSGtV?=
 =?utf-8?B?WEpZRWUxLzNTMGljMU5vaG5sMFdHR2ZmeDlPZjdjRnlWd0NuTVYxbVRKQ3Rq?=
 =?utf-8?B?VHppSUZsd3JocG1BUWs1TkczdUQreEhNTjhkNDVONGllL2VSMnFlbVJ3OVZz?=
 =?utf-8?B?TVk5b3Yxcy82SjEzZkZtYkFkS0JMbXlaamVaclQvQ3Z5WTRScEJoMkw5Mk1m?=
 =?utf-8?B?dnlINmUrR3gwMEE3bHZkbC9MRm4vQmxHeGkzK3hqZiszdnk1U0ZleFdwRE9W?=
 =?utf-8?B?RUVtZ2xVdWdoUTd0N2E1K2hrekFlZm9CNHVhc3pnTytjMThySXJZQUVIWlJv?=
 =?utf-8?B?YnQ1anNuTFZxc1dtTXZheUtyb09rNlRwYWxqY01UNnBOeEwrU0llL3VYRFl2?=
 =?utf-8?B?RFFQYlNCMTF0ZFRLQWJNL3cvQlBvL0FrNHZIK1VsZWNyaWZTbHNENXpwYm00?=
 =?utf-8?B?TGFTREhWbUVHMnp3dFZtNUNPQnBYa0VyNUVqaHZqY1BORUdnNVZ1M0dvQ2c2?=
 =?utf-8?B?am1DMXRQZ3I3bTNWMUZsb3ZwUU9taWl0UjYycVRLRjlMVTJXMHlzeGxMK05v?=
 =?utf-8?B?Y1Nxcy9SMU5CTDJ2elRONHVYU1oyL29PNVluZHRIR1Z0dVBFRXR6UkxmeTRM?=
 =?utf-8?B?YjZqYW5MeDBNMFpEOWtxRXI2UGVrYjNVUG9SbUM0M1o5MGhKaWJYQ1BWVExL?=
 =?utf-8?B?YjhrSVc0N0crS0t3cG14OEJ6dnhycis2Yk9BZlRrQWI5eGlxdFQ5dmFuZFBv?=
 =?utf-8?B?UDhkaUsvVjFwMitNeUR1KzZGMEdzQUxuelFqWTFIWWdVbnhMREhIeGV2aHNQ?=
 =?utf-8?Q?k0DAw4G0agMfotAtUBfComQfgo6lWj+84VQcBy09yD/lE?=
X-MS-Exchange-AntiSpam-MessageData-1: bMurxbR3w5vFpA==
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: de5e7853-6e43-4473-a3af-08df4925ed60
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB9730.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Nov 2026 05:52:15.8116
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Ovv1snhNfZJW7St6ni4xDtp/QbG3dmr7PBr+l/zQTvW7lNc04U3hcnf6FcyWVhccXJ2D+5gNQbZQoJCBi+4rsA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR12MB6238

On Sat, Oct 31, 2026 at 03:07:58PM +1100, Aveline Noir wrote:
> When a query starts inside a device-private PMD owned by
> range->dev_private_owner, hmm_vma_handle_absent_pmd() still fills the PFN
> array from the folio's first page. The returned PFNs therefore refer to
> earlier pages rather than the requested subrange.
> 
> Add the query's PMD-relative page offset to the initial PFN, as the
> present PMD path already does.
> 
> Fixes: 10b9feee2d0d ("mm/hmm: populate PFNs from PMD swap entry")
> Signed-off-by: Aveline Noir <jm5905938@gmail.com>
> 
> ---
> Found during a synthetic test_hmm check of device-private THP handling.
> Tested PMD-aligned and non-aligned subranges, PMD boundaries, split
> PTEs and fake-device data accesses with test_hmm in QEMU TCG; all
> executed tests passed with the fix. No real GPU testing was performed.
> ---
>  mm/hmm.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/mm/hmm.c b/mm/hmm.c
> index 2f1e98c6b644..e89f140d3e5c 100644
> --- a/mm/hmm.c
> +++ b/mm/hmm.c
> @@ -355,7 +355,8 @@ static int hmm_vma_handle_absent_pmd(struct mm_walk *walk, unsigned long start,
>  	    range->dev_private_owner) {
>  		unsigned long cpu_flags = HMM_PFN_VALID |
>  			hmm_pfn_flags_order(PMD_SHIFT - PAGE_SHIFT);
> -		unsigned long pfn = softleaf_to_pfn(entry);
> +		unsigned long pfn = softleaf_to_pfn(entry) +
> +			((start & ~PMD_MASK) >> PAGE_SHIFT);
>  		unsigned long i;
>  
>  		if (softleaf_is_device_private_write(entry))
>

Looks good to me!

Reviewed-by: Balbir Singh <balbirs@nvidia.com>

