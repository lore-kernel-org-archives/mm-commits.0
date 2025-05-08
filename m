Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D85442065
	for <mm-commits@vger.kernel.org>; Thu,  8 May 2025 10:12:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746699155; cv=fail; b=c15wWMMCCMtPVENy86kAHFidnuGT4bYIycFXqYkUl17YUy2iy2M3/+RuV8ghqq62kOFWXjOrQFo/d1VjO/CR/IE+O5J0CekeTJ9NkKSjx4cmTXvO9BIXj0LE7+jxPf1CPlfDDPvUGOHt4CoASBT8EM1r/GHV7ZuPhaqxE2+/fyQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746699155; c=relaxed/simple;
	bh=LmGIb9Yowk93VundD3G3uH15RBTNJEAg7n+MlwY+PaM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=r9Fi+ade4GzNaoni2pjL8itmdlU3RwtziSouNlwle8UqjGRcmddlWc7zMqWEMq3FzFZhMuqN2B6QFPIBQvSBzAMrl8dgW4Qwaho7wTQ37eHq3C3ONagnPbUR3RYpvLeLTLD4nm0GR6R42mWEVS1h0NZLJCyWkgeg2ULpbmlpdPQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=V5aKb+Kw; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=vT3OgIhz; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="V5aKb+Kw";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="vT3OgIhz"
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5488797D012553;
	Thu, 8 May 2025 10:11:58 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=TmyX5Tkqkp5+ux8D56
	+dAVlmb4wL7IsD0JV0H3F9b64=; b=V5aKb+KwjdSWCQ2w70Kyw3dvShiXfD2qsS
	B3UslnEnwiCiYqcQqn/n4KkYjzD1JyfqVuf3C6RZ5Sd44ADSAFqVYOMiHh4TI820
	YkxLJk6KPDeFHhBpZPqboLCikd2R4f2eyicSgWPmCGV0mCTMju9AhKG1K7+7lS9y
	pSY+bpOVHkzhF3oj/lpjMSNe8WvD/qXy3qw9P0b3rfnTW/nz4hHNzwplFv5xeUAH
	eCC2LvhEiqWxVrHIflDmZwFqcun/WW/T20ngzTRvyMY/QTaqkZ+tbB2KrmaPZ5hS
	X0R6PzzxdFUYDNCUD9dhlY/ewc5a4eEGWM1J+8ERdqqpBZ5CEvEA==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 46grtn86pt-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 08 May 2025 10:11:57 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 54885WK2001976;
	Thu, 8 May 2025 10:11:57 GMT
Received: from cy4pr05cu001.outbound.protection.outlook.com (mail-westcentralusazlp17010000.outbound.protection.outlook.com [40.93.6.0])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 46gmcbjrnj-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 08 May 2025 10:11:57 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=LmR89T9IPgpnSVx6OzdK022MHjaSw+zBw2sQiQS8uwGSZYf6fh1p7DJgECVW+SdDYQZ7Vpl++3MiXP89u46rvvP8d+hdR5uCTdxwQrC4+n7B8yB9gdFFnVqnOJDpYw35d/K1IW8Rv4YTCJgCkIIPBEAbvC8Dy8MCUEZihOfnJtBlBA1wEw81b325bwO50O8PjAiUEmUzR0c92YlHCUdHtwIrCl0AixofrMIr1WqbtRbb7y75zKVIBHkMBAwFs7O0d656On7oZBgPDojG+ehD/XXxEIESruoB2TwRLwf8ekyb/19NEeaV2MVsT6ymXVKo2yHxdrdSq+fdP8mVSGCw7Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=TmyX5Tkqkp5+ux8D56+dAVlmb4wL7IsD0JV0H3F9b64=;
 b=MRW2BmchkLPD5GIZJYez9Uysorcvb682O38vgwvqhib1jQNM30/Oalzcy7OYF+BGohKWmTz1LYl+9OKmAENj9uEgU87E8FXMTh1G+ws0ZoyPqbyHpT8Z6+HrkQV+uKdcAp99XkBA60RQpxzDnrLzyJBqKA7b6SCeGOwcgZbAhpQyPgNI3bHKFqf6mN4OJYZVWppw9KcYO26SYwfq7ID2Lm5G4UQhWRIGB3+yjhORXBIQDwnuzFxIqSraIkWNSf8C9T+nwzA2Di8O2Tl3XfrhgE1oG97LqvT6E+LctbzqBA1Qu4Dotc52pGP5DMwnnp+Ayp39lDXbc3SczYZVEwukcg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TmyX5Tkqkp5+ux8D56+dAVlmb4wL7IsD0JV0H3F9b64=;
 b=vT3OgIhzaqN2nJjapf/PN1ZxU2+PShDSq3Hr68jve0CiBQ9Vk0xJrCA1mn3eT5zbCPSBrdiZSsV818tospdBMSRpKPZQSF0/HAbpL+2uWfv39hCgAdO53ybM3gXyx4ie7lUOEpkIlbxrvOKhNn5eDgUEmc2k9O3htx/r0xY5+VU=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by SA1PR10MB7587.namprd10.prod.outlook.com (2603:10b6:806:376::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8678.31; Thu, 8 May
 2025 10:11:50 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2%5]) with mapi id 15.20.8699.022; Thu, 8 May 2025
 10:11:50 +0000
