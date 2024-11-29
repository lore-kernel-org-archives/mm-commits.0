Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 914AD33C5
	for <mm-commits@vger.kernel.org>; Fri, 29 Nov 2024 11:46:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732880773; cv=fail; b=JikFERWdPAn1NBxbZODCchrmlaOYDHJAsl6acEo4/uIok5d193hWhrJXz6crZElOFpyfX0wwkpAkLCw2g7Q5JVLWrWa2lVLqDKbUZhoC3unOiSbq5l/qsPaNZy+qh352u6axrenjkdi/MMTQwI9bwmuJIAcVmFeAm+fP7MCr5gI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732880773; c=relaxed/simple;
	bh=phrijfoCWb9/FvKaHhGhg781isR3/o2DOP7v2HK4AMU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=G8OXvityEOoNJovEppGPkQEl3c2rMwWWoMy+X7f21GVr7CgrWVQnZNSnxwP+LuJyuNULns9lGHWmPfsig1ndrsFgroBqh/ZYMjzbEthub5seE9ZUFALT7iPNX1zAav8SnuH0bNTEhKXFj87XCBTIhpvVZcZQ9Zb5Qd2LwIsPhYY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=B6XLInVQ; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=mv4ydxbm; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="B6XLInVQ";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="mv4ydxbm"
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 4AT1fpXJ022215;
	Fri, 29 Nov 2024 11:45:56 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2023-11-20; bh=4U5MCUaCwXpn9IW7GA
	pk4MQbRfJfpj0u6NPwMdzuU+8=; b=B6XLInVQYgju3JCQqfU6gxTEWETbGHbIiy
	X3rXhXl+Fp/ZGRyPyv+WUARVB/Mzm2+iYuaL1TIQbYUDquXwMA09jAuRSirs8LYD
	zugiq/Ltg278D5ufe7PXDSXSz9V4ZEOS7anhaqmCV0ekkLxPvqDZXieCbXB3+E53
	RDgip11pWZJ0MR1hniWBXtLcIwO7AaS5Z4VndiBN1KRcMQxE3xDSo+i1IP97Teip
	6Rrf7pVNbE/pNhiiRdvwa+tjYkQ4hfqqueQiTx97KdFD0o8qTgQYvodepqqqLb8Q
	2+2VwMPYOwuUy9avn0z7SFXlgYT44JgaRZU7Hdz2KJGL5lJYbW5Q==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4366xyb7us-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 29 Nov 2024 11:45:55 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 4AT9HaJq027440;
	Fri, 29 Nov 2024 11:45:55 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2171.outbound.protection.outlook.com [104.47.57.171])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 43670537e3-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 29 Nov 2024 11:45:55 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=PK1qM9aQ9TTZLLUxtsxNWvrSCXW0KkZpGYvZwCRabsMZJJdlr62JnhUEHavX+GBi6euNKKkT7weK7m/rTrRsbbubsqfOpiQsWMaP6Cg6XRQhs41jl+OU2XU74TUAAM9K0Vg3FyjWeQMnyZa2nokRgTpuqtL/ar24A8uesEztKwwr44TLBSyxsPbrClFE6Uozep+0M1cJXdYZxYhSLvrUcPAGB4Qmr2qra0t7G6aB+uSU05wuEITROAdbS+QVCJKotYSKOOpo7O26/jjOl6n5EnSNtLWcS+G19Nom9n+YZUo12xGXgscoBXjm/ejLNWF8c9FseOyqmsxUhjD71KaDrQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4U5MCUaCwXpn9IW7GApk4MQbRfJfpj0u6NPwMdzuU+8=;
 b=RSg7KqfbS2Le1P81Gkk7XvV+PdIQBeNod/eRFGCWVNQuCgKDXw2U0LHl/3eF5Lprtu7FJnp8IKVF7ekHEJdMRU4uEvC0PCghZ5N6NenDuydEoVgbz3ZcGYta/HEF3anAi8tyeEncqbshY1JkObLsHUOGUl0mBWPdZYxwz6VLJW9qG2HtgHXDNO4pmeEg0N3+Ce/KXhoBRQd6xiHioG9SOiu43XWKq8I9Xkam65Xg72/r8r3irzn/ERHuOPJDtf1qqutVx6HaVb7Tpa+NSQiEOJD4wwGF1eB5m8dOX+jxn83kgb8UTh60RvmZYttlnH45/mK3cI+f1VelXwjgFe1Bcw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4U5MCUaCwXpn9IW7GApk4MQbRfJfpj0u6NPwMdzuU+8=;
 b=mv4ydxbmsDHRXfWfpWY+G3eTWFe32A5QXzuYhk1kw3HnEKtHc5YDg67Lk9rwegG9wDnZy/ryzEZ4V38RLjyO1UtT/8z4s+6CYJ+LJ/tGUny2Zv3w6vLcrzEmtsOKI6PacBvSWpKfYqtme+ap0hf8zrZXYgnZMMoUsktZt+Lm160=
