Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F1C3EC433E0
	for <mm-commits@archiver.kernel.org>; Fri, 26 Feb 2021 03:52:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8BF8E64E20
	for <mm-commits@archiver.kernel.org>; Fri, 26 Feb 2021 03:52:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229586AbhBZDwW (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 25 Feb 2021 22:52:22 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:41008 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229508AbhBZDwW (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 25 Feb 2021 22:52:22 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 11Q3i7fG078320;
        Fri, 26 Feb 2021 03:48:30 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=LFDVOqeppSDtXUl+rAfwUyoeEzJ/x6viw0HCVwKD2kw=;
 b=PZDL3q3I4fTvwhk3SVQFE8U/pyP1/s+lnQxKQjC21CwCiW+RyTTqC4sawlSE9AJbm2Vl
 vi8cVtKnsZ0ddc1XYJ+67FVXBStCDc0AE7SkdmfYyRIk7EYaPFArRTrNekORImYjRA4+
 Gg/4/GG7IqMFLYN2lHUcUjwS7N3MT+pRty4m093MSXzzPMnto6IdPpVSjIqAkJNx7qf2
 HbOqikhwykBQMr8DXbGcc/9J+3sD9cF1hoAuVz+SG4qU11yfbxNgqltSPujOfEDrcizM
 IKznTQ1qPCkNvLb8Mo8KzXuVnnNHStlfiRpYXDisx9pK6oAqeQHvNZ4PYul2E/fCBBCG jw== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 36xqkf84x5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 26 Feb 2021 03:48:30 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 11Q3khhP045579;
        Fri, 26 Feb 2021 03:48:30 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2173.outbound.protection.outlook.com [104.47.57.173])
        by aserp3030.oracle.com with ESMTP id 36v9m84na7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 26 Feb 2021 03:48:30 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DYM9lyJFwtA/XUYGGNaVJ1Y7fdOL3XK3UT7XDku3DtSU6e123tOfqc1d9Zef1iVfhkrVflSJ618pVtGI1Z627g1mHqFPGR/R6rO8xn721Lpvdv7Ib4OkVb5sFcSwdBnoPP1Z1L33lQhkjZcmko5k2T7ujgsEdpRdFejnrY7nvGph0zu3H0uKa5hnc/oiCJpinve1keZA9qDn+ahMEYTwndNHt/tQvrIQ3LGPYLflclbhWEKFfnFOEtRzkQLJgN3L8c8hEeEajkO72Gexy8hxaZdnVzKbaJjvTQ6b5pDWQfIW4wvSp8ZlRe+BOPvFToe1AS7ifBXA25yZx+lOLlOBTw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LFDVOqeppSDtXUl+rAfwUyoeEzJ/x6viw0HCVwKD2kw=;
 b=Q/kXEPC/3ogxdPnWrhSg0OVp3IqQjsryHI6jsrjLmVN9kurX31lOC45X2cQThVK/8GpxzJQj8N5yZGj3TAv2i0Xpab7QQfg3O6aCMwBBzBZ/8yDQGyz4R8EOK2N+8HUmfbAgE5egUlJtLiALMq7EVoD3s9w00NRI08O9PW90SIqEyz4baKLCJy4bojuf+C7ytDfefBeWzFlqyNAEgCxPedDgAscquWLCw+HAF5vsZ/PQ2IVkW927VXCu2qPnT3RfP8G1dLPa1oK/1ITJxet8Iz0xTnj725EfQlsNjsEcxQlXaO7yADkcJ4IGyO0R9QzGAnjNRENvAxbSDX70tLFfYw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LFDVOqeppSDtXUl+rAfwUyoeEzJ/x6viw0HCVwKD2kw=;
 b=mquLzHBvt3S5KhlWGWMMbHEhHO7ROtApPz6bMh0OR0hIlngn5oejkwRXaDZ3uQ2TMcmB9HiE3W19wL7yb7GAEcMADnUQ6AiZMBoLaBV/7JBoAha5K5r42XbnNmIoaoVCzUokUkRwP38Rsqaf6E+ihIkOYWOTdLrt0WCQhaZsHWA=
Authentication-Results: google.com; dkim=none (message not signed)
 header.d=none;google.com; dmarc=none action=none header.from=oracle.com;
Received: from CY4PR10MB2038.namprd10.prod.outlook.com (2603:10b6:903:122::20)
 by CY4PR10MB1592.namprd10.prod.outlook.com (2603:10b6:903:27::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3846.29; Fri, 26 Feb
 2021 03:48:28 +0000
Received: from CY4PR10MB2038.namprd10.prod.outlook.com
 ([fe80::842f:b854:7899:e759]) by CY4PR10MB2038.namprd10.prod.outlook.com
 ([fe80::842f:b854:7899:e759%8]) with mapi id 15.20.3868.033; Fri, 26 Feb 2021
 03:48:28 +0000
Subject: Re: [patch 014/173] mm, tracing: record slab name for
 kmem_cache_free()
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Joe Perches <joe@perches.com>,
        Christoph Lameter <cl@linux.com>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Linux-MM <linux-mm@kvack.org>, mm-commits@vger.kernel.org,
        Paul McKenney <paulmck@linux.vnet.ibm.com>,
        Pekka Enberg <penberg@kernel.org>,
        David Rientjes <rientjes@google.com>
References: <20210224115824.1e289a6895087f10c41dd8d6@linux-foundation.org>
 <20210224200055.U7Xz47kX5%akpm@linux-foundation.org>
 <20210224203708.4489755a@oasis.local.home>
 <20210224210740.73273c7a@oasis.local.home>
 <5a0b6fb4-6efd-e391-45fa-cd188f181d5d@oracle.com>
 <20210225093128.4cd86439@gandalf.local.home>
 <CAHk-=witGXc2FsqkOUy+Fh1_Vdpg=G5-MnDnDHv5DR5d6bRztQ@mail.gmail.com>
 <20210225125741.4fc7e43e@gandalf.local.home>
 <81645797-baee-fb17-6432-6a5cc423f09b@oracle.com>
 <20210225215640.51feee2f@oasis.local.home>
From:   Jacob Wen <jian.w.wen@oracle.com>
Message-ID: <301b57a6-8630-d3a0-699a-361c2df9f561@oracle.com>
Date:   Fri, 26 Feb 2021 11:48:18 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
In-Reply-To: <20210225215640.51feee2f@oasis.local.home>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Originating-IP: [138.3.206.58]
X-ClientProxiedBy: TYAPR01CA0009.jpnprd01.prod.outlook.com (2603:1096:404::21)
 To CY4PR10MB2038.namprd10.prod.outlook.com (2603:10b6:903:122::20)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [10.191.28.58] (138.3.206.58) by TYAPR01CA0009.jpnprd01.prod.outlook.com (2603:1096:404::21) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3890.19 via Frontend Transport; Fri, 26 Feb 2021 03:48:25 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 221b4c3c-8746-4696-11b8-08d8da09606b
X-MS-TrafficTypeDiagnostic: CY4PR10MB1592:
X-Microsoft-Antispam-PRVS: <CY4PR10MB15920A2F7C455D83B44104E6A49D9@CY4PR10MB1592.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ZETZTjVnL0Zo0EU4F8nTeA5r6IBLxatJo0tRAa7ZwVxYXim+GrkdxLRJTK0pLbCrS6BaHbgGAVuGy4Fpge7O/M9QW4t+Ga+0r+F3p0xZ5NQROWsaKNYL5JEiu7mAzra4fKSK+JeenbMmrI3lEoc37WLhrPzIbjdbilNr9D94ZIV5DfZin2p0gL3gSB97yNZ5/d7Ad6VB9HRA3KtC0yCyX1A3C5U73IQoa4gqLEocUXhy/M1dr0udqVZwlZ7yx8z98OKuvT87mXBV/xJJNbdQWehDkuu3bKBGMHO9Dk9Sengn++l2rmM6sH9fHKzyYipXFTOO8YxEZWmlJhK5b2yibS+V5TfzJrZhurMaZbsv9rqSfgRrHiTVd09+PuoyxrVPDqb5iyfnz3Upv+Hr8PG5jTV8EKXjvrhyD/IBuHxvkgSr5YcGCP3eklbXhcBCOxqEnvuVJphCgDALqc+BOTiFVOTaSgHlTIZmvAs50UaDkUL6+/HhUgFks1iP05txJoqGX2Bo4MX3WJmrzMz1hyhYkH96yctApG4a8GiuJv1Tujw6PySCjHU97zCcU9cD4gdf4aMPWzI3/5E1c7FkvcCvwtfqDfjy+X3IV5DWeYt0dms=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY4PR10MB2038.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(396003)(346002)(136003)(366004)(376002)(66946007)(52116002)(54906003)(66476007)(4744005)(66556008)(316002)(16576012)(478600001)(6666004)(8676002)(36756003)(956004)(7416002)(86362001)(4326008)(31686004)(8936002)(5660300002)(6486002)(16526019)(186003)(31696002)(53546011)(2616005)(26005)(2906002)(6916009)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?VWR1UTZOajJnK3VXM2FxUnNRR0E1U0xxYnRlNjVEcHZ3SkJvSVdFakNjM1BI?=
 =?utf-8?B?dXZuekxob2p3blIxZUZROTB4UnJpSGViWWdsa0ZES1J5dmh5VWUyZ3RORWww?=
 =?utf-8?B?NmNHRisyaE0rcUtqMmQySjNERzJNdWN3bmlmaHN1K2RwekIxL3hMMHlVdVNu?=
 =?utf-8?B?TlAza09Vd01Rd0NVZHhWaWdyNmdheEJPL1Rab3U1bUFCMXIwYVMvcnFZaWRv?=
 =?utf-8?B?enZYRVc3d1FibUdTdWs5Q25DV2Q1L1h1OEdzcjRMRHVIeVR6bWpQQlNTWjVz?=
 =?utf-8?B?b0xlbzAyQjFaSmhpaGE2Mmt0c2ZkR0JISjRISGZ2M1ZTVWJjVG5iTVF4Ry8z?=
 =?utf-8?B?akZFZjlhMThOSUxpU2taZnNGbFA5SkRNZXF2QkFBT29WVzdiV1dmUGg1aWUx?=
 =?utf-8?B?cmJRajBQZGlibHQ3YTd2ZWVMU05kM2xIdjJPNW42SU5nVitFeHFCWktrWml2?=
 =?utf-8?B?MU9ySU5OVmZwdEovNlFsbHc1V2ZrcDcrNkRsMG1sc08xTFVxcHdmRktaV0dJ?=
 =?utf-8?B?ZUhkY2lyZm1CdjRwYTl2OE0vM0c5TlFXbWNrb29XM3o1UUxaL2hQUTVmZVRV?=
 =?utf-8?B?ZUE4YWpNdTgrU1ZFdFdHR2ZNTlN2eWJ1dXVWaVlGcWYwb1lsWWZZMElBUWx2?=
 =?utf-8?B?cHpTdUQwMytqaFBEbVVCajVrSGlaS2dJOFVUV1NwOGsyQTVyUmkrV1ExMjlp?=
 =?utf-8?B?NTlWYkIvTDZ4OSttN0swbEpKV2M4cU0yMzFPaW9vSzl2MUFkRHFhSU4yNHAv?=
 =?utf-8?B?aFZCbUNvd21pbVRzbVdEUlVCQVNKSG1ZS0NuSWJ1bndsTWtITnIzMUlHdUNL?=
 =?utf-8?B?RjlPT1ZYdFdCMTZDNEZQaFd1MmlGcytEZzNrSGpnWmRFNHlNYk9hNjBBR0tE?=
 =?utf-8?B?ZWtFSjB4TzVZekRibkNkWDFYR3doL2xqdk9qaVcrS1lSQThuUCt0T1Vac1Iy?=
 =?utf-8?B?aVgzdUxsdDhMM24rUVdhMm1vWkIzY05GWG52NStVVVJrbUh4S3gxSXQxellw?=
 =?utf-8?B?N2h4YmsrTzBFSURoYVlUaXZ1cFhVcS8xNFh4d2JxMThDSkQrRmx6ekVMVnNp?=
 =?utf-8?B?VkV3Z3I0eWlMclNmL0JvWFB6Ui9UTXdnb3dWdHIyS252TWluMVhsZ29POEpZ?=
 =?utf-8?B?Uy85SmpaZEdWZjlmRTZiWXFBNEJPK0E0V3l6a3ZMRXFkai9oWTEzeHh5TnBM?=
 =?utf-8?B?OTRqaGdmL25XWUREQkhzbjNkTWE3OW0xS2VxQnZhV3lnbE1IOGE3UitNZHg2?=
 =?utf-8?B?ZFJaM2lSS2U5N3dGRjFvWlMvTVpkc2Z6ZjNDNzJESjcrNEJ5TlFoWDEzdGlm?=
 =?utf-8?B?OXJZdmxqcDl0Y0dtQ1cvaitmcVZGbFFaNThqNkRxSzJrTFlhYmxwUTJCZmJa?=
 =?utf-8?B?WGNwSmtmaUgvWHZOaUhOUmgwQmFFRDBjRWpCQTh2YnE3djNtTXVBOW0wRTE3?=
 =?utf-8?B?cHpSQTNVY0dBUVhFcjl1R2lhR1J5WmJEUDAzVjlWaVpqM2MxY3htWmtWQW1P?=
 =?utf-8?B?aTFsV21UaVIzZ016VDYwT3VJZEpkVTZwNHhjbG95aGNVN3NFaU1Oa09Hamd0?=
 =?utf-8?B?VC9zV1hpam1hUFVMUE5yRFQzY3JwNkgrUkE4SnE0MWd3QjdmNDhuYW1rdjd6?=
 =?utf-8?B?elY4bElSY1RuK0VSUVAvamFnVk5FYnBrcFo3ODRmYlcwZEg0TzBuM1k5U3FB?=
 =?utf-8?B?SXpJNXZuM1crL2JqbFczSFhvV2hJSXZNVnBpQVlzVVZsMEQrL1RDcU94YjIr?=
 =?utf-8?Q?uLNfboFizfi6esO5+x5GzxUS+NhUG0YzK1mvEPt?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 221b4c3c-8746-4696-11b8-08d8da09606b
X-MS-Exchange-CrossTenant-AuthSource: CY4PR10MB2038.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Feb 2021 03:48:28.1914
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: oIQByscr8PVxgY0Ot74okadf9LBe+udKCje58/7jUB0aHfrj9qOJGPR8wRRgi4FSZLa+VnwvSisIx8kXnsQQRg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR10MB1592
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9906 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 adultscore=0
 suspectscore=0 mlxlogscore=999 mlxscore=0 spamscore=0 bulkscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102260026
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9906 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 clxscore=1015
 malwarescore=0 suspectscore=0 impostorscore=0 phishscore=0 mlxscore=0
 spamscore=0 mlxlogscore=999 bulkscore=0 priorityscore=1501 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2102260026
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


On 2/26/21 10:56 AM, Steven Rostedt wrote:
> On Fri, 26 Feb 2021 10:02:53 +0800
> Jacob Wen <jian.w.wen@oracle.com> wrote:
>
>> Freeing a slab name generally means removing a kernel module.
>> See the callers of kmem_cache_destroy.
>>
>> We need to fix some of the trace events that call TP_printk with %pS
>> to get a symbol of a kernel module that maybe removed later.
> No. If the symbol is not found in the kallsyms lookup at the time of
> reading the trace, it will act just like a %p and print the address.
> Yes, it can change the reading of the trace file form one read to the
> next, but it's harmless, and it's been like this since ftrace was
> introduced back in 2009.
>
> -- Steve

Removing a kernel module to see if it releases a lot of memory is
helpful to quickly find out the root causes of some issues.

It seems nice to reserve the symbols. I don't have a relevant use case
so it's just my 2 cents.