Date: Thu, 8 May 2025 11:11:47 +0100
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: Dev Jain <dev.jain@arm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, mm-commits@vger.kernel.org,
        ziy@nvidia.com, zhengqi.arch@bytedance.com,
        yang@os.amperecomputing.com, willy@infradead.org, vbabka@suse.cz,
        ryan.roberts@arm.com, peterx@redhat.com, mingo@kernel.org,
        maobibo@loongson.cn, libang.li@antgroup.com, liam.howlett@oracle.com,
        jannh@google.com, ioworker0@gmail.com, hughd@google.com,
        david@redhat.com, baolin.wang@linux.alibaba.com, baohua@kernel.org,
        anshuman.khandual@arm.com
Subject: Re: + mm-optimize-mremap-by-pte-batching.patch added to mm-new branch
Message-ID: <66fada4e-c9e2-4d67-a939-9cc1a93239d7@lucifer.local>
References: <20250508014113.7E78FC4CEE2@smtp.kernel.org>
 <addcfcdf-3ded-4d9d-8a96-6006d3b71a51@arm.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <addcfcdf-3ded-4d9d-8a96-6006d3b71a51@arm.com>
X-ClientProxiedBy: LO4P265CA0173.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:312::18) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|SA1PR10MB7587:EE_
X-MS-Office365-Filtering-Correlation-Id: b406fef7-0d05-4199-24e9-08dd8e18bf73
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|366016|1800799024|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?75BFM7Y05V5aHGxDQ0C/asrMZR7t3cNIDoK6C1mOC2g3oSSuu9R6k6rwnCVF?=
 =?us-ascii?Q?J+zouxw+3wjI2deoaZSO+d19h0fzqyxuS4pAee9vBhI13ASZmAJMRCCa4d6w?=
 =?us-ascii?Q?9ql9C/XGDhYDtPspfbEIjUhq2Az2s0RL2xoQaQSQM5I0dSEg+Wcbmr91EXwA?=
 =?us-ascii?Q?ay5VylJzswwtvZozAbDlO9hJ/79W4tiR3lN96PzZU16QZhwEoOpF3Si4ZhhH?=
 =?us-ascii?Q?WktMEXcTLejArmGmdYnntgOA9jQjImB1cPa3qFt0aQMHKhkdCctypeb7pIxZ?=
 =?us-ascii?Q?5QgYnuUInuvWmHGKS3XC6rrIxwiS15xZ01vNDTLfduLFIUYJWQaoRiK7pKWy?=
 =?us-ascii?Q?aVbIhHOW11tcj0iiVFjMHf4tEC3vCXhcNDUAWHk//z/CC8qZi5uXOLJKRwrw?=
 =?us-ascii?Q?aWbowXOpf+D7a9/S7yAQDAnzRAxFAJtuy4VHfc2wQj8Lfnoy8KCRcOzU5yRo?=
 =?us-ascii?Q?CAzwK3bynZbySiW62a4a6MrpuK9dnB3Qz0Q5sOd6jj0bvK93va00Y5I46Jwc?=
 =?us-ascii?Q?Dr50l32v/jYNZZJbKkLoom3LIJ+wzGGa6nLMf0S17EN1pxKKCtbyoYIdopst?=
 =?us-ascii?Q?QdxKmYileFS6h9DtGx4CFjLS6LctGWaKVNyKcHbwKfkGkoDl5fZQ/TahXsIJ?=
 =?us-ascii?Q?l9mN8c3qHeSRkRmg+U1RnOeYfCc/Vig3yx+Tjs6V/3NuCUeOdvPs5qh/1ra6?=
 =?us-ascii?Q?PEwuQXRKDsmP607WHM1+Lr+q/75l9QMieYvnXNFUgwOy2D1LzgCykXsxMaJb?=
 =?us-ascii?Q?0CqVD6h40Hq4jPCF7sc7AxmLmHx+7XTcBgibExZCZ90jwLG17aR8VNGZGvqQ?=
 =?us-ascii?Q?haPrZax/9SDMUbTxxkf0a5BtDrkGwvH5gQ7A00fufdQNFU1ounyvkqY2gNPt?=
 =?us-ascii?Q?Jt+v58O3UHY+0D8H+K/r3J9DrMZmTwcijK1Dq1SEJjvxDe3AwIcNvM2fLEwU?=
 =?us-ascii?Q?JAQVpj+jq6zRYlA2nhJbHJPu3oFvR2LhDFLCOQ6f1meNs4NnPzA23HiP8lfL?=
 =?us-ascii?Q?lmiLWK1QDf0EytW9b5lSE5pjaaqlGGBaLuHd67U+BC66JnkpBnG7uWfJeIJj?=
 =?us-ascii?Q?vBXa0ldN/q/nOqmX3XOTYjf0arS5juwmBDd8jXt8KVeJ08Jf1SgQDr39cjgr?=
 =?us-ascii?Q?WHmqExqmOiWJtl7sM8kzXMM/VK4MpiI1vVM/Pn94T1dNeQJhIiYl64U81dVl?=
 =?us-ascii?Q?OgbdbgCSd7mbV680hFkYxkGUTWTelG+RTqIDPviVpPDn8bwXSW9jRyVBbzBb?=
 =?us-ascii?Q?tp6Sw/6lxH5amBSNsFMjkaCRP7SYhnrTKJ9rfhEZaV9VBak1L/pJSqj1vR+h?=
 =?us-ascii?Q?a7kNKlKeNVwUStgcnuFF/g3/y8hbJdvYFQlOb/yMpQbmiGo1q1jazVqiKcq9?=
 =?us-ascii?Q?TQpbKo37iZK+bXHi/M5oW3MWdDk2uQ/CaWCdlUk+UHLgDcFWHA=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(366016)(1800799024)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?/m5zgVsfTsteJHIraHrCLMfVmzGln1ko/R9gj9TSI7o7+rSpt1xEvEsRG7n7?=
 =?us-ascii?Q?mMlaAtoppI7KDLf2wov9gykZhVKhTsR4XHsvT3ortqmeg7YoHapU9PG4dv6P?=
 =?us-ascii?Q?1RCWSzLd8n9BDte+0tSINwO9JliZHmfz58K7VkZPlA/1eD+xJajgnD1bE3/F?=
 =?us-ascii?Q?RMDU1c8vLFAOxY4LuiBwikuJhMFUcLwjPjfbyI+TrELRhr9MfQk3nW/HSQle?=
 =?us-ascii?Q?YT8BaJ5LxBBxj3fnZqZaznZGhGq0lFCpOQUvR1DKZsFEUi4Kk9LLKTeVId3S?=
 =?us-ascii?Q?BJPLTBtR0YkyPBBYf3iiEWVj7MMnsZb73ov86sJPVavlJuAy2SsCx/o//YzI?=
 =?us-ascii?Q?lFLRUH3im1dgsmpV9RSX1Ya52JFUGb4z2lNgcPeMr3ecv+yI8iSX3Q8Iwq9C?=
 =?us-ascii?Q?tHre+RjHoFEs+iQEYNZESZRxuNvWrXzktZ3b36wfuz2j6IxTyumFGRP+MxAB?=
 =?us-ascii?Q?DIw/yYPkfr8MzzCiC2nCGyvSkpLG0o+h+Bi2mgO31E/LSg3Pek1jHGFViSC6?=
 =?us-ascii?Q?Hn7NdkwvsaO9cOCBIRJwh0A3u7o4CKjcKDEHVBRVJWSl9utwWCLAi+3/uPDS?=
 =?us-ascii?Q?C6VuWE25t5Q9g3aUmFs2ZEtUzyJGdUMqfXmwzFTiXEU32tm2G+kkWdZrMyP4?=
 =?us-ascii?Q?wdHIpHkrSZA4JJwJ2fIT/JQYIB8N3DcYRmNN5fHXU1bgFnXYOqoM9nGXm/Td?=
 =?us-ascii?Q?Hw1Zah7jZw7tBPlcq06VtnmTKxZR7oIRn0KV5JwuJT4E06F6Z6rD8GfJ5bhE?=
 =?us-ascii?Q?7CSVGCYE0OXLRMOigWKQgoTZ35g5OEtPizYptjLjvaxKxRkt1mV+uqPfe2cM?=
 =?us-ascii?Q?DeJ2HWfFYzf5Se3UK+S6FWT4UK6TtBZ7KuUCGBn4qHfYSjtMTl1cUQm+TlSN?=
 =?us-ascii?Q?qQZzXPOftnWHmllFJK5gtlyEGXDZtQG/JMba4T0beHiMRiuPsNUt8R1tKhAW?=
 =?us-ascii?Q?2AendSjCM+yiDEPcvsixsZYKjlXN8CMcL9hS5P7I8PpEpW30f18wHq0YEljm?=
 =?us-ascii?Q?+jTIc3nJ0qN+CD+h+BwzaUynW73UlwX6CEfLJp/LZGrdDq3pIhmxHlwXhpAQ?=
 =?us-ascii?Q?XSQCd9l+Ss3y60SGTP8m1LN+hbRaqwuRW68WMYRfgQMe5wYBcq1T+YXev8yx?=
 =?us-ascii?Q?srFimRfHN7Fo1/JSMFTx/WE4wg/UBDjZxMUSbHgwDPj4NrivVSgJn1XcNE3k?=
 =?us-ascii?Q?Ug7n5PzBhKSFH/0rgYA3Vva04Ev1IQULs3ezvpjprPF0tc0QhHPhfl2ZgDKp?=
 =?us-ascii?Q?gaePa8UAcoA8C/RV9yKP744nXfFVtHtDeUXSPWLATg+XtfzPwaMEcLCTghWQ?=
 =?us-ascii?Q?stxKyFPO9Rr9rsT2Jz4FnN854+ajLsxOfl9XZVGcUVZQwKdnUwGWP8aopDzD?=
 =?us-ascii?Q?82LS9EUT4Fq1kuCJ2AXX4ebXUmXD2P+ZDfstor/GoSi1DNGR69+JfSq7E16c?=
 =?us-ascii?Q?kMsxXtUvFAbHQgwB7wXy/wuZiiIzaeK/2ftjnbPm0yNleYnsNkd7BklSLnh4?=
 =?us-ascii?Q?Ex/QAkWtf1R4jHfh1b3DJ6ITXB0WzqKQNtvVgg2qcijuSlxwlhgLEFn04PhT?=
 =?us-ascii?Q?Qt2507Q6i0nK6OzGntRt8H6l8zbbe+7MKfGePq2y6kP6+mEvOYcq4ufzpo3M?=
 =?us-ascii?Q?rQ=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	4DDT5Q8gVHrq583+3fQX6BmtCT6uOkWfJ4uBrH8Uopx9LugLSF7lSJiYXQXpCNgVx6Uk0DungaGeXyJEROsuxFH+7ZWysyMAictyy21WdEO3RBWKfkzlAQwgz/qLaMBGrmBpk3SHGd9P4l+MgpPxaUDHFV99LWdS+OEOrod8iNsn0kt3W6rYiaxF3h1mWjkdbkDW20J1/qCqXrTr75139F4+ucsBH+tnJCXmSEXhoMQD4Y+/632sOA/lxLm63nyBATgJVVjlvMgcMkyqsacP7lPm0jTFrINs76I6hmuyOK8119ST/i2KCWGIc1UjAnrZjzh3ipLXwEnE3/YOJCjCJZn6tn8TP7YzZEQ9MCjhFeyLgRBQJSzCfbw5C1xkNKTNUXMITOkOzBJDgLaOUnOGh5qQUbmIOe5Dt4C2ZEMYNRgy938NuTuBqRbGxfOXVxKN9+BhFsAxSYJcPXUsspsRig4JQcAXZVDmGED6d/PGlMDQhe/gJM2ONeDmq0HL/72lRfgG086kXiJpFodrzi+PMKLJksPSCVeFCk/9jdLReC8XJ4KNlXxPT+zMcIk8uYJLaJENFaNn+3nQDVzVga18hOOtS2E/8n7iJt41nrPEThk=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b406fef7-0d05-4199-24e9-08dd8e18bf73
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 May 2025 10:11:49.9530
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: dzoXY2HXey7Ncgp6/Uc2YN//ia9M9ZUV7CST3iXZiXd1nKuem7o2FxXF/tOfMJmv9kiTTUr3b9kYCxQqUSma/teDS2Gp3G2coIBEH33Sei8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR10MB7587
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.0.736,FMLib:17.12.80.40
 definitions=2025-05-08_03,2025-05-07_02,2025-02-21_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxlogscore=900
 malwarescore=0 bulkscore=0 suspectscore=0 adultscore=0 mlxscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2504070000 definitions=main-2505080090
