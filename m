Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47300217F2C
	for <mm-commits@vger.kernel.org>; Sat, 26 Oct 2024 06:04:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729922666; cv=fail; b=i145CXbDbTgCRtdnx/LG595RS6pfp1twuT076TLBxyhsIaI9yEJlM54+ADozyQ8PbWOKi6LTA2oXTc31lpMo+e9HdhDfEDQvF5C2iTcm+5ehccpk5/Pb9dSerp4fDQ6DQhKbF4mo5sxHCxeXwDK1Y8N/t1EUKu/RsqZRJkwu5gk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729922666; c=relaxed/simple;
	bh=Mo2zuQmv4k18RXWNzbTuysZYvaYtZsD6MaUsP81JOqs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=coqUaDwt4mmziFh046UGqY4VA9/ASTMjqUiQASbhhoS05zkiHPNb9ayzv4Z4VZMPKSyC6AZrw65k3orA8rbs9gBYO9F5Edw/L5asbhCK4mLYjl0yACfRHwDpKZX8cAk2n/eCSspsnzIcP7VSLFtUjnDlhdIYBmjC09aOig+0ilo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=AmsjGp5k; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=QV8KDN9b; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="AmsjGp5k";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="QV8KDN9b"
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 49Q4qghY029725;
	Sat, 26 Oct 2024 06:04:17 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2023-11-20; bh=i+08lwWmoKdSpAo6Uu
	vQ+/Zum2c71PvM0iphsECnMVc=; b=AmsjGp5kVB2VI01pomyRT9LaWtYXhaqf7O
	2WuOGyQshRYnPN+HzOAFm7JDHEBuDIyf5h2SjoaeWoLuHZzirk0j7j7fRz144fIu
	cAx6rx44lCyA7JV/c4vW9t6dje8nehB7mVaUeK+L+/8R1x8NNPG13sIeTkX8fiu4
	Df1qR95dk8hBmglmyurDtHddZ+zNRpyYjIqcIUuAO4I0rDZuRGFzrPqEsdcV3MMa
	BERvNWobzBhGYOQ3B6jDsgLIZks6Hv3n0bWoKLBrOLkPOyNreK5P0VfgxmQmOJbc
	XJLV/rhnZpfQDmV9k7dbkihNs7qXyk9TrDd6eZwKmlCmaMRalGXg==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 42grc8r2mh-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sat, 26 Oct 2024 06:04:16 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 49Q3Di84016354;
	Sat, 26 Oct 2024 06:04:16 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2176.outbound.protection.outlook.com [104.47.57.176])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 42gpv43pfj-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sat, 26 Oct 2024 06:04:16 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=xaTd1BYoLhI/LMzV6NfiirkPScXSe5oscSOO9JCQycBYS0Wf6T4kYjvnD2gx13tdye/opSpt32mz3RMcortJY0YzkMpFY98Jz7/0rtUUeoJoX6lQu+YHbWkDHcmsmq5XtlsIBtQdUjiAJc0bvpKnlVjiZVPYXaEt3sBt2+4pBh5IYno40+S7W6B4j3oh2CnrHl6ZOBp3X8gV48vtPRhk++qdwl2TZdZdfZFDoMFXaD1cd3393jDmUlLLgQUK0c9QCgkO4Xq4fofOCB0nxWQGWA/rKYA1zBCRQKKY9w8ZzfWIz1LOUpYP/bVBOzsR4asaucGLX76eRmPUczk1QRXTHw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=i+08lwWmoKdSpAo6UuvQ+/Zum2c71PvM0iphsECnMVc=;
 b=MqSzbqv3C8jKThh8vMtODf5/DGSlodPqwqFySijlPhYAgxFUeNj7H9BjZYNAmgQa9JhLjERFjxsjWtuMPxhvPei+O7HtAHrnOLpPwW4J7SoK8OVis+EY8ORb+AKYN/j9IeSFH9HTK8IpQpLpqiYeyzyxS74XXVaWadIZ5uLP3UGzxR1QFx60PdBZ57Jft4LdAkESkUB3K6RBd60aVXDhiCCH5FykbXAm5CZIk9rVDeLM8ShoSvkJoB/AGZI79aNUa7+rBQe5yyKdkz4hrQl+UWg8ewg8ZTLfN0mobSBRKCkPTd578MxHCTIJ2DgU8CvcoIzkAFtQstIibO/HjXPHgA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=i+08lwWmoKdSpAo6UuvQ+/Zum2c71PvM0iphsECnMVc=;
 b=QV8KDN9bwrl8CMHVPCc8139hBjYC9Kz1JKaq1g3YrSiun+6Krkb1X2FcJLxO2+CEqPc7UFpU9GIJQLuDyeNv2YT0UYFqCZ5E9sQuLIc5PgPHotXtd/+EtpS+Ugws/mefrematW5yDW1bpCEtY3zM3j1SpPHqxzHRrPYpPJUPdak=
