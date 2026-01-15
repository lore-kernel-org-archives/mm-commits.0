Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 627C03594F
	for <mm-commits@vger.kernel.org>; Thu, 15 Jan 2026 02:31:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.13
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768444320; cv=fail; b=gnC/qTCFyJpGlGS217VMJmEqBqCzk/u1cMl98BcHKIHKfOFd2XKKlUquOZLwtckMynlzECe+2cbnTsU7SxqkLCDRsUOl7rvif7iFO4QR5VeiCc6fpjsagZ9aAPMJJtGGN73dHYRL2qhuFnQO34GiuKfKBkYOS5WqCekdNaLwwXw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768444320; c=relaxed/simple;
	bh=OmiTZ7/4U+3xN5Jb3dDpizcE7APZ8O2wQALXFRRtSrc=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=rkjwHZfhk9dJb0nnU12YjOemGxWMsRZFiMKDzjbUGXTeLS5D2budNlZXMSFumSCNbYQaYVqacdXeXjbA1jVh4Vi0u2DeKRdQYkb37fOXqNY2dmPLeJcEdu7FsHiXmW5QbvQ42vUSCqcVw2jCToGvgO3bTgFRE7DM+t5C7CbKNT4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=UYO3zv2x; arc=fail smtp.client-ip=192.198.163.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="UYO3zv2x"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1768444318; x=1799980318;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=OmiTZ7/4U+3xN5Jb3dDpizcE7APZ8O2wQALXFRRtSrc=;
  b=UYO3zv2x1xjM9ErxRKTUx6oU8LPDycqGeWQTpfWkfHaGmS7mEfRFbazD
   vtDzkGTmWZlNy+Qhe3Zp6CSJ2s2GFAoA0F4ZFqoORxsJgqpgDda9r6oAU
   KQHy1x53SCZQDMyjYn5UUMmnzHcvNBV4H0OQuXl+BhV5xJFjWsX6Lxfi7
   DUgI8IaYR2g4OKD+mqLlFlWXRnUX9OuM0sWqCcyqkB857n7qgiB5WYvHJ
   d+k7P9Wlh5cw0e3Bp1mux2pfv1Ms4demVP1GXZlaquAKKxiR5eqdQW1+N
   0EOBXpYKBMNGyPhleiSxl8UK83GwwaCilWr38IsKsEIVNdhKrhr/Aac1d
   w==;
X-CSE-ConnectionGUID: eUnKOmiaRG2uK7vtbrejbg==
X-CSE-MsgGUID: ACK5YkacTuml0U9oPzBxqQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11671"; a="72335848"
X-IronPort-AV: E=Sophos;i="6.21,226,1763452800"; 
   d="scan'208";a="72335848"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jan 2026 18:31:58 -0800
X-CSE-ConnectionGUID: reUFbvrrS4mpvJGchOevJQ==
X-CSE-MsgGUID: XAWbi+q/S/u101kT1HXzIA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,226,1763452800"; 
   d="scan'208";a="209308792"
Received: from fmsmsx902.amr.corp.intel.com ([10.18.126.91])
  by fmviesa005.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jan 2026 18:31:57 -0800
Received: from FMSMSX903.amr.corp.intel.com (10.18.126.92) by
 fmsmsx902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Wed, 14 Jan 2026 18:31:55 -0800
Received: from fmsedg903.ED.cps.intel.com (10.1.192.145) by
 FMSMSX903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29 via Frontend Transport; Wed, 14 Jan 2026 18:31:55 -0800
