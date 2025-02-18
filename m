Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60B4C286294;
	Tue, 18 Feb 2025 21:18:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.18
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739913541; cv=fail; b=mYg+iRfzBViNNF6B3DZRQbjvJLawkE7IsowVIlbAJsYusQ0TktO5XVZ3E0QL15rXfw/tkcS41wsaet34WTJoV9LveivbACp41TVNlR697SUGNRQzHaQvE14qzNvqA+bJzfzDjlA1ZdGsjPw+S8TEeNvRMI3orSShTuzPyhs/SAQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739913541; c=relaxed/simple;
	bh=MHRnQTexkBphw7dejqDzEnYZRtnF20xhGB2077G0n28=;
	h=Message-ID:Date:Subject:To:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=KHLcI9Cr2Viws4zewAIAKTXHJQSccK+cGINy4Pmm2SKvq3DJKk8EU0VXGzbDI5acgubZI6jiz0MRzoQ/x064S/3MV7NZ/te13XClgDrmnfnZeCUFbpG99OSzGfyKOM73tPam3His1LKOSonIbe+UtWYtG/MX/4oaWxmop3xeskA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=UCmxhPRl; arc=fail smtp.client-ip=192.198.163.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="UCmxhPRl"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1739913539; x=1771449539;
  h=message-id:date:subject:to:references:from:in-reply-to:
   content-transfer-encoding:mime-version;
  bh=MHRnQTexkBphw7dejqDzEnYZRtnF20xhGB2077G0n28=;
  b=UCmxhPRlmOBa5R3brgCu1trK4cobbY8JeRcIug8+v1SDW7XSZGXdnUgA
   HGEWlBTG3KoEMnd5M7o2SLiJFZpgaiGPVc3jiadRb4/obhsH8ALmTEufD
   YbaFPQDhICR93sIT3/r3pDFqO4Zs8jcy/m1Hs3HGJD06BIfGsw1Psr3Hy
   RTzUd29WzhOPpLxBM5T8dj8SGFZ+CR3Tn/80jPSl4VjwG+YdTy3Z8i2ZS
   oJ4tHnRjaaQjIKFVBG1mKUlpe47gYCVfOmPEVQylqTuzhrx1cYJ14PN/3
   9enoq2DNqvJyI1tTqa1rzEWRTgLQVdhysW+8Utui+pgmV/o0c1OhPe5kN
   w==;
X-CSE-ConnectionGUID: iajBgP89Q3KWwHU+3ETeBA==
X-CSE-MsgGUID: eB9kagO3QzmLxunlaKvWBQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11348"; a="39862199"
X-IronPort-AV: E=Sophos;i="6.13,296,1732608000"; 
   d="scan'208";a="39862199"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Feb 2025 13:18:55 -0800
X-CSE-ConnectionGUID: v1HzONoJSQCcaE8nNIiKVg==
X-CSE-MsgGUID: 9NYzHNCoR2iktTgkTQ9vlA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.13,296,1732608000"; 
   d="scan'208";a="114693254"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by fmviesa008.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 18 Feb 2025 13:18:53 -0800
