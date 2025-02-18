Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09C5322B8CA;
	Tue, 18 Feb 2025 10:07:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.9
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739873260; cv=fail; b=gj/KgoM1rBVaPJgrpXaWR0EgJ7S6opx9o0FEy7QSTrmbBo/IVPjNkRbFmb4fZ9+PoYZIcIAFCOFdJTcVf+pFsjDZtdxb6EcDC3tBz1rCZb49L9hUQTxFb33ardUtbQg7VgRC/SzvD37LQXQppD/vjP5x6LcDJIgZg1jNY5YQB4w=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739873260; c=relaxed/simple;
	bh=kVq7sw9DCvcjw/F6JYR35DxkKCZPSA67inf71MCiwh8=;
	h=Message-ID:Date:Subject:To:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=GSPp2j2Tqi/snsr2Ryc9Moi/ZEBil76T6iuwvvo0vGuGHZgEKzA+U42yVJjzxcx1pUwS6k8DMrV36qMalA/48upnVQT4TAKyg+wOy3iD3uxynwtKsJZ84kzVgdeIQvpQWBGOzqxsX889DiLNtL3rBvDkcSK4DmScYn9mZiGfoTU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=D+Kwtr8z; arc=fail smtp.client-ip=198.175.65.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="D+Kwtr8z"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1739873258; x=1771409258;
  h=message-id:date:subject:to:references:from:in-reply-to:
   content-transfer-encoding:mime-version;
  bh=kVq7sw9DCvcjw/F6JYR35DxkKCZPSA67inf71MCiwh8=;
  b=D+Kwtr8zdoTnxiW/0FxyXzlWUx6LdMSy8SUz48cJCLuJfpyNHb4VWM6L
   xa/gb97dewbuEGpyaizJKmDDeV7D0ABAyx5usQv/kXCc190V0h1rUaZyA
   rVY/pc0dupT3WFazbb+Sbj+Q5iiRrC3E7LuRzlxAPKmjO6uOZ1rSzVNgo
   OWrKsPHwONOXh4T3r8Ph+C8hl6lm3bpJ4mWsW2cY/80VXFjPKrsSBv7SP
   /3bXM7bPkL091AT0xhtLoxtlxFCFN3fRFsCaFifL0xlJei6Mewd3Jhoj0
   OmbgV+8WvTLy+1t7kIbGXXGt3UlimEAd7uhf4ckoW9851jOtqWOfsj25K
   g==;
X-CSE-ConnectionGUID: EragoT1FQ5ml2TZ8SAHKlg==
X-CSE-MsgGUID: B9Qc3E5MS+ipZBhDbQJzDQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11348"; a="63038218"
X-IronPort-AV: E=Sophos;i="6.13,295,1732608000"; 
   d="scan'208";a="63038218"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Feb 2025 02:07:37 -0800
