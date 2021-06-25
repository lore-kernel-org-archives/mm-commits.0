Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.2 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 462C9C2B9F4
	for <mm-commits@archiver.kernel.org>; Fri, 25 Jun 2021 21:34:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 11A4661949
	for <mm-commits@archiver.kernel.org>; Fri, 25 Jun 2021 21:34:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229776AbhFYVgw (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 25 Jun 2021 17:36:52 -0400
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:28108 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229531AbhFYVgv (ORCPT
        <rfc822;mm-commits@vger.kernel.org>);
        Fri, 25 Jun 2021 17:36:51 -0400
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 15PLRHY8016268;
        Fri, 25 Jun 2021 21:34:05 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=dTbdYoRfClNwP8Nn3X4JNM9yTTLw4c7acAmRAcS8/e0=;
 b=UReVR0KvYUu0gez4TlYpf7GayZ/gw7ITeJMs2FMkFvqiYW/9RxssAE1Hx9/DgUmAUtNy
 aS92sTHOKHwZmnJmb+8lr45+2pp+SWX/pLoK30kvPCm6jw5j9SrquBdR6uKbTVwJs6oZ
 3RiaS0WMT9SOSqQ7gAm/YrxQlWiC8+C6037AkUN8FMpsttEZw2sdwndaWjpvPFNwoLsf
 4wowGGIxC0x0/7Jg2u4H+fcN1YFpsu7aIWNlhxnRjU5ODUH/dGomQcbX4VpPybezFGEf
 E1mBv6g8vIn5pU6KHtfI/LIp4fkhJ3+8C3s+g9WBUlvO0h/CmuTK2p5LgQxyQnGkh68Z zQ== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by mx0b-00069f02.pphosted.com with ESMTP id 39d2aht70q-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 25 Jun 2021 21:34:04 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 15PLPSGY131677;
        Fri, 25 Jun 2021 21:34:03 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2168.outbound.protection.outlook.com [104.47.56.168])
        by userp3020.oracle.com with ESMTP id 39dbb222ba-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 25 Jun 2021 21:34:03 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=l9QkZI5enqN9aBVIkf2J/VyJ5eUGxw+yEbd/By6FgZwwNOe/HKuYniiqOr3GpIkZBfeTTA9IBNtf2cVHgMYvCptEEcyZpbxitTz9XU0YL3K4LMjm2sgnWuqsHmuDRq1vFbmjYsiM2mkJUhPIPkBGwyJXPbGA+n0V440rR9SEVuMnUut6pUoxtbt01zwNBTT1lVfnDS4xY3n460VBfGvhcuXOoJagCXbouRz5DfNtKP17mUa2JC6083YeabO0KsapQ1kIt7mkIHkosc1NzG13L905gF/4lea67LrttLgBm9QfFECagSfTmsid6x69YSYiswfjBFp4FOFsNkO3QsZh3Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dTbdYoRfClNwP8Nn3X4JNM9yTTLw4c7acAmRAcS8/e0=;
 b=TIOUuFT6+4BkYTSXI75U4DKeMJHz5WAYl0c/JHWUsXKZA1/4sFVBfRgUME2+cpL3Co6CxwIWCbvDABgDJG3Q623fI48NcSFeKAbf8hXnXan9WmaPehuBmOiMKoQtsBRNX0RV4EbH8B/Eju/H+z4zF82XcHBN7jRfLB2sJPwyVnx1RiTP5Kl7HFYZeolgNi5Zhehh4yN7FFL0x7E+UgTtP3fXHu03zoWO2YaE0Fd+TqPcW9cBTLdsmBa0kUxuMzUXP5UbDJlgZZUu8QReZWB4w2ckdhdXUy2+efUEu2HpYdByl1m3F1lTUzIXP1htgIMWzjKEY7QFujxNmV1OAkcsEg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dTbdYoRfClNwP8Nn3X4JNM9yTTLw4c7acAmRAcS8/e0=;
 b=oKdoHGABmx5qkbGQJKQV7CFHNx7RD3k0yRvSLK0F/O3+DI5mUvpH7RQZiZV2YJG387Y1angtgUIdRNp+b9XKMbrYmbLf7X2t7Gm/0Z9HqKafPLjibsTA4kWMaXZkyqwqgAosVcwkU4FfHDpQxdzQ4K+RC6zAM1P3EWueJS5yC44=
