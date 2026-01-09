Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF37A2DC789
	for <mm-commits@vger.kernel.org>; Fri,  9 Jan 2026 19:13:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767986039; cv=fail; b=bEuuHpJhncq5EO3n9tc4yeoD+fC4Bk6e8F0H+oFbgiD+iIZ6V2rVpDShi/Ze5GVzRRkpmpxdiWgD3WVcy3RgM5u5x2Z8g/8FHcQrfRy4M/OAabxnz++cDQ39V9J0+rFAQq3v42P1iv56lsLHskgSWCRqeMK5J/GFkWG3baAkf8M=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767986039; c=relaxed/simple;
	bh=yr+HQ2dmSudCv+jTTvk43licI/iRBdRaPWG5Ebkb3Ao=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=WL1b51VZl1h1QTxuBERCkbxqNEdJv0RpcZcWfwgnjXr+VvDNDBU3YtC5+CIYJxkX53lBXywZD2SLfhq/MEANxtzBtXuc2OARzG//UG8p+hmbQwqB0BRIH431cUqNCwL7YNDnQZtP1n9roDcM34X5WIbWBi9bSuWHtfZzcrRJRUQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=npKk0nlQ; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=g4gCWGMK; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="npKk0nlQ";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="g4gCWGMK"
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 609ItPtr3303386;
	Fri, 9 Jan 2026 19:13:23 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=j+c6aaJsouFRQlnOCf
	+kP/ivz7qLCtjebCPVq/GcvXg=; b=npKk0nlQxyH31fWUNUTM1QMUnDnxQmkM6B
	pFbQA5t9ONZXz/rUhkISqCNNP7VuJ+l30qLwNRzZPUMYsP0+7CjZ3PV4g7R/jqoq
	QriXTzBZWtbeZ0yASXWpYOtwsU7BChxuBFVr5RB2dsNj3cTnO/EIM8CXb7aXaorV
	tPdWH6YtwUk5/9/qhtNWLB0Fr6f6RmLT1xb4bM0cjUkSEbQYdzxxQEa08Q0iQCol
	XJeN4I47upouHCmd8mkTzMqBf6OPIQCFXaaruKycEzHoimuzu8aVs+rIUPEaRIq0
	R+nS8C2qr/lFf3iDuVx+Z5J75TdBlfPX5MgW2/6sWIgYZxdOQyOQ==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4bk7cp80s1-2
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 09 Jan 2026 19:13:22 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 609J42aq027384;
	Fri, 9 Jan 2026 19:09:47 GMT
Received: from ch5pr02cu005.outbound.protection.outlook.com (mail-northcentralusazon11012062.outbound.protection.outlook.com [40.107.200.62])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4besjcf1v2-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 09 Jan 2026 19:09:46 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=bWReIbJeS0CVZzMVZVk5nNq5A7QrsA60Vr9c+0PFWS1UvO89zqImieJ/tRrvwPM42CmQtpqPnel1cypxioeSmsnIN7EP8Qvo8Yb3bXihc3CKzVGqqLkpHj+5UWkF9MvPrOoTNhwon2NSIcGsCSgFRHue3BYpFi1h2IFshFKkS2f4iEnWIrDQtHo3KBM0oLeUorMxHfoettSIFzVssY2ItJysdHyq419SU1Lz0eof0wOKK2SrbbdHBu5M78Q2Ejorf69coiobTJGhYw23xfQi2zopxO9F3786gwtjvlqqsXd9kSi2XcHVzgdf3kl1Rwfk2XulnRZfMtgiiGnpRh6NHw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=j+c6aaJsouFRQlnOCf+kP/ivz7qLCtjebCPVq/GcvXg=;
 b=omsQ3qS/XnW9K/0wNCxaZfyEO3M9bsqUSdk9iSmXGYcBI3QfeYROa63QEeqBSn+nOVm+F10Z6EkZ9y7H2I9SweOg7bDdaGsgBzCmWXZzPMfdeEIPYolN+1E66CDIdZdIcm7uhgmWunvanD/fylHLc5VJ/V6v7VW0K8ZhG8Jy4WBUUCJVe2BUEk8ks7+o3JOKUc92zaQeOtbvk3wR5iKG11/jO7/AhjHs7hHGxEWqIlSJeOOe6hE7DUTwj7MhWnPy1peex59I12MzwyETNTufyZ5hHNUHMtCjT4SzVZa8kYmn05Ndb0ha/aw1xQY6wnc2dPl1Tbx9i+YX45X/ajI1qA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=j+c6aaJsouFRQlnOCf+kP/ivz7qLCtjebCPVq/GcvXg=;
 b=g4gCWGMKzTSChX3TYKWjm3DIiFLKjirdEF4BAUJnSUP1WFzvHVHSVFr+2M2T6GcR9t9RXFJS3M/O0WTPuartEeslJbdxk38u21851sT17FMpsyeObOaY95w5STGKN6cH+5qYfD5wsC+VYzsAhQgt1bfZfXB8cRYKFfktXWqpL7s=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by DM4PR10MB6767.namprd10.prod.outlook.com (2603:10b6:8:10d::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9499.4; Fri, 9 Jan
 2026 19:09:44 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::f3ea:674e:7f2e:b711]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::f3ea:674e:7f2e:b711%6]) with mapi id 15.20.9499.004; Fri, 9 Jan 2026
 19:09:44 +0000
