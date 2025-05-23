Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84276204096
	for <mm-commits@vger.kernel.org>; Fri, 23 May 2025 05:10:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.14
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747977019; cv=fail; b=sTuY9S9gD1Na/L2GjP9KzB1RQRMbSdJgQMKMw/Z381OxKS3cwAczuD0Y/HYSNCOGv5726cmxJTiEoIxfaYAdMAc88HPBE7sd7zf7Lf9bC2WzM0sQgJO8PEKyESVBiGJ4mFeGwsyq0vi/6t0/Zw12JP/iP/wI+OR7iJ72Mzkbza4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747977019; c=relaxed/simple;
	bh=VUc0f0rgEEP1LSTcffog/5A3cPLWxZZbhvi7u9wG3dk=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=mdGHXGymqcBJR9wVNJUQu3Qqw5nnlFbHUNR/WSMDGGhvvzIPhXUGKPZFzjDUFTrGL8d7mIUfiY7gHQ4HnS1FJ8XbUBDn8RIiLe3p4FcG6jA2aeakmB3m1Vn3CNa9ZZOFrMexxNYTTn2KeLqDLCkSVYU2N5eAk9eLmwJuG12lAQs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=igBmZW1S; arc=fail smtp.client-ip=192.198.163.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="igBmZW1S"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1747977017; x=1779513017;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=VUc0f0rgEEP1LSTcffog/5A3cPLWxZZbhvi7u9wG3dk=;
  b=igBmZW1ShrSOt2SdBmkTewqUhDorRiblRz3YiptPuebeNQ9TnyRW7Yop
   1Wo9VBMroeRAgSqqayZWAyhCYQ4lnFa2Yvwd6yOqLrP70AcPQXLz9JMpR
   ML6xwApKP+zgWmAVCw6t04pc+9PMt/3yifbqBOM8kfToDM/NhVTOsfI2n
   znICv+Xm0Y4LnnIWIf6fX/hIqsa2m544iT3VaE4gucLp705Ylr6ASbNnI
   leFTCaeIG4DqXQk1vxHamXv62brdkAg+VBAfvBxiA8x6JVW8d2tkZufxO
   8bT4xRSVXnYjeCXzipBtSOiqsXfeAsr0ogawQg4ESMAy6oTdjip5GP4Mt
   Q==;
X-CSE-ConnectionGUID: bY6k6j1cQnKDzrKnx/pjAQ==
X-CSE-MsgGUID: P+IrmMmPQfy5O/ooa/IZ/w==
X-IronPort-AV: E=McAfee;i="6700,10204,11441"; a="50136560"
X-IronPort-AV: E=Sophos;i="6.15,308,1739865600"; 
   d="scan'208";a="50136560"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by fmvoesa108.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 May 2025 22:10:16 -0700
X-CSE-ConnectionGUID: crSq57M7QVK3TUZUovZGkA==
X-CSE-MsgGUID: BXKqz8CWSGCEAmxap45JFw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,308,1739865600"; 
   d="scan'208";a="145663150"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by orviesa003.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 May 2025 22:10:16 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Thu, 22 May 2025 22:10:15 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25 via Frontend Transport; Thu, 22 May 2025 22:10:15 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (40.107.237.59)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.55; Thu, 22 May 2025 22:10:13 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=iXhtk0CWaT7PBoGsUedsRUqWf/Zrcs0Y6mS3vai8y9FSCSBSwNYbnkIrsb/halDfSl7EQauYx9LB0kpPI5tEuD328nOY49BCBSulZGRxJlImH6BEFknYCnKQvqU8aO0zyCQrEFiQ04zRcTYMILKI9CGe2P95LVbcvOrjt8LkT93hxSX+JhbSzs6urAnE44ql0m5mrsQ5bbvFF37Ebx8hynwcOhZ3T3F6a+kCKKTX58BV3Jr+AT+ROdUT22k/rX65koJoQcIiiSo3raYjZIrwGJ94Gdlnn5aRyrb4dqugJH+dqr4vORZrmgZAn8kaURIkKFbI85wVZtH9dYe13fUsLA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4/YHvTIh/a734g9L+/r022zSrXtuC8Y1qUdGZtXaoRw=;
 b=Ve6ffI7w3WSQi7zFZCW6WGXwtciQhaw3kM8k8CgVP95kLepxpxHMCM/EeBBFkyjvaybOKDLRFyveYyJ+UrGf2FfSU8tfRFXvc9dzDiaj4QZCIGoZYqcoG7+jOKu0GD8V8pk7VxocwPmhML1rU+CPwAdVjCo/7Q3k8L6WH486Yd8vd2C4YoeN42VcRHKqAu+CucOd+H2n9XHCbc9pDKxC6tNgywh1wHQbfqxpkrDd8U8qDimIpLdZKG8lOCtPDV+U1ZphPAmXNa1iVbMHmMGdz7Jxe6mAZAApCy8kcw+hGzjClakIBWYM5u7Lb64MKxxLwQQgOrpTXLVCDopmvXnOrg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM4PR11MB6020.namprd11.prod.outlook.com (2603:10b6:8:61::19) by
 DM4PR11MB7759.namprd11.prod.outlook.com (2603:10b6:8:10e::18) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8769.21; Fri, 23 May 2025 05:09:58 +0000
