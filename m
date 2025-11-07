Received: from SN4PR0501CU005.outbound.protection.outlook.com (mail-southcentralusazon11011062.outbound.protection.outlook.com [40.93.194.62])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB80A548EE
	for <mm-commits@vger.kernel.org>; Fri,  7 Nov 2025 00:42:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.194.62
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762476170; cv=fail; b=eOIQDuO9wk5tijOB0WrnkxjMMmM5E44d7Tv+WBTq09TFj5JiJUBjB/Gpjsc+VbGQRLprDOelAQriFTPeAPAp1sgJJmtr0zlPL092l7cO87nxPdPLiFnOQA8wDpk70nH7qWEhwnw73/U5VAfYZiWYUR7TrrMKVng8FlR3wnoODy0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762476170; c=relaxed/simple;
	bh=xZ3q1IHgYvKAwqvIs+jqZgGvu5XsDEo41dTjEs8cHt0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=EeGvgUziDKEPYlXvhU8X9mJiJrByiY68i1E9q2StOSdy5ToGbIf07nXevuf2vVL8fd9UWxyka+3wlsL7lQEeFNAt82QCrO29kPOBDzJHx5hbRoEw/cfYavllJf0BMVoT3mrZsF3ZPXtT+qc1gvSQdSeIoppta+pFKRAzXMfFq+U=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=ZEfn0UW3; arc=fail smtp.client-ip=40.93.194.62
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="ZEfn0UW3"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=u8OF337Fujo8/Yf/0zDeKJqsHHeWfSvnFRln8SALAMpeZ6EWw5ef2sQLerMRIZ0Qy588gizRcwwnTJC9ILZ5IKp6icBb3Ku2VbSahmoXmTr4o06Wgaik2gT2/SuJY4nid1Bw4l1F6gOD6OD+6Kh73NKRciFmw0vfIUrviWFWQ91ScoElyVUHygnb1r2CQOSEIeMPARJVH6k2iWJYqbWKVInROeUu22wRFq6k1enSmrMKnh0icDKKoTkur98vyNyV5/UyhPoXi4FbvviNb/GTOnrj4LSrWZOUpWAHFVorPlRr7YEZgrZInQT3U1SmC63vSWr5DXU+zYOpbFvEPuq15g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jvb9qpluJQi3qeJSfhtAv2jVoOUEWTTkfzDZjXxbYRs=;
 b=RsrDh7wB3Uo5dEAicCB5nrA4ApayZvNKe5NBpYr2z2eY6ufXgk7G5g/YrtPmEmrgoRSrTnPLv7FmUhFMKR68GDy6R11N1AAB8s+yd9GlM4uixpgX3zA9Og9pE7+Xvx/c+uAGuseUOiuEIYbEjNQxzhrjPPSsq4IpfPMjBkRYYiy8iBXwwtW20CAaXpEEaVfnnP1bOVQ+RZcRZihASs8wZ2d99ycCTBi1qA4UtLAuuuy5AT5NHNmbgWo7nG71MC0d2vjDK5UH/yllie5uYAo7/IqU0ocUrlcm8wzNAksKvEZpNuRSE7T8IecFXTeqb4OEK+zBZerjOGd1VBOhCwU6dA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jvb9qpluJQi3qeJSfhtAv2jVoOUEWTTkfzDZjXxbYRs=;
 b=ZEfn0UW3dkT4pEKGZTdIKW290mBzNLY2LjObNmORRpcFhpsQACtKO90kIWpM7gHuqp+TIOa9QW/1YCXwcoLQ4IOiYz+TQEbcooyprZBRS900DXveMMJQXKABpDz7lFE8RltttwnVjzZX1EbVH9deo+0giAb1H79UvJZnOZUc3b2vVBMVMcS+HnANsKynVwyK+FobBhLnwRwO/F5ueRibJpZGERWsStmNWNpyQOXYiRuFE3UCZWrgECo6CTjR0nGPgm7rWwnv04AZ/AojGtes6ycTrFKhCp6MjhKc+dROjLqXl5v0w6JxPfD508AsW/vkav/Yo6TkzAVoaXy9NXIFsg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 PH0PR12MB8774.namprd12.prod.outlook.com (2603:10b6:510:28e::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9298.8; Fri, 7 Nov
 2025 00:42:44 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::5189:ecec:d84a:133a]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::5189:ecec:d84a:133a%5]) with mapi id 15.20.9298.010; Fri, 7 Nov 2025
 00:42:44 +0000