Date: Fri, 9 Jan 2026 19:09:44 +0000
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "David Hildenbrand (Red Hat)" <david@kernel.org>,
        mm-commits@vger.kernel.org, zhengqi.arch@bytedance.com,
        yuanchu@google.com, weixugc@google.com, tballasi@linux.microsoft.com,
        shakeel.butt@linux.dev, roman.gushchin@linux.dev,
        muchun.song@linux.dev, mhocko@kernel.org, mhiramat@kernel.org,
        mathieu.desnoyers@efficios.com, hannes@cmpxchg.org,
        david@fromorbit.com, axelrasmussen@google.com, rostedt@goodmis.org
Subject: Re: + tracing-add-__event_in_irq-helpers.patch added to mm-new branch
Message-ID: <3e112566-fb23-4a6c-8c8c-55c4b809d998@lucifer.local>
References: <20260106033842.559EBC116D0@smtp.kernel.org>
 <3a96b65e-49b1-45f5-a36a-77b38cea62e2@lucifer.local>
 <20260106124930.827da463ea281bb392a9843d@linux-foundation.org>
 <4cccaf21-c78e-4017-bb95-29a401d7c3a5@lucifer.local>
 <f916c970-33fe-4147-9daf-159ba61a0302@kernel.org>
 <8b54e314-be57-4fa0-bb53-e9a0adb7d969@lucifer.local>
 <c8b4e2db-def0-49bf-bf04-5dee7e73711d@kernel.org>
 <573a3645-e98f-46de-bb94-ba20daadfaed@lucifer.local>
 <20260109110028.8567b1a4a5cef096c25e173b@linux-foundation.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260109110028.8567b1a4a5cef096c25e173b@linux-foundation.org>