Received: from BYAPR10MB3366.namprd10.prod.outlook.com (2603:10b6:a03:14f::25)
 by MN6PR10MB7519.namprd10.prod.outlook.com (2603:10b6:208:471::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8093.21; Sat, 26 Oct
 2024 06:04:13 +0000
Received: from BYAPR10MB3366.namprd10.prod.outlook.com
 ([fe80::baf2:dff1:d471:1c9]) by BYAPR10MB3366.namprd10.prod.outlook.com
 ([fe80::baf2:dff1:d471:1c9%6]) with mapi id 15.20.8093.014; Sat, 26 Oct 2024
 06:04:13 +0000
Date: Sat, 26 Oct 2024 07:01:57 +0100
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Wei Yang <richard.weiyang@gmail.com>, mm-commits@vger.kernel.org,
        vbabka@suse.cz, Liam.Howlett@oracle.com, jannh@google.com
Subject: Re: + mm-vma-the-pgoff-is-correct-if-can_merge_right-fix.patch added
 to mm-unstable branch
Message-ID: <58b091e1-bb4e-43c6-b049-c866441070bc@lucifer.local>
References: <20241026024123.B621BC4CEC3@smtp.kernel.org>
 <20241026033436.hfb73whfbeypxj5r@master>
 <20241025212224.c03b14a7d658edb9ca09aa07@linux-foundation.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241025212224.c03b14a7d658edb9ca09aa07@linux-foundation.org>
X-ClientProxiedBy: LO4P265CA0308.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:391::7) To BYAPR10MB3366.namprd10.prod.outlook.com
 (2603:10b6:a03:14f::25)
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BYAPR10MB3366:EE_|MN6PR10MB7519:EE_
X-MS-Office365-Filtering-Correlation-Id: 050ee3ec-c12b-41a7-e3eb-08dcf584043c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?nVmbPboivCcTwzPiueonW4e4gLXCK+0/xEQb2/H9aUPQhLsyIhXO52qGwaPv?=
 =?us-ascii?Q?0ztWVsO/2fbWEr1vixtijiej1n9LWnX90W8ykqUIQ71xnUYe3vS3qqLaXsjS?=
 =?us-ascii?Q?oe4nkHX9Mvay0xGe/3OQmgB8AiI/Q+TtmlydrUNiv8H0K1/1jQRMgjPAc4fs?=
 =?us-ascii?Q?H4C8Ggd7fnZeamRJafJT5TX8hfLCHN0OcVdh30YjHF6fHmhCATYXdLCobYii?=
 =?us-ascii?Q?cKX6FdObBXLIK8rEd4t+5nG4yZfIp171PNIMlsGWFVa8NfwEikXP5Itowerr?=
 =?us-ascii?Q?yG4Otzsel84MweQqKzzMialdb0Yr0Dspgv/dwsOnZQpszGA6QY36TM2j0AQL?=
 =?us-ascii?Q?7M2I6oFRG0YePBZ9MHiBFDdL1MNIhR9K5jDcBnYq9Fp/4IMIbj1XIefqWvWQ?=
 =?us-ascii?Q?6ZQaSmVsyXvBZMuQ6IQSVhSk/OO63DiCwE2F6k377uGjpuPk5kvt8UluFoGJ?=
 =?us-ascii?Q?ZebICFMdToDNXklvKgjA3TIkTtMjv6IfAp8/6qgWOJE0FVWAA+YyCqt2lWj0?=
 =?us-ascii?Q?DOQg181Ri5RikBZ8bn2lVA2xFyJZEN0sFs/2P9TixSiykD0a+Gy9oLcl1BFI?=
 =?us-ascii?Q?WEXcQcha9rDM7f0Z36JLiC6ZBFkjp6cO8VThI0w92HrveWxpA4N8wI4cvgWx?=
 =?us-ascii?Q?/Lo0gHkIeadwwSAc94FLidljr3HHkhQIHRD6zR1x8tNeDnNEMmfwrsWzDGJd?=
 =?us-ascii?Q?2ru7tRL5thz0Gvt0DIGU3kQUmYXPgLnyarLrvb5bUj9z0bboaxn0MVJh4Xdu?=
 =?us-ascii?Q?e3ADX/ElElrULCq4AVEMgoFsYDL4FnU87Mk71Pu8snk5wTGhRvt3JbsWxjth?=
 =?us-ascii?Q?iVIugSVCzh2D68Pxc32k6dP7VS8rGM2Ghd4Elxy1egpxYwhiHMkEBBG7/aaz?=
 =?us-ascii?Q?O0mLDgkmWMNylCauxaXMqkjZgNxTe1bsfVEirurA45UX4ot3E93hmDicGFvM?=
 =?us-ascii?Q?iqZa4wzEOTPutqE1Q6nXlUI0qWSq0j/r3ITEAeNRfySIq1qcJ+3c8cYmf74d?=
 =?us-ascii?Q?9ZzedTcBTjXHXI9xDpcxUhuEwMhzVB4BKSZ6pgnIF/Xu+uEnaZ6r1Z/yUZGZ?=
 =?us-ascii?Q?f9o5cndj/ZZmj3C0vBpMg9R5s/xcX2Vq5vEiEXFsGhYkdDs8hxeX0sNRznrA?=
 =?us-ascii?Q?MYAoi3NAiTOYiwhND/64fjs3qKIIQa/j0bD3HR0dH7M+59tq2Y3rK4df13RA?=
 =?us-ascii?Q?5d/qufklHBwkhKCFVCNRZCJtM/j+dXwIVD0FmGi06GYdP2lm5YviGPYdDhO8?=
 =?us-ascii?Q?FAlkyUHnJ4lskh1k/KVwuNwBxHSoB15+D8uY+wWZat5CRclo7VhTjn50ODDN?=
 =?us-ascii?Q?OHe4w9pu3XrdZfzCebRV1wD5?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR10MB3366.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?AB+MgNsph5+unWI/dqtQOBfUiqGLG7Zc8OKdzVhvzJr4ylpEsbLH6wWmNEoK?=
 =?us-ascii?Q?LBdCtYb/OGgM++ehEi2A9YKsrWNSf/NkpWPSQbkGdzjtnHtlelngR/uAxYr2?=
 =?us-ascii?Q?0Ug7PEM6df4ySuTx2zkMrSs9MhrW2066ukIf3XT5s3YxhzBDuBvbHZ2rCBCn?=
 =?us-ascii?Q?3h0uitwavS77oZC/rcNpwNO+O26CK1PG7eVxOc3w8GYe0gVPtfxWYcmh7Kp5?=
 =?us-ascii?Q?v9Ynpq4Tr3b8HhjBe50CGc7b3u8lznjJnX3ac5d5Q2uvoLz83C01Yvxu+KbZ?=
 =?us-ascii?Q?pU/+3UZBSBE4xSt30SXjRPtBOAlhOKiDaSYkgkJgN8fp31NBiX2IfvOMkpmJ?=
 =?us-ascii?Q?+OL6OV6yyVi40+L/xNqvZNhM0YfjdEX6PNngbFYCrtdub1wiAMjXnlb18+wN?=
 =?us-ascii?Q?Q7zSRX60HsuNLgCk1VJEFG43gSBemx9I6ML8u7JGVw8UjM/RgAbkAI4W7uba?=
 =?us-ascii?Q?NaTyUqCoPEdrCMbGwpQQ/cuvurm5eGkIULGafHWxxnWWN+7twVoCcGTeTKZ1?=
 =?us-ascii?Q?pVvKivXV0fQEwRpAMg5ZXYikW2+mqbmln0vT8NAXBLe8YgyF1yjDqkYBymkx?=
 =?us-ascii?Q?aWnQsL5rSJvBQpv5qXnm/BrFl7+J7bfgEgHJysNZn5FPPbNwpumGpYQ9YTWe?=
 =?us-ascii?Q?EhLJY2l0kMdSkn0OLueyR427/HeTRtIx7c6xDF4X3M+C/6+p/HZuaCDvwJsx?=
 =?us-ascii?Q?8Urp02LVuyZg2ZWDRyF1VxCHTyQiaWbBvMZGLkqElmz0CeJMAIHPUu8Nx6am?=
 =?us-ascii?Q?G3wWcpRGtnvhOZ3jBfcNo4Dyi0+ySjmSivOhV30JtIGd67+DJvAocycsNv98?=
 =?us-ascii?Q?NFtvIz9JiiXU7z8LNA2VfKVmtOtfWccewebpDj2HPpRQH5udrCPZe+ZbPHMj?=
 =?us-ascii?Q?eLuS4MtA0T1cwpAqUTKzTcjjFEGdsQMRVUGJV+iDmosg99WDbwK3v9tUsQD+?=
 =?us-ascii?Q?U/HUP+gRHShK8sx4XE+vHo8WRq0qZWYauMugN67TyWXCfnce23RgKvzrCfXp?=
 =?us-ascii?Q?Nge4HA3rFpj065UESwGnG8TfOKOAPMNGaIAqjRG0OL7xPj8aa+bnhKjvXQmK?=
 =?us-ascii?Q?PeA9k69hxMaPAd5VOMxhExVUJs0JJar/bLxuv7Su5D94toTrgE4iXA4fYEfF?=
 =?us-ascii?Q?vsHvAnKYcYjr3QrKLw65b0kPpjF1YsMXnzEUirdU+b5LT6XnemgR/hIWK02T?=
 =?us-ascii?Q?hhF+XtGraZ+QkcJkU+mgNbWP9BWavUb5g4sVuSYswTXL9CAcFCw1ePTSd2/W?=
 =?us-ascii?Q?hnJGTLCOnDWiPrI+tUoXyOcWpmjtw9jbcVEbZ/MMJw3j9gkUUVbRIFW3QvnW?=
 =?us-ascii?Q?dTvbpC9m7kjNr7uWAKi7qaeQ0GrksA1pHwApJ0UE/52Vv/5YhRBcT6Cvhg0D?=
 =?us-ascii?Q?JmSIc0j9hdb2Phfkk8lKhhMVjMhvLe2ZVVuu9zYVEoHTVY3SX4Hr3WLxbdXw?=
 =?us-ascii?Q?CaLkeaIUX107rzwXcRRn+xCDfRiaEKdY40PZeM8aV6J420RtCUh4ORuwrIxB?=
 =?us-ascii?Q?K2fHEGppYFm1H6T4OD0VxEOB/cnTVszy/PD7ESwRCroCJzGPtWZaFWYjjHsq?=
 =?us-ascii?Q?1R8UZbXlW9XYPoZAZPQTNCFUo+LAEIZazJtWv+pDYODrj8nZ0mM/cyZVgg4C?=
 =?us-ascii?Q?uA=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	pjuOTWttusnYNTNTgpu2P2SFzDFDneGcW1ii5v1fdyzCFo0IrBCFFX2DevcPkHWCsDp9BqGiZj5S8RKjzURF0aXqcTLjzYK2wn34fbj/wG071vJKl6SWYOlUebXmFh0XmgUmstkUrXlsfCv/YOIwopBeS00gJDDfcUfugLqo0nkqy948kcvpFW/m4oVpRHNMYi7toCOOMp3cZ1agKYXzp/SKT0sc6lA+Y9L54N+s+YIe0IkfGleCvH2SBO4JxqETQZoiisQfvH8QIXsIcMRJyDtggEWpvmD2u/htrXkP1tqQXeW0tELoJ91JUQhPSgpt4TdhUSsMojxlLYbL2ggtXYkwYmCHA/lQlAvD9kWOXujumOGFpb4qm1CqrPR+dd9f2TLkLbz2h7uHUZ8D7rtLT0qJZd6aJAcDTTLmMrOnxDuNGnXUYCiyr7mAXsm8xCjQLSkRS1rmh8il46DAPy3Zkwx6cKCRMe4CqItTKc1zCVXXaqtQXONbuVSMqhGNz4QxxztWdfXFKujAncoVXpm5HMJDJNOisO5GEXcIwi4wvddG8ta2zZiPJXgyjBoOYb1QwnKT/8Y2Dhq7vH7ZxCIJQsg7vMnhuC6UWN46cP1JpvY=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 050ee3ec-c12b-41a7-e3eb-08dcf584043c
