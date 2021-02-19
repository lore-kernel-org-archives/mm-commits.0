Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.2 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 06E65C433E0
	for <mm-commits@archiver.kernel.org>; Fri, 19 Feb 2021 20:05:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BE31F64E38
	for <mm-commits@archiver.kernel.org>; Fri, 19 Feb 2021 20:05:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229515AbhBSUF2 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 19 Feb 2021 15:05:28 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:54542 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230088AbhBSUF1 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 19 Feb 2021 15:05:27 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 11JK4cne151256;
        Fri, 19 Feb 2021 20:04:38 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=G/4B8WlExRK1X5OdHW+BbAv00JQV5Mzmnl3OnPMYPfk=;
 b=iXo4onZhFCDiNVknZV63FdNEOwT3bN0IZE6MchXtF09KIk2e2UIaFyiTH7438AW6ko3/
 fj2NZXlMrYof8qTLiPK2yT0krVDKiwYY0b7LUZPV9QHEdQ8HzV9FrPF/QIE5L+VLBUtl
 KWM9kHyki4rNjbJbdW4AYb7BWqt1ByLYIjgTStZLy8ibQlIXwKhPwk7U9gYw9N7wwkCH
 l/bhkhEQobzSruwbGhcm10IOCaWHEw6BJhfCtynH0SwYLx9eeSsfc1My4xVTMFn64K4W
 q5R5l9T2Ux9naaZCr6N22DOVG9Lx/fy6fzwgqOlUqaz8Uypa6rLddY/Y9604uCXT+SUG DA== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2120.oracle.com with ESMTP id 36p7dntkd0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 19 Feb 2021 20:04:38 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 11JK0a7C004074;
        Fri, 19 Feb 2021 20:04:37 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2172.outbound.protection.outlook.com [104.47.55.172])
        by aserp3030.oracle.com with ESMTP id 36prbshngj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 19 Feb 2021 20:04:37 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VL6HCM2MPbxumqiMJV6x8A39jkAnqnRox1uelGMMn1mSXcWEAX3cYmO58QpI7M1NjsDdW/262RhlzpH4USvuT9EvjwLoWfH6o1KNShlq1tQzEYyjhG/YFf3FlwIN+aAI41d2vtJeCpMMGQEkl5qlADhVwAl75YYEN8tRocuCFWoBGOjAQzhdQixoIsiH/rT2XyWPF8shF9e/r8iJiuN7xwVrZFBQs4ESfARlya7Me46HhWPPtsLdBxbtwLWBbuhIdLceVJKzaj7jVZurvlWOgMeMxSTrTyl6FGo46/jrdmcElRXpi/DCmEyy+Mz0FyrbHxJJCeGUV8HLoYBEXdb2RA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=G/4B8WlExRK1X5OdHW+BbAv00JQV5Mzmnl3OnPMYPfk=;
 b=nCOrsumrqjFL4SnuUJSbIAdkcdMP/p/McaFyWAkgfXQumFHTI+B266S9kjw/u15cYjZRp65xy+ZMOhO3Q8Gom4y1laDTaTXKmNvSbctE7Ovk+wXD0QFl8TXbo+36b01I5U57InLxso+aRNza2/p+z8ZPodPne1zebCIo40NNatWKOwAUrgJNkFuNmeMc1lGJVPU5Lfio723MPngfx63+AgMkLHuvHjlqhKH3vXjxwMHmg9yzkLIBIjUwJrpwHSQ/179af/xMdmZgQsBnwx0MLqhdq+zhQywjuAE1L6bjYSBkBThaDN4lG+u0ItMaUhlzDcrP3y7u7jC8XIbjWQjRFQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=G/4B8WlExRK1X5OdHW+BbAv00JQV5Mzmnl3OnPMYPfk=;
 b=d9O2+n2onBgJlODieyxhXb1U2rwWt10jPxLKX5/NkaJS+lL/EWz05I8Mmpm93/sSX7keiqMRw2VoZ1couNwNox6sWWTQjJgP9/PNI7tzhvJRJDtmTNXrcD4nUVSX8bvnk/fNP8Zc1zVEvUIOKeK1ya8c+T81AXqMOc9OHsMhQyA=
Authentication-Results: huawei.com; dkim=none (message not signed)
 header.d=none;huawei.com; dmarc=none action=none header.from=oracle.com;
