Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 062FC35E53C
	for <mm-commits@vger.kernel.org>; Fri,  9 Jan 2026 14:17:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767968276; cv=fail; b=KneZCnCQFzQMPrPfBxb/vwUxc6GdwPiFbfx8yRDJgczX30B0wEHnLdb3BOAPKP/smO1gfeKmVSS9kGJmd9KG8Z96veh3K/KwP6aiTQtbAgxVUCjFLpZwZ3XyGiY3rLwJx+DlHwxZFe5tzubGTTrEp7vXs3VfT/2K1l2cimJl4yc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767968276; c=relaxed/simple;
	bh=nHYROVxFFvvokyfS/MOcP2KgdJqysMvcEk9owLjjgvQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=L6THK8j/VyY0rIJE/nd+8D8+YdBLHRsx5WmIcXCdXTiC9WxE/aAlcSrf4Qn4Kn8MIZdW05s7a1zQWaUPMCsNRfm0sSNTIli+JWTAbIbXJRSaHun1+GNFaaUsIOHVkQjKioWmfaGobdmSvjoOg7VH+9x6RWT5/JBjK+LdwUBtDAA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=lkkJ44gQ; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=s78u7VDD; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="lkkJ44gQ";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="s78u7VDD"
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 609CfGZ52675800;
	Fri, 9 Jan 2026 14:17:19 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=EFRuuS1iISIP4/5quz
	d6g8YWu1AfKs8lVoJ8HZTrUiY=; b=lkkJ44gQEegbX6YPKEVIeVY/OaCxh4pQcm
	XHK2AZOAq4VwWa3nsl86fbAwXw36m5xXmU24eh4hzSp6hXew9hGPGWuGkznTe96V
	PQf90YkwxUXARf/yQ/JI2vrg0coR62RhnOl95kX23+aZvbu8CydZIHSvgXBXyNL1
	VbDQNbRWAsfgtPVhx9n1Lu1OinzT8jcAO+0D69cjxrbGjNKe/OX5meYvhLZQGOlb
	S/cPrj08jEXR1PqxU3RcmgG32S8HuT3HkHl2lYSq7uoZCPt+eB39sneyNh97CYza
	cYsxoQNb8aA/lrv9W/vOzQzmVAXZSzYIlZnfis7cmqSU9qX0BPJg==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4bk1w7846w-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 09 Jan 2026 14:17:19 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 609CF4rr008662;
	Fri, 9 Jan 2026 14:17:19 GMT
Received: from ph0pr06cu001.outbound.protection.outlook.com (mail-westus3azon11011053.outbound.protection.outlook.com [40.107.208.53])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4besjcd65n-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 09 Jan 2026 14:17:18 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=V0RzFzsk/Sw5wXdaQbKbU/m9vItLTbZnwiTPvumcqEA2vIJNfoYsMWropM8WrM9Fhpjum/iNFMRiravHTDKOW2QNmMnPExeXPTGF34W/VaCRpZxIXhxh7v7LqA/85OE2ef/dzvr0zWdS+L6O+3USmOKAPx1rRZ4Qq5hpad+ObLEY/Kf7eDbGzFY+9O2i51H8NSufgDe/yPYUV4mF7XUAQ/Tl6KtmTkRR5oVZHvXpovaViZtQQnzNPdLN4EmjGFiCsI1Z07zCv8y58os/3p21eUj1nf3+SGXPDSYMqpXcv57yrshu5LkB7GiYRegXYwOvAaLhY1QKwLDLuKGyqhY5KA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=EFRuuS1iISIP4/5quzd6g8YWu1AfKs8lVoJ8HZTrUiY=;
 b=Qtff7gdyqCiAC6Rvub/3Ou1lEt3VgJDG3ERtdnkcyXjn32qwhNYSl7CPGYEeb3HeZM2mZVRCF7uK73vLID514mPUOnNS26W72z//Vk0jIG5wTyDrNE488nhU84dqc/DiTfJcBKympOSWjE28gkTR+nqdE4A5Qrr+c81uZlKkxXn6mOckYk45cA3pWerrQzw0N732dkayOs9mTbfkchNQ6IhGDDm5sA7Zv31AQ/uCgVgFEb9qG9QJJ75xxpH/vupRFMTkdt2rbUXcLjjJBfvjQxXwyB8BKKHnUHbgL33u/XmtcMEhnw108X4cRQ39g1gSzgbQEqWcfXQ7L4zGXaLoyA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EFRuuS1iISIP4/5quzd6g8YWu1AfKs8lVoJ8HZTrUiY=;
 b=s78u7VDD4iW1YbnVwaG8OgtEz0K2ybSK1JzvV5aEFVdSxb2drZ0FW469DSDub8U4vtCJ2qL8jFij9WTU10mUXKBvRMSjQ1t9euPjRrq5cHyVe2myQVsTEhcAE+V+1G3qgKIl8nkOHM1OIn57JoyaNjxoGwycQGPs/w/ugGbHkQk=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by CY8PR10MB6682.namprd10.prod.outlook.com (2603:10b6:930:91::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9499.5; Fri, 9 Jan
 2026 14:17:16 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::f3ea:674e:7f2e:b711]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::f3ea:674e:7f2e:b711%6]) with mapi id 15.20.9499.004; Fri, 9 Jan 2026
 14:17:16 +0000