X-MS-Exchange-CrossTenant-AuthSource: BYAPR10MB3366.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Oct 2024 06:04:13.6935
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: f1az3Oaydr06hsHqSpl++pv1IOqxiyNM2aAT/3E1amBy25kLLNikLUJ/ctiSaTcXexncCrwbUG1/DyKmQkXhs2CEpJrqv8Xb8WUcuxvGXZo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN6PR10MB7519
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1051,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-10-25_14,2024-10-25_02,2024-09-30_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 adultscore=0 bulkscore=0
 suspectscore=0 mlxscore=0 spamscore=0 malwarescore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2409260000
 definitions=main-2410260049
X-Proofpoint-GUID: 5x7MdwKDRRiy13qUBmUskSc9qxXMTMnY
X-Proofpoint-ORIG-GUID: 5x7MdwKDRRiy13qUBmUskSc9qxXMTMnY

On Fri, Oct 25, 2024 at 09:22:24PM -0700, Andrew Morton wrote:
> On Sat, 26 Oct 2024 03:34:36 +0000 Wei Yang <richard.weiyang@gmail.com> wrote:
>
> > >------------------------------------------------------
> > >From: Andrew Morton <akpm@linux-foundation.org>
> > >Subject: mm-vma-the-pgoff-is-correct-if-can_merge_right-fix
> > >Date: Fri Oct 25 07:39:41 PM PDT 2024
> > >
> > >remove now-unused local
> > >
> > >mm/vma.c: In function 'vma_merge_new_range':
> > >mm/vma.c:965:23: error: unused variable 'start' [-Werror=unused-variable]
> > >  965 |         unsigned long start = vmg->start;
> > >      |                       ^~~~~
> >
> > Andrew
> >
> > The removal of start usage maybe come from another patch.
> >
> > If my understanding is correct, 'start' would be used to restore the state on
> > expansion failure.
>
> I don't think so.  This patch did

Yeah I removed the logic that would do this in a recent series. We can drop start.

>
> > --- a/mm/vma.c
> > +++ b/mm/vma.c
> > @@ -915,7 +915,6 @@ struct vm_area_struct *vma_merge_new_range(struct vma_merge_struct *vmg)
> >  	unsigned long start = vmg->start;
> >  	unsigned long end = vmg->end;
> >  	pgoff_t pgoff = vmg->pgoff;
> > -	pgoff_t pglen = PHYS_PFN(end - start);
> >  	bool can_merge_left, can_merge_right;
> >
> >  	mmap_assert_write_locked(vmg->mm);
>
> which was the only usage of `start' in vma_merge_new_range().

Yes this is true now. We're good to drop it, thanks!