Received: from BYAPR10MB3366.namprd10.prod.outlook.com (2603:10b6:a03:14f::25)
 by IA1PR10MB5898.namprd10.prod.outlook.com (2603:10b6:208:3d6::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8182.21; Fri, 29 Nov
 2024 11:45:52 +0000
Received: from BYAPR10MB3366.namprd10.prod.outlook.com
 ([fe80::baf2:dff1:d471:1c9]) by BYAPR10MB3366.namprd10.prod.outlook.com
 ([fe80::baf2:dff1:d471:1c9%7]) with mapi id 15.20.8207.010; Fri, 29 Nov 2024
 11:45:52 +0000
Date: Fri, 29 Nov 2024 11:45:48 +0000
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: mm-commits@vger.kernel.org, willy@infradead.org, pedro.falcato@gmail.com,
        mjguzik@gmail.com, Jason@zx2c4.com, hch@infradead.org,
        david.laight@aculab.com, dan.carpenter@linaro.org, axboe@kernel.dk,
        arnd@kernel.org, andriy.shevchenko@linux.intel.com
Subject: Re: + minmaxh-simplify-the-variants-of-clamp.patch added to
 mm-nonmm-unstable branch
Message-ID: <f0db5571-8c0c-4a39-8bea-e802d05deda4@lucifer.local>
References: <20241129111143.DB800C4CECF@smtp.kernel.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241129111143.DB800C4CECF@smtp.kernel.org>
X-ClientProxiedBy: LO4P123CA0179.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:18a::22) To BYAPR10MB3366.namprd10.prod.outlook.com
 (2603:10b6:a03:14f::25)
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BYAPR10MB3366:EE_|IA1PR10MB5898:EE_
X-MS-Office365-Filtering-Correlation-Id: d0a751c9-2872-47c3-20ec-08dd106b6050
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|7416014|376014|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?8t58+Ltaer8NUsxQsi3FmcqrhoK7jav3bwfD8aUHgDS1iABvRWL9ZXqx40Ry?=
 =?us-ascii?Q?OF6cMx5vzeI+Zt28dnhUEWGT7a/vJ4GDLEKYIIwJetlVcyWL+wGuqYI3d5Rq?=
 =?us-ascii?Q?pPCXQx6sHUa0G4R2cvFV4tEVUBdls62IKxbzyKwWV3qGGfblkPOHn0YIFCg4?=
 =?us-ascii?Q?tGKoXbhNsCON8WicdIvlVarldWtIz8mP15nV2PGWAKQFMsdzzg6qUBj7Bbtw?=
 =?us-ascii?Q?FR3nncV7p5/5qHx6Lc41mae7Htwe4zbJWr0iHh3JfD/FEtIQ3NHoO9ECR2S8?=
 =?us-ascii?Q?BvUWxN4WkRwJ+gzZnV//1Qs3rNzYwdD80UDZ2OsWAxOm80gHKpUSTPUvyMVL?=
 =?us-ascii?Q?tIIm/wWx2UhxWq9+xd1EsfHpjdynxpyEPXLdVoUTeAt5tT1kN5elO9QHGNvf?=
 =?us-ascii?Q?2S1OFvcN65+qxPcQEOKzCwg2Y7/kemWhfRTzQlhcUwsK6jmhMHamXBO21sae?=
 =?us-ascii?Q?zpSzT6Bh+umg6uysMI1ZhnsnpI+9usBM+kveGaWzWvlDyZ3275l/jg5+UJ9o?=
 =?us-ascii?Q?VAdH63Mp3CKL+uDfamGKP9CPG4lAZ0y3pQg5hbIWzcY6AIC7EJaA90tpPfol?=
 =?us-ascii?Q?Bvqv6v0fDMI9HK/UPWSZznKrgMErHEPA03qQkv6x/ZiCIk802DL5LdK6PS20?=
 =?us-ascii?Q?5c01VCgV5Os2NWzOZ7kgzV6Bpc6tqL7KqGayiO4Ts/PbclFrsyeFGRpEW58J?=
 =?us-ascii?Q?QTHCX0Q7v1VJotufLis23rmbrWVug4hJhlV6Vpxp946IMSHAtMypYvItqpvG?=
 =?us-ascii?Q?ubo2Kqllnf9Rdv3PxkUrNYv/AWJRtAPW2tnSp3gM/8W0MQN0wmQoArQsrg+C?=
 =?us-ascii?Q?gP2LLGGsbPThdCCVf7ZTFCoWSzdj+Thr59d1zoc6hAGyibMccCpVCh1Ba31E?=
 =?us-ascii?Q?hDx8dvbzx8c7S0qrZI20qR1+QOOR0EpqvjT8P2EPRn6+pXJKgM+mvdgLFQ+4?=
 =?us-ascii?Q?+aAxbKpGPKnjzyakX4GogksmNUkasi8ZfXu0GXvsCj1Gp5FF4UJ3xo949NSZ?=
 =?us-ascii?Q?+f84aopD8SEuyx/QIUvOBSu17zAtm+pdhvSMwydDjijaT/85rwy9UVhpLBce?=
 =?us-ascii?Q?0DgcIvrDMMWaM3EF85Kg92VoTI8eACLRqMs5pKOnT0s4pC73DT+Jb5KfO6Bu?=
 =?us-ascii?Q?X9Dy9K3EkNekgrklxnPMfVqknrfRjYiTbVF3Gim28maYVl/8HtJv2B2HimFU?=
 =?us-ascii?Q?jwn5lAdO6kVNra72kK49woX/UDDifjxLT9kbhMlTaDYWJBVN7ikEu3rveSZP?=
 =?us-ascii?Q?ynbUKkg4IA1dd+uHOjPvPWA+ryCR6+R2yaSnnZKebYRdd07hz3VLNAa8x5hv?=
 =?us-ascii?Q?tEPBok/IpYi3UlkPD3tSUwR9?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR10MB3366.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?LL/SsHrPG6v7khjMuR5R7LxmSe1TBMU9s1BX/NRIPiY5BajK45V6WZJBMS+C?=
 =?us-ascii?Q?Jt949Yj7VaucH0abEWWzeTR61YUUOu+fnpUSGZaAj3ZOwN83UUfqRuOfNB8x?=
 =?us-ascii?Q?2RK8gHHyqP1nM1FvyFEO63YV8VisL0H4Z6HFcGbtFgHVTi2DA62EOeZCFMTX?=
 =?us-ascii?Q?sdfR8TmpmFhinfBwHCtRCb0rteXQSQaeWcULKgl5826W8Zl9l84uhY5LYHyl?=
 =?us-ascii?Q?OikUknzifWGIWqU0VPUm45n5vgPr7iAsGB8SVVNsEIy2UCsGyfqZJpeem3jn?=
 =?us-ascii?Q?AP6CUcwXyV3oM/bLRHd8CRVxQ/wYrL+yQLF9wTtOqFkwmLJnHSf9YV3z1/CH?=
 =?us-ascii?Q?Nsw9f7bNmdgcvrRmp4Jcl91iPGFgkHMnZF+vV4DU0A7kuKPWgvP1pFZwaUti?=
 =?us-ascii?Q?oyDy7DFeRhBgYYcqE82s5FCAFSeiFsMoFL29wvDbTILd23Tq+9eGyCnxWXtb?=
 =?us-ascii?Q?DCFTDkgXoHCQY21EJN9C47Ww9l3Rn+Jg8v5tWgYtM60X402xjnHapGtMcfrv?=
 =?us-ascii?Q?qelmiV/Dhgnyi+IkQDnbQPGm+bIPUGo9phLSThDwIohNymvOq0srD2ECJgTR?=
 =?us-ascii?Q?nfbDQQ0Vr/EN0Eb/4bsNqXb+EjCI4TaAqJdZCzwU3oTIpal/eiWa6ti0TwEq?=
 =?us-ascii?Q?i347+lF/DlGu4dhdKJp7hPU6y94kM+XW07NFfHnedRew87cbjjKdsQ86LA4r?=
 =?us-ascii?Q?klXPf+wWTETdlEbhZk4eD/tadzSo6nY16yhbNm1rcfHVtRJ5/wr+AoQ+XsMH?=
 =?us-ascii?Q?2nPAbDFj756zHW468kB174TEUl5iShedKjJrmATxSsFJx0wZ+zGbXc5gnzJy?=
 =?us-ascii?Q?Rp+YOiwGZS3JyYyQHbBEH/xxe865HgbtO1D8Q2UNnpxLRO9pkfo4tpYRyiWN?=
 =?us-ascii?Q?IyL+7yKs8fA3vPLESDqqPSPxkYE2Wic4w/tOAdhMuAdlSTxTOPTDTxZTF99e?=
 =?us-ascii?Q?NXg0k2YZTzOEpai0PfPM/jujQiNTu/kwbwKL21pUIS0gexhS37/BPGW/FsPt?=
 =?us-ascii?Q?gke4lNuHCzrzkt0/8i6aQ6WsbG0u2S0rc0Tw73VvGAN1mYHAJTQyWtP99nM2?=
 =?us-ascii?Q?Dtn4HfBqquhROSj6ertADPjK/gbYMiWn4dPSxYJQ+eGOChlQX6oeWEWiviGA?=
 =?us-ascii?Q?k8T4CJa886tCa5HTfZXZM8bCYZElligCzHWqhvi785fANiugQac1HMrLWfBN?=
 =?us-ascii?Q?kFrBoFOGzvdIaA6CX1x/LiRUAgmH6k/ypFDf0ro8pr/xb68fWhdpYavdvz3H?=
 =?us-ascii?Q?NM71Aw43BCYuulVRN1v1T2xkH453F3d8W4hGMmLnAggw/khuLkz/q2VKVCNy?=
 =?us-ascii?Q?QaTJW8UrGi92NTMVNUbCMC9YUQLUfgq66Dt+hrigq0c2XnxQiLDnGoZdqsw7?=
 =?us-ascii?Q?4ykh2O+5u01t+3ubYS2vVaS1Ij2zvZiRh29DYggWOtOLxX2p7J8IhCOQtuB7?=
 =?us-ascii?Q?9Z8i3gZambu8OJCHlEv8/yFolHJCboazStkoA9NaMwaRcU9DR2GMKqMRTzL6?=
 =?us-ascii?Q?Xt7BdKEgq38fANnQ/XhY+OHDZaHlkBYunZ0BjbtedfM5E4PqQVSXyhI6uXsc?=
 =?us-ascii?Q?F8U/LAgPPZYJgw5bIRWkDX7tJJlmLfJu0h7dNTv0A5YcNykH91kkb20aahyq?=
 =?us-ascii?Q?Ew=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	3OOJmZYPD0HtkU33OpXTH/mJG9v2sjOoRaTa9/uSUVhab5d5Zgu/lpP7LTMGxXWlCjR9cj6qLvX7v3Yf7yRjYkZgwLFNZZ/gGnZgzmJmGmoPqVPvNALlc/JFUAYELZFa1VS3irEcOp9qFrETF1kMz0T/+aqLAwyxrni4gDsLYyVdHPdJ/JZ7UBtubi8FcMnJHUfwdP4LR5NvxaCIib6zMEzLNrvwzPzr+sycxwwvbC66f0ru7VydFa0B/KTc3HRNozPB77sM8HmV2CTsxxjrTi79HlOctNACvV09jrHCqSPNSmH2gq1SYz3wIpvI7meKUQaZfuAsnbzzujHxoOfCwWwr3UeMVPtiaUOnuJnR8bvMofnj+GGQwmF+Bl/DjWxo+nCGsW0h+ap5YqDr/Kb2Tm4KG0m8iN7Thlb1ucjzD9ATCsjpoURORFDo+JEP63EHEzaqRI3BLJzpBqYa083B84cgKStMRjzxkejjqdkSshZRYBrRnwCytaR4aEPezM5TOZeyj2+2ZmCLfjKn130NhjnpENGs4gpYDMb3wlLn2h0ySGSMbABLSO7wdsNQ6uSr3wRPI0X20orA73SHUlu3rDTbwD1sH0MLJI63P7nsX/Q=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d0a751c9-2872-47c3-20ec-08dd106b6050
