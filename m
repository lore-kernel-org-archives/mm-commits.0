Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 352E42C237F
	for <mm-commits@vger.kernel.org>; Wed,  3 Sep 2025 05:47:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.15
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756878469; cv=fail; b=VcDCfatTijLZisLSx6A5xnKRPNJ380eh/Np/r3WN54UEhb9eQdmyGEbbztSySn3wpRAGcYIci4QHez5JPVjujlm8/RW1z/tyamd2QbWpTxi6IbfjINJs6Q1XqypM35qzYvzaBqQOF4JbuCSrcsJsefxJpkqKzmqFDoe/acL3NCI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756878469; c=relaxed/simple;
	bh=OgirnF9TjVe40YEuEP4n1j4XH1pV15H5n1YHs57wkiY=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=uqyCk6STVsAFWQu6FFhkRevHu/Eq0ASNWs09GznUMIimnALEBAXS8kuqjh3hbEI7wuLBlF8WyAHTmwSOhWXpGsusv6U0Bnue5oWMOUwa0floOt+ViLy3SpeNm8pQyKLHy8zBPVW2Kec3iZzx83FsQ3eR8MXXROwrBCyAhGtt9h0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=fr8hHCdL; arc=fail smtp.client-ip=192.198.163.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="fr8hHCdL"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1756878467; x=1788414467;
  h=date:from:to:cc:subject:message-id:references:
   content-transfer-encoding:in-reply-to:mime-version;
  bh=OgirnF9TjVe40YEuEP4n1j4XH1pV15H5n1YHs57wkiY=;
  b=fr8hHCdLoC7bjAIu4d2HGs1A5j/SCvL2OB5GGIv8XXFTaUr9xkp5+0Nl
   5cPr0g0kMrGYU+8K/unD8DanCDIzNrb+t6H8CsYEosoGyqNOf3M9q+THe
   y6nasQL3cWCCO0iOiFVq2PoTDKJ03PKJtbQgj02uj7FqmNoIvbdy0M2/O
   UGhuVD3Fi3tAuBMHMRQpwkuBcQZEbSeFTRFTB6uYtGVTm3CSRid4xed0y
   jhomxpi6Tzf9lzoctKjz0IUgwEOVHj+BAJwSEoyovAZb7LtWlgbTxa0EC
   ebqMHBWFr4DFomK11xXxYMP/ATme25UlYdFEKFl/nQO8NRl5rgvmhJK/4
   A==;
X-CSE-ConnectionGUID: ZKDfRIYzTVqxpm/eyuOihA==
X-CSE-MsgGUID: 7rTao46SRimz++U6vZ8i3A==
X-IronPort-AV: E=McAfee;i="6800,10657,11541"; a="59294308"
X-IronPort-AV: E=Sophos;i="6.18,233,1751266800"; 
   d="scan'208";a="59294308"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by fmvoesa109.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Sep 2025 22:47:46 -0700