From: Zi Yan <ziy@nvidia.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: mm-commits@vger.kernel.org, ying.huang@linux.alibaba.com,
 rakie.kim@sk.com, matthew.brost@intel.com, joshua.hahnjy@gmail.com,
 gourry@gourry.net, david@kernel.org, byungchul@sk.com, apopple@nvidia.com,
 willy@infradead.org
Subject: Re: + migrate-optimise-alloc_migration_target.patch added to mm-new
 branch
Date: Thu, 06 Nov 2025 19:42:41 -0500
X-Mailer: MailMate (2.0r6283)
Message-ID: <26E8FF35-503E-4F14-98F7-7B4FA25FBD37@nvidia.com>
In-Reply-To: <20251106234221.71A93C19422@smtp.kernel.org>
References: <20251106234221.71A93C19422@smtp.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-ClientProxiedBy: BLAPR05CA0020.namprd05.prod.outlook.com
 (2603:10b6:208:36e::23) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|PH0PR12MB8774:EE_
X-MS-Office365-Filtering-Correlation-Id: bb6e0ff8-7443-4272-164b-08de1d969074
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|7416014|376014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?aDdsVUwremJJNHFqcEFrRFpZWGxXckhxanQvQmVUUFZTWEtaci9JOWQ5bURp?=
 =?utf-8?B?NzRSaDVHaVV2eTFycVg4eGN3Q0RYLzB4VFJjb0Z4M285WkVkaHAzYThBcXdF?=
 =?utf-8?B?Q09uYk1IRjhXd3NpdEF2TGVmYnM1VStuVTgwdEtJbjVoS2xaTjBiUGpiN0tH?=
 =?utf-8?B?c1RoaWZTVnRDY0tLU283TW8xNWRzUUtRWGtFMnhHYmdwcllqbnJ2MGxkd3M5?=
 =?utf-8?B?djFzN1N3ZVZKNmxkeDdSLzd3R0NCQ1E4REFBMlBzeWUxYm10VHpSS09veGtL?=
 =?utf-8?B?c215VkFDcVJ4Q1BuNWRZamFXTkdlSCtERU9Vcjh5RlIyTk5IUHJYdjlvWld1?=
 =?utf-8?B?akNsRlh3ejdJQ2FBWS80M0UxRVZ2NnRBME84ZlRHa2srcDRuV3FyT0FtRzBj?=
 =?utf-8?B?RGt0aUZRa2lBdHJBRElrb1dXczV0OGZoNTRsS3Z2bklzT0kzNEtPek4vNTdi?=
 =?utf-8?B?M2cxMjNocU1YNUY1US85cjFPc3FCVmlaY0FRNW1rM1pMSWZmUENzQzVDRUJV?=
 =?utf-8?B?bmVSNDJlNlZ0L0hlbFJMNWY4ZTlydDFITGYyMFNtNFgzYWh2VDlWeE9KU3pC?=
 =?utf-8?B?LzZoNmh4bHFFeURNLzNOWGxJMTc3MVkzbi9NV2NqT2VRVnhTNjJhdnloYW43?=
 =?utf-8?B?M1UrZUoyWUU0b2tUYVRUejlMb05OWnRuNC9xcGVGdy9vcEx3THpmTjJiK1Qw?=
 =?utf-8?B?S28xRC83dVcwL2FTcTdFd0J5TTZtYURTWWpwejYyRFkzdTMzWjE5RFN4Z1ZR?=
 =?utf-8?B?Tzh0N1ExV09XRzBjMUFMU1RaTWs0ejIwNnZmd1IvYVFIRjNYZkRjdDB1ajZL?=
 =?utf-8?B?Uy9UNWIrQStBMERhSVJVdERMR2dxM3lTbzVTUFBqL0JwSVBqZ0E3TVpaUGFz?=
 =?utf-8?B?d2hiT2hOSTI4dFJyNkwwQjh4aUhQNks1VmNmWnNMMmtmV2EyVnlCRFJlVUhE?=
 =?utf-8?B?dFYxckxPY3ZZRndyYnRHSC9XWmsxNHJMN3VYWkpGVmRGODFZbEhlZ1g4czVJ?=
 =?utf-8?B?NGtBNllHbjhpNm1tUlhwZmJWZFo3SVlJM2lnZjUrelZuaUR6REZQVTFBbVJF?=
 =?utf-8?B?TDVIYmRDMC9lNmJsT2djZ1Z2MDdTdjNkZUJLOVBoOENpaGNkQW9taXRyRVln?=
 =?utf-8?B?enh5SVIrcVZaQkRPV3gzbnd4aUlXdS9EaUFkQmw3MzhaTGgzSVhGcW5qV1NE?=
 =?utf-8?B?NGVtVW5jdEVlN1lSYnQ4MStBUXhGeEYyTU1aNkltdzJjRTJFTTF3c3RzU3N3?=
 =?utf-8?B?NC8zaWMzMUJPSkpja0c2azFzanRhM09xSjBhZ1RQdmkxU1N2Y3Q4WFIxMEEr?=
 =?utf-8?B?SHM4d0hobHgxOVhqSi94Zm1jazB0ZUxZZnpDWEVvbnBrd0tqeC9GT0VmdUVy?=
 =?utf-8?B?OXdmaUFWZTNORXFLV2VPSzdhWUJDQzhrWGRMZEdEVWEvcE0weXV6WG1GdElk?=
 =?utf-8?B?NXk5N3Nocy9mMzVVcDFXUGdTTGtoVmFaWk5OMWI5Y3NvMzZ2TStJbllYL2VK?=
 =?utf-8?B?TVJrM3dDZTNMelRUN3h0Q2VOT2VzaThUS3dJOGFBaUdLVUpkU3JmdmJuR0Mx?=
 =?utf-8?B?a1cxWGFIcWMwVXBLcEQyb0JQYW9RQ01uSkk0MEphaDhPUEN3d1plRHp1WW9K?=
 =?utf-8?B?emJFd2RrUjFxbVRvRXp3Zi8rNHJQRU5iT1ZmMi95UWI3UjZiRzNyOGhvYnpB?=
 =?utf-8?B?aFZ3R1ZlcTF0QjNEN0RQL3FSWG9mdzUxUFBHdDA3Y1ZwRmd5ZGx2SC9xeVRD?=
 =?utf-8?B?SThnNGNTa0gwNDNtVG92SFptcXIrQ3hvcmJ4RkRpOW15amtzRU9yRU1yZlpL?=
 =?utf-8?B?SmFOT1dvT3IrUnJNWGpZTC9wOXdzNllNdmJOOHJoTzkyZm4vaWpKQ3ZtbXZy?=
 =?utf-8?B?VXF2Mm1FdkdEWEdUR0pLVkI2SUpnYTBRVGNEK2NRVFc5OGE1TC9xU2xwVEZQ?=
 =?utf-8?B?N2NTWXJUKzlWZU0xVC9NZ2UxbzV5dzFSZlJDa2hrNlhGTll1Mk5tK2VCSnN0?=
 =?utf-8?B?b1h1MThvZjFBPT0=?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?SEhMQTZzdW41T3VVNXorRXpUM25mcVRQZ1dCZW9oWUEyMnVtTlE1UExPZmti?=
 =?utf-8?B?RHltS1pNcVBkMFNXR25yTE1iTzA3My81cjE3dmxDRnJrUVBPZlFuVEs5UDFJ?=
 =?utf-8?B?T25TajJPRXRmelM5SGhkZ3hHWlpoZFJVd1BqOEswNXpwN3RUSTJsUVVpYWdy?=
 =?utf-8?B?dFd3ZXh3UEEwY1FHRnMzTytDblJBdlZGZkJkTXlxamF3MFdTWE5EUmpaVjk4?=
 =?utf-8?B?Ulk0c002cHNUY05IcWxVa0hSUTU2ZTFKalhRTmhmYmkrZkpqblFjSGFNK2VB?=
 =?utf-8?B?dXhKQUIzWU5DLzZUWUFyR1k1QW9tMjl3TXdBaTRYcFFPNFFpOVpzZDdXNkty?=
 =?utf-8?B?TFkzVHI1T3p4MyszQWpBbDQyZTJZc00xSmR6ZmhKdVZlMHF5YS80WmtNdnVx?=
 =?utf-8?B?ZWptb0ZNSktmUDhxM2xMQVc3RHVUY3RyN2ZaMHhuNmRoNWs0dkVQV3VHdnUw?=
 =?utf-8?B?SGFkdTlYdVduVUVwZklWR08xS1MwbDZtcDFKQmZUdithMzdpRE1MYUgrZE5Q?=
 =?utf-8?B?eUQveGYvM1oxUEtLUFgyS3ZVSTFyS0FoNHR4aVBZMFBlWWFJSU9WT0RXS3Rv?=
 =?utf-8?B?Z1JBYUd4dEhkTUYzWUk1K1F1Y2xvb3VjK2x3ejhCK2pJcmZNUzBDZ0hDR0Fs?=
 =?utf-8?B?OGYrbTFPZGNDTWJxYi8ySWZieEJVeGgzSE9hYUl0dmJ2WE5hV21QelhDanRh?=
 =?utf-8?B?L1B6MGpXVEJwbHQrVzZJdE9HRUlpSmZNOFpTRytINHgzNlVFTHppdjdraVBT?=
 =?utf-8?B?by9zT1dHV0N1LzdXbS9vTGk4VmtIRnd3M0hsSlhXc25xN25sUS80aFF0d2dT?=
 =?utf-8?B?NVlQUkhOZzBzT2NERC9nSkJsTVJ2QVlGVTJuRElrVXdEZTNLb21mVW5peU5v?=
 =?utf-8?B?WnFGekNNOEhYeFpKM0ZVZlI4WkF3ekxPUzlnRHpnQit3VG1JeFF1UEZVcUlG?=
 =?utf-8?B?OUxRZmVJZHBkRTFYVmo0RnFlYm1malJIVjNOeDRCMEN1UE1VSEg1WmV0QTh6?=
 =?utf-8?B?L3hWNk16cnN1RXFCOUJoSHZjcWoyQ0NBS2U3alFNdlAwbUdmSFVzSHROUWlM?=
 =?utf-8?B?MG1TVE4yT25LenVFejdwMSsxWmtFd2pUY0E4Z3I0MCtpTDc1OXdOcGRscWtj?=
 =?utf-8?B?Nm5PbWFuMHpkTGxhbEtmRlFDUmd1V3dqQXNhWWlhdWlRdmJDV1JxRVZITzEw?=
 =?utf-8?B?SjllNEU5aVVnUXgyZU0xWGx4MWJRYUJDM2REV1hwUW42M2d0b3dDdDRKdXYz?=
 =?utf-8?B?T09scXNHU3U4ZG85Z3lSUllZN0FkMkRBL0hsSFJVcVlxUW9wQ1B1ekV4UDl2?=
 =?utf-8?B?cHpXMHNLV1k3YVVyY1ZQRWE5MVVWSFp5S0trY21Na1FWZldZaXVFa3ZBUXJ3?=
 =?utf-8?B?eGU2QUZhUGtSM3JyVldaaTBXTUVMK0xXWkxlVjlTK2pLNzNxby9WN2c5aG5P?=
 =?utf-8?B?N2FhQ2lGRFVKUWZSVjN0NGhTMTZLcTE5TkEvcEpsRHJ3SDVwSzJsQSs2Ty9h?=
 =?utf-8?B?dE0wd1pGb0ZkOTFVcTdwRUoySkY3OW0wSnYyZmZ6cjNadC92UmZVTnkzdEN0?=
 =?utf-8?B?THpZc0xFSUY0MC9qSFU1QTcvM2pFZUVhSTBPWWNEZ0VuVXByRndwOHlFWXln?=
 =?utf-8?B?UHBYRDdVaUZObG5DRVBmTkFoQlE4VkZ1MG1SdVhtT29CRzZsQWhKNnlSNTR6?=
 =?utf-8?B?T1NFMFVuY1VBU1p4YUxBakoxUmZNNFQyT3dURnJHbUFYOEYzNHhTbmpCV25H?=
 =?utf-8?B?M2ZSeVNmYjdzT3MrOEozU2NCSlFqUHlBRENjZTFFa1pUZGw1bmJCMy9oSjRs?=
 =?utf-8?B?SThGcXhZKzV1MUlzQ2NKNTBrK25jSmFNb3o3YkJkN2JWR1QxU3NTUTkxbzlp?=
 =?utf-8?B?amZjS2tHQmtnQmM0UDFaMUtZVGdDZHRTOXVmdlZINFNTd3drTXQ1L2draUJT?=
 =?utf-8?B?WHZhYStGQUZIR1hFYnZrWGVEVldibTZtRjJ5Y3h0bFlkY29wM0NoNzZCZWlD?=
 =?utf-8?B?U0o5a1h5Vmh2Y1gvZDh5aEthMCtrc3BuSFRBbEtGSGM1K0RsVDNmV21VYzda?=
 =?utf-8?B?U1ZMZmRaRE81bGtLdjBxeUd2YXcrTTVwZ1AvSzFWbmVpUUFrTENWcGxFYys1?=
 =?utf-8?Q?iDqfXbMibjgvWbawH7rWXdpdZ?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bb6e0ff8-7443-4272-164b-08de1d969074
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Nov 2025 00:42:44.2476
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +lgfoZoD83k9yNR3v4+zUoqE0lA0+0SiyLtV+yuHYwiFELUfzeBLDqlrTdgf32QR
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR12MB8774

