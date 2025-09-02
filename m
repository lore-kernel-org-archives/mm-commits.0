Received: from NAM02-BN1-obe.outbound.protection.outlook.com (mail-bn1nam02on2079.outbound.protection.outlook.com [40.107.212.79])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C39FE2F2E
	for <mm-commits@vger.kernel.org>; Tue,  2 Sep 2025 11:30:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.212.79
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756812629; cv=fail; b=d3+6hVWaXwuDNehT4L6EchTkzdF70gA/Wt9D8QsowhKvCebudi5WSaLenflz2ijrsmt0YulXBObCw75y8bZiEdcKuWKQaH3ZwRpnqWKwzE3+l/9DlBfvboB72Pv6N/nBoIFRR3XC8zHM2rBUM4+O+ZKziuQWkf4jzmWRitbA2oQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756812629; c=relaxed/simple;
	bh=80BtIhLbiCKIfYm+y6jK7vI0ldPKCaWISm3gzv0iX40=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=AAq/MJ5xY0akgHqY2gNBKT9OsKnu2+ncpooZEm92kaaFi1K47L/Qxgw1vT4jCVxNYdjpw70jv63OOPUqeIc3U1f8PbB4dfBwe7QPmc61Zf65waMZBNs7HqC34/8t1EUSW8Rr2SHZsXzmmRcLFx1BmNWkdCP1Zc8F9lB8Dus2ujY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=I3WUjl3D; arc=fail smtp.client-ip=40.107.212.79
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="I3WUjl3D"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=sc2UHDSjWFkuEVwWFf0hornDEUIH/BZwBR2S7l2aMz0tDpA2opzrYDMf4nsAOcMMXF3HwydLywpG0FHCfQGwgjP3aVbJ+cW2GLyBU+wdpKWsMo9ZArLMc2Q/dxRuyUYb+mJ9dz2ixGElYh1EqUV3Xa6cg3OyYsaqdDPGqviiDo1TsKIteCB/rKxZ5zLBw0x+Gf1vWE91C9QY5gg9gD479wZoVDnd8cmEZ9w0wFjF5cBX3Z9FJdXb2AdBLV8bksK2VlmIij6Xm5L/sNT9f26BA8fjcDn53g42uCyfltsmwj3pQEx0DhMCq5Y13yfZoQy6dmfXUco9RpvXZyPyuz4+jg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=OX1b/wMytrEs+i5XN1wQPdmTjBQwmji2wumyJAIfHu0=;
 b=iUmdylGar0WIAW3FrsvhnjASu/G0wPz/px+nQ4WUyOHTqOCKndft3np9VDz0uBbP5O5En+rqd8U41CKp788BEJ9sppaySG8GqvLCJPWoXJhJJOf68+Xi/P3he/EEIsiuU4abJC688J3XLRfL03ZtArZBHc5Gt+Ur5jRtbBmA2J4AEZt6qcH5z3RdYBzeREedka5WJexB5a+oVCOnEj0UjegL511PlzwPfBw7fHYN+T1KBSI2aJhNdPgiwgJwkC/r4yRl8sqeYfKOQXPnEBkygSNS3tAj7pN/RmYtpDuQocHWP3okq5Eqny2z77FeDCBQ4Pr3yqghld9Ra0OXTgVKng==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OX1b/wMytrEs+i5XN1wQPdmTjBQwmji2wumyJAIfHu0=;
 b=I3WUjl3DyN82fNS/I5bnt52cLSQexo4Z6ipMEf3t2+2iGxWiuuRe+XUW2WJGYQGMXPp+7jqyEuzlcLqwffyTfEuS8AwEwwosjQpHO8bHzI1pC3gEMDJF/Q1iDC7HOQhCT3WJenCNev1YItjO+49DTLpy9SyWcS3Sb3hFhnPx/wRgxJRK7CTW5ifti1AsHM1u346ZONLqQqbNmKGGXpqc8JVL+rPWB/wO4Jduf/GA7dL0Zj9MlnF2T/1ek43G90Zq2zwsSqGIl3sht002plpsJMCXQes94LZpTPhEeULIIZvQm+G34dYFxop1eGMChRTFX2nzrZ9yHErhEUSIa0OBpA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from PH8PR12MB7277.namprd12.prod.outlook.com (2603:10b6:510:223::13)
 by MW4PR12MB7466.namprd12.prod.outlook.com (2603:10b6:303:212::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9073.27; Tue, 2 Sep
 2025 11:30:19 +0000
Received: from PH8PR12MB7277.namprd12.prod.outlook.com
 ([fe80::3a4:70ea:ff05:1251]) by PH8PR12MB7277.namprd12.prod.outlook.com
 ([fe80::3a4:70ea:ff05:1251%7]) with mapi id 15.20.9073.021; Tue, 2 Sep 2025
 11:30:19 +0000
Message-ID: <9481c30d-2232-4d29-a38f-6a87b0648238@nvidia.com>
Date: Tue, 2 Sep 2025 21:30:13 +1000
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/hmm: populate PFNs from PMD swap entry
To: Francois Dugast <francois.dugast@intel.com>, akpm@linux-foundation.org
Cc: airlied@gmail.com, apopple@nvidia.com, christian.koenig@amd.com,
 jgg@nvidia.com, leonro@nvidia.com, matthew.brost@intel.com,
 mm-commits@vger.kernel.org, mpenttil@redhat.com,
 thomas.hellstrom@linux.intel.com, ziy@nvidia.com
References: <20250830035612.0DE67C4CEEB@smtp.kernel.org>
 <20250902111743.1633972-1-francois.dugast@intel.com>
Content-Language: en-US
From: Balbir Singh <balbirs@nvidia.com>
In-Reply-To: <20250902111743.1633972-1-francois.dugast@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SJ0PR13CA0202.namprd13.prod.outlook.com
 (2603:10b6:a03:2c3::27) To PH8PR12MB7277.namprd12.prod.outlook.com
 (2603:10b6:510:223::13)
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH8PR12MB7277:EE_|MW4PR12MB7466:EE_
X-MS-Office365-Filtering-Correlation-Id: 03b7ed17-c7d8-4f25-6f26-08ddea1418a4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?T3RteEZXeEx6b1dVVlE1N3YzMi94TzBiT2N4T3piSWF1ZXI0VC83TzRlUU5m?=
 =?utf-8?B?bXpBaXhFUC9DNE1mUUNwNzRWek1xazFQUFFGdVV5Q3I5eWtOb1AzTVRTclpI?=
 =?utf-8?B?VTY2bDhGNmZlWHplQ3RGWTVlalBQYjRmQTNhU2l0bmhKaFg3YUNyOVlPcDVw?=
 =?utf-8?B?RWo5V09IcHc3bXZPenJVQzlVSzdBQ1k4UldLbUhSdy95c3UwL241VWtQUmNB?=
 =?utf-8?B?eXpZQkc3bDJnaTFRV2FqdEowS1c2NHNMeWdvVUt1ekJyREJoWUtjQUFqQS9P?=
 =?utf-8?B?dWhDVExOM0ZrOGNQcE1rbDNtUFZ2MVB3eHF1Q0Jkc1RxSXYyakZnZjhCU21W?=
 =?utf-8?B?eGpVZTRac0diR0ViNXlkcjAzeXhEdm5wazFYYktRcTIzRC92RnNJc2dLR2lv?=
 =?utf-8?B?UmxUekExN3lONXAzU2t6WmdSL1R3Z1E0RkFZQ2R1RnZLZHE2NEcxS1dQZHQz?=
 =?utf-8?B?Z1lTSnVyMzRGTjhKdk9IZ2RlZ0t0MTN1NkViK0pZUmtzRmtUbjJkWlNzdzhQ?=
 =?utf-8?B?ZnRidU5rM1lIWGM2MkNGcjhWU2lUbVRzaDArTC9rYTlsNEpkalRQdjAzYXdi?=
 =?utf-8?B?RkF4Q2VEa05Yc0hIUk83dUlYclQyd1RnbE80cGVwU1lTT3NvM21CQm90S0or?=
 =?utf-8?B?aTMyZHFtYjV0YzlhZFN6cTQzaW9TS2lNK1RhMm9uOGRLckZQZHd4TjBhaFJB?=
 =?utf-8?B?b1lNRk9zTGZOVUpuOVRBa0RRbVRZN2d1U3d2MVU0cFY2VmxMbFdkU3FWV2NF?=
 =?utf-8?B?ZTZEVE1ldUFUMnBEZ0JxR25YY2V5bUtHZ2tXTWw2djRqeDYydXFJSTA4NnhK?=
 =?utf-8?B?TXdaV052OEFnYWlySUtJUGhoeXZUN25MaWRjaUNDOHVuTnlHbmZvdHFmR09R?=
 =?utf-8?B?SG5iT0NXRiszNFloRXNwTU9OZ0lXbUFEK21EcVZPL0hRY01GTm1qRVZBakdY?=
 =?utf-8?B?Mk4ySDd3T1FSK1JseUNIK3NhamVsZDFGOFMxU0FPN0tnY2tRemNqOGRERmNF?=
 =?utf-8?B?SkVya2dtV1dCdzBQQVNCbnE1dEowdEtwbWtubzFCUHNPbFMxZm8wRDJaSUVY?=
 =?utf-8?B?WFV6N2VxYVpXd1VMVDJrOTZBWFNDUWlTRDZHNmp5bjNCWm1uakpXSWptM1lZ?=
 =?utf-8?B?d0x3a2pxcHVXejFnWU5teFlhVXV1aUIxSG13eWU0T1NVN29nKzc0RTJ4cEJt?=
 =?utf-8?B?NEVjR3lXRzhUeTQvNEtlT3NSaDhSc1lNa3Nydi9kNklQSWxqbnVjdU8vOHlp?=
 =?utf-8?B?Zmd6TnlibVc4S3VaVEtvYWFUQVpsZjkxcGJYMktQbnRIbHJzdngvdjFreDNq?=
 =?utf-8?B?OXlUM1ZGbUoxZkNkWjZqZ2hVcUdzQzhoVGY2RmVBQm0rUVVlSzhKK0VUbUor?=
 =?utf-8?B?N2JpcDN2anhPUFVJSFpmUURhMElyMytpcDN3TUV5QllSOHkxN3p5Y0NqdXIx?=
 =?utf-8?B?ZjFYN2NnQkZ5QmtxdHZhb0pJWFcwOGtZeHVGOU50Uzl1aVVxMUIra1hNK25l?=
 =?utf-8?B?aS9qVW5Ja3VhT085U05iT1BBeExEV2o0c3JwR1IzM0phU3BYQjgwQ25zVy9s?=
 =?utf-8?B?UTBZRi9waGlnbXZSSnBvUTNiTXE0d2JUa2Evd1ZncTNnZVBVTFpUbWFxb3Q5?=
 =?utf-8?B?R3RiSW55bUFQemFzOG1ieUt3Y0YrYm5mM3h4QXJaQUl3SFBpYUJNZllYNnpB?=
 =?utf-8?B?YzZNRnlrTy9qMkxoYjZBNXdWeUZEK2VkUUhrMTMweDAzTlhETm9UWmhnbXdM?=
 =?utf-8?B?M3pNb1ZMMHI4V2d6N1VRYUFrWDRKQlNSL3BMSTJ4bjJqWXRsYXFDa2ZaRE1x?=
 =?utf-8?B?aDNkK1c1ZVlCZmRWVmoyd0ZLMXpTQnZzNjBSSWFqc0F1SlZpamZvdXdMMVUw?=
 =?utf-8?B?ZFpFalQ1TXVWZ2dhc09EeWhRL3hQQ1FQblNpOGk1TWlYRkFkK0Fra0tDc3hm?=
 =?utf-8?Q?D4zgEpLHWTs=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH8PR12MB7277.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?WVhGUVVyNks4MkF0MHFST3NpVkt0eTFHci9hK3RtRGxTSnNvUGFCV3JoYW0w?=
 =?utf-8?B?NjlneS9YRTJrOXdBNFE1MnFoNU1sOXBaajJIdk5Fb0xEcHNsZm4yTDRrVjg3?=
 =?utf-8?B?Q0ttYm1IU3FVbkY2SStJemhLYWU0a3JUMGllMzNBTzUvMUd6Wk0zYnoxMGhh?=
 =?utf-8?B?Si9Ibndva24vc2Q2SFErM3l2YnREYWYrdU4xY0NzcmZIZ2dOd0hFbWY1dHd2?=
 =?utf-8?B?QU5oYzZ4elNZblJHWlZtMWswemdwM21lN2E4NXNzTjJPUDRkMXV0aTJ4QjNq?=
 =?utf-8?B?dExNL3loU2I5N0dNdVZ6Vlc5ZGU3MjFOL2szVzg5UjRmT1I2aGdQWno2ZmZK?=
 =?utf-8?B?VTdSdUl6cXEyMnYrZzNwQ204K1J5QzVMbjc2TktGNHhURllNWmFmUU5uakNx?=
 =?utf-8?B?WHFMWlNHd2NCWU9yOFB3ckwvMDlxNnVCUElqeFhHN25reTBNTjkzQUtHSTlT?=
 =?utf-8?B?VTFraFNqS2IraUJ1S0x4dlE5MGd0azkrYzZFTkhXd3U0UUpvTWdwN1ZGbTA2?=
 =?utf-8?B?Nk5MOVg1VWxQL0gvR1liVjhsYkg2Sk9RZ1JpTHZwYlRyWHprbE1kR1dpakt0?=
 =?utf-8?B?aHFLU0RIZ1lsZy9tUHNxVWZ3RjY1QTRHVXI4b3BtQmlBa1ZwaFNqYmJ4WjY0?=
 =?utf-8?B?OTNlS1VKVmVua2JpZnc4ZmpRcnZVdEV3NFdDa05jSCs2aEV0U2VqMjZHdTBr?=
 =?utf-8?B?a1ZXZWpLNjFvZ1pabGgxQ2E1U2lFU2xvajhnVHpCOFR2c28yQ3FQYklselpi?=
 =?utf-8?B?cE01dHhVQ2JqM0dWWVdZYVFRS2F3NldUY0U2ZzMxRTZOeFhjOUY0U2RZS2xZ?=
 =?utf-8?B?Kys3OVA0NDNrN1M2dm1kTWNMN1pDdTFKNHRHbGJ0YVlSR1F5cDQ0RmhvL0VH?=
 =?utf-8?B?c3c4K2hKaXV3U3h6MTI3eDhQVnRVd3pXY3U0VDBNWmQxanlRdWdidU5hc1pr?=
 =?utf-8?B?RzBjNGdnSkIwdE1uaUwwTDhSL3NXZ3B3L0FkdmJOajZwOWhBUElMTGF1YTdG?=
 =?utf-8?B?WjgwTDNHTzQzL0hScisvcG5aV2w5UWwyNEVNV2ROMzk1RHdUNWo3c1d4WU44?=
 =?utf-8?B?cGNBL1NWQUtaUC81cTM4RzRuU1I3cHZmL2hLdzFVbU0xeU1HbFRwc241TFpv?=
 =?utf-8?B?bzlhb3dKTXV4T2I2S09FZ3RyWERSUWd1UXdLR3FmWGZnVVZxdmwzay9vOS9C?=
 =?utf-8?B?ZVFYTWJWR1lscnlrd3dsR0toRU5OZUdYY05OMTRpYTlNVlNMUXZPZGpNWXR1?=
 =?utf-8?B?dUxrWXdTa014a2lNd0ZBQ2Vqd0xWK2JySmVoYWhOQWs1TkpvWUl5cnB4dEpD?=
 =?utf-8?B?bWRRYXNKVHhyZUdDL01sb1c0eWRsUHZTZ0Y1dHhXOEVORzgxaW1PSGY3blhE?=
 =?utf-8?B?NFpoT0c0OHFPVnFTUnpFc2FLZzdoa3RYd2xtQ3BYNkxaRjlVaEtrbE96emhC?=
 =?utf-8?B?a3VyOXNwUllJUHhBWHZSK1FIMXlxSFhzWEtVb3piSm5hUUszRkVTMS8wZ2t1?=
 =?utf-8?B?d1pLb21icDRpZjgvbUN5M2Nsa20xSC93ZFhESVFJbUUxcDNRMEFpeGpvKzN0?=
 =?utf-8?B?LzhSTENFazUyRmZhenJ3OTJWSVJpSnZOcG5QQmd5K2RrSndBUEs4K3ZLT1dt?=
 =?utf-8?B?elYrczc1UU82c2lab09qWVdvMjZrelQyNTYxTHF0MFFXcjhKdFIvbjlNK3hQ?=
 =?utf-8?B?Njh0Y0xKdUI5OE1BUkd5U28rcEtSQzI5dDlDcmJWVnJFa3lFS2RicCtZdDRo?=
 =?utf-8?B?TVdCT3ZXVFloa0VaOXZraUhGWUFtV3FJSDJONmN0T21iNkpEczg5TVJLM2RQ?=
 =?utf-8?B?Q2luZnl2bzJ0S3ZsTnNXb2JUcWdvazN5Q2VLalQ0bWV4Yi9nTlhtK3RzNDNW?=
 =?utf-8?B?eTcrdldIa1lodlpZblV3L3RQWTJuckJOd2xWKzJiNmhnZHFnTDVOU2lUMjIr?=
 =?utf-8?B?UW8rcUZwSUJ2Qjl4NjBPNy8xWm4vb0pRVEErWVlrRjVVQXR3U0VFOW5oUCs1?=
 =?utf-8?B?dys2MXE4eDFueDVUeTRuZ0VoeVJhN05PbStlSi9aZjlTL3JVMjNCZDNHa08w?=
 =?utf-8?B?SUdIUXNMWHBWVTJsZ04wQy9VdnFYTmF2VWxZRlNzTytxdW9SMC80eTkrbkMx?=
 =?utf-8?Q?ab4eu+lIt2hiKBNVn6hcocM6F?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 03b7ed17-c7d8-4f25-6f26-08ddea1418a4
X-MS-Exchange-CrossTenant-AuthSource: PH8PR12MB7277.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Sep 2025 11:30:19.1465
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: f1bTNDSs8im+kw78K87cl/nhrfY4t4FSrWg8+UjIU7eMjFw4Rw90tNbjkYhZKkexsCzKrVImaBUEXJ/n8JLLBQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR12MB7466

On 9/2/25 21:17, Francois Dugast wrote:
> Once support for THP migration of zone device pages is enabled, device
> private swap entries will be found during the walk not only for PTEs but
> also for PMDs.
> 
> Therefore, it is necessary to extend to PMDs the special handling which is
> already in place for PTEs when device private pages are owned by the
> caller: instead of faulting or skipping the range, the correct behavior is
> to use the swap entry to populate HMM PFNs.
> 
> This change is a prerequisite to make use of device-private THP in drivers
> using drivers/gpu/drm/drm_pagemap, such as xe.
> 
> Even though subsequent PFNs can be inferred when handling large order
> PFNs, the PFN list is still fully populated because this is currently
> expected by HMM users. In case this changes in the future, that is all HMM
> users support a sparsely populated PFN list, the for() loop can be made to
> skip remaining PFNs for the current order. A quick test shows the loop
> takes about 10 ns, roughly 20 times faster than without this optimization.
> 
> Link: https://lkml.kernel.org/r/20250829080505.1020155-1-francois.dugast@intel.com
> Signed-off-by: Francois Dugast <francois.dugast@intel.com>
> Cc: Jason Gunthorpe <jgg@nvidia.com>
> Cc: Leon Romanovsky <leonro@nvidia.com>
> Cc: Zi Yan <ziy@nvidia.com>
> Cc: Alistair Popple <apopple@nvidia.com>
> Cc: Balbir Singh <balbirs@nvidia.com>
> Cc: David Airlie <airlied@gmail.com>
> Cc: Christian König <christian.koenig@amd.com>
> Cc: Mika Penttilä <mpenttil@redhat.com>
> Cc: Thomas Hellstrom <thomas.hellstrom@linux.intel.com>
> Cc: Matthew Brost <matthew.brost@intel.com>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> ---
>  mm/hmm.c | 23 +++++++++++++++++++++++
>  1 file changed, 23 insertions(+)
> 
> diff --git a/mm/hmm.c b/mm/hmm.c
> index d545e2494994..d449fc4647d7 100644
> --- a/mm/hmm.c
> +++ b/mm/hmm.c
> @@ -355,6 +355,29 @@ static int hmm_vma_walk_pmd(pmd_t *pmdp,
>  	}
>  
>  	if (!pmd_present(pmd)) {
> +#ifdef CONFIG_ARCH_ENABLE_THP_MIGRATION
> +		swp_entry_t entry = pmd_to_swp_entry(pmd);
> +
> +		if (is_device_private_entry(entry) &&
> +		    pfn_swap_entry_folio(entry)->pgmap->owner ==
> +		    range->dev_private_owner) {
> +			unsigned long cpu_flags = HMM_PFN_VALID |
> +				hmm_pfn_flags_order(PMD_SHIFT - PAGE_SHIFT);
> +			unsigned long pfn = swp_offset_pfn(entry);
> +			unsigned long i;
> +
> +			if (is_writable_device_private_entry(entry))
> +				cpu_flags |= HMM_PFN_WRITE;
> +
> +			for (i = 0; addr < end; addr += PAGE_SIZE, i++, pfn++) {
> +				hmm_pfns[i] &= HMM_PFN_INOUT_FLAGS;
> +				hmm_pfns[i] |= pfn | cpu_flags;
> +			}
> +

Can you add a comment here about why this is added? Why would there be a disconnect
between HMM users and the API? I assume you are referring to drivers that are
not yet aware of large folios.

> +			return 0;
> +		}
> +#endif  /* CONFIG_ARCH_ENABLE_THP_MIGRATION */
> +
>  		if (hmm_range_need_fault(hmm_vma_walk, hmm_pfns, npages, 0))
>  			return -EFAULT;
>  		return hmm_pfns_fill(start, end, range, HMM_PFN_ERROR);

Other than that, based on the assumption that my patches are not a pre-requisite
for this

Acked-by: Balbir Singh <balbirs@nvidia.com>

Thanks,
Balbir