Received: from orsmsx603.amr.corp.intel.com (10.22.229.16) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.44; Tue, 18 Feb 2025 13:18:52 -0800
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.44 via Frontend Transport; Tue, 18 Feb 2025 13:18:52 -0800
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (104.47.74.46) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Tue, 18 Feb 2025 13:18:50 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=GEj+oME9sn12LIlpeXd64AxHhq7EcpWuiU7myuyk3Fe+b5XiXTt0YvtsVizZTRbXPnQ0zRxRVqIeLp+9SAdLH62sQSJ7gNKjZytCTq1Jyb2kjRx9OqVWI9ButGh3sSIGyvMjwRYcU/KHdZy0BTQK8S/eJb1rkCHMmF/w4bS5M5uST17Tvy58/kaLdEEBSrA0a/HuC83Db8/sQd7IEmZzPEXaPzom+TwAYUoKXNzfmrOMSL2wNcaQIWfn9wNn9+Xw8VxQyyGAaFMKkC88Ta0vxYj0POQLOb1gelr/rYectDUz5/dFQP52k3ESz/2H8Ed/Rx2xnLc1YzKvoc2vzxY0ng==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=BtZGFXWPyQutQOQidv8kTco9iXX9BLgrVjmRZbkbAy8=;
 b=aTuVvQXZyJ6un8Abn6ym0TV1MEVQ7pwS0SI8lpPFYcz0wL448UbgPQonpmShv+MQS/r5A+EE3x/xH5kSvpt1ok7EWGbYpQvT6oDtfzeTwT59AVHZ9LPOpQZTE1vWIVA9b7QdDHcZbV8CxSG4m89U4MARbugZEXrSGXWXxyqLBiuaPDom9t4TUFJa6tJxuqaVyzWbVgkIAbdnLaY/dSiYFpJbdOpX30aPx4AInG3UOKm+c3kM2c3eYYhMdSZ/yR5Zs8ObAY0E3NX+3gOBypoGRiFp05m8+iqKNymvfXwOOEtzgiI3aIXjUm7FKJ5t+RLQzCD+dtTF48qCAQs5G3vjIA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS0PR11MB7904.namprd11.prod.outlook.com (2603:10b6:8:f8::8) by
 MN0PR11MB6012.namprd11.prod.outlook.com (2603:10b6:208:373::5) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8445.18; Tue, 18 Feb 2025 21:18:35 +0000
Received: from DS0PR11MB7904.namprd11.prod.outlook.com
 ([fe80::f97d:d6b8:112a:7739]) by DS0PR11MB7904.namprd11.prod.outlook.com
 ([fe80::f97d:d6b8:112a:7739%2]) with mapi id 15.20.8445.017; Tue, 18 Feb 2025
 21:18:35 +0000
Message-ID: <cd66058c-35c9-4c32-bcae-bc2f8b9f6811@intel.com>
Date: Tue, 18 Feb 2025 23:17:29 +0200
User-Agent: Mozilla Thunderbird
Subject: Re: +
 x86-vmemmap-use-direct-mapped-va-instead-of-vmemmap-based-va.patch added to
 mm-hotfixes-unstable branch
To: Dave Hansen <dave.hansen@intel.com>, Andrew Morton
	<akpm@linux-foundation.org>, <mm-commits@vger.kernel.org>,
	<stable@vger.kernel.org>, <peterz@infradead.org>, <osalvador@suse.de>,
	<luto@kernel.org>, <dave.hansen@linux.intel.com>, <byungchul@sk.com>,
	<42.hyeyoo@gmail.com>
References: <20250218054551.344E2C4CEE6@smtp.kernel.org>
 <24fae382-2dc4-4658-b9b5-b73ea670b0b0@intel.com>
