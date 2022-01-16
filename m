Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 99D33C433EF
	for <mm-commits@archiver.kernel.org>; Sun, 16 Jan 2022 16:57:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235781AbiAPQ5d (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 16 Jan 2022 11:57:33 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:61952 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233168AbiAPQ5b (ORCPT
        <rfc822;mm-commits@vger.kernel.org>);
        Sun, 16 Jan 2022 11:57:31 -0500
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 20GDwGDL016661;
        Sun, 16 Jan 2022 16:56:55 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : date :
 message-id : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version : subject; s=pp1;
 bh=774M9w8Jtp2a/KwKcSOTUXpsM5N8I9zL6lNGnKc2z9g=;
 b=dysHkU1Tu6i4HTUPtGremr11ldXr1BZwG3VLN6l4b6F9wD57EEHT2LQ+13AeXDxC974d
 JjPlnuwR7l6I9761vw9V9shPh0x+PsICXDycDpNFd+4gar3+g15XfKRyGvzm9qTYJK8H
 E0FjwgyiJN+9WeHzD1lFN4eqcWI311CmpAxqhrJZb0RVDo8quyJRZAxnMJoxAeVU8van
 rFtOkFYtS75o1ODJ6WA9/ZqqBBU4lxj923IIyJDFsC5geJ/MjyQPM+refubr2kXFWnrc
 TyzmXq1jtLtSKzZd8dkTpNwsMe/K+dPC8aYWTubfnDL8jQKmDXoHsDL/ENTCENsuaN7f LA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3dmmq7adac-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sun, 16 Jan 2022 16:56:55 +0000
Received: from m0098399.ppops.net (m0098399.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 20GGs9dj020238;
        Sun, 16 Jan 2022 16:56:54 GMT
Received: from ppma05wdc.us.ibm.com (1b.90.2fa9.ip4.static.sl-reverse.com [169.47.144.27])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3dmmq7ada3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sun, 16 Jan 2022 16:56:54 +0000
Received: from pps.filterd (ppma05wdc.us.ibm.com [127.0.0.1])
        by ppma05wdc.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 20GGsKT0015851;
        Sun, 16 Jan 2022 16:56:53 GMT
Received: from b03cxnp08026.gho.boulder.ibm.com (b03cxnp08026.gho.boulder.ibm.com [9.17.130.18])
        by ppma05wdc.us.ibm.com with ESMTP id 3dknw9g4ce-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sun, 16 Jan 2022 16:56:53 +0000
Received: from b03ledav003.gho.boulder.ibm.com (b03ledav003.gho.boulder.ibm.com [9.17.130.234])
        by b03cxnp08026.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 20GGuqev28770776
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 16 Jan 2022 16:56:52 GMT
Received: from b03ledav003.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 94BFE6A047;
        Sun, 16 Jan 2022 16:56:52 +0000 (GMT)
Received: from b03ledav003.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 693516A051;
        Sun, 16 Jan 2022 16:56:52 +0000 (GMT)
Received: from mail.gmx.ibm.com (unknown [9.209.244.199])
        by b03ledav003.gho.boulder.ibm.com (Postfix) with ESMTPS;
        Sun, 16 Jan 2022 16:56:52 +0000 (GMT)
Received: from m01ex004.gmx.ibm.com (10.148.53.60) by m01ex006.gmx.ibm.com
 (10.183.153.187) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.17; Sun, 16 Jan
 2022 11:56:51 -0500
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (9.221.46.12) by
 m01ex004.gmx.ibm.com (10.148.53.60) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17 via Frontend Transport; Sun, 16 Jan 2022 11:56:51 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=L6mSvy2bQvVHK6YWAPfswiWITzhumRa4W7x+kkYgPXFhgr/K0zz1SeRLR4iTEzYtV42MT4EmFtgoaiE/0X4Ktv/D1I+9a6UCJ/1WXQy6mf44S9NQ35EJhZDre7Xchidd1qE/zYSZW9scphPepZiPoSO8sHjKA8bDMm4qNo4BaH8gthQAM2etA7qtiMT5Vp7Cy5MKNghlV+D8ZegCPhW5zsjM7FRA2gPEa4902eFb1ZUoSE7u8lVyUrm24OrA0ThF6WEdnCE2jfhphrFBkT70Ztq0TWOhQfnHtvxdAdVL/HbT6LZY+/rlVTOzp5FPsRz2PrlSvLuN1mpyyhp3Tzi6Eg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PlokujQKIwsJe1+4TlDngtJ+LWAXMTNpXL+M8s0sF70=;
 b=bHv+3aXJSA0+YOVdsvRQcT3d2u73tkGNJr07WwpnnqtSRMIA+fNF9Xkjw7gVPXSP9DFfZzskEtAU7DiHr6GK1fNF//ry8QxOwM4wgeDCTwt9kDY20Qoc54HCK98Ge/hbn7UEgy68+kBrGJM1ZPUckgFCH+uT1G5wmTkE0ad/alspWXpgkUPAa5VfqIvnDJ4MvzMbLCE4EuIf+h9Qnlo6HieiSxksJ9mCT4hyBHr+kGpFkF+WYJXymVVPpSTRQoI6p81KsZXzwaAys+hwtDV86hfDM/Si13pkcun+PFinjjxK6zQYrV2M/CyANFgvmWdHRMfHi0uAZ6TTcto0pzChnw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=zurich.ibm.com; dmarc=pass action=none
 header.from=zurich.ibm.com; dkim=pass header.d=zurich.ibm.com; arc=none
Received: from BYAPR15MB2631.namprd15.prod.outlook.com (2603:10b6:a03:150::19)
 by MN2PR15MB3119.namprd15.prod.outlook.com (2603:10b6:208:f7::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4888.11; Sun, 16 Jan
 2022 16:56:48 +0000
Received: from BYAPR15MB2631.namprd15.prod.outlook.com
 ([fe80::31b8:a1ab:2121:fba3]) by BYAPR15MB2631.namprd15.prod.outlook.com
 ([fe80::31b8:a1ab:2121:fba3%6]) with mapi id 15.20.4888.013; Sun, 16 Jan 2022
 16:56:48 +0000
From:   Bernard Metzler <BMT@zurich.ibm.com>
To:     Andrew Morton <akpm@linux-foundation.org>,
        "bristot@kernel.org" <bristot@kernel.org>,
        "caihuoqing@baidu.com" <caihuoqing@baidu.com>,
        "dave@stgolabs.net" <dave@stgolabs.net>,
        "dledford@redhat.com" <dledford@redhat.com>,
        "jgg@ziepe.ca" <jgg@ziepe.ca>,
        "jiangshanlai@gmail.com" <jiangshanlai@gmail.com>,
        "joel@joelfernandes.org" <joel@joelfernandes.org>,
        "josh@joshtriplett.org" <josh@joshtriplett.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "mathieu.desnoyers@efficios.com" <mathieu.desnoyers@efficios.com>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "mm-commits@vger.kernel.org" <mm-commits@vger.kernel.org>,
        "paulmck@kernel.org" <paulmck@kernel.org>,
        "rostedt@goodmis.org" <rostedt@goodmis.org>,
        "torvalds@linux-foundation.org" <torvalds@linux-foundation.org>
Thread-Topic: [EXTERNAL] [patch 002/146] RDMA/siw: make use of the helper
 function kthread_run_on_cpu()
Thread-Index: AQHYCZKDsOSN4r/+YEW4DWPymGyoPqxl4G1g
Date:   Sun, 16 Jan 2022 16:56:48 +0000
Message-ID: <BYAPR15MB2631BAAFEF07EDBD825C04CB99569@BYAPR15MB2631.namprd15.prod.outlook.com>
References: <20220114140222.6b14f0061194d3200000c52d@linux-foundation.org>
 <20220114220255.ZPEpuUjOn%akpm@linux-foundation.org>
In-Reply-To: <20220114220255.ZPEpuUjOn%akpm@linux-foundation.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 46413b7e-77d9-45e4-08d9-08d9d9112f96
x-ms-traffictypediagnostic: MN2PR15MB3119:EE_
x-microsoft-antispam-prvs: <MN2PR15MB3119BBA61F90C7939E60F2CC99569@MN2PR15MB3119.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2089;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 9OsH+NCV8Ujz04xebjbi4q7s6KaDuY2YdbUXrVpTadnY4gxwM0yzxo/VfZuSh4mZcei+tDbPEoCchpmhvrpVrbAtz2XQen99Y20fpI//OYbfSvyqepYNNaDb855qkVs2TEmHlI704bDcJDXdwGLwRqgUDGU9euQT7cTIbNTNSp2C6GhXxKkx4VIQkxIxhQtEx0qbIPGK25u5LziMMhuCVcuwayYtvbXLwQTFD7Mcpv4uXvbCwevXZg0Adf8RjH6F7+LTItI/eQFvA88z3OsJhqxbFU12Kx9T7rAogdtdeiw2gFEjUPyNZwW+IYmzZjHFDFkaZVO/+UWXtaARZHo/dz8587AWHoXXu+PhfNoFv9znkQfSTsgIcd9Xd9baZKDyi0C8L20TlkARYLqR7ix0Jlpu1ssv0RXv0Nay0O0YVnUdvym5xDF95ZpADgIVzdZmol5+NMM3R/B2DcYF4gdx6sgaGRiodlQaW6UtVDThDm5TcCXJ03ttNJBgvpn2Utx0wbCjrf1Mcuaruqk9iGlQZpf4OiN8zMD0qVZ7thu+WkuP3uJnvlR5l0rgp3lSSWaXE0tObB08781SuFe8LJp9rm6urb66YdPEpysx8xGcDvI4D2GiS7Wu18wTS7KjadI4IPmZpWCcwVkbq+MxuKyeWX9XiMrQbaxcTSxu2074f8Zl8QdkGJPyJYbtLuwmu35m4BRrhDlyQro0/kYR2EkHTqbwquuRBeJZWaXoIdQ30tmDS7njjRwZrhNP9qQdM+QAtxV4tc0BDNpmntRbbRp9thqFlAfqH+WxhIUMGfNbWZplPFHI5gMYBzUTH3bM+qrJ
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB2631.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(52536014)(8936002)(7416002)(33656002)(2906002)(83380400001)(86362001)(110136005)(5660300002)(64756008)(8676002)(66476007)(316002)(508600001)(76116006)(66446008)(53546011)(66946007)(71200400001)(66556008)(19627235002)(38100700002)(6506007)(55016003)(9686003)(38070700005)(122000001)(186003)(7696005)(966005)(921005);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?R29mcFJGZnNuTGhJTzEra2x1Y2U3L2M2aHl2OXBiVXowWVhSbTAvWm5BN3hw?=
 =?utf-8?B?aU5wMWFSTWFLbVo5VGM0T3JOK3dUcTd1UlZEYTRwU1haOXZPRkhNQlFyRGdO?=
 =?utf-8?B?bDFwWnJ5WXdiWmZTbXdQOXhLcWlJczNodlVvMFR3cGU2SGNHOHpHdEVkajBB?=
 =?utf-8?B?bkx2WkpQUHFMbTFCSnNRZXZmTVg4ZWx2YUxvNHNudHczaHFYdHlob1FZNXV0?=
 =?utf-8?B?bFY4eXdpdmJVRFVUcFpjUGZaS0xuT09GYWRFZ1JXM1g3QXh1UXc5VU5qd2NY?=
 =?utf-8?B?Z1ZUSDMzK3NRb01QVzJ1ekJ2MmxqZ2hTamVleXZ5cTFjWi96YnplNHBINnM0?=
 =?utf-8?B?MEdTd1AvOWlUMEtSV2RiUDhwTVpPcUNmOHJsSFYxendIU3ozQ3ZOZE9FMWNo?=
 =?utf-8?B?YzZjaWpSVmc5RFBQMkRudXp2L0Z6OVdvS1doNDNTU2FVdVh6eFR3VDNNS3ZH?=
 =?utf-8?B?OHRBMTZtM0NFRkZ0RVV1WmM3ZVUyNU9CS1hLMjZyVHJISXc4MHgxR3g4bEoz?=
 =?utf-8?B?czhHS2pCN0dUNzFCN3pNbVVGbTE0Ni9KQlY5R3V2VndPa3A5YnpPdVQ0S2JR?=
 =?utf-8?B?blVUdWVGMWQ4djRqTXdDWXZRdm1WbFRuZTFMdkhCeW11YVFMdnZjQnZ4WXh5?=
 =?utf-8?B?Wm4vTFpXdGRKZXAwb1NIenBSeE9OZktTc09YTGx1WWZjTjZqYUthL2hSbk5k?=
 =?utf-8?B?K0dDOG94NmExdGNYWkx2TnVwOEt1cEFYNkRPem9SVm9tQXhGVEJLUFM2cEJ6?=
 =?utf-8?B?V0oyZ3dNYnBkaWp0S0J5T1h4MWViY2NWWm5kbVVlSG82TE5lSmhobnBiSVFR?=
 =?utf-8?B?U3lhNWhTT1dmd2U3UHRoSDN0elVMZEVCQ2xzUHMwdVEvS1J5TDNYTDNOSTNZ?=
 =?utf-8?B?d0N5U21MUzdRU3RPMEg1bEpwOW5OK1hPVlhXeEo4ZjBoeXJvOEVPYkU1TCtS?=
 =?utf-8?B?WDAwUVpSRXZHN21VRlBZejVWM2FkVTJNYTBsU3ovN0ZTZTV2Wjl3cEFlZXRC?=
 =?utf-8?B?R3VNU1JlMC9IMnJQZ3BDZmZjWnFITEp5bjdNZkw3QlhIVUxBM0xxdEY0OGpQ?=
 =?utf-8?B?SkVKMnE4QU16RXRCM1BLSy9kdEU4ZzFXd2JhS2wrT2tXZmlMWi9OcXk5R2FX?=
 =?utf-8?B?eUJZK1VEaEZUeHIvYzV3RElieVVzNW5VdDd5eXgxeVZibHhVU2c0WFJXTDJN?=
 =?utf-8?B?VzBnNW1DNXNtVThDTDRNNXByTTN5VGlXNzBINFk4cERNOUYxTGI4VVFSSHhK?=
 =?utf-8?B?THUxYVhhWDRPNzluRnVXS1NocHpaYTR3Tkc5U3kwYlJvdGI5czJXb0J0RDVx?=
 =?utf-8?B?OHRlSlMvelozTHVQQXEwaVBSaCtTalR5Z1Q4MTZWdFdpdTdaU04wZFlMR2Vj?=
 =?utf-8?B?bGptQkhQL3ZaV3ZHdWZCUDIwVGxoYlJ2YktaRTRNNGdhQnNKYk5reFVNb3E1?=
 =?utf-8?B?eFQ5R25QMWNEMFlqR2hkMGk1S3ZaaGtBNDA5bVpSTS9OdUw1bFdKa0Z5YlFJ?=
 =?utf-8?B?VU45K21KTjhuSk1pQ1V0aVNYWW4zN3NWa1FZSEpxTnVuRm5ITGsyaU1lOE5n?=
 =?utf-8?B?SktEQTJ6ZGx6YUJYMnVsUkIyM3J4Rm1zQTZEVUdiRDJxRUp0UERjc1JReHF6?=
 =?utf-8?B?UDlzejVqZ0J2TTU0eDlpOE52N2pmb0RBUjJGNGNWOEZHQlVCRTVrcURRbkhj?=
 =?utf-8?B?RFRhVUFVd2MzN0lLdkZ2SmRocHF1cGE4WTNVYkc4aFpybkNNbUoreEo1OFlu?=
 =?utf-8?B?VGIvQmpYZFYrTnh6UU5zMldaSWdMNUplMFMrZisvcjRrMDZEZWdFOXNhWEFE?=
 =?utf-8?B?Z0hURzkrOUdOQzY0ZHpaQ1p6c3dxSEswUmdvODlQZWFwdXdwbnJHazB0Z21x?=
 =?utf-8?B?RXhmM1Qya3plM1YwbCtVa2lKN2tlWHE2RTZVbTdiRHFoS2x3ZzRwazh6MEdJ?=
 =?utf-8?B?MytUaWZFMzFYSUVkcGs1VFM2NkhJd3lhMjdkTE82WXZLWTd6ZHlFTmZWK2Zq?=
 =?utf-8?B?dE1IYjJaRVU5R1NKeGFVUHk3T1BHd1FjRk5RbFlYMjZ6NjhHclBaOUFXOGVM?=
 =?utf-8?B?MXFleW8vL0pTU1VYVWNxOEhXZ3ZaUy9BcFBua2QrTjZaL0RnWEZnRVI5dGwv?=
 =?utf-8?B?dFczelpMdGZ0bjlxTnpoZTgrODl2bW5UbU9lblRPbE1GdkhtYkRrRVFBRFdo?=
 =?utf-8?B?UzVEa1Z1VFJMNGRGZXIrc0pCbUVQYXdMb2xsUmJPL280c2g2REpxNFU1NzVY?=
 =?utf-8?Q?MI7xSu59d+elG7i595IwkBTs9wYbwT2lPXE2Lo0InM=3D?=
Content-Type: text/plain; charset="utf-8"
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR15MB2631.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 46413b7e-77d9-45e4-08d9-08d9d9112f96
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Jan 2022 16:56:48.5356
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: fcf67057-50c9-4ad4-98f3-ffca64add9e9
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: tOZD5e5yFOmn1sEnQoI2QfEEe1vDs7mnJ96qVDVIZsS31JP/G/S+gQSMokIU4gosBX7m8VNwWZLVwkHO1HqmXA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR15MB3119
X-OriginatorOrg: Zurich.ibm.com
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 39Pq_CMh9tFzRTLXMXDrSSTX2XFK3sn-
X-Proofpoint-ORIG-GUID: jLZF9oylvYP0W-9ZTvPEL2PJC8gQTvsZ
Content-Transfer-Encoding: base64
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
Subject: RE:  [patch 002/146] RDMA/siw: make use of the helper function
 kthread_run_on_cpu()
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-01-16_07,2022-01-14_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 clxscore=1011
 mlxscore=0 spamscore=0 impostorscore=0 adultscore=0 priorityscore=1501
 phishscore=0 malwarescore=0 lowpriorityscore=0 mlxlogscore=999
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2201160105
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

DQoNCj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gRnJvbTogQW5kcmV3IE1vcnRvbiA8
YWtwbUBsaW51eC1mb3VuZGF0aW9uLm9yZz4NCj4gU2VudDogRnJpZGF5LCAxNCBKYW51YXJ5IDIw
MjIgMjM6MDMNCj4gVG86IGFrcG1AbGludXgtZm91bmRhdGlvbi5vcmc7IEJlcm5hcmQgTWV0emxl
ciA8Qk1UQHp1cmljaC5pYm0uY29tPjsNCj4gYnJpc3RvdEBrZXJuZWwub3JnOyBjYWlodW9xaW5n
QGJhaWR1LmNvbTsgZGF2ZUBzdGdvbGFicy5uZXQ7DQo+IGRsZWRmb3JkQHJlZGhhdC5jb207IGpn
Z0B6aWVwZS5jYTsgamlhbmdzaGFubGFpQGdtYWlsLmNvbTsNCj4gam9lbEBqb2VsZmVybmFuZGVz
Lm9yZzsgam9zaEBqb3NodHJpcGxldHQub3JnOyBsaW51eC1tbUBrdmFjay5vcmc7DQo+IG1hdGhp
ZXUuZGVzbm95ZXJzQGVmZmljaW9zLmNvbTsgbWluZ29AcmVkaGF0LmNvbTsgbW0tDQo+IGNvbW1p
dHNAdmdlci5rZXJuZWwub3JnOyBwYXVsbWNrQGtlcm5lbC5vcmc7IHJvc3RlZHRAZ29vZG1pcy5v
cmc7DQo+IHRvcnZhbGRzQGxpbnV4LWZvdW5kYXRpb24ub3JnDQo+IFN1YmplY3Q6IFtFWFRFUk5B
TF0gW3BhdGNoIDAwMi8xNDZdIFJETUEvc2l3OiBtYWtlIHVzZSBvZiB0aGUgaGVscGVyDQo+IGZ1
bmN0aW9uIGt0aHJlYWRfcnVuX29uX2NwdSgpDQo+IA0KPiBGcm9tOiBDYWkgSHVvcWluZyA8Y2Fp
aHVvcWluZ0BiYWlkdS5jb20+DQo+IFN1YmplY3Q6IFJETUEvc2l3OiBtYWtlIHVzZSBvZiB0aGUg
aGVscGVyIGZ1bmN0aW9uIGt0aHJlYWRfcnVuX29uX2NwdSgpDQo+IA0KPiBSZXBsYWNlIGt0aHJl
YWRfY3JlYXRlL2t0aHJlYWRfYmluZC93YWtlX3VwX3Byb2Nlc3MoKSB3aXRoDQo+IGt0aHJlYWRf
cnVuX29uX2NwdSgpIHRvIHNpbXBsaWZ5IHRoZSBjb2RlLg0KPiANCj4gTGluazogSU5WQUxJRCBV
UkkgUkVNT1ZFRA0KPiAzQV9fbGttbC5rZXJuZWwub3JnX3JfMjAyMTEwMjIwMjU3MTEuMzY3My0y
RDMtMkRjYWlodW9xaW5nLQ0KPiA0MGJhaWR1LmNvbSZkPUR3SUJBZyZjPWpmX2lhU0h2Sk9iVGJ4
LXNpQTFaT2cmcj0yVGFZWFEwVC0NCj4gcjhaTzFQUDFhbE53VV9RSmNSUkxmbVlUQWdkM1FDdnFT
YyZtPVQxQmx2bFQwTC0NCj4gTDVaUVkzMkVUdHh6RXd5RklBV2NGMHBHT3RoS0hQXzY4JnM9bjRD
Z3E5YVlqLTM0MXZkVi1fOEJaREFrQ2NGb1JSLQ0KPiA3RzF2cHdibFR1QkUmZT0NCj4gU2lnbmVk
LW9mZi1ieTogQ2FpIEh1b3FpbmcgPGNhaWh1b3FpbmdAYmFpZHUuY29tPg0KPiBDYzogQmVybmFy
ZCBNZXR6bGVyIDxibXRAenVyaWNoLmlibS5jb20+DQo+IENjOiBEYW5pZWwgQnJpc3RvdCBkZSBP
bGl2ZWlyYSA8YnJpc3RvdEBrZXJuZWwub3JnPg0KPiBDYzogRGF2aWRsb2hyIEJ1ZXNvIDxkYXZl
QHN0Z29sYWJzLm5ldD4NCj4gQ2M6IERvdWcgTGVkZm9yZCA8ZGxlZGZvcmRAcmVkaGF0LmNvbT4N
Cj4gQ2M6IEluZ28gTW9sbmFyIDxtaW5nb0ByZWRoYXQuY29tPg0KPiBDYzogSmFzb24gR3VudGhv
cnBlIDxqZ2dAemllcGUuY2E+DQo+IENjOiBKb2VsIEZlcm5hbmRlcyAoR29vZ2xlKSA8am9lbEBq
b2VsZmVybmFuZGVzLm9yZz4NCj4gQ2M6IEpvc2ggVHJpcGxldHQgPGpvc2hAam9zaHRyaXBsZXR0
Lm9yZz4NCj4gQ2M6IExhaSBKaWFuZ3NoYW4gPGppYW5nc2hhbmxhaUBnbWFpbC5jb20+DQo+IENj
OiBNYXRoaWV1IERlc25veWVycyA8bWF0aGlldS5kZXNub3llcnNAZWZmaWNpb3MuY29tPg0KPiBD
YzogIlBhdWwgRSAuIE1jS2VubmV5IiA8cGF1bG1ja0BrZXJuZWwub3JnPg0KPiBDYzogU3RldmVu
IFJvc3RlZHQgPHJvc3RlZHRAZ29vZG1pcy5vcmc+DQo+IFNpZ25lZC1vZmYtYnk6IEFuZHJldyBN
b3J0b24gPGFrcG1AbGludXgtZm91bmRhdGlvbi5vcmc+DQo+IC0tLQ0KPiANCj4gIGRyaXZlcnMv
aW5maW5pYmFuZC9zdy9zaXcvc2l3X21haW4uYyB8ICAgIDcgKysrLS0tLQ0KPiAgMSBmaWxlIGNo
YW5nZWQsIDMgaW5zZXJ0aW9ucygrKSwgNCBkZWxldGlvbnMoLSkNCj4gDQo+IC0tLSBhL2RyaXZl
cnMvaW5maW5pYmFuZC9zdy9zaXcvc2l3X21haW4uY35yZG1hLXNpdy1tYWtlLXVzZS1vZi10aGUt
DQo+IGhlbHBlci1mdW5jdGlvbi1rdGhyZWFkX3J1bl9vbl9jcHUNCj4gKysrIGEvZHJpdmVycy9p
bmZpbmliYW5kL3N3L3Npdy9zaXdfbWFpbi5jDQo+IEBAIC05OCwxNSArOTgsMTQgQEAgc3RhdGlj
IGludCBzaXdfY3JlYXRlX3R4X3RocmVhZHModm9pZCkNCj4gIAkJCWNvbnRpbnVlOw0KPiANCj4g
IAkJc2l3X3R4X3RocmVhZFtjcHVdID0NCj4gLQkJCWt0aHJlYWRfY3JlYXRlKHNpd19ydW5fc3Es
ICh1bnNpZ25lZCBsb25nICopKGxvbmcpY3B1LA0KPiAtCQkJCSAgICAgICAic2l3X3R4LyVkIiwg
Y3B1KTsNCj4gKwkJCWt0aHJlYWRfcnVuX29uX2NwdShzaXdfcnVuX3NxLA0KPiArCQkJCQkgICAo
dW5zaWduZWQgbG9uZyAqKShsb25nKWNwdSwNCj4gKwkJCQkJICAgY3B1LCAic2l3X3R4LyV1Iik7
DQo+ICAJCWlmIChJU19FUlIoc2l3X3R4X3RocmVhZFtjcHVdKSkgew0KPiAgCQkJc2l3X3R4X3Ro
cmVhZFtjcHVdID0gTlVMTDsNCj4gIAkJCWNvbnRpbnVlOw0KPiAgCQl9DQo+IC0JCWt0aHJlYWRf
YmluZChzaXdfdHhfdGhyZWFkW2NwdV0sIGNwdSk7DQo+IA0KPiAtCQl3YWtlX3VwX3Byb2Nlc3Mo
c2l3X3R4X3RocmVhZFtjcHVdKTsNCj4gIAkJYXNzaWduZWQrKzsNCj4gIAl9DQo+ICAJcmV0dXJu
IGFzc2lnbmVkOw0KPiBfDQoNClRoYW5rIHlvdS4NCg0KUmV2aWV3ZWQtYnk6IEJlcm5hcmQgTWV0
emxlciA8Ym10QHp1cmljaC5pYm0uY29tPg0K