Date: Fri, 9 Jan 2026 14:17:19 +0000
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
Message-ID: <573a3645-e98f-46de-bb94-ba20daadfaed@lucifer.local>
References: <20260106033842.559EBC116D0@smtp.kernel.org>
 <3a96b65e-49b1-45f5-a36a-77b38cea62e2@lucifer.local>
 <20260106124930.827da463ea281bb392a9843d@linux-foundation.org>
 <4cccaf21-c78e-4017-bb95-29a401d7c3a5@lucifer.local>
 <f916c970-33fe-4147-9daf-159ba61a0302@kernel.org>
 <8b54e314-be57-4fa0-bb53-e9a0adb7d969@lucifer.local>
 <c8b4e2db-def0-49bf-bf04-5dee7e73711d@kernel.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c8b4e2db-def0-49bf-bf04-5dee7e73711d@kernel.org>
X-ClientProxiedBy: LO6P123CA0042.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:2fe::13) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|CY8PR10MB6682:EE_
X-MS-Office365-Filtering-Correlation-Id: 68e6511e-adb0-4688-7ef3-08de4f89ca7e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?TmHM9vXS+Hk+XBVoHZ6y3hgRnJpVy9uetBmmwxjzUDQg8vHOVnATK33vcMcZ?=
 =?us-ascii?Q?2HGkP94Ud4Z2QHCrZG8jUKCj0ery3k0kBB+ifc44jNhwAZu7vjegj50/yFsc?=
 =?us-ascii?Q?XgRwwkZ6Gsi3kbL4f7Yab7hixYuWRG4r9P3uKH4csWcz+rE3lsjSf4o5A4+j?=
 =?us-ascii?Q?j+scmWeum4JFr0pzmM04jCemcYXr82AQgthS66scFlDtZq/tEEd8KRspaqf5?=
 =?us-ascii?Q?oBVauTgHHggP5fLSk/cFrUaWAN04IdzTvj9spYu+tQiDmtcM6y58vwvSDWbD?=
 =?us-ascii?Q?sYwYAj95UidPHYs93RU07h8rr3Xy8lDsWfNh5ayb3vOCV63UPmcGlNdlGhwm?=
 =?us-ascii?Q?sGOWBW8iMW0p9sS8fZb3X4soLwWZcYdsULff2q7lXpAaLIxcEzrhIoUNzlWy?=
 =?us-ascii?Q?QGJpMN2/5f9o0uFpg5gdVT6MQIvIWo7TD71OXtR9m9pZ5UgC+LAKsbIR5HtG?=
 =?us-ascii?Q?2sb2ych3vtVm9W7tHYq0xXBTkHJSYSYGqovmLnQNmtLMkO/Dag8lhVubHmCT?=
 =?us-ascii?Q?JuhFAPKxP0J9xk8NhPOUTNpRKXwoqdsCV1Kd7vSWjY/Nn7G3+h/odBShJOAW?=
 =?us-ascii?Q?9AKgjt214sy2D80Yjbntlsws8rGCgVoXSvRzJikcu6OjPwPv/htfq69L0ZEC?=
 =?us-ascii?Q?+MIUYhBl03DZO7D+KY1WJM6q+BTirGgNV10cZCzka5XZJjKDoH7v+UHglOzn?=
 =?us-ascii?Q?WjqdIWA+QU9eecoChAxCPv5R+xlTf7ftrKExH99nDniUjT6wmKD7HCXyHDZw?=
 =?us-ascii?Q?LlWGfhsrICINFleif/YJK+JRirnJy2t7Inpqd8wR39T23+Z+suNzwygHc1S8?=
 =?us-ascii?Q?IMR76eTOHiFq7a/F5xBSodhxD4Cv62V97K+TQgqx5Suy037xFJqpPZnR6HaR?=
 =?us-ascii?Q?MNXJrJvmCLcU4gHJ6OQ3QeZH+ho8gVY24kl9ubBAjt2xO9G2reEewBwvn6BZ?=
 =?us-ascii?Q?v4iX7Ytpd1N+TnGLWbSi8+CwZtLom9CvZxUnDIXGTgBGMcDt127sqVw1xhob?=
 =?us-ascii?Q?qS3diMEPBR3WUggStf1d8Nv52AnrbhNepAbtAM0UPsQZLtMJVV5fodujGy4G?=
 =?us-ascii?Q?QrlEIGMPFR30EcydOn8gNp6Sx4fFR9OxIVhogS3I+N3wvoBNz+jjdBA9Zk+b?=
 =?us-ascii?Q?/7xexS3w0D2QTLdUFEjkLR6uqhq8ZnGOWngNOqitFLYzHVWgaQFuEdMKn6zf?=
 =?us-ascii?Q?fHRoqp6fHrH9ZcIcXaz1S29m7LmbvfLDpiAMEoPsD4BTrqAaovDkka6LWy/y?=
 =?us-ascii?Q?oK2B49PycuqHhxoXfBaqEvqlZBw/ebEUzsIRReNkeiuJQ02f12HiieExnFM3?=
 =?us-ascii?Q?3J43M7Skp/iVyiRoU1dz0k74mRFmJuuCw5eEEG4FHHAPU5DV0fZ10IKOR1/1?=
 =?us-ascii?Q?W3qkfNZifigK5+yyg3z+3qY0hGjrmqgtQakm3TaSOaTK8vdiH8jbhf8YrY6M?=
 =?us-ascii?Q?qOItyS0JZ344i6Z1vETrOytTOt1uEfFc?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?jRdHgEt2RKStWhTY5d/WeQ1mS8jUxy+7MdBIxBmoVq2kBi9yfLErzXZHKJGP?=
 =?us-ascii?Q?gGBQui6ZoplIXEU5AZGnnjqRL1csadDWv9ov74S2A+RpjAJgci4w9WN5WDkb?=
 =?us-ascii?Q?G5dk/vlNK1u6X1C8B/HneLB0ZUuwikzeLfkOpTFF//13up+kl+9Pq7Jwm2gl?=
 =?us-ascii?Q?KwqljhA3vEwEg9x/hhvX/G5JJE2Zd4IQduEYnSTvr98qGMYTpmE+jtjjH7UO?=
 =?us-ascii?Q?a8toMQToPE8fdAjXz8O14Qriu9FHU/H/hrjPEjAQHrVlEU1MsUbHVIAEx0/n?=
 =?us-ascii?Q?9r/gE8fRLFGOtRnF1Ge16la7E/9fvyYGlwjg//WwzSrtSgfqnh8maH/uQIAk?=
 =?us-ascii?Q?9uf4GszC9gqPtGwN4b1f83u8lWeY+uER1QqzX/t08Qn/y0T6PzKvMqI8oFYG?=
 =?us-ascii?Q?z6ABa8FOGqYI53usUfwUQYcjH77F7qHxsH8Q0B1jYUP+5MXkW7Q/L8UvOrt7?=
 =?us-ascii?Q?B73HidvEDQBqi+gyzRSEdlU4/7zWP40oIe63N6egrWTCudsvH3KiY1WIUJbJ?=
 =?us-ascii?Q?MKThiyMS2UdrzCuquey5PpCB+M00NFe6LipLtbupnTPAc3GN3EPEQNM0QLpJ?=
 =?us-ascii?Q?Iybd0fD2iOgw65ojTLUK2rA/FHM4SrUH9hanxN1qFpnCh5pmrIeFCnhaUt0K?=
 =?us-ascii?Q?eYFt+G8I5Os92FH1osx1p+75UhispzjX6PeqLZO232qlYg1u09iQu1oCqiit?=
 =?us-ascii?Q?hKAmQrSzHqh+HK1l0lqpWixK5HnGEuVXp6VzpQ1IQQOL7jTbnJx4uLXdRslz?=
 =?us-ascii?Q?donwF8OoGuKJx97fYW4eVck+y5GNjnNpW+Y9NyAS7o8kLdvMF0hmwprYbpzr?=
 =?us-ascii?Q?Cg3qZpP0wLaYMSYF9xu5BO6qtkfNb8wUJ/ZC3mWTuRU94z4d+o+No0bLBkmg?=
 =?us-ascii?Q?RZ00v9bVDMbXpJ9DoWpAP/HmY7Hw7GROw2sIJAZLLYO3JLAho4tEQD3IDg9P?=
 =?us-ascii?Q?SAwqtH8Ix0j7aPbI+qQRGPls3QUfHcNy4WIEBa/e5tPZ+B9OgTLhcYM8ZFIW?=
 =?us-ascii?Q?DZuQvtXajnJH55RiFKBLvIoHyX5cQrj6gKZfoYyW+xoE0+I7g9LEuRhuVZAH?=
 =?us-ascii?Q?Sk8q4EcohOECTFbZI8lbKQm6hOnWH7NP+A2aIBluMbjyHWxezDHP33RkkOsC?=
 =?us-ascii?Q?1n9GlinagV5znJmlbsmy8H2R2SjJcS92digwyKUW0L8BdTFiUdZ2kybkIJdN?=
 =?us-ascii?Q?W5xtB+E8kIARNDAJyi05xiKVGFDRAOzyJLWjdxd+JnAA+H/hCF74T+YI/JWz?=
 =?us-ascii?Q?ZXk/v0GHCIlOb8G3NIb1bg+5FhwjD444Hnon1ur0qZgH3NGd7MNl7jOVFZjC?=
 =?us-ascii?Q?ijOL5jSAYHe58BvV+ssyl1g+lM6ugCsIvrr9lC6cdy6DWPFrpRdXgoM9/vAb?=
 =?us-ascii?Q?+eA/QDbMN2D9qLI08yYsbnHnd0QDkBCSfOlTFpMHHahSubUo1nAErTbrvThq?=
 =?us-ascii?Q?Wdq+QK4N922U6n/Sbr3FCij43dgFvRfwsrydY499/Y3/YHJiJ2L7MYbmQVtR?=
 =?us-ascii?Q?Fv4MPmDcv2R7/43FW5+FrQx30OrDvdDY3umqfI50i2X8YJO4P9eXsLzgDEn5?=
 =?us-ascii?Q?vaz6zIIsGLWcORl/fouVkrWiwogwLrY3VW26ZbdVcxdOGmGuMjJZGrA3m32e?=
 =?us-ascii?Q?uDhBNPh8X4dXXqdRvSAlpeTDo0SPocyes/vlTWhO5ozrBuRWl1aVirxAlKwN?=
 =?us-ascii?Q?3svW0PNsUK8lI/9UFfM3hoo21LF/C8caFUU24I9pc8i76uiPLZLku2OZNuhJ?=
 =?us-ascii?Q?RUUNGUMXr18e9Ch09qxYzm4vVnh91qI=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	wOWFxswSBMbuTF5xzA8Bfko5Be4id5w4nepdmngOWACCOunn3wjhnjDuLU8jIjP3gMb6GKQcclkAXgLimQPuo2oMElufQIWnl8BDjnIk3k1Qpdk2g6s6ViuuD1DKDc9GBn1lVbBFBfi1KfUyPALbQtpizAGDW4DJuRyQUt9lVQIb4e3vhizm70w4n2cMZsm5qLHUd/UeB/Wf5edKJ5dnz8suFO8PmyipLaaNqQg1zGXuGLwx8R4ZZEIuTW1YlYY+hC3AFoo5t64SdWX4qZk2Ne2aGd7JsheRQ+Dm2o0//LLVSmaLMpb5GhA2laQpqbLbBPmP9IVEMUrx9MpNg++Y4I96trwljwpnXR3aG5lGkl9XEQU6x5S58OdUwKhWqrGKPCgmFu2f1DKrpRnQ4wRCsRUdDtUfYoBXe0cffIV30pRGBkfOi1V28EDQe1xR+Y0lG1UTikQpQ16aM77QLKTkOf/zsL0f47ut2MSQPuLQtsBv0armGr6Te0a3W77rhsgwqvwgWuRkxtMN5lIIWOABb7oP/bVyz0cDLZscMdWUx9ObdqFStZ8CSnIwfmdpMry3lesKiWIvgtz9Ogj6XsaaTgOV00Kc6BEQB/1nGN3JaG4=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 68e6511e-adb0-4688-7ef3-08de4f89ca7e
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Jan 2026 14:17:16.0788
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: DxDTKiGN9hb6oyCEpoHmRCWyOLHuJqM6Z2dR+rgkGIX/1JRFDbfO06rIJA6+1GlyfKDvrzT5Oh15EadYZEu94kMVHiWtnMlOxSz6x88f9dA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR10MB6682
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2026-01-09_04,2026-01-08_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 suspectscore=0
 mlxlogscore=999 phishscore=0 malwarescore=0 spamscore=0 bulkscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2512120000 definitions=main-2601090106
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTA5MDEwNiBTYWx0ZWRfX6scj8ITWmGtP
 W/YPkjTie4aIAnzcNExBilr4I6hs/oXpB96DlyNHmnPm63jk064AG5m+mEtQpdm1M6qAa0DGfDp
 OCnro8zmwnEEWkOynAdoq6ZRKQ17OtYOpdeHFhlyXw7RKoGDx/UUh02XYQFs/vFYJ4AK4nxhGGp
 xlc10dc3TD7oWwHAIzBvKytY8POrCk6VpUXDBN6CZ9EALiDZA5ytUX2CDJBgI5I+tftgTIEf9Yv
 zYmV/hRQBhpHFmMmYLbq8DxdkPQUqGNO3pLGjiYaSKyULCFDzq46nZGHMRGx8Ei8ZnmCRUnWpTw
 s9z7nqxRsDDovTDQIoG2tGQXzn3rryiatzS8el2M5vOd/jHIaL/9STp678E4qfY5NdY4KO3SZ0q
 ZND1vjHGjk1gtVtjC4INWF1njMhPt3ulfX3wzgnz3DnzyO9TNXmJpRxSsAJnHOJxzZyNU+aXkCz
 qvgZvDyIxasAISlkN5A==
