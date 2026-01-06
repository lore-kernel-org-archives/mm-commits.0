Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8BBE2749ED
	for <mm-commits@vger.kernel.org>; Tue,  6 Jan 2026 17:31:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767720677; cv=fail; b=LGN1iJfi0RDA3L8rj5/F8LsFiY2VUCTrmZTZNlEfwZAeIxsJnZLLARluUzK4MB78s7S7EAPW5aMuRejRTp0v6C5lG2sGgv3u3F35Spo63hn1KEo6P4rUKLXxdZmGBgNhk7DAoxAOk17eQdNF0FtnYozNcspKNHC+J1UUlAUemT4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767720677; c=relaxed/simple;
	bh=jk3fnwstu3diSDtA/3VL3ERGskZ0OP24Dz5UZZYBsm4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=jnN9+BKLrD/82cTbI+VGuX2+15eEqORvZuX/ILCajMe3jOX7hwCmpPpJTqwInabmAZGTCDTwbOUuy3mRBb4+uhgRS51rsM7BzPA11yy3h/FTHlA+rz2ta48K/AOGFT+7qOnRxEHS4Ycnflwy1c7mIaQPLgALd3IgLeB/MeaL5BU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=UwEh50SD; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=teJAxY2r; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="UwEh50SD";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="teJAxY2r"
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 606FYhQN4089938;
	Tue, 6 Jan 2026 17:30:36 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=Iy3delFzxRW4fHH1mVY5BQqVXDzMaIxPN0DNThSQMKk=; b=
	UwEh50SDiLvheYRPM9PuR1p95OkpnCZqjSJu4jvP8biEwvixt9cFtQTPUqXmJGAA
	ho7cl/KWE+Fo/R63b/nCL35xy5MpvocI60ANm0kMssFobHiJoCgubpcDtsHPj0HD
	QCyb4qAVEQIaMkk2O4JY+DJbyuNmQSdSB0kzpb8MiLqeqKfa65H/Z6PNPwvXx79J
	IUTmYKXdbyZdq0YxhmQps1EbXxkWl8aloib3HNTgAawRi3GT6pt/LWy5aH1LYBkT
	hBzW5V6PC3tf2COOooyVFWYX0BBhFZ+zF9+fF9YgLPkeUC4qPeTJEIrPSj/FRi6v
	GpgHxnlhKqXn1E+SFL+mJg==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4bh55m86gs-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 06 Jan 2026 17:30:36 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 606GG5fC030722;
	Tue, 6 Jan 2026 17:30:35 GMT
Received: from ch1pr05cu001.outbound.protection.outlook.com (mail-northcentralusazon11010069.outbound.protection.outlook.com [52.101.193.69])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4besjcvhrq-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 06 Jan 2026 17:30:35 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=qc6XDo+J4Arq/SDPs4Raee17n8Q6+BObkzU+WohLdPOmgJ2Vx2Gu63zQ1QkqacP5ea/I6khnAktUt6rwq7dpUuI/KuhGai0fM+oPMfdc91+U5AkjgcQ+TBaQr4LWVaFBl95Ic4l4mJDp28+Ko1M30sb12H0zLJruK0cqKV5qPWyPBLTtHN9Tu9HeQzhazQrbnP53o/oPwqIsyZLvhcrNBRiioK5+hQo1oH+j+LbK3R5QvHswMltfv++uEPHnQ2NMjZjbjH+sLHLTf/zqo/IRTqiGXGnS4d5cav9j8dS78E1LZgtd8+03n9bgdcLj2nOsfUTbo9sF0rQZEWIv40mkYQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Iy3delFzxRW4fHH1mVY5BQqVXDzMaIxPN0DNThSQMKk=;
 b=Rt1VwVbjDUhKMqjbEUMK63tCz8yea3vzUa5MT9PE7ZYl8GVGNuxUb5DwykXfq0byjv6pyFej96QTEi2W95VfY1Imqyc8WjE5T7/zKzXqGIOUu1yIOL29MyPiEPrGVnaCfc4SJjTZlSymHUNXCXD19ihODEdYjx5rmBj78fieiBbGg7pZ/TkIM9imZUvdflmCBjIr1Tml/5tNd3gi7yocEv7xZLh1YPciZmvDiJR+O22VWa6uKHLzowWFTl2lc1aLOhZ8XBFmDQkcl4js93resy66VzHAxffvsF4E4/My4gqLdJnFpBeAz1AMFSFXeHzE9yU7wOQo2jKO0dlMMdUkqg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Iy3delFzxRW4fHH1mVY5BQqVXDzMaIxPN0DNThSQMKk=;
 b=teJAxY2rqlI37Wys+7vuYnfLo1TSb6m3+Ys+2abLMIKD9nGRb/GOYjhhOtglzqGJ+gRSo1sY/GPoo4QjaDdhwRfq//UxriCSEJe7goHaWk99rqM1Zj1Qvg2E63nqs2I7e6GezA0RsOierD27QDdhui3RvSDfz42J0qPsc5SvGo4=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by PH7PR10MB5879.namprd10.prod.outlook.com (2603:10b6:510:130::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9478.4; Tue, 6 Jan
 2026 17:30:30 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::f3ea:674e:7f2e:b711]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::f3ea:674e:7f2e:b711%6]) with mapi id 15.20.9478.004; Tue, 6 Jan 2026
 17:30:30 +0000
