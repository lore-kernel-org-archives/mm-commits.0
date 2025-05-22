Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2045.outbound.protection.outlook.com [40.107.93.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F390D515
	for <mm-commits@vger.kernel.org>; Thu, 22 May 2025 06:31:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.93.45
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747895513; cv=fail; b=Ojibf5ov5/xiwRxF6Jog+XAqz5nlrmWXZTSzGDPEhC/JayoHwyR9CwJ7MREcTmVk/GdpKEKYiOyeUcTG+mD9N+twRRLBEunADsjHg0BXL7PwQFqnvxg64ZMg/9AuEEr1mz2LY8AOqUh9NEE2k/jQrvgAcUb6q7FtbmSEiRu6OEI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747895513; c=relaxed/simple;
	bh=+Vtp+vAF2Tj9xhJO0QPRJuwf2P2CfCjcU2Mw7hhcyXs=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=BGtMlqp7ZdNd8Xe0SSk1dGBTiaQk5kPJFNqdWYzZmXFLHPuSNK29tM9eF7kQYeyPHD85l62/6vAysSTFoCCeYW/Ge21x57pd5nA6FMdtnwMe5rxaqQd+1BwEn+EuT/8NLfUJMY/XsvjgeFVSBb8ZguOoCOlfNdT8jhfYii8W0yI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=1NJhrYcz; arc=fail smtp.client-ip=40.107.93.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="1NJhrYcz"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=cs6X3ayZSLyMd0TSTLhnL1zAHcK7XX9whurn7wotfsN0Y0htnHvGOaNFPg+ON1YYDsBnQo/5aSlkl6Q4QWkxl4f4/Q+tp/PntcvKFXvxiuzs0uCcoa6S8ho+euwcxzQmJRFIdwERzfuRbkWQd0IRuMbDCZX/vQt4yDeFSeBKNA5ps7b67ZcQNLtboEd6HQ54IQlDlJqvWIFlNsxZpdrSnVh97UBcKqxc4hwGOkGYPMZdbZPOrMd956oquijT87+67vQaPbw4OOhlr8AjtdlKhBDJ+QJSZY6EJhulF+21B+/7oMZACZ45IJH4Nyq+GSNI5kl7iG//K6ROrE7TgRVvEw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=no7EBjrZOOp2bYJiCimqpwU51nFzF+nanZcxM799xNg=;
 b=UU+G4dOwNjvZP8NgS3YAoCVqX2b/42V7VnPrZXtaxHKSPpGVyGOxW7s4ThJi/UeB383KLO+V6K5uNW3zTOQVrh6/uFAhh6EY4nQymtXdD32KRY0grgHIhb1zEQvYJbL71LlYWriS2ff2zsH1LLp5A5xLYKYEwJKKSdHygVitfhmHY42uDBHNM16aOe4CuG2DQ2AGaacBDXryYiIrIZo5ExroV7g9wgCWTHl6gL113jhCVmhd94FH8TWGlqs2qJitYfO789kaiAjkET0+SejlcoCUPlvf0aYgNAPCCft46NMwmDtwHYR7ywIPHfzqf1OZeXGLJJWKL9sc7r0ubrMr0A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=no7EBjrZOOp2bYJiCimqpwU51nFzF+nanZcxM799xNg=;
 b=1NJhrYczXhezX/cqznqBIuzvWAOidDZxC1EudfLcZYHhpFS5FH+V/SmO7UoTnmAxLiULWdxYGVXmxEiejhdkTq9g8RP5rjxvyzuO8hGYYm60xXhFM/LNJutdP/wALRBkG27yGmLzCv1nlXYIqyXUqcWK5bazDXtjAJtAYIxVKEs=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from CH3PR12MB8658.namprd12.prod.outlook.com (2603:10b6:610:175::8)
 by SJ2PR12MB7798.namprd12.prod.outlook.com (2603:10b6:a03:4c0::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8746.30; Thu, 22 May
 2025 06:31:48 +0000
Received: from CH3PR12MB8658.namprd12.prod.outlook.com
 ([fe80::d5cc:cc84:5e00:2f42]) by CH3PR12MB8658.namprd12.prod.outlook.com
 ([fe80::d5cc:cc84:5e00:2f42%7]) with mapi id 15.20.8769.019; Thu, 22 May 2025
 06:31:48 +0000
Message-ID: <021d2962-2fba-4c27-ae9f-4ded2df44903@amd.com>
Date: Thu, 22 May 2025 12:01:39 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [merged mm-stable]
 sched-numa-fix-task-swap-by-skipping-kernel-threads.patch removed from -mm
 tree
To: Andrew Morton <akpm@linux-foundation.org>,
 Peter Zijlstra <peterz@infradead.org>
Cc: mm-commits@vger.kernel.org, yu.c.chen@intel.com, vineethr@linux.ibm.com,
 venkat88@linux.ibm.com, tj@kernel.org, tim.c.chen@intel.com,
 shakeel.butt@linux.dev, roman.gushchin@linux.dev, muchun.song@linux.dev,
 mkoutny@suse.com, mingo@redhat.com, mhocko@kernel.org, mgorman@suse.de,
 hannes@cmpxchg.org, corbet@lwn.net, Ayush.jain3@amd.com,
 aubrey.li@intel.com, libo.chen@oracle.com
References: <20250521165653.4CFACC4CEE4@smtp.kernel.org>
 <20250521191114.GE24938@noisy.programming.kicks-ass.net>
 <20250521135854.3ba2d1f61bd2c6a4af36ac13@linux-foundation.org>
Content-Language: en-US
From: K Prateek Nayak <kprateek.nayak@amd.com>
In-Reply-To: <20250521135854.3ba2d1f61bd2c6a4af36ac13@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PN4PR01CA0071.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:c01:26c::16) To CH3PR12MB8658.namprd12.prod.outlook.com
 (2603:10b6:610:175::8)
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB8658:EE_|SJ2PR12MB7798:EE_
X-MS-Office365-Filtering-Correlation-Id: 864939a9-469a-4860-c293-08dd98fa5426
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016|7416014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?OEZldkpaSitzNjlGTSttVEdHejJhaUI5NlVIUHFXaW8xNmI0UEFKMnZSYk54?=
 =?utf-8?B?WWkwZmJ3SFFlbDJ4VHB3MEpQWnlJSlBxTFRtY1JTOUdGU0wyOHZoNjdtQi9s?=
 =?utf-8?B?eEZvd2VSL0h2UjNwOTE2Y1NrWnlRU1lwcWo5ekZBUDNrUndDTGZuTkR1VVNI?=
 =?utf-8?B?V0FoM3VrbWc0Skg3Uk5Pc01Lb2dUYUNBOFVOUWJ1M0JXc2hLUDBmblFsVDhH?=
 =?utf-8?B?RWVEM2tTcUs4NUNlTWV6TklURGRxTlEvRXJyUGMrME45OE42Lzk1UGdGdkNl?=
 =?utf-8?B?NmMrOVZhN0JLQkN4YWhJRnFEQ3dwWFZ1ejVEME9YQllOZVNZdFZSRDJpSDJu?=
 =?utf-8?B?OGZKK3FHQmRrdTZ2dHFZODRHWjcyOWJVRXVvTHJpeUI2TmRKZDByWXVuMnpm?=
 =?utf-8?B?NVgxcys4QjdVVUt3WDR5bmZjWXJndDRBS3Y0SXhmbWxmQzkwY3NCODdyRlkz?=
 =?utf-8?B?YXFHZFhiMk9GZmRXYmtTaWZKYWFkVnUxZzBHc3ZnR2c3ekRJUXZHZnA3Z1E2?=
 =?utf-8?B?M01wODdJQ3ZtVi8yWFJ5em1kTUJzeHA0bmJpSENXYUxhSTlIWW9FNHVKWWl3?=
 =?utf-8?B?RmlPRVlLb2M3djdBMDhrWEtWMnFCY05jQXNGWFYzNTJIT21ZZTZYOUQ2Tngv?=
 =?utf-8?B?ckRuNityeXF4dTV4QStRUUFvTW9rVnRKM0w0cSt3R0FYRXkvMkR1U0tKeXZ2?=
 =?utf-8?B?eGZoRExGN2ZnVTdkZXZpelQ0Mm9WeTc4S0FpZGtkL2haVHJoQUxRWnNQdDlh?=
 =?utf-8?B?UmhDU1VmdkI0bk1pV1kwRmdUZDFvSkdrMjVRbnRsQ2g4RlNBeS9YYXFBOTJh?=
 =?utf-8?B?dzFwTGdiN1BtNlgrcDZpaUhTYVhtWFphQmxRQUQySWtsQTU4YTRFcmxnRlJY?=
 =?utf-8?B?bEZDYlNyNS9nMVFmQVVFaVV2NjFBenpqN1Mrc004Vk9aZ0krNGhwcjRrYW5H?=
 =?utf-8?B?ZlJpZDBWMzFXMnFCMUVvL3ZQNXRGVEhVdHI1TlhxMGVuVWZMSGVCV1lvRXBP?=
 =?utf-8?B?ZXZxTEdsakozZDc3U2VGK0s2Q0ZReUEvb2w0VVJFRTdLSjdqS2tNZEhNa29h?=
 =?utf-8?B?aEFjaFlQN3MvZWhMN2FUakgzcFZzREUvYVVTVG9BdEVoeGMrYmI0MmQzK2ox?=
 =?utf-8?B?NVIvNUVRTjcxcFYwLzBCOTRUSm5NdDVNR2o5bnBCMkp3YW9rb1RSWk4zK1Bw?=
 =?utf-8?B?M1VLbVFzU0pxSXRFSG5xMUgxQko2aW5JUGlvZjN4TWlaWWI4RXlHZEpUQ2hr?=
 =?utf-8?B?dHBHY004YnlhcG15a0ZVOHpRTXZ6WUZEYnowWmRieWdWYWZqTEREWnJDK0dB?=
 =?utf-8?B?cEVMKzVhWGMxRVBGcG80bFJoM0ZQL2xDU0NEUGhMYThEV3pRTUQrNW16SFQ0?=
 =?utf-8?B?ZjdBU3owWlFGVFZJT1N0a1V5NDdiNnd3dzcwVlNIL0lybXlaK3JmZXNWeUlu?=
 =?utf-8?B?dnBQSHJSOUN5RDNvV0p5T2N3WlVXaDM2WkRicWkySkQvaXQzSTQrV1h6MXk2?=
 =?utf-8?B?NjRWanFRNzR4dlI3SHpaZDc0a3l3NWhKVkx1dEVGZ0w0RDN4UGpXN1RnU0Y3?=
 =?utf-8?B?bUJKU3NOWjNRSXVIa1k0VS9Oank5MUJBTTU3Zy9NUHZOZXJ3a3NRZHNoY054?=
 =?utf-8?B?TkhGNzRQalFRMzd2UnhrbEFyTzBBTUZpZWYxK3FJZEs5UVRoZE5zWHQ1aW9w?=
 =?utf-8?B?a2pTVmZxUDlNT1JTckNnNDhielgzZkI0bisremtVR0xTQ0tZR0FWREdKa1h1?=
 =?utf-8?B?R2JaZ0NOQjJiZG5SM3NmS3c2aWptZWkzVUwrVDgwLzNvWEZXc0l4ak41Vngw?=
 =?utf-8?B?MGg4bnBWSWg3bENkN1p2TzlkY2I4TzZSY2VSMEJyWlRQY0JweTZFdlRBSE9J?=
 =?utf-8?B?eFlFSXVYVmFGOGZzRHZvK3BHNEMvMFRDN2piTTNPOGd5a044bkpCbzhNUk51?=
 =?utf-8?Q?PFxdvFz6lJE=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB8658.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?Z0p3TlY3OTdMN3FEZkJrSG9pNE9TL0R0bjUzZTFiTmhmVU1aWExWNHFGZlY0?=
 =?utf-8?B?eHZYWDh5VDlIR2lRT0NSN2hjT0xSemwyWi9MWG84d1c5cXUvVWRPc2FweGZ6?=
 =?utf-8?B?WXVJd1NNRjJXaDBtQUNqVkFvNUZUMnBIVml2SzN2d3FDNEZYK0dRRFRRMVVp?=
 =?utf-8?B?UGVjVExGdWR5aUptY2pTTzR2SlVuM1c2RjVKSnVqOGR0VFg4TE4rOVd5ZEJr?=
 =?utf-8?B?dlEwT21JMzBjMEZHa0hpZmFEdjdnUDcrUmk2eW54RFBEOUFDNkdtRGVGOXhK?=
 =?utf-8?B?b1VOWE5ZSGhCT2ZIZHJQakowdjR5eWt2b2ZjV2U3N1FsNGxXM2liWDc3L2tQ?=
 =?utf-8?B?RGdQMkF3S3BoREpMazBhNFBJOVlnbTBLY0RSUXFUTzRUaGtvdXdEOTZKNlp2?=
 =?utf-8?B?bGNoSmEyMW9jU0tPcU9FNFFydExXYm5iM09IUGFXNCs4MTJXRTA5UGZDMWY0?=
 =?utf-8?B?b0JGNDkyaG1LeWh1WG5VMWFkeXljdjR1cDE5UmhlWFAzaTNpdkVKTEMvdjFE?=
 =?utf-8?B?YWF5VThrRlZ6WTRPU1Vibk03Z1JuVGtTb2hqQUZxL0o5YjV4UkswcG5QNFhR?=
 =?utf-8?B?cjBwaWY2T2Vaei8zZGg0dkhvZGE4NWlHRC9QSzIxZXNUMEh4bWJMN0IwdVVM?=
 =?utf-8?B?WkxpY0RsQzVLYzRTMlY3ZHdRYjdCbjkzbkk2RXkzcjdGRlNkckZpcVNNYUsy?=
 =?utf-8?B?QVgrZ1pqRzgyNG4vUU9GcTMvVWxXRi9MY2lETTM1VWN0ZDEvVDBQY2FDSnhP?=
 =?utf-8?B?MnAxQ2lVTklVTFBITi94NERFQmZFZ3VLMFp5LzVPeWRRSktsK1FPdGtFRHl6?=
 =?utf-8?B?cEplSHI5ZkNPWWw3RmxvRzVZTlZtVitqcm1rQnhSUEpsek1kUnQxazNCdTBQ?=
 =?utf-8?B?cW9rRmlFSVl2Z1h6aFBGWE9jamxUdTB1UGYwNXd4RlZibmFOc29MNEtOTGFK?=
 =?utf-8?B?UG9TVjg4akl3SWlvVXN4amxDQVBTaDhUSEplaVJBN3k4dXpidUxZYmhNbHJH?=
 =?utf-8?B?bzJWcE5IVkNxckordldHQjNsK2QvM0JnUkxabkdjdW5talo3eStZbEFzL2pL?=
 =?utf-8?B?c3ZLeTZqVUdncW45WVJMWGRTRFpMWXQvR2pBbTFWN2tDNDlJbm5XQWVUNWhI?=
 =?utf-8?B?ZlYzeFJYMHBWQTd3VytHTnVRdHUvVDlLWno3MzFsVXQrNVdxOVdUSko4eDdu?=
 =?utf-8?B?eFdJNHpUOGlvMzQ3ZWI1T3NoU1FyaTRCUFA2ZU9qZ2hJNGlDeFZXT0xJbmwx?=
 =?utf-8?B?dzVKUEJpMmwyZWJCZHJoZWxXa2JKaDg0bWFNaXF3eEljeWN4K25KNGgwWFdM?=
 =?utf-8?B?WUxuS09ZNlVlallxY2NWVmgrREJsNE1ST2p2MC9SSk1MVng3eVp6VW9XZ0VI?=
 =?utf-8?B?WW5OYklLT2tYRUE3dHF0dHdWNlJEUExTcnRIYng2SWJoUlVBeHY4YUJNZi8w?=
 =?utf-8?B?Q2FkckE3TWQyM2t2blhXaXVXWnRNcG9SeHk2SzZrUVFOVUpwWkdYdG9RblBa?=
 =?utf-8?B?QzMzdjlybEpHbVhOOGVxeHJLM2tmWWhvOStwak9uYUVOajkzYVVyRWZ2Z0pv?=
 =?utf-8?B?d05uRGtudkx3QnlZRHFjM2Vpdm9RaXhZdDVtSlh1MWZ3N2pkRFkxejJ1eWd0?=
 =?utf-8?B?RzNuOGxUbGZ2R09mcW01dFBybXQ0R1VmSHRwS3pwemR4ZWx3UUdDUUtXb1pV?=
 =?utf-8?B?N2luVmQ3WkNFc1lFVW9xN0h3QUhueWh4UDRqUlpETG83Z2M4UFoxalNOSGY4?=
 =?utf-8?B?WG1nUDdGbW4yL1F3R1BqcnZoZElwTXdaZ2FuZ2dDanVOZi9YRG5WdlBSY0gy?=
 =?utf-8?B?d2xLc0tYTDUxRjNCaisxbHlXZU5YNDUyejFFYjIrbUdaam9EZjdmZmJ4dGgx?=
 =?utf-8?B?SE9jZkF3cklVdkJ6MzdxOGxiVzJSZFVkNTkwYTA2T0J6VVUvNmM2d3FZOFR0?=
 =?utf-8?B?V25CdWZBSGhWOFI2aHdQSjY1Q1RaTTVxcENIWFg5Z0Q5RytMUklTK3RwWjlQ?=
 =?utf-8?B?RkYwWlR6cDFkZU1BWnM5R0UrK3VTa3RCbnM5eCswemo5UmFoUTAzMTE2bHEr?=
 =?utf-8?B?cWFKcmpIOHFKOWVuUmhNaU9lRW1yeERIekUrbkpxS1dHSGd5YjZlQ2xGcmNx?=
 =?utf-8?Q?HWPplXr31/9sDdgukqPQ4wM4y?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 864939a9-469a-4860-c293-08dd98fa5426
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB8658.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 May 2025 06:31:48.2005
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: GX+VUXFecw5qPqX33+nmySv5GkgVrftL9L/ctUBAsvMeltzlZzJbpdlEmExRrW6RpywTJ4QbyRq6P6YJZ5ow6Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR12MB7798

On 5/22/2025 2:28 AM, Andrew Morton wrote:
> --- a/kernel/sched/fair.c~task_numa_compare-correct-check-for-kernel-thread
> +++ a/kernel/sched/fair.c
> @@ -2274,7 +2274,7 @@ static bool task_numa_compare(struct tas
>   	rcu_read_lock();
>   	cur = rcu_dereference(dst_rq->curr);
>   	if (cur && ((cur->flags & PF_EXITING) || is_idle_task(cur) ||

Question: Shouldn't ...

	if (cur->flags & (PF_EXITING | PF_KTHREAD))
		curr = NULL

... be enough?

is_idle_task() checks for the PF_IDLE flag but looking at
kernel/sched/idle.c:

- play_idle_precise() already ensures PF_KTHREAD is set before adding
   PF_IDLE

- cpu_startup_entry() is only called from the startup thread which
   should be marked with PF_KTHREAD (based on my understanding looking at
   commit cff9b2332ab7 ("kernel/sched: Modify initial boot task idle
   setup"))

Also "is_idle_task()" seems to have replaced the "(cur->pid == 0)"
check in commit 1effd9f19324 ("sched/numa: Fix unsafe get_task_struct()
in task_numa_assign()") which should be marked as PF_KTHREAD before
reaching cpu_startup_entry().

Did I missed something?

> -		    !cur->mm))
> +		    !(cur->flags & PF_KTHREAD)))
>   		cur = NULL;
>   
>   	/*
> _
> 

-- 
Thanks and Regards,
Prateek

