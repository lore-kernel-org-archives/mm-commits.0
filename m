Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7CF7430BBB6
	for <mm-commits@vger.kernel.org>; Fri,  9 Jan 2026 14:57:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767970649; cv=fail; b=DGi5jTvSycR1mtGKzTTD/Xg6f3JsS1BIYGzVsSSjx1Nfzds6LhckVSbXACoep+XvMhchxrV9RCoU+pTGTzilQj55gkfaJUqX55aTsOBue6EOTcZY08SAx10R6jZjVPhW4J2fYHROQclM3MyEm9kdkdVoAPXTkMoOC0cGqC8OBE8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767970649; c=relaxed/simple;
	bh=U2kZbt6nIoyaFNG5GJeHBaSczlPbPCwkpqiQL7AMkho=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=TMN2zWD0y6MX20PXSmNaIG+7tSlknGhreEC/7YHVAHic/Tom07sE/uoqwrWaT2JDpnztwrQoAQg4qcp8jz6zqsdsrD5Itwsy8jFWzDGTEmNvIDfAClRDtOMXJb2xKxSikRGlfGJ+9b/3+6exk4f1fwaCocrKbZ3bRhlWcxarqdw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=IhPao/r5; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=dBqnjLW6; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="IhPao/r5";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="dBqnjLW6"
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 609EbHR72869226;
	Fri, 9 Jan 2026 14:56:42 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=SqFXsBpA7av/NSa9Zv
	sI03xjlsnpbVFhbwuuNrKYfJI=; b=IhPao/r52NpzO+o7eRLEu+pk7IIAeLmdMf
	zZu/kmmO2hRnC4SAjW04hlw2FX52cPLPAT0fjIGQq6qm6ooyYkXeDQLUDn1T40N2
	meoNgekav/MoZoqSDasBt5c3jaRvxnHU8PBc0BB5kjSSwxrGBdbzrnolpKJhwGeX
	cZtsPgRKHC8HOXg/fDh/F5lCONQmF2pTkGpCP2BBGhnK2HYK76kv9co04lPJfMQL
	HSUViI0WFxBRhXuCdG3MgTX0jd51aenA3cX05xO9hXbJtfqXXejja13S1JuZhiSs
	b4SZmbjiZeR7nTHFyXQ2fv99CxSuHhCByl5DJGB2N/goy4/Tncpg==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4bk3kp80v0-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 09 Jan 2026 14:56:42 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 609EOiZ8026379;
	Fri, 9 Jan 2026 14:56:41 GMT
Received: from ch5pr02cu005.outbound.protection.outlook.com (mail-northcentralusazon11012028.outbound.protection.outlook.com [40.107.200.28])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4besjpqf8n-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 09 Jan 2026 14:56:41 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=uuM17H+h5CS1MANRtggzbjMJ85c7vKJQ2M4WXxyvUrE5sIo5d3Sx88TNHdVHyMqK/lIvATUJoPQASb02HbTXtEO8JeRlHFNf5DMXeNeg4WS0ISsVkE993rrH7VTZMm9vwM+9O83o2rzjKoZqV8BomjoiEfo0qjUgodNL9uDgFUai9wQmGR8BBqJ76lDZA1ALe7sdBRD6ZS/+/2Nptli3ptQ3AdTuz1y4+J6Jr8HYU6M/umlzT486LOGLQ/US9soZMTK8VwRlPWLR15BBE+uwDLl6iBPfvM3NgjHNmBdfF90BlnGkhTHB8fs/tOBZ1HztLH4Udfhin6Zk7XjbI9ZRkg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=SqFXsBpA7av/NSa9ZvsI03xjlsnpbVFhbwuuNrKYfJI=;
 b=EGylCGCnqun2/qlBQ8omUG9kzsQujjdcBwGxbWSBjN0MCtwC5Zq3HIio/o+ja0cRWbd08RZiv8qMWiVop/IxrssYl3NLLqTpLbv8T9r0AZT6c59j2RuV1lA/7qQdiOMZMgoTT4Q1kMzpbPi2Wc0OeYQkKP/gjqnx/1nsuqc4sUliggbJGiugD6h2meZMviuSv/Ic9SuVZEwmofm7wL/WlvyQieJ+Rda40Eqy3OOOvcW5TKIOxHfUlzKLbWDI529lXTC4WvNiDtZIl3d/+XM+8XncXDSlZz33Fb7I3rOc68ntZVn/2bXhuRNMON/PNwfaVo6IegdcGVZKkoCSAGhu7g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SqFXsBpA7av/NSa9ZvsI03xjlsnpbVFhbwuuNrKYfJI=;
 b=dBqnjLW6zAQLsDqvrvLvv2HlDr0wz7Owx1xl3FQS12DRLBEf1f03VVgdierTf5F2Cu/RIgz+UWwivWHZFQ3hYFLKU96eTf9Ifk1BjD6eSBdsdX0v3a+bSkjJvf9wtkKYhcbQChnsShl2voE5aQf1YjtmrG0DWYcBHK9q+D94ZYE=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by PH0PR10MB5729.namprd10.prod.outlook.com (2603:10b6:510:146::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9499.4; Fri, 9 Jan
 2026 14:56:36 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::f3ea:674e:7f2e:b711]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::f3ea:674e:7f2e:b711%6]) with mapi id 15.20.9499.004; Fri, 9 Jan 2026
 14:56:36 +0000
