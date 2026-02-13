Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 202C82FFFB8;
	Fri, 13 Feb 2026 09:23:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770974618; cv=fail; b=Jvb/u6hObFSEfZxj97v2TjKRtQ1zAPAyCaElBtAhplH/IIfiZ5kOD/V8mpDtUSBqIa1BSeQLMEnGfByXc9AwuSDvVmECFmHIVlBvdg7mqM9oKbqUUCNedEfsgwAeSErgJ6d8fkZ9q7G5m5kYH2RK45ph6mG4KsYhd2ol0mZv72c=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770974618; c=relaxed/simple;
	bh=zObPxxq1/5RZIW6m39qcX4iQmHwb0wnvOsP4kkkOajc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=qhFtSFjLytcvqkbr4+0yMriQ4eUTHGI4ZoReIe9pFeqZPs+LySeeiQ+vXLmAE6hrIxhoqhW73RunCKMbGyUGxgVnJEwWDmpj9XUiPg/O/AK6EO3xyG2HdpU2HC78x9lG7kSHGsgg9mhoESlgfM0ceGdXH2IWq6RFv0manzWg+yY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=IkHrVpcm; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=x8J7grLy; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="IkHrVpcm";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="x8J7grLy"
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 61D6k378964560;
	Fri, 13 Feb 2026 09:23:29 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=tXqiM8ZiYvhELFjuau
	zImEm+YIjXI2aTGMJm9uPAsuk=; b=IkHrVpcmaRR0Cqdbl+zflBK1f8Fy3flR15
	/BrV76exbGwZgWlOkpGQ89BXq9d1SCbJ9luqcqQAG40ZBPJuFT1qLlpyS/HtXn8A
	WEkPwac4I1OvJuOvwSgZQifvoOBAnr3a2a8vXRRBFJ/i728/tgq4eTO1UqaCTfp5
	hk9XWX4dKvIrjIabDc3xMjtpUtkIKV9Jh+hxtduuTLZBfNVaAZrP7AfFthQTLaFN
	x+QWpWNfLtoYOpn6L/SwhKzIKVoqPjW5MDYJBPDMorXx+hHE5bK4SXcjr5rz0mCg
	noC3DKL11wk1piVYVBU+S+bQeNLIe9Or+097JsH7DBE9yz0c1sNQ==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4c7rxu69tw-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 13 Feb 2026 09:23:28 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 61D7W6wb033605;
	Fri, 13 Feb 2026 09:23:27 GMT
Received: from dm1pr04cu001.outbound.protection.outlook.com (mail-centralusazon11010003.outbound.protection.outlook.com [52.101.61.3])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4c8248ufc6-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 13 Feb 2026 09:23:26 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=oWmCCnk5MUeg1VpvcCMhtFkgfnlCrRg8wiypYLZnN5Dq8TziTFqiQUlNCmDFMx7nWfaOFV+/ld3q4CVatV/5W0LFlQM5TgXtyABRZEFfel7cA3Sel5J+N0ef7mn8u5jHOtCerZZc4E+hoJsYXHV0XXmmIvkxMYrhAUSzZ/SvVY2TcEHJNc6vYAQyuL+rDtxbazhZO9+HYn0WDjKOIZSPIlTuQd/e4W78s8Uu3oRdqVYnTYC1r5QTYUyaCHijNXBJh1MT9EcYiiqGXaq0F2fOW6tXjKZUfLgYKvsB8pJMWb2Bhios3SOAsZMo5KAJ7G/geAiDYgdjXsw0fHOArrO/jQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=tXqiM8ZiYvhELFjuauzImEm+YIjXI2aTGMJm9uPAsuk=;
 b=kzSUAxCVP1irKN2KOaNNCHhJocrd8mzqO4rWeNjBajoHmcmUZPwU7siXifPZXY5NloucquNRnzF0EcZhGaUZM2QCQxbIWVhzVmkUO3xt7T3lpXrg9R95Si/958s7Ub6imuTRty1HXM6tGalkZOM6FUjS0PtYYUFpOhbI56POxeK0qHp5T3tlVATv6dfnIUMtI1PA2qUCPnunonCkgU8mWY3kPW7xSmYZ8Sz+FgswbVngLJ2gjn+Gh9aS6AenH4vw9Y45R6ZQjGfAVtuvlFM7fVlbDrSkdMMjt4bW9uwy3ySisOgk7wo1DULOveNZjjDkGqlc+Rz7V3hGK7DcJz6FGA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tXqiM8ZiYvhELFjuauzImEm+YIjXI2aTGMJm9uPAsuk=;
 b=x8J7grLy3rUS1eeMRdZNR3dAIx4tmxzHy7gTNOQtrKNHtkOHxH5gTPpFpTFXmmiR1M53OMPOVSIfvq7Z3g1nPqKstcswQqHybfpV3f6Yx4USuoSdSaLadBeRSGaUoX1mfFYDeKf/HFHxCAUXHcYlj14WFZp9Io1JAGUk/za/TUI=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by DS0PR10MB7344.namprd10.prod.outlook.com (2603:10b6:8:fe::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9611.14; Fri, 13 Feb
 2026 09:23:10 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::f3ea:674e:7f2e:b711]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::f3ea:674e:7f2e:b711%4]) with mapi id 15.20.9587.017; Fri, 13 Feb 2026
 09:23:10 +0000
