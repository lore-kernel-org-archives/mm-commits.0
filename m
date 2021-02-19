Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.2 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E077DC433DB
	for <mm-commits@archiver.kernel.org>; Fri, 19 Feb 2021 21:27:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 970B364EBD
	for <mm-commits@archiver.kernel.org>; Fri, 19 Feb 2021 21:27:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229612AbhBSV11 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 19 Feb 2021 16:27:27 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:42886 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229620AbhBSV1Z (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 19 Feb 2021 16:27:25 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 11JLNx9O143484;
        Fri, 19 Feb 2021 21:26:34 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=xXp/qDAbMPdGjG8R8kV+hQII6LQrhzi6Ie8ll6q1VW4=;
 b=N9cIsc2fQIS4ZohuuA8kPJBnm0f6pUxWls9WsGte6WDFqR0zWPxXhluglYpZpZLUn3Sq
 9viTn2l64ZEjO4dcZiZ43RlnJcUZvcNrvLAa+uG4ERU4BWd1t4/5460ZhJoQr8mHNlKn
 Oy3hxpMgCNpDkqvuGa0KqtQozYJ2bjAAcAMdXPi9ox93Lf7lrkMMMgdAMiI7ADVz1hza
 9h4SNY07MNexXFPSSHJKInAamAaYwVl7EaTm9ec93Dl9WfCRIt+Bqj6bL6ygp543L3wk
 QfaVCPvnIgPCleqX4ex857pnfkFvJrIrXGJGkQdzTOFCVTMdWoKs6hTIfTlNtCsx2oxZ Pg== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 36pd9ajc69-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 19 Feb 2021 21:26:34 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 11JLQU0J102304;
        Fri, 19 Feb 2021 21:26:33 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2175.outbound.protection.outlook.com [104.47.57.175])
        by userp3030.oracle.com with ESMTP id 36prq2cx4g-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 19 Feb 2021 21:26:32 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PNxaqVuere1kGaaPpL9Y3U68OZWrN18Mq7HDrUlGv3ojFW4UcNFPU5nAWuo6Mg3oLw0zEyT5rvaJE5PTqbP3VABRHPumRddZk0FvKM89GODm4l5VrdXYfn4iyYT+gS9nReE1YOF4jUAzqyiM+ioopdqNVi/UDPJZffRPSzoOnfOf9tcNKac5Al9l6A/zdAzX7r//Ct3xWC34Xq5Ef+vvS4lotINUO4N4vhST2auvu9vnx9d+HwLFt/y9hnmb5Vt/bZHpgGYmjItAw1EvOeD6gjEUtFEvBc2fiRyb6XYrLJ3NFmXf+/+YXCN5d8b2v8U02Z72uHcqUbHLG1FYlvApAA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xXp/qDAbMPdGjG8R8kV+hQII6LQrhzi6Ie8ll6q1VW4=;
 b=dyXlVN293Wybdau1/Zmc0XqJmxaPpngLtU+lnmBQbs3oKdU3Tp2uDvwrmPmlSz8SfSrjesSuuBn4YzwQFFEYi8yVd89rOu8L0LgBP/qdTw/AmpaX+CyXATq0s0d4vRd42gcAwIvo+Ni5ORJA7qYDtCJpLkgfbmutLctNLID/d8NHTrwRguxjQoJq8Ok5tz/v1piJQsF/WyijaI+RcsJoDWLFm5/agQErYqg/dfni9zebGusRdhbqzfh+AD8yMlhh137WyNQn/toUFLmu1D80muG3hw9PlE81JWqbYh+KC0T7rLlutkJt8147QyiwZiLhwnyu855IJ+gQy+WfoayG3Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xXp/qDAbMPdGjG8R8kV+hQII6LQrhzi6Ie8ll6q1VW4=;
 b=elp/p7ZdAf0c11d70z9pjJHVzIHMwHN9ZHblFsNpIQoFfwVkoZLNctYKgy41md3uSqMqLQZKqyfviGZkU9g8UaixBww1IlV22I10AeG8Y8apima3xRWL2V+qfC2IXuKS8wB9FtEYouECjdlBAaXo7CfhJPDukXSym4ydLvloazU=