Received: from DM4PR11MB6020.namprd11.prod.outlook.com
 ([fe80::4af6:d44e:b6b0:fdce]) by DM4PR11MB6020.namprd11.prod.outlook.com
 ([fe80::4af6:d44e:b6b0:fdce%6]) with mapi id 15.20.8722.027; Fri, 23 May 2025
 05:09:58 +0000
Message-ID: <d413234d-47f6-49bb-9b99-5dd0da5d79b6@intel.com>
Date: Fri, 23 May 2025 13:09:43 +0800
User-Agent: Mozilla Thunderbird
Subject: Re: [merged mm-stable]
 sched-numa-fix-task-swap-by-skipping-kernel-threads.patch removed from -mm
 tree
To: Peter Zijlstra <peterz@infradead.org>, Andrew Morton
	<akpm@linux-foundation.org>, <libo.chen@oracle.com>, <mkoutny@suse.com>
CC: <mm-commits@vger.kernel.org>, <vineethr@linux.ibm.com>,
	<venkat88@linux.ibm.com>, <tj@kernel.org>, <tim.c.chen@intel.com>,
	<shakeel.butt@linux.dev>, <roman.gushchin@linux.dev>,
	<muchun.song@linux.dev>, <mingo@redhat.com>, <mhocko@kernel.org>,
	<mgorman@suse.de>, <kprateek.nayak@amd.com>, <hannes@cmpxchg.org>,
	<corbet@lwn.net>, <Ayush.jain3@amd.com>, <aubrey.li@intel.com>, Chen Yu
	<yu.chen.surf@foxmail.com>
References: <20250521165653.4CFACC4CEE4@smtp.kernel.org>
 <20250521191114.GE24938@noisy.programming.kicks-ass.net>