On 6 Nov 2025, at 18:42, Andrew Morton wrote:

> The patch titled
>      Subject: migrate: optimise alloc_migration_target()
> has been added to the -mm mm-new branch.  Its filename is
>      migrate-optimise-alloc_migration_target.patch
>
> This patch will shortly appear at
>     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/=
patches/migrate-optimise-alloc_migration_target.patch
>
> This patch will later appear in the mm-new branch at
>    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
>
> Note, mm-new is a provisional staging ground for work-in-progress
> patches, and acceptance into mm-new is a notification for others take
> notice and to finish up reviews.  Please do not hesitate to respond to
> review feedback and post updated versions to replace or incrementally
> fixup patches in mm-new.
>
> Before you just go and hit "reply", please:
>    a) Consider who else should be cc'ed
>    b) Prefer to cc a suitable mailing list as well
>    c) Ideally: find the original patch on the mailing list and do a
>       reply-to-all to that, adding suitable additional cc's
>
> *** Remember to use Documentation/process/submit-checklist.rst when testi=
ng your code ***
>
> The -mm tree is included into linux-next via the mm-everything
> branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
> and is updated there every 2-3 working days
>
> ------------------------------------------------------
> From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
> Subject: migrate: optimise alloc_migration_target()
> Date: Thu, 6 Nov 2025 20:14:49 +0000
>
> Extract the zone number directly from the folio instead of using the
> folio's zone number to look up the zone and asking the zone what its
> number is.
>
> Link: https://lkml.kernel.org/r/20251106201452.2292631-2-willy@infradead.=
org
> Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
> Cc: David Hildenbrand <david@kernel.org>
> Cc: Zi Yan <ziy@nvidia.com>
> Cc: Matthew Brost <matthew.brost@intel.com>
> Cc: Joshua Hahn <joshua.hahnjy@gmail.com>
> Cc: Rakie Kim <rakie.kim@sk.com>
> Cc: Byungchul Park <byungchul@sk.com>
> Cc: Gregory Price <gourry@gourry.net>
> Cc: Ying Huang <ying.huang@linux.alibaba.com>
> Cc: Alistair Popple <apopple@nvidia.com>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> ---
>
>  mm/migrate.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> --- a/mm/migrate.c~migrate-optimise-alloc_migration_target
> +++ a/mm/migrate.c
> @@ -2198,7 +2198,7 @@ struct folio *alloc_migration_target(str
>  		gfp_mask |=3D GFP_TRANSHUGE;
>  		order =3D folio_order(src);
>  	}
> -	zidx =3D zone_idx(folio_zone(src));
> +	zidx =3D folio_zonenum(src);

