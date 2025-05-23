Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 520831A288
	for <mm-commits@vger.kernel.org>; Fri, 23 May 2025 07:49:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.10
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747986544; cv=fail; b=BEJr+iBwpiRAyh0Wl/oCHeb65mepSUPSAc82YChjAlFKqHiDzgF6pGypIJtiECG1ol/6fr5grtTvLEtQ3ayTz6yWov7cFyrHe1x5DANqVKGHdgXHtVAeFO/GPIjVSzSh/Yj8yQm8n1GeSlKYCg2aAW4Z+fZ1HmeoxqNlW5rRq2A=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747986544; c=relaxed/simple;
	bh=k42y3DNaPvMxea0XBwE9g7lectRZBO4m40H5cJgr8jA=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=gGG2gCNFFoBQsCBQj2s3LLu3LYXVxYTW45Vos4CKIyhFE5Db7tM5FUIuKsdNvwU9WRMS1taPBVN/pTiTu2WMaRcCfFnvuBmXriSH7wl/8IPGri3Svig4/trsBYieOc5xR3Guaud9uAwWbUJNJR8EWC+Kt+AFstQZoPOo2MapmGE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=lIAkUI7m; arc=fail smtp.client-ip=198.175.65.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="lIAkUI7m"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1747986544; x=1779522544;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=k42y3DNaPvMxea0XBwE9g7lectRZBO4m40H5cJgr8jA=;
  b=lIAkUI7m2P+9ALEPjLAox04fQlBCihZ7fnsO/713RQ6ROUUfdfzjY4MK
   OtZIW7GVuSvA/3951xmnwiuv9xfXqcHnTrzvQDxqEUaEA3kT3DRUW47hh
   eA5krhg9dYtmMKgyoYvADTjcZPJLom9lKIUFsJcy3SDpt+s87wyOwJK9G
   Vf8MrhH4NpP9vNREYOFUgbotT3DcRAp8NJjM6ApsQPxEq0+c/n1coWfpq
   eSIB9VFQe6shteKLugOcAvKtvlDEKdO/rvFj++A6BVpZNK7agAgcogH/i
   lw7Nc8F9lfFiI/5DUCbpljj9OjiqwhysumWmiaxb1pjQB8lU/uZtVeujw
   w==;
X-CSE-ConnectionGUID: jhVgTkPVSxmghmCjeLj+Dw==
X-CSE-MsgGUID: TEiVxYgPSUSMBX2uAXon+Q==
X-IronPort-AV: E=McAfee;i="6700,10204,11441"; a="67449422"
X-IronPort-AV: E=Sophos;i="6.15,308,1739865600"; 
   d="scan'208";a="67449422"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 May 2025 00:49:03 -0700
X-CSE-ConnectionGUID: YgLaBtPbRfS/fA9igPe6FQ==
X-CSE-MsgGUID: fUcYc5+mSOOScw41Afc+5g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,308,1739865600"; 
   d="scan'208";a="141580959"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by orviesa007.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 May 2025 00:49:03 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Fri, 23 May 2025 00:49:02 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25 via Frontend Transport; Fri, 23 May 2025 00:49:02 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (40.107.236.46)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.55; Fri, 23 May 2025 00:49:02 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=cNYeb0YeDCJZu+/cOq1fyI1WMgiacachjb/+agcI1UW1VhUlI5yJHXOeYcmP+9gBHnVxmZt+GzhuJzx5nHhdXWXMqhw2rvnAP3HnBlkX7UcSY3gbP94B+/gLY4XrNeuyeitxlNzYxZFdOrGDCuHulBcW/4F6nP1MRCjPRUMkh0PhkrhUfczfDN6xVnwbyATzvAjaeoVr6+i0eTagP5i9Saca80uJidNH9GcJ0w2lUmFkoPjn+To34UwuHwZ7TUNpe8D4nQyoqfuMLhWOJ0yShzidMwPZIxXj3+9InOTLhBshTc01wFftjKOqdBI60LE1vtAl23j5xdG0s2Smw+tKPA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wZ/tYwT04CVnZA6FEUbiSiZgtCI9AAnY9tQlQ9AKsk8=;
 b=rZKB74Z1q/946q/ukuZSFx/A5VbnrAfNfkErsCdS7v0jGp83NvPEemSm8Oz54qeaoknconHl9fA1hEPFNQEM/JHYReq0yiee9p0l+Meg0dnnOIb1umbS+lcE9B9bL3TG5O7ZZyHrk/4tRmGYUEd5ut8k+iMHdcHO3i8JtIuOmrFEVQLuCQhnMT3yHJAqWY/cHKzWAjobqNIiPksMNkjgyC26OesL0GxTwzWlJ6PXNfLsNrmAHXxBiZ9JUv9Mi9t4iEK52n6GXLF6dBGtahK5yMhpXIBNlGJf3W7tvwiNFhKh0MsccPQCrtW2jl3ls2YzY8MyqmIt+EPo0VWfwm6aRw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM4PR11MB6020.namprd11.prod.outlook.com (2603:10b6:8:61::19) by
 CY5PR11MB6209.namprd11.prod.outlook.com (2603:10b6:930:27::16) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8769.20; Fri, 23 May 2025 07:48:59 +0000
