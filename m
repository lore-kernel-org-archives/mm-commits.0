Received: from YT6PR01CU002.outbound.protection.outlook.com (mail-canadacentralazon11022095.outbound.protection.outlook.com [40.107.193.95])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B73EB224B0D
	for <mm-commits@vger.kernel.org>; Sun,  4 Jan 2026 14:24:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.193.95
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767536647; cv=fail; b=ghaHDvzH9cAZfyvC1uPjLPcHd1nYLSIUe85OnIwe87kIStYcS5vYRLdpvvvaus2aTS9B8i+3vOwV/7hgeYxFSoMDxIKrNEKDvhVOyxXocdbPSA2y7WVaVvIAOF4RNueezVpgtt0Kmee63+6x51NQQRex45UCw0aOeH1aUUd7Q6k=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767536647; c=relaxed/simple;
	bh=QQQz4jToIm+ESwL4PmGljmgrM4DOc3vtQOcw6g28N8A=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=Yp5PJJA+EwpsjoI7N++S+1TUvwb1/jz3e8fk7vZ/mpkrskjzdHWo0zks/Wd41GS/tMAvhCXy6slxO1wa4eNb5cQsa+vwR2phm/CMo7SCKzZplk5Ye2SZzYlJfybgbeWluY1rqZNCWcHj15EPktEPA8dHBvR/r+pdWOEqYEZwANc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=efficios.com; spf=pass smtp.mailfrom=efficios.com; dkim=pass (2048-bit key) header.d=efficios.com header.i=@efficios.com header.b=s9QhbDOi; arc=fail smtp.client-ip=40.107.193.95
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=efficios.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=efficios.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=efficios.com header.i=@efficios.com header.b="s9QhbDOi"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=RymTMWpd+utXrW/DX3G//402fNjWC+kGyZwRH2rc01cSPkShoDlbYw0cifIYtVxHFtNxq/p6pcQuW7aff4vPIfGj/yiwC5rTlxeW+YFSkXZZTb4fp9g1QwesKOZ0S8s12ur01WVi2zw4ir6vUQoRrZkMg8r0yudl69hrx1MaUkO9NPzYuTS0McA378boJE9NrZDPkxxYrYgiP85uVL6ncBkvrQK/JDfXZSbCljLGuk16lcfxQNWIgJ/X29PaBPZzZcbwzeTe6A66+54L9CewGocLTQrRe7h2QQsnR6iYWJoWMNQa+iGd4qTKCy+kMEIDRVZPWgwGT5qfg6uGv9psgQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=j2L3suaRBeNKxO6MXX7LnV6EkfNR5bcuP+oYf7FxSNo=;
 b=SevSqkrY60Oxy4Kkcb90+mIfjY/1Rq7D81tWzDHlFaGfgnKbOlOqQYEf2+A+d+TvJa0H1vVMpeoKlf9TrZxGhBu7gWyU0IB9xP4JSOJII2KcqhWpmvCYrEPkZbeSqASrSQAJXqdw8tXFOMOZPE/8jr6szlWmvgHzd/5TZwjcEL3ird5YQkPYeBhnAaEbsi+yU9+FN5UtfLGW4h29l8LPdPKEh76mdxaHZEdzJVG8nLDC91A+jPkwjdriBxfGFLv3UhNMgkpkvQOAj/SX4+DEWCed/hPWUAAdE6Bhuly8NG5ABohqYMKf6fF56DTAzHIvtvI1Yf++tw/ZNsaZR2Wd3A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=efficios.com; dmarc=pass action=none header.from=efficios.com;
 dkim=pass header.d=efficios.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=efficios.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=j2L3suaRBeNKxO6MXX7LnV6EkfNR5bcuP+oYf7FxSNo=;
 b=s9QhbDOivtLSCcYjm8yLAgozmbIhXMTHku41NNaQ7IXSHyu5PJamPE6GS96oec3hHJOIrhG5lxz+bP+vJbJE1hwvrBkMDxd8WlJqDH2kCn+UjqZVmiS53zZqPuhjK181v/m1Q3uqvR54MQWI+oKtbahkAsCuelDFEOk9a9wa1AjJl03EdOmNF/x3K4vr5QAwdmvmNoc1MqaKrd41pbYxZZHaqBMDNV59pjeJi4Cq14+xVrNYXtgg1diKZNEoPz1Ebq9J0zVHDIXpecuU/eB7lT1/2i/V/U+Et5A/0d3bgRLwkewEt5zoji4w4xs93gUJSbeQYrlTlH6LuTELXBbLXg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=efficios.com;
