Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2045.outbound.protection.outlook.com [40.107.220.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 331FC7485
	for <mm-commits@vger.kernel.org>; Fri, 18 Oct 2024 22:58:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.220.45
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729292325; cv=fail; b=E7bJvqisI0Hk8MpqAmvsj8TSXOuhPOrQKMzu5A+4EwNyROr9wuFRZqmEjTFVSeZD8muXKyV5bqSH3/WGvR/6DdrZNADzQK2UksR3tAwA/IYOW1CVzs/3jK83SxqgtbZMtn/JvYawzaPU7i1aoEd30eN2iIIKgWAs4jSZQM5TPf8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729292325; c=relaxed/simple;
	bh=L2DxZm8gmy41N9txHhOWUG71M+Ep5iosBKVoO/TcxCA=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=jFRb+6K+UuIfcMHqxsd7uBTOlOhoAMnC5tCkr28DN+cPBqvaMYzEEmHhaQDHkgwaJ0LiRtuNtQvYyrJaFHAN1rBNQJ2CRcrPXxkZCL4lB/bASdAw9aoDcuBAnCiK9A5G48QFHeklj1tYcLldJRKJZMZAnZ2MqJJD9FcnihXt/FE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=DBaBpPUl; arc=fail smtp.client-ip=40.107.220.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="DBaBpPUl"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=CkmpQv2w2VoJtp4r5tqXh0DDqMDIQ3/0tSrjWvur+9yyL0uM7XPY5C5xV8U88xVBHoNE+Wv8Xyj9WRFn9C3IrNtvhW5IaZ3hYMIrQ9fwQO1C6TdbHHtnwOhtaZdN+/6awAFny2l1OVlVbH+W/YrrYJufXFhywJMfEfOYeIQuHQA5K7fA1xhNj+wZREMqd9atroBV7joxh9aNOZopEBzAsBlRo70GDUkC1MM7M00uoEAlGrJgGzK7IQteiFVHIZRscslY6c0uf9Rr7yYmm1qbULaoffrlIACM4CXZwYEKM28n5zrKnso/uIMz+i2gv/9/E7apw6XPL2X5DuFtQgOVFg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=m5AgfgP+GnjFzFkxWO7OzKpb+Xl1cWV88ibm/phxBLc=;
 b=mj5C677g0yxSxWQt72XA+f4wzZO5TzF2aapVONzxB/KzTxsokmzDeCTEFZJxep3/mOhCmH/HKieXEjXP23A2jr8QEcBUoi1a9VJKbwa7Yxht7K74+5AazxWE7aArqTz3uhQfAd6EuZtHEmKu3tG8SouHUb7oGP9xG5OA7y7FUN/IU4JQty/H+qeHXyaw82qSZDer+L8lT0BhVcX51tzpMZRPVLWGbD93Z7oJnGV0z7LoEmGkffpLtIxWY1xV9OA1A9b+4GJuduLOlAyB8BlQAZvlgrY+8vZwQgq6q9+lcJ66eVKbyKGP+O5DiEZrhp2d8TBvDM3qg8lulzNT8meufg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=linux-foundation.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=reject sp=reject pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=m5AgfgP+GnjFzFkxWO7OzKpb+Xl1cWV88ibm/phxBLc=;
 b=DBaBpPUl2F7qD7di02rw+suBOHQAR52HsPHrGhEajZGQ5mIN6XIiqCrlFmA7SaMNuUXiJFqW5o12pdlwoPinuZcg8rySBKCCiprVE2Shawz4K28ajgdAP0G4Fim0EGyYii1ddCyCVKd7urCoLJeDy9pw5Xd8qvUEo3zYhWUtSoYoZLtn5L9pfW3uxpgYnxiIFQqtGOqrENhOMTVh0mbt57zjBqKhw6HEOdnvmJdkjSqmzyh1iJn+05GeWdm9OF2HL0imqW94J1kDNDsOQvYc0rF/ZwpfZWGsBuLRq/slFQrjAyiQV+wfEHsnFneDBdyOFHqQCcWCxLwdlaaCVfDp7g==
Received: from MW3PR05CA0018.namprd05.prod.outlook.com (2603:10b6:303:2b::23)
 by CH3PR12MB8355.namprd12.prod.outlook.com (2603:10b6:610:131::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8048.26; Fri, 18 Oct
 2024 22:58:38 +0000
Received: from MWH0EPF000989EC.namprd02.prod.outlook.com
 (2603:10b6:303:2b:cafe::36) by MW3PR05CA0018.outlook.office365.com
 (2603:10b6:303:2b::23) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8093.10 via Frontend
 Transport; Fri, 18 Oct 2024 22:58:38 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 MWH0EPF000989EC.mail.protection.outlook.com (10.167.241.139) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8069.17 via Frontend Transport; Fri, 18 Oct 2024 22:58:38 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Fri, 18 Oct
 2024 15:58:23 -0700
Received: from [10.110.48.28] (10.126.230.35) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Fri, 18 Oct
 2024 15:58:22 -0700
Message-ID: <2d622109-11e5-4c5d-8f13-40e695dd2127@nvidia.com>
Date: Fri, 18 Oct 2024 15:58:22 -0700
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: +
 mm-gup-stop-leaking-pinned-pages-in-low-memory-conditions-v3.patch added to
 mm-hotfixes-unstable branch
To: Andrew Morton <akpm@linux-foundation.org>, <mm-commits@vger.kernel.org>,
	<willy@infradead.org>, <vivek.kasireddy@intel.com>, <syoshida@redhat.com>,
	<peterx@redhat.com>, <pasha.tatashin@soleen.com>, <osalvador@suse.de>,
	<minchan@kernel.org>, <mike.kravetz@oracle.com>, <kraxel@redhat.com>,
	<junxiao.chang@intel.com>, <jgg@nvidia.com>, <hughd@google.com>,
	<hch@lst.de>, <hch@infradead.org>, <dongwon.kim@intel.com>,
	<david@redhat.com>, <daniel.vetter@ffwll.ch>, <arnd@arndb.de>,
	<apopple@nvidia.com>, <airlied@redhat.com>
References: <20241018224747.DBC0BC4CEC3@smtp.kernel.org>
Content-Language: en-US
From: John Hubbard <jhubbard@nvidia.com>
In-Reply-To: <20241018224747.DBC0BC4CEC3@smtp.kernel.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: rnnvmail203.nvidia.com (10.129.68.9) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MWH0EPF000989EC:EE_|CH3PR12MB8355:EE_
X-MS-Office365-Filtering-Correlation-Id: 1d4b13a7-1183-473f-69ad-08dcefc8671c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|7416014|36860700013|82310400026|376014|921020;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?U0RpZWdBek1xZkNHRU9tL3QvSm1LWUhZU1lNNStITzNvUkpoSi95aW5uQlMz?=
 =?utf-8?B?V0tVbVFDQ1ZPQ1JVS2krNklDWnpQOXdUSXFtUmdoaGdkMXJIR2o0a1JvanVw?=
 =?utf-8?B?QWdxSm9uWDFKQkUxcklmRTlTUmFpSjkzdjU5RXdmZ25NbTRsQXE0Z2RDc01Q?=
 =?utf-8?B?L011c1MyV0NWbFcrUkJOMmFKeFVlaCs3bmJ2dHNrYmZBWDdyMW5Pai92UEJO?=
 =?utf-8?B?ZE15VGIyY1MvWTNkWnY1MnU4SnEwSEV1SlBWTmxNMTJ5SC9CWlg4RHVnd3po?=
 =?utf-8?B?enBDQzZOb1dYSWt1Q0M5bFZzN0MwcldDalF3Q3BIUXQvT1JMOXFtb1lYL20v?=
 =?utf-8?B?cEw5UFBHU0JoMlRSSHRXN1JyRlA4SGZFZ2wrTHNJdnJ0T3JoQ3AyY1lUcFhD?=
 =?utf-8?B?bVhkdFBnSHRwa1RqaWY2YSsyRzlkOVROdjhzMFhNS2dOanpZbUpxNzVwK0RV?=
 =?utf-8?B?cXpZVnBha1BJeDk3RVJQRDF1QWhPZDlXQ3JyU2FXbGxsYVo0TURmam9VV0w4?=
 =?utf-8?B?dmZPMTZGMnpqbzBubTN1bDEycGdha1JlcWQ0NVQ0Zkk2TmR4UXpyZTE2S05Z?=
 =?utf-8?B?TjArakxFS3J4VWtJWURRcmo2VzlHSzFTazArclRkNjBQYWRsbCtDMlVDcTBL?=
 =?utf-8?B?aVBaL3J3dzBVQnlEQXFQNmF6YjZFTUdJSjd4bytKUEU0NVB3VkdpK0kyNXZq?=
 =?utf-8?B?V0hvaytsdkp2a1NBZEpmSWsvSUVDd2VQYUJwMTJYeG9uRHFQNkVUbkpvVHNP?=
 =?utf-8?B?ZnM4azBUMXFwUi9kQlp0cmFoSmNlN3RqSGJRNXlHRldUS2tySmF3SG1JcnY4?=
 =?utf-8?B?Q1QxTXMwRWhoVGZiYjVkR3E0SjkzOEhwZGw1aExlQVVvU1BPam41K3l5QnVE?=
 =?utf-8?B?cmMrUVpCOE52RmZ6NmdwekxGdmF1d2hkQU1yT1BoNFIwbVo4djZEL3ZwYWlP?=
 =?utf-8?B?TXhhV1BvbDl0OVQ1cC85WlRlK2lYY04zVG1QMHR4Qm4xU2hoREhXcE5sUVpQ?=
 =?utf-8?B?ZTU5MnFrM0dHQlJJZXhhTFA0M2Z1MXo0ellucWdHMXhoSTgyWE5RbWhPL1A5?=
 =?utf-8?B?VWYwQ2tlMzhOS0luRlJLMjJxTjZmcXlMYlVFR0FyYVdmRkJOZWJXWEhVVlBx?=
 =?utf-8?B?Vk9GTmoxcTl4bVhFT1QydWI2UGdBeU00YXk4TmMvTmc2SXFyRGhld29pV25P?=
 =?utf-8?B?c3R1MVlwWkhqSWJxcmZZWWRBQmEvZnY3ZFZWaGtYbjdicTFmMW9ZNVFoaDEy?=
 =?utf-8?B?Tk5UR0l6NjB2OWUvQ05MZ1BoQW53eVU0L3lvM2pYV3cyeVBzQVJ4M1dsOG8z?=
 =?utf-8?B?WW1vK0k3WVZwdmdESnVCR2Rmc29EK1BPZHVDU25LTEphdHR5VmZGNExnSVhR?=
 =?utf-8?B?WGVsMHM2alZhYUNjbGNyQkpuejhzcGh5SDAwV2V0L29TUVhSL0FneTdQdTB4?=
 =?utf-8?B?VllubWRyTXZvMG55TmJkWnM4SkpIbU5kRUhoUEpobW9HY0NqVkVBeHJab0VI?=
 =?utf-8?B?L3NtRzVlR3NZY1NGZW1iVi92aSsveWg3aWVXUkFqVHI5U25tamZlOTI4OHNp?=
 =?utf-8?B?RUw1Rm1FdVRwNGU4MzErRnpncGxQWUpzTmdBUE9uZGY4b09hVVl0TzZHendJ?=
 =?utf-8?B?QThtcENUT2NjQkJFWFFEVWM3UFA4Q3FGczBCS0JQMldiNTFlYjRLdGRLYzZr?=
 =?utf-8?B?ZEREVXNnTFRRUmQ1TGljam5Rdy8zc0ZCTFZxa1hCcXlZS0RlcXZrQmtadGlQ?=
 =?utf-8?B?MmFzbVQ5dlRzYzJJQkFQbzlUNjZTR3pocWpreU1BVno4bWFiNVdiYTQyMHYz?=
 =?utf-8?B?Tmc3ZENseUNxeVZzVnhXWGpBSmZlMDVkOW84TFUrOGNGRnRBNVJZbTh5ZkNh?=
 =?utf-8?B?M1RTT3krM25KSUlxcjhUVkxBbzRRSDFxLzQrNE42a3V6ZTlKUUlNUTE2STY2?=
 =?utf-8?Q?fN5eLTHDwsE=3D?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(36860700013)(82310400026)(376014)(921020);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Oct 2024 22:58:38.0774
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 1d4b13a7-1183-473f-69ad-08dcefc8671c
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	MWH0EPF000989EC.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR12MB8355

On 10/18/24 3:47 PM, Andrew Morton wrote:
> 
> The patch titled
>       Subject: mm-gup-stop-leaking-pinned-pages-in-low-memory-conditions-v3
> has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
>       mm-gup-stop-leaking-pinned-pages-in-low-memory-conditions-v3.patch
> 
> This patch will shortly appear at
>       https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-gup-stop-leaking-pinned-pages-in-low-memory-conditions-v3.patch
> 
> This patch will later appear in the mm-hotfixes-unstable branch at
>      git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
> 
> Before you just go and hit "reply", please:
>     a) Consider who else should be cc'ed
>     b) Prefer to cc a suitable mailing list as well
>     c) Ideally: find the original patch on the mailing list and do a
>        reply-to-all to that, adding suitable additional cc's
> 
> *** Remember to use Documentation/process/submit-checklist.rst when testing your code ***
> 
> The -mm tree is included into linux-next via the mm-everything
> branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
> and is updated there every 2-3 working days
> 
> ------------------------------------------------------
> From: John Hubbard <jhubbard@nvidia.com>
> Subject: mm-gup-stop-leaking-pinned-pages-in-low-memory-conditions-v3
> Date: Fri, 18 Oct 2024 15:34:11 -0700
> 
> 1) Applied the fix to check_and_migrate_movable_pages(), instead of its
>     caller, as per David Hildenbrand's suggestion (thanks!).
> 
> 2) Dropped Alistair's reviewed-by tag, because the fix has changed.
> 
> 3) Reworked the relevant documentation, and commit description.

