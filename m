Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0826B318B98
	for <mm-commits@vger.kernel.org>; Sat, 10 Jan 2026 10:48:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768042125; cv=fail; b=fqbBj2fV/FdRDu7Lq+mGnQkpJSChXyRBZ4PnwaotmDBEIdQg2r/TmNrQ053PAhFjqrQMq6cEcBjPR7aUigj11R6dV8OS6KgcMLGfBrGpwz0kxrWIslj+5ZIP9uXeQ6OTh+SdP/Csl5L/m/NbvMLoXzdVwxFEMkareMUl7iqgq0k=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768042125; c=relaxed/simple;
	bh=pyqfP4kB13RxpO4D6gedBxnG9qIs5dcaIShGJ0JVF3k=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=ZgtzgCchl0kmadZBKqWWo4r5jIroung9ZmpF8xHlzL9zo7tbkXDcp5UuTr7QQtntL3IKLDQsa3ksruLE5PAh5qWNHERfOPJ9ToEms68NVqrC3BD4ggZJTc4PIo+b+ORjw2Nd4zVKZPMLtu6k5eUNWOuTP4Yjq+oCAlUBkeIBZbE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=pkBYsenJ; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=K0brWQ2Q; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="pkBYsenJ";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="K0brWQ2Q"
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 60AAlOm81011019;
	Sat, 10 Jan 2026 10:48:00 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=Ponz1ZMOXpA8+TE2k0
	7YPm4BI4zyn6Tuc7aZ71GHbUo=; b=pkBYsenJ1z0B7w1zFKXl2/e+ELVcP01Ean
	MhZQ7ih5CMHLjDRkaYf61t8S5MqW9oP8GBpn2JuUuYpWuwvdt+gkPTkjyxxnsTJv
	nnkyZM58ZBmWInrA3xQzSjbwY2PgTcZKnApKYwsqZomHsQbI9kavlczS3fMZpRRD
	jXsGSkcnWYJZH2BimPzMvkvjnvy4ppYxxktM1TqkTVJmfa4aiM4iqf22ORypznNp
	tre6TB9f62veQH+wjPeNp35xN3h0aF3Znuzjk2ubiTty1XJcT2a9uVGkeE0B0M3C
	kB/MueV5U4iUvL+avMVtydgM9BePZSx31m+ZplWfhVupFSU8fHBQ==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4bkh7ng37j-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sat, 10 Jan 2026 10:48:00 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 60A70aUP035299;
	Sat, 10 Jan 2026 10:47:59 GMT
