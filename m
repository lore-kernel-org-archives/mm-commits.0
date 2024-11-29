Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D1E4198E74
	for <mm-commits@vger.kernel.org>; Fri, 29 Nov 2024 12:14:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732882477; cv=fail; b=T/dIvKOXbRmW+g/nuiktOGvratsVckJnR/cGuWipc7WDRSSkG5kIRp3aYgIbvznEJBziG3u5RTYGwiZRzy3gj/Fexfh6vl1mK2PhSqDu65hB7kSJq6uj5oBYN2AjAo17hxFHcnUoqMnJ4/ttciPCVq/2oVvSOGVVSXPlcVApUhk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732882477; c=relaxed/simple;
	bh=KlNmR/TfhG3wr5Flcs8wugL7GgMKTfkE1jyJWiptE+I=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=Zup3psQ4IoeGTHqa5NLL/DJzI9amrczx16W9l+jXD3wspOrNGZ7vM38nmlkD+qP5IlIuVpz/89fxVj1rVXLRCRlJ2/DYH93A34xpxF3FSvA5KVRyflWdVg7/ODyY3ot6idXsH8g7DWO6cBwK2S8WfgMHk2xSQqtTV8Qv2e+tsFw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=EFtJEy8T; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=JRWbbkV6; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="EFtJEy8T";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="JRWbbkV6"
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 4AT1fpZ6022215;
	Fri, 29 Nov 2024 12:14:22 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2023-11-20; bh=cfQ5z/Hzuq+iy0Ku3f
	M/BYVfTQoM4toTKAR2A33njHA=; b=EFtJEy8TDQdOEQbKNK0vlj/cGUPOFOtoAP
	MCIuW/423CQ4oxTdPkBvsCgvKStbN1YAAUHO0wyGbMFVJyrI+3dbhxQdyRRWAlSJ
	tThHpkHjOL2HTCPcbqIRRRCB+imOZzdZD2tqSJbYtWKg4MZF8z+rvPL17OaikkwE
	xuyYsqveVnl9tNjJ3e1Wost9LpMAegxQItsDNFtifE7IxjKJL7dUh8WMk4DbyPOH
	5pba8Dcpj5BP/BfF3nH1Lc/KgzP1R3gRyxU7NbuHjpl93CMHIU+Ucy/T87MDfLiJ
	gu6Cd+6HV0/0/5G4aid3jDIqFIMKGFucarn6mRHePatf510vXyBw==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4366xyb8uv-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 29 Nov 2024 12:14:21 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 4ATBVDBX018026;
	Fri, 29 Nov 2024 12:14:20 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2049.outbound.protection.outlook.com [104.47.70.49])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 436706nka7-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 29 Nov 2024 12:14:20 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=UAC/EO81IRjLdC1rHVVwvhMa5wRaWK+x81bErQRtE4rCD3Yc3LZphnz89HTA4yuudSkBuUA0ciFJ4XxWPPJzVOwA0S3NOk5FmkQHqsKmgrokApISiT6BmEnMu0OObCyYoxLME7smyurvrmfN3P5Wjaa7b+b+mEeX6lHJpEp+Hq+9YHmxzg8iMszoSyYsde4Bv7XYhOxjGn66qilo/Zq3vn4/kHEVPfLlTvx46IZXb+PwfMKOmagqS1vPjF0yln5WuKSTjCFOT1gpCiZmA1IviB6DHfH1Yk2o2WZVv8aavRTa25B0fCvP7/tdV0MWUfsf7KUKyQ7PQ5k9VOXO7Nnmew==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=cfQ5z/Hzuq+iy0Ku3fM/BYVfTQoM4toTKAR2A33njHA=;
 b=zJlsAyibG3lyPi7oKUFoHADIs/3177LTGLSEy9MoY0W/LbhTBReJEegWQBGdFGeWu3R6+aZ5EG/FZqQWjhyzUFrJJb3w071AaKgUilXuV7LwXmM4iAIxso6AU/2IfFfHsxc9ifY5HBnhF3iFVlEqOJyvaW9OUZGdRnhRz0Ss5KwKEo/mXeGRTUEMBpeccog88YzZbbjAEEc68JQxSUItOhkn6DCmQS5I1DsfvGwUMbhUphl+UITSQP3YtOB0xQqX/2rVQyrHwIFbFlz4hnC1umBVsmCbWegmnlll4767wOy+FdzlipBvnQTO0itryvbDwIXItnCDi4uARRP6gqcJMw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cfQ5z/Hzuq+iy0Ku3fM/BYVfTQoM4toTKAR2A33njHA=;
 b=JRWbbkV6dAktXkaiEJQCIbgzRufiJy6vgPUby4OiryGHl0yCBsldGldEyyFRzHkUl9QARXn8KHDMu4V24ecfJ9A4NGquUGlWor/dL2MLkQ7FvRxy4GaAyZSVd4Ng7WlhoNVyJRrLeFNb2uujy0PfYxt48esowD427kAgwmAAwY8=
