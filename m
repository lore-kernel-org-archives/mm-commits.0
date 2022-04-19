Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DD64CC433F5
	for <mm-commits@archiver.kernel.org>; Tue, 19 Apr 2022 20:30:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345952AbiDSUdX (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 19 Apr 2022 16:33:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52902 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357642AbiDSUdR (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 19 Apr 2022 16:33:17 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A8B33C4AB
        for <mm-commits@vger.kernel.org>; Tue, 19 Apr 2022 13:30:33 -0700 (PDT)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 23JHcfsq009531;
        Tue, 19 Apr 2022 20:30:26 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=Ih3CfK503+9Z/w58DtmZcZWFxeU4CXNGpvInTehOHPU=;
 b=EhNJ6dR4Kc4vtdoilQKxINANuXgbPJKlAQ16Qbyjj0U9QN26b3OnNr8ZYZyuaXeN7WYY
 Pg3fTnQ+pzeM5EV0DArKMY32s8T5RvW0BHpGSXdkA3wZAOq4IFNCLtbgad1HhoKiiw/o
 eo0OLCv9u7rRAyun+hztv6YYs8ezQ3sJQ/6B00H9BpRhezXBrvwhhW0p0wO92h1EMM1A
 2wmjCgiHxmpY8JIOLC3Qd5HKhnTv9BqVSXA25J3W+srAFVFvkazhb8KEcs179RfvHQvh
 Hi/AD1OU4KostBi8pt9naWjPpuETJtZpl3ofTMny7fooWdCjs82Uc+5Inwxy4T6paQU0 Qw== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com with ESMTP id 3ffmk2q6a2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 19 Apr 2022 20:30:26 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 23JKFfvJ015342;
        Tue, 19 Apr 2022 20:30:25 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2176.outbound.protection.outlook.com [104.47.58.176])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com with ESMTP id 3ffm88shgb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 19 Apr 2022 20:30:25 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EldB7LmFQjkOhMQ1lSfkiih8Wo9afU/7VeQBaakc+NTWEKDRsgoMBkAJsyFzxh4uswI1PcrbYD891MRoPpYYVPMSAdkBCg/CGx+ZjhfOK26z0HcpTd1iViEXLfm2mNq5q2drLzBIh7VrX/1SYypJrwlqpeEW/GICKSREZybmv+zqMN+j8Kp4+sFQfNtof2ZnDPLe3tCCr27oSn+oClcb6QGyEWQO1CdPafbgGe8nhLMpBhu+n2nIAB2TCZbwqgXyGwkX+0bLoUAJUk2RFiD6jBFtg+TN6Y2dn2KKmS4Hi2ZtAuJwVxCbfxp4nO8523TKNZQuc4iHq9OpqV9cV9Yudw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Ih3CfK503+9Z/w58DtmZcZWFxeU4CXNGpvInTehOHPU=;
 b=XtEda3pLkWwMbhXkzrZ8WOOn0oUnk4ruKnMjCcfkNE7lVPn9CS6+RjqiCHHOA5j4qetx6a40/gQAGVsn+oCUHAyZU8SF+Rgx5GfmaxUDx5GlWa/c4wEJ/z6/dqo+gyL6eqDAKTaHM1KV3H6SIFTKcG8v7oLxgLJ60we/4RQwuuIj2rrrs+b8Yvz8zo2BOVk1jxrg44CmrVXuT8eRQpiU/X/ly48pDaLIu51fg5wyefeQXUsLk4aiCbeorNWcp7vAqb/Ebk1R5cc1vyK5qnpb5Jf3Ve5arkaHoo1UIgmx4+MbNTTaAJIhU4dTyADutTRdsXTy9FzURd+ZFsUrD/3hqQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ih3CfK503+9Z/w58DtmZcZWFxeU4CXNGpvInTehOHPU=;
 b=0Mo9ijl8WA3KcwTKlFPVAB6vd5Cz6R3c6rSVM+IXqrmQFSoMLJAyibAOGNIo9BpDF+ESNPDMVFvDp8dnodaEyw4qGkpSTlCSMBGgEy5hGvnjQoR0s9jhRGzn9FBHGN7h+0BTEAjMU51OBKHZtmm88HAVgPHEpYU4Gbb9cA3ZNdM=
Received: from SN6PR10MB3022.namprd10.prod.outlook.com (2603:10b6:805:d8::25)
 by CH0PR10MB4923.namprd10.prod.outlook.com (2603:10b6:610:da::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5164.20; Tue, 19 Apr
 2022 20:30:24 +0000
Received: from SN6PR10MB3022.namprd10.prod.outlook.com
 ([fe80::318c:d02:2280:c2c]) by SN6PR10MB3022.namprd10.prod.outlook.com
 ([fe80::318c:d02:2280:c2c%7]) with mapi id 15.20.5164.025; Tue, 19 Apr 2022
 20:30:24 +0000
From:   Liam Howlett <liam.howlett@oracle.com>
To:     Andrew Morton <akpm@linux-foundation.org>
CC:     "mm-commits@vger.kernel.org" <mm-commits@vger.kernel.org>,
        "will@kernel.org" <will@kernel.org>,
        "catalin.marinas@arm.com" <catalin.marinas@arm.com>
Subject: Re: + arm64-remove-mmap-linked-list-from-vdso-fix.patch added to -mm
 tree
Thread-Topic: + arm64-remove-mmap-linked-list-from-vdso-fix.patch added to -mm
 tree
Thread-Index: AQHYVCWFvq3YBPwrukCu4m9fzB/y3Kz3sEKA
Date:   Tue, 19 Apr 2022 20:30:24 +0000
Message-ID: <20220419203015.f24d45chne4v4nee@revolver>
References: <20220419194147.D348BC385A5@smtp.kernel.org>
In-Reply-To: <20220419194147.D348BC385A5@smtp.kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: b35b305d-ee36-4936-f728-08da22436ec4
x-ms-traffictypediagnostic: CH0PR10MB4923:EE_
x-microsoft-antispam-prvs: <CH0PR10MB4923FAA3677C36F3F765C7CDFDF29@CH0PR10MB4923.namprd10.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: z9hdVUFX+XoVKR11AtRQ1QnHtKXj0T/u2CetUFB7jlSzTSRqs0cmImH3k7MaOHZ7B3dG8PYnzGXlQmUS/tXYRw1b2uJ/hauEwJ981OM+hb0IDywhqqgEtvfdxfco/SvarksiGRR8Ya4NSoHdPH2kiZ2iydKitxcsfgRAxJ7d91kF0QV2rXExcePjrPj8l+EOTaZiNcFWz/k7tmnH9xYnkEXbyoR3fCJFyyooc1u7AYed5eTcZujmf6wwpXQq0jPJCewHBWYHhj9lwPBH6Snubt2MDQxVix+FYUMkJao3XkPbROUd0H8pYLc8I+JfQIDaaIWe0hIscoiBhKznN71N7WF1G+hsZl2i5V+iCzRX20PgiVXYsdI52x+lhIJMNzZcDW+GiIHSEhIzyVT0G4fGf8BOsmxL/imgGmn/X3LhcW7CG7zIGJNm/zPhMzgzN0i6hhGSa36yF815a79HyAadk0xKNp1T1N19smiXxgClL8CJnLxl+/ucVoWB6z4GwXBW9DHs5INVFd10GDTIXeQkxVa75UB9d1ytYj+enZgku2AOAwqlwvI8MWeKcb1IAw0/RYrL4pC0+9KXp+4a3JuUXwIjcnBqjgOHKUSdlnQnI6p5nR4fSAJVuJVPR1BP9YHyjxxgGiZfPnx4YABi5p5k03Ex3e6qadxp4+85KPfSlyyHyUsjzCky27T+LA/0Fn6iAT4bwjbEx+mTdwhrCqsymmKUvSHXQDcGWM0o2W31GCWmN2WZ2loLsUOE0PviUBU7JI538RUcyIDo1+kb3S8hj9j3xweUb6EPT/OfqLhRpQeM4F7306Yw6xJhoKM3sODhN3CnG7tE9awVp6J40zszNA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR10MB3022.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(7916004)(366004)(8676002)(6486002)(122000001)(66476007)(66556008)(66946007)(64756008)(83380400001)(2906002)(33716001)(91956017)(4326008)(54906003)(38100700002)(6916009)(38070700005)(316002)(966005)(66446008)(1076003)(76116006)(44832011)(5660300002)(6506007)(8936002)(9686003)(186003)(6512007)(26005)(86362001)(508600001)(71200400001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?7Cc7udo3FCdPqpbuEcWz496przLqUPuEwLPTzLszc0e5grAFxl6odB8PQHIa?=
 =?us-ascii?Q?FBRxSwIvnP75RAjmNMldgZ0VTI5sRAsxrCZCcN3l+vWpiO/V/nmnyo76yUmv?=
 =?us-ascii?Q?QqUCydvBj4PtB7ZkSMxvFmTj8OpIia+7/i2rBNlvzP08TRvPnpc8Wh8IgXYz?=
 =?us-ascii?Q?zn7VqCn7qgL+lmdEN7EIB+A0PStiNhgUePUSZtRFHU8/uRNhD3abpELUTRMw?=
 =?us-ascii?Q?P7ucl1258KKm3DT8tbT7kBc5zwqy3omWlrbq2BE2hptegZJf7Wg19/OrmCCQ?=
 =?us-ascii?Q?U279eXgf/zdh5IK+DnN6hEny8yXHZnwIONEWlKv39Fw8i3k9jpmND9sYwVwm?=
 =?us-ascii?Q?NRNln8SywK0MvJT0RJFRhrvnsF4Mq0TwG7z0VodCXQnOwBxHqn5W//fiziNf?=
 =?us-ascii?Q?wmgDqtoI2ibCKnHBiy09JRMHdcNb6+n07mhgXZzhIVsGhbumWoK+e02BY80S?=
 =?us-ascii?Q?O/REq64s1X00grU4k/v4l6RXCsnq5mC5rVUiU4wiu81YoEwgyLoOnNxV9TTL?=
 =?us-ascii?Q?UBySGK/+qJVVFKwhP8zSxiJyUKP6hnEGl+8J4TmwhOSzsinS3pPgMvMSrWCR?=
 =?us-ascii?Q?tJYZIVyE8lh4c9xfIV5RJzwIy2VfCqb/JNe3p0Zd5qTpcgYv2CwCVKZdCgum?=
 =?us-ascii?Q?/B4SbzFzlPjHfrve8NxFWuCpuBZFVSywWuO9Gwz00O2wC3Fau5u2uT10T9fm?=
 =?us-ascii?Q?UjuiGFwdu/SkXSMSHlSyHgR6wCs3Z1JyXQ5+soivuQy7uk8+MZbMMvBprenJ?=
 =?us-ascii?Q?OpTBpq4jxG9wvjhQR/H3Q171ojUFHvW6dcTzfcY00/MDqMALi17q6Q6CsV4h?=
 =?us-ascii?Q?ILaoGqpvPNwkDOSQSyj7yru04MBOqFDEafFwz5qXVhshoUIWwXl7MC3kolRv?=
 =?us-ascii?Q?er8Wx5+9rztzL8TaVPM3IClMOsPlZ9+R8hoykO9aUngEvfJW4m+dUCVm8kUR?=
 =?us-ascii?Q?F30CRDW7YJic/PuOjnwnconwu8c7r1rTS2q3vwQWWudATxQ3HKz0eti6iFdI?=
 =?us-ascii?Q?ve27wDWYQzJOzVMH7X1vQ/f7hEAxePS6D2byucjzsz1m5X9OK6S6IoF6KFJ/?=
 =?us-ascii?Q?VB5LCd1tA4IPYr7h+gWXrl4EhR576UqIE9HOkRJ+ucomceI50lndWh/EIgJy?=
 =?us-ascii?Q?AL/bNpgf5x9doImsDJhdy1MIj1PDL1NTuA2GWLwGe7SvclkhDcHetiwTFhCb?=
 =?us-ascii?Q?AM01qIR7cGgyAV+hMlAu5erNnA0fzYkpcX787EROG7SKIxIJ58LNK3Vs5uqa?=
 =?us-ascii?Q?7hdDTYgT1w55YiJXA//BUGeKW3DTmTjp3u852CgtcAvEta2y/VPVQUn1732Q?=
 =?us-ascii?Q?YaEiIZBY7DBQWuwOGLqAfU4DULiC2sBQbWqcFUbr9bDUZj1ttl618+uQf2WV?=
 =?us-ascii?Q?q72e7SFCQt3YsRmAmO9ulkG7JC1dSfam4QLY/HufB+n9WBnWUnUY7Mv5+EP+?=
 =?us-ascii?Q?UctITMFPwk560fWNnCjmgYSS30Lv1Y7tdHlqPhvTmbJueRq+hd/xeC0/1Djs?=
 =?us-ascii?Q?OEqCWl6bCAmYVcefuK9COwmN2O0BfxwmtPuq/QMTh4oed2LTtNJbi6XED4up?=
 =?us-ascii?Q?wliS41/JyoVe2uxO5TeU/6Rq/MceL7G0e2Ngi7ikLMs7g5lHthTpVuN5WG3V?=
 =?us-ascii?Q?f8PI6lU4d/RLjNN9p+nn17Rzwwv3vuqVRRj3JBXBQD6gb+EmIOo9J+KQAig7?=
 =?us-ascii?Q?gQLYLYaeJIoDAl+oGynRX4vUSQiinVfyAhcLOXJ2f5ZhJZkkrNT7i69Yd/ut?=
 =?us-ascii?Q?lctbdQBGusQRHlEQlhgJCMdLpCEmfVk=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <70654A7AB2E60A44B624CDA7AB989327@namprd10.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR10MB3022.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b35b305d-ee36-4936-f728-08da22436ec4
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Apr 2022 20:30:24.2433
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: zt6wDfjszwoHH4nvmf6VahzBjz3ZqiwbmsPqIQ1CXq1woO3EoBIgIHqQ7BdGq9R6rX4DywCrnJxlVNOSFbBETA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR10MB4923
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.486,18.0.858
 definitions=2022-04-19_07:2022-04-15,2022-04-19 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 malwarescore=0 mlxscore=0
 adultscore=0 mlxlogscore=999 suspectscore=0 spamscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2204190114
X-Proofpoint-GUID: qdre-pFv1QqGHSKndiI7MewaP8G_Y9GS
X-Proofpoint-ORIG-GUID: qdre-pFv1QqGHSKndiI7MewaP8G_Y9GS
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


Can you please keep this as its own patch?  Although both are linked
list removal from arm64, it's probably best to keep them as two logical
blocks changing different areas.

Thanks,
Liam

* Andrew Morton <akpm@linux-foundation.org> [220419 15:41]:
>=20
> The patch titled
>      Subject: arm64: change elfcore for_each_mte_vma() to use VMA iterato=
r
> has been added to the -mm tree.  Its filename is
>      arm64-remove-mmap-linked-list-from-vdso-fix.patch
>=20
> This patch should soon appear at
>     https://ozlabs.org/~akpm/mmots/broken-out/arm64-remove-mmap-linked-li=
st-from-vdso-fix.patch
> and later at
>     https://ozlabs.org/~akpm/mmotm/broken-out/arm64-remove-mmap-linked-li=
st-from-vdso-fix.patch
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
> Subject: arm64: change elfcore for_each_mte_vma() to use VMA iterator
>=20
> Rework for_each_mte_vma() to use a VMA iterator instead of an explicit
> linked-list.
>=20
> Link: https://lore.kernel.org/r/20220218023650.672072-1-Liam.Howlett@orac=
le.com
> Link: https://lkml.kernel.org/r/20220419192157.2jn6olj7lg6jvo5e@revolver
> Signed-off-by: Liam R. Howlett <Liam.Howlett@oracle.com>
> Signed-off-by: Will Deacon <will@kernel.org>
> Acked-by: Catalin Marinas <catalin.marinas@arm.com>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> ---
>=20
>  arch/arm64/kernel/elfcore.c |   16 ++++++++++------
>  1 file changed, 10 insertions(+), 6 deletions(-)
>=20
> --- a/arch/arm64/kernel/elfcore.c~arm64-remove-mmap-linked-list-from-vdso=
-fix
> +++ a/arch/arm64/kernel/elfcore.c
> @@ -8,9 +8,9 @@
>  #include <asm/cpufeature.h>
>  #include <asm/mte.h>
> =20
> -#define for_each_mte_vma(tsk, vma)					\
> +#define for_each_mte_vma(vmi, vma)					\
>  	if (system_supports_mte())					\
> -		for (vma =3D tsk->mm->mmap; vma; vma =3D vma->vm_next)	\
> +		for_each_vma(vmi, vma)					\
>  			if (vma->vm_flags & VM_MTE)
> =20
>  static unsigned long mte_vma_tag_dump_size(struct vm_area_struct *vma)
> @@ -81,8 +81,9 @@ Elf_Half elf_core_extra_phdrs(void)
>  {
>  	struct vm_area_struct *vma;
>  	int vma_count =3D 0;
> +	VMA_ITERATOR(vmi, current->mm, 0);
> =20
> -	for_each_mte_vma(current, vma)
> +	for_each_mte_vma(vmi, vma)
>  		vma_count++;
> =20
>  	return vma_count;
> @@ -91,8 +92,9 @@ Elf_Half elf_core_extra_phdrs(void)
>  int elf_core_write_extra_phdrs(struct coredump_params *cprm, loff_t offs=
et)
>  {
>  	struct vm_area_struct *vma;
> +	VMA_ITERATOR(vmi, current->mm, 0);
> =20
> -	for_each_mte_vma(current, vma) {
> +	for_each_mte_vma(vmi, vma) {
>  		struct elf_phdr phdr;
> =20
>  		phdr.p_type =3D PT_ARM_MEMTAG_MTE;
> @@ -116,8 +118,9 @@ size_t elf_core_extra_data_size(void)
>  {
>  	struct vm_area_struct *vma;
>  	size_t data_size =3D 0;
> +	VMA_ITERATOR(vmi, current->mm, 0);
> =20
> -	for_each_mte_vma(current, vma)
> +	for_each_mte_vma(vmi, vma)
>  		data_size +=3D mte_vma_tag_dump_size(vma);
> =20
>  	return data_size;
> @@ -126,8 +129,9 @@ size_t elf_core_extra_data_size(void)
>  int elf_core_write_extra_data(struct coredump_params *cprm)
>  {
>  	struct vm_area_struct *vma;
> +	VMA_ITERATOR(vmi, current->mm, 0);
> =20
> -	for_each_mte_vma(current, vma) {
> +	for_each_mte_vma(vmi, vma) {
>  		if (vma->vm_flags & VM_DONTDUMP)
>  			continue;
> =20
> _
>=20
> Patches currently in -mm which might be from liam.howlett@oracle.com are
>=20
> radix-tree-test-suite-add-lockdep_is_held-to-header.patch
> mips-rename-mt_init-to-mips_mt_init.patch
> maple-tree-add-new-data-structure-fix.patch
> lib-test_maple_tree-add-testing-for-maple-tree.patch
> mmap-change-zeroing-of-maple-tree-in-__vma_adjust.patch
> arm64-remove-mmap-linked-list-from-vdso-fix.patch
> riscv-use-vma-iterator-for-vdso.patch
> mm-mmapc-pass-in-mapping-to-__vma_link_file.patch
> mglru-vs-maple-tree-fix.patch
> =
