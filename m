Received: from PH8PR06CU001.outbound.protection.outlook.com (mail-westus3azon11012044.outbound.protection.outlook.com [40.107.209.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3BDAD515
	for <mm-commits@vger.kernel.org>; Sat, 15 Nov 2025 00:14:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.209.44
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763165696; cv=fail; b=GVGBz5xYeIXe7YvtI6DDbCbahRxBbNFqteKXO9vjq0MP4psp29VRA9JA0qw/u6CCdW0BUDq6r3OIBC9KbhTh1UeY/ik8zklZPisL9CdOAW0zMRukpFLY3Grde/LqQP/FCRH+G1vfHWf7L2ZvcudidBaecYzpocrAn4Sj9SBx8hk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763165696; c=relaxed/simple;
	bh=R/9Dql66Meo1EDQe0Bd48+Wp5EJz0kCfJPS+422noEo=;
	h=Message-ID:Date:Subject:To:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=iUG7bhhzCD1AOYBNnwgw9NLsT3HIJjsc2Dfadc64QjOiQmGQmT2roOOq/ojmqTY74CKE/03FnLaYN7Cc+vX0T1cytcyt9ojeWVwMSpbmP0gV7xEWf0OPdUg+zIo/kvnMy9w1kLH1LGstQLbYTuf10d5kgsSzxPd77FkpcVc25Gw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=WSo8ZJv2; arc=fail smtp.client-ip=40.107.209.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="WSo8ZJv2"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=SQpWN0NIL5AXmM2DKq+xjbNVTB+Zjk0ERDRzLL4DwOK5nw+6Ewf1PkHSfmZIzf1fKSumvvj7hnSY7dQXpLaTg7aHscq2k6fmVgBOI/hyhixzvo8qF6O5Oism4kDfAYJMD2Ip3v0pHduGXBqOgkae2VW4XwuzktwBPtkLmyLSuDWkJAQbYnT1ozmEF79e4Nka5YaxMW+l1lfzVPSd46s7XZJhw+97uVsey62fQ2UFbqLHeHL2FtIUHdIOFiUXA6xdtT8IWqA6I8091Hh4qGP5pKlz/uWdU1WHlYo6vrFojm23QKCYB9qDtVAtE4JjQj4oAJ7vVuFgZACFRn5kCppvxA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YJmmAOttyRcXPlFs2C25WoU2bW4bwXDazSyVMG5/Ug8=;
 b=ICl3Mcv1NGV8GE2F9A+PCkVmta7xA3jFehmknf7/iyDJkEOYW8kS/CgGwkbKMguucsKMcW6S1RRIBUSKx9lfuVjsZY/GN3J3UKlj3dPzD9m20siL74U+l+ulMwPz8M3gVXxeVR+BflKf0fzOLzU4BGTLyPvmT3iTZHrOAlVQOSdkwWOPwLXXTTILMxkvI4OWeMRM6Q4Efuz+/0IXS0rr3hQ1fpxcyColR+WUqzY7zqBIwM5FyZZ4yhoCwHXkLR6eCpszTBThGMjOoGAekn2h7Kx9EWgCBeYGCoUsOzmaf1B7dW89k/hhDds388t2jIF37sm2R4zih3cjGCY0uxCqww==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YJmmAOttyRcXPlFs2C25WoU2bW4bwXDazSyVMG5/Ug8=;
 b=WSo8ZJv21WdfVuy6L7iKJiK1ijJYnMFGgy4Ki13PtaQaEyalAA+MB/asHBT7+zPFLJbb89hLUGLpGUEY8TuD4WbNZkTqJN7fchCpqEsHqk6y3ueCB6E2D1UbJzLpRbhyzguxdr5vBMaoeop73zs/RE2QM7lK/zL6OZO1/cL1UcR8Z9zew681BWV5ZIicA1aiayBLDjhMNJtNSecC2+/h29RZUCc788FsMQvrNj6R1cTtWItnRoo/YK0JPTIE4RUar8nbj78t3+kCNJ/CWLd4tO+3t6FuDCjLu3TzdmVTFiCL9onepiv4D3l6e3SGsH2bnja/+q2pp0KxoMvHWplKcA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from PH8PR12MB7277.namprd12.prod.outlook.com (2603:10b6:510:223::13)
 by MN0PR12MB6102.namprd12.prod.outlook.com (2603:10b6:208:3ca::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9320.17; Sat, 15 Nov
 2025 00:14:51 +0000
Received: from PH8PR12MB7277.namprd12.prod.outlook.com
 ([fe80::3a4:70ea:ff05:1251]) by PH8PR12MB7277.namprd12.prod.outlook.com
 ([fe80::3a4:70ea:ff05:1251%7]) with mapi id 15.20.9320.018; Sat, 15 Nov 2025
 00:14:51 +0000
Message-ID: <0c7a451a-60fc-4131-bf9d-fee05720420c@nvidia.com>
Date: Sat, 15 Nov 2025 11:14:44 +1100
User-Agent: Mozilla Thunderbird
Subject: Re: +
 mm-rmap-extend-rmap-and-migration-support-device-private-entries-fix.patch
 added to mm-unstable branch
To: Andrew Morton <akpm@linux-foundation.org>, mm-commits@vger.kernel.org,
 ziy@nvidia.com, ying.huang@linux.alibaba.com, simona@ffwll.ch,
 ryan.roberts@arm.com, rcampbell@nvidia.com, rakie.kim@sk.com,
 osalvador@suse.de, npache@redhat.com, mpenttil@redhat.com,
 matthew.brost@intel.com, lyude@redhat.com, lorenzo.stoakes@oracle.com,
 Liam.Howlett@oracle.com, joshua.hahnjy@gmail.com, gourry@gourry.net,
 francois.dugast@intel.com, dev.jain@arm.com, david@redhat.com,
 dakr@kernel.org, byungchul@sk.com, baolin.wang@linux.alibaba.com,
 baohua@kernel.org, apopple@nvidia.com, airlied@gmail.com
References: <20251115001320.6F37CC4CEF1@smtp.kernel.org>
Content-Language: en-US
From: Balbir Singh <balbirs@nvidia.com>
In-Reply-To: <20251115001320.6F37CC4CEF1@smtp.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BYAPR06CA0041.namprd06.prod.outlook.com
 (2603:10b6:a03:14b::18) To PH8PR12MB7277.namprd12.prod.outlook.com
 (2603:10b6:510:223::13)
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH8PR12MB7277:EE_|MN0PR12MB6102:EE_
X-MS-Office365-Filtering-Correlation-Id: c245cf04-849f-49e5-c0cc-08de23dbfe8f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|366016|7416014|10070799003|921020;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?VDh6aDUwUWQ0WkxGUmtQS2tHL1JObis0VUxzZVoxRk5HTHU5ZHBMN25jL05N?=
 =?utf-8?B?MnlPS2pHVkpBZnlkdnViMkdGZjcrSjFHRnBGemxMOFcxR1F6M2RoRjRYVElj?=
 =?utf-8?B?ZFBGV28vR2Y5Z0VkVWNGRFkwR0JLdmlnanFteDJEdU1kSFdMWmFiK20wT2Jo?=
 =?utf-8?B?bkhVUzdRT1VUVExKOSsxREFIWm9MQVlsM2wrMEl5S0FTZGJFRnpwZG1xYW00?=
 =?utf-8?B?OW50K0ovUFVzOWhOVkxSVlpucVkvNmRrQU5SdUlMZ2RndHFtZ1hEMTgyN2F2?=
 =?utf-8?B?SjVvakNRd1Vha2xTTzdwR1B6dG84SHRiakc5eXRXajR4QTRVSDZJdWY2dUZX?=
 =?utf-8?B?V2xyeTd5UzVHV1NGZmdjOUh1eEptRFQ2RGMwQ0VWNThNTndzTlBFZmkrUnBO?=
 =?utf-8?B?aDFMSTFEM1I2WTd2a2FuK2FkTzIyRXY3WCtjb0Q0aEpHZkljdmlHdG0rVTYr?=
 =?utf-8?B?dzF5R3A5M2xyVnRxb0VkRnJRaEM5WHBOOWl2cDJhM25jNEFWUVV0cE9UVmRM?=
 =?utf-8?B?QzlMdFdzcTNrZlNsbGMzVFlLb3VUWW0zRU0weTc5bnFXVTZ0TFJiRmZ6Umlh?=
 =?utf-8?B?ays2OUwvQy9ha0ppM2xnb1kxSEJxWmo3S2daeDdCcXZWYldkR3RKUDBkdER2?=
 =?utf-8?B?Smo5MklaSFB2TG1rVzJ2bjBtczRxbGpvQWdsOXNnRzR6aFJSMTBxOTEwUmVC?=
 =?utf-8?B?Z2xZRzliU2czUjltUU1DOGVLM1BHNysrRCtPdFB6RXpIV0JYNGpqZTRSd0Ir?=
 =?utf-8?B?VFZtUC84U2M2MFQwMENHSDFwcDJlN3AxQnBpV3JYMEV2ODNDTTVyVkErUC90?=
 =?utf-8?B?SGh4YmdJQS9ja3ZkQXl0cVdxLzA2T3FodnYvZE5YeVJVc1ZIRXRBRHp3ODkr?=
 =?utf-8?B?bDdwaE5PNHA2RS9BdXhUcFhySUtFajFoWHZsQ1FGU3FwK0dKTXNraFZVWDVW?=
 =?utf-8?B?aTdTY011aklzMnd0M0pYT3RrNGZtc29BMS9TdXRsbkFQTkw2QkNmZHJZblNL?=
 =?utf-8?B?UDZYK2c0Sy9RcjFoaWtqamZ4cmU2akw0VGw5djEzVVpTSWcvcjcxek40K1BO?=
 =?utf-8?B?VWNKN3JSN3E1YjhFSk5uaHVnNUpkeTBYRG10R1hEcEVjS0tSRVN0Qy9ucXVT?=
 =?utf-8?B?dVRiRGF5d28vVmRmRXJaT2VJbVVZbFlVUnBLSy9mRlV3ZkZJL0orLytOSm5J?=
 =?utf-8?B?ZWtOSzcxUFlqekNQcHpobFB5ZjBOY2d6NzdmZ2lkMFFRcnlXbjNIeTR6YSs5?=
 =?utf-8?B?RnNhck5YZDJtTFp2bU03UXhpdkNteWVwL0M2eXUxWDVDQlVCZm02U3N4WkFm?=
 =?utf-8?B?U0prRGxrb1hRRTRoRmlPUFNvc3QvaGxTUk1zay96YTRCazZqR1RtZzFXMGpW?=
 =?utf-8?B?V3dhSjBtR1hzM05LcWFydndzN3A4K2VTV21DU2pIdW5lOFRXenpIUUdZK0w4?=
 =?utf-8?B?QmxSOFZGRURzc3RZajlYYXgzaEdQKzRCcy9DQ2IzdGhhVHZiMkVLUmtGbWlF?=
 =?utf-8?B?emRQR282UmY2dFVPQ3B4TE8yZjdndWp5N3V3V3BzY2NhcTBKVmpVZVJHQnRO?=
 =?utf-8?B?cGdtU3hiRGQwQmlKOE5VTG5TYVg2aDlTNmNZM21FSVl1QUlXZlpwY1pzTlJh?=
 =?utf-8?B?YldFTGdEaFAwL2ZSdG9BaW9qUnhtNW1GTWNMaGJISzBvd3dMbGR6OVMyaXF6?=
 =?utf-8?B?WVlSNEJ4a1k5dDFaWW1pUG9QSllwVGVEcGtxMlpKMW5uZmx3b2FsdHNFOHN4?=
 =?utf-8?B?OGROZzBxTWtOaThhR0NTNHNKNzJ3dlRkUmlaSW15NWFSUTZUS2g0Q0VIc3Zl?=
 =?utf-8?B?VXVqS25mRUg2NnViWXdvRXVIWmR5UlByeE1XTHFDWVRwSGlUc1M4MmdIZXlY?=
 =?utf-8?B?cDRtdG0xY0xlS3ozUzNiUWo1WGhrU3VtN3dNa2gyMnJSNWR0UW9DVDZVMzdU?=
 =?utf-8?B?eFljVzhkeWR5MUg3eW5pS1BDMXFPY3BDY1g3a3NSaGJRc3ppTHRMWjIwOEZx?=
 =?utf-8?Q?zEKaPKYs7dvTYchh3l46I/LAe9hJ1s=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH8PR12MB7277.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(7416014)(10070799003)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?ZXQ2NFM5dmhFa1NNREJrRTg2OE54dnNRTlFDQmFpRkFVeTNaeVRFaWlHeGZQ?=
 =?utf-8?B?bThjbUpDeTkvUWF1Ujl0akc2SFVLNmtZMVZXYjZraEk0dFJKaE5xWGZ4elU5?=
 =?utf-8?B?WDNiLzZDeFUwY2IyWERLckRlUVZQNkxoRnc3WWFLS1dxenFwTm8rM3VYZUgy?=
 =?utf-8?B?UENmREVCV2NFV3FjTmdaUkNEa3dPSEgyaWp4TzdqSE5NNnNFWklqSXNOS3c1?=
 =?utf-8?B?R2c3NjdBVTdteHNXZVlreWtGTGlZcFhmK0NPdzN6VmNzdmNiR1NzRURjSjVh?=
 =?utf-8?B?bG1SQ1RyekdpZWVreDU2dlVaODA0UWQ4VURUcjM4cHc1NGxud0EyakVjK2dE?=
 =?utf-8?B?QVBiM0VLdEhOV3RlYlRvOFplVEw1UnZmOUFlWDdKZll2QjdHc2dONzY1ZXlZ?=
 =?utf-8?B?dE96V25sVzdKdWtYbWJnV09vL2ZwMnpuM01saUVNQlpkdjZ0azVLNUFmMGxR?=
 =?utf-8?B?TEZNRHNLb0dsZWE3WnkvM01mWWlPSXdaSWJ0ODVmUStSV1Q2bEhKSmxpQWc1?=
 =?utf-8?B?UVRXQmJJOFZBQk4wMmhKYmlmV3dzZUpkZlAwSG1wa0pvWFlnLzFBNlRsTTBs?=
 =?utf-8?B?eEJOeEZ5ZWU4TERKVDhEc2lEYWtkTWgwMzNGRkFlN2liQnRqOFhhNHNIRFlw?=
 =?utf-8?B?RURjait5TUsrRkJTYkE5TmxTMGNEMW9BbnRVRTJOMXlDZ2pCcUhEb05Ea2NS?=
 =?utf-8?B?ME45dFkwb1lySWUyTTdmbG8rNU9ENlQ1OTBXZHcyMk0vaWxGaDB3NkJqWEo1?=
 =?utf-8?B?dysyd0JqK1pjc0JjeW0yQ0ZOTGFNV2EyK29tbXpLOGhTYTRsV25vVEVOcWdj?=
 =?utf-8?B?aUtnQ3lOdnNxbWRidnFpSHdzR1NWWG14V3d2OU52OTc2R21Ka29DSWNyc25E?=
 =?utf-8?B?ZFBWakh4RmNybWpaUEI5dGtkZGZLREsxc0t2THh4MHJCd20zdjRJeHBSdnV0?=
 =?utf-8?B?UVpONkNaUUQ0ZWIwa3hMRFFWR09DOFVNemROUmdVZmh2ZCtBOGVOYUUyZjdF?=
 =?utf-8?B?U0NWVXdPbFJIUjd3eWt2WThrSERGZldqTVNBdXFxdCtrY0U5RzdxSUJjUXhl?=
 =?utf-8?B?SXdnbWZveXR4SnIzb2ZtQ1dTcEFnRDcvTGt5bG45RDJRRHRBd2tPWVRpZ3hI?=
 =?utf-8?B?MDVnL1V0N1VsL3Q5UUlMSnY3R3BZRVFvdkdoVTA3bjhPbFZzWmNXdW9JT21q?=
 =?utf-8?B?aXBXNnNDclMwU25qWW5NNGcwU0UydjZHL3FGaENWWXIvVUdVNnJJcUJPRFNL?=
 =?utf-8?B?aVMwSjZDb05NbWtYTzBzWHluMUJWbFQxeU85VCtmcXZMT1cra2p1YnRmVWQ3?=
 =?utf-8?B?em80c2RTUTBuemRjOVZsSndKKytWS1JlRTZVai9sN3RMYUE5RGdEK0ZwSEZR?=
 =?utf-8?B?Qncxb1RvRHNFZndhb0xQRTZCcEZwYnBPdTZyaHhmYzJqb3pBYzZBSHZyS2ZE?=
 =?utf-8?B?ajNzamVSY0VhZGJHaWJxTUlJZGpmV2RWUDlVMWJmYlpSbDF2bGxLTG9iN0ty?=
 =?utf-8?B?N3MrcjIyYVg1V3k5Y2tXempUYUJPTjBOOHp2WHJmbzBIblVQdVpPMDFiaXZ0?=
 =?utf-8?B?ODBxZU44QmpFaE9oaTAwUW54alpOSWpPVVZNNitpcWVNTDBTMHZaSFpSU0dz?=
 =?utf-8?B?b2xXUTkzNTNlSkl1RVBwdHdiSC9qakVWSnB1VWE5UkVqMEVBTmZyazVGbmto?=
 =?utf-8?B?R0ZqZllMWnd0QVBXc0Vzd0N2VlV1VjluRXZkSUpKQkk1N0V2MWhpTEN1N2JC?=
 =?utf-8?B?S3MyVDZTYVV2T0x3ZW93d3dUZlRneGhOMXovbjlCT04xdzZTK2tSRUI1RnAw?=
 =?utf-8?B?ZmdsUWFRbVBZa2xER0ZFcVVOT21wVTVpZzNEeXhndTJYZmUrRG1wUXM3VW81?=
 =?utf-8?B?TXozY1RFYWdGNUp1RE0rblpvUzZCUXRxQmFoUEVRNVIxY2dPcHF0WnZBaVdu?=
 =?utf-8?B?SXFQMjllN1ZvcUFmcUQwSThOQk1KUUd0LzhXV2srS3d4cGVFZDRjZzlJSFhM?=
 =?utf-8?B?TWtYTFI2K0wwWXlzejBuVUErMG5oTDMwMmxYQU5kd1BTU08vM0tuS2JYS3Fa?=
 =?utf-8?B?dDcvYmdoSGpLL21qOHBrUTIyeVRMZWt6SlYwaUVsdXRoN0hveEQ2RUtnV3ky?=
 =?utf-8?B?QXl6YlpOdzZqK1M1bTZoQmZvcG14YjE2QWoxMlF2anV6UW5rNk9nMi81VHp0?=
 =?utf-8?Q?XcMb4DyYhfkNrQUa5sa8Uwhi24rbYqhA259qNjEsUnpk?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c245cf04-849f-49e5-c0cc-08de23dbfe8f
X-MS-Exchange-CrossTenant-AuthSource: PH8PR12MB7277.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Nov 2025 00:14:51.0537
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ZSR/xXQfYpvXpc/HOw0CYOZ3kuadHHz7d4+QdzXjFFAtJTm/suuxYradJHMC68YxHIsOFBgM/PRKHRSJhQWHyQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR12MB6102

On 11/15/25 11:13, Andrew Morton wrote:
> 
> The patch titled
>      Subject: mm/huge_memory: fix override of entry in remove_migration_pmd
> has been added to the -mm mm-unstable branch.  Its filename is
>      mm-rmap-extend-rmap-and-migration-support-device-private-entries-fix.patch
> 
> This patch will shortly appear at
>      https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-rmap-extend-rmap-and-migration-support-device-private-entries-fix.patch
> 
> This patch will later appear in the mm-unstable branch at
>     git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
> 
> Before you just go and hit "reply", please:
>    a) Consider who else should be cc'ed
>    b) Prefer to cc a suitable mailing list as well
>    c) Ideally: find the original patch on the mailing list and do a
>       reply-to-all to that, adding suitable additional cc's
> 
> *** Remember to use Documentation/process/submit-checklist.rst when testing your code ***
> 
> The -mm tree is included into linux-next via the mm-everything
> branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
> and is updated there every 2-3 working days
> 

Andrew, sorry I am sending out a better fix for this :( It fixes the issue more generically
and does not require any changes to softleaf)

Balbir
