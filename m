Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB49F1E9B12;
	Sat, 25 Oct 2025 03:17:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761362225; cv=fail; b=FgpbCy4uXQopV4Y3WmbqNZRNwUexKKtRoITgBFPHTkC5Lji04Gz5kn9Ce+7rdNng80afovRpBmx9qaTiWG/iMlfSeKrwg23aJdq1f7vMT6Wk1b3mKETC+B7gMyzZSe5kw25sD6mrCqp4wiX92tSp4Zt+Ua8bOu1FoXqf38WDwAk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761362225; c=relaxed/simple;
	bh=P5KeHpaOr7u0yQLfDQ22ebTYdcZydXnBwzdK9y4m7FI=;
	h=Message-ID:Date:Subject:To:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=pYbtECoj5HR6MK+LX2bNjOJrIYje/I5mQ+QBHRCbQwcDTsFUZU7qiHOR+J4vIlZ6yHKkqa32VK9Dlu1TPx9s+fJYCqICoSL0p64B7O0DY75sakMJ/sl2MRgzmZIAYPQDd+tXWybWkBy9xApjDWVroGurx3bAlSJ4Ib0p2pRWde8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=MXF+ZvE/; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=BjyZR/Uj; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="MXF+ZvE/";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="BjyZR/Uj"
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 59P1XVpA009178;
	Sat, 25 Oct 2025 03:16:26 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=
	content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=RtL+u5oQJaLIzrcE0S8sIxWdJxIyiFnww/hTOIuk1Ps=; b=
	MXF+ZvE/3MP4sQKeIsD+QDuF+l5HpB/d5a0x4+Rp6gkH3mv+1OKu8KprQavF3pqd
	P14oJ5iWuh58aUg3TF+WGx3+hoZmyUXpuondTeSt38nDHn2HS+EjrMNSuLuQ+l9I
	aj8ASBtZ0jskenhC8Si18FkmCdnGwjv1lJcYgNRFHGqQE42gJdiMD3C0cgJT1KOd
	6CiCOJx2AWXZdJMpDfkCNTslrR3g11j31P5uCEE20jtjQPz17IpcHXq84abOLJQ+
	UrBOEy6yxRkZttpgCTcD6Br66TowbAo6DqfKZpnJ+Ec7XcjBPfN7du5/iBDO/2Xy
	8nDJ7TqV4MNZQEVpiBexLA==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4a0myc01jc-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sat, 25 Oct 2025 03:16:26 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 59P1Xgoq037516;
	Sat, 25 Oct 2025 03:16:25 GMT
Received: from sa9pr02cu001.outbound.protection.outlook.com (mail-southcentralusazon11013063.outbound.protection.outlook.com [40.93.196.63])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4a0n051s4u-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sat, 25 Oct 2025 03:16:25 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=lYFzvYgq80n3cruce094TCGdA6LY5SWzirbJ4wiGCMzAm8RocWUMOCz26REQsfoatO1pGe8zj5ds/1vn1FD/DxCfjODq/9hs22MirlWU+Pn7kpuSrjvSLCEjQYDp5MM7zDuVYyjKtop/fqMPvvU4vkVPJvBDmMyB7MDPhk7/BoX5GVIF4BDL944fnbnzTmab9aLnWGcNR+7fX0iITKF5T1rnLpGodT85TRyYKFbtvVU1+42K7EV5sx9AvvywjDC4fnvO385rN5KhlsiQup4FsLX0BlQaomRzWkoH2X84R7c82zTpmCjX34dg1Iu1+UZpMbmV/T5+dKemsDciXfNNnA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=RtL+u5oQJaLIzrcE0S8sIxWdJxIyiFnww/hTOIuk1Ps=;
 b=NxCXDn07gaqdpA0wBWu/L0LHiFibaD/6jBWK7pzcjXtNgeR9u3kf+vgLRA4Ko5OqwilrzYz9m6+0hRicn6dg+McjWFZYqiTq8O9/Sz0y5vvmdpsLgH5F7/U8bU0n4OUFYsJ0pEqOkrEhq4sKF9ZPgBrV0S9ZBhYZiLnWgHXkaX1625KARUgZdbPdX33WGZ/KECI0MX57qdn/4YjaEzH1A3tOxUAyApo+C+1Urt8uemHwBTyMvqa5TqeNLLNd86/CABa+iixNQgl7Vq5DMtCE5OqV9uz1PkqOAei/DiCY3y0LXhgb7+hkRV96pQZm+wZzYT7TawfTKhHhq5k6abUU/g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RtL+u5oQJaLIzrcE0S8sIxWdJxIyiFnww/hTOIuk1Ps=;
 b=BjyZR/UjSjIyOJQf/oga+mgxzdAQQu9dDf5bRYV3+ftml2DOLX+TbtK8jn/1pyetZotpresCsnFd53GjUjtNI51rpiun/S2GtMptX4/286cuqhCOZuq2x0V3UH9dZUp5/b2y9lmUSxU4XMJR6/mfRoueV+fYkkltyJZrA0iymHI=