Content-Language: en-US
From: Gwan-gyeong Mun <gwan-gyeong.mun@intel.com>
In-Reply-To: <24fae382-2dc4-4658-b9b5-b73ea670b0b0@intel.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: VI1PR0102CA0058.eurprd01.prod.exchangelabs.com
 (2603:10a6:803::35) To DS0PR11MB7904.namprd11.prod.outlook.com
 (2603:10b6:8:f8::8)
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR11MB7904:EE_|MN0PR11MB6012:EE_
X-MS-Office365-Filtering-Correlation-Id: 4b4aef1f-6de4-4ca5-0e79-08dd5061cda9
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014|921020;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?cWFzR2RGekJxdjY4SnBHbWU3OFRFcmQrcU56WEs5b0lWS1ZYOERaZDNnYzl0?=
 =?utf-8?B?R28zc3M2WURyRG1JVmdxQ1loOHBiUzRHSWlwdXRTaG9KVDRNKzRObG1oU0dC?=
 =?utf-8?B?MitPbnhUNk93V1l3S0xDVnE3QklsVnZzS0dZa3RoeVlPSGl2WFoxQkJMOVdq?=
 =?utf-8?B?Nm10TnA3cUNRL2JSWlg3dy8xSzdPSlRkbHRkMmhmM0VrajBidHlFTUk5M0VM?=
 =?utf-8?B?WlJWdWs4MW9ESnNzRDg5VG1GSHhya2xmSGRyZTNpNFR6TnV3R2dWdUd0cWRM?=
 =?utf-8?B?M2tnbXpuMVBsTGpJdFl5VkFKdEw3N2tteVJKOXZFMFkrSzhEUVltK3FIRm9P?=
 =?utf-8?B?OGhEY1BqNDlJSnBnc1VXdVl4RERMMzhrdXltQ05GODZYMkpuR29ZMEkzRlRI?=
 =?utf-8?B?NVhYQVY3SkE0WGFMemZrNENoREU3ZXdxUk0zMlBKV2o5ZkxuT01vMUYzc0Iy?=
 =?utf-8?B?SW1Ub0NXSmZyZVBiaHpBenVpN3VXZWxUNnJnUnM0dSt2WE9YMDZIZHlPTXky?=
 =?utf-8?B?N3Y3Qk8zZDRDOFQwRnNsaTZiM2kvbjkvUjUxV3NaMktjUUI1VEdGVHV6OE9D?=
 =?utf-8?B?Z01Ed3RvWjJVWGU4eXVKR3pRKzgwclgzTE10dEl5cTJHUjRRSVZFL1p4NWJa?=
 =?utf-8?B?czAyUU9XWm9zbmNIOFJJdm82cllqMEhVVG5QbndYRDl4MW9wREc3QktGU3dj?=
 =?utf-8?B?WVdtZkg0bTh4VWwrRDVxZE5FS1NaRDBWb25TcUVrTGFZanloSEg0STl3SVNs?=
 =?utf-8?B?b0VhSld3SnpkZUxYamxWalhCajJUWDNZYmU5SUtZdllmZmVmWkt1L01Pc0tT?=
 =?utf-8?B?NC9XSTRNZ2JHLytsUkR4Uk9DOXR4RFU5ZjM1ZTNIV2RMQ0JTakczaHBVR0l6?=
 =?utf-8?B?c290YlFySmgwaWYwbWFiY3JSeXZBSDFac1E3T2VNdTcwSmxGdkYwNTN2Y2NE?=
 =?utf-8?B?dmxCNU9Nb0JVWElVMVFINHdhaVJOeEN4dHV6RlJiMkR4eEhjRlAzOHAzOTlZ?=
 =?utf-8?B?M2JPdG5VL0pUSTNWdGJNb3Nvd1M2TUJQSE1GOGdEZjNPT0NFaTZDd2x4OEd1?=
 =?utf-8?B?aldablZwS2tYMVd3Sk1WTWJEZmRPYUNURDRtYzVZTEpjKzkvbmViODlDd056?=
 =?utf-8?B?aXMrOTB4bHBwbUdEM1l6ZlFzVTB5RU9ZOHpHY0JjNXdiZE0vZ29ldmxZeVNK?=
 =?utf-8?B?MkJIWGVlK294cHBQSlJqbDlyaGZsc0ZjRHlEMDNlZjlZODFyaFREMTFPb1ZN?=
 =?utf-8?B?SmlTYkwrOHVHQ3FNbXl3WXpJS2pEUldPdGQ4VjB6UUU5anZrT3krM2pLeWht?=
 =?utf-8?B?M0pOZW1ZTTd4ejFWMVoyMG82cWxZVlVIYmxubnE2dUdqNEQwazlQSjI0V01G?=
 =?utf-8?B?NXgwM1h0elBZVTBueTlyQkIwbDhlYUZ3TmRxb0ZMd1NrVTlUWklKT090TTFB?=
 =?utf-8?B?SmhLMGVaKzFCc29KZkNFaTdhNXBIMnJVSkJEdnAwT1NnOFNCK1BybHpyMFJx?=
 =?utf-8?B?Q1BvSkxTY2tFTVJuM0FxRmVmRmZzRHFZUTZBWlV1WEpvV2dKcDlNd045SkIy?=
 =?utf-8?B?cWFsVmVDZ09CRC9ZZ0w4Q1dDVHFTOHNUWk94aXhGS3JVNnBzKzd0WkpBbUxQ?=
 =?utf-8?B?YS9QMjVxQVBVZGJ2RDYxa29lZkkyZi9jYWRxd2ozOXo4SDZWT08weVpvV0R4?=
 =?utf-8?B?VGQ4eTlWd2dHTlpkOGNDNjVFK2xwdGhGUlJCSWwvL3Y5VTNjYzFQUjhQQVR1?=
 =?utf-8?B?TjhHekhkNllzY2hJS1h3MlFVNkVmTUZhYmZyS2s0L1F5NU9lK3V6V2RJZFh5?=
 =?utf-8?B?QTg4VjJ4WHpVNzhKK3hyekI0MzUwNWpldkVRaEJOSlJma0crOSttUmliZkp0?=
 =?utf-8?B?OVRGeVUzTDZzeUJodU1ZaGdIRnpRc3h3bWZNMG1iZVhIMVZXSjlKU05pUUh5?=
 =?utf-8?Q?2KBiMq+GqL4=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR11MB7904.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?dllaQ3NpRG8wK1M5c0Nsd3JXYjR5ejFJdTQwMEVLZGRiWWphSmZTZk50U1dl?=
 =?utf-8?B?bzdOQ2ZUamJKbWo2Q1hmeThhY1E5YTRjYy9vdWdXTnQvQXVKUnh1OUgzdCtm?=
 =?utf-8?B?d2NYZUtZSDZJc3VDd0daNUFOQnhrUDNIZlBQWDN5N3hJRGdIZkFLUlV1RDIz?=
 =?utf-8?B?RTlKb2Zlam5vdDd0THpVYy9XdWtOL3Z4b3dPTitnaG5HZGJxZDBheE16UkNX?=
 =?utf-8?B?cTlvUTBWenhlZ1p3UkZjcHcxYlBWK1N2eC9xM3RBY0twT2I1a2JlTE94WE1m?=
 =?utf-8?B?bGtWQ2xvSlF3alpCQ0MvUUJiS1pIczJRZFhacUtwS29QSDIwYmtJZHFSR1Y1?=
 =?utf-8?B?M2Q5aDVEd25LSFg5RzFUTVhRU0srUnpwNWIvRlU0M2NrSjVrR3NzNWtWdVlH?=
 =?utf-8?B?bzVtVExwWnhkcmpaaDVRLzV2N0NzVCsyUzR1NE9ncUorSmtuMi9nWnY2MmNS?=
 =?utf-8?B?QjRYNkRVUFFtbmhudVcvMTViUVBoVjNlRnBWdTcwT2xRN3A3OTZxakI5N3l1?=
 =?utf-8?B?aGs5c1JjTHFmanh1ZnZLWU9pYnJXaTNXM0liMzVJWDJzem1EQ29SSmJjUFM0?=
 =?utf-8?B?TnI2YUU4WHI0SHRGTlJCVnB6ZHBWcy94OTlBYlhoVXFlUkh0ZW1naDJoZGhN?=
 =?utf-8?B?aStBSnRlYXBBYkpFdVZ0R2ZrUWdTZmo1UGZ4YXNrdElMbnNsY3hnR1NlTU1w?=
 =?utf-8?B?MjRjTlAxZ0t3TDNUU2UweTdNc3lDeFdXQ3p4VUJyNHYxV2c5R2tucEFjUVlq?=
 =?utf-8?B?anpiYWxaKzFmMDdxTER0LzR5UTBGNWtDbXR1UnNGTnRSejA0d0FDSlJ6cDZt?=
 =?utf-8?B?dmRiNnJGSkpSeFU5Qkk2Z0J6OThUS1grWDA2ZUFEZ2Vzc2NyemErd1FtbXJX?=
 =?utf-8?B?b1kyRG16Q3phb2JEWVo5VWFnVSs0V2JFWG5CQVZNeXlNSTJyc1hjUm1ZVjI0?=
 =?utf-8?B?U0ErajA2RGN4Q05xN1lRSnV3SE9QY3RUc3c1bzY4QjU5S2xGVzRQWjdLanJO?=
 =?utf-8?B?NHcra2tCZm5VZGJueDNzL1pCUVN0QmZiNDRiNXM4WU9XbHFtbUIwSGtlQmFR?=
 =?utf-8?B?YmRzOEZoYTBVeGtTc2tLNVkwaG0zTVhPSUN5dXREMnZjWG1UdEIrK1cyeEZ2?=
 =?utf-8?B?ZmFJK1VISUcxeTE0Wm8wcEE4bWw5bSsrUnk0dUpCTSsxWVZ2Q0xudHNlVmdZ?=
 =?utf-8?B?amVvVU1EQXNsdkNSSEphUFlBUDBScDNJQmJpdDRMc0dwZWsyNDlmU3FFRFpj?=
 =?utf-8?B?MXM1SXowanNYTFF5OXdmZWRFMk1WRWp4T3NJcldXSllucHIxbGVKUkMwbzli?=
 =?utf-8?B?M3lKMTd6c1RwMmhUTXl0cnB0dHZoVmhpVnExL29NQ2VoZDJTY2J6aGtvRXFJ?=
 =?utf-8?B?dkRhU3YzUDlqSHQ3bDFrUzZSK3FRS0l5R21XM1o2RlFuVUNhS242MWp0QW41?=
 =?utf-8?B?TXM0Q2pVRncvKzlIMkN3UTlQY0l2SlY0dHJRTkoxQzE5NEV3ak1PaGkzTVY0?=
 =?utf-8?B?Ni9xNTdiVXFQTWg2azNPeXhJZUI1M1RQc0VENkwwejdpWUVVSjNwQmR5Szcw?=
 =?utf-8?B?S01ST1l5Y05WblZxY3dneStsMUhvSzI4Rmh4T2pqbkZNd2JtQld5b0FFNGNr?=
 =?utf-8?B?RTgrMnJLQThZcFpEQlhFeG9GS2I5NGlUR3plbkFSOEM3VjFMU1NCd29QMzNX?=
 =?utf-8?B?N3Bka254RzJFQ2t2d1I5djg5Z0JMY2RzRkluL2dTajdJdlBnR09sY0VWQXNB?=
 =?utf-8?B?VDV4U2greDU3cmRscDZtTlRSUlJCdlV1SW5qMmZRZkRHb3V1VHRuQmVVZDZW?=
 =?utf-8?B?clArUjVpRGtVNFVwbHJTdm9SOFlrYTdqUytGa3MwQ0FZK3hVNFNFOGhRS3gw?=
 =?utf-8?B?eXhDTVBqOGFMVVhaV3M1eUNvSldSOG1Qb3JWbVBsTCtIMXkxd2h3eG4xbTlU?=
 =?utf-8?B?UTc4VkEya1Bhc05xNUhPL0lkaUlMdmFDSXNUSWY0bkJIWmRqNHlnR2lmRjdD?=
 =?utf-8?B?MHgyRXlWbGNBWFI3LzZtRmN2cVRsUFJuYStYbUNkZGpxc1hGNlBJVzFLbE5p?=
 =?utf-8?B?T2wvbEFaNnJlYmtNazhWd1BiQzU5Tko0YjlFSnc4TFZITmtOdXZEOXA2aFlk?=
 =?utf-8?B?UEdZZE52ditBalJFRGZHb0U4ZGtpMGtCWGgyTVZ5c2xZS2hPVU5DN2kzSzRV?=
 =?utf-8?B?QVE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 4b4aef1f-6de4-4ca5-0e79-08dd5061cda9
