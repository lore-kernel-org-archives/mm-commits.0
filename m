Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23F9D3595B
	for <mm-commits@vger.kernel.org>; Tue,  2 Sep 2025 12:53:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756817606; cv=fail; b=eR5wq4YLCqXnG7V9ChHcYmZIJHzbvONgxkxhjj7gKw8Ug7iq0/GZgslTUWeIQTncqs0Nz40dd15nxSHS9Al9XpVgR/9dvmd8+pqCBkri5U3lr0ASJNOpjEdcjDFGOFxCJ9FJ60p/fODs0nIde+s+t+y1a9RLDrt4PSuh5LEmFjc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756817606; c=relaxed/simple;
	bh=k4uKv+Cl2QVIjpVw5u8fcr0CNaamQU5LqciyH+wXiMY=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=YUr/SK0TQMdLRhgC9SO7Tu4XAWU+T4eLPR5zbDWRB2JY4ck2P7SU5D4fO+KOmvUIznAsKsSf0ATR4c9cIpBUIP+2jOVTC3UVbRdzcEeRus02Mx3/+1piT9j+mYf/rPRou0b9aT0hJS2eioDveRt5jLci2gX628xROO08/3ubtFk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=ma/wyNia; arc=fail smtp.client-ip=198.175.65.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ma/wyNia"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1756817604; x=1788353604;
  h=date:from:to:cc:subject:message-id:references:
   content-transfer-encoding:in-reply-to:mime-version;
  bh=k4uKv+Cl2QVIjpVw5u8fcr0CNaamQU5LqciyH+wXiMY=;
  b=ma/wyNiapfQZnoWL8S+Z0kr8/4by40mDaiIimwBDy5Uup17WGR1edGcs
   /NhD9BgnLfwLm/5QSlSw8SSUeXYRynvlISVROYZIu8eDVWu5B8AITmIoP
   92bE9MKMDQJuCXuGKRXadztD7tGdYnZPtYd78XujX40rEK2HIennUDb7n
   Z46HkPJTJBPjmocdsm4umQGdJelqCokvM3wII2lLtr+I+QP5UL+mN5H2i
   eE4vB5lGYIoMEX8LNwgtwGXsK7Y7IYtxtusPjhLhEGM3EDU/U66C/MCr4
   HpL8Wi6vx8ceGD8R6q9CIyXttAfbGo8ZsNuOWLBZKAr0gET265QjM+xGj
   Q==;
X-CSE-ConnectionGUID: VkHr8uQ3RiSaDykIKaKIJQ==
X-CSE-MsgGUID: N1+EdWd0QMe49TwRgErMbQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11540"; a="70518874"
X-IronPort-AV: E=Sophos;i="6.18,230,1751266800"; 
   d="scan'208";a="70518874"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Sep 2025 05:53:24 -0700
X-CSE-ConnectionGUID: jemRWervS8SmB3rgaII+aw==
X-CSE-MsgGUID: 64In3+umTOqBErqVc7hzFw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,230,1751266800"; 
   d="scan'208";a="170827175"
Received: from fmsmsx903.amr.corp.intel.com ([10.18.126.92])
  by orviesa009.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Sep 2025 05:53:23 -0700
Received: from FMSMSX903.amr.corp.intel.com (10.18.126.92) by
 fmsmsx903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Tue, 2 Sep 2025 05:53:22 -0700
