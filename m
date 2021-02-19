Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5F102C433DB
	for <mm-commits@archiver.kernel.org>; Fri, 19 Feb 2021 20:12:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 114FC64EB7
	for <mm-commits@archiver.kernel.org>; Fri, 19 Feb 2021 20:12:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229555AbhBSUMk (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 19 Feb 2021 15:12:40 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:17498 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229515AbhBSUMj (ORCPT
        <rfc822;mm-commits@vger.kernel.org>);
        Fri, 19 Feb 2021 15:12:39 -0500
Received: from pps.filterd (m0148460.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 11JK8ugm028630;
        Fri, 19 Feb 2021 12:11:44 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=VowV5Nk3hrT06XEEC2ka59+RxamF5FmS5DkyUanyKdA=;
 b=Z8L0MLv/OOEYkaCJk6Qn3KsLnzgADJpxrpK/O9EwpQUhbFkSpMsyoyajTXNdzd7Wwfog
 bNyhM2cccW1GhZcgqxRt+z+fC9PtFJHMx9vssOwqSXnGVtK/1ouW8hDLx5co8cHJwJan
 a6HgfpouqCe9OhsdPYhPVn17LF6AQnCccI4= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 36sdpmungd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Fri, 19 Feb 2021 12:11:43 -0800
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.36.101) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Fri, 19 Feb 2021 12:11:43 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JwwKe7K2Kyrfj9eoXbPJ+2jYVo837n46zUiVRMNab7bSQmmNnaKuYfUW3ofL9QDDdvBnJkXt7bKTUanXTAkMF3rTjPsOFkduF/sjN7+RcTRZJeQK3OInGLDnbe7O2tRBaLJ/e/1/8aORwpH9CKX7+Uj+3XIHwp6YKH3nYeRtUBvOTfBlobIWZPkT3FsjQeRQmlDOkiNku0eOkDN+j6YncPLRXkwDvtjEiNdShcjaurM0dJDb2AjXc1mEzYZc6DiZGUif70cmidikGxSiEcCgnSZ6w3SfCci50GiZvFEx33it79xpYc9slAu52CNyarCw3zzADXIXgeQ6eRZwp/QHSg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=V75PeWuwZGAVOIOX+IefznjIu78BOyTTQJfOHINUTSA=;
 b=OJFVAm2+gOm2lwH0MJFW79dCTEJLhA/ygfiPFFKJanepnrFQuB2n+eFnsDxes9uWpDTyB4nn7hnhmNiR3GX1uGz9cmXjmQtga0/lA2vK5hZz6awUNnz4uGgRWyotdYeNsmZ25OZRPV5bJaWz/MwdaMRQo7ezQvN2fROMeMt1XKAPYC7zzp06cNzqDZiqXiqc+O+chLAlKFbDB58evlS0p+zioThl/o6yM4ZVIbiNGxxDfKRzs/aoIqHQBiO9H/zOt7v0sMRNp2HMbaiAFKdDe9ulYZkVJ5ozOx0BpNHsdQt8c69Wl4wgcpWGlBG6fY/oZBIxQ+Ahye7CU/IQ20ef1A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Authentication-Results: oracle.com; dkim=none (message not signed)
 header.d=none;oracle.com; dmarc=none action=none header.from=fb.com;
Received: from BYAPR15MB4136.namprd15.prod.outlook.com (2603:10b6:a03:96::24)
 by BYAPR15MB2983.namprd15.prod.outlook.com (2603:10b6:a03:f6::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3846.27; Fri, 19 Feb
 2021 20:11:41 +0000
Received: from BYAPR15MB4136.namprd15.prod.outlook.com
 ([fe80::53a:b2c3:8b03:12d1]) by BYAPR15MB4136.namprd15.prod.outlook.com
 ([fe80::53a:b2c3:8b03:12d1%7]) with mapi id 15.20.3846.043; Fri, 19 Feb 2021
 20:11:41 +0000
Date:   Fri, 19 Feb 2021 12:11:36 -0800
From:   Roman Gushchin <guro@fb.com>
To:     Mike Kravetz <mike.kravetz@oracle.com>
CC:     <akpm@linux-foundation.org>, <mm-commits@vger.kernel.org>,
        <chenwandun@huawei.com>
Subject: Re: +
 mm-hugetlb-suppress-wrong-warning-info-when-alloc-gigantic-page.patch added
 to -mm tree
Message-ID: <YDAbeDsG7GhV6s6B@carbon.dhcp.thefacebook.com>
References: <20210219183717.02Po6%akpm@linux-foundation.org>
 <YDAVzRNTpFTXGR93@carbon.dhcp.thefacebook.com>
 <c6a1e494-ae82-5a71-d799-34f0857ecb7c@oracle.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <c6a1e494-ae82-5a71-d799-34f0857ecb7c@oracle.com>
X-Originating-IP: [2620:10d:c090:400::5:25d6]
X-ClientProxiedBy: MWHPR04CA0070.namprd04.prod.outlook.com
 (2603:10b6:300:6c::32) To BYAPR15MB4136.namprd15.prod.outlook.com
 (2603:10b6:a03:96::24)
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from carbon.dhcp.thefacebook.com (2620:10d:c090:400::5:25d6) by MWHPR04CA0070.namprd04.prod.outlook.com (2603:10b6:300:6c::32) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3868.27 via Frontend Transport; Fri, 19 Feb 2021 20:11:40 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4535d4e7-fd70-43da-6c73-08d8d512923e
X-MS-TrafficTypeDiagnostic: BYAPR15MB2983:
X-Microsoft-Antispam-PRVS: <BYAPR15MB2983662D868242CC2C61704BBE849@BYAPR15MB2983.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:117;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: wzdX3G/6i9tA1qIer+wdKeF0vJ3guzliL1+0hMhSlfjoNAGq6AX8d5HMS9Rg6ZWoUmS7PT7Dg4gOI4TeZkSt3Vz5R1ETA4gLV/CbVNFwbfBpZHE/HbkVwa8UXNOx+Qqe71bTQ2T3dz0BzFaNFof2VvHoCPF8fkqHYzjhfpVCAzHkrNnEqDC98bZW/Jx+z54dcUil8zKUWkG4WcrR8o5Ih8mboGDLDNeKPPBuDBtQWkKXG/yw0vjVGHPmbP6GNCET7M1adhFJYyGSZkaJDyTnTkv0BIfD1gidy4YOWA/fhpHcg58IdcdL/pCpUTkRR6AM/IYiDnyCqauOxnOCEdzKWqFVCAeXRlp73B5gZFn0Riak7jJ3RBHgILrC3ngtFddKpIBgusIvntR17mLp2Pvm9GittqDs2v5ztY8rdGtO+4duhX7/FeFcKbOYTrD5lQqGDMMSuisBGKJAHAvBrii3a7vqYCzG2seP7x7giDR585zBWe558i00G1dkN0VvMDpFdRsFM45HDP6tEWHADFiSy2HrLLbcZBrjVw0tEi6f9GRTxIWvW6PcomBmdsX82VJcarAbE88zUBLel64tjh7L+A==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB4136.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(39860400002)(396003)(346002)(366004)(376002)(55016002)(4326008)(66476007)(6666004)(6916009)(8936002)(52116002)(9686003)(83380400001)(53546011)(2906002)(6506007)(316002)(8676002)(16526019)(5660300002)(186003)(966005)(86362001)(66556008)(7696005)(478600001)(66946007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?KjlImPgAvYKaSRUBOySMID6IeSwJMT+S7NgNte07p5HDtLQsPgGR9vPDKVef?=
 =?us-ascii?Q?Ekp3GQ+Aukl7RbESRjIdFVKWkjScbAiRdCRjovWyv7XZtRptUro/EEXU8OPl?=
 =?us-ascii?Q?e9GgJPl2k3ZOnmkqApn4LP4ppZR/E1V4OmNxB85YeGi3hW89zOp0H2NAIkey?=
 =?us-ascii?Q?91EsQbSsJ6rie+H1Ie/nIjxa1EwPHcSM15WCO0JYczdNZVpvhylvu24SCNxl?=
 =?us-ascii?Q?ktwLWOJxYczpziGxd2pQl7OG5nVlw2eF9PP+aC26uyxfT4SekKi1LyKXepkf?=
 =?us-ascii?Q?Phz323bwQ7pdR3u7a0r4Mnl0C8pZPf94E/72sFFaxIDjzpAkpuqo5IOlllfl?=
 =?us-ascii?Q?9lmndMbkxsG/Cqc5rXIJPcI4cyzkawRQJ1QfmS3FDtxLPWyXBsgbGZp4y1Xw?=
 =?us-ascii?Q?clYP+9DW/uT1JS5I8yomxN+TgOPVEZk4Ln8DHAXhBWdqVUjbe+jdE6005vlS?=
 =?us-ascii?Q?2aESOq8zt2NIS++chrhY/DGyagxdLkfrRrXMFZy0/2zD65VGHYbh4apwAixr?=
 =?us-ascii?Q?RStxX+Z5/I9REuhgXRfapNUJ0Wx2Htuu4kfvskJRoUpM6YFIM0U0NeZ0ic9V?=
 =?us-ascii?Q?eSVxjITWX3IPas8INx2Zaz1bcWCTEPCHSj78Eldn14gqzHMp5p/nW3VZv0ig?=
 =?us-ascii?Q?/lEXhIV2zWePWBECa5AOUFqaCr9S8xhLsksBW9FYpZVjWE6aw5ZwmMc6xYOE?=
 =?us-ascii?Q?jCMnEBDtdd46MCkd6BoKSV0ovrRFUMpjhc8JmjyMm6VD143oAjrZ+CRcdq0M?=
 =?us-ascii?Q?fC7krYUkddClxm0U4Llw460EZVOaRjQ18Z8LQLoKoXh55CSsrqnBHJTmKM+P?=
 =?us-ascii?Q?SER5LEbJ4aomD7MV2CwTdjias1mHy3eguPCvOUwzKxIUJ72vO6+k13xV3mz8?=
 =?us-ascii?Q?gKwglg796wb9Fcd3hZNvlHSkgqutXIupaf88fZcukZiJXWrmm1DV/BaOCQ+7?=
 =?us-ascii?Q?+TnS5kyxY5MfLE2WQGLde5CPvxv5guA0ZGQBvspg/7ISdtuhyNKs0wZAF9eq?=
 =?us-ascii?Q?HVmpX/PaKq/ONFNdfQU2Skw92/Odox3HdEwqUHkUdANWirzm8guwJ6rsigRI?=
 =?us-ascii?Q?8MOYBN2harNdCfoQC+TQoDvotGG93bwFb3/ehMOFJpmO6HFxbqQZezAqFSjI?=
 =?us-ascii?Q?gMUbVZGyULWRDdM9m8wasmiF1OvWu40JSbRnheS/sHX/64Zpv/2yNuVe3yqq?=
 =?us-ascii?Q?vUIZ/zzLnW9dGo9rzAr2zjpJUDbcetCpoPXsIRgjQskBQcqTS3lkFwZxiQ4p?=
 =?us-ascii?Q?1UVr3HW5HZVY/HugNjFdjfScWrx0W0iwl3iWz3xzro7SAq7knXBXLlOCktxk?=
 =?us-ascii?Q?u06wF5GzoqosLhKqjLvQP6DvsLin92WukSXXgqLbC7mcdw=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 4535d4e7-fd70-43da-6c73-08d8d512923e
X-MS-Exchange-CrossTenant-AuthSource: BYAPR15MB4136.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Feb 2021 20:11:41.4846
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 6ZCMUXsr6r9+yDODbin8AO7abStDc9+TsEBA3uKlUcTB0JfuFdtrfFA90PBaAwR6
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2983
X-OriginatorOrg: fb.com
X-Proofpoint-UnRewURL: 2 URL's were un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.761
 definitions=2021-02-19_08:2021-02-18,2021-02-19 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 lowpriorityscore=0
 priorityscore=1501 clxscore=1015 phishscore=0 adultscore=0 impostorscore=0
 spamscore=0 suspectscore=0 mlxscore=0 malwarescore=0 bulkscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102190161
X-FB-Internal: deliver
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

On Fri, Feb 19, 2021 at 12:04:32PM -0800, Mike Kravetz wrote:
> On 2/19/21 11:47 AM, Roman Gushchin wrote:
> > On Fri, Feb 19, 2021 at 10:37:17AM -0800, Andrew Morton wrote:
> >>
> >> The patch titled
> >>      Subject: mm/hugetlb: suppress wrong warning info when alloc gigantic page
> >> has been added to the -mm tree.  Its filename is
> >>      mm-hugetlb-suppress-wrong-warning-info-when-alloc-gigantic-page.patch
> >>
> >> This patch should soon appear at
> >>     https://ozlabs.org/~akpm/mmots/broken-out/mm-hugetlb-suppress-wrong-warning-info-when-alloc-gigantic-page.patch  
> >> and later at
> >>     https://ozlabs.org/~akpm/mmotm/broken-out/mm-hugetlb-suppress-wrong-warning-info-when-alloc-gigantic-page.patch  
> >>
> >> Before you just go and hit "reply", please:
> >>    a) Consider who else should be cc'ed
> >>    b) Prefer to cc a suitable mailing list as well
> >>    c) Ideally: find the original patch on the mailing list and do a
> >>       reply-to-all to that, adding suitable additional cc's
> >>
> >> *** Remember to use Documentation/process/submit-checklist.rst when testing your code ***
> >>
> >> The -mm tree is included into linux-next and is updated
> >> there every 3-4 working days
> >>
> >> ------------------------------------------------------
> >> From: Chen Wandun <chenwandun@huawei.com>
> >> Subject: mm/hugetlb: suppress wrong warning info when alloc gigantic page
> >>
> >> If hugetlb_cma is enabled, it will skip boot time allocation when
> >> allocating gigantic page, that doesn't means allocation failure, so
> >> suppress this warning info.
> >>
> >> Link: https://lkml.kernel.org/r/20210219123909.13130-1-chenwandun@huawei.com
> >> Fixes: cf11e85fc08c ("mm: hugetlb: optionally allocate gigantic hugepages using cma")
> >> Signed-off-by: Chen Wandun <chenwandun@huawei.com>
> >> Cc: Roman Gushchin <guro@fb.com>
> >> Cc: Mike Kravetz <mike.kravetz@oracle.com>
> >> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> > 
> > Acked-by: Roman Gushchin <guro@fb.com>
> > 
> > Thank!s
> 
> 
> Roman, I was under the impression that this warning provided some value?
> 
> It will only be logged if user asks for both preallocation and cma reservation
> on the command line.  In this case, we ignore the parameter requesting
> preallocation.  It seems reasonable that we log a warning if dropping a
> user requested parameter.

There are two warnings:
"HugeTLB: hugetlb_cma is enabled, skip boot time allocation\n" and
"HugeTLB: allocating %lu of page size %s failed.  Only allocated %lu hugepages.\n"

The point of this patch is to skip printing the second one if the first one is printed.
It makes sense to me.

Thanks!
