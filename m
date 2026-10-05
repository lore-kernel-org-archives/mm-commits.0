Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E4AA36B916
	for <mm-commits@vger.kernel.org>; Mon,  5 Oct 2026 07:41:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.18
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791186065; cv=fail; b=TmllQdsNgtwjSmEMOPpqrf451l+vO6otxaz1klHS5HZ0R2mDOt/X+jpVMZ5s51q+VUPjvzAuqFg4XXON6QWcyD9hPSAwHAWPb9RLBpAL+yybx2l1YoyTfuJLVnqtAVjMtRZNxDXii4usiolkb2q/MFdwblVZm7UuR4kgP9faFww=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791186065; c=relaxed/simple;
	bh=ffM8MmGov8haolxWrbPaplstN+PMuR+1tThjHrUeVOU=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=Put2GNOgPPSaPAmOznEcc6X0rYT5eI5JMManG5lPzrYWheyLIz/1z3hjo84dlRugCpw0QexZZ4KpmY+6ZOF+gYbnL672gTXj29oi8o3D5sYnaCBCAKLUfm321skTtD3JkLGSxUnq7fOyhlgvxjl/Ex09CG6Jkuxn1PujxIBunGQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=TCUPPW6X; arc=fail smtp.client-ip=198.175.65.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="TCUPPW6X"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1791186063; x=1822722063;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=ffM8MmGov8haolxWrbPaplstN+PMuR+1tThjHrUeVOU=;
  b=TCUPPW6Xf6YMwvd/wCZz0CaDX6L1+8W7pwh0lfnEUkF36YTdNE8g1Tyn
   GSpXkTOIjI3AjnnKML4xT+TYGu2xJeAF0c90zJZzl1Kf8r27WuaIvNFh1
   rSEPv1v8z8iOxd9bRxeax1cV2kAWd4Eju3xaxMSjf3MDkuTUGlHF7AvKR
   bOvgWSwHrZa5e3ROznPbPr9ykV3a4RuWBMbVgNAOEfDTziV2pHv4TQzDg
   xuw58aYiMH4qt/4Cpvuay1Lu19AiTQ5lXoY+EeyvgrptjxW/ycpTcDdgw
   4lDwAU3+N/cVylZGD7Qp+gf0+Iqgu7IrZZ06YOWCk6h+Rg9YUQYyIsQeT
   g==;
X-CSE-ConnectionGUID: djohD3PHRvallVafb3hmng==
X-CSE-MsgGUID: nLsbt7dISDKX6Q75fSv65A==
X-IronPort-AV: E=McAfee;i="6800,10657,11925"; a="90907016"
X-IronPort-AV: E=Sophos;i="6.27,141,1787036400"; 
   d="scan'208";a="90907016"
Received: from fmviesa011.fm.intel.com ([10.60.135.151])
  by orvoesa110.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Oct 2026 00:41:02 -0700
X-CSE-ConnectionGUID: +w65+lJhStW2dHUHk9QPzA==
X-CSE-MsgGUID: fi1cqwoITUyVfYgmbmflQA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,141,1787036400"; 
   d="scan'208";a="830160"
Received: from fmsmsx903.amr.corp.intel.com ([10.18.126.92])
  by fmviesa011.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Oct 2026 00:41:03 -0700
Received: from FMSMSX903.amr.corp.intel.com (10.18.126.92) by
 fmsmsx903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49; Mon, 5 Oct 2026 00:41:02 -0700
Received: from fmsedg903.ED.cps.intel.com (10.1.192.145) by
 FMSMSX903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49 via Frontend Transport; Mon, 5 Oct 2026 00:41:02 -0700
