Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8BCF3002DA
	for <mm-commits@vger.kernel.org>; Thu,  4 Sep 2025 13:25:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.18
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756992360; cv=fail; b=D0fZ5hoa1OOtCmIJpJpS/F5qiF8jmv5p4TE76U0kbWgiB0bsKSCRov2XRjTmFpk1Kv7IwOiSN6fM/Cn8pHYk0pUrIIAqOIrO34hKltNF/3V7nTQwn+YbpbT2Ljfnhz6KXxGxiJFkgkKb9SW2B89ZCJfxu8CMJajpp824rpj6gww=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756992360; c=relaxed/simple;
	bh=7uO2Nh8q8+/UWrSCJOTJuRgDvPv4wiYHXSa4Yb1D2cc=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=ZFA6y9jdm1BT+oxfJqqRDA02Nicxz8OPrqIghLhJilN2dwr3zLyWaxeIF0zynEBB3XnlCsJEx2HryIwE/YhQW4Ri7KhGd3EQlLxjvyzej0x0l0Ltfyz4PWI+E8KL/3uRhvYfr/QEcqGZohA6+il5gk4PWtsRP64CdZFB4SamoIU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=iKyh4tmJ; arc=fail smtp.client-ip=192.198.163.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="iKyh4tmJ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1756992358; x=1788528358;
  h=date:from:to:cc:subject:message-id:references:
   content-transfer-encoding:in-reply-to:mime-version;
  bh=7uO2Nh8q8+/UWrSCJOTJuRgDvPv4wiYHXSa4Yb1D2cc=;
  b=iKyh4tmJfiiClWnw95iLYLfLhr/mErTvBjXrO4D+fGr6j5qH7F26NdBF
   FbKk3yVET3afizeRy+CRMAT10hEKK2C67qJ4nArxRk3BJMxa6MPChtpfG
   ZB9s93WDzfxtcO82KeGj5kQDwAFpxQvCW7ZJ4u76OFeBgRThc+p9pT0uO
   Hx9xniLMG46ydfTYBUQqzp0Ie257kS/FQ4DxNcEqGk/AzcSNij7AEXJPW
   qlnyaJj/TZDv8BRkEKpv0Y4PrjFnRdU3oS8Ma+x3arNoKaXNM1qSW9Bs/
   pXhLfU0WmamDanjKnhRjDM3/enMEZ48JSDfmgYOPUcmSXtnxhS/xk4NFY
   g==;
X-CSE-ConnectionGUID: lGDirLGsTbi7MP0WBx9h1w==
X-CSE-MsgGUID: QUPotv9YQfaLvl86dmHZ0A==
X-IronPort-AV: E=McAfee;i="6800,10657,11542"; a="58543088"
X-IronPort-AV: E=Sophos;i="6.18,238,1751266800"; 
   d="scan'208";a="58543088"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Sep 2025 06:25:57 -0700
