Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3D1DCC433DB
	for <mm-commits@archiver.kernel.org>; Thu, 25 Feb 2021 07:09:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DE21264ED3
	for <mm-commits@archiver.kernel.org>; Thu, 25 Feb 2021 07:09:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232557AbhBYHJO (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 25 Feb 2021 02:09:14 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:49434 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233161AbhBYHHw (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 25 Feb 2021 02:07:52 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 11P75KQB193300;
        Thu, 25 Feb 2021 07:06:29 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=1WgdC9Rknk+EVqtj90SwjyYVYIZCYbNMNaj5VhF5xH0=;
 b=bwktcoOg6jXIbRYEBEVZwWKEn3bxHY6LRrkzOSRhvKzYBq+pXx+wk4jVUx0XcKmn3a1G
 w82enn+SWxdTzlkJhdh76p4ScoNAsqfrzZENWORRw91k4YPxHFqBHWbq/p2X6TUjaVR9
 lOwmdh9DvShy0Ha/3FsFV5C5qpHuPhNM9Y0tVO+kBONjL8fPbrzciHEYOA2jBLDxq7qS
 1CoXY4qIroX0RVAUhUwxrhZp7HYhxXUsUK1i6BGLXrGR4Okf0gYtAQfhQytKk0gNRhGU
 7ILLDFLfKjUs8Xblp4ZPxorV0AH0VsL37nmIvrE+0iJp0aOTHqZs494dBF7xUm+wySXR RA== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2130.oracle.com with ESMTP id 36tsur5eqb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 25 Feb 2021 07:06:29 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 11P74c8d173001;
        Thu, 25 Feb 2021 07:06:28 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2177.outbound.protection.outlook.com [104.47.56.177])
        by aserp3030.oracle.com with ESMTP id 36v9m6wcr1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 25 Feb 2021 07:06:28 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=D7n8uJcupV07RaQJKoPe9fNfiCAf+Dc7ee8eq8PuzkQfSiCbqTbxuGt9eUMFNFDjvPcx3U9XeX/Ii37ZeRNgSSBWYAUJJI5ZI0lOp5PAGN6/NVasx6Np7AU9kAltXJHyL7PGSDMdCVyE/UVocoWOiS74rKz+5CyaiWV+JlFb0P3pzXQn1uWQvHdaf9T0NelG63aDGZOEe//RPGKQmUMxaFyN9zBMCt2Q/o1LNwcgdlMaBuludAGXM9L0feXECsAT6gCw1lQmLT2Axper3LM2fYCMwMYxycGvhXIMaAb8G0m0XY9IpW9qDExPehY5pVXX/DJQUsy2eX3FNf7PfzmeAA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1WgdC9Rknk+EVqtj90SwjyYVYIZCYbNMNaj5VhF5xH0=;
 b=Vu/uZTUJz+BEy5Ax16qKc7cx7+w2PMZDcsWJNbIwT039PfFuEy0JOE9Ma0nFlAaPDYNIt+E4+jit2z87gLbb9iyCMjUxPng50lSqEekdecdy3gEKzE3tYs2NXl6QoJt8qpzNkvUHPqA9+ju9iCmYD+0bHUxovz1vuYdq2tsgFPgjnVh0k9zzNR6TPk7HnoERkgCFQcIOBnPX0y2f/k89GXAsVGBcFocDlJkNZliHtRjHfGEoQvukKNuHbBUYsCADsZE8BtvWWKhy5RO4Co3MMtTbkegZsS3R53hkbqBOro1dAmafWD4cCOAm1NFp5msO4SJf346bLlyeZHgtc4gOoQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1WgdC9Rknk+EVqtj90SwjyYVYIZCYbNMNaj5VhF5xH0=;
 b=moOsbzdLEv3nMFf+rWJ6TqcChBYe11xIg/JSXXhfjlF1OiAHyV+QG/q1lqeosC0AEfbPiu6x64A4ehfSqcV43Ao29r+//XMRUBQFKGaoW43uxAkqZ06a9LrhekXHE2bvKPhfU47s9gYyU+etiLib3Hgu1dutKpPuglGx+D1Y778=
Authentication-Results: google.com; dkim=none (message not signed)
 header.d=none;google.com; dmarc=none action=none header.from=oracle.com;
Received: from CY4PR10MB2038.namprd10.prod.outlook.com (2603:10b6:903:122::20)
 by CY4PR10MB1351.namprd10.prod.outlook.com (2603:10b6:903:2b::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3868.33; Thu, 25 Feb
 2021 07:06:26 +0000
Received: from CY4PR10MB2038.namprd10.prod.outlook.com
 ([fe80::842f:b854:7899:e759]) by CY4PR10MB2038.namprd10.prod.outlook.com
 ([fe80::842f:b854:7899:e759%8]) with mapi id 15.20.3868.033; Thu, 25 Feb 2021
 07:06:26 +0000
Subject: Re: [patch 014/173] mm, tracing: record slab name for
 kmem_cache_free()
To:     Steven Rostedt <rostedt@goodmis.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        Christoph Lameter <cl@linux.com>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Linux-MM <linux-mm@kvack.org>, mm-commits@vger.kernel.org,
        Paul McKenney <paulmck@linux.vnet.ibm.com>,
        Pekka Enberg <penberg@kernel.org>,
        David Rientjes <rientjes@google.com>
References: <20210224115824.1e289a6895087f10c41dd8d6@linux-foundation.org>
 <20210224200055.U7Xz47kX5%akpm@linux-foundation.org>
 <20210224203708.4489755a@oasis.local.home>
 <CAHk-=whoqLWCcUXOBfWsEu49jLRJFkwnCRq6dyjg_M=dO1FhcQ@mail.gmail.com>
 <20210224210302.0e0a196a@oasis.local.home>
From:   Jacob Wen <jian.w.wen@oracle.com>
Message-ID: <aeedc1c3-9cd3-150e-aa63-29b4efcb43c2@oracle.com>
Date:   Thu, 25 Feb 2021 15:06:08 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
In-Reply-To: <20210224210302.0e0a196a@oasis.local.home>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Originating-IP: [138.3.206.30]
X-ClientProxiedBy: TYBP286CA0013.JPNP286.PROD.OUTLOOK.COM
 (2603:1096:404:ce::25) To CY4PR10MB2038.namprd10.prod.outlook.com
 (2603:10b6:903:122::20)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [10.191.25.30] (138.3.206.30) by TYBP286CA0013.JPNP286.PROD.OUTLOOK.COM (2603:1096:404:ce::25) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3890.19 via Frontend Transport; Thu, 25 Feb 2021 07:06:23 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 8cca6a1c-b57e-4718-3050-08d8d95bdde6
X-MS-TrafficTypeDiagnostic: CY4PR10MB1351:
X-Microsoft-Antispam-PRVS: <CY4PR10MB13517DF80AB96CA7091B61E3A49E9@CY4PR10MB1351.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: qIw3gG/PyDIJzeY2agFiMkntiu1gCA5iRIAv1mVUo6xwlzS3mJYQMyMJCWNEqYJzwG/DPXYMfGHa3GJSEFHORFuhd+nPdU/28AcXBHP0biKNZ53QhElDqdz7lf09CBypxxqUcl03DfX/EIVHowoIk6bR0jBi8BCOnXHEFBP3Lzh0BGMQ2TbuAg2NrN6/QkP1Ft/jJXUic4OLUKU49bC4q9/aATAJdYGJFvl+Zgd56/0q6CwSQMJAXTImVuU0snZ7a6deg2jR5KBqFJ01o5sPZefPqfN67QeWeuBOvylvbGG4Ch4ksS9cBO2/IjociDle135WJlun+VrjbjQ9kc+MrxDTxMeBcWKS8D7FV6xqezw3LAPMBSozzwDwOEBPh3Z1kNq3sU4kzjRx21A6YPFLZaE4wFONnAhAuDC1CDtYnAKat+KiZdisCcYGbsQlJPoeeL/QXmpO5tlxBArtJv4mPTcQ92Xczr/fFH3tUqI4np1YK3qFvOyIpidQuYpHSNgiXWEHCvdp0DwsCfpkeTasOtteS2oGwSBuslLM+tdGQVVL4X3qkJH1Zp240NyCYjXcotv0GtlPxFgPSDK6ExWBdQqeMY+Sipj21wQ3Kk6qwTI=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY4PR10MB2038.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(376002)(346002)(39860400002)(396003)(366004)(83380400001)(6486002)(7416002)(31686004)(8936002)(5660300002)(16526019)(8676002)(186003)(4326008)(2616005)(956004)(53546011)(478600001)(110136005)(52116002)(26005)(54906003)(36756003)(66476007)(66556008)(66946007)(86362001)(31696002)(16576012)(2906002)(316002)(6666004)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?Q2Z0UGdGUXJQb2g5SklRYVFLNjg0V1Z5T2s0TGh2bngxMGRCMUloc0htemFX?=
 =?utf-8?B?dnlwTVYxNFdjVmJrc3F4QnpPQ1JOR2VKQ3hHU2FMQVRnYU1LYWdNQkN3dlN2?=
 =?utf-8?B?ZGdxT3gxbmVYZnZ2RTVER3lLNzB6ckJUV1RjMy9DblBYVW5KWkZnZ0Vxck5L?=
 =?utf-8?B?Z0FIRlB5WDRhTXJuNlJJeWxTYWJXWTdxZTR3cXl6M3RiNGZUS3ZNRC9pM3hQ?=
 =?utf-8?B?N1gxQTVGbkh6RFd0cFJsWVYvV01DVUdlcHZXUWY5SXVWcWJ0by9oZ3VLMkNN?=
 =?utf-8?B?Z0lZWGNWdW1NVXZrY293ZWZhbG5SZW1jS05GMndGNGFwQU1aQ1RKZ0pkbFFl?=
 =?utf-8?B?QkhIZ3lxRURObDkvY0trbVQ2U1VDYXYwbEtRczN0eGY4Qmc2bzMyRVBUVjhm?=
 =?utf-8?B?NTdCTUxwWm1LTGNJTkw3OGlSSjJNVVhla0FpenVSb1hkK1NzbVExRjZ4Uldq?=
 =?utf-8?B?STZEM2lTSkcvM0V1aldOOU9CQkJoTzdNa0VVZExDc2JwMkxxMUJITW5seG9v?=
 =?utf-8?B?WHdDQ3JQWlByT3Z5YmhaWjF6YWZlbDRsSU9MT1FOOFhjTnI4M2tLUDRKT0ds?=
 =?utf-8?B?M2NiVEJnbXY1RU5icGZ5Zk1oNnl5TlM4NUd4YzJmeXFvd1hBMGpocThxWE1T?=
 =?utf-8?B?UTJwcHZkcnR0T05mNWNsRlp0R1p3MEFZeU5tOVBid3hsenF2ZkVFMm11ZlZH?=
 =?utf-8?B?RVVvR1lvNWtjblh4TkVCVzd0S2t2SmFnT2ZHUkdKaHBBRFl3Y0dnVVpDbkpG?=
 =?utf-8?B?VVh1dTlMTTE1SHdJbmdacVR5b2E2THY3dDlGUXQrWDEzc0VWQVV4OUlteElp?=
 =?utf-8?B?UzVoeUFBNlJRZ3NhR050cmxOaGIxK3Ewam40VlNvbm1OdUl5cEpSTXF2TGE5?=
 =?utf-8?B?NDhUQXhDOHZ4NG5XaWI4QUY0WDYxNmQ2dlVGbmNPcGdteUcvanpLSkJnQkEr?=
 =?utf-8?B?dVlBN2hFbWorMWdSSWp2Z0J3R2VUMkJhS3VZZWJWS2FCNGxZSm1EY21jdXFn?=
 =?utf-8?B?Zkp1YThBUThpdEhjUDlCKzdncGhkNmNtaWFxc2xLL0ZMR3c2bGZ0QisrMHNJ?=
 =?utf-8?B?eXNQSGFWQi9TT01CWDJMcVBhT0MxSklRT0oxekphMEVadloyQVNNeXoxWVZR?=
 =?utf-8?B?WDlVaFlJSTBncUp5OTY1a2dqdjVuZlVYZFpjNlI4T2grWUF1SVNFQ0hxUlF5?=
 =?utf-8?B?bi83YisyUVd4OVQwSjhqUmk5VCsyaGRsanhuNHZQS1lYNjdqdGVJTlRnMDBY?=
 =?utf-8?B?Y0xIVFo4V0VIZUQ4bmZCcXdRODNNS05ITVp3ZUk4UkU5QkFTdHJjT0gyaTJM?=
 =?utf-8?B?cmxGeWorclBHYWtxZXVZWEZ0d0pJdHpJeUFVT2pMa3lHQlBsbWVpalZXV3lu?=
 =?utf-8?B?bGtyMjViRjVmSHBwa0ZvOE1TQy9pbXhnT2ZBODFIbGppaHNPSHpGNmxWTlRM?=
 =?utf-8?B?VXJXY3l2dHRDNU5GZXVxajl4YmNtc2hlbDAyVnRPMkxLSDFUN3MxRi9ROW1r?=
 =?utf-8?B?YmJPTkF5THlxZEgvYmlWOWNQUjRLQ1RXV004S1JUUmtTbG1pVzhzRjFhSEZv?=
 =?utf-8?B?STlDQ3hDVE9zTGNSaGtEeUVneUtwS2ZwTklITjhUQ3FjZFY1b01MTnZGUGJF?=
 =?utf-8?B?d3UyQUMySkNyYjVGYk56UmxpbTZJQ28yQUtCQXdaT3ZGSHZ2alVOb0dQcXFr?=
 =?utf-8?B?WmRyZ1h4RGQrS01UaHoybktxZzlmVUJIKzRqZzBGUjNaN1cwV282S3NDTEJ1?=
 =?utf-8?Q?oNWtYR3rklemfZg9ZAmhNnY3FsEeEAmY2dUYiQ+?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8cca6a1c-b57e-4718-3050-08d8d95bdde6
X-MS-Exchange-CrossTenant-AuthSource: CY4PR10MB2038.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Feb 2021 07:06:26.2346
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: YoHNPG8m3xiQr7vE/VNFZP5z91FEKQ6AiRxlWErlhPII11OXBINcLj6o8NxlJL1ly1M12qsMg2r/LlpfchCqag==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR10MB1351
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9905 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 adultscore=0
 suspectscore=0 mlxlogscore=999 mlxscore=0 spamscore=0 bulkscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102250057
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9905 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 spamscore=0
 priorityscore=1501 impostorscore=0 bulkscore=0 mlxscore=0 malwarescore=0
 clxscore=1011 phishscore=0 mlxlogscore=999 lowpriorityscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2102250057
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


On 2/25/21 10:03 AM, Steven Rostedt wrote:
> On Wed, 24 Feb 2021 17:51:46 -0800
> Linus Torvalds <torvalds@linux-foundation.org> wrote:
>
>> On Wed, Feb 24, 2021 at 5:37 PM Steven Rostedt <rostedt@goodmis.org> wrote:
>>> Please do not apply this patch as is, it is very buggy!
>> Sadly, it's already there and pushed out.  I try to wait a few hours
>> (sometimes overnight) with Andrew's series before pushing things out
>> in order to catch comments like this, but this one came too late.
> I try to look at patches like this for these very mistakes. I don't
> seem to be Cc'd on the original patch, and this looks to be the first
> time I've seen this patch. I should update my lkml filter to send me
> any patches that touch include/trace/ code or has TRACE_EVENT in it,
> and forward it to my inbox if I'm not already on the Cc.
>
>> I can obviously revert, but if the fix is the two-liner you outlined,
>> perhaps that is better? Mind sending it as a patch (or just putting it
>> in your tracing tree)? Or Jacob? A tested patch along the lines that
>> Steven outlined?
> I'm done for the night, but if nobody does anything by tomorrow, I can
> write up a quick fix in a few minutes. I prefer the original author to
> do it, just so they get into the habit of understanding strings in
> events.

Learning how strings in events works is great. Thanks for the detailed 
explanation.

I don't have time to fix and test it today.

>
> But even though it's very buggy, it wont break anything unless people
> really try to. The breakage would require enabling the event, then
> doing something that would free a slab and its name, then reading the
> trace file that has the events. In other words, the risk is low, but
> something you don't want on a production system. I don't see this
> breaking current mainline testing, so its not urgent to get fixed
> immediately.
>
> -- Steve
