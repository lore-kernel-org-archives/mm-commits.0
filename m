Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67A8C3D76
	for <mm-commits@vger.kernel.org>; Mon, 12 May 2025 23:51:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747093872; cv=fail; b=jC10TIwOKjt6t6I9v3qVajj0G+zmzWvnvYZ6043hDq/E7rRQS8ZZZzQ6EU5/TkWd13GHga2P26dkhccpQmHwt7RE8qPTVsg5oFTi3M8Rf9/4pJNCyRtx9XBlT4l4BMDXdOUsAmnLPckKnVU2N+DdGmAOqTU1sOGGQyQcgeVkTnY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747093872; c=relaxed/simple;
	bh=98psouh00dDljMcOB3YDxk6kdjq3gMqL2peIla+qGrg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=NGBcw5s1/8+O1eKK13LdmV7xz5+0KD1Q3qIi2UTxwn+AmFHYVGvdOWbcA/8qnLg/Ay0SvOuGDJ4IsmINhPnmUcioK1CAPavMuoLSBHvz7JdAaROrGQpiEaQH5J+2TiRMvi7023WrrtAzGlMyV/giE3i1bufyAJFT7o3wrBZAmdg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=ZL5HWV39; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=xCloHOeK; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="ZL5HWV39";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="xCloHOeK"
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 54CK7DbI022855;
	Mon, 12 May 2025 23:51:05 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=QEjBJdJKEygP+p4lYb
	9cOtJcyi8CP3NgN/AdWef+1hc=; b=ZL5HWV39KQUSu23MqAuh4eD9eiKFPi+ZHZ
	xsxgEAQEz32vhMn8iaOvUDVemO4Cjv4RHJn4TlMxNEWOLgN8dzFoL0QMoA+ru8Gg
	c9yVQB4Zx96HBIT1Pan9DuR0OW4oMZapLsliGCSQWgfkCH19pJu43NDem9CeW4q+
	HLD2DnW79lB72xEgHYqo8m8DzxaX+ScWy0CK2/7RSsLy1ck832HfweMqMrIagPXi
	sXh33eM3x2NFNllKDOZr8sA2dju3/tiFMPAotTwcBJUfD+x6YAxxDkzdtW5eb51R
	xXuzZu0IsAq8RTjOMj9FYXTI1vN5Nc9KthM6fzH9hkhNfOSlQ4rg==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 46j11c3jqg-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 12 May 2025 23:51:04 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 54CN1XwM022289;
	Mon, 12 May 2025 23:51:03 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2168.outbound.protection.outlook.com [104.47.56.168])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 46hw890kpj-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 12 May 2025 23:51:03 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ulPdE7AGld7ia0oTSb5V61jPE+bj/9rj98ERI63HYjdj6mF8m1drQxCGXCl7Sz9+IGhEzhfieSuOd4/aVP8qxJGO0OP2Bx12m0Qv2vvdGbYc3fWB8/jqlhIgX7iBJyaIE66K0p31zfhIYXuhyJeXOsqP2kUrDrd3hcNdbWSogpqV5mSs9UQIAPEJ9+zMd9i9ipUX1YC3p0NGJeEZMaIyQX9gzLr39o0GUWNgs6AZpiBOnPZFkHGBEAOvdTQq9RsvqqoCE83s9iVJB/OCpFzze47eTBGFmx7kFW1EeGC+10/yxQeN15ZQqtxglJyvcZG1qN74UBEUDo4hzMRBfSfXcg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=QEjBJdJKEygP+p4lYb9cOtJcyi8CP3NgN/AdWef+1hc=;
 b=stNrUqUFs0bsPgReyjTHWXKA1uM3ceY2CpJ1DRDtPGsoco3iLZJewKrq7EyG6Ouve37WsB4R3mQZUhz8JOPq6UEJmiPdjzJ3JibzIjgJsVOH82gPF4bZN/0qXet5HhtMXbqx4DeOke5LN6HzbjwwWmvfo3AXZwggtja1AGXGQUH1wp2Hz0UTULD22xMpCNbosPC2U9JsqVJ9c2j3V9w8KSJFFSCVhdQeWniO2b7mNCGOeFe85O3gKJ8sNCeWqZNd1CR9dtV3H52VRjG8cDd3F2iWvPMGkShniXYM3K9/RFWtQyWx8Tuea0+A2WvQoyj/4ST8EY1+qgKCvXJhP1zL1g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QEjBJdJKEygP+p4lYb9cOtJcyi8CP3NgN/AdWef+1hc=;
 b=xCloHOeK3Vox/BMLlVvVaW2kcJhRKzW113ozveBZjFbwHc1MsHCOjdGWxNdBWjP2SXx4BevWyxCZTMy6CWYMGPKn8Q5ngGXzFENmXYBH2/TEq3kIqqoYGmBSQXy66sJyO2avPJi2vXycvMrjo2gnVxX/4bv4uyrdnAG/ddGcYb0=