X-CSE-ConnectionGUID: EgdDc0iZSyCuEBcN89bzDw==
X-CSE-MsgGUID: p9psciUBSQ2Y9zolOVgE4w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,238,1751266800"; 
   d="scan'208";a="171128696"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by orviesa006.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Sep 2025 06:25:57 -0700
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Thu, 4 Sep 2025 06:25:56 -0700
Received: from ORSEDG903.ED.cps.intel.com (10.7.248.13) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17 via Frontend Transport; Thu, 4 Sep 2025 06:25:56 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (40.107.236.55)
 by edgegateway.intel.com (134.134.137.113) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Thu, 4 Sep 2025 06:25:56 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=I0lxqy81XF79QTGjYe9jtKUQWb49/c/UnQh2CSv7E3gdv58SVGhs0WFXfSJ8Hzpc0lkOWNEhUznF40Su0Ik+dJFiS3XSrG3Qg05y+HnhDDpJZSha7gMKu0SiesM1mkLinRnfRwfAG4RdypDqOWof1mlyAhxPKC7MJMupsEZaoZV/N2i3Ev7iGxwbTPEMIOw0IPkzSh6qXwPDwRna93dXpMfFhnDLxtMQTzHvQ+rA3/PVKDfbR93dAkQ5akaRznb6LWaTrj0RYviqOjNIiJUyegD+OJWfIBE/yO7XMqshz6zzx/fXGSg3/04cPWs2QkJOP37eKtqjDCj/eIRcHViIkg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PMplQYDmM89+xZnKewaAgyofR7/+U+oTX1qOksIjpes=;
 b=SsMGcu/Bh5WNqYn+lBVdpGaWGrR6lw/nP4P9wfk7Gu4o+DPzci3HN8zvBrk4B1pkFGaB2zPE47/dpfplFJyi1lnptkDOgT7QJ00fsjWnYnJybBAL20P5JZckY9Mz8Y/ok3EzLyAACfERBisQiOXy3OYC7XbiPXCcYygXAexFpkbNlo6iefyjh4p2gqbTkgN6YJpnfo3nK3J8WSl+HRYRidgHFAJyVr8/JVLmXO68hAmudq+E1zcDzEctfY2AMlU2AEG/olWYlCrWrV3i/GmIFM5QzHUWZMV6WsiaWjyk3+17HpAknscetNQ2ZZzlGxMLe0uWg/0G8x3aOv22c40Thw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CY8PR11MB7828.namprd11.prod.outlook.com (2603:10b6:930:78::8)
 by IA1PR11MB8829.namprd11.prod.outlook.com (2603:10b6:208:59b::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9073.27; Thu, 4 Sep
 2025 13:25:53 +0000
Received: from CY8PR11MB7828.namprd11.prod.outlook.com
 ([fe80::5461:fa8c:58b8:e10d]) by CY8PR11MB7828.namprd11.prod.outlook.com
 ([fe80::5461:fa8c:58b8:e10d%4]) with mapi id 15.20.9073.026; Thu, 4 Sep 2025
 13:25:53 +0000
Date: Thu, 4 Sep 2025 15:25:46 +0200
From: Francois Dugast <francois.dugast@intel.com>
To: Matthew Brost <matthew.brost@intel.com>
CC: <airlied@gmail.com>, <akpm@linux-foundation.org>, <apopple@nvidia.com>,
	<balbirs@nvidia.com>, <christian.koenig@amd.com>, <jgg@nvidia.com>,
	<leonro@nvidia.com>, <mm-commits@vger.kernel.org>, <mpenttil@redhat.com>,
	<thomas.hellstrom@linux.intel.com>, <ziy@nvidia.com>
Subject: Re: [PATCH] mm/hmm: populate PFNs from PMD swap entry
Message-ID: <aLmTWhL36_ciqajA@fdugast-desk>
References: <aLbotHsTPaqk50fK@fdugast-desk>
 <20250902130713.1644661-1-francois.dugast@intel.com>
 <aLfWfB1wjX1y1T5d@lstrano-desk.jf.intel.com>
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <aLfWfB1wjX1y1T5d@lstrano-desk.jf.intel.com>
Organization: Intel Corporation
X-ClientProxiedBy: WA0P291CA0002.POLP291.PROD.OUTLOOK.COM
 (2603:10a6:1d0:1::29) To CY8PR11MB7828.namprd11.prod.outlook.com
 (2603:10b6:930:78::8)
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY8PR11MB7828:EE_|IA1PR11MB8829:EE_
X-MS-Office365-Filtering-Correlation-Id: 06c81081-9a09-47b5-aee6-08ddebb69274
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014|7416014|7053199007;
X-Microsoft-Antispam-Message-Info: =?iso-8859-1?Q?XLlng2Bh83FlvDI9EARv5aeHm0jqdBh5aekgsMT853oz0GyQux37PwLDWI?=
 =?iso-8859-1?Q?8cCC47sHZ+t8jPwwBWar7zQxyBLmtLhRSgbKFNLfhbwuIf8ggfAqMVCrb8?=
 =?iso-8859-1?Q?99r/Qn47yqA88WZiHanPMFul1wTKHZ38wPNx1HP+HM9+UW2C2CLUD0mvNB?=
 =?iso-8859-1?Q?K3IVPjJxXaj7KeSfsfSA657Nx5j5mbWqEJfNOceFe3YLdZWN/H1rB0oXhF?=
 =?iso-8859-1?Q?NcDVr2JQjyU8cUvPqR5ZDRM2L4ge63aPem1bVNtbEQDRp3pXJlQxTh5reT?=
 =?iso-8859-1?Q?mFip+mUzo9PjXzUC7rri3wnR24S9HO2U/P+pSr0Plcb4cm/Qq4XPwUd18N?=
 =?iso-8859-1?Q?PAAQUEgPI3OPXVMIq904Wt0FZTL8lA8x7k54cHrMpQknyNqXYtRmomp9xz?=
 =?iso-8859-1?Q?MkEFx1YLwJyVVs229fiqDPlc74eIc7BA8Gk2CFNJzC43hIL/MkDm6q6SdU?=
 =?iso-8859-1?Q?X4UlJmOPF8tIue696gZqn/Y3/7qnHQM7tvqu0jfV8sAcA1PakRTM0l6iAQ?=
 =?iso-8859-1?Q?PLsTbQJU73/rHp9hDsatx8Fv9mN01Vln4fQZ1B8/BGNdCEL9PL6kmOO4cF?=
 =?iso-8859-1?Q?9dc6PBXo0F8zaL7WsL9xMn0oCQ+0MgkHsO7O30TVjNksbjFKY+rdtgXqeu?=
 =?iso-8859-1?Q?Cr/V9fqLD/+eh2e+h8HJTUBGyYANwExyQxucQueMUxD0Upn0EjmvcvPLX1?=
 =?iso-8859-1?Q?2kMsOaeM6qUL3uPYcVpfH43n4WfXMj9YtX+eUYCaIzQgrtFWkK0g/RvaLd?=
 =?iso-8859-1?Q?mJFdpGy205JTF4H48r87txJQfvBpCNxywifmHsnG+U2yFDIRTXrl1y9o8I?=
 =?iso-8859-1?Q?mohTANXcVXZx3bWEjvZ/FHIfo9I/sS7EUQfqlYF6xEjPEW9gmnAagc8huZ?=
 =?iso-8859-1?Q?yNy7ggUeLXXp2x9bfqqJezmiiMEuW2R7uSYic9plnsy9CYbzyTbQwTm3A2?=
 =?iso-8859-1?Q?6kuIsxTWiVS/+4bKCIewIkXRitGpLoJqbo9tNOa5VW0x6t6gJlkyOSxQxr?=
 =?iso-8859-1?Q?LR45qMAq/IFsS7B6xVCfA5xsqydQJsV05YV/PnaJHWPWdVpqeimeSoVy2v?=
 =?iso-8859-1?Q?s6oP+hT5koBmy4HvzBvKan28Se9jni1369bzzP/qh7Pm0T1RQiLMp1kDB2?=
 =?iso-8859-1?Q?sEKMNfkF4KcIyxenWu+dP4sAc0PCxI7uwOfTLGRfrXWEJchWprn0oUHrSJ?=
 =?iso-8859-1?Q?ei58bSkyXwFc1t+ZRJY5AYcLTepRi1YceGJk6nDaDvD2HDoO8XIvSD3hue?=
 =?iso-8859-1?Q?HXDpXvlnfbcifombu+tbIOKk3kLLmvH56uXF5ZAm4z2GJenpW9jBVkpdDm?=
 =?iso-8859-1?Q?QE1slp5ulsNgV9rGtozwNnMpDzKiGah/ayd1Ae1w80pVBmTMDdaHrsKMDm?=
 =?iso-8859-1?Q?r5rUTPKu34MUcBRj67mNWoohzJEFc9JhZHqz5Phzs6pFyWMKkc3Xc=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY8PR11MB7828.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7416014)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?iso-8859-1?Q?+qJZ3QCL6Ri+A2EK11MMWSQy5ZeCh9fUn2UDN+XX3GBuV6vYzjOOWBMh4h?=
 =?iso-8859-1?Q?Jue4lcD8hzRLKb4LN9al+hPpXCbogcQluhw5jiJIqHV1pyatEdsqUdRT0K?=
 =?iso-8859-1?Q?UcATIk/R3HNUh6EkKoc8RHDKAS0I+M2gYLRIe+cEZlFmk9RQ13qPBlgCxf?=
 =?iso-8859-1?Q?YoQDQGDde80rYoLp+OQNvjq2PZotlJqxzuOGuLtAkG6BDU0qKS6/c/av0H?=
 =?iso-8859-1?Q?SYXNH96ZLwnLC0ReMJGFrSzd6+fHErICPf4YkzojX1nKfe5sfpG0r6QbGn?=
 =?iso-8859-1?Q?RPqzLicaO3p84SJAVigSFuE/ebTdVmo9UFbdz2bbP6+tfcyWqDn+uLHHev?=
 =?iso-8859-1?Q?oTv19bFI/M3333C+IxxDTUvRQ2c9ZXekJ6xbYnsEYLJWldl/Hr/5oo8LV/?=
 =?iso-8859-1?Q?PjHknDjp7NSRiLAOiZRkkyd8p5rsFotfu7RPMDanIWI91LZ+BKLN872u7L?=
 =?iso-8859-1?Q?uwpdFkP3m2VmKMrakeeNu1aWgCSCnimlp4lncyujf8OCKMEFLg4C2wXA7N?=
 =?iso-8859-1?Q?6cvueAn8Eq8HctiAAzaGZnA+HyNQdOkLEkdwNKyXyVzmp0hw1nltp9K2D1?=
 =?iso-8859-1?Q?D8/J1gxHzzvymATzJ2Xp/x2iI/uno3+w2jlddJm3uFvwvESGgtrh3xolsX?=
 =?iso-8859-1?Q?9oddEhtHsGUHdLTFFmy5Ff4u7HlBju0lPw9ekTJJovwnF3lBoo/blh4mBv?=
 =?iso-8859-1?Q?5i3ujuqDYmXDEjGh3KYV+CPS5sepLEd+NHCK0hts6MOnAhtcsqSen/+bGJ?=
 =?iso-8859-1?Q?ersNzVlUsn8HZMmeh6mN7KmLm9EZU720zLKGV3K3pblHEv3YHLkdZqe9MT?=
 =?iso-8859-1?Q?vj54ViPFQnO2z+hO7gOPQs9Cl+8BfJLM9PLuh82C9ba2mWsvdbvmc7KEd/?=
 =?iso-8859-1?Q?uaOA+eHPyn0P/cZyJnDEGvq4hpYsN31YW1mnKZfCTASHwSokSLgasfYsdy?=
 =?iso-8859-1?Q?m37WB365J/svhcwTclHGf5jfPhIWK1OSj7HqvO3DlBXpvIKQVbIkK5EJnV?=
 =?iso-8859-1?Q?sMZCdr1u8AxB8AX8UVsaKsuZbwB4zGbn+3Y0w+BhOe4LMYJjQfVJceh45i?=
 =?iso-8859-1?Q?SqwQQDuVRX60B7Y9xJ2MHpA2u2La9u04dxU4F6wpujvyyTlcNhjDONmDvY?=
 =?iso-8859-1?Q?bj4dl5mFoFr2LJ1rwhn4CGGzkyoZ31D+JPXmESjavw2EDVrB+N5JJCnids?=
 =?iso-8859-1?Q?BqWq5FPGiEW0vmjZEiwaKEIb2bZBh8bQPWznVdnHSUUSzeAw/Mo5yWMpsR?=
 =?iso-8859-1?Q?rEjaZot3ht+jMIeqvOAyG+ld0KDYv+/XSi7R6cFoiBFrzurCDjdmoGq5OJ?=
 =?iso-8859-1?Q?2b7x0mcdVu0gMsRwQSV3nT5mxRT8oSUPyi+1XjhmSeQ3mhXycPRGmVPKRL?=
 =?iso-8859-1?Q?Jtpu/iGiIm0i52yq0VfUZZ0cpcB9Y0v537IL5N3pxey0os+BTQu6t4+70j?=
 =?iso-8859-1?Q?qFFAJyNPBbAEuyYa2tzl3nCgWWec9JCvHznHJXzhHna4eXrYaYUIJVNTZv?=
 =?iso-8859-1?Q?yeHLeE7wgZan/FpNAUpEUg0lnnsyHfEBJ7AwbvBNl+9wcZHV0LKXK2yEIR?=
 =?iso-8859-1?Q?bzyjkItVjR9D8hQWj+mW3ZxOjWyzfIbvcrc4zc57rk3wxZeOjqA+l7RqWp?=
 =?iso-8859-1?Q?G6CcPUGJUw3MWWSk7ghrbG/63Q6vlsBheExCGPMQTbb0egEnHxrg0Krg?=
 =?iso-8859-1?Q?=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 06c81081-9a09-47b5-aee6-08ddebb69274
