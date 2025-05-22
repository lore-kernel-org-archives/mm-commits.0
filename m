Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93C27EEA6
	for <mm-commits@vger.kernel.org>; Thu, 22 May 2025 08:37:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747903034; cv=fail; b=l909bwvmBGgEPb+iJiQrCl2jyHzl/HouG6Sh4TsqI2vDVcWZwwiB3vpIXPN/pb0bEcRkzbnocM7pc0NsS/46/WR7lJ1/XpmD9S+ZI4eGkYtYqeApgdKFt58opWMaOn04v9AGQ4s1Sd75SUoB/cZ1q7iMyk7TCFddlLx9ZSghczg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747903034; c=relaxed/simple;
	bh=MHv/pZSl2qo/6i3NN9TfPwUDI3m0kUYQIP99xY7YSHM=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=cdgkp60GJjNe/je9GKMJIHDN7LOOrjUftAWz6uZj1g+afowPqE4UOb8BCfGwMgaYzDz1bumQzeajmHDExlyGjmrOl/g0d/uCpIFtLMUB1eNCy6jPez/vl7zrMXSEK8kRBAWqzrVTaKuYsc6rdqoMyZoF7GlLalCcxTdBIZfSm2Y=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=KxTm3Wlh; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=m8XezvgV; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="KxTm3Wlh";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="m8XezvgV"
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 54M8S4rA027951;
	Thu, 22 May 2025 08:36:38 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=XYmmcd4yn/zJr1KDPAH+JmGYOddURamskgKDHTu9wds=; b=
	KxTm3WlhWpyPmr6cb5li1YLlO2aTcgln2YDSmV2iCUbdHQ2mIswIX+fTdtL2LXrB
	Jn1eFlLPzVM4woT9498/94X9sEhbEkwKw7TsvA7O+A3jK4rukiHBi6OSVa8KD7no
	7UuFxoZYtIDZ42zTWZ41KNKP1aM9JouUtnMpQB1VfSJL8aAqZVVbMyHcxkLDF2oW
	RCitEiwKo8ixs/oFtxDrklFYIqf6bI9XCLSWupWoG67yPAU0mHJhKEqrMpnUAIqu
	qwUGSijhlR9BNo3RWF5if913bOtzzDHF0stMeh62KaBRYHb9Ubbcuz625u1Vax3A
	l0d57Oh0VcYLvqkRrG7CYg==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 46t0e1811d-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 22 May 2025 08:36:37 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 54M8WXG7033631;
	Thu, 22 May 2025 08:36:32 GMT
Received: from bn1pr04cu002.outbound.protection.outlook.com (mail-eastus2azon11010043.outbound.protection.outlook.com [52.101.56.43])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 46rwepcska-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 22 May 2025 08:36:32 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=i764EB+rWdqP+bc0n3m6jdNSc4lsE18SovGcfzhuVcrnlVA0AuRljLbxWeOlmNXFop4oUG2JSqdUqDql2GL+J4wCPrCgQP+rLhHH2v7hgbSoox6h9yVz5AubTYz5sSALcl+k3Euc3e8LYKPjj2Ahaf7v68M65Mc0aTPjf3m0zgmxobIkaJdXVoavgZ4uXm/Rd9C6ZarwXGvQnOJimETfB0ndXp4gkbSFGGc3xV5dFHux83OTe2cTeJqzgDbRKceilS8A9Hor1GngPv5urbPsKp1CQegqRSmMa4X77t+fCQiqci7r6MEB6rAAg0hOcg9Sidrc6pVPHRrCANJhudDKTA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XYmmcd4yn/zJr1KDPAH+JmGYOddURamskgKDHTu9wds=;
 b=BKGfRHwiAxF5bf4uTCLmuBxV6Wp/QvITZBtwBr1vXHiLAxQoYWLtugeQeWL24SE/RmjFdYs6YmpDJ5RR4oOKFcYRnVSBdBcjN0XWzS6HVBIszgrmz6zcX7dQz/Iz9ou4GhLNmPzibAw0az5C5LcX8xKEk3NQpws7M/WbUqaVKepSC8M7cfkv7ZAzFoE2EdrXUeHlV9UX7GBbJ/Xg5ErqCKvLYWOm22hrDsUy5WOyaLi5c2JWO2w9BQ9+dQGCtp1prntU5pQrHbkNGnMNHBGxKJ5y1dMS8gLSs/E4Om0fddHgzbIbArmmFbHrgsHXk+cbNeh3WI2QWuqfJhC3F7YvrA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XYmmcd4yn/zJr1KDPAH+JmGYOddURamskgKDHTu9wds=;
 b=m8XezvgVnv/89VfGlsNmXjLlcG5HVr3qJLmDGPnH5kjVp7SH2+WMN2icqkUk+kOtmKc3LHsYiR68/YoABinMBnx1ImObEUoS8XFqjRxxxa59O4ki2iDSsQhdmblaaZacqZc4c8R3GN9wQifaTUvvifP8uF/hQvHcddNABG98x+M=
