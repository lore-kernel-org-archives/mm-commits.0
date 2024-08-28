Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 886148288F
	for <mm-commits@vger.kernel.org>; Wed, 28 Aug 2024 08:35:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724834143; cv=fail; b=MdoT/hjSh/Bm5L6dFcTyLO/RdoE5NSRPkEiZLjzh7LGL8uLLcDATpVSWC0lg1SP0yXJZAmB1dNp9yLuBP7pKfzxboooizXmn2wE7em+h2VxSNsW933ry5OFlOi0AmIsAB8d72RxbjaAqKOa9luMUfUeTldadHRzk/SnLcJASjN8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724834143; c=relaxed/simple;
	bh=Zmry/hGAlot7mKGxj8BWsgSL9p9uVlmUCHAfDK6G6uI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=BO5o0z1mYhzH/XD+ZqrH1bVinhzhZguIbgLKSAETNgq2/7N1UQuVLi8K1zMdqN1b9tuFuTrU0M+hYWzKO2JmWk14mn0dNQSviXksRGmx1tc0a38VgaOAjUnkI5HftxNb2Ew+G3mPr0sOTPokbu2oL4ISOYTopyxJT3A8Vxe4+9w=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=TrrBl+ue; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=Ne1ZyCyG; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="TrrBl+ue";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="Ne1ZyCyG"
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 47S7tVvs000910;
	Wed, 28 Aug 2024 08:35:37 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=
	date:from:to:cc:subject:message-id:references:content-type
	:in-reply-to:mime-version; s=corp-2023-11-20; bh=sjIOAiWp9rFbnnO
	0bNRDMOpkDN4OqVlyhfjsTiIXKAY=; b=TrrBl+ueLqoBT/UrvlwjUfUFQAXh27W
	0y9gnzjGSnO3RtIhvx9cUeBHws+bbWxJhwmDpd5XXv+WR6YcCjFGUF1IGgTNJMuI
	gzk1qT+Fc6tH49IlhveAWCJCBjict6CdX0kbrndTHbMjOa7+ODregi/qCM5Z4awD
	H98T8nTSmbZavVbcsTt46+otUihbV2Sp0Z1pFR4v3mlmJ4gUUJL7R2YalE62N48Z
	b7j/Qt7Kd0ev10UD3O10v7fhfXeb3HRcS/hli65iZQ8RPsEO0FL1eTlif9ALeJR6
	xtoE/IPlt+iCmFKWtnaTnSoK1QIHap6/OWSG9edBfkaxSiz7PNl9k9A==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 419pugrs28-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 28 Aug 2024 08:35:37 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 47S71Vk8034817;
	Wed, 28 Aug 2024 08:35:36 GMT
Received: from nam02-bn1-obe.outbound.protection.outlook.com (mail-bn1nam02lp2045.outbound.protection.outlook.com [104.47.51.45])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4189su6fde-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 28 Aug 2024 08:35:36 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=YHdW653F4+LN6cCU8+0cQxmyMPGFwG2BgJcdjmWuANLrd8rig/XiWSEZf7qHL13X/slFJ48WGzOdmw4m6x1+FU4/VMIC4+Z6DxdAZKXh3uTWzqDt0BThS3+jyJuMOXrVYaqAmf0NeCyKpbntRFY5yhA3o64eUv3ZVCu/1UgJPGktIo+qXVE/nxfgNlPSPa8iCARHNL8XfhCKf83uWe9tV9F+2rFlsTSZS3sjl5jNw9h2ZEI4cG4p8nw1WPwRYpvxeAAlWA39oceB5PzU2cIOO7gNsTry5vk6nw2FtJqG4x2BvRokAhvf7bhRV6zr6zMpxROj0QmQgZgFRwFeWS7umg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=sjIOAiWp9rFbnnO0bNRDMOpkDN4OqVlyhfjsTiIXKAY=;
 b=i4w+HRIgDncbg2e5aguLSqnL6+WDa5mraEHhRPJy3n2/SyfQdJeVHvtEHGcP03PPBdTB31ghYOkfYhIHHg5UKb8wDND+uIOYng9+sv2dpTp1s7kTl/JDRfS9iYS8035qQcw43tTBaLTG/J9pOyUiihxUPe5eO4SOOOB8/sG6WeCY45axIxPG9DlbmZ1tHWUeSuhiEZkZ1NZuBOEcV9XJ/7Ev0/NqYS4Te8vCG3/6ILRoW7mowXT9gZPeEYbUFAKmK03f4WJOlZITncOGStBb4LKmI/4xbGFhPd07N1fkJCf8rpXN+if5LgoDCpNc8L2Zuy3l7BhJ1WOKdK9yJfT42A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sjIOAiWp9rFbnnO0bNRDMOpkDN4OqVlyhfjsTiIXKAY=;
 b=Ne1ZyCyGSHLteGcJXsYba15t88TzUjAbxCJQN3FJRQmKtOWykoXWvzjgtMvYk6q000vKcCv1YJm/X0WfNTPvWCX6vZPtsLDfoROO9znB87vezFK2cZcWr6LiNkzprOcLGnx+MlCkoM54GxUkXPO21mmZWnm0Qpv4OmeNp+kvGeM=
