Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B0EE3B8D5E
	for <mm-commits@vger.kernel.org>; Fri, 12 Dec 2025 17:47:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765561630; cv=fail; b=r1caSmD5ldO4VpscS3LgyRFz1qqm6dAS6H3TL8dzi2MUqtdjw0/sgfII0ms1mlaV9r3ahUzwQrK9vrebf4LsoD5IfzOus0ZqqLI3hjwpcx43i6skJI/lnBwe7Fj33PX2RTympaji4JIkSWnd8uWsEIIsGOuqHk01xbw4+BMXwJg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765561630; c=relaxed/simple;
	bh=ia1WJT/CGJValjRsEO0JzlVCRZvns7nC9Dm8AT8snJA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=K1D3h8niUhPaM7pfRkTGORV0iZPqBHU7wsHI7jXwha4GE677ouvknpuGpnq59UEDlm246cVfjxUrDBbLiuAehvav+gnSOStSjp9AKxN9Tz9HQhP8wTZdR+D5ilgDZ0tPsKDMHQ/49/64u/XFqKeql8NrDMrMLbyDmSx+TkELRxA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=A1IrV48x; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=t+M+KCzg; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="A1IrV48x";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="t+M+KCzg"
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 5BCHRLd64077843;
	Fri, 12 Dec 2025 17:46:49 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=QmX29+zVsghTO55zys
	zJwhm5LMYf1PnadLeKmIuZ0Dk=; b=A1IrV48x7CCJ/Pqvx0SQteXx0JK8YEBljr
	IAXRFw/UIL40eZO/FyMQ14YjSJt592EUOUD04Cq5uv0CT0qpPAqD2PVrySFiLZa4
	psa6XeEAo+xLeXM2T4urEfzYvvLx9ig1WusRlaDHXqufYgssFQO+OSon2kWKXkhR
	cfQWq/ij5+opR8IojrOO+GV4tReARNcJ6s+QcRfbBt2xvToqIymK00EXxq2HNnKs
	Sc0OPakqwNzQwW3HooGwrYfgSOBkbuY6fvuKoqPwhJw1X8bFVq/2RnPM/TgouIpE
	jjFiEhOG4ENhGCLY11LNGuXHwwDsTJS3NREzAG9ozA4bVZxeoxEQ==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4ayb2s42nc-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 12 Dec 2025 17:46:48 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 5BCG65KG040820;
	Fri, 12 Dec 2025 17:46:47 GMT
Received: from sn4pr0501cu005.outbound.protection.outlook.com (mail-southcentralusazon11011017.outbound.protection.outlook.com [40.93.194.17])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4avaxh32ja-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 12 Dec 2025 17:46:47 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=a/e+bAQs1pqqxuafk/2qwWzUzAFjqpLuNiJGa0u0Iu0FbT+y7DK5AiO2pj/+el2e7ykwlAyp/w1xV+BTZIDMhvGoR9n8QIS2f99ToDn+fEwX4hJ+m8zFDruKKt1Rxv5yv7CZO5e5QOPUAMp2jqvulrV9MB8v8h0AszPd5iHl0+RmEJhfl572iJYtp9XrMGLjR5Y+Pc/SIz1BuJL2XEEmeaPw8wxzzlBodP6dPkPAArIfqB157yf41j0NIZwFvYM/x0dGI2iVWMdW534CLO0auxcD28FOQOHEKgv1NruY5GG/e2qsLUytW0bu+ek/bnbAi09kNKyl5LalPXt4Rp0ozQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=QmX29+zVsghTO55zyszJwhm5LMYf1PnadLeKmIuZ0Dk=;
 b=Jgkp65q+d2O7UFarKMm+QFUoBq2GBbyO2+3ynsm6OQbKJWDjDixpiWQu8WASWLR3rx/4H8v/vHOzIzyfX/FzPlRy9VTN49ki3zZKi0RThnvmFMxMLHM56veih3HjX/hL/8df34nX0VYbqZwOghny6rKDBMjw8yvLJZU0Ej7KGOobxyDTZDhufbb4TEyFDWprpX1dg+bMkBo0k2B42XBeIXYD8FdHdDsTGi7HzOcyUEn3TfwzCr0qd2skIF10pyWI5iOsJp2j0jyoLoD4djDK2NhMzqVOmrNus41LNNgn0DVqyelVHjpJTjd2nqKYkIi9bXMZmzRIyLv+tIRHRtmhRg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QmX29+zVsghTO55zyszJwhm5LMYf1PnadLeKmIuZ0Dk=;
 b=t+M+KCzgpqe7Frq9ieMSqxD/foRPrpHGS6m0UuicgOE1Ns+l+xWZ5WvNUzpHLbUmC0VTppY4NkhrdOMnMtaQCv+9mNLlMObtDUNq51QsDXtlz3c/V3bx1S2KM1gcW/FUp2D9A6ZqFJf/hmY1gMqHtdsvJpy/Z3EMio+9Ii98r48=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by SJ0PR10MB6423.namprd10.prod.outlook.com (2603:10b6:a03:44d::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9412.10; Fri, 12 Dec
 2025 17:46:44 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2%7]) with mapi id 15.20.9412.005; Fri, 12 Dec 2025
 17:46:43 +0000
