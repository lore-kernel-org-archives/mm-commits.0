Received: from CY3PR05CU001.outbound.protection.outlook.com (mail-westcentralusazon11013055.outbound.protection.outlook.com [40.93.201.55])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5641343882
	for <mm-commits@vger.kernel.org>; Mon, 29 Jun 2026 17:06:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.201.55
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782752773; cv=fail; b=WbWZEp/i8yh9vVkWaVyd6qKANMEFtd/kgi0AKwXfCfb93mvR6tEVeA/ujKHD+OVSLKUfvKLT0TgAl6ZBNw0YRPf5zGLGi3GwWsO3sVfsrn4jPgv26q9ShBLvANWAOQ7fCSm9QOcUL5T6jptWn5WWhWsvxAq1nLbypIUY0SonTGQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782752773; c=relaxed/simple;
	bh=qG4rbbW60mx5tRxBgpR+8uPWA1xmYazhJkuggkcWBcw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=EwDc2qVrD7PRDAKCxRN2JW+MR03LntMHDuYcculUFP/DWTPgCUsGO1xyZNbcDuO7j39OwN806F+QzFEMYZGiPqz3HJtKK8jVZyydca5d/ofplrBrrwUwagU5EtYv/12UJLkUU1KgVa4zY6hs9ocItBjT/C2XY7RxJxoKbPAt+Fo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=cuModMk6; arc=fail smtp.client-ip=40.93.201.55
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="cuModMk6"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=gcQkKwT8noK3lV5emu0zHbyal83/kOJs4B2SBE46whYMO9Yf1W+cveviLm9cZQk/oLfonSCP3IlLCpvyhpls8BmamR97c0+fNFZ17fjx+vzenuXjyVyiKRIqbDOangO9oGywXTBcN8EXNU3/kilPIHy7S971/qR4A1JCiY8MSNB0/is9C3rUmAL/1GyK23E0wZyPMyizZXLy05gmuRwGuPm+dTKKVUzocvXJ7/lDMJhyuiTKZb7gmiKKXMgK+2JbuiG7zSLSeG3YpvP8pgAoPum5rCU3s0Aly+TEx39DXF6p5tFHQgzgqIOp6i+K/fbBPS9SBiiSyyO3TfK87lomvA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=GNK4HQaHv5pNu8Y0pWQcv3o3MtsuuEY3R+aObXDfjvI=;
 b=aKSk+NMv5iV9p3RMsh8zl2+Mh7msixFcCLXOqKbz72GI29mNXNKXSPUG2L11R0gkGKnfsp8wrMCCLSNyjiA9scoVzK9al8+qkAYWHNdiH/UkLlqyvN1KgkZgpxZeQ28V6aV3fbzAzzof+2ZfNnP0gaMaB8T2e4jEPFv7Pe1gs/1Q516fPMHGkvZzlMQ9BE1yhmPPDFtqQvWuCsAkog24AqV2gjF5Wa+WIy45zvGaPndW73DCUmZFX+zPKtBz4xBYkXXzZbpadSm3XlubL13OJsGAVkhoE2MKaWcVyNyloTLUBMFyoQSHRlz0wRT0TxOCXTox8gOXFxD3ns4u/rNv6w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GNK4HQaHv5pNu8Y0pWQcv3o3MtsuuEY3R+aObXDfjvI=;
 b=cuModMk6EBGtzXHvGDIR5YJNySaqKb8Ry12CJeTiSlvxBNd/TvS+Aeano2yDUIk2W2t20WPhd5rLPk4xw5LSF0JFJ/b2PhAG/jdMNSjAhuxd8vwuPom69+9oGebKvCfq78GcEts0nHcVrBc1+3jKSMa6gJzjR1qAOMlt1udydelrKoS2WJGJxheLAO6eZ5VtEwKCaZ/GVPYQncC9NvPHXD98cIaVpYxEaGCB9Ps0UjWMsS9FZCnJ8n9IWRWeBSwc7GKms7swLvav3tGPgVaGRwS7h2SsnIZFttooXeYBnuJxPUDKPraCob2X/PtlD6ntNxhRfTWbnZ+WKH0dUA5OdQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from IA0PR12MB8374.namprd12.prod.outlook.com (2603:10b6:208:40e::7)
 by LV8PR12MB9715.namprd12.prod.outlook.com (2603:10b6:408:2a0::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.159.19; Mon, 29 Jun
 2026 17:06:06 +0000
Received: from IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16]) by IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16%5]) with mapi id 15.21.0159.018; Mon, 29 Jun 2026
 17:06:04 +0000
