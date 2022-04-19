Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BB4F1C433F5
	for <mm-commits@archiver.kernel.org>; Tue, 19 Apr 2022 19:07:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240570AbiDSTKD (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 19 Apr 2022 15:10:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57926 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238364AbiDSTKC (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 19 Apr 2022 15:10:02 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EACA513D05
        for <mm-commits@vger.kernel.org>; Tue, 19 Apr 2022 12:07:18 -0700 (PDT)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 23JGDs01024600;
        Tue, 19 Apr 2022 19:07:16 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=HgDeWJo2uaNHNpP3FEsC/9SoTDigYN/zFdED1uvErWk=;
 b=UXW40fX+4rDTaGa3kdsYhzYzcCP3i/1LxxUrQ5wWkngLi1qP4sX1poQpQfyop9qANpx9
 gyisV8ImgzO5U7v6w28Dk8X/iZfiSrcpNjYeYHn/Auyjvz8s1pvzWdzlN4pybfo6I0ND
 Zr5WW/EQp6ir9SFqY958Kcox7E40g4TGpkWVDh8tklc59kPbVC+Oyiz1ke/c8dpJ7JJf
 +DHBeAaZivneOqappBELcVvFHs+7+Y0BmUHnZL6L5kI7Hu/Ie9lFY5pONA3FZXqSgffd
 QY/XvO+YWPZ+Ok5k1lVkVeOgeK4iL79jeIt8kcHNdYG0xR2Qf+M6b9oGJ0M13pUJbwIV hg== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com with ESMTP id 3ffnp9eukd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 19 Apr 2022 19:07:15 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 23JJ5gk4034055;
        Tue, 19 Apr 2022 19:07:14 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2109.outbound.protection.outlook.com [104.47.55.109])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com with ESMTP id 3ffm88r9w6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 19 Apr 2022 19:07:14 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EH+98+BgTxN3ILB5XDZAxovcgRHoDrMc+HtI5cARkpJplYuB/TIoqWJEUIIXmAcN9RDv8iRW9bwbrRFW3PiZPhYyZK8BRyDhmemB+NBGKwqtriXkJDqiMMogTu4BTeCyHOPHYKS1xKboys67+amFzQu4EPsC9ckI9AQbV2iLJ0tx7gCyTYAvtLPl+aIxFIfhfUwj3WtTjgsKfNrJg4hoKzL/RqpvcK3sfX7NffRZKXzeyZtEdTXQKGfFwZbJGxeM3TELWZ7lKlKbjFR4WH/iQ5jo/xK2b75PlxfKV+lcAtniUkXa9g7bccPSitT/9FI3AsDJtumOWuXuBDjve5yKUA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HgDeWJo2uaNHNpP3FEsC/9SoTDigYN/zFdED1uvErWk=;
 b=gVr9RqJN6RjyRk58+ytMaeYoqsQFY3X7Ht/drMBRD/iNp1JzT/gJh8Yv/7PS7SVeYdBUcoNINX4839l+2ByYqUM4ViFeDGEwTzp//yUW+b5NFGumJwqt3pNh3P7cb2O1+nOn0PlPu1LvJtGbYqHSP+qj+q4kb3/GcmHGF0BiTOYCdioJYrZn6syvOTCs7yZS5eYXwTLx+j1xSqSJa6vsrgfSYx1+oaM5WW7DSnAhZYf63EwWSKbLawbZZg9aZAX9e8Pf84J1vIvlEbJeQUJYWLweUpatuIpjMIKB7yy7wm/0YN/MO31mYUdJiandoj/NJucyYXDFOC0COEDtDIkbuA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HgDeWJo2uaNHNpP3FEsC/9SoTDigYN/zFdED1uvErWk=;
 b=j9rJMwW+nxFAy1tKchBIp/t6kfidxLZdleJINyygo9en1yRcYSWRBizkv0gr2vb8/zp2azu27ZwB+g2jSV8cmwOpT94o/Vr/FBWTyn++2tGIZC7eeVgKjaO8nLAWlCZQUtghMIKXcfm8Gf7FR+SVjY6NR4FN0d8ZtgFt7etyvJ0=
Received: from SN6PR10MB3022.namprd10.prod.outlook.com (2603:10b6:805:d8::25)
 by MWHPR10MB1280.namprd10.prod.outlook.com (2603:10b6:301:8::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5164.20; Tue, 19 Apr
 2022 19:07:12 +0000
Received: from SN6PR10MB3022.namprd10.prod.outlook.com
 ([fe80::318c:d02:2280:c2c]) by SN6PR10MB3022.namprd10.prod.outlook.com
 ([fe80::318c:d02:2280:c2c%7]) with mapi id 15.20.5164.025; Tue, 19 Apr 2022
 19:07:12 +0000
From:   Liam Howlett <liam.howlett@oracle.com>
To:     Andrew Morton <akpm@linux-foundation.org>
CC:     "mm-commits@vger.kernel.org" <mm-commits@vger.kernel.org>,
        "yuzhao@google.com" <yuzhao@google.com>
Subject: Re: + maple-tree-add-new-data-structure-fix.patch added to -mm tree
Thread-Topic: + maple-tree-add-new-data-structure-fix.patch added to -mm tree
Thread-Index: AQHYVB3mQNxR9kkn6EqpckukG6O+gaz3mREA
Date:   Tue, 19 Apr 2022 19:07:11 +0000
Message-ID: <20220419190702.ct3fraf3qm55e2wf@revolver>
References: <20220419184655.BF769C385A5@smtp.kernel.org>
In-Reply-To: <20220419184655.BF769C385A5@smtp.kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 456f3c15-45dd-472b-ebb4-08da2237cf24
x-ms-traffictypediagnostic: MWHPR10MB1280:EE_
x-microsoft-antispam-prvs: <MWHPR10MB1280B769B9D106E9191B85E4FDF29@MWHPR10MB1280.namprd10.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 4DKjOKro7YIud7kapbe8CyMgTripRGkBGfxOJSaMCDWKx1dq6i7Py+kLm23m307Y9CT0lITu05TX3SNiP14Ti1Idgl/ZLm8iuwOZ5o1Rbjna3eqEWaqecBbHycYuVQrMSuxKOTr6LEQUsEWm1AQYNzm2RZPjnlMeLy5q2NMLQFwOp3otcMzX93VIC1suoYHaXkGRBrCca/Sdphd3+rzzAZZBsz6w4PapN9tntAdLdMwxkhk+rcShRDZ0jtEbEnEBlCs7BZoB2GQhgbeQgXBhoUqhwhnGYo2IfqjBQzKCeEA/iIX4jE3SBpUkhkkXJODOl0N6B6+vLVWCUHmM/JPvJSKFXZVABo2LeIw/1s5X9bcg6mdKOxgC4tiwsR2443TlDV0F7fT4ekE/TDkoYxd9Yc0iKWqUNfnv0yoUUsqnBZaNxTu5YiN4sAdRRZakqQb0aR8RCo/qfW2uW1OlCV8+N8YWyVRxZG1Y+nS4ZOQu0TMV1eikE5II1fSrVpM0BFkDF5TVonlCaGEZK67RsiKCeCnxiK/eJlXD+cNnes1JSUzeYYlJd8UIesV+NmdfiFkKBCw5/dDiizKaIVHhnLeQ7fISlNp3VQ2Qvy5upqX0IOj9NbHMTjVWa2AfRgnmJWIzIRpFD2VY6plWLaOCpws1RqGC8b9BYkIeBbQHbHuaA0JGxaUdD1aHYG/4qTn6tt5zR/g7FHeCaAH0qWJ4wgDSeVZWJJYQ1msFaGNaSBSxGN2j68n5f8i6Fn3mv/q9FC2BMS/HNUwLssqfC3tKEuPcGh/x9pTJEE/IkIk639Le1rU=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR10MB3022.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(7916004)(366004)(316002)(66446008)(6916009)(4326008)(64756008)(5660300002)(186003)(8676002)(83380400001)(38070700005)(33716001)(54906003)(71200400001)(122000001)(44832011)(508600001)(38100700002)(6506007)(26005)(66476007)(966005)(66946007)(91956017)(66556008)(76116006)(6486002)(8936002)(1076003)(6512007)(86362001)(9686003)(2906002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?Urlt6NxnUoOxwidpjeaxRWf0HtzolZ8dfkzNXEeKojaWa4niBK4UAgx3wWfA?=
 =?us-ascii?Q?omimQs9NhcZuSByF3At8693p5nCMlV6Kpj5Vtr5SrHQqRnBKd5gh0UFYpSV3?=
 =?us-ascii?Q?s+9INZiwfXUTteaoCzZw4GblY2PSGNzFSrWU3L2ghiJVnoMk9WbG5kCnxwVi?=
 =?us-ascii?Q?H0a40OOZDeZZ/0oDi0U6hxznI4i9ALSwhhsvkfAV5sXbiKLg2aGWJzsYNdnh?=
 =?us-ascii?Q?6M42zvD/FUL7w+croY7ILxjNNBHiaUNpfC/8PoY5KB/dptFW1KWAZ8aGJSEO?=
 =?us-ascii?Q?KEBryFEraEFlgdZ+ONWpVJ6e7gDUDFqQHsb48fvZyX2NseTO1VgSo+OUGoiQ?=
 =?us-ascii?Q?w3VcAAPxbgUD9N6hpLIAp8HMqZrYbevSx2DBSki1BzDd8FXGZ4a8unKif1DS?=
 =?us-ascii?Q?hLCPUrKdMZ9yuq59Ge5+uey1zoZLz0w4xikd6rEWmzPIrKu69xjztIxfcqCB?=
 =?us-ascii?Q?VDdErweVbT6kivMwW59ed6gygJPAxHI3dEypM3z4JwWudw5d3Hh7IvXN3FYj?=
 =?us-ascii?Q?QKGSEAvR8V/ffy1w4UBnE5vXLUg8eBAWLet6OuIo5xTQhyysGXrF+3G0lLXi?=
 =?us-ascii?Q?h+OZgo8DuXwDqCgi8M/om+znW4ca1ZDV0r+qF/Jv7NkgNXdMlRMiavCEUWYE?=
 =?us-ascii?Q?bxEYmvEhb1fPQC/NwBKLjfA/+Lqom4wqirc3t2VR1oIEbfNDEwc3zcXa/III?=
 =?us-ascii?Q?Ng5Bs1/WXPnQa8YR8nM7yZaY3i92gI4AlEbFDuKaXn1870ZQXqSdqDy1yacw?=
 =?us-ascii?Q?HzPSdn7koVPlx7xsXma4yOSfbuF7mKTp8Ru5QuLJdn47RucY3WfQr0/u051Z?=
 =?us-ascii?Q?yEzKQ2SFHc2k8aRD1zM3Yxf6hKvc7/PauiLMnPQSWL6/TktqegH3s1SDjScX?=
 =?us-ascii?Q?WOV3cfWqSTCd2IIJkpKRg/n5oyKlurWjNRHGxJBmU/nK0cSbwqWd55irhEdm?=
 =?us-ascii?Q?iqLjvQ2faOmggsSRDd8wOpNfXK3IlRvFQy4sTejzMGOGi0ihGQcqUJ5bblEL?=
 =?us-ascii?Q?Y3PfNDLu46HW8MKqDsvO90LSBuy1q8YCnwjMw5tnX5GK6xkOH7ORUBNWDGEX?=
 =?us-ascii?Q?oVNY5SqYxmsKoxlDGpM20qfo77F6gPrR5oLXpV3ntVHYYJnTQcDiQZXO9TJt?=
 =?us-ascii?Q?WuTrATCF6jOOlo5Ycdi5O4pOvpoS7CDkoI/UnTiC4opG+v6T4ImOi6uJo+qy?=
 =?us-ascii?Q?kXC9NjyjcUvV1ah88koBNNHcV0rQhGcHJy9WBnb3MNjP6SMD2N5/xVflyQdI?=
 =?us-ascii?Q?wb3fFNbnUvZwLu343O7l9YB/fevDXcsRKfLmDBJEcTIOm5RurS+8riNU62iE?=
 =?us-ascii?Q?9HrLvGi5mwcsvpPVBVeF8hcVOuN3wMxItPfS4x2JUwhF1y01RZhiW1jLw/8A?=
 =?us-ascii?Q?wUusXbBEMJX3xxKNL5b5MlXfweS6M4jhIjT0Dajq51pQFG0uZBK1rei9+1dO?=
 =?us-ascii?Q?FE8YMtyXqV3zvsO6M68j7OcU0PxMHMSOMgtCdwTOIIL4UfmWxDNnKBXm9O3C?=
 =?us-ascii?Q?meJPBP/4p18ZZ8xrGa6Xl/iY55nHwSY/x4tcmH2qjyzECeZoExRpa2u6fgV3?=
 =?us-ascii?Q?n5aD9COGO5KRtbaAp9ZTsVDBPZYb2/BdhXs4VSO21tSQPzQzM46z28P6igrn?=
 =?us-ascii?Q?zbiM+SziOSEl7SdP50LK1jgqmD7774kiKVoP2IFD7Yq9o6KQLZCSfiTqFKy6?=
 =?us-ascii?Q?krD2gn1pz8emTSshLNUNPDu3vB9AfoS1ltRETJfCo9YelcKtPJ7Kpp9Wtz5f?=
 =?us-ascii?Q?EsZygzM7l+lrSY9CHbK+E6pVCZdGhS4=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <6FDDD9195A891F43B8187F7612A3E517@namprd10.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR10MB3022.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 456f3c15-45dd-472b-ebb4-08da2237cf24
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Apr 2022 19:07:11.9414
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: uOUqt9sZGqeALcMB+3oXs7O8ITMAjXahh9MqMwkKMH8sHhpZmaSeZJFy1a7b2v2NjptL+1BSd36iBMsc2yPy3A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR10MB1280
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.486,18.0.858
 definitions=2022-04-19_06:2022-04-15,2022-04-19 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 malwarescore=0 mlxscore=0
 adultscore=0 mlxlogscore=999 suspectscore=0 spamscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2204190109
X-Proofpoint-ORIG-GUID: bM4ymE64RGyVdkbR4yP9kbWY2DNt4Qan
X-Proofpoint-GUID: bM4ymE64RGyVdkbR4yP9kbWY2DNt4Qan
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


Thanks.

This can be squashed into cf5c2c20d811 "Maple Tree: add new data
structure" when sending upstream.

Regards,
Liam

* Andrew Morton <akpm@linux-foundation.org> [220419 14:47]:
>=20
> The patch titled
>      Subject: maple_tree: clean up after bulk allocation failure in mas_a=
lloc_nodes()
> has been added to the -mm tree.  Its filename is
>      maple-tree-add-new-data-structure-fix.patch
>=20
> This patch should soon appear at
>     https://ozlabs.org/~akpm/mmots/broken-out/maple-tree-add-new-data-str=
ucture-fix.patch
> and later at
>     https://ozlabs.org/~akpm/mmotm/broken-out/maple-tree-add-new-data-str=
ucture-fix.patch
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
> From: Liam Howlett <liam.howlett@oracle.com>
> Subject: maple_tree: clean up after bulk allocation failure in mas_alloc_=
nodes()
>=20
> Link: https://lkml.kernel.org/r/20220419155055.qf52xpcftqb3r5nj@revolver
> Cc: Yu Zhao <yuzhao@google.com>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> ---
>=20
>  lib/maple_tree.c |   22 ++++++++++++++--------
>  1 file changed, 14 insertions(+), 8 deletions(-)
>=20
> --- a/lib/maple_tree.c~maple-tree-add-new-data-structure-fix
> +++ a/lib/maple_tree.c
> @@ -1206,6 +1206,8 @@ static inline void mas_alloc_nodes(struc
>  	unsigned long success =3D allocated;
>  	unsigned int requested =3D mas_alloc_req(mas);
>  	unsigned int count;
> +	void **slots =3D NULL;
> +	unsigned int max_req =3D 0;
> =20
>  	if (!requested)
>  		return;
> @@ -1214,7 +1216,7 @@ static inline void mas_alloc_nodes(struc
>  	if (!allocated || mas->alloc->node_count =3D=3D MAPLE_ALLOC_SLOTS - 1) =
{
>  		node =3D (struct maple_alloc *)mt_alloc_one(gfp);
>  		if (!node)
> -			goto nomem;
> +			goto nomem_one;
> =20
>  		if (allocated)
>  			node->slot[0] =3D mas->alloc;
> @@ -1226,20 +1228,20 @@ static inline void mas_alloc_nodes(struc
> =20
>  	node =3D mas->alloc;
>  	while (requested) {
> -		void **slots =3D (void **)&node->slot;
> -		unsigned int max_req =3D MAPLE_NODE_SLOTS - 1;
> -
> +		max_req =3D MAPLE_NODE_SLOTS - 1;
>  		if (node->slot[0]) {
>  			unsigned int offset =3D node->node_count + 1;
> =20
>  			slots =3D (void **)&node->slot[offset];
>  			max_req -=3D offset;
> +		} else {
> +			slots =3D (void **)&node->slot;
>  		}
> =20
> -		count =3D mt_alloc_bulk(gfp, min(requested, max_req),
> -				      slots);
> +		max_req =3D min(requested, max_req);
> +		count =3D mt_alloc_bulk(gfp, max_req, slots);
>  		if (!count)
> -			goto nomem;
> +			goto nomem_bulk;
> =20
>  		node->node_count +=3D count;
>  		/* zero indexed. */
> @@ -1253,7 +1255,11 @@ static inline void mas_alloc_nodes(struc
>  	}
>  	mas->alloc->total =3D success;
>  	return;
> -nomem:
> +
> +nomem_bulk:
> +	/* Clean up potential freed allocations on bulk failure */
> +	memset(slots, 0, max_req * sizeof(unsigned long));
> +nomem_one:
>  	mas_set_alloc_req(mas, requested);
>  	if (mas->alloc && !(((unsigned long)mas->alloc & 0x1)))
>  		mas->alloc->total =3D success;
> _
>=20
> Patches currently in -mm which might be from liam.howlett@oracle.com are
>=20
> radix-tree-test-suite-add-lockdep_is_held-to-header.patch
> mips-rename-mt_init-to-mips_mt_init.patch
> maple-tree-add-new-data-structure-fix.patch
> lib-test_maple_tree-add-testing-for-maple-tree.patch
> mmap-change-zeroing-of-maple-tree-in-__vma_adjust.patch
> riscv-use-vma-iterator-for-vdso.patch
> mm-mmapc-pass-in-mapping-to-__vma_link_file.patch
> mglru-vs-maple-tree-fix.patch
> =
