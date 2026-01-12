Received: from YT6PR01CU002.outbound.protection.outlook.com (mail-canadacentralazon11022108.outbound.protection.outlook.com [40.107.193.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6625A32D0D4
	for <mm-commits@vger.kernel.org>; Mon, 12 Jan 2026 20:04:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.193.108
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768248288; cv=fail; b=mJHGe2u4YCIdZMO8GX0/lrPqtZNuobxTL0UeB79wZBjZWfT7F2JA/CrtTrwrXGvfkHvEnqMefPnMxdodwTwiW2ZQozkdflRdjmB8nPq1S+eaoYO3eLECGRjZv42IjqKvRLfhiXWZWOlsubK6s/2IyUJvCTz7McTxDxI7oC3+4qc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768248288; c=relaxed/simple;
	bh=wYUNOKWWTdk2d8hVcCXORdefoULS+XLmVyj9RZmN6Ik=;
	h=Message-ID:Date:Subject:To:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=u4TWgn0p9oKbMjkQkWxN3WYV4Ojd4d9pooFLGIZ8OlXNyA1lBvtNLF7Ctki8W5sQ9JpJHCKQF7X66iy9FZ5KShA/sTYlkom1Bkt9vYtFaj/8X+wdbyAuF7Vy8yqZ49lz7LtG0uxRdxW+MKjw45mHWsEiV1wkwzJ4AFxDTxKHdQU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=efficios.com; spf=pass smtp.mailfrom=efficios.com; dkim=pass (2048-bit key) header.d=efficios.com header.i=@efficios.com header.b=qSV2ZZkh; arc=fail smtp.client-ip=40.107.193.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=efficios.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=efficios.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=efficios.com header.i=@efficios.com header.b="qSV2ZZkh"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=UAM13cVj9+B349gNCRzM+rp/jYlQgFzWbnz1COXssviJbofgQsJ/F2QRzy2EDq+z7YTNRJ8t5GsLwk6udgzNUo1GYUtLngz8xzqF/EmWcQbD9XnqvWzoL7pkFwyLq5GLVPld8Lrp2LQ5g9/Mze0XF7gN/ez50NuJxBWJd/9MBFANaBDI5ejJ9TTEyP0rr8Faf9X4WY8hu2/sc3+1ZiBd7Gp0zks1aRa8kIqOweZclwiRNngSvMXX3m8fv4xgxZe4Hj8pkE8DoyZYOVyUvjBESjQ70b+HN1AmQp0dRhO7JIO2K3pTS5cxmnZI6lLl684gCFL4t5xJBiR2+vCXmfupmw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gj09jZKxaBvZ6+Q597llNmpeWYzTDsUK2dihXT+3VYI=;
 b=PHvysGTR+1l5fXTrdOnohr2UyNqehLnmcZs7OElAi5ChTasyfkzd/FXYn7GxG88lM29fTSe9HBbl3QgeQEskpFKc1ynVDVHIav8leRTSr0tF4FK4CjnY7VcWpN1ApsbdsDx/XbsbdaalxX/Vsr2WnaFzOfebux1Gvq4R0VqPiXr2neXEGD2InKZToiYFtn8z7a8AZnDFhkNMV0zkYgdFfJFdmTF3NKw1oQCSflXKCS2jKkTtrx6j4/OzU+SmPb5VVGWfrM3+cPa55LemjR/RHXco7GwqP2zdERX4OUG3MXy+2US7LCZwY0RfT71JIoVsfv9oZaBvBphUXkd6Kr+Qvg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=efficios.com; dmarc=pass action=none header.from=efficios.com;
 dkim=pass header.d=efficios.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=efficios.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gj09jZKxaBvZ6+Q597llNmpeWYzTDsUK2dihXT+3VYI=;
 b=qSV2ZZkhBK5eG0peC64gcqp89ZJ5t1FoBGxCw9q/ZLswBHjMlB5xDjQUYopuqqTBbi2B61ULKTT73+SeZhPE6FNx/BfLCoRvyMou2NbzUx9MyCFsleTv04y54wECFih/wBksAqsW0CE7N2r142sGXdAfXwnjAyFOB1XvGE/yDY94Q6xX2++20MYI21luSKi+7jPbQ/P0sxBYwJC3x1PWFnXBqrHjHf/W4uvzmFry34NEGml1jvAFzVQoB4VPN61A7AZAE8LrZilFkgBONgol6X6fecAQzzVmEqo+M/LLlfh7fPpGh+zMbmmdI1qb1DTem0MEUjA3xeNduSsBSx0XXQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=efficios.com;
Received: from YT2PR01MB9175.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:b01:be::5)
 by YT3PR01MB5410.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:b01:60::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9499.7; Mon, 12 Jan
 2026 20:04:39 +0000
Received: from YT2PR01MB9175.CANPRD01.PROD.OUTLOOK.COM
 ([fe80::6004:a862:d45d:90c1]) by YT2PR01MB9175.CANPRD01.PROD.OUTLOOK.COM
 ([fe80::6004:a862:d45d:90c1%5]) with mapi id 15.20.9499.005; Mon, 12 Jan 2026
 20:04:39 +0000
Message-ID: <1584c24e-2d13-469e-9048-c5eab6bef9ba@efficios.com>
Date: Mon, 12 Jan 2026 15:04:37 -0500
User-Agent: Mozilla Thunderbird
Subject: Re: [to-be-updated] tsacct-skip-all-kernel-threads.patch removed from
 -mm tree
To: Andrew Morton <akpm@linux-foundation.org>, mm-commits@vger.kernel.org,
 yuzhao@google.com, willy@infradead.org, viro@zeniv.linux.org.uk,
 vbabka@suse.cz, tj@kernel.org, tglx@linutronix.de,
 sweettea-kernel@dorminy.me, surenb@google.com, sj@kernel.org,
 shakeel.butt@linux.dev, rppt@kernel.org, rostedt@goodmis.org,
 roman.gushchin@linux.dev, rientjes@google.com, richard.weiyang@gmail.com,
 paulmck@kernel.org, mjguzik@gmail.com, mhocko@suse.com, mhiramat@kernel.org,
 lorenzo.stoakes@oracle.com, liumartin@google.com, linmiaohe@huawei.com,
 liam.howlett@oracle.com, hannes@cmpxchg.org, dennis@kernel.org,
 david@redhat.com, cl@linux.com, christian.koenig@amd.com,
 broonie@kernel.org, brauner@kernel.org, baolin.wang@linux.alibaba.com,
 aboorvad@linux.ibm.com
References: <20260112195532.54FA8C116D0@smtp.kernel.org>
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Content-Language: en-US
In-Reply-To: <20260112195532.54FA8C116D0@smtp.kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: YT4PR01CA0076.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:ff::20) To YT2PR01MB9175.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:be::5)
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: YT2PR01MB9175:EE_|YT3PR01MB5410:EE_
X-MS-Office365-Filtering-Correlation-Id: 089f3ed9-8ade-4b1e-3584-08de5215d169
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|7416014|376014|366016|921020;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?b1Y1Q1NBUUR2YWJzOU9FUnFtbXh0ZUxiUUFFSTNjMTFOckJpYk9CYTVCY3NB?=
 =?utf-8?B?bFNEdXoxOFRyT1ZYUWNZZVFoai90KzlUQ0YwTVdaSDdhK2lJOWxBeXlSNmph?=
 =?utf-8?B?cTJZaVFiaTZIK0lKOGJyWGZzd09FWWpiMWFSY016Z1Frc3NaRy9qc1Fkendo?=
 =?utf-8?B?b2lRVkJya2M4RERhMG5wdkMvejZGa3dEWWJ2aDZzM0hPaG45M0JxVWpJS3R0?=
 =?utf-8?B?MldGS1EwUHhwaUFTdGVHSnpxRXVwUGpHa0Nud0plaTkyMHgyM3U2TjAza3Qv?=
 =?utf-8?B?SmVQUVp6T1lwVlIrRGpWNG1PMUxWYjBNQkNNQVJKNHptSnhxM015bEdvOGRM?=
 =?utf-8?B?WTlwNFh2NXRlVDlaQUNITkxDN3NIRUt0YTdjWUlqUGxkV0YzYkxUSlRTR1VN?=
 =?utf-8?B?eHYyU25MQmFwUXcwTngzUkZuajZ2cjFkWTdTaS9DeEh3Q2tqbzdIZHdobTVa?=
 =?utf-8?B?MGdpem1HcDVvbjNQNEFxamR0UytHanhiakM1MC9XNFZUZWJkVG1xOTVibERw?=
 =?utf-8?B?Z1ZsR3JNSHRHRXViQU5GQm9SekgyWGFDazF3Sks5dFN3SDhSbXFKWUlSREw0?=
 =?utf-8?B?eTNyK2FaaHR6UWVaNFVleWczZTdRMGxFa245WThLb1M3SVd1d0ZsSENrOWl6?=
 =?utf-8?B?R2paWDhGZWt4K2VDclNpb3l0N0N2SU1ZV0krN2djeG5rTWlCWTVpNEJLQUVr?=
 =?utf-8?B?MzkzRVdRS09VZmY1UTVkUWFBdkJIVGp1K2U5c2hKNWVKM2JXdzZENS9yZ21z?=
 =?utf-8?B?d0lnbURHK2xMWElFdWJ1L3d3cjVIL1kxTXZqdFR6eVBmanB2U0U2VGVZcjYr?=
 =?utf-8?B?ZHpNOXM1ZnVUbk5DNXVaWGVTdEsvSlpjaTRGbDNka1ZmMHpMc1cxU2hiUE9T?=
 =?utf-8?B?bkdxVEcvb21BcmppSXhCRk13cE0yMGk2K01WVERINkEwL2NURDVpOXFKWDcw?=
 =?utf-8?B?YjVTUFMyZm9MeThXTUc5TWdKdkJiRFR6YkVKeVVnTHVvTUtyK2xNNlVuR1pX?=
 =?utf-8?B?cTF4WWMwM2NrZ1hUMC82MzljUzhSVG95WTBnT3VaU1dsQXdQdHJudGx4SG4z?=
 =?utf-8?B?Y3dNcmtqTEVtR1FpdzF6VXhBc1FoOXRTVU1DeUpla0lFR0UyeEpJUWdyVVMv?=
 =?utf-8?B?MXUzNTVNVG9ZRVdJTS90WjRZTENyUC9FY1ZlQjNQWWp3WUhmRmIyME52RmZB?=
 =?utf-8?B?bjQ3OGdIWno1Y21kMmxjWkIvaDAzdnNaR2U2cW5qdnVtZDdxdmMyZnFHSmFV?=
 =?utf-8?B?MThrRFdLMUpndCtmbTVrSmxEakpicnllbkNtTGZ0d2tsL3lYb08xcUZaTGNP?=
 =?utf-8?B?TTN1MDVVSmo3Wi9uUkdVQWxKNVR2QzF5S010VVhTTmw3ejBZYmQ5YlFwaGR2?=
 =?utf-8?B?R0hoZ3B5NnR6a1pIcUgxY2J6KytvZ0xIQmtSUTBiZzhXVXNLUTVaUkNNZzYz?=
 =?utf-8?B?ajhzbFlIMTk5TWlrb1JaM0VJMHBzQ0t2cUxCa1ZnYUxoT1M4NDZVTWFKWFh6?=
 =?utf-8?B?OHQ5akNLN1NqYlF4SHdYVmovVWhRZm1mSVgvUmFBZnhySFlCMFhDQTZFNitu?=
 =?utf-8?B?ZFgwRDQyL1ZJZGU2YXNtRkhTT20zdVBKeXBzanBEY013eGRJQ0Z1a1ZwYm1G?=
 =?utf-8?B?Z0tBRXpRZ0dQT0pMQ05Gckg3WjhnWk1QbmVLaUg5U3A0RGhZcnZvcExHMUt0?=
 =?utf-8?B?UXlIUC8zZjdIQmxBMjBEKy9MWGRUZEF6d3YrN1B4ZXZjaVNMd3AvVVVrMTVm?=
 =?utf-8?B?NTZnaGR4SDljdXkyWk96bTluamU4SzNFaEpsaHZoUFc2NTFPUnRXK2FlYVZR?=
 =?utf-8?B?ZHVvaFNqYVlrU1VLTVZUZWlZdGlUc3ljaGt4T0RuQ2lqK2VudlhKVy9tSTFx?=
 =?utf-8?B?VDc5OGJKWGtjamtKOFIxdUZGZ2s1NVdhb3lGNzNXbFA1N2N1b0NpSG1NQmhT?=
 =?utf-8?Q?wKsfe41OWS0=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:YT2PR01MB9175.CANPRD01.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(366016)(921020);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?MnVwQzFTdTVZYUZTcmZ4WGFHa052amkrSlAycW44UGxzYjgxd2MzdVc3djFX?=
 =?utf-8?B?TXQvR1pqQkM5TDlVTmpwblh1b3BHdEtKN0phQkh0OVpNM3JiS1JsVTFrQmtI?=
 =?utf-8?B?alZXdlZ2OXhXbWRIQktkeENqeU1FTk1sQnVMZVkwNVBOSk43QWxCYXZnUHlt?=
 =?utf-8?B?VVA2Mm1pdnRjTkxvc0hNMVNEU1NSMyt4RnR0b2dpRUY1N2h0VnZPNHc0ZTBX?=
 =?utf-8?B?QmdnQTE0aklKSUF6TzVuUnh1akhFTERHUVBTSElsb3hMbGFmYjJhbEg0NDhq?=
 =?utf-8?B?NVB6ZDQ2RzNCVitsRkpzL3hadCtUK2dHMGlSRVg1aHlYWUEwMXQyaFBnc1Zl?=
 =?utf-8?B?Q1pXbTQ2M2syZHZXd2dIY1RNaTZUYzFDTE03cTNHNGxsWnJOUXdlcjRvVU5p?=
 =?utf-8?B?ZVNBTEd4dE0zMGdvZkJYU2lOUUQxRVBrOW53K1RrVXpFemsxYTFFaHN5eldh?=
 =?utf-8?B?RHBCSE1RcHZDNU9EMnVBaVJFOGpYQWFVNHVFMmplRm1IVUVmcU5PeG5qSXFq?=
 =?utf-8?B?a0RNNHpPNzJDMGNmTnVWOS9pUzhqK0hLaUN3cWFHZTBqSlBVWVl6c202dmhw?=
 =?utf-8?B?aW1abkd0Ky9xYlZsYmp5VlJ5RFNCVE5hbnZGYklUd0Zuc1Z5b1V3NzRvaDg1?=
 =?utf-8?B?T01HejFackQ1Z2Fqdyt5RWxUUTQ5UnFRWmVLeisxcGdFNUY1L1pSTkwyZG00?=
 =?utf-8?B?WExsTzBVeFhLU3h4RFArZk1tSCs4SlNTTDJKNlJtM3A3N1FwcnpiVW5SNk84?=
 =?utf-8?B?RHM3SEx5YlRTeXFucDA1QlRLNzc4bFlyZElUR1VxSDlReEhhQzFIMnAzLzVl?=
 =?utf-8?B?dExURERrSzRvWGRZVHp2SGxucXhzNVhPSWpKa2hVSVNFZXNaTWVEVXNLZ09y?=
 =?utf-8?B?VUZkQXp2UXcrSmo0YmgwZko5S0I2bk0yZlA1ZWxKaFM3WE9pdHoweGxOdWlG?=
 =?utf-8?B?MGh6UU5JVGhwVGZWZEpYY2U4VE1leml0MURhOVdHcjZpTEcrMFpLYm9NdjU0?=
 =?utf-8?B?M21sZjgra0I2SEZNT2F0Y1B2Z2N5UXlRWnpzcy9rK2dGRWx1UjJjWmNGRWFX?=
 =?utf-8?B?L3ppZ3FRdDRzRW1aL1g3ek84ZEwrNHdDSDVQVjRDRW5XK0UyT2Nabk8rNGZW?=
 =?utf-8?B?QUlSRlYvSHk3dkE5b2R6TmRtbEVXSE1vbURpdld3ZDcwWXJnRG5qOVFHbFZR?=
 =?utf-8?B?N2szMUJGZ1hJS05vV0dQRXA5K0pZNERoQTB2Q25HRFVHM2htRWRkUlpPbXZC?=
 =?utf-8?B?NStBckNRMkRmNkdNS0hoNnp6aDJUVFpvMElaU1R2Yjl6WjJtS2RjT0NSU011?=
 =?utf-8?B?SlhIL2RoN2d0OWk5dGMyVThBNUVCM1MxaTl0Ri9QMy8wdldGK3hkMUFsQlA3?=
 =?utf-8?B?emlJTlk1S21OUjJQbmluSmltbXNERzJRNlZOUFBMY1JmWjlIajdKSzVGMGUw?=
 =?utf-8?B?MEJ4RW9PYzRzdThhMXJvc3lwY29OY2N0NGJBNEk1bWhlaU5uVjZsNG9VNGsr?=
 =?utf-8?B?cXI1bWs0dFZXYlp0K2FFZHVKMHR6UlJFUTB3emo4NjhITG5UVlpFWXR2a3VG?=
 =?utf-8?B?TkJTUS9KVHY0VjdQcE9ROUZBOWZMQWE1dUxRbHdYWGFHM3B6aTR3ZTd6SnNC?=
 =?utf-8?B?cDJrSmgrYVA4RG16QlhvMm5sbVJ3Y05kQzRCWU9CSE1VeGp4dlBQNVJHaGxx?=
 =?utf-8?B?V0ZKdDYxZW1IUkRSenZ5LzJOS3cwRERNZkowYmhvQUlXbG5SemFody96K2ls?=
 =?utf-8?B?SGJwcnRkdVArM1VVWGZwb1VmZGNWM2FNSW1WL253RjVJRnFUdjhJZ2hXSkM5?=
 =?utf-8?B?ZVJGZ3ZrQ1N1R0RaVnJ1Yk4wQmVhZGpucGk1dHJ5MVJzaEwwdHlnMEQ1RmFF?=
 =?utf-8?B?YllWendtdlI1by9DalZqRm8vZkMvaS9GcjA3WUJ3QXBKOTNOWnRjTWsvc0Rn?=
 =?utf-8?B?OWoySkJ1dU04U3llKzc1d1V3NDVUamZrQ0pUdlJFVkRiSndJdXhKakpnR2N6?=
 =?utf-8?B?dkI2bCtDdU16UjlZR3EwQWgxckw1bXdNRktTQU0yd0oyTlg1SkUxVzBmTTZU?=
 =?utf-8?B?eWlKOGdoSHQrTHozUnd3R0lxTHV4cWVBbkcrSGxmNFFabzNDT1ZSdThqcmJi?=
 =?utf-8?B?Y2NSZGtuamh0MnhhaDFoU2IzdUsvZHVvQmVsZ0lITG5OMjB0VnRSYUdZZ0x4?=
 =?utf-8?B?eDBYZUFnOS9yaHBLanJPbWdpM1g0aEQvNU5NSzRHTXBoNzFvR3BCemJ6SHhw?=
 =?utf-8?B?dERmR0JoSDlpdHRyTVR2N3gwYVJON3VBV2ZDbSsyd2sxWmkwaWZkZS9sMmhC?=
 =?utf-8?B?dE1VRmhWZlhlaitMS3NvY1FsN3ZNc3M2d0VGcXpwSGlTSWVOb1VCQ3h0TWl2?=
 =?utf-8?Q?/JwW4xZjPm4zH1p4=3D?=
X-OriginatorOrg: efficios.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 089f3ed9-8ade-4b1e-3584-08de5215d169
X-MS-Exchange-CrossTenant-AuthSource: YT2PR01MB9175.CANPRD01.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Jan 2026 20:04:39.6062
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4f278736-4ab6-415c-957e-1f55336bd31e
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: OOSf7pPLl+hUwlNVyEmOXxxWkMwFBerVXMZKADc7XJeWRzSt5my5U8IPxKa3TrwUrJZ8/5QUyp4dLeKHE4J9Xnjw9fX9A4fsT4gsgPYPEnc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: YT3PR01MB5410

On 2026-01-12 14:55, Andrew Morton wrote:
> 
> The quilt patch titled
>       Subject: tsacct: skip all kernel threads
> has been removed from the -mm tree.  Its filename was
>       tsacct-skip-all-kernel-threads.patch
> 
> This patch was dropped because an updated version will be issued
> 
Hi Andrew,

FYI I did not send any updated version of this specific patch.

Thanks,

Mathieu


-- 
Mathieu Desnoyers
EfficiOS Inc.
https://www.efficios.com
