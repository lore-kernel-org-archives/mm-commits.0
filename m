Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46C42230BE9
	for <mm-commits@vger.kernel.org>; Wed,  7 Jan 2026 12:12:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767787975; cv=fail; b=JxJ+a7HQ/U7MNgE8EIdINAFasg56DvcVI6Ui/nK7ggWcbQDf5Yk5HyFYSDHzWfl0X/W8HJfJqC6p/QOrXe0Ol7+koJE0pRVkq/XFYWgdW1cjzVVSQfkWqGaHy3QrlnvqnL+RbH/1qgEkdadi6X8PCeXJINLznQgRMyJ2NZvApYU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767787975; c=relaxed/simple;
	bh=TklA/y/dyb+wyOoq1FkR+WWWaW6NO5zUK7NYdnGbjVw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=W14iNR2xpH7LjTz0BLSK1jV7P+cLYrTcVtXWVD5ujzvOOXiXfHR+8fa3rofmHQDnPyZTjlUnP6w4An/96wx5na50u72oBnrFIdu3OH5v016/dWeCCwYdFfLet0oRWwgxhicVWOwFkjiBjh5UWYyQKGLXG1gybqzDpHXaP/T47OY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=DrKwjF8S; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=FKCnL1bm; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="DrKwjF8S";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="FKCnL1bm"
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 607AQFDp1752266;
	Wed, 7 Jan 2026 12:12:26 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=2Nlr+A1rfqYhuqg9zr
	JdBPc6tEHgfFnVQ2QGqT5OREg=; b=DrKwjF8SFfzyjXYChjiSOTMn3KHEwkqSdj
	wUcXD/vZhBSq46sB4AAYLmgH2UGkXNdwQEInUay4Pj/+EBHpiXLSpt4ix08pHC6U
	Yv6RXAkMG6S4knm/O9gwCV6xIOf5VWMYkQ076N79prUVVTyRL52nY4Wv9/Jnn4As
	bCZsf6aR0oKTbuRtdYTQgLZAnPqDEliPa9p0IZa1x8hIORZGFhgtFMGmPUC1+8Lj
	VbbQcznZzExIoe2UEMWQc3rqly7rZodGiL6+hLk0SYnADLjl3WWmcEVmnGUGREac
	uFjtKidLPp4MDzl/qYu6VsGQcz2s2W4EWm7KmDd5X/20UDP0YM7g==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4bhnr0r3n2-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 07 Jan 2026 12:12:26 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 607BV3fR040098;
	Wed, 7 Jan 2026 12:12:25 GMT
Received: from byapr05cu005.outbound.protection.outlook.com (mail-westusazon11010053.outbound.protection.outlook.com [52.101.85.53])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4besjkt0ns-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 07 Jan 2026 12:12:25 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=X9I5donBbBzizfGFubDP0G0eF7UfgJPMy0tfpTb1ioVc3KTZ7pArtDVAtSmDdqt0fHirI0NjNwWZWZkMbjDvLmyHFCPyYMIodtXIw8oyWMKJlYEQdGP3n5/5o7NxAJfBhBcqZFO3IFC9sMOJ8pxT05KFTa2pcUjyRuBVRdow2jrxDyZYwy5JxVyaMV7AvCF/LbO7rPOBGKWVKMpMn1v8NDLQ7EhUz/8etBv+2jGiPG0tyDIUAiI3163qiEzwhpUNCqkvRR0F7DAsAaDJekwDVmpe6045M8UnCbnx3BIBN9CBlkaLuEDIrf1WXJXWkVxNkqqBk0nmFiuozEtK+Pa0DQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2Nlr+A1rfqYhuqg9zrJdBPc6tEHgfFnVQ2QGqT5OREg=;
 b=gNmZzLGGxZV2UOxJ81+NYH+z7JzpK/u13B2zaNNp+IJhAzrWNbfYKG6LpQ4MQgN2py10jDfCCjwmxv/OplL6loDJtjxETJxZOxb+l8NdA6eRHa5rUUw7l4JlyKWkD5FAQpbQpjRCjRAEqK8ME3c+VCR7AaB/DVr1uegRqNh0IUgfcYMzgOfFidE0gtvhqeDRvjwrNtrLP9D5vzJyW6+V23ZPGZayCjZK6HaG3kIH5PuhyRWK1lkXdp8HCFRMhNKOVcYa/OqlSad9ci5Lj1yxSlPYH0fVRcHbx1pc4PxxQElDUWbGIuazrlykEkKYSKV0JA5vmHCQ0OLriPQbGbi5Vg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2Nlr+A1rfqYhuqg9zrJdBPc6tEHgfFnVQ2QGqT5OREg=;
 b=FKCnL1bmSKCwQ4AqkyLxBtcQEvy0UTsgCU4Y0VTOgA4ExTm7HK867N8m0n0Hlp2e9uV4W7Le/4LGVpoqxZY38wWGcErwZs/vOWGUei95qEGng1aNKsHUTNPXog6yOV+sKtv20BjyV5zXfWr2CARPzo+zrpVqE0V6yHIA6aI8rLY=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by SA2PR10MB4556.namprd10.prod.outlook.com (2603:10b6:806:119::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9499.2; Wed, 7 Jan
 2026 12:12:21 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::f3ea:674e:7f2e:b711]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::f3ea:674e:7f2e:b711%6]) with mapi id 15.20.9499.002; Wed, 7 Jan 2026
 12:12:21 +0000