Received: from YQBPR0101MB9184.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:c01:5f::12) by YT6PR01MB11120.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:13d::22) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9478.4; Sun, 4 Jan
 2026 14:24:01 +0000
Received: from YQBPR0101MB9184.CANPRD01.PROD.OUTLOOK.COM
 ([fe80::d202:1261:68f4:cb16]) by YQBPR0101MB9184.CANPRD01.PROD.OUTLOOK.COM
 ([fe80::d202:1261:68f4:cb16%6]) with mapi id 15.20.9478.004; Sun, 4 Jan 2026
 14:24:00 +0000
Message-ID: <13f8ad1e-398a-4384-87b4-5edcab5746f9@efficios.com>
Date: Sun, 4 Jan 2026 09:23:58 -0500
User-Agent: Mozilla Thunderbird
Subject: Re: + mm-implement-precise-oom-killer-task-selection.patch added to
 mm-new branch
To: Roman Gushchin <roman.gushchin@linux.dev>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: mm-commits@vger.kernel.org, yuzhao@google.com, willy@infradead.org,
 viro@zeniv.linux.org.uk, vbabka@suse.cz, tj@kernel.org, tglx@linutronix.de,
 sweettea-kernel@dorminy.me, surenb@google.com, sj@kernel.org,
 shakeel.butt@linux.dev, rppt@kernel.org, rostedt@goodmis.org,
 rientjes@google.com, richard.weiyang@gmail.com, paulmck@kernel.org,
 mjguzik@gmail.com, mhocko@suse.com, mhiramat@kernel.org,
 lorenzo.stoakes@oracle.com, liumartin@google.com, linmiaohe@huawei.com,
 liam.howlett@oracle.com, hannes@cmpxchg.org, dennis@kernel.org,
 david@redhat.com, cl@linux.com, christian.koenig@amd.com,
 broonie@kernel.org, brauner@kernel.org, baolin.wang@linux.alibaba.com,
 aboorvad@linux.ibm.com
