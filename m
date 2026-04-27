Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F43B27AC45
	for <mm-commits@vger.kernel.org>; Mon, 27 Apr 2026 14:46:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.16
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777301163; cv=fail; b=GW24KaFm2+rrWYmqwQStxsBzPh7z7HM/hFMaBrCrX4qsw+dWXsmmY+/2RJt86B8W4c89X3dkIevTB7KGlQIR2Tn8mCPHhPiAdhqcStSyG65rxAlRHgTAaVb3D+dyEqcgJMVg7wT15lN/9gi4mPrjCeop3fUNqg7PtjCea4iVR5w=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777301163; c=relaxed/simple;
	bh=Q3WaLlYbOWU9aJEc/6sSmTng1wPXU81gMOzgoRVJd7E=;
	h=Date:From:To:CC:Subject:Message-ID:Content-Type:
	 Content-Disposition:MIME-Version; b=o95CrhP/PdoSh/AqFqcrsdaFRlER21WRO74H5eT/UZlSVSbV8s2D9XmBc8r1TWcGk36slsUOn1CCzUBGKTiFfQnw8UClcmmYfMDGRhg3k7jQagoGbhL2g4gS69wlKoiEr/PJggFyEbSY3gVQG9XVKYWKdQMO1VOMvw+mEsXtcow=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=dpQxkxsZ; arc=fail smtp.client-ip=198.175.65.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="dpQxkxsZ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1777301161; x=1808837161;
  h=date:from:to:cc:subject:message-id:mime-version;
  bh=Q3WaLlYbOWU9aJEc/6sSmTng1wPXU81gMOzgoRVJd7E=;
  b=dpQxkxsZnpbx6sLFN1XZIQUVP0RKvzc0vO9l2maHpAQm0v1MMkMumhAd
   Oi3jolZkX2gkfHSz7Q4/adt/JyXkKsGeFepR7FEEd6zw8kmpHj4Tk1JlL
   NoO1TYX2h8DvNDbOVPmUFTLdcE0Eo/in9QOVnU4+kdfhvKSunFL0sz2bd
   DGF5UyeXVnA/MWNn1B210uhAUbZchOjweEu43/hU+60jl05njsDDR6Yh6
   JzsLZRmABSua9nhxE+f9Rp4ompxmtBGMouCpgTY+vhRCOLJ7HqeFBaA6w
   PxRD1dOUtuTBrOxn2wvn/ljzgY0zkuRqunn1GiaF+aK2xu1iKBkr20/2E
   w==;
X-CSE-ConnectionGUID: lomCS2JiQzq4O+ix653GGA==
X-CSE-MsgGUID: F0fbKfG8S1KDA2PjUu+Vpw==
X-IronPort-AV: E=McAfee;i="6800,10657,11769"; a="78378309"
X-IronPort-AV: E=Sophos;i="6.23,202,1770624000"; 
   d="scan'208";a="78378309"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by orvoesa108.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Apr 2026 07:46:01 -0700
X-CSE-ConnectionGUID: 2xLPsojqQCmHEMC1oWGV0g==
X-CSE-MsgGUID: bwpdF3QJQUGuM4UfNjkh+Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,202,1770624000"; 
   d="scan'208";a="230468080"
Received: from fmsmsx903.amr.corp.intel.com ([10.18.126.92])
  by fmviesa007.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Apr 2026 07:46:00 -0700
Received: from FMSMSX902.amr.corp.intel.com (10.18.126.91) by
 fmsmsx903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Mon, 27 Apr 2026 07:45:59 -0700
Received: from fmsedg903.ED.cps.intel.com (10.1.192.145) by
 FMSMSX902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37 via Frontend Transport; Mon, 27 Apr 2026 07:45:59 -0700