X-ClientProxiedBy: LO2P265CA0428.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:a0::32) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|DM4PR10MB6767:EE_
X-MS-Office365-Filtering-Correlation-Id: 54e5ffb1-fd92-4451-9199-08de4fb2a624
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?Ac/3mVbzfqJ5GpfCyYWBVctvtjNrXL8fHFT2v1WTrfefahJpLc9I0MGAmr2/?=
 =?us-ascii?Q?zUCgEZ7pMSssJR2pKhlTneEAYDtMGiPdGKUNAOCfg0C9DRJHr3KQj7cgtO0x?=
 =?us-ascii?Q?LfYiztJyunwpuO6hel8Jvg2KTKHtA5PkHSIuHN2C1raDGpEB4UZjEcRtaZ9q?=
 =?us-ascii?Q?s3/sJ7Cp8X9Ku0LjUB9jgBcgcr5csz9AZkFEjxt2VXRrz5DQIOuaCUlnn7Ak?=
 =?us-ascii?Q?suGMTNniZDDRInM+1UWTk5XTzELO0ozjvlHl0wagp20SzGv3pLFmdwQqKMeG?=
 =?us-ascii?Q?aSD/zOoCdy6fP8dIW5qA2Bl5L7DBLcPL+GGz8qtPMNFOIDWr2DymXGLwn4Zj?=
 =?us-ascii?Q?YiqdQOkqSkATO/ZPtz7qYoAOkVEKbdeIqFXrzfYavZdQhC2GQDZ7shbaM6hV?=
 =?us-ascii?Q?HOaEp9ukiYXWa8D54w7/wsg5se9pw2pJbhmMpxrLbwCcROQv4CsYytHnTPfE?=
 =?us-ascii?Q?fdrZapfG09kDecjkalj5dL7Kr675q3cKTSCAe1VfQ+KjuX4dsyKx9o8s4O/T?=
 =?us-ascii?Q?75JLkJjDQ1ODEpij7cvL1TcGWe1TN7u2zHZcuUvRGBw+A6MYpts43XclJRHT?=
 =?us-ascii?Q?HrnFLMUzkNIjJqYxtjf9MBaY1EAXo3sIngO8hER24pigz9wpA4829l3siscK?=
 =?us-ascii?Q?qG9FokH+zXvqsVOKjsvpCzD6WbW1idUvummpVihva9H3Cvwi3V2xBHYZteDj?=
 =?us-ascii?Q?X4yQmCsQpnWC/Hkes/sZj/e8f7O8h6GFoN1Xw/CeLDccIxQCNqAAWNBF5Yoe?=
 =?us-ascii?Q?5/oABR1tpxiqPgdIjtM+p/u/i0i9ixOQvKABr6gYZFji/yAJ16jpvy0H8qkl?=
 =?us-ascii?Q?1XLZ2A28LrJpB+A+QDm70bqP7UcCA/vbgA7pfyLGWll0m31neiFSWIL8XcFd?=
 =?us-ascii?Q?+VNVtJz+1k1JCKFHRi/RoaCOioANmG5MuyAEvzSDidZqjT8j5TKN5cszmVRN?=
 =?us-ascii?Q?LG1qNRu1TnfZ3nTQfrXwSbQhL4r1dkRbo8BBOdxpVJj0dS16oGJHtMcoNmsz?=
 =?us-ascii?Q?1J6U9N9P4vEnpKOD265yX/LmAnMFMlQ71p527SUeyUnkih8Bfhc/Yk3NS1KI?=
 =?us-ascii?Q?J33nUYXA35bQJ/W6CNmdk3KTz4USDGHoznPbbX+hQdiYgCr6vifsCrI6HapG?=
 =?us-ascii?Q?5IqclHFgxt2HgFsroHpLJslJYDMpmQCgafFOi7Vtve2yAc6EA4mLkLHqFpvy?=
 =?us-ascii?Q?SAffyvaYX106e+yPnu4Aoge8GigJ6u8MQDT6iT8TvZskgITAcahI9QXTeaZo?=
 =?us-ascii?Q?FsIpXc9PLCwx61vpsof9UNs2Bx/OgQcT3vX/tTQFYfylatN2yMREGPN+HwW/?=
 =?us-ascii?Q?7jN2nOgrPUsMdQ05q2e5/locmXXkiSmcoHhbXyYL2tm6HHRk+C3n/pnwahiN?=
 =?us-ascii?Q?wXP0evh3P9AOX0eYOwDytLT7UOTO1godppxHLjyENpMNOxP7LqLTxFNYciKo?=
 =?us-ascii?Q?MfexKNROKn3iFZQbkGTtY1JUCTyD4583?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?bpjCNEgdUsHkJEKqwdJn4lIFGluIgRYKtM82Q+GWf+uFwtnTp7YXQ21spt84?=
 =?us-ascii?Q?U91uR5JfZDEs0PqYrnu1DEkgpyR6tS8dh1qAesTGDBevgnpysVbhwY8SCY72?=
 =?us-ascii?Q?pnGyF9V3HkpWTQE/cRnVwa7PVnXj+DXqRyxHdFr5aEeQT0ThriB/k/R3gio9?=
 =?us-ascii?Q?/9zrsDsagmnl1ysiKX8VqPDsaqO+OChS3NrENb0b22CVdfzVDxmGh+pYqg88?=
 =?us-ascii?Q?bmWwN1L5rbUVIH+vvNVIRVmwZ9RleWTwHqpYiT5MWU61JtLogBaJEOQzODSX?=
 =?us-ascii?Q?vneh+1zaHsnoUMUKjUpuW++PyH3CPYH0ggPiAQcLFN5sIBz/Ffkq9QXWHgPp?=
 =?us-ascii?Q?biEu/1jH4cSlPkyNx7aYhHfTK6tgB2u+aMr/Qd1JMStkvXvCmFaXOBX9hyGE?=
 =?us-ascii?Q?nK3zPkaPecKHgAdSxhu+a3Rvc+K78WrQ6SiODZEKDI/g49gw2Bf6zn06Ogev?=
 =?us-ascii?Q?KDYjTYYnBauA0BZQjxsIWcNN2FhnRGZ98Ml2+6n2kVwtYLxDdseV1upCik1I?=
 =?us-ascii?Q?ux9QxXLboBpGzLX/gxwO1IZoA2KLTzlOnwxFsHRJ6SILQV0nfSc4Qut/m4h5?=
 =?us-ascii?Q?vQ3aSVaEzjOCTYh2E7/uxuKKXS/e1OL+rDZuVLtdLcB27Pjjo0XDHoWacWFr?=
 =?us-ascii?Q?30IkGcOgtVe3e2TxZOB6Jh3tti6T/RUgzzk8nu/02U+lZ/WeSlvcKf+//o+M?=
 =?us-ascii?Q?YVqkRWSwvrCbDIN5q9DnOcL2ugxWKfAIJjK2AU6lu83wAZ+Wyc8x0QddhYiS?=
 =?us-ascii?Q?gm9Mc+s2aIp6DSsonLJk1cXbFGyzi/CdyFDbMzmLelhVloJ5krgVzrChxG0t?=
 =?us-ascii?Q?lpG7BGtHCNhnoU6fP+Qcuet85hUbO7toPd/uvoVSowYuGeogUhNqYWlmNR/s?=
 =?us-ascii?Q?qHDeRaQAHRAQjghtRfbFag5odFk8ceT/Ey9USIn1mBXlxd3kzINJyeq399Qr?=
 =?us-ascii?Q?Rx+sQ8qNRnJvm3mwRGkjn6FAiYCfxZxt72wO4DVqH8GnSHGqVP+V512GWSPZ?=
 =?us-ascii?Q?0S+kPDnemFfbHGNM4NZuhRxsmLBivI+np0PuZkcm/oHq0KsrPpMu1Exk01/c?=
 =?us-ascii?Q?RFqee6eZbI48zMTCVYM1ENe8YyglCvHLFS9WqW/ulY8jhgIZrjcfLB42rWLU?=
 =?us-ascii?Q?2QGXVCaECS/vPdGyNC9qTkXDBtvtl5NIl8NbvukUDI3k9fJJj3YjxLhCtCpA?=
 =?us-ascii?Q?Mfc8eTRlMa3ZGU8it8D+AVwp4YzddyOLOQ3mhvAO6Oa8hNoexyvBkCh1GO2i?=
 =?us-ascii?Q?afCm8nymPPSEDwEL+sWAn/xPSsLJUi3cI24kyARmwYeibcdx0CEj0mVcTmmh?=
 =?us-ascii?Q?+EuC5342L2y4dLiOveQ3ECwFD54Hboch7iTdr/D3seV/XBXDFoE8NAnqjPJj?=
 =?us-ascii?Q?XQuKFNItSUZdrlXv/UyYDitM9pA+93tEybS3+6hNat1G3WE3WfW4qcuVpXCm?=
 =?us-ascii?Q?oazivHHA4bL3I+epP07AjPjOxDT0hdZorlfGsXUu5FWVxpeeyFZs6qIle10X?=
 =?us-ascii?Q?RDAavYTpB8RpO5KJEMQh57zsRnjhak1RSbjpssb+zTFxdTLLm2ykDWJJtD0A?=
 =?us-ascii?Q?sh1LOYOO75qG1X42eRaqIt1hg7Xi48Oo9yuHiARyGwi0C4hAulWaPE4P468Y?=
 =?us-ascii?Q?ih2Ti41JyebT9xihJpvJvs4Q5fmioK0s8xLnrhAgahJwcgAXDcv5hjZVo+Hu?=
 =?us-ascii?Q?yqicYdqA6YUnnqSCnzb2ZcvqahTbHbCWVZthYo3Asp0lwjB3e1mc5kR/NuzJ?=
 =?us-ascii?Q?aqyn5qUpHiJQl8I/w++2tm2xeHb9H2c=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	QY7lBbWcOicl9txW9UqBAI4TeCsyJZYz0Qp2Pw3KBVBA1CflTi/6xdrlAHNrcXm1DflvCLpmnM1KppSQihc3SlWG7EoMMnbHLtQWtz9v87R2/dZEUdJ+IsRlmmdYb6WyghOJcVXBLunJ7l+bAFWt3VGtMcL53jkzkYHdG3QmHprCFpJxW6pTlZqriH2WEaoxSVmIsDD8M7D1918xiruzC5+KGGpb0RiPm+eyTPmE1+xNbEIm/PXmBD0z4h29mx9XdwY7JwhJERlFV5+1kQUXBMRm/DNwUY1k6JP8Th25S7zhyvYCQAa/kT3+G6ZoWGL3xwTgwDDRYT9sNH12qof8V0Es7+dfclD76Pov2RV+5+R6GpWlH2B8IygPn8vH43rhHC61bSgoaNZuo6wlTD7cN8NwUdwb8+6wGcj/LA5ujkEElklxatt3LAbO8kk/nLZYL/hgLTCkpYZXEopUqP68QTobUpiQHx38YVa/UWJh/f833uW2JaCR57OCKQKckkajqsIRflh22rsAuc8vcDdr8djp4C6OUgLq6wNXXqifxZXolvUiZIpxlZnjvR/XQv0f860quE+x2fOSIdC7JB1esqRXQkVSMMJDpD0hPAbLaPk=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 54e5ffb1-fd92-4451-9199-08de4fb2a624
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Jan 2026 19:09:44.5033
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Bj4gLrAK/jPWgL+hsnSgBGWTi9EVnqi5IdupJXM6aZgzX2eLLE1uwr4Sz9lbZksSDgVrLUWvlT+qYFnklq7LvEAitfS0RvBQPsvba3PkLYE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR10MB6767
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2026-01-09_05,2026-01-09_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 bulkscore=0 suspectscore=0
 mlxscore=0 spamscore=0 mlxlogscore=999 adultscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2512120000
 definitions=main-2601090148
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTA5MDE0OSBTYWx0ZWRfXxUW6PIhzfoc4
 NlQykPlh/V1QfU0RrbWUcY4QQ7HvCmJoY24PCVShjKf9r2KU3ePucrKlUQlFPo0mO76XeWlkivE
 MRPoQwfftuKsq3c4RE8An0bHTkggb6j/FeOWG7y2jChhLHoA5pe9xdLZ04Vhk2ZATzAjlF1ccpB
 br9vFjSCRQmIIxkUztjZpdqg4VbEXCXHJnwC7MvTljqlFWtVAY5Exg4YaZoP9DOVz3EGSkYljYO
 BdeAPPicahyGJrfdcIp6B7PwJomDNSSQZtEQol2oFQmKiyySOsrt/Ibf/C43+E4Zvgj5x3d4Jos
 t4nknGRb8QNhOTJ/u3SNYxEhhACTh52aeHfdxgIHlfKh8y0brT97dzH/XZwlR+PvqyDfvmiqMDH
 0OmjS1icx0Wbb+n+D3UVLHCYsnTRzVaHTSCSNOFTg+k2j6PMRjLF3JukrgM/RRInjHz5TFiVS4N
 l49uMNNFtoVL5yxk+mA==