Received: from CH3PR10MB7329.namprd10.prod.outlook.com (2603:10b6:610:12c::16)
 by CH2PR10MB4358.namprd10.prod.outlook.com (2603:10b6:610:a8::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8722.20; Mon, 12 May
 2025 23:51:01 +0000
Received: from CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::f238:6143:104c:da23]) by CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::f238:6143:104c:da23%4]) with mapi id 15.20.8722.027; Mon, 12 May 2025
 23:51:01 +0000
Date: Tue, 13 May 2025 08:50:56 +0900
From: Harry Yoo <harry.yoo@oracle.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: mm-commits@vger.kernel.org, ryabinin.a.a@gmail.com, dja@axtens.net,
        agordeev@linux.ibm.com
Subject: Re: +
 kasan-avoid-sleepable-page-allocation-from-atomic-context-v7.patch added to
 mm-hotfixes-unstable branch
Message-ID: <aCKJYHPL_3xAewUB@hyeyoo>
References: <20250512222307.ABA4FC4CEE7@smtp.kernel.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250512222307.ABA4FC4CEE7@smtp.kernel.org>
X-ClientProxiedBy: SEWP216CA0032.KORP216.PROD.OUTLOOK.COM
 (2603:1096:101:2b5::19) To CH3PR10MB7329.namprd10.prod.outlook.com
 (2603:10b6:610:12c::16)
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR10MB7329:EE_|CH2PR10MB4358:EE_
X-MS-Office365-Filtering-Correlation-Id: 359e14d3-1244-4c9d-5411-08dd91afd976
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?L5OQpZ+dmwjoIWlyOuY5AW62gf2Ozq6K1rj2scM52hdexmkRDtNImzTeEY0s?=
 =?us-ascii?Q?7L6saIQOL9vFjw6To5XyE7y6o5ccO1Tq+wjtuo4uFJ5P1mepFPpJ83gY5W6r?=
 =?us-ascii?Q?7ah2PsfwH/lDdaCHVk07kGsnZ/OTYSn2cflLA9GhddiTd14/kdl7JxEK7BYY?=
 =?us-ascii?Q?VK/EdcMkjFtKSrm1B3MKxU3rGejTzRX5h5Zn8GeNoXpu6Oo0RLkHx4sgQIR4?=
 =?us-ascii?Q?a7UX0IxJ17NvDB9S8OwRtmwHSVjh7R6qCkdEQOUkZwNml7GJyZ+17AwA69Qo?=
 =?us-ascii?Q?5lr57fDmwUKvN92nAhhfh3uTetkivUf6va9Wdp87MKBoW9UVQNr8YFWreV/X?=
 =?us-ascii?Q?RP6z9L8Agyld/Y+MQ52O2xq4ImGYpbCuY/QNq6eY92htFzYHUcEGK9UC5n3C?=
 =?us-ascii?Q?dFluXNdJf+BUMFHkFe6a/nChqeqoylT9rrzvtlKtAdIE+YZGUv4v0eAb0r3W?=
 =?us-ascii?Q?FrCyM+/mOhPGDX+Y2hiz3R/JARohEeHtsiZP7f8i6RwQxfa66ZysudQxJXgz?=
 =?us-ascii?Q?Gv3RUHgyfHmqteX6uND2YVrWqka/rCwPahE8HfyPS5R/jiNQZ694KyubKp1r?=
 =?us-ascii?Q?A9BHe1X4V7JFdcz96oKbH+V8fJttwdzA4GsR4DMCCV8BR8OZYXrg1z8IferE?=
 =?us-ascii?Q?B+PBiSbRcUXyX4YBJ7MmF3OMe/1f48tnt7AfJqPsAJnVqTKCGiRHQQXUPjGZ?=
 =?us-ascii?Q?u8rPszD3KC3G7KOVBAKfAgXbI5TYQCCojKwgbuxy6wTy/8rqnrfYJdLGyqtL?=
 =?us-ascii?Q?NFtHSE4kuOeYlpL07fP0xnO7G0bCAcli30wAPQS58n9+7MBhIVjRw1xSOMr1?=
 =?us-ascii?Q?0xOMatJYIwWTdJJMoA3kqa+2NrwJ2awbPK3A7eels+RlDNBzpNnWX/vqDn87?=
 =?us-ascii?Q?W0zXCSeUl7WtXS9/e3Ozk+nucIBEI+dxf/DZfs+xCOYbNrvXFJIw9lYq00nK?=
 =?us-ascii?Q?Gkvf1/+l7yKyMtSWqSgy6O0VAFPcjowiddPiwkw661XExRDI2TypS+/1ijdv?=
 =?us-ascii?Q?Tb3C4t/w/1zTKawZVfcYm8bMxStPpUiE/UYFc8UX2ZLP/61OF60w51SNSMYk?=
 =?us-ascii?Q?UUf/ib4wI/+Eq3Pamq0ee3xlF7FGc6EHmPiSYBOV91NxlqQLF1Mq2I+3rrf/?=
 =?us-ascii?Q?q2HsO0Ud/5weH0MYO5MI0up/bWKfHNAuJ4ZXjt4ZCgF/tQHaU9hchAJUFdog?=
 =?us-ascii?Q?0WgjsB69b0Zip5BLZphkEEUkdGsuj7mgR3oI9WXMtw4m/A+5NxFnUnwfM6Ac?=
 =?us-ascii?Q?YKrZJk0ROCuZ303u1HpCJXVmlB9XW1MrVORjBythyc8xIHe6IkKNQt47RYnO?=
 =?us-ascii?Q?dWQtAJSaIBuZlz8UYFg5eykgZTKqLwh/0b1JPtUJLSnQE075mGyCtc7HSZ4m?=
 =?us-ascii?Q?uNoN2+DIYwrNZ8RSCFZUlekyHxw0W0aQKsFiggyeEpvH/poW7gRtChfwLfUq?=
 =?us-ascii?Q?0SiLF1xQNJk=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR10MB7329.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?OrTmnpiHvTPXAal6Jk3TwmiqgR/DL6rp93Vz6NiQdvKTML+2lsbQ7O0amz60?=
 =?us-ascii?Q?rg/YCHSvuKqsqjjcR03PUEv7doBgqZImdhxSIZkuva62FoLDSIT20qlyMhYj?=
 =?us-ascii?Q?A02151ZfdOPsTCkejNRefNmHyNlhNibGZ9EVUEJaaWjjp+6+Hu2gsdI4Xfpt?=
 =?us-ascii?Q?EpZ9e6n0DTsl4dGrxhehG0uHJG8dAeWt4YYBRdOfiQC91ReU8AW4TQDPle0P?=
 =?us-ascii?Q?QVnbivu6/JcNhycMaQfOoxwVy+KEmrj6vpRz/+y5yAN9ELy6E/gNId1G7Wbm?=
 =?us-ascii?Q?w51CzJB1yOZYq43fB51pRxCK8G+0BqjBdJM1W8jkfTs8ywZFFhDcBh//nYIC?=
 =?us-ascii?Q?aGS2bvttGwFgm+HTC5WjqfYcxdc0JZss2SSGwqvPtpvF8Jii3YpuMsYn3itT?=
 =?us-ascii?Q?irpqhHNiA9/ysQc5BU9NnxNbRCepl4FAKNlJjB/CUk1j5iQQfoQ10HcQqK+4?=
 =?us-ascii?Q?QvmMlTepqrSr2MsrOyQR70Ks75bhDeSt8NG0OaJUCwRLNBT/B9KgaWsHGTGB?=
 =?us-ascii?Q?POF4rEHe/5WvyKNLDHn6V/XDblSu+C0yLpFMZvfaI8gwY6nLqvlRbXndqCcb?=
 =?us-ascii?Q?rPY1KGHoBx/jgRW40s2BNZfikUV2SG/NHw7X13K1jxvSgvEBdrGi2vLDUFcH?=
 =?us-ascii?Q?OpVuWQ8jwrXQoUTA4/qQtdIF6GUZm4yu+HNylbc0xgSXls1wjvp2C4flTkIV?=
 =?us-ascii?Q?OzFivvhEkHrYc7slxEU9B2CFXsy9GIvM92yGdPGP4zJycZdnJM7FvvV7b4s5?=
 =?us-ascii?Q?1AHZocsGaJFqpJAV0nL2xAhzmDsz6y8U7JBkkqDQDWPJMIUSeDN2WGvpz2l0?=
 =?us-ascii?Q?+BpX0x5v25GmqVzVHLJHUrW2oCMa9dLZrFCsEH2GYtFoV/JYrvUI/Vau8cPj?=
 =?us-ascii?Q?fh3xsVnpuaO6oz9Z2FvDvh/3I21GINpgHimiU6Y89L7b+0GCV6jf2glGnPvZ?=
 =?us-ascii?Q?9bqtj/5Ppf3q6gcBg06nXg0Odf9GCReF31QjQhpuf2thCAOI1NEcHAYDnHHJ?=
 =?us-ascii?Q?q1OemY/E5oGvqHiE89J6YIEtSYr093dyl//YBeJI4WyPkZEx02yQIR58ZZmw?=
 =?us-ascii?Q?RZEZVneDQLHGXJtNCytHMJKwYXNbm019yaXewgkGGSUquVG+X5dm8J7YCAIP?=
 =?us-ascii?Q?fNxT/UYXiP7wt1I0b+hqxszRVTTQmTzgJyYaOlauUlxITPjsaGiAnor7rfvg?=
 =?us-ascii?Q?Ee29PhBvPpVzOr7/rw81wq4YyFqYd4T/aDsqSeg0Nc3hSxe/pMHUJuvFSN11?=
 =?us-ascii?Q?zfi2FfsQ7iONRgNu2u/ZeANxZmrzdMDA9sNq12i9YXrNWT08ei8m+3HiLWEM?=
 =?us-ascii?Q?vHdlNOiYK+RP1K5oz53Ol/YHU0g7jUsegfbrr0JJU3u+4qiMeIdZmY9c4z3s?=
 =?us-ascii?Q?RdZ4/Kde38PAsqEKo3lBqzttk8uN0gpgCvMCpgrJwqP3Ub/qDnBWqgtPXWoa?=
 =?us-ascii?Q?aUWx1gL1Gjv3kbQktiiDRJJUXe1rOKKzaxGXE+lNJN6dhCoEC2uGLpv+AIVj?=
 =?us-ascii?Q?qmWSIi6t4bSCXD3o7egcsNsrfFI7wfygw7+yixzW804uCg/q5aWj3pRZv4Q0?=
 =?us-ascii?Q?nJn6e7Oty49+gi294mRop7Cu5XTuvPFcrxRl3E3d?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	9kyyVFpyW3OQxfD4h7nmxM+kHveIuRiqxH7cESVGqdOsxC2Sm3P00Pp2z1p/x/kDVjmFsjvVTW6Kz+uaqGNTjNDyP252adIi9L+ifTAdQsOvMdn4YirhG3+dFyQb2pZMGtJjVdkOERBe8Ci8+eUtUOldydIwXJ9UkeXuQ39Wnlm8PWmOrhLP5c9/jEWwUgb940tSc/xIktUozVAS+K95zBUyT0SP3QfVtr+IEjjEGU09DI92GE8oavycjM4A2qh6zs9DW/N2hUtRP50dkeUk18zXiMvcIO5OPpGC+y/i/Huj2SjOoemPWZzoMkAtMUjTPRpKZzL9x6hdDPx/PO2eslbgu5IpgItY4a+DNkBrnW0ckrhefmHs0EqWhx1HQMOYPVEW3US5FmM9tkN7n5eLrR75SNxpKGJF8pa5RzmMO/FapP5kugtPcSDyCGVv4yZbN+akFU7BypDo/ogvaWu9S+KlgzXFjTq6WmKKCZ4zyXuKE0mHNzsl+HMZFUEGtRHjh/k1VIIpkXhdsInrZHKZbL+xeNb/56gcEEQMMdlCpI3ia8o02UtqB7WGIbMaOSUPxDLU4syYCdEems2Eim0SYhvNRN1CowkAhIchECTbUZA=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 359e14d3-1244-4c9d-5411-08dd91afd976