Date: Tue, 6 Jan 2026 17:30:32 +0000
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: mm-commits@vger.kernel.org, zhengqi.arch@bytedance.com, yuanchu@google.com,
        weixugc@google.com, tballasi@linux.microsoft.com,
        shakeel.butt@linux.dev, roman.gushchin@linux.dev,
        muchun.song@linux.dev, mhocko@kernel.org, mhiramat@kernel.org,
        mathieu.desnoyers@efficios.com, hannes@cmpxchg.org, david@kernel.org,
        david@fromorbit.com, axelrasmussen@google.com, rostedt@goodmis.org
Subject: Re: + tracing-add-__event_in_irq-helpers.patch added to mm-new branch
Message-ID: <3a96b65e-49b1-45f5-a36a-77b38cea62e2@lucifer.local>
References: <20260106033842.559EBC116D0@smtp.kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260106033842.559EBC116D0@smtp.kernel.org>
X-ClientProxiedBy: LO4P265CA0196.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:318::6) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|PH7PR10MB5879:EE_
X-MS-Office365-Filtering-Correlation-Id: fea6ac02-ae26-4ca4-ef6d-08de4d494a1b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|366016|1800799024|376014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?UlNhcWhWYSt3QjJ0eUdhSXV4Z0RJZkExMGpJR2hrL0ltOWZydW5hNTNIcW5k?=
 =?utf-8?B?dWcwdS8rTFp1RXUrSVQxSDViaXRuV010ZnIrSXBJY2tvdWdjSFlpN2ZlWDFs?=
 =?utf-8?B?bjM1MUdkaDA3UFo4VUZ4VTVOUjlRVkFjMTJJMCtuS2QxRnYxVC95TUNkQmJ3?=
 =?utf-8?B?U0ZmV3g5Um56ODhyNkUva1BWYnozWXJYbmtEbkVWa0JLcWJrRk53V215Zndu?=
 =?utf-8?B?Ym8zNDVZcEZKaTZzZWZJUW1IVGJRY3VXRGhnRjluZUJiaGxFMFRKR1B4aVJF?=
 =?utf-8?B?WVU3aEJwd3lqNmJCd0VKb2RRTW9lOXJIbDhqamNUZi9vaEtvWWFtanRzQk5s?=
 =?utf-8?B?aTdmMTl0ZTVaUmlFOUVuUWkzQzV0byttOXdMVHNOWVdUMHhBSDhHQ3pJK0lT?=
 =?utf-8?B?NkkyVlU4ME5VRFFzNkltMHlIcElmUFlrYUV5L0szZnAvdUtNUnV3bXlvMmpG?=
 =?utf-8?B?T1FaaUQrL0cyaXpzKzk0dTdDQkFrQTBjS0F5ZEZua2NzVERRMHNQSEIwYmdi?=
 =?utf-8?B?VVJjaEQvekFDb0hkbDdsL0gyME9OaGZPT0xLT21oR2d6UVB1NWoyMXpwc1Fi?=
 =?utf-8?B?b1Q1VjFVbW96R2JuMTF2bDlIZGVXSjhEb3dLeUVvcDFLS0FQZllhZjJoaHNy?=
 =?utf-8?B?Y2FtT3AzSHNJNHJXZE5SRWxaM2M0YXM1enErQjVBUGVqcTE1ZnVXMWVERzgy?=
 =?utf-8?B?U0xIdzlJTjNYanJwZXhkb0M0RWV2U0xweC9MN2FoZSs0NWZkZm53elJycS9V?=
 =?utf-8?B?dUw2SWJ1aTVjektHN0ZMODVVcXZDMGV0dTdCNWpKOUhEYUdRc2hycHRRek9S?=
 =?utf-8?B?Z0czeU9OY2prUFllWVRsNkdZOU5ISCtRMEs3Wm9uMmtISnBpSHpwVW1hdVhk?=
 =?utf-8?B?YXg1d2c0Qk9KM2NodVhGd0ZzWWszMG5TK2gyMGkrMnVzbTh4K2c4dkxob2x3?=
 =?utf-8?B?NUJMY0R4bmJveUR6bFo0TXlCQjJKdTQvRjltK3UxSG5IcGh2OUc0YjcrZVdp?=
 =?utf-8?B?QlhRaVJmNkFMcXJpek9YdnoxbVBUemIvYUphbnVlQW9EVGlCYmRJRXVQdzlP?=
 =?utf-8?B?RjFXQ0JENDBiODVnelNWbE1oeFg5NVVqZEhPUHhBYUJZQUJnbGlGN1VMbU9O?=
 =?utf-8?B?L2pMRFBUMzdxUXJxNi9OZVNwamcwMEtPQnpRdWRRNFB1U25Na3JKUjlxZHV4?=
 =?utf-8?B?WHoxZFRMMHYrNklTM3VtbUxsajBXY2d0cEVwTWZ3Zk55czQ1S2M0dWRjTWJj?=
 =?utf-8?B?TnNRK0QycUpHcUozUms5SjlUZWt6SUE0NHUxaTBJZG52S2JqOUxLWXBhc2dz?=
 =?utf-8?B?THZhUjJGMHYxV2VBc25nVHNjcUF0MWoycnVPV3pZNjNyQUVweXhvVmgxaDRN?=
 =?utf-8?B?L1VnaW5HclNmVDREU0R4NlJadHFsbm15bG45TkRVMnZjWldTTVBTS1dYclg2?=
 =?utf-8?B?dHFkQW03cEtCNDhnRUhTYy8yT21wTnJVOHloaHZXVkt1b0o5QjdrK1B5Y2V0?=
 =?utf-8?B?dkhrR2VSYlFKNXZkeGUyRFYvdkhPNDBGL0owYU5tMklnSUVka2FwdFhtZ3hq?=
 =?utf-8?B?aHRKZVJWL3ZBS2NBMWZtdEZVSG1WUXgrNjVMZFFVaEliK3A2YzI4UDgyaHpU?=
 =?utf-8?B?U1I0QXBxSU9DUy9BRjE3QUthNks3SW02azN6OFoyYTk1cHRnSVhUdGNyZ2NP?=
 =?utf-8?B?ajROc3RiY3crSVNBeno3TkdMUFlEWGlKbDFZSHFOMjVsUWxzSUVyQTJrMWhq?=
 =?utf-8?B?N3hMRVJ3WHNEZGNUUHNtOVZMUGRHN0RXSHRtTTZyaG41WU9kTE1tb0FxWDJv?=
 =?utf-8?B?WlU1RDhzbmR4V05taG9VTk8wTllEcU4yRmNCOHBCNDE4YzdGOWZtZzFEcWV5?=
 =?utf-8?B?VS9qOHE0NjBIeXBHQ3hiL2o0SUQ1T3lzeEFrTGFGT2ViSzEyc2MzNXcraDdw?=
 =?utf-8?B?UnJ3ZWtjTHdDQTQ0ekhIQU9pdWV4NTNpUHhUMkhRSE05eFArS0Y2ZnkraURP?=
 =?utf-8?B?ejdKa1UzK2VBPT0=?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(366016)(1800799024)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?VVJjcklKc3ViWVBwTUtHVUtPUXpTam41RWJqT3JGTkFyWVFKN202am1IWGFS?=
 =?utf-8?B?UU9XN0duOHM2SW0wK1NlOVBXSnNDc1JlUzBrQldybkYzcHZBclRBTEdVSzRp?=
 =?utf-8?B?WU1xcThrbUE4OXBmcHRNWGNwaWdjeHFhbC9WKzFYbEhKa0dOU2VMYmlobFVS?=
 =?utf-8?B?K1NLVnhPTjRHQkVoMHo2dlFPbFF3TUphOWF3dC9QTDg2M0c3aGJCanpNRDBM?=
 =?utf-8?B?emplSjFsTEdaSzVrd1pWcnJQU0E2MEdHNFVpNExpbi9EaXkyWi9NK3J2ekt6?=
 =?utf-8?B?RjlhUkNyN0RLRDgybEphZURUclB1WXd6SnhWYXk2dUtLaFpJaGdWU1FaazI0?=
 =?utf-8?B?VGRtdlBsUHc4M2M3dVdJb3MrN1FFVjlaaFNCQTByRmg1Z0xyQm9tYXJXcXVn?=
 =?utf-8?B?YWVMMkU1bHExRENKQXkvYmQ4b0pSSHlGazl1dXBMalRreHd0Wk9BWEF1SjVy?=
 =?utf-8?B?VE10Y1hVVGYxN2ZZSjQ3bzBnclVHc0ZIdkZLZzF6NkU4SlBQUWRwUGxCeTJz?=
 =?utf-8?B?Q25PSjBGajBDaWVGeWNQUXczTlp4NVFCOVpOeXFuMWREOU8vZU9MMTBPY0NN?=
 =?utf-8?B?VjF4UnNGclhGcFMxNlE5dDZXa1lNeHdRK29yTDFuMjl3ZEVPdHBLdGlhZUVQ?=
 =?utf-8?B?aklrTWo4bUtGSjhUWm1XTVBCcU01WW5IajZVMXV1WTh3WHEzcXprZkZlTm90?=
 =?utf-8?B?K3VqaUpjdURRMDUyaEdMODI3Z0lZWkREOXkranlXeFBoazQ2ejJFZHB6MzBQ?=
 =?utf-8?B?ZlVDQUZOcUdFaUlQM1ZvRnVjd1dzUkJQMkVKS2VpQi9FSFFYM3BOTjkydEZn?=
 =?utf-8?B?ZFl1TUdFamFESzRSWG5QQXVoUTNYTTgzeEpMNDBwRytEeWdLY1BRY1JQSnRH?=
 =?utf-8?B?Y0dGQi8zM081d3BYQ0E3SGkzUHU5TlZZZjJQY1h6NlRQQi91N0VZS2hpdVFw?=
 =?utf-8?B?TGNQRjlSV0VXWXhiRFloeXowSEhCUEwwL0o2cXdkWmh0eVdGeEMwUzFXb2NZ?=
 =?utf-8?B?VjhFSk43UWtIODdHQjN2K3kwbFAyaXN2bHVtVjdDbmNWT3hJTGNWbW5iTVJQ?=
 =?utf-8?B?TmF3anFFdSs5NTFvK25pdzY0Z3ptaFBDWDB3dDRoZVJDVzA0K1RiKzBYT2VP?=
 =?utf-8?B?NS90TVoxN1ozR09EWTNtcndCZ1l5bTFOeHFPVUlQRFlZU3htYVFnM3AwL0dM?=
 =?utf-8?B?cGUyZnZTcnMwcGM2bTRWZExXRU1hN3Y5ZWNRVm4xbjFiWkQwdS80Rm9UVk5x?=
 =?utf-8?B?elFtcW1FbDRiT0xPZlBJRXliQjFWWUdIU1VZYk9uZXN6WlRwTGI2UHBWbEVC?=
 =?utf-8?B?ejhDS1RQRzNZelFPSmUzVDIrYXVsLy9CYzFpWTJiYmtvc3lFNXQ0ZUNSK1gw?=
 =?utf-8?B?NFVhOFJzTFgweGlLZDNCK2JlQzQ3VjNZVzFLcUYyVWRlOWpRektLWE95d2di?=
 =?utf-8?B?R0txdjcvS3FXeWMwSXQ3RDZWM2h4dkdkaU9lcVovTlB1M0lnQjlwR244R2Ur?=
 =?utf-8?B?dnJGWkhGZHl5NVp1ZE9jK04zejVmK1g4M1NZaVhlL1J6NDZUVEJZMk1mQ1VE?=
 =?utf-8?B?OUJ4dkVGNzdyTkxSQ24rOWlQTWF5S3hGZ05BNkN0REhwdTB1QUQ0UjlnSkRV?=
 =?utf-8?B?RlYxWkUzSm11cmpmRXZndFJNTUZ2SFcvYXVBVmNBV3dKaDUvTmZKQTNJcnNk?=
 =?utf-8?B?SUNKdUZIbHBIdDd1S3kvZGdZQjZFQnFCakNteWZOdkViN2ZLbmlqempYTTYz?=
 =?utf-8?B?MzZuQnJTZXAwcWtheDdZQmkzYTdlKzZHNFNsVEZqTmNiR2x0QTJHSjQ2NDh6?=
 =?utf-8?B?NWNRRlZyOHZvRGtoUkxvdHh5TER4REZpVGRaNzVUanhRd2V2alZyckNpZWFp?=
 =?utf-8?B?bUI3UDkxUUpJN2NJVVpjbjZFRHVpNUdaVjdGdS83MUU2WWVJaEtZRkVTejNv?=
 =?utf-8?B?SzFpdlJRaFdFR3RPODVZc2pSSlJqb0w3SmJmZ2d6Q0dMUnZtNzV6YVpXNzJz?=
 =?utf-8?B?dU1ISDBpSkl0MENwT2Jjd1ZvbStweEl4cnRWQVFia3NhMUJUNnI5bTh5UVBM?=
 =?utf-8?B?aXFlYmxleWI0ZkVYSDVFemhjamZ1N2JtOFRlNGxON3FlTEJFRFp4TUpyN0da?=
 =?utf-8?B?QmwvalQrcDczdThSTW8wN1g5Tmp2UVpVUlVRVHlRYVFMeEZINnpJY05mclZY?=
 =?utf-8?B?OTQ0TGtZUWtRRXRwd0JKM3dyMzRFS1ZJLzBFQzNMVmhUNjRtblJYY3ZLRG9Q?=
 =?utf-8?B?YW9UUEV3OU9GSENQa1RSSVcvT3Q3NU44L3diRG56d2szZ2hmS09lQVJ6aTZJ?=
 =?utf-8?B?dzB4K2Y0ZkJtdnVSQXpGS2hWcWhkRWZ5QXdUcmNOZEZKelNQQWRoak5mckVj?=
 =?utf-8?Q?FSAAjYvYjgPMrqXg=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	NTEW4B/yNaCeYZyFiEL15+CSYgTiACxZ0sQ+K1ROUueccz5cW0iTSx4F2MBJ2IwgOm84SWl6zUiWtuDOmw3T8pMPYxiIfmC85exfyLzbgksto4LBMF3A4mw0j5g5sENSy3NnFacuzob9fNMy2Z9wFD2UfG+kcd9jGf0/7UG+88bFGuXGxe2L5kz4SQYOW6f7yYLDwRDliBBiS/EO96Sh0WFon7iSYNnUhWa1R4e1FlrXi8BTJC26EHMflOculoWIbXjfHb6+7we/wBmH4Upzg7PQJLo1hxs0D56oFfS3pXnjxKxOxmygHmPbLtLmZkd6iycyfyzaswRwctDoHVa9Gjd1ZllELlttWqKTcfhMiKIUce75mFjWR0IXp0aAglYzf+7UDibtsT+32LU4DnqnQv3KxBETubxlDzAkEB4DgW0SQyP6efdhzxFGD74H45VuYsWf1J6WcItvwNcBpJf0Bxe6dnfYKw17piKXxRxP5/4uIuBKFTyi3AXg/4RxTS0ksssvrG4WfNF1KzxwYT99MbC4+zPievIqVDT8aTkU2abdC588tl2VMuC3F/FcxXdnAqC9ISeo1IM1qgs3xDIC7xChQCOEaVvEiVY4BJlIs3c=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fea6ac02-ae26-4ca4-ef6d-08de4d494a1b
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Jan 2026 17:30:30.7376
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 83imAUhoFRqWq82zoMOfSqCRfkfGOOmq3Y6vl2SKJmUFR2gXhHNcdTT6m9KRbkJ6GDk2j89qXDUGIZW5HhUTXOhwnUbeoxVt4FEc1CpTLzs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR10MB5879
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2026-01-06_01,2026-01-06_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 phishscore=0 adultscore=0
 malwarescore=0 suspectscore=0 mlxscore=0 spamscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2512120000
 definitions=main-2601060152
