Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0BEF9C433EF
	for <mm-commits@archiver.kernel.org>; Thu, 28 Apr 2022 19:47:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240718AbiD1Tu6 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 28 Apr 2022 15:50:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34056 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229449AbiD1Tu6 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 28 Apr 2022 15:50:58 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D2AC4BCB6E
        for <mm-commits@vger.kernel.org>; Thu, 28 Apr 2022 12:47:41 -0700 (PDT)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 23SIUfj5003733;
        Thu, 28 Apr 2022 19:47:31 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 mime-version; s=corp-2021-07-09;
 bh=aC8U5dduVkrLlrV7GTQ1xiEG/XDoWuh/d6YG96DkrwY=;
 b=eGQLcxhiObfGwj8/iv9xSunmSCaIwH9naz3pN8UL3f4LJM3BQbT2fwP+qX9GB91GaJFX
 7luZxfGxr2qZ0Nte8adOKneYGNpn0QjvjE08ZrGEjt2qQ2y9r2jMbbM8ueqoiju24P9p
 +aB0j0X1Tth+XSwVRA/+Ifkuj69a66/spK9PFqVt+S3ly3bzLTaJ1lnkooPw60RSmrFu
 aL34TrTHX48NC5NQFrz0jZFEwSfFX0x1kkEwXSym8ULfUT5GI1TGscVRY7qJlEzuI2If
 qLizF0tgpJVQ0yb0nagWQfZcNKLCPHWkD1fesFP/C24M939/ieZXLvV0MIGfSMq/EYt+ LQ== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3fmbb4vm1s-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 28 Apr 2022 19:47:30 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 23SJfQjV001318;
        Thu, 28 Apr 2022 19:47:30 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2170.outbound.protection.outlook.com [104.47.56.170])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com with ESMTP id 3fm7w772a3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 28 Apr 2022 19:47:30 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=O4c8IgNmMVEtvfkM3I6a38fe7/zSN1X6ZSflCh/8KXGWHNVIw7SKR2HyXjvxDzgCqc9SNRZwqsJZWp0GxWmg1IllHVGr2SJfotC9YERj6tD0VZOqPAsr4cHxv2dVYEE+5gil1haxcXdO0/WwfldT8ky9N0OD1wJ+E3DxOEOEEoYVQs78PqpUXqUiG/hAKfdLoqxq+e4UndPZ+Sw5i39Jl6S2ZfG0RIFBwWWRUtm71FFpABkexnyDGWXC1aEDGIbOTbP9y1gqP7Y8j5GwSYYtMU/aadh3fHRSpGCc+dyIVdYTD6In9myGyVfFfYsvLr5zpxO05OCycX41FEfbYyDTaw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=aC8U5dduVkrLlrV7GTQ1xiEG/XDoWuh/d6YG96DkrwY=;
 b=PuoMQ/X1WaT+3tWo0oMThSXTYspLAdqRxJ1vr00b1GzWq/jfPqc3saFWz5fwyrXsNbqBEqX3rWtlVKxV7e2s37/DW2JbdjfKw++ufc1BIXHmpixX3+NUaNGOTYW14U6ZxqqMo6+8UBtms3HdjERaCsaZE5IYCUYTjZW1+hxBx3ivrIqjPjrKnadEtmXIompGXwwxnCmI7/TURj5/tDRtNQ0Fs67jSmKfzSAuFZIL7XTAuopx0nHIdzxSPfjjqv5HykUU6Ro+8f7p+Ia6DG2vA3g4Gn7+F5+1dm+JUXSle/ZyHdlIIsiFXq9NPinwnl3hgrrIvhFlDtzRLNc6yQq7Hw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aC8U5dduVkrLlrV7GTQ1xiEG/XDoWuh/d6YG96DkrwY=;
 b=PHeZ0fgdmySJG34+2nbuH2soSjpzN9Zp54qAvI/pSC/B/evr0FbCj/Qws3tDx2P7ECawCxgwSI96P9u3GFNYt7nPs8qmVjfE+tbe8bmOnPqi+myTNKX/uO+aekcvAPjAVG3W8hSdjm25+whA1O4jzaxllq7ZL9kWQMoOv2YvFpc=
