Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2B2C22126C
	for <mm-commits@vger.kernel.org>; Fri, 23 Jan 2026 12:34:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769171691; cv=fail; b=F3IhETMaBzyh7AluLz5ZssRrNpm2F0aJZ/y5wAQn1UiOygTvrARh2H04TJsT0zcQ4skJlsnWhQ/3PopG8E9D3iiVu+9i2CQNPVrH8tu/0EyFCDptHEY485JdjA5FGOVEnr8w/kVIBiidj2DEJjs5DRYEzONu1HnhGYviRTduDNw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769171691; c=relaxed/simple;
	bh=NiCj7R6nCU1/bnLIuZKcyy8gAFaxEM2uOlt9t2EMWM0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=jZQLpJyav1Whef9hOeEbXcu4uYvpbTOvu3FV0jqvvJg/NAkCrao6t/a9BfNnob72akfufrf0Mhhc/+XMYX+sYpfTJ8afovp5aPFrCDtrtg2dbeJHSiKdltgIuUpJKNlMWFlchVYH7HDQxgW20Lj/9KjmEDIhdSJe+g52Hr+15K0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=RA63pxDI; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=RAwF7DAt; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="RA63pxDI";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="RAwF7DAt"
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 60N3EMnQ2973511;
	Fri, 23 Jan 2026 12:34:44 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=NiCj7R6nCU1/bnLIuZ
	Kcyy8gAFaxEM2uOlt9t2EMWM0=; b=RA63pxDIJ1Wa14nvl0U2CnM0y+ypXwGocR
	VgW0s4EhxhiSqCO12BNn9oUBNcVNmN32NKRrFTwdUKrTVLmJC8wOEvwq5cW+ticQ
	bIKnxAXaBJFLCvWDEpcVaSIQxYCUpQKNrOQR7Cro9Zm5ZqrWZ4tRFyTFZvjviQFw
	QA9w4QvaGgTUmsIp11TXnMCOinbatwdNKaimKUGidRv7YaD9vmUkIQQnebjN+Uq1
	/XbtljtoVsFBYHCJjnOvnH73c/AYhPcCKft1CEB8kozaj0ob45U4pQmtzKB+qEOo
	JtqvHKQMLxmj5aknLoLBjDTfaH/Im+9o6ryzp6VhlHdQ9gCqJvxQ==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4btagcxwb6-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 23 Jan 2026 12:34:44 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 60NA1EB1032955;
	Fri, 23 Jan 2026 12:34:43 GMT
Received: from ph0pr06cu001.outbound.protection.outlook.com (mail-westus3azon11011042.outbound.protection.outlook.com [40.107.208.42])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4buyvesm0x-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 23 Jan 2026 12:34:43 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=mg9mRwvqVTl1amQD1KluKcrNfn6QEZgR1YdZbDiffSpkfEBrX3bE75dQn59bTK8aLjAnqpG6EpUuLVMQao+7rwzFIbKq37R0hckc9U0vrkvKIV9L8cpnb+gHE/GjQa8AMXWQFqmYFm5Ou/kf4r6MxXtTf5tjTM1whIrRoJqasU3KBTGmeCFbABJ10B4EOsVNdrx5JcNt8zPrr5YyzKKZQ95k1ik5Ke+ZZf85Atz1hdq6uwnjwSn9Pb/AQrTjXh8/ic01o9DH4MD2+CV6j7nD3ZfMxWCnefpyLgdUlHSdBssTXnE4zson9nfR84CFspXF/fsYsL5scOcS6B4tAtFHiA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NiCj7R6nCU1/bnLIuZKcyy8gAFaxEM2uOlt9t2EMWM0=;
 b=mgaq7OoKuB5G1ISE86cMHz9E+jzLImaC5med/1AX6hMEU5uUl1p9+Q+PNc0ig68xssoDDpnmwxfo7u5wYUpG+icefbbMHqSVYeSY4xUbDZt901VNu9MMJukjzZNKAOe/S06LuBT4scl4LzsEko8V7UYTB+pBqAiHYoEQiIO/MrE1a4U95uwr1BMOWGPNTbtrwq9mpWfj3EeabFvaAQCSQqGPhngFFm6Zs6KoRAp8aQ7lcZlg/q9zO35opXhAH8rH3xG9niwi6yNcecFgDd4oN2cBiaubwaxHuyzHIOpKpholDvW2miOej2CQ0o3hcnSc2YD2v+W+U/wS2u17CoTsjA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NiCj7R6nCU1/bnLIuZKcyy8gAFaxEM2uOlt9t2EMWM0=;
 b=RAwF7DAt0LndTUIDFnv8TVAYiziVob4VVLum4A1VZZMr1ewhhXqbsIk9ex2Sy3pNJYdGQrakEaXJfcWp2Vhe0q2l9cZjlqFuzngH4U9Q6xUckkXgxDW91j0C/0xGtTDuf8qKfIjYZvSDcELUlKLoNIqDWWf0R81/vbwK0h4yKRY=