Received: from DM4PR11MB6020.namprd11.prod.outlook.com
 ([fe80::4af6:d44e:b6b0:fdce]) by DM4PR11MB6020.namprd11.prod.outlook.com
 ([fe80::4af6:d44e:b6b0:fdce%6]) with mapi id 15.20.8722.027; Fri, 23 May 2025
 07:48:59 +0000
Message-ID: <223a8f82-52cd-490a-a507-d693edf77d0b@intel.com>
Date: Fri, 23 May 2025 15:48:45 +0800
User-Agent: Mozilla Thunderbird
Subject: Re: [merged mm-stable]
 sched-numa-fix-task-swap-by-skipping-kernel-threads.patch removed from -mm
 tree
To: Andrew Morton <akpm@linux-foundation.org>, Libo Chen
	<libo.chen@oracle.com>
CC: K Prateek Nayak <kprateek.nayak@amd.com>, Peter Zijlstra
	<peterz@infradead.org>, <mm-commits@vger.kernel.org>,
	<vineethr@linux.ibm.com>, <venkat88@linux.ibm.com>, <tj@kernel.org>,
	<tim.c.chen@intel.com>, <shakeel.butt@linux.dev>, <roman.gushchin@linux.dev>,
	<muchun.song@linux.dev>, <mkoutny@suse.com>, <mingo@redhat.com>,
	<mhocko@kernel.org>, <mgorman@suse.de>, <hannes@cmpxchg.org>,
	<corbet@lwn.net>, <Ayush.jain3@amd.com>, <aubrey.li@intel.com>
References: <20250521165653.4CFACC4CEE4@smtp.kernel.org>
 <20250521191114.GE24938@noisy.programming.kicks-ass.net>
 <20250521135854.3ba2d1f61bd2c6a4af36ac13@linux-foundation.org>
 <021d2962-2fba-4c27-ae9f-4ded2df44903@amd.com>
 <27831b60-53f1-4348-b33e-1f30900e29a6@oracle.com>
 <20250522145659.91bb0bc4c8affc8e62306e0d@linux-foundation.org>
