Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8578685931;
	Wed, 30 Oct 2024 07:28:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730273328; cv=fail; b=B1I4WDDcytFv2oYg77B0oPvcSS3SRYmgfoFeXf9zRzzxH49PkYzdynw6FbWMI7jaY0+EvnY8d5y3l3U9bRsPmIlEEG8v8vwto7PXFd9LGykkIaHiFGMO+4j+cin/hV6JKaqeq6lEJF0JY0ZJIsI7ZqQGMHcR1fNxpENFRqz7Smo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730273328; c=relaxed/simple;
	bh=Rkcp0D95nqGNv50OvGh1EaUHiIoiDYLnB/C8wvZ6cMc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=QiaRa08aGTarvkk7fQj3DDE1g6ZMA+/JAtl9ja0rZOGFt4yo/9sphRJRQFKqx5u2A47JZTO2YTlcKB7bE6TGWJF/1Har4lZgeigBGvQ7tx4YzBBAyzSHLUCv2ROAbf3ZetS2rqPS1NFc8uiksg1Ad0oY98h7XabTXJhPRxkoEEI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=HZc4KVk4; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=Xmh0WACM; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="HZc4KVk4";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="Xmh0WACM"
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 49U1fgff009026;
	Wed, 30 Oct 2024 07:28:37 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2023-11-20; bh=gPEkAsDxzI5IeDlXq0
	KmotKN0cQv7JKNXimtpYay1ZY=; b=HZc4KVk4ifF0090UvXy8hXGUxQQNoxlUFv
	5oiyWrcR6PAM20Q9y6wH8rv/qyv8MIXqMPvAZ4SfmH6fhUk0LDHkNDTZdm4SxAkU
	wo15LRxhRVefhrts+QDQjy2UMHDZOPKVVSk3XFxERLgcNUN2Pkcwe2tVDdj5SpZA
	NBVEy+XHO/fdDFNjYv4D0id+HAFSzUADiXwbWIj4/YY4MW/sX0mlQbkyxR+62mJ8
	Lmb3fnbt73LD1MuS7xQEENDfdJICP56MtupsqLxtQi9npI6pwOJGrxnrdsNsgX5J
	WEtu+Tnf0OyOosOBhc/9hN6RX5+c+nIZ9Zpq36RPb67IP0WLIWMw==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 42grdxq9s8-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 30 Oct 2024 07:28:37 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 49U6UDJL040238;
	Wed, 30 Oct 2024 07:28:36 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2048.outbound.protection.outlook.com [104.47.55.48])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 42hnaq7c93-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 30 Oct 2024 07:28:36 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=VVAPe9Rwtyv7H5Wz9lAQF9QAoDaICeMnR3snLujSETmWFyMg6B+dfGc/TMvS3xDE8tyoEw4C/lyb2A0SLqSMikJN5FNkNnsl4QoQdu2CdfK1e0RSjPPQS/lyghl/1veGdjMmQ8oM+EzGPjpqYsZkoZpD8ZcM+9LPM+MroHuiKV9zmqdH2zDJVdba/BKWKbc7M3XVRdDE8EmjEOHj4oomTYUCR2xTqohWKGuVMkTvfzPKWbopeojU09CUwFun5p39jlqf/URhhqd4OISpt5HwEF6CwBkNhid36OGzsIgV10xErKKyD+aGthMN4e8crMjtJkp6SZvJGWQORCmQelrcVw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gPEkAsDxzI5IeDlXq0KmotKN0cQv7JKNXimtpYay1ZY=;
 b=jd4dluhUtIr3khdPq7xIkgvWLAdEL2xkWqgEQZgkZDdpIuouA/R5ai9EA5PTUHPxkmIWgQI6rlzL+Qz0lTXNyPFIbaXmm3FhzO8QChNgvaP11B77X8nhbDTKWcO98sB+DjL0qM5QO5AreR5UykvBiGb6twRt6cKU1n4kVr20I0wHiMLYWxq3YR1U0DvIeTlusf1tK9H0bhy2ZTUQaQwMZU6a2MJ6JR9nk6LfenLOgRijuFPx8XnPoFZySWPp8MPx+kO3GzR6BMFQjU2fLfRq/7DKXNq1cX30m1Z/r6NiYsN2LPux7P3omqr5LgwKcQbsSdSqtRZAPfNcjP/9rgSyMw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gPEkAsDxzI5IeDlXq0KmotKN0cQv7JKNXimtpYay1ZY=;
 b=Xmh0WACMl+/HuFDFg+pxIvshFmvWMHo9RgKQUOX4krRl0TWhgVfoJENlY/rSSRmicHXQD1PJQu51aSEGastPT/q7xqvykcoB7RuFs1RnkkvHDsIf90COItHYcp2HtYssOjX5DxmYxPAcvdx1/wGMQgf8gIRhHBYX2r2oGLBwKpc=
