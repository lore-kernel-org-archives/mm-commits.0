Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5260B2D47F4
	for <mm-commits@vger.kernel.org>; Thu,  5 Feb 2026 16:43:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770309803; cv=fail; b=TJHGbBY69ZZjEO60Z0rvEBa7fcJBlcp9K8LSyYXq1bm7QC7yHHhrzzLQ7+aMyGCADIhQo7qLOqAyMmiG1GfK+SHhpGFqSB1BR4tVbWY+IJoAsUqKtVqbQbsFruP3xzcPon6UUdYzLkNOlBTRNy3/MvjHYxfv05XZPSsaj3pLZLQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770309803; c=relaxed/simple;
	bh=xUQ7B7qKDutcHKLPyl0AIrpJYs9GXp93ZR5RoWgzVOs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=M1scy2inqhmG7zFwpUOEiplWdIrs9kaPIebe2fzJo08RJMmiLorb8F+yBm0htxzlVf4YcYvYfImvunioRDr3O//b2mk+0Zwz8dWQpMQN01ZLj2s5RyhCJU/AlskkmWrNub/jNymmhCywuImSReY43/QUrV3vo2YFka+2RvvrlSk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=sOWw4arc; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=My8kiOwJ; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="sOWw4arc";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="My8kiOwJ"
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 615FuIj6892794;
	Thu, 5 Feb 2026 16:43:19 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=8jjidrVeHCKBfhKKOK
	ZWWzXkcGDE4N7sdj0ef4f0PC0=; b=sOWw4arcitTWUqSx7PXlz1ovKOd4NTNbe6
	Rfb01v16GGHgzXxJHPpQgRg9+o4EMAHw/7BvexqC7KARq2UjQ33246mbDudpQXxp
	Ti/+jz5KBJXxyUxtj3nLICPkFLHLK4BsUaqD15y7taOSsl7FKvukm5fUjG+G9p7k
	vEkv0WoqN2dQoC/N17Ys7VvLGUHrp8kVjy+orOiLARXQuglzI+ZCx5DMnwbyWYcX
	4opneuyYitTwLkbAbWGU/YsGGuDlPklqFadH1CF4z5OHUQZ2e0HLtHgdjtoX3DdU
	7gdmYiPCOJm/Vchd8xTVwM/OSUqu9NX3GqwX3tfBPI/rbMp+RNNw==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4c1au683wu-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 05 Feb 2026 16:43:19 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 615FUkQ8018819;
	Thu, 5 Feb 2026 16:43:19 GMT
Received: from ph7pr06cu001.outbound.protection.outlook.com (mail-westus3azon11010003.outbound.protection.outlook.com [52.101.201.3])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4c186qy44p-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 05 Feb 2026 16:43:18 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=IygekpIMo+PZv1yrTZSc3YY7AxytkTvhr/zpkvSN66PjNpdmskfBhOCXXeAwk1Ciq5Qizqv3wE8VGwF8fK9Hf7ntmMhsZw7bzN2uxYKZ9pkbXmrcwtoiUiuDOq/+Dt1wrJzd1zXsyKciI1T76cnXC8ncGXkn/GSA8yDT37WxXB3Msfl/J6YgpkIPc5/cn2fFuWzMMvRg05zWOqeCXmEAQQvaws0SZwnbviH1br/lvM6wYL5LJeZE0JPklDhe71T39/CNMk0MZyrdgYogvSoU8Cy2hxIXQholxet+uTAQGS24f10ArQbc5FpbePWYxzw/h+KKSnOZT2IQMJJ76JztVA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8jjidrVeHCKBfhKKOKZWWzXkcGDE4N7sdj0ef4f0PC0=;
 b=D/OMw62V4O7f6It5YKHlzS82RPaPHcjtOZS2VuGGKzVkiUs6cQIJ5drwgLTDrNuDwv2dqem6Bg23II77wT+/XJiIo90BmFUoqQsDb//G7wmngwPaxfoZrISws1V2VHLULVpV4i6JOm+k0UX9UY8ZKv9miqhtIwmr2WA785T/Ewut8zo0XhoLuv8s+Pdtp+lo/0mkMTVtjedRaTJB3k8UqH9ccc32Oe/0UtmLlnGqLYCP7TyvD3MR8TfVYzGOSx3wI+zJpX5keXyrKZUZ9OIU93b9RA/XTvkQC5PsPBwIlOh3WmkExqUNbjDcE923dYhP7mm+NT3Yw0m0M1ZFLR8Nxg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8jjidrVeHCKBfhKKOKZWWzXkcGDE4N7sdj0ef4f0PC0=;
 b=My8kiOwJJes/jBX62mvIKcL8JrbTdQ1B6RAkG0gltCnJ9khW5nxX1X0UBQUoBYulhglRz/PILHFNBVrMemBJ1rgvtFHIC5TirBCIx0Madby5Km5nfpJpiBvIbRUvsNZ9/8YSVahzGYg9c88tlhZqeX8TC021OGpL4pRmj7AgIYA=