Authentication-Results: huawei.com; dkim=none (message not signed)
 header.d=none;huawei.com; dmarc=none action=none header.from=oracle.com;
Received: from DM6PR10MB4201.namprd10.prod.outlook.com (2603:10b6:5:216::10)
 by DS7PR10MB5117.namprd10.prod.outlook.com (2603:10b6:5:3a6::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3846.31; Fri, 19 Feb
 2021 21:26:07 +0000
Received: from DM6PR10MB4201.namprd10.prod.outlook.com
 ([fe80::ad89:6caa:4481:b733]) by DM6PR10MB4201.namprd10.prod.outlook.com
 ([fe80::ad89:6caa:4481:b733%3]) with mapi id 15.20.3846.042; Fri, 19 Feb 2021
 21:26:07 +0000
Subject: Re: [nacked]
 mm-hugetlb-suppress-wrong-warning-info-when-alloc-gigantic-page.patch removed
 from -mm tree
To:     akpm@linux-foundation.org, mm-commits@vger.kernel.org, guro@fb.com,
        chenwandun@huawei.com
References: <20210219210312.wEdZw%akpm@linux-foundation.org>
From:   Mike Kravetz <mike.kravetz@oracle.com>
Message-ID: <9adbe665-6e1c-8021-9e89-fc57d3c4be8d@oracle.com>
Date:   Fri, 19 Feb 2021 13:26:05 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.1
In-Reply-To: <20210219210312.wEdZw%akpm@linux-foundation.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [50.38.35.18]
X-ClientProxiedBy: MWHPR10CA0018.namprd10.prod.outlook.com (2603:10b6:301::28)
 To DM6PR10MB4201.namprd10.prod.outlook.com (2603:10b6:5:216::10)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.2.112] (50.38.35.18) by MWHPR10CA0018.namprd10.prod.outlook.com (2603:10b6:301::28) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3868.27 via Frontend Transport; Fri, 19 Feb 2021 21:26:06 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: dc4ccea8-6ebd-4e04-26fc-08d8d51cf82d