Date: Wed, 7 Jan 2026 12:12:23 +0000
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: mm-commits@vger.kernel.org, zhengqi.arch@bytedance.com, yuanchu@google.com,
        weixugc@google.com, tballasi@linux.microsoft.com,
        shakeel.butt@linux.dev, roman.gushchin@linux.dev,
        muchun.song@linux.dev, mhocko@kernel.org, mhiramat@kernel.org,
        mathieu.desnoyers@efficios.com, hannes@cmpxchg.org, david@kernel.org,
        david@fromorbit.com, axelrasmussen@google.com, rostedt@goodmis.org
Subject: Re: + tracing-add-__event_in_irq-helpers.patch added to mm-new branch
Message-ID: <4cccaf21-c78e-4017-bb95-29a401d7c3a5@lucifer.local>
References: <20260106033842.559EBC116D0@smtp.kernel.org>
 <3a96b65e-49b1-45f5-a36a-77b38cea62e2@lucifer.local>
 <20260106124930.827da463ea281bb392a9843d@linux-foundation.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260106124930.827da463ea281bb392a9843d@linux-foundation.org>
X-ClientProxiedBy: LO4P265CA0309.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:391::13) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|SA2PR10MB4556:EE_
X-MS-Office365-Filtering-Correlation-Id: edbb1d09-7f4a-47ec-1732-08de4de6025e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?jNo/wAtngZwIq38zcaj6AUOgYpFeyQXjqlNk1fVIqQR90owYODR2+pARkJlA?=
 =?us-ascii?Q?uvvbwwANmaRPFe2ATgMlhxkc11HwIThrCcqnHzCeU2iwTnkEDigFdMpuPoyx?=
 =?us-ascii?Q?yghpLQPjryxt+EfmpyL4z9I5GnLCoa4nScTuvC9c5xVDnOaYzVRVkOvF66R/?=
 =?us-ascii?Q?5xG8/0kSD82IEXfIv3jrGxi/RRyCdzBgH76PkA9SbFaB2ImC2zhLC/hf7JUg?=
 =?us-ascii?Q?aMg5xMklTIgahsckhthslA/uvUM0wop0hY8o8FZzH3VSrV8psMkoav1MKKkN?=
 =?us-ascii?Q?tZb190pc0/rKhKy7dINL+aUBerBarSMaYykj5gYdGvG7jLqGsNQ9UDc9QKlC?=
 =?us-ascii?Q?bFT6qCJtMKx2SRu9wpULlui1TWGHxLRc3guIrm0C+Q6gsNYvgHfAbCbI39/i?=
 =?us-ascii?Q?UbCekU/55OhGpZSM+Q45xRBWXTsYDJLesYspylJsAizusoPTZKU539dkxGAx?=
 =?us-ascii?Q?wzCCf16tTxW5omQgvl2V0s1pQXJQ1MR98E5c6K8+ah/CeTLf24BI/RtOXVC1?=
 =?us-ascii?Q?9QUBmL6awFdptXsF9cJxGIf2+fRqonrkbpdaTup4KRhN5jIv0F4xUN9WQvJh?=
 =?us-ascii?Q?0xjAf7ClWST5VIDpzdNXivXyRqcTZMeNINj+WE4VOWEyFHSg6gaZgogYPxUz?=
 =?us-ascii?Q?KybBTeknzWaHq7II6NqoEcr/LU0GkG1tklIy9ssKH6IJ50YtuLTVbYZh2M/P?=
 =?us-ascii?Q?29/8jxiTofz1DbAwRsO4AWY+AzLKzKvNWVCQ2uTaIksKynB3aWGTYqvVvIWx?=
 =?us-ascii?Q?G5fjEVZ9omN9liDKkukuElwTlM5wQ4lHcelA86ozUbOA+QWdMn9L3ohP6m5k?=
 =?us-ascii?Q?IAZkH6WhsGo+mGHPY2Lcyicl5/mAaOJBaBM/diUJicC4JJC3ktdWswLlhG1k?=
 =?us-ascii?Q?7XnfgWuUmGu2DbqsQYD0K2Tze4ve6P92/YW8M0DOd/0rLcTzb0fFdb35asJ7?=
 =?us-ascii?Q?eU9V4Fx95Pldj+Bg7EsoAdzLwCfs7AMtnmGwY5rVkQPpWV+UnJklqznGWq45?=
 =?us-ascii?Q?jKuvEMnPcaBXYRTEMY9dFlcbRbmtz4Nr70Xzob74iYu5XO+OzjBsDjobMFT6?=
 =?us-ascii?Q?8/gC7BtJF4tK3FQsclbC9RytQTrQnhAQJVXTEjLI2rWi5zzCUIupXZJibXHY?=
 =?us-ascii?Q?lD47StQDHNf4TzAJrYt/M8BE3tsgLydl0c8FRDeTK2D8cPvp7KgRRDHVuMgl?=
 =?us-ascii?Q?faokwlq/krOwhc/Y60o3uUk1j6ZQYiBBDYjVo7flPf+4AZaw+Dvd2KF0k+wi?=
 =?us-ascii?Q?pVMfD/Wde/J8w2i9w7Mp/Y04LqLOyPZrD4N1Ih+xF4hk+fKqAJNyCK/SFiiP?=
 =?us-ascii?Q?wIt74W/CTqjyNb5vmjLsyq/abnsGEj5FjEA0v1JOOLrAkk3U1mlZxn4JZ5Va?=
 =?us-ascii?Q?EbLWYasFh0WvlcdcnVvduBflt8JCREZCJ23WDCHQghPlGUgs6oWiSrc5do3C?=
 =?us-ascii?Q?l/wV8+y1uws2r73g5Gw3e1VfLt32vxos?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?PzqtvsYz+Lp6MXKGspxV20ONEGy8+gQPi0k0MvuDE1j1zOuqV3Iqk+Vu+EMx?=
 =?us-ascii?Q?pDI+m8Gq53o81GwVbOIGA9o7rFC5rOieJhHyiR+Ox82qyP3zeimhyZGxPLfh?=
 =?us-ascii?Q?y8uRFT+dV+Sarm3Xbk7f1+iPwm1piQRiFTB6uAS+i1+87fHQEIwyhlcoDAuJ?=
 =?us-ascii?Q?5DOwXTGgJA7iAUQg24JOM0SFkBm5IkeeWPBXj0A+c+fPsAvmKNNrBifjx7jQ?=
 =?us-ascii?Q?PY+ie8CM/Wxwn87VhqjdlrtzEp8CuyMli1xwd01wg1hOPW0XVIjJEFaL8s71?=
 =?us-ascii?Q?8cq/aC64Ds5WmnnRcXS2G9rx14v0s+97lfaprGDLCWsRdd5ixnLWMKbNd6RM?=
 =?us-ascii?Q?18UmgSXRsSB8ZpRH3AHvuGytzeqNeQM0HoXbzaXLF0MgI65/GFWbQ7ydn8Sq?=
 =?us-ascii?Q?YcTmsMXznGVBpj5XTD7FEqFbP7kAJYupfPQKBl133ZthD18CPeHLSh5ffsxJ?=
 =?us-ascii?Q?GSsKITo5HYssqXj0RkN4nA9osjSLaj8H8XbaTTG/SOY/YIylTM9qhxcmf8Rm?=
 =?us-ascii?Q?CPm6o+wvlfQXisoXuvdM3rfnla9tjf3FURexSbKZFjMa+RmiWCizS3EILiaE?=
 =?us-ascii?Q?pFqpWA+1xuT7+kDuw2VlVbAu1L/5wqYkeHHmIYtu592nb6xX98ABq9pUj5sY?=
 =?us-ascii?Q?vbK/pG0xgiZKLydk5gLkFLs4vLXguVeSMC73rreb6nRPaRUeW42WmZiO0lwd?=
 =?us-ascii?Q?s/rbD/utQt9VcTMkHo/V0UQgl31hUTgewiDId7AnaegPV9XFAd3N03u+Q0Wf?=
 =?us-ascii?Q?u9mEzDMxwZrooXA6vtzmfl7ozqdiO9s/3Vtq7Tn+uuAkI+u5AyhV37PhDrrX?=
 =?us-ascii?Q?WzY8e1UE7YaoqAOlHrKJkBEvZLO22d5gDp7Da2ejt+1Wx8CCBm/y1blkZiOp?=
 =?us-ascii?Q?m5tolixlkoxBVQEDi2Bn2RBSwFg+Fe3yNXdJrKKWzbUxPIpbjglSjdG+9moR?=
 =?us-ascii?Q?YtFFSDWnS8D0y180QYmlQkqF7Him1Inks82c4BLOK7rmeesgz8JOSWYb31LT?=
 =?us-ascii?Q?pQQgnKGSGnyCXHzh1KJeMFL1iICH3ZBYMbjkNjWsWyHWKl5FRXUG+3RVie1E?=
 =?us-ascii?Q?27k6AWLn6SiAEf96LL39VE7CqWuYS+aBaPWHcCWopb9LpsUMr4aNrC96oTXq?=
 =?us-ascii?Q?+hVxA/CeJmR86vI2tcf1Rbp98g1HxTl56S8fJY925AIs9bjxvU6FB9bWdTCh?=
 =?us-ascii?Q?OyP4qMDxnwYO66h1aXkMw/KDlghbGwNEZm46cWH8rVMqRMchMUNCLIJ5b9kd?=
 =?us-ascii?Q?vgj3zCTL276fEhmMY+S1ao1NLATICbRlUSAvmdMIZHXnqgb1g3eBuuOovcD6?=
 =?us-ascii?Q?l8sSjsi7bwQ2swR23PWEHceA/7EDhKTAo5hMqpr+Cwt2nIOEx8XVTDHgN//d?=
 =?us-ascii?Q?z/ebhIHYcLfD9XWI9Xw1Hyth+KPauwL0cGkgKVAcChqpzzmDvT6cVUfX75FC?=
 =?us-ascii?Q?TvJavnCk2Vb1ZbLgSFEixoT8tD033boAOxvYWeL3vaNJzoSRcnCI3vBypgGM?=
 =?us-ascii?Q?0hc5AYKxw3hO1D7agkRblTgJIpz6lG69tC9QPIv12/6wcPTXg29jZshK27ij?=
 =?us-ascii?Q?hohU3CGWkmIZxKz/YO8SVJ6CYHCRFpHtK10wIXW/u3g63NYM+a0gztvbssFA?=
 =?us-ascii?Q?SktFnBpex1Ud9rUAKm2scX3DLK9g3yqtLIDKIBvOr0ZrFVEQxwrHVVNMP+4l?=
 =?us-ascii?Q?c33hvyFkFGYVuIseLgQHmS4Bv6GSOpYlgHsGFFXqRu+gb2X/oPD73iHcrrxs?=
 =?us-ascii?Q?f89vsx0EqEh+r0/lRvFhfJX5A/n5mfw=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	OvxXhV/ZZAnwNr3gkvogyjUpF7hmAF7iRpHNdkAM0dlQ44v6751xvhAKLd+W9lxYk7nDmMTIYFDbmuIeZoCu2USif941X7Yuhzkf8QVdHfVVmQSvGQEmr7QfTvp500KvRi6Tm5CYaEfpIpC2nmvFkKt0m4rGfefMX4gMOS5b1BpQIm9v4UPQITKX459Eh14S/LrPyWK6V6CnFQRbxQO73zvwACzHV8DwOYjoPJbvHmz7V7ea5Z3F2lKj59ErVutc1TROs0Xd/gOPsfyB0/ZO+dyViHA+Jnx74eQAbTanfWArq4Aer1PaY2cPmEoA6IHclLRL1DGO2AK8vYVBIq7gVieju5Hr9AvE7wmQk0HOFZovdKbv4VnwF9QykUkK5mgwcBu+rB/s0BmhA+KH8+CeVne01IUPLjzz45zMCN43FyU98Xyi1BOnIhodncst3q+hPXwg02q/DxwjUTVMnOEcvWirk+h17Oc64aet58swpO0pZ+NjEE2EnzG5ayQbGXGRRRWPITli8Z5NpWUIhmhgr/lGKFrgjRwTPlnG4sTzTflbt4QvRJObW3T78QPTzhJRNevX28llcpp1H+grL0JZMZKjbf+pdLtRRJHAWtEYlNk=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: edbb1d09-7f4a-47ec-1732-08de4de6025e
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Jan 2026 12:12:21.3226
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: jEcMmlmFtzi3FMrEJUQGzqCRCWXC9XbQXKh5hV7MFO/EBadMn5gPPG12HhgRsjMuc0pM2tZCDc9/Et/dCPgHyb0oB1TaKVLSAYutOpVliKQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR10MB4556
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2026-01-07_01,2026-01-06_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 bulkscore=0
 suspectscore=0 malwarescore=0 adultscore=0 mlxscore=0 phishscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2512120000 definitions=main-2601070094
