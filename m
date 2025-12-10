Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DDB0E1FE45D
	for <mm-commits@vger.kernel.org>; Wed, 10 Dec 2025 09:36:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765359402; cv=fail; b=FSYFEfstQfOQybPpHny3mPViSXo/Q6AoJwlW154z+vi3M27cWqqTcF/tBhP/6t11LDTFTRh0gucMbHee94ZFZ0DwvnRMivmELNjOPi+gNdNug2Xe2ebjGAblm1TaebOmaX1D1HzCpniCY5tgF749Oqhk9JMQpPGpcnpPPqi/Kmw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765359402; c=relaxed/simple;
	bh=06+9iyrIOvSf/0a8sdcMGJvcFsvZAkYqyZYwCGgFDmo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=PoEHq+YpJqQD7BsKzeriWhE8z+JlNDYz5LQF1/uzhYZV3FeweRDcLVEVeuNNUREi5uACoBLGGD1R2HGPwqSHo9pnS89ymMYq28EHLZarnLc/gsQcfRQNUOTQW+WryRtuFjd9nxjeQQX1LToqOeS543ydLrhFDkIlJXkFyMz2JGg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=VfK2qdW8; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=n/XYpdN9; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="VfK2qdW8";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="n/XYpdN9"
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 5BA9LQ3v2774659;
	Wed, 10 Dec 2025 09:36:27 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=n3GFJu9oy4gIw84YKD
	9S+PJVfIpj3eL/4vHMYWwvHJ0=; b=VfK2qdW8jjyOYxB3SF7SkJiM2yHnx69nkA
	lDVnicW9jSzE0q0ZoqH7MkzO75IOurwQN++tmv4yM1+sOOQmqrw0WMrIH6i2Dune
	abZqi6OjN3v3xDkWRr3aYxgAXUYCaHZEhg5v7UWsgXX4wE1TsgxMR7h1stinqW06
	p++vrqrjXL27syYygzKqcpBsB4flIKvwpH2kmqgo8hVAWvP8K/dZrRXJxVPHpotU
	vwNazprNpmpFjdQ1tpI8lV0KwLrxAR9NeWxou+d5ayS9EPG0oUVq70OB6aM2AGij
	DU/mFBXH35gdvOEIdUUgn4Ty0/CeO6IqW0XK6dfUOQSUvCOLkVjg==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4ay65mr0js-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 10 Dec 2025 09:36:27 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 5BA814pU039821;
	Wed, 10 Dec 2025 09:36:26 GMT
Received: from ph7pr06cu001.outbound.protection.outlook.com (mail-westus3azon11010048.outbound.protection.outlook.com [52.101.201.48])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4avaxm2gxb-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 10 Dec 2025 09:36:26 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=A2fUk0mGmS2l4R3y0n+MEUjExuula2LIfrA/w2y83/mk1Sv+9b7eP6UJAiYQytNrOhmdvvUoGrZyh1nNHJVrqNd7KYoPfcajlDMvRpTJXg9nuyiOtYj7hlLoxNSrXKpIBnPz2FEbG/8+S5KkGS8s6iZtPlZbiuL79m7Wf/Wtug7CfJDtGG/DtQLYjU/GVKV8nrb5Qoo+tEibp3NgEqrW9zSpjOGo+9JPDqLhWoQoFk7paNEkXQrL/CoUiuOT7eeqPTxRXnGsjVdIdVItBVZ31SVsOd13FWLvA4JZjV1pSvVJKeNd6q9hlO76l/p9Wj3kYcNMyfQOvMC4tHspjcN8lQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=n3GFJu9oy4gIw84YKD9S+PJVfIpj3eL/4vHMYWwvHJ0=;
 b=qevVZjGhexFKjHSWQj0k0yWUK7UjlRVJHRPLtzJ9X5dvg8f96yznOqOkow6kRlnDx9Q8aT0REn70PPxhmHP1bnUimOaXn//PD6r5VrWjReKDxXs155JQ18/tMkwyrPDpxON27fVBuXgTTlZ8ZgxzYafG2fv2+9eYOlfLOIeyENI1ulj/JD4SQ+wB9YodBqQNgy1PJS0hpMbK7c1EHt6ZMpQZOtXqT1HMQX2pM2wKl1jR6jICWton1KCw82fq/2xhOfbabL6elI3qpOQURRzvkEuOFZqi2xIUQJxEHnnrGW++hsRfVZTARAmCDNZa/HmkltjIRcIJ2H2PYhb+LMmgCg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=n3GFJu9oy4gIw84YKD9S+PJVfIpj3eL/4vHMYWwvHJ0=;
 b=n/XYpdN9zMDJCAuHL+RMtrjyP1C0SWY0o1JanI2hU/sGEB4lQ7Mlc2OLMxzgOIJAZPLDwyBkY8LKoowq0jPggIeZ1SpNUo/DehqDrIL1U5geOgCzDLcQb3kuoGQTPOFUYUB6o1H2FXD7q386EFJmhNGmRfSUUObXfduMPo+dq74=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by BY5PR10MB4370.namprd10.prod.outlook.com (2603:10b6:a03:20b::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9412.7; Wed, 10 Dec
 2025 09:36:23 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2%7]) with mapi id 15.20.9412.005; Wed, 10 Dec 2025
 09:36:23 +0000