X-MS-Exchange-CrossTenant-AuthSource: CH3PR10MB7329.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 May 2025 23:51:01.3528
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 3poAFsZs03OxR7q7DBMFeKmgG4gXSHHTAlpKfq8lUp06wqkjKZAPJ6HUBKAidW5obOMYykAFyZgeXVQfWl0ThQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR10MB4358
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.0.736,FMLib:17.12.80.40
 definitions=2025-05-12_07,2025-05-09_01,2025-02-21_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 adultscore=0
 spamscore=0 malwarescore=0 mlxscore=0 phishscore=0 suspectscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2504070000 definitions=main-2505120245
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNTEyMDI0NSBTYWx0ZWRfXxqdUxmKee4lz oYSCSiIz+o+PEAhLAvlXK2qIFWV/m6ey6WM5iXmB1xZ3BiyS/fADJc2MBEXA1ad6ytQiEpf/naY 759eZcM5Y+XvYBEwSSn19Wd3CUkp2fUFs7L0OAzHQPI7OutUKEdMY4iXZHTc0dFtDAJOinvAkPr
 pzoZue2kJr+hQNpJHu0+Ro1T0qaVhmivz4lNoG5LbSDLIoK27WygdEwxOPl4RUzoQmSvtFx0kGt GAd3D8PvMPyPHwDvtbIBsZcZ+yrHpRfep3cF+lmAf+h2EkpVOp82kVBq9q3mWJHJA1dTCtLcHwq pe9R+f4EKnyhhlgbanzpGGAXgfEspqZKq5ZIpgMEumtMKv/L6ntSi9t4mvTs2+sOBLWy56cwIDv
 5O+NlmkEpUqfnoCn/kB/MBQp9OzIdy017jmET88nlkeJT73ongOfiqXaElqB1X55KxVNr+GV