Date: Fri, 9 Jan 2026 14:56:36 +0000
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: "David Hildenbrand (Red Hat)" <david@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, mm-commits@vger.kernel.org,
        zhengqi.arch@bytedance.com, yuanchu@google.com, weixugc@google.com,
        tballasi@linux.microsoft.com, shakeel.butt@linux.dev,
        roman.gushchin@linux.dev, muchun.song@linux.dev, mhocko@kernel.org,
        mhiramat@kernel.org, mathieu.desnoyers@efficios.com,
        hannes@cmpxchg.org, david@fromorbit.com, axelrasmussen@google.com,
        rostedt@goodmis.org
Subject: Re: + tracing-add-__event_in_irq-helpers.patch added to mm-new branch
Message-ID: <24157690-0f24-41cb-809e-448f18cf72ae@lucifer.local>
References: <20260106033842.559EBC116D0@smtp.kernel.org>
 <3a96b65e-49b1-45f5-a36a-77b38cea62e2@lucifer.local>
 <20260106124930.827da463ea281bb392a9843d@linux-foundation.org>
 <4cccaf21-c78e-4017-bb95-29a401d7c3a5@lucifer.local>
 <f916c970-33fe-4147-9daf-159ba61a0302@kernel.org>
 <8b54e314-be57-4fa0-bb53-e9a0adb7d969@lucifer.local>
 <c8b4e2db-def0-49bf-bf04-5dee7e73711d@kernel.org>
 <573a3645-e98f-46de-bb94-ba20daadfaed@lucifer.local>
 <db6c90de-f14b-4047-b03a-3074ffac1662@kernel.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <db6c90de-f14b-4047-b03a-3074ffac1662@kernel.org>
