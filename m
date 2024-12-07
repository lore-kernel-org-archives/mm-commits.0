Received: from YQZPR01CU011.outbound.protection.outlook.com (mail-canadaeastazon11020073.outbound.protection.outlook.com [52.101.191.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95ADF22C6C5
	for <mm-commits@vger.kernel.org>; Sat,  7 Dec 2024 15:34:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.191.73
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733585698; cv=fail; b=ok6D+cU3K2vpWJt+d0U7uERF7E2wRsJbha33tLm+PL9/YD+cmzSB2CWiKCaBGC5XZYBSq0P2hUkDD9gXT58Am8Yk8CLFElWia/Vj0crcBPGGDPftqyc10lSmqQgfll8lbjZ+Ti5HRlD2RHyKFUr8ppDmuWmuqrHMPZ0FhDO8nCY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733585698; c=relaxed/simple;
	bh=AzrsC015Ni1M0zKApynX9TCU132TBUFDiyT3kTnAnTE=;
	h=Message-ID:Date:Subject:To:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=TSYZq82XpdramSlQNNAc5EwNRrlXXhZ3rC0B0DueI1w607cOddaQEdC3jMKI9G7/UMk14llzvmDC2ue2dYGdzl087WbdAZ9vKJKgV/9tVUSUcf3YCsBouj0i53uXNHBrpI5HgFHdPz6LfCliQGmBrNmOjbn7n548sT18tojH0Vg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=efficios.com; spf=pass smtp.mailfrom=efficios.com; dkim=pass (2048-bit key) header.d=efficios.com header.i=@efficios.com header.b=kKvIGCuh; arc=fail smtp.client-ip=52.101.191.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=efficios.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=efficios.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=efficios.com header.i=@efficios.com header.b="kKvIGCuh"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=IhauifbLVcmrfCVGBz9X49baTKCcKGLfJ9S8AtERyMpV1YFbQwNiOAKP1FJWopzvYIDXd+by1YDnYzUu3129jEz7uDgQPjnZzOWFC5+Zeqkteh0yfiyojkqH4WGfurUb6D1jP9Yq7RGonbo0qupq+Pc/vEGMgzwgBpRU/r6SVONNGbJ1YgIaZaLmb5aaDM3qRCxFK9RR9alsdGJMm8IBJKLBErKg264MSPGCs0x55neVNQ/gggkYvDT8YRzCouoqKQIEuKZkmxnJ/38lQkVpvuXIjIs/KP9S78K3jiaIeE4hXlpduFAlHRpQ2PE2WKsdOggRhMTqnoHlNO8gh8XF9w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=X8MGhS3GiR+ngwjXtO0mCjocPOXon0rx6LEqO0V6fdg=;
 b=hYeSzEXE7t065AWeUo5N8b7K88h8tIC6iWiawi3OxSJWF9Gm5BmzMnT9oOHsRRena1Te7UcZppRcqEQG+sI/olQELWNJfIJ5jmVHQiLdytFfmyCl5l6tX4BH6RBTbfFgE2RYEWVeIDEj3pdlgRd3cpZc3EYhzlP/dGYwagcj26VnX3et3MvPntXp+aYCvwZJrjYmAkBLGAteY4VolHyu7AniZHR/GFUelUWLbGiIeRsFlE7VfzNzLMFjmjhApCNsZ/Kqo6ob8o6KB0Dl3mBHHRd4n/Umgk1WvU2GKIy7fiH8WMJMNYGzRGohtcVlY19MA/7VJzv1ZiemX4qqSZEGMQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=efficios.com; dmarc=pass action=none header.from=efficios.com;
 dkim=pass header.d=efficios.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=efficios.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=X8MGhS3GiR+ngwjXtO0mCjocPOXon0rx6LEqO0V6fdg=;
 b=kKvIGCuh/R/jSTJnxQJegrDK5/gX4tdeyNxbsTo/juY5BO+9zHnzIfT4I/jB3Nl5ltP7JzNQCPfw+lz/2ZXcNCKac80oU5no6TfogU5Yhn5671MtgjRYPHQd0mcpGHinrdT1uEWHiBxL6RUposmOCZOrPExVOlInVX1UD6dRmiXg5OUAOcaXjd8AwSPUQri3PD2Sj3F2StyaTeqcxQhax8y77asA9QTKrA8AZDwfc4hlHBU62PLnmdelIqncUtphvWIL5VDqmWymvOK+oMRo2IO1O2v4YqQ2m7jPJc/EoGNkqWOmPw5NDnH5DI0inHsSNOYtAnQ+zoqrpgcSQmKQUw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=efficios.com;
Received: from YT2PR01MB9175.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:b01:be::5)
 by YT3PR01MB10816.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:b01:fb::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8207.20; Sat, 7 Dec
 2024 15:34:51 +0000
Received: from YT2PR01MB9175.CANPRD01.PROD.OUTLOOK.COM
 ([fe80::50f1:2e3f:a5dd:5b4]) by YT2PR01MB9175.CANPRD01.PROD.OUTLOOK.COM
 ([fe80::50f1:2e3f:a5dd:5b4%5]) with mapi id 15.20.8230.010; Sat, 7 Dec 2024
 15:34:51 +0000
Message-ID: <a4878ce8-5c48-4c4d-963c-12697efba268@efficios.com>
Date: Sat, 7 Dec 2024 10:34:49 -0500
User-Agent: Mozilla Thunderbird
Subject: Re: +
 mm-use-clear_user_highpage-for-arch-with-special-user-folio-handling.patch
 added to mm-hotfixes-unstable branch
To: Andrew Morton <akpm@linux-foundation.org>, mm-commits@vger.kernel.org,
 willy@infradead.org, wangkefeng.wang@huawei.com, vgupta@kernel.org,
 vbabka@suse.cz, ryan.roberts@arm.com, linmiaohe@huawei.com,
 keescook@chromium.org, jhubbard@nvidia.com, glider@google.com,
 geert+renesas@glider.be, david@redhat.com, ziy@nvidia.com
References: <20241207055659.A4BD8C4CECD@smtp.kernel.org>
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Content-Language: en-US
In-Reply-To: <20241207055659.A4BD8C4CECD@smtp.kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: YQBPR0101CA0172.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:c01:f::15) To YT2PR01MB9175.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:be::5)
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: YT2PR01MB9175:EE_|YT3PR01MB10816:EE_
X-MS-Office365-Filtering-Correlation-Id: 31c28fda-7cff-417b-7c3d-08dd16d4b0a6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|10070799003|7416014|376014|1800799024|366016|921020;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?UzNNZDFKNzFJeWg1ZWt4Z0FiRWU3MTZQMW1SR3lwUHY4ZVROU3BNQXF4MDd3?=
 =?utf-8?B?b0NadTNERjlKREtNVUk5UlFNOWtoMnpCZTJMWjVTTDNZZ2hhazdudlp6M2lN?=
 =?utf-8?B?ZWcvT3NPU3JwUmJKKzdmT0RJQmdIZlh5bHZCRlBpZkw3clVid1Fkc21EMVNS?=
 =?utf-8?B?RUs2bUdKUytLRGxWeXd6Y1YvcmFRNzllNDd5Vjl4N292N2NsaVc3clFXbTV4?=
 =?utf-8?B?K0RWUXlRU0pXQ2kzYTIyekNwNm94V0xsZHUrQXJGMldKT1A0SDE4YVBIWEg3?=
 =?utf-8?B?TzhIZ21vRlIwUVg2WFFCdEFGTXBHYmZiZ1d6MGc1LzhyUVZSWllxSWIwNmhx?=
 =?utf-8?B?TzRCU2FHMkNjaGFxN1BFZ2dxR2lIdGo2eHozek1YVys3Y2pLZXN5cHNFTkhV?=
 =?utf-8?B?MThtMnVXM2pQR0x2S2RBNFJWTlhvckZXSDE0S0N6TmlReVFEUnE4c01MUDZZ?=
 =?utf-8?B?VWhkSW9TcU10aWJESXZkT0lNQzlLOFE4anRtcnFiOXNnczRnUDBMVXpZUGVW?=
 =?utf-8?B?UTJ0OUNZNFQ0QzdzbW9semtqbjFsMkVXL2o4RCsxcDViSThZN1RCclpFd2JV?=
 =?utf-8?B?b2tDR3oveVRwOEQ5bDBsZTZuS3A4aitRTVhNbnBLV1BGSEltRjhON3RZOVIx?=
 =?utf-8?B?VitKZjY0U1JPNWpUdFpucENXVHJqM3hjOVJvd1k3UElxM0JHNWF0T3pSeHV2?=
 =?utf-8?B?SUw0RmlWNHhoUmVRbkFyclQ0TVVvV2FXQVYycitXd1pMcllKbUVMeHBrdnM1?=
 =?utf-8?B?Mjg3UHBrRXlDQUNVRnBJejdJT0ZPeUFFTGtnYTlCZHl2ZXlDSjd3UkYxNHpG?=
 =?utf-8?B?N254ZUpCazBaZm96THJOS3ZwTG5EMjkyYjdCbDlsQVdvR2x4andkbEZPVC80?=
 =?utf-8?B?YlIyZk5UK0xMckVCQmJxNjBLbEEwWWdWQ3QrWkZYNm1OM2V2TUI5NTJCdWo1?=
 =?utf-8?B?dEtjK29rSzNPcjU5Z0FjT3lkMzlMcStrWmNxQzRMMnJLVzBRajRVdk1FbVZm?=
 =?utf-8?B?VFRNZm4wbVA5bFF0N25IbnkrdWgyS2JwaG8vdWVNQ1VNcUJYbHRqSzlLVnVY?=
 =?utf-8?B?MFV2SldYZ2dhdkNQU3lyQVVFbXQ0c0VmTHk2c1pMbW5VQk1tVFhuaW0xWUxY?=
 =?utf-8?B?d1FoNk9kaUt0L3dlb2RpcFNabW5SU21Xd1FXa2QyVGQzQWpucklteldrOXBP?=
 =?utf-8?B?eFArYkkxWkpCaDBoUHAvQUVReUNaU0I3YVFJQ2h1QzU0WVYwd3MycDZFY3B4?=
 =?utf-8?B?QmRmdVlmK3cyZmVzNVB1NGJvdUliUWQ0eVdqWWRnci9hK3VIcGZxRm5RRStW?=
 =?utf-8?B?N0poVlVvUEJWWTdkcFA5b2diaGt2cGMwQmhQdVhHeXFnbDR1RGlRT1JZRm1I?=
 =?utf-8?B?TnR6czhkMkNHbzhtL08wbDRicVF1OFAyampTR2pBSnNuNnpZdW92M29tNWJm?=
 =?utf-8?B?Z3BZZzRJSll6cWFuczFEczVBbVhIWWFpbjhNRXNCRXZTanFFOWdKODd1cGNU?=
 =?utf-8?B?YndRWGp4RUdlcVhPb2I0dGV3aFN1R3hjVFFwNXhaSFBhSlJGWFh1WG4rZjY5?=
 =?utf-8?B?NTdROEdZZmZYZmgyUzV2MlBYOWI4eVRad1NyZnVVcGkvVWtUMWhudHZud3FY?=
 =?utf-8?B?cXNraHgzZW9FK3Z1aStoa0t2bVZtczJ3M3BaMVA4Q3BlbFVGdUc3OVB0OVl4?=
 =?utf-8?B?VTNnZVY3NmZIK1VJWmF6aUxHMTlKZkdQVWJ5WStScUliVXRjdFY3TmJXaU12?=
 =?utf-8?B?K2srSEM2MWZtS3hDaStGM3N0MnlBQlJWcDYvaVAvaUVyWm1kNEp3R0swaDBV?=
 =?utf-8?B?TjVsNmxSWGNqdW1Ba09vZz09?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:YT2PR01MB9175.CANPRD01.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230040)(10070799003)(7416014)(376014)(1800799024)(366016)(921020);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?QWpjdU1FMkxZaVdVdzBqSWthOWRwNnV4MHduS3JWci9jUTM1WmE5WXZNNzJQ?=
 =?utf-8?B?TzY2OFFPNHZEa0orK0lqdERTUUJZMm9EQUhmb0hRbDhieDBVbjRyTFE4Q1Ra?=
 =?utf-8?B?Rzh3ZnFBV2tScmFvaVRSU2Jvb0xPeEhYWE1acXFKczdWdDl1WGduTEtVblZZ?=
 =?utf-8?B?eEUvNWxKbkdnZEJuUVdlaCsrUGs3alF6UkRvbllTTWhwaEJ4bU1xaWhDT0k4?=
 =?utf-8?B?VjNJQUYyZk5NaWdnOVY0YXdEdTUwejNrTk9MLzgzZGF2cmxuUGpUZ0JJSUIv?=
 =?utf-8?B?THo5cmRQTFpzN3NScUd2bmxqRTJKOUQvQ3B4LytrVGVVRnlWN05wQVo4dDFO?=
 =?utf-8?B?b3kyZEM3NmVkNEt0TzhlcFlNa2RLcnRhZjcrdGRpR0ozQThvdmVDSklteURV?=
 =?utf-8?B?RDVmMWhmVHRYWjBuK1hwT0J1M2dPYithYXhrMVJKdWN1R1VZcUVGTi9sN0lF?=
 =?utf-8?B?WUNWdnl3UktURkRTSnB6NDdrY0RJeDNDNysvTXB4WHEvdDcrZURlZXJXMnRU?=
 =?utf-8?B?M3B3OG8wNDhZUThrWkJrM1pObHZQaGJjbXVQNjNrajh2MlRLSjU4U2c3QXVF?=
 =?utf-8?B?NkNqdXBHNmxnUEZNMkVSQVBsTjN6TWZVRllya2dhbThpNDNiRTQvTmVOVzBW?=
 =?utf-8?B?WXZzUGI2ZWg2K0Z2MjlMWktVRHhPT1BtUVhVekw5Yjl2b3VFTlVmZVV4Wnhz?=
 =?utf-8?B?YVIwSlNnUFBNQ0RrNE9ESisxbUF5djBOV2JId3BvbXZMTG5BMms1N2hqUEQw?=
 =?utf-8?B?SjJTUzRkUDM0Zzk3Z0NNZjNYc041Z3FZU0xaV2NEbEZ1V09GTnlCS2pEYS96?=
 =?utf-8?B?UTh1UjQzV2NTNEpCdkRlbWZEeGhHM0ZRc3lSOTY5NlpGRGtjN29TYmJPbW1O?=
 =?utf-8?B?cW5mYmp3UWVsVTNseHdHcCtvQitEZlVZR1I2azJzRGF1TDI2ZEI0a1FReXhz?=
 =?utf-8?B?US9zdmN2VFJxLzZqbTlKSnhsZ0EzUFBnVVFxcHRZenZlVUxwVXhGSktkUys2?=
 =?utf-8?B?cDQ0cDlHWER2QXBoUkZmQ20yZm9ORnVVd3RSTk1ERXJkc0dmUVc2dzdoTERp?=
 =?utf-8?B?N2QyZzdzSlp0R0M4VWxwcWx5V2IzcVJ0Z2hCUXkvVEFhVDVhaVVTVldCS3cx?=
 =?utf-8?B?WVRrV0p0Wm1DWVZjNktZSmpUN3FoS1BNMnNmbytnRGVUcGx4ZWN6eGJsOVVn?=
 =?utf-8?B?aksyUW54SHBDdVIwM1pQYWhqR2U5K0xnQWx6SCtvUDdVVjdnbzJRVHJVWkxl?=
 =?utf-8?B?REhnVlIySEpLWWZGdjNKRnRtTDhqRlVkc0IwVDFiYXBuMGZKMnZHb2UxM1dB?=
 =?utf-8?B?cE9wY3RtbmlZUEZWN09RUlY4Z1FSSGpzRWZINmpaaWZoUVJSQzE1bFNqMzhQ?=
 =?utf-8?B?L2Zzc1ZMVVJyU3lUcXczNjJJN29hSHBvMEVKQThzUE1LTnVMZnFadkV4U2U3?=
 =?utf-8?B?dzZ6K0FkbDJvL3p0eXdRVEZYUmxvclFWR0FQNXZmYTIrVWtnSUhXNzltQk1m?=
 =?utf-8?B?M3l4amhmQVdmUSs2TU5jV2MvcVEvY0RwanBCR3BhQXk4dGpFWkdINXh1VDVK?=
 =?utf-8?B?VWlBVmczR2RJeTk3TnY1ck42YkZ1RS8xTVJEcTd4RFE2Y3hmRUQxL2duVnAv?=
 =?utf-8?B?dkkwOEJsVmFQeVRjRXQvNU1RUUxQYlExanVBUWM0NGtvZUpZVVZwUnEzVW14?=
 =?utf-8?B?anY0c2pCczFUVlNUVmhmUmZJNEZYMll4NVEzUUhzNDlKODcyUXBWYVRVbE01?=
 =?utf-8?B?Z1ZQbWoxbXh4SmJpdWFoYnd1MzNVak5aMElRVmREYys3bUVhNUtaSzhSdlpp?=
 =?utf-8?B?MmV3SzRjZWYvQVhzTGJwSEs1UTRIWE9IRHpTUUR4aGRZWU81WHlXRmxmcjdC?=
 =?utf-8?B?MzNsS3kvcXNPTWd2Mis2TFVkRGN4dktzcTJiajc0SlhxaWFtSkJzM0Q1c09E?=
 =?utf-8?B?K2JnUllNY0JQbUdoYkkyd3dhOWdJYWJKN2laazNBQm5Zb0xBSThLUXBseGVr?=
 =?utf-8?B?ZUQ3WkhhWE5CSVJKTmxwL3gwVlRlOXdwWGY1aDFNWlI2bE53VmU0aDhNL0c2?=
 =?utf-8?B?Wk9NNis3aUJxb1lXeERYYTl5U3dRYnNKMVo4ZDBuQmZlZUs4U2J2aVBHaU9K?=
 =?utf-8?B?Qmp4VTAwdmtHTTZESWx1UlpLUWRMc1p5ZXNoWlNBbGRXS0Rvb3BOSU5UUU5k?=
 =?utf-8?B?V3JhS1hTLzY5eENoNHlZRzU3N1NzclhmWWhUZVl5c1B1R3ZvTGM1ZWliY2pR?=
 =?utf-8?Q?O8w5C8T/N/t8UfNz7gVj3pWGV6u6cEmDedKFcZovPc=3D?=
