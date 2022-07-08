Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 93F9AC43334
	for <mm-commits@archiver.kernel.org>; Fri,  8 Jul 2022 07:41:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237233AbiGHHlp (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 8 Jul 2022 03:41:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50446 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237232AbiGHHlp (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 8 Jul 2022 03:41:45 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 812CA7D1C1
        for <mm-commits@vger.kernel.org>; Fri,  8 Jul 2022 00:41:44 -0700 (PDT)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 2687DNRV015405;
        Fri, 8 Jul 2022 07:41:26 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : content-type : in-reply-to :
 mime-version; s=corp-2021-07-09;
 bh=m8a0R3hcDVI5F7cqqlBGov/hi3jyhMwPrP5OhxoLVI4=;
 b=AosfK58WI5dYnlVOA5dVhYnorf6tYRJYVHxVlpk5va8sV2Ln8vn3NYvUYCTbkrXQMi2p
 /LF1vmWz0PiKls+ulxcGA7680gwX3XMMDcRhK0Gk/2e9pU04IiB2ATvti5CV8CjJJW7g
 wmfS43e795Uu9kCW6uvmjOffcFLkFRBn/xPuxHEbbdn6UpActtU9jKDrrXvhpZljNrrm
 9UYaRvWjwI8yKl+JhfeA0q/6G/ikOe+DWDfnVNGbkT4TT5RRD6UXA+CgkNLbQ5NRE3zN
 u7cmB08KMyvdPT4uCTjYooWY44tX7VLSRtx0O0OQlxr7Yu1bk7io1ikBoq0qN7ddn+Zw PQ== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3h4ubyy5t4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 08 Jul 2022 07:41:26 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 2687fKtJ023193;
        Fri, 8 Jul 2022 07:41:25 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2108.outbound.protection.outlook.com [104.47.58.108])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com with ESMTP id 3h4ud6h6tb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 08 Jul 2022 07:41:25 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=i/czDqwOktw8kpl+HYWjS2DjfPHSRNVoGmbEoFPnRVgCIGSEusxLzYz4Th3k96U3uj6F8B3PScHs8m+sXdFPWTo+Mt7uIW75GG0PU6ygPUR+iwQOdHEt2yERP0B6o5hXxij3fd83iZpJqIOaM2qAo3F62Ped/yWbff1IgvAget0QQ4TZAdnMsBhYUG0qRz84/Tm+c9796CHEBTt+vcivVeK00mqPvA4YO6Z0wjA+g3QXJ17cNP8opwDDpPTVMCk6XmQUosp2mSbjhmTuidgNhWxR48zp+jNgrawGSO52w3BBUmbAS/Dk6kuOSohmxzWs9RC/lFCUYBlWKCO+sYSuNA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=m8a0R3hcDVI5F7cqqlBGov/hi3jyhMwPrP5OhxoLVI4=;
 b=U55BxmsJhe2XPfRUf34inUgNhPFRY0kqODVpu5cfKjNNaeEf3iLzbZQosVIv46+G4Ca1nXLoW6RPzJHrjrwjAg4Ac3OxZmuoz1QUPn8sL3M/uxoxZ5+KcfLDp5o4zih+cHRI6f1pAfX076uCQBtpE1McMvmjJ5tfvntZxcGee+nKHzV9o0jeujcV/s9jjMml6jWuX8QYSll1lDhJuGtAA4VD1MGWRQfaOhINjzghywR/2KFtBk84HsU+QySPwGVuHLIpnbLflR6Qw+kjE4pX/KWdj20666zfmCUkLJN5GR1HC9N203ayFhDxB4uiVCCSqBcxSGys3hyzT4rsLNSHVA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=m8a0R3hcDVI5F7cqqlBGov/hi3jyhMwPrP5OhxoLVI4=;
 b=C+b2w1rfLzjscqloz8pjcXc2/cl2eCteY/OXtE+aUFBNFRS3St8oqcCkkYJErnlVkcioR69D/yx43OyjXMzJk//9tycZU3M9VngCTFw+uRQZ2un3HKA6Ek3gYyOuyveE6HNwSOmqastLFY8DBifRhTqNJIG75W7ZDfT4fDvElu4=
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 (2603:10b6:301:2d::28) by BN6PR10MB1748.namprd10.prod.outlook.com
 (2603:10b6:405:9::16) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5417.16; Fri, 8 Jul
 2022 07:41:20 +0000
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::5020:9b82:5917:40b]) by MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::5020:9b82:5917:40b%6]) with mapi id 15.20.5417.016; Fri, 8 Jul 2022
 07:41:20 +0000