Received: from BYAPR10MB3366.namprd10.prod.outlook.com (2603:10b6:a03:14f::25)
 by SJ2PR10MB7811.namprd10.prod.outlook.com (2603:10b6:a03:56e::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8207.13; Fri, 29 Nov
 2024 12:14:18 +0000
Received: from BYAPR10MB3366.namprd10.prod.outlook.com
 ([fe80::baf2:dff1:d471:1c9]) by BYAPR10MB3366.namprd10.prod.outlook.com
 ([fe80::baf2:dff1:d471:1c9%7]) with mapi id 15.20.8207.010; Fri, 29 Nov 2024
 12:14:18 +0000
Date: Fri, 29 Nov 2024 12:14:15 +0000
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: David Laight <David.Laight@aculab.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        'Jakob Hauser' <jahau@rocketmail.com>,
        "mm-commits@vger.kernel.org" <mm-commits@vger.kernel.org>,
        "willy@infradead.org" <willy@infradead.org>,
        "pedro.falcato@gmail.com" <pedro.falcato@gmail.com>,
        "mjguzik@gmail.com" <mjguzik@gmail.com>,
        "Jason@zx2c4.com" <Jason@zx2c4.com>,
        "hch@infradead.org" <hch@infradead.org>,
        "dan.carpenter@linaro.org" <dan.carpenter@linaro.org>,
        "axboe@kernel.dk" <axboe@kernel.dk>,
        "arnd@kernel.org" <arnd@kernel.org>,
        "andriy.shevchenko@linux.intel.com" <andriy.shevchenko@linux.intel.com>
Subject: Re: + minmaxh-simplify-the-variants-of-clamp.patch added to
 mm-nonmm-unstable branch
Message-ID: <d9052f1c-756d-40d8-874c-ffb36abc36b8@lucifer.local>
References: <20241129111143.DB800C4CECF@smtp.kernel.org>
 <f0db5571-8c0c-4a39-8bea-e802d05deda4@lucifer.local>
 <496cba0483554fa187d2346159157431@AcuMS.aculab.com>
 <15a2907b-530e-4d0d-9b6e-3fc5a290ecc6@lucifer.local>
 <09dfd66250e24faf969ecd6fe2dd764f@AcuMS.aculab.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <09dfd66250e24faf969ecd6fe2dd764f@AcuMS.aculab.com>
X-ClientProxiedBy: LO4P123CA0462.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:1aa::17) To BYAPR10MB3366.namprd10.prod.outlook.com
 (2603:10b6:a03:14f::25)
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BYAPR10MB3366:EE_|SJ2PR10MB7811:EE_
X-MS-Office365-Filtering-Correlation-Id: cb059934-ebe6-40ac-8d8e-08dd106f5979
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014|7416014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?1D5C/Js7VoOZ94o5yzJEF6RSwzJMCvduaAcpoyoCH4854kssP4KjsLLiK/Hz?=
 =?us-ascii?Q?0G/dIoi0mfB6i/Gd37sAHmpv8EkiivB7xEQ76MgFmGipCTxLzcXdI34436aD?=
 =?us-ascii?Q?6lHe5JeLcRuY7+tZtt1lOYbjGFyrzdspPR+/LD0i0NChCDZ5jbHt4Y+2BlK+?=
 =?us-ascii?Q?NHMdN4dhiZb/5zb2kF5GnynOCVn406MOjbISBcPsmjk6KiaL71FPqOqXhnMb?=
 =?us-ascii?Q?k2pl6w1zazz2SFvI+CgnlwTFnU2K51bS0qYNHVpymtt1/yRTCYazH8m/u42I?=
 =?us-ascii?Q?/GtcVuR4bku/JJDpVHR1OAq1v9CNM3kG6imjjuBEMw+tdiLKucef6Twfia0t?=
 =?us-ascii?Q?Mj9eQ818NMqc3KmMKbsYgBE/WNwp6Qs7evY4ft5PxnWsTi3Qf6FHBYHM4ul7?=
 =?us-ascii?Q?dbLopJlkDB6V6NqqNe4h4+pLYj0Cxgty4c5HDjfujAqPinFWVqEmbmHlpybA?=
 =?us-ascii?Q?BBhbdxOB/prBbPHX7ZyhpR3LmEcB4AlKXjM1/FB1iQ4yYLVt0hHk37B6CUzJ?=
 =?us-ascii?Q?MJCoA0GvlgoYBp7Za2l6pqMQj5usYIGcenQAn18e1htZ4mVrHH3QvPPFqACl?=
 =?us-ascii?Q?Lv74nOUzuAy/oNQVhyJbM9eNhF0YbV3NiXw4NvJ1QpK4ZJ+mRvQqX8tj8TPF?=
 =?us-ascii?Q?wki/TNXYdehFUKFjy5c4CcpU48Jq38ufDnzzU625wLPiSip0pTRpVXl10TN1?=
 =?us-ascii?Q?XPqIByb7XTdTbN9H9V/C9BLg7KiSd4oDxcoSrf21WlyxbiKCtlM+lMO1lo9c?=
 =?us-ascii?Q?XGNUApfufyGxoB4t6DXrLC7oiNVSDlKG9+6gW94peKS9S24x6ZR1yzfpTWnV?=
 =?us-ascii?Q?aYtxe9B4dv+6TLE0hi9BErnPRxcJEG4V6TGkeNwGw8I6/CrG6L7DfGCXKCQK?=
 =?us-ascii?Q?rb2r1+GzEgXVpIEJmtC6YAOuFC29iV/G1m5ysgDCcLzr3mOsVRgWHRCL72+l?=
 =?us-ascii?Q?eYASCyRJVMHGUjEdn87RSuk5zrguCd6V+OJSaZBiZpZMlwYiOTMincpMAOdb?=
 =?us-ascii?Q?OUsgdkA17yFPxZf5UVFUoDkDrkiARUtu7y7lBy0AyKzM3499fQCrAgVAHrQC?=
 =?us-ascii?Q?NRIWYPXDmfP1W88UKViD6MPP0goilxF6g86jpTuqVW+zhITx7HO+K1TqnWsL?=
 =?us-ascii?Q?ws2sOpn8D5zj/nWBsaZ1ZBZdg6BwTsx+tjRS3BN7PNZ2gV1FUqGXJ8LNUnBh?=
 =?us-ascii?Q?55HMKQNd5PDM0GIeaYKXcjkrRy0QYKx9L9GMfdrRiv9dyP0SIPt3Sh8rSoj8?=
 =?us-ascii?Q?TaMK87wM2It7ti4upxowiPhGKGtHBIp8omY0ZluHZjvu/iQMFROYLE/u0Fu7?=
 =?us-ascii?Q?EpQYcy7Re97qpihnEZwrhGiNZnKvavx3DQpqWcwBFIg6tA=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR10MB3366.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?eb/4Otfjrf+gtnp4rWWhhe7r5oMZT3JKcogNvjVOwwEsQ4I3fGszLrbEk5Fy?=
 =?us-ascii?Q?NR+lKsFmfZHVXmqiL7HryIltCOKECOI/BTSIE/B134muwUwoaLoSTcTug1HA?=
 =?us-ascii?Q?UOeW9t7lTe78/5oAPmPzf2WffHaR1bVh/qXGk0NRH1P5oS7INEtp1Kh+yNmO?=
 =?us-ascii?Q?QHkVAdij9iLXUCgFuUYHuF6AuuOb0m0buNCkrzQ9P3drSekiRo84UIqIDcwr?=
 =?us-ascii?Q?+f8pdAtwlgLDqTcclS40nB3qhkjj9ySlK1YID3xGv3xh9uGxsIbrKG/bM2B/?=
 =?us-ascii?Q?OV53lvx+TUZsXIOXU1wpxv+12suDc/q6PtHzn07QdQM280mSnSSuUuQEJvIG?=
 =?us-ascii?Q?gfvE9jWYhdAq9k2Hjbpc1d56kbWNySYwmLWnTG5OaGEok/bYsbXLSYBFTrwh?=
 =?us-ascii?Q?/c3mmb7Ewm6u5iqRgXAUJPyZCbWXMFBq0CrBPsichgVMgfZsUM4JbMAH6vpI?=
 =?us-ascii?Q?dcxrEIPrxbdpH5yFt2flhlPG2kTI6G3tL3Eiz80cwmEUsKXzgS5l6zi2+I53?=
 =?us-ascii?Q?O30ZG1wRPn9mijacMteiBXsQzE2hksRKAB2Q2uRO0XZfEW3HjPMm89kU2zwy?=
 =?us-ascii?Q?hLjrRr3d5xWLqqbLup6nH0J3zknwUr0eIdd6K6Q2XcFr2B3I2Z2AbdpPN1PO?=
 =?us-ascii?Q?xla+pL3kE1TJH/3q2VGU1BrAc4UCt7xgH+WMpRsHNNmhYRzKoJ5B64N9gqlS?=
 =?us-ascii?Q?s6ZEsR6mxk1lHfccwHC/PVmBtVT5j4MiUsHL6LUnySnOC/YlksQ6+UJzbRiW?=
 =?us-ascii?Q?N1GThMhm+1ks+/T/vat59qNUu69ybBfKQU/binDok1rehgKNWHg8Ep6HPnId?=
 =?us-ascii?Q?M+Mf4w4LojCy5Q/rwv1dKvfZ+Ti4Dg24PAF5/jLzUGYsEC98qVZRBUZp3n2s?=
 =?us-ascii?Q?G6y22H6t2zW35h+MHb4nY0tNssb6t2mfXu8e9sQcA7+gKKsKqcySp2WezbQC?=
 =?us-ascii?Q?CQAiU38/dTaCnsnUl57DuZb8gYy7lZDEVrapmmygR6F66r78lXxHW7PVrSTZ?=
 =?us-ascii?Q?p43sCM6Rs3c6Muu5T47GkRacymBGjTm5rAtrqiGqO7xV+f/5IpwXHFawwR9B?=
 =?us-ascii?Q?H6Gd1npvjb7dFculalXij+9eCCvihK760LlUID+huqftitIcqPwawUeEcVS7?=
 =?us-ascii?Q?AVMvwflppC66x0Utlc52f7lAXcJSIdi9id6UFSSi3oPJavpEyl3B77PuToA5?=
 =?us-ascii?Q?gYcGgzyQGt8YepefG4mz3MFaPBh2PPl4AhW6/syuFhFB5Ak4lCpZTOmGLUE3?=
 =?us-ascii?Q?3E60GlONBPLG+LIiBeCtq1oaTarTdQtuyFF9K/EbHbUDMRYdE0tHRsPWAz3p?=
 =?us-ascii?Q?G4cO7/5IrcV/bC2jWsQ+JSDisxNMJNtN5hLZiLy4cd5dg3xZGO+gc0h+ZLGa?=
 =?us-ascii?Q?0nZ3WAes8XWrb/Gy/hY+2CGuLW3BNxMkOrl/IShij6IloKZcDsjZl+gMi5dG?=
 =?us-ascii?Q?ufIoRCApcG1Ptf0WBTu6JGnrN2eaYcEORExsmyZpJ4h7WEitjUUpSwpRfQpx?=
 =?us-ascii?Q?nGQHSkU0ZRkerRe+ThkTVWKW4qRlFNC0j3IK4XNHshKDiuZ/lTJyQNhJDwAu?=
 =?us-ascii?Q?NRYvoSEZ8ase6iSmbp2a3bb4cGMDxPfjhKeTj24oio+grns2kmKghVSQhGND?=
 =?us-ascii?Q?nA=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	i30Z2ZGIL9Hvw5CYkJXIbTkTtV2DM69OOkb5BuoeuT0F2J/Aj/vGSgIjn6xbA1zVBtF8aPvwbVX0h2yKSypE2y+QWYZySZjucu/EzejE49Bi7XzJKkIUYn45yet8n249AhfDH11SP84X9C1Sg7d45S9ShecuvC3gUbshimcmWj0A75F4QES8sfzRx93pznoo5REB2n4rJ85N7Ti9TuLH2QeB5LevW6bJ/t8lwuIe3i127LJ+Vsttszkbo9zjf+/3Gf+4ZrXn3z4y4Eo/EMHmdseMb9ZyuR/5M72q5zov3k5Mx2jSMNBxFJmp+bVgyxesIGXxgVGVxvuAhycyYC0+7IQkMBUnrvhSrCjNYRsJ6LNbXsSOgsdpPw6U5NdsfF+i7kdS6iPSS7sgpzU9vb8moZPNqOC7FvnbXxTUFe5/TC4FAPallh65qpwKbWEc3LI6ERQDWz0dDmRn8gcuc0REsTVB8dBiKcpIphbmHkWlPCGS64i84M3HuNRy4XFn8M75U3yiDcogQ9pVacUksS19lszm17q9P6y5577UyuWy5PmGfUjQuf4iQh45S77/Du2GFp6bGAleeIjdMqM8+G1TxcP8cG6GhQHaplII8Wn4eZQ=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cb059934-ebe6-40ac-8d8e-08dd106f5979