Received: from fmsedg901.ED.cps.intel.com (10.1.192.143) by
 FMSMSX903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17 via Frontend Transport; Tue, 2 Sep 2025 05:53:22 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (40.107.223.58)
 by edgegateway.intel.com (192.55.55.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Tue, 2 Sep 2025 05:53:22 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=w0G000Row6X4CweNCMbZg8W4sHh9XNNxYtHUX4xlCQ784wNFrRNCwfzJFH3tnem/f8Lgdf37U8JiegmAE+UtdcVMgbm5q3wVQW2cBaSY/Rr8X3fF1q6WbLfGKnlvJyQHuW1SJl2hbnuNQ9RORLGKHbsEfV9nSDJZEkPjP5pJ3/+6MXOLHzRkrxArJlsvoUDL/XzXauzVrmWFWIhLKSjFVqJbyY1k8Zdh+OmtPx+TAMs871ZI9sBXJvMysrbssI7g363UFlbsVO5iJJ7mdIiv8idkh1PiuzgHZxBJgoawpxUi6GZxevko878B3A3ZzrjWuBp1CK2gNSMPuIiFFIDsQA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PRIOTvObxAtKVtayk3an+Fb1mBQ+CxM5ls1fVpCWO70=;
 b=Ppb0357gIrmFUPLR3aQcU15nFx5uEHlEPNJPuxOI4YMiADap730GLvUNR5zELbJaPBMupmvDSBM/vzfkIg24iIscv6JTkWeD8GjymUJJeR+B4EGgrYSRo77m9BVeZIaQhpC64L2rOvBKSDB4sr2ia9eu3zCeLiTX7s+ppbebD7kk8UMm833BsK6/XFN27n/A+s2Fbf3Sp0tpWS4iJ3M9bJKxCsaPI958DqG4gsGDilufDdHiFR+QEjgUsLs8o2cLto3lrz0xbQKGLrdWie9SAyJyI6fYbYk7HQq7iFWOLdmtZRx0pnYTY/O2xZByPyN/9Hn/s15byMONr/aCzmNcmg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CY8PR11MB7828.namprd11.prod.outlook.com (2603:10b6:930:78::8)
 by CH3PR11MB7844.namprd11.prod.outlook.com (2603:10b6:610:12a::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9073.27; Tue, 2 Sep
 2025 12:53:18 +0000
Received: from CY8PR11MB7828.namprd11.prod.outlook.com
 ([fe80::5461:fa8c:58b8:e10d]) by CY8PR11MB7828.namprd11.prod.outlook.com
 ([fe80::5461:fa8c:58b8:e10d%4]) with mapi id 15.20.9073.026; Tue, 2 Sep 2025
 12:53:18 +0000
Date: Tue, 2 Sep 2025 14:53:08 +0200
From: Francois Dugast <francois.dugast@intel.com>
To: Balbir Singh <balbirs@nvidia.com>
CC: <akpm@linux-foundation.org>, <airlied@gmail.com>, <apopple@nvidia.com>,
	<christian.koenig@amd.com>, <jgg@nvidia.com>, <leonro@nvidia.com>,
	<matthew.brost@intel.com>, <mm-commits@vger.kernel.org>,
	<mpenttil@redhat.com>, <thomas.hellstrom@linux.intel.com>, <ziy@nvidia.com>
Subject: Re: [PATCH] mm/hmm: populate PFNs from PMD swap entry
Message-ID: <aLbotHsTPaqk50fK@fdugast-desk>
References: <20250830035612.0DE67C4CEEB@smtp.kernel.org>
 <20250902111743.1633972-1-francois.dugast@intel.com>
 <9481c30d-2232-4d29-a38f-6a87b0648238@nvidia.com>
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <9481c30d-2232-4d29-a38f-6a87b0648238@nvidia.com>
Organization: Intel Corporation
X-ClientProxiedBy: VI1PR04CA0086.eurprd04.prod.outlook.com
 (2603:10a6:803:64::21) To CY8PR11MB7828.namprd11.prod.outlook.com
 (2603:10b6:930:78::8)
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY8PR11MB7828:EE_|CH3PR11MB7844:EE_
X-MS-Office365-Filtering-Correlation-Id: 4f9e4ba6-bd9e-4865-2744-08ddea1fb083
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|7416014|1800799024|7053199007;
X-Microsoft-Antispam-Message-Info: =?iso-8859-1?Q?agCtB08UTXFIK/INtRz0hTZYIbjsnzVhCUQ0dq0KicaYu3at0l3v35yNCk?=
 =?iso-8859-1?Q?d4PMPMk+3NnDJKq0vj/rppWWtpkx4lHsPybasJNES0KaJZby8bL2KbfD9d?=
 =?iso-8859-1?Q?dC/lvqm7iUARQfcLvVGsdJiJergBvxAgpb+wa+uxvXbHD3L0e1o93RuVNN?=
 =?iso-8859-1?Q?ci+QE8w8JA4uCFeUv0UgM0Cv8izusnXcY4lqc4wZMS9bu++TQiqLDBU2mN?=
 =?iso-8859-1?Q?JlYglVJsjJ2O8unbEu5Y30FrUJDu2Z9/F1GuwT5BWxxkcpAdxQFut7JSfL?=
 =?iso-8859-1?Q?b5m5ijud5ONCEI4dO0fYcTfpSo0nQ/UdmvctvkiRvlrlan2lxl/ShFMPLV?=
 =?iso-8859-1?Q?/Tqe56amPizvVY/K6NkQHDdPXweI6BnlsYm3BDsMLPpXq9sMhwLnUpoeKZ?=
 =?iso-8859-1?Q?PWD6NhbSxxvAsW4Z88t73OlwfV0Kh5j9gb6jVI3KGcZ0jm/muTnN4d4vIL?=
 =?iso-8859-1?Q?qigM1kKxEQWJRyTsliyc07Qsts6d2GGAdDx76p9jOO6AY4xSxAyDI8RZ/g?=
 =?iso-8859-1?Q?Bin6y/eEbSOo8u0bPNKSzkiN7UHNHiCNiZI7uSLUAx8gRkbhyI8WyAKNFH?=
 =?iso-8859-1?Q?upnoyJ2T2jjzLpjqUm4+MNFWT7GwGRV4hX5mOX0zP1n3iGfGA4WCdjcTdm?=
 =?iso-8859-1?Q?f1OMeoTYsvjnWyOdIH2soiFS7bKN2T48rF90n6hklY3eepR/ZhUCbMbCjQ?=
 =?iso-8859-1?Q?b9Ocf5xmop79w23SoNfrHKqyfH/viTb5gFRQHJl2ZykToo1Ht/PwkbTZs+?=
 =?iso-8859-1?Q?rpVB5JlcME/DgSbkrQCCFv1+4VODD2Se1V4RcFNUxneixbpbKj7bQzWIC8?=
 =?iso-8859-1?Q?1DXjAxAC7auaDSFR4er+is0/xMWyVdW+Uuo3PW2sNNqH4R/LB6fRpokNKm?=
 =?iso-8859-1?Q?PgJpjpk6PTq9+DrBd+Nu519aZ+8jewI1dZv3qMJh8TbNSV0eKV791ylo+T?=
 =?iso-8859-1?Q?nsym5oAVYT6h1LanS9Nvpy9vjQhEq0iLXWWC/03MnCQBAI7h4UyfGfIqDq?=
 =?iso-8859-1?Q?Fay4t3LlVs2rkqMd0OX3MnABwG5jjvYxuuA6n+9bmj01DVhjRyOO2oqlou?=
 =?iso-8859-1?Q?WKuq1Znf02FvlrF6iqo/lGIr94KsQ7cQNBC8mATC/A/wvXkriX+peXXIYa?=
 =?iso-8859-1?Q?7loIPE/jVaOL4CQVpVdKtmJreaiJZbke1xJfGq5pTs5NeJasmASsRyeaML?=
 =?iso-8859-1?Q?217KnvPYTMCfOIUJaSfX0HLyrdNl+aRygiS0HYfrox5OsQodX7pCnNmUMt?=
 =?iso-8859-1?Q?rwEVJP3i+oGe1TBusDFi3P4USPLxc8FXnc5Ij1vaEGMY9RIotRUiHZaMQ7?=
 =?iso-8859-1?Q?/8sS2KBu0+cEYo8LO6sHgEYg00+ovbdqpTy9i/6ZdvV2vK++Zwbg/iadll?=
 =?iso-8859-1?Q?5EKisZVh6Z2cHLD2I5mUn5vkKEfebfLr7QFVAv2cPGSwalh6xXF56oISrt?=
 =?iso-8859-1?Q?YJXPF3fkZ+XrmwlOX0Jc0M0mcXUCaCA+ijHoQEcai6trpNV56C60UGQ1US?=
 =?iso-8859-1?Q?E=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY8PR11MB7828.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(7416014)(1800799024)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?iso-8859-1?Q?96sbWemPNEOvQHYY5CQTBNCo9khhO9WcyNH7FD1Mr/U2otEPUSJUW9SW1C?=
 =?iso-8859-1?Q?cj93bOKMJFd+1J0zkWJYt9UXloE8NuGzCNSIfbNArI/ZKbY1LfBtXoGje1?=
 =?iso-8859-1?Q?NlBD2rDYbaOHH5MofFYKkLsh9zBn0V96cgzCdldQ4VqGL6lNFNjaDuoScP?=
 =?iso-8859-1?Q?YdlPEkFDM+KYAz0ly85zsnO9UT3M/FF77M0pp8zfQR5g79lvdllqVNGM8/?=
 =?iso-8859-1?Q?NDR3r26EN3N092AfPzi7xr06/ePWjx1FUyj98uB2s84dNWRV1srgAGfKrh?=
 =?iso-8859-1?Q?PzZkHtZYJ878WtHcUDJbGLryLRwV/PsCr64UM5bUBMkEuToQ+a5Vtuy2YF?=
 =?iso-8859-1?Q?AG2A8lDjlhIdaunoHVU0eJ3LIy4yrh94Qfwl0CIwZ3yMCP4/J2VLfleVdn?=
 =?iso-8859-1?Q?8qps621bA3R9aCQhHitwlfOzjR0Ty9h480nc1BMUyDTHlJzr2iG70+uAlr?=
 =?iso-8859-1?Q?ROioYAd16xCiLAcFyrCmzZIV/sLTCy6CF5X5FZhaJQ7ayI5e0EdJ+XspwX?=
 =?iso-8859-1?Q?r4XF2ZnnYnyKwNOxNidoNm/8Sj8gIYEwvGisRdbPRI+199uLbmkOOcgCzE?=
 =?iso-8859-1?Q?KEkYFq0omwxaswNAZinEBAGkSL+h3+uWpB1oi5yh1C2dr/QXWP1ev4Qtb0?=
 =?iso-8859-1?Q?c2wfWd3jzb0j8xemb/SZDVvD1TxWlqkM3RDS5Zzm2t+D7vwsHdv0a9EX5n?=
 =?iso-8859-1?Q?vtdH/VHOPDTEjY77GatnbHhz4G0Oye9kT9i+QdftRglDSPQq6wciDPbzUq?=
 =?iso-8859-1?Q?57+L7aZAa0S68wLdXoJb12bpelLCUm3djdih2B8tgQuIxLUTPuh2AUaltG?=
 =?iso-8859-1?Q?sU/89aaIARD8MzvCMQA27kreXa2hSOVtl/4FhDkWBlGID+jXNfBeLqhHLz?=
 =?iso-8859-1?Q?xzxppxW/bPdqElbLJR6ANDXVpRohZ9z/zwiNPIwRv3KDGoXPtn7+BQ6WkC?=
 =?iso-8859-1?Q?8P8KTYoE6wHf83whDeTH5gEiLN8K5N6yzoxgGAqOTFvtLicNOJARFoyCcj?=
 =?iso-8859-1?Q?VoonjIJD8bCTzxNGfsacX9ETWI0BhtaBGI9E77xgldAgdvKkl80AvhBvXz?=
 =?iso-8859-1?Q?hat+tOIFSQc3JmKSgBksF7p1sjJUnn+JDwp+PaPUr7mtqi0cTl+zYFQdxt?=
 =?iso-8859-1?Q?iCmu8mX1+ddd8SuSI5FMqqNECQ1S3F5tNxfGskoUstDjMstNXg0HmtBCV8?=
 =?iso-8859-1?Q?Eud8+ShdJNKugNIlCfJcHlNLaXzy7szxyaDeVALygEge9xGAMGvY5f50Kv?=
 =?iso-8859-1?Q?H6QqRLf3yaRXRKiDjmvk4cO7vJc5GZnw1vKMdhim//vwikNmX5D0zSLDRg?=
 =?iso-8859-1?Q?Kn2sLaR2BmKmfsG4i1PNOSYrRD8OW0QsMOmxlQLyr5YnYbIWS6CHGvekZz?=
 =?iso-8859-1?Q?yBr2gWcuJjjcSYIYF98+5czE5DDQTZb96no1o/jgNalSNwdi7OIpAhXURZ?=
 =?iso-8859-1?Q?RstMJKXWcyUAUs8BLrYFpFABhiPwBdnjCJqN0CtFclNBpzlJmU4bQehkzl?=
 =?iso-8859-1?Q?03Fl732/WgfPWpg4PZvw1aW2wmlKKkNdDLs+wNM1mHbcmH1USapitzpjHo?=
 =?iso-8859-1?Q?a1op6NulAXc5z9BTfSIEorTcYFL5takEbedF6WhYqkv6hNqtmIQEv/J8rr?=
 =?iso-8859-1?Q?ut5z9+pY5tETaHwhUwO2yOKYloRJgFYADCVHuzKZlUvafwIdt5gXX4QA?=
 =?iso-8859-1?Q?=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 4f9e4ba6-bd9e-4865-2744-08ddea1fb083
X-MS-Exchange-CrossTenant-AuthSource: CY8PR11MB7828.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Sep 2025 12:53:18.4705
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: fUuCCym1Q6s+zpIOhtbeV7eHDtyIM+s8gVo0zfoLHbVDflsRVhQ+5lVjLrwh+LrL4+iXHCuHXS3azYi/xcyagWv4yRuLcXXGl1kxwGiVCe4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR11MB7844
X-OriginatorOrg: intel.com

On Tue, Sep 02, 2025 at 09:30:13PM +1000, Balbir Singh wrote:
> On 9/2/25 21:17, Francois Dugast wrote:
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
> >  mm/hmm.c | 23 +++++++++++++++++++++++
> >  1 file changed, 23 insertions(+)
> > 
> > diff --git a/mm/hmm.c b/mm/hmm.c
> > index d545e2494994..d449fc4647d7 100644
> > --- a/mm/hmm.c
> > +++ b/mm/hmm.c
> > @@ -355,6 +355,29 @@ static int hmm_vma_walk_pmd(pmd_t *pmdp,
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
> > +			for (i = 0; addr < end; addr += PAGE_SIZE, i++, pfn++) {
> > +				hmm_pfns[i] &= HMM_PFN_INOUT_FLAGS;
> > +				hmm_pfns[i] |= pfn | cpu_flags;
> > +			}
> > +
> 
> Can you add a comment here about why this is added? Why would there be a disconnect
> between HMM users and the API? I assume you are referring to drivers that are
> not yet aware of large folios.

Yes I am, will do.

> 
> > +			return 0;
> > +		}
> > +#endif  /* CONFIG_ARCH_ENABLE_THP_MIGRATION */
> > +
> >  		if (hmm_range_need_fault(hmm_vma_walk, hmm_pfns, npages, 0))
> >  			return -EFAULT;
> >  		return hmm_pfns_fill(start, end, range, HMM_PFN_ERROR);
> 
> Other than that, based on the assumption that my patches are not a pre-requisite
> for this
> 
> Acked-by: Balbir Singh <balbirs@nvidia.com>

Thanks.

> 
> Thanks,
> Balbir
> 