X-Authority-Analysis: v=2.4 cv=YJ2fyQGx c=1 sm=1 tr=0 ts=68228968 cx=c_pps a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10
 a=kj9zAlcOel0A:10 a=dt9VzEwgFbYA:10 a=GoEa3M9JfhUA:10 a=VwQbUJbxAAAA:8 a=VnNF1IyMAAAA:8 a=pGLkceISAAAA:8 a=yPCof4ZbAAAA:8 a=JuTF4qcAAAAA:8 a=Z4Rwk6OoAAAA:8 a=HkjvVkcSvAZes_ZDbVAA:9 a=CjuIK1q_8ugA:10 a=WlT8qwTXB_Kj6um4hl3b:22 a=HkZW87K1Qel5hWWM3VKY:22
X-Proofpoint-GUID: c_f_41FyXcKk0xXC4kxt_ds71jHz82RI
X-Proofpoint-ORIG-GUID: c_f_41FyXcKk0xXC4kxt_ds71jHz82RI

On Mon, May 12, 2025 at 03:23:07PM -0700, Andrew Morton wrote:
> 
> The patch titled
>      Subject: kasan-avoid-sleepable-page-allocation-from-atomic-context-v7
> has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
>      kasan-avoid-sleepable-page-allocation-from-atomic-context-v7.patch
> 
> This patch will shortly appear at
>      https://urldefense.com/v3/__https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/kasan-avoid-sleepable-page-allocation-from-atomic-context-v7.patch__;!!ACWV5N9M2RV99hQ!IDZGs5LvdWUbyEOsjCGQ9n4Rk5nHMYzHfbAvvr0U07eEBuITVQjUmFA0nvwv6w4E_2SDwb99rlhHW1qS4ZW84Q$ 
> 
> This patch will later appear in the mm-hotfixes-unstable branch at
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
> From: Alexander Gordeev <agordeev@linux.ibm.com>
> Subject: kasan-avoid-sleepable-page-allocation-from-atomic-context-v7
> Date: Mon, 12 May 2025 16:27:06 +0200
> 
> do not unnecessary free pages across iterations
> 
> Link: https://urldefense.com/v3/__https://lkml.kernel.org/r/c8eeeb146382bcadabce5b5dcf92e6176ba4fb04.1747059374.git.agordeev@linux.ibm.com__;!!ACWV5N9M2RV99hQ!IDZGs5LvdWUbyEOsjCGQ9n4Rk5nHMYzHfbAvvr0U07eEBuITVQjUmFA0nvwv6w4E_2SDwb99rlhHW1oEPUM6Aw$ 
> Signed-off-by: Alexander Gordeev <agordeev@linux.ibm.com>
> Suggested-by: Andrey Ryabinin <ryabinin.a.a@gmail.com>
> Reviewed-by: Harry Yoo <harry.yoo@oracle.com>
> Cc: Daniel Axtens <dja@axtens.net>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> ---