From: Zi Yan <ziy@nvidia.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: mm-commits@vger.kernel.org, yuanchu@google.com, weixugc@google.com,
 vbabka@kernel.org, tj@kernel.org, surenb@google.com, sj@kernel.org,
 shikemeng@huaweicloud.com, shakeel.butt@linux.dev, rppt@kernel.org,
 rientjes@google.com, nphamcs@gmail.com, mkoutny@suse.com, mhocko@suse.com,
 longman@redhat.com, ljs@kernel.org, liam@infradead.org, kasong@tencent.com,
 jackmanb@google.com, hannes@cmpxchg.org, david@kernel.org, chrisl@kernel.org,
 baoquan.he@linux.dev, baohua@kernel.org, axelrasmussen@google.com,
 gourry@gourry.net
Subject: Re: +
 mm-constify-oom_control-scan_control-and-alloc_context-nodemask.patch added
 to mm-new branch
Date: Mon, 29 Jun 2026 13:06:02 -0400
X-Mailer: MailMate (2.0r6290)
Message-ID: <C860E962-8025-418A-A9AC-CB05FCCD804A@nvidia.com>
In-Reply-To: <20260628063113.99A031F000E9@smtp.kernel.org>
References: <20260628063113.99A031F000E9@smtp.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-ClientProxiedBy: MN2PR14CA0009.namprd14.prod.outlook.com
 (2603:10b6:208:23e::14) To IA0PR12MB8374.namprd12.prod.outlook.com
 (2603:10b6:208:40e::7)
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PR12MB8374:EE_|LV8PR12MB9715:EE_
X-MS-Office365-Filtering-Correlation-Id: a0c0453e-ee87-41f1-57e9-08ded600b3ed
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|366016|1800799024|23010399003|56012099006|11063799006|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	Wnb+3g/NjoNyHmo043K2zWwEWIU2uyFY3KR1b4rf48+to8QG4zzyH0eqLnb2q8eKP4LI4nE0ejaJmD7w2uLtMGJ2zooSKaaWcSJFJVUQuUYHCFJyfXBhUm86st1y5TqrJJ9sgijyKp3EuuCfcGb5+ipD5yWe+XBi1of57I0hsdOEpNmuqIXBsWaFxCQfpCVFcl96+Wz9BrmSI4yZ57qmBP91RqQxngsw+5cwmHzd/BNy7RU+xLMW23pUkziX4lnHgytVhmsk+aSRWMyC0/O9Bht7cWe3F4FMBNRk+5MAncmjzTut0Rcg/0N/mmzW9qXmoxECLR2QL9GHBQO+T3pskLxyvahDyDipMkF3zkR6XhXv2OQ5XVmQOveYUuHdiJPjZ1V6JVIoGWuGwf7xEJ0mP3A5DbeDIGrrYNRTBhhiQcxZYXRltJKaX/7ESV6FdqKPBZLkgQXGiXv1B9OzDRdVpJgJVb9kewAelODRIRF0lIDQfk7xfhPvy+NFPQxXcQJdMlZvc/ORkKSsOWibwgbZrraByGDnhbuPJNIBh9mBv1243YWEX3Bm74SwfgRMW+U10jTDG8kgw7/Vr3Lb0xHvQQdhjALf33cUoD2qB/kpXMxaDvSstA5dYhjMCD24bZSC9x9yA1mi4ApQCJVyUWCOmJ3ijo0Ra223tqidzTNo7+8=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PR12MB8374.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024)(23010399003)(56012099006)(11063799006)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?TTB0L0wxNEhxWXdPdUlFWVMwNjFWMWdadWszTXFrVUlUUVB5SURtazBiQlF1?=
 =?utf-8?B?VU42bUVTUWVDSHJqWTNRTmVhVFdzeGxJUTdWVHJ0eXlNbEVoMmZsamJDTnZn?=
 =?utf-8?B?MnIxbzIybXdwVXpRai9wcGUzUkMvRXFOd0lrdTNZTnF5TDZ4cWpkZlRsOEtZ?=
 =?utf-8?B?RFBINVhoQXljNFVkSXd3YjlHdlBmeTlpRThiUzltaUlNUzRXRnRYT2V3Snhn?=
 =?utf-8?B?UmVBNVhtL3FXMXcxek1mWU04Yk1QOSsxcGhsejhVbXhFY21xRlBDMnhBVWNC?=
 =?utf-8?B?Z3JRWWNoekgrYk10VjhCYkd3aW0rSEhGNXpXUVRNZTNKWVhtNlJiNmt4RFIx?=
 =?utf-8?B?MVRjSlZGT0JobFoyTktsbVNNZHhEMXNVbWhEdTRUZER2K0FZK1Z4eDNrV2lZ?=
 =?utf-8?B?Y2Q0dkllYVFuSmdFNktlY3JWUm9DUGVOT2p5SVduM3dield5eXlGeTl1eGFv?=
 =?utf-8?B?Qis2L2pOZmNSbE5aczJmRmtsd2RIU0pDNnBWS1I1WmY0WTBxR2tJcC83RWRE?=
 =?utf-8?B?UW4wYnBWdGpTUUZGWERZRlU5bDFoY3pVdTZsMFZSYjc3d3djVVgyaWJ5bkhU?=
 =?utf-8?B?U3lxNXgrVmpaS1NjdjcrcmFzRm1zQXEvbGRueHFPMHpUNjgwTkc1VkZMSzdO?=
 =?utf-8?B?YTBBRythd1RZRC80bzBMeUU3UTlEMVNNRUxTVzFDYTN5VCtwOFRldTE2Z3Nz?=
 =?utf-8?B?WWZGZWxGQTVVWHZQaGNqMytYMHpXYnpxL05JYjZlaXVGRFcvbnVQeGRBVHcw?=
 =?utf-8?B?MytJV2F3K2RtWlFXblB4QnJpNThKRlY3QVh4WEZUVkxseTUxb2kvUzc4QVlN?=
 =?utf-8?B?NUl5eXVsbjlvVFE1UVhxRG1sNlJtb3N6ci9aVUROK3lEYThIem9kL3VzdEJo?=
 =?utf-8?B?bTM2cjgrWHcwdU1uK3FmU05WTDNoeHkxSmNiQ25pNkdLWUxFMlVldEFkUjdx?=
 =?utf-8?B?c1dhSFRmVExFV2hHb1NhY2lQTDU0MUhUUXFJVklPL0ZHRGVpTkdTQWZSWGEz?=
 =?utf-8?B?Q29zQ1ZDRldUN2NnbXg5ZlZFdFJka2JFRUljUEp5QlZyaWZtVDB3dWxpZjl0?=
 =?utf-8?B?azIyNU1nZWhJR1poUk1HcC9KYVQ3Q0I0cU1PZThWeFpwZHAzT3VGd0NsbW05?=
 =?utf-8?B?SFMvRTBPZDFLeVJON1NTcWREQzJXSEZUTjZoS2xRem41Ukl0VVpNeWJYM2Jk?=
 =?utf-8?B?MHF3RFd3eHNOZ1ozcFR1QzEvZTZ1YlRQSlFIZDhHUjVYN0dyZ3BpdkNIQzhq?=
 =?utf-8?B?NTVoeHk3YXZBekNrbk5CTnRybktqVmkzM0Y4V1B6Yi9tS1huWW1MRGErKy9X?=
 =?utf-8?B?VG1DdERmSDBFSzB2Wk9ubGlKT2E1T3N4bVNJQmQ1dkRldlZaeGFZWXA1TFFu?=
 =?utf-8?B?N2gvMjUxQjFySmhwR1NzZUNQbTZieVpreW4vWTN5Lzd5ZWQzRWJzVnQ0QUZ2?=
 =?utf-8?B?WUJYVHJSVVgybThlMTZ5d3Y3Vk9MT1dEb0tLNEhEMkdoVWxnSkhXamxRNkhl?=
 =?utf-8?B?cjd4N2NwTXMvV0VLRUZHd25BZ1U0VFJodm9Xam9wRUJIZ2Z6bm0rNEt5RXAz?=
 =?utf-8?B?TWJ1NjVFSlV0eEtva1RZN1UwMjU0S2dNTFBtL05USEtYdGxObHR5RS85aEcz?=
 =?utf-8?B?N2oyZFB4cWFVMlVzeUtsTWI1cFJQZU5CSmV2d2xGbitIUVFCa0VINGhjcFRQ?=
 =?utf-8?B?SHhZckRST1U2bmZ6UnpuR1hSUmRYS2IrbWs3YkRaYmVNU013VjM3TC9GOVNx?=
 =?utf-8?B?ODBNY29wc2ppbDJaN1Z6ZUNTMHo5NXd6YktUNUE1NVlDNVN4OXg2K1I0ckFq?=
 =?utf-8?B?V3N5TmxPVDY5clVid3IyVDRQTmE4TEpCbGtPWlZNUllYNG4vVFQ0MUtnaFJC?=
 =?utf-8?B?TlpycnczdC8rL1JxUllGb1kyc0NIbkZZbDdXWHZWeGxLbm5YWXJZWDMvbnlM?=
 =?utf-8?B?MlBGNkZWMmNIT2Y0YWZyQlZHRDVEVWsza1hzODhIdDBQdDlUbWxQWnYxZ291?=
 =?utf-8?B?c3Zjd3RLN3htdEZiUnJ1Z0NvdXNDdUEzVnptUGlwalorcWY4NnNYWjdIN2lW?=
 =?utf-8?B?YmFTemRNRGpCTEs4bGcyTWt2amNtSmRDMFN4NnZiUUFZYWxjNUhyWXI4aDIy?=
 =?utf-8?B?M0RMRDBYaWh0N1FWWU9yeXg2MlA3eHIwZXpEaGJybHJ6V3NIcWtteVhGSFRu?=
 =?utf-8?B?T2d2WVgwMDl2Qit4Zi83YWtQRy9hY3c1bWtMNEJSN2FPVEFaQUlBeVpZeUt3?=
 =?utf-8?B?Nzh4TFRsQmNwRTVlTzY2UlRZYWJQNXNBaTZlOVRQNHRDZkZDZ0tZMXNjN09D?=
 =?utf-8?B?c3RGTWxLVEUxUjVRS1VxWTdCeXkya3FKZThMcEo0b3dXUHBFNlAyUT09?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a0c0453e-ee87-41f1-57e9-08ded600b3ed
