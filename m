Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1AF2A7DA8C
	for <mm-commits@vger.kernel.org>; Fri, 23 May 2025 08:21:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747988509; cv=fail; b=TPyk5fc/3cEY4MRKJkI6OCsuEbBeUPhIUq3oe/+Dm05rkZNK4nNXELWLgHRzpzn78yADQ0zH1OwiqE2OQetBsJHtgr5FpVVAPS6/mqkUzpn9CEkcibeIJBOayMP1zWE728/OpRMwduMjWNtJRB0gIgPa2Q1F7qCGtSS8yOSqFhQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747988509; c=relaxed/simple;
	bh=0LBIKFcMFfd6oDPRMk+iSTdgl3yfzmCHh5IsnNyRj5I=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=DZdgXJsn/UaN/8ViMty45MnbNHTH8LWULfkKxpWJoPg5YnkWf1i9fh+jj7SD1tN+o05V8hchhjlhIc83V9uL4NMoJBmgmV/lYSpoz+kN4bZhgge9XRpM1UMHQM7wL/8xP7SU/Gv0FeoFZsq1139u7146hWOrPlvty7G+4o5Nz3Y=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=Q1QrZ7of; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=LNNmBGBD; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Q1QrZ7of";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="LNNmBGBD"
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 54N7g4PM023669;
	Fri, 23 May 2025 08:21:26 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=jhOQGR+k9dN3a3WNvTGwRgwEoRd9rBJT3n7CFdeItOc=; b=
	Q1QrZ7ofDSAZK4YcAXH0sb7NPGZxXtBDlKGDqA9Xk9LFBLlDBkFwdWOrtvSDeJt7
	y2Fa78fl02RnqLqAfsZ9n3OR59ohGv+DsvoJvIeRg08tE5O2LqzPldTiJAl5j8cy
	QLNeThsJFSiVGokUVr7fDxFiQ3MsLTnS/5MC1sh6E4CtzQ3bzQ844hL83709baHX
	WrOyp2hmORJD35Qj+ovsXpinAzIwNyVYQWRNSlwBQ0U5w6oA8N4cKnCkWaALQ12q
	KLHW2Dr+kbdFiJChb0gJQgnwg5QIcq5CWYwpTlxs13JfX3/PVWGV6mF0RlBKfvdc
	7ty2nx3kzdwLLHUmznWggw==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 46tmt9g3aj-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 23 May 2025 08:21:25 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 54N7SOur020313;
	Fri, 23 May 2025 08:21:25 GMT
Received: from sa9pr02cu001.outbound.protection.outlook.com (mail-southcentralusazon11011065.outbound.protection.outlook.com [40.93.194.65])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 46rwew5tmn-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 23 May 2025 08:21:25 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=uKIWdaWJLDFrVuZpFOmZeV2caPRm7kjoIj9/9ebHO+gxFK9Roruk72qg640vpYRQ2K6k00k9pvUrVCDZElgDgbxqeVsYWu0BH5gmN6Yz5qn7eGfzTtUvHWaZEuejBBicYe6XuVfipToPQbuepEam79Ke7fInuSriCJBcCbH7RcG/OEdj72hkyCBOjv9Znj0MmKAmBvswjKRKUsd7QV34eDjWfup2mwhSc1X2R9mUwAS8mPdsMDgI94/ZyvcWjaUdrsNqoWk7/yuYXcjNsn0cdWR2cEMsRtVWlZm05ipfOyNVSMRM5gNUTQY+WYeDlc91PmLRMiQMsuQvYghULwR2jw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jhOQGR+k9dN3a3WNvTGwRgwEoRd9rBJT3n7CFdeItOc=;
 b=Vokpg2uvJb20mQNE3PE7412R1p3p4LZDwiljTngNDU8m/+pCexxcJwiL5xC7Y+3Gs4+oc/AJBk3+Ah3lkxFsWjWm8um6qYAmfs5W7OFHIMG3dMleN64t3oG6kVKpA7hEmurbR46ts5o7J5RWcyR8nrSLsu3+DGdr5VMhlgLh4SYKLMIexYylh0DYEfWv+HlhpveLHa6jApCN138eUHIXU92GHKK7FOgI9NSHqeGgBCAZ0ckG2fmbnWLtFcWi9S4hxyhJgrYNP4q4AfZJPuNknjeLpqqj0CmuSVejF0iKlJgBtrQUcADkcgdHtnnVfvuwntV6a6kdr+v+Gm11Ob3+vA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jhOQGR+k9dN3a3WNvTGwRgwEoRd9rBJT3n7CFdeItOc=;
 b=LNNmBGBDJ5IB4YAmIkNBdCbGA79jqr4hYf1d630St/NnJJ3YR4Tbc8uwZeI2jBHMKFeHMKZIShb/8NZgZPfW341ErrQ0YdkbQRC1Z3pxr1SUoxbWmrCdtFj2WKE4zUtJ2KduPoAOQPrSYeTFZys0EJm5jMjQ8Gm3tFJX6ma1fwc=
