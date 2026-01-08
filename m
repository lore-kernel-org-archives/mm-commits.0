Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80863347BCC
	for <mm-commits@vger.kernel.org>; Thu,  8 Jan 2026 08:40:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767861638; cv=fail; b=N7LNPhtJ5hUcQtZ6XAOxyano34uMh0B91x1ZZ0zm2I/VoU9oKwSv+JJTelNB6Lj5/cZ8bRvBgpreCFuC+BddVN9tO/B3GYeubzAJY72ZI2zmWRQWEDPbSVdxKKhKeivyvizVpnYyEsV3L4De42oSOcf3OOXOgCYE1jXxhe8rM10=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767861638; c=relaxed/simple;
	bh=JhAVxmgCV+gnzcI9rSaRdl35zROUv7QQPA5JUJNoOiU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=W5JUccJ9vA5zTTOz/DkqBqpaVJQ5Lwi74Yh92hEBot/BocXRos+h5dSXJo8JEjTikv/ePI5FvUBG5U2+eb9cMiekbT91pT5yuMfeZyYralptPmu8Cis7RKklaGhuX/IcemCu0UYd4wJVFLTX2Ln5VDNXGhEL0sFyUIlaf4ORFSc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=DCn3Jm45; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=Tqdin97K; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="DCn3Jm45";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="Tqdin97K"
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6086p6H33950585;
	Thu, 8 Jan 2026 08:39:35 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=RiWrqnXTQlQtxVW1qk
	yR1Qqa4xi6xfPtNPYqdeZ9GJA=; b=DCn3Jm4546OwXhecKu3+vBI90/PIvcQKPW
	1j2GzXheGuyXEE6EwwIFt0MNcaTTs+Sgo/E0nAJfwxLkEDRVrHGsv6amLemgdAjV
	Ewub9DCjPEQtgp2ElO1Zaq7PEQ6epBYUtAwGK7OxtSJpe0jN+SPfmbT5Kym1/bMt
	hd7ufQzwxk0agAo7QVKyF3fWmSd4pKfv4Aa+M0Qq+nbXfRL/BVKXxkyKBR88Fa65
	LytMhTDWAOrVYwNHQiGs7fn/s/AS5Cksfvp96UVB8XeUN48jCcNiMuS9LZordsfR
	n6kn9Jq0uKpGk58mBxOPpILCaQiqBg1cc31O1lymwTD1M6ypmKRw==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4bj7ntr34d-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 08 Jan 2026 08:39:35 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 6085wKju015533;
	Thu, 8 Jan 2026 08:39:34 GMT
Received: from cy3pr05cu001.outbound.protection.outlook.com (mail-westcentralusazon11013046.outbound.protection.outlook.com [40.93.201.46])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4besjak48b-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 08 Jan 2026 08:39:34 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ZwlQNUxN0OZjwRBVq1HLBYe7q/mjAYhlySOE0q8ipHRxaHhRzORw8/yhiVaeburjnJP8XGCM1rzkHLitKnySa1JtLon7bgJFTpZ5R74evmzBagKUw/L5Q61iNoCG5MrBX0J7S2uOzdXHqXQ2lPjHF4mFX8SUCe0GsR/u0vN8lWraOv42U4k07Qnrf/bA4cbftQANTA30kGdk2fbE1O9dFf1tWGY7MWOehm/Fijsfybgr/lup/237EbNjpdjNSEplqv90JRZajZ7MjLX1EsdAI0ayR4fKmy+F+XGKvm9r627hyOeDgr9M5wx6pFXOGt8vs7yejLpr+EUCGiaWdcN40w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=RiWrqnXTQlQtxVW1qkyR1Qqa4xi6xfPtNPYqdeZ9GJA=;
 b=MHYRLu9ihfsa2kaqigGXG1mOHXjzC/ZObYPm5h64+AOf+kKLcKaAvHCeKFqCOG1diwu29v5JDG/dKPOjgRg/nxKGiinoB0rialisf2zX3VrkCwPYrsgd/8pt/NjnraYjtcm5IAEC43COVDQbLg+GXTM8OKpa5m7fosG9XFpZdG/VBL0brwcxQb4EB4AkSS0wWCt3wXZsHy02bhStpCBdoGUxkXKFxzZ8KNmhLIs4KljubkjKDK/iO2Mmpg6p/e/J9foCjvj6MOSWmT6BnOU/CWy1W/LolfboLUUyprlkf6X3dbKh8uLJbfCwyGECB7vVXwysEHmM2aoH1qOECTTc+w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RiWrqnXTQlQtxVW1qkyR1Qqa4xi6xfPtNPYqdeZ9GJA=;
 b=Tqdin97KZywbwXpGPaZIFssL58lPP2pMHpZqNHkbAWE+/+swx3R7RYn8XWtWo3UQUyo47xcxqjj6SJxMr6ZUfczzxDlUqi7H5wFDQZ4i+APy1F6EO2lAL+zJEWwBO35ezNkpoGJGKCgyUihcMpxB05ggbl5SVEyFQJegOLuhvyU=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by CY8PR10MB7172.namprd10.prod.outlook.com (2603:10b6:930:71::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9499.2; Thu, 8 Jan
 2026 08:39:30 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::f3ea:674e:7f2e:b711]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::f3ea:674e:7f2e:b711%6]) with mapi id 15.20.9499.002; Thu, 8 Jan 2026
 08:39:29 +0000