Andrew, please drop this patch                                                  
(kasan-avoid-sleepable-page-allocation-from-atomic-context-v7.patch).           
                                                                                
v7 has a memory leak and after discussing with Alexander this                   
'optimization' doesn't seem worth here.                                         
                                                                                
But as Alexander mentioned v6 also has a memory leak in an error case,
and I believe a proper fix to that should be (lightly tested on my box)
below.

And with the change below on top of v6, it looks good to me.
Reviewed-by: Harry Yoo <harry.yoo@oracle.com>

diff --git a/mm/kasan/shadow.c b/mm/kasan/shadow.c
index 660cc2148575..8212a7007b02 100644
--- a/mm/kasan/shadow.c
+++ b/mm/kasan/shadow.c
@@ -339,7 +339,7 @@ static int __kasan_populate_vmalloc(unsigned long start, unsigned long end)
 {
 	unsigned long nr_populated, nr_pages, nr_total = PFN_UP(end - start);
 	struct vmalloc_populate_data data;
-	int ret;
+	int ret = 0;
 
 	data.pages = (struct page **)__get_free_page(GFP_KERNEL | __GFP_ZERO);
 	if (!data.pages)
@@ -350,8 +350,8 @@ static int __kasan_populate_vmalloc(unsigned long start, unsigned long end)
 		nr_populated = alloc_pages_bulk(GFP_KERNEL, nr_pages, data.pages);
 		if (nr_populated != nr_pages) {
 			free_pages_bulk(data.pages, nr_populated);
-			free_page((unsigned long)data.pages);
-			return -ENOMEM;
+			ret = -ENOMEM;
+			break;
 		}
 
 		data.start = start;
@@ -359,7 +359,7 @@ static int __kasan_populate_vmalloc(unsigned long start, unsigned long end)
 					  kasan_populate_vmalloc_pte, &data);
 		free_pages_bulk(data.pages, nr_pages);
 		if (ret)
-			return ret;
+			break;
 
 		start += nr_pages * PAGE_SIZE;
 		nr_total -= nr_pages;
@@ -367,7 +367,7 @@ static int __kasan_populate_vmalloc(unsigned long start, unsigned long end)
 
 	free_page((unsigned long)data.pages);
 
-	return 0;
+	return ret;
 }
 
 int kasan_populate_vmalloc(unsigned long addr, unsigned long size)

-- 
Cheers,
Harry / Hyeonggon