References: <20251228222349.36756C4CEFB@smtp.kernel.org>
 <7ia4344ssqks.fsf@castle.c.googlers.com>
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Content-Language: en-US
In-Reply-To: <7ia4344ssqks.fsf@castle.c.googlers.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: YQBPR0101CA0346.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:c01:6b::16) To YQBPR0101MB9184.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:c01:5f::12)
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: YQBPR0101MB9184:EE_|YT6PR01MB11120:EE_
X-MS-Office365-Filtering-Correlation-Id: 3d14583a-d022-47b6-f410-08de4b9ce781
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014|7416014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?S2hlZW5WNThRNDZDTUVlOTNUVGpzaEVwdkRFbTVtUTczZHFEbkVWaHk1ZHNG?=
 =?utf-8?B?bmJzdldtWURGSmt4Mm9LN1RvSFpmM240QzBoUTlWZ1ZZWEJYRmhuejkyS2VX?=
 =?utf-8?B?cTNuNnFlZVZMTlhjamYxdlREU0tSc2NKMjZ4cUxmbFBJUlF3cVFZOFhUNnpk?=
 =?utf-8?B?QitxbWdodkg1TEd0cWwvWXNCRW9KV01KUStPaEpCeWYrTGJBZWhGbzZFRVNr?=
 =?utf-8?B?Z2JDS2xBQUgzTFFsVkxNVmJTUUY4QlY4R01vL2tMb1N3NFVVdEo2dHQxMkVs?=
 =?utf-8?B?R2VwaGhwZkhsZkNsY2VHR1BiTXpjekFEWlc1U2ZyS01TRkZMVlpjR3BGZXY1?=
 =?utf-8?B?Z0NKUUdRZmp2OXg4Z0pBT09OK2xLOU4wb0Yxb1MrVm9GSXJxckFYa1JSMUw3?=
 =?utf-8?B?U3pyZkRQbmZMamJwV1F0ZGdFTk03REFjZ3plZHZNcDI1UzB2OXVPbUNEZExN?=
 =?utf-8?B?ZUwrZlEwc2JvWmlSTDNSZzNnR29odk4vc1BkY0U1cmowOFkxU0diY1U2clAv?=
 =?utf-8?B?OFlOQ2J2REt1QWFFWWtjNDBMWG56UllsY3B6QnR0MkRoMk1RalJITkpCSHJR?=
 =?utf-8?B?TTI0UWZMYTFDYWVCN21CSUV6Z3NzaGJQT3phbExYUlBISDBJckF0WFAyQy9o?=
 =?utf-8?B?Q3BMS01sRmdJa3J1NWJQaWhrZ1IrazlIM2dpUktBYmtzWkEraEV0MHZHMzI4?=
 =?utf-8?B?L0loZXpSV0wyelVTN0VwRW94UENLeHpBOXczSHU0MS84cUxWYXFweEMzdGRn?=
 =?utf-8?B?dk1ORXV2bzdQUENhMzNQQ0lHSE9DUGRYb3hFVkdnYnZhMTN6UzF0V0dMSTBW?=
 =?utf-8?B?NU5UeEsxVWw4UENNVWlSSFRtR2pwWXlBTDcveHl6cTNZeWdrVjFaRXptYjlG?=
 =?utf-8?B?L1BvRGNuOHdzalFyVWU2cFJvVlpxS1NjMHhTQmh1TnNKaWx5Sjc2MnZMOENn?=
 =?utf-8?B?SGIyL0drSWdZdElOMHlGay9vcGhzTnk4UWkwaERqU0JQSVp6NElWMkFYQzAw?=
 =?utf-8?B?ejYwR3VUSzdCbnc1ZnIxSFFDalR4Y0hrRHhPakt5c0cxMEV5YmV0ZmhWc0lT?=
 =?utf-8?B?TXVOcElvbGg0UHZhZjhxKzVVNXYzZGgzdGQxWVA0bmtIdVltaTRja1BrL1h3?=
 =?utf-8?B?MmRZT3lNVFBIQzJYZzdLUURZQkZ1NlMwUEVQNmRBL0lFbzVwVmJ4RFdlc0NH?=
 =?utf-8?B?SXBaaUxaRlFZTlc4VG5WTlIrOGNPNHBBTWpYZG1SUzJ5cHo5c3FyNUk3L25p?=
 =?utf-8?B?VjgvTHozNDRUZWVuR2YwTURWTjZ3Y0haakpHdkxlaEF5ODBub1lmWUVhd1hB?=
 =?utf-8?B?RXRuQ0J3QjU3K0JiK3Btam0zRWRvWTVzNEEzZHdXb0J1Y0FvcFR6eXhiaktZ?=
 =?utf-8?B?S3dibVRzdk12RUNqMC9NM3hTcTdnUlhCVVNybmJaeHJXQk15b1hMY2xTN1RT?=
 =?utf-8?B?SXR1VGNoK2F6bkRaQWRHKzVXbHkwZWdXT3k4N3poZ2VpdUNLV3JmRlU3Tm9j?=
 =?utf-8?B?Y1g3cWEvSW5JbkdFMC8xTXhRYzgycWczR3JkTGJsanJ4NWhpelVjMk04STNs?=
 =?utf-8?B?QWVtejdvaEJvQXFkVlZPRU5iSHRRL01oSmVkY0FTMXJzMzdheGpFcXpHbmpK?=
 =?utf-8?B?eVVnTE11dk8vVVpVR1F6Z21KaE1rM3NmTlkzc0tZTU5vQ1c0K2JOTjJmTDF6?=
 =?utf-8?B?SnRNdFpwQlFYNzFQV3lrZTZvTjV4YytVK0hoU09OclliMnpyTHBrU2txVEVq?=
 =?utf-8?B?cTE0cWMyZlJEN1IzT1lkSDFMZVBPbDduV2N2UGYySm5kWGhSTXRiOHBYYm9S?=
 =?utf-8?B?OEpvbXVXcmRYa1VDU09idUttU0dja3BDYlEreXB6OFdQTy9hcHBTWFg4T0Nx?=
 =?utf-8?Q?wP2nCI3AOZdBF?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:YQBPR0101MB9184.CANPRD01.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7416014);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?akdIekdtREpVakZGS2FtWkFUNVM4Y3R2NUhEZ2QvZGVJRTk0VHVEZnRLckNY?=
 =?utf-8?B?eEpQeGpkUUtaamZNaGhiL2pDblFpaWhHeXhsYVdraXlZazUxZzJ2ZG95UWZt?=
 =?utf-8?B?MktLL0tuY2VKbUZXblR0MU0vc2hUSkk4aHNRek1SUjVRdGlISkM0V2RrMjdL?=
 =?utf-8?B?YTdmcjdZRzdLdEdlK25LcXkzcDJMbXdCekVrcjhqRit0V1BYUm9EU0RYOUhz?=
 =?utf-8?B?UUx2QTR3Mm9McEZ2MTNFOVJERnMzMFZCVXJ4VFFuRk5zSlR1bnlieG1TY2l5?=
 =?utf-8?B?eFI5V1FFR1NlS0ZJTVFnTmxzdndYaEc1L1hzQVVyMnhnbDdWTi9aWU5UbGRz?=
 =?utf-8?B?cG9qdEN1c1g2czd5Ym56Rko1R283SFRndm1MTFhNRmVOTFphZXNsamw1NGh6?=
 =?utf-8?B?ZUlBMzZTb25USEwxVUdaUWV0Ykl1VHBQL3plRzROenRZeWQwZkJmc0RsQTRr?=
 =?utf-8?B?TXhrTEZINWd1Skd4VTBRa2dDNElnM3Mvd2pwb1p5c3hYZXZpbStMRUxvNnBI?=
 =?utf-8?B?NG56TGYvYktkS2VIUDFvOFlLYUMvNmpUQ0hVWjJNZWNMdHAwWXQrVS9LbEZz?=
 =?utf-8?B?MWs2Z1Q1RTdkQ0U0WEdhaXU5SnFEeEh5ajJaVkZkK1ZqMnhITXlBeUNpZXFz?=
 =?utf-8?B?WWM2RFNFUUFDeXNPd20yUjNVaENZdUo1RFNiZlAvdlA2a2xweVI5Uzc5R1Na?=
 =?utf-8?B?Tnd4amNsalZWRHZDZWNSR2QwK2M4ay9sbisyb05zQlJZb0RKZ3Vqb0F1ZU5n?=
 =?utf-8?B?SUlZS3dmZlBEdHZrU2hremIzeHN1TXIwK3BjQlFkSDBGNmhCR05TbDN1Y0dq?=
 =?utf-8?B?VHIzZmNVRjYzMyt3Um5EdUVLdEVCR1QrVHMxQlM5VytHRWUycUxvdlVDbWpS?=
 =?utf-8?B?cEZPMlZOdmVKcElaZGFVYVhmbGYySkxKRjdEeGNRZURPTWhSdExmbkVSckVl?=
 =?utf-8?B?emhTOC9WRlc2TlhiWTYzN3dBQmx6dWUwQk5BWS85Nks2UjNSSkVtbkhDTW5i?=
 =?utf-8?B?L2Nwdmp4Z0s2M2dQNTZScTF4bUViKy9zOVp2amw5TGR6NnI5S1E0c3BEYXN3?=
 =?utf-8?B?UlRYVEZTa2kzMGhZdzd0Z3VmSnVBWVZ0VWRjd2MyTmF4bXAycHdVSFdXMWFl?=
 =?utf-8?B?RXJoaW8zR1ptNHBPcVdGbGNhTzI4cHo1aXIyRE9RK1IySi9BZFBUKytDS05u?=
 =?utf-8?B?YVNtQzF4S2NYbmk0ZVEydjdlWGsrT0FLSS8vWGJlR21IQ0o2TlU5cGtpVllh?=
 =?utf-8?B?T2o2a0hCZ0lma0gxNkxzWndQNmFiQUZab0E2R1pkVDcza09CTlRlYzZJOXJy?=
 =?utf-8?B?cDBKZFR5U2ZVemVPN3AwenZtdnZiak0wcU02clU2TnVMb3VMUzlhVVpQcUN1?=
 =?utf-8?B?OUhTcDY4YVBRNk9wTkhiNEgxQm5WT3BqTi9lckZnVXRIaXJOV1pUK25YV0Nj?=
 =?utf-8?B?Y1IyYXNyVi9kSDdMeCtVRU9WOXgybmozZFc1QkVvUTRMZ3VsM0JOOENmSWt1?=
 =?utf-8?B?a2J1TDhpdVhRMVltaVhFSDV4KzZsMENFRm45b1piUFRXelRnTkdZc3NJQ0g1?=
 =?utf-8?B?YlIxZTNKRzFBSXpoM0xEMHM2TFVYaEhvRjFNZkprLzVwdjNkSzQrVEF6NTkx?=
 =?utf-8?B?SnM2REtVRk5LMm93NDA4ZUJrQWRVT0V3bUdFcllnaWxDTXcrUk5qYkV0N3li?=
 =?utf-8?B?L1lVSzAzcmJJL2grOFVrd3hmTWhwNlpvVlFyeUFGSjd2bGlPQWtDT25VTENT?=
 =?utf-8?B?ZHVzQzQxQXFoS1VXbWdaa0x5bGZVczZWR2t0T3NnaWMzdlpRMTNhaWhWOUN6?=
 =?utf-8?B?THIvWERuQ2RuVk1EekJETC9pREFQM2FWUUEvNUVPNjBrYk1aMVI5ZERjY3JF?=
 =?utf-8?B?NHprYk5hZ0VVdEgyMHFtK0UyQ29XajNDb1JKYmZCOThZYllmV2xnUkFxekFj?=
 =?utf-8?B?RWZDWUN5MHhqOEZ1QTNUVzB4QldYZnJXWjZNLzFKQVZSOUh4QmN6ekV5aWRh?=
 =?utf-8?B?ZnFmZ0RGcDQ2UUxnRWVXUFo0SjNLUHVSWlBsMXdLMW9YNkp5K0lXNXVjbkJz?=
 =?utf-8?B?WUlWeGF0bHYyRVJscUU0SDkvWUhLYlFOYlY0MnRrV0JTS21oUjBoUUhvSlN1?=
 =?utf-8?B?NHJwOHJsWkthR3dkQmNEYUVreGc1dVdBWnFMakhGaWFCQjQwUkxQWGlMdWEw?=
 =?utf-8?B?UkorbkFJR3RVWGRNU2ZnNnhlNEVscmxDa3F2dE5NT0lUZlFjRGY3clB0UVQr?=
 =?utf-8?B?NVhlQjQ2dE14RUpuUjUxeUNLZDAwMGNTenhuMHZVVnQyREd3VXlGd1hyaDNv?=
 =?utf-8?B?cXV4MU9Nb3gzcEgyUzRRc0RJUXVaSGhDSlJCM0dTenNubTlFU1BsMEptRUFN?=
 =?utf-8?Q?Gj6OPsz9yNwAzfww=3D?=
