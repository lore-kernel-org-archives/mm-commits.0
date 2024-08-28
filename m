Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0FDA8288F
	for <mm-commits@vger.kernel.org>; Wed, 28 Aug 2024 08:35:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724834119; cv=fail; b=Jdmvp9g9g0X22xlNTcc1amwAT11gIHlL/1b6G0jLSdd7v6zdsStny5EdGIAgRBsIb9L6OAauRKIJOPbc3miFVO7AnYrKsN3nGvx3Fp/Y5/OG0DU+oLh+xsj2lyKelWMYA0cUxFE+Z0a2jdqZJhvTJdO+b0pd4eojYXkfJayDC9g=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724834119; c=relaxed/simple;
	bh=Zmry/hGAlot7mKGxj8BWsgSL9p9uVlmUCHAfDK6G6uI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=rkZytks549jzpCJZIf+iQKnWy9A0SEIFykUC7HR5rt2cLbsG5MO+y8KZKLgPvNB/Nfb5KyFqtEViDERN7hzHJu37zAHxWgKR5GRZZVv1mZEHGQ7pcmj/sfPvnNU/U1PqMKZvH9uxChkmbJuoM1HrrOCk0/kXgHAqWaauZCF/rZY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=hD72fGH2; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=fCMPd0gO; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="hD72fGH2";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="fCMPd0gO"
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 47S7tUCp003598;
	Wed, 28 Aug 2024 08:35:11 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=
	date:from:to:cc:subject:message-id:references:content-type
	:in-reply-to:mime-version; s=corp-2023-11-20; bh=sjIOAiWp9rFbnnO
	0bNRDMOpkDN4OqVlyhfjsTiIXKAY=; b=hD72fGH2IMmohq7l8qXwo3z/5BaxiOY
	QXVv9Dsk5xLvoyKAvl0vsRP58CIeiCdnd8XbIFhoUESeXIY6lzWAQJo8TMT6MNes
	jpBWDR+Irk9HbOjQSJkL0CYMInBGIYzqtnAKS+g+vk0w00IVkAHf194vUE0KYb6r
	CdVblzH4CReGqQ0tuy9K0IG8ZGKhVA8ZfF/uhodt78RpG6kQ7oUr3kFEvnKfWD+G
	avUD4xbd4aJuA/OiPUhtIi37xjOdwlFWqVgYhWgkk6OS9WVBLvtuaiyuBcH3uwcq
	CVKpsrXkd61W70fbRhxLZmwEBw8mcI2yRMpTPVgiGjStQ/ZC4wbrMQA==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 419pus0rhm-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 28 Aug 2024 08:35:11 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 47S7IjlM034678;
	Wed, 28 Aug 2024 08:35:10 GMT
Received: from nam02-sn1-obe.outbound.protection.outlook.com (mail-sn1nam02lp2041.outbound.protection.outlook.com [104.47.57.41])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4189su6eup-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 28 Aug 2024 08:35:10 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=BDQmiMToJl/AIxyLh8XvW5C4AqwQ0CfJqz/brgPj7kLkNRf6Gmqgr8wAAOHcHEEHF6batHd3hDr0/+UEjPdHvslifGlWN+Xd7z4M4EVrx3JGSuCvCZmZMSvvTV3Q0uz3cXexWBueZtTKEj/ENbkfIrILpBjeT9ejlCFfXlTpoBK6pvS7zhzKHw5coHg+Yirs5BOu/z843wFzY8KeXFQ4wmorJw33spGPaySje8izJVIHxLyUfu1lF7r1+8fNBpiT+a3V+a3sy3m44IxbSZkR54kSAWrflOFt3iWPmKo1RL+olI71fIQ/6bY0b1//UxK/GjFt4OkUJddB/fM5cFLzjA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=sjIOAiWp9rFbnnO0bNRDMOpkDN4OqVlyhfjsTiIXKAY=;
 b=YFiLZqMNT2TzzVSHXJZy7mfHtnAjCxijDcz4cuiiGqo9O2tBjQgebOSLTUqEw0FkJAx5fArMSNCVl4loLLH0jPwA0/ZE7/J2iklmKeXSsxf/xm9KZjePMjHX9jTqno3eOrb3L52HghCSfBWM8FXhfYk/Y7KNLOQfpid+HFXCIX2nT0xr3ObGnl36v7dU3v5SFSYUVZ5K5H/7VXk2gicwRTDN8J9DorsjjetyX6KX9uhHq/LWVkBZ7Oup/vgnfexTJiAI/NzRb6FLKkeconNRbL3xSk19RXDDbn6+GdMtecu9691tbvXnyBzBjJWNiV7Ejti86bJXw7T0mW9dYoxIKA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sjIOAiWp9rFbnnO0bNRDMOpkDN4OqVlyhfjsTiIXKAY=;
 b=fCMPd0gOQpW/s3fK69f+2dCcWthvBSojfQQ/gEYlfL7sf+o5JQAZ+4s6TgKvItl4vyKbRiglFtnuZR0K+mBkKFYijSuGw/m2MOL6OSs7lzMQSRKCj7XP35TSlg/BaGINeo4DUjGT4U6GOWD+b5HLp+OLHGki2EL2zdM0GfrSBNI=