X-Proofpoint-ORIG-GUID: pFvSvn9PMVZOTuuh9naONKu_gYUUz-Rg
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTA3MDA5NCBTYWx0ZWRfX0nt3s2FZwWUK
 A/kYs0i9zghPK/HNYMIhAcBNVUllxj2U5+Y7Ocmwi+Z0GwqH4qFyh0XPF5cZ1WlcE6iAljtr9vo
 6LacWNqv9hig9puuumlav7chxB22dKgFhECEEZ6CEwuCS+cMAhSat2LftWn2ERBZbnRy/nuPFvR
 r7dhL5we9eN9LrNXWaZI/FkfoFfChwrMhbHdUjiGRAhV3um6psGKLidoKnYvHe211xnZIHWuftw
 tb5l++OArMCwIiPN2cfxvwJDWQaTGa+AgyeSDClHQ8bFiySnluZER8kpzOII0B8JNuhG0C3shtP
 ZyWa6iLsGffSzh7EbfbOdyNMVJJX3Z85DLTtgy6tDL6L5pBVIpgIfL2otaQduKUtadi5PYaSM6e
 yjZ4wYc+AsGohnUtJw4jWUOdDyCiOB36NnFbjKMc4VxkSH5vtXPexCE9DD0VvLEJXiYqL4Nz29C
 RW0UWPiHXcFyP/jm/2b0QqJYpHUB++TpVfHRPkqQ=