Date: Thu, 8 Jan 2026 08:39:29 +0000
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
Message-ID: <8b54e314-be57-4fa0-bb53-e9a0adb7d969@lucifer.local>
References: <20260106033842.559EBC116D0@smtp.kernel.org>
 <3a96b65e-49b1-45f5-a36a-77b38cea62e2@lucifer.local>
 <20260106124930.827da463ea281bb392a9843d@linux-foundation.org>
 <4cccaf21-c78e-4017-bb95-29a401d7c3a5@lucifer.local>
 <f916c970-33fe-4147-9daf-159ba61a0302@kernel.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f916c970-33fe-4147-9daf-159ba61a0302@kernel.org>
X-ClientProxiedBy: LO2P265CA0514.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:13b::21) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|CY8PR10MB7172:EE_
X-MS-Office365-Filtering-Correlation-Id: 9ddf4a86-7a11-4544-e697-08de4e917066
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?47/m9kg/ZCpG1QyEMEfeoq+tAE8lHBSqpwrBjS4HnX58IBaApYhOBvxUa2OQ?=
 =?us-ascii?Q?othpNOaVya+F6HjL6pDrq51lu835JjKe7wdQGrJra5v8nbCAxrMtqbBwak6I?=
 =?us-ascii?Q?4ePKLkqDQyAURJgDypKhaOgkpY8MwAgqn3HQ6zXlEHY4yMZgO6b2CrxUWxdF?=
 =?us-ascii?Q?py4fXfpDEAEd5u+v5gCwpoZJPQ4uCNw8+HfveFmCrJ9L/N0UCBNt7sEDqWMv?=
 =?us-ascii?Q?g731EGFB8cfASOQpaoS41kiwkCKbnzRoRSZvkz/mAdr/scNjt/8RliGqFdc5?=
 =?us-ascii?Q?RFQP8lzgIXp7Y1UBtdozNIWrD8qX6yyP/BWaiPNqV8uyaSKpmG4oPtk8FM+n?=
 =?us-ascii?Q?lFu9Rt+iJmUjsursj0zI3CdyKfOGtA1QFPfwYAJgda6jxJR7U9W58R3c8zqn?=
 =?us-ascii?Q?pu2+iEVAFMHDmdTy0UIiyrOMZ5rQbKQGxmgKF5f5OHBGgntTHdOTsV2duO29?=
 =?us-ascii?Q?2xhF8fwlqNgM8qO1c6aRHT2cNAvMmbgbxExT9EXvm/EifuSFsJu6jX6mOZtg?=
 =?us-ascii?Q?7kTEAAgUyluhZ4Gxa8/ia2QIzW1psnkM8cYwNfWhQOpRi+sgMznPMMksVmmv?=
 =?us-ascii?Q?fZqMLeb3eetrboPgCrmVGwbMnnswE8AxBZEisrHLS0EZHRakMrP5x9l57WD9?=
 =?us-ascii?Q?CNGT1VVz4xdTMGO9EBWE9n0SipEd3tPuK07DcwEvpqndWLOYiUqQNzZXSKU4?=
 =?us-ascii?Q?ANve6+S8iVFTn1AjyoigBQbaza7tGEC54nr7oucHkq/ma4NxReOe4lTpwbh1?=
 =?us-ascii?Q?s41WJW//4dgL7ZpgCvrpfwCKTCpe57K0QxJguGseW8MJWSiAxKp+RpTzcW9o?=
 =?us-ascii?Q?QDnXg8IYXyBaItlwIKAVT/10ikVIxoWYT4QlJ2HtSSneNfdhufEM4Cx0oda0?=
 =?us-ascii?Q?mwCuHva8yDbDMXtbubovunzwO2FlJEXjfK2zqRD03TBuWZuQioL962jC0IPM?=
 =?us-ascii?Q?oLElhfmrtdF9cS3Qul4UhJDUkPRaGg8BzdMI3KS8qS0+mo7yIiUl1am8WtZg?=
 =?us-ascii?Q?bqtfb33BijRBGIe7aMyPIqnoorZ/ZaLxiItPIq/nUxd1Pd8r8ymVWC5R1V70?=
 =?us-ascii?Q?1rof0clK0+y6MO6gCdaiY84HTjBB7gKpp0avH9RVF7/TB1D49WM0HSiLGA0B?=
 =?us-ascii?Q?N4Gpor3i7AJy1Qk9Wk+aL/uNkKjM0OlsgZ2+ijvEweQa4TRU7Nh9TNvskXhr?=
 =?us-ascii?Q?Yfefo9IW9FdesR0EH+uw2PnlraLVarBwydoQ3Z9Hl7bgLUZcnN7PFStNsyfQ?=
 =?us-ascii?Q?hg/eQVmeSEydedxtt4tipmlcikOdfw8dn2E4rM7VHD0ob6BuGpiG9KYIc3qr?=
 =?us-ascii?Q?/3Q4D2unYIQ6VwOTzD0Bisk+CcJCCw/WU268w6DTwN4huY6BPfWPYif1pKoU?=
 =?us-ascii?Q?67MroPtXxmZ/vqrZjD8kQxx6k8qQ5LGJHCQRq6aQYtbH3185+LXxfiWhlMKy?=
 =?us-ascii?Q?d1JcbQC8SGN21uOAvRlaAJTovji0h+uI?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?OXtwDiDWmnCTAHdYvkZAkj+WtMdVbaI1DLZrNM9MmwT9twh/S4qhCr3e9OlT?=
 =?us-ascii?Q?h7NFYQsyg4A+haR/g1wtbnny2Pf/6xUq1noeWDnQPcYxfHF4BTHiO8v73yeT?=
 =?us-ascii?Q?yJAzV2wRmzu7R8rmnZ3rrIZ06Vwx/6/yEB1RLVtXIy6+AI4StuK0m3uLw+gU?=
 =?us-ascii?Q?VHbcCI8aqc4spys52xP5DjbyVnvd3cTNVKipgb8Kt+VSxNg2cyVOW0qA4Ed4?=
 =?us-ascii?Q?D7OR4d/6ZE+iI4oDO3Z7rcIF5vdBq9yw9EnCseu91Gbreruu3LVlr+BmoQWF?=
 =?us-ascii?Q?onVCTxla6mc7gB9tiySnoqNfzD0aw2w0wwlDy6zb8/HPgH4QZEpPdx5zC+4D?=
 =?us-ascii?Q?wE1SsT/SpKpnFC/hyYndnKxhezmv36v0YhXz+1EiALfbLnYn4ge8Gs5JdXx2?=
 =?us-ascii?Q?4rqsVAew/RjDjoXckT2W9hRHj0wz0YnmCa4S+hk0N3TU0FM1ATLbIeiUC4li?=
 =?us-ascii?Q?CTYOjKBbw5oAwUxBF+OJh9OR87Xhv8XSJRMPyEsdrS+M5ca3xyvLSECLUHeK?=
 =?us-ascii?Q?Mb6mP04furI84jdlZYxnCopjrY01kGCTVP3TQY2k1r8Dlix36QTYAOFx1znZ?=
 =?us-ascii?Q?q/qMDgv7e6GA4pu1D34MpaH8PDwxtoELuUQ3vKKETdhNHzCXdpKrZCSaWiPx?=
 =?us-ascii?Q?yZ+uptb4D/GHg8vQY5tuKVhUFA1cL8wPYcnVvpJ9YlOytzG4Tvkvv2lbaTcI?=
 =?us-ascii?Q?nISsLjofL/tsbYv2Z74SyjoFGWdiR5KfeIQhgAsmqdZhhivrsh612KoVahhI?=
 =?us-ascii?Q?SNBvuFEGLrYjoQoUuZhCCsuvNmI8MuscN+qFJhshtqtyveW4wBHkn8sDwn4n?=
 =?us-ascii?Q?27ytWyfI3Tnb/QW7O3kuMPKoXpnGCKZC17VnUYSpMwZAzd7Za3Umyph6CtcS?=
 =?us-ascii?Q?vuIoXanHt9Rk80nCGDwmNg9DkmYuuwuUmtu0kDum5nAUALROI5dy/Aoj1rR5?=
 =?us-ascii?Q?TO5vFUdaiqkZnYGLmskfdINdZq5gQoxaNuGihH+i0n8BKm629h7sbyBhJOLL?=
 =?us-ascii?Q?wwXREmBRhq1iYu/WyTZ44zq7r6kFRa/Bd9JcvQyT3ufMG8/FgkYnVFcGRQTk?=
 =?us-ascii?Q?FUcqOEv1fAwffFyv28PoSP/X7K3hDvk8yOpdBuODYmrlgZHD2/Xzx8KM+pQo?=
 =?us-ascii?Q?Pm315C4vLmX3RSXTo7M7KJ+RY5k6kHFUoY5MZDGeGV/q6HuGKsbQw/K0/U2F?=
 =?us-ascii?Q?kcHU0xkdKdQsEzOcjX82HyB4FhToCfAEBk+7Evgz+szZ14aHoMLCbfhPmDim?=
 =?us-ascii?Q?GRLnxjFrTqXP/4CULfDjV2imIoy9artOT7hyKcHTqcJkFHD0WoTh8xzCEHm1?=
 =?us-ascii?Q?vQlqiRrWJ3OIJKfc7yV+XUa80KPgRp9amMaowKd39dcMVcuBiZajeVmkPFte?=
 =?us-ascii?Q?NBR+HQGEHaH1a2d+AytpmuIDrLoTau1CSpN8UzpLp6XjUQtcb4QEO8jt4dtz?=
 =?us-ascii?Q?rFw0dhNKC66HJ/gNVBbOXtjZ7re0jrD5/oegCx450ul4qAnwLHONofVCStHU?=
 =?us-ascii?Q?2p+S6Q6E9ctBvJtA50mGdiND0ZQES4x/WaUVlEyXWvmOEWW/Os8eWWZ0AwE3?=
 =?us-ascii?Q?sCevM0/sEiY0vGqwothwfDjGCT11KcYVkHgO2sGieNaVdHKuI7b7pRpN+qID?=
 =?us-ascii?Q?6RaNcKjsy82GkX0tMWYkGeOs+Ks7gC0Uzn15K/xO8n0rcozYiVvgti1cDan2?=
 =?us-ascii?Q?I+sDBYm3+qlPONQXlS+4UxWXp2esKybxgzqWvgTkrfzCVz4Jvis5qiJuJQIo?=
 =?us-ascii?Q?c/ESyJLd4q7qE1/3dK51RB7jpJOD9so=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	eheccbyuB5THPCU0gSWFeVpT66ggZl3rlDXPPSB0cyX7D/cwJtdbHM2FuavH+sDLtt4XCVTa3kiL5cYXJ88zC4yx6qzUN8kRr/dZJn6RAnm/sQKG2K+Y6UAo5oMNEe9IITVe8zqNyWF7Lfvnpj8CAUFru9Kf1i8vLc3N12jsa0R3rxD9uNtWd/8oCvw7U8Ak3nE9jLatc7j+1oWnG05iY++Y6QU75tztTT1vDT8afrIuyRSAd/yHP2ZHe35ah5y8yoTwBu9Ituix+zH/I0hVujTpvjqiOw65UYuaRgBHAM7gdKahGuzKzUpsmAmQqPUEBGziDWuwGwZnNjSjQ+yGkQp3N6NZ+IVOqhlBc6xjwdkYZjhXABLUBz8uD3UH6mLSzOg5qTBKziRW419/j/ZWdLun/GQCYxGl+VbtjgQWRVMfOZjTb2f+0eqM/upFgpXE88/ODUpL1nHc6z+jTVh0qDCKW82+DJ/bfskTRd9a/stMpUJvBkpOPRoqH6xEDwimwW/Y0K9F/jtfEztpHJAo1ZS0E+/c+NZAfM4S+CqdIISgMCf2RV/wm50uK5kAa2FOS4/tdsNjPVOnFJ+VOGwUBzj+yWTNgvsVsIlmZLtXQcg=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9ddf4a86-7a11-4544-e697-08de4e917066
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Jan 2026 08:39:29.8724
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: jzrJRpP5+WbZGHXz7C0I3jA91e0g7nhdLUeCrJpv2cyzyEA5Xp1gq1mCNEXbPvK5lzlrSRnHA25gFAO46bLoUYWCa/8svPVJM6XWPnxWgKQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR10MB7172
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2026-01-08_01,2026-01-07_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 suspectscore=0 spamscore=0
 mlxlogscore=999 phishscore=0 malwarescore=0 adultscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2512120000
 definitions=main-2601080058
