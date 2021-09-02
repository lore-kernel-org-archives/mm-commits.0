Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.9 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5FCC5C433F5
	for <mm-commits@archiver.kernel.org>; Thu,  2 Sep 2021 23:23:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 449916109E
	for <mm-commits@archiver.kernel.org>; Thu,  2 Sep 2021 23:23:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348028AbhIBXYu (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 2 Sep 2021 19:24:50 -0400
Received: from mail-bn8nam11on2089.outbound.protection.outlook.com ([40.107.236.89]:29409
        "EHLO NAM11-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S236202AbhIBXYt (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 2 Sep 2021 19:24:49 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=D8/4hk9lHatgfSgLImQKGNbkwGw2JDr1hNikpHboqo44gB67g7Kkt4ixOOopp0gwAB7+Pc+w+dR0Ygl2g8CyzfI9htomKDiedEKLkcc0HYI1W29gpUsb8AuQHqBBitxnNpRndbtJDbmEzLW8y0/c1P2aRHZBvJpZmKpPfL8VYsSJSoVVCwtZkbs6ZfCL7PLEnOLujM3LMSQQ/6+pAYaMXMx4toJpumyohVZ99s6VQugl5fJ7xheBfRQ/jjDVrnws7MYM781aBotbOgiyPNks3FvzD3Y4vEH8JAUpli2hBcWZd1X/j4lPI0ZVomxUaRCaAp2KY9eOZ+6dJr4LWYp1yw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9w4Owv0t0mpmuD6Fs3ws4X4Xo9OK0Lvl1t4AKxVEyLk=;
 b=B8dccS9aeKdKLpeInh9FQ+1O/T4XoVi9ec7cu5+Di0dZq1aXXDQODzEDS6bCRG9nPNNUcmetsAufzCCqNa9zb20Dl1SmkoyeIPwueAKbbderA8xHHypSMhRsByNswgJhRcthWRt7QPPc4tGxW9eX70LYf8CtppExilpOFfqGuo6KqdfKDO5ANmGbCpxRTuc2G39vySFrfl2vmWMVG3lLJ6GB1OHBsH1Pfb93OWbRAxSO5YpHypOEt8bXbJU7T7EMF95haxnuksYaPEBNjlITWjxP6XBPjXP7gLoffuBPX/m9ZbMlLoPH2Cdn+84LBD0yhiKgpD23rheru3g2o1FR7A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9w4Owv0t0mpmuD6Fs3ws4X4Xo9OK0Lvl1t4AKxVEyLk=;
 b=uVJurzpNJ25iGePuULo0iJBeRUl+fcPO1fjXPlkTnA7aUEEJf+ZAEQGihGXi4corI2Ul3gxBVBoM3miIn8QFt19YYOuASL9F3P3UDRfcxAf9PQRx07Mz9dUovgXuR9kzVp8nu/ZFqPSezyKnBvqvibn+rjy4eDYnoNyedXyUZx4jhyC+qn/6IYIAo8be2Vxzyf5LE0WhD41L+TAQiFMlb/him5gyMn7/aWeASKhZHd8L2XE6g0fpD1Zn2u5P6YXg/lAvf+PVvmDycn2wXtT1AbCCq8GMuORr3iOKKoPRyU9zJjvVmOlaIqaf/TBqQQ6ZhBvYmzNdlHhX/W0zSguZwQ==
Authentication-Results: infradead.org; dkim=none (message not signed)
 header.d=none;infradead.org; dmarc=none action=none header.from=nvidia.com;
Received: from BY5PR12MB4130.namprd12.prod.outlook.com (2603:10b6:a03:20b::16)
 by BYAPR12MB4694.namprd12.prod.outlook.com (2603:10b6:a03:a5::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4457.24; Thu, 2 Sep
 2021 23:23:48 +0000
Received: from BY5PR12MB4130.namprd12.prod.outlook.com
 ([fe80::18d1:be89:51d3:58c9]) by BY5PR12MB4130.namprd12.prod.outlook.com
 ([fe80::18d1:be89:51d3:58c9%6]) with mapi id 15.20.4478.020; Thu, 2 Sep 2021
 23:23:48 +0000
Subject: Re: [patch 075/212] mm/gup: remove try_get_page(), call
 try_get_compound_head() directly
To:     Andrew Morton <akpm@linux-foundation.org>, borntraeger@de.ibm.com,
        gor@linux.ibm.com, hca@linux.ibm.com, hch@lst.de,
        linux-mm@kvack.org, mm-commits@vger.kernel.org,
        torvalds@linux-foundation.org, willy@infradead.org
References: <20210902215354.ipaXS8yYx%akpm@linux-foundation.org>
From:   John Hubbard <jhubbard@nvidia.com>
Message-ID: <b92651f5-14c2-8711-9bc1-daf33af06887@nvidia.com>
Date:   Thu, 2 Sep 2021 16:23:46 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
In-Reply-To: <20210902215354.ipaXS8yYx%akpm@linux-foundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR05CA0193.namprd05.prod.outlook.com
 (2603:10b6:a03:330::18) To BY5PR12MB4130.namprd12.prod.outlook.com
 (2603:10b6:a03:20b::16)
MIME-Version: 1.0
Received: from [10.2.52.41] (216.228.112.22) by SJ0PR05CA0193.namprd05.prod.outlook.com (2603:10b6:a03:330::18) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4500.7 via Frontend Transport; Thu, 2 Sep 2021 23:23:48 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f3a648cf-7e33-48be-0149-08d96e68b770
X-MS-TrafficTypeDiagnostic: BYAPR12MB4694:
X-Microsoft-Antispam-PRVS: <BYAPR12MB46946E8A722CF1189FB5A707A8CE9@BYAPR12MB4694.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3383;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: uAOfApERv3HyiZgAaz/1tPaNGN928YcOEwShmApNopnYWhV7p7vIGGnxRljxHELm3iW/rvzynK2QnjejJ7XPdRjP+FfKC7eB6TbQhfEbDDCkHDdLAZ2UuWHh43VvEAUuleTh+Lpa6KzU5y4LYV/GtOhq2KaXDJMs6PvhhmLm3Ohbsp43cMoEBvKSwkLm1tWxJdLSeC+DvxktIllbll9oOaMxyuVOZ8+K7DxTVfii1JkBs5IxG4psSPeCsvdhF7iIkWDQC0yQyNLKIoeCWzv15uzvpwiwEP15j7f3RgUdFwvfMchbSYw0BHuvR1TwzaEH1CyvGKeH6ntecOUAwylJHCV9/EPbck5a5LgEdCipbdCB7AUzGlS3KiFf/rAtBfoljeddGv/1Uxfd045FhW8hCgc6dz1DykuzKELhFWMpusOKcz4p2wMZJuMjJSrSwGRUzjkDvEbPhlHmbTX7zDVsTGLoWd61wCkhkR87sPxrGnK7qvoVeIxSN4up2NP+8ob5VlaTjRYIEGbeWpKUW4GUt8rknO20jqtw594OCfIdko0hguhc6w5lAeJGfKa3mckXGAQiZD8/8sY6mkufgFWdn9Md0OhgdR5Etd48P8LMcSH9/qcvQSqf0Tl1B7BE5EMpq5cKL/LCXHQvGMmWIQMV6H0msFbrYpZSgHt49zqtOLo6Zr3SMX/7ot/sz1kmDgovaNeo8+ExjvxuLWNmpKLk8zWsuvd2gtCFpRe/FDi1SWLSwYyyd8nq+G9B01Cqhh8f
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR12MB4130.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(376002)(396003)(366004)(346002)(39860400002)(2616005)(66946007)(86362001)(31686004)(8676002)(5660300002)(31696002)(6486002)(16576012)(478600001)(8936002)(66556008)(2906002)(4744005)(53546011)(316002)(38100700002)(66476007)(36756003)(26005)(956004)(186003)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?YlREZU5TcC9uRUhkdkQ2OHBQL0JobTUybElrbHVUeTVhQ0ZFNFNmTDdmNjFy?=
 =?utf-8?B?bm4ra3QyVzExbzY0cnJvdTlYMjVQVDF4a3BUd0JGeWFNM1hKYm13bC9pSENM?=
 =?utf-8?B?S2tkL1A4SE1Md1VHUkFrVkdvT2Z0ZEx1Sk4vcXMvVUxnUkZodEJ0d2prNjdB?=
 =?utf-8?B?WVE4TkxVQlFMRys1eXZqT2Q1dVE1WmRvMlBYL0l2ci9CYUdaODkydmZrUXAy?=
 =?utf-8?B?TFJEais4UWhYVjgwTWtOc3RxcjFiZHQveVdDdzk4MlpObUYwcElrTkM2TnFV?=
 =?utf-8?B?VGlKUkFaMU9jZTBSR2pBaExJdXlWZnlrTi8rOVBrNWwzaHZmczZadXkvbC9M?=
 =?utf-8?B?Mk91c2o5Q2ZUZW9SSzZ6RjN0aFY3bVdpeExXQWxuWnQ0cDZ0NDNLbjZuM1Q2?=
 =?utf-8?B?VWREeU9yVXBWTVlPNW0yVkpNcDhLdlQzNjBmWWNPOE1RSnBCS2I2WDM5ZVI5?=
 =?utf-8?B?WWh6Y0NHRXRLNEM5LzJkWjVlM1ZBWC94NlE0aVVMUzlpRkpsbWJHcE1yZU5m?=
 =?utf-8?B?RzFNdzdCQUpnNXIySmZyakE0aWZSOFNrbjJSblk2SUs0R0RBR3g2SThFNEVm?=
 =?utf-8?B?RTk3L1V3VisxUDBueWNkRzB0eElsVEdpeWdYcHM1NS9JS3hnRW55dU5qU0Fz?=
 =?utf-8?B?d0JNNWtsUFdQTlp0WUNTRVR0ekQ5dzZ6T0pRdEhzOUc3VXJ0RG9QSk1tZFpB?=
 =?utf-8?B?NDI3Q0NrUDZZQlUwK0NMYlhvZ1BiNmxYblJ4MCtudTBIVlRwR1NrU0dvODlP?=
 =?utf-8?B?MU5uRTRqMW5FU2RFcUx5dENLbmxHdWJnVjlFNTJ3RnVyK3JxcEE1OUkwZW9X?=
 =?utf-8?B?Snpwd01GN0FRVk9PM3NIdnRNdXFkNUQxaEdkZzRmSW0vOVFiQjIvalB2MXBn?=
 =?utf-8?B?ODNYY1JheVY4TDVlV1ZMbEdHNUdhSzkrMHJSV1hMaWFtTWJpMmc0UGFsOVpS?=
 =?utf-8?B?a0kyVkZWQWllaDBrQjN3UFg5cWUvNFRGdUJtTFh2YmlZKzErV1YyWFFEcnF0?=
 =?utf-8?B?QnRScWJhSXdMRkdiMUZReFBGQ1lQK2s1bGthSlFVUTVGUnRvYjgvdWNMajI2?=
 =?utf-8?B?MmRmRmVXRS9VK1VnaWZqaU5EZGhuTDRMalEzMFZneVZNTHNIYlRTd3V2anpV?=
 =?utf-8?B?MTlLNWxKOWlNQi85b1ZUSTYwNlFKNGlySlc5a2Foa0FTUEFpWmR2cGJ1ZjBZ?=
 =?utf-8?B?MjE1SWRtd0lSTmEwQk50QmJ2UTFPeTEvN3hLMUo2aUo4UnNRZWZYVU16b2Q1?=
 =?utf-8?B?T2VjTm5PakN5T1BIeXo1QiswYUJvWERCNHRqOHBaNEwxTGo5cXE4ZzZMdVlt?=
 =?utf-8?B?Z3ZmbDhZeDI2ajR5WlM1Qk1rMUtIMmlkTXBvclFWeUNKY2JOV09jQzdQbmRa?=
 =?utf-8?B?NDYrR0ZUMStCcnhpZDhIZW4zRWEvL09EVmFnSUFtNmRtM0MzejZLRHlSVmd6?=
 =?utf-8?B?aW0yR0tRcmFOQmFFdTAvdHppLzQreFozTDA4TTR5N0UvS3lyRjhDYWp4cmFi?=
 =?utf-8?B?ZmkzVm1JWkt6ZU5lTEE4T3ovRFJUZk9ldnNUdi9OelZiNzJldnd3Z2xqbXB6?=
 =?utf-8?B?QSt6c1RYYVpWMkVYbUUzR0poS3E3VEk5RHVqY3lWZzV3eXhLSEdwMk0rZ0E2?=
 =?utf-8?B?TkdycS82amVHVXhmUlZpSjlSd1ZjK2puRFVmTC9Dcm5tNCsvU1dxaExOWURs?=
 =?utf-8?B?NW1BMlRTV2lTSHBRVWluekcweHdXMUFEbjQvMFJiT0FMS0x0K2FvOWFZbWg3?=
 =?utf-8?Q?7Zrqbb+6Kg7o4y8AZq/jS3vWRCyw7VxlFMHmnUU?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f3a648cf-7e33-48be-0149-08d96e68b770
X-MS-Exchange-CrossTenant-AuthSource: BY5PR12MB4130.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Sep 2021 23:23:48.4214
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: l+OsiUKRXzwtGPbDaOBQQmfYZJVaM1tsfcp7DIIsZ0L1jkkBbBVDgsh9OYzqJ7aJn2yo7nNQiylK8GZ6YZcnRA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR12MB4694
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

On 9/2/21 2:53 PM, Andrew Morton wrote:
...
> --- a/mm/gup.c~mm-gup-remove-try_get_page-call-try_get_compound_head-directly
> +++ a/mm/gup.c
> @@ -62,11 +62,24 @@ static void put_page_refs(struct page *p
>   	put_page(page);
>   }
>   
> -/*
> - * Return the compound head page with ref appropriately incremented,
> - * or NULL if that failed.
> +/**
> + * try_get_compound_head() - return the compound head page with refcount
> + * appropriately incremented, or NULL if that failed.
> + *
> + * This handles potential refcount overflow correctly. It also works correclty

s/correclty/correctly/

...that is, if it is reasonable to do a typo fixup at this stage in the cycle.


thanks,
-- 
John Hubbard
NVIDIA
