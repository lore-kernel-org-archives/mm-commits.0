Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BB48AC433F5
	for <mm-commits@archiver.kernel.org>; Mon, 10 Oct 2022 20:43:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229819AbiJJUnZ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 10 Oct 2022 16:43:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44188 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229760AbiJJUnX (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 10 Oct 2022 16:43:23 -0400
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1AFFB1B7B9
        for <mm-commits@vger.kernel.org>; Mon, 10 Oct 2022 13:43:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1665434603; x=1696970603;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=q/YtpbARBmazl3OMTwGzVattwmvrxeFeDFLQaBidCOs=;
  b=M2wF3VWgGZxZ+IDskMvXIiWFu9qF8WPLXyWXuA8wvDJGQ6ocx62Kz7Pc
   mTnTQ50/hYfugxI41ejyI016+xDl/Mu51Ay89HmfAOU3Wu96B2kSWfPLe
   bIc5BF4cssazDCmFc72I4XSXAV25hPNlML7/OwtxgTqcspjYMuJD14zST
   LTEAjNoDn6MgY6znTohWOJHpojcGm1doJt1Rd6Wglz1V1rVbjxZI6DoZi
   okNG2sce9Vtrrde+dIBqnCiggeS/d6nKDwSAEYcgs78+qoJgng30c1Omm
   +pK6Vv0cjmOuCMbEtre7GQcGdIq95r3O+jq2RU+sNpmJp93zSTEEiRdFi
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10496"; a="287595470"
X-IronPort-AV: E=Sophos;i="5.95,173,1661842800"; 
   d="scan'208";a="287595470"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Oct 2022 13:43:22 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10496"; a="628431246"
X-IronPort-AV: E=Sophos;i="5.95,173,1661842800"; 
   d="scan'208";a="628431246"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by fmsmga007.fm.intel.com with ESMTP; 10 Oct 2022 13:43:22 -0700
Received: from fmsmsx609.amr.corp.intel.com (10.18.126.89) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Mon, 10 Oct 2022 13:43:22 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx609.amr.corp.intel.com (10.18.126.89) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Mon, 10 Oct 2022 13:43:21 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31 via Frontend Transport; Mon, 10 Oct 2022 13:43:21 -0700
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (104.47.74.46) by
 edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.31; Mon, 10 Oct 2022 13:43:21 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=M82JTTe+49KEI9dV9umwG2X+L+hSwSH4u12eHXI/3/LRF8q1RyCfbGlDVdLaKp/ejpoHwloedr0ABqoAlcYsvUdoWXGE+L4Pgj2TVOs5iKUwHJPkfBopZ4QMm6gMBx+RdiDfuEPAUrC3EhE9quRNJaifmYbbhX4t0l6+ig09QPe/Zx3D9stpU8/njGzyAnu3afuPnUyINQFliOtuHGZg2LKuGTdpAASH3tJSW7MAkywK7giu6eAb9ThR3naUPf5UDfCHw2q5LC+OozQFOGlmLJTh9ZwkYKaI3G2Wmxi8XBRjwscWghYNDIA7RItPLtISrgKYp8M9znbN8Jvhraaybw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=t+vuKpwl5FmbcTMoxx6TPJaDBBiiBRgnBbke6s1pf3U=;
 b=ZJRSSZE9GhTA9SP4EIMBj6OP/z0BY9BUsX031MYw0H2MEGfdkuzXvY4VMkKhOCY9L1+VJMI3N5iiBu6edAOe9cUzF+FJncOkJ7JocPJ+K++pD2USyccnY+XaO7KhfaVWl2a2+i57ZBG76s2Jpz5R7M6pqTEl+RGbbEEbPF0evj0aiEHsM65flZDuhp1PmN7+prxImpAxAiOUv40M/7iD2Ix7cksPdvzyY6y7ZdsH8a4yBQwrl2oXRLEf+n+Ck8OoUoOIJN5PHo4B3aIsdI0hF+exKU9oHJ3FmCwtAZVYxYcYA77rK/SQbbqvW65p3X6grpQxhvYSyH8E/d5t6vwrMA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SA1PR11MB6733.namprd11.prod.outlook.com (2603:10b6:806:25c::17)
 by CY5PR11MB6308.namprd11.prod.outlook.com (2603:10b6:930:20::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5676.32; Mon, 10 Oct
 2022 20:43:19 +0000
Received: from SA1PR11MB6733.namprd11.prod.outlook.com
 ([fe80::6f83:c165:aa0c:efae]) by SA1PR11MB6733.namprd11.prod.outlook.com
 ([fe80::6f83:c165:aa0c:efae%6]) with mapi id 15.20.5676.032; Mon, 10 Oct 2022
 20:43:18 +0000
Date:   Mon, 10 Oct 2022 13:43:15 -0700
From:   Ira Weiny <ira.weiny@intel.com>
To:     Andrew Morton <akpm@linux-foundation.org>
CC:     <mm-commits@vger.kernel.org>, <viro@zeniv.linux.org.uk>,
        <tglx@linutronix.de>, <lkp@intel.com>, <hch@lst.de>,
        <fmdefrancesco@gmail.com>
Subject: Re: +
 highmem-fix-kmap_to_page-for-kmap_local_page-addresses-fix.patch added to
 mm-unstable branch
Message-ID: <Y0SD4w0V9BLlMtsh@iweiny-desk3>
References: <20221010201355.CF250C433D6@smtp.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20221010201355.CF250C433D6@smtp.kernel.org>
X-ClientProxiedBy: BY3PR05CA0001.namprd05.prod.outlook.com
 (2603:10b6:a03:254::6) To SA1PR11MB6733.namprd11.prod.outlook.com
 (2603:10b6:806:25c::17)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA1PR11MB6733:EE_|CY5PR11MB6308:EE_
X-MS-Office365-Filtering-Correlation-Id: ef4c1304-dc6b-4312-ebff-08daab001024
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: RH7PY+ui6sP78qiOqH8LtNISz9pkVXTFKVeVFR+YcnbBpVql+UZ4yD802D9evugW98e2MPf0qv128jLezLh1TUzCQt80Xqpxp1uPG3jOJPWqrpJoYiG51Pix8UDs2UNX7j7rDkn/hk/MhsivthZ7Xgki/BmcMrf+Qj4Nt2Phr3Sf7R78+nWBwxRgxrw6Ssssdx2WsLO3uu/eio0Na+9Y4/dzIMAceZY/Ktfvc6bcqOogpcLaGToQjIBr+0Lb589PQz5IdnY/9bI0H783OT/6pLpjs8rfgXvm679XHMhIPbfSGsm+jwQ5AXLQjZeOSOM9lzieiXgABcPeKs7/oNAW6qyfZIfQv41ltiimU9V2qMl1wlaFUtUeuRF6XUwZTrXmXMlmrV7kZHlqcIp6f2zgSNF0tQj7QdcZ71M/tNgB7lzwTIzIioDTDTZlfJJgK1dMb2XSY8ED2K2Oi/PpVPVJjCLafwJc4fTL2Dwyvk9rofd7vrXvKmyzMLU0vgDPalfevPD/9V6mc7HgnzFYKfGs+vzK4ims/3y4UZngjIyKcUfinjSsWLqC3V7XOl4b+j5Q9vLGNt0cDEksbu3CgeKbVLpF4q5dfCnsm72IlTtmgePGqo0h9BCTEObBcUB/ye8TNWHILGOECkSHwEelTn4fFyuBxf9x75yvO2v73hasogC+PGMLq7Gk+7DK+3/0WlHMAFrQUR2kLNjHvnkAoQL2+aTwNJHdgYMkNnB5DVQ8CKg=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR11MB6733.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(7916004)(39860400002)(346002)(366004)(136003)(396003)(376002)(451199015)(2906002)(66899015)(86362001)(5660300002)(6506007)(316002)(8936002)(6916009)(44832011)(66476007)(6666004)(66946007)(66556008)(966005)(41300700001)(8676002)(4326008)(478600001)(6486002)(82960400001)(83380400001)(38100700002)(33716001)(6512007)(26005)(186003)(9686003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?IAI+AVwCACUeOLZC09kvFcF0EB6Puq+dBEwvsgDetrtcnmJwgvH9jXFzZ9ln?=
 =?us-ascii?Q?PyScISZ45flvmJIgshL/St90TzHIXFgVWSAdNf9yvQcG2JhqZXZhKvbkmhHQ?=
 =?us-ascii?Q?P3HXKKUlZidtpkvQo77RwGLaslzWi/uDJiIvPNPrLNhgTJdAQXZwix+el3/R?=
 =?us-ascii?Q?E7EVZ12aGNpH8Ty+GpCfMu54j6oWye7CQCSzFvjv+erBzgeTIoWxdxSa3Bva?=
 =?us-ascii?Q?pvTKKDogBWgT5lQJMTiD9ABuTISMZv7UJ8qBuiNmWoYGunL2uIUCHJG9mn5d?=
 =?us-ascii?Q?Fu68PuUjONSvPXeHizjVnvzXt0ypyJiiM/X8qFZc/6uuKhnIQ9aFdqnvQcUO?=
 =?us-ascii?Q?KIFMlAX5hyRZy7ZoTx6tjY+WQOuBdOwBgyblqFgMEG04rrWso8yHbpjvoc2U?=
 =?us-ascii?Q?xAcfsUPekvjhA3r2qpnXvkB0Gfs9mh1RnC5LWruTISqvzIdBN1Mep6tQyjCW?=
 =?us-ascii?Q?1QJkahmDg2200LvPjRQ7RAkFyhS3hnIwu1OPm1XAFevPt4wc6/gHc8QjI0Zs?=
 =?us-ascii?Q?6uaYFP8H4tndaisBo2QGOvz3A95yT6Cuut8ShZMJAEXc4araBu6kr8nFPn81?=
 =?us-ascii?Q?S46lFcsjfDk5zjZa66aAk0T6wArA+IncazEq5gD6tcFVYiIhLMa1hnckyTh9?=
 =?us-ascii?Q?MyYiO+OldssUtS/Nc9Njb6jhFoH/BT+Kr0lcNdYcDflrQ4qUTPidOe9e0c/K?=
 =?us-ascii?Q?DX9uwrBR21Pf7ZX33mE2mdeZKMSARYGxlE5/fHUQL0lb35HUsOeLxubl/IX2?=
 =?us-ascii?Q?OXJVya22pdUd6F0CS2/rmM/pB9QONVrOoB9Zqb8N4rGonIRz/ukPLIfUyE+R?=
 =?us-ascii?Q?iTZDpjlvXlpIG08hANbSJfTl/A/Z3BcgrxBOkCKQTtE2jE/DyxyeCp7BxvFU?=
 =?us-ascii?Q?liYavWe9sxHKsn8RZYy7stQlLkuKQud31G3jcjzthFDEPhv4MxBwbqfN5tHV?=
 =?us-ascii?Q?Z+Q72nc9PCpf6Q5hRVvJELbaIvuXB//xl9KfWN3AMg9V39SeqYcpvcRZbaiQ?=
 =?us-ascii?Q?L2d/dzh3IEz5QyR+1U7zjHU1W1nI2/p8xQ/HjZ6LH4kmMwAcLLj5+mUFv21h?=
 =?us-ascii?Q?akGPFn4A/2sHku+ByILtQlOkmstmtTzbYvceEITPap3pHFp/82YtypBJseaI?=
 =?us-ascii?Q?t5fm/a+BFqrMVcAI9ez2U/ymqE2d6fq/e8vN8Ey6NaW8dfx20VfdmDirAdRR?=
 =?us-ascii?Q?l5fE5S/hxlZpDlIcyMN9DEmLCM4vP7bVrrCWeOCGchqltOP7yU7E2zr37xCV?=
 =?us-ascii?Q?ltiDV2g9NAATSfSdtKlR0baHhtBh6w6QXY34rpePCVfHOqXMdxpzGFC/l0jg?=
 =?us-ascii?Q?mgAHCZHSrwyTmNGjaIEBFnChlagsoh7DfqNTxY6Qo/Cj7VCq68dlMM6waEVi?=
 =?us-ascii?Q?W+11VBiyTyNrrYk2RFMBbVBU93YT/+Q8mCdbX0EUhCvLbncLw4rt0lFdtOxZ?=
 =?us-ascii?Q?cv09u2gdDa8G5dn5bizmaR5azoRjtF7xV8SBklxisMvfUqxv81F5TaD/vpYK?=
 =?us-ascii?Q?MaeMK5i1RcvKfK6xoOp78kbL/JFTRQsvMuS1z3jYZuDzzwMxjuyLDqvNC0gj?=
 =?us-ascii?Q?qCLDweqtK80ZoQ6IDRtzumVItRdYtxI8OkCc+l0F?=
X-MS-Exchange-CrossTenant-Network-Message-Id: ef4c1304-dc6b-4312-ebff-08daab001024
X-MS-Exchange-CrossTenant-AuthSource: SA1PR11MB6733.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Oct 2022 20:43:18.6957
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: EVcKEo+61lB9rbJaezRonLgvrTlYQflK0Tm3N68oT0MHCXHMTT7qxUd0UUJ6F9wgC16FrmTuxGCrm00uiSkp5Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR11MB6308
X-OriginatorOrg: intel.com
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

On Mon, Oct 10, 2022 at 01:13:54PM -0700, Andrew Morton wrote:
> 
> The patch titled
>      Subject: highmem-fix-kmap_to_page-for-kmap_local_page-addresses-fix
> has been added to the -mm mm-unstable branch.  Its filename is
>      highmem-fix-kmap_to_page-for-kmap_local_page-addresses-fix.patch
> 
> This patch will shortly appear at
>      https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/highmem-fix-kmap_to_page-for-kmap_local_page-addresses-fix.patch
> 
> This patch will later appear in the mm-unstable branch at
>     git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
> 
> Before you just go and hit "reply", please:
>    a) Consider who else should be cc'ed
>    b) Prefer to cc a suitable mailing list as well
>    c) Ideally: find the original patch on the mailing list and do a
>       reply-to-all to that, adding suitable additional cc's
> 
> *** Remember to use Documentation/process/submit-checklist.rst when testing your code ***
> 
> The -mm tree is included into linux-next via the mm-everything
> branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
> and is updated there every 2-3 working days
> 
> ------------------------------------------------------
> From: Andrew Morton <akpm@linux-foundation.org>
> Subject: highmem-fix-kmap_to_page-for-kmap_local_page-addresses-fix
> Date: Mon Oct 10 01:12:33 PM PDT 2022
> 
> fix warning
> 
> mm/highmem.c:164:7: warning: Local variable 'i' shadows outer variable [shadowVariable]
> 
> Reported-by: kernel test robot <lkp@intel.com>
> Cc: Al Viro <viro@zeniv.linux.org.uk>
> Cc: Christoph Hellwig <hch@lst.de>
> Cc: "Fabio M. De Francesco" <fmdefrancesco@gmail.com>
> Cc: Ira Weiny <ira.weiny@intel.com>
> Cc: kernel test robot <lkp@intel.com>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>