Received: from SJ0PR10MB5613.namprd10.prod.outlook.com (2603:10b6:a03:3d0::5)
 by SA1PR10MB7698.namprd10.prod.outlook.com (2603:10b6:806:38f::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7918.19; Wed, 28 Aug
 2024 08:35:33 +0000
Received: from SJ0PR10MB5613.namprd10.prod.outlook.com
 ([fe80::4239:cf6f:9caa:940e]) by SJ0PR10MB5613.namprd10.prod.outlook.com
 ([fe80::4239:cf6f:9caa:940e%5]) with mapi id 15.20.7918.017; Wed, 28 Aug 2024
 08:35:33 +0000
Date: Wed, 28 Aug 2024 09:33:15 +0100
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: mm-commits@vger.kernel.org, sj@kernel.org,
        Liam Howlett <liam.howlett@oracle.com>
Subject: Re: + mm-remove-duplicated-include-in-vma_internalh-fix.patch added
 to mm-unstable branch
Message-ID: <d898ce04-3231-441e-98eb-ceacbef930f6@lucifer.local>
References: <20240828025612.79FCAC4AF11@smtp.kernel.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240828025612.79FCAC4AF11@smtp.kernel.org>
X-ClientProxiedBy: LO6P123CA0012.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:338::18) To SJ0PR10MB5613.namprd10.prod.outlook.com
 (2603:10b6:a03:3d0::5)
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ0PR10MB5613:EE_|SA1PR10MB7698:EE_
X-MS-Office365-Filtering-Correlation-Id: affe94d6-fa4b-4919-5278-08dcc73c61a3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?0noF084IogO88PTRpd0yxUNmYA26FQapYJwy5zBVCmO4ntloK7NCdHI/I4K8?=
 =?us-ascii?Q?g9ORqJhzxUg51sjEJpAwreLotzcfHJJC4z5LBHJGdKpf1tVsAjorIQQ4sZLJ?=
 =?us-ascii?Q?31OXtjItPPwnkhAK/Vn0YCKhN59AFDPpiYBa92+zB7nSw6PuCb8vIQV6s1XI?=
 =?us-ascii?Q?50btunyKMjMytYUZtwp4kTCIM1vuhjiapAcvbwGcZOAmAJZQFjD/5UWNByE8?=
 =?us-ascii?Q?0h9H+QHL4wfoOUGFSXtlEOvwomZQJOZaJONvnC/lhirpdKRHCeqmwVr7WhqA?=
 =?us-ascii?Q?UIHo4yLAFs0aAWRB5e6yfoGq5vVgOCTsZNcfANY63mEbp7Oiax/CeDfTcmuA?=
 =?us-ascii?Q?KCZvqTkgVITcehHfNC2aOApvzdyrVORE21Kkfh/sdL6o+YYu1ID/jXoDFQsx?=
 =?us-ascii?Q?/0S3C5zuptZ1SwaB6xqv8eMqsoR/JLvwsY+E3ZPDTB+4CzZ8RS0PeOaU6JR6?=
 =?us-ascii?Q?fYVdPjyVica6hmvDHmcvyOxsLAqh+tjr5HqKoKt/+U8uBuzfXS81MKpCNrlh?=
 =?us-ascii?Q?/yqALWzZQqIcAtKHzDu4KlL1MidgUyI+h26WBWWfN2wGwrrKKywLxK9BeMme?=
 =?us-ascii?Q?zfEFiSePaeB8iBUbzGtikTHDk6hTIyw1muQJowf28EA1vXEIVzIoUe0EhZ3Q?=
 =?us-ascii?Q?KEOqkwnrY/qC4ukqT9r2j0GrSM7GI59gteY8N5fMD/IMWWDDS8U+YOcohQY0?=
 =?us-ascii?Q?FFZMj1LuKH35J6osmZyxSNJCEQzYC8eK9NGmc2ssZ7fvO63dadeLwumMSQ1h?=
 =?us-ascii?Q?LBTGLa5lkfsF3qMiGhSK4ddQ0hZm0Pb4pnLFdflNw593T6mw5qfd59m2foQ9?=
 =?us-ascii?Q?2jGqka/ysZXcrGUXgy2kL/UlPTO/eBFIV0en+WeGz618/qw0DCCV0PGloERs?=
 =?us-ascii?Q?Sk559q196RI1wn7Z5mlcE3iO7YMU6+qfgYjhRXcGB3om+QXDBRBlE1zbwNv9?=
 =?us-ascii?Q?7FEqFbZQfWHxKw+aCQiLp+V+27Iuwl8v4GcSLTG1ygOXN70VDX6oz8neXdbQ?=
 =?us-ascii?Q?XFIqFbK7GfWx+E5ZnaD71hgiWN7/X6nvQXdbY9yr5cpOcVyYUkd712JGypPC?=
 =?us-ascii?Q?XyMo8uij1eVstO7d6zEKIFvl895KwrOYMiIOqk42RPPzppt3i82VvjMRKH39?=
 =?us-ascii?Q?kAM5qi5O6sDbXGKntzVdMvigZeGVvvTvTcTqJfNC3sX6V1TIJBIJpwlxhDpN?=
 =?us-ascii?Q?dMp0k3UHN8UW2SVWWpsiGlrU9gyL7AADKcouGpFZXS58nI/APlmOmkYCrKx9?=
 =?us-ascii?Q?B6/w4Vb8h+HcbnW1Xj/lopHaxn713PNgdVSelnNnZ4UGBCIWRoSSVP5QDHaT?=
 =?us-ascii?Q?VVTanOqgN9rH4orZqlaosm89?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR10MB5613.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?SuHBszPwIuRQUvkckt0/v5RygG//IB1iSl5tQugxH5SdjedfY0G/8iSjFyfC?=
 =?us-ascii?Q?w4u1TnG6QgCJXdkXx1B30aEEqrgoCHIietKCNp4ZeqbZNLObe78S9bly/Znp?=
 =?us-ascii?Q?g5vhCxQIh9mTnFCM+3ZpOyTQ3FonRWM/DGEKARGNPJ0eOFafp9/6YIYsWnH5?=
 =?us-ascii?Q?R+86PHz1tRVz9cdguKQTnREikXf4aiXeUnREY1lipys3bLgSsMc+zvuU3GXp?=
 =?us-ascii?Q?9BdgR/XqimS9PUkUAGn6K4LjipH0rSTCIw/+tOw7BdfqMwqZ4E9cqCXYPSTC?=
 =?us-ascii?Q?u0JV+Ll28xYg0mBMtVaFn4uaRY83Lle/fDVu8X1DaxkTYR+KEwN/NOYNQgcE?=
 =?us-ascii?Q?pM2OO+CNBF4YTrFAl2aAIUngOBRbDJ07eE7EzR5tkU+qQQj8GVWhAMm8pTSm?=
 =?us-ascii?Q?OhN7wRQQsqpOV/F/SUK3LvQFDARJtUOZQ2BYr87G0T/jT+BJo/JVOFCi2nXU?=
 =?us-ascii?Q?FQ2mgocc3FsV1XPf4ivVvUjAZPN+AqFyfgZYV2WrWb2mBKuMgNelMbQ6mFDt?=
 =?us-ascii?Q?EBCMY9llXJ52D2EvSsaptUah6UCH/INtRnVwfJY4dMWmu0Uuz5xVnGQhav2p?=
 =?us-ascii?Q?6YZxEs90Iw5UL3TNcUPNPKP+n9zp0vw1NxVOmyPmJeOgPO99dQY9nBpxH6Fa?=
 =?us-ascii?Q?LYocxyn8i2W/RDngri0We037vF0DhCdCxSO+YvFyh3atPVCz89WA/Hmx1dJ4?=
 =?us-ascii?Q?7X6EprF5jTuzLzrm6VxztEDWViC8nempRwqfeFJG0zjaTGseZyjtKoiKs3Af?=
 =?us-ascii?Q?V0c/larY9p20IAeqREkTJE4gvlopEUoqBzULl7tJBbFj6fJ8TVE6+hjmVlI3?=
 =?us-ascii?Q?/xOHq6mfKOIz7AUL7RjMr7g34fQ1wce+VOIAU9BMQnqhZZwLxu2jybm5uyO3?=
 =?us-ascii?Q?2uI+yYwaLB/j2gSypnX5r7TyW7ikAxOA+gorclFZpp+ra4pMiQFSrjvWfvJP?=
 =?us-ascii?Q?OyiaXaeJUKDrj+8tpO6XCRiefay9L+0a0oPOXzFBidczavv/1RL4Ex6viqIA?=
 =?us-ascii?Q?2iu/qT6+weOYA2DkFgy3ZicgECYFMmJi29s2JSV3O+512issC2qOnIOoz19T?=
 =?us-ascii?Q?MBgsCFBd/xGh4TQyecHJQxyxuKFUD4Hj+Er+pyZgis/OZN5GZUrkPTjnZDS2?=
 =?us-ascii?Q?d3PfIrtQ0u2AMRkDo+HmgHgPAG6oqYT/03qeRD9nxi41T2eSJbxvstG4zxwY?=
 =?us-ascii?Q?114oEEfxSG7mOm7wMufa9wVIR8IsoVeTwZHQhwGDl1ZSXmO0wDC+Ze1+wAJU?=
 =?us-ascii?Q?EPg4WJaAodUXCwsheFkkjFEouT6GJ68owbKP49TvG2YmXg+QHsuQv5tXAY5D?=
 =?us-ascii?Q?L65pW/bygCEh9jR85jL5WTAorSpCz8agDVys5l9dqckXCOc9T8EoQIJ7ISTZ?=
 =?us-ascii?Q?4iXmRpORRz+eci2rNWULDaHTbkrlbr9/WQhGe2GMPxGfbaAo7ufYGW+xCgpc?=
 =?us-ascii?Q?JXY8fSIvX3QjnYRBzd38AW3xRt1nubsE/UnT1an8DSawkJr6qurAcdVJh6dX?=
 =?us-ascii?Q?iVxhub9sxStN44rYQ3gwwobCYUNRGevGs6QkmDazWVXclS59vynq2irqWH/1?=
 =?us-ascii?Q?/jidKx7Pc6Xh38pk88OxSvpMoXYoPpMiNf/cLl58/pMVPnXZKZuyDpr2Dl+f?=
 =?us-ascii?Q?Nw=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	vkDOmw+JAknYJNq1vzIyl25iJS3M366sD7Quc73SqKUIFmfj923EApgjPViep/tB9epqVB4wFZUSAU/ZvOZO4Q+dirbOXo3btYTUUyLR5TwsicNYRC/rUI7WUhWFdoJwHJXNhhsElAfPjRR8iAmcaMRNQScptburXT1o4pZipS9pS5aaRO99LTeXp3KBgUjMmUWkXmuh92k56As2de3uhVIQ1/ZUk5g5YBkclhhsoxYT8YZYfRPec46eeKOyl1J5olFoGR7axKT/S/lOL18qo3e7vBvI/khRRtwzS4XI+ITq3UPXENimnmpIvTrZIYdCdC7LtOrlS9GdLmNmYHvQLNBcIasNphQaLXeBjSrAFilnlR9sdSTSceCr/Aisi+H6Wzfap/c8LDcyhlZTfJ06jxp4Wh8BEHml5kQzXfw20IiNk9/FbKyfNW4hwoAcR11o/vGA5rzhuL7w3SPQFAYWwWYT8OEtRd9tyjw1ohgisA49UoUp5/CuwsipLY8AA1beavujuC4zHE+oMtMGVv7ivFhyqi/7P4u5voLEOC1Fj7hPr3S0/noPKi/dK1pDcHnBo2OYZTZGzY0Jk7hSNUfCpJHUo9Y/qJL61Wa2CoUUQwM=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: affe94d6-fa4b-4919-5278-08dcc73c61a3
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR10MB5613.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Aug 2024 08:35:33.0487
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: yYKtzSJPFztZlMMSuL0GDInIpxTtikrX7jeWwvEe5DuK3LvK+a2Fq9X5NXCJpHQINoDQPaJ6Fq/kdH1ej2qRz8c9z293Yg1lDHgrb7ZQdAE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR10MB7698
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-08-28_03,2024-08-27_01,2024-05-17_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 spamscore=0 suspectscore=0
 mlxlogscore=999 malwarescore=0 bulkscore=0 phishscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2407110000
 definitions=main-2408280060