Received: from DM6PR10MB4201.namprd10.prod.outlook.com (2603:10b6:5:216::10)
 by DM6PR10MB3131.namprd10.prod.outlook.com (2603:10b6:5:1a1::32) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3846.25; Fri, 19 Feb
 2021 20:04:35 +0000
Received: from DM6PR10MB4201.namprd10.prod.outlook.com
 ([fe80::ad89:6caa:4481:b733]) by DM6PR10MB4201.namprd10.prod.outlook.com
 ([fe80::ad89:6caa:4481:b733%3]) with mapi id 15.20.3846.042; Fri, 19 Feb 2021
 20:04:35 +0000
Subject: Re: +
 mm-hugetlb-suppress-wrong-warning-info-when-alloc-gigantic-page.patch added
 to -mm tree
To:     Roman Gushchin <guro@fb.com>, akpm@linux-foundation.org
Cc:     mm-commits@vger.kernel.org, chenwandun@huawei.com
References: <20210219183717.02Po6%akpm@linux-foundation.org>
 <YDAVzRNTpFTXGR93@carbon.dhcp.thefacebook.com>
From:   Mike Kravetz <mike.kravetz@oracle.com>
Message-ID: <c6a1e494-ae82-5a71-d799-34f0857ecb7c@oracle.com>
Date:   Fri, 19 Feb 2021 12:04:32 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.1
In-Reply-To: <YDAVzRNTpFTXGR93@carbon.dhcp.thefacebook.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [50.38.35.18]
X-ClientProxiedBy: CO2PR04CA0167.namprd04.prod.outlook.com
 (2603:10b6:104:4::21) To DM6PR10MB4201.namprd10.prod.outlook.com
 (2603:10b6:5:216::10)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.2.112] (50.38.35.18) by CO2PR04CA0167.namprd04.prod.outlook.com (2603:10b6:104:4::21) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3868.27 via Frontend Transport; Fri, 19 Feb 2021 20:04:34 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c6fecdad-25a0-436b-3a9a-08d8d511941f