X-ClientProxiedBy: LO3P123CA0033.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:388::11) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|PH0PR10MB5729:EE_
X-MS-Office365-Filtering-Correlation-Id: 071f5b56-51d8-4c52-311e-08de4f8f497f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|7416014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?kJbtSwaqkkY3ZjYLBRj2i60IJe4JcNMmhAuNhqS/VF99t17DFtE1Yr8IQlNd?=
 =?us-ascii?Q?ZdBjGZ/AHtExhPluXh6GDbwP/simbiUPDIM/0mVMCnCxA6saxxgM5FrwhI/O?=
 =?us-ascii?Q?Z4X5DaZY/ybD0cNCIbqkgzgm6HyxM+PnEdcmi4Q5Ppa8VYDkPRn45QHjnYgR?=
 =?us-ascii?Q?OH0c+BVhZW3BfuQbgs+lgkaeqFBDmnY+9NnCf2ERA8zbjfxjpop53YKknw3j?=
 =?us-ascii?Q?DNDBPI+0c8eo+Kd1HfHlaGo8/NodgWdRWVv3ludoD9WZZ0DqwUv80AWTWR3a?=
 =?us-ascii?Q?HlIdbhlABGzUHW1htycsPTfPmYRi4wVSjmcENbidp8M6b1TUuBRROskfyyPe?=
 =?us-ascii?Q?utdQjW/CxsL4sckn952vv+ro2fxvEyV/x2CuOUK0NnIJq9HNSqRIIla0KJGM?=
 =?us-ascii?Q?1y1To9dliVt81wNYmXpS0Rk2nAfCfdl9NV/tZwTnc9kbybIPKscNHPszW4RB?=
 =?us-ascii?Q?z9jg4OoF3qRhR+1rsohijpyeFx1UiXmDQMNYZAzcB1Ilqx5JprY9NVfg/Trr?=
 =?us-ascii?Q?GEAtcoYmmWNgP+SwVKIONU+4V7ivDUlXBHkZZHgDW7EArzVdHu1oJyETQeoW?=
 =?us-ascii?Q?JDvRfTFUW2PPspUnIrOoQzeivLJOioONG19ZSa72Y0oUCVo9QyKyT0IzOPG1?=
 =?us-ascii?Q?L0VvavvwYCXJLCYboDOdkqzPjre/Gzcdt+jAGj8cTVpLVWsMVC8XK/alFDHY?=
 =?us-ascii?Q?CNH8hJO3BYZloi/4RelLP9fXEWtVpTXpUPMDeVpSd7Q8YSsjTXizd1KztHUf?=
 =?us-ascii?Q?MKb62c+85xv8V6Awr/Q3/uMbqZlfd5pdyETZdRfdQHXYAjoppejVty8+o2Ea?=
 =?us-ascii?Q?CSxt7IrW3Yu7euzKXWyXtHgaHJcPG9PC9+UPSPVKCJYu157zC68Y3P2BGw+q?=
 =?us-ascii?Q?j1+JBLTY+0XFX51kXQN6pinsJNIhABol2vfwOahE3f5eqgYXwsl0dOy/bwhU?=
 =?us-ascii?Q?OFlV0pIeKwGSpNBn0uaOWcz99L2RoDNiv5XgDOQU99cySrjpTGchwAwOnKQn?=
 =?us-ascii?Q?3+koqYvE3pQyLuF5fJoxs41kr8+kK/WksnDdA8iCj/vbFpu0OgHNR4DS/guo?=
 =?us-ascii?Q?gT5XICMbT/bnh35dt0gckNGj0IcydRM9MnYpcz/lvTSqdEm9Jg+2zwN9y4Ak?=
 =?us-ascii?Q?4ZrQnIaFWpLh6c07YL7UA7/yF8M96gyIp8oE9lp/unUdBJ2n6ABk/LNwMtkV?=
 =?us-ascii?Q?TiX5v8jB/XKrDNJyPUxEkZJPhxhaj1JNNlcu3fXPXYsgahNhhcQWVPQIPxYZ?=
 =?us-ascii?Q?A7aer5RQpU+aOVFsHUVV/0O6fIHzD7jqMQwNTFeS85iFHm9yycYDC2XAsdaJ?=
 =?us-ascii?Q?NHqxk8ZOZrv6+241hLSpIhf7yPd4Mrxr0re+XLVNrso8RkVB+3h6shog/Fao?=
 =?us-ascii?Q?MKPPrhgXtyqnRkx0sR8FJpNRK/c/NZM0D9EFtDnZQiOS6SVGqSThRwKpA3fu?=
 =?us-ascii?Q?G5lWyVD+jX1VtU4EQD6trTZrB1QbLzyx4JoVpaPyWwj40GS6n6HVHw=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(7416014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?XRxQrOV5ISiqTn4gJ6IhlttCTVmzIwX4fBqAYXvAyiwY28fAYV/FsKAtJ6R5?=
 =?us-ascii?Q?fYgXRYe7FyHAhDFZF2saFWQyeXaRHG3HyWDhmbj85RzWC2XMHqAACCcxEOXJ?=
 =?us-ascii?Q?9AeLI+qauJf9o17rb+A23Fvrhn+0sWYDm/27A26HSE13dfnALeDTAl9Mw2wx?=
 =?us-ascii?Q?B5jM84u+ycHYsCUO35T+AkPu4elwxDn2z8ujBoPIZ8weGDKJ9RI8JXm8KUKn?=
 =?us-ascii?Q?CLBpsSibLqO09M3XdbUz//1Yy9ZmEaYPxfB/1M2FFA08KDqQ5FHhLvnP7ftK?=
 =?us-ascii?Q?mYmK9nm5QvdfKJXfO8gYk/Skh3BLOfbBXTUBRskrauJ07HhqptInpSrWxHxI?=
 =?us-ascii?Q?l0fHrgl40e5mDiWANTTn91m22MOmk2Lamuh5aQ2QYlMl+yczsvf/NhDPWkep?=
 =?us-ascii?Q?e/pjKyOLdg03vVNFRsAThbbPPgO3C31wdGbEnl59X5oSFCjDJh/HLYxJwmHy?=
 =?us-ascii?Q?tIz1uxvADEXZP3B5iJ5X6xbWns2UYXXMP7r0vj9eHqFAUlYLZBeaaViLv9df?=
 =?us-ascii?Q?8qOKo7XMehPE/k7vIPVZKC2I0I6bYRzi9O3uOBiLiOiaUEhWXnPGBgi/umfT?=
 =?us-ascii?Q?I4ulZoT21YFQ2519Y0cN80YUI8a/Wpx0SML1rtTxAkCYxmdyyZUzdLcLMzIr?=
 =?us-ascii?Q?ylK6wf5oDlr4GO+N0opKZpxFXlpJdkB/b8JWw/aJbLublBjSBBoO7+uzZ2LH?=
 =?us-ascii?Q?jvMT0Ii5Z/nUGgo+KgPq5iZiNyREVpInlYJsOSPv5qo2aepL/Mp+Zl+k4SkS?=
 =?us-ascii?Q?84nAGRt6YkosyF3yB+bzGxuwKpG88jylsRs46NOsWktWzByGdQ5FexsU2AoN?=
 =?us-ascii?Q?HZgazQDYlJJPbmMwuhxtmUeyo2CBJUYehQznvNP2W0fkQah0GLfjrkPpWS3g?=
 =?us-ascii?Q?auNR0kItDhQAghbb2VtDIHkUKP7P2K0tkETHGA1ImaA5tIsvAaMYUXMJaDwp?=
 =?us-ascii?Q?akbbUyR75oCxHLljDkDxpil2TGqWTOSYJn/m4SGt0pZpm8aOF/diRuLU3CHR?=
 =?us-ascii?Q?e3iCNWrx6LtDtTsXMmMIzKgf9JBGbeYldYGmDv3bt34wV5gM16JM0SAk2sH7?=
 =?us-ascii?Q?1DugDC027XhAlvS9vEgVBfYLy1Zc4u8ZgvB0LGf911Hjk/yKZIHcufygRptQ?=
 =?us-ascii?Q?mo6FlN+i+mM7JsDC3RA52Xig1GOtvG42eFnyarRCP4gMa+4c2eXaEA/7wPCy?=
 =?us-ascii?Q?PHekQ1YkFDqpYmqLhF9YitD5YTQBUGXnrMbfhDxQAIAQZLmZAW7t+KAy9NxU?=
 =?us-ascii?Q?YTcZry6S+k/iOLqkGJohYF01zDm+dwudJT1xbChYtGNi52c6+ONuQawX67ej?=
 =?us-ascii?Q?MH6aVkTF9NJMDtrdk81vcL6ArEmMj2d9Y+cz5+HH7nrE+v133BOdmhuEux5c?=
 =?us-ascii?Q?u2md5rMnwlPxK9wdr+fqjIGmHCRnMtYH3LaCXmDqXmSUWUvADylKRqfpgf5A?=
 =?us-ascii?Q?h4AkDPCdIWdGl20Xt6ZU3REEdr3N4B9n7FFtyvNHed1+Qi9ea8AIpov69XJC?=
 =?us-ascii?Q?fT66TkyK2jGxft+sq9uQqmY80PL1Jdzf9QSGqxbA/+vhDHZ4D76DP17umg8q?=
 =?us-ascii?Q?m19YLK88jurmEMuLPYgWEuN70yJj2jZMu6vpRqr9oipKsQdlJuih+gT5MokD?=
 =?us-ascii?Q?e8040/WANyjcVvl78X6+lRvmFGdeBMfQyrqc1/mgvixyyFBD0E0yFba0lFQE?=
 =?us-ascii?Q?sIP1ttygdT58GfPzUcaZX3sp3WwduqeHlHYl4/WZ3xgo0OA/Xl/BGTfUnBui?=
 =?us-ascii?Q?Q+rU+VWHjTHGfhuA47iKU9zA8YDUu2U=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	tiCn66Cd52QxYtyWl/R/EW+QwKWMkKCyuDLiN/m7CvwEeMxm8W7NwAd79dSRlgkC5CcDyHue4iO8FMxCG+xdo7FoxluIE6aOtqwEEXdpM/+orxuEAXFZ3h8YOwR8qNLsE8KY0uwAEon2aXVBzCk6uJRufI8OJXVG89lgiCjvnXSa74dMSluYDSPpXNeF4Xr8XDNeWcuEAm91nr5/K7BunmIHi1mWfDDV3uJn1H1MLPEgO2gfHzM/pTMryakQnAhaoXYmmJhIRCb/ATYVtWsPp20Kym0xzO0P/TxQHTEYfeopfebmLsczMsfK6M+OPgdb4OOkPozuyXvI8TKyHf84QODGz65bpd/XBYozZb1SCEs1NUVzUWtNBX5iH0aZY0+RuAl07TKykwSJrPevECIqnq01zDCfIu9f8HOOZrlvjXJU3x5YX4iSpfkgI6NzUEW3EFqkb0/l87cpsSYhDBihvvzPu8VD31R5A1sVwuCIA9A9ojVv15RxU2GByF39VkLy83QldRd9oJtqpmFqqdNmeP+ggHTTMNEI1MLLMRFNvmf6x+EVH3B7agNxrMHI/Ebnr5HFHtFSvzQ/Ax3gBhqTdmpFcHjTCHjCL1O0yTsNT7E=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 071f5b56-51d8-4c52-311e-08de4f8f497f
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Jan 2026 14:56:36.6277
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: P/XRCwKwAdo3oXveRCYuYPM6+hi03nX8dCGR0sHnOMPsr3MknbeXrEJ6vmJh79zTVi8FCafuVBArJYGzGtMSx0l9J/OLYL7Du+UjSHFSbnU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB5729
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2026-01-09_04,2026-01-08_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 bulkscore=0 malwarescore=0
 spamscore=0 suspectscore=0 mlxscore=0 mlxlogscore=999 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2512120000
 definitions=main-2601090111
X-Proofpoint-ORIG-GUID: y-8B9GV2jH0HtRo3CUzDpY0LxE4rf6Hy
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTA5MDExMSBTYWx0ZWRfX2eMttzurUE3T
 koTWGGifabP8Cb8Wf5od3+MzxdkQeWyT70x9O8ppkHWdafZ5omoGrJFvPsgVktPZxu4kIVjmeKy
 qLaX7JIcx+2yrT535pPSPSPBmnNzNUHweik0GfEX16FRz0H3zCoh91nT5S6MHH853/2dkyd2KAA
 Gg3rDvdXevUsjE9l+8AYdQZX8eDG0hI4V6nNEaid5Zl0+wQOz74TRto4PubVnM7mpPGfG6ssjeR
 JSv8CmCIXslokPlD25gz6Culb1sDVI53HN/SCKGKpFMM30d00+y+GHQo4sTec4+7OJLoU5LjoZh
 NoSMbJkkS3DM6c4x3NYsOBSRsMfDMnqCv2xeIdBJJrSKWQzPLGavlpSKYqRhWd7k1PPEST9+ybK
 qwKIJp6FLvAVZv739PswKAZZFk/zcqD0igs4qJ2MEaUAMM3sZUx8wyAVsVYffjDJtVZlGL70Fnh
 YWiDdPyiQtHhqXf7OQ9ax40XLEc78loZtiX9W5Ak=
X-Authority-Analysis: v=2.4 cv=P4I3RyAu c=1 sm=1 tr=0 ts=6961172a b=1 cx=c_pps
 a=qoll8+KPOyaMroiJ2sR5sw==:117 a=qoll8+KPOyaMroiJ2sR5sw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=vUbySO9Y5rIA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=VwQbUJbxAAAA:8 a=QyXUC8HyAAAA:8 a=O0YcDbr7s2kWlcazcuYA:9 a=CjuIK1q_8ugA:10
 cc=ntf awl=host:12110
X-Proofpoint-GUID: y-8B9GV2jH0HtRo3CUzDpY0LxE4rf6Hy

On Fri, Jan 09, 2026 at 03:29:11PM +0100, David Hildenbrand (Red Hat) wrote:
> On 1/9/26 15:17, Lorenzo Stoakes wrote:
> > On Fri, Jan 09, 2026 at 02:59:38PM +0100, David Hildenbrand (Red Hat) wrote:
> > >
> > > Nothing to add to the above :)
> > >
> > > > >
> > > > > Hm.
> > > > >
> > > > > [1] we have 0day now running and reporting problems mostly private to me, I
> > > > > just didn't have the time yet to closely look into the results I've been
> > > > > getting because there seem to be some false positive test failures in some
> > > > > unrelated tests.
> > > >
> > > > I've not seen bot reports from mm-new at all, so this is news to me.
> > >
> > > So far the reports only go to me while we are experimenting with how helpful
> > > it is and how stable the results are.
> > >
> > > I skimmed over some results today, and apparently it found that the new
> > > memory-failure selftests are a bit shaky (fail in some environments).
> >
> > I guess this is why Andrew isn't bothered about me no longer checking the
> > branch then, you're taking over that role somewhat :)
>
> I consider it just another attempt to catch more issues earlier, before
> patches reach mm-unstable and end up in -next.
>
> The build-bots + tests can only catch some stuff. For example, 0day
> runtime-testing is x86 only and only tests some basic stuff (and apparently
> some unstable tests in their ...).
>
> So I don't consider it any replacement for manual testing like you do.