X-Proofpoint-GUID: fw4fo_ZbCPlvkfzeFWaikOalYKR-Q0_n
X-Authority-Analysis: v=2.4 cv=VoEuwu2n c=1 sm=1 tr=0 ts=69610def b=1 cx=c_pps
 a=WeWmnZmh0fydH62SvGsd2A==:117 a=WeWmnZmh0fydH62SvGsd2A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=vUbySO9Y5rIA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=zEbaauUV3s8vu7QTV1wA:9 a=CjuIK1q_8ugA:10
X-Proofpoint-ORIG-GUID: fw4fo_ZbCPlvkfzeFWaikOalYKR-Q0_n

On Fri, Jan 09, 2026 at 02:59:38PM +0100, David Hildenbrand (Red Hat) wrote:
>
> Nothing to add to the above :)
>
> > >
> > > Hm.
> > >
> > > [1] we have 0day now running and reporting problems mostly private to me, I
> > > just didn't have the time yet to closely look into the results I've been
> > > getting because there seem to be some false positive test failures in some
> > > unrelated tests.
> >
> > I've not seen bot reports from mm-new at all, so this is news to me.
>
> So far the reports only go to me while we are experimenting with how helpful
> it is and how stable the results are.
>
> I skimmed over some results today, and apparently it found that the new
> memory-failure selftests are a bit shaky (fail in some environments).

