Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4836614C5B0
	for <mm-commits@vger.kernel.org>; Fri, 29 Nov 2024 12:06:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732882002; cv=fail; b=Qgtc9keuEcpuZU7NyW6Y8/MehNGr2py+sRvRAgt8HA9sNnWCYFx4GVrwrDt5trh0+pa1h2dq73+1+Wnl4jBmcTY0w7pn+/O7woCXL6aUFiiQgblw0sR16t7Qd4bx4yLHpL2mqZiV104jdU1y6kkHHqWMHfcPKDzq6Ixvs1gNaZY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732882002; c=relaxed/simple;
	bh=s9UCrK7y5ZXEWQZCh22575gt+B0u/DjA3aRJr0/omVs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=ACh/nrM8+VjfKIr4SMnIChw60Gwq8nYRGQqKnBqhJLcNI2LZ3aKvSji+/gdm/njezu/o4a8SUzvHrPtv/cyWjujrbDyU3Y2YYOk/3uaf+Mhkw4CKKFK18al8/3CmRCrhiXU5kQW28gjyqBQtmB+5q7YY4Wv/0VG3dLJCZAiVBlw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=g5Nba4LP; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=KzSshhSB; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="g5Nba4LP";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="KzSshhSB"
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 4AT1fkiX021974;
	Fri, 29 Nov 2024 12:06:25 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2023-11-20; bh=XEy336rQQlvZtHgTrX
	xlewE3yV/Kj70RMbsdCurDLCo=; b=g5Nba4LPXHImSpUurLn+PUx7WrIdqUUWPc
	0DU3i9X00MDVRe2iivhqdheNM9IOVtjYDqZphZpuoeLKBM7g7jveaYnwBVVBtgDw
	MgcIaBm7dSDiwZWQAmEEnKfySWKXyZf8dd551ECW2Xaq1f4ACjo93/XXSjryNIqh
	1mcm9Z7a7GSj7OHn/AY9epiuqCGNAiSlQFjeW1QMg0IFhgLbhcc5hchuVqK/FVnr
	XBewPcaQrJ2HNH/xF+U5WTbRTM3TZxSf1q+TWnmDSdtomxySd+IuxY1BUfOM2atA
	QSKM3XZmefyX46vnKm1Vz+3E5njPH+z3SmikAO1KlpZyYChtgaRg==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4366xy38q6-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 29 Nov 2024 12:06:25 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 4ATAR8gq014243;
	Fri, 29 Nov 2024 12:06:24 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2046.outbound.protection.outlook.com [104.47.70.46])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 436700m6bb-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 29 Nov 2024 12:06:24 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=LAqwatlZzg6J3NwJvFVZhh6qxKGsb74NFCDYk2r+7F3ox92LnkPPpBqZZi21vIGBdD0s/5LFWJTCkWnz4CiiSX8OoeALDBcRkNJZZ6mwrYbHWHXoECb9q/6B5f10CxvcxS/Oj8UPtnHMuHM+JEL6Lbul8mDufNss4u1Ys8DuL0j8ZU2yCAFRmthZKs3ggKAKWw0+00flo6BLtWsxNozxNjNPGs/1rhDrdWp/1yOfVHpmxYD/jio9yio5GQcc/f7pJtXhvpGGT3xoxKbhDzeXuTVHLdqBbz70WFyVpVwTDf5Ctf4rRPPTrxa2XWnnrQ3MFBYKsZLEeaoOmtsvWnbMbQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XEy336rQQlvZtHgTrXxlewE3yV/Kj70RMbsdCurDLCo=;
 b=G6IJR856ypQT5kSn8ZlLSBNW5MhmcX+QZk0jlYD4lOL6UMGAJfMLg9O1AwpAjhiJgohq6weSRsiwccsPp1atG/lY8FNtVeOoc8LQewEXDRaYQ/+jtSf+obwfMpqUKRdpZ6+jjpmAKBYgiMsZD99BntRU5bdXFeq0RV1EA8z09L1AnNbtM8jvEvmPgFOzhYNsotaUJGzzPAxEqxIyPbOfhxJUvufWTXoKHdqbjbXkm9+d8fwpNHvBzyQGSJnY3sR3ZW4OnKkFQhAZK0LJpKIDHmp7pWTpahD+ekj/75XisztiNuLDoIlxQaN0PIPvRsq7R9G3veXM6wsGlZ3mAcPbnw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XEy336rQQlvZtHgTrXxlewE3yV/Kj70RMbsdCurDLCo=;
 b=KzSshhSBee31my4/9KKImi76YeuJe+RnZWa/+csHBsc3WJxgoi8vHKl4USbh6GVebyau7zwwmFfkAUb3uDOr0zhCwfc0Rm6iX+uzSAKIw3R5Kp6SVbQBfSNuvwNn3ZAg7/Bti3b1GbdyBwIdLSX+/gqrPa1B6AYIZe/zxMDUkSE=