X-Authority-Analysis: v=2.4 cv=RpTI7SmK c=1 sm=1 tr=0 ts=695d46bc b=1 cx=c_pps
 a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=vUbySO9Y5rIA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=VwQbUJbxAAAA:8 a=meVymXHHAAAA:8 a=7d_E57ReAAAA:8 a=1XWaLZrsAAAA:8
 a=7-415B0cAAAA:8 a=ufHFDILaAAAA:8 a=yPCof4ZbAAAA:8 a=968KyxNXAAAA:8
 a=yMhMjlubAAAA:8 a=Z4Rwk6OoAAAA:8 a=A3RORQ0Nkv7OIBxvErAA:9 a=3ZKOabzyN94A:10
 a=QEXdDO2ut3YA:10 a=2JgSa4NbpEOStq-L5dxp:22 a=jhqOcbufqs7Y1TYCrUUU:22
 a=biEYGPWJfzWAr4FL6Ov7:22 a=ZmIg1sZ3JBWsdXgziEIF:22 a=HkZW87K1Qel5hWWM3VKY:22
 cc=ntf awl=host:13654
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTA2MDE1MiBTYWx0ZWRfX43FVe4tftcoG
 Ww5ypYWoM2FwaChg83mu7JIuB/NPll2J9n2pvQJPZL/ljJIbS4YFnZ9WchNgVIwIVSTYA1JijhK
 NDFyu9rC0R7wuFEKJbT+dqxGpajbGlg8m6zOg2uoIXvpZcHyGPXBpj1YNYSr/v4eM+pRC7J8Qmi
 NCmJBdRpCgbOo1ZzqEfRBX8IrEBWoO126GYq/S6eLUPVDoo/2zIDFqNciIqmm4AnqxXdEO/Fx9e
 yDRZ7B8Ld+FgRyM2MKhIu46xifoi+55C65XK227oi6itfo2fgQB7bcCT+XS9q5B5eeS2NbjSLfZ
 BxcBDZeHpAwwRrxY2ecXZE96oLC6IZ95JSGVwXBZiHaUOidgZSEgi9lpd0pzpbSz/Kq/bOa2xbT
 FERstM7B+joCjYiuECIBgZcYoa6CrfAxsDZL4RQTTr0aAJQ/CxUQgYFLritXAgsQ40vqYyLXWHB
 Yk7b3j2lUmlZIDrLXU+d+xWlQGWSz2GEPelk9jZE=
