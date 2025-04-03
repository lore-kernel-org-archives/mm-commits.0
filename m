Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C10D1F12F2
	for <mm-commits@vger.kernel.org>; Thu,  3 Apr 2025 09:19:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743671942; cv=fail; b=Ml+Dq4I7uwks7Y4dTC8Wg58572jNNzjccifBZmkRnXEnYMzkxoQ4goJMA//Dbp1BJBvvtKBA8eyo/3+NdEsXX9TM+CnRyPQXYmdCsQltJDWiP0LrGr5XIOiGQbHh0XWnW8BEkAgvhiRwc8ExOyi5UbRS0gCNNPUbAe0TDvxQDfk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743671942; c=relaxed/simple;
	bh=10HGx6VpzW+MPyaAk8x2rI3o43uc4sqkFc5dTfm2hZQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=nr0dyuIBi5twGTSOMYshNDLB1EUEU2tKaYa0qTM7VtnoRFr0hXp+PveFr7FPA9eh/yFvueN7hoXOJwZJaKNJRBQsviZMo0VxEnnLLDX1fWkqTramXDnixzugQEf7Qaiu43rLwPNi87WCu7BCk8f3/lFlQAncXe5vx3UhGu1McmE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=TqUqxsK1; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=FkS1rN8M; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="TqUqxsK1";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="FkS1rN8M"
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5338tsTC007803;
	Thu, 3 Apr 2025 09:18:46 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2023-11-20; bh=k6NpEIoYpGlQNgBlS2
	DNDz4MaB2GQpZgdr1UlEk4qfo=; b=TqUqxsK1wXnvXvsPb1pD9z0EoDLtpr33R/
	bAEGwL2rpfRxHgN8jorAauf5db6vE5iujhAX5kCc/Il2oDtrQEElqfFwG9v3HAYi
	2qkkFnKaHTAdsDuUmMcWJ5907/ME9doqYfAbebf6NIR6SEQcjoNn3/QBNAnqDu3l
	VjFCLnI8OF+lCstbtoo6o5e3A4UBPnYpEYtaHjL5idfaFbsrOGybsOdKzHulUwmL
	EyuRze441A6uytw7O8lzBPG7MvuVzUI6n3nw35qO0ACFA/l0mXskYV5kgoVgeeXl
	3jWudeHD6GlwQiD48Ld4seE7VK1SXjfsGLdbnQ175rcOs//64HmA==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 45p8wcmvyq-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 03 Apr 2025 09:18:46 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 5339CLGV003866;
	Thu, 3 Apr 2025 09:18:45 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2171.outbound.protection.outlook.com [104.47.59.171])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 45p7absm6p-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 03 Apr 2025 09:18:44 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=NGk32nwM46nnlPBU8QjK10Qdfjn1Bxw1DxMfHfcH7OCZ+ABOv4igVdJKqnmkGL+EcTHQgdq5Lbk36eKPY12vVUNTe1JLNQpyclW6zH1lBI/OmJszCc1Spkln0hq3tRwm44N4+rDYOREauRVqKqwUVl9jFRqKl3Ox0ttgLTlXub7SqbBd+9dyZbUiAsbxnhrj02EsB7vNGnm8B6AzETJ61fDVXQQahvrpvIfDhsefvaPxjs2UqvMk0Qk5cY9sNxwJpu06E3VyGwbm5+gyIY+6zU4ApwfqSejhfxx4bMsuQ1WoBkvA8bZXl/vFhOcbqyhzjA/hYOsOKHl6P+AyGG3BeA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=k6NpEIoYpGlQNgBlS2DNDz4MaB2GQpZgdr1UlEk4qfo=;
 b=qckadJiB/LJZdMC2E3BoxojsMxEwuw8kE6eLKYfTLT8eavH9snM9WRcGV02J1R2xqvDCxSjiVLLUXCtkYmK1Q4Tep7VWh2zMWXWM6LZDbouZEcombtliR7xi/E1fk4sQGHUlL18We93CIDiJh7G1QVJO8mLW+8wDzfaFcauXQMekApsLqCJ8f3KyLdf7FWpi5iJZNAc5eMc9Lys34v77n3Zuhe7sb4nVvVzzOLa7NB7yHANuix7Tuvk9qaWLS83FLE0lDSRttdEjo+xpDDwlU9d21RdaVl6EPNuyQ3rmK0CVh8cy+nlbKs3arRFCNEtQgfZC8Q6Xzxm2BiD5qey/PA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=k6NpEIoYpGlQNgBlS2DNDz4MaB2GQpZgdr1UlEk4qfo=;
 b=FkS1rN8Mt7nSRCD4Fp2uBrO9jtkoutJhx2nIAAH6ZIgzbZTeQrDcWnJ6vV87ofvUNMf+MLifa/k1OsvIgip2kCGoB0wu+meGrBWJNPeUnmjKUdHKDnrXiuXLbHN0SO18Jj8TxEu6zVFKSkOOM9N6r8Tm+Z81xaGH4mcBSPmGO4Q=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by IA1PR10MB5947.namprd10.prod.outlook.com (2603:10b6:208:3d5::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8583.41; Thu, 3 Apr
 2025 09:18:37 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2%7]) with mapi id 15.20.8583.041; Thu, 3 Apr 2025
 09:18:37 +0000
