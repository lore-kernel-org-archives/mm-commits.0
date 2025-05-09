Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2056.outbound.protection.outlook.com [40.107.244.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BDBCB2356C9
	for <mm-commits@vger.kernel.org>; Fri,  9 May 2025 17:11:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.244.56
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746810669; cv=fail; b=YPxfaqlpa+9xbxOtmIfMIq85Utrg9zy0xTrrV1YnINdO3LDmMNFm1vPD7Fe+6p/1ih0id+9K1hkApXptshtAltfVKJERAHKKv3rwOXDjwMNp1bjTcP69UyHkJFHUWBqqgnKVVOe9dyEAtIB7v4zynauj1lrDnD8c0vWmuzlMDQc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746810669; c=relaxed/simple;
	bh=fi6p1ZAKazN5kqVYj3v2T3VwNKKY0Xz71u0Lnf0LblQ=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=W6hztRzTp0INrwLowMHfKPgviUlz5qFfEenYS83946a2GNXzBW5xb5LudnTcW4kjsrjtKzfhKWsXCQTnR+PJAd5gWO2x8CpdhyGknFeuCmd3XCQbKFyFlKtMD9h3fLHkhHAf7BfRZ9RFTFUz/a4pJ9oTDKGEJpr46qQc6a2+y5k=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=SOnhh26s; arc=fail smtp.client-ip=40.107.244.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="SOnhh26s"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=uCcSYaBRD0ccpsi4c22E8uRz5WqtjExAcehomGvq1odA4rj9EmOIPc8uF4ipeqSW5tyyfSH+L0xOBjV6U4asv3I3+CXc+T3zICi2c9XO7M1X3ww7mdDLc74ArysP/Dm1ISGLUTP269vN2STX1WFy/MFf1m7sDYA8U/DbYrnv+VXgZ+/FgAMdHyh62xxIEgYUMu7DI76+WEmeltqmByDhiLI5zDLKnr94EIrWcCOCSSqDZY8XIaEXSlD46z6YVV5I+G5zk3T8PMSWpfVsL29XXnp2ZfkOGvHTYgSxsQTvZ1jVTeJgVQ5KnP2ot5qY+Le8d5BVEaZonYv/t1usPTnUpw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qK+k5jQlYPMOAnQKzeQh2elYB4k53JNbaPX9K7ffBYE=;
 b=q3S6/aKdwCUzyvRlhDgps6VqVCnhiAsne+NpcE1plslAQTJrcTN5YpDki5gPVP8swYp7kDrC65BeHI06Wd9ph7S6SqmyGH7Cs9CX47ydGzVJ80OuZeUzvUi7TjtRN3/Ny9eJKm8RNa0Go8xR0efKxM0BgyVme3mQNbRjIMaHRxIcIdfizIkIjWAvPVnbxdJurF1AeAxu1VfuzB12hsxVxXK/+W5F34GRBIZusCZyYhXQra8UA8UU8K5LSztv1oTfoKf6gtoX0nz/xCYE/diccWUa65+dgFlGyyUHE2ntsCziGMBrU+9b4JYDLRwUUrz77Q89w+PSz5NDGws8lBYs/Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qK+k5jQlYPMOAnQKzeQh2elYB4k53JNbaPX9K7ffBYE=;
 b=SOnhh26sjcK8jv0NZz0uNy3/wgK1UcJ+0tvzpyhGash1n6RYBMemgVbSF9ZgkXB0hrzyti4QKOhZWYT1QR1XRKPc+2So4KUKeaLKwKVWjnMVd2EuSqbmdNlDkvAIiFdA5Z2VNVpS9vyTnP3Jbl3i+Wde/8WCrrKPUEIKBgLh2rxbmmD9Y2WtNsJi5gsdGi+2U2bo6n257toEi/0X12kGLH5bmHk1HIEm2b7qVRQDeFpzEWyF86Yx/Fz3Pp+c6xcpErTfdzWKxwFLQ5LbfRvJgdKd5Xaf4NEIRnJ54eYmX1+kIcx1niTV0AKwrbfwQwgceaS2KzNKlrvO4+BqaWgKYg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5968.namprd12.prod.outlook.com (2603:10b6:408:14f::7)
 by IA1PR12MB8285.namprd12.prod.outlook.com (2603:10b6:208:3f6::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8699.26; Fri, 9 May
 2025 17:11:04 +0000
Received: from LV2PR12MB5968.namprd12.prod.outlook.com
 ([fe80::e6dd:1206:6677:f9c4]) by LV2PR12MB5968.namprd12.prod.outlook.com
 ([fe80::e6dd:1206:6677:f9c4%7]) with mapi id 15.20.8722.021; Fri, 9 May 2025
 17:11:04 +0000
Message-ID: <b7c796e9-81a9-4f1e-ba84-5e9af061ee1e@nvidia.com>
Date: Fri, 9 May 2025 10:11:01 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: + fix-zero-copy-i-o-on-__get_user_pages-allocated-pages.patch
 added to mm-hotfixes-unstable branch
To: Pantelis Antoniou <p.antoniou@partner.samsung.com>,
 David Hildenbrand <david@redhat.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>, Peter Xu <peterx@redhat.com>,
 Andrew Morton <akpm@linux-foundation.org>, mm-commits@vger.kernel.org,
 wade.farnsworth@siemens.com, c.briere@samsung.com, artem.k@samsung.com,
 David Howells <dhowells@redhat.com>
References: <20250508182718.40f16121@sarc.samsung.com>
 <e74d39d7-c304-48b8-8199-be31be8bd4c9@redhat.com>
 <20250508173535.GA8129@ziepe.ca> <20250508204711.6cf9f6e3@sarc.samsung.com>
 <1030abf7-c8b3-49fc-8bb6-fbd021ebc60c@redhat.com>
 <20250508211136.7a0a3865@sarc.samsung.com> <aBz8QuzT7YkPqrrF@x1.local>
 <8d66d995-f69e-4ac8-b10c-13a98ec9e848@redhat.com> <aB0BI-inU839lcIq@x1.local>
 <5d791609-411b-4e4b-b502-ffee80e8b46b@redhat.com>
 <20250508191920.GC138689@ziepe.ca>
 <CGME20250508193438uscas1p151cf203cd399facd3eb8dd950ff95775@uscas1p1.samsung.com>
 <5815c21f-7ecf-41bf-8bfe-89dbdc6c4595@redhat.com>
 <20250509193042.5a8af82e@sarc.samsung.com>
Content-Language: en-US
From: John Hubbard <jhubbard@nvidia.com>
In-Reply-To: <20250509193042.5a8af82e@sarc.samsung.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR13CA0041.namprd13.prod.outlook.com
 (2603:10b6:a03:2c2::16) To LV2PR12MB5968.namprd12.prod.outlook.com
 (2603:10b6:408:14f::7)
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5968:EE_|IA1PR12MB8285:EE_
X-MS-Office365-Filtering-Correlation-Id: 03b1c57e-9d7f-4332-4534-08dd8f1c7ae8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|10070799003|1800799024|376014|7416014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?aUVnMmpRQnFFUzU3dDJPaFU1a1pLaE1nZmk2MVFDZnZ5UGY5S1Fha3NGS1Vi?=
 =?utf-8?B?dUM2aHBqNVB4RFNsVndxa2ZKTm04YnNqeXM1K3lyOEM3SmpPWVVKTXBZWDFq?=
 =?utf-8?B?L1VJajVreW81V0pKOVNTc0VGMUc2RUNvWTk5MzNxSWFnRFZyV3RsWnFyc2cw?=
 =?utf-8?B?eHFyZHEvWVBUNVhNV2tVdEpWRjFWcTRienBvb0lLYllJS2pJQnNPa1IwQzli?=
 =?utf-8?B?ZUEvdkNHcEQxcnJ3V3hjNUVmdVpKTjNuMmxOUEdVTVk5VWlxTU8vYndvWllM?=
 =?utf-8?B?Um1abW04di8xVjdwOXFveGRkVzF3dENIQmt5MzRUNHJPZHV5T2Vua0Zmb2lw?=
 =?utf-8?B?dU5JbUJuR3FQbFhUenBpNGl4MWgrNTNOc1ZHa21SQ2tJeXJaZk9aREtZTTJl?=
 =?utf-8?B?YnYvb0lHV3JRbWc5RzNpOVArTk9xNEZWbERDWnRiWFBXMVU1citEcWdQeUIx?=
 =?utf-8?B?MWJjWElRWThzN3NvbjJMcXhWWExEYXUwektuZXUyMWN2QWVMWCs4OW5vRjRw?=
 =?utf-8?B?OHBmNGpqNyt3MkVSR3J3cjk0RE1PaTExYzJYdGQwZ0c1ZVRUKzB4bDlQQldN?=
 =?utf-8?B?L3Q0VXpYTjJaenFhZkE1ZFkrMHFpZU9DdmNrK3gvNWRKOFZSN2VSWXYrY1Bh?=
 =?utf-8?B?akh6NUxRaVZHbjN3WlVqMGhreDBYRlp1VGtvTTJWSExXRlMvUjY1WUpzS2dx?=
 =?utf-8?B?azFzMzllNFdDdVlIY3N6dGdLbXcvTUZTZDRLWFdiRkFwT3VKMVNLSmdBTmJu?=
 =?utf-8?B?NG1VQ0prMkttMDBwbU5WbGN4Znh6bDQ4clEybjEwMDhwVldwN1NEeEdjNUZF?=
 =?utf-8?B?OUZUTXZmdFJJRnFacUlUNzVvMkk1cDQ4c05aTVBxcW1haHhhcVREYzJkZWNQ?=
 =?utf-8?B?REtiQUtXYUNYK0dlVjJPanlwQmhONGdOZWU2THZPKzFDdERJWlBwKy9sY3c5?=
 =?utf-8?B?RXpHSSs3eTJodjMyOVBiTG56dUFDeXZXMG5QRGl1cXpxVkNGNU1ybjlncXFv?=
 =?utf-8?B?U3ZoemUwengxZWZFcDEyNHl3SGdhanNMSWE4Kzg4ci9JVDJ1OUNIT3JaRkFZ?=
 =?utf-8?B?eVlIZm5JZVV0VDBpNEIwWitReWFtUTBubW1NTTZ0Qk5KcWN0OVJ6TFdha0hJ?=
 =?utf-8?B?NzhJcXV4UkR0Qkg2M1c2c2gyL09wNUFJTkpsTjdiakVzcmVqT2Q3QUozRURE?=
 =?utf-8?B?OWFGZHlIRXFmSnFsRG9zYjJmdkg1S3RrbjhpbDdzSG1iODQzVWpteFcwZmxU?=
 =?utf-8?B?QWRMTncvVHp4dzZoeUNkemVTSEo4ZmxXMEZFaGNNTW5oM1d1R2cvVENlbWZz?=
 =?utf-8?B?ZUo1a3pCalFKeEwvWEx0dlBvNUZDRk8zd0tuMklZbGxqZy91Wjc0UUdyQUU1?=
 =?utf-8?B?dTNQNmJJNXY4WTBXQXFEMC9xS0hPZ1FXdnpYendVWnlFbkhSWmowYWFkVGIv?=
 =?utf-8?B?NU1aQ3RwaGlRQXJCUGNveW1WdHA3MWI2QXpCQmdRS3l5Vnh0SG1YdUxYTGp3?=
 =?utf-8?B?cU1yTUwwUTdzVVhQczMvNW1BMExhUlA3bjBSc2h3MWpLakZXN29OWWZNYlFh?=
 =?utf-8?B?cWRpb0VZcS9sWEIxak00dXJiNmZCam01ajZRbk1yaXEzbVdOMU1pRUdoNDJo?=
 =?utf-8?B?UDJHVEdjcVJRL3FjSm1WZmpOaEwzWndKeng3MnNNd2lGWTdqZ2ZpNjNsS0RN?=
 =?utf-8?B?RC9YMllaWldVWmd6SUZDSDNsam5SZmhqajIvN0VwVklMcUtHYUVJQ2xoTmh4?=
 =?utf-8?B?ekNyUlBCdjROQUJXT1lKNUVmOGVrSnZkZVUrbExPQk9jMmRhVGY5b0VNOFFp?=
 =?utf-8?B?cS94Tmw5Nk85cWkrWkRBbzJLWnRQM2tEaGFoRzd4SzNGNTlsY21naHdXUGRF?=
 =?utf-8?B?blk3TjliQkxDdlBaVk94bVJOSWF4VXA5bjZCcjVsRkZKNG5mU1JpSm5wakdt?=
 =?utf-8?Q?mdZfgNFzauc=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5968.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(10070799003)(1800799024)(376014)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?NnJNL1lXb0JLS2lkN0lzTUY4dlBDWGEyY05NNHRXTm9vM0JQcXoxcHdKNElk?=
 =?utf-8?B?L25YSnNIN2hDUk1XYVNIUitvV0pZbExiZTRWZmxrNWVsc2lZVjRadEdYdy83?=
 =?utf-8?B?THBqOHRXMTg1NEkrb2JUZnhHVXZYbVBUWVhpTmw1WXZXdWVLclhCMmMrSjNw?=
 =?utf-8?B?MzF6cWczcHM3NWJxU2hOK1lKQldueG0xRzhSQWlpYnFsWVN0WmlsLytDc1Jk?=
 =?utf-8?B?UGF2eTl5eWVFMVk3RXlJUnVDMGdCYVFkdDB5R3JoRERIeC9RV0c3ZzZOcmtG?=
 =?utf-8?B?WFZLbVRuTWxXamxuMmxTN2VVcmNrUzN2MTl2Yi9xUzQzQndOc3NwRUwvVDRp?=
 =?utf-8?B?dUoyVHAyb2lPTWlvSHg5MTBPdkZoaHFVSWVPOW96Vlp2TGdLLzdHUFd6WGQ0?=
 =?utf-8?B?TDMvdTg4RXZNRDVueTVydzZkdXNlUVloZ3BPQ2tmNjRFRVJWTFdLUmpLTTlY?=
 =?utf-8?B?QVQydkVqMkk2clJBRXJWVVF1WGlpSWl3TDJUNGQ4Qng5RkZwNnQ3YldUN0Jp?=
 =?utf-8?B?ZmtXOHdOOG96Y2JSVHM2WDhhbnAxRVpZUkNPQWpnUlZhQm9EcnFSZVJaRGFG?=
 =?utf-8?B?cVQ0MEs3V2lHU2NLZUIxaUs0bG5jNDBEQlpHWWlSQUtFbUVKdktMWS8zWG56?=
 =?utf-8?B?NmYrTFJocUxBZm1jd2RoSUVUK2dTako3U1ZmSnE3THIwbG05VE54S25YV2ZM?=
 =?utf-8?B?enZSTEd3SnBCQUhiUlFsYlRqVW5OV2hIbVBJUzByMlBJN0R0WXhOaktianJo?=
 =?utf-8?B?OUNpVVk0d3JjWkRudnNrQUpBbk9FSUFYOTNwcFd3bitRTWcvbm1uN1hyblBD?=
 =?utf-8?B?bFZBenZJOE1qUU1QeStZOFBKc2xmQ3czeFZBa28ybldNZWhFV05HdmpmWThF?=
 =?utf-8?B?SklZckxRcktmM29GeklYenNQb0lvbmNHMCt6MThMbFFKTHBTZG1Ed21IaDIr?=
 =?utf-8?B?S01ESUFieVpOZGJ5dVVPVEQzT3ppWU1LKzJjSUZobGw4eE0vQ045VWxHY3lr?=
 =?utf-8?B?eWw1Nmc0Ymc5anM0Z1VSWjlLOVhNRHpXREcraURETnB3b2thM0Q5Lzl0QjY4?=
 =?utf-8?B?bk1WcTNTaXBGenpzcnZkR1l4VXVNNnZ5S1ZrandPWTZLMmc0K1FSaUJvd3Ez?=
 =?utf-8?B?QlFCcjB0aHBnSHloSndac29YWlgwOG9wZ1FuUWhJWExaK2hvc0Nkd1VFekt5?=
 =?utf-8?B?Q3Q2N0xqMjM4ZEp3Ri9lOTRyUDlCQTVyNHIwREk5V0NSK3dULzBBZUVDSnFK?=
 =?utf-8?B?SHRwdy9wc09FNEJhQjA2U1ZSZ0ZEWWo1MzdrcVFIbUhMMHRRNE9TOVZiVU5j?=
 =?utf-8?B?YVNtSUVLM1FXRnNnWCtzYlM1bUhuMzFFZm9DM1F5dG9UUkhPL2trM3EwL0JY?=
 =?utf-8?B?UHlIUm9YU21VMXNtcVVOSlcyakIydVVtdFpqNEhTRWlhcGdOSUtsdnllaG5u?=
 =?utf-8?B?ZHJWRStxekZiR1FrbmwwWU5RckREUUZTSTVrcGs0eU8xZDBPREw0SVpnZ1dq?=
 =?utf-8?B?OUdwNnpoQk5MTjNORS9XQ21pdHVUQlRkT2FyS0Z3elUwd21GZE4wK3lQdmJp?=
 =?utf-8?B?bE1WZFgvaGZhWFhtZEdqZmZoaFZ6by9zUk51eEt2RXFLN2VXbEVKZC9QU1g1?=
 =?utf-8?B?R2xWaEtPM3FLM0UyZVU4UW5lTXJrMEorc0ZrQVhaTmtERXRuNE5WbUZPRjFX?=
 =?utf-8?B?S1QzMGRhRWc1WS95c2hTbE5LMDNxMGNJYzFzeUN1R1RlZ2VwdGwvZVJSMEQx?=
 =?utf-8?B?RWxKaVNacmJjWGJpREQ5UUptZGU3QndkV0NnbkhUNlNyd1JKSHpsbmovQWd1?=
 =?utf-8?B?aDVxMEI5MWp0bkVqYUpaeUF5aWVYMXlucjVWVFhQZ1QyZlhHVk5SOVY3emxK?=
 =?utf-8?B?bm1oalNlQ0FXNEdkYnRocW02STRYM0pQc1RXeHJYVFRzeWVmdlJRYzk1dTAr?=
 =?utf-8?B?TXIvMXBKL1kvQy9jYm9SZzI5eGF2bjNmYnJzMjJNYXZDejRaak41UlVSYjcy?=
 =?utf-8?B?SHN6RVlSTVU3L05idENiMUppbk8xS080UlpGZ3N6eXFiWXh4R203TURIQXBG?=
 =?utf-8?B?enQzOUpja3V6bXQ2N1FUcjcwdzdWWVlCSlFXcitraXE1dFRDSWljMXAvcEc0?=
 =?utf-8?B?T0xVKzJhTkdkbzA1MDNsdk1oT2R1anZ2Z21VYmlVYkE3S0w2YjNTNWhVVjJa?=
 =?utf-8?B?U2c9PQ==?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 03b1c57e-9d7f-4332-4534-08dd8f1c7ae8
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5968.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 May 2025 17:11:04.4330
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /oeNLaYsxprHWAd0UESmmZNW9GMZdDf9BNKFtXB5Rz/chh5TjIyqEViwCvwX46wVOHLJIgnhl7fs5fnUSBvlEw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB8285

On 5/9/25 9:30 AM, Pantelis Antoniou wrote:
> On Thu, 8 May 2025 21:34:28 +0200
> David Hildenbrand <david@redhat.com> wrote:
...
> So what's the plan now?
> 
> DRM seems to be the first place to be fixed, however am I wrong in
> thinking that most of the uses of remap_pfn_range() are wrong in the
> context of system page backed memory?
> 
> Should we start with an implementation of something like remap_range()
> which does not set PFNMAP bit. Its use is wrong in that context IMO.
> 
> And then move to DRM proper and replace the call to remap_pfn_range()
> with it and see how far we go.
> 
That sounds like the right approach to me. Because the way we get into
these problems is mostly due to the lack of a clear example, and so
providing something correct to call is the way out.

thanks,
-- 
John Hubbard