Date: Fri, 13 Feb 2026 09:23:07 +0000
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: Linus Torvalds <torvalds@linuxfoundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, SeongJae Park <sj@kernel.org>,
        linux-mm@kvack.org, mm-commits@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [GIT PULL] MM updates for 7.0-rc1
Message-ID: <ca17ad1d-3d9e-4621-ab17-e7f982d8c2cd@lucifer.local>
References: <20260211192351.6684a77b8c70cc032a3e7a27@linux-foundation.org>
 <CAHk-=wiHK5_oBUdUiNAaevmN9f-ORe+QBqbRefAZaw-RbgEn3w@mail.gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHk-=wiHK5_oBUdUiNAaevmN9f-ORe+QBqbRefAZaw-RbgEn3w@mail.gmail.com>
X-ClientProxiedBy: LO4P265CA0255.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:37c::20) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|DS0PR10MB7344:EE_
X-MS-Office365-Filtering-Correlation-Id: 78308d5a-23e4-45f8-8ef9-08de6ae18158
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?10k2dfHC8i6IATEOn3LBoqdJxUSWkTsNQun09dQzehgKRU5QSvRxGS8+SSMH?=
 =?us-ascii?Q?cVYoKdnL5koqcCNElYmjwU/m5uTxHEKf/KBnlOIN7XP1Lmh0sJjKSU0sLoP2?=
 =?us-ascii?Q?49iefrCai6tfgZil3ZPOofDN2qiiw+R7MHv73ToD+wJqmePYxuCtu7htrU3d?=
 =?us-ascii?Q?SucNqyV13eZNeHQMOzEXP2PRDauDErfK/2S+Cog9UMNDOkeLySH5TfdlVZ4m?=
 =?us-ascii?Q?eQUsTRj2EjKIp+r0svaeIJo3VRZTQRxWn+swvTqa+y1bKkhGoM7EX8G/586s?=
 =?us-ascii?Q?Gj8zTlJH9rnv+vTv9OqOJWdGW1ZwuKJ99BTlhtN2Y8SLmoxxnONd1Trf6r/T?=
 =?us-ascii?Q?hslnanJ1E2Xi0IOl+E8ja0lJ6i+HIP6umuft4ymk0XxgCEUVhyeZEwbkNg7t?=
 =?us-ascii?Q?I/Daw+plAVqrfj4vJl4Zyc+QWs35Xiu9Z04jKY+wM6GBDWbqGeEMJiRvgXk4?=
 =?us-ascii?Q?hX/TnKnJuLSiOzZ5UFi1lrY39jNudHQA5D3xqMOgmFPnIfkMWGi1fFgb62zU?=
 =?us-ascii?Q?AsbbY7Dg2kwXZkSRyQk5TgMOGvMIzGyWE1Tg5jY5EUF/mhQGTCQ9gC8XnxPF?=
 =?us-ascii?Q?B9G/VDJsSibZ7vdFr3GLXBe2vfX+mNb+hg7n9MHCSpHZwQSdfqUmxK/CizZB?=
 =?us-ascii?Q?NRhoFLEsWBL/4WZMXV5Vk257RpMkrW/oJB8uNaAG3tjiMC/xBwA3KzH4IYz7?=
 =?us-ascii?Q?CuWU+lKm+QUDo6sAmGFpEE8uqSSsn8buBKX6ZDhG4uR4uWHG5pV3D8cNl8CF?=
 =?us-ascii?Q?1CDi2ol5eBz9bPeMTFndyT1ItD3NxCV6DMiXa0WSRgZXkvhL9y3WewomIVp6?=
 =?us-ascii?Q?OAkMCbXfwPWX5zBiSrQzaraVf+4cU1/Cvx3N8Pg2HCgs/Rzb57CpwSxeVKYz?=
 =?us-ascii?Q?NPx7ATc8K9LJ27KUl1aN04u9kzYmj1YYzhZAYirY4PXSa3YXWMdISHoMNwcS?=
 =?us-ascii?Q?6iqjoz5yYWRvuNXAcOZ0ZHZCAbyxKnB+tQ3TzTDt1lODp4gZW584Xzpm/ADk?=
 =?us-ascii?Q?cEDxbwdWkUprSGRZGYda3RFXMXyGHn+oSV4q6spCxkMSPnAlr2BZy3tfuz78?=
 =?us-ascii?Q?2IZ7EIka8aNSh7ms4S/z3eiuQMqS7R4OQn8z0+EUyRfkismMyJxGQeBlaJPo?=
 =?us-ascii?Q?55kjKUvh9n+6DkTT6A4fxpYr8M9N7s2fBCN4wjq56QBj8iGGOdU8jYyl0Lj5?=
 =?us-ascii?Q?yAYVZPVvMMqmqosa/eJsk6a5BRe1rX3rt2zD88+TwdCldmvXFLZWl1HgcFy2?=
 =?us-ascii?Q?D9cIKqoVPJVDhtEbcRtVr5nIGKkAirzZ2zCkpv4LrYOI949QIJ9r3AFwTRoH?=
 =?us-ascii?Q?Fi/zYYPshcCZ/ILsFZeLdH4rQDlpccRlLmhT3CoVNiyHaFb/DAOclRJUKpdL?=
 =?us-ascii?Q?MOuhjLXtZIDuL0O+oXbYC0v64vcD/qapvN9pxbXQIWPvwXzLnBG7qpFUrH+e?=
 =?us-ascii?Q?a+0vYqal5s+pFR39sCTseUPi7QG5JEWoUrPImfULXw5r1PRgEOIcVPxPwqu+?=
 =?us-ascii?Q?6e9J2bGpwpUSjVINHIJMYr8XCkZfWEjEcYDoq9b5KB1VtyoVHnlx6krfzwwX?=
 =?us-ascii?Q?qaeuk/bZ3evXx34eGZA=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?puuJ4EbB6/4iA+SwRVJpJNW+ZRtcN9Rh9km8n0W4QPYacxSBoR4X4YbXQIWm?=
 =?us-ascii?Q?wtaJ0m+gwMRpzAVm/y1hcqVE9wbqynxcnEaJnsPqULa5G37yRPCdmL29Q8HU?=
 =?us-ascii?Q?FMviE44yOLdp7yXZ95rY6+Kz/CiJ/lqfNFxDJJxiOxiaBYsUBav9OgMJIj4+?=
 =?us-ascii?Q?3XZ/p0KUFPHo0lv1/sn5wwrlquBY59PtgBYKxbtvk/fv07mE4jrIO4HWVh8p?=
 =?us-ascii?Q?Nkq/Q8+HcNES8OURvh3oe7tcO8Fmz++mKyRjlb9dGbfCj2ZFP7DZrYEpwzbG?=
 =?us-ascii?Q?Kdf9M4nINldJR7lg1+LH9XZfF53q7LyV0KQ105EChHoPb54iuDgOaX6HTeWv?=
 =?us-ascii?Q?D7MeZwP/rSXmdlQSa8pjeawYW5QG4qro8+4IvC1lL0DLEGKpgY0PAhHmeM71?=
 =?us-ascii?Q?f0TpvwW2DRttXhA/IB1oR+GzSzxrNxWkffn618fbNUoiFbyBoeZcwDbOVKMZ?=
 =?us-ascii?Q?LJ22/Umm9QU53/pjMNhYv6ckP87FQj7Yx81jpHZ3T8twxBbouBdZpwzCq7RE?=
 =?us-ascii?Q?BJL9g2Ga7qRsq69rbNfHGXQpEW8ohAJMS9hv0U+K8pNnoW9MKGATFT7GIrop?=
 =?us-ascii?Q?aeDQYnb6mj12APKUpr89cgGgnJUeYVCfq4jWnN7UcdXTGc9g2gnQvcqZGTem?=
 =?us-ascii?Q?cx/edzYdi/EG3zmmnlZwHxminyJ/g+pAdETHt75fMG+za5oXriAfr3/Mhuyv?=
 =?us-ascii?Q?l8BbY0DQgCSyiaywh5hqtF6iRsFJrtEdwTWL5qLHz+EdIdENJ/aIGkjVNI/D?=
 =?us-ascii?Q?6kixD80zkOwODqSAN2GQISyZR86wcs5D/9L2xHqhL6KDhS6m6Hw1c7KXyI8i?=
 =?us-ascii?Q?sXSQi0yTaJKdbJNuj+CbDwvsh6NiYChyzDga5Od2k9DMki5e6DMFrb2zH2HX?=
 =?us-ascii?Q?9bTyG3CgEfSKdQfDTSlTdVsFWOhAFXa4XlDWy3yOgMGDr0o/Y4kvCpOxL4gV?=
 =?us-ascii?Q?l9pW3okxF0euBaX70Huolyze0iLopSn2PY37knz9SogK3acA3fUxKc1V/so2?=
 =?us-ascii?Q?dp4tJjZy1C68Uq1AUtNS1GgdU/ZJHL4Tn/p7WEa13xTBYl6VHFrX2U/5ZloD?=
 =?us-ascii?Q?ZaZQa7q2ypJuKClAfXvB1h7/2xlo/fKlZLbrDhGiGql/1CTieHZkDU1Ff+sM?=
 =?us-ascii?Q?6zi68WgjY/GGp2EV/nSjg+3xEF3Rej1ASGlmRWdHvQXdHqqAu9s6V8/M5vmd?=
 =?us-ascii?Q?ouMiTxr5Qf+c/6hc3SmACsjZ1eEJQNBZl0nJSaTK/D5cDiUZEGnT/6U0jdIF?=
 =?us-ascii?Q?JMdxbMe0Y7bhWiRKHXl4pyo2b2rFnz52g3DHfKc9RPm6qI++H4+lJ2s/+aSP?=
 =?us-ascii?Q?rrlbrplAI49wLRJwu/nz/3BchR2Qljp0hoUHIJhcVU70xt9nhOu5G6NpxtaW?=
 =?us-ascii?Q?qdR1zEznfSQccKjZXD9wQVXCvZV5KzBOql2VbWb+NNSSR0reMG5GVUhX+eqH?=
 =?us-ascii?Q?4rGqlVcHCSAXTTINBkrs8d1ilVQZsrHIv1HqUKpG5TwlcyuAIQf8MmyKBoT0?=
 =?us-ascii?Q?ICya54WmdVi5MYWfZGZqjqKdWW9reYb8JNf5M/h9o9QPIUAxTZToaq04oF3+?=
 =?us-ascii?Q?EokjZbEkhok6Vs+eFGpUOgIGFKlyH68rxw59OHDvlTnCM2ssZoo1SrUsSVCI?=
 =?us-ascii?Q?wtRq3qe3GLmgkEPpB8uDmIGad7zanB3GxT+EJ2kCmM+JYZu7LQDsfPRpR3AP?=
 =?us-ascii?Q?1tyW9EbUwwU/Za0P32G6zKakJfD8z8hf/me+xfaZAimMmwrWCnnNCgX4/b+T?=
 =?us-ascii?Q?tU/bI6pLakEGgFQQdlWH9jRbGcLs2f8=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	woKsnPiVkDsP7TAzQUYTh6nIRfFFwUo8QerfIL8O1852BdU0AzaWAH5CBPA8JIFR+6SEyVL1L2yUdzuTm+aI8oHUAW673RwvO+pciWRjt91Jnl/gB6AmQbi3NeCjtydU3XsWCAk+7TRtDqTCccSBwAiMyth7K6rprrR7g+s1hxZK+CU6FFrd2Dcc+2+l4rOEFysG9JtUEt8uuQVOBtovo1eoFmW3GiO7FvbzZIx8WzxtS7GP14oKGOADRvhRuOo+lixpH6Ssc5KXLYB+wwzsie58VXkIbaWl5kXs0fJjEujiEO6ByWaZM8gaCplH5MVL48RG4+FiE4hYulGHIPkIDkb/vSZ6AMZWyn4nKCLGiYd+OMwPS8Y0827THO9Q02xBsOJ/ij1rLgpvniJPcK15w16KPr4t2PwPvLGP7cVOqN1ir2FDRl7V7FbWeFFwYITgnhw5tMVRbotOnoY8pxRMNMM3hYSypmjByRlP6KFodC3LaA3mGl7mKPjriT7J6qDG4EaMzm/gVbFeCyQptzU5x9wyxWlgHA0zLJxwMDfZlnS4RyiaJmsC2e6ZilWXUvimEBeEEdrC0FkJJYmcanm9xNGdwMQYEtl3w/25HBxaX6M=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 78308d5a-23e4-45f8-8ef9-08de6ae18158
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Feb 2026 09:23:10.6404
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Q4KECO/2Y8BT6hYAhfhZ02+pYtLfyx/S/NbO0H5h/h+HBkpfWSQ6AjDhpIHb0kDjuCwCOBew32ibT3M6cqKuTnAg78Z3CkIT+6zkt1XRvVk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR10MB7344
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-02-13_01,2026-02-12_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 malwarescore=0 bulkscore=0
 adultscore=0 phishscore=0 suspectscore=0 spamscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2601150000
 definitions=main-2602130072