Received: from CO1PR03CU002.outbound.protection.outlook.com (52.101.46.54) by
 edgegateway.intel.com (192.55.55.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49; Mon, 5 Oct 2026 00:41:01 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=XX0q84CVznJIJJgXc9zlWZOjEaU/gjuOHji3uOq1uPVfGN7R7WlOSJuVP5IRuyBTCyqXmxnpZh0T3/vz/SCr0nS+ulbfAGu2YHScNf/CnNr0UO9Rusf2D9XZ7ZKf7/EE9pIT5rh179Ve97YyRuvaE0BAfzOXo37cwNWApn5FDpaC8OyDMH13ejXsgQVtGBHTqLFtft6v9YUnkfHWf0N1n4cOA3+dhQtEW6EeQ+GMKeMOAGJ3zrdk3Fldtr/4YPruMiPlORItOOxYby/yZ3kC1ORvfRdtfdaL/wyaJUfDA09FF9nZ7dZeR1ZVEC+RRJIj3HgGbQnO5YjK9WFEjw7HRA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=SQ7065eK7n6Zy1+IfHptngDs3cr/F7JXv2eaxh4NFSo=;
 b=gSazFnrk5Ud13CDLlQCB7Rsrb8Hx3gGtObJevJC72qBYD7R0820HFc7lSl8TLmXQomLn5OY9eEG7M1BaNJ7fhj/aCNrs8g6WfUA6lWEeBn/1tRNBPRg/H+V3t1Xmvb8dq/4+snDu/9+Tw2ro+MsbjDXuCEnEvFk18TXN82Pj7ofo3KjD2U4kH9nwlyZ2Qn5ttDF4CRblqXLQps+kcLDK5ZtmuiHyUy7IDYXojHb8dqGDDnoFlo+WhOXmdhWXOT3ZC5ZSpCsEfFleHXQE8EbiiuVI4OcTIvZZ6icXmHnqUWZvb4+/luEnrfkFqgDUe8JyDqsl4t/+YqMIDsPAOwnVSA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS6PR11MB362586.namprd11.prod.outlook.com (2603:10b6:8:4c4::14)
 by SA1PR11MB5947.namprd11.prod.outlook.com (2603:10b6:806:23b::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.451.25; Mon, 5 Oct
 2026 07:40:59 +0000
Received: from DS6PR11MB362586.namprd11.prod.outlook.com
 ([fe80::71a6:38f9:43ed:8f8a]) by DS6PR11MB362586.namprd11.prod.outlook.com
 ([fe80::71a6:38f9:43ed:8f8a%6]) with mapi id 15.21.0472.016; Mon, 5 Oct 2026
 07:40:59 +0000
Date: Mon, 5 Oct 2026 15:40:49 +0800
From: Philip Li <philip.li@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
CC: kernel test robot <lkp@intel.com>, David Hildenbrand <david@kernel.org>,
	Linux Memory Management List <linux-mm@kvack.org>,
	<mm-commits@vger.kernel.org>, Suren Baghdasaryan <surenb@google.com>
Subject: Re: [akpm-mm:mm-new] BUILD REGRESSION
 763ad0211c7b587344f03bc4d1299810aeb736f4
Message-ID: <asNUgRwsmaGWdsGf@rli9-mobl>
References: <202610040408.3LHzXZUE-lkp@intel.com>
 <20261003143826.be180aae972aa1e6a24956e7@linux-foundation.org>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20261003143826.be180aae972aa1e6a24956e7@linux-foundation.org>
X-ClientProxiedBy: KUZPR03CA0022.apcprd03.prod.outlook.com
 (2603:1096:d10:24::18) To DS6PR11MB362586.namprd11.prod.outlook.com
 (2603:10b6:8:4c4::14)
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS6PR11MB362586:EE_|SA1PR11MB5947:EE_
X-MS-Office365-Filtering-Correlation-Id: d2d8de84-5bcc-4d06-0ada-08df22b3ff5e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|23010399003|366016|56012099006|4143699003|10067099003|11063799006|22082099003|18002099003|6133799003;
X-Microsoft-Antispam-Message-Info: 2OKdzCsTemYjzdofcjbllXasVPpCHaqL86xFUWggMa+xpdykcztN+BrLZoDFMiaswIYwdmoI/wm+hzFc6NjZ+ib3jMR0BpOKKh5HUVVxaZSljCIk4HFK+W4nYrJO74VJdLtlKDx4dUgdDGDJw1yTyjqv0SjSw+vQWUVV8REn7JtBNtrahjzluwxeykGvchjYLQAQE5OawwzZ4g2VsVSBkPXJT0yRWwya+Yqqmr+sL5iJB2Dj7sABzbgUrOnKGwHeK4oI9oUeL8OoQiCh3X/L1izH/3ahJCITtPGwiYPPeAAYBJ1Ym42P1SYfGQfQgT87kOVCiPizvYfNMujLLWTlt3AEVBVCuYrPMRnv2u1/bH6QNgpmA87zFvQgiBInpMpOzVMvhEB+tGSdADmqoDfPhqhNsBMTWciTAC7im207fFUFc2o9DTIPZAvZs/2iiNw8v37zpGy5D9suNU1AXvXEmm97TcjrV3KrxJk5VNQeIpBdi2swNSOKXrtyQoluWKZqSrvpvm94/Ku6jvdRW7rL9G/RzXEDf7ZQkH1vpSdkTRn8fEiuWn0LoobGO9mNRU8LLcfUkfgh6DGRY8mfm2772I3UhqBVyM/cSMFpwbNBdAF/GS8OEoEi/kDQgSxLM1Wa
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS6PR11MB362586.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(23010399003)(366016)(56012099006)(4143699003)(10067099003)(11063799006)(22082099003)(18002099003)(6133799003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?8fWudmCWoX4icOd5nwCdzUo7GlD0EWJDUj6htxDBAskRGN7KsDr6kFWUdR1Q?=
 =?us-ascii?Q?cHDCR7YuoFSUFpbYY5BbLIbPpi/kex7/E6n4je/AD/kjzRAkTUDW+78PssQs?=
 =?us-ascii?Q?HP0u0Lp5yre/02jo5vAx/gsEzyNNjvwIGCKg7PBRr9ccQtOoR7/RwtWGvYZk?=
 =?us-ascii?Q?4+neMVPgwOF8JIKYgfuoxgxLraBR7zSPQBcolwuIRTlxvl1uEWIr5zCThaz2?=
 =?us-ascii?Q?qOzhng/OqRknPg3ujK5s37fhIORfITaVov6LG/Ev/SRLBWXuhxjQ845Yr+Li?=
 =?us-ascii?Q?s3UmgwO107ul2ia61MtnUhcBgjQQ+vwYNByKeH2ol300U8XcucuRnIcpLSx3?=
 =?us-ascii?Q?M1AJX6gi8QHl/eFzFF29lRdOhoxkU+66cDLAsZnzXqJgOZ1y9JGc1hGatJq+?=
 =?us-ascii?Q?usKVHBPLaqGPAXVreF1yGrl5Pj6tPEB5obPIit9nNwBYbY1J3s4TIt49pnWf?=
 =?us-ascii?Q?fedfNRS+5awkU3pqEZzIwnsv6UxsRcsypjyoeRZQdEWQXYJhB1gxYynhtShR?=
 =?us-ascii?Q?mwcxU5B+ChQgUzKhhBZUf32WwMshfAmhu2u0F9F7XLbkVKxabBdNy4qPOMH7?=
 =?us-ascii?Q?fM6UKJi7AkZXiL6xfOwffVGweattBjeAkTdy6eP6rYNn8gb9YQGpgIbiM/Xs?=
 =?us-ascii?Q?tkO5QXm/09n08rhiWnILakN97dKmjOMQ2a57yQJCDNs3288EjSIOCEbmlUpQ?=
 =?us-ascii?Q?wBNrb40FTL9UE7KW44fAdv78DvcFwc8DQuthzjCiaU8xwy6A+TL6J/vcg8hV?=
 =?us-ascii?Q?UoHZuJfJcqyqlKvinBDBNUCuiSAEN583y7yDA9vgVzfq5VZNOTYMzI+gpNUJ?=
 =?us-ascii?Q?OKh4hwOhJ2eGvmgWPpmPWYkO3SgDashdaH5UqLmmE/I+JX5lOa5+k4QztpKT?=
 =?us-ascii?Q?j8WjIA89Uq4zs/Y8dNQPHDaWJTFgcrlvV9EldxHtJFTkhIGDS1uS3lAQlz13?=
 =?us-ascii?Q?M0Ee6c11b2GCmPgwgkr1N3jYkros7dPdBy9kKUJos89gcxS3nZKZIM9nJfTY?=
 =?us-ascii?Q?SN9ED4yQEPqjZCBxYIcCqOMP7UzZyyJ1u9XX1JmDGQVJ3/ahvPNM8/X/Lc+p?=
 =?us-ascii?Q?czXoOvZ9I+olESoyh8uCjp62rjn991IaujHcbHwz+NUQrmLk1VUwAYrE/ce7?=
 =?us-ascii?Q?rzTGYaY0xhJeUwWWR+2ZERFNughnFoCJjGpMLddQ4I0n+3mB+j8VnP9HgbOi?=
 =?us-ascii?Q?ZRsFGHyIypo+C7Ujk4HUjSd+COljmiezIg5upNWTRvR2ABbt64GN24NSLyA0?=
 =?us-ascii?Q?jhuzOhgbbDIBK6fr91Puz0+hUphzJ2DJ3KC7aHCuHKxwvGPKzp6gOU2hxTN6?=
 =?us-ascii?Q?eJEYmUuf2hnK0/D2U9w8Og4I2X7MZn5o8M8zMPBbss8sQIJuWvCOzPirkaRq?=
 =?us-ascii?Q?6Pmfv0e2O9f9hQwmwnnBjfSkNaMObj7d3sZX++NpL9T88hPPC750NZLa1iMV?=
 =?us-ascii?Q?kGkvF9ImSCq4KLgi60eGvOxtvt9pp2BJ0v0u5CFUl/L/SRq/20YZ/UIaOu3E?=
 =?us-ascii?Q?9fZRwRwj5jaWAiYeX8pBvOYoW7A/cm5XfI0ZWe8Q+f4shYtPj4+JF0WiV2O1?=
 =?us-ascii?Q?WsG+zyMdWeoZF2szLIKMCTEe0a9nj0OwHM013Bura6QX3N9HUwRN8HYMtolY?=
 =?us-ascii?Q?nCFrTOUKNO2hLXdZ70s+Sbg7YVz/3GxVu9v1eeRtpVFkOzqcXvsYOXtb8CBZ?=
 =?us-ascii?Q?OVTmQpY9JP5ObgTFs9oSKUTIlIEQP6a2SYdhm4TWxE3kvWnPF+kbnVZAygJm?=
 =?us-ascii?Q?VaGd2NG90g=3D=3D?=
X-Exchange-RoutingPolicyChecked: W/lLjDmAjo/aopv423InWfDkIZAQax7RDsxma5sB3FghoVi4kZsZQV8WXtxYPqB9Rp6SFJu37DKkqlVzuzfTMiKBtBYR9k1CGLLxmhLYC9liwBiR0UVWwlg75D1m7CZBzHAHcYp55EoyU4TjcqFTwydPoIDGQmcj9nIml4vYt+EXmIaiemrsqDPWcT33D4IfMrRHVOaigtkVuoNqipZ1hDSdA86CLNpocSlUAayp5ZL/FHqWX4+iSbMW/EHxqPZ76VIzvZjHc3csq1/BRyWo6MicjYK/z3mxmDGym283yt1hgZAjQNJj7rpQoIghDOeHho+89AkoCmRUcrJgZZemhg==
X-MS-Exchange-CrossTenant-Network-Message-Id: d2d8de84-5bcc-4d06-0ada-08df22b3ff5e
X-MS-Exchange-CrossTenant-AuthSource: DS6PR11MB362586.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Oct 2026 07:40:59.0147
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: makU9WM5zrHu+T+ZzEtWRrb5LDiJIyopH/J+PZIgdPDlUEAOCHnyKG1wuwhSdTVDsMZUXk5X5lPRWkFO+envIw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR11MB5947
X-OriginatorOrg: intel.com

On Sat, Oct 03, 2026 at 02:38:26PM -0700, Andrew Morton wrote:
> On Sun, 04 Oct 2026 04:27:12 +0800 kernel test robot <lkp@intel.com> wrote:
> 
> > tree/branch: https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-new
> > branch HEAD: 763ad0211c7b587344f03bc4d1299810aeb736f4  mm/swap, PM: hibernate: atomically replace hibernation pin
> > 
> > Unverified Error/Warning (likely false positive, kindly check if interested):
> > 
> >     https://lore.kernel.org/oe-kbuild/202609121707.Hya5cxAX-lkp@intel.com
> >     https://lore.kernel.org/oe-kbuild/202609151628.hydefVEV-lkp@intel.com
> > 
> >     drivers/scsi/sg.c:294:1-17: ERROR: sg_fops: .read() can deadlock .write(); change nonseekable_open -> stream_open to fix.
> >     fs/proc/task_mmu.c:1427 show_smaps_rollup() warn: 'vma' is an error pointer or valid
> 
> It would help if these reports told us which tool emitted the warning. 

Sorry for confusion, I will enhance the report to show the tool clearly
and show better connection between the report url and issue.

So far, it is not that direct, which need open the report link for the tool
chain

  - it is smatch for 202609121707.Hya5cxAX-lkp@intel.com report as you
    mentioned below ""

  - and it is cocci for another 202609151628.hydefVEV-lkp@intel.com report
    regarding "drivers/scsi/sg.c:294:1-17: ERROR: sg_fops: .read() can deadlock .write()"

BTW: both reports are unverified yet, which could be false positive.

Thanks

> This one was smatch.
> 
> 
> "proc/task_mmu: read proc/pid/smaps_rollup under per-vma lock" has:
> 
> 	vma_iter_init(&priv->iter, mm, 0);
> 	vma = proc_get_vma(m, &pos);
> 	if (unlikely(!vma))
> 		goto empty_set;
> 
> 	if (!IS_ERR(vma))
> 		vma_start = vma->vm_start;
> 
> 	while (vma) {
> 		if (IS_ERR(vma)) {
> 			ret = PTR_ERR(vma);
> 			goto out_unlock;
> 		}
> 
> The code is funky-looking but I think it correctly handles all three
> cases: NULL, IS_ERR, valid vma*.
> 
> 
> > Error/Warning ids grouped by kconfigs:
> > 
> > recent_errors
> > |-- alpha-randconfig-r2107-20261003
> > |   `-- drivers-scsi-sg.c:ERROR:sg_fops:read()-can-deadlock-write()-change-nonseekable_open-stream_open-to-fix.
> > |-- alpha-randconfig-r2200-20261003
> > |   `-- fs-proc-task_mmu.c-show_smaps_rollup()-warn:vma-is-an-error-pointer-or-valid
> > |-- i386-randconfig-2103-20261003
> > |   `-- drivers-scsi-sg.c:ERROR:sg_fops:read()-can-deadlock-write()-change-nonseekable_open-stream_open-to-fix.
> > |-- nios2-randconfig-r2202-20261003
> > |   `-- fs-proc-task_mmu.c-show_smaps_rollup()-warn:vma-is-an-error-pointer-or-valid
> > |-- powerpc-randconfig-r2201-20261003
> > |   `-- fs-proc-task_mmu.c-show_smaps_rollup()-warn:vma-is-an-error-pointer-or-valid
> > |-- powerpc64-randconfig-r2101-20261003
> > |   `-- drivers-scsi-sg.c:ERROR:sg_fops:read()-can-deadlock-write()-change-nonseekable_open-stream_open-to-fix.
> > |-- x86_64-randconfig-2100-20261003
> > |   `-- drivers-scsi-sg.c:ERROR:sg_fops:read()-can-deadlock-write()-change-nonseekable_open-stream_open-to-fix.
> > `-- x86_64-randconfig-2200-20261003
> >     `-- fs-proc-task_mmu.c-show_smaps_rollup()-warn:vma-is-an-error-pointer-or-valid
> > 
> > elapsed time: 882m
> > 
> > configs tested: 200
> > configs skipped: 13
> > 
> > tested configs:
> > alpha                              allnoconfig    gcc-16.1.0
> > alpha                             allyesconfig    gcc-16.1.0
> > alpha                                defconfig    gcc-16.1.0
> > alpha                                defconfig    gcc-16.1.0
> > alpha                randconfig-r2105-20261003    gcc-8.5.0  cocci
> > alpha                randconfig-r2107-20261003    gcc-8.5.0  cocci
> > alpha                randconfig-r2200-20261003    gcc-8.5.0  smatch
> > arc                               allmodconfig    gcc-16.1.0
> > arc                                allnoconfig    gcc-16.1.0
> > arc                               allyesconfig    gcc-16.1.0
> > arc                       axs103_smp_defconfig    gcc-16.1.0
> > arc                                  defconfig    gcc-16.1.0
> > arc                   randconfig-1000-20261003    gcc-13.4.0
> > arc                   randconfig-1001-20261003    gcc-11.5.0
> > arc                  randconfig-r2100-20261003    gcc-8.5.0  cocci
> > arm                                allnoconfig    clang-17
> > arm                          at91_dt_defconfig    clang-17
> > arm                                  defconfig    clang-24
> > arm                   randconfig-1000-20261003    clang-17
> > arm                   randconfig-1001-20261003    clang-24
> > arm                   randconfig-1002-20261003    gcc-11.5.0
> > arm                   randconfig-1003-20261003    gcc-8.5.0
> > arm                          wpcm450_defconfig    gcc-16.1.0
> > arm64                              allnoconfig    gcc-16.1.0
> > arm64                                defconfig    gcc-16.1.0
> > arm64                 randconfig-1000-20261003    gcc-10.5.0
> > arm64                 randconfig-1001-20261003    clang-17
> > arm64                 randconfig-1002-20261003    clang-17
> > arm64                 randconfig-1003-20261003    gcc-8.5.0
> > arm64                randconfig-r2106-20261003    clang-24   cocci
> > csky                              allmodconfig    gcc-16.1.0
> > csky                               allnoconfig    gcc-16.1.0
> > csky                                 defconfig    gcc-16.1.0
> > csky                  randconfig-1000-20261003    gcc-9.5.0
> > csky                  randconfig-1001-20261003    gcc-11.5.0
> > hexagon                           allmodconfig    clang-24
> > hexagon                            allnoconfig    clang-24
> > hexagon                              defconfig    clang-24
> > hexagon               randconfig-1000-20261003    clang-17
> > hexagon               randconfig-1001-20261003    clang-24
> > i386                              allmodconfig    gcc-14
> > i386                               allnoconfig    gcc-14
> > i386        buildonly-randconfig-1000-20261003    gcc-14
> > i386        buildonly-randconfig-1001-20261003    clang-22
> > i386        buildonly-randconfig-1002-20261003    clang-22
> > i386        buildonly-randconfig-1003-20261003    clang-22
> > i386        buildonly-randconfig-1004-20261003    clang-22
> > i386        buildonly-randconfig-1005-20261003    clang-22
> > i386                                 defconfig    clang-22
> > i386                  randconfig-1000-20261003    clang-22
> > i386                  randconfig-1001-20261003    clang-22
> > i386                  randconfig-1002-20261003    clang-22
> > i386                  randconfig-1003-20261003    clang-22
> > i386                  randconfig-1004-20261003    clang-22
> > i386                  randconfig-1005-20261003    clang-22
> > i386                  randconfig-1006-20261003    gcc-14
> > i386                  randconfig-2100-20261003    gcc-14     cocci
> > i386                  randconfig-2101-20261003    clang-22   cocci
> > i386                  randconfig-2102-20261003    gcc-14     cocci
> > i386                  randconfig-2103-20261003    clang-22   cocci
> > i386                  randconfig-2200-20261003    gcc-14     smatch
> > i386                  randconfig-2300-20261003    clang-22   sparse
> > i386                  randconfig-2301-20261003    gcc-14     sparse
> > i386                  randconfig-2302-20261003    gcc-14     sparse
> > loongarch                          allnoconfig    clang-20
> > loongarch                            defconfig    clang-24
> > loongarch             randconfig-1000-20261003    gcc-14.3.0
> > loongarch             randconfig-1001-20261003    gcc-16.1.0
> > loongarch            randconfig-r2304-20261003    gcc-13.4.0 sparse
> > m68k                              allmodconfig    gcc-16.1.0
> > m68k                               allnoconfig    gcc-16.1.0
> > m68k                              allyesconfig    gcc-16.1.0
> > m68k                                 defconfig    gcc-16.1.0
> > m68k                         stmark2_defconfig    gcc-16.1.0
> > microblaze                         allnoconfig    gcc-16.1.0
> > microblaze                        allyesconfig    gcc-16.1.0
> > microblaze                           defconfig    gcc-16.1.0
> > mips                               allnoconfig    gcc-16.1.0
> > mips                              allyesconfig    gcc-16.1.0
> > mips                          db1xxx_defconfig    clang-24
> > mips                 randconfig-r2102-20261003    gcc-13.4.0 cocci
> > mips                 randconfig-r2305-20261003    gcc-8.5.0  sparse
> > mips                        rbtx49xx_defconfig    gcc-16.1.0
> > nios2                             allmodconfig    gcc-11.5.0
> > nios2                              allnoconfig    gcc-11.5.0
> > nios2                                defconfig    gcc-11.5.0
> > nios2                 randconfig-1000-20261003    gcc-9.5.0
> > nios2                 randconfig-1001-20261003    gcc-11.5.0
> > nios2                randconfig-r2202-20261003    gcc-8.5.0  smatch
> > nios2                randconfig-r2307-20261003    gcc-11.5.0 sparse
> > openrisc                          allmodconfig    gcc-16.1.0
> > openrisc                           allnoconfig    gcc-16.1.0
> > openrisc                             defconfig    gcc-16.1.0
> > parisc                            allmodconfig    gcc-16.1.0
> > parisc                             allnoconfig    gcc-16.1.0
> > parisc                            allyesconfig    gcc-16.1.0
> > parisc                               defconfig    gcc-16.1.0
> > parisc                randconfig-1000-20261003    gcc-11.5.0
> > parisc                randconfig-1001-20261003    gcc-8.5.0
> > parisc               randconfig-r2103-20261003    gcc-8.5.0  cocci
> > parisc               randconfig-r2306-20261003    gcc-9.5.0  sparse
> > parisc64                             defconfig    gcc-16.1.0
> > powerpc                            allnoconfig    gcc-16.1.0
> > powerpc               randconfig-1000-20261003    gcc-12.5.0
> > powerpc               randconfig-1001-20261003    gcc-8.5.0
> > powerpc              randconfig-r2201-20261003    clang-17   smatch
> > powerpc              randconfig-r2309-20261003    clang-21   sparse
> > powerpc64             randconfig-1000-20261003    clang-24
> > powerpc64             randconfig-1001-20261003    clang-22
> > powerpc64            randconfig-r2101-20261003    gcc-13.4.0 cocci
> > riscv                              allnoconfig    gcc-16.1.0
> > riscv                                defconfig    clang-24
> > riscv                 randconfig-1000-20261003    clang-24
> > riscv                 randconfig-1001-20261003    clang-24
> > riscv                 randconfig-2000-20261003    clang-17
> > riscv                 randconfig-2001-20261003    gcc-9.5.0
> > riscv                randconfig-r2308-20261003    gcc-15.2.0 sparse
> > s390                              allmodconfig    clang-24
> > s390                               allnoconfig    clang-24
> > s390                                 defconfig    clang-18
> > s390                  randconfig-1000-20261003    gcc-12.5.0
> > s390                  randconfig-1001-20261003    clang-24
> > s390                  randconfig-2000-20261003    clang-24
> > s390                  randconfig-2001-20261003    gcc-13.4.0
> > s390                 randconfig-r2104-20261003    clang-17   cocci
> > sh                                allmodconfig    gcc-16.1.0
> > sh                                 allnoconfig    gcc-16.1.0
> > sh                                allyesconfig    gcc-16.1.0
> > sh                                   defconfig    gcc-16.1.0
> > sh                    randconfig-1000-20261003    gcc-9.5.0
> > sh                    randconfig-1001-20261003    gcc-15.2.0
> > sh                    randconfig-2000-20261003    gcc-16.1.0
> > sh                    randconfig-2001-20261003    gcc-16.1.0
> > sh                   randconfig-r2302-20261003    gcc-12.5.0 sparse
> > sparc                              allnoconfig    gcc-16.1.0
> > sparc                                defconfig    gcc-16.1.0
> > sparc                 randconfig-1000-20261003    gcc-8.5.0
> > sparc                 randconfig-1001-20261003    gcc-8.5.0
> > sparc                 randconfig-2000-20261003    gcc-16.1.0
> > sparc                 randconfig-2001-20261003    gcc-16.1.0
> > sparc64                           allmodconfig    clang-20
> > sparc64                              defconfig    clang-24
> > sparc64               randconfig-1000-20261003    gcc-16.1.0
> > sparc64               randconfig-1001-20261003    clang-24
> > sparc64               randconfig-2000-20261003    gcc-8.5.0
> > sparc64               randconfig-2001-20261003    gcc-8.5.0
> > um                                allmodconfig    clang-17
> > um                                 allnoconfig    clang-17
> > um                                allyesconfig    gcc-14
> > um                                   defconfig    clang-24
> > um                              i386_defconfig    gcc-14
> > um                    randconfig-1000-20261003    clang-17
> > um                    randconfig-1001-20261003    clang-22
> > um                    randconfig-2000-20261003    clang-24
> > um                    randconfig-2001-20261003    gcc-14
> > um                            x86_64_defconfig    clang-24
> > x86_64                             allnoconfig    clang-22
> > x86_64      buildonly-randconfig-1000-20261003    clang-22
> > x86_64      buildonly-randconfig-1001-20261003    gcc-14
> > x86_64      buildonly-randconfig-1002-20261003    clang-22
> > x86_64      buildonly-randconfig-1003-20261003    gcc-14
> > x86_64      buildonly-randconfig-1004-20261003    clang-22
> > x86_64      buildonly-randconfig-1005-20261003    gcc-14
> > x86_64                               defconfig    gcc-14
> > x86_64                randconfig-1000-20261003    clang-22
> > x86_64                randconfig-1001-20261003    clang-22
> > x86_64                randconfig-1002-20261003    clang-22
> > x86_64                randconfig-1003-20261003    gcc-13
> > x86_64                randconfig-1004-20261003    clang-22
> > x86_64                randconfig-1005-20261003    clang-22
> > x86_64                randconfig-1006-20261003    gcc-14
> > x86_64                randconfig-1007-20261003    gcc-14
> > x86_64                randconfig-1008-20261003    gcc-14
> > x86_64                randconfig-1009-20261003    clang-22
> > x86_64                randconfig-1010-20261003    gcc-14
> > x86_64                randconfig-1011-20261003    clang-22
> > x86_64                randconfig-1012-20261003    clang-22
> > x86_64                randconfig-1013-20261003    gcc-12
> > x86_64                randconfig-1014-20261003    gcc-14
> > x86_64                randconfig-1015-20261003    gcc-14
> > x86_64                randconfig-1016-20261003    clang-22
> > x86_64                randconfig-1017-20261003    gcc-14
> > x86_64                randconfig-2100-20261003    clang-22   cocci
> > x86_64                randconfig-2101-20261003    clang-22   cocci
> > x86_64                randconfig-2102-20261003    gcc-14     cocci
> > x86_64                randconfig-2103-20261003    gcc-13     cocci
> > x86_64                randconfig-2200-20261003    gcc-14     smatch
> > x86_64                randconfig-2300-20261003    gcc-14     sparse
> > x86_64                randconfig-2301-20261003    gcc-14     sparse
> > x86_64                randconfig-2302-20261003    clang-22   sparse
> > x86_64               randconfig-r2300-20261003    clang-22   sparse
> > x86_64               randconfig-r2301-20261003    gcc-14     sparse
> > x86_64                           rhel-9.4-rust    clang-22
> > xtensa                             allnoconfig    gcc-16.1.0
> > xtensa                            allyesconfig    gcc-16.1.0
> > xtensa                   nommu_kc705_defconfig    gcc-16.1.0
> > xtensa                randconfig-1000-20261003    gcc-15.2.0
> > xtensa                randconfig-1001-20261003    gcc-9.5.0
> > xtensa                randconfig-2000-20261003    gcc-8.5.0
> > xtensa                randconfig-2001-20261003    gcc-10.5.0
> > 
> > --
> > 0-DAY CI Kernel Test Service
> > https://github.com/intel/lkp-tests/wiki
> 