Content-Language: en-US
From: "Chen, Yu C" <yu.c.chen@intel.com>
In-Reply-To: <20250521191114.GE24938@noisy.programming.kicks-ass.net>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: KU1PR03CA0012.apcprd03.prod.outlook.com
 (2603:1096:802:18::24) To DM4PR11MB6020.namprd11.prod.outlook.com
 (2603:10b6:8:61::19)
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR11MB6020:EE_|DM4PR11MB7759:EE_
X-MS-Office365-Filtering-Correlation-Id: 3c7e4246-d24e-4164-b469-08dd99b81024
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|7416014|376014;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?ZFlIbzVmSmE5Tnh3dGJ1dFBkY28wS1ZrdWRpMjdaOHd4MWhBVTEvN2w0ZHZ2?=
 =?utf-8?B?ZE1mcURCdmhTSnllb1dCWmdEYkhneXUyaFBnS085RkpGTTBTL3JQdWNlZHlj?=
 =?utf-8?B?aWcwSkxFd0tGM0NWVDBkYlhtd1hNU1VYOTFaT0tDM0J4WkVVajBuNFh6WDZx?=
 =?utf-8?B?NE1tQ2g3SFZIc2xYZUFyWTh6M1d0ZlhVaFhjaG12dUJNUkZpRjAwbjhaam9t?=
 =?utf-8?B?R0Jrck50NlVGTk8wdEQ4Z1VQUUlZSUtYY2QyYm5kck9rRWtQVmVUejgvNjIz?=
 =?utf-8?B?ZWpNcWd2OEppS0RoNFFjVVZKMkdVNS91aFNEMDhXS25LU3I3bFIzNUR4K3JB?=
 =?utf-8?B?LzJ0NjNDY0NENXRTQXBiVDZ2d1pFcVJxQjJ6K0w4SGgvWm4wazVlL1J1T2Fj?=
 =?utf-8?B?WWF5MnY3OTJMN2VRMDVyZ0tmb3hOSXpCMGI5WURobEJCTllJQUlKRlRJYWt3?=
 =?utf-8?B?MXpYTllkVG9XejNSZWNuUWFXMXBQMUZxemU2cjFMc1NPY1FKODJnYnpnVmdj?=
 =?utf-8?B?ekM3bS9tQTRiYlhhcTI4alhJWStneGR6QTBPZ25aR2txdnBSOGp3TE0ycm5I?=
 =?utf-8?B?ODdPZGVqeGp3V1puT21lcnkvWnBqazA5Ry9nU0dZWExaSzM5ek9Va2MzdWtP?=
 =?utf-8?B?ME8yQUFoS0F3clNZSFRhbytoWnlkeW9oZ1BLYlVjZnZEMmZOWXlkZElzcCtP?=
 =?utf-8?B?dEk5WHJtVFJGaGN5aHhNRnBGNFA0ZFdqZWEwZTNNWXozNkRzcFMxK2s0UFMy?=
 =?utf-8?B?Q2NGNFlySll5RjNQN014ZTBVVzhlVWFTWUU5Uk1Qd3dKa2dIVVdPakJwVXlV?=
 =?utf-8?B?aFB2Y3RLc3ZIOFdheXg4OUp3ZUw0V0JwdkJZalFLY0kreFFqOW5ZTFQzcHNN?=
 =?utf-8?B?RzZOdVRBd3F3WXdpVGxDWGJKS25UNHdvWTlzVmh3QUpQQXNhSTBweTlGV3Zw?=
 =?utf-8?B?ZGp6ZDJhd0V5RDlFRkhCaGZINU1yOEQ1ek95SnhYUFZVNVhBRER0YlF5L203?=
 =?utf-8?B?SUJkTTdCaGJaVVFKT2RQZVNJUVJBU2FmNzdtRXU4b1NJRW9hdHBNUVhJeE14?=
 =?utf-8?B?WVhOUlBDT1VPd3l0OHhSZmRnSmYvWTVYSlBKODZ2YnprMWhBbGNiYjFSeWEy?=
 =?utf-8?B?UTQxY2s5Ymw4Zm9LK0d3ZDJFOWtCeW8vaXc4YkVCaEJxdkJNQ0JpM282RENP?=
 =?utf-8?B?RENBWnpxTGErcWJqYURlcC8zaWFXVjMwdUd0L0MzZTdENkhPSTBMU0wrU0R6?=
 =?utf-8?B?d3JtWHF3L3E1YUNhRW55NW84SkJCSHVDVXBXZkVrU3N5U01UOHBZZjlOZXNR?=
 =?utf-8?B?VS9Yb3Bvak8rcTd3cXBrbmJ2Ump5MENMZ09BbWZ0U3BEWDh4OEtMWFB5d0Mr?=
 =?utf-8?B?UWFVZXVQSHRrczBIRmQ5REZLTzBXcHc0UW00UDBMY3RlR3p2KzlHb09Gb0R6?=
 =?utf-8?B?SXhmMENCb0E2ZUtQZFprelY1ejB6bWs1cWRPQzVpSU1RakFsTGxvUlRWaU96?=
 =?utf-8?B?MitYYjEyWGh1ZnEyT2dnZnZGMmdjbHJIYldWODZnNkVhN3M1UVd1aXpOTmtr?=
 =?utf-8?B?RlB0a3hlQ1hTZitqVHd4TklEU2wxcVNEcGJDWDAybWNDVjVtTWdDM2dZUmtF?=
 =?utf-8?B?MWxGUVR5QThmUXJ2NzZLeFd2Z1ByZWRxeG5sTHBsRXQxMmJWbmhrWWxkbzlT?=
 =?utf-8?B?eHFyWFFJZU9CcGNjNkcyZGQ5OTBIR0JpdWpvc3pPTlNjR1Y2NlRrTjJWN1o0?=
 =?utf-8?B?WEhjeEFjV0VOc04xb2ZGV1p5eURXRWltRlZkMkZaY0hXdWJJQkQvdFRqL1Ju?=
 =?utf-8?B?aHgvcXBjUDV6S2NuR0Jsd1RTZWdkQWhtZkU1c1lvT2w5ZjBwQjFGdlNHTW9q?=
 =?utf-8?B?OE54QWZjb1RYcVozT1J3a3JKOGsvc3BlcW4zYmZRVVR1S2c9PQ==?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR11MB6020.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?MXB6bG9sYi9nNzUyV2ZZNzJscFR0MElicmlNRm43NDJCT3R1eGNiQzk0d0kw?=
 =?utf-8?B?YUUrM2MrYWFPanZrTmtTY0pYMEZFVk4rV0NicENnMHFsS3hhU1NRbUxGc21O?=
 =?utf-8?B?b0syQzl5VjVTbHZrbHBCcEdoejRiU01vS1p3MTBRazA0WXV6MFp2UGUvMSsw?=
 =?utf-8?B?Rzl0TDF2N0dwVFFtem4rbG41OHgrTis2cHN1QWF2YW9QNnJsUGpEQk9IRUNL?=
 =?utf-8?B?cFFVVVYrQnhUeW00TEY0ODE5bnYrc1JSVVM4dW1xdkJLUGNSVVExREh5QytY?=
 =?utf-8?B?enZUL2lsU05CSUhIMldrUmhMQXF0TUQ4eGNVeXFXekNDMlcyQzE2KzZXVTI0?=
 =?utf-8?B?aWpPQWZVU0dKRmQrV0w1bm8raEJCWXdiTUlIdElBQkRRWldyV3AzcHJCMVk4?=
 =?utf-8?B?QUJYaUEzektEUmtJOE15Nmx2MElUekZBOEJaeWhrUEY0cDJEamtCTk12OVpK?=
 =?utf-8?B?SStDWnVUUktiWnRXelg0UTJlUEt0MElBRW13UmZyNHVmWU53QzVpbnZNVHVr?=
 =?utf-8?B?dnF2eGNsZTdLcVVRb3hEc3dLMTQ1N1NleEZBRWQ4eWFJRjhhYTc3azEzM2o0?=
 =?utf-8?B?YjU3cnhYb0FjbVRLaXVOWjBSR0YrbmdnUmxoVnpGNWExSWRlREZwaHVJcTR3?=
 =?utf-8?B?ZjhNQUF2MEZ4MkRSYlFqOUcwSmtoM3FJbEt4NGpDMDVlY01Od2h4dEhlMGJZ?=
 =?utf-8?B?TU5rSHRQZnlqWC9iYXRyZWpEMXc3MHR4emR2enNVd1BkdFRmTjQ1VGVES0xn?=
 =?utf-8?B?Ny9GRVVuQ3RIQjNsRXRKbnBYUWh2UTRkaFltMWoycTJ4b0xFUjAzQVpub3Yr?=
 =?utf-8?B?aVo4MDlHNlAxN3RBZ3lvbHREOTBTYTZDYkdpZnJTeFVxMC9ZeWoycmM2SThZ?=
 =?utf-8?B?MzFTZ0tKaFBQZlZqSlRMbUJ2M1U0MVRyTmd0MjlycElaeTdHV25BSkpwUnJ6?=
 =?utf-8?B?aC9HQXdFUkYydkY5UE5NVERjeDQzOElRZDQyV216NkI1T0lrYTNEWFBlVEZZ?=
 =?utf-8?B?K2hTK2dnbzdndXhDMWhZSm1TdEV3bXl5Q0xYSnZyYVd5V3M2Q3luSlRWODJE?=
 =?utf-8?B?NnZwUVJ4MXpEbjFyU01xWERtbFBCMlVrNTJUZ1grc1VoTzV6T0JDVC9yc3Nu?=
 =?utf-8?B?UWFUM2I2eTk2TEF6SlRxaUNGKzlYNjNaRXZ2dmwxTTB4M0hMQUhodyszaVdV?=
 =?utf-8?B?Z1oyYXlFZ0gxOFp3Q0ltWTkycDUxZkthRDdwV1gxQmdTOUtyMkVsVTJFSVpt?=
 =?utf-8?B?Rm5tZmFEVFlrSUthN0duOGtWMmVBaFZqY0xRUlhzdVRhalZqdUpndU85Sllu?=
 =?utf-8?B?SmZDRVFsUmZPT0QwdTBLUmtTcnNYVWZTdHo2eXRLZGZJU2EvdzJaYVBxR0p0?=
 =?utf-8?B?ZFI4Nm10YnNKRGJKWnAwQTJGQ1FIM3ljN09taEtuNnVUWCtmbmxiYmQ2bjBl?=
 =?utf-8?B?YzZVMi9qQ1dvNzdxWHorZElxRDZHYkxDMHRMOUxFM3VDdEdlYi92T2RSWVFp?=
 =?utf-8?B?Zk10V3E1RHlLd21XbWgySnBBWTNxWHdMYVo4QWlBeFZGdmh5SWFsa25EYXY0?=
 =?utf-8?B?eE1lMzd3ZTd2TlIxTU1qY1VqR001ditIMnJwTDlsb1JBRzVHYlZOc09hUG9x?=
 =?utf-8?B?ZGdjQWV4QWdtQjMyUzNZamF6UHRvaXZPSkMvWndTcW9Za0lWOVMrUkJVcFIx?=
 =?utf-8?B?dVQ3VlJoSDFPVUs0ZDRFdEtrS3g4dE15T0ZhYllsajVkSko5M0UzcTEwQWsy?=
 =?utf-8?B?UWViRGpNS2ZxMjVEQVBBWit6b0FBYmFtYUNkRC9MTzlxSkhZTjlPeWpoMEZt?=
 =?utf-8?B?azFjVUFFaGJHTEdpeE9FRXdiRDZqRzJvT3Y5Q1Uvcld3L2hkV1AwTi9kdTNF?=
 =?utf-8?B?ZHpnOUlyQzZMVnZic3BJNFg5bGZxQ3BxR0tXWm5mL24rMk96b1NDZ2JVR2RF?=
 =?utf-8?B?bHI4SE8zQnBxN2Y0TExBRXQ3dmFZb3dyZVRoZW9JSlk1S3VJQXFnaTFUa1Bs?=
 =?utf-8?B?UUNLY0htMFFDTW13dFE0bzVUbjlHR2xXL051S3lZZEFMemYzL0kralUwWnBr?=
 =?utf-8?B?NEhFU1cwTWpXTklWZjhHWGxwVXh5RmNnTVdBc2I1Nkh1TnV3OENaMjhPaHpz?=
 =?utf-8?Q?yfNrgIPlNsD3FtHFy1f2Q+e6x?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 3c7e4246-d24e-4164-b469-08dd99b81024