X-CSE-ConnectionGUID: qFBfhyDmRl+TXtGfEluD3w==
X-CSE-MsgGUID: uX/FzWeoSSCbDnpm/o3jPw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,233,1751266800"; 
   d="scan'208";a="195131283"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by fmviesa002.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Sep 2025 22:47:46 -0700
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Tue, 2 Sep 2025 22:47:45 -0700
Received: from ORSEDG903.ED.cps.intel.com (10.7.248.13) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17 via Frontend Transport; Tue, 2 Sep 2025 22:47:45 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (40.107.244.89)
 by edgegateway.intel.com (134.134.137.113) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Tue, 2 Sep 2025 22:47:45 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=pwNEbQZFN/UA70JNO8g5iLtCIY/R2WnNETXbWMgRYSdog8muv6YgZwlRHhKb2BIgDzrN0Xovk+LIxiCulI+/bfzw7ocNqdmTVmj4+VIFK7xWOTrhkenb1SztNmDNdvJxDqooZ44Y8z6ZiYQQWdzka9hSWAMZsDm4riDShrLAZKMJPlwrcyjCLzWjdJyz6nwBaeuTnvF1ObZOi/bQYGhQQGBprIrHu05L6sX5fVGThtOAs+RPbXUjRxQB3oiFRUR6qRY92fMF5yhTWebNizNeB0P/XGdnqqE73TLfXcuA9lMAB5QYvYVAIeQHs4zY+zYphcUEcJYokQREWpGmbJE/tQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=SfZYEW9K67adugkDeSb+9wDqwybpLKslvMi9817V4Ig=;
 b=BBMECscY5va1rYBdB4ME4lWXYrQjj6fhPAH4hnoWOuRSxewo8mNUtTtTI1rfIrarvn5B+bxmG6fKE/tmfkhuBvhmLlJ/saMqlnoV4rdggO9uXZ+Vrrv4AwerZOzAKqwoJJV6vkrIec2Y2GbASd4k404e8zP0guGulSuL49ywZpHVAsqBaPyBmt169AxwmFVVU4s3MJDwK+6jgIOhq2RqFo58ofkZrg9wIW9gTklefouXFBEgNtxaLvGf3z0CaylXdKcjpAbB4KT5Uyo3hJ9AqXE4A73GOb05+suB6SVtW3NgOeMSNQn2PkzUZnFqbfzl9NMRvmdWZyT38AN3GCcfAQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH7PR11MB6522.namprd11.prod.outlook.com (2603:10b6:510:212::12)
 by MN2PR11MB4566.namprd11.prod.outlook.com (2603:10b6:208:24e::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9094.17; Wed, 3 Sep
 2025 05:47:43 +0000
Received: from PH7PR11MB6522.namprd11.prod.outlook.com
 ([fe80::9e94:e21f:e11a:332]) by PH7PR11MB6522.namprd11.prod.outlook.com
 ([fe80::9e94:e21f:e11a:332%4]) with mapi id 15.20.9094.015; Wed, 3 Sep 2025
 05:47:43 +0000
Date: Tue, 2 Sep 2025 22:47:40 -0700
From: Matthew Brost <matthew.brost@intel.com>
To: Francois Dugast <francois.dugast@intel.com>
CC: <airlied@gmail.com>, <akpm@linux-foundation.org>, <apopple@nvidia.com>,
	<balbirs@nvidia.com>, <christian.koenig@amd.com>, <jgg@nvidia.com>,
	<leonro@nvidia.com>, <mm-commits@vger.kernel.org>, <mpenttil@redhat.com>,
	<thomas.hellstrom@linux.intel.com>, <ziy@nvidia.com>
Subject: Re: [PATCH] mm/hmm: populate PFNs from PMD swap entry
Message-ID: <aLfWfB1wjX1y1T5d@lstrano-desk.jf.intel.com>
References: <aLbotHsTPaqk50fK@fdugast-desk>
 <20250902130713.1644661-1-francois.dugast@intel.com>
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20250902130713.1644661-1-francois.dugast@intel.com>
X-ClientProxiedBy: MW4PR03CA0133.namprd03.prod.outlook.com
 (2603:10b6:303:8c::18) To PH7PR11MB6522.namprd11.prod.outlook.com
 (2603:10b6:510:212::12)
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH7PR11MB6522:EE_|MN2PR11MB4566:EE_
X-MS-Office365-Filtering-Correlation-Id: 859449cb-ec9e-41a6-be5e-08ddeaad66d8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014|7416014|7053199007;
X-Microsoft-Antispam-Message-Info: =?iso-8859-1?Q?tVLiMgzkVSptdowbFqzqAa7vAh6CU0er4vgXg58BqlJ/3F6wSAtBjB7p04?=
 =?iso-8859-1?Q?en+BuC6dj2Yp/Ll8wpiEBcqXsybZ7y7+mwTFK/PhmgqrphoZnpI/P0DQE6?=
 =?iso-8859-1?Q?oFb5THmkoUoLdOlfOMyR0cA3Mgbp/MCJUdjmgCpvoAAZEe83sCO6qX0OWK?=
 =?iso-8859-1?Q?kJU2fH306H6gjptx1P0pPuYWUBjWepK11ZuH9u53P7ieR5bLrnce84Xu96?=
 =?iso-8859-1?Q?M6N2Dis2jeRUOLme6n+C6tC9X3PH7ugHQeyf+pgFj0TDGd0EcLUGcF+S9O?=
 =?iso-8859-1?Q?7vCP3cf+3I5pZAUE866WQRqS3kQVE1R10z1m8VVi+i1fCP4IpyFxxGNUBr?=
 =?iso-8859-1?Q?+3xwUc2H4u9OkEk0f0zJRUPtPTC+6gcwuZGnwGoKTX3B07QhlE1FOhld53?=
 =?iso-8859-1?Q?ZUiA6YLd/GiAgEwWDgNqO5N7lD7rWNtZ/JE5xi9+yzVWq0/5sJPqAKXj6u?=
 =?iso-8859-1?Q?YDVQiyOCikVdDZu8YyF5M5LNPSbg2FZ3/6cPvi82MPwnnH5P1bs/SPhztu?=
 =?iso-8859-1?Q?gRGJrfb/ZNtKXaHex8eSC4ySZNZeD0As0fJzpv0bYys0t3bUcpHK0IgBVA?=
 =?iso-8859-1?Q?WnjRTPM/ocMAFJ4WppbJRAL32idX3ftHK5VlpYFuc8TIz22ZGkOK5mONp6?=
 =?iso-8859-1?Q?JOpZ0yOxCoEnl9M1OYZSVZLJgNwSSHrVvPR5airpEU3VXltg20HdME5JVi?=
 =?iso-8859-1?Q?mhzfmi+eGHFvBV88qifem+uVDHsekTATsfoNca8xmZKtnE4aBgdaMYaA2G?=
 =?iso-8859-1?Q?SBEisVfOcNnwaksx/Ti1rnwI8RKDg+OtNM2YwR8WX12BdijjoMklkjTd0W?=
 =?iso-8859-1?Q?dpNZ1+TW6rm954I2m7sgHVCYIUVMOM6Yl6QV2jmVWtwrcNaByoA72T/yO9?=
 =?iso-8859-1?Q?107iUTCeF9efjd8FMYr+G+uj1eIAfzczsezv2Dt7OxqSraaOjcpD1ti8tM?=
 =?iso-8859-1?Q?9gTEKCojddk/TeBcUqSR253s0es/L1eG1O3kXgxSVeUKCwt0YS8XvM8RjX?=
 =?iso-8859-1?Q?0n+y3JXrd5dBXwzhcBUonhQ1uicy6E3seqsVrdA7fy0kTUNXHgq+VPeO+0?=
 =?iso-8859-1?Q?PQ9w/F//+fN6V7vYPSG/UFpRTc9rqOuavPCsmxTFKHvk/NXz63n8tNyPWh?=
 =?iso-8859-1?Q?tM57U0BWZsABuM9eWoT+wJb89MbJqtxqL6sZ2TqeIlhMuMXBxs/C6t5sEE?=
 =?iso-8859-1?Q?DxI8jy0UYDLDxpN537pzrN2T0MxfWWwuuw9s8bnRMd96yqrz3vXhNHF5GA?=
 =?iso-8859-1?Q?8xTFu3d+PNJjq4sNOS1/RSkPmFbNmaN14lTsxeJcPnUltm6mWMhgxEYMSQ?=
 =?iso-8859-1?Q?V1a8NUXFc7Fi8bCJcxEq2hIa8wtcoBsgrMCQFSjU5lipIPjaNWZq2VShO3?=
 =?iso-8859-1?Q?bJ0v638ZFMidvpGxEFrH7f2Nautiti8QIZygqtMfeCCRjdMTOb12byq4YE?=
 =?iso-8859-1?Q?15xVM7xxSutWe4acybK0/o7ei7vQ/2GUTyQvrXeqo963SjPhh0ZlHMl+U1?=
 =?iso-8859-1?Q?Y=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR11MB6522.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7416014)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?iso-8859-1?Q?cTFvw+fH1XMs4/xD0r0mCmcbx0P4yPhUSFfgqjtN7jpSil0DoGiKNO3WKL?=
 =?iso-8859-1?Q?XWpW5Slk197SuAgQAj3FKPS1hyNbEEkms/niSS12HzRYhN04AdmpxxpaBa?=
 =?iso-8859-1?Q?8rcJ2PIUTLcwrvJztio12PcSlGowvwLvWHiSkwAg20BTOAUp3Xmn9ZTDTc?=
 =?iso-8859-1?Q?M1fSkR9nJXDH8Ok7lA6z3Tua+cEejT+f42pVYkuJ3FXf7NwHhzhTfWe3AZ?=
 =?iso-8859-1?Q?tj/1OcB2ZkggL8I5558j96zxgClWYG4uoS4y8XkK7ieZnQn64T6/4yhyWd?=
 =?iso-8859-1?Q?xsLm3S4aPcYtZ5rWgaB+9YHPwkO1tz6qkPadv7z2B6Ek6BIZ3bne8to8KY?=
 =?iso-8859-1?Q?NbJGua7olNoqLQfvr76vkVKBFLGDmJuFmjTdd2/1bTjunOoasgtLh+yfE5?=
 =?iso-8859-1?Q?8aA1w49eIYjX1wZBwP/VsFAFFyUQt/r36CBKj2xx+343aSqVrx7m2EWkpw?=
 =?iso-8859-1?Q?I8BQ60sSQ4uo8SdSUn7K1HZb7jlrQOFDycZRboHNg1wqREOYMen/QifkE9?=
 =?iso-8859-1?Q?ooTw87rM50GvnTPbW4ZYkujKLlFvb3n/J450s4tEuduolirt78DOyjNPP6?=
 =?iso-8859-1?Q?XKlOQSuZqrR09n5w5SZf5OmGVSnrznmGh5KJ8aPEveKVHxkorEP76rkxx7?=
 =?iso-8859-1?Q?aqm6ftk+EdOqqmPwci1Hk/L/lHJtdOW1RC1fOi07QWO20VHQP11Xtjtr4p?=
 =?iso-8859-1?Q?2JkY2KdV2/50cAzOw9HsIriXzIwbWOXrYixmn1qw4HWz0OofzWGznitKTo?=
 =?iso-8859-1?Q?rkQCS11JJ257OERKamBkEgtg7IWLcKcu5u/5XPymURhanagKhT5nQlSXYQ?=
 =?iso-8859-1?Q?kTVIBU36RXwRoxcPoJXzWZhI2L+8WLm7FqON5RIV4fd/MranphX2Nk3+8r?=
 =?iso-8859-1?Q?k2J2PpxgbAxAxYWceKQDSenQSk4xR3f4Ut9/+1cnyaU1cRVDWSyhOLeHeg?=
 =?iso-8859-1?Q?wOAT+JCRA/e//Pp4h59H9NoAwJZs3BwzUV9+a6TQ/3mVNyPe6vV/zcdJ8/?=
 =?iso-8859-1?Q?z1WaDf151BkFSPffDGY1AnmZY2K7K16KT1jyT0qxii2JQy7//UddnN6Kjw?=
 =?iso-8859-1?Q?HQFKHtlWW+enVLaN2pLeA+vfOpqoHyYPeDziOK7OPDAJePU94Gfj+rUh+h?=
 =?iso-8859-1?Q?g6l9jImiXxh1SuanaSCGsvui3JNH0atUoepySU2MwoaGrdG8gT5R7DWa45?=
 =?iso-8859-1?Q?S4IqJJsLFHnat5dmWAtLim13+/MEYSUEkFFZVl85R4mGdNIS7unAcpHcsK?=
 =?iso-8859-1?Q?TTXafVjC9Gm/xRlM3GL15AOUAZdAwAE0Xem7nV0tKKkDK2ryZSc6nE0Dby?=
 =?iso-8859-1?Q?kp/U8hgROkuME9EYIxtb0K9Bqiq9X62Qbu7Vd+MClLZD2/XWB/zqJjQVCh?=
 =?iso-8859-1?Q?xKTkAmI+2WacWicsccqSDGzB/Bz/n7W7DA5VVZUfBCYuooUcpD4LO29FYd?=
 =?iso-8859-1?Q?7kZPc4OBzpdE8au1p0PrOBv478bEiNiMBo3gc2Tqo38pyzDuIV8RrF9HYc?=
 =?iso-8859-1?Q?11w8N7uLLFHxdjAxFWaHPxHyirRS0oRa08dEq2EtLsxG0yBbxMVhnvj9FE?=
 =?iso-8859-1?Q?Y5aX9ldTxczekh8WhFfhVBljqkRVG/W37tHDQYz3zj0T1gVOMT7MWABuba?=
 =?iso-8859-1?Q?Ea3XNbIQvlthBEERTzf+2YIk45+sgirFVbPlu5BWXuBlvnuZgCYwZnIg?=
 =?iso-8859-1?Q?=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 859449cb-ec9e-41a6-be5e-08ddeaad66d8
