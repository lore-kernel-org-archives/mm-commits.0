Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A491115B107
	for <mm-commits@vger.kernel.org>; Wed, 28 Aug 2024 09:35:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724837725; cv=fail; b=lCzVFEFZ5ecHh5mspyQ2p9ypl4XL7WiE0cQNC65OcuG2WlNjpjZXxFo5/FoGGWhf8cU9zdj5v6+L+CdoxntHI1eQNJOvrdN95uE8m6RCcTsq/gr6VPmv1LOUSr9qNSiTE08DBhBF+wPEtFrKAjlr6pD8xBA63EOBClNaV+uK7yE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724837725; c=relaxed/simple;
	bh=5bIEyTKsYs6Jy/oDf+IuC++ScDiosj9yfXqs74SZILA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=P9ZP7dCGpSaX0gtBpRafM63kNUdY/lzWjQZKvwW3OEaRLde5wycxddKsG92I2CUx2M0V05FGgX1SN6p+xp0+UqSovFRZGCyh2TtM4hzu/JSpNlfezgqA0U5UygDnTrmeIJ0+khlUvGvUXSlr0Gb6OE61pFsWtRKwz3FKFQoSAn0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=AfVwphaa; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=K+0pWDyc; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="AfVwphaa";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="K+0pWDyc"
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 47S7tWAR007360;
	Wed, 28 Aug 2024 09:35:14 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=
	date:from:to:cc:subject:message-id:references:content-type
	:in-reply-to:mime-version; s=corp-2023-11-20; bh=lz/3PBjwU//69Cl
	icrTDX3g4J5KV3F3H2nAPnALqkqI=; b=AfVwphaa6NG5VasfPs+0DHsSNxHrQuD
	LKYx92QOvvUF/GMmR2E0xL8ZTdPGwD3+qKWVlWTtosxZHErKKyJbW0mkt4+9rA8x
	zMvR4rGzqN5/4DBk//AJHENBJ1BNPAwc1+qaXFMJ+noYQk61TmAz9Cgby6fgr7EZ
	LZk3E4+89W1GsWjVAO977isLgFLqYQP7KugoIbIMjNSj6ljPmoUpySNXqNnRg8rC
	2MWwGNRnTev9sndqGRfjOngQH0u+XesAsOY/yxAuEXJ1Cc/H8IA0sukMYNqBm4qg
	iGcNU1jnUs4+qvcOw+7qASylPgxoKdQvcJSQgwtlioa1WiATJmo6rQA==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 419pup0w2s-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 28 Aug 2024 09:35:13 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 47S8O6Jk010488;
	Wed, 28 Aug 2024 09:35:13 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2177.outbound.protection.outlook.com [104.47.55.177])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 41894p3m0r-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 28 Aug 2024 09:35:13 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=SPpnt4Abhw9JzglKzVlueoWYBvFlybIj81G0DvmWZujAEzkykQFtLWH10d4Jv0zv7CVNp6Qak9UgVUS+6S4hEixBSOTVABBWcoYLL3GKzvpTwhBjYp2qhWhvYAUjsFTQpRYZ5zMg0HYONimXDnQG7XdtD0xMGd2ApmSzOiKlFL8Wz0FuRLIaasdQr11dGQbPzkbS06KM2QnpH/e1upn0KRdI98gwSCH8IfjL0QgQU2CuWkl3o9VXm927Fp6m89/jaQnYDTJt71r3rSrdRjE6TW2zF1HcpmqByRpJ00pOBTeWLZELhZAZHRzqRSpEcchoJolFAwFxKWOaNJx6oncE1g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=lz/3PBjwU//69ClicrTDX3g4J5KV3F3H2nAPnALqkqI=;
 b=Ldr6d4nR9dZnUciozP4S/rqyN3qFletRHYSqpmvVhDnAddM43j1rbyPH6mBN4Gkob4Txzk6FGY8I23sHlvIRGGrigCkR6xGZ1Lz78xjVobkvgbGjMNQ3Ccpg3VDezGvgc6JWsnM2xh7vZiQACp9Wd/58q6v6uP2KVKue4il7DnAxLlrDskYqT2N2tm31EpkmCvoiC8N0MDNhZ0UI/M/ihY6ru1YEe85p33+/EcfEptVRJSrdQV29Px9SKmdREYuhK7W6jA4dkRGZfwj4nG44YuPInqaziO67zcVa37x1SacVNjo0MhYPgcxqKocabSUzzQSmDexmIepjRBmHPR8ENg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lz/3PBjwU//69ClicrTDX3g4J5KV3F3H2nAPnALqkqI=;
 b=K+0pWDycX3AM3x/XKMkY3Pod8q2PpHy1GsCr8gdCleont/XQuqb/B5/f8FAnOZ2ZqDlb9m1WpK/YPkp1B2YOOTm5yG8CuwRikuLQtS22nQdDonr89hqZfRZ507KmDg6miHYDLeD7PGXL8cE4W4T0H0Gb5HwzTSJFuR2kcsMcICc=
