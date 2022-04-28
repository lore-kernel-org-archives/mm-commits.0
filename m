Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8D2EAC433EF
	for <mm-commits@archiver.kernel.org>; Thu, 28 Apr 2022 17:35:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232566AbiD1RjD (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 28 Apr 2022 13:39:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54684 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236578AbiD1Ris (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 28 Apr 2022 13:38:48 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E6E116C969
        for <mm-commits@vger.kernel.org>; Thu, 28 Apr 2022 10:35:29 -0700 (PDT)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 23SGPjXQ011286;
        Thu, 28 Apr 2022 17:35:20 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=774VXQSicyUy2GnsJXm9jKbPO9Z/Gc2EbEaEyBiAnys=;
 b=VvbdhwTDGYKvT+VerDAjRDPHayMV45rXrPnzm/2Qe1kdu2lFljpEFVBK0BxFw6pDu8l+
 oWm1EpYvS6A9AImtxVnXMQZgfKjtR3xyUhAh81Vjf2rj2+x62sJ+1CdQb14Mx84KF55a
 0JsI7tU7fDpVT8u2LA6Z7Mp8woNTO6mW5KR2vrY260TLtZuBCVr4bKFV8J9c4UCf7iyi
 bwk+7EN/3fPLgmmxyo1X3E0pfWh9+Fry+Jhcx01EZp1DORxYqhFTZmtXKcOBF9xOlen3
 Nj137lNRCZYKOem/DTHATD5ayjDpPN08qr2ptqrtEMs/TipzffvQ/EmyvUikuFwXbkjF Eg== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3fmaw4mu8f-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 28 Apr 2022 17:35:20 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 23SHVBdm038972;
        Thu, 28 Apr 2022 17:35:20 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2107.outbound.protection.outlook.com [104.47.58.107])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com with ESMTP id 3fm7w715ff-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 28 Apr 2022 17:35:19 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kN7Yk4dkigarJSq9Dw/PJNHxqgO6RFwliTyL+3prwkaoBBUHLgV5VKYigOfxkABxTx/5mz7PhjE74XR86zUh3gTaM7cXxGkP/wSTxw2RAoc/toA/Frgkx0sYmWAXEcrb6ywm7PXES9cfnHCqbjn8CmhjNRDQ+/q9MplK255piwfY5G7k7834l+nMlZFw4if3teSylca0l3B3qbBEW4rr8AZnnr/1LkvmS9gUwLTBkTr03t7l7MBLuWPzL6t4DAVFaV6IH+R88yUXy8+9DXhFJMqZ6wJKUSHDxXZcep5MVp+fSM/JNllUm1HDkpCIvk5UDdQvREDgeonW+53AffqTPA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=774VXQSicyUy2GnsJXm9jKbPO9Z/Gc2EbEaEyBiAnys=;
 b=nje5xqSUhPmajuzlqVFS3uU2bNT8uWxuR8sx0MBgdbTKTlYIR4IDPNejeF7E633T+VkwI83zfnk12sSFoJHbFRp6nwAMR1ogX0VnWY8SV86GVTRRnGTaxcP8vJRS0v0n//tKdVp+3iD6Fv5ZjRBPyN+jvIXupCwAv26+bYGGRC3dJOUMQtrhnhZFBiRRhIFY0EbyqDG0R2WY2HXOGxiKT7HZj8l9MVcFdFMJ/8EawNQfFSKlZvBxuJio7bbRe/XdT/AatiLgC91Ae+xP/hBEkFq6cCbmpYT2cKYXMQiUP/zTVxqii2vwjS+0sdJL3jPHbLKXAh2rHRz7/jtAvPfbwg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=774VXQSicyUy2GnsJXm9jKbPO9Z/Gc2EbEaEyBiAnys=;
 b=bRYTikCKw4xAJhaTgPV/w666t2ZcWSylxsrrEc6AmKBCv/IxH1cHZCnp1Co5BsoljpoYLj9dj1YcLs/E+hm7OIy4VSff4g25AFYRNDYqgqRhe7wUTvzpksETeXWh2yCd2vNvNrYx6xhXLZcjb47reruAzXFwC0OCtUielRWkdNk=
Received: from SN6PR10MB3022.namprd10.prod.outlook.com (2603:10b6:805:d8::25)
 by MN2PR10MB3887.namprd10.prod.outlook.com (2603:10b6:208:182::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5186.15; Thu, 28 Apr
 2022 17:35:17 +0000
Received: from SN6PR10MB3022.namprd10.prod.outlook.com
 ([fe80::318c:d02:2280:c2c]) by SN6PR10MB3022.namprd10.prod.outlook.com
 ([fe80::318c:d02:2280:c2c%7]) with mapi id 15.20.5186.023; Thu, 28 Apr 2022
 17:35:17 +0000
From:   Liam Howlett <liam.howlett@oracle.com>
To:     Andrew Morton <akpm@linux-foundation.org>
CC:     "mm-commits@vger.kernel.org" <mm-commits@vger.kernel.org>,
        "sfr@canb.auug.org.au" <sfr@canb.auug.org.au>,
        "quic_qiancai@quicinc.com" <quic_qiancai@quicinc.com>
Subject: Re: + mm-start-tracking-vmas-with-maple-tree-fix.patch added to -mm
 tree
Thread-Topic: + mm-start-tracking-vmas-with-maple-tree-fix.patch added to -mm
 tree
Thread-Index: AQHYWoodUsYWZDiu/0SwxWbjHjABlq0Fl4kA
Date:   Thu, 28 Apr 2022 17:35:17 +0000
Message-ID: <20220428173510.7hfswk5v3avlxdnw@revolver>
References: <20220427225656.A5C98C385A7@smtp.kernel.org>
In-Reply-To: <20220427225656.A5C98C385A7@smtp.kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: eb675f61-6974-40e1-0284-08da293d761a
x-ms-traffictypediagnostic: MN2PR10MB3887:EE_
x-microsoft-antispam-prvs: <MN2PR10MB3887E978CDC7D66C6122E1BDFDFD9@MN2PR10MB3887.namprd10.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: sLAw3dTd0+9D1oPbuQ2Q+nyTwW1o8Xs2+ogNF3bRCqpq28CQ9a0jc5rqhWigW4GFWRoXc8id9vqbt28TR4ZwY210xo090ME7OsXLvVWItnaiGzmwUKucTVV/ckLvUR+EHYehcmYy+URMCD9OuYBklS4QxDHuKTtHvzerugrzwPXTWSnWJKeemK500z+Zh73VvbM5NaD7reDf+qQ4Qc1MdnaqAn93qEVXsdflpysQyIbGTRkbFVQLJ5VM3l7hZsGvOe5fv43Xg0TYWRGtDChTNpknTupKcMdpJBnKWMg+iZXyxuwcfvDr6Ds55HN15qRHZ+lCKFem9vRPs1PeljR36zmpDP0lUeSbH2GkDau3Wya2RoLlDRobfwisyfgej1zpuAQZTrq2V1+/CldgI5qcBOdjsJGEd2u9Y2glyeAL4euyYaKXUyYtpifNnfuoTd4TwEr16b+NuwfqGKI4ZD/y49fpcwpeNPl4u8tifychJ7dsTKJInuXs/MAeDTD5/Odrui+kQRy1Lkt5j3Nz+uml2moc7Ip+gt3YBWYfVD08RmiiBFMPv1eIHey8/WfrVFAQPBmjD7bdw8UobSxE9rUQcgwnWxQD7W9eaxJ8iNupplRdW9/NbHZBiLiFk+f9591LZg9/x/N2fZmzdNkuKGUHsF3pjEo+ecGV/JozrmMvjmKScEYQgkVLTZGt8nblSzXkXlp4ZzCZ7fcMiclVWwn9aeZegwBajLILy85ywY6eah9HE67BONGYjlqC02ZEoIew6JoG0cWxbmk+Y/a5BP07UegHuWLRs45KQ9wN4HKkZS4=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR10MB3022.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(7916004)(366004)(38070700005)(122000001)(38100700002)(83380400001)(8676002)(66946007)(4326008)(66556008)(64756008)(66476007)(66446008)(5660300002)(76116006)(6916009)(91956017)(316002)(2906002)(44832011)(8936002)(33716001)(6512007)(6506007)(9686003)(1076003)(186003)(54906003)(966005)(6486002)(71200400001)(26005)(508600001)(86362001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?yEa+RtWazUrhNeHn8Fi8zMdgK6NXOkRHzY6rldzslYuVEa6QXi78iM5E+g2Q?=
 =?us-ascii?Q?YWsuiU+dZc3u4G1r0fGVmBXB7F4UNMbZHB7wJ1oALmHmWTwpUVnAq3VPR6z5?=
 =?us-ascii?Q?pFRURgCj3/KeO7Ymi/cKi2lTuZV2tuH14POtrVtRBInXAHWVEAutdHaXLgAx?=
 =?us-ascii?Q?D7voP6qJM06TxbYs/Yg+b+9iOTICfj72gKGi6j2tQvg6MKGQ6MqEzPWNaCZb?=
 =?us-ascii?Q?t7YmMOkqu1tSSQSBvoBUUNhfYJxZHN2vqDyLvKCDc/Pa+BaCNrHs52Fyy/7K?=
 =?us-ascii?Q?5R1yL++4iaYRy1vxeVzJ2ZMDA/j7845DdF6NOXIRWn2HQsAWFK7E2Cy3xJKA?=
 =?us-ascii?Q?d+x7sJsB5gI7cTbv0GJHbffbUUJNm37QbnmjxXdIcwECDl+9VpvUc+BftLLJ?=
 =?us-ascii?Q?KxA7OTJ3iufeLw9v7fSTh15OaWMQDTI2S4qzxpCwnj2nBLCPiiyGPoDOQQ+L?=
 =?us-ascii?Q?twzrtyJLiWsm275tPQs825vy3ozk/HHWZsRynxOXdE5TbY+wG8go1RCecunT?=
 =?us-ascii?Q?C10jx/zX/p18HkV8Oyw9+9KegsNoUH4za24oW9+DtsRFn0cDcrd+OVmvYGdI?=
 =?us-ascii?Q?7x36JB6epp37SlBOrQoNhZU8JhNSjiVr0gBwDpa3UdHJQ36SgGtoIT3twYc8?=
 =?us-ascii?Q?/sNKRISxf37wZ7pedk500erMTg+zrMZCrL3nNa4GxcagjlRCjNrBSsJDkbij?=
 =?us-ascii?Q?8ziefs5ojJiEzALkfAJ+O05JRyE7es4xq3nW/QRkzegRtClPfKtMkp6lCInH?=
 =?us-ascii?Q?gDd+dRcq8jrb1ZrTqwqz7txCnhfhQezLfP0aHfCsuj+/vF5fF7ffy+Auxk85?=
 =?us-ascii?Q?Z/3SafuCPia4hclcuRz5cVkXbx2/qiZK1WmeAwCMNXG2YTQW47lKwA9rN9FG?=
 =?us-ascii?Q?W2lqwakbJp4rVLcBuM2xBz7CgoELtwwQV7sbEzVOTBAatVrR3izDVkd82cQU?=
 =?us-ascii?Q?maXOt3BKg2HlW24X7rh5dOd68z2uU7us4Dqz+mpKj79DyzP0wdYHW9nVmEsG?=
 =?us-ascii?Q?NeYZ+4dn+XZ/D2CM3O8+SAEWKeUrf41VeNucUbBjWPfx2Yg1u0YXLDNgg8aW?=
 =?us-ascii?Q?z3FGmXAK7ypUgwq7CJOpcyGYrqgciWdSKm/RjHox7lfXtjpugLMx2gcUi4HN?=
 =?us-ascii?Q?aKZVGKMX76tpNxjOOFlpCK2GJ0gTOo2T2HrbQ810CpEEsNLAHpSmIhaWyUjm?=
 =?us-ascii?Q?OEAbvWujs7yuMGveDHnusil1iDRfvcwBBTimZv8Aa9DV5XbJe5KZJIqIjae6?=
 =?us-ascii?Q?l6bujeYHjzFBVuDi4XFB6/YhbEQxJdjSRh4nZ4vFBJ9mTHtTGtcTXZn4XiUA?=
 =?us-ascii?Q?jsvebNG64O83v+l/Z/cy4pBQfEiOgWhVkc3WdWbVYtz2SH4mJWXmxM79EpBc?=
 =?us-ascii?Q?Lhpcxb0Kv2QHsImoyA9fvypcMRboGIdSTMDI6uW4bRmpimKdgr0813QfQMkx?=
 =?us-ascii?Q?Dp5z8pEsMQZ7/U9rIWvdNGlQksVGtMKfsifDIIByS8voHJrB5andDNBEv+TJ?=
 =?us-ascii?Q?1rEFIlK0QyuoQLnri0OFrRCUQViDLYieTsBfze60l05fRj03i5vTJFxMPZZr?=
 =?us-ascii?Q?iCyuDzHqNVxYpsAo3gEpV/ylmNuOtodlIFCDUHUzG6O1PRiY+LE8Q+6/IuqQ?=
 =?us-ascii?Q?0VluZ1/5kdG4Ge+/ch1ZCF+nlVuV0ZmAF9bu5pMA+lARYtYtGC8d1UZymdTz?=
 =?us-ascii?Q?f1OAAaftowtQr0zp9QuoXv6IUaiFpgqpSVifIWrhREJ/4SwIletuA4m7D/K2?=
 =?us-ascii?Q?uiEJaMEa9x9Sc7X2tISmGvK/iU9CEEo=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <4E626668A8083740817A5443BC95DB33@namprd10.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR10MB3022.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: eb675f61-6974-40e1-0284-08da293d761a
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Apr 2022 17:35:17.7350
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: llqC86mPa59IcL1JiPaUFdPDmNkYggU5O76KhEiKr4FezIdaeC2DxW2tKCuBPll1x9WOUEj9bNjo+kXoxjw/qA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR10MB3887
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.486,18.0.858
 definitions=2022-04-28_02:2022-04-28,2022-04-28 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 spamscore=0 adultscore=0
 mlxscore=0 bulkscore=0 suspectscore=0 malwarescore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2204280105
X-Proofpoint-GUID: WiOhn323zeK9ZKHhZ_cfHDWQ2ZzuJo6h
X-Proofpoint-ORIG-GUID: WiOhn323zeK9ZKHhZ_cfHDWQ2ZzuJo6h
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

* Andrew Morton <akpm@linux-foundation.org> [220427 18:57]:
>=20
> The patch titled
>      Subject: mm/mmap: fix __vma_adjust() memory leak
> has been added to the -mm tree.  Its filename is
>      mm-start-tracking-vmas-with-maple-tree-fix.patch
>=20
> This patch should soon appear at
>     https://ozlabs.org/~akpm/mmots/broken-out/mm-start-tracking-vmas-with=
-maple-tree-fix.patch
> and later at
>     https://ozlabs.org/~akpm/mmotm/broken-out/mm-start-tracking-vmas-with=
-maple-tree-fix.patch

Both of these links are 404 and the patch does not seem to be in
linux-next 20220428.  Is there any chance this was missed?

Thanks,
Liam

>=20
> Before you just go and hit "reply", please:
>    a) Consider who else should be cc'ed
>    b) Prefer to cc a suitable mailing list as well
>    c) Ideally: find the original patch on the mailing list and do a
>       reply-to-all to that, adding suitable additional cc's
>=20
> *** Remember to use Documentation/process/submit-checklist.rst when testi=
ng your code ***
>=20
> The -mm tree is included into linux-next and is updated
> there every 3-4 working days
>=20
> ------------------------------------------------------
> From: "Liam R. Howlett" <Liam.Howlett@oracle.com>
> Subject: mm/mmap: fix __vma_adjust() memory leak
>=20
> When shifting the arg pages, the maple state may be left with allocated
> memory.  Free the memory by calling mas_destroy() unconditionally at the
> end of the function.
>=20
> Link: https://lkml.kernel.org/r/20220427224134.yurrplclbhmnrloj@revolver
> Fixes: bd6a1fd58daf (mm: start tracking VMAs with maple tree)
> Signed-off-by: Liam R. Howlett <Liam.Howlett@oracle.com>
> Reported-by: Qian Cai <quic_qiancai@quicinc.com>
> Cc: Stephen Rothwell <sfr@canb.auug.org.au>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> ---
>=20
>  mm/mmap.c |    1 +
>  1 file changed, 1 insertion(+)
>=20
> --- a/mm/mmap.c~mm-start-tracking-vmas-with-maple-tree-fix
> +++ a/mm/mmap.c
> @@ -864,6 +864,7 @@ int __vma_adjust(struct vm_area_struct *
>  	MA_STATE(mas, &mm->mm_mt, 0, 0);
>  	struct vm_area_struct *exporter =3D NULL, *importer =3D NULL;
> =20
> +	mas_destroy(&mas);
>  	validate_mm(mm);
>  	validate_mm_mt(mm);
> =20
> _
>=20
> Patches currently in -mm which might be from Liam.Howlett@oracle.com are
>=20
> mm-start-tracking-vmas-with-maple-tree-fix.patch
> =