Content-Language: en-US
From: "Chen, Yu C" <yu.c.chen@intel.com>
In-Reply-To: <20250522145659.91bb0bc4c8affc8e62306e0d@linux-foundation.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: KL1PR01CA0157.apcprd01.prod.exchangelabs.com
 (2603:1096:820:149::18) To DM4PR11MB6020.namprd11.prod.outlook.com
 (2603:10b6:8:61::19)
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR11MB6020:EE_|CY5PR11MB6209:EE_
X-MS-Office365-Filtering-Correlation-Id: 2f8630f6-f4a5-41bd-b083-08dd99ce4731
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|7416014|366016;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?cXd4N3c0WkgrRHNMQ2tYdURTeW9oUlpjcHF0UnhzR0ViQ0JrUjk0TkRqbWlo?=
 =?utf-8?B?QUFzSmZyMGNKNUNEM0NIei91QVcyYUFrSmFnUzE3OXZlZ1ZjU3RmcmlCRHB5?=
 =?utf-8?B?eURKQkdjRnlySWs4L0NiS3N6aXMxOS9od1RPMVk1SmM5YTVCdVdqOFJveHE4?=
 =?utf-8?B?NG1wTTFoZjl2dG5CVVRqa2IveVVvZE9iTEpjcTB1VFQ0b0xJckZVOEY4WURC?=
 =?utf-8?B?NnpJQVY0YXJ4eTBnQzh4Qk1tWFY1SzFJMWZuOG1JRlF4UTcyODN1U2FRWW9J?=
 =?utf-8?B?TFpJNmtmNjMwcEVVd3d0R0dSdXJEVjRyaFREVUhWY3pHRTdoM2hJN2NDeG5x?=
 =?utf-8?B?dEpPZ1FmQnJ5bjE4Y252N2dnTm0wdlIyNHloQzEwMVAwcm1xNWMvY01lbWZx?=
 =?utf-8?B?NFN1WGZGbWxmSkJqclhBSGl5Zy9PclZOZ3VZMXRTT2NkUE05QkJBTFpOVVQ4?=
 =?utf-8?B?QkpYQm1BbmhSbEd4M2NBdGwyckRJZEUyOG1yelg1TFAvQ2MyZUJBTTdkVDJD?=
 =?utf-8?B?eW92WHRaUWdIM0ZYc0FmNGdQOG1YREl1bm93QTRLa3hZbGRPNlpVcUd1UkV6?=
 =?utf-8?B?VE5DYXh6RzNOWEkxL2d5NmpYNzR1ZjRlVkhuM3VpY1Q3QmVxYndvS2JUVnlh?=
 =?utf-8?B?cnpRQjVpN3pncUE2NVV0T0RmOUFTQU5FVDdhZVNhTmNRUnZ6dHB0c08rdWJD?=
 =?utf-8?B?WGFob1pvNTVaRXczQUNWdlpBdXRadTVzQ1I2YWhlU0c2dWdZeHp0MURNQWNs?=
 =?utf-8?B?TmkzQ2V2RHBXVy9XS2pCRDdockVhQTgzYzV6ei9wc3FpaUd4Ulc4aXhEKzl5?=
 =?utf-8?B?UlBvTEplWnUzUGRMemoyemFISGhyYUkxSjM0Rkd0aFhZOFo3YVovRGUzeTBz?=
 =?utf-8?B?ZStoUE92YkkwbTdTRlRVTVNxamFBb1dRRUt2aVJjbTNXRU02L1hLSE1DV3RP?=
 =?utf-8?B?ejJBLzlKOTRMV25UcUFtVG4wa2hQc2doaDlEQ3BTUDMwdlgyYnNzSnhsVjVU?=
 =?utf-8?B?blc0OFRjS3h6MjAvc2FIQUJGVVhzdXVPMmdqcVc4TGRTWVR1Nk5jcXE0M0tX?=
 =?utf-8?B?NzN3bGkvbkt2L1hPWXg1cytYMU51ZWdNU05nck1QMVk2TmxVNEFiYTlQeHBp?=
 =?utf-8?B?S01UZGxwMWxubk45OGx3U1BNS1BjdWVJeENTTmFUNXcyZ3RxMnBFTWpiYzJ4?=
 =?utf-8?B?amljZlUzVnN0K3ZseXMxZXNxTVZsVU1KK2E4c3ZHcklUOWV6ODZadnNqQk1y?=
 =?utf-8?B?UEIwWFprbUdYekZKMHhIM2trblQrcG9aZ1d0QXVtcFRqVFE5eEJUV3l6NUdR?=
 =?utf-8?B?RDBGdEZMUDk4azYrS1pySTZXaWdOeXlQQVkzNnZVaXRZUXNoNUhVd3VNS3pV?=
 =?utf-8?B?YjIydk1RKy8rM3NqQlJqcDRQeTNhbm9pYzBuVHltZ3VzL0g3Q1YxZ1BYUURO?=
 =?utf-8?B?OUdVVjB2Q1N4RFNEbzl5MVFBdWU5ajZwNm5ranFGWHZDKzUxREhCVjVhWDhG?=
 =?utf-8?B?STU4TTY3OExDcDgyY0hNSWIvSXJFRUlRWHlxYkZpclFXdW5GYjdYVTVVck85?=
 =?utf-8?B?M0d5a1ZwNTFzdENBRFRKRjY1L2xjQVlEUmNESnpPdDRLRDl1ZVFuLzlhNWM1?=
 =?utf-8?B?MFZUTDVqeWE4Tm9DaUhDTG1WSEwyanB2YU1QVXBMVGJJdThkb3dzWTdaNWIx?=
 =?utf-8?B?NXYzbnQ4ejFMTk5WdTFBZWYrbTVRWW9iZEI3Vk1LQ01YOFMwVlZvcHVHa256?=
 =?utf-8?B?bEdZQnV2OHdSNWo4c2w0MVNUUCtIRTRrT0UwbEhCU2JoNGM0LzBYL1Vzc1dN?=
 =?utf-8?B?MVRCT1d5Q215SU83aXRJMjdDZG9WWjZFQkUzV3lDRTQ4TS9VZ0pBS0MvdG93?=
 =?utf-8?B?RHdZYnQ4cnd2T1JFNVo1SGdmU0xXR0IyRE1aaEFUUHNYWVkzVFc1MUN0VUJj?=
 =?utf-8?Q?v9ZnuqwEHeY=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR11MB6020.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?TmdBOForajZsaHR3YjFFZjVFdWNuakVHbFBpODZ4TGVJQnV6R2hFTXdGRnFK?=
 =?utf-8?B?UVJtL1AycDlEOUZWamFOdlhabkpCMk5JdHQ4anp4a1Q1bUVxdU1iZ0lLbGhV?=
 =?utf-8?B?N1ZmaFBuZGhKWCtnN3VkM2MwTlNLSEVpcUN5Qkg3eTY4ZDhRRjJ5YTZFdzVt?=
 =?utf-8?B?K0hQVk5ieGcrOHZucmVXMVlwVjIxUnlvZjNtb3N0UmJQVXhiWnljSlplcHZE?=
 =?utf-8?B?VUdEaUI5MzE1dFZwWjByckVmMFFCVzUrcW5OanhnVHRVVDA1Y01wL2src2JP?=
 =?utf-8?B?Ty9nbFRrckdxSFk0Qjc3U1hTQzVPeTBnL0M1eWlkSVBEajl4MDg2am0zc0tX?=
 =?utf-8?B?S1NaYjVSVzg0bTlDdGI1VzRFbkJ2K0kwNkh6YjM1ZWpMYmp1VVI1MDNsS3Jz?=
 =?utf-8?B?QTVGRDhKT0VoQzRnVmdka213aER5RmIrMmlFL3kzZ2pGRVZ5TzdLUTNLbHh3?=
 =?utf-8?B?UHRaUjcxZG9ia0hWOFhTMXRqaEF1NTF2dCt0TzduR0lsNTZ6Q3k2UDJnZFFn?=
 =?utf-8?B?QlcxNmF1cDVjbGR1K0VDSFh4anJrMzJUMEhOUUtaaU10dFJ5SDllNkg5SXVi?=
 =?utf-8?B?Y1M3YVBjUkVNYUZPbnFXa3ozWXpPN2VZakhQYnRKekxqUHV5eU8ySkdQRTJr?=
 =?utf-8?B?b0hIVEpMK3FBWUdvOEx2QTM5TE1wN3plU3Ztc1FnTHd5MWpTcWZ2d3AwSEh2?=
 =?utf-8?B?REVDUjJXMVVJRkRrdFgwSGJGam90QTBLVlgyTENLcytpOWM1M1J3aUx2Ym5S?=
 =?utf-8?B?Zk8xZFNoWTF0cE5FV1Q0ajdPSHlZRWRPTjM5ano1REVMdFRnOCtrMzlUdEQ3?=
 =?utf-8?B?NlF4cHJhelFqd2pVVVdsWFBjRm85dWFHVVh0MDlPbk9rQXA5a3I0S0hJUEdx?=
 =?utf-8?B?eFJQamtjY2FhMlpoV2xZTGlyRUVROTd5cnQ4KzFLWVlYYVBJOW1NT0VIcGIv?=
 =?utf-8?B?ME9vK2RBakcwWVFwTkxaVFowMlNIby9pNC91SFZlVTUrVENETmFHaW0wSTdh?=
 =?utf-8?B?dmY4b3JXd21vdVFQRTlmSnhMZjAxdnRjK2g5b3hHcFBZdXhxWEJLTE1ZTVFB?=
 =?utf-8?B?RzE0SDdDa29aa2N6Sm5ITzczK2RiRjRENzFoSXU0dnV1Wnl5aUlXZTQ2NGYz?=
 =?utf-8?B?WXM5bDZ0OUtTWEd4ajkxdUdieTliTzNRK24rVUIrNUR3ZWNSU0szMGhjK3lO?=
 =?utf-8?B?ZHVHcUZFUW1IdUl4S0ZFMXFzVGs3NWVPWC9TL29oS2EyS1Nwb3F6ZmhQYXZ0?=
 =?utf-8?B?RFhRaHdMVnFVUzRxWWNyYjAxcDUwWSt4aWpRQi9VOGlHYUx4Ym1kblc5dkk5?=
 =?utf-8?B?b0dpaFlycGJIN0JCTng5blRRc2RRRjduWEhuVklBam1ZVWJmM010T0pCL1Fj?=
 =?utf-8?B?akpTU0sxWGJLMHpCSjlucVRBZm1LR1E3cktsWUpkYWx4K1U5eEVacW5GV1Zr?=
 =?utf-8?B?RE9nSWJ3MkdweU4yRW5NV0V0ZzFUTkVOL3ZpSXhydXMwWG8xZ3o2UjAzUmg4?=
 =?utf-8?B?M0kya3Fpc3cyVXZOM09OOXdLMHM2R3VMSFhNY0NJd1A3RWQxb0F4Ly9mOU9M?=
 =?utf-8?B?NlU5Y2l0c0NjbDlsMmlTdmc1dWtld0w2dVE5bXk2YnJqeWN4QXFWREZiWWd3?=
 =?utf-8?B?L1hQeTFiZ0NQWUNHUFhLRW0zT3pxLzhPMVpSQ0U5VUFudVh4NUZDY0xEbzkx?=
 =?utf-8?B?N3dWaDFMUmpTOU1KU1B0b002RnNNdGYwSXRBcXlyZ2ZZdHNrK3I3bGs2eUJL?=
 =?utf-8?B?ZlZCSjVPQlV0cm8yU3lzNGdYeHcvaFRXWXhMNXo2TXVwUDVMamd1NTZJaXFr?=
 =?utf-8?B?Z1ZrQmlTMGtOTmg4VVkvK2FZOG80RjM4OFJqekhURGF5UjE4azZXa1RxVlA3?=
 =?utf-8?B?dkRhVDJLc0tKNmxYT1JGU2NjNjVZUDZOSlNTazI0N2s2S2k2Y1lUclllTzc5?=
 =?utf-8?B?SVkrTVh4bThmQVFXWCtPUFFDZmF2VmZCejVaU1lqeGFnUTNYQXZwNXZ4NlhU?=
 =?utf-8?B?YTU1WFpGOC9hbWtSVU9paFgzeDZyRUFmNnJhRFlmTGcweVR4OVJsTit2ekRP?=
 =?utf-8?B?V3FUc1ZzdXRlY2dlQ0VQZndMNlBUbE1Ea0hvUEg3MC9PN3Z4ZkN4U1I4Sy9z?=
 =?utf-8?Q?jCU0fmD+YwbznOvEQkZ6IlDzX?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 2f8630f6-f4a5-41bd-b083-08dd99ce4731