Date: Wed, 10 Dec 2025 09:36:19 +0000
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Vlastimil Babka <vbabka@suse.cz>, mm-commits@vger.kernel.org,
        surenb@google.com, rppt@kernel.org, oliver.sang@intel.com,
        mhocko@suse.com, liam.howlett@oracle.com, jhubbard@nvidia.com,
        david.laight.linux@gmail.com, Mateusz Guzik <mjguzik@gmail.com>
Subject: Re: + mm-avoid-use-of-bit-macro-for-initialising-vma-flags.patch
 added to mm-unstable branch
Message-ID: <5a479ed5-3cce-42fc-a572-771244108dee@lucifer.local>
References: <20251205201510.3D83EC4CEF1@smtp.kernel.org>
 <95d18dbe-9055-43b8-bb4b-da40da670c10@suse.cz>
 <20251208174009.f982210c3a12ecd2459f59ce@linux-foundation.org>
 <20251209112943.6f5e405590671076f55bf4a3@linux-foundation.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251209112943.6f5e405590671076f55bf4a3@linux-foundation.org>
X-ClientProxiedBy: LO4P123CA0275.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:195::10) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|BY5PR10MB4370:EE_
X-MS-Office365-Filtering-Correlation-Id: 0bd17138-142c-497f-293c-08de37cf94eb
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|366016|1800799024|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?x2XXyLZVazFuqaFvRFIm+84NQ2gBkndiD67rUn1NX6Hrsfof5Bgz4pXdftLc?=
 =?us-ascii?Q?wMJpPf+iGAvrtqtYK1pcaFW6byTLbaaL9+OD/xBFjYpEpmTVhYgtcz6zsvqD?=
 =?us-ascii?Q?caWgIT5xfSIdJaYliNi+gG63dE1YqCqV2alj0uwctaxd4UW20t0texXE7s/w?=
 =?us-ascii?Q?AbJ2oZyiDTCCAUgZH844h7jIs+PSsMFBMLgoUfXSpGDKJ9lls4QPHbfqEuNA?=
 =?us-ascii?Q?Dy3ugGic4FVRsTw/joWdGhVu7kPjSwR1vnz+brZKIZFElyqEqShoMDB754QD?=
 =?us-ascii?Q?9H9ciY5sV6QuYnslq7II+xCNszLBCHEGx1jiRzz2GfKZ2dikEKtzgyHzd22m?=
 =?us-ascii?Q?f7MiF+UZcZNyp3iBc9PtgDlec8cIp/WpEWdKPIc41eznjVslwBlfhur1Nbd4?=
 =?us-ascii?Q?pDTmIWFs9DvLoNximtGi7IE6CQtcF1Ib1td5ighfA4LSpIxaxl/mJcKGFEih?=
 =?us-ascii?Q?OEVLvBYpYOG3YMKK9DD4jx1N6izWhlayomZBsBc/cgE1owbaUXP3oN+eJLcq?=
 =?us-ascii?Q?U6++oRz+VpF6l5c9ko4+BmNMrNfCEAejHpr38PI5etzyGDK9oEsOShSHQ8Dp?=
 =?us-ascii?Q?UWX1RBIGoJZScQZnVeP+zxhwlAl96/LFQ2nCuddDGJftHa2ZgAWHYtbKF5qz?=
 =?us-ascii?Q?SzDkDsOUELZetRdMybYDzaPUm2dyofYWemNRVeWTk2xd7VqqcK5yeObdEl9R?=
 =?us-ascii?Q?1oiFvFX8L04hC6lYucUbRSqJp6PKMjKlkSobjOoZvHeV/yKZ3JoKPhjBaljy?=
 =?us-ascii?Q?7TBrgb5pi5iRpmizuz8vcCj4QIJgkvoTRpM7il3ICWugX6D4d/BOfsaFG9F4?=
 =?us-ascii?Q?q91igLVUSmmPrguR8R2Mf9mIdFnNMT6tDZkiu9wGwZXT7Jsy2XREbW2htTp4?=
 =?us-ascii?Q?52Z/cZMqQlhW5jj9y0/+u4Lierfap/tyKIhi/S9gJYjYXu/OTS0NiIyTssLB?=
 =?us-ascii?Q?SieBZeoEfzNHzxrPV/ROefbW4VC8NtwtyTWC/dE25lhEbsx74xt3NdxhPN+4?=
 =?us-ascii?Q?qLi8yTqntdgJhaJA8kfQKWZWqPNhoRGqDXsp+2wi/QdXS1my3JxEwf2hJ4IC?=
 =?us-ascii?Q?Odi0QJhArhf5QY4WmOKAFQFGs0mA2QI2QUH6HtiWxjU0ELwoFj4YX312dTJ0?=
 =?us-ascii?Q?TtSEoCXz4SIi6RDOkluaB/hzPPWoAla5vdrl+lak7Nua0bn8WKU7vKsHtlLr?=
 =?us-ascii?Q?TpKwfIxuS9D7pRwiz13H4aJutmre3XNybHHhiM/JrfromUCZYG6VFDMEhDmQ?=
 =?us-ascii?Q?zhSdv8iOtgkXWWolKZ5XRehgcXO0ZKL4ENUFxL2K0djZ/7Wn5Ngk49HUb3Ii?=
 =?us-ascii?Q?oDgokLMw/fiL97CbFC92SlT/4MJy8G83HfClXGwi58+OA54Wf7dmH6uIA1Y2?=
 =?us-ascii?Q?NW4t5C80BxhdVQ4EIb9zgxwDZ/hlkMsk4PpTf4DC1njV2w+zaYOEAYzmVof1?=
 =?us-ascii?Q?wxe4GXaUArWSQmnu4v6K/EzgM1dHmE4K?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?P/qy65r9/qHqPMQyangNhsjSr4Dwo/TLw+X2pohN/bCgGMUwKQ68cmCyEbL+?=
 =?us-ascii?Q?YnS+1nV5N1bwUDeHHnk7hEZiE4uz45qHXNv4FGRGYx7cju+NKMxqpbWi9nGo?=
 =?us-ascii?Q?tpkDlxy5Je6m8lLZ1gbGepJC2w2QT9xYHEHZa7RPLLHMxrNix8ye8wkdyaOK?=
 =?us-ascii?Q?xS8MUwyIJGPDEo2JFNmie9PItQQExc+chMFm9PSQ/CYciISHmGhfX9lHZEd2?=
 =?us-ascii?Q?ydMjOj7e8fgYcbln0rCDtzfbUkvKCtvb+qfgNzeak8tU9CFbs45NWbAJXkJU?=
 =?us-ascii?Q?atDmqtuhliIWBDQS3Oa559JmscdwooIR3fm37HwfBybmAcse9EQvnAJPt+zK?=
 =?us-ascii?Q?Knc5AmQRAtAbdp1HE0LZxLSGP+WxcZRlhwdt9CLv5ofS0RwN2gaSXN6EbFsT?=
 =?us-ascii?Q?skPckSllxR1WUc07ZxjrXWgNvYSzG56m7bt5abouhEk2idA8feGsWYwcwIcG?=
 =?us-ascii?Q?CKvxcxnkbfDbBjS3jmLUQDUkR7EdUBfqHcj3XfkPCLNwBE6Ksmy73O1JNFBA?=
 =?us-ascii?Q?BXyQN4R1ewXBh0Q76rzrd8pUNuY6/bBVVfWxFhxGuPL0BJyniXbF9PG9MDxK?=
 =?us-ascii?Q?LwwW8CgUjfTjQmsuU0rFzPU3SFxU17kr/6HXDCzHVAIEyTI/zy4GZwSOzdgQ?=
 =?us-ascii?Q?nBKEyYX8EPSFtoZkMfEhVIgDbJk3nM8WDk4freMPt5faJIxpbsDzXTEEIHDT?=
 =?us-ascii?Q?2KOumCiMU/OQAal7sRVRfkoPy9skU8X2+8/jqOkjv7B94HQUSI9FFBKJH6mG?=
 =?us-ascii?Q?gt6cn1TwDWodd2rIxRxhYGXZd4oUBXk8eThPfWVbUVIzUWr1o7bsuqRSiqDM?=
 =?us-ascii?Q?IzsX8cma7h7OfYa1DF9ijwmB9RJ70GwcGVBcP8e7Yu/xwf+fmTjj+Uiixejq?=
 =?us-ascii?Q?akS43rUbIVzj0Y0LR4alNQ/V7X/+efI3CdYgcXV82zHAyIvOmJh8maD7I0rt?=
 =?us-ascii?Q?n35ZZWzWaM3Lw+/derl8drivEL8gkqMKslwkRbFjkY9D9zgxprdtLhvWJeiD?=
 =?us-ascii?Q?lGAwITWIzC7tVeRU0Ld0ud5qZLFrsRbFZoOp15aJErEn+BKqlUI4BJ7hdDLN?=
 =?us-ascii?Q?c0n4WClCMIWR1LNldWT+kcBH8mnsVvCEThHfGqD2RyD7o8D6Lrrvg0y3JrLU?=
 =?us-ascii?Q?r5PRkaKTUcSlQgEe9qJtkQeHazuP+NFlNjpvuVX60ZIos+2Qhe8amNJm4Dao?=
 =?us-ascii?Q?JTatoVK72NtSVjxhXDvmdXjkVHMCAs/wcUpHgMsPxnvpBQLM5gSB04R1w5AV?=
 =?us-ascii?Q?NG4frQ3zvwUW3BOS5irSUvMHdRfgVVbyI0G19LH97QvM1mb8SD1EoQpQ8Ha5?=
 =?us-ascii?Q?eHOfCE/WcsjM98ANwbtuR/fU/oAgrpnEivkaGJ62ut2GGgycwgZJK3TW4JCD?=
 =?us-ascii?Q?lAwGiCmcjZvBKWvPX62TYT12bB5OMU4kgnecVXJf9sIt0pzRuJLjnc5lmrhN?=
 =?us-ascii?Q?JOOkmKbj0suJirvYeeRhtPN9jPxC9wEDrpHdrdOnV5/Y27TOCjLYIA0UkZHS?=
 =?us-ascii?Q?eI2IKQX7o1RdJs3/GX4Ag0DpyLCdOia2LZEyHhjZFeu/cyDNDWIk1eZQ4HeZ?=
 =?us-ascii?Q?Pq0ZUPlDtkHd1SWb2kWOyzqXwesRGEc7m1laJ/Ap8SgkxIFQRT6+/OQW3fLz?=
 =?us-ascii?Q?WQ=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	fWb0zdnvDu4XYXF7IEaagu4uO8l+hhZ+O6q2hJ/JvOBYJRqRzEhcaRClCujNBmWuoyFDMja7lJUny+5iSSa+x4kkxKPecWVMShwvgIjXDPYViyq/ptTJxeqxwAsHXBTyFzd6g+Pdq/ZGJ9KpI6I2hnRPqwYD059Rq+glmMdjf67DXcRo0Njtax5wFLcQPLeUXncY6kMhquoRXdYq0KiHbg1/EhiGlKNemwHhx15icOeWirA8eEQX4r4zSumJgTPP/YaFeKbtaNU3kauPhmK0TUXZwAnPDzu4ppMlbwORtFcp4PHK99FKzA1VCUOMbwsIMahaI/Rotn8AVvgOTaif/hRU3kL9VDOU4fwxXd51Cu3nqHn4W2MRDhtcueLXyB9Qy+3E8xybOJ+9ix1pBqPtA6nJYCwKR9LOxzEHfrVEo6xGBcwphtU1arMJ3Sq5UTWbjbyCDA4eBoRY+lA2NJkuZGz9hBEnlSlMaRjlvLyNoC5lTWbuX8X6yYQKhcyiMnjX4tDkmPZ/JgaIQbcY8srPucSvReHb9jnlzu7N75ZCHYqHT58d5gF38wW8BAlD9SrLlIzwdaw6D+FUPe1RR2D6Fbm8AW03dsLS2IJBbHJgbkQ=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0bd17138-142c-497f-293c-08de37cf94eb
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Dec 2025 09:36:23.0309
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: mxaLmLjqXHPi+zwqYRlrHx+coNPSyWefOkAbPO1uK12WhEyIKwm6D7uveauajTZm5FsuXDCJ4qqTbiVlUuhhcr1RacgKTFXjMQ4wFkyCMR4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR10MB4370
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-12-09_05,2025-12-09_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 suspectscore=0 mlxscore=0
 mlxlogscore=630 malwarescore=0 spamscore=0 bulkscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2510240000
 definitions=main-2512100082
