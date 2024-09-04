Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42AF81EBFEC
	for <mm-commits@vger.kernel.org>; Wed,  4 Sep 2024 20:33:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725482040; cv=fail; b=sUCZ7VebEtcdN//+9T3lD93umH7evkRz+UdMGnxguWln7c2+m6whGy3VbPOPAR4+EIIsHzxajVyw723Krr5LZ0nJGf4NVPgIxVR99Nx4mVkeo2CuvbL/bDHoaWAcPCG/ezZb+cT9sIM59y21zWbmjWKTxJ6x3R+4PpxEyzCXTbk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725482040; c=relaxed/simple;
	bh=5Qz1OwsIg3WZHaMVjSDQdT7pVyAEvTqJ6EjFuCJwP1Q=;
	h=Message-ID:Date:Subject:To:References:Cc:From:In-Reply-To:
	 Content-Type:MIME-Version; b=kHHC2axWFN/rDp/JglEZuijQRWVO2LgO3KsOg+HfSZpIP+OlKseBv+NrvrUJyL6DWNjm1KZey7KOrswV8nBzXtp4fbiNi+t3JysWoxfYc4/zaadVRVObT/43Df+GqW39+RY2maPCUiYSH1dM2lXM1/LfzBGCvHOTzVpHRCXxNLY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=feNAxudd; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=unwQT51S; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="feNAxudd";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="unwQT51S"
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 484I0ZCo028415;
	Wed, 4 Sep 2024 20:33:47 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=
	message-id:date:subject:to:references:cc:from:in-reply-to
	:content-type:content-transfer-encoding:mime-version; s=
	corp-2023-11-20; bh=Nbkl4IQ4cYdELqpfFeCJvIgBz01AKcUDoMw+dbaxhO8=; b=
	feNAxuddwVYTXpAwa+ZB3EEGEEitCC/L7a8jnTjsdtoihXHu7bOxx2bK8l9BG5w9
	+Bew2m7cz7srVS49XDben5X/ebGJ/DPnpC7d7wqZ6IeT8/0u2j1Z3aKa4VPeVpoi
	uH1HRQpu0SNGggMNuiFUl6mBY1cT+k+EJa41mnq0e9g1Yqhj6TL7HaTpuKBYjwEG
	efOG5e924AgxWk/8hnuJ7JQ9GY/KMHMYnSNmuaHy8xdgVYEcl+PAtlhFK6UNVagl
	w47+3ROIZOekFtwPIPTyv2TSboD1IjxHbTjgKURl/Q4vD26ri3bb8UOREH1uJOx9
	tfSahqMkB1MQEHkdKm6FSQ==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 41dr0jvv1h-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 04 Sep 2024 20:33:47 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 484KLmkK039552;
	Wed, 4 Sep 2024 20:33:46 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2175.outbound.protection.outlook.com [104.47.57.175])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 41bsmamtb2-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 04 Sep 2024 20:33:45 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=kV1reK6nKwKIoINOn6bykvXMGkcslE3ID3BAn4hm0zlQCSGeiOC/WH6POJIyHOIJIHVBmMlYduvxr1esUzIBi+jpn29HpKxlI1pKLL6B7OjPfrwTNqrg+rji8a2yt44eWHz7Cz/6dHTwNiTsgxohftP87H8hTt8IMmRnqBfkypzkK2hoWVrR1yIr4JiHxj1515Swhfey3+wjwz0bSSWaCsEq9TbZCq70iYouDpvSA71JbIbxxST9mgA/w3KqwIOHRGBIWO38HUNMNVmKvdOrbXjBxgOyMjeNeYtdEKeeIYqGwUgUha0o3Nlw3/nMdFVRCyqYSIw9gDNaX0R7Anhxlg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Nbkl4IQ4cYdELqpfFeCJvIgBz01AKcUDoMw+dbaxhO8=;
 b=gGs1xq+eUYTyr8MD87c2qHOQYAEwicLW8Fvx3ZPy3uOnMRqjuhNTIOqaRkO92aNnk4xtjliCSAQc+b+motmDRsn8ccBLHippfNmrOmOcO3N5QtamjBJ5yYksvS8xGGZKpDagKWcsXpBk6YOZbYKzNJJOUiqkxQDISBv3k5x7n2aBkiB2re74RANUxJMhlmbURMZJRXZbbANkuTKPKMW/XkvbN8BbNoRcl2O9sO7r4STrNa+6KJo93+HVVsE/Ugp7TooETnPlDHvGiu/P6mCRCV9I5plUC1fEagLnOeHOG50oq6Xs/6AkAdP1neGTDOSeGsGNbX0fyKNfEzsCuXK9LA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Nbkl4IQ4cYdELqpfFeCJvIgBz01AKcUDoMw+dbaxhO8=;
 b=unwQT51S3aX/kChfoDW5tU6mj+TPJdf3E0Q1dGDftqYJvHGZaliwPI4PxpSOEEnuF6m4G/O/nOJKh8+0fekDatQXLFApuxGSdFXEnpz0j6k7XtOI+Ec3mnNf9WmGaMsIMPITu2vy8UHgjHDx2Z3vvHQ8OZvt7Z7Foea3Sa8DZ3U=