Received: from SJ0PR10MB5613.namprd10.prod.outlook.com (2603:10b6:a03:3d0::5)
 by SA1PR10MB7698.namprd10.prod.outlook.com (2603:10b6:806:38f::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7918.19; Wed, 28 Aug
 2024 08:35:08 +0000
Received: from SJ0PR10MB5613.namprd10.prod.outlook.com
 ([fe80::4239:cf6f:9caa:940e]) by SJ0PR10MB5613.namprd10.prod.outlook.com
 ([fe80::4239:cf6f:9caa:940e%5]) with mapi id 15.20.7918.017; Wed, 28 Aug 2024
 08:35:08 +0000
Date: Wed, 28 Aug 2024 09:35:05 +0100
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: mm-commits@vger.kernel.org, sj@kernel.org,
        Liam Howlett <liam.howlett@oracle.com>
Subject: Re: + mm-remove-duplicated-include-in-vma_internalh-fix.patch added
 to mm-unstable branch
Message-ID: <44f86dc6-1368-4796-9f04-147626278180@lucifer.local>
References: <20240828025612.79FCAC4AF11@smtp.kernel.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240828025612.79FCAC4AF11@smtp.kernel.org>
X-ClientProxiedBy: LO4P265CA0129.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:2c6::20) To SJ0PR10MB5613.namprd10.prod.outlook.com
 (2603:10b6:a03:3d0::5)
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ0PR10MB5613:EE_|SA1PR10MB7698:EE_
X-MS-Office365-Filtering-Correlation-Id: bbdc870b-c5c9-4437-78bb-08dcc73c52a7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?3XmyNbDKXEMIPdvvOMbMXDIfJGN6SicQ1BqBEpEPV8Zby/K8eLRzeHx3++Fo?=
 =?us-ascii?Q?E5CoxXhwPnX83FgNdmvn+mE2CIl2sOhJj6Vt0Sr1BJ5KwYFzh0tHgFml9KZA?=
 =?us-ascii?Q?IkRK9Fg/++xicHnfASDF5qV8II0qCReUdGVEvmvojreIRP5RiiNQAI/nNHOt?=
 =?us-ascii?Q?cQdtHgX9SbpSIzpaWkwOfFzZvMFAMrdMIqEXIE4mpE1O9wcNv6ixrF/BUUV5?=
 =?us-ascii?Q?N6ahz30u7jl3kBU0YOunpRVFGI9/FQ2NC/qxs1L/L5NZRB94oITZSJ64anTj?=
 =?us-ascii?Q?gLjzqH3VptwdxdFgDyYhPsC2cWWTDlylr2a/0ZBkHu6K9RBdCGxFM+Kk/0zQ?=
 =?us-ascii?Q?UVEQoaW6EbwRzrWZtvRP8hzxVCZybCxcy3mFHAAZgQ+4vFQcUQqW5NAEIArF?=
 =?us-ascii?Q?dzKwwZxCzwRydjzCrleeQI4PN0uEK1Wp2xgpY9/aGbH7sRpgkGVWlurIvC9B?=
 =?us-ascii?Q?bTVF4sytvaTNAXvL//8WTcetGbudF9zx6yW/GIz7hyDFSjouHM6HDpM+nQNn?=
 =?us-ascii?Q?CVLJyM+jSFIZcJLhyXGJncFCOZZ6QnYoPnYlac28yMCmGhqZQ0h/qkRO5vaJ?=
 =?us-ascii?Q?n3v3dAmLpDwf8ou3iuldB7CwDvMohqchQjelXe4v4yttgjlsxV3GMPiC7duB?=
 =?us-ascii?Q?OSHIM1L7G7ELP7SwhRNfmb+r4po8j1Ery4W8EZ2VnApwxYqkHE5MCaeS53jj?=
 =?us-ascii?Q?ehKNUWTvcWoUhwLu9n6NygTpaQMRf669JHOICgAjAtg41zXEYQHsh6DKK83T?=
 =?us-ascii?Q?zoMkfxHkmeotPL1+7Z2RjoT15reaCY81vpHeEIBxW++/B4UCD2rAW5/r6Oo4?=
 =?us-ascii?Q?w/MCL/siETQItKcr85RM1Ak7L66tznw2QE70SWwVp99iE09Co0YwJk31y9OE?=
 =?us-ascii?Q?C3qrqK3onIRQgRU6oytaMebmS+5UPJmbtZsG4UjwabjknHuK0Xs55fcLOC9d?=
 =?us-ascii?Q?9qJBS5knmqkJmG/y8U2AFk7GZ9mHYMZqhdYwo/u0+X2DRp6Zqxi7CFIztJ6R?=
 =?us-ascii?Q?qEDgwimJIMqTG5LTFidzVNxHjFgMuDtoHzGCIkaxAYValOJ9bEKTycVbr81M?=
 =?us-ascii?Q?8m6ncyElz2etykLzmqlpk9N/h4KL8tUg4XYUyei0pJqgT5M/xW5p4wY1X0Nm?=
 =?us-ascii?Q?32ngqzWU9NZX4oS9oLPTWsTHTI3GnotQtL2J/qEsrlLVgXNljQ6/pL3+VOB+?=
 =?us-ascii?Q?zgxVC+THKT5S3UceC4tzIa0g/3eM1uvbbnsIO9rXfp/2tj1EIIKet8XKXk7r?=
 =?us-ascii?Q?MwSkigqkhSUowY8dV0jy+aEzyQdoNy2gjJC9wzyWQbBdf2p8ydcihz+Qhy9z?=
 =?us-ascii?Q?INtZDaIFRFJ950kZiV1K98Ig?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR10MB5613.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?F6AMmFMX9CmlrCfgk5KuaZ3D2QADBSX1JQrUlnvkSSnlVH/Kvnt4cMkRKOPu?=
 =?us-ascii?Q?q9tGfvY9gQAvhZrAOfj8M+GcaL3ZYnyPD49jI/tyP1n4dVO02tpKBV3PkxF4?=
 =?us-ascii?Q?fNL5icCKl+tAEfFWomLfBfg4j2GvdwnmyRVYnZI9Nl6ECabfuVOiisrIjJGw?=
 =?us-ascii?Q?A4NR3XoEy3JonR+90Jh4j0oCir2QRrpfVJ89EESCjB/fKrH7ZTyjF/WFSfKD?=
 =?us-ascii?Q?xLYTK8vHa1JrK/yZolil4yIkzXl+i/E+qSFdjuWfKsCRGbkt26mn2XHD+XBL?=
 =?us-ascii?Q?Xi+cqGSD2YYOX6/PedncMa+h+cpGeyH4sfQt0P0RkHsQn+vqcx0uFL8+wMZr?=
 =?us-ascii?Q?h/BZ39SXnozgQh5275vaQeDV7f8EYlJZGWOGvFJmHgR8T1KHdbeubayONcFW?=
 =?us-ascii?Q?hnqMzrmBjNHFMXIPvCgZiAa43h+i5MnjAkLIe7/oy2czi8Izqjdyly/1YYR3?=
 =?us-ascii?Q?mbSojyaC2qxjnEBCoyjWK6XN6zXZU8gtxy9rRZGQ6sUMIgj7kqLAB8FYMSZP?=
 =?us-ascii?Q?VTg2Yc5/x+5u2wS2sfiF6LdorrI705dGLBtzdtqcHERGQFr4PBz6uPuIXMdc?=
 =?us-ascii?Q?NEI64F9caI7GypkzIHJGuRXP/k+rkLVd4VJ953bqvMHVYK6dB3jILmnfHI/Z?=
 =?us-ascii?Q?L4AwF0rVXX6ldN9iyQbjQjBxYzVeCag7w41OG3GUeaWecImDgehspIH5Apju?=
 =?us-ascii?Q?9UA2xKo1kyiZwPGLjnMU0TGDvkXBSlx/ZUUeeoN8qSNQgVqv2sVzHZrM1+mC?=
 =?us-ascii?Q?wQF10R1DrtB6qlSQgRXoKJvrW2gxSTwh9ec5jrkyVd+3LNNFibD2qiXKfeN8?=
 =?us-ascii?Q?MskByYyd9PzPVtWWLg3Yn+8joLpWpwkABARZeNgfC2nYHPkaJtUbeRnXyasN?=
 =?us-ascii?Q?t3ediiKMPBXmI/IPZrAXJIaOomse5QJOmLjqastTUhF0B/QU15JFwz0xC16a?=
 =?us-ascii?Q?LDYWO0ahw4gTpzooBGyjcpShj+0U3ZFd0wZGRawep+VepPRHOheV+FIlh7i3?=
 =?us-ascii?Q?EkqGFioBM3DlLrhtj76wTWHnynizhcJ/H9csz6SwTbskUPn6uQjChlmwV2FH?=
 =?us-ascii?Q?wHMZCpc1g8x36hLifwQjzAXag6y5w1L9INKDzhRd/uJJvEDj/Kt1AROg3xBE?=
 =?us-ascii?Q?xPbx7E6HHAEOm2Ux3niC7o7EYMCSNQnLogshRD1jQgjaKLPLlROajklFr8IX?=
 =?us-ascii?Q?8hJd/aIOtxzUTpNzc1K/eCKEI0x55oSSsNS94scjLhW/Uw5SxL7hnfpqqUPI?=
 =?us-ascii?Q?BcM6S22K8Bu5PFSOdtorOWgto+2Ak5urVwHO2WBhoQlPuXNoZJPaVJe57fzX?=
 =?us-ascii?Q?EAEoPKm9TYjBxvx4BoyRCsJpugfJaxkQGsJCzjzKNWsRbhx/jnAV/fLvuAOG?=
 =?us-ascii?Q?Ftr0ls0iLvJffvS7MnzvNUgVKj3jmGGYGWy/vc6y9qiP1GPArxU1q1fZMjtT?=
 =?us-ascii?Q?L5gZh4+09ijalev00b0PFMonFFGu2Kl9LFWMXKX6yJdUGMg5KTw2gSi9dbRG?=
 =?us-ascii?Q?oW4BzAgqcFYcA7umijC44D4W5bYbpYfujoWaPJwSSnMv22gPBW0OCsORVrrb?=
 =?us-ascii?Q?apbPXYiaXx9xLe7tm1Vg8oiOKIEsggn8MYNr6cpW/jC47xq/aCFRhhQ1WI0Y?=
 =?us-ascii?Q?1Q=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	rBg/IF7EmM8CDrvckFhfwywY2LgE8iepKCwjXiwDaEnRtmPI0mNu7GbH2SJlf3LtsGPzCu8dzLYnZKBxcCu7s5rnqMexYDSXHFjjEHbM93zROpFEyPRIEMjmU9i9wrieKwNgZ2aLGi3SkXfjgA9YcqpLs20k9kgYdCG1Gnq6NMVWvM+MMBYjygKp0RqfIy5OuUdVx5C41IE+iOt3fDQUK014j9GOJw3djgme5Tz7iwphJc13VQ+4E6gCqUIY72mD1Qc0DvGlBEsu7Z426stSc2KxpTRWI+EfTjuP5XlH95NIDRHSrV/hL+QQcoChNlQrTnaFRMEl3k7NWI+/uV3GnV0YwHSMeJvxz7IoQUfVZDLZxgaD/dQe6OxJHis9+fKmroEZch+2BwqM2qMQ7nqYGt23gr4L0dBAmRpdoXKdAZlVMwJFbGsAcNVx6M+swFg5NOoqqiiC3t5YXqAS5NIGgzwXM/rticReIr9H/dBT5CH7hqmNGSuMuFFKSww573mNIfMbNejgTy5zk/J2/tSHZ2cNI126DWix7Iahh5PngIo2fDbre3NQi1DNosgVWRQphLdIvS50H++qxX+CgZeEBNRYHumfgncT5k6eKZZZ+7g=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bbdc870b-c5c9-4437-78bb-08dcc73c52a7
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR10MB5613.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Aug 2024 08:35:07.9377
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +VKKC0kyy/2QUNNX3v0/VYeOcdbp8o8W+yxuqyG4g0ui2arottIGTSP4tSp3FmYiaBd5xt4joIjLY6NhrOdyr55Tizr6blqm0sl26IZBScU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR10MB7698
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-08-28_03,2024-08-27_01,2024-05-17_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 spamscore=0 suspectscore=0
 mlxlogscore=999 malwarescore=0 bulkscore=0 phishscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2407110000
 definitions=main-2408280060
X-Proofpoint-GUID: hfnv_IYcQX6KKlooXHB4O5_7Tby6OoJF
X-Proofpoint-ORIG-GUID: hfnv_IYcQX6KKlooXHB4O5_7Tby6OoJF

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
