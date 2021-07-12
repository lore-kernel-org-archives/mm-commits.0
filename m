Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7B09FC07E9C
	for <mm-commits@archiver.kernel.org>; Mon, 12 Jul 2021 16:59:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5FC80611C0
	for <mm-commits@archiver.kernel.org>; Mon, 12 Jul 2021 16:59:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233772AbhGLRCM (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 12 Jul 2021 13:02:12 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:30618 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232710AbhGLRCL (ORCPT
        <rfc822;mm-commits@vger.kernel.org>);
        Mon, 12 Jul 2021 13:02:11 -0400
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 16CGtv0m025459;
        Mon, 12 Jul 2021 16:58:58 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=KHqX2JEznDbZC7DV33/MSdohL87TC+K8/tmVzax4VP8=;
 b=m0PSZprTDKCtLVifwnBbpBkQE0CK1W6dumk2EJ+9ycknbtbzf3bymGg4WJyEmysmA2T2
 WploRrf8/t3M2O4+amaJWOT/ErgqCgT4xEcW6GblVGD1E50APNu3ht33ldr/SEOZ+Ygo
 uMMzfJ8LUnsAo2k2/FIcPwvPMNc/9snbwrcTzo7dQHAkD48p1kukFv9gUq4HuGDZVGHX
 6ePHqbQ0Zi3oi6xpeI0LMhD6kBM4PkyezrAowFIfmbATR3/OC3WKmnGk/w69X6XJzd1y
 5oQQNI6w9BMqltIFjnezeyAIs0zd+YPSW/yXBMdBkkKeBmD/9cTkteNpJqZ4xJcFxmFT PQ== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by mx0b-00069f02.pphosted.com with ESMTP id 39rpd8rk77-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 12 Jul 2021 16:58:57 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 16CGt7RJ064701;
        Mon, 12 Jul 2021 16:58:56 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2103.outbound.protection.outlook.com [104.47.58.103])
        by userp3020.oracle.com with ESMTP id 39qnaukrj3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 12 Jul 2021 16:58:56 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HMCXmA8/BHzb4cqr8w9vFr2jKG4OpueCvxsAXlErr6nnw7PmFMZqCWjXtEHoC31qP98g/N9RjqbW7i/jhgE4O8Vhw0KJclOXTePrsNAu2jnwzGJfhqd7GdOa1SPBSfTWT7sqS38cee1PMyCMiSFt0yio9wm7LA9XFZ9/g5Aq61n8euIRn5g+qc5ROhr3+ziJwbe3ezSeq0NHj+zYdxQrxoS4p5/0xQwtbYkIXTBJJvHGzsCIpOrgt8gm/yn1khIDWnXGM/uoSV4X5/8zTzYtXzuGW7MrUgwZGL+jGPsnDgVLlfKABY8scbVClHr1oc8dvxB7Q/THrNL1/CbJSNa5tg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KHqX2JEznDbZC7DV33/MSdohL87TC+K8/tmVzax4VP8=;
 b=DF7hgWqE98PANPKr+meJv1SJla1Mnjm4i8B9IRuFUX1zdh8fXXBuRU1WWK91S0MqHGmHrcBkYYGpZ3O13j4cXCxfLxaPd5dWyKNKxuMH83yqNUJteb35sg9i2KAteff/TShJ7pQZvSxwFrcyZ221U27hsQsL3rwreZSygR+5r1yGcfrb5E1s1BJHqDRqp1A1BcyBYqU7uKz2t3K1c9FQXX9wUGbromNl00SZIIlGCIJjvoWdb627TpjXpxRznbUfTiwq++EJnpSYNUE/xr6lIsZV1dSMDPoLRWgj8CVtLfri/l49jPCARmuuRND/Gvj3Zt3gzM4p1+YA8AhQ5bAV4g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KHqX2JEznDbZC7DV33/MSdohL87TC+K8/tmVzax4VP8=;
 b=GemdlxqmFyrcLMPoZn/F38dhrujFm2jP974+SbbA8pngkDZM0A7CHSJIpBrUBRYDuLbTsJOw99SquNOwXZzf8OICGrGxVq7oK2E1/IiStWUeKZYtzrQ/Fo2KmRPKuG5YKNy36+MrSCOqZBM/zTuPjvRfzJyI3qt4HFsCJnLVCy4=