Received: from DS4PPF5ADB4ADFC.namprd10.prod.outlook.com
 (2603:10b6:f:fc00::d1f) by DS7PR10MB7324.namprd10.prod.outlook.com
 (2603:10b6:8:ec::22) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8746.31; Thu, 22 May
 2025 08:36:30 +0000
Received: from DS4PPF5ADB4ADFC.namprd10.prod.outlook.com
 ([fe80::2072:7ae5:a89:c52a]) by DS4PPF5ADB4ADFC.namprd10.prod.outlook.com
 ([fe80::2072:7ae5:a89:c52a%6]) with mapi id 15.20.8746.030; Thu, 22 May 2025
 08:36:30 +0000
Message-ID: <2d424f40-c6d3-4c7c-ad46-e6cc6e4077e7@oracle.com>
Date: Thu, 22 May 2025 01:36:27 -0700
User-Agent: Betterbird (macOS/Intel)
Subject: Re: [merged mm-stable]
 sched-numa-fix-task-swap-by-skipping-kernel-threads.patch removed from -mm
 tree
To: =?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>,
        Peter Zijlstra <peterz@infradead.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, mm-commits@vger.kernel.org,
        yu.c.chen@intel.com, vineethr@linux.ibm.com, venkat88@linux.ibm.com,
        tj@kernel.org, tim.c.chen@intel.com, shakeel.butt@linux.dev,
        roman.gushchin@linux.dev, muchun.song@linux.dev, mingo@redhat.com,
        mhocko@kernel.org, mgorman@suse.de, kprateek.nayak@amd.com,
        hannes@cmpxchg.org, corbet@lwn.net, Ayush.jain3@amd.com,
        aubrey.li@intel.com
References: <20250521165653.4CFACC4CEE4@smtp.kernel.org>
 <20250521191114.GE24938@noisy.programming.kicks-ass.net>
 <yf637jkmcdunhgs6qjbnprygpkifnphdcqofp546dd6ti6s6i4@b2geqedevt42>