Received: from SJ0PR10MB5613.namprd10.prod.outlook.com (2603:10b6:a03:3d0::5)
 by PH0PR10MB7005.namprd10.prod.outlook.com (2603:10b6:510:281::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7918.17; Wed, 28 Aug
 2024 09:35:10 +0000
Received: from SJ0PR10MB5613.namprd10.prod.outlook.com
 ([fe80::4239:cf6f:9caa:940e]) by SJ0PR10MB5613.namprd10.prod.outlook.com
 ([fe80::4239:cf6f:9caa:940e%5]) with mapi id 15.20.7918.017; Wed, 28 Aug 2024
 09:35:10 +0000
Date: Wed, 28 Aug 2024 10:35:07 +0100
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: mm-commits@vger.kernel.org, sj@kernel.org,
        Liam Howlett <liam.howlett@oracle.com>
Subject: Re: + mm-remove-duplicated-include-in-vma_internalh-fix.patch added
 to mm-unstable branch
Message-ID: <de03e6cb-2d49-4d75-b732-54a46eb82bb9@lucifer.local>
References: <20240828025612.79FCAC4AF11@smtp.kernel.org>
 <d898ce04-3231-441e-98eb-ceacbef930f6@lucifer.local>
 <20240828022700.4770704b60227a4acd2a7648@linux-foundation.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240828022700.4770704b60227a4acd2a7648@linux-foundation.org>
X-ClientProxiedBy: LO6P123CA0040.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:2fe::18) To SJ0PR10MB5613.namprd10.prod.outlook.com
 (2603:10b6:a03:3d0::5)
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ0PR10MB5613:EE_|PH0PR10MB7005:EE_
X-MS-Office365-Filtering-Correlation-Id: 5f56f0ab-531b-4a0a-3a26-08dcc744b5e1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?ysZGQGpoyeQP2U/HjN7EVcHXIEQsEbmlis0ObjIgScTddQ4hzZCLhwtDV85b?=
 =?us-ascii?Q?CLQEhGgUOuI6lNB70Skz5ZiA6lygcLJhu1zRZHOo/B8vNTDXhgwIshnpGtkO?=
 =?us-ascii?Q?jaiejWZyt/iaPqOGExEKXUGRxvbxYSPruqNTVVzAH0PYnp58KFBpTLTuy/DB?=
 =?us-ascii?Q?u9Yxy4xLgxTDULZb3mj+Xu1aC1DvyfMzbU5ZEE2od8oWJKdSpISX+d2K271O?=
 =?us-ascii?Q?sP3mqZefVfFmv7coatrmGxTwQptX/rbknNIK2fBBAta37CEv+PCqviIeSNhm?=
 =?us-ascii?Q?u4Rl+VNlP2hZA0RoW0dsaBs5+uvR1QOVxuN27z0u0f4QeZ7fpLw4fWWlCUSj?=
 =?us-ascii?Q?Z/XTOdemHwz3oYLt4RNpXFDZJOw3S2a+1CnZw3OWOYxD1LxB+7sSpJ/k5ox1?=
 =?us-ascii?Q?eB1W1juwIZ1V5M5SGSKgPcJJiWxLGEzUU8bKKNugsRa0cjMKRYV17LDucI+L?=
 =?us-ascii?Q?/C3O0SXan6aKDaOFQNAzaPkSx86jE+8M1/D5Oj1bYrxrhvDzCI5D3FVg/0Dm?=
 =?us-ascii?Q?lctImNViFBkerZtCKy23hioEYaL2puBxd9Sg0vzR0+2fEAcAdqSyUKLQNvg1?=
 =?us-ascii?Q?d3mGUfaPuccwY2T0LWw8H1GQYDqsrUrxdm/qxbSefWs0SDTc3GBXnPj4Q7VJ?=
 =?us-ascii?Q?uzU0TFF4Ksm6X7WknLKOwEjH8fe90ouOL+KA0TP5+URpNixqC9rQjahTYgwD?=
 =?us-ascii?Q?EDQox8zQrf/QdgQrkAmWVoEsoTIALee1NMBY3D18Wysmy9cqxzYSYkhicIgz?=
 =?us-ascii?Q?PH5i3HEjln9oCMv8gjEYcvDXDb0dppNgCjqKqIOVMVFnhUzNspDYMR+W0UTD?=
 =?us-ascii?Q?5M14JmR8zYHHykXfced950oS0Iwfixf9px5vNuqsaZm1k2Tl9VuKX4Lho8Aw?=
 =?us-ascii?Q?JfvqxjYpQsALD7bfcO8Cm7tDXCmM1kQHGt33BOQeP+t+AWR3kLbgKNSmpWUG?=
 =?us-ascii?Q?cpsrkV6KilSShTICJFagDU6OBw3o2ptjavP6o0gl66wsaOriNphqJIfrdFTs?=
 =?us-ascii?Q?ua+KKjsOnY297v2BKcLyadnxt5V6udDw7o9tZq88g6c7OMds/dOR8JpqH7Ao?=
 =?us-ascii?Q?mKGXVARRwKABEOCxjuIjRcGo07nuAZewTOZDDWuJb00ONOCzjo27rFgCdKNi?=
 =?us-ascii?Q?chXk3+qvBFmB7zZJLZ941nOUt7jhM4Lk0MNtgnRQ+FdyX2927qogiAJsAjjB?=
 =?us-ascii?Q?676kOvqPVkA2pyEgodE6sjplMG59AUrV9W23nDryyjm1+aSmh9kFElBB+3Tr?=
 =?us-ascii?Q?yLXfBMHrhZ/JvNyeBBi83ZzyIUPQ9rvjEeTHqw3Mz2xj1rYsIIT++6nZoQdU?=
 =?us-ascii?Q?24I=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR10MB5613.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?lu680jVAEYkDTsQZOXYgkk3Wd9JeoxosB/Wdgc+FUfLcEEilswtHwbzcROHR?=
 =?us-ascii?Q?TsLkr4xTKHPgAu5sGdnNVmLGGGTpsqTyFvlkJ/Yl9qM8D7vTkNqchIvC13bS?=
 =?us-ascii?Q?+dw0ONsyhNaIAm7khyDJyW2Hi5ypooZsGe09EIv3dW/AUqn08ZebrqwWSmD6?=
 =?us-ascii?Q?5kZf9EJadwTi+aIlvUA606FrS+PfStl5mcq8dQD/QJABA1o6XNj2xm1eBEZ9?=
 =?us-ascii?Q?7fxlvBn6L911jaet2KP3eTNdt/raa/FibjMt7dYF33cPzI3rqW3hyQuBKfFI?=
 =?us-ascii?Q?39+QMyeXlt81KNn6s+EC75JMdBu7ERQx1t/AWTvqUtuJU0NZjycGM12+HdJa?=
 =?us-ascii?Q?zaBKwsceTZsOWooQvxLpVWLah7U/w1SxgW7r9jQ1y2C+liNQ1lrt6jwN2EKa?=
 =?us-ascii?Q?5HtLmczhNYRd28nCX86IxeAPI3ZxnFbZwa7LwEOHofRp5cCDa3g4RRFCA3V0?=
 =?us-ascii?Q?zmKi+GIapHMKKqq6guNqEgz4RvDLlhHs0gg817E7qIa1hiRppjRpYeW0OOp2?=
 =?us-ascii?Q?3S47475l2JAxoq1qPrs/SbPmD23d+D9ISLpRPjwUY9l1kG6GLkCuAjcqE1pO?=
 =?us-ascii?Q?NBeuCg614WHBSLRF/f69/gQlRNqIpc/Qk5uorkgFKHGOA7ZAkgccGI3bKJht?=
 =?us-ascii?Q?qIKFUXHk5ad+6wziiw8/UhCu6wpLIq3W0ouQr933d2IPXbGuSjJCiSabsxj6?=
 =?us-ascii?Q?jZsCaMupXSHBmjqTJqqPYj819sd1SugdBgfbN4atc1oLO7EvRRk9yP2OipxJ?=
 =?us-ascii?Q?IraHBh+pfulbjlvR6WW5LajZezmeKE1Uws+9RcyLMD9bDaNC9qC51JqbQp+T?=
 =?us-ascii?Q?0+JbmHM0DkeNvulJCt+h7eDg1fI4X/GEsIce/QM4yuiFcxJqoWCNZCCwFNGR?=
 =?us-ascii?Q?OEZf5JM3JbcLqMy8t5fwRxfi/x6TvRfUxQbCJfuhLHeWFU5+Bz1bnPnfn1Ws?=
 =?us-ascii?Q?dewqiyQMSJvF/3JFZfGzG/gT119xL9MEhaycvawc7ohVEWaMMCSScrfiWHUA?=
 =?us-ascii?Q?Pjd252llEgp/p4aAW6bl8wdTDiZTbGyUHqQLozp6V4Q0a4u2zR88HxPqY5yc?=
 =?us-ascii?Q?dJoizGza5ye1XkrjhD/tP3z5D9rDErLOP01VBZHD/GSq89XIkEpg0+aTQk88?=
 =?us-ascii?Q?cfHdMW3nTkSHPZ4j7txWxQR6SweFSBjkJetubqm3/pRsJabg+83Yp2DqpC0U?=
 =?us-ascii?Q?VHFqDBqI8OztzeCiK1ax9qYosyHEnW8BOKLX0f/rpmovDp69ZCpgz4ortZf5?=
 =?us-ascii?Q?rQEGqeuLyp97e6hB/LxMWcURFIP9XeJ0SpPSb7+b948qW38KvDYDVT3dILbM?=
 =?us-ascii?Q?CidaCWfb/l8ivgj04nVspUxNxB215jgWohXm8S53gtW80dRZgCKep6qR2hpv?=
 =?us-ascii?Q?QH365cV+pfayI9/h7ATKjY3FQu3D09MqtiTjHqLGJwKZOJmo/BaBV2kEo1TU?=
 =?us-ascii?Q?/LsVBm5xwZmCbdx8bkfeOdbuWESmtmu8GIyMMoRohmODwTBpJUprfQyp3g9w?=
 =?us-ascii?Q?6pT+0fEYqX6dXXtQyllHvIk5EPe6TwFBk4kYoyplbWW+zpSoNubhhs1HlFtw?=
 =?us-ascii?Q?DYiM2b0kE0IdnCmfb+8NgRDpukNjVY4+JY9l/spWC9Z2YEf7Yw6jAkMt4PwU?=
 =?us-ascii?Q?gA=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	t40/7pKAvsM6KdkHHTmVthODC3whofP67QlSzrmTwj1gBP8jVqfNgV5xvqbBBL8r2/jk5jcSzfp64sE1DqZROnesgVmTNH/20n/1Umxfqz4AdhXG0LlIYZvWH6Xo7nhVcs/VvdyAJx6gXVSvGfvvE5NqtheDY/Fr30DEntEEVRPn5yBNkr17TWcP9PWTnvws4e0iURibGug/ChGI7T8GyxnD/T4t0pZe64lL/ITp8G+mGK5DJaJCtErleZGIS3WI78aH8ykaqx1yKfu8N0QZIwmFyHeKBUikB+zbcntjMTQ+KguMkP64UisMIS7ecCI2aIvhL1bHB8fwq7gQ9qpCyE3NAFbGdek6ArKxFXjU6C60QCe0taKvEKSFKFgY5ubuv4+o0+xhVjxkVKcmkmGJyePvoVlDfoxM5eiATP/C6/qO0AH9NS76QpaLfaSB23m3J0Rk4MNIx5LFCbAI9Unb5uEIlhAxpyaFqyf7mP5TuwNitXwsSrgA07qpa1E/uHBk0y1/rLKCSVO7QgjX4Cell0dMM4K1QriucwWv93L3xZrmoJ9xWV0GP98DQd0Z0AR+dgq7tj03p+eWcKTpKps4e6OleiTjFFcKyOAty3mTpS4=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5f56f0ab-531b-4a0a-3a26-08dcc744b5e1
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR10MB5613.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Aug 2024 09:35:10.3811
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: F/MtwDeYiyRg7TUhsdNsady4llOox8LCa30++9GoxnUhPy5ODhdigqfjXLXaX+PdHqKmqEb1pwxsXUOGj65YIqEWUNXXiY/3oD3/zchmn6o=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB7005
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-08-28_03,2024-08-27_01,2024-05-17_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 malwarescore=0 spamscore=0
 mlxlogscore=999 adultscore=0 suspectscore=0 phishscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2407110000
 definitions=main-2408280068