Received: from DS4PPF5ADB4ADFC.namprd10.prod.outlook.com
 (2603:10b6:f:fc00::d1f) by PH3PPF7FF16ABD6.namprd10.prod.outlook.com
 (2603:10b6:518:1::7b0) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8746.32; Fri, 23 May
 2025 08:21:22 +0000
Received: from DS4PPF5ADB4ADFC.namprd10.prod.outlook.com
 ([fe80::2072:7ae5:a89:c52a]) by DS4PPF5ADB4ADFC.namprd10.prod.outlook.com
 ([fe80::2072:7ae5:a89:c52a%6]) with mapi id 15.20.8746.030; Fri, 23 May 2025
 08:21:22 +0000
Message-ID: <c801dd3d-bd07-444a-9ff3-f4afa10d92cd@oracle.com>
Date: Fri, 23 May 2025 01:21:19 -0700
User-Agent: Betterbird (macOS/Intel)
Subject: Re: [merged mm-stable]
 sched-numa-fix-task-swap-by-skipping-kernel-threads.patch removed from -mm
 tree
To: "Chen, Yu C" <yu.c.chen@intel.com>, Peter Zijlstra
 <peterz@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>, mkoutny@suse.com
Cc: mm-commits@vger.kernel.org, vineethr@linux.ibm.com, venkat88@linux.ibm.com,
        tj@kernel.org, tim.c.chen@intel.com, shakeel.butt@linux.dev,
        roman.gushchin@linux.dev, muchun.song@linux.dev, mingo@redhat.com,
        mhocko@kernel.org, mgorman@suse.de, kprateek.nayak@amd.com,
        hannes@cmpxchg.org, corbet@lwn.net, Ayush.jain3@amd.com,
        aubrey.li@intel.com, Chen Yu <yu.chen.surf@foxmail.com>
References: <20250521165653.4CFACC4CEE4@smtp.kernel.org>
 <20250521191114.GE24938@noisy.programming.kicks-ass.net>
 <d413234d-47f6-49bb-9b99-5dd0da5d79b6@intel.com>