Date: Thu, 3 Apr 2025 10:18:32 +0100
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: mm-commits@vger.kernel.org, vbabka@suse.cz, rppt@kernel.org,
        liam.howlett@oracle.com, jhubbard@nvidia.com, jannh@google.com,
        willy@infradead.org
Subject: Re: + mm-rename-vm_area_struct-to-mm_area.patch added to mm-new
 branch
Message-ID: <aba805fc-1d2c-460e-a197-e00258643a82@lucifer.local>
References: <20250403034145.D5208C4CEDD@smtp.kernel.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250403034145.D5208C4CEDD@smtp.kernel.org>
X-ClientProxiedBy: LO4P265CA0318.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:390::17) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|IA1PR10MB5947:EE_
X-MS-Office365-Filtering-Correlation-Id: 51cb930a-c178-47f1-0313-08dd729083f8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?l187XkAVxzjI8iw7r5FTRlSRENwS+axW7LtkBxsftxJxQT1TWT67tMI2dg0m?=
 =?us-ascii?Q?Tv69+BV06EYxTHxfuuGp3Wy3yp23VkCd1ZiiaoSH2bBvN7C+gbt6wohWsaLi?=
 =?us-ascii?Q?dLpy2dEbO4XnaGSllmQjwBC/jgceHNjTPkFkbxSRwL1avvWH5kBFCQCkQtgI?=
 =?us-ascii?Q?5TYYGoa2/thEmxd2PoR/wxHP5bAFzMroLcewkEAjORbLTJwT7KRZsf6P8kSE?=
 =?us-ascii?Q?VHOjiGaV1wa04YEwXO/BPdpnPZTwU4ukQuohpx3TndTu52Df8ND9GX3nB4/q?=
 =?us-ascii?Q?HslLF817aPpCFf57bdJ+8UgeCo2UEcIrP0363ErEpWAU/rI6ms/NfAVuaApQ?=
 =?us-ascii?Q?MeR3+V7+MbBz8DRMlsNO4XBVAigTBTAvxH2X+lINPJzegWyqnl1xNrJ9Zpop?=
 =?us-ascii?Q?l/uQWfLQ0zXOjverMBm7tFVeX5pCXXnSjyixU0oR2w2Dt2h+l7sG2hybJGWV?=
 =?us-ascii?Q?wUQ+hInJGauoAcM0ZRpSB9Z6rc4stupbK55b/stWcavDjRL/TAsbUdNPvAVc?=
 =?us-ascii?Q?zGr2Eo9yjy5n5+2s24XwDNrJ1igElqcmcW7fASycP3BzVU5RCIaQxStFMV5z?=
 =?us-ascii?Q?qTI+FtKWov8igeP/NiZinGuESEHrqmQFZRUxvDhnVzWbu5Ad59Ufyi42Zziz?=
 =?us-ascii?Q?WiVYvZkG8QJUwp991jLRFkvsQSvV4epOc54YTK6M/1YoATh4ALLBzCtTWQt2?=
 =?us-ascii?Q?S8HzbLR2L/2l1A3VBFtEFeA8nwHBl5aXCGHHIl1yD44b4MbBcCX90giABnVk?=
 =?us-ascii?Q?sWcs6jxhOtWYIGWd78hiri4AD4i3wZSMgxkGz7i1PhdoK6lVgXLYhlDmHFHZ?=
 =?us-ascii?Q?ZNCvcqvo4EmO+eI1SNrTixtvoiHbaL5KeEGyzJ0NG8CfjHcec+kxlynHX+zY?=
 =?us-ascii?Q?Cj2Lrngd916z+3cXYf9/VmstVAP4VZFK0ZQQWMa26Z/HAEaNojbfLnDEeS+M?=
 =?us-ascii?Q?mzVt4nOnVNsfzruoMDMq2fHs9efdbIZfBj1S0BTU4otWDIcES+rN305DwfUl?=
 =?us-ascii?Q?NC0L7HoMsE2RT+nT4YBMHd6e9cUhBvxt0uEw1j0KoEbYs41MvwZfLzHf4Lnz?=
 =?us-ascii?Q?VDrHVgwvVWPUawIbMC1L3BO8GyVx6pneQFN3WrWblV2vWxYGK4x6CgUIJRvH?=
 =?us-ascii?Q?dO2dG8UsOlA70hx0s3IBzz/rwDDsOrl0s1YPOuXpEvFNXyjIN4LnuzgYXNFE?=
 =?us-ascii?Q?aImIZ5GC+8Ujziw9sE/7eOO3undkRBk80mYdY/6s6B1uiKqxXNC7ZAOd/qwn?=
 =?us-ascii?Q?bKlk3BNEhl1CWXN2o+eD6Fda6T1Z12BriAX7TXYuqnNDi3F84URYA6ygpOJy?=
 =?us-ascii?Q?PSOV144aeFfs1T7U+QuNFb7FVnAxS//GZC/9ewEuexSytN5rwzw0QibCjN4O?=
 =?us-ascii?Q?X6wio5jSbah+LlAIIATrU+on5k+zcX84bVruL8FgwqzTJDe7Bw=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?smmupjJm4oP+4xAqnCp6xNAo7Ut4zzcfyMgoBdJxvHp5vgMacXHvn7o8YAp9?=
 =?us-ascii?Q?6yr6AVYAMh4aR9Im52jJqtHvUAwVRNfQID2xx+jUSDT4FdJD1wFm3/PtlT6R?=
 =?us-ascii?Q?heWRqUsSro9b3YZA0Yg1zjPfH1qBn7vR9NWv1MTdvtb9DVnkXZ4NJedWsUfe?=
 =?us-ascii?Q?VmG6ca7SlRfZnmBPOqhdOmUcmt7rdcuZtGbqmvxqYPz+scJllbvi7/OZLa0O?=
 =?us-ascii?Q?oaMXaBuQpo+WB5gI4uPxGGA9zhgV6zAeF47BUl/ToZqTe3U0VTyJyk261gge?=
 =?us-ascii?Q?Im3yfSZ6gxyyNlayD0TSPbR1PoJojND4V4Y1p/wddBehNUzpa5lTQLUltmOE?=
 =?us-ascii?Q?r+FavFAoFCvGKbtrnKFaGiXbP8Reqi+gFpNxQ8P297XtKI62k7Bfe98M8CNA?=
 =?us-ascii?Q?+O5JxzcDz7JWYWknh6kWZK4INvLR8Agj9oN3dUzWCdM23JO763BXC3RUfjGK?=
 =?us-ascii?Q?s7AngGox2SfKPTm9kbbxE1Q7wPARPKPdzoVysxT3jnRgZLkA2Yykq/sl1U8S?=
 =?us-ascii?Q?hTgnjfAI47irvHo8GDSQ4JmkLD3AzD7xfzHaKoTi4wP3qV0bJ3vIbLRyenfs?=
 =?us-ascii?Q?tOTzMOHLS67brTSrFozAO9HnGnfwLMc/pmajPErTSCWvKPQPhXdtYHd4OQOh?=
 =?us-ascii?Q?hOGT47O2Sy8SNHdT23kdThsAwz33Lt74RdEN7jxbbWYWiG3+IO6u8zGtsVWA?=
 =?us-ascii?Q?LKED2scafxtxvALZa9sbAezJL66SmvmDhcamqKK6ffMEJNeAmbuT4AQHrqg8?=
 =?us-ascii?Q?2ZirAPacHzbQiy2OEvOYWDPxx0oQ/5YsGc+MED0/b7eGXtIk75ywySnj07dh?=
 =?us-ascii?Q?PWFD1MBOaqrFcBJxR349VjGGAmcJrXY00l58/Yz/cg8NraUNoC2HugMA6zos?=
 =?us-ascii?Q?pC5XE/v6hIR+bcind0c2Vy3AiRVznPRZkz2MQwk3oTAFI4JxMy+9JMqnKuzo?=
 =?us-ascii?Q?NKN4qS9lt/exQw4Wfk4RU47C1/lLbPRoBzVFw2t5KnX1UT5m7N24ZGykOeKh?=
 =?us-ascii?Q?UWmluNKDNn8l0zTr5j0bvHluDDp6i80RwffWcHiJaaUXoYfxoORkiKDipQAH?=
 =?us-ascii?Q?mw65PZHG32ZL0nmJzyc9x1cF8VDcoPo8JeWLKxkUh7mBqMrjP87v4gymkJIj?=
 =?us-ascii?Q?zzGNoDnc5BYpPmjO7QDVT5gVUhT3eKpy+J9no7YaVVX7YCXU6RhzcqokVpK0?=
 =?us-ascii?Q?AzLF126NLnDzWyNe4rfenYqgO0RPESMHpeDaSlc9pQx2lpaSXSgsW61GYQyH?=
 =?us-ascii?Q?gOglo1ty1t6D6sMsmfCXIAQ/aK004r1FvHkaX3E1qbL9sU3S8SrtNCB43DE2?=
 =?us-ascii?Q?fsWXlRAuI/F4bkIx+j3BHzNOZdhUvUOj4COeh7kw1FzzWDcS8+uI2RiobvUb?=
 =?us-ascii?Q?nV2PLUc6w15cKIM+jY0yVflfkztFgSKtuQs5jWsHomNspAV6YLty4oRawUcw?=
 =?us-ascii?Q?bZJUI3zwtx7DMOQvChA9/rvO0w7+y+S68C3JiBWGd6PY3fLAHp62zMyFCHsf?=
 =?us-ascii?Q?BsfAtOPeTzetIHXKuRcOTe3f7k/T3U3UpnBmxD2G2WmYrFyb6/TtgT/4HMUT?=
 =?us-ascii?Q?BCIPEWbzP9LLR93N3GViw0em1QOCmSuOtFqIxvl+Nh96V8O4FO5Yuf+IlFTg?=
 =?us-ascii?Q?Iw=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	f6gAIDaEhTVdFQ1tUjHVS7regnPSivx5d4pEphHP/QpgXfxOUfx01tliEIQzLWKhSzIsS+8NZPeIWFkoTqr7fBWlaXPmJrHRGJ/AnKSj4/e0jN5r2yx7RA83Yoq0P8xFVTygsMeNn8jRfiqRwP3nKXwzjAysEjB/x0r4LdxOxes/T26H1PdecZQpUhU5IJBc7ubStyh5JWKaSli6IXeH7K98dp5b4ddofdcgfARJIRxMDqyBPOJxSvQshmHDxxxJB56WTEeTpBCXrBCNfUPVwinb71GLexKpI3+QBmhJsqtXaUoeYy1ET1UPieqmbZfY4+iHhEfIqQM20awoYQrjCj+f6KbY0yKIbFGRMSlfdWxj0+OUlfx1ZMhVhl/BfK0TK7MS18xSpBCWcDDk4VvYeqSU9E3hcQaAhS7MwJSoz9RHo3b1c+pWITugjsCa71ZWKcSj0GwaSa7+h2GDmrQ+7VyTT62vGPrK8ZDyIEaAgGaC3PrYvDUovWCZT+r7Vn1LdRjBbmg0prhJ1cgKogEnCBQBceFmJiVYNCcQmdmEOnZGyz5lfQRzwZv2z1kxGhSfBsVHa4vj1LK7koHumwZP5XxBsx1pt9IFdfItBkCnHLk=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 51cb930a-c178-47f1-0313-08dd729083f8
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Apr 2025 09:18:37.2139
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: YrSCzdOCeQlWwjo3xto4ozyfMUzocOhcF1dRvXZsInvxu4pEct/ZLn8+67bIYlVuvyMwUmK4Bwhm+GhMUbfGIqbGE6ZtoOEFeqlfbMTKyhs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR10MB5947
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1095,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-04-03_02,2025-04-02_03,2024-11-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 adultscore=0 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2502280000
 definitions=main-2504030033