Received: from BYAPR10MB3366.namprd10.prod.outlook.com (2603:10b6:a03:14f::25)
 by BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8093.24; Wed, 30 Oct
 2024 07:28:25 +0000
Received: from BYAPR10MB3366.namprd10.prod.outlook.com
 ([fe80::baf2:dff1:d471:1c9]) by BYAPR10MB3366.namprd10.prod.outlook.com
 ([fe80::baf2:dff1:d471:1c9%6]) with mapi id 15.20.8093.027; Wed, 30 Oct 2024
 07:28:24 +0000
Date: Wed, 30 Oct 2024 07:28:21 +0000
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: mm-commits@vger.kernel.org, vbabka@suse.cz, stable@vger.kernel.org,
        Liam.Howlett@oracle.com, jannh@google.com, richard.weiyang@gmail.com
Subject: Re: + mm-mlock-set-the-correct-prev-on-failure.patch added to
 mm-unstable branch
Message-ID: <11f2daed-05c7-4c96-9600-a37e6f81ea33@lucifer.local>
References: <20241029041205.A0DEAC4CECD@smtp.kernel.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241029041205.A0DEAC4CECD@smtp.kernel.org>
X-ClientProxiedBy: LO2P265CA0504.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:13b::11) To BYAPR10MB3366.namprd10.prod.outlook.com
 (2603:10b6:a03:14f::25)
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BYAPR10MB3366:EE_|BY5PR10MB4306:EE_
X-MS-Office365-Filtering-Correlation-Id: 6a06a940-68e0-488b-302c-08dcf8b4708e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?2BvM7n3p8hwA7GRVDvG7F1INq9/OkbltK5H3bwllOp6BbRSWXQz1neG9EZ1m?=
 =?us-ascii?Q?t+f+aoDAEMKEFhWPR9mk1Z4Mlog4zfYNsUdN7xFHXqkwJXvpXrtBUNT4Nv2/?=
 =?us-ascii?Q?ago9Xeryem0SOZh74d4CGG3MfiJ0wGX1QlOpIYoPX8yHW4l1mALyaNjA3rvj?=
 =?us-ascii?Q?4CqBCVYNpxyv+M7/J74Fu/3m8hY3OSKRoRKYaTCul1Z7jabr4kDH5IbHVX53?=
 =?us-ascii?Q?36NfqbIOtd18ioZdC7C4AtlddlFt/FhafmsLolJ6wpiK/UqSZcuUg5GseiFf?=
 =?us-ascii?Q?FZP73s1Y0y/z88oNNzvquJOqaLNEwyDsI66TDV14d9+K9TKz3yRfSpfSUc0b?=
 =?us-ascii?Q?tyGRQ5FTWGNoMjaOLZ1WEWXfJ7UgbuWj+XwFztNDwrmD6lGGWLijfCbNxhXB?=
 =?us-ascii?Q?ak9dQ+9SyOKdCkort2s2GyRV1pbcw70ERlErSGAgJUOnWwhG0FjbXt4CAbx7?=
 =?us-ascii?Q?740n8Rv4m+Rx75wJYE0UvqQUdnCP+CYO2qHUNQbdhnyCfUqTDrVR1FkdEaCV?=
 =?us-ascii?Q?WILp7Z6mSdxoKjKvQ6XRDj1gnZTtgrZQ5uYaXmb1lMmFSHMgWxoeJ2gkY3Ek?=
 =?us-ascii?Q?CImd7cd+Tg61mntjZMdcD3vxoOlVrJb2xGw30l77GA2P6prfqSlv05t1QT5r?=
 =?us-ascii?Q?1NiGNjuQb8PpPguZrVcodXEZGv3HJfV2AmYXZgpybm4bCNScfHp8Ojtn+mi9?=
 =?us-ascii?Q?J7w4J/JMkPHEMTH7AdPh2ip/kqyC/gB4Vkqhex+LK9oNRRuOUJdO147kUYHU?=
 =?us-ascii?Q?/GHhJANLyxJeZyWLSTbaWis7k0PEROSrR/u4IDFlrRj91rpH69itLjbWDjXh?=
 =?us-ascii?Q?lYv8hlyJsstCC9UWTmGwjVWPh3Lz9NGHHAnreCTsr6XxBNjVG10SXq2oCJ87?=
 =?us-ascii?Q?tog2aIDs/BfgYeEurpieQPeeC3ADTfT1DmpCjSfHPgSel0NzZBbL4Iyg8qy/?=
 =?us-ascii?Q?fXvT2sXnQH3DPdmcEsvDZ60ZJwreoOVP+k4PE84p4U8Mvzr1N0QGcQgobebV?=
 =?us-ascii?Q?4JYTT8xQacn6F4X7XRPt5jiHxi0NHsMklv3feH4hmKtDY78iYiuB+cm8axV/?=
 =?us-ascii?Q?wMa2bgvrg4fk7pt5kaewtbv8DGP4283aeAaHICi1GXhYOBU2bgSjZ0BwJ6qR?=
 =?us-ascii?Q?2r8j9qQYiX4uj+lY+2N7IbwXR4GM5v9R88VGLIzr/CsQQvUloWkTWyi26n//?=
 =?us-ascii?Q?x767qdp4ixg+zKAE4YdlRu+MVWbwUaY/ZHzjqAKbGUa228L0AQNJx3Zibkfr?=
 =?us-ascii?Q?+KSiQYRwXHQebWCefmxyoAlAsytInfqCc4ztn+UIbYp3sBkxcax3ERWwTXT1?=
 =?us-ascii?Q?yQDz7goxHJQ8YUTS9aXYw13G?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR10MB3366.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?p9cR+yyJnGgryaf2qVb/4Joo8R7f9TIv/FhE/EEHgywip9Yk7ZXQQvVLrtUg?=
 =?us-ascii?Q?cbMxEGggm7nqJI4SAEOoU6JRVCOYMYiA1RHFdzBba4RUa0zuaxRwY/ulsknh?=
 =?us-ascii?Q?fW5+4ECvBcnw4reqvZR9A3A+RWbDpaByhi7DhbqIH4VfJgBx6Jfbb4A7csDg?=
 =?us-ascii?Q?PfgLQCQWqiQ4pjM09HWIeDhX0vq6wDd4xyrQPZmSSS4Uie9dayfBo7rrwIgI?=
 =?us-ascii?Q?CRJyVCcFTwhKu388GwWlZcI22v3WkUXSHSyvzcYsw2oiBtjsDqP5XsK6lUPb?=
 =?us-ascii?Q?seo9jtytyGwM+6Eg5Opi+PE1FWZy6ne323Zer75IpGZ0uydF9nGIiudUBNto?=
 =?us-ascii?Q?ORse+BwGggVD2sIpBDc0C8GjdMlBX+DogpHXia4GCMV7BMMYJaHRdhcjQ/jf?=
 =?us-ascii?Q?42s5NG15dV7VsMxvCO2wEimT/8EXDBrUKAoXZZ90VBgfLacHGIr4MnNyWpBb?=
 =?us-ascii?Q?iVu8eXknhyoOHIjJk1cUB8P+V22UAPwXw2RKqgBoQbGZT/Bz6smNEL29HCi6?=
 =?us-ascii?Q?fmVILDdW+U06B75d6G/gYvgttxE2v0oiiSUVBkjFnNnta5KJAujbgrJMP+Ag?=
 =?us-ascii?Q?hFI3f+gXeDYtVpcUcQSYqjQq2qF0o1l8E4IoFemOFmbB498O371ZcyjMjqov?=
 =?us-ascii?Q?Xd8D9qb7U5o1lLLpuQlfUDF9DewkbuHTJ320AwKISaWTYg15rD9j8TE4Cz+O?=
 =?us-ascii?Q?KLRt/UGnizopL0ZJEuczkn+K/FKmbmf6zlXArocS8kVSfSIyCl/v2Sr8HhSZ?=
 =?us-ascii?Q?30SX6KiIUI/0J2Iks9sJkC8uwNePOb1lBpHUEwIm4z+AYfpEYnONypCza5DD?=
 =?us-ascii?Q?rX9MXlQ7xXxGWTJv8xqRhWzRlns65JX55Y39BRbtexSd+i6xJT14PC1lwsaZ?=
 =?us-ascii?Q?AfxrKp2i/ufgarDHHPe85IKwuzgw1SCdaEWkviSmy1pLEbu+QO0nrM7A59/3?=
 =?us-ascii?Q?JnHZYsmvrIkMgAi81LEm2+JGOveqQzB8u/QB3jQtiUJXQWGodCYbDxeRaXZG?=
 =?us-ascii?Q?+V4iFV/s6rrTEaVP15i1qDWeA2r3BK+GJdqbVSvGXGUIoJYwEAxCiSN6XZps?=
 =?us-ascii?Q?Scf4j0Je7SvvsK4iMialGSieJXiS5JUfK7CL2bbbpGdS1NLhCEO8n60VkZkB?=
 =?us-ascii?Q?qbd21KF95OplaVxSzvsBQ7FP3y5dZYkeK5WdDkXkGvSK7v4JnuM9ki/yi7yT?=
 =?us-ascii?Q?pAl2f2Xo8JMxh6/ibO2/p7TJHedoR1xeMzSG90bKULULS/NeB8lNSiBbOoGD?=
 =?us-ascii?Q?BMOlWvowk8jpLkwvgBLXSKC0DzXV6pGe4XXZvqdJdh2eLcDP0w19OP3iXluP?=
 =?us-ascii?Q?cP1Oq0YcJcpugYg5i+BuO1NfzZ6+6fB7vaOIRQvFXEt5PNAwHfkE6d/ujGVS?=
 =?us-ascii?Q?thHSMxqYEfgVIjdTEwOlrv8Gdr5XfrpU4FAWOA/GhkJ/fZAfaad21Yfcoz71?=
 =?us-ascii?Q?s9S7OfPiOBhxat2G/lcKIMfwweZoXN6vWK9QA3nDm7GXpn+BJPLiBzEVIryS?=
 =?us-ascii?Q?BoJnamIqF7haPafmaqCmfrPsMWKcD0NAFf0ZTQThe36CS7bi9iX7exWIJxXI?=
 =?us-ascii?Q?Qmh4nJOuomqluMwwcesY1LuHqwJ97pm7F3I0bEdefC4AlCSKxvsn0Y09cSPO?=
 =?us-ascii?Q?pg=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	Loyl1mtV8GTip2FUtDGgddZKLJh2/07DrhNhpIZe69/wb7biNNkDyYCV2VOf1adrV/0PMBw3gHvpj2AhyKGQD7oXxELkqVhd9+LhxLGQOK06ff6R+mGtD8yPk0UgfhZQdbHl8RAeEprg9TgOt7M3EUswdPRfF5r2qbJrWu4eyxLUOY01RcPY6HnrXKcNfB2c6HWk3YpsNSul4NiZs/CqZWQh4odg6MvLjs+aMDzDWnbOW3hMI6VTWmigQe2G24GXV7mHH7aww1Pst17+dwWXHVQfPb+Evg8MBIn1xB9HR82i+YbPt/hetHaGpwy4XAsN5CnMgY79vbvHb8FjgXcgkG4OJ1+/Vj/04JBbVDTL+Z9x7O34rXCu5jLL43+72qa4q7U4DPA95PnwTmvMJaMASiGclAjW5w7mG8FKfq2nEe1rQM3Imzf7b4Q4jc8gu0af1xI40xyNKYg13aKgtN4PZjBKc3bY7leZ6pEoQdPFVrLkWq/zNTDxEZdPJXW0OaFo8xPdYMsy2YVn8KqDMD6ldOSaQjvH4bShL+wqnNwa45D4/F+r7ick/Vtn7Ajh47dYRmt3ns1hfK7wBA9stU1raxaPaEuTjVzJapZDnyPUc04=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6a06a940-68e0-488b-302c-08dcf8b4708e