I guess this is why Andrew isn't bothered about me no longer checking the
branch then, you're taking over that role somewhat :)

Did you not have the bot running for this patch? Or did it happen to not
generate a config with !CONFIG_MEMCG?

I mean I ask again (>/dev/null) - why are we not putting patches into
mm-new randomly this cycle (I mean also previous cycles but on fewer
occasions)?

Surely even if something hasn't had review yet we want to test it no?

And with no information on the process for moving to mm-unstable, I guess
we are relying on some privately sent reports being flagged and you taking
the time to ping people.

This all seems pretty broken, and you're busy enough as it is.

To be constructive, FWIW, here's what I propose:

	I think we should rename mm-new to mm-early-testing, base stuff on
	mm-unstable, and have a clear indication as to how things flow
	through.

	We should then use the testing to determine stability, drop
	anything that's broken, and move stuff to mm-unstable after a
	certain _set_ time period where we'd expect bots to pick up any
	issue.

	Then stuff in mm-unstable goes to Linus if it has a sub-maintainer
	tag on it, if not it doesn't.

As of this cycle - mm-new is totally worthless - and if we don't move to
something sensible like the above we should just drop it.

Nobody outside of a handful of people in mm even know it's a thing, aside
from those I encouraged to use it prior to this cycle.

Overall I'm very uncomfortable with the way these processes are pushing
work down onto people with no regard as to the volume of the work or the
stress it induces with seemingly no say in how the processes are done.

Which is why I'm personally opting out of reporting mm-new issues and
significantly reducing my review work until there is some movement towards
sane processes that reflect the needs of the community and importantly -
those who do the review.

>
> --
> Cheers
>
> David

Cheers, Lorenzo