X-Proofpoint-GUID: pFvSvn9PMVZOTuuh9naONKu_gYUUz-Rg
X-Authority-Analysis: v=2.4 cv=a8k9NESF c=1 sm=1 tr=0 ts=695e4daa b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=vUbySO9Y5rIA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=yPCof4ZbAAAA:8 a=iD58l85YdxJWiZQ13I4A:9 a=CjuIK1q_8ugA:10 cc=ntf
 awl=host:12109

On Tue, Jan 06, 2026 at 12:49:30PM -0800, Andrew Morton wrote:
> On Tue, 6 Jan 2026 17:30:32 +0000 Lorenzo Stoakes <lorenzo.stoakes@oracle.com> wrote:
>
> > This results in (yet another) case of mm-new not compiling. I was trying to
> > do some other work and (yet again) ran into the compile failing.
> >
> > I bisected the issue to this patch, enclose error message below.
>
> It worked for me, and presumably for Stephen.  Please tell us how to
> reproduce this.

!CONFIG_MEMCG.

I'll let you guys investigate, I'm done reporting mm-new issues.

>
> > Andrew - I am still confused as to how mm-new works, this patch looks
> > unreviewed
>
> It was written by the tracing maintainer.

OK well that's at least reasonable.

>
> > (+ doesn't compile) but you took it, a related series that also
> > didn't compile and had review push-back was taken to mm-new, but other
> > series without review are rejected for not having review?
> >
> > Be good to get some clarity as to what mm-new is for?
> >
>
> The email you replied to had (courtesy of David):
>
> : Note, mm-new is a provisional staging ground for work-in-progress
> : patches, and acceptance into mm-new is a notification for others take
> : notice and to finish up reviews.  Please do not hesitate to respond to
> : review feedback and post updated versions to replace or incrementally
> : fixup patches in mm-new.
> :
> : The mm-new branch of mm.git is not included in linux-next
>

This provides no information about why/how things land in mm-new. At the
moment it seems entirely random.

Anyway, never mind I'm giving up on mm-new altogether at this point.

I'll let linux-next bots catch things from now on.

Please assume all future series I send are based on mm-unstable.

Thanks, Lorenzo