X-Authority-Analysis: v=2.4 cv=cKrtc1eN c=1 sm=1 tr=0 ts=695f6d47 cx=c_pps
 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=vUbySO9Y5rIA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=89T88C2wC_6oftEBCsYA:9 a=CjuIK1q_8ugA:10
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTA4MDA1OCBTYWx0ZWRfX6Uye1iOyn84a
 5Zt9rk8/9cSZRNBjMM/6lhHXbtrbNatqBGF8HVj3aiq4ujurAeKEajgaI3fERgYOhOJsmrR76QZ
 YTBQzNlH/TGNIJ0phNHCuVCeQF+GPUUYx8/mY3J//Pis869b89O2ix8wdt38ExGLTMFcp/DS4cA
 F23zAyF3GAqhcAszWIB/FjzeN3OKXHQjTXor3BFKnE27Y2FkblBdN/ACcu3uNy2vvqvIIjdlzPN
 Qhk4BcduDAHUtBgej6Ebs1w1VK0BST48WsxGFc9k+4KkUNDNAr88ESHhvjTrrqDeL8xf8C93vft
 AncNzdRVMCNrg1tGDca7aOYJDYHLJ8v50YOtNMGtWVST9d9s6s0VULFQ4Ufnm7DDCYH8Zr6DY7y
 wGl0IfQTDxsLgktAdUMDcy4RPLKG/Vv80YF6Anp9p9vjq3OibL9np+RIR9iBsq+/dEFFDyXCOpb
 n/4aHWCmjXHtOJNmaXw==