Content-Language: en-US
From: Libo Chen <libo.chen@oracle.com>
In-Reply-To: <yf637jkmcdunhgs6qjbnprygpkifnphdcqofp546dd6ti6s6i4@b2geqedevt42>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: PH8P221CA0047.NAMP221.PROD.OUTLOOK.COM
 (2603:10b6:510:346::26) To DS4PPF5ADB4ADFC.namprd10.prod.outlook.com
 (2603:10b6:f:fc00::d1f)
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS4PPF5ADB4ADFC:EE_|DS7PR10MB7324:EE_
X-MS-Office365-Filtering-Correlation-Id: 1da235a2-ef9b-4c84-843f-08dd990bbfe1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|7416014|366016;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?bmdwcEcwQUgrT0l1VC9Oa05wMFdZUVpTNVZ3ak14QjI0bVJ4RUdDTHZ4SFYz?=
 =?utf-8?B?b3hBQUQzazYvOXB0Tm5kMStmNDlxMlAvN2JFeXJFU3N4QUFpVVdqbzlCVlN0?=
 =?utf-8?B?S0VBc3g2SHVMd1BudHduQ0Mzc3kvR3kxT09CV3plN0NCVnYwS0lyWWFKY3dj?=
 =?utf-8?B?RmM1RTFzOHc5MkQ0eUVsSXh5Z1ZHOWpoTGpBRytmTTJrTmZpdTVINllJTkIv?=
 =?utf-8?B?cjlIQUtucy9peUlUMVp4RzRBSnVIK09ZZVVxZkl3M09NVERmYkZBTjN3VGJo?=
 =?utf-8?B?TS9RQ3FoUC9zSE9pdXF6UDF1WUl6U2g4MFJrQ2NmbUorQVBhOHgwMG5sbHho?=
 =?utf-8?B?ZHN3NWkvNjV4MFRZUi9jMkdsd1RyR2J2U1M0dlU5djhVZjVaTDlmVXo2MXdV?=
 =?utf-8?B?Z3h5ZUpCKzUyWHpuMmhpdnNQV2s2UG83YXhyeHRieWVaSmlEQ3F1MXFuUkFk?=
 =?utf-8?B?SUNLNU56UmRVckpLRTJXanBMTmxXUzY1RXBDOHVHMk9zU3AxbTZuaE5Xb2I0?=
 =?utf-8?B?R2FIUHRvL1FMQzNERXhwTXVmU2tIbk9YcW5NYnQ4RDkzTS85dmJpdnVlT0ha?=
 =?utf-8?B?K2UwMXkwM21GQk0rcHlSeGFlZzlZTG5zTWtaa3FKdnlpVHg2dmUzMWZqb240?=
 =?utf-8?B?ZTZDR0tMZjM3bmN6dHV2ak52bGlrdGNlanRlQmV3VmhYY21Ccm5jYlZwWFFV?=
 =?utf-8?B?NDgwSGRFVUt4UFViVCt2eVlsWXNqYmNSVko0Mm1naFozY3VseFJ3NEt6amJI?=
 =?utf-8?B?Uk9HdXdzbExTc21JcjFGS0lTSGNWVTcyL3VKcUtLOC9LbGJESytMVGxUaHhR?=
 =?utf-8?B?NG15VnZFRy9wQ2JRVzdENHJLRWtucldYaDdHcjk1Qy9kVFhrRFlxdWgySnNY?=
 =?utf-8?B?eGpQcVVQUTlFdFpOQzdzS0wxME5PUmJid0dHSlNEUDhDN1A4SlFLL05Jczdk?=
 =?utf-8?B?amNxS1Y5dHowTkhkdkN5VlFFV0xmcTdoeGcrSnNZNS9pQko1YzBHNTB0Q3ZM?=
 =?utf-8?B?ZEdlYlc0ZTJESVhJZ3B0bVd5bzY1RjZkWlp3WU82UFhSdm04ZUtTOXlVcHVY?=
 =?utf-8?B?eWtnVHR6K05tMldkblNLbG5lSGtpT0FzcEM5Z0VDS3YyTGU0UlAxRm53RE5P?=
 =?utf-8?B?U0t1OUdxU291UUpKdTdZQ1pNMVExWXVobW9ybkt0bFlEWWdsT0YzVzBKVnkr?=
 =?utf-8?B?Nlk1NEtvV01XT2xMY2Q2Y3NmOStuQVZMQ1ZVYWladldkTzF2d0taNUNCOXg5?=
 =?utf-8?B?NXp6ZUE0Q25tV1M0bzFtVG1RYisveTk0b1V2d3VMUlF5UERPOHM5Vm5SMnpu?=
 =?utf-8?B?RlBQWThIbENkc2Jmc1Rhd0RaN2habldYdFRhYmo3bjZPbGlSdkpsWm5iLzln?=
 =?utf-8?B?eEhqdXpwbFRHSGx4UEFQV2wvczhSaG9aUjQrZ21YUEs3WlVZN2twaG01VVht?=
 =?utf-8?B?emErUnlnd1VPZDdTMTRwQk43eFVCWjJOamdDWmw4U3VxMUQyb1BUais1dVF5?=
 =?utf-8?B?VW8raHQxSzNwdDlSWmZYK3k0U1R1N0kxbWR1OWZ5VjNvZUJidjliYTJEQVZV?=
 =?utf-8?B?NVFsbm5RSTlCMzZwalZkcitQVGNqRWt6ZzFHaVBHazM4OUZPNUZQUHdjNUEx?=
 =?utf-8?B?SGloMlpkN0cxM21NSCtJMTZrSHRvS1FIR3duK001NXZCUmFYcHJDcWJZNHVv?=
 =?utf-8?B?NzRSRXFzNnY5bDF4Y0JCeXNmUFBPOHN4N29aMWRBYk5RSUZwMTc3STMyTlZm?=
 =?utf-8?B?UjltSXQ4ejZBVnRTcnhBaWRaL05vb211NXJ0SGErYXF0d21hSUluMkY3Z1Np?=
 =?utf-8?B?UG96NE1oUjVWRVpPYTA1YVpsazdSbXZINFdTaVNpRTVTRFM5ekkza1V3OEgv?=
 =?utf-8?B?WFBPU0xFdU13TWpNbEhSK0Y2QlVCd0V2d2wvaTBaSk83V2ZrTVlhK1lIWEFw?=
 =?utf-8?Q?orA4gqzunXE=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS4PPF5ADB4ADFC.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?ejZiYlpvTDRJMXdySWJZTTg1QTVtOElodExiSU5sNjVIbHRIL0VvVmtlbnFI?=
 =?utf-8?B?UmVWaDg3TVF2VUZVYWVyQlZYMzZWdExheHhkZExSeldYajVIb2dsdzMvRWlY?=
 =?utf-8?B?UitUcjdxMjc5VU55UlRZQzVPUlJoNmJNU0JvVDAyZE9xa0c0R213QWwzcS9I?=
 =?utf-8?B?OElKUzVQdkZuZnhwcGJmSjZjclQwbFJ0OUZQZHQzbDREMWxzVXQ2WWxZQ1hv?=
 =?utf-8?B?R0xUVnk4YVY1MXUxaG1tdWRrODAva0dhdVJDUGk3TldyclNMS0dwbUc3aHNi?=
 =?utf-8?B?SVpOT0JoOWI1ZG0rb2JzOG9wRmRWNzVRa3hQVWNiS1JFSGZJUDJLNjVESUhw?=
 =?utf-8?B?MUJ3VjlFbTkrbnY1cUFDS3JLWC9DQmtmK01xdHNtQ0FEZ3RCdFZueFlVbTcv?=
 =?utf-8?B?dXpJTzk1bFVDMGloTEJtSnA1TE9BNDFCbWlrRkhvVHd2MEFmd0VVZVpaRUxi?=
 =?utf-8?B?cUcxWW1aV01QZ1JLNkwvTEgrak5MSG9xNkVtMmM1ZHJjaEk3ZGdWbkdaWkJX?=
 =?utf-8?B?cUNXSHAvY2duTVVrY3d3alpsS1VVb3hrb2VITXo4TWQ5SUduRHBsdFhrVFJL?=
 =?utf-8?B?NUR4d2xhZjJuWkd5SXdES3k3ei81OWkwWnlxREFnUXQzcm5oSCtVdkk2aEV5?=
 =?utf-8?B?VC82S1lLalE3RkRrZDluTG1iemtZbm5SdkgvM0VRZE5tRFljYkZDQU1PTWdG?=
 =?utf-8?B?Y2Q0Q1FlL1AxWXlMaUczbzdHbDd4STd6NkJJeG9FWFU4UTNBL2Z4TDcvWnBK?=
 =?utf-8?B?TUdhck5VYjRsY3dYQ1lnTkFGeDlUUUVkREp0YTN5dU8wQVNyeGR5bThqQms2?=
 =?utf-8?B?eFdkSFlhRDhkR2tYWHRMV3BBVHgzUWNVaWlTNVEwNnllOVBoV1RycllRSEhO?=
 =?utf-8?B?L3JVYmlseWpzWXBPamloNHBoMUJ6Wk9iQ0dFWVh0cmNMTFFMQUVxNVowSjg4?=
 =?utf-8?B?Q1B1blNOVnZ5aWR1QnlnSGlrcjNMdDdMTkhlOWRiRU42NkdYa0FDVWlleHg0?=
 =?utf-8?B?Y0F4VVl2MVBvQVdudW91bnhsTjFLS1pzaEkzbjhzZnVScDFFTzNKdHdqYkNk?=
 =?utf-8?B?anU4OHhzWSsrOGx1WWxhZ2toQnVPcXVMSjhEQ3E3L1NXRURlQjE3TFNURVE4?=
 =?utf-8?B?SUs0YmtmTEtmcG1OblhHVExQVENaUXR2dFlxTFdadWNrNjZNZmtVTHFYRHNz?=
 =?utf-8?B?MnZCeE1lenhiR1J6SlUwc1hJaXpuS3EyL3lreXlrVkt6WUlhRURlWEdrNThs?=
 =?utf-8?B?aTlGYXpKUXRobGEvdEYzdWd6dkJBWXFLanV1eGwrRU9CSlEvSGpJV0hkWUxU?=
 =?utf-8?B?VzF2VlFQdTlPQlhRZ3o5eGRNQ1A0cGRvZWk1TkRTSWtjMjM2RW5zMndlaEdw?=
 =?utf-8?B?T2U1Z2ttckdwMTJRS1pDT2xXT1FwWjBkbHRhcXZYWE13RktKNXFRRWVwc3Rt?=
 =?utf-8?B?cForRWJ2TUlVN2syWlh4MFo5VG8xRkhmVUZ2ejh6eFErTkJoL3RQdUZWekdr?=
 =?utf-8?B?MnMxcjZsRGI1ZnRLbmRPUzNLblZiUk5oSm5uQ0FGWEVLeTNLeVFkUGZERjhx?=
 =?utf-8?B?OHlTQTZJUXVaZ3RnanFkS2wvTU1WVjFGc2dvc1VHL2FVaWlUTlJIMHkzMEV6?=
 =?utf-8?B?dXlMcWpVcmMreHppZHlIQ0tRUTBmejdXdThBWmJIU0JacGEzWlV0L3UzQkRw?=
 =?utf-8?B?MFo2YytlT0JNaU5LenJyYTc2RWtodWxvVzMrcTZlZlJjQkovRGxBMzA3cWJK?=
 =?utf-8?B?ZTZoM0lLQ1Y3Vy9mVTZWL2d3WkpQbHpZeE5vV0VlcEpRcWNCaXVYZnF4eThS?=
 =?utf-8?B?Q2NUOXljY2FLQ0IyZjkzcjA3cEIzd3ZCWTNzSTlTMmk1VENHTkRhWk1kYWZR?=
 =?utf-8?B?anpvOFNDZnZXNVFacE1ja2NrUHFlQk1vZkdFdjVaYklndjF2NUV6dEh6bFpL?=
 =?utf-8?B?M1ZBRkhDME5qWitRUGJJZE4vWUJDOWxpRzN2UW9qOHJGRDZFQ0JGNmdDZmIy?=
 =?utf-8?B?cmFTMVRWNWZaY0k0OWpNYnpyMHBWQ04xdUlqcStTODVtbEh0SGtXMVU1STBD?=
 =?utf-8?B?cEFlS2c4TnAyRVJldGh2UXI5L2YweTh4Z2ppTE9OS2hOeGV3NlFDLysyL3pF?=
 =?utf-8?Q?+F8pW3TTcLh79MNAX8sIue3u8?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	pzmuoqTvVBee36lPKfDV1mtsDX8lUlH36x0KwcHvPM1/jIiPv8LRaFoDh0qJpaSOvSUWIk2mwwlg/cE0lVbkkrgG3UKzvTwRxC7mNIcZDRgsZb5YgXCO3xk2cM4YAVr+eGYr81eCjm1iRyJbESqWv3AWdFFVm1Wh/6E914IRI/9HAH0CtRilzNeJYQTGPqbnqbfQkartitErU6RfzQ96SkAdERw7wbVRQ7oMPw5dtO5JZvIwkE3l6V5f8gE0Q1lmHnGDv+phnhJ2CSQZ6vwdgtcSI8tQL/R+dQZc21ReifmwAXS6PVL/CqD5PECw4bLSltHWakQ4GHJTAq4Co1vbojfDmNwXv/7pEDvOmuBXj0ke9w6nwgpNmjgr4uZQfcK4MgOMIbR2LmxBPzJZ8dRn8rBLxvTHV7FSmEMyFUb5EUkY5m9dDKvpdLNTGkLFwxv7phbstGq5Digu2jJY3iUxInppFDTfdb8j89K7N2Mu7hEbnhPCw30gj2SettIZa4zxc2zT7PR5CS0nZZpdmPUBXxYLBps/YjIWXYC4nAEQvU/9zfQOkT9HxWyORkpR29+ef61JpSjwTu6PA0QanLt6cHxQwUhF/DDtVdwpasE9gHs=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1da235a2-ef9b-4c84-843f-08dd990bbfe1