X-Proofpoint-ORIG-GUID: 3-arZPlk33u2OfIHgYwPWZgTRp4leN0f
X-Proofpoint-GUID: 3-arZPlk33u2OfIHgYwPWZgTRp4leN0f

Hi All,

This results in (yet another) case of mm-new not compiling. I was trying to
do some other work and (yet again) ran into the compile failing.

I bisected the issue to this patch, enclose error message below.

Andrew - I am still confused as to how mm-new works, this patch looks
unreviewed (+ doesn't compile) but you took it, a related series that also
didn't compile and had review push-back was taken to mm-new, but other
series without review are rejected for not having review?

Be good to get some clarity as to what mm-new is for?

Thanks, Lorenzo

  AR      arch/x86/entry/built-in.a
In file included from ./include/trace/define_trace.h:132,
                 from ./include/trace/events/vmscan.h:554,
                 from mm/vmscan.c:73:
./include/trace/events/vmscan.h: In function ‘do_trace_event_raw_event_mm_shrink_slab_start’:
./include/trace/events/vmscan.h:238:68: error: invalid use of undefined type ‘struct mem_cgroup’
  238 |                 __entry->memcg_id = sc->memcg ? cgroup_id(sc->memcg->css.cgroup) : 0;
      |                                                                    ^~
./include/trace/trace_events.h:427:11: note: in definition of macro ‘__DECLARE_EVENT_CLASS’
  427 |         { assign; }                                                     \
      |           ^~~~~~
./include/trace/trace_events.h:435:23: note: in expansion of macro ‘PARAMS’
  435 |                       PARAMS(assign), PARAMS(print))                    \
      |                       ^~~~~~