Received: from IA1PR10MB7447.namprd10.prod.outlook.com (2603:10b6:208:44c::10)
 by SA2PR10MB4667.namprd10.prod.outlook.com (2603:10b6:806:111::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7939.14; Wed, 4 Sep
 2024 20:33:43 +0000
Received: from IA1PR10MB7447.namprd10.prod.outlook.com
 ([fe80::f2fe:d6c6:70c4:4572]) by IA1PR10MB7447.namprd10.prod.outlook.com
 ([fe80::f2fe:d6c6:70c4:4572%7]) with mapi id 15.20.7939.010; Wed, 4 Sep 2024
 20:33:43 +0000
Message-ID: <8592e3b2-de60-4890-b6e5-e0a62128f447@oracle.com>
Date: Wed, 4 Sep 2024 16:33:38 -0400
User-Agent: Mozilla Thunderbird
Subject: Re: + mm-hugetlb-simplify-refs-in-memfd_alloc_folio.patch added to
 mm-hotfixes-unstable branch
To: Andrew Morton <akpm@linux-foundation.org>
References: <20240904195844.99242C4CEC2@smtp.kernel.org>
Content-Language: en-US
Cc: mm-commits@vger.kernel.org, willy@infradead.org, vivek.kasireddy@intel.com,
        peterx@redhat.com, muchun.song@linux.dev, jgg@nvidia.com,
        david@redhat.com
From: Steven Sistare <steven.sistare@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <20240904195844.99242C4CEC2@smtp.kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BL1PR13CA0382.namprd13.prod.outlook.com
 (2603:10b6:208:2c0::27) To IA1PR10MB7447.namprd10.prod.outlook.com
 (2603:10b6:208:44c::10)
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA1PR10MB7447:EE_|SA2PR10MB4667:EE_
X-MS-Office365-Filtering-Correlation-Id: e2ada1d9-7353-4430-8d42-08dccd20de60
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?QXBBNVFCUmM0S2dGc1Rma2xONGlYZ1VHdzVsT3h1cWVMZ3dYYzlrcDB5UkZt?=
 =?utf-8?B?anNaU2NrV3J2djYwTlhsRi82ZzdCQW9qaWFodkpseWw4REt2WU5rTXBDeGVX?=
 =?utf-8?B?bXpuOGYzQURkbzdzS1M4L1owMU13WGEvc0l0d3dHVlk1dlE0T2V2Y3VQK3kz?=
 =?utf-8?B?cUdtZWh1MFZYM3p6cWxvK2NMY0VpNnB1SXlpYzdMWjhtT2tOcFFQUXMva2dm?=
 =?utf-8?B?VG1UTnJZT3laN285TzV2OWpvTVBHRHJ5bmg5Z3pPR1A1MUJJc0Y3aC9MajhV?=
 =?utf-8?B?aDBOR2hXQ2ZoSGxmRlpsbThtWHM5ZmpMQU56cWFyR1hYT3l3MEdLU1ZBNnoy?=
 =?utf-8?B?dG8ybzc1dnRZOVZXWlNpVEwrdXFYYmcydUhCT1NRQzYvZ0FuNTVxaVZMV2pm?=
 =?utf-8?B?dzFqWVVYbmVuazFNalRUTHIxT3pDTnBjQkNkTnI5Y3JPVnh3NEVaWXZyeFpw?=
 =?utf-8?B?VmN1RlFMT3RydHk5bVFlY1dzVUpKT201ZVBGbERwb0Y3ODVTeEJNK3plejR0?=
 =?utf-8?B?WU5MQm0ycHpxQnM4NStZSnJWeHV6U2M5dS8wRkFQUUdvNG5NVlQ3SmdIcll3?=
 =?utf-8?B?c21jRnQ3Z2dyMnh1Q1gyY09GTElGT0hRNXIxY2ozWEQzbE1pZ0dTUWhZbnRm?=
 =?utf-8?B?QjBKWHFhZ09ZV3ZTVjlKT0xtVlg0SXBreHVsQWRKRzNGSE5Ic2FxRDV6cHp5?=
 =?utf-8?B?dGlxakF3dkNnSFdaOXpBWUFzeE1CWTdUVlMyT3BKNGFkZEI2WHFrVnVScEZD?=
 =?utf-8?B?QStjbTdkQUpxK3orUFVzT1FkOFBoR0JDMGx4MnU4dm0rTXRiamRmL2JQOFNx?=
 =?utf-8?B?SGt2NWovb0N4RTN6aXFmVGJ6bTF4MHFLOS9yaDZrYmRjaGV2czRZbi90K1Y5?=
 =?utf-8?B?b1EzcE8yTnJxWlRXRDdUcTEzSEk2NXZleC9ZOTlLazJzUlRhSGRDK0ExdE9V?=
 =?utf-8?B?cGlFZW1QR0tDUDNscnhENzg4Y0Z1V0pEQmtvR2lsT1VnamZ2QjNNZHVaeElk?=
 =?utf-8?B?eUlFWnE3dmc2TjhKQlZ2NS9IL1lhc3ZXeDdNaTJ0QzVVd2dOTmVqbHR1eitv?=
 =?utf-8?B?dHdvMkNBMVdVdVdKRnJnSGFtMVArTlZkbnZKRUR4aDkyU2JQZWk5S1dlaGU4?=
 =?utf-8?B?d3FpYVJvaWtqdGNaajJWMXVDa1I5a2ZQWlA4RmNZVG0wTlNjdjVOZE9nUCtp?=
 =?utf-8?B?UjR2UERnRkJKUktQYnZ2QzgxR29BN1ZGQUhZM1BIWHhBODBWODZlQWtmcW9U?=
 =?utf-8?B?UUxWbDhZbzlYUkozaUZCU2p2OFBqU3dqUkVDR3lBR0lCcERyZ0NzOHZIVUhq?=
 =?utf-8?B?REFtV1FMZXBieG5CZ3htbHMvamFSTzFnNVRVL1JaTE13SWhKbHp5K0c1dGdC?=
 =?utf-8?B?V0RGWGtON3QreDFOZzBCYWNuUm4rOC9GaTVuV3BEQUs3TjZwWjcwZVJHdGZZ?=
 =?utf-8?B?R3d6YVhjRHprUW1iL0ZkemZEK2wxVmpvZUtSSVQvMkw3bWdNT1NCOGM5dVpZ?=
 =?utf-8?B?ZEtkNVpIMng3VUNsZm4zcWhxTTh6WU9yOEoydFdZN0p2Z0VVMXZjZDFKZTd6?=
 =?utf-8?B?aVRTMmhLVmdsYmVKYzg1eW53MUJxcEdURDc0T0JsUDNvMmN1THhxZ3llYUxV?=
 =?utf-8?B?NDErTDBYNTBENmQza3pFbmh5Q3R0WGk2c2ZZeUk3Sit4M0NrZVpvVW50ajlu?=
 =?utf-8?B?ZHNWWFNUYTRZV3hLbjlXZ2QyYUxBbG9VZmtPY0RDUUNMYjdlVk1BNW0rVjZx?=
 =?utf-8?B?ditsdW9wMGZaS21neWZiN3F5SmdtejdRM21RbkowYUpxa2lXTnFsVFhObDB0?=
 =?utf-8?Q?s8D47oWydxq1W2H5QPW6lLEsEF8Lr2ApoIkDY=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA1PR10MB7447.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?SVZQeHYxQkxYRjg0UlI2MUpncXgzeXAxU2h4RHVhY3gvMnNWR1N1bnRKMkhT?=
 =?utf-8?B?TDJXSFQ5YjFnMmRKaVo5VHgvVFczZXBEL3l3UTNaTjVKVTlRUkZKTGIwZFRx?=
 =?utf-8?B?a2o2dEQ5M3VLOXBmMmVnVWFUWGxQRWxzUXpYb0w3ZE5ac0p5MC9hVllrWmZq?=
 =?utf-8?B?dGIxVW15QUdzcWdMcXQ5aDAzaXZ4aE5TakpuOFBaQTlyTU5BSE12SDBXbC9l?=
 =?utf-8?B?Ui8xd2VmaGlRUnlEamFaa21Wd21rVU9IY1VrRzQzRUlBcnBrNXArdFZKdith?=
 =?utf-8?B?Uk5CczhVNmMza0RxSmxwZkIvNm00Z2JHd3dHNkdVUFR0MmszNlNlSDdzcGJT?=
 =?utf-8?B?MEViZWFzTFZORTZaejQ2Z2lOYmVrQTlOa3ZUVWFRVmx6eVIwdDRieG9Fc2pl?=
 =?utf-8?B?ajByTnJqRlBMRGFlcHZQUldxOGNYUkVJV05oSWdvZWE5WlNQRXFWQ3pMZ0di?=
 =?utf-8?B?bDYyT3gxb2liNEY2SThadEdrWUNzMEJNUW02Z2F0SjRSOCs2SGgxL0RnN2Ju?=
 =?utf-8?B?QU1sN3llYTJUWmFFYUNsRUUzNGVpbEd0T0xTbmpNS1dqdWVJcFpWWmwvQTEy?=
 =?utf-8?B?OTQwYlF0aGs3V0YvaWRqUU5hLzQ4MGdFdm5EcW5PdEtHVmZZS1FvS3VHcTBM?=
 =?utf-8?B?TFVJVHRxK3RnK3BOWDMxeEpaejFuYkFxZzYzQnovNEcvdnNTT3lBcXdGcWg2?=
 =?utf-8?B?ZGlzZE5iZlF3NkU2T01oeUFEdURVVlhVQjluZG9BcmlKV00xQWdGTEZaZUdD?=
 =?utf-8?B?bm4vMWR5T3h1WWR6dUc4K1FRai95SlBaSVQyOXZOQTlnOVNlSDlDdWNYV0hl?=
 =?utf-8?B?N256alNEMlpMVHRzZUptc21sRzJmeUk4aldsUTJ3Q09qTGpyTUgzQ1BsQXRJ?=
 =?utf-8?B?cEl2enpRbkpxcXNpa0RGY1NteFpVNS8wQXhCREJrTHpBSml3cVdUcldoZGFo?=
 =?utf-8?B?UWdVOHh0bmlaUEUrWUkxZkgwdnpPaUZoeXRid25mMDl5Rm1rMHAzV1FDNlVC?=
 =?utf-8?B?UkNnUk5HMnNzNTkwU0pDcjJ5QlFIM3ZUMnlqN055MERWSjEzNXNiSVdpZjE5?=
 =?utf-8?B?T25JQXBmN2ZNdEtkUml4ZkplK1REd0dlWHV3WE9sdFp6NkpoR0VnTm9KV2NL?=
 =?utf-8?B?blJBMG5ZMnVqSFhRRDdQa2Z2aU5PQkFXTHJ3Rk1Zby9zQ0E4eFRITXZzR2Jj?=
 =?utf-8?B?alZ3WGMzTnlMNEx0WVhITG02L1VLay8rZUtNTzgwOWtYUzM5MjNNdktTbDM0?=
 =?utf-8?B?bXkrMUFFMjlwZGlUcStSWkJWUUFTT3ppTXprZW5qSERDZFgrOTZBdFYyQ25G?=
 =?utf-8?B?QkpxUENlU3JZRGs1ZlE4RUNhdmNhdTJtSnAyUU52YU8yb2IzenV3ZlNRK1gz?=
 =?utf-8?B?YWdTWkE2M2M0S3VHdmpUeFRIeDIwTEFZWmU4YVdKbXJuNEhXWWpJODduaStw?=
 =?utf-8?B?MTlxbDdxTlZ4WWJoSktXbDRUdlVPSEJTTS9GYysxWTdDYWNOV1V0UCtMNkVD?=
 =?utf-8?B?Z0RFNXk1TE1XaUQrS2dwdUsyczNnckxsQTExZGpiMXBlcmhhMUF1bXhOSGxH?=
 =?utf-8?B?STl4OHhOLzJ1K2hGcnFDVWtRSmsrTUV3OTc0TW5CaTdqOUpPOVNYZXY1OXNk?=
 =?utf-8?B?Vkd5STVVaEJCTG5tQ0ErQ1RVUFB2eEI1T0FxQlNiUThSU1BKbzk5VUhEenVa?=
 =?utf-8?B?b0NqeDNNWUNLUXFTRVFjN3pxTmc1OVcra1RrSk1YQnFMVFJDT0lIaitmc2Va?=
 =?utf-8?B?YTFRV3ZBbEYxVmZGWmYyZ3RVS0JZVlV5bXllQzU5cjdPditKV2pkMXZIN2VY?=
 =?utf-8?B?a1NJR29ER3RsQzNGT3RSZ25IVHdLQ0dLOW1GN2xNRU5OM25sV25RL25hbHpt?=
 =?utf-8?B?UElvbHpWNFUwQ2lrQkdiZlBkSXoyR0tva3pMTzA0Q045Yjc1ZXdNcHJiNXpl?=
 =?utf-8?B?K29QY0ExdkNSc3JIMkZIV29Ia1BuV0FEZTMzWmw2dys3d0xaVmpGR01OajZs?=
 =?utf-8?B?WFlXeVhGL2RlYUdDUSttT1AxaG43N1ExeTQvZm1EaEVKNDN5VzNIVzlxL251?=
 =?utf-8?B?SVFLMjIvNUVybmlPV2lrM1BxMDRPRmFvcXJKRDEwV0R6TkdhOFJaMXVvelpu?=
 =?utf-8?B?UUF6RlNXbWFOV01vVCsvYjU2WlFBVWpxSEFEMldlNGFhUityYlU4TG5WWmNa?=
 =?utf-8?B?a0E9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	3rzupXE51yc1sC1TGCXp+zYV34c8u+67cVJX5b556zxIw/+TeB2QThZc0tWKZ9a2kcIqu8VWYpE96ANnJEIY0Kql1carwnaDWCd2x7/xtt6/Vi2ZEgqNSOAeJX7RMln9Wp2RnDNw9o6h6umqzvmSXidCJUAX9N6gTKo9w5fP5oxEekiMRmMO2AYYkG7QiV6Yan4+NHUV16iPzUR6VzvNmZJI/H1xwW4WfSEC/v9m3z8ftyHGdZxXFfCzX/+khES3tAhBMXiaZ/D8YoRqU3Sa7BLlutOVLLz/Nnxzj9Q5zysuLbzbSMmYLGQvvXbD6xe6j4P42gmVNWtDBBNQVhX5nzdxS3Y74l6OO1xE92AcIMOcWSqBeU7nhevOEAlC6Fhqhp7xAa2W4Dzr/K8A1pi2YHx6loj306oPkbxT5JzvhrodB7z0CCN+n8npz0h20zNKjTRRuAf1Tf3UQlfs9rjiyvvkERGF0e9whZgiHUANDUg922NBFTTtn/7JZzs5fVNnoGU+s/U/ovISZ7n+db2yenMIE/xjy87kDtqKCLbmJy19vc0ocEO19rPzo3NkGoOXhLoCEVvmDghpSc1baLJbjxIae9IEdJ1/+fxjB7/ZcYI=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e2ada1d9-7353-4430-8d42-08dccd20de60
X-MS-Exchange-CrossTenant-AuthSource: IA1PR10MB7447.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Sep 2024 20:33:43.4181
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: GKghbmLFYqsCoj+ivgDkeSAM++inUlKgY9+d9EMF/THi66k5AsDgeLRZy4Yy+fDstMaxiCVUbzaeSiwTZBu43cP7x8Tgh4ui63n8V5tV3Ag=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR10MB4667
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.60.29
 definitions=2024-09-04_18,2024-09-04_01,2024-09-02_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 malwarescore=0
 mlxlogscore=999 suspectscore=0 bulkscore=0 spamscore=0 adultscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2407110000 definitions=main-2409040155
X-Proofpoint-GUID: YV5HXzu3yvnCxMUlRK12hHYwSY2YO-Ma
X-Proofpoint-ORIG-GUID: YV5HXzu3yvnCxMUlRK12hHYwSY2YO-Ma

Hi Andrew,
   Please delete this and use the V2 I just posted.  Thanks!

- Steve

On 9/4/2024 3:58 PM, Andrew Morton wrote:
> 
> The patch titled
>       Subject: mm/hugetlb: simplify refs in memfd_alloc_folio
> has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
>       mm-hugetlb-simplify-refs-in-memfd_alloc_folio.patch
> 
> This patch will shortly appear at
>       https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-hugetlb-simplify-refs-in-memfd_alloc_folio.patch
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
> From: Steve Sistare <steven.sistare@oracle.com>
> Subject: mm/hugetlb: simplify refs in memfd_alloc_folio
> Date: Wed, 4 Sep 2024 12:41:08 -0700
> 
> The folio_try_get in memfd_alloc_folio is not necessary.  Delete it, and
> delete the matching folio_put in memfd_pin_folios.  This also avoids
> leaking a ref if the memfd_alloc_folio call to hugetlb_add_to_page_cache
> fails, which would otherwise need an additional folio_put.  This is a
> continuation of the fix
>    "mm/hugetlb: fix memfd_pin_folios free_huge_pages leak"
> 
> Link: https://lkml.kernel.org/r/1725478868-61732-1-git-send-email-steven.sistare@oracle.com
> Fixes: 89c1905d9c14 ("mm/gup: introduce memfd_pin_folios() for pinning memfd folios")
> Signed-off-by: Steve Sistare <steven.sistare@oracle.com>
> Suggested-by: Vivek Kasireddy <vivek.kasireddy@intel.com>
> Cc: David Hildenbrand <david@redhat.com>
> Cc: Jason Gunthorpe <jgg@nvidia.com>
> Cc: Matthew Wilcox <willy@infradead.org>
> Cc: Muchun Song <muchun.song@linux.dev>
> Cc: Peter Xu <peterx@redhat.com>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> ---
> 
>   mm/gup.c   |    4 +---
>   mm/memfd.c |    2 +-
>   2 files changed, 2 insertions(+), 4 deletions(-)
> 
> --- a/mm/gup.c~mm-hugetlb-simplify-refs-in-memfd_alloc_folio
> +++ a/mm/gup.c
> @@ -3618,7 +3618,7 @@ long memfd_pin_folios(struct file *memfd
>   	pgoff_t start_idx, end_idx, next_idx;
>   	struct folio *folio = NULL;
>   	struct folio_batch fbatch;
> -	struct hstate *h = NULL;
> +	struct hstate *h;
>   	long ret = -EINVAL;
>   
>   	if (start < 0 || start > end || !max_folios)
> @@ -3662,8 +3662,6 @@ long memfd_pin_folios(struct file *memfd
>   							     &fbatch);
>   			if (folio) {
>   				folio_put(folio);
> -				if (h)
> -					folio_put(folio);
>   				folio = NULL;
>   			}
>   
> --- a/mm/memfd.c~mm-hugetlb-simplify-refs-in-memfd_alloc_folio
> +++ a/mm/memfd.c
> @@ -89,7 +89,7 @@ struct folio *memfd_alloc_folio(struct f
>   						    numa_node_id(),
>   						    NULL,
>   						    gfp_mask);
> -		if (folio && folio_try_get(folio)) {
> +		if (folio) {
>   			err = hugetlb_add_to_page_cache(folio,
>   							memfd->f_mapping,
>   							idx);
> _
> 
> Patches currently in -mm which might be from steven.sistare@oracle.com are
> 
> mm-filemap-fix-filemap_get_folios_contig-thp-panic.patch
> mm-hugetlb-fix-memfd_pin_folios-free_huge_pages-leak.patch
> mm-hugetlb-fix-memfd_pin_folios-resv_huge_pages-leak.patch
> mm-gup-fix-memfd_pin_folios-hugetlb-page-allocation.patch
> mm-gup-fix-memfd_pin_folios-alloc-race-panic.patch
> mm-hugetlb-simplify-refs-in-memfd_alloc_folio.patch
> 