folio_zonenum() returns enum zone_type. It would be better to also
fix zidx=E2=80=99s type.

This fixup could be folded into this patch:

From 33f1e8eb9ca08eb52f055c6bff856a0e081330d2 Mon Sep 17 00:00:00 2001
From: Zi Yan <ziy@nvidia.com>
Date: Thu, 6 Nov 2025 19:41:13 -0500
Subject: [PATCH] mm/migrate: fix zidx type.

Signed-off-by: Zi Yan <ziy@nvidia.com>
---
 mm/migrate.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/migrate.c b/mm/migrate.c
index ceee354ef215..2021866a1065 100644
--- a/mm/migrate.c
+++ b/mm/migrate.c
@@ -2165,7 +2165,7 @@ struct folio *alloc_migration_target(struct folio *sr=
c, unsigned long private)
 	gfp_t gfp_mask;
 	unsigned int order =3D 0;
 	int nid;
-	int zidx;
+	enum zone_type zidx;

 	mtc =3D (struct migration_target_control *)private;
 	gfp_mask =3D mtc->gfp_mask;
--=20
2.51.0



>  	if (is_highmem_idx(zidx) || zidx =3D=3D ZONE_MOVABLE)
>  		gfp_mask |=3D __GFP_HIGHMEM;
>
> _
>
> Patches currently in -mm which might be from willy@infradead.org are
>
> hugetlb-optimise-hugetlb_folio_init_tail_vmemmap.patch
> migrate-optimise-alloc_migration_target.patch
> memory_hotplug-optimise-try_offline_memory_block.patch


Best Regards,
Yan, Zi