X-Authority-Analysis: v=2.4 cv=c9KmgB9l c=1 sm=1 tr=0 ts=69615352 cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=vUbySO9Y5rIA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=yPCof4ZbAAAA:8 a=ZcKSPZsMfaUvQek0EvwA:9 a=CjuIK1q_8ugA:10
X-Proofpoint-GUID: eaTKq3egj7kvEASVp28vn9v5XmAYQcpG
X-Proofpoint-ORIG-GUID: eaTKq3egj7kvEASVp28vn9v5XmAYQcpG

On Fri, Jan 09, 2026 at 11:00:28AM -0800, Andrew Morton wrote:
> On Fri, 9 Jan 2026 14:17:19 +0000 Lorenzo Stoakes <lorenzo.stoakes@oracle.com> wrote:
>
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
> These are serious matters and they merit serious consideration.  This
> takes time and I shall not be making half-baked statements.  Please be
> patient.

Thanks

>
> I've seen some buildbot/fuzzbot reports for mm-new but they seem to
> have stopped.  It would be good to get this all going again but I never
> know who to poke.

That's something we can try to dig into - David how did you get what's set up
already going, or did you just have the URL?

>
> > To be constructive, FWIW, here's what I propose:
> >
> > 	I think we should rename mm-new to mm-early-testing, base stuff on
> > 	mm-unstable, and have a clear indication as to how things flow
> > 	through.
>
> Yes, let's not base changes on mm-new.  If an mm-unstable patch needs
> work to integrate into mm-new (unlikely) then I'll take care of that.

OK thanks that makes sense. I wonder if a rename is in order then to highlight
it's testing, but that's a trivial thing obviously + doesn't matter too much.

>
> I'm working on documentation for this and much more.  Hopefully I'll be
> progressing that significantly this weekend.

Thanks

>
> > 	We should then use the testing to determine stability, drop
> > 	anything that's broken, and move stuff to mm-unstable after a
> > 	certain _set_ time period where we'd expect bots to pick up any
> > 	issue.
>
> I like to move things up after 2-3 days - it's all about protecting
> linux-next from too much damage.  I've perhaps been a bit slow with
> that lately, holidays and all.

I think with mm-new/whatever-we-call-it acting as a testing buffer zone that
makes sense. It then very simply becomes a place for checking stuff pre-next
visibility.

>
> > 	Then stuff in mm-unstable goes to Linus if it has a sub-maintainer
> > 	tag on it, if not it doesn't.
>
> Sounds easy if you say it quickly ;) There are complications.
>
> Much more to say when I'm ready.

Sure, devil's always in the details.

Thanks, Lorenzo
