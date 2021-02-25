Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EA7B4C433E0
	for <mm-commits@archiver.kernel.org>; Thu, 25 Feb 2021 07:11:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A1BBA64E85
	for <mm-commits@archiver.kernel.org>; Thu, 25 Feb 2021 07:11:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232600AbhBYHLi (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 25 Feb 2021 02:11:38 -0500
Received: from aserp2130.oracle.com ([141.146.126.79]:41268 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229529AbhBYHJe (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 25 Feb 2021 02:09:34 -0500
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 11P75Tug061535;
        Thu, 25 Feb 2021 07:08:12 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=tzM2SGd7UK3rj2DgaUFpjfWS6Lw+ziM5hdUCvQP140k=;
 b=aHMjVOTCr1cM1mnmtyf0Q1zPMAMB77zZ0awoZ+u6p+CNEWW3LlrBCEAaRJgo9fotny+k
 RBGAN5NQnHU5iwvlIA0ZiHBSZ4NR93KwLpIMU22dFzUwzSz7JNO0AjAAbia+o5Hh4bXL
 rcJ83yvTr3YndyX3K3uXWN/2vy2X7f8dvzf33UaXnYz46yBUPTYZao+43gvq1DpLPtX8
 jpyZ5NioAAYFj/II66NxkP5Op1w9C1F6q0fLWNS1U9sYW9NPbahtyJA7Q5krEOE1nsZh
 0a9WdCec30TaMtiLylbyFBDC6iLOcaT1wh61dX3i3jRNEXeUa3zQjzUhYbHcCQ3qtGYg ig== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2130.oracle.com with ESMTP id 36vr627s5h-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 25 Feb 2021 07:08:12 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 11P74feC195500;
        Thu, 25 Feb 2021 07:08:12 GMT
Received: from nam04-bn8-obe.outbound.protection.outlook.com (mail-bn8nam08lp2045.outbound.protection.outlook.com [104.47.74.45])
        by aserp3020.oracle.com with ESMTP id 36ucb1p64d-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 25 Feb 2021 07:08:12 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Pi4vjBLfVaRQRrY0ePvTCDXDcvw3u9R45T5QJaWXLJemymRmul2XaaDRSZFsmaj7xkWMBdl3nk7WF+yVaTYp+pLyB5M9UueA9dwHg7s0U99ahgVTetmtKA/ZT0971mK26t1Iztf4GAK3qh3ReBRA/M9HO6CigK+6Z3/HzNvQfGFni4bZxrwwIkizK/ImpmCk1klzrK6+Kig156Ep4TnT0jnGp4kVxfr0bXjmZhTacLFt/SP6tBiGfhRBj0JTBjDz66m8XEJBEr1gzwG1zvWSl3NBuD5p7lUZl0LtoG71gZp6iVBLxcRcDFMwXPe45lyJ1o5LNhyKeCdsdaftaBEc9A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tzM2SGd7UK3rj2DgaUFpjfWS6Lw+ziM5hdUCvQP140k=;
 b=ibejiPsuXem7eXaGt9PAu36/hp7CPs8NUqn8UmfnAQwwYzWhaox//crx0P5W5QwEGaNgnHzy7ACcJ7BymiibezEahjtwzstKPnozqHcEXQrafkupYLcRyPHr8xYvWohDboYNqzOrqUeoYuCkF1nXfOXxBVpzzxvvOYibeIl8mzuGbHQ3RGArN/MQpdc7gYP+qGjSNALk2AjUmv+yHchQZuumS5hkfzUoVPwNkdW8WiHKDPBdSJVpnJFdxDJwqcgl9vetXGwEgSq3FcEkjTGu8h1tZPIOdCJon6Z7xMKUcPxbVkmymNn9+aXDWC+IZbqC8nLGSZaT2cTOcjulHHmGfg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tzM2SGd7UK3rj2DgaUFpjfWS6Lw+ziM5hdUCvQP140k=;
 b=ctuUPVppc0iy3S72Cq2VjdoVy2lP0VgY/rRglA4qWAzTpShFNYNRmKVRCl9fk8aD6vnNaeFyfh1W4A5V1jr2rV7k0ZK9b74pcGjj3jWhhvMoVTC4Nv5tu8ZGFrFIOtW81aE3RBOO+cJUYHC+HRxNR3Ja1nvTPmE/TAb4f7kH2MQ=
Authentication-Results: linux-foundation.org; dkim=none (message not signed)
 header.d=none;linux-foundation.org; dmarc=none action=none
 header.from=oracle.com;
Received: from CY4PR10MB2038.namprd10.prod.outlook.com (2603:10b6:903:122::20)
 by CY4PR10MB1959.namprd10.prod.outlook.com (2603:10b6:903:126::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3868.29; Thu, 25 Feb
 2021 07:08:09 +0000
Received: from CY4PR10MB2038.namprd10.prod.outlook.com
 ([fe80::842f:b854:7899:e759]) by CY4PR10MB2038.namprd10.prod.outlook.com
 ([fe80::842f:b854:7899:e759%8]) with mapi id 15.20.3868.033; Thu, 25 Feb 2021
 07:08:09 +0000
Subject: Re: [patch 014/173] mm, tracing: record slab name for
 kmem_cache_free()
To:     Steven Rostedt <rostedt@goodmis.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Joe Perches <joe@perches.com>
Cc:     cl@linux.com, iamjoonsoo.kim@lge.com, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, paulmck@linux.vnet.ibm.com,
        penberg@kernel.org, rientjes@google.com,
        torvalds@linux-foundation.org
References: <20210224115824.1e289a6895087f10c41dd8d6@linux-foundation.org>
 <20210224200055.U7Xz47kX5%akpm@linux-foundation.org>
 <20210224203708.4489755a@oasis.local.home>
 <20210224210740.73273c7a@oasis.local.home>
From:   Jacob Wen <jian.w.wen@oracle.com>
Message-ID: <5a0b6fb4-6efd-e391-45fa-cd188f181d5d@oracle.com>
Date:   Thu, 25 Feb 2021 15:07:50 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
In-Reply-To: <20210224210740.73273c7a@oasis.local.home>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Originating-IP: [138.3.206.30]
X-ClientProxiedBy: TYBP286CA0019.JPNP286.PROD.OUTLOOK.COM
 (2603:1096:404:ce::31) To CY4PR10MB2038.namprd10.prod.outlook.com
 (2603:10b6:903:122::20)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [10.191.25.30] (138.3.206.30) by TYBP286CA0019.JPNP286.PROD.OUTLOOK.COM (2603:1096:404:ce::31) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3890.20 via Frontend Transport; Thu, 25 Feb 2021 07:08:06 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 9ba7c34e-30ef-4f5a-8711-08d8d95c1b66
X-MS-TrafficTypeDiagnostic: CY4PR10MB1959:
X-Microsoft-Antispam-PRVS: <CY4PR10MB19598D9A5BCD437913568E76A49E9@CY4PR10MB1959.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:983;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 2eVBh5pwso4bI+/lqD5d/Bs8vB8G7+9Z5DWqMtADGttiQPo62k4/zNFfryuZeWjsmHhVncmsBy5lSp8nIzdA/vmJFwjYPmkNCYPqUISeuUVeOOT4bI/ZZWoSsEfqglKh5UapcFTwOWuvGdVmnRCjl+by9GI069EzRP6cnpg44jc5YqTY2D6McXNygSf+DE5gNNnwKmKZVWmcxaJhBdvjRsdt7hWjXCiUfB9uh8RDVJYJesMfLlktqDecRQ02T8mvSLfsg6WuI+0lTsybGLyl4d6l22I03eTMefXRPnGF3A+SBu58lELnZhORq7GlPFXzD+lhLgfLBFGr3VV0maBYu9OAoW+i1I8CT7CtmNHjvTA8mI1F4dERSqrXMI3+JCX4j+hJZh3SmvJpeOEccon2Tc2f11VNsZtAlj1x/P2fXftuod77nePZzmA+C7hRuY2HQLIcgt596VV0opK1jLLRa3aAsmJRPZsqgo935VvCcWkciiE+XNJNxkY/Z50nRU+YjvSv+Siy7QLj1gS0wVuvEof4KBOpLOLMmWyiJ0jo5ORwj0jIS4tR7ShECPO+C5aROKkOure8QmU4FBPTGSv+aDLdzOQcrl5I2hawped+x+21kOd2SJNIF2pOt24LJFwn
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY4PR10MB2038.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(366004)(136003)(39860400002)(346002)(376002)(26005)(7416002)(8936002)(6486002)(31686004)(8676002)(110136005)(16576012)(316002)(5660300002)(66476007)(186003)(66556008)(956004)(52116002)(6666004)(66946007)(16526019)(2616005)(478600001)(86362001)(4326008)(53546011)(2906002)(36756003)(31696002)(21314003)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?Wkxvak1NU1R5U1paVGpRNFIxMnZXZk1salJKVUdRRzBIL0pTNldIZXVoK2tm?=
 =?utf-8?B?ZFlCQjlHb1VkRE83SU51UHdVY0dRK0t3Wkc0VVVGWVNnTjBMWk1hamYvdk53?=
 =?utf-8?B?VVBTTXo0RDljeXEybW5xQmIrSE5xL1g4VUpZb3FQVG9IdWkvRmRxRVZIYUVM?=
 =?utf-8?B?MW56Q1hQQ2F2bEFVZzRuMEkycERPazNQeDN1ajg1dVZvd0xJclpLdVM2cXBx?=
 =?utf-8?B?MllDUlVNQTUrK2RkckxNR0IyYWRXTnhsbjg2RS9YREJWT242eFBkcTNuR2Ns?=
 =?utf-8?B?QjRmRDA4WVBpK2pTeW1oM3VyOWp0bDlkUUdSTW5wUXY0R2FISHMrZ3p3Y094?=
 =?utf-8?B?NEhhWUJoM2NBV2JWTjRpQnArdllvUGJXZTQ4aU54Y0V1Si9Xb00zSHVFNk55?=
 =?utf-8?B?TE84a29kc3h1bDRFc2hUUVNNamZXRUJnNThjMXl3UXFxVWgwbU9ySW1RcFJs?=
 =?utf-8?B?Qk9BUnZ2Vm55ZUZiNnVrQTJzOFVXWWE1bUg1VFBOZUpLTW1Dc2F2Tit2aVdQ?=
 =?utf-8?B?L0NxblRzeTlGQVFRR24rUWVhUjRlMlk0RFpZaDNGbDNONWZpMEV6eXNoaEJW?=
 =?utf-8?B?bEVCdDNwdWhLZVI5TElCNmlSL0FWNFJ3YW1ORHpESmtINC9GSlpJbnRBTGlD?=
 =?utf-8?B?Nzhmb25STUlDeGoyclA2OWtFbDduNmxZQzBZdlZSZGlSMW1UTTVKc0FkZjhu?=
 =?utf-8?B?T3g1WjB6RmNvVUFVd3hicGFHRzRtaExPb2FXckhxTVhocVRYMUNyeVlKWHQy?=
 =?utf-8?B?aUhtQVV2ZHpUTWkvSVJKYnhOUHoxOXBidUY2VmNXdnltOVpSNFdDL0pqQ3Fi?=
 =?utf-8?B?RktNeDIvblQvY0IvZWdCUzRBeEFvRTROaEpQMmpzV0J1TTlYelFNYTNtZEZH?=
 =?utf-8?B?MDBUdWNXMFk3Y3RreXBUTXprMi95N0taSWpmb2x6bE1zU0FlckhXNlVMOTQ5?=
 =?utf-8?B?QjkyTGgwdkJHV21TSGx4UFdoaUlvV1crWEhuOVRuNUtMRkVuTzloUGhzaHZP?=
 =?utf-8?B?TWVXdW1PRnJxOUU3NFZYQlFnYUFkVElWS0dBb0hzYlI5K1B6ckxjMzlxa29N?=
 =?utf-8?B?UkhMSklvekNhY1p3Z0VwbHJ6ZDR5ZHB1dDBUeUE1VC9FNVRDd3hBa1A4RGtm?=
 =?utf-8?B?KzRvd1FPS2xrQXVCUXBJZ0xBcjN2QWp5QnBlWXVFYk1BNWFxYjgxNFppSEdq?=
 =?utf-8?B?SkdqdkQvdXBBN2J6Zmo0ODdkOW15NUV2V0JDRDBLWXB6TjlLN2pZSW5ub1hi?=
 =?utf-8?B?VG1DcVc1eGhiUmhhMThJb2NHOHZWTmw1a0dRTCtTTzFaZlRrR3dZbzllTTdm?=
 =?utf-8?B?clRjaDIrSjhTeElrK0RYREhHMWFydmNGSmlhUjNyWkFBajlPZHNFdHQveWpW?=
 =?utf-8?B?Uk55endqWUxJQXhDRE9OYUdlMGhGSjRoRjIrYmRjaHlkcUUrT2g4RkdoVUJD?=
 =?utf-8?B?ci9scDM1endQb1pNN3ZUT201ZFdhNVFYL1pmK1RQR0Ercm5XSS9ScEptbjFI?=
 =?utf-8?B?ZVlxZ3c1WkxDY1FoaXExajFISGdvSk9UMGpjSlhLeWhERzI2YUFwVktzUG1X?=
 =?utf-8?B?dDg5VGIyQkFJMjRSS3N1bEtiQnNKdU9DdjdpR1FEdGlwekFCSnBqMDdXYzZy?=
 =?utf-8?B?ZmIxdHBxN3E2Rk45ZG52a0VzOHNTU1NyNDFBZDRmRzdMWWZRd3NRQm9IZCtq?=
 =?utf-8?B?OVlPWWZ6bGdObGxRVlgzakhpcGNSYzZQblJTUUVQVm5iUUpoR1YwRExoSDVv?=
 =?utf-8?Q?lQuj1HsXRPQZBQ4C6oX3T1XjEdAZe0VN3qO8Xol?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9ba7c34e-30ef-4f5a-8711-08d8d95c1b66
X-MS-Exchange-CrossTenant-AuthSource: CY4PR10MB2038.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Feb 2021 07:08:09.7885
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: iG1vFXtKA2xb/VRD2Q01a3Jv6brHQgiQEh9T52BeTgEhq03f5HuUABTmdyA7VOvZM2cWMjSoRRf4HCgOIUZ0ng==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR10MB1959
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9905 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 suspectscore=0
 malwarescore=0 mlxlogscore=999 adultscore=0 bulkscore=0 mlxscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102250057
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9905 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 bulkscore=0
 clxscore=1011 mlxlogscore=999 lowpriorityscore=0 phishscore=0
 impostorscore=0 adultscore=0 mlxscore=0 priorityscore=1501 malwarescore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102250057
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


On 2/25/21 10:07 AM, Steven Rostedt wrote:
> On Wed, 24 Feb 2021 20:37:08 -0500
> Steven Rostedt <rostedt@goodmis.org> wrote:
>
>>> +	TP_printk("call_site=%pS ptr=%p name=%s",
>>> +		  (void *)__entry->call_site, __entry->ptr, __entry->name)
>> 	You must use __get_str(name) here!
>>
>> (see other users of this logic in include/trace/events/*.h)
>>
>> What is happening is that TP_fast_assign() is called by the tracepoint
>> logic (at the time of the event), then much later (seconds, minutes,
>> hours, days!), when the user does a "cat trace" of the file, the
>> __entry->name is read and the printf logic is called against it. Well,
>> the s->name that __entry->name points to, can be long gone by then!
>>
>> Instead, using __string() tells the TRACE_EVENT() macro that this is a
>> dynamic string. The __assign_str() records the string into the ring
>> buffer. The __get_str() retrieves the string from the ring buffer as
>> part of the event, so it stays around as long as the event being read
>> by the trace file is around.
>>
>> Please do not apply this patch as is, it is very buggy!
> I wonder if we can add something to checkpatch that can check if
> TP_printk() has a call to "%s" where it references a __entry->xxx and
> not a __get_str(), and will warn about it.
That's helpful for me who don't know "%s" of TP_printk is special.
>
> There a a few cases where its OK. Like RCU uses a TPS() macro around
> strings it passes into the tracepoint, which is used for strings that
> never are freed, and maps the string pointer to the string for user
> space. But RCU is the only user of that I believe.
>
> -- Steve