X-MS-Exchange-CrossTenant-AuthSource: BYAPR10MB3366.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Nov 2024 12:14:18.5870
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: x/GcNZ+In+MZbZ7MWoPRklizasolzAsxe+wlGaV3mDvLBq3j1O13eAzeosjL29yWN+FxtyNSnWSDhvVUfMRW+ErOmyNrCr21nKP5dEhaGEg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR10MB7811
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2024-11-29_11,2024-11-28_01,2024-11-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 adultscore=0
 suspectscore=0 mlxscore=0 spamscore=0 malwarescore=0 bulkscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2411120000 definitions=main-2411290100
X-Proofpoint-ORIG-GUID: 6Yd-q2pRwkKpPvz9hTsH8kBNcwXsfSCx
X-Proofpoint-GUID: 6Yd-q2pRwkKpPvz9hTsH8kBNcwXsfSCx

On Fri, Nov 29, 2024 at 12:10:19PM +0000, David Laight wrote:
> From: Lorenzo Stoakes
> > Sent: 29 November 2024 12:06
> >
> > On Fri, Nov 29, 2024 at 11:56:01AM +0000, David Laight wrote:
> > > From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
> > > > Sent: 29 November 2024 11:46
> > > >
> > > > On Fri, Nov 29, 2024 at 03:11:43AM -0800, Andrew Morton wrote:
> > > > >
> > > > > The patch titled
> > > > >      Subject: minmax.h: simplify the variants of clamp()
> > > > > has been added to the -mm mm-nonmm-unstable branch.  Its filename is
> > > > >      minmaxh-simplify-the-variants-of-clamp.patch
> > > >
> > > > Hmm, this was generating kernel test bot reports, should we be taking it without
> > > > that being fixed?
> > >
> > > That is reported for W=1 builds and is correctly reporting some very
> > > badly broken code - that has always been broken.
> > >
> > > Probably also only affects allmodconfig builds because the code in
> > > question is unlikely to be included.
> >
> > Ah fair play, you are poking around in some creaky, cobweb filled bits of
> > the kernel so perhaps not a surprise...
> >
> > We should probably try and sort out the W=1 stuff though! And by 'we' I
> > mean you obviously ;)
>
> Not me, Jakob is trying to fix the magnetometer/yamaha-yas530.c driver.
> But I keep on pointing out just how broken the code was.
> So there should be a patch to it (that needs backporting) soon.

Presumably that somehow interacts with this clamp code that he's also
addressing you mean? As that's something of a specific driver (I have no
idea even what a magnetometer is...)

In general your series seems mostly to be various reasonable cleanups (at a
glance) so think we're all good to at least have this in 6.14 unstable
anyway, to be clear.

>
> 	David
>
> -
> Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
> Registration No: 1397386 (Wales)
>