Received: from DS0PR10MB7364.namprd10.prod.outlook.com (2603:10b6:8:fe::6) by
 CH0PR10MB5067.namprd10.prod.outlook.com (2603:10b6:610:da::16) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9253.13; Sat, 25 Oct 2025 03:16:22 +0000
Received: from DS0PR10MB7364.namprd10.prod.outlook.com
 ([fe80::b7d7:9d3f:5bcb:1358]) by DS0PR10MB7364.namprd10.prod.outlook.com
 ([fe80::b7d7:9d3f:5bcb:1358%6]) with mapi id 15.20.9253.011; Sat, 25 Oct 2025
 03:16:22 +0000
Message-ID: <86935d30-eeb5-4a38-9994-e4dfd30d3013@oracle.com>
Date: Fri, 24 Oct 2025 20:16:17 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: +
 mm-huge_memory-preserve-pg_has_hwpoisoned-if-a-folio-is-split-to-0-order.patch
 added to mm-hotfixes-unstable branch
To: Andrew Morton <akpm@linux-foundation.org>, mm-commits@vger.kernel.org,
        yang@os.amperecomputing.com, willy@infradead.org,
        stable@vger.kernel.org, ryan.roberts@arm.com,
        richard.weiyang@gmail.com, npache@redhat.com, nao.horiguchi@gmail.com,
        mcgrof@kernel.org, lorenzo.stoakes@oracle.com, linmiaohe@huawei.com,
        liam.howlett@oracle.com, lance.yang@linux.dev, kernel@pankajraghav.com,
        dev.jain@arm.com, david@redhat.com, baolin.wang@linux.alibaba.com,
        baohua@kernel.org, ziy@nvidia.com