Content-Language: en-US
From: Libo Chen <libo.chen@oracle.com>
In-Reply-To: <d413234d-47f6-49bb-9b99-5dd0da5d79b6@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SJ0PR03CA0365.namprd03.prod.outlook.com
 (2603:10b6:a03:3a1::10) To DS4PPF5ADB4ADFC.namprd10.prod.outlook.com
 (2603:10b6:f:fc00::d1f)
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS4PPF5ADB4ADFC:EE_|PH3PPF7FF16ABD6:EE_
X-MS-Office365-Filtering-Correlation-Id: 1240903a-f751-4733-554d-08dd99d2cd2b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|7416014|376014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?UVhLWnJBeDJBWEUxdUIyWG1ZMXJqWUt1VVBVbUJLcUJYSFJJZFlSejVNa0ZH?=
 =?utf-8?B?UzRJYSs3SnhFbDJCRUJFbUJuN1J0am5aOXFvbHNwU2xzVFo2NkVsRFkwdnhp?=
 =?utf-8?B?SUtnbmduWE9VV01UMFRaYjFuZTZneXpjTzhPQ3oxZjlTcTVrZGhxM25jYzI4?=
 =?utf-8?B?dEdESDFhSGJYS1VaZWlWNElzamNPeDlrMmV5c3Q3QjlXdFI3enRHOHRtL2lt?=
 =?utf-8?B?QzNyeUN6dWxlbXJkY21qYjNQT2ROSTVXYmxWNHZ4dkxpbGN1TWhwdFlXWVcz?=
 =?utf-8?B?N3RWUU95L1J0SlVvVzhSTG0vb1MrcG9NUHRaYzlvVythMFdVU1U2ekVTK1Nl?=
 =?utf-8?B?enpERE9mb0FnOFROZXhCTUh0bGRlOVNKeTB2OFl5TXpvM016SFZ4bDZqTjVE?=
 =?utf-8?B?MzRMTUdXYVYwQUtrcmVxeGhmSnZ2aElieWE5VmdBSVZRUGJQL3hvMkFma3Vo?=
 =?utf-8?B?eWI2NE12dTVYL0NOMUJ0UXhTVE1nbUxVSjUwZUJERmJwZlNCaGFOSjE1Ymsx?=
 =?utf-8?B?eHNlU0UrY1hGVTFDNWNCS3pMTWRFWHhPNE1uVVM1MmxnZUpYK015Mmwxd05D?=
 =?utf-8?B?dWhqMnFlRy96MjNlOVFkLzMraU9uSkRUamJQWklndlhvZUdjdHFQWjZDUGRm?=
 =?utf-8?B?cGs3THpadUIycVJvNXZ5ZWdnUVVSd1U0SnhEMzJjTTBKOWFQOFk3NXZVRnVO?=
 =?utf-8?B?WEFYVVFKaXh4ZDNidzUwVTdlVFBLdFhxM0JRSFlNYTduc1F6azJXRm5VRElM?=
 =?utf-8?B?VE1saGpYTHRNb1RweG5qY2FvbHdsZ3JlQ05EVVFhSVVkNld3MVNKSEV1RlZz?=
 =?utf-8?B?RWlhM1Mxb2ZhWXZBdXpweTVPemNVdytOTHgxaGdvMGhXdElrYXlQay9vK1RV?=
 =?utf-8?B?bkJtblJSNFh0VWNvVXNzby9SQ21tcG1DRVlSMXZqaWFUalZ4UGZTN2hkbzVz?=
 =?utf-8?B?NHV4d1ZZUTRxYzhXZ3NWZ0EvdFk5cFM5ZFdaTDlFM3ZtR2lzUEVSUDVmbS9N?=
 =?utf-8?B?WWs2bHp1TnpOeXZ4bUVBWUM0RUhyc0Y5Q1NRZmVsZ1lxMkRjeVdidXJDanIw?=
 =?utf-8?B?Q08zNk9jTENYVzZ0cGJlR2ZYaHl2WXltenJVZXNtUDhhemdtbHA4OVBiTFdW?=
 =?utf-8?B?czhVRlFlbkk2NWhCRjg3TlUwZ0pOSmFMc25xWkk3U1hwekdwcWN2Vnk4VkNp?=
 =?utf-8?B?dXRweXY4VFV5bDg3Wm1GZzU4T0JUNUp0Q3ExeFZnczFZV0hoNVdQRktoajNJ?=
 =?utf-8?B?d01VTzVQRGllNW9xSHhISkhKSG90Z3ZqYkNGSkJDUCtCZWVUZjZLVWdueTFD?=
 =?utf-8?B?bWFEZkpOMzJqc0hvYnpvR2hKUGdKS3BvNFU1ZnVlbGRLLzk5VXlCYlFKNWtD?=
 =?utf-8?B?TkZ1M1k2ODc0bHoyREFyVWxoekVtRHlzWkJuVU53d3gwY1VQVzduMkRRdkk2?=
 =?utf-8?B?cHg2STRKUGc0cU1iVjV5WWZ0bU80dXlYaVFrdTd0YTgvYjB1QlZtV3UrNU1H?=
 =?utf-8?B?WTM5Zkg2akcwWXZxR1lpVEt2a3JNcGN5ZmNmK0F0WEVqQ3BjbGErN2FvN0pH?=
 =?utf-8?B?dmFvczhyci9sN0RYOEUyZ2w3UW5FaVpWQVlWVTF3TlYzZm1EQkswbDFDUzZy?=
 =?utf-8?B?MU5QRjk3alJKcGduRzNPQ0tlMitmOU4zZXZ5NHh6K1dBbUZtMTN3cUsxaVNw?=
 =?utf-8?B?djVSbkxBNFhtUFE3SG1taVBpZE1VMjRxNVZuVU01ZEFCRi96YUlwWWRTN04x?=
 =?utf-8?B?WlNIdkM5clltV3M5V25TZEppUnkvdlM5bE5ralhEbnNLNzFvVTdsRVZOdGYy?=
 =?utf-8?B?eVRoWlBOWHBXdC9WSG0wVUxqSGxrVzhlNmQwVWF5MzBkVnVHaTlEUnZjcldE?=
 =?utf-8?B?eG1zUmhnUU0wbnR6RXpGTkxxWjladlZhL1JHdmN3dURjUUE9PQ==?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS4PPF5ADB4ADFC.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?YWpqeWQ1ZGhsajJ6dzJqSVd6OEpGWFBVdUJtVVdUbTZja01QM29WRWxjS0xX?=
 =?utf-8?B?d2N4MlErSVRUVGJaNmpIMjN2WFBrVWFqUmxqTlNBU09uMVVIeVhZWFZzKytD?=
 =?utf-8?B?OVYvQUVnVjlKYVYvWDc4TUlNQXU0aktPbStKalE2bjFod2ZhTHQ0SkdlS2dP?=
 =?utf-8?B?bDRlbHE2K1dOWnN1VlJQS0xwa0Q1MCtyTlFsdEdLek4xTURlSUhZUzg3OENu?=
 =?utf-8?B?RmFvb1lLRXRETUVkaCtlWnZ1SEhJN2tKbmk3dDFPQ09CdzhHSlREZVQ3NWFS?=
 =?utf-8?B?RFo1VjNtM283QzJVVDNKOWFZZnJRa1JQSzRWTm05Y2ZLVVdBNHUybjdLWEwv?=
 =?utf-8?B?dCtDL2NOdVNrZVBiaXFQejlBWnNBSlVoNXJLalNpb2ROcmg1MFpnQUs1Mzds?=
 =?utf-8?B?QXZkUHNNamVnUnJtcG5JRmRTblIvWjhPOTN1RDhuSDFoY3FPYzRTVTEwTlll?=
 =?utf-8?B?L1dvcHM4Tko2NEFaY2huNWYrd3dQcldwdXd3cDYxa0dTb09vaXZwQXByd042?=
 =?utf-8?B?bFBwQWpDKzBFRmozY29hOWQ2SjloZ0llazk5cXVPWTRhMXVjYzU0ajJTSVkx?=
 =?utf-8?B?VzVKWTViR0FxQVFucWJ2VmhtTVc0SlVCVG04Wng0bm5yUGdsZnFHOWRzdkVy?=
 =?utf-8?B?V0FhVk9MbUIvLytudTRtMGdPemEvM01UQ0laR1FrdS95NkxqaEhYdU9yUkhv?=
 =?utf-8?B?WDRqd1REbjF0b0QxYzVJN2F0QkcxQ2pEcDJwWVNXUERTQ0luQzlWNnJ5Z3ZP?=
 =?utf-8?B?YWFnT1JFT2VJNk8xVHlMVUhWRTdmdHVjRWZZVTN4Wkt3SGErRmw1aittckdI?=
 =?utf-8?B?UlE4aWhDRkNoSzQwQnJXczF2OFM0VnN6R2JwZU9lUi9JNkZGbDRmQzcyQS9N?=
 =?utf-8?B?dDhPcEpoZDBRb3Y4MUhTWkExVXBmSmRyR3ZocVNiOXFUZ2thUzFjM2IvNGJq?=
 =?utf-8?B?WmtqNjE4cHNGMDdHZGNoNnJXTFhZZ1JsYjBXdzdmbVdML1NqaVdBL2Y0Qjlr?=
 =?utf-8?B?RjBvSmxjTVRlTlNCR1lvMC8zQ25rUHRWRUVZWVFvMkt0WWN1cDhlVjd1MWZx?=
 =?utf-8?B?S3FaSWFrT1FEeHJ4dVgzWHNIcldIK0RlMGU4eWRkRzFHZGlvc045RWZzWERp?=
 =?utf-8?B?b1c4dGg3Y0tTV3ZWYjJ4aXpCWitkckgzcDlOOUtFMU9UWDdRaVY4dEdNb2tR?=
 =?utf-8?B?MFRENDhSTzd6SEFhaDhuWFhBQ2NFNm5PbWhETGxMVTZJVS95QTdPSlZwQkJz?=
 =?utf-8?B?WWdVemx4dTVkYjhlMHJibDVobWdGUEdIc2R1K3RUeFJ0WGVTWFQ0NVVDUTJ5?=
 =?utf-8?B?Smw5TTF0d0xSdk91NVhCaDIzVlc1VHplODlXK0p5aHVjZXJER1FQOGpCa29i?=
 =?utf-8?B?Vy9mdUdocm5WUlRZU2c3RkpsRUR2NXBvMURidFppbEgrSFZTdzNMU2xZZlQx?=
 =?utf-8?B?bnVwaGlVMGlDUlM5ZGsrZU1oWkFycnl4Y0RwcUkwS0hBUnhydEsrZFdQdHFE?=
 =?utf-8?B?YWRHK2NnY0xXcitVekRBVTY0VXVLMG05Z0w1aHZ6Wkh6SXRRNitqN2tkay83?=
 =?utf-8?B?THhhTlNXTnJiWG5CcWdkd0IxdCs4aHllUXE0dFJ5Y0YvemJhUERLWVVsbGFy?=
 =?utf-8?B?ejNCMTRKV0RqTnNWazZITnFUWTNNL3BwTkJmZ2JCdFNPMDNGeEFQSHRyV1Iy?=
 =?utf-8?B?bDNTQ0dUcEpNK1V0a1laNnVZTUdxV1kwODNsbVY3dW9UczhJY21pT0xpNi9S?=
 =?utf-8?B?NlYxWHRFSUM5aS9Za1NkdmFoSjZSeEVYWWFwOTR1OTZKVUdkTzVaTUF3dFJV?=
 =?utf-8?B?QzlVSmpiLzE1eHkwa1Y0M1NWSzQyODN4Ym1Id0NCdWRhUTUzcmNIdDFYL0VS?=
 =?utf-8?B?eFJ1bFF5OHhNNk1QZUg2Y01hVjdSaUlCcng4Lzl2SEF1Z1pmclBLSkg2LzJV?=
 =?utf-8?B?Nlcvbk95eDB6eFB1RGIwUUJkRVEweWl4MVRBVWczT1RGZjg5QjgyRi9HQlFP?=
 =?utf-8?B?UVEzWmN3TFhDRmw1dVpRMmhsQVQxTXVTNmg0WjNsMURZM2twcEtHZGYzWm1p?=
 =?utf-8?B?S2hEVzJyOWlQVFUvcmpiZ2t0eUk1QnpJcFdkSWFEZ1B1MXpDODJ3bkNDNXd0?=
 =?utf-8?Q?z9p+KPFKZW9aPz3O4FhRB6/Q0?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	nQneAkStOhhaDRSKIjpgpTBQ/x21yeTEJ/+6ssSg34JUEUBwVW4prW111J/a+TxvyYNAp4B9Df4xjihG4x0aho943UDIjNQFnfq9mrDl60c7FYd8NZm3XtR5DS6MT792PVV+WQJBxn4mFUjHkljuhVZh9ZaplPTbGSuJGUXRGsVljjr3J70bSZKChIRGl5rUt6QAav6xrzg3vRGGtBpWAQwlfrka7eIMOA7nTsR4SYNAi/mwFx4vgCHV/9dSKACYEuIao9a6MPp2b1VZHD7r6c+/mkXsQD1yDGG3WO6H+r2ydHJBuBrI6nWzky02Y2caYfPTEP1nu8ahpTRupOvzyuit7cV7g2H3Q9BDRZY4Z9UoFgxL+vhAFTLISepxczrl21j1BGCq0Ahx1pIBzibSkihB4z7hnS4ATQUxNglVfMUBlRiaXfXsKVKoYUe/3M/FuYZOgAQDNDSwkI/gXIAU3dzieuchMcUDM8Oq59TlT3Khp3mWN9Bsup39vU8QYbK25RReTVqC3e9I/PFd8eBt98yVyHVXvonhWWL4y+sWHkA6Mdy25aXtw4xWoIdsVkizSIPRPCfHJSKOzQRP73y4VkxHyRLje/JtrJga3XJseBo=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1240903a-f751-4733-554d-08dd99d2cd2b