X-Proofpoint-GUID: h8CPMTIUQvZTP8CeXaUFx30rWsnMl961
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMjEzMDA3MSBTYWx0ZWRfXypBlBpdh3nAV
 N1+Y6bbg8gTozl9giYya2EsM3faKn4ZPRdksiPSHkaQ+q4rpY9jf4r948ICEPYK5mBHcD5+bGhG
 m8Vkkxn9wC+NsZcV3uXKS3yQbE+dhnzOOrQfW+zmRGpYyXQwdDTlUaPOHqLPKwYRCNdQ761RpCv
 ry9JaZ3QxLC9ZybZNvjHAl61ZQquYtuVNa6wlyQ6nLrkYLBA1nuU5J9GpLdkasxcxiIceQs5Bm2
 cLGZ/Qc5DMSeMp5OdrfuZNbcrZXiS4jyWfeDmZJRCuLFxkvCAenITZcB4LiLNCFd4HBBxm067yD
 GX/I09uVXprLe6DwmXQuv6SXWu76PwnKGCPP7ujxdaUAG8wwUCBL+X7eAJFsbNDoNvCu4D1/wK8
 7krw3G3X2nSH99/Pdfz1LAeXRPiRiA1IZMlDIgVSfcByXbKpmflRbpnonP4pUUoNWZm/G5f4Yl7
 4GKrlaZ0I69omw+Ng6w==