References: <20251023231218.AECFCC4CEE7@smtp.kernel.org>
Content-Language: en-US
From: jane.chu@oracle.com
In-Reply-To: <20251023231218.AECFCC4CEE7@smtp.kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PH0PR07CA0092.namprd07.prod.outlook.com
 (2603:10b6:510:4::7) To DS0PR10MB7364.namprd10.prod.outlook.com
 (2603:10b6:8:fe::6)
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR10MB7364:EE_|CH0PR10MB5067:EE_
X-MS-Office365-Filtering-Correlation-Id: 96bd7c3b-194c-409f-e35e-08de1374df80
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|1800799024|366016|921020;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?MWNtZmNyTFhhMGNXNGJlUHlsQzNEdCtYeXVzSXZQeEhJcDEveVpSN1lrSHdC?=
 =?utf-8?B?U2JESlFLWVJnRGVldW5VbTh4ek5QZUUyMW9jUFI0blV1YXRhRHRxcmN2SHdH?=
 =?utf-8?B?aXBHZk91L3lkVmhhT2IycGhrTCtmcWZzZ3RRK2pRWnVYMW4xZUZhL2Nla2VO?=
 =?utf-8?B?VURDeDd4UzIxOWtwdlZiU1AydW80bEVDQmZKbytKUzBvQnMrdWw5aXJqRWpk?=
 =?utf-8?B?a2Y1aXJBMGhWY3VqV29lclVHT2ltMGp1ay9zVU1keGdtQldmN0JNWVFTOTZl?=
 =?utf-8?B?QnNLaFhlSnlvb04xZlpGdk9SUVRmeUxJSlRGOTNoSVRWeW9qUWVNNGd0M09w?=
 =?utf-8?B?ODZWdFNHeUZHUFdFckYra2FLQUhHZTZhZlZtVE1rZkJMeWpybTl2Y1daTjBu?=
 =?utf-8?B?V3dGTTdQSEVHSDI2eldLNG4yRGQxNVRqbUY1VXRKcVl5WUdJL0NvajVwUC9D?=
 =?utf-8?B?cGpHVlJoZ3dFT09YWnhtL1E3dWhQdUVIVUE4bkNsc2twUDg1Nit5N0ZJS1Uz?=
 =?utf-8?B?VjBPUU1nR0YrUjFyWEh3bFVZVDB0UUl6T2dkY1hZdTdQeEhGTHdORCsrOWJW?=
 =?utf-8?B?Z0FwNkgvYXZNWUVMSkRYVkdRV2J5Q0JTeDlmalFGcUR3WE1MYlNneFh6dWZL?=
 =?utf-8?B?RDdKdWVQTklwQUwxQkk4bkRNaWhsb0Ntb0VXenkrUkZ1RjF1cUZYV0s1bkI1?=
 =?utf-8?B?SWFBeGVVMFRuVXdTSzRJaW01LzNzdnRmcGlNWXVkMlZBTlBaUWJ2TlhOSnR5?=
 =?utf-8?B?dkRlYk8xUzFKOGpvcWYxNDNHTnQyTTZFZFhiY0NOMHJBN2V5MHRBangxbjNw?=
 =?utf-8?B?a2J2bmVYTXYxUTl5SUZHazRZREtuZHhacS8vUW82WTZyS0I0MDA1QklxWjNR?=
 =?utf-8?B?UCtPcHZLRlFmYllMOGYyZktmTThDalJZR2hpNlJBSEpyRFB2bmJUMXdzYkpH?=
 =?utf-8?B?ODJ3TWc3OUJNQkcrWXkzSFBvRjFIdWdpbGJSQkpkamFyWENwMm13aWZEU1k0?=
 =?utf-8?B?MDFZcXFNZ1poejhQVHE4YW9JT2VoZis1cUNNWFZFN0pqVWRIQ0NzUzNmZFdC?=
 =?utf-8?B?U055aU1ydGtwVXQwVTZ5UnU2alNtUEdWb21vbW9RWHVERGkrUVBodU9kYTcz?=
 =?utf-8?B?c01vQVh2TUdzWHdNSVV5YjJIYzEwTHFJWVJRcG91ZjNIWHFIcEZOQWJzenFt?=
 =?utf-8?B?TlBGU25VZ3JFQnZ5TExtNnovOVVmWXF1SnlIV01laTVjVlhZYkpkSFc0TWtz?=
 =?utf-8?B?ZHpnK3RlVk0rb3crLzRVU2VlaUxpM1IzQUdjVkIvZ1d0RUFIOG1ISjZHUnRl?=
 =?utf-8?B?NkZKZ0xRb0VQUlVjQlpBNytkTXh4cGk4ZkZuSVRvNjV6ekJrL2tJM0J3MmVm?=
 =?utf-8?B?MlBWdzVVLzEyNzltRnppZ2UxK09PR0JKTE9IV3o0SklxVVlLM2Jlem42K1Nm?=
 =?utf-8?B?VEh3dGYrV2ExcjFVSFYzakswSUtJS0g5c0VCa2NYanNCckFCNjQ2VTJIZk9Q?=
 =?utf-8?B?UDNiZjV1V2RSYkdLajJJRGNwbnB5NVdsdzdWUmt0UFQ2bUZPeVNEekhWbVli?=
 =?utf-8?B?bk1qeEhsWmZJV2I3NkRJcnREUlFjUHgwcGJnby9mZ3lxNnJRTUVyMEwzaFZ0?=
 =?utf-8?B?RkxSQ2RkS2JQdjV3bW5qWElVM2FvdGFEMmNLbFB4ZU1kKy9sTnB6cEgxR3JO?=
 =?utf-8?B?bW85bi8vTmpkc1VzVGZXWnRaWVJwT2pMdU5sb0VwRUw3K0dpOFJLbmFuaXlz?=
 =?utf-8?B?OGlNanppS2FJQ3VTeTg4eEFlVXl3bEtEOEpEVjRMc3ZTNVFGdm4xOEw3engy?=
 =?utf-8?B?enBLb2kzQUNPNUd5NDBpVVhrQ3dQRDE1Nm9nWlUyZ2tid0xSa2RlTnVzcHE1?=
 =?utf-8?B?U3FpZDhZV1ZEcXp6NnJKbUNpMC9QREgxeEY5YmdyWXJUdUhZWHZoNUlzbHhT?=
 =?utf-8?B?RXN2Z25UT08rL0tlMlVueTFXcXd6RnlDMWxBRC9vb3VqaC85RnhOWjhLWWNn?=
 =?utf-8?B?ODJLdmxUTDFBPT0=?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR10MB7364.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?LzlqaWRudjhDT3l0U3ZsQ0ttNEhwOEw2OUtqOXpFWXR2aDhmUS80dVR5NkNz?=
 =?utf-8?B?SVExaE1FWm5oWU1KSkdoYUlkK2p1NGpVRzNqaVZWWThvOFVZZ25CaVFqTkk0?=
 =?utf-8?B?ZkhwZDR1V3B5L01tSW5zVXNlWlhlVExrbGRlUzRGd2dJQmU0a2FrdFNNdXRR?=
 =?utf-8?B?a1FhdDB0cEw3UFpFMGM1OC9FbmtpOUExL3NCZDJuK2ZZQVdwZmVWeXlWVFZu?=
 =?utf-8?B?ZGFIblhudjFaV1VGd2FSVEszRnhsa1V3aFhENVJnZDZzTTRKZjhkS0RrREp1?=
 =?utf-8?B?cGp6aEZqMlVKSHdnajlQbXc5YWc5OVhadkVRVlQ3Um1IRVdoT2ZoUEZDWmsx?=
 =?utf-8?B?SXNQeVpVWmp2T0hCbzcvR055MGtuOFhwZlBzTE1pc1JyMTdxSzd4STdYeEdJ?=
 =?utf-8?B?Yk9QZUUvc1RTclZuanY0RDBiS01IWi9qNFE2Y3NXTVh6bmxBNm00QnRPUlFJ?=
 =?utf-8?B?R2hIZmhEblorN1oyYnFsTUxwdnFXRGkzb2o3MVZXcEcrMWk0dUphN2FpTFZU?=
 =?utf-8?B?N0x0L3A1Vk13VkFEclhvU1lqM0tpQnFBTnZyYnVpM3RzSEk1Mk5HcmRnR1hQ?=
 =?utf-8?B?dmt6ajBOcS9NQXd2dmx2SUtteGlYYmxOczZSKzFVRVBNUVdYV0RWSzFBd3Fs?=
 =?utf-8?B?TXBxYnBTK2xMclJpUG5pUGpxYjAxeG9UMlJuS1pLT2hQbmxRWFowZ1UxZ3lr?=
 =?utf-8?B?TURIWXh5Vk5EK0RNdktWK2c3OFdBdUdRVDFsQ0VwLythUFFjbmt6YnhNcGpn?=
 =?utf-8?B?Qnp3N1JGaTQrOGJzeHYzcUU3VGpWU0Q5dFg3SXhGb2p4b2JSWnRzOTNvUlV3?=
 =?utf-8?B?Tms5NDZUZXFMdHJhSTg2b2E1ZVFBL2d4REY2WXBTM2NMWk1vZHFuandBR1ZX?=
 =?utf-8?B?aUZZdWhHanhkb0VWV2ZWRWZaNWx6R05OMER6Z1hmcVhoT1F5ZDBHWi8xalQ0?=
 =?utf-8?B?N1YxcjY1YWwwMmpUclViQW5tOEs3YzhzSkR1SlNCTHFMc2tvUnhtaUxtUEF5?=
 =?utf-8?B?RVM4VGZ4VzJZUEhNMGU1Ri8yN0RHNWdYRVZBYVorYzJMSFRjYjBGb2Y4OFZD?=
 =?utf-8?B?Uk1xa1pxeDNmK1hNZUZ6Q2hxMmh2WXpuN0JOZ0JWN1k4bWxmVUhLcUtuTDU1?=
 =?utf-8?B?M1JvMjZoeW9GeEZ5dmFHdnBsbWRhQkFOaHdKS05WWnRYdHlHUVBXL1ZXTzZY?=
 =?utf-8?B?aGJJM1pZVmtFeVhnQlpLQ3p6a2FCUXZFclNyRDVPSkJtZUltSzh4dEtvMmRB?=
 =?utf-8?B?UVhDMXdBT1lGN0wwV2lBcjZUZ3JsRXVyM2FQcEZwSWlyejVmMHY3VjZJVGVi?=
 =?utf-8?B?eHJBbCtDVkwvZUF1T1FoMko0K2NEYXpaK2d4K1piQThVOWtpd2RZU3U3cU93?=
 =?utf-8?B?VDZlOFpxMDErTUE5c01DV0l6QU5CaVRRMVdSWS9aS3ZheWM4UGpYUGx4UWVY?=
 =?utf-8?B?bzJGZll3TEFveDcyQzVlb2d3L2NXcVVGRng5SjRlWG9hb0FwU2dmMm5mbzFC?=
 =?utf-8?B?eHpmcHJvSFJVVmczQWRlRmN6NTh0ZGJkdjlzdCtOdWRhWWltbmxiOWIxenBa?=
 =?utf-8?B?Znd4akNhcHJtNzRWQnAvOWU4SFppLzZMazhQTE13MU9wT0tKc1B4MHYrV1c5?=
 =?utf-8?B?RnpuRC9BNGVLTVZpWS9oeGIwNjhuV1ZaYWVTZWlTQzNxNDhLc3FHZ3U2bVZr?=
 =?utf-8?B?cGtOc3N6akR4WEk0aHNUVUE4aEJSSGY1aVh3N1JwRFUwNGdYdmxGSkZReW12?=
 =?utf-8?B?WWtMRG0zQ0ZjTHhJWEpaWXlkR1R2Y3hnL1RPUm4xMGpxMkJqWVY0d1dmU05n?=
 =?utf-8?B?ZVNUMHlxNUVQcWQrbnJUWWl1SFVDSUZQTGs4VnlSM1VhWmx4TjU1ZUNWREFE?=
 =?utf-8?B?T3F4blNxTkVUYnNXVVdLUHMyMUZ0VDhxRjlPNnMyRngvcnFTWnpsOGUzS3FO?=
 =?utf-8?B?SGp0STRSWXlGRHlIdzdTVURPek4xeEpIOGxWMEduME9XRXRPVWluRHdwZEZV?=
 =?utf-8?B?RXdUR1JITzAvYkVOS1l0ak9GNjJOWTZjcTNHYWRNeGJsV3cwc2VYWjc4bWxw?=
 =?utf-8?B?UnAwelRFdnUyblpYZzhGTGJtSW9MTUE2QS9iYVBZeVJKWkxibXg4czU1Sm1R?=
 =?utf-8?Q?hDa5WBafLxj7WdX9uhf3OtnOD?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	cCpBvDFj5bMa0MVDGarIlqecVlWUkzMiSnV3AvorAH1SoUy5WstCBTiSyem5V1itNfL+j7SIL7c6FxfAfpWd3X4WIVNEl1emsT+LpWWS7mlGOmjb5YqgWQBp2RvHUrb/5xhvwtHayBjJKS06Jw2G7OFrAlUNtS/1bK6hW3mHgtjJ79uFMG7SMr7kUqW1ceZCqfjzvUrMgN8mwHxBJdIc4DBinqrE38kZQFm543ALWTf5MTzSxQ/T5ep1/Uwz8KLQ2kYjOS0BJkaFEypa/KUCDMSj9GtSGZRuINobUbRzWKAZfnz1wSj1yd/TDBTIKTcwyyweAd6a5ge8RZwusK0l/5BdSgLM5Z1wKlULOq22SFkQTQg7CtI7ZEbzdxXO1Cga7EmyDIGipRvPmTJFLSfRyRE82bNKSW8zPLNig9oej6Wk+xfBXSILEoHxe4i9CvAz5Bq0SQ3uv3MoctaZEUHVUsLPIvLtjPfebh/7en8+xjTGMraDmHUUIhkhwP23Uv+xECZtb5KBtxbYGK0hcEMNCkPP9z6/l6MKuiZ9Y5wuye4od7AZju/cAP3v8CU8kTeHuiZBVYRK2driAvqIW/y33DyrhmV3afNRA+BujN8U3VU=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 96bd7c3b-194c-409f-e35e-08de1374df80