X-MS-Exchange-CrossTenant-AuthSource: DS0PR11MB7904.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Feb 2025 21:18:35.3574
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: unJN2KdHkCqiRRPLIQbEjMFpimGz0Z6LEZ0hg8FpX6+Jvk01oJecZQDzlrCQSyUU3qKwg9elt6HKD8s3Qb24TZm8NZP5PTx4QBYxRlE7HiI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR11MB6012
X-OriginatorOrg: intel.com



On 2/18/25 8:41 PM, Dave Hansen wrote:
> On 2/17/25 21:45, Andrew Morton wrote:
>> When a process leads the addition of a struct page to vmemmap
>> (e.g. hot-plug), the page table update for the newly added vmemmap-based
>> virtual address is updated first in init_mm's page table and then
>> synchronized later.
>> If the vmemmap-based virtual address is accessed through the process's
>> page table before this sync, a page fault will occur.
> 
> So, I think we're talking about the loop in vmemmap_populate_hugepages()
> (with a bunch of context chopped out:
> 
>          for (addr = start; addr < end; addr = next) {
> 		...
>                  pgd = vmemmap_pgd_populate(addr, node);
>                  if (!pgd)
>                          return -ENOMEM;
> 		...
> 		vmemmap_set_pmd(pmd, p, node, addr, next);
>          }
> 
> This both creates a mapping under 'pgd' and uses the new mapping inside
> vmemmap_set_pmd(). This is generally a known problem since
> vmemmap_populate() already does a sync_global_pgds(). The reason it
> manifests here is that the vmemmap_set_pmd() comes before the sync:
> 
> vmemmap_populate() {
> 	vmemmap_populate_hugepages() {
> 		vmemmap_pgd_populate(addr, node);
> 		...
> 		// crash:
> 		vmemmap_set_pmd(pmd, p, node, addr, next);
> 	}
> 	// too late:
> 	sync_global_pgds();
> }
> 
> I really don't like the idea of having the x86 code just be super
> careful not to use the newly-populated PGD (this patch). That's fragile
> and further diverges the x86 implementation from the generic code.
> 
> The quick and dirty fix would be to just to call sync_global_pgds() all
> the time, like:
> 
> pgd_t * __meminit vmemmap_pgd_populate(unsigned long addr, int node)
> {
>          pgd_t *pgd = pgd_offset_k(addr);
>          if (pgd_none(*pgd)) {
>                  void *p = vmemmap_alloc_block_zero(PAGE_SIZE, node);
>                  if (!p)
>                          return NULL;
>                  pgd_populate(&init_mm, pgd, p);
> +		sync_global_pgds(...);
>          }
>          return pgd;
> }
> 
> That actually mirrors how __kernel_physical_mapping_init() does it:
> watch for an actual PGD write and sync there. It shouldn't be too slow
> because it only calls sync_global_pgds() during actual PGD population
> which is horribly rare.
> 
> Could we do something like that, please? It might mean defining a new
> __weak symbol in mm/sparse-vmemmap.c and then calling out to an x86
> implementation like vmemmap_set_pmd().
> 
Hi Dave Hansen,

Thanks for the feedback. I do agree with a generic code rather than a 
diverse code for x86 implementation.
If everyone else agrees, I'll send a new patch in this style.

> Is x86 just an oddball with how it populates kernel page tables? I'm a
> bit surprised nobody else has this problem too.
Presumably, this won't happen on other platforms where they don't have 
the scenario of accessing that address before synchronizing the pgd.
Please correct me if I'm wrong.

Br,
G.G.