X-Proofpoint-GUID: iLCUtp4GBZ8XtvaYyXzJwDtaSyM6-McZ
X-Authority-Analysis: v=2.4 cv=Z6rh3XRA c=1 sm=1 tr=0 ts=69393f1b b=1 cx=c_pps
 a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=wP3pNCr1ah4A:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=Z4Rwk6OoAAAA:8 a=HvFhDm7G11KlSUumfQAA:9 a=CjuIK1q_8ugA:10
 a=HkZW87K1Qel5hWWM3VKY:22 cc=ntf awl=host:13642
X-Proofpoint-ORIG-GUID: iLCUtp4GBZ8XtvaYyXzJwDtaSyM6-McZ
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMjEwMDA4MiBTYWx0ZWRfX7i7t3TT+OvDZ
 Is0yMMQ8oyguGulOh6ZcXx2FBhqQehhHL3gE1ykzcdhz6+919UILoblAEbhSH1/I+sHKWLP3Yge
 LuUzUEhWL03Do6B36xpClY+AlvuBcDOXwxSt9oFEGlzRpNICdcxgIeBDD5R3CnQkBrk2PeuZLbg
 YgiMK/KTK648hPpQNGqYW1uPofeYZclKmAicZ3WhDJ2h7azw2/I+sKm98uCTpLw+l7UxUSdg65Q
 Gl4ijIKu69H/qF4yq2tKigfyCO39PApnP3IWFxm5NmFkPXXBUQT6HUA35uIwSxlXaOBWyTjjym6
 AKMdR34Cdvm4R5eRx/Wueg90OzINU3OyoBmUoWPTiZJ0aFU2bTPsyOQOf3Dtcg4/799FkJ8C+jf
 St3JlL6cHseDIEC7OTPYHcDLUmKBqhhyj5rvnaS8epA2DX+rAKc=