X-Proofpoint-GUID: lEzuQHqIWn-FCEw-og-sy1UQCh_OeSke
X-Proofpoint-ORIG-GUID: lEzuQHqIWn-FCEw-og-sy1UQCh_OeSke

On Wed, Jan 07, 2026 at 11:30:58PM +0100, David Hildenbrand (Red Hat) wrote:
> > >
> > > The email you replied to had (courtesy of David):
>
> I think it was courtesy of Mike :)
>
> > >
> > > : Note, mm-new is a provisional staging ground for work-in-progress
> > > : patches, and acceptance into mm-new is a notification for others take
> > > : notice and to finish up reviews.  Please do not hesitate to respond to
> > > : review feedback and post updated versions to replace or incrementally
> > > : fixup patches in mm-new.
> > > :
> > > : The mm-new branch of mm.git is not included in linux-next
> > >
> >
> > This provides no information about why/how things land in mm-new. At the
> > moment it seems entirely random.
>
> Yeah, I am also still a bit unclear on some details of mm-new. So the
> summary mostly captures the idea of mm-new from a submitter point-of-view:
> if it's in mm-new that doesn't mean that your job as a submitter is done.
> That's a great start, but obviously lacks some details.

The key one being - how does anything end up in mm-new?

Before it was generally the case that things went to mm-new prior to review
unless glaring issues or somebody already pushed back on it significantly.