Received: from PH0PR06CU001.outbound.protection.outlook.com (40.107.208.18) by
 edgegateway.intel.com (192.55.55.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Wed, 14 Jan 2026 18:31:54 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=NWmXcpVyu63/nNabonpdw5RKBqBm2YQHb3OpBKoT/xbDsuBnpDYOZX/Gg5vmCYz12mQ2kzv/AE4vnc+Hsq6hX+hWobCp8se8yWtezek6HzzwFJAlhGDPjcBsAqrESOes96BuTmvdT/qcPmOMM4dUtMIie9zmjsem3uGCW03wMQN2RJd9OJZiLswxlLWma6gEcMYDURleLoJo6w0KH02NTxi3EPudOnYpkl0P8EeRmQ6tQ+akib565oENTEDgCOX8pnRhfwvIWWpXfIwgb0boUqatkavFzrUNKeJ1MvrY3G+FoS+ypPDBt+BRVxCgRXF+F96ApSYctL+eNA4GNZxFbA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YV7KdJq0mdw9ylMR6YrLXlXz6CZyTiVY15yUciie6Eg=;
 b=XNerDWum9xZ+YIq5zwwVMEY34V1Yya9n1Og0y+IRoeh9ByHw0ExSB9f5mVajD6sUTnxkrPuvXFiFbjjWv0vQGDDD1VBp91O1b6mhEl05ka7Ht8bKc7H/eDEfshpyxuThYQ1UmFLn2ntQlJNtRz2cE7gVhXgbC51NUQvcTfLYk3D+L4+66lSg+ygcbFckDvUF8CP8zKgIBn6HnxjLGumXTunGZTa6u058tKJBvn7l/ntZ1F3s4vGvLQqrg6v9RFPLuITdQ6fA0D1IpRkEwcTQWSyKADNbPzVU1RzXFKOUHLDnsG++CY2op2rtc152nynN6ykFFkasji/9GUreia9ghA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH7PR11MB6522.namprd11.prod.outlook.com (2603:10b6:510:212::12)
 by CY8PR11MB7799.namprd11.prod.outlook.com (2603:10b6:930:78::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9520.5; Thu, 15 Jan
 2026 02:31:53 +0000
Received: from PH7PR11MB6522.namprd11.prod.outlook.com
 ([fe80::9e94:e21f:e11a:332]) by PH7PR11MB6522.namprd11.prod.outlook.com
 ([fe80::9e94:e21f:e11a:332%7]) with mapi id 15.20.9456.015; Thu, 15 Jan 2026
 02:31:52 +0000
Date: Wed, 14 Jan 2026 18:31:49 -0800
From: Matthew Brost <matthew.brost@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
CC: <mm-commits@vger.kernel.org>, <ziy@nvidia.com>, <vbabka@suse.cz>,
	<tzimmermann@suse.de>, <surenb@google.com>, <simona@ffwll.ch>,
	<rppt@kernel.org>, <osalvador@suse.de>, <npiggin@gmail.com>,
	<mripard@kernel.org>, <mpe@ellerman.id.au>, <mhocko@suse.com>,
	<maddy@linux.ibm.com>, <maarten.lankhorst@linux.intel.com>,
	<lyude@redhat.com>, <lorenzo.stoakes@oracle.com>, <Liam.Howlett@oracle.com>,
	<leon@kernel.org>, <jgg@ziepe.ca>, <francois.dugast@intel.com>,
	<Felix.Kuehling@amd.com>, <david@kernel.org>, <dakr@kernel.org>,
	<christian.koenig@amd.com>, <chleroy@kernel.org>, <balbirs@nvidia.com>,
	<apopple@nvidia.com>, <alexander.deucher@amd.com>, <airlied@gmail.com>
Subject: Re: +
 mm-zone_device-reinitialize-large-zone-device-private-folios.patch added to
 mm-hotfixes-unstable branch
Message-ID: <aWhRlcANsVnqMx1S@lstrano-desk.jf.intel.com>
References: <20260114215029.F3356C4CEF7@smtp.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20260114215029.F3356C4CEF7@smtp.kernel.org>
X-ClientProxiedBy: SJ0PR13CA0204.namprd13.prod.outlook.com
 (2603:10b6:a03:2c3::29) To PH7PR11MB6522.namprd11.prod.outlook.com
 (2603:10b6:510:212::12)
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH7PR11MB6522:EE_|CY8PR11MB7799:EE_
X-MS-Office365-Filtering-Correlation-Id: f70afcbc-1b2f-4362-4fd0-08de53de3e0a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|366016|1800799024;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?9b9aTN0VJTI2UHue43cw4h/chB/wuyrmJMYFwh8l6MJ7jmHLn8fn2ouMrXZW?=
 =?us-ascii?Q?mZD1AivFheGhQeqo2MwdlilZjprn50/+trCjysk4dRRQAa2lzbT2ln7v6LFf?=
 =?us-ascii?Q?rfxbrZA9rHHGW49YN0dsEMkWTFKomSMMK9NAtE1vV85HjAn0OTk3ZyAICDt0?=
 =?us-ascii?Q?d5rfMcoq+YaRIqT8mEnRq/FBRapsoiGmAiGUjG1665px9QdcL9JU/cJcGUDK?=
 =?us-ascii?Q?+FbCH4ST/qoYmwr29jyD27aNzGzMltm5tf/kuOi8ZGm9MYyESSIn53r4iPLt?=
 =?us-ascii?Q?5Dlalf3pioG0x4rmk78/MdLX2HCc2tOPNZBFrGIJsGjZRWItDGjBdhEno1pJ?=
 =?us-ascii?Q?TV2hLbLfe77J0TuDb7JWQOUiWqDy6GBuUX04ePNNKUrqln81J2zj/qR/VSeJ?=
 =?us-ascii?Q?S14dx7aLEjUlzBLrjWCcaoROUvOY2JLp0Rd6AC6ZGcZa8Sa8qOKcQb70IAUB?=
 =?us-ascii?Q?OTTA+nfK+pPtSfVQczxTu6iPiIsdnasD20jcEn/b2SVh4fyRWc2AS7CKfimU?=
 =?us-ascii?Q?mqB7NPALJBLgZoWwR7PbYWC3AlnwX1Cy3N3B5WtWDAhcyDekvPD6GVAxSqTe?=
 =?us-ascii?Q?SI5S3SkqO3JjLj4voGvadsddXTAX3DFXdfwFovMnbziF2uV/+uCtLwVZxH9p?=
 =?us-ascii?Q?7nzu3tYBnnDw7PGQspenn0DY6f9/HhTSFsy30PqqvSKiFzfIQ94MGH07nP/A?=
 =?us-ascii?Q?xb9OTTQq2J4RISzWtHUb39o8dzswCnzHnJnO3Wi+vJZ5HTgW3KvuuhxONcQc?=
 =?us-ascii?Q?YmdEKkgT/Vcdpsc2I8F4T88UlNii3Tqv6MlRvdbuUjesGG6ctw5Th2W5Sv4b?=
 =?us-ascii?Q?Rs8wmu+8mzp3PV4NTJEmiUVwJ7k93QQCkcqrQoyQ/0bI4KXAhRWkr1XAdhHH?=
 =?us-ascii?Q?+OSjQyEyrGzEXHgWHq/be54YAdYZB5sORazBcNabyV0lw3ntsLaKk66BE5BG?=
 =?us-ascii?Q?p+ecANgqHaMghjmyHT+OPilGeq/qyYCGqVMFmDCLf+s7AukLuYcx/NYep3AQ?=
 =?us-ascii?Q?MiP5ghhhteoTZCoCC8iLGt6G22yjrWLbEjJcsK18VjdE2Y83FWAihYIVFYcN?=
 =?us-ascii?Q?Gp10VRCoQYHILEXCItQPIT9gSLnXhQDNSXh48hz3LhCzYC9xV5GSS/EdjXCj?=
 =?us-ascii?Q?0ojX6/T9n65aQ/bwK/WFMih52VOJCciaZZ9cN7KGwXe61+qxMnsuxmQSqO86?=
 =?us-ascii?Q?A6BaP92HjmMBpjhznmbU9MSpobiq2nGGz7P3MT9g86R79g/MDFsrSEScE7nV?=
 =?us-ascii?Q?lrQ8EfDlc1kJ39/YlrGRxfFhWHlKrkwTjNPWTtuBTtWbGTRJgkPqnAafBLD3?=
 =?us-ascii?Q?q/eHpyPBgtHYSWV6Sdu4n6DCVCYEpORpFARMQvtjv9eXJhKeIQcMNyvh6hOZ?=
 =?us-ascii?Q?gwNlPqZP+7I32MQPSVKuyhn+wJOafG5sZCLvZnFwLwgeUys3T/kGiac4X7qZ?=
 =?us-ascii?Q?QzRLDv3oA42pIWNOX8MZHcdP/pJh+WQwB9K4Wu0BENdpXUxDcbggzO2/RS39?=
 =?us-ascii?Q?W5M0lyVIUbtoHY2KUjJIGpn7LBTavAejMu3cJ2uyOONJ1kVNyDqcGid3a/mr?=
 =?us-ascii?Q?aCQ37RJIIdoHQ79NJjtEIe1qQAxyfRM53ehZFXqP?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR11MB6522.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?pqIkhsD6+haKsEa231Nl9mK3rKCJGhSjnT0m4ITljfKB1BTtj/YnXXo1ZJt3?=
 =?us-ascii?Q?XrilhuHq+LFagEK3+2RTs+P35Zst/7kC00g4MW0X1JfYc4JMYfB1c8c5GkhX?=
 =?us-ascii?Q?9FkbS020BWUXVqllU2SX5PweOrE08C9Zl7kOqfGJ0yz3XCVHRphMzYz84ytJ?=
 =?us-ascii?Q?ZP87HfyOJY5YNGjhb3/Qa37oQdQHSGOxXNuIz+JEoW6Ffk8jdigC4zOw/sk6?=
 =?us-ascii?Q?r7CyMKbEGUOckNE9fFCEG61ajnErukxn0jxF/LU6Eu0Kpy38P2csawjIc+EH?=
 =?us-ascii?Q?U84qb2WvqWwmmtDTjjkJ7snqu04+olSadU5TkeknyA6HKE3pxJEbbdNL7/nR?=
 =?us-ascii?Q?qHLQ75rXyBe4S4IT2QPaI6p61qUZcY3ciOrhmovSOqnnXirS5nfPlL0ojsRh?=
 =?us-ascii?Q?7vh/DQY3rz0FO0SmeC/9KFS9JAborw8LVW98cvfMt3EehjgjabYN927ADoDU?=
 =?us-ascii?Q?KynXwk8e6TuIpsXeMLs3X0MjEPxA1M3u5a5IwuTwLbKBXOaq4PeeZ9lcH7st?=
 =?us-ascii?Q?bXnkLrJeQ8HmW/gQuDa62UhzVIfluj7QQw19/iOs3lvpgT6ivIsprjeSXrMc?=
 =?us-ascii?Q?86ym58cT/5poFsCgiwGJuo4HH0Qz9qPCFMGVkSzSpVgr2VhklYWnFENaPJxK?=
 =?us-ascii?Q?QHs5jZ6Y916rVj1ZQaZ3s9VWkTQaxzcGju26wKjgCBQbvhV5nbnDfq6i0j4k?=
 =?us-ascii?Q?/bV94XB/8w1NLdUEg9L4JYY4IV/inz+5QaOTXVghPB66feBlvIrFVwryulnd?=
 =?us-ascii?Q?dFc+b6/JRVIIV21ucT9mp0Irw6QehIzvG5nQBWZ0f+DiX1GbjuGxo18G/Unt?=
 =?us-ascii?Q?1INqa1hNLG4mgj1k95vQpVsxPmx06N5rt4vf90B2HEq63EM1zDGXcRs//yAg?=
 =?us-ascii?Q?ZZ7TGLaB0iYxz+BRwFn7eONQQTZiP23juONrmz0WMN9TbFuSY/mOcKQpePHw?=
 =?us-ascii?Q?kWDP3E/eA+ggMWW6OYIOohkTU8Qyl2GLZNyXIZAxlCzCDu1ev/ZjkoWaTXY2?=
 =?us-ascii?Q?8eSiDRyYvFY/pG1El2ZpuuliEFhiFD87Do1/X/rscehVbkSjx80Km9IZomxz?=
 =?us-ascii?Q?4+qg213UxWyADqCzqys7vp9DPNYZGrKRvRoA3dMg3hLKFeqpNFrYePnPJX+X?=
 =?us-ascii?Q?cW+ExeKLq6tN/oOoYdKMOLN+GTZWIXh1fwSEuMKHun8mRRPviQNhafyWpcoy?=
 =?us-ascii?Q?l5nRCTVKkRw1dAwSTGNQot9/0AeNwbJWfswNCL45TNRbYiLH3elQsdGdydIM?=
 =?us-ascii?Q?dy9CDNW7qKK10vWCx/ZoGvz2Sn74c7eKniLo+3zO7qrhZ6avjb/nqWwY02Ke?=
 =?us-ascii?Q?vfPE/MlXB3RtO1a3oJR36CY+cTyHtqcJpPEsBVH8NMNJ1veVRDwdYl9RoJ+Q?=
 =?us-ascii?Q?gY5siJ1iqnWI80uq0X1scwGYfn7VYGERrYp2i/bDQ36Y162JwZd4RlbpgyCc?=
 =?us-ascii?Q?5ide5n9LaQjobLiVP8YW3Gaj+/ZNk7vrkpW2Fbmo0+rCPXJERhXp2I584/DA?=
 =?us-ascii?Q?ceIYwqQtNxgLu55SDedCiYHE5LDa24jK3MEgCTrBTOQFZgCD1eEXLuVvBVv2?=
 =?us-ascii?Q?GD2u+yznLccLG/2WBV7mWsY8Ow+8WUpCsZ4NTCx132V70G54nw3dZjwlvg7/?=
 =?us-ascii?Q?0dpCn+D6v1MIJbxkhJsoRwHNX6PYaEpogq1MmxsVSODQrvWAf8BIKSFhRhFD?=
 =?us-ascii?Q?FwJ8A4xgNjG0yAM6ZuDRMqUOt33V+naEdikmjysJgzlIqcaW0S+FycGiaQy/?=
 =?us-ascii?Q?Ttbcy9Mu7wG1U8KEPVQ96XwKL+kVCNY=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: f70afcbc-1b2f-4362-4fd0-08de53de3e0a
X-MS-Exchange-CrossTenant-AuthSource: PH7PR11MB6522.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Jan 2026 02:31:52.3184
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: iD7+pgZy94Vn845TRGT6sfkT4t6xi9AtVZVEdqSQW7XTIZ0tvhalBuG/C8feIXIrIZPH2sC7KE8+yUQfFhX66A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR11MB7799
X-OriginatorOrg: intel.com

On Wed, Jan 14, 2026 at 01:50:29PM -0800, Andrew Morton wrote:
> 

Any chance I can merge this one through drm?

This would make my life easier to get the subsequent patches in the
series into the next kernel release PR.

Matt  

> The patch titled
>      Subject: mm/zone_device: reinitialize large zone device private folios
> has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
>      mm-zone_device-reinitialize-large-zone-device-private-folios.patch
> 
> This patch will shortly appear at
>      https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-zone_device-reinitialize-large-zone-device-private-folios.patch
> 
> This patch will later appear in the mm-hotfixes-unstable branch at
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
> The -mm tree is included into linux-next via various
> branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
> and is updated there most days
> 
> ------------------------------------------------------
> From: Matthew Brost <matthew.brost@intel.com>
> Subject: mm/zone_device: reinitialize large zone device private folios
> Date: Wed, 14 Jan 2026 20:19:52 +0100
> 
> Reinitialize metadata for large zone device private folios in
> zone_device_page_init prior to creating a higher-order zone device private
> folio.  This step is necessary when the folio's order changes dynamically
> between zone_device_page_init calls to avoid building a corrupt folio.  As
> part of the metadata reinitialization, the dev_pagemap must be passed in
> from the caller because the pgmap stored in the folio page may have been
> overwritten with a compound head.
> 
> Link: https://lkml.kernel.org/r/20260114192111.1267147-2-francois.dugast@intel.com
> Fixes: d245f9b4ab80 ("mm/zone_device: support large zone device private folios")
> Signed-off-by: Matthew Brost <matthew.brost@intel.com>
> Signed-off-by: Francois Dugast <francois.dugast@intel.com>
> Cc: Zi Yan <ziy@nvidia.com>
> Cc: Alistair Popple <apopple@nvidia.com>
> Cc: Madhavan Srinivasan <maddy@linux.ibm.com>
> Cc: Nicholas Piggin <npiggin@gmail.com>
> Cc: Michael Ellerman <mpe@ellerman.id.au>
> Cc: "Christophe Leroy (CS GROUP)" <chleroy@kernel.org>
> Cc: Felix Kuehling <Felix.Kuehling@amd.com>
> Cc: Alex Deucher <alexander.deucher@amd.com>
> Cc: "Christian K??nig" <christian.koenig@amd.com>
> Cc: David Airlie <airlied@gmail.com>
> Cc: Simona Vetter <simona@ffwll.ch>
> Cc: Maarten Lankhorst <maarten.lankhorst@linux.intel.com>
> Cc: Maxime Ripard <mripard@kernel.org>
> Cc: Thomas Zimmermann <tzimmermann@suse.de>
> Cc: Lyude Paul <lyude@redhat.com>
> Cc: Danilo Krummrich <dakr@kernel.org>
> Cc: David Hildenbrand <david@kernel.org>
> Cc: Oscar Salvador <osalvador@suse.de>
> Cc: Jason Gunthorpe <jgg@ziepe.ca>
> Cc: Leon Romanovsky <leon@kernel.org>
> Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
> Cc: Liam R. Howlett <Liam.Howlett@oracle.com>
> Cc: Vlastimil Babka <vbabka@suse.cz>
> Cc: Mike Rapoport <rppt@kernel.org>
> Cc: Suren Baghdasaryan <surenb@google.com>
> Cc: Michal Hocko <mhocko@suse.com>
> Cc: Balbir Singh <balbirs@nvidia.com>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> ---
> 
>  arch/powerpc/kvm/book3s_hv_uvmem.c       |    2 +-
>  drivers/gpu/drm/amd/amdkfd/kfd_migrate.c |    2 +-
>  drivers/gpu/drm/drm_pagemap.c            |    2 +-
>  drivers/gpu/drm/nouveau/nouveau_dmem.c   |    2 +-
>  include/linux/memremap.h                 |    9 ++++++---
>  lib/test_hmm.c                           |    4 +++-
>  mm/memremap.c                            |   20 +++++++++++++++++++-
>  7 files changed, 32 insertions(+), 9 deletions(-)
> 
> --- a/arch/powerpc/kvm/book3s_hv_uvmem.c~mm-zone_device-reinitialize-large-zone-device-private-folios
> +++ a/arch/powerpc/kvm/book3s_hv_uvmem.c
> @@ -723,7 +723,7 @@ static struct page *kvmppc_uvmem_get_pag
>  
>  	dpage = pfn_to_page(uvmem_pfn);
>  	dpage->zone_device_data = pvt;
> -	zone_device_page_init(dpage, 0);
> +	zone_device_page_init(dpage, &kvmppc_uvmem_pgmap, 0);
>  	return dpage;
>  out_clear:
>  	spin_lock(&kvmppc_uvmem_bitmap_lock);
> --- a/drivers/gpu/drm/amd/amdkfd/kfd_migrate.c~mm-zone_device-reinitialize-large-zone-device-private-folios
> +++ a/drivers/gpu/drm/amd/amdkfd/kfd_migrate.c
> @@ -217,7 +217,7 @@ svm_migrate_get_vram_page(struct svm_ran
>  	page = pfn_to_page(pfn);
>  	svm_range_bo_ref(prange->svm_bo);
>  	page->zone_device_data = prange->svm_bo;
> -	zone_device_page_init(page, 0);
> +	zone_device_page_init(page, page_pgmap(page), 0);
>  }
>  
>  static void
> --- a/drivers/gpu/drm/drm_pagemap.c~mm-zone_device-reinitialize-large-zone-device-private-folios
> +++ a/drivers/gpu/drm/drm_pagemap.c
> @@ -197,7 +197,7 @@ static void drm_pagemap_get_devmem_page(
>  					struct drm_pagemap_zdd *zdd)
>  {
>  	page->zone_device_data = drm_pagemap_zdd_get(zdd);
> -	zone_device_page_init(page, 0);
> +	zone_device_page_init(page, zdd->dpagemap->pagemap, 0);
>  }
>  
>  /**
> --- a/drivers/gpu/drm/nouveau/nouveau_dmem.c~mm-zone_device-reinitialize-large-zone-device-private-folios
> +++ a/drivers/gpu/drm/nouveau/nouveau_dmem.c
> @@ -425,7 +425,7 @@ nouveau_dmem_page_alloc_locked(struct no
>  			order = ilog2(DMEM_CHUNK_NPAGES);
>  	}
>  
> -	zone_device_folio_init(folio, order);
> +	zone_device_folio_init(folio, page_pgmap(folio_page(folio, 0)), order);
>  	return page;
>  }
>  
> --- a/include/linux/memremap.h~mm-zone_device-reinitialize-large-zone-device-private-folios
> +++ a/include/linux/memremap.h
> @@ -224,7 +224,8 @@ static inline bool is_fsdax_page(const s
>  }
>  
>  #ifdef CONFIG_ZONE_DEVICE
> -void zone_device_page_init(struct page *page, unsigned int order);
> +void zone_device_page_init(struct page *page, struct dev_pagemap *pgmap,
> +			   unsigned int order);
>  void *memremap_pages(struct dev_pagemap *pgmap, int nid);
>  void memunmap_pages(struct dev_pagemap *pgmap);
>  void *devm_memremap_pages(struct device *dev, struct dev_pagemap *pgmap);
> @@ -234,9 +235,11 @@ bool pgmap_pfn_valid(struct dev_pagemap
>  
>  unsigned long memremap_compat_align(void);
>  
> -static inline void zone_device_folio_init(struct folio *folio, unsigned int order)
> +static inline void zone_device_folio_init(struct folio *folio,
> +					  struct dev_pagemap *pgmap,
> +					  unsigned int order)
>  {
> -	zone_device_page_init(&folio->page, order);
> +	zone_device_page_init(&folio->page, pgmap, order);
>  	if (order)
>  		folio_set_large_rmappable(folio);
>  }
> --- a/lib/test_hmm.c~mm-zone_device-reinitialize-large-zone-device-private-folios
> +++ a/lib/test_hmm.c
> @@ -662,7 +662,9 @@ static struct page *dmirror_devmem_alloc
>  			goto error;
>  	}
>  
> -	zone_device_folio_init(page_folio(dpage), order);
> +	zone_device_folio_init(page_folio(dpage),
> +			       page_pgmap(folio_page(page_folio(dpage), 0)),
> +			       order);
>  	dpage->zone_device_data = rpage;
>  	return dpage;
>  
> --- a/mm/memremap.c~mm-zone_device-reinitialize-large-zone-device-private-folios
> +++ a/mm/memremap.c
> @@ -477,10 +477,28 @@ void free_zone_device_folio(struct folio
>  	}
>  }
>  
> -void zone_device_page_init(struct page *page, unsigned int order)
> +void zone_device_page_init(struct page *page, struct dev_pagemap *pgmap,
> +			   unsigned int order)
>  {
> +	struct page *new_page = page;
> +	unsigned int i;
> +
>  	VM_WARN_ON_ONCE(order > MAX_ORDER_NR_PAGES);
>  
> +	for (i = 0; i < (1UL << order); ++i, ++new_page) {
> +		struct folio *new_folio = (struct folio *)new_page;
> +
> +		new_page->flags.f &= ~0xffUL;	/* Clear possible order, page head */
> +#ifdef NR_PAGES_IN_LARGE_FOLIO
> +		((struct folio *)(new_page - 1))->_nr_pages = 0;
> +#endif
> +		new_folio->mapping = NULL;
> +		new_folio->pgmap = pgmap;	/* Also clear compound head */
> +		new_folio->share = 0;   /* fsdax only, unused for device private */
> +		VM_WARN_ON_FOLIO(folio_ref_count(new_folio), new_folio);
> +		VM_WARN_ON_FOLIO(!folio_is_zone_device(new_folio), new_folio);
> +	}
> +
>  	/*
>  	 * Drivers shouldn't be allocating pages after calling
>  	 * memunmap_pages().
> _
> 
> Patches currently in -mm which might be from matthew.brost@intel.com are
> 
> mm-zone_device-reinitialize-large-zone-device-private-folios.patch
> 