Thank you!  I've been meaning to get another version of the patch out.  But
I've been super busy today.

Reviewed-by: Ira Weiny <ira.weiny@intel.com>

Ira

> ---
> 
>  mm/highmem.c |    7 ++-----
>  1 file changed, 2 insertions(+), 5 deletions(-)
> 
> --- a/mm/highmem.c~highmem-fix-kmap_to_page-for-kmap_local_page-addresses-fix
> +++ a/mm/highmem.c
> @@ -160,11 +160,8 @@ struct page *__kmap_to_page(void *vaddr)
>  
>  	/* kmap() mappings */
>  	if (WARN_ON_ONCE(addr >= PKMAP_ADDR(0) &&
> -			 addr < PKMAP_ADDR(LAST_PKMAP))) {
> -		int i = PKMAP_NR(addr);
> -
> -		return pte_page(pkmap_page_table[i]);
> -	}
> +			 addr < PKMAP_ADDR(LAST_PKMAP)))
> +		return pte_page(pkmap_page_table[PKMAP_NR(addr)]);
>  
>  	/* kmap_local_page() mappings */
>  	if (WARN_ON_ONCE(base >= __fix_to_virt(FIX_KMAP_END) &&
> _
> 
> Patches currently in -mm which might be from akpm@linux-foundation.org are
> 
> hugetlb-take-hugetlb-vma_lock-when-clearing-vma_lock-vma-pointer-fix-2.patch
> highmem-fix-kmap_to_page-for-kmap_local_page-addresses-fix.patch
> 