X-MS-Exchange-CrossTenant-AuthSource: BYAPR10MB3366.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Oct 2024 07:28:24.9216
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Y5BtGaksl6X5Zu2sSWqfa/RX+ReEzXh51y47O3GYp5xLHrWNB+65H0u78HX6CxflyijuvH/Gpnzwe7ame3blGB9EbiAE6wreFhy6Sn8mz2g=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR10MB4306
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1051,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-10-30_03,2024-10-30_01,2024-09-30_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 mlxscore=0 adultscore=0
 mlxlogscore=999 phishscore=0 bulkscore=0 malwarescore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2409260000
 definitions=main-2410300057
X-Proofpoint-GUID: BKMzBtVqjubCw9Z44HS39PlEruYCLkVj
X-Proofpoint-ORIG-GUID: BKMzBtVqjubCw9Z44HS39PlEruYCLkVj

On Mon, Oct 28, 2024 at 09:12:05PM -0700, Andrew Morton wrote:
>
> The patch titled
>      Subject: mm/mlock: set the correct prev on failure
> has been added to the -mm mm-unstable branch.  Its filename is
>      mm-mlock-set-the-correct-prev-on-failure.patch

Hi Andrew,

This patch needs to be applied as a hotfix as it fixes a bug in released
kernels.

Thanks!