X-MS-Exchange-CrossTenant-AuthSource: IA0PR12MB8374.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Jun 2026 17:06:04.1563
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: AmXIbvEbJtHGTVkE+JOof7IRvtFdDWzhS8IYNh6ztIuyPJkJZELzDNPQP/8a4UST
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV8PR12MB9715

On 28 Jun 2026, at 2:31, Andrew Morton wrote:

> The patch titled
>      Subject: mm: constify oom_control, scan_control, and alloc_context n=
odemask
> has been added to the -mm mm-new branch.  Its filename is
>      mm-constify-oom_control-scan_control-and-alloc_context-nodemask.patc=
h
>
> This patch will shortly appear at
>     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/=
patches/mm-constify-oom_control-scan_control-and-alloc_context-nodemask.pat=
ch
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
> The mm-new branch of mm.git is not included in linux-next
>
> If a few days of testing in mm-new is successful, the patch will me moved
> into mm.git's mm-unstable branch, which is included in linux-next
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
> ------------------------------------------------------
> From: Gregory Price <gourry@gourry.net>
> Subject: mm: constify oom_control, scan_control, and alloc_context nodema=
sk
> Date: Mon, 8 Jun 2026 20:29:19 -0400
>
> The nodemasks in these structures may come from a variety of sources,
> including tasks and cpusets - and should never be modified by any code
> when being passed around inside another context.
>
> Link: https://lore.kernel.org/20260609002919.3967782-1-gourry@gourry.net
> Signed-off-by: Gregory Price <gourry@gourry.net>
> Reviewed-by: Lorenzo Stoakes <ljs@kernel.org>
> Acked-by: David Hildenbrand (Arm) <david@kernel.org>
> Reviewed-by: Barry Song <baohua@kernel.org>
> Acked-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
> Tested-by: SeongJae Park <sj@kernel.org>
> Acked-by: SeongJae Park <sj@kernel.org>
> Cc: Axel Rasmussen <axelrasmussen@google.com>
> Cc: Baoquan He <baoquan.he@linux.dev>
> Cc: Brendan Jackman <jackmanb@google.com>
> Cc: Chris Li <chrisl@kernel.org>
> Cc: David Rientjes <rientjes@google.com>
> Cc: Johannes Weiner <hannes@cmpxchg.org>
> Cc: Kairui Song <kasong@tencent.com>
> Cc: Kemeng Shi <shikemeng@huaweicloud.com>
> Cc: Liam R. Howlett <liam@infradead.org>
> Cc: Michal Hocko <mhocko@suse.com>
> Cc: Michal Koutn=C3=BD <mkoutny@suse.com>
> Cc: Mike Rapoport <rppt@kernel.org>
> Cc: Nhat Pham <nphamcs@gmail.com>
> Cc: Shakeel Butt <shakeel.butt@linux.dev>
> Cc: Suren Baghdasaryan <surenb@google.com>
> Cc: Tejun Heo <tj@kernel.org>
> Cc: Waiman Long <longman@redhat.com>
> Cc: Wei Xu <weixugc@google.com>
> Cc: Yuanchu Xie <yuanchu@google.com>
> Cc: Zi Yan <ziy@nvidia.com>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> ---
>
>  include/linux/cpuset.h |    4 ++--
>  include/linux/mm.h     |    4 ++--
>  include/linux/mmzone.h |    6 +++---
>  include/linux/oom.h    |    2 +-
>  include/linux/swap.h   |    2 +-
>  kernel/cgroup/cpuset.c |    2 +-
>  mm/internal.h          |    2 +-
>  mm/mmzone.c            |    5 +++--
>  mm/page_alloc.c        |    6 +++---
>  mm/show_mem.c          |    9 ++++++---
>  mm/vmscan.c            |    6 +++---
>  11 files changed, 26 insertions(+), 22 deletions(-)
>

Acked-by: Zi Yan <ziy@nvidia.com>

Best Regards,
Yan, Zi