Hi Andrew,

The above is the mini-cover letter, rather than the v3 commit description,
is that normal for this phase of the patch flow?

thanks,
John Hubbard

> 
> Link: https://lkml.kernel.org/r/20241018223411.310331-1-jhubbard@nvidia.com
> Fixes: 24a95998e9ba ("mm/gup.c: simplify and fix check_and_migrate_movable_pages() return codes")
> Signed-off-by: John Hubbard <jhubbard@nvidia.com>
> Suggested-by: David Hildenbrand <david@redhat.com>
> Cc: Alistair Popple <apopple@nvidia.com>
> Cc: Shigeru Yoshida <syoshida@redhat.com>
> Cc: Jason Gunthorpe <jgg@nvidia.com>
> Cc: Minchan Kim <minchan@kernel.org>
> Cc: Pasha Tatashin <pasha.tatashin@soleen.com>
> Cc: Arnd Bergmann <arnd@arndb.de>
> Cc: Christoph Hellwig <hch@infradead.org>
> Cc: Christoph Hellwig <hch@lst.de>
> Cc: Daniel Vetter <daniel.vetter@ffwll.ch>
> Cc: Dave Airlie <airlied@redhat.com>
> Cc: Dongwon Kim <dongwon.kim@intel.com>
> Cc: Gerd Hoffmann <kraxel@redhat.com>
> Cc: Hugh Dickins <hughd@google.com>
> Cc: Junxiao Chang <junxiao.chang@intel.com>
> Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
> Cc: Mike Kravetz <mike.kravetz@oracle.com>
> Cc: Oscar Salvador <osalvador@suse.de>
> Cc: Peter Xu <peterx@redhat.com>
> Cc: Vivek Kasireddy <vivek.kasireddy@intel.com>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> ---
> 
>   mm/gup.c |   33 +++++++++++++++++++--------------
>   1 file changed, 19 insertions(+), 14 deletions(-)
> 
> --- a/mm/gup.c~mm-gup-stop-leaking-pinned-pages-in-low-memory-conditions-v3
> +++ a/mm/gup.c
> @@ -2394,20 +2394,25 @@ err:
>   }
>   
>   /*
> - * Check whether all folios are *allowed* to be pinned indefinitely (longterm).
> + * Check whether all folios are *allowed* to be pinned indefinitely (long term).
>    * Rather confusingly, all folios in the range are required to be pinned via
>    * FOLL_PIN, before calling this routine.
>    *
> - * If any folios in the range are not allowed to be pinned, then this routine
> - * will migrate those folios away, unpin all the folios in the range and return
> - * -EAGAIN. The caller should re-pin the entire range with FOLL_PIN and then
> - * call this routine again.
> + * Return values:
>    *
> - * If an error other than -EAGAIN occurs, this indicates a migration failure.
> - * The caller should give up, and propagate the error back up the call stack.
> - *
> - * If everything is OK and all folios in the range are allowed to be pinned,
> + * 0: if everything is OK and all folios in the range are allowed to be pinned,
>    * then this routine leaves all folios pinned and returns zero for success.
> + *
> + * -EAGAIN: if any folios in the range are not allowed to be pinned, then this
> + * routine will migrate those folios away, unpin all the folios in the range. If
> + * migration of the entire set of folios succeeds, then -EAGAIN is returned. The
> + * caller should re-pin the entire range with FOLL_PIN and then call this
> + * routine again.
> + *
> + * -ENOMEM, or any other -errno: if an error *other* than -EAGAIN occurs, this
> + * indicates a migration failure. The caller should give up, and propagate the
> + * error back up the call stack. The caller does not need to unpin any folios in
> + * that case, because this routine will do the unpinning.
>    */
>   static long check_and_migrate_movable_folios(unsigned long nr_folios,
>   					     struct folio **folios)
> @@ -2425,10 +2430,8 @@ static long check_and_migrate_movable_fo
>   }
>   
>   /*
> - * This routine just converts all the pages in the @pages array to folios and
> - * calls check_and_migrate_movable_folios() to do the heavy lifting.
> - *
> - * Please see the check_and_migrate_movable_folios() documentation for details.
> + * Return values and behavior are the same as those for
> + * check_and_migrate_movable_folios().
>    */
>   static long check_and_migrate_movable_pages(unsigned long nr_pages,
>   					    struct page **pages)
> @@ -2437,8 +2440,10 @@ static long check_and_migrate_movable_pa
>   	long i, ret;
>   
>   	folios = kmalloc_array(nr_pages, sizeof(*folios), GFP_KERNEL);
> -	if (!folios)
> +	if (!folios) {
> +		unpin_user_pages(pages, nr_pages);
>   		return -ENOMEM;
> +	}
>   
>   	for (i = 0; i < nr_pages; i++)
>   		folios[i] = page_folio(pages[i]);
> _
> 
> Patches currently in -mm which might be from jhubbard@nvidia.com are
> 
> mm-gup-stop-leaking-pinned-pages-in-low-memory-conditions.patch
> mm-gup-stop-leaking-pinned-pages-in-low-memory-conditions-v3.patch
> mm-gup-memfd-stop-leaking-pinned-pages-in-low-memory-conditions.patch
> kaslr-rename-physmem_end-and-physmem_end-to-direct_map_physmem_end.patch
> 

thanks,
-- 
John Hubbard