>
> This patch will shortly appear at
>      https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-mlock-set-the-correct-prev-on-failure.patch
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
> From: Wei Yang <richard.weiyang@gmail.com>
> Subject: mm/mlock: set the correct prev on failure
> Date: Sun, 27 Oct 2024 12:33:21 +0000
>
> After commit 94d7d9233951 ("mm: abstract the vma_merge()/split_vma()
> pattern for mprotect() et al."), if vma_modify_flags() return error, the
> vma is set to an error code.  This will lead to an invalid prev be
> returned.
>
> Generally this shouldn't matter as the caller should treat an error as
> indicating state is now invalidated, however unfortunately
> apply_mlockall_flags() does not check for errors and assumes that
> mlock_fixup() correctly maintains prev even if an error were to occur.
>
> This patch fixes that assumption.
>
> [lorenzo.stoakes@oracle.com: provide a better fix and rephrase the log]
> Link: https://lkml.kernel.org/r/20241027123321.19511-1-richard.weiyang@gmail.com
> Fixes: 94d7d9233951 ("mm: abstract the vma_merge()/split_vma() pattern for mprotect() et al.")
> Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
> Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
> Reviewed-by: Liam R. Howlett <Liam.Howlett@Oracle.com>
> Cc: Vlastimil Babka <vbabka@suse.cz>
> Cc: Jann Horn <jannh@google.com>
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> ---
>
>  mm/mlock.c |    9 ++++++---
>  1 file changed, 6 insertions(+), 3 deletions(-)
>
> --- a/mm/mlock.c~mm-mlock-set-the-correct-prev-on-failure
> +++ a/mm/mlock.c
> @@ -725,14 +725,17 @@ static int apply_mlockall_flags(int flag
>  	}
>
>  	for_each_vma(vmi, vma) {
> +		int error;
>  		vm_flags_t newflags;
>
>  		newflags = vma->vm_flags & ~VM_LOCKED_MASK;
>  		newflags |= to_add;
>
> -		/* Ignore errors */
> -		mlock_fixup(&vmi, vma, &prev, vma->vm_start, vma->vm_end,
> -			    newflags);
> +		error = mlock_fixup(&vmi, vma, &prev, vma->vm_start, vma->vm_end,
> +				    newflags);
> +		/* Ignore errors, but prev needs fixing up. */
> +		if (error)
> +			prev = vma;
>  		cond_resched();
>  	}
>  out:
> _
>
> Patches currently in -mm which might be from richard.weiyang@gmail.com are
>
> maple_tree-i-is-always-less-than-or-equal-to-mas_end.patch
> maple_tree-goto-complete-directly-on-a-pivot-of-0.patch
> maple_tree-remove-maple_big_nodeparent.patch
> maple_tree-memset-maple_big_node-as-a-whole.patch
> maple_tree-root-node-could-be-handled-by-p_slot-too.patch
> maple_tree-clear-request_count-for-new-allocated-one.patch
> maple_tree-total-is-not-changed-for-nomem_one-case.patch
> maple_tree-simplify-mas_push_node.patch
> maple_tree-calculate-new_end-when-needed.patch
> maple_tree-remove-sanity-check-from-mas_wr_slot_store.patch
> mm-vma-the-pgoff-is-correct-if-can_merge_right.patch
> mm-mlock-set-the-correct-prev-on-failure.patch
>