Received: from PH0PR10MB5777.namprd10.prod.outlook.com (2603:10b6:510:128::16)
 by SJ1PR10MB5929.namprd10.prod.outlook.com (2603:10b6:a03:48c::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9587.13; Thu, 5 Feb
 2026 16:43:12 +0000
Received: from PH0PR10MB5777.namprd10.prod.outlook.com
 ([fe80::4b84:e58d:c708:c8ce]) by PH0PR10MB5777.namprd10.prod.outlook.com
 ([fe80::4b84:e58d:c708:c8ce%4]) with mapi id 15.20.9587.013; Thu, 5 Feb 2026
 16:43:12 +0000
Date: Thu, 5 Feb 2026 16:43:09 +0000
From: "Liam R. Howlett" <Liam.Howlett@oracle.com>
To: SeongJae Park <sj@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, mm-commits@vger.kernel.org,
        david@kernel.org
Subject: Re: + maple_tree-add-cp_is_new_root-helper-fix-fix.patch added to
 mm-new branch
Message-ID: <wkp2cj7ysb3at2iu6d72zgcx4ejta7ehtq2hx74kmfwktyz72s@ul6gcnwhfrj5>
References: <20260204195637.F2B13C4CEF7@smtp.kernel.org>
 <20260205015036.68763-1-sj@kernel.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260205015036.68763-1-sj@kernel.org>
User-Agent: NeoMutt/20250510
X-ClientProxiedBy: YT4P288CA0006.CANP288.PROD.OUTLOOK.COM
 (2603:10b6:b01:d4::12) To PH0PR10MB5777.namprd10.prod.outlook.com
 (2603:10b6:510:128::16)
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB5777:EE_|SJ1PR10MB5929:EE_
X-MS-Office365-Filtering-Correlation-Id: 584c4131-d715-4435-c52c-08de64d5a6ca
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?GVQQOgP2ev8yMw0w4JlOvie47W+RpIvQM/v5IjC3kv/3z+3hUrwnwFSiqp7c?=
 =?us-ascii?Q?xRo4kbZFUpI6hblhgT66GE2KWpoUM1z19Nwe6d61ifCZb2C1uzs+G4Hq4IMA?=
 =?us-ascii?Q?ESBufDm/hAQw9vvUdWgzj2j145XmlY3NgVBrFeFwXbGx31R3lhZgkumywpzB?=
 =?us-ascii?Q?Ckc3yr9kngefrIpPG2q3dsIT0nKAr846x7aF4QqAhmlSR49YgIEohF1yyICG?=
 =?us-ascii?Q?gYvg3SVK1vinbfZvBrhV28S6HobtYzZfnigaY0Ks5BMzLvSn5DM2jMTOkdMd?=
 =?us-ascii?Q?uU5Pw+05yG4stUdcqITVzVSacJHi7lEvUWE9KVmwFu2mzYMdbwqrKwvzf+Cg?=
 =?us-ascii?Q?IWcLdFh8XBsZUx55DOIFRpi3v6c85AIiAwU80uEZLhgRbTQwyFX2D/vxTBq+?=
 =?us-ascii?Q?/aO+fdlybVQKA4/7csHn+xrnuXLW9MXwsxXy521VAnnsRyYHFzF1HXOQg9s1?=
 =?us-ascii?Q?j75B8L76lMdbBwDjTEQdPUSA+HylN+GnNyhGiZlHo6+uWn1o89mq2tKElHpv?=
 =?us-ascii?Q?AWvtLDuqmVHKVqZ1nWXo86wF2/Zc+U/G6T0zkfVnyXzgq3vitcsGAKc4kyG+?=
 =?us-ascii?Q?1+5494UYEdWxDEgXSIHy2DOcyxN8iE2yPxhugkNN+v2bomV2F2M+cnm/aXmt?=
 =?us-ascii?Q?5Pm8ItauEnY7qhpqr8RMBpzpEqFFqBdt2RjAnQsj21gmvbZXdx6Xu/unG/al?=
 =?us-ascii?Q?a1F3qnyuHNnA+PWTqbCvKLigrgW62cAx39uI7RUi87msBHdCy6TQ/lGfgPZP?=
 =?us-ascii?Q?RCZMzAAaTE4rP8U5/Isl+cifC9xZ3+T1i0IGip7jNwLRiK2QHP7T+qqEY2Hq?=
 =?us-ascii?Q?KkfJQrZmSKw41bn/13KFU4B5XPahGFwXEBvzKNoMWPsyD7FdAp8iEn15O0aD?=
 =?us-ascii?Q?QiOcdzLHAesHDSr/QbtA84b8z/hPANDqJnyTsbjdZcCisGVcq9QC7qf1IrqG?=
 =?us-ascii?Q?1vfRatw7cUn/go1r0vPxCwSZYO4i5lvjG5M8OBrGOb2LWbEMpezH5N3Kvf6Q?=
 =?us-ascii?Q?QVLBVyvd9SMRkfMBcDDU6FoBiWg6H28s2lZilyFYQG3vATqyYplRDEpIYKQn?=
 =?us-ascii?Q?Dyikirptt6h109u89QmK4bQv/LqYQ7M669jduyKEyY0p8E0T2Mf6HwSW4f48?=
 =?us-ascii?Q?bfAWva3JuqWmyLxWknOfhjEEVhYJbt8tyWwdEZ8+3FXxNOzUXgHTz+uk20Kq?=
 =?us-ascii?Q?0Cd3dbOEkBNgD2FFngMsdLrzXwyZDrmj5W8+i1XZUPEY1TRAgHIKGqt7OiqG?=
 =?us-ascii?Q?r05lGlm2fyZ0ybjQb4G0KefZnNBdVdmQyGvWqq9XjTEyQVLy0xO7+j4rG9q3?=
 =?us-ascii?Q?g7Q4SBNP4kn1Gvn9npJX5GUypkLH1f7WADzrF6D8+Qd/0bE7AHRrkaWhmD/O?=
 =?us-ascii?Q?GmRjmIQpdJ9U2IlZdt8YBws8CxWUPQoIi4wtjgpttTk9ECtAEkCdeIlEcjnZ?=
 =?us-ascii?Q?l+JAY0DYV6Xr0m9kTexPy1DIYN1oN4sKEIItQCGrgttAYtlD4Qn/YKU98Sx+?=
 =?us-ascii?Q?Hr1bZ18JFaOrJgab3z7CjqeppdJ5vSzF8OqHqp9kJ6R88bbqMPZp8agvNxZ1?=
 =?us-ascii?Q?SOpC42UUbn7NGo6t/dgk6jtHe84ckOFGNGIBFigF?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB5777.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?u8TTfanWhixuWwsymUJv9VQTlIX16Ww+iXzx7vkIGDRZxLKTHBdjzyGIbK1V?=
 =?us-ascii?Q?C5hYR3kW2GL3SS3Ga+FVeO6dUTA89XHReW62lNhz7qKztK8MbXrw0w1uSSmv?=
 =?us-ascii?Q?vov06H5gkLxpYAofrAYvrAAP4sTxmD8mwWrFmnjVtLbWdBoj9JFAxLZTWvkr?=
 =?us-ascii?Q?3yDHQEiCrBBNY8jFHZ/xBzq/Qx/pcfbejaC+KrBtsYumSZOW/b/CHM56GUVf?=
 =?us-ascii?Q?HrUYjGQ/OPSCfjEp6MyIT5/zt3TRLPewPjscM1pHpXYuR0TUUbIHbnJnkJjE?=
 =?us-ascii?Q?P9Wg5AuhKWtsVVeHK5VTtlTzekrQV4jcYx5UC76JJb2bR2py8gSapiqUMnjK?=
 =?us-ascii?Q?h4WFHY1k8jfrZnF9J7Sg3aorBwfxyAnD5+MHJFCzcC+UKKLlNISiCseYYvkQ?=
 =?us-ascii?Q?Rkc0rUqoudD8HUx6fiATohoat749FPNGBLYfSDRKvnxjsrF+9k23lWoBnNQQ?=
 =?us-ascii?Q?Q7/Zbd8pTIjwJivGN4GyUWvUsOjQnQXEIjFuLxnKRojILVIAPot4jI7BCOb/?=
 =?us-ascii?Q?k/E4SgRn9sr1vdUxqZNQ4Hl7GCgP0LfCOdqrfbL7Pis93g0wWOwZZ5YwvTnQ?=
 =?us-ascii?Q?7i7F3/CsxqHEUuKLBN5wyDQkwSsVGdgsKilGANDix1Np9fXymdVgvWfPGVfM?=
 =?us-ascii?Q?7Bk1NDbHVBXCqeNL6v30cZpirV++I3IS2lgZXaqTN+OmROIwoV8B/D0ObaVQ?=
 =?us-ascii?Q?PObQv5ydEADwKJmogdzR3M2i9d1iwKxVJs/vS9VRZQzPblTRGT2HrL4WkpjP?=
 =?us-ascii?Q?tyO1Oe3EGEszSzE9NG/etDrJ9QwbK7VzC5ZnH8wjsteaXrmmhN8RNwtzDKzk?=
 =?us-ascii?Q?/fTOFMhrufLTNDHHBt+6bnNi4dXHc/ollnGOk6dCTGbcWaLDux/SH6o/+Am8?=
 =?us-ascii?Q?z/0/8HF9X5mV5R45IjE+obdmzboypDVai3o2ZteQzCjOTUBhAwr6bGQIu9pX?=
 =?us-ascii?Q?qwythMIYiYVAA6VkOw/KbV+cXb51VBap4LAWPqmv3PuPBBaOYaSEVe1h1tRF?=
 =?us-ascii?Q?hfhBzsJRw2SzljxbApi0zUQ5jjJe+a9GtzVKU9/A6NXSs8QR75vr3hN9NdpD?=
 =?us-ascii?Q?+2ds54PFM7RdSO5y9vrPq4+iRiE7UNqTtQo8jzNIBtRQHFXQz6Xc4RKCbuO0?=
 =?us-ascii?Q?oTm6U+34hxCsZVF087nfuNopqYjeaerfS0JIPIMhLgMgC6YeOrXVAiPFUPcl?=
 =?us-ascii?Q?YrQjCkWiUiTtQgTLwQ2eegMMkpOj0ZJhjJp9PuwrxmiNmqpVgY6TDnSBvuVG?=
 =?us-ascii?Q?gbWkG9w7Yxvk8DKma/O54y5fRkP5b4nvuoz0/KUMDyitQI9ldrrmqBrHBKS8?=
 =?us-ascii?Q?P4gmeWVE9GoZBZHXWiIY+qiYVkt4vjtniEuG955HWeqMcZqqXKOf/DBiH4Z7?=
 =?us-ascii?Q?hauh3MoQJFrowWUjR6FZRf6Ca3qEVg/me2yhnIDJcmu7+E4iTUJxEzbHoCQx?=
 =?us-ascii?Q?1efbhUMj00vdNqfN+ImuHccdg/pr162KcmsJeHTNqnijJ9Yr7c0ZLD4qM05d?=
 =?us-ascii?Q?BDS/abqV+a2cyWJWbDQu4LF+dkTiXb4MFl/EmjwIzUuRQ5cpeIbO3I8UTi50?=
 =?us-ascii?Q?MSA4DZ5tehXyI3E0jUQ8cDC1sB06kSolp7S/8wkSXfIvd/xhRncor4ccMvV2?=
 =?us-ascii?Q?0QaggV8NVA2e6+AbGCzZfttetiXUDWjSzHjyFhmIcppI8PrIbP/BAlkLjGw+?=
 =?us-ascii?Q?H6afGTR0YdHwK1Ucr6xQP9b78E/d0e8auSmF3txftgnHPeHXZv56radjxaYO?=
 =?us-ascii?Q?L9SpLtme3g=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	Q80UfZPL7LqmAVzYo4S11sOTTGCDOTTxOMxmhKRqEZ+v0XaU48INLBwmi+hc1xksOb9kH6kV0Oj5SPuqaSKuSwTHanucsxZvMkFjK1JFdCpptw20REK6Cxuzmw+qDbAueGB9TgmRLhVCSXxAJ7LzhbQvdZuWLiY5RICx4bxk+9mjNtV1VNxHol1jqX0aitWA0VAbc/PonZjNGg0FSLLhxJxXSzkmckQ5SotLsNvJgnbpkEpTIAFyX1RB2Yx1ILfMCHPdJo0DYazTy8ViHTuf/wIhvTw7MlHE9CBVWBSP/6FGpj77B42+sK/M8HGqRcWRKiEySVQzw8zDF/HDfXTIfsJcn5aUL3J7ycZUZn5Q+yTyEtG+GWr0YZyl8M8BbJxuwpFwt1bQDvh4FY0ylka/UKHZ4n9m8Uwu1A32Vt5wlsVUAwI6oOS3s3UpfJgo2++Fw5duXhbbUC8FqyeMv0vf8JvH+flf7a1tPDnCvwpD1OC8jkhBrr4tMW65OOpHHo+m8K0ujFFfURat5GTOtJFWJUhZkcGDaEjF/5+c1UXjf54EN120oUSxKrOAEIR1jONoJtoaeJqYyG3cspFSn+raTCJ0B0FWHGhWTzTxwHBqOQc=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 584c4131-d715-4435-c52c-08de64d5a6ca
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB5777.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Feb 2026 16:43:12.3986
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: sSShltj4GN+9vzWhxHgQgi90RjIzbR4LQPSrr1zdw/WNjFPFmBbLBT/t/VFXN2kevYTcrnFi6xwt8POCbBPvAA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ1PR10MB5929
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-02-05_04,2026-02-05_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 malwarescore=0 phishscore=0
 suspectscore=0 mlxlogscore=999 adultscore=0 spamscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2601150000
 definitions=main-2602050126
X-Proofpoint-GUID: n7rR2o0fqKiGx8iW-QYvlBiskfKcfNn7
X-Proofpoint-ORIG-GUID: n7rR2o0fqKiGx8iW-QYvlBiskfKcfNn7
X-Authority-Analysis: v=2.4 cv=Nf7rFmD4 c=1 sm=1 tr=0 ts=6984c8a7 b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=HzLeVaNsDn8A:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=VwQbUJbxAAAA:8 a=Z4Rwk6OoAAAA:8 a=yPCof4ZbAAAA:8 a=c1sw1RcRzdhlqMFKZGgA:9
 a=CjuIK1q_8ugA:10 a=HkZW87K1Qel5hWWM3VKY:22 cc=ntf awl=host:12103
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMjA1MDEyNiBTYWx0ZWRfX/qD6lIVojKzO
 w1Nkma3Wrxg0bnRmBo9S/z7SsO6laML7IoUT5QiFsE4wwc3wIq8etHbGrsGzHAxjMVJkVimpcPI
 piGzZhQIyx+EUZOzSH8lHhPVmvYENu3CK01+6b1f7J8DYBMrtlygTFAWCOAT7v3YY+4a+/xsnIm
 luuqtEaS0Bzgg/AHG+Z1v5aahGNf8FrH+QNTO1i5kfsGUlqor7TbaMxUqdiA6/Mt27vWynHOpGt
 549M1g+GuapsdA6T1Xm0ctkscEVxQCCWCjvzLs/fretd+GiUPVqRnSMIo9QUgWi62zHVpVgnpG8
 KvGucsEL1Or3idCfTVNN/FjqaKURiKILB6NZR2+T4sowFI3KRGzUHtpBrAVFDoYkr0jqfPT1dx4
 NAYxloapF8IeW+u3pDt5Of3vVgSlRyLlV4VkWcCYTasKeWp9Y8C97Ude2lq2ckx9YvPG9Bj36r6
 eMGkNKgwYBJ5xy+yjebxzfZ7xDjz5+0MREYHWclA=

* SeongJae Park <sj@kernel.org> [260205 01:50]:
> On Wed, 04 Feb 2026 11:56:37 -0800 Andrew Morton <akpm@linux-foundation.org> wrote:
> 
> > 
> > The patch titled
> >      Subject: maple_tree-add-cp_is_new_root-helper-fix-fix
> > has been added to the -mm mm-new branch.  Its filename is
> >      maple_tree-add-cp_is_new_root-helper-fix-fix.patch
> > 
> > This patch will shortly appear at
> >      https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/maple_tree-add-cp_is_new_root-helper-fix-fix.patch
> > 
> > This patch will later appear in the mm-new branch at
> >     git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
> > 
> > Note, mm-new is a provisional staging ground for work-in-progress
> > patches, and acceptance into mm-new is a notification for others take
> > notice and to finish up reviews.  Please do not hesitate to respond to
> > review feedback and post updated versions to replace or incrementally
> > fixup patches in mm-new.
> > 
> > The mm-new branch of mm.git is not included in linux-next
> > 
> > Before you just go and hit "reply", please:
> >    a) Consider who else should be cc'ed
> >    b) Prefer to cc a suitable mailing list as well
> >    c) Ideally: find the original patch on the mailing list and do a
> >       reply-to-all to that, adding suitable additional cc's
> > 
> > *** Remember to use Documentation/process/submit-checklist.rst when testing your code ***
> > 
> > The -mm tree is included into linux-next via various
> > branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
> > and is updated there most days
> > 
> > ------------------------------------------------------
> > From: Andrew Morton <akpm@linux-foundation.org>
> > Subject: maple_tree-add-cp_is_new_root-helper-fix-fix
> > Date: Wed Feb  4 11:54:03 AM PST 2026
> > 
> > s/cp->slot[0]/&cp->slot[0]/, per Liam
> > 
> > Cc: "Liam R. Howlett" <Liam.Howlett@oracle.com>
> > Cc: SeongJae Park <sj@kernel.org>
> > Cc: David Hildenbrand <david@kernel.org>
> > Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> 
> Assuming this is a fix for https://lore.kernel.org/20260204063620.15857-1-sj@kernel.org
> 
> Tested-by: SeongJae Park <sj@kernel.org>

Yes, thanks.  And thanks for the report!

David found it with sparse and I was able to fix it.

I appreciate your help on this issue, I did end up reproducing the build
warnings with CROSS_COMPILE= and the compilers from
https://cdn.kernel.org/pub/tools/crosstool/files/bin/x86_64/

C=1 or C=2 may have caught them, so I'm going to add both C= and
CROSS_COMPILE= to my testing.

Regards,
Liam