X-Proofpoint-GUID: 3LR_Hw8cH9R69TpFUN_vIVBC5R-ZD_ZO
X-Proofpoint-ORIG-GUID: 3LR_Hw8cH9R69TpFUN_vIVBC5R-ZD_ZO

On Wed, Apr 02, 2025 at 08:41:45PM -0700, Andrew Morton wrote:
>
> The patch titled
>      Subject: mm: rename vm_area_struct to mm_area
> has been added to the -mm mm-new branch.  Its filename is
>      mm-rename-vm_area_struct-to-mm_area.patch
>
> This patch will shortly appear at
>      https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-rename-vm_area_struct-to-mm_area.patch
>
> This patch will later appear in the mm-new branch at
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
> From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
> Subject: mm: rename vm_area_struct to mm_area
> Date: Tue, 1 Apr 2025 13:25:51 +0100
>
> We don't need to put "_struct" on the end of the name.  It's obviously a
> struct.  Just look at the word "struct" before the name.  The acronym "vm"
> tends to mean "virtual machine" rather than "virtual memory" these days,
> so use "mm_area" instead of "vm_area".  I decided not to rename the
> variables (typically "vma") of type "struct mm_area *" as that would be a
> fair bit more disruptive.
>
> Link: https://lkml.kernel.org/r/20250401122602.1738511-1-willy@infradead.org
> Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
> Cc: Jann Horn <jannh@google.com>
> Cc: Liam Howlett <liam.howlett@oracle.com>
> Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
> Cc: Matthew Wilcow (Oracle) <willy@infradead.org>
> Cc: Mike Rapoport <rppt@kernel.org>
> Cc: Vlastimil Babka <vbabka@suse.cz>
> Cc: John Hubbard <jhubbard@nvidia.com>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>

Umm.... :) I think not a coincidence that this was sent on 1st April :P

Especially if you look at some of the responses I think clear this is the
sense in which it was received :>) (though - hey - maybe difficult to
discern parody from reality when it comes to me suggesting
3-letter-abbreviated helper structs tbh!)

So I think best to drop.

Though the naming of this isn't brilliant, if we were to change it I think
we'd maybe want to address in a slightly different (or at least more
broken-up!) way :)

Cheers, Lorenzo

[snip]