X-Proofpoint-GUID: adsFQGh-QyN4ZUuNEgENmFtcNaTeiMPh
X-Proofpoint-ORIG-GUID: adsFQGh-QyN4ZUuNEgENmFtcNaTeiMPh

On Tue, Aug 27, 2024 at 07:56:11PM GMT, Andrew Morton wrote:
>
> The patch titled
>      Subject: mm: fixup vma.h for nommu
> has been added to the -mm mm-unstable branch.  Its filename is
>      mm-remove-duplicated-include-in-vma_internalh-fix.patch
>
> This patch will shortly appear at
>      https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-remove-duplicated-include-in-vma_internalh-fix.patch
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
> ------------------------------------------------------
> From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
> Subject: mm: fixup vma.h for nommu
> Date: Sun, 25 Aug 2024 12:29:47 +0100
>
> Some series of includes result in vma.h being imported by nommu under
> certain circumstances, which references FIRST_USER_ADDRESS and
> USER_PGTABLES_CEILING, neither of which are necessarily defined in a nommu
> scenario.
>
> Work around this by wrapping the inline function which references these
> (init_vma_munmap()) in an #ifdef CONFIG_MMU.
>
> Link: https://lkml.kernel.org/r/7d0ea994-f750-49c5-b392-ae7117369cf3@lucifer.local
> Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
> Reported-by: SeongJae Park <sj@kernel.org>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> ---
>
>  mm/vma.h |    2 ++
>  1 file changed, 2 insertions(+)
>
> --- a/mm/vma.h~mm-remove-duplicated-include-in-vma_internalh-fix
> +++ a/mm/vma.h
> @@ -225,6 +225,7 @@ static inline int vma_iter_store_gfp(str
>  }
>
>
> +#ifdef CONFIG_MMU
>  /*
>   * These three helpers classifies VMAs for virtual memory accounting.
>   */
> @@ -255,6 +256,7 @@ static inline bool is_data_mapping(vm_fl
>  {
>  	return (flags & (VM_WRITE | VM_SHARED | VM_STACK)) == VM_WRITE;
>  }
> +#endif
>

Something's gone horribly wrong here! This ifdef is not meant to be here
but rather around init_vma_munmap() as shown in fix patch in [0].

I'm not sure how the patch got mangled like this.

Could we replace this bogus patch with the correct one? Thanks!


[0]: https://lore.kernel.org/all/7d0ea994-f750-49c5-b392-ae7117369cf3@lucifer.local/


>
>  static inline void vma_iter_config(struct vma_iterator *vmi,
> _
>
> Patches currently in -mm which might be from lorenzo.stoakes@oracle.com are
>
> userfaultfd-move-core-vma-manipulation-logic-to-mm-userfaultfdc.patch
> userfaultfd-move-core-vma-manipulation-logic-to-mm-userfaultfdc-fix.patch
> mm-move-vma_modify-and-helpers-to-internal-header.patch
> mm-move-vma_shrink-vma_expand-to-internal-header.patch
> mm-move-internal-core-vma-manipulation-functions-to-own-file.patch
> maintainers-add-entry-for-new-vma-files.patch
> tools-separate-out-shared-radix-tree-components.patch
> tools-add-skeleton-code-for-userland-testing-of-vma-logic.patch
> mm-remove-duplicated-include-in-vma_internalh-fix.patch
> mm-vma-track-start-and-end-for-munmap-in-vma_munmap_struct-fix.patch
> tools-improve-vma-test-makefile.patch
> tools-add-vma-merge-tests.patch
> mm-introduce-vma_merge_struct-and-abstract-vma_mergevma_modify.patch
> mm-remove-duplicated-open-coded-vma-policy-check.patch
> mm-abstract-vma_expand-to-use-vma_merge_struct.patch
> mm-avoid-using-vma_merge-for-new-vmas.patch
> mm-avoid-using-vma_merge-for-new-vmas-fix.patch
> mm-make-vma_prepare-and-friends-static-and-internal-to-vmac.patch
> mm-introduce-commit_merge-abstracting-final-commit-of-merge.patch
> mm-refactor-vma_merge-into-modify-only-vma_merge_existing_range.patch
> mm-rework-vm_ops-close-handling-on-vma-merge.patch
>