X-MS-Exchange-CrossTenant-AuthSource: DS4PPF5ADB4ADFC.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 May 2025 08:21:22.2729
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9Gkp30vbTDl7u480/Y96D95mCAR7yAeeISZ1VSCCmsLHqZ2hLrLbEE8At7k+5Ex5O9yNjg3l3iSEGalvNwkFhg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH3PPF7FF16ABD6
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.0.736,FMLib:17.12.80.40
 definitions=2025-05-23_02,2025-05-22_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 adultscore=0
 phishscore=0 spamscore=0 bulkscore=0 suspectscore=0 mlxscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2505160000 definitions=main-2505230076
X-Authority-Analysis: v=2.4 cv=XMUwSRhE c=1 sm=1 tr=0 ts=68303005 b=1 cx=c_pps a=qoll8+KPOyaMroiJ2sR5sw==:117 a=qoll8+KPOyaMroiJ2sR5sw==:17 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19
 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10 a=dt9VzEwgFbYA:10 a=GoEa3M9JfhUA:10 a=iR4E9_NGay1U2jznpMUA:9 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10 cc=ntf awl=host:13207
X-Proofpoint-ORIG-GUID: hUNBJV1Pt8LwB99PtfVRw-rkOs1BPnzk
X-Proofpoint-GUID: hUNBJV1Pt8LwB99PtfVRw-rkOs1BPnzk
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNTIzMDA3NSBTYWx0ZWRfX433NJHNqzOnm nsFVMynX1roXX5Ntrj8C2Fmy5CbMD7Ro4SFUSE+YaQ3IcnOWruLMXJmn1+Wfcaedw0u+qmdLdF0 gCmK/PgQecYZfB0J1zywuznwQ1R2bm9wOFfoEi2ZG1QnddHpL9UOV0yJRmyVinflbnzEdWw08Z1
 W1zGxUYVBxTayayNUe7Dr1PjlVQ7iMRoWmuT92mHcTzxxo1xj0NXPfa2/ZFBpBTDWHm71KmbXUZ y47WON2DBxGVDh/8b+2CFdBLKnkT43gDoCd2dpAb5uMY3n9rbKLCE/Alr990SxONNWmcdwKAKoF wOGYNslDJllMv5ux0k4Y6R0C0cSIYVh3+TlEXhT65pPa17klUYVif99B/duAVtTwdCgnbw2iNbQ
 1KFxECFGvXMhcu/pcL60Pfgu8FXZhqtuAD3KR7PgwlZHnarD3KiIT6srDWp1ueFGiMjgcUy7