Received: from CY3PR05CU001.outbound.protection.outlook.com (40.93.201.43) by
 edgegateway.intel.com (192.55.55.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Mon, 27 Apr 2026 07:45:57 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=AjmXqHMdGgCTuqf7U/UtUmE2wqhbwkYs1VJXWFEvZOVZHNIVIMeO49tFSrFcHZ6AyHh/rwYkHx8FICgqYuG2CR0ObOmorSxL+qg27joI4JjJiepaht0txxxxUEb+dyZa0HlqKYVq1bJwKO9qymF2KYEVxTvDXXOqviN081EoWHcWODODF5cYw3G1rH068s8bZ/G+/kAv2ic4OLezGDqH08VlzrsoDQZyThMkSjB7qg0n7IcJD/cwmtXJuRrloTqkAF3J6iGLEYAiRqFMzXLar+Owgl22JMqLvLj6cKBgXf8a+f6sLWI+NdYghMZfIGvFy8PHeKVszrjUsxXopfzmcQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HB5Tp0K+QSVsZ3I+ui6oE05ZiYvk/5ZTF3DAkTKZ9z4=;
 b=OO7gyuVJuqnbkhp4Kw3R32pKrfKXe09tzNohFNVC2Vczr7al5wzyNYgu1XdqKabbariQoX+DgNJeyojY+ZUT9SMChM9yH3RoWFQcEbgrbP6BtZnEC3O25rDDZ8pcrKFLBKeCYzORxHCdHNuIIUBaAT53rTZP7AgfXhnhkqe27vV04uVnFdrdwZ5NXuv95ZCFsUdaILGdqFcs9LRpdC8tq16Cuj8DrMaYYPUN5EldcDcCVPWonLKkoWP5fTJ/MF8HMA8y/iYmkAdSoUvZDJo8k8bPd4/RobUMP5CE0IITlUW9wce8gZYgb8LJdlU37lC9/QybP0GXMYiW3Xs6RC0cGQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CH0PR11MB5428.namprd11.prod.outlook.com (2603:10b6:610:d3::19)
 by CY8PR11MB6963.namprd11.prod.outlook.com (2603:10b6:930:58::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9870.16; Mon, 27 Apr
 2026 14:45:52 +0000
Received: from CH0PR11MB5428.namprd11.prod.outlook.com
 ([fe80::b8c4:d29:c56:a2da]) by CH0PR11MB5428.namprd11.prod.outlook.com
 ([fe80::b8c4:d29:c56:a2da%4]) with mapi id 15.20.9870.013; Mon, 27 Apr 2026
 14:45:51 +0000
Date: Mon, 27 Apr 2026 22:45:39 +0800
From: kernel test robot <lkp@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
CC: <oe-kbuild-all@lists.linux.dev>, David Hildenbrand <david@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>, Linux Memory Management List
	<linux-mm@kvack.org>, <mm-commits@vger.kernel.org>, Davidlohr Bueso
	<dave@stgolabs.net>
Subject: [akpm-mm:mm-new 117/130] ./include/asm-generic/fixmap.h:77:9: error:
 implicit declaration of function '__set_fixmap'; did you mean 'set_fixmap'?
Message-ID: <ae92kz3LeyaFBvKw@rli9-mobl>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
X-ClientProxiedBy: SG2PR04CA0171.apcprd04.prod.outlook.com (2603:1096:4::33)
 To CH0PR11MB5428.namprd11.prod.outlook.com (2603:10b6:610:d3::19)
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR11MB5428:EE_|CY8PR11MB6963:EE_
X-MS-Office365-Filtering-Correlation-Id: fcc0a6c7-eb19-40c7-26a3-08dea46bac51
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024|56012099003|18002099003;
X-Microsoft-Antispam-Message-Info: HdljYQORb+R1iAHmpg2i00S3Vp+TWjqahvhKSN4JU6XicuK1W4Yqb5Nt+hQWL//TQvvP+SlZKqniNajlOeXLyL76fyBCNbM3Y43z17SGo1Z7oP06sagsig1cfn+mAC1eVR++YUH6ht77Ntd11mVZSVRFeBxBIDZpUy2+noxzmuVlHtNjg8A9F75iQedDd7lBsZ2xltD19n4jxRQPDcfCGOej35iPpIy/GHQ3UnKBd42fwhmju1kVl9JfJDscOROkEQNAYkaL74QWDSO8jWg5rZeBe6AlygP/9a5WtkRzLDCqwrbAflPLImMOYLXPgInx/hhiTfOmgd5Tw8vMbDk7bhXON8WhiWwYNE67nneeZpA9R7IJ5FbcwWLWqgSvSsaP/wFLYz6dec05LUJPWzsZfz7vXfbosCErbPxSPUCnHS32NVErhO3dOvE+j7YihUDWRWffTJps4z90XEmHdOtCtl3L3T0Ekh45MQYgmnk72SqBlIg4Gu+avONCBnekG6MqpoMat/IO0s6dn3DPbx3nNvIXMY41u9gBJOjpQZPSd3MDjebNk9kqg/iIzqxOM0V+gH2bskb/U+XNz7NUOZjA4XkaQEIMtfeVWm/WcexpjufK1/xRh3aX1vP0GNoU5IL1oP9vzL7CT7QPLFan8ZU+QMASMSLzOTiKbyYGWx/7h/Kc3WaPCva4MsHXa7oRtu3hBWiJOZ+A2KB/qODcKXQo/A==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR11MB5428.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(56012099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?D0kTz7tlUahEG2yq4dxIA3rwf0gI21Y4/Yny8MTY/JuaMLGk0u/wPEbT0D9O?=
 =?us-ascii?Q?SnK4xiQV8HJGkDdn/zQWXN2tgNU7YI9WxDEW0ZN925neE2TARlY0HLJ7k/Yp?=
 =?us-ascii?Q?DOSdZZVh0DR1t1zajMTQjY4csPPzvpzUACvJuMTWHqaDkHG5Ad4C23QhuLaC?=
 =?us-ascii?Q?K0xIfDLADvOGOJ9SibG0KzM0eHor5i1s7k5XPaTWr2f1rT4m6Ww9ozA62uAG?=
 =?us-ascii?Q?GmgHEr8Ho9bjQSXcHjt6H8TL5mJEGubOK/Shjq/j8xAE47hkmGI0np9FMMBO?=
 =?us-ascii?Q?tqBX15ksUZm5BxnGbEy0qRPbyLLekmGi11j3+tIAWh5JupuzpS86u3sQjJG+?=
 =?us-ascii?Q?VV7xE/SiJDGC29OHUm7emrrz8dXbcyo9llAgELTGsOUUI2B/EySYCOthbp/d?=
 =?us-ascii?Q?DRS9phkjNSarppr+RTYsAu++XJEMYQc3n80AcWp0lorahBYhFu2Ge45/ucwJ?=
 =?us-ascii?Q?p7hludUBeXqzucDjYukI1AQ2zSxgucZ14Fjhmzm3S5V5Z1vBPQ7H0hyqJTHE?=
 =?us-ascii?Q?chye6eqNB1y41rtCOTtVlzNJ0AoBXzweGo1zkDE/zZujZpT4rNekX9JujQ78?=
 =?us-ascii?Q?Z+zwPKcGM+tk7FixKs8drZc8pvAzvQSbWaI/PJ8GTjiniqj1916EjrlrcoCc?=
 =?us-ascii?Q?qjpboCQ43RAw3Y6uGz2E1cZ4J4KU4q67Sr8nkqBGcYpJaLQjM/ZkHxt1B2Qh?=
 =?us-ascii?Q?bpZ7onqCNcKmCh92MLdIcesGW0SmzJuE/cAaCLXSyRWywArrLlIsAynPa2kP?=
 =?us-ascii?Q?4O5oXWjLdII8CYcetjgUGreHOjx/yxSMqckhlF1fdQPTYxbViybojqV1gLxQ?=
 =?us-ascii?Q?XJJseUUk+NdftRTUxz4P3BbwN7a+0tQ6CKX4xT4sp3sBPZZkilboBmmRfGzH?=
 =?us-ascii?Q?kyiBVZ/jmHXxXNxTLl0ckjlMVdwFvkfgUV8fd5yGgz9pzlX8U+HS7G2dGaji?=
 =?us-ascii?Q?HlpN+uxMLci20n4tPl0wFhwvK8I0CgIDAlpIzsk22JXHjl0r/tHC/EOpOGmB?=
 =?us-ascii?Q?BxrQA45/U8GvfJy0xe5kbMiYdjimssPL8g5ViyQHg8p/iEG3HLz6PpdgoVZf?=
 =?us-ascii?Q?SfacKho0CGRdl6oKo58LImKQj8g8joc585kiWFxXVAsDFVtZTFub2vcQ+Y1j?=
 =?us-ascii?Q?KACOEawqcJqAxLf0+X9q0R8vT/hqPM+GDtyFqzIz00PBoobEQjgVMHGDhaP9?=
 =?us-ascii?Q?bOXhYPGqlF7yUFIli2UY999qQdckh4Web9tQn2BQ6shc5mQ/SJHejPPjUzmA?=
 =?us-ascii?Q?XbkpNnnb2q4ZQ08h5mVcPfPh2S0fwESVq4HXSOGhO7CweLjYkjUd6tLcScQU?=
 =?us-ascii?Q?0YPvPmW4S7sA4UWK7tR+fK8zXTNQ6NrHbt2XOwkguxiItsy9dozgJDyo4H4f?=
 =?us-ascii?Q?cc7F0xOYWbof08eYaAwGND2rLF6BmJvKEeT7GMTga7Hq/cUun0c5H7EWIOhU?=
 =?us-ascii?Q?nMi7v2QJG321zL6FF+0qCxlCWsM7swoUOtn8S4SjWih8WyQgc8sqwTyyVWGO?=
 =?us-ascii?Q?dob2arzu+uQyxlcA8392EJkzUJhNZroqm/bmWZjGVFiees4XfqH7lKAm74ol?=
 =?us-ascii?Q?HUVdH84OjDOrQF7XrhuNPf6JLQ/5WZcf3gdzJD4Wd/IWhzQNqrPssaBDv8+M?=
 =?us-ascii?Q?v1YsbNjiRVkmtlSp24Xb+Ij3a2S5WNhltUg8CXSmpBZDkqUixxSoHIGFRHGN?=
 =?us-ascii?Q?rEQRGEi3hCI9/mkZsOuUiWNQhlh64VZ+ssSXSAZUcA/IAXuxkw+MbSq0WpKK?=
 =?us-ascii?Q?lfULdoYc7A=3D=3D?=
X-Exchange-RoutingPolicyChecked: WUbrRIC1ij4ZzQdL+5rmQsW3zpeO+Vq7KIVLK0NtyYgg+29nB1JkRxWmJKe5KA2zKrH2RfOhQIz6HbW04m784n6u6By7G76jF9yuDn7tVta0N7MxXPouBtQld463mGx4zvQSbqyO6ernGB54lQ510xjo/3kNb4gmM51YyNyaIRFMVHjmsAqBpAbXlusBidBcVi40/JxEQ6axM0RJX8QR1K+NlWvgcc8gTxyl1SiLDOi5K3ngR06WSzTJ3cI73JQXUXPuygBFrfmSAHHVBtdnrzhGb302EizbxyDBgnRBfADb+MU/i3nj32N8HPlOo/+/oTWz5xbZ8mhmR2IULPRMqg==
X-MS-Exchange-CrossTenant-Network-Message-Id: fcc0a6c7-eb19-40c7-26a3-08dea46bac51
X-MS-Exchange-CrossTenant-AuthSource: CH0PR11MB5428.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Apr 2026 14:45:51.1648
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: AlMmXdMNY7hNffJedDOoJMXLyJ3ZSwHV0ZKOKydC2pTsrqPTAzubc9HUmCZVOW7EBZPcJLfSZD5MWqaJ++9C9Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR11MB6963
X-OriginatorOrg: intel.com

tree:   https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-new
head:   4f7b2cc1ad8719d55a8de9675a0aca65cb17c364
commit: 93580c23bb3da5dd2926d6ae991ef04c2cdacaf2 [117/130] include/asm-generic/fixmap.h: reimplement nasty macros in C
config: powerpc64-allnoconfig-bpf (https://download.01.org/0day-ci/archive/20260427/202604271114.ebmzs1LE-lkp@intel.com/config)
compiler: powerpc64-linux-gnu-gcc (Debian 14.2.0-19) 14.2.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260427/202604271114.ebmzs1LE-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/r/202604271114.ebmzs1LE-lkp@intel.com/

All error/warnings (new ones prefixed by >>):

   In file included from ./arch/powerpc/include/asm/fixmap.h:91,
                    from mm/early_ioremap.c:18:
   ./include/asm-generic/fixmap.h: In function '__set_fixmap_offset':
>> ./include/asm-generic/fixmap.h:77:9: error: implicit declaration of function '__set_fixmap'; did you mean 'set_fixmap'? [-Wimplicit-function-declaration]
      77 |         __set_fixmap(idx, phys, flags);
         |         ^~~~~~~~~~~~
         |         set_fixmap
   ./arch/powerpc/include/asm/fixmap.h: At top level:
>> ./arch/powerpc/include/asm/fixmap.h:93:20: warning: conflicting types for '__set_fixmap'; have 'void(enum fixed_addresses,  phys_addr_t,  pgprot_t)' {aka 'void(enum fixed_addresses,  long long unsigned int,  pgprot_t)'}
      93 | static inline void __set_fixmap(enum fixed_addresses idx,
         |                    ^~~~~~~~~~~~
>> ./arch/powerpc/include/asm/fixmap.h:93:20: error: static declaration of '__set_fixmap' follows non-static declaration
   ./include/asm-generic/fixmap.h:77:9: note: previous implicit declaration of '__set_fixmap' with type 'void(enum fixed_addresses,  phys_addr_t,  pgprot_t)' {aka 'void(enum fixed_addresses,  long long unsigned int,  pgprot_t)'}
      77 |         __set_fixmap(idx, phys, flags);
         |         ^~~~~~~~~~~~


vim +77 ./include/asm-generic/fixmap.h

d57c33c5daa4ef Mark Salter   2014-01-23  72  
d57c33c5daa4ef Mark Salter   2014-01-23  73  /* Return a pointer with offset calculated */
93580c23bb3da5 Andrew Morton 2026-04-25  74  static inline unsigned long
93580c23bb3da5 Andrew Morton 2026-04-25  75  __set_fixmap_offset(enum fixed_addresses idx, phys_addr_t phys, pgprot_t flags)
93580c23bb3da5 Andrew Morton 2026-04-25  76  {
93580c23bb3da5 Andrew Morton 2026-04-25 @77  	__set_fixmap(idx, phys, flags);
93580c23bb3da5 Andrew Morton 2026-04-25  78  	return fix_to_virt(idx) + (phys & (PAGE_SIZE - 1));
93580c23bb3da5 Andrew Morton 2026-04-25  79  }
d57c33c5daa4ef Mark Salter   2014-01-23  80  

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