X-OriginatorOrg: efficios.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 31c28fda-7cff-417b-7c3d-08dd16d4b0a6
X-MS-Exchange-CrossTenant-AuthSource: YT2PR01MB9175.CANPRD01.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Dec 2024 15:34:51.0070
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4f278736-4ab6-415c-957e-1f55336bd31e
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 6y7yb2l3Ys/g52M96ucl2mkRVqWscrzi9YztsMobExtNixWDB/wCO4n+sB5MG0u+42HsEmvJI/zCBYSmNjqDM5nP0r7+LZrLh8tj1b+ogUI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: YT3PR01MB10816

On 2024-12-07 00:56, Andrew Morton wrote:
> 
> The patch titled
>       Subject: mm: use clear_user_(high)page() for arch with special user folio handling
> has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
>       mm-use-clear_user_highpage-for-arch-with-special-user-folio-handling.patch
> 
> This patch will shortly appear at
>       https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-use-clear_user_highpage-for-arch-with-special-user-folio-handling.patch
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

Hi Andrew,

Nack from me. See my motivation explained here:

https://lore.kernel.org/lkml/acd263a4-824c-4c8d-a3e2-8b2f391fc775@efficios.com/

Thanks!

Mathieu

> 
> ------------------------------------------------------
> From: Zi Yan <ziy@nvidia.com>
> Subject: mm: use clear_user_(high)page() for arch with special user folio handling
> Date: Fri, 6 Dec 2024 12:42:46 -0500
> 
> For architectures setting cpu_dcache_is_aliasing() to true, which require
> flushing cache, and arc, which changes folio->flags after clearing a user
> folio, __GFP_ZERO using only clear_page() is not enough to zero user
> folios and clear_user_(high)page() must be used.  Otherwise, user data
> will be corrupted.
> 
> Fix it by always clearing user folios with clear_user_(high)page() when
> cpu_dcache_is_aliasing() is true or architecture is arc.  Rename
> alloc_zeroed() to alloc_need_zeroing() and invert the logic to clarify its
> intend.
> 
> Link: https://lkml.kernel.org/r/20241206174246.2799715-1-ziy@nvidia.com
> Fixes: 5708d96da20b ("mm: avoid zeroing user movable page twice with init_on_alloc=1")
> Signed-off-by: Zi Yan <ziy@nvidia.com>
> Reported-by: Geert Uytterhoeven <geert+renesas@glider.be>
> Closes: https://lore.kernel.org/linux-mm/CAMuHMdV1hRp_NtR5YnJo=HsfgKQeH91J537Gh4gKk3PFZhSkbA@mail.gmail.com/
> Tested-by: Geert Uytterhoeven <geert+renesas@glider.be>
> Cc: Alexander Potapenko <glider@google.com>
> Cc: David Hildenbrand <david@redhat.com>
> Cc: John Hubbard <jhubbard@nvidia.com>
> Cc: Kees Cook <keescook@chromium.org>
> Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
> Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
> Cc: Matthew Wilcox <willy@infradead.org>
> Cc: Miaohe Lin <linmiaohe@huawei.com>
> Cc: Ryan Roberts <ryan.roberts@arm.com>
> Cc: Vineet Gupta <vgupta@kernel.org>
> Cc: Vlastimil Babka <vbabka@suse.cz>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> ---
> 
>   include/linux/highmem.h |    8 +++++++-
>   include/linux/mm.h      |   17 +++++++++++++++++
>   mm/huge_memory.c        |    9 +++++----
>   mm/internal.h           |    6 ------
>   mm/memory.c             |   10 +++++-----
>   5 files changed, 34 insertions(+), 16 deletions(-)
> 
> --- a/include/linux/highmem.h~mm-use-clear_user_highpage-for-arch-with-special-user-folio-handling
> +++ a/include/linux/highmem.h
> @@ -224,7 +224,13 @@ static inline
>   struct folio *vma_alloc_zeroed_movable_folio(struct vm_area_struct *vma,
>   				   unsigned long vaddr)
>   {
> -	return vma_alloc_folio(GFP_HIGHUSER_MOVABLE | __GFP_ZERO, 0, vma, vaddr);
> +	struct folio *folio;
> +
> +	folio = vma_alloc_folio(GFP_HIGHUSER_MOVABLE, 0, vma, vaddr);
> +	if (folio && alloc_need_zeroing())
> +		clear_user_highpage(&folio->page, vaddr);
> +
> +	return folio;
>   }
>   #endif
>   
> --- a/include/linux/mm.h~mm-use-clear_user_highpage-for-arch-with-special-user-folio-handling
> +++ a/include/linux/mm.h
> @@ -31,6 +31,7 @@
>   #include <linux/kasan.h>
>   #include <linux/memremap.h>
>   #include <linux/slab.h>
> +#include <linux/cacheinfo.h>
>   
>   struct mempolicy;
>   struct anon_vma;
> @@ -4197,6 +4198,22 @@ static inline int do_mseal(unsigned long
>   }
>   #endif
>   
> +/*
> + * alloc_need_zeroing checks if a user folio from page allocator needs to be
> + * zeroed or not.
> + */
> +static inline bool alloc_need_zeroing(void)
> +{
> +	/*
> +	 * for user folios, arch with cache aliasing requires cache flush and
> +	 * arc changes folio->flags, so always return false to make caller use
> +	 * clear_user_page()/clear_user_highpage()
> +	 */
> +	return (cpu_dcache_is_aliasing() || IS_ENABLED(CONFIG_ARC)) ||
> +	       !static_branch_maybe(CONFIG_INIT_ON_ALLOC_DEFAULT_ON,
> +				   &init_on_alloc);
> +}
> +
>   int arch_get_shadow_stack_status(struct task_struct *t, unsigned long __user *status);
>   int arch_set_shadow_stack_status(struct task_struct *t, unsigned long status);
>   int arch_lock_shadow_stack_status(struct task_struct *t, unsigned long status);
> --- a/mm/huge_memory.c~mm-use-clear_user_highpage-for-arch-with-special-user-folio-handling
> +++ a/mm/huge_memory.c
> @@ -1176,11 +1176,12 @@ static struct folio *vma_alloc_anon_foli
>   	folio_throttle_swaprate(folio, gfp);
>   
>          /*
> -	* When a folio is not zeroed during allocation (__GFP_ZERO not used),
> -	* folio_zero_user() is used to make sure that the page corresponding
> -	* to the faulting address will be hot in the cache after zeroing.
> +	* When a folio is not zeroed during allocation (__GFP_ZERO not used)
> +	* or user folios require special handling, folio_zero_user() is used to
> +	* make sure that the page corresponding to the faulting address will be
> +	* hot in the cache after zeroing.
>   	*/
> -	if (!alloc_zeroed())
> +	if (alloc_need_zeroing())
>   		folio_zero_user(folio, addr);
>   	/*
>   	 * The memory barrier inside __folio_mark_uptodate makes sure that
> --- a/mm/internal.h~mm-use-clear_user_highpage-for-arch-with-special-user-folio-handling
> +++ a/mm/internal.h
> @@ -1285,12 +1285,6 @@ void touch_pud(struct vm_area_struct *vm
>   void touch_pmd(struct vm_area_struct *vma, unsigned long addr,
>   	       pmd_t *pmd, bool write);
>   
> -static inline bool alloc_zeroed(void)
> -{
> -	return static_branch_maybe(CONFIG_INIT_ON_ALLOC_DEFAULT_ON,
> -			&init_on_alloc);
> -}
> -
>   /*
>    * Parses a string with mem suffixes into its order. Useful to parse kernel
>    * parameters.
> --- a/mm/memory.c~mm-use-clear_user_highpage-for-arch-with-special-user-folio-handling
> +++ a/mm/memory.c
> @@ -4733,12 +4733,12 @@ static struct folio *alloc_anon_folio(st
>   			folio_throttle_swaprate(folio, gfp);
>   			/*
>   			 * When a folio is not zeroed during allocation
> -			 * (__GFP_ZERO not used), folio_zero_user() is used
> -			 * to make sure that the page corresponding to the
> -			 * faulting address will be hot in the cache after
> -			 * zeroing.
> +			 * (__GFP_ZERO not used) or user folios require special
> +			 * handling, folio_zero_user() is used to make sure
> +			 * that the page corresponding to the faulting address
> +			 * will be hot in the cache after zeroing.
>   			 */
> -			if (!alloc_zeroed())
> +			if (alloc_need_zeroing())
>   				folio_zero_user(folio, vmf->address);
>   			return folio;
>   		}
> _
> 
> Patches currently in -mm which might be from ziy@nvidia.com are
> 
> mm-use-clear_user_highpage-for-arch-with-special-user-folio-handling.patch
> 

-- 
Mathieu Desnoyers
EfficiOS Inc.
https://www.efficios.com

