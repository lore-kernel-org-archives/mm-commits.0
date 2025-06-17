Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2075.outbound.protection.outlook.com [40.107.93.75])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C91357483
	for <mm-commits@vger.kernel.org>; Tue, 17 Jun 2025 01:35:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.93.75
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750124102; cv=fail; b=n/5dMakB2nCovFklZq7uBDlG3PEtD9sFarL4EH7PQsBJH5R8KCBfaMVxlspb835D5s3WKrjrfbOl46laY+bBv57tMAl3mnVosglQRevp0LX/GDpr3kbrq/gBdezoOZCf1Sr3h2hYN85YDuA0Gm1sAjIm8Kbj1Zb7KLB398y6MF4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750124102; c=relaxed/simple;
	bh=NfjDiYbgvDpdmxLh0POZiQL/q7EJ9qNmLJ7UnFM0udE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=uXcIw4woQuzy54iSuHeiTNZX7CrkJwRSSY8AwikwqyDJStPxoYmO3hWyPjpDPdrEJdJyAVkHM4giTYCPp1H9J6Vt1eEprd1egf8Tdz5jC3fs27I17em7kyu4a382bTPKv98IXwyx1nmQ6CS6Y8hqGZy7+Q0aKVXLabESG2gzl2o=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=bLV+NQCu; arc=fail smtp.client-ip=40.107.93.75
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="bLV+NQCu"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=FzbX01wVnaJGZXvaUl4BOWQ520tMQicpL/GHs0oYiuPYVClPpMLU32P9BhhXgE0Te/5p7/jvX1PQICfAK2+dXI8YIAIykxIms/ZMZX9rSbog7UaX437HcZf+odI0CFTNFFMg3wcL5oSvt/kDkLyOh9q2o0J98YPe87hwigJ7Gs4zMdBygm4cy6EwvzSqmZFuyfmlefEZ3gXJ9ArHHnXiNOolUPHy2XT0mk5wR4n3+4ClIoV/95Ar888ct0Xodx8pZMQr330+NvV/nLaJOLgyVa8PFv8gdH4MQi/+H0J84ayoxvLDOD1Uhg/SiFCO+5VS6TLLI4/YmKAu+iWd2S5CnA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=c1sGMaYoEMpe1I8fGFY814S7/nrCMzoJpgqP4+KdRDg=;
 b=yTIbx9QpxXZ6XG3QrpYrP4LWJ+bykdBP3NeSZ0IIpM07FLlYcYR/RALO4WiRJhgCEHHItXmDFK7c2XyJe6Pf8MFx4UJ0ZAteX3zFxo3McPVhoxWaINWApkASjEJyBH4wca2Br/awdIoCR5+YE5h+7bKfJqYPanPhBBIp3+KkT0o8mhvD1SwrsvOaRJf7tNhxMUq97386x3cM1D3+0CEBcL8BQc+B357i8HTNbufJKm9uAuYU41kupC8dqvC7EyVm3Dn/lsl0OSOkw47E2jc+/9o1KW/dvnW/M1u2qZvKsicPkILBfbIK9w9PmqNLNuNAxLhKVnO/CzXyqE32H2gTuw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=c1sGMaYoEMpe1I8fGFY814S7/nrCMzoJpgqP4+KdRDg=;
 b=bLV+NQCuTo6EnxYcgbfBLpyydoJdjPUjLQZWmCbwFOuhau+g1KmcWRu0K3j29puswDwDPDXcPAt5eAAuGUbk1nP/xVdEA7L9AJf1/X5fGK6Nh1zWKaJ4jXB7XZjhsSySlcOOoOD4KAjFbPkmTjVgiohH9QTZnTaudwGWz94URdVVNzmaASD9II4wtojTcXjgNt3FjMy2hA7OwimJgx+LhVt9CfjvpT6eWo6XIAsq15NczmNYSDITC3BFMyw0k1qaPuYbOamGNskQ2cob1QmRt2O76KANf5fUnqx90d+Sc+P1NylqnhPugIa4WO2YwCOuOIoS1pk/uKBBnaegCo4uqg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 DM4PR12MB6590.namprd12.prod.outlook.com (2603:10b6:8:8f::11) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8835.29; Tue, 17 Jun 2025 01:34:58 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::5189:ecec:d84a:133a]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::5189:ecec:d84a:133a%5]) with mapi id 15.20.8835.027; Tue, 17 Jun 2025
 01:34:58 +0000