X-Proofpoint-GUID: kYgL3X_qQFsi8nMj4SDV7sJbFCBmTDCf
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNTA4MDA5MSBTYWx0ZWRfX+jdoHZ7EherD RqmIXwWsbvJ5hV6p/dyr2lDzTDcfFtutQ8wKjfKFG4D9Pu8RhCLuwWU2PLsM34XjaAz9JEBOWkZ +ulaidPr1G6lMF026uZT5UZ3BTJv4yZU8VCwX8uBLnUZv3IUY3b9r0E2hoiZQ7M/2wAk1fupbUf
 LgDEmjVxZfBFo0xnmrgRcg7jSpzYnb4jR/RZVTh5rDoKZfq6cnDUEC6H1T3dVctVFuIFqc2souX EpkLiOV4JzfMptaVgVdI6UuwRhTtXT719raXM8ScyfWbkL5OCofoV3RbnQmpsDxzjUTnH93SkRO d9RqNk+HYx1iCF8b2K87EfcKVmPtiHVG1jFvz+cQ02ZfOs2VXDRoyerNIn6F5mkVEefediNFrKN
 tupKk6IWkevXIY8TGbrBPEysiGFCEMfKNFfFxL7zC6CKT6mWOTWjINOXgz8yZVMXvIxJPzPV
