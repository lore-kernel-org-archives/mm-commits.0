Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 59708C433E0
	for <mm-commits@archiver.kernel.org>; Fri, 26 Feb 2021 02:04:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E59AC64EDB
	for <mm-commits@archiver.kernel.org>; Fri, 26 Feb 2021 02:04:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229508AbhBZCEb (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 25 Feb 2021 21:04:31 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:43706 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229534AbhBZCEa (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 25 Feb 2021 21:04:30 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 11Q2043Z126898;
        Fri, 26 Feb 2021 02:03:06 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=J1y36dIr1yHOAXgnpWA77mzeaP1x6Fnc4Q9xUQnoow0=;
 b=ZzWTMo3xD6U6sSqKt9bvVRyCxJISo23bh5ReC1Mo4+RatEOWwPzBgtka61KCxrYVLKNS
 d12EU6WXww+b6yHMjItxRf5CLq7xhwinHgRF3sI0WgihJmul/uGR+Uxz9h+i6lbmfTGa
 mZaLzWaSwRf2ZOOqMiHgEHRaYRTlpiLtHx/7DiThGHgN/DTJWrCIc3cWdoNciEuQUDmi
 bsdu4nP/6xzAzytI3C71t/z45S+q1xmOKMA1FFhJwbKuLLOLQONR7qHZDroL9re+sbns
 FRqIywIaWtAmZ4pjfrKhcQrbeMkTowFJqRt0vlvrjjst2ZtbZ1gb46eqR6xJ86Pz9a6u Sw== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 36xqkf80p6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 26 Feb 2021 02:03:06 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 11Q20KhB184997;
        Fri, 26 Feb 2021 02:03:05 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2108.outbound.protection.outlook.com [104.47.55.108])
        by userp3020.oracle.com with ESMTP id 36uc6v9hwk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 26 Feb 2021 02:03:05 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IsrVHMttLVK/hs+oB+NtUMLuBZXkKykqglRPGgye3zjZncV60LKJ18cEB/0STgZoBIA2i13J/0NBbHAkgCFzf8h8/2aAmuyHKAqctZrihsY4LRN5QcFWMRZ2i87xt5SBcgRwgCzWbtZWdER6Cf8SfS8aWYkRg8pVY54sDr2362+/v7kBhKs9GjAlsRTxgXIvIdhhFurdVtPQZszjqIBQXHpCLJwO4V9xApRCooMDaWR3Xc62MBi1sfQBL6Ib5KfoxKwS9KOcc7c510xOh4938LPuCsZec2Mj0yniaDnB1tfrLh5GSXd7uMbrFcHAYKlRy5dqhKRPJy/WOquEFcoz+w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=J1y36dIr1yHOAXgnpWA77mzeaP1x6Fnc4Q9xUQnoow0=;
 b=LNGSNu4qPW4F9NClub8sgeRpPCvNvHuMOpBgF007D2svNddoesHOiYeh+zDpIoF924eXIui5NUXAgHUrKqGa9bWXlJoSSx7ZsLBsDzMwNxFEgORneoxOVuxhJvivO7ErpTDbpR/udi83/gisHocBrAqr+raeeFdFnPstge9U9HUzA9XE8iKvSBo2lwJlhYa0suhll0KdW7wzo5BjFvcTcHyrq8pmhKMX/gFIGvTwVMdWm5fEKaOI/LiccC+H3FToCrt+JYJ4gANfsISFW37ZvHukKY47doZy6wdCpDbM1/U3+nJi/oCfUb1L+/IHFISzUFZBzsUXpmFXc1whfKxmUQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=J1y36dIr1yHOAXgnpWA77mzeaP1x6Fnc4Q9xUQnoow0=;
 b=Pff5UVlybyXpxYo6HusV8zXpO9hw2/Zv0EOqVICWUd4de6rh8d53O1NMC+CbuvS6BFUfGcWMlVTwjBGM3Re9eeNw5nDr/2b122wblx4q6AJPyHZWq6Erk4/meB2RemrWN6BVpsOO2nKei4Njo6Ms39usy+qOuQ/TSq3IeUB3vvo=
Authentication-Results: google.com; dkim=none (message not signed)
 header.d=none;google.com; dmarc=none action=none header.from=oracle.com;
Received: from CY4PR10MB2038.namprd10.prod.outlook.com (2603:10b6:903:122::20)
 by CY4PR10MB1591.namprd10.prod.outlook.com (2603:10b6:903:23::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3846.30; Fri, 26 Feb
 2021 02:03:03 +0000
Received: from CY4PR10MB2038.namprd10.prod.outlook.com
 ([fe80::842f:b854:7899:e759]) by CY4PR10MB2038.namprd10.prod.outlook.com
 ([fe80::842f:b854:7899:e759%8]) with mapi id 15.20.3868.033; Fri, 26 Feb 2021
 02:03:03 +0000
Subject: Re: [patch 014/173] mm, tracing: record slab name for
 kmem_cache_free()
To:     Steven Rostedt <rostedt@goodmis.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Cc:     Andrew Morton <akpm@linux-foundation.org>,
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
From:   Jacob Wen <jian.w.wen@oracle.com>
Message-ID: <81645797-baee-fb17-6432-6a5cc423f09b@oracle.com>
Date:   Fri, 26 Feb 2021 10:02:53 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
In-Reply-To: <20210225125741.4fc7e43e@gandalf.local.home>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Originating-IP: [138.3.206.58]
X-ClientProxiedBy: TYAPR01CA0127.jpnprd01.prod.outlook.com
 (2603:1096:404:2d::19) To CY4PR10MB2038.namprd10.prod.outlook.com
 (2603:10b6:903:122::20)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [10.191.28.58] (138.3.206.58) by TYAPR01CA0127.jpnprd01.prod.outlook.com (2603:1096:404:2d::19) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3890.19 via Frontend Transport; Fri, 26 Feb 2021 02:03:00 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 470950b9-87e4-4fe6-53e7-08d8d9faa65c
X-MS-TrafficTypeDiagnostic: CY4PR10MB1591:
X-Microsoft-Antispam-PRVS: <CY4PR10MB1591792E29B9D9E9BB067626A49D9@CY4PR10MB1591.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3968;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: aFuq20qS3oj6ECY091lHRnZjIrBBMOmOC/z7kbjy/eWHlJPaw6qZ2eqqALwLHG6qUblPDCc6KxeoBIrqxTvnhARTLxwjO6PZVNflKHdzKR4BkYfTlPolXWeBtAd9gHDomqShk5SQV7vbcDJSL5LXqDv5qsGuxTAg0Wzybv9MRPJUbmMOyPe9H3M23RW//rR9qHxx6tc64gqpMz5kQsMNAFRCzbKQkp6XEWqtf4XxlzDAXT/VDzlfLHgwVF9N9A8sYPv26JPpdDWrPj5/ovEuYlLDldx0RG2PJ0+HkxmKlhQNow2iDTJruLDxyY7ZIEjn7yzXZV1sptleH7sbBmg+SQdtO0N0wqYszoqyrX2ip7u0xLEW5BoUQXczIFG1n9pP0ygdsLDHMzOwHli9xkihHu/jXghWfCiquaeu1a+lxTVp7zWMZdPiw6LRxfl+ObC7AnqZAdOLELkA0sSgaa31gY41w3gkfa78KpE34SC7dkChn01UfsN9ld3D3pV2Py0Beb5GE8PJsPJmw4PPAHdzO4F+q9omduowc24cjOoAoC69zP8pr6RySV6kSkzchrmNW7un0mMv4E94Xe59ATfzwehG+j+WG5JKSZIoUS0+mQY=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY4PR10MB2038.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(346002)(39860400002)(136003)(366004)(396003)(186003)(31686004)(36756003)(53546011)(5660300002)(16526019)(26005)(66556008)(66946007)(6666004)(956004)(7416002)(2616005)(83380400001)(316002)(31696002)(54906003)(86362001)(110136005)(16576012)(478600001)(6486002)(2906002)(8676002)(66476007)(52116002)(4326008)(8936002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?TUVScDNZVit4MEpJMUdVK1k1UURWU2V2MjhNVXdnUFdXcXlrVGx3T0lFN0ZJ?=
 =?utf-8?B?ZmE0bDllSk9xSXEwTU5iY2t2NmdNc1BTYTc1enJoaXI3M3BhNTZKYWRSdWRt?=
 =?utf-8?B?ZSt1eUxoc3RkL2IxcytONG9xM0Jmb0JhZncvVGQzVHJPaDFGR0xSUzdhZWgv?=
 =?utf-8?B?elIxOW84TDBVc2tsQjZKKzFzUS9qMjhBQWFEZXQwb0JaeXpJek10cjBBU0l3?=
 =?utf-8?B?d3dnZlVRMVJTQ3huV0hLalFSWkdESEtaZEp4VGlOSUR0U3l3U1c0ZW9tcXpq?=
 =?utf-8?B?Si9Ddm5lTW1LUVVlV0F0NHFyWXJEK0pXZzJ1WVNNcGk3U1V5bTdMMEpzODVq?=
 =?utf-8?B?RG9KbllQaU55Nm5EaVlqZ1NEbXV4b3V2VnI0aGhTTnI5NDBETTFIdHJOekN0?=
 =?utf-8?B?NUU1YzhmRzVSMTd6OERUS0hua09SOEJnaHF3UGVyaTNVUEs4U3dBcXZjZFAv?=
 =?utf-8?B?bjRFQi9ncy9zdFNPZlJnUFZPSVo3MFhQRCtGekQ3aVVLKzduMUplSkdpcDhL?=
 =?utf-8?B?VjduSnVRVHFvL0F2WGlWMjJVUTZUQWZmNXFaYzBEVmd6aU1sc1plQy9ZenY3?=
 =?utf-8?B?cFRJdTVBZHZYMjdCcVFQVFVxRWNhS0UrWUpjTjBvckRTOXhxRlhaeUF0R1Rj?=
 =?utf-8?B?ekNkZm9GbFBhU3ZyaHZkQjhqUk44Y3FKWGlzMldRdmdrSk5tazh2QjNETmtF?=
 =?utf-8?B?V1J5cEtkcjRXMVRLNzhrUmw3b1NnTzdaWWZpMmZiY0paM29oZk04NVFtd1B2?=
 =?utf-8?B?R0ZYUVdGeVM1T2haSERGYWhZajdsQW5jcVUwNVZhTjhNM0p1YXRzNzkvbG1x?=
 =?utf-8?B?UlhCRVVUdDFUKyt0OTdpc3NnUEhPYmNFUk54Z1N5dU5VVXBwN3Z1Njkzbm54?=
 =?utf-8?B?WFlKM1dYcHA3amRYOWZwSzg0ZlJLdlk0QWxWSnRFS2p6YkFEbjd1S08rVEl0?=
 =?utf-8?B?S3FBTjRmRjNyNDRJQTgxL0N4b3I5K3A4a2laYitmRXdzajBkZ0NpVTdCNlpU?=
 =?utf-8?B?L2JmS2Q5RlhVbFlJaVdwaGF4NG10bENVMzdEN3dHaXRwRXgxZnBHa1d6L0Zn?=
 =?utf-8?B?ZUcvY3M4QVdVakpvN2tEOUN5ZFQ4UExycHJsU01mNDFsMXdHUHQ0dXdaaFNp?=
 =?utf-8?B?alNJM0dJbkhOWTlXYVFmWVVvNEtQYUNHWnJOZUlnSEp3dFNzelRROGM5LzVG?=
 =?utf-8?B?WlhpT3orMjNoalpHQXFVNWFDelNYaHE3c29saW5HRWUxOEVZQ2F1dldvV2NQ?=
 =?utf-8?B?cFV1T2lYMmpBZG42NFhOK2JTbGdDZ2RleWVZWkFmLzBIVGYyRFlRSHlncXV5?=
 =?utf-8?B?SXNNMzdJRHZpQTZqYWhQR09XOFZEcjhoOUR4QXNYWkZSMExZVlJWNTVwdTMx?=
 =?utf-8?B?TFMzbFEwL1FiTDBERTlOdFI5Si9MK2xKT3Q2WEUvcUxaOWk3Z3lrMlVoTFBI?=
 =?utf-8?B?TXVPZ2tsVWNQMGJVNEwrYWFDQzJJZFFQUElCY3BGaWxQRk5zbmFKZTZHQXRu?=
 =?utf-8?B?bVZZQWtwcWVaS0s0ZFN2dlJyR1ZqcEdiTituR2N0UFB5VjFHT0NPbGJ5Mm1O?=
 =?utf-8?B?Ykp6aGNMUzhDa0dPeEVMTXIyOXh1YnJNWmg0dTBac1ZYUDYxdDhFK1dkS25V?=
 =?utf-8?B?U3Z1UEJobm1KS1RsQ0FDNDJlMmhHYW9MMnhndmw0N1VTV1g3N2ZmQ0tqZmh1?=
 =?utf-8?B?M3R5eEVHNElFZitoUVpHUHJkVFJHOFpWdWY4Wkprd2ppSTJlelBiS2dWbk1J?=
 =?utf-8?Q?vhbpmbzC+IfxEsJ9GRwdK8po611/jRm11i/bND0?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 470950b9-87e4-4fe6-53e7-08d8d9faa65c
X-MS-Exchange-CrossTenant-AuthSource: CY4PR10MB2038.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Feb 2021 02:03:03.1534
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: VlVCS6NarfIVVOnzroBemh01sEzjWymY259nnK2X1SddYfW2O1917/x3BFfU2L6k2R3+DKWlp0OKeUzOd2PuiQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR10MB1591
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9906 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 mlxscore=0 spamscore=0
 mlxlogscore=999 adultscore=0 bulkscore=0 malwarescore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2102260014
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9906 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 clxscore=1015
 malwarescore=0 suspectscore=0 impostorscore=0 phishscore=0 mlxscore=0
 spamscore=0 mlxlogscore=999 bulkscore=0 priorityscore=1501 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2102260014
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


On 2/26/21 1:57 AM, Steven Rostedt wrote:
> On Thu, 25 Feb 2021 09:49:15 -0800
> Linus Torvalds <torvalds@linux-foundation.org> wrote:
>
>> On Thu, Feb 25, 2021 at 6:31 AM Steven Rostedt <rostedt@goodmis.org> wrote:
>>> Here's nothing special about %s in TP_printk. It uses the same code as
>>> printk() and what other string formatters use.
>>>
>>> What is special is that the print is on data that is stored from a previous
>>> time.
>> Well, technically that's not actually limited to just %s, although
>> that's the common case.
>>
>> All our magic "%p*" formats do the same thing: they print out not the
>> argument _value_, but something that the pointer value points to.
>>
>> So "%pD" takes a "struct file *" pointer, and follows it to the
>> dentry, and then from the dentry to the name. So it will in fact
>> follow pointers even more than "%s" does.
> Correct, as I've told people about that as well.
I was thinking about this yesterday.

Freeing a slab name generally means removing a kernel module.
See the callers of kmem_cache_destroy.

We need to fix some of the trace events that call TP_printk with %pS
to get a symbol of a kernel module that maybe removed later.

>
>> It might indeed be worth having a warning for TP_printk() about any of
>> the formats that follow a pointer, exactly because of the whole "by
>> the time it actually prints, the pointer may be long gone".
>>
> Just a comment? Or should we add some check that gives a warning for when
> one of these are used? That can be done at boot up or module load. (note, %s
> can be OK for some cases, as mentioned in a previous email).
>
> -- Steve