X-MS-Exchange-CrossTenant-AuthSource: BYAPR10MB3366.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Nov 2024 11:45:52.1000
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Rg1k6vCCIdt8ZyRBtc3Z8TyLqSDS8N50qVDPlCxz5PO7PNWH+Hy0xXmGeo9YxAHK5sRuQFuHdnywAN5E2H0twp+aleMYYVyznjHdc8FmnwQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR10MB5898
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2024-11-29_10,2024-11-28_01,2024-11-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 adultscore=0
 suspectscore=0 mlxscore=0 phishscore=0 spamscore=0 bulkscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2411120000 definitions=main-2411290096
X-Proofpoint-ORIG-GUID: 3CpDL3spHFExaNDmyN_gVNR8jzf7eAAc
X-Proofpoint-GUID: 3CpDL3spHFExaNDmyN_gVNR8jzf7eAAc

On Fri, Nov 29, 2024 at 03:11:43AM -0800, Andrew Morton wrote:
>
> The patch titled
>      Subject: minmax.h: simplify the variants of clamp()
> has been added to the -mm mm-nonmm-unstable branch.  Its filename is
>      minmaxh-simplify-the-variants-of-clamp.patch

Hmm, this was generating kernel test bot reports, should we be taking it without
that being fixed?

>
> This patch will shortly appear at
>      https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/minmaxh-simplify-the-variants-of-clamp.patch
>
> This patch will later appear in the mm-nonmm-unstable branch at
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
> From: David Laight <David.Laight@ACULAB.COM>
> Subject: minmax.h: simplify the variants of clamp()
> Date: Mon, 18 Nov 2024 19:15:05 +0000
>
> Always pass a 'type' through to __clamp_once(), pass '__auto_type' from
> clamp() itself.
>
> The expansion of __types_ok3() is reasonable so it isn't worth the added
> complexity of avoiding it when a fixed type is used for all three values.
>
> Link: https://lkml.kernel.org/r/8f69f4deac014f558bab186444bac2e8@AcuMS.aculab.com
> Signed-off-by: David Laight <david.laight@aculab.com>
> Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
> Cc: Arnd Bergmann <arnd@kernel.org>
> Cc: Christoph Hellwig <hch@infradead.org>
> Cc: Dan Carpenter <dan.carpenter@linaro.org>
> Cc: Jason A. Donenfeld <Jason@zx2c4.com>
> Cc: Jens Axboe <axboe@kernel.dk>
> Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
> Cc: Mateusz Guzik <mjguzik@gmail.com>
> Cc: Matthew Wilcox <willy@infradead.org>
> Cc: Pedro Falcato <pedro.falcato@gmail.com>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> ---
>
>  include/linux/minmax.h |   24 ++++++++++++------------
>  1 file changed, 12 insertions(+), 12 deletions(-)
>
> --- a/include/linux/minmax.h~minmaxh-simplify-the-variants-of-clamp
> +++ a/include/linux/minmax.h
> @@ -183,29 +183,29 @@
>  #define __clamp(val, lo, hi)	\
>  	((val) >= (hi) ? (hi) : ((val) <= (lo) ? (lo) : (val)))
>
> -#define __clamp_once(val, lo, hi, uval, ulo, uhi) ({				\
> -	__auto_type uval = (val);						\
> -	__auto_type ulo = (lo);							\
> -	__auto_type uhi = (hi);							\
> +#define __clamp_once(type, val, lo, hi, uval, ulo, uhi) ({			\
> +	type uval = (val);							\
> +	type ulo = (lo);							\
> +	type uhi = (hi);							\
>  	BUILD_BUG_ON_MSG(statically_true(ulo > uhi),				\
>  		"clamp() low limit " #lo " greater than high limit " #hi);	\
>  	BUILD_BUG_ON_MSG(!__types_ok3(uval, ulo, uhi),				\
>  		"clamp("#val", "#lo", "#hi") signedness error");		\
>  	__clamp(uval, ulo, uhi); })
>
> -#define __careful_clamp(val, lo, hi) \
> -	__clamp_once(val, lo, hi, __UNIQUE_ID(v_), __UNIQUE_ID(l_), __UNIQUE_ID(h_))
> +#define __careful_clamp(type, val, lo, hi) \
> +	__clamp_once(type, val, lo, hi, __UNIQUE_ID(v_), __UNIQUE_ID(l_), __UNIQUE_ID(h_))
>
>  /**
> - * clamp - return a value clamped to a given range with strict typechecking
> + * clamp - return a value clamped to a given range with typechecking
>   * @val: current value
>   * @lo: lowest allowable value
>   * @hi: highest allowable value
>   *
> - * This macro does strict typechecking of @lo/@hi to make sure they are of the
> - * same type as @val.  See the unnecessary pointer comparisons.
> + * This macro checks @val/@lo/@hi to make sure they have compatible
> + * signedness.
>   */
> -#define clamp(val, lo, hi) __careful_clamp(val, lo, hi)
> +#define clamp(val, lo, hi) __careful_clamp(__auto_type, val, lo, hi)
>
>  /**
>   * clamp_t - return a value clamped to a given range using a given type
> @@ -217,7 +217,7 @@
>   * This macro does no typechecking and uses temporary variables of type
>   * @type to make all the comparisons.
>   */
> -#define clamp_t(type, val, lo, hi) __careful_clamp((type)(val), (type)(lo), (type)(hi))
> +#define clamp_t(type, val, lo, hi) __careful_clamp(type, val, lo, hi)
>
>  /**
>   * clamp_val - return a value clamped to a given range using val's type
> @@ -230,7 +230,7 @@
>   * type and @lo and @hi are literals that will otherwise be assigned a signed
>   * integer type.
>   */
> -#define clamp_val(val, lo, hi) clamp_t(typeof(val), val, lo, hi)
> +#define clamp_val(val, lo, hi) __careful_clamp(typeof(val), val, lo, hi)
>
>  /*
>   * Do not check the array parameter using __must_be_array().
> _
>
> Patches currently in -mm which might be from David.Laight@ACULAB.COM are
>
> minmaxh-add-whitespace-around-operators-and-after-commas.patch
> minmaxh-update-some-comments.patch
> minmaxh-reduce-the-define-expansion-of-min-max-and-clamp.patch
> minmaxh-use-build_bug_on_msg-for-the-lo-hi-test-in-clamp.patch
> minmaxh-move-all-the-clamp-definitions-after-the-min-max-ones.patch
> minmaxh-simplify-the-variants-of-clamp.patch
> minmaxh-remove-some-defines-that-are-only-expanded-once.patch
>