Date:   Fri, 8 Jul 2022 10:41:06 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Vlastimil Babka <vbabka@suse.cz>
Cc:     Yu Zhao <yuzhao@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        mm-commits@vger.kernel.org,
        Nicolas Saenz Julienne <nsaenzju@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Minchan Kim <minchan@kernel.org>,
        Michal Hocko <mhocko@kernel.org>,
        Mel Gorman <mgorman@techsingularity.net>,
        kernel test robot <lkp@intel.com>,
        Hugh Dickins <hughd@google.com>
Subject: Re: + mm-page_alloc-protect-pcp-lists-with-a-spinlock-fix.patch
 added to mm-unstable branch
Message-ID: <20220708074106.GI2316@kadam>
References: <20220707200919.90C41C3411E@smtp.kernel.org>
 <fc7101bb-b9b9-4444-1d8b-4a28ce13f333@suse.cz>
 <CAOUHufZEwtvOhKQZqBp7Lg41eC9tK7hyL_UOUb2RdLKva8U02g@mail.gmail.com>
 <44ae6dd9-c290-ae4a-15e8-593a9cb587ad@suse.cz>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <44ae6dd9-c290-ae4a-15e8-593a9cb587ad@suse.cz>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-ClientProxiedBy: MR1P264CA0115.FRAP264.PROD.OUTLOOK.COM
 (2603:10a6:501:50::33) To MWHPR1001MB2365.namprd10.prod.outlook.com
 (2603:10b6:301:2d::28)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 688b5953-317d-4d64-5e61-08da60b53ff6