Received: from ph7pr06cu001.outbound.protection.outlook.com (mail-westus3azon11010048.outbound.protection.outlook.com [52.101.201.48])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4bkd7600am-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sat, 10 Jan 2026 10:47:59 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=TtGwWb8SSPffk8sitnqDZLCcKgdm9H8WccW3LKFZGeScxfMKQobftXFt/5vJyvRmmFCzzEDH00A/ts8hQSkBh6TlnLpKdss4VC/VHKkC3hwtX4buLN80MHkEdfu/xbCuQ+LT+4whTxbSAM42pec0hSVTAdUSdllcVP5cRVRbE++1QpcYEu2Ihlw/zzL4wuhyb87rjR6wLKVK1s2I/iz7erY0E8YITHdXEGpp2cpssSA4MQfMzYGnF3KwCksKi85jKmEKadwfar1sDPrauixNDIdQyZw+wyjVYgxHFg25no9IFa9mQ7ppnp6tKvgtvJUKW9MYl9+A7kycTp3kw79loQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Ponz1ZMOXpA8+TE2k07YPm4BI4zyn6Tuc7aZ71GHbUo=;
 b=iGah/l7o5JJuFgozw7Lu477qRzFEWw4629GtM6+BAVaU1w59FQAIkoCi/hc8y4peScnDfTVY4RxkF3srVRyHRCBDnYI/f/B5pSk9UKtYhsYekTzkTdRFZ6SsaocK7Xs6K6gRfywaTofqQIa+xaR9cFVOnidh+VnvFsB/p3M3dgIgzMslYM2eJW5mZf8+7xdjQwnjB7M503/ydeaeE6RgPqFL7iLQtLvScWshkLE90+J/BKz59t0+hovFWVD+430991WUGSuE4excs2SfmPs4T1N8jJMAlk4iYJClhULlWPBzWTc5ncetixPmC+zvySz+R5GdZ6sT5P6LSLRjjRp2JA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ponz1ZMOXpA8+TE2k07YPm4BI4zyn6Tuc7aZ71GHbUo=;
 b=K0brWQ2QH0p8TqsroM0sE3L7WQ257ITY0psq8z5sbfudLqN5iOf/JbzIQMqKwIRbL1XP99bxQoTjoZ3X6tKtxeWdwTf3CwKtjVOeIPpnF93h+di2kcS3BlhLOAYlQjQ8P2EEwf7h4ABwV84ujJ5w2CBzd3ViPpshUOGhn4BlMPM=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by SN7PR10MB6570.namprd10.prod.outlook.com (2603:10b6:806:2a9::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9478.4; Sat, 10 Jan
 2026 10:47:55 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::f3ea:674e:7f2e:b711]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::f3ea:674e:7f2e:b711%6]) with mapi id 15.20.9499.004; Sat, 10 Jan 2026
 10:47:55 +0000
Date: Sat, 10 Jan 2026 10:47:58 +0000
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SeongJae Park <sj@kernel.org>,
        "David Hildenbrand (Red Hat)" <david@kernel.org>,
        mm-commits@vger.kernel.org, zhengqi.arch@bytedance.com,
        yuanchu@google.com, weixugc@google.com, tballasi@linux.microsoft.com,
        shakeel.butt@linux.dev, roman.gushchin@linux.dev,
        muchun.song@linux.dev, mhocko@kernel.org, mhiramat@kernel.org,
        mathieu.desnoyers@efficios.com, hannes@cmpxchg.org,
        david@fromorbit.com, axelrasmussen@google.com, rostedt@goodmis.org
Subject: Re: + tracing-add-__event_in_irq-helpers.patch added to mm-new branch
Message-ID: <63b89321-5530-4206-ac68-80e34ac97140@lucifer.local>
References: <20260109110028.8567b1a4a5cef096c25e173b@linux-foundation.org>
 <20260110003232.79586-1-sj@kernel.org>
 <20260109171521.d088eac0f8e3beb703051089@linux-foundation.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260109171521.d088eac0f8e3beb703051089@linux-foundation.org>