Date: Fri, 12 Dec 2025 17:46:41 +0000
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Vlastimil Babka <vbabka@suse.cz>, mm-commits@vger.kernel.org,
        surenb@google.com, rppt@kernel.org, oliver.sang@intel.com,
        mhocko@suse.com, liam.howlett@oracle.com, jhubbard@nvidia.com,
        david.laight.linux@gmail.com, Mateusz Guzik <mjguzik@gmail.com>
Subject: Re: + mm-avoid-use-of-bit-macro-for-initialising-vma-flags.patch
 added to mm-unstable branch
Message-ID: <33122d25-9451-47aa-b4ea-a0ba22305bff@lucifer.local>
References: <20251205201510.3D83EC4CEF1@smtp.kernel.org>
 <95d18dbe-9055-43b8-bb4b-da40da670c10@suse.cz>
 <20251208174009.f982210c3a12ecd2459f59ce@linux-foundation.org>
 <20251209112943.6f5e405590671076f55bf4a3@linux-foundation.org>
 <5a479ed5-3cce-42fc-a572-771244108dee@lucifer.local>
 <20251210094642.113c6cc9006ffe4da771f6b0@linux-foundation.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251210094642.113c6cc9006ffe4da771f6b0@linux-foundation.org>
X-ClientProxiedBy: LNXP265CA0033.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:5c::21) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|SJ0PR10MB6423:EE_
X-MS-Office365-Filtering-Correlation-Id: 6feb2cdc-c405-4cd7-c701-08de39a6695f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|7416014|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?IWl7nuDgcqaH7KbH5O+sfE5UU1RsmaH/nD4wQ+zFeaS4uObJ4HgNar1SrDTu?=
 =?us-ascii?Q?t52TK2UncSkZMNJcuyv4FW3MW2Qi1DberdXgvFO2SoACYCsCnJ1OWNeHGw2n?=
 =?us-ascii?Q?GzhHaMHTkPPYQLLrV79ZH19WATupFIIURAUdqKiVQyhn6uaqqZUbsMH7lOJT?=
 =?us-ascii?Q?o8nispyJZtoN8PSGPdboxYlPYNHLRMFgdbv5DmVi7bmJb77YA+GQCVMt9hlC?=
 =?us-ascii?Q?Dcx6vON8wh6km9u5xO6eLtKrx+3Tf0sLUTa70eTLvXCIPypu/08u0505gCdr?=
 =?us-ascii?Q?7sTzOGmLc8ZF89FUP00V9Bthuwm2/nml8mnMw9QCUCaALEprE6D+eb3b+0zV?=
 =?us-ascii?Q?kyNRhrayOSOFaOWkYXZfpGs+kF8KeaL+4TNWq5pgBcW3BjX7IhBd/IUrpGvH?=
 =?us-ascii?Q?Xj1d8clq77UDmpiA5YzelK5oN60FXINc4rYwujCuthS7GZPJ+D6G4etA6677?=
 =?us-ascii?Q?S33IQw493FYhH7IeUNtk9Ei1sHwQblVhAIKFCx9IVWIs5VJFS3E7csj9hkBs?=
 =?us-ascii?Q?KgW3XwcMH+a6iK3NUWhca9N79rzqwgo+yYyhl/nbF2EHtvRcmFzvDWoGyH68?=
 =?us-ascii?Q?sD8VVuYqMKL8/ZBvYza6coA+8FcnOCh0F5AxsrTLSDeMPpN09lX4nLjahy3X?=
 =?us-ascii?Q?hT40hxLTA4ObnBnI67jDIfI4lUqwhz1XDPSn6UlZ3uREBWgGqRh/XMyoRI2z?=
 =?us-ascii?Q?FfTmsgPDfMMjMqsw25jvG85rcXJ/nqCta7x3i/zh8jQG8F3wxsee/bOrz1pm?=
 =?us-ascii?Q?9NO1UM1SEBgFb2uzBK5KJuzpJoZpszg2Fw4Pdt0Xx3y6cqCaA+ktRT86BmTY?=
 =?us-ascii?Q?AuypIjT98hwSUGvjKhIcSo+4rszF96fxfoEChEtrt0Fwzm2IQUf2Hsu7I2GO?=
 =?us-ascii?Q?JYQlQmHdfxTqog3dX7oqscLA8mVsbiGUu37cnV1YROXiu6YeUZYPf+VOmVok?=
 =?us-ascii?Q?TBJhd86OVZhKHvR+X063g8NB2m2SB4V966Yut1/17ZZ6jMAS+/pVrPyZ/9H7?=
 =?us-ascii?Q?9oB+U8TKzzK5u33RkI+LlOWtD9nNe9j34ofb7mLxkjxh+xXzESKGdghvtyCx?=
 =?us-ascii?Q?hYKly198qV+Fw3i+lTUDSmyoBvojzzLRRiiSGw9J3Nkk/iZMskJaYP9u2C4z?=
 =?us-ascii?Q?xPa2SzAlEMazb8pjWsGn1ZOy/hoPPomqVVpWSnZ6BFgqT0A0moquRY46XTsJ?=
 =?us-ascii?Q?TuKpGclRTnvj/cXgj+TxkR64VRkJfdDEB/LP+b5ZBoBS3KTco5Mc0QQefnR/?=
 =?us-ascii?Q?FW1L+rydSCdOcp83drhYDcUWA+V6I7X9uhtnOkgNfWzHtL0wM98e+6HF8XEO?=
 =?us-ascii?Q?Dqy5cqjG06HBUn7PAQufxXfEejb9jiw44u08U6RQSSonj4NDOUhOnekfh/Ac?=
 =?us-ascii?Q?w289GIbmLI08CavvbUu3UGtHD17Hu3P4ZODBwqgBW6tTqxAguVP2u2Bg/nkB?=
 =?us-ascii?Q?wGMLRNZ4RuCYNl7450yulTBO4WPAxJ6u?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?NxH2fXVdE6Hh/tNZHnqi418KdW/m6TGfG6dPzJEJMIi/MSelAXj8WD/0xkMS?=
 =?us-ascii?Q?J2r7Ti5fSkEN3PfyWcX8iCJRUAfhTUspCwp1bTvOarHndwjxbfWqR/mvxtB8?=
 =?us-ascii?Q?7E5+ezTpTnXHZy5BlN/jLcmsyqanXw+FZQ6+Jr4ydS/VbTWwgRM4p6DH2x6R?=
 =?us-ascii?Q?ae4AfOp4wV1p7avWfKJrzuBHvMOkmcYiJfPuroIodG+q7sPJ+f28544JaME9?=
 =?us-ascii?Q?hSQOg7xxA4oEtpEdzNr4Aj1EiahbOQYai/lPKFKxXWMmGypmTGaoNQ8XZeU7?=
 =?us-ascii?Q?/xrsEmhceoX5vPlmhkAdJ8YFqa+FgmJyyepYlSzTtLl6jWJUzET7UIE75RcJ?=
 =?us-ascii?Q?KGG6idv5k9bbJAeFZwz9GX/ex5nsScqa5YbeKAB0a5+RJGC/qVDS2jHf9n4j?=
 =?us-ascii?Q?RirkEl0S7U/d6aDcHPsw8nCpPolCozxUpOqYn3BJJQOZy5AfQVIPJ/BrD/02?=
 =?us-ascii?Q?1LolgRPuSwsGU0VNTtgW4qQ0QUy6ycWS/nmYzcRxfojj/OxsmyboPyBUwQW4?=
 =?us-ascii?Q?dEMqjLQzNVZ35Pr2tLvhyTOt4aGjCuRZV/mhpZXJ2xE6veF0Ce+i9nBPAB0Y?=
 =?us-ascii?Q?oJGCCYPGcJdDb0U4Pu9njgmtPoEgvd3olWCB5cMnc4XiTUe6ThKqqbPh+tQz?=
 =?us-ascii?Q?l9V8rqhr5JNUFoFo9g1EallFUbThTC0gtkHAcRVpNvtwl3VBh+iECByoU2Sx?=
 =?us-ascii?Q?PJ1bXWzOtZQVzj0vQDzyu1J29PrLbbqNjo3JTjgugTtKwOGDfu8DT78+/7hZ?=
 =?us-ascii?Q?zyLLDy04zodUxwMlWMUDn8vSVFvu79xAEQsHAp9U0rIOO0b5G5DYPUv6szjg?=
 =?us-ascii?Q?NDOGyRaa3Qp4OVI4sLN7q/fOIp6zhQ7fnx3p4zrIMt1WVK6qEop8rV6V55sk?=
 =?us-ascii?Q?4p8T+odx7orpZQVEeFXyA/g16heSDgccv5xzHVR2FESGJH+HKltLEzTPR9C4?=
 =?us-ascii?Q?UgxMlPybwKZE+EKRbv4LhDXjkHtM1+ehKmJB4OIjbcNtEH3nxUc8GSm6JPrE?=
 =?us-ascii?Q?8DKRxLapLgMhOd9JAavO3kQPkqMtsnXJhifk9oYqonihaG8tQq/8RgZphUtZ?=
 =?us-ascii?Q?gfnfsjx7pkTFL8tga96R2dDweAbLtC/5JSueKcmVkPSWIkatuN3fIbMOEVPf?=
 =?us-ascii?Q?SogRK6VqAED3lyZI0klQiEvI6uJSitd/4HeEuyaTNz+2OPiZXZ/yfSD/NcnO?=
 =?us-ascii?Q?0Spl9cA2IY8m5Qbakoqg2uLSHxWxJmRF5y/offBsH7pX0E0Io8T8wYJAbXhA?=
 =?us-ascii?Q?AlLzcX2gJa5uQki94NO/33Bw17UhakhQigDEknYsmmONzQvfF1Jidod6NuQj?=
 =?us-ascii?Q?Q2Ghot7mz06oHLbimbkWg6Zy0h6S5whskw77jtjLkDv8nXgnYOqkWNuQmjXK?=
 =?us-ascii?Q?x5GSAbIf13AEyPJ1XXBH61E72p1JVlD5INL+KvQe2PbHMPfBOGHCfGsInnJ1?=
 =?us-ascii?Q?Z+KQFD+6vTuBdORhj9Jfb+sH+k73b1gj3gH67TYzHnYL1wIhQ7SRt9j3AFYt?=
 =?us-ascii?Q?UMlnpkuMc1EJZ4FhIWYMYup2nAQdYMqbD9BYv7kJ+gH32+Uv3U2zBcY5JsGr?=
 =?us-ascii?Q?jEdZ4VH+7+9rNUScIyLSwcBS44RrIpCWKn2Q5sSBIB6McvD+9qax0/xrcy8Y?=
 =?us-ascii?Q?lQ=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	1pgqC+my/g2R2gowjhC9sr4FgK9GLYB29LEIXRtuQUqWHduLe+BbpUaUOAOlrXj1VdyUc0H0MFFUExKZDVmnMmSRTIotlz5oP3l0BOY3dVHwxrX859vXYf24Hwl4eScYYYuaC5T82HxKStYEGqvbA2O6eDQtAVggkfxrS7Ffn3C0AiKmTxSEyRC4HLv4BHuQjRCseuQL0keFsEe5LOg+i7XngVbZ1Rpdwinp6qoHNu1+9bAmPLcw7Sn7eI3GCpEamH022F+Ae9jGbXQBufCBcaX0PH7dTWGJ66dA2vfsIoEgqyt6omhfhmuCZOmg7reM6yxMV0oLnbR2NqGvZfqB/Zpcd+skUqyZhft3Wzfqp7v1r9fmW3OBg+mTAy9fRnpDjS5OhPoRw8u7vFE9y5EOJ9s+uxCwsbie4xvypMl2Zopn0lxeybV3mhg5JRM8LZjE4n7hheEvAknGeTynOo6qqyXKWpmXgpY3IUsnLYfmECWjD0c6A22FTEV6MRS8aF6Bwe+fAOz5IeS4Rj+dvbLKNVVPA2Yoiz9XJnk3xW8zLJMWEd2fJdQ6kFHnXutcBsnnc/zAfT7clbIRAgRqvQ7lHnGjeZ7DxmXWh5DgosAve1Y=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6feb2cdc-c405-4cd7-c701-08de39a6695f
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Dec 2025 17:46:42.9692
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: oce4wod7BN3rxz0pQnUNYYk2irlbOhzXCTTyx2rHEYX+67rjL023wG7YYT3X1E8B9suYAUl0KCfdtWFECyS42hLOKZ86g6N+gBuWH4WdqoQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB6423
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-12-12_05,2025-12-11_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 phishscore=0 adultscore=0
 mlxlogscore=896 suspectscore=0 malwarescore=0 bulkscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2510240000
 definitions=main-2512120141