X-MS-Exchange-CrossTenant-AuthSource: DS0PR10MB7364.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Oct 2025 03:16:22.2239
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: DiLjFhXxIpZEL+eqFxh9LlxvCNU64ppuJIvK9BsZbvBOFwIuZUmVYO7cvdEcEaPKtkhbQoea/D1F2waiQcHnwQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR10MB5067
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-10-25_01,2025-10-22_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 phishscore=0 suspectscore=0
 malwarescore=0 adultscore=0 mlxscore=0 mlxlogscore=999 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2510020000
 definitions=main-2510250026
X-Authority-Analysis: v=2.4 cv=fIg0HJae c=1 sm=1 tr=0 ts=68fc410a cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=x6icFKpwvdMA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=VwQbUJbxAAAA:8 a=pGLkceISAAAA:8 a=Ikd4Dj_1AAAA:8 a=20KFwNOVAAAA:8
 a=NB37xtsDAAAA:8 a=vzhER2c_AAAA:8 a=SRrdq9N9AAAA:8 a=7CQSdrXTAAAA:8
 a=yPCof4ZbAAAA:8 a=JfrnYn6hAAAA:8 a=i0EeH86SAAAA:8 a=Z4Rwk6OoAAAA:8
 a=aGyTmQ2GaQzGmsgbloAA:9 a=QEXdDO2ut3YA:10 a=IlkzfGtsIyjWS4YjqO81:22
 a=0YTRHmU2iG2pZC6F1fw2:22 a=a-qgeE7W1pNrGK8U0ZQC:22 a=1CNFftbPRP8L7MoqJWF3:22
 a=HkZW87K1Qel5hWWM3VKY:22 a=cPQSjfK2_nFv0Q5t_7PE:22