X-MS-TrafficTypeDiagnostic: DS7PR10MB5117:
X-Microsoft-Antispam-PRVS: <DS7PR10MB5117DC0FBC9D13AD8399028AE2849@DS7PR10MB5117.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:161;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: kXMb7jrJWRsrxIwnUMQyKut04U0n2ZhA+YWadEIrfV+VNTgHhvsT1Q7X25En8WTBiNERZrnIkzeJ28PAq5ikygIDxjvCDTQFhEat4zeV5Tn7/RZClS/c6yk7olEEMc90TJHPKEyHfPWm2URgULO9C503e582E50JPtiXvuR1NucouXot6lIY8wP+oF59PaVWnfXoYJoCUfTFANtCZY8UudAynb6+JqZzJcvya2xBG6Jfec3MrxBA8wpdvGNZ/ojtuSM8xvUeibyny9H699bZDhOZZGALIs0HCEcHnkUSnYu+v3sXiStHYHcS1iA1aREZ2njnUt4j7sgwZ07WtonVBY1wIs2JGt6ulkv73fXV+epIWmPy11C/UG9MrMessOiuBVtJR5OZpo6Y/yE9fYAbWujykXat+d7YceiJ7ZBRo6RmYil0vegutiSPdwPFiUoYA4A+hL2jFE9x85YFvM9f+r0h3G62HeSDnAWJBI3g1csZpAyMO63KcHvzjhLzij/O9hS2tqsKz4Abu/gXTy4DeU3b7UKAaaK1tMhbKC3coJ+xIrlfrHSACZtUrNCTXo0gdiwyjUN/L0y2tRUQ4RRzLzUFO2sUFq9PZkg72RiQX4yBvh/StVBJnuPLr98ln1nHzPjDnw9BzkWPuoEZnh9HWyYwyVBDxrKze/QYZpyMF/UETIQ4rAPJyHOazfln7NUD
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB4201.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(376002)(136003)(346002)(396003)(39860400002)(83380400001)(8676002)(5660300002)(966005)(53546011)(6486002)(44832011)(2906002)(16576012)(31686004)(186003)(31696002)(478600001)(66556008)(36756003)(66476007)(316002)(86362001)(2616005)(52116002)(16526019)(66946007)(956004)(8936002)(26005)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?eTd4Ni9zNTB6akJTNVFhcHIzYk1oL2FML2NOOEV0cXlvSTQxWUxaL2hlMGRK?=
 =?utf-8?B?eU1rU3gvWmQ0S2NPWlB6aUFXSU5GTFhLdGtxY254aDNxT2xHVFdFYmVzdDR6?=
 =?utf-8?B?TGk1L1c1SW1DT0JNZURVMHZHN3JzdkNXTTdHOWthRm4yQTB5c1QzWkxTNUg4?=
 =?utf-8?B?c1pBUHk1djhkOElMQUIrK0NFL0ZmR1QxU3ZYMVMwbm9HcVR5T1h4bEE3bHZz?=
 =?utf-8?B?Z2RrZHI1QkVaWmp4MU1ieVZQa3J1bkdXSEkwTDNxcWRUNVh6V252N0NXNzlF?=
 =?utf-8?B?UEwzdEVHcnVOYk41cWt1RUZ2NzZaNXZYOW5GVFdZdUhsVUtHaU1CVDh0KzJR?=
 =?utf-8?B?b2pGdWNSdEMyWThDY1RoTENtY2dNYzZZalYwTVdFMXhaUFpNcjlMZnBzaGl2?=
 =?utf-8?B?Z0d5enlIRjRVcnRsTmh6YWVKQTk5TzU3RWo4bm96cEFXZDJuSnM2ZnIvV2FW?=
 =?utf-8?B?YzRSYThnREkwaTM0eEtWaS9FbG41K2ZPUlp1T0FmbkZRLzN5K2l6dlcwTFNU?=
 =?utf-8?B?M1FmVGM0cm1xT2kwLy9YQklkYWJxT0pHaXY1emNqVVl3S3FQdms3S1FzQ0N2?=
 =?utf-8?B?cGVWTmFpUUVpcG0yYThaSUxGYkwzMlZyUGtyTDVvQmplZ2hkeDkxenFYOWF5?=
 =?utf-8?B?ZHlZVmxIV0MrOHlKN3JhbVFIdFdaR29uSXBxRzJOSitLRWx3Qk5rbUhlVzho?=
 =?utf-8?B?QUVXaGt1RTRaSWtaMWN4ek1pdXhpWktoQ3djWGV1ZTY0b2c4cFV0c0VhVmUv?=
 =?utf-8?B?QktreSt0NTZKc2FpNGdrczBtKzJJNklYS0NKQzhHYVI5QTJWQW16VFUxZHd5?=
 =?utf-8?B?bU9yV0ExaDlTL091cDJwQUhyNDVRU0Q2cUpYTnBEZFN0SjRUL1JBcmlUdDc4?=
 =?utf-8?B?QUhZdE5DWDl1UTNNQitSTUk0SVBZMW00NHZtQ1EzMm5SKzVaUmYyNVVhNVEy?=
 =?utf-8?B?bWxDZHNYVkNzdDIrWkR3MjNxMHNza0J2Unk0SXhOY2QyS3VhTTc5anB2RkJS?=
 =?utf-8?B?VVNVQUpIVTErVnY5NmlKVDhOMWhMbHkrTC8yVFRBdWdOVll2SG1VZGtVUmx1?=
 =?utf-8?B?OFlNaGtIUXhLYU1GL0lFMkdOZWRadFhMOEE5ZWFPVENIM2FlUk82U2VwdS94?=
 =?utf-8?B?S05vVEpjNzF5R09UQjdYdkMwQUZ0QnVJeFB0cmczTE9YWlpPNzV1RnhWVTlQ?=
 =?utf-8?B?aDh5eC96VXdRUTJta2d3R1U3TURaRTRUNTh2VndYQVVaNml3K2E1UWNxc1pO?=
 =?utf-8?B?SFZjU004VzFodWtRblBFN3VONkhmcUhIV2tCd0hRT1ZtbEVhNFh4Y0lqNjQx?=
 =?utf-8?B?YXloRTdpLzJxaEVnR0N2QUtBM2FBSm83dE5nbVNsdGhwRXRhSFMzNFNNS3hW?=
 =?utf-8?B?cVJRV2xjSnVza1IwcU00WkhOalc4dXRSbWdFVlJlNGE5S0ZMb3BTL21FSklQ?=
 =?utf-8?B?a1pOYlFZaHBMUnlHRHFxbXNETUpWc1AvWlhLcTdSaHJCT21IaDJTQWo3Mjl1?=
 =?utf-8?B?djF3UWVpQ1BMYlY1NCs1MFB0aFV1WnYvQWJmVVVHcExMNVNkYzJLTXU3amly?=
 =?utf-8?B?TDhWb1dwUyswZDV0YlNwZk91NzhEVEdMV2gvbjNsT3dTZklIaCtCWXg1WjN5?=
 =?utf-8?B?cW5HZmJjT29jbCtkdkNWaUVxTlF4UitkeTZIbEk4cXlvTGFJNVNRNXpkbGVk?=
 =?utf-8?B?WHdkWWk1OE5GUG1WR002V1A2R1JJbTZpSkF5Zi9lZ3FzK2drSFY0ME5QN3ZJ?=
 =?utf-8?Q?4tyfcyKiQp2RoQLUDIWQzmBl+9ZH0n+gxeHyAKn?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dc4ccea8-6ebd-4e04-26fc-08d8d51cf82d
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB4201.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Feb 2021 21:26:07.3171
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: oefal7rrVwnsNdZv9sJSvFpJ9MvEw6RgaCm3qg/yAVdorabYNECo2LhHXjU7APH+KLUeRhKkO1+0igSd+g/5UA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR10MB5117
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9900 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxlogscore=999
 phishscore=0 adultscore=0 mlxscore=0 suspectscore=0 malwarescore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102190172
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9900 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 clxscore=1015 impostorscore=0
 mlxscore=0 phishscore=0 mlxlogscore=999 spamscore=0 bulkscore=0
 priorityscore=1501 malwarescore=0 suspectscore=0 adultscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102190172
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