+cc Mateusz.

On Tue, Dec 09, 2025 at 11:29:43AM -0800, Andrew Morton wrote:
> On Mon, 8 Dec 2025 17:40:09 -0800 Andrew Morton <akpm@linux-foundation.org> wrote:
>
> > > On 12/5/25 21:15, Andrew Morton wrote:
> > > > The patch titled
> > > >      Subject: mm: avoid use of BIT() macro for initialising VMA flags
> > > > has been added to the -mm mm-unstable branch.  Its filename is
> > >
> > > Can we move it to mm-hotfixes-unstable please, to have this resolved within
> > > 6.19 itself.
> >
> > It's in mm-unstable at present and I'll be moving it into mm-stable
> > soon in preparation for another merge window mm updates batch.
>
> So I haven't moved it into mm-stable.  It's a bit unclear what way the
> wind is blowing on this one, unclear whether the performance regression

Hmm, well it's bisected, even it's just perturbed timings don't we want to
fix it?

Figuring out that it's that doesn't mean we shouldn't make a simple change
here no?

> is real and we've yet to hear back from viro.

We're waiting to see if my use of __bitwise is 'cargo cult' as in I just
copy/pasted it as an idea from somewhere?

Even though Vlasta (thanks!) and I have clearly stated why I did this - and
proved definitively it's not 'cargo cult'?

It literally prevents very possible future bugs in the kernel. Consider:

vma_flags_set(vma, VMA_READ_BIT) vs.
vma_flags_set(vma, VM_READ) (which _looks_ correct)

So I'm not sure what exactly we're waiting for there?

>
> So I'm holding it in want-and-see mode - we can add it later as a
> hotfix.

I mean not sure it's really worth holding back given this is:

BIT(...) vs.

(1UL << ...)

Hardly something that is hugely harmful no?

Thanks, Lorenzo