Authentication-Results: huawei.com; dkim=none (message not signed)
 header.d=none;huawei.com; dmarc=none action=none header.from=oracle.com;
Received: from BY5PR10MB4196.namprd10.prod.outlook.com (2603:10b6:a03:20d::23)
 by SJ0PR10MB5405.namprd10.prod.outlook.com (2603:10b6:a03:3bc::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4308.20; Mon, 12 Jul
 2021 16:58:54 +0000
Received: from BY5PR10MB4196.namprd10.prod.outlook.com
 ([fe80::8d2a:558d:ab4a:9c2a]) by BY5PR10MB4196.namprd10.prod.outlook.com
 ([fe80::8d2a:558d:ab4a:9c2a%5]) with mapi id 15.20.4308.026; Mon, 12 Jul 2021
 16:58:54 +0000
Subject: Re: [patch 023/192] mm, hugetlb: fix racy resv_huge_pages underflow
 on UFFDIO_COPY
To:     Matthew Wilcox <willy@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>
Cc:     almasrymina@google.com, axelrasmussen@google.com,
        linux-mm@kvack.org, mm-commits@vger.kernel.org, peterx@redhat.com,
        torvalds@linux-foundation.org, yuehaibing@huawei.com
References: <20210630184624.9ca1937310b0dd5ce66b30e7@linux-foundation.org>
 <20210701014819.Vm-gaPGHW%akpm@linux-foundation.org>
 <YOxWI2imZq5/e8VW@casper.infradead.org>
From:   Mike Kravetz <mike.kravetz@oracle.com>
Message-ID: <45b03dc4-a5ad-928b-313e-0f2ee8904a5a@oracle.com>
Date:   Mon, 12 Jul 2021 09:58:52 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.1
In-Reply-To: <YOxWI2imZq5/e8VW@casper.infradead.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MWHPR22CA0042.namprd22.prod.outlook.com
 (2603:10b6:300:69::28) To BY5PR10MB4196.namprd10.prod.outlook.com
 (2603:10b6:a03:20d::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.2.112] (50.38.35.18) by MWHPR22CA0042.namprd22.prod.outlook.com (2603:10b6:300:69::28) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4308.20 via Frontend Transport; Mon, 12 Jul 2021 16:58:54 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d009b1e6-cd99-47a8-220f-08d9455654ff
X-MS-TrafficTypeDiagnostic: SJ0PR10MB5405:
X-Microsoft-Antispam-PRVS: <SJ0PR10MB5405BE493C9831DE679E6AF3E2159@SJ0PR10MB5405.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 8U+Hfkdzg/x4KjRvOoUgiZgaGmk+7LYjH0pA+VI1tMFccKxRcECWEZ6iq2VuoPiw2/Kd6dbzsu39J7Qfym9VoQWA6QZRq3EdDu52EWL5Qs0E+cV2wz7CmWzbB8amUFiC74/ggIMqTkvnG7CDuyqEAV5TAYiqM4C4fX5THb3cOJ3TbUDvU+ne022pT0R2LpLaaWsL/ibGdYBBKjJbFO0SqNBStp5Uh6/NT5/BQn3txfcrWO8/YzCsASuvJDmrr8uwABol36+oMzvapahF8va3ysgmWOgrK2pnMHmUaxJHEAbxNZaIcj1mkxRJcn/QhyIf5Oxy1K+o5dxq46yCi1CYx1OHyRm+NU69SJUObOCFdPGLELQLijEo0yML2g5TFRykO01wG2UGG5blVhgmQsOXgMXj+bvZWDYh77IjOyvi6ZriApOqfvlRpL9EDTID+9+b8pyKsx1TLqJ1H7hzgH4CygnxdptJMl765dm8NZ1vVBaOHWxOOLRdumk/ZThn/XzWGLcGluk+HCkO3RtfbIR3iKzAgrmgBrRmDBtFA9f5zNORu83RYYBQvWdnVuGwq7FjmcMixx9h9aMRkh8p5o8DmTB6KsmmghO9Ck27kHU8CSdIrI9QDO2H10pfyU4LIHxyBThcsVSoPfAy0Wc8u2ww20PzCrmqgNXMFlwxFKWSkUx1wOWKwj+totHwp4ibMKbNfMywe2WkESgFXBmz1wdW9bTnYUxyuKhIHEkxoQJ+GeHni1C5rUZfLytYF7d94bDX1b7lkfvIpXt2OFEmzvYwsdyxpUu7gLIBO6lL57SLiM0=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4196.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(376002)(396003)(366004)(39860400002)(346002)(38100700002)(66476007)(5660300002)(478600001)(26005)(8676002)(83380400001)(8936002)(66556008)(66946007)(38350700002)(110136005)(4326008)(316002)(31696002)(36756003)(2906002)(31686004)(86362001)(956004)(2616005)(16576012)(53546011)(186003)(6486002)(52116002)(44832011)(14583001)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?WUIyQlljR0o4dEhlYmIrMjJneEtMaUVyU0FFc0FBSWNYandIYkRqeTJtaWdB?=
 =?utf-8?B?THBlUW5ZdnE3ZmhoU0xLVTIxUHNaWXFwbkc3RlpKQnZ4UldZRHNXbDlidjlP?=
 =?utf-8?B?c2dlVG8vU095ZTdqVkNoSTBTNzRJOHVvcmFSL2pqVkdNOGkyMG12Q3p6cUJm?=
 =?utf-8?B?MVIwMkZVSUpaM2NxR3VvSHRpV3FocTBNeXB1bW5rK0R2aWVaRy9mRGlwZ2Jr?=
 =?utf-8?B?aC9hVzNYYld2ZlVjczFrZjE4d3p4d2JCR2tFeEdlYlVmKy9BZ0ZMQ1NKeDB5?=
 =?utf-8?B?Zjk1RU1GVk1uYnNTZFNBbkFnYkdaS0sranJIbDlrcnNUaEFINzQwSWRDNDVs?=
 =?utf-8?B?NzBaYTIxWnNTRGpvYXp3QmsvTlVwNTB5aGJ0WWxjMzdOUFhlZWYrRDdUNys1?=
 =?utf-8?B?TnV2Q3N1V3VLWndneDhZM0V2d2ozNXJYK1R0OWI2dDJMcFhJWjhraTJCZnov?=
 =?utf-8?B?c2FOeEdRUDdXWEU5V0lrU1plVDE3VjRLcGtZMEl4NzBud3lualNoejVadTBE?=
 =?utf-8?B?OWpjaFJBc2dQbGRPY0VjUlYrUjdSSzIzRjBEK2pJUjdLZlR5YzlObzlIVmZH?=
 =?utf-8?B?aDFmdnM5UDNmNlcrTy9TSCs3S1JXNFNFVXAvVXU4YUZCNkVEWGZmUHJGNDdr?=
 =?utf-8?B?RExheWEwMUVMaktkWjU4Rm9kQnptRHJvYzZLd25oUVBPWHdHblVzOGFSdkFm?=
 =?utf-8?B?d3dQb3J2ZXpEZkRDTEVhQmV1cnVxaSswVFEyTFN2ZXAvQVJpNDVodEVVaTEz?=
 =?utf-8?B?a25LNFdmY29HNXpyM2llTC91S3BraHM3V1JGWlR5VnkwalEzd3VqTDYwSE53?=
 =?utf-8?B?VkJ4bjJmaFVRemJDaTFHT2JGUk50RlY2c1dtaktkQWw0eURhdDB2VmQwaUQv?=
 =?utf-8?B?Y3V2aUtTa1UwTUZUU012eThlbm9tNUZZeEVTNEhJRzBTM0pSUmQ3MWFJOVNN?=
 =?utf-8?B?b2RhVWsxL01ub04rV0ZHY0ZwMlo0TXJpUTR5bVBvdG93U0lZcVI5M0dYZ29Y?=
 =?utf-8?B?UWFFbnNBWFFwMENSbzlrUDlSdjNNeDlsOWpMVU5CVDRtcDYzYVc5bTFtTUR4?=
 =?utf-8?B?QUlpNk00TTE1Z2E1QXF2WG1KYjhUUUlFYTNjcUh4bFlhbVNReEZqdXMyVjlW?=
 =?utf-8?B?ZnZHVE1aMi9VUVhFelgvL05MU3o1b0Nnb2hnNTFYVU1ocFBNMEJjdVlKTm1a?=
 =?utf-8?B?N1pjb05ZZGwwR3MvQStjTEJYK3ZJRFVyNFBJUHN5WmtLRWlVYTNSY3J2bktr?=
 =?utf-8?B?aUVtWG5jcTVDeVVUYkRNUnBXSVl2ZzhrQUhvbmJicXdWY1BpcVdtVHlrMy9u?=
 =?utf-8?B?ZVd4T1dQeWtrOHJ4MUpYbHZVcExXSmRJV2cvOHA4bUt5dFBQQzZxNlAyUkp3?=
 =?utf-8?B?Q01MUlBRa0pYMG9iN21NSTE3Yk1NRVViVFdQRmVIQ0ZuV0FDWnlIQUJQUlZT?=
 =?utf-8?B?bXRiZ1cweXZNa3BwYk1Ya3JFTG5VVnl1YmMreVBZeWI2bWRhdjExNThnWU5L?=
 =?utf-8?B?czh6SnlRN0NOOCtMVERsbjVaMlJzVm1lMm5TRXhXWmhPZlp0d2ZPTmIyVERP?=
 =?utf-8?B?b2Y4YWdZU2VOWFdFck1udDJ3emdpalFxbnNOdmdpR1cyUUduZ052Uy90REF5?=
 =?utf-8?B?OENaRkhndTFvMnBTY1I3SGZKT3ZWOU1HUzYzeHZtMVMyRmhpQzhsN3hNUnBy?=
 =?utf-8?B?c0czU0d0SE0rNUNRS2FRWVhFRlJORGhGMkFSMS9nWEg1dFF5eTRQdTVMTGhm?=
 =?utf-8?Q?XhGJbe3xruSDQTV5/vPCgPQPqf87aNT+Oaj6YOY?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d009b1e6-cd99-47a8-220f-08d9455654ff
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4196.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Jul 2021 16:58:54.6560
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: boLIbcVocYCPop01E+4aPOCH49YDsIRMPTuP9eAbIqzZ9IgEboCjZzoynBDOXWialnBlYdDZ6mLTH7wmfeg5ew==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB5405
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10043 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 bulkscore=0 malwarescore=0
 spamscore=0 suspectscore=0 adultscore=0 mlxlogscore=999 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2107120126
X-Proofpoint-GUID: RVNo-hh_KsFTtPb7Soz5sFwh4a6E-z-v
X-Proofpoint-ORIG-GUID: RVNo-hh_KsFTtPb7Soz5sFwh4a6E-z-v
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

On 7/12/21 7:48 AM, Matthew Wilcox wrote:
> On Wed, Jun 30, 2021 at 06:48:19PM -0700, Andrew Morton wrote:
>> From: Mina Almasry <almasrymina@google.com>
>> Subject: mm, hugetlb: fix racy resv_huge_pages underflow on UFFDIO_COPY
>>
>> On UFFDIO_COPY, if we fail to copy the page contents while holding the
>> hugetlb_fault_mutex, we will drop the mutex and return to the caller after
>> allocating a page that consumed a reservation.  In this case there may be
>> a fault that double consumes the reservation.  To handle this, we free the
>> allocated page, fix the reservations, and allocate a temporary hugetlb
>> page and return that to the caller.  When the caller does the copy outside
>> of the lock, we again check the cache, and allocate a page consuming the
>> reservation, and copy over the contents.
> 
> But you only copy over the contents *IF* CONFIG_MIGRATION is enabled!
> Now, maybe there aren't many configs out there that enable HUGETLBFS
> and disable MIGRATION, but this is sloppy.
> 

Thanks Matthew!

Not copying the contents is also a security exposure.  We rely on copying
the contents to clear the page's previous contents.

I suggested using copy_huge_page here as a previous version of the patch
replicated the code.  The NULL function slipped by me when reviewing.
Perhaps it would be best to move those copy_huge_page routines to
huge_memory.c as it is used by both THP and hugetlbfs.

Mina, can you look into fixing this?
-- 
Mike Kravetz