*did :)

>
> >
> > Did you not have the bot running for this patch? Or did it happen to not
> > generate a config with !CONFIG_MEMCG?
>
> 0day keeps reporting some issues against mm-new, but given I am on PTO I did
> not get to check all of them yet.

I'm very sorry you're forced into working duing your leave period to keep
all of this going :/

That really is a sad indictment of the gap between Andrew's claims that
processes 'work' and the reality of _how_ they work.

I hope this adds some emphasis to why we need change.

>
> Skimming over the reports, it found one issue reported on January 06:
>
> https://lkml.kernel.org/r/202601070517.0yxdw4WK-lkp@intel.com
>
> At least I think that's the same thing from a quick look.

Yeah looks right.

I mean I'd say with the proposal I make below this could make mm-new
(renamed to something like mm-early-testing) quite useful.

I think that's a sensible way to go.

>
> >
> > I mean I ask again (>/dev/null) - why are we not putting patches into
> > mm-new randomly this cycle (I mean also previous cycles but on fewer
> > occasions)?
> >
> > Surely even if something hasn't had review yet we want to test it no?
> >
> > And with no information on the process for moving to mm-unstable, I guess
> > we are relying on some privately sent reports being flagged and you taking
> > the time to ping people.
> >
> > This all seems pretty broken, and you're busy enough as it is.
> >
> > To be constructive, FWIW, here's what I propose:
> >
> > 	I think we should rename mm-new to mm-early-testing, base stuff on
> > 	mm-unstable, and have a clear indication as to how things flow
> > 	through.
> >
> > 	We should then use the testing to determine stability, drop
> > 	anything that's broken, and move stuff to mm-unstable after a
> > 	certain _set_ time period where we'd expect bots to pick up any
> > 	issue.
> >
> > 	Then stuff in mm-unstable goes to Linus if it has a sub-maintainer
> > 	tag on it, if not it doesn't.
> >
> > As of this cycle - mm-new is totally worthless - and if we don't move to
> > something sensible like the above we should just drop it.
> >
> > Nobody outside of a handful of people in mm even know it's a thing, aside
> > from those I encouraged to use it prior to this cycle.
> >
> > Overall I'm very uncomfortable with the way these processes are pushing
> > work down onto people with no regard as to the volume of the work or the
> > stress it induces with seemingly no say in how the processes are done.
>
> Again, nothing to add from my side :(

:(

>
> >
> > Which is why I'm personally opting out of reporting mm-new issues and
> > significantly reducing my review work until there is some movement towards
> > sane processes that reflect the needs of the community and importantly -
> > those who do the review.
>
> Shame :( But I'm afraid there is nothing I can do and I can perfectly
> understand your position.

Yes, apologies if I'm adding any more workload to you during your PTO.

Do let me know if the workload gets too much and we can split things up in
THP at least. While I object to the current state of affairs, I take my
role as maintainer seriously.

I for one at least can say thank you for all you do! :)

>
> --
> Cheers
>
> David

Cheers, Lorenzo