Received: from BL4PR10MB8229.namprd10.prod.outlook.com (2603:10b6:208:4e6::14)
 by CO1PR10MB4786.namprd10.prod.outlook.com (2603:10b6:303:6d::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9542.11; Fri, 23 Jan
 2026 12:34:40 +0000
Received: from BL4PR10MB8229.namprd10.prod.outlook.com
 ([fe80::552b:16d2:af:c582]) by BL4PR10MB8229.namprd10.prod.outlook.com
 ([fe80::552b:16d2:af:c582%6]) with mapi id 15.20.9520.005; Fri, 23 Jan 2026
 12:34:40 +0000
Date: Fri, 23 Jan 2026 12:34:43 +0000
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: mm-commits@vger.kernel.org, baolin.wang@linux.alibaba.com
Subject: Re: + mm-update-shmem__file_-functions-to-use-vma_flags_t-fix.patch
 added to mm-new branch
Message-ID: <432df561-213e-4e7a-b646-c1f9611e6464@lucifer.local>
References: <20260123063646.A7B6AC4CEF1@smtp.kernel.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260123063646.A7B6AC4CEF1@smtp.kernel.org>
X-ClientProxiedBy: LO4P123CA0273.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:195::8) To BL4PR10MB8229.namprd10.prod.outlook.com
 (2603:10b6:208:4e6::14)
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL4PR10MB8229:EE_|CO1PR10MB4786:EE_
X-MS-Office365-Filtering-Correlation-Id: f85e4ba0-c85d-401a-6faa-08de5a7bc744
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?MgM51cNXR0IQo7qZQ4OlzYdZuKNMNe7R0+TePfQlFQNye1FgQ//rjPX82bFW?=
 =?us-ascii?Q?8cADRBk/kj8urg7qKjEHWlADIJu9K2yTmvr/MzrbL0Lt/4BatWB+lmo9JY7m?=
 =?us-ascii?Q?b8Bt6XX+b57RkLUhCPIFNXtxPxYqpjch4CBEhNImTb7RWtPOo81ef+DL+2+L?=
 =?us-ascii?Q?0pfW/ULAQJRMHIfiF9KRuF29ODagFFUaXVRSP9LmyyucI5Nz9YgkWjm1/5yO?=
 =?us-ascii?Q?7jm721GflwQrRyRCX2g4xCoDwhCFqDKA8XaT+HgtE/PV+JCgVVxAyUp7hoep?=
 =?us-ascii?Q?l8vrkWK1eb1iYvfhnhmwqV0n/IL80Lm0asREx/oRHaSWYj4h3KGcKdQ9vBsA?=
 =?us-ascii?Q?CAZsNIoRKfYRan10quyMoJLrfKlwO6FQT05RdZa1vNmeq7w+z/QfUAyqVDWt?=
 =?us-ascii?Q?hdSynHhqe6tTT1wsSgU5VLw/eb+pVlzquIH9MGNp40wpJLs4htdrVYusqU88?=
 =?us-ascii?Q?UKZt2q1nC37HJGHjDgzFLD9A58ALeS4vEd9sWaJd+uBCIhX0YjSl6uL9q6bI?=
 =?us-ascii?Q?9k9dDH1d50tWH0oFs+r+YFkz/gSA0+XxDsPixmrlaJiHLKoEHeE7kHVGDJ5e?=
 =?us-ascii?Q?gja0zOBjEOGTb6vfXTIKF+moD38+sSmqagXsvjpDF5W5X6Em+d6ckGjqxSH2?=
 =?us-ascii?Q?RIyMN/ptaWef2nd8+FFEtb0BWAOVd1abH9WKV/uak0zPBftMT2r9pM9pubEr?=
 =?us-ascii?Q?LB/H340ec5fLHCxSF/v8uSq1OYHddkdhI2bvs3MMhNENLWZx8/DDRideJFGQ?=
 =?us-ascii?Q?fD9/El6RbJM3HL4/+8+Ykl6jMROeYwuN+Pk7/Qf2aJRcQp1LffjP8wqOCv05?=
 =?us-ascii?Q?eGcXTOqD+vc88a3v+NIWV8LvE7aBzsxjI8YH7OVenlI11G5+RuHc7hbp9U2H?=
 =?us-ascii?Q?p0sQ0QicVUq5l05TcqhkFai1mZEjcj2+Idql/ZZZW77/9BZPNeTzntZO6C2B?=
 =?us-ascii?Q?XgsBThWNSt1oi85H7a9S7aFYL7Bn0WcpTX4alTxVUKDameleovikZ5fsCqmo?=
 =?us-ascii?Q?Q2n5KHASS1vcqMKHMm4clvOVFd+ifDLGwbMjNVWWKAWaykoykzXf9zQGrumj?=
 =?us-ascii?Q?fIBU6z9qs3Kc4I1Xf8S2wWsPNqqKIE5Qe0LliooMlXAxjgyBeviLQBJuB5cw?=
 =?us-ascii?Q?4cVUiBVI2HB15dhlm+/2+eBjno6cAg9GY4j46pQMqmaOAHsWFw2/Xq5mIRDB?=
 =?us-ascii?Q?r1qgVR+o+lnT6dkkrOJCpJSrMXhcBAYZs6RxeJs7wFEtRSS2QB+8eP3IH01H?=
 =?us-ascii?Q?fUVP2GFf04+xmqh/RmSHiSLEnzsM6K2kysWKx/6AHSZAZxWy7tONad5WEl78?=
 =?us-ascii?Q?iVCY+s3SHsR8AXohvsRzGT3vkoYLgXCtRVAJVZ43hY3ZDokqq+fVQQv4xX06?=
 =?us-ascii?Q?mDHXyQDaG2LEXXmVe0Di9F01Bd7RV//G8+5Ha8EddIlwdLfLxiPZw4/DufPW?=
 =?us-ascii?Q?p2AOLVyeMLwXveOwT/EVIMd9zBJHPzOofW58T0zQS5AVpLhvme7+kgEAsfqZ?=
 =?us-ascii?Q?ol+uOuPkWnCFL5FWexmCnFmjMF+fPpuQ5svav0TSRO+h2PlX72IUvgIOrZu/?=
 =?us-ascii?Q?93b+FejFfVnOXfQAd3U=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL4PR10MB8229.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?UxAKMMYGt7AZ/bl/pIUwTdMv4912mALjGa5dy89m97WBF6QblN3XcXSXBTiR?=
 =?us-ascii?Q?3Cqa/08H1aBxXfmTljDOfiH3L8Ct13naInIuWA58go5ik2UE+hnNUwVqNcgb?=
 =?us-ascii?Q?CQ9kGoOYx1BN/e/Ql1ux2rSTbZHrPoTAVInl8m74KT9VHDGkyDUkR84ijtEa?=
 =?us-ascii?Q?4pkuT78cHrzPCcMuPIGZ84AkVJlE0mtIOY6abnzy/GK8fVVnDlzq8K6UD3r+?=
 =?us-ascii?Q?usk1LgA23BlEgS/zJvImvaqcgtjZRxny/GAg+xAsobk8E1oVncsVs/JdKWGv?=
 =?us-ascii?Q?cgmvrQzp9k6DvJZuyuu1uCNaYOAqtdw7xpQoBDXsZqy37KASJPIltoTRO4Ly?=
 =?us-ascii?Q?ubA5TVE8f8Di3pGQG/CJYPlv7HGbRRJJnVPnxoo26Zl4v42JogSM21jOvZLW?=
 =?us-ascii?Q?W9UHLIGtBrWJAc7co+nlcbyye0liOn98I3ZX/1MtNO+gEkQUhghBpirQcHg+?=
 =?us-ascii?Q?bMtMf8DKvQXiGmLbAffCgm9UUkwv2WyuvR/EOUehRe+4ggE/9Y2Pxt9uqCvD?=
 =?us-ascii?Q?/RLtFB3hpTK591GKLkTQsVu3pIA1ZJoQ2MGBobxXWQX5Oyw7OuciUxVaLh8j?=
 =?us-ascii?Q?NXdEkuDdACcttK+s0nQXUMk9v3Bg/8Wi+WM+pn9/hS9llGcK1OaVyzbiCb7s?=
 =?us-ascii?Q?fxkd7atmPEhpVXwDL9njPSB6dSdv1eUpwBjiFVbjoi+thlC8VekDt4T92nKb?=
 =?us-ascii?Q?WZrljyq3QScJBG6eA23bo8mL2tChkcfj5EyVUXrOQAk4UGi7+isPQeDdHGN5?=
 =?us-ascii?Q?149xKcRDIp5LOUF5sT8jYiaGxhLMAdD0hsByoqCdQfYXDS+r0AeAbIw71kQE?=
 =?us-ascii?Q?zG69KzFGDvughgyAGD3bYcjahr/ggQ8IlTL1VRB/szCHond71xfEK8SbC1MG?=
 =?us-ascii?Q?9miiY0NGlVcU1IWVZ371HrizXxcECw36S/Heh6eU5GwQnG4H/PRBAUOwvtmK?=
 =?us-ascii?Q?5TY5xfNAoMTbhI4nFBqmzprsYAELFWchvRuclKH9SKvlw2TRqC4aemw8IHkW?=
 =?us-ascii?Q?e3TAZG/Fyn0QlG/O2ZvqOm2n2FUVXQQc71VWqMWu/GqPQyIuncpJ2LCNegCA?=
 =?us-ascii?Q?wCxtLVnR7q3uWHC8sspYUpdKijt5FHX9Q6OBjDKPkKAD4D4WV4zqTKPY4yQm?=
 =?us-ascii?Q?1QqFy04DrSTvow/fpgj4uqBxEVcJ1eLpB5pgVMqObk+iTEU+gP7LazKcK00e?=
 =?us-ascii?Q?/aVgVkbT+WKznB+i0rGUkQ9XLE2QX7Djlo3AVq1Rj6koigitoW6MzWk/tuMi?=
 =?us-ascii?Q?Q3VTglnWR6KjjoeoQEzzMR/Lrvjmx61ySLvsg11+NXMLgGRyd/QMq3EesC/2?=
 =?us-ascii?Q?DDT2f0fj7Tx4lFqXZl3fCWMcoGsLLmlw+nlYa3NqInINlqeNGlLRu/jSj9Px?=
 =?us-ascii?Q?81I8ZcGC6PoAdLtR1Cc+X6PZcSYVGrAC8uWYyV4pKdokqGqdr+foiHAH+4IP?=
 =?us-ascii?Q?6xVsQC94ctSkLCtjiI9SD4elujmAh5xKSYo8Ly/CQd4xkisubdwKTwCTL+DA?=
 =?us-ascii?Q?QqTsc30HbAW9yvS2Ul2/WvwIQId8tNy8CJRsogMEfgkert2tuT4A6sJLWlX7?=
 =?us-ascii?Q?1D2vE+xOZaUNE3nWe+2wUksZQo7IAhHSGBqqCcfmVXBrefGOlb/gs1DXBcXP?=
 =?us-ascii?Q?Zr4c1qxvX/vMCAO2+/thvtpPiVYmLXUh1c205DObSBzzMX7ddrjwmBkBaqIQ?=
 =?us-ascii?Q?EUO87iggPe8PCpCk10DYpWNeVVH04lRmzEXeHQnJgM/1TtPF9RNnzG7NFlfs?=
 =?us-ascii?Q?+Ll6lcfY+O+ojtMvy3YJl793HfAOtGI=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	TFwYfSNKqLn8xXVchdblgTTXM2L+gA8zpJLiaXSq+2RrIPO1BFqURoXWMs8R8WZ4vbsXO5vWkDfzYitJTxoYNXSSpgmY5PSffp+wBTdB8Dbt954fQuugiPS4aURt/Ap8xu38p520wZWKF+oPWTtJIbKL+D6tiYzsPmDRhDBSLyxNThgbPuVWQxpslAEpK+1DZWLZ0IHwqWzCgaS2DjFxiorEjmGnB9/KJdFY9i2mdtnK71uECVBisiHxYT3iM7jp7KwvhUjUnGTOIQkWWEeSVzpnPN4aOlFzZ6egrqBzhL/YWjQSywpi6OiseidHOHX2PX73kqsJvfhP9fHekFQPJhA6cZ+dOo79SwexFN2FJN0WCFrknOtSDfuwV7o2hWm9h/UuvvEk7NZEITa/KzSNkxYOq0EkZiXDIuyewsbYPyfKuOPqCcfZGoa7RbVzTR7lbN5sCeR+g5Dy8LVEtcZN8U7AHzZKgg2HDRY1hsQZVWWumRYhMID0eOZVo12S70+kvDgkahhaIlrllGz6ak0AvDjunaI9DGOpIrxnCAk+9Zd6DZ+pZEmrP9MjJs55AxH2BnqmvWRzPZtGWqpSlbRtp2gPHWCr4nwOd3MR0pcBmbw=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f85e4ba0-c85d-401a-6faa-08de5a7bc744