X-ClientProxiedBy: LO4P265CA0209.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:33a::16) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|SN7PR10MB6570:EE_
X-MS-Office365-Filtering-Correlation-Id: 64fcdc04-e064-4c19-b5a7-08de5035b625
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|7416014|376014|1800799024|3122999015;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?DEr7ioD4vDOkOJuVV3+JQOLuv3iIiN1GjgbtKjg9i13vUJDv6z7hXc7nJV+u?=
 =?us-ascii?Q?zbSissFMuIPTNwkzn5fhiu9FtsLY2Be8NewduCEXIma8i/7u5YU1VUPPDf2r?=
 =?us-ascii?Q?2sxNxj3HtPWT4NPcPC4oIsLS5irsVdzpJL+20Co4vnGWYvoBNHsuLZWUjpLR?=
 =?us-ascii?Q?Fcpn+lbBOhLgmKJ6TgqqGfMosm6b33V/ESjpdyikSDJRzIYEkDRENqY98Wen?=
 =?us-ascii?Q?A7fErpRJX19GPJDI3Se5ptZSjZ5tF2Dlgj6cflnZOYJu8+0aSwL99wFK8MC3?=
 =?us-ascii?Q?QXF9ITu/PVRpVwNLCFrz7MZH7cK8PZRs6vwJ0pHpfyRCv85pTuVV/IkMWJAT?=
 =?us-ascii?Q?UtpW/dQycAuU8MWV0/SQZWJBpiBV5XKVPL0sBgxWtqZIvlRrQ/DVgzAzg571?=
 =?us-ascii?Q?GcbbQJ/D6El2Z4LyWJ0r9XOufoH3+txX0VMBqFZCOHZmM/VdONsrpcmf1kB1?=
 =?us-ascii?Q?4uI7tCgxzlsglAx3p+cRA0YZJpFnzpufDoXxo7RJW0UGOP2Sh4RH09NdAxBA?=
 =?us-ascii?Q?YWIqq9e96czyHuE4RIFbC1LIrhFKBp/BUnzFskVU3jc5qOK1BKF7uRfUEEhI?=
 =?us-ascii?Q?I27JJ/Z55rhyhO5hDYtKVnG+6NTzxmCscq1EGqzLvSg3V+qwmq4UE+fgfQ/G?=
 =?us-ascii?Q?J8ZhEipsI+/o0spMFSUfmcKYwDzYNzfyicwUcssTI03R742nto3v+71aCZNp?=
 =?us-ascii?Q?kAoIzjvNfNCLAUffRfFKmowb7iku/MTxNJN74yo1rGdvRPKuuXhOPOW3CLRW?=
 =?us-ascii?Q?8Toty3qNSe1FXfszgsYVwVDkvsp/itJLstdGzWWLCFLjHD2s6hoFnVjTvoqr?=
 =?us-ascii?Q?s3AYJz6sR8A3Q/5FK0GzRpgLSoXWcwkDA9WDCPlTVhuYpnoy+uzdTMtvHUXA?=
 =?us-ascii?Q?q5/+SIiidwHPFtjezNUXDwTOMoGQysYZzzJNDExTqpJq92yZn5yPFEmyBrPK?=
 =?us-ascii?Q?n7PAqxkcBW64NiOEzMQvQR/L9+mAGMma5nlMXxxeqsg7XiXMbzSJh0kGXUUc?=
 =?us-ascii?Q?u7uv2wQCkVIfAh7iaS9Fw/O5rkMqGHIxHP5ZVNxpJoY6r4Xkx930efL4vLfJ?=
 =?us-ascii?Q?e9Or6IECUQqj0RFo+GuzVD/kMJnx81id4c49Y6ZvGpctS2DyoHRO83Up8KzS?=
 =?us-ascii?Q?YRzOgsUV5mVAkgcJyzWlHoT/ayGWlyuwBkdRCskHZ9bgw6QF54636iqtQffC?=
 =?us-ascii?Q?agLMHWwZRepDnSMVZeg7nnIwoh1FkL7I+u7AYtBonb+WTwdW/ZgJSsTpgVFn?=
 =?us-ascii?Q?SlqR6nH6vNOdWpxOSyZKz/lE7P5gZW7iEBGsQYozUNhynOkhJ7iZ3w6gdNfe?=
 =?us-ascii?Q?YXNx8Fwci/KhMIPJodgDfsLyGd0dqGlPZv4EmD5bssDP11t1s/iOoZz0xGHh?=
 =?us-ascii?Q?A07FrT2ht8+tjDp1XdflSRH68vU9bCr5+D3+UqMAnL9AFyGrs7hrQunKPcya?=
 =?us-ascii?Q?4K6orZOCMVlkbxWl/++7gGCMhdf4AHD4gD6SI9poXyjErnwkcbV7ug=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(376014)(1800799024)(3122999015);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?WXF5ko9kp8bjGloL5e3u+SbSpntBIoAYFFaLrrrz6wBPu1VxPyokFRG7ad09?=
 =?us-ascii?Q?U9acu0VAjXbmd4qL+dJ47Uw7AGRmT8lQMoVC8stiybLCSd/8FB1UlGBcYsQR?=
 =?us-ascii?Q?imfbN/dmk4WbO9owIOF/1fIIVOCHPDzX4f6Tgt1M8B/Pbl9Ni0NpOrW6dyBk?=
 =?us-ascii?Q?53z6E6Ny6udGClR/XMtkFd4u0d5CsfkcPvxqA+qoY6HiXa9/Ac8oiIM5Rhki?=
 =?us-ascii?Q?VWkeDM1xatTEvwgMkx5RKC06p8JWbpNVVxHLBYdim/JYfRx/VsUFD3eaDNWQ?=
 =?us-ascii?Q?QdtSPstLCowvKvbbJtk47m7RgdIvgx5gL72IjPsr51vcPjyDlHnwtYGrdaYI?=
 =?us-ascii?Q?/8s6NJF10j9OIzu6VdSwGPikwGe4tVwsEfovoBHYnqmA5xPdAkHiL40ZFZSM?=
 =?us-ascii?Q?XF6/TKz5n+ZR9T0XobZw8IkrFINxCfI1Xk1cfZrG1YyN20tLLVxaUcuHztZZ?=
 =?us-ascii?Q?G/Uu2b9hnxMZ2eVgDyUzevRhmUkEribnzpEsq5gbYk2b0eFzew6qt7wK8Qp1?=
 =?us-ascii?Q?WDeGj+7dbQTKH8X+IZ8cBCkK6olma2xk0oyxoZZV0Z+UpPLrL646PcUX2sJw?=
 =?us-ascii?Q?8D2ywPIkiyc4j+jhtcJUtyJMuEeZxCey4LeTNDQFBekcIfB6rL2GauTlZXWw?=
 =?us-ascii?Q?3UJu4PxDoViO1K9rWfnLukto60CGv6QMA2aQ4vKE99HAOHQOjt+3rzpkxf58?=
 =?us-ascii?Q?QARgjdilhgEKPKQ+c5mOpGl6aj3+YLG7mdre2APiOaopSMBWxPBmoBT4Vd94?=
 =?us-ascii?Q?8+UEiGrS2n9Nzlx4HPWrhUi0Jxw/DSuud3KTvp5XSUux4wpMDKXdEFTvkrIN?=
 =?us-ascii?Q?o2GvwNu6VCZwUjE2TWqsIy5vUHnlvBraXk+W3weBcjpE75fl5dYAB7+FCKaR?=
 =?us-ascii?Q?uQhvcGyiTKNwIDA9N0dIPDDeVocsO5yRE6eLOID7eOEN2k36pRnRsACUrFfs?=
 =?us-ascii?Q?5kp3A0AhOzLrEEaTBKHLTNsRxdRt6F4Z+YOazL1btEFhRjFGgi8QrjF79QX3?=
 =?us-ascii?Q?2TkabrzKmXOgrQVxccURE4ZYZ3T8NN0gavabsaphNhBjvxxqCI18svtUw1mQ?=
 =?us-ascii?Q?QyfWVNc2dki0kc/9ZXch148MZ58f2yr8Baeak1M2xwJL9aiTiE2va8XkV+sr?=
 =?us-ascii?Q?utXBvFL+Q0dlClNtdmPTnw9KiiYnu/KmgKQgiEj01RZMTpNhE1Ng9dUVJubv?=
 =?us-ascii?Q?9CpJho3hzFi8OD6DgdjNzmrf9/CEMhb0a76o7nTdyLdDaL/IWQkhEgDOP4vD?=
 =?us-ascii?Q?59GknKZh3H9LfnQ8ZFt3m98I1BSpmcaVyi6dgIUBWchv/9lVMMqO1/zOtVBC?=
 =?us-ascii?Q?seAGIstaHxTAuqxgiqUsyO/NsSG6oTygBoKaxVT89WL0CZU/8u9B4/1DO8O1?=
 =?us-ascii?Q?0xAhlQOxbJ7bR1LbkhrKUAaxif+ZGCNuR+VwVMwQMnPXVbOZCzinVHPn39Nw?=
 =?us-ascii?Q?nIQ1d2TAK/ZIGR5fqQXGMh4rTCnsKHdkQB/onkd5s+7vCLKzw/4lDkLSnGpz?=
 =?us-ascii?Q?FHkC4OHUHY53v+WqNoW95d8257hQm7esrvHNk3Xv9l/WCalYwuI9n7SNnbOK?=
 =?us-ascii?Q?vhV9VXtcKchqWsxdsqWx2SwQxOqON2hdENAX1BtRulDXg8xXl7AgV4hzmZA2?=
 =?us-ascii?Q?H5Li/nrLEiOlN06ORPcenPsygslRfBG9O2ZelyvBrzQAA1iNFCn2dQcYInT2?=
 =?us-ascii?Q?Y0UoiEUZsuLVxPBn76t45uhUJuxIuJVrjCK+S2RBrSuoiHYJTR3dzsCTMcWC?=
 =?us-ascii?Q?ncVc27KiXnqxX1Gf371mQCZoHUPFdFY=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	GPOMr79261DaPeDuzEwWFcI8k4efSlBi91Nnu75dfGweL9jKUnBq8EqKpt9K17x9sPUStF22Nq4bKQFeYcTJFPGqyjP9xoKPB2UCcEE22UlsAWbwxkLf3HD9i0okYyI2Bj4YSIxpYgVWbTyVsF1mnm7JJlipDucFOkmz8vEqJ5PG/eiB7Qu+k1VuvXrnD+tvpggyMWofuisn3j8DNhyToFcPOPuVq9nfMJ6hssVwdeCmLKNs9GiVdQI/b52H9lFjMb3QtLo89WTM0dfBsNO3+n04eDG9KVvJB7WYavL+AHZFlHbKIBtssHLSkNHWaUlmhuIDSSXgn4b3WH5qhnnE/JnknDIhHd4hk4nC+6sl7XzPA+0MDq67Lr+rzC3liZNxMbLOaafM/4Y232b0cqPrM5H6Tx1JTEHKvOruK1HwGt7nx9ZFB1Nd/G2SP70Iny3/WFfYx57kMCgQkkrMmoNquggYJDOzG1aoPkd3qjZrTaUuNKzoAQ7DbtTzp88zK5tIwBERbGbMQfRQgn32mtRLQkyqR5j65HWhVcHKV4DtmuU9huoXGCXHC/qo8m7icmclxRg8+0dRkfjv7FTqSf3WSs9i5CoE1Tbp8zJr2572RK8=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 64fcdc04-e064-4c19-b5a7-08de5035b625
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Jan 2026 10:47:55.4201
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: XbXYD/KpVrs3r+/XttjNFgeJRasBxjsK808a3NXXVvrD5k/VE43if6rY3QfqQhEjEJ7tGrKhccXSOPZ1eNfMG+6XS3JfMGh2CANqJoR6g6s=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR10MB6570
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2026-01-10_03,2026-01-09_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxscore=0 suspectscore=0
 mlxlogscore=999 bulkscore=0 malwarescore=0 phishscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2512120000
 definitions=main-2601100090