Now it's ???.

Also there's no clarity on timelines of how things go from mm-new to
mm-unstable.

I've been using mm-new as a base since it was added (and encouraging others
to do so in order that I can a. make sure I take into account other series
and avoid conflicts and b. pick up on problems early.

>
> One point I see, also related to another mm-new-related discussion Lorenzo
> raised: If we want to use mm-new to find issues before they hit
> mm-unstable->next [1], then we should make sure that some known-broken
> patches/tests don't stay in there making it harder to test other patches
> that get put in there afterwards.

They generally don't stay in there, but it seems like it's mostly been me
who's been reporting this stuff to catch it early before we break
linux-next or things get merged.

As I said in the mail replying to this, I'm simply no longer going to be
doing this.

It's quite personally disappointing honestly to ask simple questions and to
be ignored on a thread where an issue _I_ personally took quite some time +
significant bisecting to report has been addressed.

And given I appear to be one of the few people to be reporting build/test
issues on mm-new, the fact that my no longer doing this was considered so
unimportant that it can also be ignored is also on a personal level really
rather disappointing to me.

>
> For the time being, I assume that everybody should develop against
> mm-unstable, and mm-new should mostly be a target for build bots etc. But
> then, if everybody would develop+test against mm-new, we could actually find
> more issues earlier (IOW, before mm-unstable -> next).

