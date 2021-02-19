Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.2 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 17727C433E0
	for <mm-commits@archiver.kernel.org>; Fri, 19 Feb 2021 21:20:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B90D364E38
	for <mm-commits@archiver.kernel.org>; Fri, 19 Feb 2021 21:20:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229734AbhBSVUO (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 19 Feb 2021 16:20:14 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:44746 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229771AbhBSVUM (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 19 Feb 2021 16:20:12 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 11JLAZBj043975;
        Fri, 19 Feb 2021 21:19:23 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=q8YnFtqIcbubEh0D4FjkE5EcA8gxEIQmbQIfdhA5lLY=;
 b=qKinAoXyRZF4V3uqHYpVu5K9/qIOdGWGvPYp93tiV95onr6zDE13vIHrIEBLvx1gwCBk
 N3TkpomTwl6gGaSXtk0JpXMV/9ycvqOxfZv8MiJvVXfJeyY+bYjFWQMEgYY73Y2VCAGn
 aMV3ILmUr5GnKakCBowbYhCp8kfPlryoKwu72PUnlmZVT44FIh544oTY1rQ7lrUZuU1/
 dag55gN1bJoFeyfhw6G8LKh7Ka2nc+/wUOerzxbsj4lT9UvfF5th6fn/x60SWEbO22gu
 JU2w0PAunrVOb0uhlLnzHbZZMewrpYckeMosXTXgIXNLNqOeHJ3QUB1jCXv9zJcVqlPt nQ== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2130.oracle.com with ESMTP id 36p66raus0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 19 Feb 2021 21:19:23 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 11JLAWpY091629;
        Fri, 19 Feb 2021 21:19:22 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2172.outbound.protection.outlook.com [104.47.57.172])
        by aserp3030.oracle.com with ESMTP id 36prbskwdh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 19 Feb 2021 21:19:22 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VmtMdx7Ep0bFtI0UC67ivQuTLIO1xumObe1rhPYEF361+9yTdCLKg+/w4/PtyUjTw7OPK8BfUQwTvtonXDPbo9Xy7CfUhJBAfB71iK17e10hOFW/gKs2xWvrCVmjw88eCUj+3R8Qa/nMp9PdT39uAlWKLnaOW69nmQ5Z+Bpp7b7tfLMWvHRETo9fjb2YRmDEE0hWNx4q3EhI2oRIg5mYseYxlidXRJlWz7jQlSBiCphoFUTjgb8zs6D8dF70fQ2l2Dsk+JoBuFllh2AU4xJq/Om/affn0T44NPgu6ZU1fiJLoRh+gwfdrjcKFqjGMmIWNJ1juHbEUpE97JKi+okQ0Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=q8YnFtqIcbubEh0D4FjkE5EcA8gxEIQmbQIfdhA5lLY=;
 b=SArgrny7xHvOUzZ9MsAygedG/96sB+ctiB8t5jy9JsugVj9BDTjMKNpF7tnTYHZQ/U3CeA/fA6OdZ18w2J8dgHvb5iiOogUUlXjurAC6fGiJFeq7/s2DNlS4wpEd3pCnuBZMNYODrrd707Bno2jn+dWAw2WTp2TdVlKk8X/9QOlgoYnlEDt5rueBkJZYmYUJRq5oyjuBZD14jtgcGGETVpiONaYIR1FlGl2gJG3MKalWOuU2DP+bE6jjTLCoiG/5BOWg8mocoRGGcSxG6C20w4L4HsLWf4cS/i/fRYNhKpN2RXrUGCudJunbVXELhUsxsHONgkhYPWvzcpdl7+9gRg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=q8YnFtqIcbubEh0D4FjkE5EcA8gxEIQmbQIfdhA5lLY=;
 b=vkGrvDcVOdY4vUfiEoBVPin2q+mIc76RQ3PG4aEKVoZqbigjd5SqJRuuOQcqC15Q+W3GqwXc7eE4fNhocLDPI8K1v2XgPMQsuuvCiRX6li1wTSnzdWPhNvl9Y/tyHkO6NV6/52pphghhKmDYs9BLPAKGL0/zkMDw9eTFP0EyeLo=
Authentication-Results: huawei.com; dkim=none (message not signed)
 header.d=none;huawei.com; dmarc=none action=none header.from=oracle.com;
Received: from DM6PR10MB4201.namprd10.prod.outlook.com (2603:10b6:5:216::10)
 by DM6PR10MB3211.namprd10.prod.outlook.com (2603:10b6:5:1a6::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3846.26; Fri, 19 Feb
 2021 21:19:20 +0000
Received: from DM6PR10MB4201.namprd10.prod.outlook.com
 ([fe80::ad89:6caa:4481:b733]) by DM6PR10MB4201.namprd10.prod.outlook.com
 ([fe80::ad89:6caa:4481:b733%3]) with mapi id 15.20.3846.042; Fri, 19 Feb 2021
 21:19:20 +0000
Subject: Re: +
 mm-hugetlb-suppress-wrong-warning-info-when-alloc-gigantic-page.patch added
 to -mm tree
To:     Roman Gushchin <guro@fb.com>
Cc:     akpm@linux-foundation.org, mm-commits@vger.kernel.org,
        chenwandun@huawei.com
References: <20210219183717.02Po6%akpm@linux-foundation.org>
 <YDAVzRNTpFTXGR93@carbon.dhcp.thefacebook.com>
 <c6a1e494-ae82-5a71-d799-34f0857ecb7c@oracle.com>
 <YDAbeDsG7GhV6s6B@carbon.dhcp.thefacebook.com>
From:   Mike Kravetz <mike.kravetz@oracle.com>
Message-ID: <944f8378-d2bb-9579-5556-d95d3f95749b@oracle.com>
Date:   Fri, 19 Feb 2021 13:19:17 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.1
In-Reply-To: <YDAbeDsG7GhV6s6B@carbon.dhcp.thefacebook.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [50.38.35.18]
X-ClientProxiedBy: CO2PR05CA0086.namprd05.prod.outlook.com
 (2603:10b6:104:1::12) To DM6PR10MB4201.namprd10.prod.outlook.com
 (2603:10b6:5:216::10)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.2.112] (50.38.35.18) by CO2PR05CA0086.namprd05.prod.outlook.com (2603:10b6:104:1::12) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3890.11 via Frontend Transport; Fri, 19 Feb 2021 21:19:20 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 81feb6eb-12a8-4e8d-b4ef-08d8d51c059d
X-MS-TrafficTypeDiagnostic: DM6PR10MB3211:
X-Microsoft-Antispam-PRVS: <DM6PR10MB3211E4ADFB095C56FCAD2E92E2849@DM6PR10MB3211.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:125;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: SWkkBKBhCLSVVnUzD+zixGiqbOcl1GpUUmVBQol1GxTmR6MYpFxnSEJRsYAB8wPMK6tSj45p8xcjziMVyBP3FQXib0BcLnGBrB5ADcEjHa/5mj0rNz+WR0KDESb3JShXoNOPdg+mtsr2OTME+Y3VhP4d3840kGXVL8Km+EbzElPEurTjeC+sJbi1bS5oNXQjB5RF2wza914N8pj83illWieS2ydDV2sb2fQ6LqyBXT6lgVeh2d0DJPc2+sQ9gkCT2eHJMW6Y/WR8+dNhSLhPV95yTfzlXAubrAr3KxRAryT5JM+tbJYu9Es1665f/Bk8LgmatHFsN9WpH9aib+LfS/sR41hpB1+elRkXC+oZWieUfhvSIv9RqWRGvz04kb0saBv1AyvhKYeH556scQERbvaGCP0lgUjeDgB476C9J3As5TOoBSb2ritcKI4zWGH5AZ3eTIU/KDadnEIpMY67WK1CtisUseohX0N7vV0qnoI+AyVBfjQGONbdtvfy+KUHg/CHGtlA+XkQ+fBJeJn4pqEm1O8cxYFcZxCikwq0Q929gza64XSHbb867zn8IPHESi0iYZDzXqs/91c/n9xfi5ZEKi1IDtD1LikGn9nihMv8b2XsBHb4vbShbb4/cAaOkpJ24z/IVMdvLanDc0xD9y9ZQETPdEt5FOwBMkzT9D6M+9DSnCGnemOgbH8AwWLq
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB4201.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(366004)(136003)(376002)(396003)(346002)(8676002)(956004)(316002)(44832011)(26005)(83380400001)(4326008)(31686004)(31696002)(16526019)(16576012)(186003)(66556008)(66476007)(478600001)(2616005)(66946007)(36756003)(6486002)(5660300002)(2906002)(6666004)(966005)(53546011)(52116002)(86362001)(8936002)(6916009)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?b2RuZ2ZXZURhZlJZR0cya3FOamNobFVUZ0hJN3hZNEhuMkRsdS9nbVhwa01p?=
 =?utf-8?B?WE1xQWpZL3BIUU0zVUVKQmFPNllQRmV5NVZBeEQ2MXd6emV4cWNCQ0hMcWFH?=
 =?utf-8?B?TitVTXdYMlZITTRBcUVKc3ZiQmZUWVZwSDRKMzlJMmFFYkI1alVWOWZxZXo2?=
 =?utf-8?B?VUw0WFQvRlZHMlNMcXlrdmRueEk4VGNJZFNtQ25PK2JCYlFQYXlxZjEvS2Jm?=
 =?utf-8?B?cFpMS09zQkFYdlFlOEo0RUc4ckVLaERhb1hnOUxScU1teFM3cFNRT1lTOXdq?=
 =?utf-8?B?Ujc4bHZyT1JSMmFUeXRCazQrMlluZCtsRmtyMjVhM0p0cG9wVnlCNnlRb092?=
 =?utf-8?B?VVhJMHFtRzNNcnhuajdZYXlvRHBBWXFPR0s2TWc2WUpHeGd0aVNTdjlkOGh1?=
 =?utf-8?B?aEZ6eVlQbERUNHh3OVpVdWVNMjRGOFlkR1NwKzdickx1UklSUUZrM04ySHNn?=
 =?utf-8?B?ZUpTTWw5dGZndHFmeDl3KzBtbkFWQ04rclVJZDlIaURubjU2S3lwUENDNGd0?=
 =?utf-8?B?UmtuSVhwYjBSeW1CZUtoaENBb0wwdHQ1TUN6S2pZTTMwRG96Y05wVUF4MTJF?=
 =?utf-8?B?Mjl5aDcybEYvUEtscDNkd3EvZ0UranU3UkorYTRibzJydDY4bkk0clZjazZ6?=
 =?utf-8?B?UWYvMElhd2dQSldVaFlmMWVmUWdJanRZeXF6VlBjdVlnTkpRQ3VTTGZYSmkx?=
 =?utf-8?B?V3BIaVJHOUhRcS9keG1yakdWSzJsVGprTGg5WHZmNXhjUG14REtxZGlHSStw?=
 =?utf-8?B?TEtMSXFsajFOUzZHdWtka1ptNDJZOGdsQWtiZWh6U2J4TERweHRldC8xNFp0?=
 =?utf-8?B?blFqM1NqYWVLZ1k0dU5ZZkRiQ2xqSFRpRzJMUklyTEhJZ0F4TjB5S0dLdkQw?=
 =?utf-8?B?Q1JIbTg1RVhpWU0rbkpoT3ljSFZocmU4czh3ZU1DUVc5QkpjNnNZTHZkMnhE?=
 =?utf-8?B?UG1SeFFXaEkva1pNSnNiRlNKMnhrMDNjNlFSdXhFRGlYQ2RkR0tUQ2VnTGRI?=
 =?utf-8?B?eGtUWnFMNjhEVTBKN3pjVWNMdGQ3TVdBZElQNmRJK1JSQkFWZ3dsekRnTVd5?=
 =?utf-8?B?d2lBeUtEZXNjSXpqYzBCZjM2ZDE3RWZOUmRwTHZHMk1kVE5tSHRsNklxVm5R?=
 =?utf-8?B?cDFrbXRFWk5tbXZ4dFhHS2llWUFSQkxHQ21aRCtSck1kNFNkbVFyVGZBaDdh?=
 =?utf-8?B?SU50dlNtZWVCb1IxendSSWxjWW51dnJ2Z0kxcDZhaDhOYis2UVRaekV2MmZt?=
 =?utf-8?B?RklxRktMdTFRZndBaTJuWUxFNnhoSmdEOHFsak9tTUtSL2pzR1NES2JDajZW?=
 =?utf-8?B?TllsYUNCRWFvNUpXZHJZdUkzSk9McEQrMHlVQ29HMUNxZDRuaWlMMW9GUklC?=
 =?utf-8?B?eWoxN0ZzWlpnU014eGRoeVVCVm1PcENQd3A1UnQ2QXRlWDB0MFB5cHJ5K0E2?=
 =?utf-8?B?MzJQQUJZd3JkMTFlaDZUSERpK0FHMnJkTUtNekZyL1JzM0hsLzMzaVJ0WWJM?=
 =?utf-8?B?SVh4RFdIUXVuS0hHYmVzeWFuNHVlZVFiYk1DekgxWFBvbGM4T1RtN2x0cHBT?=
 =?utf-8?B?UHNGSS9TNWJRamJSb2N5Qlo3b0xoeDg5SktEeWswQ2RBMW9nNDZ1eGt2QUNk?=
 =?utf-8?B?VnB5NlBmZVVSVFhrbXF5RHNFN3pNOXhlSjE5eVREbSswcVFKWVc2d3ljOXJH?=
 =?utf-8?B?SVhFdmdJMjMyYU5BRzhWekRLOXp2UTJlbnl3MHExNG5HeGw0eU52Slp2NEVw?=
 =?utf-8?Q?xZwsAPFCVKeNRLRl1jvc2JXYvMB/+pVpeAIUU+X?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 81feb6eb-12a8-4e8d-b4ef-08d8d51c059d
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB4201.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Feb 2021 21:19:20.4440
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0BKsxbVD5ZqRSL/dR2CCFtldl7kofMVui0mbTksViYT46vTHqcpfukIzlfGISKzKBvqTgYqyPeHOfBqSoQi5Eg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR10MB3211
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9900 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 spamscore=0 mlxscore=0
 phishscore=0 adultscore=0 bulkscore=0 mlxlogscore=999 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2102190171
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9900 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 suspectscore=0
 impostorscore=0 priorityscore=1501 clxscore=1015 spamscore=0 mlxscore=0
 phishscore=0 malwarescore=0 bulkscore=0 adultscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2102190171
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

On 2/19/21 12:11 PM, Roman Gushchin wrote:
> On Fri, Feb 19, 2021 at 12:04:32PM -0800, Mike Kravetz wrote:
>> On 2/19/21 11:47 AM, Roman Gushchin wrote:
>>> On Fri, Feb 19, 2021 at 10:37:17AM -0800, Andrew Morton wrote:
>>>>
>>>> The patch titled
>>>>      Subject: mm/hugetlb: suppress wrong warning info when alloc gigantic page
>>>> has been added to the -mm tree.  Its filename is
>>>>      mm-hugetlb-suppress-wrong-warning-info-when-alloc-gigantic-page.patch
>>>>
>>>> This patch should soon appear at
>>>>     https://ozlabs.org/~akpm/mmots/broken-out/mm-hugetlb-suppress-wrong-warning-info-when-alloc-gigantic-page.patch  
>>>> and later at
>>>>     https://ozlabs.org/~akpm/mmotm/broken-out/mm-hugetlb-suppress-wrong-warning-info-when-alloc-gigantic-page.patch  
>>>>
>>>> Before you just go and hit "reply", please:
>>>>    a) Consider who else should be cc'ed
>>>>    b) Prefer to cc a suitable mailing list as well
>>>>    c) Ideally: find the original patch on the mailing list and do a
>>>>       reply-to-all to that, adding suitable additional cc's
>>>>
>>>> *** Remember to use Documentation/process/submit-checklist.rst when testing your code ***
>>>>
>>>> The -mm tree is included into linux-next and is updated
>>>> there every 3-4 working days
>>>>
>>>> ------------------------------------------------------
>>>> From: Chen Wandun <chenwandun@huawei.com>
>>>> Subject: mm/hugetlb: suppress wrong warning info when alloc gigantic page
>>>>
>>>> If hugetlb_cma is enabled, it will skip boot time allocation when
>>>> allocating gigantic page, that doesn't means allocation failure, so
>>>> suppress this warning info.
>>>>
>>>> Link: https://lkml.kernel.org/r/20210219123909.13130-1-chenwandun@huawei.com
>>>> Fixes: cf11e85fc08c ("mm: hugetlb: optionally allocate gigantic hugepages using cma")
>>>> Signed-off-by: Chen Wandun <chenwandun@huawei.com>
>>>> Cc: Roman Gushchin <guro@fb.com>
>>>> Cc: Mike Kravetz <mike.kravetz@oracle.com>
>>>> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
>>>
>>> Acked-by: Roman Gushchin <guro@fb.com>
>>>
>>> Thank!s
>>
>>
>> Roman, I was under the impression that this warning provided some value?
>>
>> It will only be logged if user asks for both preallocation and cma reservation
>> on the command line.  In this case, we ignore the parameter requesting
>> preallocation.  It seems reasonable that we log a warning if dropping a
>> user requested parameter.
> 
> There are two warnings:
> "HugeTLB: hugetlb_cma is enabled, skip boot time allocation\n" and
> "HugeTLB: allocating %lu of page size %s failed.  Only allocated %lu hugepages.\n"
> 
> The point of this patch is to skip printing the second one if the first one is printed.
> It makes sense to me.
> 
> Thanks!

Thanks you!

My bad for not taking a closer look.

-- 
Mike Kravetz