X-MS-Exchange-CrossTenant-AuthSource: PH7PR11MB6522.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Sep 2025 05:47:43.3786
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: X5BLRziSE8rxVV0SdZ+kQtmB0fzBdCs9ewd0vbeF1aAH3nXllsUKGWlU/R/CxrBWH+lhl/M1X7dC/p3K+sdoPw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR11MB4566
X-OriginatorOrg: intel.com

On Tue, Sep 02, 2025 at 03:07:13PM +0200, Francois Dugast wrote:
> Once support for THP migration of zone device pages is enabled, device
> private swap entries will be found during the walk not only for PTEs but
> also for PMDs.
> 
> Therefore, it is necessary to extend to PMDs the special handling which is
> already in place for PTEs when device private pages are owned by the
> caller: instead of faulting or skipping the range, the correct behavior is
> to use the swap entry to populate HMM PFNs.
> 
> This change is a prerequisite to make use of device-private THP in drivers
> using drivers/gpu/drm/drm_pagemap, such as xe.
> 
> Even though subsequent PFNs can be inferred when handling large order
> PFNs, the PFN list is still fully populated because this is currently
> expected by HMM users. In case this changes in the future, that is all HMM
> users support a sparsely populated PFN list, the for() loop can be made to
> skip remaining PFNs for the current order. A quick test shows the loop
> takes about 10 ns, roughly 20 times faster than without this optimization.
> 
> Link: https://lkml.kernel.org/r/20250829080505.1020155-1-francois.dugast@intel.com
> Signed-off-by: Francois Dugast <francois.dugast@intel.com>
> Acked-by: Balbir Singh <balbirs@nvidia.com>
> Cc: Jason Gunthorpe <jgg@nvidia.com>
> Cc: Leon Romanovsky <leonro@nvidia.com>
> Cc: Zi Yan <ziy@nvidia.com>
> Cc: Alistair Popple <apopple@nvidia.com>
> Cc: Balbir Singh <balbirs@nvidia.com>
> Cc: David Airlie <airlied@gmail.com>
> Cc: Christian König <christian.koenig@amd.com>
> Cc: Mika Penttilä <mpenttil@redhat.com>
> Cc: Thomas Hellstrom <thomas.hellstrom@linux.intel.com>
> Cc: Matthew Brost <matthew.brost@intel.com>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> ---
>  mm/hmm.c | 29 +++++++++++++++++++++++++++++
>  1 file changed, 29 insertions(+)
> 
> diff --git a/mm/hmm.c b/mm/hmm.c
> index d545e2494994..a8ac8d830e39 100644
> --- a/mm/hmm.c
> +++ b/mm/hmm.c
> @@ -355,6 +355,35 @@ static int hmm_vma_walk_pmd(pmd_t *pmdp,
>  	}
>  
>  	if (!pmd_present(pmd)) {
> +#ifdef CONFIG_ARCH_ENABLE_THP_MIGRATION
> +		swp_entry_t entry = pmd_to_swp_entry(pmd);
> +
> +		if (is_device_private_entry(entry) &&
> +		    pfn_swap_entry_folio(entry)->pgmap->owner ==
> +		    range->dev_private_owner) {
> +			unsigned long cpu_flags = HMM_PFN_VALID |
> +				hmm_pfn_flags_order(PMD_SHIFT - PAGE_SHIFT);
> +			unsigned long pfn = swp_offset_pfn(entry);
> +			unsigned long i;
> +
> +			if (is_writable_device_private_entry(entry))
> +				cpu_flags |= HMM_PFN_WRITE;
> +
> +			/*
> +			 * Fully populate the PFN list though subsequent
> +			 * PFNs could be inferred, because drivers which
> +			 * are not yet aware of large folios probably do
> +			 * not support sparsely populated PFN lists.
> +			 */
> +			for (i = 0; addr < end; addr += PAGE_SIZE, i++, pfn++) {
> +				hmm_pfns[i] &= HMM_PFN_INOUT_FLAGS;
> +				hmm_pfns[i] |= pfn | cpu_flags;
> +			}
> +
> +			return 0;
> +		}
> +#endif  /* CONFIG_ARCH_ENABLE_THP_MIGRATION */
> +


I believe you missed my comment in a previous rev. I think you need
something like this force a fault on dev_private_owner / pgmap->owner
mismatch.

               required_fault = hmm_range_need_fault(hmm_vma_walk, hmm_pfns,
                                                     npages, 0);
               if (required_fault) {
                       if (is_device_private_entry(entry))
                               return hmm_vma_fault(addr, end, required_fault, walk);
                       else
                               return -EFAULT;
               }

Matt

>  		if (hmm_eange_need_fault(hmm_vma_walk, hmm_pfns, npages, 0))
>  			return -EFAULT;
>  		return hmm_pfns_fill(start, end, range, HMM_PFN_ERROR);
> -- 
> 2.43.0
> 