X-Proofpoint-GUID: sjiYdXuvcKsn3jmBch_-NV5VdjtLiAUE
X-Authority-Analysis: v=2.4 cv=X7Bf6WTe c=1 sm=1 tr=0 ts=69622e60 b=1 cx=c_pps
 a=WeWmnZmh0fydH62SvGsd2A==:117 a=WeWmnZmh0fydH62SvGsd2A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=vUbySO9Y5rIA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=VwQbUJbxAAAA:8 a=yQhYLOGsFOu4AvUYkNgA:9 a=CjuIK1q_8ugA:10
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTEwMDA5MCBTYWx0ZWRfX0G+Br/ee897U
 +eM6b/Z89+IA7jdCYeJE2HZUu+toOGhGaOlvCE43CfI2UIBl7nhTaun2GiSrmhNsWAOflZHj9Mj
 EA5COZloEEont35fbRqYb8VaBC1q3sFZaRADtHZbbyBT+wesIpcvUiDTGbUYpYssgkPBjMa0E8A
 K7N1lbgFZWq3Lc+6iFcorw85+1rg0U1sR6PYYpY5fQfkjbWilmNoVVNNrS7AU057H7a/QlhML0f
 SGP7ciJSiIS2VH2ApxM+ia3ofo5EkqjSKW7OUVVaG7H3mn10gD0Y2EqVZNWpSaAwHLY8N0461HB
 Xtf6YEF96dC9zUQ5SV6rf+EQchLdwq1C5XhbkSdZMV1r0J2snGearpxqSwpBblVjByHEprVuHMa
 wiUynRnbt0BdovkxeU+E8gvGBIXsWHK7dPnVsFdG4sbYgSE+GFGILzUJa+DNaZ+M/1gthibX/fv
 8vsHg8avcz++LS4xZBA==