X-OriginatorOrg: efficios.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3d14583a-d022-47b6-f410-08de4b9ce781
X-MS-Exchange-CrossTenant-AuthSource: YQBPR0101MB9184.CANPRD01.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Jan 2026 14:24:00.6050
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4f278736-4ab6-415c-957e-1f55336bd31e
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: yVPTbVUoWbCZFyaJ7rQA/I54iP5IWGCKhgqMIM+lRF5GjRd0BdYhltRuwshFUDXeuQZwaBVAdN6HukPieDdtKBRCaU7DTZ7TdHe+n0UgHbo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: YT6PR01MB11120

On 2025-12-29 20:31, Roman Gushchin wrote:
> Andrew Morton <akpm@linux-foundation.org> writes:
> 
> I ran this patchset through AI review and the output is below.
> I doubt all its findings are real, but some look real or at least
> deserve a bold comment in the code.

A few good points are raised by this review, I will
comment here first. Andrew, I will likely prepare an updated
patch in the coming days based on this feedback.

[...]

>> +int percpu_counter_tree_init_many(struct percpu_counter_tree *counters, struct percpu_counter_tree_level_item *items,
>> +				  unsigned int nr_counters, unsigned int batch_size, gfp_t gfp_flags)
>> +{
>> +	void __percpu *level0, *level0_iter;
>> +	size_t counter_size, items_size = 0;
>   > +	void *items_iter;
>> +	unsigned int i;
>> +	int ret;
>> +
>> +	counter_size = ALIGN(sizeof(*counters), __alignof__(*counters));
>> +	level0 = __alloc_percpu_gfp(nr_counters * counter_size,
>> +				    __alignof__(*counters), gfp_flags);
> 
> Does `counter_size` allocate `sizeof(struct percpu_counter_tree)` per CPU?

That's indeed wrong.

> The `level0` pointer is `unsigned int __percpu *`, suggesting only 4 bytes are
> needed per CPU. Allocating the full struct size seems to result in significant
> per-CPU memory overhead (e.g. ~64 bytes instead of 4).

This should be sizeof(unsigned int) indeed.

[...]

>> +
>> +static inline struct percpu_counter_tree_level_item *get_rss_stat_items(struct mm_struct *mm)
>> +{
>> +	unsigned long ptr = (unsigned long)mm;
>> +
>> +	ptr += offsetof(struct mm_struct, flexible_array);
>> +	/* Skip cpu_bitmap */
>> +	ptr += cpumask_size();
>> +	/* Skip mm_cidmask */
>> +	ptr += mm_cid_size();
>> +	return (struct percpu_counter_tree_level_item *)ptr;
>> +}
> 
> The `struct percpu_counter_tree_level_item` is defined with
> `____cacheline_aligned_in_smp`. `cpumask_size()` and `mm_cid_size()` return
> sizes aligned to `sizeof(unsigned long)`, which is typically 8 bytes on 64-bit
> architectures.
> 
> Does this manual placement guarantee the cacheline alignment required by
> `____cacheline_aligned_in_smp`? If `ptr` is not 64-byte aligned, could this
> lead to false sharing or other alignment-related issues that the attribute was
> intended to prevent?

Indeed it does not. We only have alignment on __alignof__(unsigned long)
for mm_struct flexible array content, and all the content happens to be
multiple of sizeof(unsigned long).

So in this case cacheline alignment is only done for the purpose of not
having false-sharing across items, so if the base is not aligned on
cacheline size it could cause false sharing of the first/last
items wrt surrounding fields.

But before we go through the trouble of bumping the alignment
requirements, we should really ask ourselves whether having
cacheline alignment of the hierarchical tree items (beyond level 0)
actually matters. Answering this will depend on testing on real world
workloads.

With the current hierarchical implementation, having the tree items
cacheline aligned leads to significant memory use per-mm. For instance,
for a 4096 CPUs system, we need 585 items:

- With items cache line alignment: 37 kB per mm
- With 64-bit alignment: 4.6 kB per mm
- With 32-bit alignment: 2.3 kB per mm
- With packed single byte items: 585 bytes per mm

The tradeoff here is increased false sharing when incrementing the tree
items above level0 when propagating a carry.

In my userspace prototype, I've implemented a custom tree items
allocator on top of a strided allocator which allows having the space
saving gains of the packed single byte items without introducing
false-sharing. It shares contiguous tree items memory across tree
instances, which are all accessed from the same topology location.
So there is a way to have both compactness and speed, but it comes
at the cost of adding extra memory allocator complexity.

I wonder if we should first have the tree items counter size and
alignment configurable so people can try out the various configurations
behavior on real life workloads, and then we can make a design choice
based on metrics ?

> 
>> +
>>   /*
>>    * per-process(per-mm_struct) statistics.
>>    */
>>   static inline unsigned long get_mm_counter(struct mm_struct *mm, int member)
>>   {
>> -	return percpu_counter_read_positive(&mm->rss_stat[member]);
>> +	return percpu_counter_tree_approximate_sum_positive(&mm->rss_stat[member]);
>>   }
> 
> `percpu_counter_tree_approximate_sum_positive` returns an `int`. The previous
> implementation used `percpu_counter_read_positive`, which returns `s64`.
> 
> On large memory systems (like the one mentioned in the commit message with >6TB
> capacity), is it possible for an RSS counter to exceed 2^31 pages (8TB)? If so,
> will this 32-bit `int` return type cause the counter to overflow or wrap unexpectedly?

The previous percpu counter implementation used 32-bit per-cpu counters.
This motivated my choice to go for 32-bit integers. But given the way
the counters were periodically "drained" into a global long counter,
those did not have to reach large values.

The hierarchical counters are different, and we can indeed reach large
values on any of the CPUs.

So if we keep an iteration on all per-cpu counters (level 0) as mean of
aggregating the precise sum, I'd recommend using "long" rather than
"int" for per-cpu counter type with the hierarchical counters.

However, I also have an implementation in my userspace prototypes
which uses per-cpu single-byte per-cpu counters. This is sufficient
to track the batch size and carry from level 0. However, we need to
change how the precise sum is done, and iterate on all the intermediate
levels items to perform the precise sum. This also introduce the
scenario where a precise sum is calculated concurrently with a carry
propagation, in which case an ongoing carry propagation could be
"missed" by the precise sum aggregation. This can be done by using
RCU and diverting updaters to a global counter while a precise sum
is performed. But this comes at the cost of added complexity.

So overall, I'm tempted to use "long" type for per-cpu level 0 counters
in terms of memory use vs code complexity tradeoff.

> 
>>   
>>   static inline unsigned long get_mm_counter_sum(struct mm_struct *mm, int member)
>>   {
>> -	return percpu_counter_sum_positive(&mm->rss_stat[member]);
>> +	return percpu_counter_tree_precise_sum_positive(&mm->rss_stat[member]);
>>   }
>>   
>>   void mm_trace_rss_stat(struct mm_struct *mm, int member);
>>   
>>   static inline void add_mm_counter(struct mm_struct *mm, int member, long value)
>>   {
>> -	percpu_counter_add(&mm->rss_stat[member], value);
>> +	percpu_counter_tree_add(&mm->rss_stat[member], value);
>>   
>>   	mm_trace_rss_stat(mm, member);
>>   }
> 
> `add_mm_counter` takes a `long value`, but `percpu_counter_tree_add` takes an
> `int inc`.
> 
> Is it possible for `value` to exceed the range of an `int` (e.g., during large
> batch updates), leading to truncation of the increment?

If we go for "long" counter type rather than "int", then it makes sense
to change the increment to "long" as well.

> 
> [ ... ]
> 
>> diff --git a/include/trace/events/kmem.h b/include/trace/events/kmem.h
>> index 7f93e754da5c..91c81c44f884 100644
>> --- a/include/trace/events/kmem.h
>> +++ b/include/trace/events/kmem.h
>> @@ -442,7 +442,7 @@ TRACE_EVENT(rss_stat,
>>   		__entry->mm_id = mm_ptr_to_hash(mm);
>>   		__entry->curr = !!(current->mm == mm);
>>   		__entry->member = member;
>> -		__entry->size = (percpu_counter_sum_positive(&mm->rss_stat[member])
>> +		__entry->size = (percpu_counter_tree_approximate_sum_positive(&mm->rss_stat[member])
>>   							    << PAGE_SHIFT);
>>   	),
> 
> `percpu_counter_tree_approximate_sum_positive` returns an `int`. When shifted
> by `PAGE_SHIFT` (typically 12), the result is calculated as a 32-bit integer
> before being assigned to `__entry->size` (which is a `long`).
> 
> If the counter value exceeds 2^20 (1 million pages, approx 4GB), will this
> shift operation cause an integer overflow, resulting in incorrect trace output?

I plan to use "long" rather than "int" type to make this a non-issue.

> 
> # Commit b886461533a8 ("mm: implement precise OOM killer task selection")
> commit b886461533a8bdfe37a9f4b62e606da7c31d886b
> Author: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
> 
> mm: implement precise OOM killer task selection
> 
> This patch implements a 2-pass OOM killer task selection algorithm using per-CPU tree counters. The first pass uses an approximate badness score, and the second pass calculates a precise score only for tasks within the accuracy range of the current best candidate.
> 
> Link: https://lkml.kernel.org/r/20251224174638.650551-4-mathieu.desnoyers@efficios.com
> 
>> diff --git a/include/linux/mm.h b/include/linux/mm.h
>> index e2fe66aed267..8d9e3239d2cc 100644
>> --- a/include/linux/mm.h
>> +++ b/include/linux/mm.h
> [ ... ]
>>   static inline unsigned long get_mm_counter(struct mm_struct *mm, int member)
>>   {
>> -	return percpu_counter_tree_approximate_sum_positive(&mm->rss_stat[member]);
>> +	return __get_mm_counter(mm, member, true, NULL, NULL);
>>   }
>>   
>> +
>>   static inline unsigned long get_mm_counter_sum(struct mm_struct *mm, int member)
>>   {
>> -	return percpu_counter_tree_precise_sum_positive(&mm->rss_stat[member]);
>> +	return get_mm_counter(mm, member);
>>   }
> 
> It looks like get_mm_counter_sum() was previously providing a precise sum
> using percpu_counter_tree_precise_sum_positive(), but now it aliases to
> get_mm_counter() which uses the approximate calculation.
> 
> This function is used by task_mem() and task_statm() in fs/proc/task_mmu.c.
> Does this change imply that /proc/<pid>/status and /proc/<pid>/statm values
> (like VmRSS) are now approximate? If so, is this intended for all users of
> these interfaces?

Good point. I think we want this instead:

	return __get_mm_counter(mm, member, false, NULL, NULL);

Which calls __get_mm_counter() with "approximate=false".

> 
> [ ... ]
>> diff --git a/mm/oom_kill.c b/mm/oom_kill.c
>> index 94066316e3ec..14421e29a7da 100644
>> --- a/mm/oom_kill.c
>> +++ b/mm/oom_kill.c
> [ ... ]
>> @@ -339,9 +353,28 @@ static int oom_evaluate_task(struct task_struct *task, void *arg)
>>   		goto select;
>>   	}
>>   
>> -	points = oom_badness(task, oc->totalpages);
>> -	if (points == LONG_MIN || points < oc->chosen_points)
>> -		goto next;
>> +	points = oom_badness(task, oc->totalpages, true, &accuracy_under, &accuracy_over);
>> +	if (oc->approximate) {
>> +		if (points == LONG_MIN || points < oc->chosen_points)
>> +			goto next;
>> +	} else {
>> +		/*
>> +		 * Eliminate processes which are below the chosen
>> +		 * points accuracy range with an approximation.
>> +		 */
>> +		if (points == LONG_MIN || (long)(points + accuracy_over + oc->accuracy_under - oc->chosen_points) < 0)
>> +			goto next;
> 
> The check here seems to use accuracy_over for the current task's points and
> oc->accuracy_under for the chosen task's points.
> 
> If I understand the bounds correctly from percpu_counter_tree.h:
> (precise - under) <= approx <= (precise + over)

The above is really expressing a range:

approx is is within this range: [ (precise - under) , (precise + over) ]


> So: precise <= approx + under

So precise is within this range: [ (approx - over) , (approx + under) ]

> 
> To skip safely, we want to ensure the maximum possible precise value of the
> current task is less than the minimum possible precise value of the chosen
> task.

Yes.

> 
> current_max_precise = points + accuracy_under

Yes

> chosen_min_precise = oc->chosen_points - oc->chosen_accuracy_over

Yes

> 
> It looks like struct oom_control does not have an accuracy_over field,
> and this check uses oc->accuracy_under instead. Without tracking the
> "over" error for the chosen task, can we safely calculate its minimum
> precise score?

Fair point. What I missed there is that we need to use the opposite
limit (over vs under) when going from approx to precise.

> 
> Also, assuming we had the correct values, shouldn't the check be:
> (points + accuracy_under) < (oc->chosen_points - oc->accuracy_over)
> 
> The current logic appears to compare:
> (points + accuracy_over) < (oc->chosen_points - oc->accuracy_under)
> 
> Which checks if (current_min_precise < chosen_max_precise), effectively
> skipping any task that *might* be worse, rather than only tasks that
> *must* be worse. Does this risk skipping valid candidates that have overlapping
> error ranges with the chosen task?

I think the way I express my ranges (under/over) of approx in
terms of precise rather than precise in terms of approx is
confusing.

I'll try expressing "accuracy_over" and "accuracy_under" as
the range of "precise" in terms of "approx" rather than the
opposite. This should make the calculation easier to follow.

Thanks,

Mathieu


-- 
Mathieu Desnoyers
EfficiOS Inc.
https://www.efficios.com