If everybody bases on mm-unstable the mm-new branch becomes totally
pointless honestly, unless it's simply a place to set the bots on things
which would make more sense.

But we _still_ need clear criteria as to what goes there.

If we have long delays from mm-new to mm-unstable - given our 'default
merge' policy + the huge amount of incoming series the mm list gets (I
personally am cc'd on ~100 mails a day) - we are inevitably going to run
into merge conflicts, one series breaking another, etc.

Refusing to send series there for arbitrary reasons just means we delay bot
reports etc.

This is why we need _clear_ criteria and timelines.

It doesn't feel like Andrew is too open to my point of view here but FWIW
here's an e.g.:

	mm patch timeline:

	1. (within a day) Unless significant pushback, added to mm-new.
	2. (within a few days) If no build bots pick up issues, added to mm-unstable.

	If at any time reviewers clearly reject the series, it will be
	dropped from both trees. This will not happen if the review is
	simply incremental.

	< ... stuff about merging to Linus (after M signoff) >

Right now it's:

	1. ??? maybe gets merged to mm-new or maybe not, no/few bots
	   running no build testing.
	2. After ??? days merged to mm-unstable or maybe not.
	3. With ??? criteria added to mm-stable and sent to Linus.

Which isn't really useful and causes stress for reviewers, maintainers and
submitters.

>
> Hm.
>
> [1] we have 0day now running and reporting problems mostly private to me, I
> just didn't have the time yet to closely look into the results I've been
> getting because there seem to be some false positive test failures in some
> unrelated tests.

I've not seen bot reports from mm-new at all, so this is news to me.

>
> --
> Cheers
>
> David

Thanks, Lorenzo