X-MS-Exchange-CrossTenant-AuthSource: BL4PR10MB8229.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Jan 2026 12:34:40.4674
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: XFd7EY7ZeF5K9dTQI68Hmn8yGh4NlVZPQab+4+SvJ4x66fCjsL8D4KXTcnAcutRnesy3pVxykU2eSYUsMficn4u2So+sI4xF8GDq2hrGykM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR10MB4786
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.20,FMLib:17.12.100.49
 definitions=2026-01-23_02,2026-01-22_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 adultscore=0
 malwarescore=0 mlxlogscore=742 mlxscore=0 bulkscore=0 spamscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2601150000 definitions=main-2601230103
X-Proofpoint-ORIG-GUID: YV2cijWOtMyCKMQBCEQS_iV8j2Qesphz
X-Authority-Analysis: v=2.4 cv=IsYTsb/g c=1 sm=1 tr=0 ts=69736ae4 cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=vUbySO9Y5rIA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=0asZ-QupyuckQ_gqijIA:9 a=CjuIK1q_8ugA:10
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTIzMDEwMyBTYWx0ZWRfX0gjBzCdvvXv4
 kH65nnTCrTVRyjlq4w3fci623tcsXZTTWUSCiR62N+Mnc+Rg9piOTaRrhTwabMOkb/VGf30Yu6t
 qpACtsngivQ3N3reFAQkOlNiqgPWRevfvN01xe0sWvcnYBCiZ+MWbUD5ftJetutiUOzlYTKZjqj
 NDmzqodUjSviKc0T4DQlN+hvy/XtB+sGL5zMG2RjTv+YmhbLsXeD065xqpU3bElx5DfesgGVBAa
 vbN2LvZla+dt8+bfaRkZBkEyGUBrEM97ycwkpzR6xfWEl3SmCV8k2LI6+6tteIzHZw/iSNAETbw
 3NlHvdJajshZ5VFq5qN6C1x/liqv0utQLQnHnH6gXqUb2h86ke7cQInNjHw3WfRhN0QMYV74aZx
 pqaNWqjiXEiTpk8SV8zR+XUcorBcnPSZzWUwLoLRpV739mNRsp2IYX/6zD+NuuZWRc6PgXux6rO
 odhj8MkMdtnBLjavubw==
X-Proofpoint-GUID: YV2cijWOtMyCKMQBCEQS_iV8j2Qesphz

Ah you already did a fix-patch :)) didn't see.

Well you can disregard my identical patch then ;)

Cheers, Lorenzo