X-MS-Exchange-CrossTenant-AuthSource: DS4PPF5ADB4ADFC.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 May 2025 08:36:30.1015
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: AFVhSQPPtI7OLMgHPnF/g45NmYk3nyqieHhmHfBsD0XpFIWst9iyxIJj3DN+aoY5hAcSRvapDzU0Q1fuJxLa+w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR10MB7324
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.0.736,FMLib:17.12.80.40
 definitions=2025-05-22_04,2025-05-20_03,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxlogscore=999
 malwarescore=0 suspectscore=0 phishscore=0 spamscore=0 adultscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2505160000 definitions=main-2505220085
X-Authority-Analysis: v=2.4 cv=BsOdwZX5 c=1 sm=1 tr=0 ts=682ee215 b=1 cx=c_pps a=WeWmnZmh0fydH62SvGsd2A==:117 a=WeWmnZmh0fydH62SvGsd2A==:17 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19
 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10 a=dt9VzEwgFbYA:10 a=GoEa3M9JfhUA:10 a=JfrnYn6hAAAA:8 a=WAxD7xmrjhEtNItHi-MA:9 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10 a=zZCYzV9kfG8A:10 a=1CNFftbPRP8L7MoqJWF3:22
X-Proofpoint-GUID: u-lmBris-mkUEtfPmFwCcSTkmMfPeVul
X-Proofpoint-ORIG-GUID: u-lmBris-mkUEtfPmFwCcSTkmMfPeVul
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNTIyMDA4NiBTYWx0ZWRfX9kDoGkl6uiGM Bx2zQdPVhUzdiMMdGMRy4WPsI0lUPfyVCTrca+S5xKxoZWzqPecX5mQyk5ejZPb8rWDIJkM+d0W WMysvfKQKKHiBQD+WBAV/UMnCwVluLmxd1BPIzWo3s+CQxJPMepUx8q1tPzJgD6vuAFnGS+QnkG
 Jk3220gXl9m7TK9E7aQLk7WXZR8yHeQLfmSsZzpMhhS3tL065D4Tgw+RR8mFhdtOaKj65jBvcPu sTfRt8xB0JqKEiog09zMTyWk/oHhCXC7etM+08ffukosUxVRjMO0qwCvMhV+qpjglsiODzH8Nlh MBWRfFLz6+X2Dk583UDcdM4Q2kvr1PoMkwj3mzUMwIiy0/qZ3xR9FJr0QnNBmvoWB9vVr+a+uVM
 ClELPzOVyrJPvRaIJPUyPbvNW5IunK9Sr5Zf0QdDlBV3ksyzz1G95ATBuQFemcQUjRvBZcKt



On 5/22/25 01:19, Michal Koutný wrote:
> On Wed, May 21, 2025 at 09:11:14PM +0200, Peter Zijlstra <peterz@infradead.org> wrote:
>>> @@ -2273,7 +2273,8 @@ static bool task_numa_compare(struct tas
>>>  
>>>  	rcu_read_lock();
>>>  	cur = rcu_dereference(dst_rq->curr);
>>> -	if (cur && ((cur->flags & PF_EXITING) || is_idle_task(cur)))
>>> +	if (cur && ((cur->flags & PF_EXITING) || is_idle_task(cur) ||
>>> +		    !cur->mm))
>>
>> !->mm is not the right way to determine a kernel thread, PF_KTHREAD is.
>> Notably, there are kernel threads that have ->mm.
> 
> How does this compose with the NUMA balancing? Should kernel threads
> with ->mm be considered here? (I don't know thus asking.)
> 

Not really, at least not until we change other part of NUMA balancing code.
Kernel threads right now with or without ->mm don't get VMA scanning at all
if you look task_tick_numa(), so they dont have page access stats from hint
page faults.


Libo  

> Thanks,
> Michal