X-CSE-ConnectionGUID: HZhtLZFrT2uv+btaJ5ciAA==
X-CSE-MsgGUID: Wm50uZlbQS2+cUkM+DYVSg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,224,1728975600"; 
   d="scan'208";a="145255864"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmviesa001.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 18 Feb 2025 02:07:36 -0800
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.44; Tue, 18 Feb 2025 02:07:35 -0800
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14 via Frontend Transport; Tue, 18 Feb 2025 02:07:35 -0800
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (104.47.56.41) by
 edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Tue, 18 Feb 2025 02:07:34 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=gkU1Pf9vt3hVNKHYRbXDI8epAc8aWVsufXaRFwfm/XB9KD11l8OOrJQIA+SIWrPzoD0Zx4D4AROVtilz7ZBitgS5cpsnnLgmy3PcVI0YlDit5GuLxfCJETBDpb4gnEaUwxjFD9FSrlOssLk7/omNmuE3zXTkZ3ypRUj7m1wisyDKfHyirdhu7YcNNPDi6twUDpghMuH+BtDurXthzq0gi+8j42EzpXk+pJx4Wz+oyMrqjIcpdEoQ/ZrPiAWLa0MKM0nzB5kRDHk0gqLco+YgnYlXb5kp3jHgfOZ+e1vvd3UVZxFAdoIoDBHelqCrVJQl8mTW2PSeeWTGULubmuRBnw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=52hS6ndeZgslUwmT55KtlPI23CDO4lKwoHjaUPK6iiU=;
 b=JAEJQY6dNMA0sqxg7u/taPTw8aHt7iyZurpd6L3EyBGXjpzMoY5Qzlbdb+wrmGGrPKx890h9luE+w0VrNNHGHP1BmQ6xe/wQzjrefA6/PcGr+TuKX3DKRAzZ8EqxKdb2WKuvs0OXLgjg8rbRv0ez8CxSX73Ap/KbuIEhsKDjoDeB6Lt7dvhSGxXDc9sCWsE57bGm5GwSWDwnHLuvOX6Gz+Tic66QuaWLoo3jhH59eSiedEeRum+WFzkepITZ2MaHgbllP2fNtGj4GzLXZHK2prgwbDu+2ph1vHT3nUiDmozuYjPmcxtxtWaiVDLI8yIetQqQdUSbKQ5HkppHd63MWg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS0PR11MB7904.namprd11.prod.outlook.com (2603:10b6:8:f8::8) by
 IA1PR11MB7920.namprd11.prod.outlook.com (2603:10b6:208:3fc::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8445.19; Tue, 18 Feb 2025 10:07:33 +0000
Received: from DS0PR11MB7904.namprd11.prod.outlook.com
 ([fe80::f97d:d6b8:112a:7739]) by DS0PR11MB7904.namprd11.prod.outlook.com
 ([fe80::f97d:d6b8:112a:7739%2]) with mapi id 15.20.8445.017; Tue, 18 Feb 2025
 10:07:33 +0000
Message-ID: <f197ef17-641a-4ed5-9bdb-15fdbc10b86d@intel.com>
Date: Tue, 18 Feb 2025 12:06:29 +0200
User-Agent: Mozilla Thunderbird
Subject: Re: +
 x86-vmemmap-use-direct-mapped-va-instead-of-vmemmap-based-va.patch added to
 mm-hotfixes-unstable branch
To: Andrew Morton <akpm@linux-foundation.org>, <mm-commits@vger.kernel.org>,
	<stable@vger.kernel.org>, <peterz@infradead.org>, <osalvador@suse.de>,
	<luto@kernel.org>, <dave.hansen@linux.intel.com>, <byungchul@sk.com>,
	<42.hyeyoo@gmail.com>
References: <20250218054551.344E2C4CEE6@smtp.kernel.org>
Content-Language: en-US
From: Gwan-gyeong Mun <gwan-gyeong.mun@intel.com>
In-Reply-To: <20250218054551.344E2C4CEE6@smtp.kernel.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: VI1P190CA0039.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:800:1bb::20) To DS0PR11MB7904.namprd11.prod.outlook.com
 (2603:10b6:8:f8::8)
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR11MB7904:EE_|IA1PR11MB7920:EE_
X-MS-Office365-Filtering-Correlation-Id: 3e6265c1-65a7-4a08-58b3-08dd50040fba
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016|13003099007;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?U1dZbktkaU81V0g0Ylo3bDA0SGxSK0hPWm5tZkRKOG00a3R4b1duMVR5WDZs?=
 =?utf-8?B?bm0zTVhvVjBCbm1ZZ3NQcE1WT2pMWWZHZ2RZcGZhTkRxdE1VeFBldVRMV0pu?=
 =?utf-8?B?eFdzS2ZIQ1Z5aXM0MnZvdXZCOU1XUXhlaUppc3JGQ294S2xLN1BPQ0toRWRM?=
 =?utf-8?B?RFJKbGZCUkNqR2YvcUlBS2g5Y0htZllDRThlWm1XOG1BWDZobjNNZUYyMkQ2?=
 =?utf-8?B?QW9mcG9Pci9xT213cjJGZ3Q4enNCR1l1NDd3UVA1SWw2WjYyb0tNcE84SFF1?=
 =?utf-8?B?YVFxRXVlZ2k4ay8xWTBiLzhrNG5GMTBqTE9hUExzOXpGRlQ0ZDBmWUVlWjdC?=
 =?utf-8?B?S1pmLzdlVTFLNG9qSGdxWWt2ZjNIS2NjLzU3Z0tweXdSVVArRy9CVUFWNFpH?=
 =?utf-8?B?RDRUODU2cUwzQ3RSQ2ErMjV5K0lsRVo5azZIMHhsQitGc2diUDRXZzFNekdH?=
 =?utf-8?B?VVFydlFqZkhGRFh3SlBBOEdYOE1JT2wyZ1NyR0Z2c1EzYXNrL0xqUXMwNVFj?=
 =?utf-8?B?MklvR3NEOXB6NHk1UEMxR0ROcG03VGtnRFRSaGZOQXlqYnZQN05IclFiWVNU?=
 =?utf-8?B?WEFyWXJoa0pTVkV6bWxqQmZuUGxvNUdxRExtbkpSM3F6bHY2dkNSMGc5RlVh?=
 =?utf-8?B?TktQRDZmS1hrZ1FWT0d5TkFmN3huWUxPU3dyZWl2ZWhmVU01bU5lYlFlRUxG?=
 =?utf-8?B?ZENwWWpKR2luUk9zQS9nWlhVbzV6bEdHV2szSVUzRVYxVDEvTVRWbTdsZkl0?=
 =?utf-8?B?VDhOLzBJcFJlaHNmQ2UvWkVBVjZhTDNJUW5OL0hmOW5qMTR0V2JSLzMrampj?=
 =?utf-8?B?cnRpN3huQjExbnVpeXI0NFJIdG4rTHlXQ2JhMkc0SWlBS0U4ZzhVanArRkVl?=
 =?utf-8?B?cG9JTWNQa3dwZkRKVml5Rk5vL3p5MFlyWlRnZWdvZEFGamRUZnJOdkJUTWV0?=
 =?utf-8?B?SnE3ZXdsMFVjTVVtQ2FhdFdoMmJ3Sng0Y0Yzc2M3cFZCT0gyQk5aUUFuZS9Q?=
 =?utf-8?B?QUZFLzBlTmhmOVI5bkhlaEJFRU9mRk5udmxFd2RITW9Ua3JzTmkyREZuNWUx?=
 =?utf-8?B?cE00NFpDNi9xZ2lweUtWMnloZzBuVXRMRHl6UGFpMlpSdE5hdXRtYTh6VkJ5?=
 =?utf-8?B?UHUrUnhheXp4UWVwOW4zWHpjSFR6a21wdldwQ1V3OXZ6OFRuTmNML1JXcmVC?=
 =?utf-8?B?amlOVC9NSEdvcDBZMUpvOWNqcG1HQmVLNFM3aGtFL0Z2Yy9qcXo4ZWx1b3Zh?=
 =?utf-8?B?MWJhTHZ2THFBMkFLNnhZQnNjMmE3d1VZZGptbjRpUVRqcnRNeldRamp2L3hr?=
 =?utf-8?B?a2pwcC9EYkRnaHhmTmh6LzdnUkc2amV0TUtGbHFnSDdHZHFQTjRNSm0rQ2VW?=
 =?utf-8?B?LzJiNkdyVnBvVVpaay9CSk8rNk5KWFRueDlzRUFMRkp0dnJQZDRrMUllTGo3?=
 =?utf-8?B?NHpWeGV4UHI3OWxtc1B2VEtKRzRHMGNBNWxxRFpVM0pTQUwyVE94c1BYY0Jw?=
 =?utf-8?B?NmdZbklEV3oxWXpoVCtwblkxSWRwQ0ZCKzFnYm84dXdzVDhwVzBGdU1QWmVq?=
 =?utf-8?B?SDc1aStQNmJUd05veXRvS21XMmgzZkMrU2Q2dlFHSGZHbC9Bb2lwelZEeDY0?=
 =?utf-8?B?QjZGT0drTWxGalB1YzBBTDJzbU5WVGV2d1ZGTUh4ZUJCVUtodDNjQ3Z4KzV6?=
 =?utf-8?B?d2dmaDhaOG8zSUtFV2NZOHQwbWVaSjBXcVliMEF0TzRYOGlTUTg4Q2hXTmdt?=
 =?utf-8?B?dmZldVN0ekt5bHlMelhBOW5IRDlLblhBdk9acVNjUHZXVVlaSDNVNUpTanEz?=
 =?utf-8?B?b080SVh4L3gxcFAxS29HaURqbDd4bnMwZk4xTnBITFhkVmNXUTROMlErU2xK?=
 =?utf-8?B?aWtzdFFVTjB2cWlzRzN1SzZEOEhRYUErSVYyL0k2ZmZPWlE9PQ==?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR11MB7904.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016)(13003099007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?RWdreHUzNXVFZC9FVkVNWlZNVlZvUG5kYWsxOHZPMVpTa0Q2OGlnNU0yUUlH?=
 =?utf-8?B?WjVaQlVIeTFwU01xZWRrUEpBRVZ0RWRoeDdwcUlUbEdieFdGN0RyQlh2NGp5?=
 =?utf-8?B?S1J5OEtyWnYxaWFTd1RvaVE1bmp0NDRzODhqdStHSS9XajY1Nk9SZVFBQzBV?=
 =?utf-8?B?alpHV2pxOVp3QmxhYzdNTHR1ZjkvemZqN1prT2RnYXRvWWhWSng0K2FlK2p1?=
 =?utf-8?B?bmhhdTFtTUxPck5LNlJEUmZlY290STBFaXdXQVg0bVd6Z2I0MitXdWxnVTd0?=
 =?utf-8?B?VWtHcmlUMDBnbGZlMWpIaGFwN1A2ejhETmlWV2szbExPMW1Pb09mQjEyZ1ZF?=
 =?utf-8?B?elNvcVJreW1PN09PZGV0ZUt2S3pZOWNJbFNxOU9rYkhhN2lLZ0Y1RXk3elRB?=
 =?utf-8?B?b2M5YkR0RWszVkkvdit0UE1zSlk1VWhwV2lBbnpReUVZT2M5K1ZoM3IxUnoz?=
 =?utf-8?B?QmJTMkFkVFlMaExwelRMS2h0OGRqSWsyOW1wZ3RyVk5TcFVILzUxdHpOd2F0?=
 =?utf-8?B?YVhQWmlMNThCT0IzbW9XRVRweXNRY0x2TlZ1aWpLU243RmJpaUtaampIY29r?=
 =?utf-8?B?bzEvYmNJTFZRK0cvTG10UlhLdzVCd2lXVHdtdGc5bkx1blNJR2pLd2VDSko5?=
 =?utf-8?B?MGtIRUUzTFhvZVlFY2pad25URWRuL0N5UU1adFpKY0lVaStpUXhOcm1VNHhi?=
 =?utf-8?B?Um10bGM0WUROclFVY3FHSHI3djdPa3V6VzNKcHZXWHM3ZHlJRlQwb0d5bWYv?=
 =?utf-8?B?QkNqc01ER0JDK3E2OXZTUmI1MkhBUTVFS2xsNGZGK1J5TUFGbWtNMEFBL0lY?=
 =?utf-8?B?UFRud0xlYlJuR2dPUGVUTElOa3JCbUk1NGNLN3JPODZMUDRpalVtZjJVUFdW?=
 =?utf-8?B?OUlPY3hZajJRT0diYS9YaVFsK01EeVRCbWdxOEthODdVYW1kOHZ5a291MEEy?=
 =?utf-8?B?eHUwMEJVM2VjcUluV2ZXekRDQUljWGl6THJ2YVRWaFIxcnlaNEdmdUtaNVFW?=
 =?utf-8?B?Z1VEaUQrdnNFQjY3WjFSV3A4SG1tcldmelpZbGZFTlNDazEvMzdISDhiRUJq?=
 =?utf-8?B?QU83Zm9SSHpBNzUwcllKYzVKYTJBUWFRZ0ErQ2dqNitwN0hPOEJzMThxbmd4?=
 =?utf-8?B?a2hLeWRVdVdITlk1TFYvOG8zMjVFVzNnTkIwbVJ5TTZFSUl1cTlSUHBHMVVF?=
 =?utf-8?B?eXJRa2J5alRTV29vSEp4b3FSRFA3L1dXalJtd3BBbHdjVWVoT0VZWEZqSkhr?=
 =?utf-8?B?dktyQ2ZYWEFoRUp2aXhrMVpZTUhveE1aTEMzY3d4Tm9yQzhnZTNVRG9SYnl4?=
 =?utf-8?B?aXkrS1JRcThaQ0d5ekU1dExhL1JTY2p2enMreFk4NzVTS3RwLy9VNzNvb2Jh?=
 =?utf-8?B?L2hGdEpyREZ6Q0o2NVhrR1lsenVPR3dRYUhmak9PK0s2aGd3dmpYQ1BjeFlX?=
 =?utf-8?B?L1VaaWF6R29pR29BbHNkckRuYTV6UTh0K0h4THJOdXNjVHptNmVCNEFKcTN4?=
 =?utf-8?B?eng2SmNZaTZ3bTVTc29JY0krUjNOQyszZXlqQTAreUxObnFsVUd1WGZpamov?=
 =?utf-8?B?QWtTWWd1WVVJb1psVU1RY09kaWtURXdtNGRTRndCQVBCZkMzdlhWa0d3aXND?=
 =?utf-8?B?aUN5VDJPWkMxbys5LzZoNnFtY2RJTzFGR2gzY3M5eDgyTE1aOEJIcGJoZFg3?=
 =?utf-8?B?T2RBTmRqMTA5ZVJ4bFB6Ly9wc2dsUURMYXBiSXVucWFBWXZwWVBZb0FCWG45?=
 =?utf-8?B?V3UwS2dZSHlMVis1RWFpSm12UzJDV1NzYUVVNGtBeHF6bjA5OXVod2JaTFl3?=
 =?utf-8?B?SGhlTGVVWmhUQXgreFZtZmZGY1gxQUhQWitUbklkRnc5SkRDUWswT2kwTVI2?=
 =?utf-8?B?dzJCSFpicjNsdXErWnF6S1o4SXVDMStBTzhNNDFycVpGcHVJMTZBMDdLRVNk?=
 =?utf-8?B?Zmc5RVBWTklKQ2x4WDdjWVJSTnlzOWlsc2RhS0M3aE0zMytNZFNna292dVV6?=
 =?utf-8?B?TUVhWDEwWXhoN2xRbTJhODc0S1lTMm9obmN1R3pETkx4T2h3alphV0lsUXlD?=
 =?utf-8?B?USsrVGkzRmFVOEVtamJKY2loc3dlZy9TNWJmUThDS3oxV2lUNk0vUDRDUFNr?=
 =?utf-8?B?KzZQYjJxZ2RBdGdxcjBEMlhUMS90Y21ka1hsYThLNTdTMkhjVndaMWdFVFdL?=
 =?utf-8?B?aFE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 3e6265c1-65a7-4a08-58b3-08dd50040fba
X-MS-Exchange-CrossTenant-AuthSource: DS0PR11MB7904.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Feb 2025 10:07:33.1421
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: sr+IsKlL4NnoPjTQq3uHjlUKrEeHiBbBCeVVJCj2ZQe6G8u591SHIPvYIGgd9AjMpFPiPHsCSQf+BRsYVTIRm+CtmL6UyQMyr6iyl910udQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR11MB7920
X-OriginatorOrg: intel.com



On 2/18/25 7:45 AM, Andrew Morton wrote:
> 
> The patch titled
>       Subject: x86/vmemmap: use direct-mapped VA instead of vmemmap-based VA
> has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
>       x86-vmemmap-use-direct-mapped-va-instead-of-vmemmap-based-va.patch
> 
> This patch will shortly appear at
>       https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/x86-vmemmap-use-direct-mapped-va-instead-of-vmemmap-based-va.patch
> 
> This patch will later appear in the mm-hotfixes-unstable branch at
>      git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
> 
> Before you just go and hit "reply", please:
>     a) Consider who else should be cc'ed
>     b) Prefer to cc a suitable mailing list as well
>     c) Ideally: find the original patch on the mailing list and do a
>        reply-to-all to that, adding suitable additional cc's
> 
> *** Remember to use Documentation/process/submit-checklist.rst when testing your code ***
> 
> The -mm tree is included into linux-next via the mm-everything
> branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
> and is updated there every 2-3 working days
> 
> ------------------------------------------------------
> From: Gwan-gyeong Mun <gwan-gyeong.mun@intel.com>
> Subject: x86/vmemmap: use direct-mapped VA instead of vmemmap-based VA
> Date: Mon, 17 Feb 2025 13:41:33 +0200
> 
> Address an Oops issues when performing test of loading XE GPU driver
> module after applying the GPU SVM and Xe SVM patch series[1] and the Dept
> patch series[2].
> 
> The issue occurs when loading the xe driver via modprobe [3], which adds a
> struct page for device memory via devm_memremap_pages().  When a process
> leads the addition of a struct page to vmemmap (e.g.  hot-plug), the page
> table update for the newly added vmemmap-based virtual address is updated
> first in init_mm's page table and then synchronized later.
> 
> If the vmemmap-based virtual address is accessed through the process's
> page table before this sync, a page fault will occur.  This patch
> translates vmemmap-based virtual address to direct-mapped virtual address
> and use it, if the current top-level page table is not init_mm's page
> table when accessing a vmemmap-based virtual address before this sync.
> 
> [1] https://lore.kernel.org/dri-devel/20250213021112.1228481-1-matthew.brost@intel.com/
> [2] https://lore.kernel.org/lkml/20240508094726.35754-1-byungchul@sk.com/
> [3]
> [   49.103630] xe 0000:00:04.0: [drm] Available VRAM: 0x0000000800000000, 0x00000002fb800000
> [   49.116710] BUG: unable to handle page fault for address: ffffeb3ff1200000
> [   49.117175] #PF: supervisor write access in kernel mode
> [   49.117511] #PF: error_code(0x0002) - not-present page
> [   49.117835] PGD 0 P4D 0
> [   49.118015] Oops: Oops: 0002 [#1] PREEMPT SMP NOPTI
> [   49.118366] CPU: 3 UID: 0 PID: 302 Comm: modprobe Tainted: G        W          6.13.0-drm-tip-test+ #62
> [   49.118976] Tainted: [W]=WARN
> [   49.119179] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.15.0-1 04/01/2014
> [   49.119710] RIP: 0010:vmemmap_set_pmd+0xff/0x230
> [   49.120011] Code: 77 22 02 a9 ff ff 1f 00 74 58 48 8b 3d 62 77 22 02 48 85 ff 0f 85 9a 00 00 00 48 8d 7d 08 48 89 e9 31 c0 48 89 ea 48 83 e7 f8 <48> c7 45 00 00 00 00 00 48 29 f9 48 c7 45 48 00 00 00 00 83 c1 50
> [   49.121158] RSP: 0018:ffffc900016d37a8 EFLAGS: 00010282
> [   49.121502] RAX: 0000000000000000 RBX: ffff888164000000 RCX: ffffeb3ff1200000
> [   49.121966] RDX: ffffeb3ff1200000 RSI: 80000000000001e3 RDI: ffffeb3ff1200008
> [   49.122499] RBP: ffffeb3ff1200000 R08: ffffeb3ff1280000 R09: 0000000000000000
> [   49.123032] R10: ffff88817b94dc48 R11: 0000000000000003 R12: ffffeb3ff1280000
> [   49.123566] R13: 0000000000000000 R14: ffff88817b94dc48 R15: 8000000163e001e3
> [   49.124096] FS:  00007f53ae71d740(0000) GS:ffff88843fd80000(0000) knlGS:0000000000000000
> [   49.124698] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [   49.125129] CR2: ffffeb3ff1200000 CR3: 000000017c7d2000 CR4: 0000000000750ef0
> [   49.125662] PKRU: 55555554
> [   49.125880] Call Trace:
> [   49.126078]  <TASK>
> [   49.126252]  ? __die_body.cold+0x19/0x26
> [   49.126509]  ? page_fault_oops+0xa2/0x240
> [   49.126736]  ? preempt_count_add+0x47/0xa0
> [   49.126968]  ? search_module_extables+0x4a/0x80
> [   49.127224]  ? exc_page_fault+0x206/0x230
> [   49.127454]  ? asm_exc_page_fault+0x22/0x30
> [   49.127691]  ? vmemmap_set_pmd+0xff/0x230
> [   49.127919]  vmemmap_populate_hugepages+0x176/0x180
> [   49.128194]  vmemmap_populate+0x34/0x80
> [   49.128416]  __populate_section_memmap+0x41/0x90
> [   49.128676]  sparse_add_section+0x121/0x3e0
> [   49.128914]  __add_pages+0xba/0x150
> [   49.129116]  add_pages+0x1d/0x70
> [   49.129305]  memremap_pages+0x3dc/0x810
> [   49.129529]  devm_memremap_pages+0x1c/0x60
> [   49.129762]  xe_devm_add+0x8b/0x100 [xe]
> [   49.130072]  xe_tile_init_noalloc+0x6a/0x70 [xe]
> [   49.130408]  xe_device_probe+0x48c/0x740 [xe]
> [   49.130714]  ? __pfx___drmm_mutex_release+0x10/0x10
> [   49.130982]  ? __drmm_add_action+0x85/0xd0
> [   49.131208]  ? __pfx___drmm_mutex_release+0x10/0x10
> [   49.131478]  xe_pci_probe+0x7ef/0xd90 [xe]
> [   49.131777]  ? _raw_spin_unlock_irqrestore+0x66/0x90
> [   49.132049]  ? lockdep_hardirqs_on+0xba/0x140
> [   49.132290]  pci_device_probe+0x99/0x110
> [   49.132510]  really_probe+0xdb/0x340
> [   49.132710]  ? pm_runtime_barrier+0x50/0x90
> [   49.132941]  ? __pfx___driver_attach+0x10/0x10
> [   49.133190]  __driver_probe_device+0x78/0x110
> [   49.133433]  driver_probe_device+0x1f/0xa0
> [   49.133661]  __driver_attach+0xba/0x1c0
> [   49.133874]  bus_for_each_dev+0x7a/0xd0
> [   49.134089]  bus_add_driver+0x114/0x200
> [   49.134302]  driver_register+0x6e/0xc0
> [   49.134515]  xe_init+0x1e/0x50 [xe]
> [   49.134827]  ? __pfx_xe_init+0x10/0x10 [xe]
> [   49.134926] xe 0000:00:04.0: [drm:process_one_work] GT1: GuC CT safe-mode canceled
> [   49.135112]  do_one_initcall+0x5b/0x2b0
> [   49.135734]  ? rcu_is_watching+0xd/0x40
> [   49.135995]  ? __kmalloc_cache_noprof+0x231/0x310
> [   49.136315]  do_init_module+0x60/0x210
> [   49.136572]  init_module_from_file+0x86/0xc0
> [   49.136863]  idempotent_init_module+0x12b/0x340
> [   49.137156]  __x64_sys_finit_module+0x61/0xc0
> [   49.137437]  do_syscall_64+0x69/0x140
> [   49.137681]  entry_SYSCALL_64_after_hwframe+0x76/0x7e
> [   49.137953] RIP: 0033:0x7f53ae1261fd
> [   49.138153] Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 90 f3 0f 1e fa 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 8b 0d e3 fa 0c 00 f7 d8 64 89 01 48
> [   49.139117] RSP: 002b:00007ffd0e9021e8 EFLAGS: 00000246 ORIG_RAX: 0000000000000139
> [   49.139525] RAX: ffffffffffffffda RBX: 000055c02951ee50 RCX: 00007f53ae1261fd
> [   49.139905] RDX: 0000000000000000 RSI: 000055bfff125478 RDI: 0000000000000010
> [   49.140282] RBP: 000055bfff125478 R08: 00007f53ae1f6b20 R09: 00007ffd0e902230
> [   49.140663] R10: 000055c029522000 R11: 0000000000000246 R12: 0000000000040000
> [   49.141040] R13: 000055c02951ef80 R14: 0000000000000000 R15: 000055c029521fc0
> [   49.141424]  </TASK>
> [   49.141552] Modules linked in: xe(+) drm_ttm_helper gpu_sched drm_suballoc_helper drm_gpuvm drm_exec drm_gpusvm i2c_algo_bit drm_buddy video wmi ttm drm_display_helper drm_kms_helper crct10dif_pclmul crc32_pclmul i2c_piix4 e1000 ghash_clmulni_intel i2c_smbus fuse
> [   49.142824] CR2: ffffeb3ff1200000
> [   49.143010] ---[ end trace 0000000000000000 ]---
> [   49.143268] RIP: 0010:vmemmap_set_pmd+0xff/0x230
> [   49.143523] Code: 77 22 02 a9 ff ff 1f 00 74 58 48 8b 3d 62 77 22 02 48 85 ff 0f 85 9a 00 00 00 48 8d 7d 08 48 89 e9 31 c0 48 89 ea 48 83 e7 f8 <48> c7 45 00 00 00 00 00 48 29 f9 48 c7 45 48 00 00 00 00 83 c1 50
> [   49.144489] RSP: 0018:ffffc900016d37a8 EFLAGS: 00010282
> [   49.144775] RAX: 0000000000000000 RBX: ffff888164000000 RCX: ffffeb3ff1200000
> [   49.145154] RDX: ffffeb3ff1200000 RSI: 80000000000001e3 RDI: ffffeb3ff1200008
> [   49.145536] RBP: ffffeb3ff1200000 R08: ffffeb3ff1280000 R09: 0000000000000000
> [   49.145914] R10: ffff88817b94dc48 R11: 0000000000000003 R12: ffffeb3ff1280000
> [   49.146292] R13: 0000000000000000 R14: ffff88817b94dc48 R15: 8000000163e001e3
> [   49.146671] FS:  00007f53ae71d740(0000) GS:ffff88843fd80000(0000) knlGS:0000000000000000
> [   49.147097] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [   49.147407] CR2: ffffeb3ff1200000 CR3: 000000017c7d2000 CR4: 0000000000750ef0
> [   49.147786] PKRU: 55555554
> [   49.147941] note: modprobe[302] exited with irqs disabled
> 

Hi Andrew Morton,

As the description in the cover letter 
(https://lkml.kernel.org/r/20250217114133.400063-2-gwan-gyeong.mun@intel.com) 
is included in the commit message, the same explanation is included in 
from here
> When a process leads the addition of a struct page to vmemmap
> (e.g. hot-plug), the page table update for the newly added vmemmap-based
> virtual address is updated first in init_mm's page table and then
> synchronized later.
> If the vmemmap-based virtual address is accessed through the process's
> page table before this sync, a page fault will occur.
> 
> This translates vmemmap-based virtual address to direct-mapped virtual
> address and use it, if the current top-level page table is not init_mm's
> page table when accessing a vmemmap-based virtual address before this sync.
to here.
If you can update the commit message, could you please remove the 
duplicated explanation?

Thanks,
G.G.
> 
> Link: https://lkml.kernel.org/r/20250217114133.400063-2-gwan-gyeong.mun@intel.com
> Fixes: faf1c0008a33 ("x86/vmemmap: optimize for consecutive sections in partial populated PMDs")
> Signed-off-by: Gwan-gyeong Mun <gwan-gyeong.mun@intel.com>
> Cc: Oscar Salvador <osalvador@suse.de>
> Cc: Hyeonggon Yoo <42.hyeyoo@gmail.com>
> Cc: Byungchul Park <byungchul@sk.com>
> Cc: Dave Hansen <dave.hansen@linux.intel.com>
> Cc: Andy Lutomirski <luto@kernel.org>
> Cc: Peter Zijlstra <peterz@infradead.org>
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> ---
> 
>   arch/x86/mm/init_64.c |   17 ++++++++++++++---
>   1 file changed, 14 insertions(+), 3 deletions(-)
> 
> --- a/arch/x86/mm/init_64.c~x86-vmemmap-use-direct-mapped-va-instead-of-vmemmap-based-va
> +++ a/arch/x86/mm/init_64.c
> @@ -844,6 +844,17 @@ void __init paging_init(void)
>    */
>   static unsigned long unused_pmd_start __meminitdata;
>   
> +static void * __meminit vmemmap_va_to_kaddr(unsigned long vmemmap_va)
> +{
> +	void *kaddr = (void *)vmemmap_va;
> +	pgd_t *pgd = __va(read_cr3_pa());
> +
> +	if (init_mm.pgd != pgd)
> +		kaddr = __va(slow_virt_to_phys(kaddr));
> +
> +	return kaddr;
> +}
> +
>   static void __meminit vmemmap_flush_unused_pmd(void)
>   {
>   	if (!unused_pmd_start)
> @@ -851,7 +862,7 @@ static void __meminit vmemmap_flush_unus
>   	/*
>   	 * Clears (unused_pmd_start, PMD_END]
>   	 */
> -	memset((void *)unused_pmd_start, PAGE_UNUSED,
> +	memset(vmemmap_va_to_kaddr(unused_pmd_start), PAGE_UNUSED,
>   	       ALIGN(unused_pmd_start, PMD_SIZE) - unused_pmd_start);
>   	unused_pmd_start = 0;
>   }
> @@ -882,7 +893,7 @@ static void __meminit __vmemmap_use_sub_
>   	 * case the first memmap never gets initialized e.g., because the memory
>   	 * block never gets onlined).
>   	 */
> -	memset((void *)start, 0, sizeof(struct page));
> +	memset(vmemmap_va_to_kaddr(start), 0, sizeof(struct page));
>   }
>   
>   static void __meminit vmemmap_use_sub_pmd(unsigned long start, unsigned long end)
> @@ -924,7 +935,7 @@ static void __meminit vmemmap_use_new_su
>   	 * Mark with PAGE_UNUSED the unused parts of the new memmap range
>   	 */
>   	if (!IS_ALIGNED(start, PMD_SIZE))
> -		memset((void *)page, PAGE_UNUSED, start - page);
> +		memset(vmemmap_va_to_kaddr(page), PAGE_UNUSED, start - page);
>   
>   	/*
>   	 * We want to avoid memset(PAGE_UNUSED) when populating the vmemmap of
> _
> 
> Patches currently in -mm which might be from gwan-gyeong.mun@intel.com are
> 
> x86-vmemmap-use-direct-mapped-va-instead-of-vmemmap-based-va.patch
> 