X-MS-Exchange-CrossTenant-AuthSource: DM4PR11MB6020.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 May 2025 07:48:59.6602
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Aj00OYfOSeE/DbGdNS2HoZcQODbqBvWMsD/IEW1fP9GK2RibczQDnm7YqKsbwq29VqezMg7mmVEaaW5L+6R85A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR11MB6209
X-OriginatorOrg: intel.com

On 5/23/2025 5:56 AM, Andrew Morton wrote:
> On Thu, 22 May 2025 03:01:34 -0700 Libo Chen <libo.chen@oracle.com> wrote:
> 
>> On 5/21/25 23:31, K Prateek Nayak wrote:
>>> On 5/22/2025 2:28 AM, Andrew Morton wrote:
>>>> --- a/kernel/sched/fair.c~task_numa_compare-correct-check-for-kernel-thread
>>>> +++ a/kernel/sched/fair.c
>>>> @@ -2274,7 +2274,7 @@ static bool task_numa_compare(struct tas
>>>>        rcu_read_lock();
>>>>        cur = rcu_dereference(dst_rq->curr);
>>>>        if (cur && ((cur->flags & PF_EXITING) || is_idle_task(cur) ||
>>>
>>> Question: Shouldn't ...
>>>
>>>      if (cur->flags & (PF_EXITING | PF_KTHREAD))
>>>          curr = NULL
>>>
>>> ... be enough?
>>
>>
>> Good point, idle thread is always a kernel thread. I think we can
>> remove is_idle_task() in that case
> 
> I'll drop the v4 series from mm.git.  Let's have a v5, please.

I'll send the v5, thanks.

thanks,
Chenyu
