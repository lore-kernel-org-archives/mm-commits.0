Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1390AC43219
	for <mm-commits@archiver.kernel.org>; Thu,  9 Sep 2021 13:10:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 00D49611AD
	for <mm-commits@archiver.kernel.org>; Thu,  9 Sep 2021 13:10:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347610AbhIINKv (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 9 Sep 2021 09:10:51 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:23740 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1354728AbhIIM6T (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 9 Sep 2021 08:58:19 -0400
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1899CJMm029648;
        Thu, 9 Sep 2021 12:56:47 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=uWH4n1pHwz6rxl4H1UKRCsC7jnZ7V12zVCY7Qb4xLPw=;
 b=qnyq3PfJ5wad0MaDp59sIRwpZB7r0TxJzx7T4AvOYT7sWmkOd1oFprxMxrU4fRJYXern
 D3t3CjukG3a9bARJ0/Zl5sXXZkyUkxpsNMSndUmGm7RYR8HGSbPKbnGW+dFrFjUf01fQ
 RDiXYgkspgVS4jqkdASysCdw4zXZN9SvPMyQP1L68SvcduVVsMVYWYXUNYkKmMC3IIuy
 GVTZttk2uolTV0ACafpBYpI4PsQOlXtHUXcoUIlNSoZEdtPBOSbyg1XkyRV1nK0cEP9Z
 ig7I3En226MxPOdr48jHOw7Lx57CnHuH+q8ov/EK684w+miqC15TGW8HOJPwVglqe3Ji uQ== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=uWH4n1pHwz6rxl4H1UKRCsC7jnZ7V12zVCY7Qb4xLPw=;
 b=mbrcdDrr7xzke6kSmVHvfzr0ZJygLDPp7mfnlKl+owtvZ1336JKO/FfQ1AyqcFitoXVT
 YBp3ALRCv2wReTGHyfZTD/mhSEvbJkbfgxpTj/jx5UMFBYDIkt7GOKyXQh2E7xONnQV4
 DT7PeOygC0HF2Tuf6vgRYvdCv39PbOioL6ms0pmyBU/1jpEakYxjBcmZv49mpG96YmY2
 ttCE0nFzLbmOyxh/n1Cf9BWOOkejRVeUlfhAPFnZPqaKDYEvdao6ixX/mYCThsSaM4Nf
 mBdphDE4PC4ImI7+cGBVQxItB38tW63lx1f8A88fcjZHJaHH9cDz0R0qhYn1+Ab5xTdp Tg== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by mx0b-00069f02.pphosted.com with ESMTP id 3ayfe90jhe-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 09 Sep 2021 12:56:46 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 189CuFiw093404;
        Thu, 9 Sep 2021 12:56:46 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2170.outbound.protection.outlook.com [104.47.55.170])
        by aserp3030.oracle.com with ESMTP id 3axcpq64hv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 09 Sep 2021 12:56:45 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=M0Fybtl5UmLRYv1AdDuxSwsdq0ZtrsNLbBlKJFZZuUzrDcQzUwyL3VahSILOctSFuMVYoOjl4D+WL6GGjCbCJhGiBmuFtWMZVe2f+gB8jYThb1RB+9FENsl/VfTT2T2+nwYEwqCIx59goiiuvF3g3SWBl6+DFU5bWgCbIiAO3d+00itdV/TpbPFlaEXAUMKxrfp6FVB4zF/kyw9r4GXKVt80iZxofVDDuRi9pgvtLXWIqaSTFZ9YkHzzVtZRmt1kib+DDubCbHctZuUrE6uYEo5Q/Hkol8x3koe/Pqf3NQw/v9Lw4jkF37yeUWEfKjhHlnY4UsdrqFqsKtZz2y47yw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=uWH4n1pHwz6rxl4H1UKRCsC7jnZ7V12zVCY7Qb4xLPw=;
 b=g/ez8ZgurBM4aGdefRBXO9WRp6q8JOfgkAhMUZowPtXfa3A0TpteeHlRaUoXxhYvsV0HJhKMDX8C6/D1TtY5kqb+4jilzt9OF9GcCT3YCQWnm9kqj1MhLjQaPd8SNnAy9rENW8I3QLJmx4mcrYBBc4DqP/xy/Xq3/9eYbdO5FaZipJ70HWyk2ZOFGVByFmi01+V5V8gicfWqP2bLu9CU1h+fiYHjvpDX916FOWXsFyttdf0F8of/b4fywaeoQ4iTUsO1vDBiHzE9aYfzNUXg6YUdpMpaCEAB75vg3if7smvUu/YY8Bz7lGf6XatCilzbSzZq1aWRmROUpMoIu6pmtg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uWH4n1pHwz6rxl4H1UKRCsC7jnZ7V12zVCY7Qb4xLPw=;
 b=MR74cOF1z8jjzs1UdlnrrDhZI6iyNSxUj+RzITSFSlWfnDEp/PsWOdhcIpX8etbhg1iocpeQr3RIp/dMwSmuoXjmEl1bKSLsYiR85kwiMXGqZ5lgQSGFCV0SvGtoVD471ZUrUZwVHc00F08Y7fbSFfO0qUrNi9OM6eDL1etY/Ug=
Received: from DM6PR10MB4380.namprd10.prod.outlook.com (2603:10b6:5:223::19)
 by DM6PR10MB3177.namprd10.prod.outlook.com (2603:10b6:5:1a4::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4478.22; Thu, 9 Sep
 2021 12:56:44 +0000
Received: from DM6PR10MB4380.namprd10.prod.outlook.com
 ([fe80::f4b1:d890:7745:30a3]) by DM6PR10MB4380.namprd10.prod.outlook.com
 ([fe80::f4b1:d890:7745:30a3%5]) with mapi id 15.20.4500.016; Thu, 9 Sep 2021
 12:56:44 +0000
From:   Liam Howlett <liam.howlett@oracle.com>
To:     Andrew Morton <akpm@linux-foundation.org>
CC:     "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "mm-commits@vger.kernel.org" <mm-commits@vger.kernel.org>,
        "rostedt@goodmis.org" <rostedt@goodmis.org>,
        "torvalds@linux-foundation.org" <torvalds@linux-foundation.org>,
        "vbabka@suse.cz" <vbabka@suse.cz>,
        "walken.cr@gmail.com" <walken.cr@gmail.com>,
        "willy@infradead.org" <willy@infradead.org>
Subject: Re: [patch 5/8] mmap_lock: change trace and locking order
Thread-Topic: [patch 5/8] mmap_lock: change trace and locking order
Thread-Index: AQHXpRd0yVsIOsBn0ECDvwTJZRI94KubqhWA
Date:   Thu, 9 Sep 2021 12:56:44 +0000
Message-ID: <20210909125632.jws3ob4kn35juqiv@revolver>
References: <20210908180859.d523d4bb4ad8eec11c61500d@linux-foundation.org>
 <20210909011014.JJu-mAZB6%akpm@linux-foundation.org>
In-Reply-To: <20210909011014.JJu-mAZB6%akpm@linux-foundation.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: linux-foundation.org; dkim=none (message not signed)
 header.d=none;linux-foundation.org; dmarc=none action=none
 header.from=oracle.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 24f6f7c2-fe09-4dc3-836c-08d9739146ae
x-ms-traffictypediagnostic: DM6PR10MB3177:
x-microsoft-antispam-prvs: <DM6PR10MB3177CD9D4870D12DDA7A0217FDD59@DM6PR10MB3177.namprd10.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:4941;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 5WR77wR9zea/Ycc56dlM6synoMkBjiM5hLwlTpi/TfWO+myi6kVyzI/ZEjHl1rvgOYQTid6vKnqj+8B8hdv24SubExErw9C02O9HUYazPlvubESGhy1rTJiZV/t8nleuQCzyryhV1FzBodrvLVuxEJdAAaTAYH1N5Uj8f4FPVhW//n/4/BAaMsseaCwifQnAZZILYgI3lckKVz3EIARlF+4W4h6q9GxRmZEklTI00FIy0jd/1ZhI8AHzofrf8aBEohA36AVEZFey8W/f0ZkZwFBvXmyuGVTS1nxvsFqorhYjKuLv2zO3AdEteT/4H/WOkuzvJ1zKkxkYNGwJgdbwxQ3y7YZZO282VkPxDaf9scHmFLQNlWk615mrsivo0tUAcG9id2u5QSDLao+YIgcHXs+Q+qyezsuOptFbhoRtu5Rd4nc/Keb8q+Q39lsHR5DB5Jy8LJQsF9kiR9CtW4hUnYKHUDmLAaPD25Gz7erH8BGHW9FTxuURPLOxSU54/u43y6tpCGGjpJI9H3vYugaRdRHWXkdykvsB2byHcLzDg3/H5MIyqmIE57Iv5oXLTB2NCuJCGf1wlBk/o0PIJEWThCFXAUw5TpoIhYicVOp/2d2Xm7KUheOathmN9YIQefOjKgbK97pWAz8SSL5IyGbeUEkpSdebWdJn0Vpv4SGOLGRJRVcETHiU+k75r4OsnKfc9Be00CJpvxMZzwffSRCTP0rTtgzpbMZQRX+xYkOozGAvu8R42JGxrBV4bH0ferszq0EEE7kRmBO1gEFQwI19xOzaZlJaEMlvrOBWayYGa1lYqvVEhlwXxTRxkS21xQu6
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB4380.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(7916004)(136003)(376002)(396003)(366004)(346002)(39860400002)(122000001)(38100700002)(33716001)(76116006)(4326008)(9686003)(66556008)(66476007)(6506007)(91956017)(8676002)(64756008)(66446008)(38070700005)(5660300002)(6916009)(2906002)(6486002)(66946007)(83380400001)(8936002)(6512007)(966005)(316002)(54906003)(478600001)(71200400001)(26005)(1076003)(44832011)(86362001)(186003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?nXj9m6hrzNgjvIQs8envHID3oe9IhFO5eP6e+378QfiSG5M8MO1RCsNmjUwT?=
 =?us-ascii?Q?8OWxRD3hITPgImiVb2JWtMg5k0/7LhueApuifQj5Br5zeL3cOM9s7ayRjRQf?=
 =?us-ascii?Q?MWZe43gNGsQI88GopKE8qnVtjkW8lhuOnHjRVo3VbOA0ckaIi1tP3g5EjGyS?=
 =?us-ascii?Q?pWXPaYehhNrkxuulK1J3sfbCeDbhlu3wDiEkd6kpkBN8zl4S25UO+4tldvxL?=
 =?us-ascii?Q?UnTyKuq/lJCzRuUTYeQeLG0J0E/vt8C31DeABhOSkiKc+p/tbO4o9KEqgYwK?=
 =?us-ascii?Q?ZvgMwLViwcWE20eQu6MFuL8v35vazpxgSgaY5ug+H1FaHbpJjYGojJ7ZoQGT?=
 =?us-ascii?Q?P2Gii3+VyrhpWrJWpuc1LaC8X9QTvRcRpFTJulmZA66dAoLHIfq1OLpkSt7N?=
 =?us-ascii?Q?U2QmiPhWw/x/kM9JpYOU3TRtj4RTCFztq4G9JNSN0oX213iM/3oNuFOquL6o?=
 =?us-ascii?Q?5mj27LQH/nzPqj40365Le+4JHrvu71JG2VLGmVU0WHrg3DhO+NheU3+HV6nE?=
 =?us-ascii?Q?va1Phn0rwGzFmQSWONDIfTRHupztTXJVZHGnJncILOnhCb/QnBeVXaiNKp4c?=
 =?us-ascii?Q?ichgKXmV4Wlot7K/HDWNCPgmw9ofoRvvWsr30H1VZ6MoWAombxagkzNUgyuz?=
 =?us-ascii?Q?dB/EizXEG/GxlhcV+n0lMoEr/RPze7oJQtfi1N2U/uowHOReYh/zW4I4YxaO?=
 =?us-ascii?Q?AjOsPEoc4SMqGPoXyCP8OsJFt6J8DZkEIh7+isy13MUc4kuWFGd0auYiite3?=
 =?us-ascii?Q?5uMaf+FOQH9vMjgE1Am5rcXzt24QrKbPVBDuQYgB4vqjslc4dRaI+Ff/+BwJ?=
 =?us-ascii?Q?av0DjKRJZGMNBqlNcxcMt8hApWeHqwSlFXrMwp79UfVY3TlvpOcY7b+F0duN?=
 =?us-ascii?Q?HHKXafBLDcW/XB/6c5+SilfOn9ZD807SGuGeb2Sw/DS3yu8wjX7dALOKNkxY?=
 =?us-ascii?Q?DrNWWmFJiqJwmPwBWzw2UbrbxdlH625O04IKtid7jr+vIa3lUOjaAUiA8nf4?=
 =?us-ascii?Q?We+Lhdf9iA2XAq6XV5kp95X60RKdX1QTrx/WC0nhK+0jqPBqoGSbTNYcirY6?=
 =?us-ascii?Q?gIRS0KA1qj89Li5mKUIZu4uwKgOKHYFT6uvKBkz600wnqsy/X5wSHwqbmzaF?=
 =?us-ascii?Q?gczkxyXYlbswdlVaAeRDXDIzJPzgFxXVqJelhPBqtg6DKYCMC5hTY/y3xWor?=
 =?us-ascii?Q?Mp29wbKzLvloCEIfViadlsGFhOooGdnmZfpP6oubD7AVHj2zW4JHqPSZj1O0?=
 =?us-ascii?Q?Pne9uKPS7focoUpXKKliKBzC+p0wUpy3DPzmWmKQ+Bn3IjdJiYAmOIvpAr+O?=
 =?us-ascii?Q?5rrh1slGjW6w8XAw1dkdx6Fh?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-ID: <384DE0670AB2FF499BE61D47F419090D@namprd10.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB4380.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 24f6f7c2-fe09-4dc3-836c-08d9739146ae
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Sep 2021 12:56:44.1436
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 2eV+HseVKCral0RtRgAuDEgQaNzgQlTUFsLa9YBBlwxwebUtk0o6CQWa3I7A7KSOmgdWkQ1utPzs9I2wnbHzig==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR10MB3177
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10101 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxlogscore=957 bulkscore=0
 suspectscore=0 mlxscore=0 phishscore=0 malwarescore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2109030001
 definitions=main-2109090079
X-Proofpoint-GUID: uNBbhVwdfiIMGKDKr26SFK1D01SapEn3
X-Proofpoint-ORIG-GUID: uNBbhVwdfiIMGKDKr26SFK1D01SapEn3
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

Andrew,

I sent a v3 of this patch with a better description as suggested by
Vlastimil Babka and Steven Rostedt.  I also forgot to add the
reviewed-by's and acked-by's from v2 as Steven Rostedt pointed out.
It's probably best to look at the email message [1].

1.
https://lore.kernel.org/linux-mm/20210907162537.27cbf082@gandalf.local.home=
/

Thanks,
Liam

* Andrew Morton <akpm@linux-foundation.org> [210908 21:10]:
> From: Liam Howlett <liam.howlett@oracle.com>
> Subject: mmap_lock: change trace and locking order
>=20
> Print to the trace log before releasing the lock to avoid racing with
> other trace log printers of the same lock type.
>=20
> Link: https://lkml.kernel.org/r/20210903022041.1843024-1-Liam.Howlett@ora=
cle.com
> Signed-off-by: Liam R. Howlett <Liam.Howlett@oracle.com>
> Suggested-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
> Reviewed-by: Matthew Wilcox (Oracle) <willy@infradead.org>
> Cc: Michel Lespinasse <walken.cr@gmail.com>
> Cc: Vlastimil Babka <vbabka@suse.cz>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> ---
>=20
>  include/linux/mmap_lock.h |    8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
>=20
> --- a/include/linux/mmap_lock.h~mmap_lock-change-trace-and-locking-order
> +++ a/include/linux/mmap_lock.h
> @@ -101,14 +101,14 @@ static inline bool mmap_write_trylock(st
> =20
>  static inline void mmap_write_unlock(struct mm_struct *mm)
>  {
> -	up_write(&mm->mmap_lock);
>  	__mmap_lock_trace_released(mm, true);
> +	up_write(&mm->mmap_lock);
>  }
> =20
>  static inline void mmap_write_downgrade(struct mm_struct *mm)
>  {
> -	downgrade_write(&mm->mmap_lock);
>  	__mmap_lock_trace_acquire_returned(mm, false, true);
> +	downgrade_write(&mm->mmap_lock);
>  }
> =20
>  static inline void mmap_read_lock(struct mm_struct *mm)
> @@ -140,8 +140,8 @@ static inline bool mmap_read_trylock(str
> =20
>  static inline void mmap_read_unlock(struct mm_struct *mm)
>  {
> -	up_read(&mm->mmap_lock);
>  	__mmap_lock_trace_released(mm, false);
> +	up_read(&mm->mmap_lock);
>  }
> =20
>  static inline bool mmap_read_trylock_non_owner(struct mm_struct *mm)
> @@ -155,8 +155,8 @@ static inline bool mmap_read_trylock_non
> =20
>  static inline void mmap_read_unlock_non_owner(struct mm_struct *mm)
>  {
> -	up_read_non_owner(&mm->mmap_lock);
>  	__mmap_lock_trace_released(mm, false);
> +	up_read_non_owner(&mm->mmap_lock);
>  }
> =20
>  static inline void mmap_assert_locked(struct mm_struct *mm)
> _=