On 5/22/25 22:09, Chen, Yu C wrote:
> On 5/22/2025 3:11 AM, Peter Zijlstra wrote:
>> On Wed, May 21, 2025 at 09:56:52AM -0700, Andrew Morton wrote:
>>
>>> Fix this by not considering kernel threads as swap targets in
>>> task_numa_compare().  This can be extended beyond kernel threads in the
>>> future by checking if a swap candidate has a valid NUMA preference through
>>> checking the candidate's numa_preferred_nid and numa_faults.  For now,
>>> keep the code simple.
>>
>>> --- a/kernel/sched/fair.c~sched-numa-fix-task-swap-by-skipping-kernel-threads
>>> +++ a/kernel/sched/fair.c
>>> @@ -2273,7 +2273,8 @@ static bool task_numa_compare(struct tas
>>>         rcu_read_lock();
>>>       cur = rcu_dereference(dst_rq->curr);
>>> -    if (cur && ((cur->flags & PF_EXITING) || is_idle_task(cur)))
>>> +    if (cur && ((cur->flags & PF_EXITING) || is_idle_task(cur) ||
>>> +            !cur->mm))
>>
>> !->mm is not the right way to determine a kernel thread, PF_KTHREAD is.
>> Notably, there are kernel threads that have ->mm.
> 
> One question, would removing !->mm be enough here? In the current Numa

Was wondering the same, but I thought it's not possible to create an user
thread without mm_struct...

> balance implementation, neither kernel thread nor user space thread that
> does not have mm will be skipped IIUC. As Libo pointed it out in task_tick_numa():
> if (!curr->mm || (curr->flags & (PF_EXITING | PF_KTHREAD)) || work->next != work)
>     return;
> 
> If someone uses user_mode_thread()( umh) to create a thread, this

ahhh, didn't know such internal caller exists...

> thread does not have PF_KTHREAD set, nor it has a mm_struct. We
> don't want to do numa balance for this thread I suppose.
> The commit b3f9916d81e8 ("sched: Update task_tick_numa to ignore tasks
> without an mm") add this !curr->mm check, and we might also want to
> preserve the mm check + PF_KTHREAD check in task_numa_compare()? Do I
> miss something?

Yeah, that makes sense to me and perfectly aligns with the condition
that allows tasks to be scanned for hint page faults

Libo
> 
> thanks,
> Chenyu
> 
> 
> 