Received: from BYAPR10MB3366.namprd10.prod.outlook.com (2603:10b6:a03:14f::25)
 by SJ0PR10MB5583.namprd10.prod.outlook.com (2603:10b6:a03:3df::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8207.16; Fri, 29 Nov
 2024 12:06:21 +0000
Received: from BYAPR10MB3366.namprd10.prod.outlook.com
 ([fe80::baf2:dff1:d471:1c9]) by BYAPR10MB3366.namprd10.prod.outlook.com
 ([fe80::baf2:dff1:d471:1c9%7]) with mapi id 15.20.8207.010; Fri, 29 Nov 2024
 12:06:21 +0000
Date: Fri, 29 Nov 2024 12:06:18 +0000
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: David Laight <David.Laight@aculab.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        'Jakob Hauser' <jahau@rocketmail.com>,
        "mm-commits@vger.kernel.org" <mm-commits@vger.kernel.org>,
        "willy@infradead.org" <willy@infradead.org>,
        "pedro.falcato@gmail.com" <pedro.falcato@gmail.com>,
        "mjguzik@gmail.com" <mjguzik@gmail.com>,
        "Jason@zx2c4.com" <Jason@zx2c4.com>,
        "hch@infradead.org" <hch@infradead.org>,
        "dan.carpenter@linaro.org" <dan.carpenter@linaro.org>,
        "axboe@kernel.dk" <axboe@kernel.dk>,
        "arnd@kernel.org" <arnd@kernel.org>,
        "andriy.shevchenko@linux.intel.com" <andriy.shevchenko@linux.intel.com>
Subject: Re: + minmaxh-simplify-the-variants-of-clamp.patch added to
 mm-nonmm-unstable branch
Message-ID: <15a2907b-530e-4d0d-9b6e-3fc5a290ecc6@lucifer.local>
References: <20241129111143.DB800C4CECF@smtp.kernel.org>
 <f0db5571-8c0c-4a39-8bea-e802d05deda4@lucifer.local>
 <496cba0483554fa187d2346159157431@AcuMS.aculab.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <496cba0483554fa187d2346159157431@AcuMS.aculab.com>
X-ClientProxiedBy: LO4P302CA0007.GBRP302.PROD.OUTLOOK.COM
 (2603:10a6:600:2c2::14) To BYAPR10MB3366.namprd10.prod.outlook.com
 (2603:10b6:a03:14f::25)
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BYAPR10MB3366:EE_|SJ0PR10MB5583:EE_
X-MS-Office365-Filtering-Correlation-Id: 77e1c689-def1-41ef-f559-08dd106e3d55
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?CQMT7/7aTmfLXi24kEe/2OHwRwvz4VwhxPcayHtJE95epUPspYaKqDLR899s?=
 =?us-ascii?Q?D+0nXoVC4Kp6AN6TmziiGesNVmNENla0d2+OpkN4LM7bFZBF+H1thNlSxdSb?=
 =?us-ascii?Q?8dvRauwuxCQMvBaV4IjuFodFgaCUXZXYHOLxgqbSTdpRTWyyPBmX2rz0wtgw?=
 =?us-ascii?Q?NnsjvfWpJwWOMWdicqq3EHfWWIcD+ZQGZ4osaC6J/uaJy7VfUHfW7Vn1gKfP?=
 =?us-ascii?Q?Zlt7AMEw5g3YgOkCCVa4imHykZG9xzszCGe8wEU3nxyyZNH6V24W8afg0jZM?=
 =?us-ascii?Q?ORQUIe9DPohOFF6UlycZiHBDiVVkABwK51h731Ti5rzPGSjkxkIQKFTldA+R?=
 =?us-ascii?Q?1gnqaeYBtLVOw8kDbH7i16V4pZFQNPgyKjkXvWGs9aLQrXnqE/6TzfpBDu8m?=
 =?us-ascii?Q?0kRLqUbiR/0wUHoY+5/OjF+GfmDg4zeksYUWlBTs1FceCf1Q5diT8yptKZWk?=
 =?us-ascii?Q?Ag5bMBmZ2vm8FMyQvqVfLcC/rV+L1U+SIynVVJkKUCElqUlCJ9HP5yOzc/3E?=
 =?us-ascii?Q?VaxxmJ/2PZHonIPAyRkUUAHft6Iy9idh4Tn+bn3cGpounRWQyM0OOKKVDyB1?=
 =?us-ascii?Q?NhKU5XOva2P7XBpYxqs/g9pobccfeX+tLFpW4rXSbUXs5J/+iV3f+JFwEXME?=
 =?us-ascii?Q?I0weRGXPniwByj04buTtsS0GwPW9k8latWnXQMREUvneQ48Tp6WTe0N4mOhj?=
 =?us-ascii?Q?+a8JPTGl35itwBD4MRnIIs3gcmWGBdWRaTSj62DqdiKi1NUxQB9WyAwiStbx?=
 =?us-ascii?Q?k6ERTuS8uBmARsLdZBSVsT4/jmDXWc1IFfbJwmsvuXs3HWl6jWVHSlQUklhK?=
 =?us-ascii?Q?jZobLZ+ve4FJrpy5vDEtIs64PLugPd2BxM9WHPvOJSr77FC3BK57WO6nuxBZ?=
 =?us-ascii?Q?GLk0TqsdHE5hoIVhJBxlfTE3WyyZ6ngnO6sfSIsz3TpdqrBYPG5zSIx6l/H0?=
 =?us-ascii?Q?RF/jxVwb0xVz6EaBFVLLpW22+3E/y7eYuCSJMdAPPRXQRSUbQGVZtbNTx7r/?=
 =?us-ascii?Q?JNZJIkAwAXQQ47xIfzbNGeaBAKYENzHX/dg9RlP8Rxs4z7sVEsoAjLQgzlXE?=
 =?us-ascii?Q?re1TizEA+UHW+wsZMgJvFixRZ1XT8YQaA31oGdPX578ku6hQxzLlzcPdBqtL?=
 =?us-ascii?Q?MkoIcr4CQog7JmQ07k7HbJ9WLzxF3f/fdXag+lIXPO8VwfRRCS/rIBEg8Uuu?=
 =?us-ascii?Q?UYyUzB7GwRFrvo4oR2RQEREBTtRx0b1Py2Xbxb79oyAYvMqR50hXE4ZMCaVo?=
 =?us-ascii?Q?ahpH0mvkCAt599J66tIrACPedzDeyXhPZ/9xgKgrIBr+fZeJTomMgrN2QLBg?=
 =?us-ascii?Q?tFTv08U8te/7IklmB52WVAP0bmlNqmuhQ0JmW2rb9w37UQ=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR10MB3366.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?tCMIFSDQnweFySFLUYVW1k+Ac9wxBbtU8YYkn2K0WivrP2JJF3Jl3Ja618eG?=
 =?us-ascii?Q?GmdW7t92uzDxbME7xeYBxRJiZeCqzwChRFY/cLjbXQ+YsBTJDw+mcWzCRRBc?=
 =?us-ascii?Q?e20zJhfoRJJRz54h69y79YhEQpF652sCCFyF11yKji3aNjLv2qsiy+o1bSoA?=
 =?us-ascii?Q?cK+HHeYX8dNJUQnt0fBEdPQQptwrtGvRuC5j/PA6Fl6DsJy3QQNiSNWZjm52?=
 =?us-ascii?Q?z7yxm6c2eTQsglYCozyaoNkjbsrGRl+PYEV/X2b9LXa+qJz7nWwWlaf+aldH?=
 =?us-ascii?Q?l5WaucOUPoTcyPyZLcePWm83caBdG4/mESMb7xNi3RnAX11WDcVg3nvmrnMQ?=
 =?us-ascii?Q?ULIyN/eh2oe0Q4q4X5cTunUKnkCXFTkAd7ACug1DPxglzKOV8LWixNq/3J0k?=
 =?us-ascii?Q?UeayW94luhTYTlIKYkH2A1AzUXQjyYA5RfNU5IOQkIRNQkQTdNfGpdGWYfMG?=
 =?us-ascii?Q?aOrBV52TJGFSf+S4GeYL+FQvV6y8u6IdAc6Ol5qHo9KLUjYh3lx46LwFKl/H?=
 =?us-ascii?Q?sIIEIb4F9Qt31mPtZ6FYz6+ild/pJV+LkMUBx4NTe9SaOelY1HVKv7/aberG?=
 =?us-ascii?Q?BNbr1Vc5u6sJFNeSSPAn57LOzF3MDmVXDhQPEGgq6O2wjpDdVAsvvV+f1IHP?=
 =?us-ascii?Q?73mWtPY4ZT6FW2zVAq+KxlHy7D5q8XBOL/W13WOac+HYP5RqCdgKau1/ZPOM?=
 =?us-ascii?Q?Q0tvKgpTfwh4PTOaR46MA/geZeGkrG0fVRO1Bec9+TblpkSj9vVw/R3dL84q?=
 =?us-ascii?Q?popRZF02wD/zIbh8p9noqG4+yv1DxtRVpUCbBG6635OamW91KjNzeS9VevVn?=
 =?us-ascii?Q?wbm+OZSbktyLKr0T2rqSLIyRhZz9U+xQ7XJy22ezF00wim4YVG+pxEg/ygcp?=
 =?us-ascii?Q?7cyTh0RrZxi4FEpr/J51T8mn/3J5F7Aki/+XSWi6axNzJEWjbv8LHLiuVnPg?=
 =?us-ascii?Q?geinPD3vgcnO83LNP0y46OujJFxPhvsfHm2LtU81LMR2uznte2h8xx7KvFGe?=
 =?us-ascii?Q?jfuEUR4Ncx9lPi+2GvsqVGV9u46dtiqXCsTFiErn5fOhxQaggd7wGAG8Ba3s?=
 =?us-ascii?Q?KihQjwR96x+OHObP/+JgUW1rOT9XTBTnyH0Vr5fp1PPRMwCxAUzMQiGdLHVv?=
 =?us-ascii?Q?u7VJAyc4/lPld7ELiPHOFN9INx81IBfTfEzgeV7nSsUQXytDwH8dCt8qTnCz?=
 =?us-ascii?Q?01+KEd/E+55+3XYKjjRypQkuCsucN1DWBLUUUgDFSVzTUSG12eMYicD8Xk3z?=
 =?us-ascii?Q?ipma8oonsSiVmMBmRkcBsWAXBJWZeEE0rm8BBaNwNzdSu7lChfhRgT5BTiWM?=
 =?us-ascii?Q?lpFoBWz2ZXAvlOt4GL4mwG2GaxeXnStSJAXWCY29C+vuofEKdo2qNvaObUu+?=
 =?us-ascii?Q?kJsmg6Iz74KI/gpYtLM/HGdfGkdH/i5YCbWIrOB3WPAq1Yyv1X7Fz3fYNbTW?=
 =?us-ascii?Q?fRntI0n2SPSSdmuzbtAF2l0tnZIDa5TVUijZVOVlMLEjIXB4zGx+wl9NDTZo?=
 =?us-ascii?Q?BUT98QRscNzcZPlLgoKlundM5NYNvyAME7tHBIAVuHCBGnGPR91WycBxff39?=
 =?us-ascii?Q?cD0F9gwO4Qq2pLHw7dJQiiahTr6704eMsq7KFDCUh+Ibqjvzukm/+nxZ/PYV?=
 =?us-ascii?Q?1Q=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	eegBMrMiCzwY2dsVNaqhTRzh5xT9m9dmwMeFvIR4/UQcd24fPbxJsKPfmqzAtP3E735Khq+H302OHoKxunnfk6m/FI4onacIEE4Njfux1v2EgJ0HxB60AcDy448jF/2qKb12A9oFLw1hW4Vv2q6d1jDbSLqKqXCwXZrUAsd+3JU+KZYimzYCowTi2r3S7mCeGWbx9nDPadNPmXSpTS33jtc2xWwNRIRqflwU6GNDkf8mRRN4WKgTm8Kr6S4BqXdYokotXlnGlcYpj9JTYR2kVusCsTrWc9E1Rj0raWyf86nnbhAEK1jmIc+S4sy4Wenp3XUpHGt5aTJ2CsWhW/HrnN+TaG3z74O5wBxF7phjQQt91otoap5impx3FvByO9RZteGaNoaJl3pmyw8DWKRjZDO1aV9D44o2fUHDg5tD8NNUdC8xId1BGJrfC8Pm37BHZLJu/0A/eZFdowsS+C30e/COxX2TP9hVXLaEy+YXpOi2GgiSKl6nYJwUgfFWWnerU4hHwCXTACOSdlfg/ZKtbP0govsLLcQjK5a/q0dI98fAPHouTRpw4QGxXKef6Z36L3XXAMTep5s8axOaP2cAypdG0ifkyB810I2JpUj5Ods=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 77e1c689-def1-41ef-f559-08dd106e3d55
X-MS-Exchange-CrossTenant-AuthSource: BYAPR10MB3366.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Nov 2024 12:06:21.8876
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: igIN2tmbFf4V4awM8YNLGfLZHTdB6rdTSQSKOuHJquuFYqSzHK/Ow9M5bhoqE6ZA/Nv4iF/NpYN8QGeWuO/9TyoW5pU+6R6nRB3EEmlFztk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB5583
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2024-11-29_11,2024-11-28_01,2024-11-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 malwarescore=0
 suspectscore=0 spamscore=0 phishscore=0 mlxscore=0 mlxlogscore=999
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2411120000 definitions=main-2411290099
X-Proofpoint-GUID: -6MoTm0t5wNT2AYMva9sN9BG6yja1_zH
X-Proofpoint-ORIG-GUID: -6MoTm0t5wNT2AYMva9sN9BG6yja1_zH

On Fri, Nov 29, 2024 at 11:56:01AM +0000, David Laight wrote:
> From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
> > Sent: 29 November 2024 11:46
> >
> > On Fri, Nov 29, 2024 at 03:11:43AM -0800, Andrew Morton wrote:
> > >
> > > The patch titled
> > >      Subject: minmax.h: simplify the variants of clamp()
> > > has been added to the -mm mm-nonmm-unstable branch.  Its filename is
> > >      minmaxh-simplify-the-variants-of-clamp.patch
> >
> > Hmm, this was generating kernel test bot reports, should we be taking it without
> > that being fixed?
>
> That is reported for W=1 builds and is correctly reporting some very
> badly broken code - that has always been broken.
>
> Probably also only affects allmodconfig builds because the code in
> question is unlikely to be included.

Ah fair play, you are poking around in some creaky, cobweb filled bits of
the kernel so perhaps not a surprise...

We should probably try and sort out the W=1 stuff though! And by 'we' I
mean you obviously ;)

>
> 	David
>
> -
> Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
> Registration No: 1397386 (Wales)
>