X-MS-Exchange-CrossTenant-AuthSource: DM4PR11MB6020.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 May 2025 05:09:58.1661
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: wNCI4vELKdvPsbHRDya6H1OKiubk07ANLX3DiNqMK8uAVf+sftQh40ldX51/UN/wecw9EbVS4nLIVXS/jkhNBw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR11MB7759
X-OriginatorOrg: intel.com

On 5/22/2025 3:11 AM, Peter Zijlstra wrote:
> On Wed, May 21, 2025 at 09:56:52AM -0700, Andrew Morton wrote:
> 
>> Fix this by not considering kernel threads as swap targets in
>> task_numa_compare().  This can be extended beyond kernel threads in the
>> future by checking if a swap candidate has a valid NUMA preference through
>> checking the candidate's numa_preferred_nid and numa_faults.  For now,
>> keep the code simple.
> 
>> --- a/kernel/sched/fair.c~sched-numa-fix-task-swap-by-skipping-kernel-threads
>> +++ a/kernel/sched/fair.c
>> @@ -2273,7 +2273,8 @@ static bool task_numa_compare(struct tas
>>   
>>   	rcu_read_lock();
>>   	cur = rcu_dereference(dst_rq->curr);
>> -	if (cur && ((cur->flags & PF_EXITING) || is_idle_task(cur)))
>> +	if (cur && ((cur->flags & PF_EXITING) || is_idle_task(cur) ||
>> +		    !cur->mm))
> 
> !->mm is not the right way to determine a kernel thread, PF_KTHREAD is.
> Notably, there are kernel threads that have ->mm.

One question, would removing !->mm be enough here? In the current Numa
balance implementation, neither kernel thread nor user space thread that
does not have mm will be skipped IIUC. As Libo pointed it out in 
task_tick_numa():
if (!curr->mm || (curr->flags & (PF_EXITING | PF_KTHREAD)) || work->next 
!= work)
	return;

If someone uses user_mode_thread()( umh) to create a thread, this
thread does not have PF_KTHREAD set, nor it has a mm_struct. We
don't want to do numa balance for this thread I suppose.
The commit b3f9916d81e8 ("sched: Update task_tick_numa to ignore tasks
without an mm") add this !curr->mm check, and we might also want to
preserve the mm check + PF_KTHREAD check in task_numa_compare()? Do I
miss something?

thanks,
Chenyu



