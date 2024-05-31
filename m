Received: from APC01-SG2-obe.outbound.protection.outlook.com (mail-sgaapc01on2056.outbound.protection.outlook.com [40.107.215.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0196156F40;
	Fri, 31 May 2024 11:07:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.215.56
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717153641; cv=fail; b=DqZ3o9OwkGwrlUjl53mCaD4cZrMbS7LOpLm1Fb9x1Byqux4bMawCNfAZEV4Fxg2P32XcSfzQl78dRpO6QYYlUs/5KKcfuGz7AMqoRo6oXTKq7rannlHAp62O6NJQK6GJ70F80Ze2dlJ+jwabABu8GrPzhFMcZ2xHLKdR1e+0Fwk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717153641; c=relaxed/simple;
	bh=AcKauf7xG6Cyoz0wUJHS53fNvniMIcqQaLcqLFNa7PA=;
	h=Date:From:To:CC:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ZrH2VOa8+02kXJCDJRYN5wnKwvMMJDYHcRZimMCoiGd6nFK8ELzvUI4eMaCN9051e82Y5MimlZ959qRk6dG3pYWp0p/6froon/s5OQfut6yOsv7DRlXzrlwRH+DAFAtH1oRntkYGOTWLtCPsBjxQIzJf5EM3gU6GmwUa8dhUekc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oppo.com; spf=pass smtp.mailfrom=oppo.com; dkim=pass (1024-bit key) header.d=oppo.com header.i=@oppo.com header.b=GZIGUvr0; arc=fail smtp.client-ip=40.107.215.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oppo.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oppo.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=oppo.com header.i=@oppo.com header.b="GZIGUvr0"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YSeB2Xw1HNV60CUC5cOLJMoiYMrliqYLoK0xgP8iwLoJIPutD+lGPrKzT2aKW7BAJgSZC58MALxvLU7zrykE3kpjkNBgPPK7n9zyzerZKv46EWDnh0LIiJ1AoXIHnZEeHgiXantpFgqXNvPrQ4D+HsFFHKkbQceUF3TgY73/iP3ruNgAXwNUVlpO038jaaFnFMPOIGUSinSpEMlKYhm3SOWvL19CTnCBlFJ4bCGdDN2QAJsXrrcrXQpNIuxE8fFEZuk32UV5XBQ8t1PewBBcHgJ98fjdAgB2FjUVNbteDw8WliaDDW6ioMWw3y55jcxpc2IEexaYQUZUUuadLkjc0w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YxPRvTEyWkCUc29jOHVnhWvBj+Bjtcfx7c7GJZE7hJI=;
 b=oZp+hr/UQe87C17+vrUwD+kJ+cEOMNJ+fo5hIvjVBm+IgXDJ34Fck//K2SV4SUG4/FACNNX0qf3WnKAZoAGauexwWdvX3cIT3Z2zmGEc6GqWjda3knbm+uBDdFH13XO9jOfG6viLHVle2E4+T7SRL7DErj4DRTyJVQD0gv8AoLLS9t4y18LI9nrlGXIMBocXRkhVgmCG7W4Au+uhkm8zJ6tKwH2+sYFduAMRcrWm4lMZThvCd5C/e+6EA4s+PLua9vuhLaysu2pQpg850y22Bfq7U/lgR7FKHIW61aBRry4DRd/uan5Im6Ke7XjmYqIVnH0U4ks9YrC8Dro/84+0Xg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 58.252.5.68) smtp.rcpttodomain=gmail.com smtp.mailfrom=oppo.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=oppo.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oppo.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YxPRvTEyWkCUc29jOHVnhWvBj+Bjtcfx7c7GJZE7hJI=;
 b=GZIGUvr0HkdNMRtQjxK2B0XTWiHiFluBMMqRscp+Bqjk8JXVP0+qD1gzyE01Fw4BelwKsHe4dzXZARqQ0jv/QibTX4Ose5IriLp22ZfuTXX/sqPYh0RJeUphUAMJBi+jA7oIRpgYtcVDJ0zSRpzh6/Xk7pYZC3lVtUjc/IwIgUI=
Received: from PS2PR02CA0092.apcprd02.prod.outlook.com (2603:1096:300:5c::32)
 by SEYPR02MB5845.apcprd02.prod.outlook.com (2603:1096:101:5e::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7633.21; Fri, 31 May
 2024 11:07:13 +0000
Received: from HK2PEPF00006FB2.apcprd02.prod.outlook.com
 (2603:1096:300:5c:cafe::48) by PS2PR02CA0092.outlook.office365.com
 (2603:1096:300:5c::32) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7633.22 via Frontend
 Transport; Fri, 31 May 2024 11:07:13 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 58.252.5.68)
 smtp.mailfrom=oppo.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=oppo.com;
Received-SPF: Pass (protection.outlook.com: domain of oppo.com designates
 58.252.5.68 as permitted sender) receiver=protection.outlook.com;
 client-ip=58.252.5.68; helo=mail.oppo.com; pr=C
Received: from mail.oppo.com (58.252.5.68) by
 HK2PEPF00006FB2.mail.protection.outlook.com (10.167.8.8) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7633.15 via Frontend Transport; Fri, 31 May 2024 11:07:13 +0000
Received: from oppo.com (172.16.40.118) by mailappw31.adc.com (172.16.56.198)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Fri, 31 May
 2024 19:07:12 +0800
Date: Fri, 31 May 2024 19:07:12 +0800
From: Hailong Liu <hailong.liu@oppo.com>
To: Zhaoyang Huang <huangzhaoyang@gmail.com>
CC: Andrew Morton <akpm@linux-foundation.org>, <mm-commits@vger.kernel.org>,
	<zhaoyang.huang@unisoc.com>, <xiang@kernel.org>, <urezki@gmail.com>,
	<stable@vger.kernel.org>, <lstoakes@gmail.com>, <liuhailong@oppo.com>,
	<hch@infradead.org>, <guangye.yang@mediatek.com>, <21cnbao@gmail.com>
Subject: Re: + mm-vmalloc-fix-vbq-free-breakage.patch added to
 mm-hotfixes-unstable branch
Message-ID: <20240531110712.b42xstbqgtn6vw2t@oppo.com>
References: <20240530200551.354DFC2BBFC@smtp.kernel.org>
 <CAGWkznHXyyfnu4eo4CdRyDO-Tvo+4eRASvkVyAHqFQ_i6W102Q@mail.gmail.com>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAGWkznHXyyfnu4eo4CdRyDO-Tvo+4eRASvkVyAHqFQ_i6W102Q@mail.gmail.com>
X-ClientProxiedBy: mailappw31.adc.com (172.16.56.198) To mailappw31.adc.com
 (172.16.56.198)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: HK2PEPF00006FB2:EE_|SEYPR02MB5845:EE_
X-MS-Office365-Filtering-Correlation-Id: f2b86080-d5a5-4916-79fc-08dc8161d328
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230031|7416005|376005|36860700004|82310400017|1800799015;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?dFQzT0pPS2VhN0g3YTdqOFdQSjdmd0ZEcWNCOEdXOHZlQXY3NmZSU2EveEpp?=
 =?utf-8?B?WERDYW1sbm93QTcrVGVXVkR2Q0RVMVJSQUg5SDIwV0JZdHFuMG9iQURTMmlw?=
 =?utf-8?B?QzZNUlRLbzRxSDNCa2VxbFdKYWRoRU90dXh6SXN3L0VoOGl6bURCOEY1YVZG?=
 =?utf-8?B?dXNwM1lvRmN4cGZQeWp0bWozenkrMTZQaG4rOU4vSVhxUEFSMEt3d25saXow?=
 =?utf-8?B?QVJlM2lML0ZCaFFRL2hXWDdUbjQxQ0xBdGp0ZjRDQXFZQlg3MytRd0pCUDky?=
 =?utf-8?B?ZmYwM1R6ZUxLUXB1M01MaWRSQVlTOWp0dHRTUDkxZWw1K0NDYkZWbHlSTW15?=
 =?utf-8?B?bS9nbU1xVnNIdXdJdm1DK3BXNndVck96UnpFNklpZkZPalRFUkU1MFArMlBI?=
 =?utf-8?B?UVRhR3VuSGVXYVJZeHJHVm1SVjNhcysrM01iMUFPZCtQN0wrVHV1cWVWRGk4?=
 =?utf-8?B?K1BmTnZpbUFieTExUllUenFQUDlqcjdVRHd6cFhqbmJvUk5ua21adHdQeUtT?=
 =?utf-8?B?QTZuU1JBRmJWMm83ZkI1U1RCSkJpZUlKeWxtR05FUFdEYlREc3k5N0hVa1ZE?=
 =?utf-8?B?SXpXYlhGa2dZbmw1d2dQcVRXQnloclNETHh4anIxbnNOWHpEN1gxOGdMV2V3?=
 =?utf-8?B?aFNZSGYrL1ZoU1I1M3NHMkM1K2ZwTGR6Qy9lSmZaNCtGU1hrbTh1T0Z6NUlV?=
 =?utf-8?B?NUdKTGF4RnVvTm44aVA1a3l3ZitYSUdPQVRpS0NDdWJVTUhGODJoL0kvQ3RP?=
 =?utf-8?B?eVlpa2NCVlJZRy9ZTWc5dHI4d2oyeml6RlcxZC9PN3lZeUFvcklQa0NibXZz?=
 =?utf-8?B?azhZcklrMUxrK21paEJ2MFA2U1dnem1sOTlad3kwTXlrd1V1VjF0RVlpeEI5?=
 =?utf-8?B?UXRsRnVCcUZOU2RWYVJMNVhwb2RHS3VJbWVidTh4cG5uVkkvWGVUME9SM2dT?=
 =?utf-8?B?T0lHZUU5ZWlZaDcrTm0rWmlqcjB1T2NKYk01aDd6N1IvM2d0V25wM2l5NnY3?=
 =?utf-8?B?SGRoVzZSUnk3dmtucElPblhiY0plNGVZbUcxeG5qZkdVSXRXR0hMSU1sbW0w?=
 =?utf-8?B?YitKV1lvWEhGQ3U5bmFsTWUyYTNzajRwOUY4THAwbGlpQnh3NDV0VFNSaG5u?=
 =?utf-8?B?VzRnSVl6TFNWVXZ3eWUxL2orM0FOWVNEOXZEbFJTdW9rWVdCRW92ZkYzZ0Rk?=
 =?utf-8?B?bnlocDNNNXQwQXRUOHFTdjRQTVYrUjJxa3hJWWt0S0FwekxVN2tGOWNXTXo1?=
 =?utf-8?B?WkdHKzg0MzY1VzY0UTNLQnRSM0oxc0ZtTEhydXBNUnhwa2hYd2Q2bThtVWhS?=
 =?utf-8?B?V1RSLy9CM2FRRmZTN2ZjcDcxL2t5WGZLa1ZkbVBaSno4V25pMjB4MmQvTm5m?=
 =?utf-8?B?NmZMQkt4ZFZDRGJJd3VBZks1NWU2UjBrSkFSdG51SGMvQllFWVFaa2luVWlN?=
 =?utf-8?B?T0E2TnBMNGJlbWZ3Q0VLU1lNWERGU05Qd3JrdGo1ZFprVnE2VEFaOGVibENH?=
 =?utf-8?B?V0ZNQmxzbDBTaDFYMW5pY0RUU3BKYlUxYjBtMk9JK1FORnhKTnNGVnN5ejd6?=
 =?utf-8?B?QXdMc0kySEJqU2tGSWRQdzNuMjZ4c0haVzQ5MkxOQ2QweGxDeUx5a3I2N0dr?=
 =?utf-8?B?SGdrczBLMTVXSDlna3pXOTZGRW54c3FLZDRsY3pMYWZMMTJZaFRjR2pzWTFk?=
 =?utf-8?B?b0RFUVduQTF5NE5CakdaYTg0dWltWUJjbDkxcDJEYkpQQVBQRTJUZHdHZ29F?=
 =?utf-8?Q?clKoqHKSF22j52nuL4Jo7m5PAg8r9BiSVxUGv6I?=
X-Forefront-Antispam-Report:
	CIP:58.252.5.68;CTRY:CN;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.oppo.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(7416005)(376005)(36860700004)(82310400017)(1800799015);DIR:OUT;SFP:1101;
X-OriginatorOrg: oppo.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 May 2024 11:07:13.2505
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: f2b86080-d5a5-4916-79fc-08dc8161d328
X-MS-Exchange-CrossTenant-Id: f1905eb1-c353-41c5-9516-62b4a54b5ee6
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f1905eb1-c353-41c5-9516-62b4a54b5ee6;Ip=[58.252.5.68];Helo=[mail.oppo.com]
X-MS-Exchange-CrossTenant-AuthSource:
	HK2PEPF00006FB2.apcprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SEYPR02MB5845

On Fri, 31. May 08:51, Zhaoyang Huang wrote:
> On Fri, May 31, 2024 at 4:12 AM Andrew Morton <akpm@linux-foundation.org> wrote:
> >
> >
> > The patch titled
> >      Subject: mm/vmalloc: fix vbq->free breakage
> > has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
> >      mm-vmalloc-fix-vbq-free-breakage.patch
> >
> > This patch will shortly appear at
> >      https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-vmalloc-fix-vbq-free-breakage.patch
> >
> > This patch will later appear in the mm-hotfixes-unstable branch at
> >     git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
> >
> > Before you just go and hit "reply", please:
> >    a) Consider who else should be cc'ed
> >    b) Prefer to cc a suitable mailing list as well
> >    c) Ideally: find the original patch on the mailing list and do a
> >       reply-to-all to that, adding suitable additional cc's
> >
> > *** Remember to use Documentation/process/submit-checklist.rst when testing your code ***
> >
> > The -mm tree is included into linux-next via the mm-everything
> > branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
> > and is updated there every 2-3 working days
> >
> > ------------------------------------------------------
> > From: "hailong.liu" <hailong.liu@oppo.com>
> > Subject: mm/vmalloc: fix vbq->free breakage
> > Date: Thu, 30 May 2024 17:31:08 +0800
> >
> > The function xa_for_each() in _vm_unmap_aliases() loops through all vbs.
> > However, since commit 062eacf57ad9 ("mm: vmalloc: remove a global
> > vmap_blocks xarray") the vb from xarray may not be on the corresponding
> > CPU vmap_block_queue.  Consequently, purge_fragmented_block() might use
> > the wrong vbq->lock to protect the free list, leading to vbq->free
> > breakage.
> >
> > Link: https://lkml.kernel.org/r/20240530093108.4512-1-hailong.liu@oppo.com
> > Fixes: fc1e0d980037 ("mm/vmalloc: prevent stale TLBs in fully utilized blocks")
> > Signed-off-by: Hailong.Liu <liuhailong@oppo.com>
> > Reported-by: Guangye Yang <guangye.yang@mediatek.com>
> > Cc: Barry Song <21cnbao@gmail.com>
> > Cc: Christoph Hellwig <hch@infradead.org>
> > Cc: Gao Xiang <xiang@kernel.org>
> > Cc: Guangye Yang <guangye.yang@mediatek.com>
> > Cc: liuhailong <liuhailong@oppo.com>
> > Cc: Lorenzo Stoakes <lstoakes@gmail.com>
> > Cc: Uladzislau Rezki (Sony) <urezki@gmail.com>
> > Cc: Zhaoyang Huang <zhaoyang.huang@unisoc.com>
> > Cc: <stable@vger.kernel.org>
> > Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> > ---
> >
> >  mm/vmalloc.c |    3 +--
> >  1 file changed, 1 insertion(+), 2 deletions(-)
> >
> > --- a/mm/vmalloc.c~mm-vmalloc-fix-vbq-free-breakage
> > +++ a/mm/vmalloc.c
> > @@ -2830,10 +2830,9 @@ static void _vm_unmap_aliases(unsigned l
> >         for_each_possible_cpu(cpu) {
> >                 struct vmap_block_queue *vbq = &per_cpu(vmap_block_queue, cpu);
> >                 struct vmap_block *vb;
> > -               unsigned long idx;
> >
> >                 rcu_read_lock();
> > -               xa_for_each(&vbq->vmap_blocks, idx, vb) {
> > +               list_for_each_entry_rcu(vb, &vbq->free, free_list) {
> No, this is wrong as the fully used vb's TLB will be kept since they
> are not on the vbq->free. I have sent Patchv2 out.
as in https://lore.kernel.org/linux-mm/877csxn6ls.ffs@tglx/
the $VB either in purge_list or in free_list may not flushed
in vm_unmap_aliases(). but $VB's flush is defferred.

In fact, we don’t necessarily need to flush here, and doing so could lead to flushing twice.
one in xa, one in purge_list

so IMO loop through list_for_each_entry_rcu() is more
reasonable to me

> >                         spin_lock(&vb->lock);
> >
> >                         /*
> > _
> >
> > Patches currently in -mm which might be from hailong.liu@oppo.com are
> >
> > mm-vmalloc-fix-vbq-free-breakage.patch
> >
> >

--

Best Regards,
Hailong.