X-Proofpoint-GUID: DgvV0ObN3c-4fTKte4El19WhCNNm3Mq7
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMDI1MDAxMiBTYWx0ZWRfXxHkXMCCt9Tyl
 bj5fkwhlPrMkGRVLhT6cejwaVHatLefhY9txTEOys+Vjoxmk5SB/nbCudjk4/2h5vqe08JDELW4
 6jCb8d1nKXGZ7JUbDgdLuwWoeG3+VwwzEWpCAkOUBNJSc/le0ayEGZCr/n2Y2Iu6Yobd7SddoKA
 1xFBlYjZe67R/4s0P5Ara7HHxX3N4Flk0BRQ8AYx6cN+6uJhQklR+UyNWBP3XZLn/U8fQKcCU5f
 lkjYpXbf7OWzW6c0Iho6ug+V0mFK+qOPy9ag30AWs9PGcDxyWiZ8lXMHjx3f1CDicWw6y0zzqbL
 iM6+gd4gPtUyzde8ZADd/FNL7dJa/Z12MpsES1Kpo+IIeEyqUN/90luqRqPklSN2lW8lJcJJdpQ
 /7KxD0qiVzdr9z3KJGvEu0hNajNTsA==
X-Proofpoint-ORIG-GUID: DgvV0ObN3c-4fTKte4El19WhCNNm3Mq7