X-Authority-Analysis: v=2.4 cv=DtRW+H/+ c=1 sm=1 tr=0 ts=681c836d b=1 cx=c_pps a=qoll8+KPOyaMroiJ2sR5sw==:117 a=qoll8+KPOyaMroiJ2sR5sw==:17 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19
 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10 a=dt9VzEwgFbYA:10 a=GoEa3M9JfhUA:10 a=a2Chu2gLbXP8YFYIbGgA:9 a=CjuIK1q_8ugA:10 cc=ntf awl=host:13186
X-Proofpoint-ORIG-GUID: kYgL3X_qQFsi8nMj4SDV7sJbFCBmTDCf

On Thu, May 08, 2025 at 03:38:46PM +0530, Dev Jain wrote:
>
>
> On 08/05/25 7:11 am, Andrew Morton wrote:

[snip]

> >   	/*
> >   	 * When need_rmap_locks is true, we take the i_mmap_rwsem and anon_vma
> > @@ -236,12 +254,13 @@ static int move_ptes(struct pagetable_mo
> >   	flush_tlb_batched_pending(vma->vm_mm);
> >   	arch_enter_lazy_mmu_mode();
> > -	for (; old_addr < old_end; old_ptep++, old_addr += PAGE_SIZE,
> > -				   new_ptep++, new_addr += PAGE_SIZE) {
> > -		if (pte_none(ptep_get(old_ptep)))
> > +	for (int nr = 1; old_addr < old_end; old_ptep += nr, old_addr += nr * PAGE_SIZE,
> > +				   new_ptep += nr, new_addr += nr * PAGE_SIZE) {
>
> Apologies, this is wrong, I moved nr to the for loop thus nr will be
> initialized to 1 only once, what I intend to do is set this to 1 at the
> beginning of each iteration.
>

Don't worry, Andrew will pull the series out of the mm-new tree based on review
push back automatically :)

The mm-new tree is also intentionally designated as the 'anything goes' one
which has latest series in - easily applied, easily dropped, mm-unstable is
the one that goes to linux-next now and mm-stable is the final set of
patches that will be sent to Linus.

So there's no need to proactively chase here unless it's heading for
mm-stable really!

Cheers, Lorenzo

[snip]