X-MS-TrafficTypeDiagnostic: DM6PR10MB3131:
X-Microsoft-Antispam-PRVS: <DM6PR10MB3131E0671F28F497C5B89076E2849@DM6PR10MB3131.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:357;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: vJFEYg70s1ut1gS8o1I8X0cD3m5EQ2VZwysa/pMdiYMhgGJ/7fDtpqkSFyja/LMrQ+nj5XN0kbewpgtMOCemdpOxt+KLeLziRGQN8hjUXFlthRhaxYpNUj6UXm98C6msu3ZQ1KZ/Xq4KABNpzAurA2sRLoHp3QVyQQEgQfcu1ygE2Z6QjNpyU57z0yBpJeOq2ee/vg5wsF7lEerxlTt9SEYDNGGIjm2NK6pxg1HO7Pd3nXw09+k9LS9b/mrLeSdsG0FGkkUuMPUJH1d5t+FE8Bb4XrdiiW3aJkapx7b7Vicu/E7LiziR0bqqXsZlwPC2UrqTQcM1So8KDZeCfT8pMG0Cn5xQA2bjAD5+RihoAghacEoDMm7FA3uv+lVC310YbIIQXR5pBL7tg3QI2TW+VEhyJHp+vpu3BA9ZYefN1xLQ7omi6slLxZf3bm1OGXD9E8sDgdLKV0OaO/dT0ltOK/nYLAMXuDYEP8o+BaMH++yIlfHOdl7oLc4FUMdf2hhSOC64D6sUNC8jt4RKMPpXDTIBZYhg+qvgW2TMFywCUoNPkjjP7XzjEtisAYGW0WCEGWMkdPH4SbFCRRcdc072LE/a7OyQ9qxlZA6qbYd/4AwvMUNDPCBFbpYXRaJ75aDmBg19L4BNUo1SriYzLZJfeNF89Mezoj8u8N/de+V1vTvjRo1o5ljZMpAbZ5HOSZfc
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB4201.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(346002)(396003)(376002)(136003)(366004)(16576012)(316002)(53546011)(36756003)(31686004)(2906002)(6486002)(2616005)(44832011)(8936002)(86362001)(31696002)(16526019)(26005)(186003)(5660300002)(956004)(966005)(8676002)(478600001)(66476007)(66556008)(66946007)(4326008)(83380400001)(52116002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?Vi9JNWJseTA4SW1oRUZQT2crM2FVcjlnNHJkK3M3OWFmV3EzRmpWVnJKNkhH?=
 =?utf-8?B?MTBsQTBPYm1POWwwN3piR1JPdWJLcWVmVTBFTGErS1BhWjJKSjVjbGdNVEZa?=
 =?utf-8?B?SzBnRUF0ZVhVY2VpRTd6Rk5RNHlGWnJwVW1ISm1UbzBJTzZ5Y2QybkpPaFlC?=
 =?utf-8?B?RFRMZTlNUGdvbXNvLzZVTXNibFFzZ1g5c3VoUlBNQlJuK2FlYnlERVVuSXc1?=
 =?utf-8?B?WnkzM0d1RDBrdGpNaHZIcWw2cSt0ZTR4Qy9JVm9LelYwOGxxMkxWMThKRmxT?=
 =?utf-8?B?ZmNJSFp1aVY5Z1Q2KzhmRWl1NC9PY2FwNjZXUlZVZk9tcCtuVlJWcTNIWDNr?=
 =?utf-8?B?eFNTR3JYdHpuMkNXOTA5U0xhNVE3SG8yZkdNQVNrRlVoYlZpQk1WUTdXcWV2?=
 =?utf-8?B?VE9UbklRdmZHdVY2R3BDa1JWNnpyay9PVi9FWU1OemI1MUZNTjBZOFNZNWVI?=
 =?utf-8?B?TE00UWtwWFo1eUlTUkJOY3IyeitWTzdBQ0YyN0tNWEI2WU9LWVMwTDRVVng4?=
 =?utf-8?B?SUx6YjVtUFh5MlJHZXBvOERaMXlsUEFvYUYxL0pYc0RUcDh5SWdCS3MxUFBQ?=
 =?utf-8?B?UWNaUncxRkJlNGlUYjNINWplc29laVljN1h6SUZlM1dBcWxOK2d6Ti9CTnBJ?=
 =?utf-8?B?eVZlSlZoMytuS2VFcGh2YWVxb00rZkFKZXBiN1dET0RQcWluTmFua3NFbkZv?=
 =?utf-8?B?d2NTK2c4eTdMMUNGWTJrNDlXRklDd0hidjNkT0Jqc0xyYlRpdkVQeDljNVhB?=
 =?utf-8?B?b1JSYnMwSDE5MUIrczNVeU4rcTFTSU51VU13dThwUlBFV0RPcnl0bG9TRk9a?=
 =?utf-8?B?aTIvbVBWNFBNa3d1NVpBR045RlpnbEJOMWVPZWxtWnJFZHo2ZkJlYlQ5dS8v?=
 =?utf-8?B?ZEhBc2FVTENBWFVSTmxSZ2xSR2FzYW4yOEMrNGkyelRLRTdweXVlUXE2N2Iw?=
 =?utf-8?B?bG9kK2ZSeGNGRVJkNE1zb1JOZmVmbytXMEdOK3EvcmNlWEVSSTRsQXlkV0JZ?=
 =?utf-8?B?TjcvazN6blV3RXU4eVUwdFpId0p6M01BcDhlSEFISUlTbEE2RWFUMlRHZm95?=
 =?utf-8?B?aWVWbjhLSG9NS2x3R1B5aWtMRk5VZk5VOUZ1bFFUZVBvTnZsZkN1YlUrbm1j?=
 =?utf-8?B?L0l6U3J0RUFVd25FOGt2bGN1aEtESCtWUVFXME5nSEx5dkxKTjEzT3NYTEcx?=
 =?utf-8?B?cG5CZzJsR09CU2RXVnRxSzAveVkyWVN6V054YStGK2N5d25kTHY2ZXdMOUNi?=
 =?utf-8?B?eHM2eGpLWXVYY0lOeERZZ0gzTzgvT0M1N3hGdlV6SkVEZDVZSUFPQTRDV2RX?=
 =?utf-8?B?amViQVFZOE9Sd1VMV3E3czgrRW40blpZRUNKSzZNNEdUa2xCVWVXUjB5Q2lZ?=
 =?utf-8?B?QTlBK2xZZHBvaTNIajFMSzdNOVFMVmxjdGxldFFQem9CUDB4YUdjZ1NGdStP?=
 =?utf-8?B?SUdRZkY2dEowb001QklEU3o0MWI2ZVBodXo1ZFY2UXZqUmNQczhuZ3I0TTJU?=
 =?utf-8?B?U0k1QldQUC9HWlBGODhaNjNNZVFaaCtqREY3a0RYRmIzajRqbVlVbjN2SXU2?=
 =?utf-8?B?SE5mL0JQZFJNWW5Bbi9tWVpMaEZ1NXNvM3NEOTdPYi9hZzJSZDVGNzRxNVVT?=
 =?utf-8?B?RWM0U2s1R1JJcVRFK0lTcTFPT00vcG1nVEhLaXc5Y3REemYyc0tQNzQ3aFVs?=
 =?utf-8?B?Ykdrc3g0M2xBMTkreXltQ0EzdldQdVFKYnNIV2pXdXc5UUZXYThoSFowVHFs?=
 =?utf-8?Q?8mo5yWjlVjYCV0l3tYZmoLTvuDFQHM6guMkVfC/?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c6fecdad-25a0-436b-3a9a-08d8d511941f
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB4201.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Feb 2021 20:04:35.0076
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 7dZyMM3KXeJyboC4POu4Wbjf7GOR4AaK+8yradS8+O1YtjZyhzJ4vQYr4hRCpmCpq2UCPf+Tt/cy78Q1/m1jpQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR10MB3131
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9900 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 spamscore=0 mlxscore=0
 phishscore=0 adultscore=0 bulkscore=0 mlxlogscore=999 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2102190159
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9900 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 suspectscore=0 mlxscore=0
 phishscore=0 spamscore=0 adultscore=0 clxscore=1011 impostorscore=0
 priorityscore=1501 lowpriorityscore=0 malwarescore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2102190160
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

On 2/19/21 11:47 AM, Roman Gushchin wrote:
> On Fri, Feb 19, 2021 at 10:37:17AM -0800, Andrew Morton wrote:
>>
>> The patch titled
>>      Subject: mm/hugetlb: suppress wrong warning info when alloc gigantic page
>> has been added to the -mm tree.  Its filename is
>>      mm-hugetlb-suppress-wrong-warning-info-when-alloc-gigantic-page.patch
>>
>> This patch should soon appear at
>>     https://ozlabs.org/~akpm/mmots/broken-out/mm-hugetlb-suppress-wrong-warning-info-when-alloc-gigantic-page.patch 
>> and later at
>>     https://ozlabs.org/~akpm/mmotm/broken-out/mm-hugetlb-suppress-wrong-warning-info-when-alloc-gigantic-page.patch 
>>
>> Before you just go and hit "reply", please:
>>    a) Consider who else should be cc'ed
>>    b) Prefer to cc a suitable mailing list as well
>>    c) Ideally: find the original patch on the mailing list and do a
>>       reply-to-all to that, adding suitable additional cc's
>>
>> *** Remember to use Documentation/process/submit-checklist.rst when testing your code ***
>>
>> The -mm tree is included into linux-next and is updated
>> there every 3-4 working days
>>
>> ------------------------------------------------------
>> From: Chen Wandun <chenwandun@huawei.com>
>> Subject: mm/hugetlb: suppress wrong warning info when alloc gigantic page
>>
>> If hugetlb_cma is enabled, it will skip boot time allocation when
>> allocating gigantic page, that doesn't means allocation failure, so
>> suppress this warning info.
>>
>> Link: https://lkml.kernel.org/r/20210219123909.13130-1-chenwandun@huawei.com
>> Fixes: cf11e85fc08c ("mm: hugetlb: optionally allocate gigantic hugepages using cma")
>> Signed-off-by: Chen Wandun <chenwandun@huawei.com>
>> Cc: Roman Gushchin <guro@fb.com>
>> Cc: Mike Kravetz <mike.kravetz@oracle.com>
>> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> 
> Acked-by: Roman Gushchin <guro@fb.com>
> 
> Thanks!


Roman, I was under the impression that this warning provided some value?

It will only be logged if user asks for both preallocation and cma reservation
on the command line.  In this case, we ignore the parameter requesting
preallocation.  It seems reasonable that we log a warning if dropping a
user requested parameter.

-- 
Mike Kravetz