X-MS-TrafficTypeDiagnostic: BN6PR10MB1748:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: zxD635R6mDuEfUzv9Rip+johCJkyt4Hk4/v4nTNd63FGZsZzK0xj+4Rf5brpYVM1EnTQb1eHwzLntGp027QMivC3CGKzPHHFHeNxHiWrpf1ICu20qgXTa/K/bXXp5D4WiWlWkWBuKvuCqxhQ73XZ+5mZpxit11jyvDbBBHk0jRdilKLTmwUhespeQjir9W34TuHUK8PvtSkifLDKWg7H5hajmUgl8wqS+cXEpNFLufZtKFAjRnyENrCEtqCgKOiaBCtGYCr/Y1n83JuSMrJk6K6mvu3yLPVraSSlcC02VwkuZSqEcVcD08LCibKXGQ+k5TXJNNSrUacx+0KfPfI1b1Xkm2ieN0Eo/8q7nMxZM5b4BWSizZDIbm5NGwB3cx8NyT0aRAWgff4K6S70Z8sdZU62px7i45B97TpnE2P+K1Zenpx4zVcwkTb98HDNKM1YYlCPudz9lz678rSZK5iMnesN6bPXIczfvierA7mDFeOibtI+xdhBpO1D4wuFp9sR9g8gEeJRH5vo2f7Dp+vLb+8QDW5ZRclvUnqEuAq1QDt1f0EvyHAnuKdkAWtiV3AcoSluSdAAtw+E5apEl0a0d5+AKj+8MkFvRFYabEisPs+XrZDZE8lfFml0ztak8cUaWJbIf7zHbJtyjTqUUn290rsZdZOlsw7lB4Vp/gf4mOLIWTNBwuxTqs9gFawwqfiCn0uGXn91rMDD9M3IoVPZWSFDEci5lMvg9Co1ZHNBSlKwioXI5airTYhsNCIXqSsgMHtChKBwvg8VtWGFhSRE6dAhhr4L867u8ft9HGyAhf9RfA4wOhd0uLel3cTnODAR/4z7W5j5+i2u5GyIcRTBqQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2365.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(7916004)(376002)(366004)(136003)(396003)(346002)(39860400002)(44832011)(8936002)(6666004)(9686003)(6512007)(5660300002)(38350700002)(38100700002)(52116002)(41300700001)(6486002)(6506007)(966005)(7416002)(26005)(478600001)(2906002)(8676002)(54906003)(86362001)(83380400001)(33656002)(316002)(186003)(6916009)(33716001)(4326008)(66476007)(66946007)(1076003)(66556008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?sZ+LRCY3rmyLIVuOlnqpBWp8GHVxbpQeZSILpWHmU+z/j/EttLjDZzJtpJMv?=
 =?us-ascii?Q?ciHoi3k8hCiaUDp2bBAVTb32ZFv4h+s/IDe5KInn4pVuHG0DNDY24CT/bHZK?=
 =?us-ascii?Q?CIEc4W/oViXtsAYVqIbA2YsOBxM9XB2hqEpHUHBIoDQhSIgcVoEBG3CWUhuo?=
 =?us-ascii?Q?uBjimq9VJ0NhKiYf4QV3JwCzn/IDL6cD02293rzP8/JNQcxpnZuuvMU1zAu3?=
 =?us-ascii?Q?3UjklMMK6lBw9zvGcJ1zDA3xzag3foqR0k4buflY2mNTGmQTeHHi89BToWIt?=
 =?us-ascii?Q?H44tAj/3nKzN39+6gvutxcx4w3JiehLrCO7Hj5fC0VAW4GlTIsb4Jz7qPJEp?=
 =?us-ascii?Q?Y+xMu9dDiBsNrp1LBMMQPIV64Y6bF3otvA0o4wMuP12b/N/+YD6sfI7f1MRk?=
 =?us-ascii?Q?j4s15c1WLUoLR9YdBgBg42B6bFpuN8ZdNwwCDhuvWb91jbTtPQqqZouTKXSR?=
 =?us-ascii?Q?xd8nc+qRwlFhP2HBXTZZBO3Gi9NQbQXagBlKvaUilMvRFKLgsmgk85+45hFC?=
 =?us-ascii?Q?E8SmSYctQmdlIvrilB8sriFqefQ0Q9hXBjRZnHxaOa2tuehZhXiXh+xXUsEa?=
 =?us-ascii?Q?7uTOnVygAEXIwHTdkKpd6pkvw/SmqCA1LRaLJZJWqBzdLw9Oo+Ltb1NE/4Pq?=
 =?us-ascii?Q?z3ERBHACEXADfefcbg88tLuSkpxtV+h/IxJiuFDFc5bxruXhOsw4uuM2Jwh8?=
 =?us-ascii?Q?7ZqRZTKCeTZXjDpqCU0k9IRMay/cZwbB3tdWve9MwcilhIZ9adw/36Ssnjyb?=
 =?us-ascii?Q?uEqxW/2CP1PMeZafUl77aS0YA84xm+e5g3q0bcftXTOKtuqhn4O05S4X5VqY?=
 =?us-ascii?Q?CtBc0ndtWfCUMxd5/uCsrAIGoPG5jovdPAlJ7+JJnBhEjNW3e27hp4bkXVZo?=
 =?us-ascii?Q?QgLHUNIu2afT087iIMCoxk8oq9SxtAbiVAafNaa5YubY/a/6OhKymyYxD9md?=
 =?us-ascii?Q?Rxj6Z1GBMRzTc102ckWxp8ym+Hg0lUPQXZzu/7ynjO1X1YixBISS3o7wf/Vp?=
 =?us-ascii?Q?7iozfrrghcHhhd+6vl3RrLvatbbLheP9wmdLG9Zg4DM8tlWTsd1mqi72IPj1?=
 =?us-ascii?Q?jP/kLTZh9ftQY2P/BmoOtPIBILX15VyM6IupEDNdCwtG/1gmvziM4r2Vp+gV?=
 =?us-ascii?Q?J4d3EARwaEy+olAmUZTdP26bJpZ/jeTobL85xDY0HgWrh09Ur12/lOH4L9BM?=
 =?us-ascii?Q?f3jf/KW4l1P7ygK8gadrWF9U2gAZqcj2s35TLpuxZ09aLXNBHmli0lOgD3ok?=
 =?us-ascii?Q?5jySEpkUR3ikbvTmZO57TsfnHIP8LXzaKrief0QYIeGqind41RlmRdg1U6Bd?=
 =?us-ascii?Q?jihUR8XHykO90wI1tT8fOuTGNufr8asqNwKZ3aRD0hbtxqL00Mx5mnQKELaa?=
 =?us-ascii?Q?BjfSalEbn9vcviCA1M8BcQaqLsoCmOXs2GytlpwO1C0z69W8S0TXMFFFiyBr?=
 =?us-ascii?Q?Z7lx5Emf3Qv4pZJ/GqQnbBIxlG5SCWTgxcm001sbhqghWf5T0PVbRKNM9uIv?=
 =?us-ascii?Q?Ammabjkjhlie/AM4exPLv/bmeNmmCY5LVOdo3Proa2z2pn66MkUMtnmdYUBc?=
 =?us-ascii?Q?sMIZB4ID9wvfKZxEEGJQKUXHGXk4mXuDKdMcBxkj?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 688b5953-317d-4d64-5e61-08da60b53ff6
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2365.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Jul 2022 07:41:20.6835
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: yXeruvps4XjMduX8x1hLhc97m72M3EGhl7qwOCtnifU2ILe0cJTejpjzGN25xXlTT0ZDcU51DnK8JHf3WS4WgA9RuJR8yEg8tgbhOOMrOls=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR10MB1748
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.517,18.0.883
 definitions=2022-07-08_06:2022-06-28,2022-07-08 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 suspectscore=0 spamscore=0
 mlxlogscore=999 phishscore=0 malwarescore=0 mlxscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2206140000
 definitions=main-2207080028
X-Proofpoint-ORIG-GUID: JfseZnEbicvE8nLxFOPREFd8qY0w22_5
X-Proofpoint-GUID: JfseZnEbicvE8nLxFOPREFd8qY0w22_5
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

On Fri, Jul 08, 2022 at 12:21:45AM +0200, Vlastimil Babka wrote:
> >> > ------------------------------------------------------
> >> > From: Andrew Morton <akpm@linux-foundation.org>
> >> > Subject: mm-page_alloc-protect-pcp-lists-with-a-spinlock-fix
> >> > Date: Thu Jul  7 01:06:35 PM PDT 2022
> >> >
> >> > add missing local_unlock_irqrestore() on contention path
> >>
> >> Doh, that's true and something to fix, although patch 7 did remove the bug
> >> later in the same series so that wouldn't explain the lkp report for patch
> >> 7. The reason lkp test robot complained was AFAICS that it was testing v4,
> >> as I just replied there.
> > 
> > Sorry I didn't bother to reply until now: it did test v5, at this
> > commit, not the whole series.
> 
> I meant this report that appears to be for v4 (full series including patch 7):
> https://lore.kernel.org/all/YsFk%2FqU+QtWun04h@xsang-OptiPlex-9020/ 
> That reported a bug due to missing unpin that was previously reported for v4
> and fixed in v5.
> 
> I'm not aware of a lkp report for v5 (found only Dan's) but yeah, hitting
> the (similar but not identical) bug fixed by this -fix would indeed be
> possible in v5 if patch 7 was not applied.

My report is the LKP report?

Some of the Smatch warnings from LKP get sent to me and then I look them
over and either delete them or hit forward.  I don't have visibility
into the LKP process more than just looking over the warnings so I can't
say how it picks which patches to test off the mailing list.

regards,
dan carpenter