X-MS-Exchange-CrossTenant-AuthSource: CY8PR11MB7828.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Sep 2025 13:25:53.2445
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /v+Lz4EQx1tD9n0mMKZuy2SF/tiveynF/VbZluHc0UbR718ZyLbrm2RdCTGFlVnJIXAofxIFEMZ/fFU9Y4ckk9WHF7x8I0akYJnl7gUzSGM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR11MB8829
X-OriginatorOrg: intel.com

On Tue, Sep 02, 2025 at 10:47:40PM -0700, Matthew Brost wrote:
> On Tue, Sep 02, 2025 at 03:07:13PM +0200, Francois Dugast wrote:
> > Once support for THP migration of zone device pages is enabled, device
> > private swap entries will be found during the walk not only for PTEs but
> > also for PMDs.
> > 
> > Therefore, it is necessary to extend to PMDs the special handling which is
> > already in place for PTEs when device private pages are owned by the
> > caller: instead of faulting or skipping the range, the correct behavior is
> > to use the swap entry to populate HMM PFNs.
> > 
> > This change is a prerequisite to make use of device-private THP in drivers
> > using drivers/gpu/drm/drm_pagemap, such as xe.
> > 
> > Even though subsequent PFNs can be inferred when handling large order
> > PFNs, the PFN list is still fully populated because this is currently
> > expected by HMM users. In case this changes in the future, that is all HMM
> > users support a sparsely populated PFN list, the for() loop can be made to
> > skip remaining PFNs for the current order. A quick test shows the loop
> > takes about 10 ns, roughly 20 times faster than without this optimization.
> > 
> > Link: https://lkml.kernel.org/r/20250829080505.1020155-1-francois.dugast@intel.com
> > Signed-off-by: Francois Dugast <francois.dugast@intel.com>
> > Acked-by: Balbir Singh <balbirs@nvidia.com>
> > Cc: Jason Gunthorpe <jgg@nvidia.com>
> > Cc: Leon Romanovsky <leonro@nvidia.com>
> > Cc: Zi Yan <ziy@nvidia.com>
> > Cc: Alistair Popple <apopple@nvidia.com>
> > Cc: Balbir Singh <balbirs@nvidia.com>
> > Cc: David Airlie <airlied@gmail.com>
> > Cc: Christian König <christian.koenig@amd.com>
> > Cc: Mika Penttilä <mpenttil@redhat.com>
> > Cc: Thomas Hellstrom <thomas.hellstrom@linux.intel.com>
> > Cc: Matthew Brost <matthew.brost@intel.com>
> > Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> > ---
> >  mm/hmm.c | 29 +++++++++++++++++++++++++++++
> >  1 file changed, 29 insertions(+)
> > 
> > diff --git a/mm/hmm.c b/mm/hmm.c
> > index d545e2494994..a8ac8d830e39 100644
> > --- a/mm/hmm.c
> > +++ b/mm/hmm.c
> > @@ -355,6 +355,35 @@ static int hmm_vma_walk_pmd(pmd_t *pmdp,
> >  	}
> >  
> >  	if (!pmd_present(pmd)) {
> > +#ifdef CONFIG_ARCH_ENABLE_THP_MIGRATION
> > +		swp_entry_t entry = pmd_to_swp_entry(pmd);
> > +
> > +		if (is_device_private_entry(entry) &&
> > +		    pfn_swap_entry_folio(entry)->pgmap->owner ==
> > +		    range->dev_private_owner) {
> > +			unsigned long cpu_flags = HMM_PFN_VALID |
> > +				hmm_pfn_flags_order(PMD_SHIFT - PAGE_SHIFT);
> > +			unsigned long pfn = swp_offset_pfn(entry);
> > +			unsigned long i;
> > +
> > +			if (is_writable_device_private_entry(entry))
> > +				cpu_flags |= HMM_PFN_WRITE;
> > +
> > +			/*
> > +			 * Fully populate the PFN list though subsequent
> > +			 * PFNs could be inferred, because drivers which
> > +			 * are not yet aware of large folios probably do
> > +			 * not support sparsely populated PFN lists.
> > +			 */
> > +			for (i = 0; addr < end; addr += PAGE_SIZE, i++, pfn++) {
> > +				hmm_pfns[i] &= HMM_PFN_INOUT_FLAGS;
> > +				hmm_pfns[i] |= pfn | cpu_flags;
> > +			}
> > +
> > +			return 0;
> > +		}
> > +#endif  /* CONFIG_ARCH_ENABLE_THP_MIGRATION */
> > +
> 
> 
> I believe you missed my comment in a previous rev. I think you need
> something like this force a fault on dev_private_owner / pgmap->owner
> mismatch.
> 
>                required_fault = hmm_range_need_fault(hmm_vma_walk, hmm_pfns,
>                                                      npages, 0);
>                if (required_fault) {
>                        if (is_device_private_entry(entry))
>                                return hmm_vma_fault(addr, end, required_fault, walk);
>                        else
>                                return -EFAULT;
>                }
> 

Yes you are right, we need the same logic as what is already in place
for PTEs. I could confirm that during prefetch by running the IGT test
xe_exec_system_allocator/prefetch-sys-benchmark.

I will send a new revision.

Thanks,
Francois

> Matt
> 
> >  		if (hmm_eange_need_fault(hmm_vma_walk, hmm_pfns, npages, 0))
> >  			return -EFAULT;
> >  		return hmm_pfns_fill(start, end, range, HMM_PFN_ERROR);
> > -- 
> > 2.43.0
> > 