From: Zi Yan <ziy@nvidia.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: mm-commits@vger.kernel.org, vbabka@suse.cz, surenb@google.com,
 richardycc@google.com, osalvador@suse.de, mhocko@suse.com,
 mgorman@techsingularity.net, kirill.shutemov@linux.intel.com,
 jackmanb@google.com, hannes@cmpxchg.org, david@redhat.com,
 baolin.wang@linux.alibaba.com
Subject: Re: +
 mm-page_isolation-remove-migratetype-from-move_freepages_block_isolate-fix.patch
 added to mm-new branch
Date: Mon, 16 Jun 2025 21:34:53 -0400
X-Mailer: MailMate (2.0r6265)
Message-ID: <E75144C0-2F1B-4C2E-8BEA-246FA4365CC9@nvidia.com>
In-Reply-To: <20250617012859.ED994C4CEEA@smtp.kernel.org>
References: <20250617012859.ED994C4CEEA@smtp.kernel.org>
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable
X-ClientProxiedBy: MN2PR11CA0026.namprd11.prod.outlook.com
 (2603:10b6:208:23b::31) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|DM4PR12MB6590:EE_
X-MS-Office365-Filtering-Correlation-Id: a3e3e7e9-5e3b-4775-7d3e-08ddad3f2b37
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|1800799024|376014|366016|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?BaH/9Od8AeQD3Ul1BZp21cCapnuBx932xGYMf+rMh/seu2f/9M01COyhM+Pu?=
 =?us-ascii?Q?v1hHeUu6tGj96QWPdWXIKiotntZkU2SH/YyZCpVRrp1YGOUHx7UdFEHQXa5K?=
 =?us-ascii?Q?WN8ZF4jpRMl3HmqAS5he4HWHOIAn6AnYXL2nx/C/toi6KP9t4H7+7BFUYSo/?=
 =?us-ascii?Q?/2o4bDjD/tTrIAoLGcbN0yHT11yGl6EUZS0zEkXaZelOiKjjescvYDTTbfWo?=
 =?us-ascii?Q?nPWR2yjCXt6/0Y7p0UC60FQgnyn1U05877CvxseZaOj4JN55ufHI4bnPy9bY?=
 =?us-ascii?Q?ZF8W/6jash6V2bXd/r9ASRU6/RXIh1Vf9zqhLv+gAUV1WJCInWkAIZTfVzAs?=
 =?us-ascii?Q?lAiXGAPgHIaIfWCraxFXfLA0w1DL8pP2X29Im7rzaDktDlq4iFS59fVLcEHN?=
 =?us-ascii?Q?g/0RJpjqz0FAm+JUwkpQwZQMgadJ53bPNB3gLtwL9xajNvIK7EewllEOHDfo?=
 =?us-ascii?Q?ZPwo2XfpacNe/gG8DCH/skaNYA4RCtR0HZkIAKx5gLoBlKCNlIREnMGUZSXD?=
 =?us-ascii?Q?8+0Wq8otqmYo+2XqWfS9UsTig4iS3HTrI2T9qXgVHOfaDuFHAKl9g6NLa6r2?=
 =?us-ascii?Q?i249PUv4Yr5LM3QbVlFgRF2RSOZlYMQKPLy856KABUxt4jyICDFt+V62xC6r?=
 =?us-ascii?Q?2+IuHANtssyskk6qfiGZQNj8qTelCoJYqrJJggvpg+7rysx5L3TW2Be3A6v6?=
 =?us-ascii?Q?X4PiiS4gUcR7ug5b7UsXmXGMvFj3ylEF+Vlpfp8fo2QSe/toRIbNs4kMV/D7?=
 =?us-ascii?Q?bSuDfnjaCxiUxrwIFvjg+VZHArhroYmtsxZHbBJp6Qkqk3ijXaUlWvjPbcI0?=
 =?us-ascii?Q?1n2tB8vStUcxziofiDm/fQXhRt7hVpieQB1/x5gkhhJHj3XKwPOh4R1VLjHh?=
 =?us-ascii?Q?R4bZmfiuVEbqllTznjGxCfn5fLie5nTQyJTqItxWLWiLbwf0+Mb42zzu0iWx?=
 =?us-ascii?Q?t3L/7gBvo8OSNm/NpFvHwtii92/FaPUW8zTBOtk5vNFOp3MpgleXf+dYGz1d?=
 =?us-ascii?Q?VcM3JaNfNwmrl6KclZLK4Oi1kzwQ9fWeLEjxziKdUN/O36UHIC8V0OQuMW+K?=
 =?us-ascii?Q?WW5AO9jKEWxEuVxZzTWB5SaH5lW+t0mwUTnazPAR8oWeNHMMDPPF6PuHlkPs?=
 =?us-ascii?Q?JEVrFtgxAssHWq9qLrBcSr8XLrv4zd3hfX7jV0VMao/2MsVRchvYbE8j7bDd?=
 =?us-ascii?Q?uMqWFZGKlpqn53hqaxLYUs5NEZDun2KzCJ0VdjY0PAe8/rhpHh7T/3WHB4ii?=
 =?us-ascii?Q?scN3lRq34N4Tr1eFQE0Kp7l0BLKDKPshO2Mbfyvfhg80h+/G2LcBIYDpVX5I?=
 =?us-ascii?Q?IYVmuSGzy1IggxQQY42gCy2/qSaPd7pAcS3a7DUoKUQ1t5Tm73OeWKO6VR+p?=
 =?us-ascii?Q?3MVKmRHlaeT6Rcf5R3gb6NsynlmIfYya79qDSF5AUFFvDXskOaeK1VUSN0hJ?=
 =?us-ascii?Q?431CYwN9J+Q=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(1800799024)(376014)(366016)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?kYzooWmObFygLBWhdQeF6shpVDH8rPbCSI4zS5580Hpj7Fl2uKvZvmJwNz+v?=
 =?us-ascii?Q?UHyDXlZkqj0VyUg1PHgX6ZCfzXTsI4Ntw94fRjLAGS7K4PdTrEbLEm/lkMjv?=
 =?us-ascii?Q?sdDrfExCKC2ybR3K2/QyjJiu/zPf/Hhr9qv+uboJrntobvapP9yAwEdismCt?=
 =?us-ascii?Q?qCM1+DaqaPEJowx7WJeI+nuOF0qhY4liBbgDW81/DXvWR341jlzJIGSEAqzU?=
 =?us-ascii?Q?lrXTDNeeMmmOCYXyQqFqBzEebFlGzdiKliW2ZSkOPDGHddz1tYybEMlBSasn?=
 =?us-ascii?Q?9w2fu9LKF2D5HrTPPcCj3bHlKa3mtRNyMCAwjtLuzP75DkBZzBW6W7+zhLIQ?=
 =?us-ascii?Q?FThFR5u0zwgIpli6jYpkTaUWltK5SwHAYIEV0UqHoJlCYm1hoE8RRxVeHN/B?=
 =?us-ascii?Q?gwADhNmYMeqP66JbeeqzZfWJ+dcEO6/XBM+YxTEATrHFDUhruKGdAHy+hcBB?=
 =?us-ascii?Q?RkWcUUOgXsQfmlBNwVicpuGvXxWczK7tWuMK/NjbB/OoBY/Km2b8iCnhyn0E?=
 =?us-ascii?Q?Iq+QSyzs7i0bhibjjS2wdRhc3IO1cXLaes3eNv2T7iD+hO15jnwLoGn/oLsU?=
 =?us-ascii?Q?/C4yGC+etF8Nq82HsbLKR69cYBqFKEVWa8iLI9r2PM6FzE3bG5EcBhn1CpXn?=
 =?us-ascii?Q?P9tzqy/o9yZFl2by7y8VxZ2vyDGqE6VBLuSTL/1DH43E6FKRIY9LyynT2TBC?=
 =?us-ascii?Q?bhHmDgdNcXgTKN2LHIy0xOoPmljLGRdSTum5pqdscpGZ7478WTpjUZnpgWwT?=
 =?us-ascii?Q?LMACjXFDYSRYDN8uU1GOM894mms3pPDcCeaQLeU35z8Onc7bX6OhMDtSSVOE?=
 =?us-ascii?Q?GSVUpU314+Wg2tmYcAPm6QnCudi0WGbLBG/O2/8RLL6JPnilMSC+JXxaFEk7?=
 =?us-ascii?Q?HBGiLgI1u5HDaT6MDHUM6lF0CkFD+k635MgSwiqhlokkcuBtL4P7/4nd5P0W?=
 =?us-ascii?Q?QzAd/HLF1X6i3uczrGpkICG5/t4/UHUVYxpIa2N5r2BLmmdgRatKUjYBVrk+?=
 =?us-ascii?Q?SrFcEiyaa63P44X+H8ZuzaN85ywIjmxqUyHSTSSj29VuW7erHErlKJo2bgDF?=
 =?us-ascii?Q?w+xjG7qU5gfy/zpNpIx/ToMwZSVfLoi1GVC4rysRA4L6043WCwcubOmuUHOL?=
 =?us-ascii?Q?tZS7cA9MJgJYVT0afN8S8YuheYpdPPTiONvC3in0iHBo4XoYnfDIEefKBInI?=
 =?us-ascii?Q?fjjP+fKzgbyoEJQ4Fqjqs7FYm4FxGhnzkIYdRbkSbX+tz+/Cgg5CGioIysue?=
 =?us-ascii?Q?8pqLe0o4D9bN1T1XxO1CWzn1dso4KYR4G+yCl+sZZschy4lFRu43xGMLShBB?=
 =?us-ascii?Q?pCnU3My/G/PWx+L7WoMOH8HF1jZ3vifUyK8upZY2F1dZ7Sfk9/RT02sabg/+?=
 =?us-ascii?Q?jmGq1UPUvTgvG51yp5Ho+K1eepBB+7dS4kHMZjaxMxKVb52QZwUa/nNbLTc/?=
 =?us-ascii?Q?pIRzKQt4dcvtGbZ2cvwWoFcmaO5c9rurPbDaWCgNhY27/SoPdD+ZgtP4CMrw?=
 =?us-ascii?Q?J+kUob9Zzy3ZDPuRJUr6TA4uernT4PvDGmCRuMDxwk+892TLglHGEqebugIT?=
 =?us-ascii?Q?gWIHAk43btR957+J8B4=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a3e3e7e9-5e3b-4775-7d3e-08ddad3f2b37
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Jun 2025 01:34:57.9356
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: t2seb4C6Vb75awLwz9ont5SXVR1XeY82FtmBxddm6PQBdMZ0eDxf/oyASHWQLK6x
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB6590