X-Authority-Analysis: v=2.4 cv=Raudyltv c=1 sm=1 tr=0 ts=693c5509 b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=wP3pNCr1ah4A:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=yPCof4ZbAAAA:8 a=1N_oQtNJMjk67hd6EPIA:9 a=CjuIK1q_8ugA:10 cc=ntf
 awl=host:12109
X-Proofpoint-GUID: S1g0AskFoEK8riO0T7m9nFZXBIa8-YcD
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMjEyMDE0MiBTYWx0ZWRfX00+E6NWOSKGS
 Bn5HxRmQa9CQsEb43RmqLvaL+HYuoZxDtJeT4RAkRdzDG92eNWH+h1S+QGRdp78YZzRWzY8f+U3
 z8Bs5pYc3mN91cjMbsrpkLMCM/Y1xXbmWGsg+NXH21AE0CX9oyUhVXPR7wUNV2Lcoz5XDM0Icmr
 D+CDhpQ4pEu2n55lfRg5x5Z5QfgXiPGmUhtrhLArqO0C/SFRe54rZOMHecP4L/DRwBXuoAY0CD+
 pzEORdogetfn/XfZh8vZImAp6j9ntGuSTD/gVOufP1awsA3+2a1uwUr06NVFxN2POnyB44IpCo5
 mCOR/o4y7Pd42Ih2bvUd2sBEDvfvFsNLuUF9lh5S9lZMx7vVsKt7baoREVv2dbFL552NmTkncAX
 LnZTdKKqwwPOb5duevjDUOktR4omkj9iQP92CpUi8B7PfOMRoJ8=
X-Proofpoint-ORIG-GUID: S1g0AskFoEK8riO0T7m9nFZXBIa8-YcD

On Wed, Dec 10, 2025 at 09:46:42AM -0800, Andrew Morton wrote:
> On Wed, 10 Dec 2025 09:36:19 +0000 Lorenzo Stoakes <lorenzo.stoakes@oracle.com> wrote:
>
> > >
> > > So I'm holding it in want-and-see mode - we can add it later as a
> > > hotfix.
> >
> > I mean not sure it's really worth holding back given this is:
> >
> > BIT(...) vs.
> >
> > (1UL << ...)
> >
> > Hardly something that is hugely harmful no?
>
> Nope.  I'm just giving it some settling time.  Doing it as a hotfix in
> a week or so is fine.
>

Actually, given we've prety much confirmed this is random, unrelated behaviour,
I don't think we need this patch after all.

Thanks, Lorenzo
