Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8A662C433E0
	for <mm-commits@archiver.kernel.org>; Fri, 19 Feb 2021 19:48:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4168564EAF
	for <mm-commits@archiver.kernel.org>; Fri, 19 Feb 2021 19:48:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229819AbhBSTsz (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 19 Feb 2021 14:48:55 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:63998 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230074AbhBSTsw (ORCPT
        <rfc822;mm-commits@vger.kernel.org>);
        Fri, 19 Feb 2021 14:48:52 -0500
Received: from pps.filterd (m0109331.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 11JJiChv015474;
        Fri, 19 Feb 2021 11:47:32 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=Fxy/eGa1RkPlGJvpFq9YW8s51Nkf2UJCcLY6UOloki0=;
 b=n8d8lcbsg/8OAUr708NrGVuT6E0oBoi1wDUE7QA+zmUCmxQistLlqEe6EGuDAAR8r/Yo
 WYzMzXjbHuOvP0X4GpdQmc8aNWGxEbI5vXUX3+Yib92UCzMRBnSyra7endHqwqk37DC8
 ooIgU4JB9wbWkjqL79ONLlBkCJEdIVLogBY= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 36tbkjar0r-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Fri, 19 Feb 2021 11:47:32 -0800
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.36.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Fri, 19 Feb 2021 11:47:31 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=f5ppe0tznRgpp9HAM0MDHQeHi6AFHaj41kA8zDJJLLrsagt5isocM3c9hknGeAtzqTJqco17UElfbPEIy2/3jn13q7cuLnBdwQYYZ1hwd8ygUuU3Q1su+9XBnjLN5ffrmBTNg8OTv4dn2Dnul38oMNlStJo5rB0syWHUqKoCiQb7evapv6ccPsEZoywK18iZfQoV6S8uBH3F/0oPSj5vTGSvKX+W8Z811aiWdQ7WSxn6Y2ryc6Set28049dAbySfa8uqHgvhv6UXcOdEo781VKrcw6gu3uLrLHf4zzoEiaww6yAV3KmgOOw6aQP6aKxhLG3hdL4whNpdkBpaLX7EDA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pCmdJRH2u2gWjgc2kRr29JN6Lhx0V711m0/4Jv59GLw=;
 b=YHplrsuMfNVXpp9Sc2eRLvsevspBwU5IZRtAD/p8xYU3J67/MY2sJ/gr/IJVOPUfSyfMSpHWVDDqxu+DdwQkTe9AeFgQlyAETvLucKypAIUQRteyROIen1YkA3mCcqXKUJ1C3V1MAzPcHMZSflggr0wy2ZstK8/Kszc3LYp83PBpGnQP8dx64kGeTCceE9oEHv63I87MMkivOnJ//J5hnytE94dosoHpGbuWQ65fsW5rR7iBz9Tkahe1tEdrrrHT55q7ZeA+rJxLqHNtbs/m495fr4y7yTQ/ENIHvuzrKZGyOudBuBX2PS8yPA53P0HeKWtnLAQNq32FjdurokMygg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Authentication-Results: linux-foundation.org; dkim=none (message not signed)
 header.d=none;linux-foundation.org; dmarc=none action=none
 header.from=fb.com;
Received: from BYAPR15MB4136.namprd15.prod.outlook.com (2603:10b6:a03:96::24)
 by BYAPR15MB2759.namprd15.prod.outlook.com (2603:10b6:a03:151::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3846.34; Fri, 19 Feb
 2021 19:47:30 +0000
Received: from BYAPR15MB4136.namprd15.prod.outlook.com
 ([fe80::53a:b2c3:8b03:12d1]) by BYAPR15MB4136.namprd15.prod.outlook.com
 ([fe80::53a:b2c3:8b03:12d1%7]) with mapi id 15.20.3846.043; Fri, 19 Feb 2021
 19:47:29 +0000
Date:   Fri, 19 Feb 2021 11:47:25 -0800
From:   Roman Gushchin <guro@fb.com>
To:     <akpm@linux-foundation.org>
CC:     <mm-commits@vger.kernel.org>, <mike.kravetz@oracle.com>,
        <chenwandun@huawei.com>
Subject: Re: +
 mm-hugetlb-suppress-wrong-warning-info-when-alloc-gigantic-page.patch added
 to -mm tree
Message-ID: <YDAVzRNTpFTXGR93@carbon.dhcp.thefacebook.com>
References: <20210219183717.02Po6%akpm@linux-foundation.org>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20210219183717.02Po6%akpm@linux-foundation.org>
X-Originating-IP: [2620:10d:c090:400::5:dfaf]
X-ClientProxiedBy: MWHPR14CA0049.namprd14.prod.outlook.com
 (2603:10b6:300:81::11) To BYAPR15MB4136.namprd15.prod.outlook.com
 (2603:10b6:a03:96::24)
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from carbon.dhcp.thefacebook.com (2620:10d:c090:400::5:dfaf) by MWHPR14CA0049.namprd14.prod.outlook.com (2603:10b6:300:81::11) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3868.28 via Frontend Transport; Fri, 19 Feb 2021 19:47:29 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 3169d095-38e2-499a-78ea-08d8d50f3107
X-MS-TrafficTypeDiagnostic: BYAPR15MB2759:
X-Microsoft-Antispam-PRVS: <BYAPR15MB27594D5510AF4E76A26854B5BE849@BYAPR15MB2759.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:107;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: sJsrhkSLh2IN3/u+HXCWVd1oEfE4ypgQ9c5saMTgBtMoKLc+k7wp9biZMgJ8QtK7GKJail0iu3OOj3cCGePcBb56KfiCREgaFRXRAAF6QnLctFlwEwAUNu6n5swEAM2y5ZXvnOlJef2gPOk43w/p2BMGUMXpz/AFTuEH8JGNNLLm6CD2S3Nixsv0coZMEY6NHZveAMwScdJ3IG4v4T23TVyx+lyXtoxROfGdPw6/D8sTTeCk/4YXsU7gxyYyrmPqkobcWdv1B1DTuBcNVjGkm9T9tnTHP1Us/QcOdJUrlZtll6tOan3J3xg/R9Gr8kfOVESR4i3yKDy6U47CrNMYb1XVbHFzyBPDDpALIA+CXKHaF1Un/xqaJ6MjDi1lJbYu2kBzH//nZC5TFktr1SY3l71mIvTs9NT7p3etUeK1OmtZPh8QGSNwYVrGmiNN/UoXR4ae7rTDq8TGp8WSvjokhFsDAVEw2G47R5f6GHmHEXMvAyCJ2kXfbtC3u06+yVP5DnpH1IKfvgwblD4TXXGs9QSsrTVxfabFtAVoS1CJ/dYKFrS5ma3n9vNFuAARGfl7gPj8DT8C+Hst5UeQDIDzJw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB4136.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(366004)(346002)(376002)(136003)(39860400002)(55016002)(7696005)(6916009)(8936002)(16526019)(8676002)(186003)(9686003)(478600001)(52116002)(66556008)(66476007)(66946007)(6666004)(83380400001)(5660300002)(6506007)(316002)(2906002)(86362001)(4326008)(966005);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?rEM0VRK1ryk+9qSJiffzSZ+aM4fY9LE2GnrDWld9vw2kYdv5zV0E1X2UyBNV?=
 =?us-ascii?Q?pgF97KUJvjzVS5Sylr7anuePvxHl0wdLpKSJWCADJGgXQoNbFWsmgCw2XA0H?=
 =?us-ascii?Q?TP5ZAVgK/LyPpyEiEWNNAghOj+xXRxIUc/58VFDGJNPAkE6Y0oYUxrH4JSNa?=
 =?us-ascii?Q?tgeJ3S8W3B7p73tfWo0zyruHgpkzfPq8y1UvObvKdXkdPjlllvHdSFkwyXby?=
 =?us-ascii?Q?QCfp2n+2pBjVJclB8yH/gX0mp/+7opgn4XqbuFkvUFBVlATDI4v+J1zapSq0?=
 =?us-ascii?Q?PPS6/g2bxT+pFCh6aUPX3t+TsI3lrw7mPrxKVPJN1/RlSKVAFZJUM9OR7bO3?=
 =?us-ascii?Q?Ay1Txtin9F0l76LDBHHYVbKA0VQEZwY/s7kq4t+4PmQZxILnbUtH4zSUv/VM?=
 =?us-ascii?Q?fWIIWm++MEBz51uO0bGf+/6gF2pwS6LzU3ySG3NAMGZe1rH+GXsFl9ER5e/y?=
 =?us-ascii?Q?kC2a9yavepZnikTFkFKzkkExPrBLq89g38JBML5mv3vdRaJLpPYGWXBUwk5H?=
 =?us-ascii?Q?b++5Q+q0IN0m21+kAL4PwaXJsRuAX5/toU99ATddO3QeCK1x4a92oFbXuBz8?=
 =?us-ascii?Q?pbShkeQBh7hvdcCXJ+Ze34rJxRZeDkbEYhs7JovUhJQYvJuHmVA7004GqehN?=
 =?us-ascii?Q?WfSMnZq0zpttbkavTrQJju+uQACeJwaxJWpEVL5VnN6ZimomC6Vtpydtklm+?=
 =?us-ascii?Q?+yxP8RaWZGjenHAegHCFL7bJXGBrfYQQDHfxkbRmYtvEbORjrlHdRSkiagR0?=
 =?us-ascii?Q?R4qmkLUDZvgESz464bc/pFEq6Q5ZwSOBoSjax5SimqOfiaLPTL2/oeAdcAw1?=
 =?us-ascii?Q?gc+t/INMDAu1QH0D76srPslkTYPs4va32062Cks8H6Vd2Ix+mWkVWjXPXN0N?=
 =?us-ascii?Q?1XAOE1zUR232ZvVZyCH1McUkcibJjh1JVXCOFOmbAN2Uugb0JpM7cywGAl3W?=
 =?us-ascii?Q?byLJXUdrQFt3621yCKV2LwHL4zQ8bvqLhYz7qT0CH6Qmzj0gSCjspGGQYgl0?=
 =?us-ascii?Q?QIZPZWjNq34GAZMtQ/1OrytcS2J8bEVoOG4sWhhx2YscEBoQaEcS6e/Nnxb/?=
 =?us-ascii?Q?d4PP+/xe4eTTN9T5UdGhHRud2hLHGopHAJ8ozK7B6UYGKz5A+iOMAs00Hctm?=
 =?us-ascii?Q?0YykGD0/ZOc3oXCZNTezuBCj25lNE07Q8oBaI82gZNS5gQMHu9MHsPbRFFq4?=
 =?us-ascii?Q?TxjbWI6S7bHHrFKNi0JwId1sATw4fwnNE3bL2qTNwo5QMZxHB468hqE6aPKh?=
 =?us-ascii?Q?LWLo6XIdNFHgGe9y0OoL9QVXxcnBXlMTWiupGfxtYrlL42hb6z082oOXNnST?=
 =?us-ascii?Q?H2e9T4jZXisltr++CZgdAl/eup60WiSUYKscq7+J7hQfkw=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 3169d095-38e2-499a-78ea-08d8d50f3107
X-MS-Exchange-CrossTenant-AuthSource: BYAPR15MB4136.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Feb 2021 19:47:29.8892
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: hqYEFA+ms9nCcMNK14R85b9afMLdag23y3er8qt23ZvnWRvm7JznBmDnBzaanByp
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2759
X-OriginatorOrg: fb.com
X-Proofpoint-UnRewURL: 2 URL's were un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.761
 definitions=2021-02-19_08:2021-02-18,2021-02-19 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 suspectscore=0
 adultscore=0 phishscore=0 spamscore=0 mlxscore=0 bulkscore=0
 mlxlogscore=999 malwarescore=0 impostorscore=0 clxscore=1011
 priorityscore=1501 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2009150000 definitions=main-2102190156
X-FB-Internal: deliver
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

On Fri, Feb 19, 2021 at 10:37:17AM -0800, Andrew Morton wrote:
> 
> The patch titled
>      Subject: mm/hugetlb: suppress wrong warning info when alloc gigantic page
> has been added to the -mm tree.  Its filename is
>      mm-hugetlb-suppress-wrong-warning-info-when-alloc-gigantic-page.patch
> 
> This patch should soon appear at
>     https://ozlabs.org/~akpm/mmots/broken-out/mm-hugetlb-suppress-wrong-warning-info-when-alloc-gigantic-page.patch 
> and later at
>     https://ozlabs.org/~akpm/mmotm/broken-out/mm-hugetlb-suppress-wrong-warning-info-when-alloc-gigantic-page.patch 
> 
> Before you just go and hit "reply", please:
>    a) Consider who else should be cc'ed
>    b) Prefer to cc a suitable mailing list as well
>    c) Ideally: find the original patch on the mailing list and do a
>       reply-to-all to that, adding suitable additional cc's
> 
> *** Remember to use Documentation/process/submit-checklist.rst when testing your code ***
> 
> The -mm tree is included into linux-next and is updated
> there every 3-4 working days
> 
> ------------------------------------------------------
> From: Chen Wandun <chenwandun@huawei.com>
> Subject: mm/hugetlb: suppress wrong warning info when alloc gigantic page
> 
> If hugetlb_cma is enabled, it will skip boot time allocation when
> allocating gigantic page, that doesn't means allocation failure, so
> suppress this warning info.
> 
> Link: https://lkml.kernel.org/r/20210219123909.13130-1-chenwandun@huawei.com
> Fixes: cf11e85fc08c ("mm: hugetlb: optionally allocate gigantic hugepages using cma")
> Signed-off-by: Chen Wandun <chenwandun@huawei.com>
> Cc: Roman Gushchin <guro@fb.com>
> Cc: Mike Kravetz <mike.kravetz@oracle.com>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>

Acked-by: Roman Gushchin <guro@fb.com>

Thanks!