X-Proofpoint-ORIG-GUID: IkFSj9lPtyAVScoTYCpj71rGwHFpKoli
X-Proofpoint-GUID: IkFSj9lPtyAVScoTYCpj71rGwHFpKoli

On Wed, Aug 28, 2024 at 02:27:00AM GMT, Andrew Morton wrote:
> On Wed, 28 Aug 2024 09:33:15 +0100 Lorenzo Stoakes <lorenzo.stoakes@oracle.com> wrote:
>
> > > +#ifdef CONFIG_MMU
> > >  /*
> > >   * These three helpers classifies VMAs for virtual memory accounting.
> > >   */
> > > @@ -255,6 +256,7 @@ static inline bool is_data_mapping(vm_fl
> > >  {
> > >  	return (flags & (VM_WRITE | VM_SHARED | VM_STACK)) == VM_WRITE;
> > >  }
> > > +#endif
> > >
> >
> > Something's gone horribly wrong here! This ifdef is not meant to be here
> > but rather around init_vma_munmap() as shown in fix patch in [0].
> >
> > I'm not sure how the patch got mangled like this.
> >
> > Could we replace this bogus patch with the correct one? Thanks!
> >
> >
> > [0]: https://lore.kernel.org/all/7d0ea994-f750-49c5-b392-ae7117369cf3@lucifer.local/
>
> afaict this is a fix against "mm/vma: expand mmap_region() munmap
> call", so applying it against "mm: remove duplicated include in
> vma_internal.h" made everything go pear-shaped.
>

Yeah sorry, this is my bad for not putting the fix next to the appropriate
patch and just linking that from the report. Have done that for other such
cases and will do that going forward to make life easier :)