Authentication-Results: bytedance.com; dkim=none (message not signed)
 header.d=none;bytedance.com; dmarc=none action=none header.from=oracle.com;
Received: from BY5PR10MB4196.namprd10.prod.outlook.com (2603:10b6:a03:20d::23)
 by BYAPR10MB2901.namprd10.prod.outlook.com (2603:10b6:a03:83::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4242.23; Fri, 25 Jun
 2021 21:34:01 +0000
Received: from BY5PR10MB4196.namprd10.prod.outlook.com
 ([fe80::5d11:ae6d:24b6:e838]) by BY5PR10MB4196.namprd10.prod.outlook.com
 ([fe80::5d11:ae6d:24b6:e838%4]) with mapi id 15.20.4264.023; Fri, 25 Jun 2021
 21:34:01 +0000
Subject: Re: +
 hugetlb-address-ref-count-racing-in-prep_compound_gigantic_page.patch added
 to -mm tree
To:     akpm@linux-foundation.org, aarcange@redhat.com, jack@suse.cz,
        jannh@google.com, jhubbard@nvidia.com, kirill@shutemov.name,
        mhocko@kernel.org, mm-commits@vger.kernel.org, willy@infradead.org,
        youquan.song@intel.com, songmuchun@bytedance.com
References: <20210623044533.LOA76kURG%akpm@linux-foundation.org>
From:   Mike Kravetz <mike.kravetz@oracle.com>
Message-ID: <2c0c9f25-ab91-3fe0-fb60-f23f771a9f5d@oracle.com>
Date:   Fri, 25 Jun 2021 14:33:59 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.1
In-Reply-To: <20210623044533.LOA76kURG%akpm@linux-foundation.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [50.38.35.18]
X-ClientProxiedBy: MW4PR03CA0241.namprd03.prod.outlook.com
 (2603:10b6:303:b4::6) To BY5PR10MB4196.namprd10.prod.outlook.com
 (2603:10b6:a03:20d::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.2.112] (50.38.35.18) by MW4PR03CA0241.namprd03.prod.outlook.com (2603:10b6:303:b4::6) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4264.20 via Frontend Transport; Fri, 25 Jun 2021 21:34:00 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 9cc2f9ee-f0c1-4e11-02ff-08d93820f28e
X-MS-TrafficTypeDiagnostic: BYAPR10MB2901:
X-Microsoft-Antispam-PRVS: <BYAPR10MB29013409028023D3E24311A8E2069@BYAPR10MB2901.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: YraJvdhttahIKAjh3NFN+7hLJqMXLp9njqpZKJk9uZ0Fx/26gomDxTeM87aqsDArkzOR754vmVsytKGwBrWJAUiH7D9zAnAybkwz83EjlybKDwcDzRBVBrnswxUG0zOCe/zg0nP4B9rCMfLYRFOSqnWZ3CFWC6BiL72RNUA08B+5ko1zvsxIs8sKCc8ZAZdyWYWJgZrUR7EKcWQG3aVmFtCXQBbQWV8I8oQVjxows4vRAxDd7JNP6Fwrepn8Ufhe+hbNzoJLub1Bp0KoblozKhU7qdnZ+QpxcsfUnMF0ZLArvYpt8l5KWoOJloeZQTpmh3lBEWfr4ptMvhaqRcbgkcVw3gJagpuuy9gKJGTea5zYTS1XrF4ZOnRWgB5If3Pchpt/QuDO8XceUD0SByAogUyx985koixaDA3onbS6R0jusV5e8Lax596HJLCoKlDkJ1/ERBWqWWBIpyJ4vqIh4PH8b1YrZqgatjtT4Bz40QhFzPS93oDdjzqfzXcI31hBhLA/LWV4lplBWdkOwnYYkUfUW75ItoQ6C3pt274ZLXdEpXIGLxz9jlWdzNna5EYoHp3o6L0PzShArjUPUpt3i1g7gAzB/GFrL5IwxxvN3yrRMjfloVXMz+LhD51UcWUsVfnb1VOPRT3Ii1ku15AKVCCaZxomVjevxVRHwhX1Gx+WTpedCjV8Fnd63XhiIzItD5GXr2OxyZAoLra05g7eHCAxncHcUwn75rc6Rq8k9fHvmvZM84raIZz2YaGCjFC5Aog4/dY+V9G3hFuxehENekoHzS0zG96uTFIXourxMi8=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4196.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(39860400002)(396003)(366004)(376002)(346002)(66946007)(6486002)(38350700002)(7416002)(8676002)(86362001)(83380400001)(921005)(66556008)(66476007)(38100700002)(31686004)(8936002)(5660300002)(478600001)(2616005)(186003)(26005)(53546011)(16526019)(52116002)(16576012)(316002)(31696002)(4744005)(44832011)(36756003)(956004)(2906002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?LzlJRVVEdUFYbTdyYjhwNXByeWM4M09RYU0rWnQ1NWU5TmpjY2U0WUlBcUFo?=
 =?utf-8?B?U2FPaW80c1dEUVpod3dNZG1CcXZMaGttenFMM283OWFERU5OQ1BYRGpZWFNE?=
 =?utf-8?B?dWVMRUcxZzJjeTlXT0pTQ2xscm1XU0xTVHdSS0dhVVNaTnNQbFVEbmRoZ0tm?=
 =?utf-8?B?RjJ2aHYwbmtiNytwb0pMaGRCbVZRSkpZRHpoQW5nZk1tK2ZueU9aWjhta1U5?=
 =?utf-8?B?YTlQeWcvek9qUzVVRzcrbk1WWXZLWk9ueWt6TDlwZUxHNGVISm1tWG9oZmlK?=
 =?utf-8?B?c3oxUUlUUG5lZ3h5M1h3REtIUUJacG1vamNNN3gwVWJBYUQzSGJQL045QjRi?=
 =?utf-8?B?blRKL1Roc2FYQkFGRVFLYWxHZnR3dythVi9MdjJOY3Q1dHd0MVc5elVjQWxo?=
 =?utf-8?B?cWRwS2N3ZU1hVE9YWFZrbFp3Rlg4cWxXYnNGRVlqWE0wOGlvRmNHVFhxTlQ1?=
 =?utf-8?B?VDFCSys2UVVuQW1KcGtBbVRrUkszZVpjenpjOHVFSmVVRC9raVNGMkx6d1BE?=
 =?utf-8?B?blNTeFQwd1E0TU9kbWR0ZXRJUHN5ajBsTE9iSVphVkVUOEFUTTdBbEJrZ1Q4?=
 =?utf-8?B?bmVzZm9XZmt2UnFXTUZudDFYZGY2VnMySy96UmJRL0VLUGx1L0lndENxbTNh?=
 =?utf-8?B?cndNVHBUbGVVOUtJaTd1cGdzUlhqVUJkMm9GSUxoTmFQTWdMVjVaM2JXcmVY?=
 =?utf-8?B?VG5YZDJpWWRGQlBSV3BtTTd2SXlwVWFudFoyVkFrc3BtWTE3SlFEbW4rMnA3?=
 =?utf-8?B?VGt5aGRxVjhyWkxKdkNsR0lhcmRkbjVIbEd3MlVHd2tjTDFRelZtRjZQMFVR?=
 =?utf-8?B?T0RhKzBFZWxnWUloRmpWNWs4YmVPUzlhME1peVdPSlFGTGt3Tk5NUDFxdHd6?=
 =?utf-8?B?c2NZQTZnamJ2dTg3Y3l0NGNobnJBSHdiQVBKOCtkdzlHem10bjJPMFlIeVBI?=
 =?utf-8?B?WTU3MVNqd1U2by9lcVR3VDJJbWZmcmdrMjk0ZFlBcUR2T2NVeHlhZ040MFJW?=
 =?utf-8?B?clFiVitxRjBPYVJsV0g3bGZKYk1IbThDTzM1b25zU1VtamhaMzR2WWQwU0tS?=
 =?utf-8?B?MEFST3NxY3NCR28rL0Y4ZE5UM0dQV0VrODBsYkgxejgwS1RDeDBPZ285MTdj?=
 =?utf-8?B?ZVpZRkVrZVhkblo5WWZ4eTJJVHprY0FNdnErNDdyNDBsd2FqS0JENVZpMVN2?=
 =?utf-8?B?VmlHdEZzZGFTRHRTMy9nZlc1TTlPQThBQ0JiWnM5cHpjd1UyakwrU3ByVFl5?=
 =?utf-8?B?NllITlBhTHpYZW5pNkM0a0RaVXFlNEczV3l5dVVSZnpjVmVwdTJaYmsvQmM4?=
 =?utf-8?B?OTJhVUkzQWRDQzc3Wkx5MGV4cGpVbWRRWEI5c3NWVUhaZFJtQzBHS21VSERl?=
 =?utf-8?B?L1pxdW1FaSswS041Rnl1bkJ1L1pHS3ZabDlra21Pb1NIT0hYUmEvbytmLy9y?=
 =?utf-8?B?RmRHbzVkUUY1WFNxREd5L2dvMjAxZjZhQmsyWkpGOHZ4dXVBRkxyRExxV29U?=
 =?utf-8?B?ODNGSEhmNHppWWN2TGJISEhTNGRqZUJMUklEL2p4UGpqYW13WGVnRnZQcE8x?=
 =?utf-8?B?emxsZjFEcjg2bTJRSFYwV3NZQWNkZG5BVVJhL1NUT0c1K0pMM0x4WHhWaXVt?=
 =?utf-8?B?c1B6ME5oNjFtOGhya1VFbUJjZDN6YlZRNmpjSFhxSFBNTTlMcjdNVnBrVjc3?=
 =?utf-8?B?bWhUQnJKbFVjSndaVGJReGVLL0NESEtHdkpmL1hZMVBWTUM3a2NYeVRwNmd4?=
 =?utf-8?Q?+aHSQ7ltAYngg1xhbMeH13s3f9My0A/ZUuCn7yP?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9cc2f9ee-f0c1-4e11-02ff-08d93820f28e
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4196.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Jun 2021 21:34:00.9844
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: SbFEijvkIyXSPin/4oNiIg5Mf766LMC/mx2y4H2g1sKlfhZqSTLRZOLUY75MnNS2PCXdOPevepRGjSLMbL4vbQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB2901
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10026 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 phishscore=0 mlxscore=0
 mlxlogscore=999 bulkscore=0 adultscore=0 suspectscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2106250133
X-Proofpoint-ORIG-GUID: mI7UinjZy0dGObf-A5LkdrA3QzKyUDZD
X-Proofpoint-GUID: mI7UinjZy0dGObf-A5LkdrA3QzKyUDZD
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

On 6/22/21 9:45 PM, akpm@linux-foundation.org wrote:
> 
> The patch titled
>      Subject: hugetlb: address ref count racing in prep_compound_gigantic_page
> has been added to the -mm tree.  Its filename is
>      hugetlb-address-ref-count-racing-in-prep_compound_gigantic_page.patch

Hello Andrew,

After thinking about Muchun's comments, I am sure this patch is
incomplete.  I do not think there are any problems with the changes,
it is just that there are other cases it should cover.

It will be a few days until I can come up with a new version of the
patch.  Just wanted to give a heads up that a new version will be
coming.

Feel free to drop this for now.  It is not urgent as this issue has been
around for nearly 10 years without notice.
-- 
Mike Kravetz