On 10/23/2025 4:12 PM, Andrew Morton wrote:
> 
> The patch titled
>       Subject: mm/huge_memory: preserve PG_has_hwpoisoned if a folio is split to >0 order
> has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
>       mm-huge_memory-preserve-pg_has_hwpoisoned-if-a-folio-is-split-to-0-order.patch
> 
> This patch will shortly appear at
>       https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-huge_memory-preserve-pg_has_hwpoisoned-if-a-folio-is-split-to-0-order.patch
> 
> This patch will later appear in the mm-hotfixes-unstable branch at
>      git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
> 
> Before you just go and hit "reply", please:
>     a) Consider who else should be cc'ed
>     b) Prefer to cc a suitable mailing list as well
>     c) Ideally: find the original patch on the mailing list and do a
>        reply-to-all to that, adding suitable additional cc's
> 
> *** Remember to use Documentation/process/submit-checklist.rst when testing your code ***
> 
> The -mm tree is included into linux-next via the mm-everything
> branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
> and is updated there every 2-3 working days
> 
> ------------------------------------------------------
> From: Zi Yan <ziy@nvidia.com>
> Subject: mm/huge_memory: preserve PG_has_hwpoisoned if a folio is split to >0 order
> Date: Wed, 22 Oct 2025 23:05:21 -0400
> 
> folio split clears PG_has_hwpoisoned, but the flag should be preserved in
> after-split folios containing pages with PG_hwpoisoned flag if the folio
> is split to >0 order folios.  Scan all pages in a to-be-split folio to
> determine which after-split folios need the flag.
> 
> An alternatives is to change PG_has_hwpoisoned to PG_maybe_hwpoisoned to
> avoid the scan and set it on all after-split folios, but resulting false
> positive has undesirable negative impact.  To remove false positive,
> caller of folio_test_has_hwpoisoned() and folio_contain_hwpoisoned_page()
> needs to do the scan.  That might be causing a hassle for current and
> future callers and more costly than doing the scan in the split code.
> More details are discussed in [1].
> 
> This issue can be exposed via:
> 1. splitting a has_hwpoisoned folio to >0 order from debugfs interface;
> 2. truncating part of a has_hwpoisoned folio in
>     truncate_inode_partial_folio().
> 
> And later accesses to a hwpoisoned page could be possible due to the
> missing has_hwpoisoned folio flag.  This will lead to MCE errors.
> 
> Link: https://lore.kernel.org/all/CAHbLzkoOZm0PXxE9qwtF4gKR=cpRXrSrJ9V9Pm2DJexs985q4g@mail.gmail.com/ [1]
> Link: https://lkml.kernel.org/r/20251023030521.473097-1-ziy@nvidia.com
> Fixes: c010d47f107f ("mm: thp: split huge page to any lower order pages")
> Signed-off-by: Zi Yan <ziy@nvidia.com>
> Acked-by: David Hildenbrand <david@redhat.com>
> Cc: Pankaj Raghav <kernel@pankajraghav.com>
> Reviewed-by: Yang Shi <yang@os.amperecomputing.com>
> Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
> Cc: Barry Song <baohua@kernel.org>
> Cc: Dev Jain <dev.jain@arm.com>
> Cc: Jane Chu <jane.chu@oracle.com>
> Cc: Lance Yang <lance.yang@linux.dev>
> Cc: Liam Howlett <liam.howlett@oracle.com>
> Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
> Cc: Luis Chamberalin <mcgrof@kernel.org>
> Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
> Cc: Miaohe Lin <linmiaohe@huawei.com>
> Cc: Naoya Horiguchi <nao.horiguchi@gmail.com>
> Cc: Nico Pache <npache@redhat.com>
> Cc: Ryan Roberts <ryan.roberts@arm.com>
> Cc: Wei Yang <richard.weiyang@gmail.com>
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> ---
> 
>   mm/huge_memory.c |   23 ++++++++++++++++++++---
>   1 file changed, 20 insertions(+), 3 deletions(-)
> 
> --- a/mm/huge_memory.c~mm-huge_memory-preserve-pg_has_hwpoisoned-if-a-folio-is-split-to-0-order
> +++ a/mm/huge_memory.c
> @@ -3263,6 +3263,14 @@ bool can_split_folio(struct folio *folio
>   					caller_pins;
>   }
>   
> +static bool page_range_has_hwpoisoned(struct page *page, long nr_pages)
> +{
> +	for (; nr_pages; page++, nr_pages--)
> +		if (PageHWPoison(page))
> +			return true;
> +	return false;
> +}
> +
>   /*
>    * It splits @folio into @new_order folios and copies the @folio metadata to
>    * all the resulting folios.
> @@ -3270,17 +3278,24 @@ bool can_split_folio(struct folio *folio
>   static void __split_folio_to_order(struct folio *folio, int old_order,
>   		int new_order)
>   {
> +	/* Scan poisoned pages when split a poisoned folio to large folios */
> +	const bool handle_hwpoison = folio_test_has_hwpoisoned(folio) && new_order;
>   	long new_nr_pages = 1 << new_order;
>   	long nr_pages = 1 << old_order;
>   	long i;
>   
> +	folio_clear_has_hwpoisoned(folio);
> +
> +	/* Check first new_nr_pages since the loop below skips them */
> +	if (handle_hwpoison &&
> +	    page_range_has_hwpoisoned(folio_page(folio, 0), new_nr_pages))
> +		folio_set_has_hwpoisoned(folio);