X-Proofpoint-ORIG-GUID: h8CPMTIUQvZTP8CeXaUFx30rWsnMl961
X-Authority-Analysis: v=2.4 cv=Y6f1cxeN c=1 sm=1 tr=0 ts=698eed90 b=1 cx=c_pps
 a=WeWmnZmh0fydH62SvGsd2A==:117 a=WeWmnZmh0fydH62SvGsd2A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=HzLeVaNsDn8A:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=Mpw57Om8IfrbqaoTuvik:22 a=GgsMoib0sEa3-_RKJdDe:22 a=Z4Rwk6OoAAAA:8
 a=d-dApe3jKlNAk7VWK2MA:9 a=CjuIK1q_8ugA:10 a=HkZW87K1Qel5hWWM3VKY:22

On Thu, Feb 12, 2026 at 05:43:18PM -0800, Linus Torvalds wrote:
> Bah, I keep noticing these things too late, and have to fix them up
> separately, but let's keep edumacating people about this issue...
>
> On Wed, 11 Feb 2026 at 19:23, Andrew Morton <akpm@linux-foundation.org> wrote:
> >
> > Lorenzo Stoakes (20):
> >       selftests/mm: remove virtual_address_range test
>
> When removing rules for generating files, PLEASE DO NOT REMOVE THE
> .gitignore ENTRY!
>
> Removing the rule for generating the file does not magically then make
> the file itself disappear in a purple puff of smoke.
>
> That's just not how reality works. The past still exists.
>
> And that means that the old generated file still exists for people,
> and it has *NOT* suddenly become so supremely interesting that people
> should no longer ignore it.
>
> So when you remove a rule for generating a file (or you move it to a
> different directory, or rename it, or whatever), that gitignore entry
> for the old file - or old location - should stay around.
>
> This is more than a "keep git status happy" issue. This has caused
> real issues in the past, where careless developers didn't notice, and
> mistakenly added stale generated binaries to their commits.
>
> No, people shouldn't do that either, and it's a sign of being too
> careless and not looking at what you commit very carefully.
>
> But mistakes happen, and the other side of that argument is that we
> sure as heck shouldn't have files suddenly appear in the source tree
> because they aren't properly ignored any more.
>
> And I'm sure this has happened many times without me noticing, but
> I'll keep harping on this when I _do_ notice, because people need to
> realize that .gitignore files are very much about state being left
> around by the build system.
>
> So you *add* files to the .gitignore files, but you don't remove them.
> Not for a long while, at least - people keep their build trees around
> for months (or years) and don't necessarily clean them up very often.
>
> (And yes, we do have a "remove-stale-files" script that is intended to
> deal with some of this, but it hasn't worked very well, and if you
> want to remove stale files I'd suggest you just do "git clean -dqtx"
> after you are really *really* sure that you don't have any interesting
> files in your source tree that weren't tracked by git)
>
>               Linus

Ack :)