On 16 Jun 2025, at 21:28, Andrew Morton wrote:

> The patch titled
>      Subject: mm-page_isolation-remove-migratetype-from-move_freepages_=
block_isolate-fix
> has been added to the -mm mm-new branch.  Its filename is
>      mm-page_isolation-remove-migratetype-from-move_freepages_block_iso=
late-fix.patch
>
> This patch will shortly appear at
>     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tre=
e/patches/mm-page_isolation-remove-migratetype-from-move_freepages_block_=
isolate-fix.patch
>
> This patch will later appear in the mm-new branch at
>    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
>
> Note, mm-new is a provisional staging ground for work-in-progress
> patches, and acceptance into mm-new is a notification for others take
> notice and to finish up reviews.  Please do not hesitate to respond to
> review feedback and post updated versions to replace or incrementally
> fixup patches in mm-new.
>
> Before you just go and hit "reply", please:
>    a) Consider who else should be cc'ed
>    b) Prefer to cc a suitable mailing list as well
>    c) Ideally: find the original patch on the mailing list and do a
>       reply-to-all to that, adding suitable additional cc's
>
> *** Remember to use Documentation/process/submit-checklist.rst when tes=
ting your code ***
>
> The -mm tree is included into linux-next via the mm-everything
> branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
> and is updated there every 2-3 working days
>
> ------------------------------------------------------
> From: Andrew Morton <akpm@linux-foundation.org>
> Subject: mm-page_isolation-remove-migratetype-from-move_freepages_block=
_isolate-fix
> Date: Mon Jun 16 06:25:00 PM PDT 2025
>
> kernel/kexec_handover.c uses set_pageblock_migratetype()