On 2/19/21 1:03 PM, akpm@linux-foundation.org wrote:
> 
> The patch titled
>      Subject: mm/hugetlb: suppress wrong warning info when alloc gigantic page
> has been removed from the -mm tree.  Its filename was
>      mm-hugetlb-suppress-wrong-warning-info-when-alloc-gigantic-page.patch
> 
> This patch was dropped because it was nacked

Sorry Andrew (and everyone),

My objection to this patch was incorrect.  I did not look closely enough
to notice that only a redundant warning is being removed.

Upon closer examination, you can even add:

Reviewed-by: Mike Kravetz <mike.kravetz@oracle.com>
-- 
Mike Kravetz

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
> ---
> 
>  mm/hugetlb.c |    4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> --- a/mm/hugetlb.c~mm-hugetlb-suppress-wrong-warning-info-when-alloc-gigantic-page
> +++ a/mm/hugetlb.c
> @@ -2529,7 +2529,7 @@ static void __init hugetlb_hstate_alloc_
>  		if (hstate_is_gigantic(h)) {
>  			if (hugetlb_cma_size) {
>  				pr_warn_once("HugeTLB: hugetlb_cma is enabled, skip boot time allocation\n");
> -				break;
> +				goto free;
>  			}
>  			if (!alloc_bootmem_huge_page(h))
>  				break;
> @@ -2547,7 +2547,7 @@ static void __init hugetlb_hstate_alloc_
>  			h->max_huge_pages, buf, i);
>  		h->max_huge_pages = i;
>  	}
> -
> +free:
>  	kfree(node_alloc_noretry);
>  }
>  
> _
> 
> Patches currently in -mm which might be from chenwandun@huawei.com are
> 
> 