X-Proofpoint-ORIG-GUID: sjiYdXuvcKsn3jmBch_-NV5VdjtLiAUE

On Fri, Jan 09, 2026 at 05:15:21PM -0800, Andrew Morton wrote:
> On Fri,  9 Jan 2026 16:32:32 -0800 SeongJae Park <sj@kernel.org> wrote:
>
> > > I'm working on documentation for this and much more.  Hopefully I'll be
> > > progressing that significantly this weekend.
> >
> > I was actually thinking it would be nice to have a document that describing the
> > current process, becasue the nwe can make an alignment on the current status,
> > and further discuss possible improvements.  I was actually about to share the
> > idea today, and start writing an RFC patch that adds the documentation based on
> > my best understanding, as MM's maintainer profile [1].  It's good to hear you
> > are doing the documentation.  I'm not sure your documentation will be somewhat
> > I was planning to make, but I sure that will be helpful.  So I will wait for
> > your documentation.
>
> Thanks.  What I plan to do is, roughly,
>
> - A whole bunch of changes to the mm.git series file
>   (https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/pc/devel-series),
>   which is the repository of all status
>
> - Add some words to all those added-to-mm emails directing people to
>   this file so they can look at the current status of all the patches
>
> - Add a glossary of terms to the series file.  Decoding akpm notes-to-self.
>
> - Explain what all the branches do, how material moves between them
>
> - High level description of how mm-unstable works.  It's a
>   development tree, not a patch repository!
>
> - Explain my decision-making process, if such is possible
>
> - Anything else I think of.
>
> The series file is a strange place to do some of this - we can of
> course move content somewhere else sometime.

While I thank you for efforts to document the current process, the situation is
that merge-by-default is burning maintainers out.

Documentation is nice, discussions of details are nice, but they're essentially
immaterial in comparison to this primary issue.

I wouldn't normally be this direct, esp. publicly - but things have reached a
point where we truly do need to change this default.

David is working through his entire leave period as a result of it, which is a
sign of things being very broken, and work being pushed down on to others.

While the current process seems inscrutible and having it be less so is
definitely a win, scrutible or not, we truly must change this default. It solves
90% of the problems and is easily achievable with no change to your workflow
(e.g. simply note in the quilt file whether an M tag was received yet or not).

I know there's some 'devil in the detail' here, which I'm more than happy to
discuss, but any problems that might arise will be small in comparison to the
issues merge-by-default cause.

In order to give you time to properly respond, I'll await your larger responses,
and delay taking further action to opt-out of this process, in hopes that we'll
see change on this.

Please note that none of this is meant to be disrespectful, rather simply being
direct and clear in raising a very real issue that is having genuine impact on
maintainers.

Thanks, Lorenzo