./include/trace/trace_events.h:40:9: note: in expansion of macro ‘DECLARE_EVENT_CLASS’
   40 |         DECLARE_EVENT_CLASS(name,                              \
      |         ^~~~~~~~~~~~~~~~~~~
./include/trace/trace_events.h:44:30: note: in expansion of macro ‘PARAMS’
   44 |                              PARAMS(assign),                   \
      |                              ^~~~~~
./include/trace/events/vmscan.h:206:1: note: in expansion of macro ‘TRACE_EVENT’
  206 | TRACE_EVENT(mm_shrink_slab_start,
      | ^~~~~~~~~~~
./include/trace/events/vmscan.h:228:9: note: in expansion of macro ‘TP_fast_assign’
  228 |         TP_fast_assign(
      |         ^~~~~~~~~~~~~~
./include/trace/events/vmscan.h: In function ‘do_trace_event_raw_event_mm_shrink_slab_end’:
./include/trace/events/vmscan.h:280:56: error: invalid use of undefined type ‘struct mem_cgroup’
  280 |                 __entry->memcg_id = cgroup_id(sc->memcg->css.cgroup);
      |                                                        ^~
./include/trace/trace_events.h:427:11: note: in definition of macro ‘__DECLARE_EVENT_CLASS’
  427 |         { assign; }                                                     \
      |           ^~~~~~
./include/trace/trace_events.h:435:23: note: in expansion of macro ‘PARAMS’
  435 |                       PARAMS(assign), PARAMS(print))                    \
      |                       ^~~~~~
./include/trace/trace_events.h:40:9: note: in expansion of macro ‘DECLARE_EVENT_CLASS’
   40 |         DECLARE_EVENT_CLASS(name,                              \
      |         ^~~~~~~~~~~~~~~~~~~
./include/trace/trace_events.h:44:30: note: in expansion of macro ‘PARAMS’
   44 |                              PARAMS(assign),                   \
      |                              ^~~~~~
./include/trace/events/vmscan.h:254:1: note: in expansion of macro ‘TRACE_EVENT’
  254 | TRACE_EVENT(mm_shrink_slab_end,
      | ^~~~~~~~~~~
./include/trace/events/vmscan.h:272:9: note: in expansion of macro ‘TP_fast_assign’
  272 |         TP_fast_assign(
      |         ^~~~~~~~~~~~~~
In file included from ./include/trace/define_trace.h:133:
./include/trace/events/vmscan.h: In function ‘do_perf_trace_mm_shrink_slab_start’:
./include/trace/events/vmscan.h:238:68: error: invalid use of undefined type ‘struct mem_cgroup’
  238 |                 __entry->memcg_id = sc->memcg ? cgroup_id(sc->memcg->css.cgroup) : 0;
      |                                                                    ^~
./include/trace/perf.h:51:11: note: in definition of macro ‘__DECLARE_EVENT_CLASS’
   51 |         { assign; }                                                     \
      |           ^~~~~~
./include/trace/perf.h:67:23: note: in expansion of macro ‘PARAMS’
   67 |                       PARAMS(assign), PARAMS(print))                    \
      |                       ^~~~~~
./include/trace/trace_events.h:40:9: note: in expansion of macro ‘DECLARE_EVENT_CLASS’
   40 |         DECLARE_EVENT_CLASS(name,                              \
      |         ^~~~~~~~~~~~~~~~~~~
./include/trace/trace_events.h:44:30: note: in expansion of macro ‘PARAMS’
   44 |                              PARAMS(assign),                   \
      |                              ^~~~~~
./include/trace/events/vmscan.h:206:1: note: in expansion of macro ‘TRACE_EVENT’
  206 | TRACE_EVENT(mm_shrink_slab_start,
      | ^~~~~~~~~~~
./include/trace/events/vmscan.h:228:9: note: in expansion of macro ‘TP_fast_assign’
  228 |         TP_fast_assign(
      |         ^~~~~~~~~~~~~~
./include/trace/events/vmscan.h: In function ‘do_perf_trace_mm_shrink_slab_end’:
./include/trace/events/vmscan.h:280:56: error: invalid use of undefined type ‘struct mem_cgroup’
  280 |                 __entry->memcg_id = cgroup_id(sc->memcg->css.cgroup);
      |                                                        ^~
./include/trace/perf.h:51:11: note: in definition of macro ‘__DECLARE_EVENT_CLASS’
   51 |         { assign; }                                                     \
      |           ^~~~~~
./include/trace/perf.h:67:23: note: in expansion of macro ‘PARAMS’
   67 |                       PARAMS(assign), PARAMS(print))                    \
      |                       ^~~~~~
./include/trace/trace_events.h:40:9: note: in expansion of macro ‘DECLARE_EVENT_CLASS’
   40 |         DECLARE_EVENT_CLASS(name,                              \
      |         ^~~~~~~~~~~~~~~~~~~
./include/trace/trace_events.h:44:30: note: in expansion of macro ‘PARAMS’
   44 |                              PARAMS(assign),                   \
      |                              ^~~~~~
./include/trace/events/vmscan.h:254:1: note: in expansion of macro ‘TRACE_EVENT’
  254 | TRACE_EVENT(mm_shrink_slab_end,
      | ^~~~~~~~~~~
./include/trace/events/vmscan.h:272:9: note: in expansion of macro ‘TP_fast_assign’
  272 |         TP_fast_assign(
      |         ^~~~~~~~~~~~~~
make[3]: *** [scripts/Makefile.build:287: mm/vmscan.o] Error 1

On Mon, Jan 05, 2026 at 07:38:41PM -0800, Andrew Morton wrote:
>
> The patch titled
>      Subject: tracing: add __event_in_*irq() helpers
> has been added to the -mm mm-new branch.  Its filename is
>      tracing-add-__event_in_irq-helpers.patch
>
> This patch will shortly appear at
>      https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/tracing-add-__event_in_irq-helpers.patch
>
> This patch will later appear in the mm-new branch at
>     git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
>
> Note, mm-new is a provisional staging ground for work-in-progress
> patches, and acceptance into mm-new is a notification for others take
> notice and to finish up reviews.  Please do not hesitate to respond to
> review feedback and post updated versions to replace or incrementally
> fixup patches in mm-new.
>
> The mm-new branch of mm.git is not included in linux-next
>
> Before you just go and hit "reply", please:
>    a) Consider who else should be cc'ed
>    b) Prefer to cc a suitable mailing list as well
>    c) Ideally: find the original patch on the mailing list and do a
>       reply-to-all to that, adding suitable additional cc's
>
> *** Remember to use Documentation/process/submit-checklist.rst when testing your code ***
>
> The -mm tree is included into linux-next via various
> branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
> and is updated there most days
>
> ------------------------------------------------------
> From: Steven Rostedt <rostedt@goodmis.org>
> Subject: tracing: add __event_in_*irq() helpers
> Date: Mon, 29 Dec 2025 16:35:15 -0500
>
> Some trace events want to expose in their output if they were triggered in
> an interrupt or softirq context.  Instead of recording this in the event
> structure itself, as this information is stored in the flags portion of
> the event header, add helper macros that can be used in the print format:
>
>   TP_printk("val=%d %s", __entry->val, __entry_in_irq() ? "(in-irq)" : "")
>
> This will output "(in-irq)" for the event in the trace data if the event
> was triggered in hard or soft interrupt context.
>
> Link: https://lore.kernel.org/all/20251229132942.31a2b583@gandalf.local.home/
> Link: https://lkml.kernel.org/r/20251229163515.3d1b0bba@gandalf.local.home
> Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
> Cc: Masami Hiramatsu <mhiramat@kernel.org>
> Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
> Cc: Steven Rostedt <rostedt@goodmis.org>
> Cc: Axel Rasmussen <axelrasmussen@google.com>
> Cc: Dave Chinner <david@fromorbit.com>
> Cc: David Hildenbrand <david@kernel.org>
> Cc: Johannes Weiner <hannes@cmpxchg.org>
> Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
> Cc: Michal Hocko <mhocko@kernel.org>
> Cc: Muchun Song <muchun.song@linux.dev>
> Cc: Qi Zheng <zhengqi.arch@bytedance.com>
> Cc: Roman Gushchin <roman.gushchin@linux.dev>
> Cc: Shakeel Butt <shakeel.butt@linux.dev>
> Cc: Thomas Ballasi <tballasi@linux.microsoft.com>
> Cc: Wei Xu <weixugc@google.com>
> Cc: Yuanchu Xie <yuanchu@google.com>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> ---
>
>  include/trace/stages/stage3_trace_output.h |    8 ++++++++
>  include/trace/stages/stage7_class_define.h |   19 +++++++++++++++++++
>  2 files changed, 27 insertions(+)
>
> --- a/include/trace/stages/stage3_trace_output.h~tracing-add-__event_in_irq-helpers
> +++ a/include/trace/stages/stage3_trace_output.h
> @@ -150,3 +150,11 @@
>
>  #undef __get_buf
>  #define __get_buf(len)		trace_seq_acquire(p, (len))
> +
> +#undef __event_in_hardirq
> +#undef __event_in_softirq
> +#undef __event_in_irq
> +
> +#define __event_in_hardirq()	(__entry->ent.flags & TRACE_FLAG_HARDIRQ)
> +#define __event_in_softirq()	(__entry->ent.flags & TRACE_FLAG_SOFTIRQ)
> +#define __event_in_irq()	(__entry->ent.flags & (TRACE_FLAG_HARDIRQ | TRACE_FLAG_SOFTIRQ))
> --- a/include/trace/stages/stage7_class_define.h~tracing-add-__event_in_irq-helpers
> +++ a/include/trace/stages/stage7_class_define.h
> @@ -26,6 +26,25 @@
>  #undef __print_hex_dump
>  #undef __get_buf
>
> +#undef __event_in_hardirq
> +#undef __event_in_softirq
> +#undef __event_in_irq
> +
> +/*
> + * The TRACE_FLAG_* are enums. Instead of using TRACE_DEFINE_ENUM(),
> + * use their hardcoded values. These values are parsed by user space
> + * tooling elsewhere so they will never change.
> + *
> + * See "enum trace_flag_type" in linux/trace_events.h:
> + *   TRACE_FLAG_HARDIRQ
> + *   TRACE_FLAG_SOFTIRQ
> + */
> +
> +/* This is what is displayed in the format files */
> +#define __event_in_hardirq()	(REC->common_flags & 0x8)
> +#define __event_in_softirq()	(REC->common_flags & 0x10)
> +#define __event_in_irq()	(REC->common_flags & 0x18)
> +
>  /*
>   * The below is not executed in the kernel. It is only what is
>   * displayed in the print format for userspace to parse.
> _
>
> Patches currently in -mm which might be from rostedt@goodmis.org are
>
> tracing-add-__event_in_irq-helpers.patch
>