Received: from SN6PR10MB3022.namprd10.prod.outlook.com (2603:10b6:805:d8::25)
 by DS7PR10MB5232.namprd10.prod.outlook.com (2603:10b6:5:3aa::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5186.14; Thu, 28 Apr
 2022 19:47:27 +0000
Received: from SN6PR10MB3022.namprd10.prod.outlook.com
 ([fe80::318c:d02:2280:c2c]) by SN6PR10MB3022.namprd10.prod.outlook.com
 ([fe80::318c:d02:2280:c2c%7]) with mapi id 15.20.5186.023; Thu, 28 Apr 2022
 19:47:27 +0000
From:   Liam Howlett <liam.howlett@oracle.com>
To:     Andrew Morton <akpm@linux-foundation.org>
CC:     "mm-commits@vger.kernel.org" <mm-commits@vger.kernel.org>,
        "sfr@canb.auug.org.au" <sfr@canb.auug.org.au>,
        "quic_qiancai@quicinc.com" <quic_qiancai@quicinc.com>
Subject: Re: + mm-start-tracking-vmas-with-maple-tree-fix.patch added to -mm
 tree
Thread-Topic: + mm-start-tracking-vmas-with-maple-tree-fix.patch added to -mm
 tree
Thread-Index: AQHYWoodUsYWZDiu/0SwxWbjHjABlq0Fl4kAgAAJ/wCAABrxAA==
Date:   Thu, 28 Apr 2022 19:47:27 +0000
Message-ID: <20220428194722.27miieldyezhlas6@revolver>
References: <20220427225656.A5C98C385A7@smtp.kernel.org>
 <20220428173510.7hfswk5v3avlxdnw@revolver>
 <20220428111056.063cf6c0c6f9bac2b67b4fb7@linux-foundation.org>
In-Reply-To: <20220428111056.063cf6c0c6f9bac2b67b4fb7@linux-foundation.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: yes
X-MS-TNEF-Correlator: 
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 178d2d4d-c277-493f-a795-08da294feccd
x-ms-traffictypediagnostic: DS7PR10MB5232:EE_
x-microsoft-antispam-prvs: <DS7PR10MB5232348D5B1F0E42C2A0516BFDFD9@DS7PR10MB5232.namprd10.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: H6BkS6dFCeoVikfEVTcrACNRroZpuclhLK2A5UdYaCskMs7gatYYfeQNjq02nWS1kMMQRBL1jykxlf04sxZApmPPhLmTgrdSKViLDucp90E70Jctk1Id0J5rCaPHIYUMb84BAUp3BPQrMyUk6hdIXOgTD3ol4Z6G8uPo6kao+DyuOep2CCC7RAM7OUDIeN1nO91u4DA5HboX7bXrc/6LbMNc4WgDMLw0Mhm+QNYZxKY9uY5VmlqfmpnmfMrGwc/Cy/duoYaTdipPp7Hj2yFNlKfQDV5sZbBXe/oJIRRkF2/BSdjUdJ81EbkjnUQ7m9Xu/ym/AMydNyXvb6ZBdyF5s+9Wf79NkMT9o1le6+ZutJaC7vwFPtKxZf4X1Gw2KyngsQi+929eu+cy08PBqZE6cWeTvDj0SHKOD4PlFWrYNgYMFXeH9p/8cgAgljbV4AAzI+iF9S1Fa664NefhKyAMtSUC9ZWYr0fc+7SHf6otm73dgUAfc0Acw58ID0/UQ13pbCxGNEDOI9/m+oIGKwMKqLQDEVVfjF6mzQ3ql91NjPPLuhZ5b7uaZEG9zToD0D6iRAW2I9dBXPeF4ShPfF8tA6sa7tclkrRjnkZQ+oO8eA8usEKB3WPsQHIlV0Hxw6PXVW/fxESnUzXnW+hOliLCAQ3goaqkCCdw3EiRHesaTVdI5PbOS77wBZ35GQ0L699JfZzXT6uFe/YI9xRxQeF39KFa+Dkjt5lCldMwnyYGcBzWwKWIW7AeuhU2bhi9PojQ6A5nKa0qyKm1UfOeF8m5OMsKnW2OaWOBQ47zSWq999g=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR10MB3022.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(7916004)(366004)(508600001)(86362001)(91956017)(83380400001)(38100700002)(38070700005)(186003)(1076003)(99936003)(122000001)(8936002)(5660300002)(2906002)(44832011)(33716001)(6916009)(6506007)(26005)(4326008)(66446008)(66476007)(54906003)(64756008)(8676002)(76116006)(6512007)(9686003)(66946007)(66556008)(316002)(966005)(6486002)(71200400001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?Yp4tmQzBC5pOIIlBu9Qpa+R5RX/aBysRP9W0QQZJBVdffZMyz6HJAvy+Yz2h?=
 =?us-ascii?Q?hlY1ROeivek4bMtYqaEV/opXGJRT721U3UX2baqe+JwQzrCWFznXC0+7nLhi?=
 =?us-ascii?Q?8kc/lKficNLVTQWDJJFdD6rR+BjuYK9TSGumoBAYGjLC4pDymycsD54WkOd0?=
 =?us-ascii?Q?Nl2tfWnmlTIJ2Kt95PYwcPy6fewmluzJ3rCqZturzfqCcT9R0JXrYwfXrgEw?=
 =?us-ascii?Q?W6ojNRmi7+Qw2GfutvlxGoIRX9rtBpxW67+zFpcfspyjiK/FXORnEHinY4eJ?=
 =?us-ascii?Q?fGNHg3n0rsIhxHHxpLv04KEXJeeupAMGaegB6WcmujyvA07VprsCpHHDeBaJ?=
 =?us-ascii?Q?JDrnVXMUJnRjbHCuZ4Rr8N75r3LwGCOPZumcmCC6nO90AzUymNOlXiY8R6Yk?=
 =?us-ascii?Q?FL2qu7caKfkZ/2iRklYbrZJA8XSH4EkTXgvlOHKcyhX1rhwYE8u9DVubU8kg?=
 =?us-ascii?Q?YnVaosQXimF+TAMiNdkOOah7kjcwQKPS0NnCLXfgFnaFmqmAiMrqwcTQZxvg?=
 =?us-ascii?Q?/yWtzkc2kSeGknwsAj4YNwcIZOCq7BOuGuF1glj+xPam6HTAvfPRSCp90Dab?=
 =?us-ascii?Q?A+axHJzXz+YIndnPDpPd7BBgzXnlUHMa+S5/H3eb9G75GMC7qosS+V/oACdY?=
 =?us-ascii?Q?+kZ+vY7owcbsXiw/zQy0onCdaxXK0AYwmFnYpUXzcL080je7lF6Ri9Ygl+eG?=
 =?us-ascii?Q?1kTxfoxIXQfzgGUP64ndz9HIXyeayjYfTghLejfszjUOFZ/w7c57D9J36AVZ?=
 =?us-ascii?Q?jK5DTTAKxz7+1ruGbXH0JxkyJg7hzNj/nyixoq4mDhu6n5dRB/qzjHL+fDK6?=
 =?us-ascii?Q?E9Nez33MlITWuuVCnYk4We8tWYZjEOIWrNKd4ceE4EZ+UF3GHb8SuEm/iayp?=
 =?us-ascii?Q?t5Y6nL7np4yRKdinEmVh0Y84UuEqbbFHpNsm1lKoiuHHSIQwhi9Gs9phWXe/?=
 =?us-ascii?Q?g8nu8sCcrPHWCzrRkxi2Wgm6+QQqOJkwMFHi7y5UImjXewqt+zYTPp1s8Lpi?=
 =?us-ascii?Q?ztSPsdPgmmM8UbiP3+WUo4sqfTmIBXPQbHebuHPS6iF/d38/gaJ1nNCy6HLL?=
 =?us-ascii?Q?JJSS1R/AbBWtFKl/pBWEoxVrxICKBW6qmNdXSgltWxcrVtbOM4yCGFqeYqgP?=
 =?us-ascii?Q?Dz07Zc2gmKSZFTyGNqab57/QdJ1oFXRp3x+q3wMXEk0u7m8mi99IMhqzjljR?=
 =?us-ascii?Q?y4dydfw54aNykCmhcYa+z0M4HL0hbDhFXpdl8l81+6s1SGSrcr8v7Gv4HtuQ?=
 =?us-ascii?Q?77jRBsvVWcutk01KuMHEVLmY5tzLjhVAHvPGporOnmXNa4sLUUiTlr0Vr2Pa?=
 =?us-ascii?Q?sqScA0MCviMz6rsq6UQNOHWXplGf71dNb5Cb4ivfATd/em0sNSFu2T16n1WU?=
 =?us-ascii?Q?jXhWk+q1iZ2oJTHMvdCk59595WgTYG+32HDA2xl6FMjr8VexbmX2A83kJkP0?=
 =?us-ascii?Q?JLagCDlgu0J7v32PJjLSEFmVw+SeyT6uuZlSHVSmfOCTq4tDvo5wwJZkvAMR?=
 =?us-ascii?Q?3UlczjCKVHsJdNIJ2PpSWRjYZMk6HyOd1D7ZQvH1mienHFzoYRZl/LPiimyV?=
 =?us-ascii?Q?529Zr1Y7muyjy8MOH50peEhTm7EIFBt8I3p5HmPDp6fse0ojUabACohz8OAm?=
 =?us-ascii?Q?vszQ7dN9PPED3s9iKHvcfbXbEj8QtRu8WQ08TUUqIaESR4evhqtu5wgJiv+7?=
 =?us-ascii?Q?mUz1qoGK0COSaIK/r1Q9oxcpv+ngZsOe2RJI6TXNNqVtoxXbU6lmHN157nR3?=
 =?us-ascii?Q?0695jjfZSCzkP1Oo4YKWCpuFqTcxrkk=3D?=
Content-Type: multipart/mixed;
        boundary="_002_2022042819472227miieldyezhlas6revolver_"
MIME-Version: 1.0
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR10MB3022.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 178d2d4d-c277-493f-a795-08da294feccd
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Apr 2022 19:47:27.7933
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Y/MIRCQjb8Hs0bhE0AfJgDB9wallmQw75hPfxRKpdzUfgncde21Btg51GzcN4BP9Be8fAK5Yg0pomPBoypfE2Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR10MB5232
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.486,18.0.858
 definitions=2022-04-28_04:2022-04-28,2022-04-28 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 spamscore=0 adultscore=0
 mlxscore=0 bulkscore=0 suspectscore=0 malwarescore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2204280118
X-Proofpoint-ORIG-GUID: zxMF-pgRnO3oKTJrAkpZB9NrJt0cqgs-
X-Proofpoint-GUID: zxMF-pgRnO3oKTJrAkpZB9NrJt0cqgs-
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

--_002_2022042819472227miieldyezhlas6revolver_
Content-Type: text/plain; charset="us-ascii"
Content-ID: <E915DF258654D84593D7C5F13B736070@namprd10.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable

* Andrew Morton <akpm@linux-foundation.org> [220428 14:11]:
> On Thu, 28 Apr 2022 17:35:17 +0000 Liam Howlett <liam.howlett@oracle.com>=
 wrote:
>=20
> > * Andrew Morton <akpm@linux-foundation.org> [220427 18:57]:
> > >=20
> > > The patch titled
> > >      Subject: mm/mmap: fix __vma_adjust() memory leak
> > > has been added to the -mm tree.  Its filename is
> > >      mm-start-tracking-vmas-with-maple-tree-fix.patch
> > >=20
> > > This patch should soon appear at
> > >     https://ozlabs.org/~akpm/mmots/broken-out/mm-start-tracking-vmas-=
with-maple-tree-fix.patch
> > > and later at
> > >     https://ozlabs.org/~akpm/mmotm/broken-out/mm-start-tracking-vmas-=
with-maple-tree-fix.patch
> >=20
> > Both of these links are 404 and the patch does not seem to be in
> > linux-next 20220428.  Is there any chance this was missed?
>=20
> We're in the process of gitifying the -mm tree and there were glitches.
> Hopefully next -next will sort this out.
>=20
> Please review the mm-everything branch at
> git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm to check that
> everything has landed correctly.
>=20

Okay, this patch is not applied to the correct line number in that tree.

mas_destroy() should be called at line 905 before the validate_mm(), not
at the start of the function.

Besides that, everything looks to be in order.

Thanks,
Liam

--_002_2022042819472227miieldyezhlas6revolver_
Content-Type: text/x-diff;
	name="0001-mm-mmap-Fix-mas_destroy-location-in-__vma_adjust.patch"
Content-Description: 
 0001-mm-mmap-Fix-mas_destroy-location-in-__vma_adjust.patch
Content-Disposition: attachment;
	filename="0001-mm-mmap-Fix-mas_destroy-location-in-__vma_adjust.patch";
	size=951; creation-date="Thu, 28 Apr 2022 19:47:27 GMT";
	modification-date="Thu, 28 Apr 2022 19:47:27 GMT"
Content-ID: <17628BAA95A16A4D9B811B10A0A092E2@namprd10.prod.outlook.com>
Content-Transfer-Encoding: base64

RnJvbSA4ZDM4OGQ1MWUxNjllNTEyYjg2M2Q5MGU4ZDdlZTIwMzYxOWRmYmQ0IE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQ0KRnJvbTogIkxpYW0gUi4gSG93bGV0dCIgPExpYW0uSG93bGV0dEBvcmFj
bGUuY29tPg0KRGF0ZTogVGh1LCAyOCBBcHIgMjAyMiAxNTo0Njo1NiAtMDQwMA0KU3ViamVjdDog
W1BBVENIXSBtbS9tbWFwOiBGaXggbWFzX2Rlc3Ryb3koKSBsb2NhdGlvbiBpbiBfX3ZtYV9hZGp1
c3QoKQ0KDQpTaWduZWQtb2ZmLWJ5OiBMaWFtIFIuIEhvd2xldHQgPExpYW0uSG93bGV0dEBvcmFj
bGUuY29tPg0KLS0tDQogbW0vbW1hcC5jIHwgMyArLS0NCiAxIGZpbGUgY2hhbmdlZCwgMSBpbnNl
cnRpb24oKyksIDIgZGVsZXRpb25zKC0pDQoNCmRpZmYgLS1naXQgYS9tbS9tbWFwLmMgYi9tbS9t
bWFwLmMNCmluZGV4IDEwOTQ4YmIyOTg4Ny4uZDVkMjE2YTYyOGQwIDEwMDY0NA0KLS0tIGEvbW0v
bW1hcC5jDQorKysgYi9tbS9tbWFwLmMNCkBAIC02NTUsOCArNjU1LDYgQEAgaW50IF9fdm1hX2Fk
anVzdChzdHJ1Y3Qgdm1fYXJlYV9zdHJ1Y3QgKnZtYSwgdW5zaWduZWQgbG9uZyBzdGFydCwNCiAJ
TUFfU1RBVEUobWFzLCAmbW0tPm1tX210LCAwLCAwKTsNCiAJc3RydWN0IHZtX2FyZWFfc3RydWN0
ICpleHBvcnRlciA9IE5VTEwsICppbXBvcnRlciA9IE5VTEw7DQogDQotCW1hc19kZXN0cm95KCZt
YXMpOw0KLQ0KIAlpZiAobmV4dCAmJiAhaW5zZXJ0KSB7DQogCQlpZiAoZW5kID49IG5leHQtPnZt
X2VuZCkgew0KIAkJCS8qDQpAQCAtOTAzLDYgKzkwMSw3IEBAIGludCBfX3ZtYV9hZGp1c3Qoc3Ry
dWN0IHZtX2FyZWFfc3RydWN0ICp2bWEsIHVuc2lnbmVkIGxvbmcgc3RhcnQsDQogCQl1cHJvYmVf
bW1hcChpbnNlcnQpOw0KIAl9DQogDQorCW1hc19kZXN0cm95KCZtYXMpOw0KIAl2YWxpZGF0ZV9t
bShtbSk7DQogDQogCXJldHVybiAwOw0KLS0gDQoyLjM1LjENCg0K

--_002_2022042819472227miieldyezhlas6revolver_--