Hi Andrew,

Please use the fixup below (to Patch mm/page_alloc: add support for initi=
alizing pageblock as isolated) instead. Thanks.

=46rom 57bf7a24f16b8186fd4f462f193bb73da0aab773 Mon Sep 17 00:00:00 2001
From: Zi Yan <ziy@nvidia.com>
Date: Mon, 16 Jun 2025 21:32:01 -0400
Subject: [PATCH] convert kernel/kexec_handover.c to use
 init_pageblock_migratetype().

Signed-off-by: Zi Yan <ziy@nvidia.com>
---
 kernel/kexec_handover.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/kexec_handover.c b/kernel/kexec_handover.c
index 5a21dbe17950..49634cc3fb43 100644
--- a/kernel/kexec_handover.c
+++ b/kernel/kexec_handover.c
@@ -1100,8 +1100,8 @@ static void __init kho_release_scratch(void)
 		ulong pfn;

 		for (pfn =3D start_pfn; pfn < end_pfn; pfn +=3D pageblock_nr_pages)
-			set_pageblock_migratetype(pfn_to_page(pfn),
-						  MIGRATE_CMA);
+			init_pageblock_migratetype(pfn_to_page(pfn),
+						   MIGRATE_CMA, false);
 	}
 }

-- =

2.47.2




Best Regards,
Yan, Zi