Not sure what am I missing, why are we setting hs_hwpoison to the
pre-split old folio here?  setting it in a new >0 order folio below
make sense, setting it back to the big old folio in case of a failed 
split make sense.

>   	/*
>   	 * Skip the first new_nr_pages, since the new folio from them have all
>   	 * the flags from the original folio.
>   	 */
>   	for (i = new_nr_pages; i < nr_pages; i += new_nr_pages) {
>   		struct page *new_head = &folio->page + i;
> -
>   		/*
>   		 * Careful: new_folio is not a "real" folio before we cleared PageTail.
>   		 * Don't pass it around before clear_compound_head().
> @@ -3322,6 +3337,10 @@ static void __split_folio_to_order(struc
>   				 (1L << PG_dirty) |
>   				 LRU_GEN_MASK | LRU_REFS_MASK));
>   
> +		if (handle_hwpoison &&
> +		    page_range_has_hwpoisoned(new_head, new_nr_pages))
> +			folio_set_has_hwpoisoned(new_folio);
> +
Looks good.

>   		new_folio->mapping = folio->mapping;
>   		new_folio->index = folio->index + i;
>   
> @@ -3422,8 +3441,6 @@ static int __split_unmapped_folio(struct
>   	if (folio_test_anon(folio))
>   		mod_mthp_stat(order, MTHP_STAT_NR_ANON, -1);
>   
> -	folio_clear_has_hwpoisoned(folio);
> -
>   	/*
>   	 * split to new_order one order at a time. For uniform split,
>   	 * folio is split to new_order directly.
> _
> 
> Patches currently in -mm which might be from ziy@nvidia.com are
> 
> mm-huge_memory-do-not-change-split_huge_page-target-order-silently.patch
> mm-huge_memory-preserve-pg_has_hwpoisoned-if-a-folio-is-split-to-0-order.patch
> 
thanks,-jane
