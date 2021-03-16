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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 54997C433DB
	for <mm-commits@archiver.kernel.org>; Tue, 16 Mar 2021 12:44:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 244EB6503F
	for <mm-commits@archiver.kernel.org>; Tue, 16 Mar 2021 12:44:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232813AbhCPMnx (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 16 Mar 2021 08:43:53 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:50066 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232900AbhCPMnp (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 16 Mar 2021 08:43:45 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 12GCNpG6119629;
        Tue, 16 Mar 2021 12:42:39 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=Z0YNyzEfEqbghBc4HVSuAvs2T4OpPm3cfO9GFwIP8u0=;
 b=Aon4dWGRs8aFGDD50ws14P4jDteNYFCZIOMN1c1p7+duK4ff7zXC8WLiP5xfE4Mo7jc9
 Dm76Qh0RDkcoFfgEh2U729XLAoyXZTnzG8kIxVjEFtGIGYA1eQSTf1ltcUlFsV6C/cxL
 MtUrkJt7EUl6/MP3Uj0FZtQFGoch9DfilyT3LQaUsC2f4y5rW1SQdZAWRV36Tiv05lHT
 jevcs84WIQNfQtGi0IdgtxlDd0CyalmDG/CWvSAteskIx7rD4y2xg2wmZfh4XJH3iFXg
 4SxdFJubWzaPh63jEvibYkHwL+jQ84O9oFxVhcCy/nHjMgka3qomqZE1Bvfa2+lePfGu 1Q== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2120.oracle.com with ESMTP id 378p1nr0h7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 16 Mar 2021 12:42:39 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 12GCQ6iH119060;
        Tue, 16 Mar 2021 12:42:38 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2104.outbound.protection.outlook.com [104.47.55.104])
        by userp3030.oracle.com with ESMTP id 3797b017gd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 16 Mar 2021 12:42:38 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mH5La5luWUYnHI4RHtms+uTgAyNrq9shuMyxrvzyCmnFpoCSRMQoId6W1OvawfxOP95OHEyFKA3D0jkffhiCgN9EIn2j11tS4yFntBJkqRyqHOJ9loBhytmmla1zZWMU1Glja+BFiJUlSwfRclZLrRvXNr67mnKytxH9H+S4N6pGC78jF8j/7jCVF6SL/P9B8J/cc4B18giQbHJicSkmWJqGUiVUAEKWqHE2EJFJ37+xQJ+Si6OmaiDRVaYobfxLYvMe8joaED/89/LXRq428x2C915F6fqkbedGEFTngyx/lsEOOvG/E87Cfo40EwAgkbuxIywFYbM42Up6urYPJg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Z0YNyzEfEqbghBc4HVSuAvs2T4OpPm3cfO9GFwIP8u0=;
 b=BkOGWTt5ByQCa+/2f3n/NLFrYIx1cyDQCFQDN5TVDWBvhNd/YSpr6D7yyRVUCWRqCBG5RN62bLaet74xqfyMKyg6r6J3ygSE+FY30fr0prn6iCdbzHxUzSbnxtOqyOpUHyR8VYmSGdxH07gUSnwVN701O8KmyNzPpgpQ4EE61FnbwY1X4vaArx//RIvTUJP9+kj9ZvO9nArIUb/l5CpJKQ6369qfwIGEaRcO6YAv/6Nvx//68GyKIHHmcuq17ThJLyqolaZajK4Z/VheNOG5yqVvwn6ZlW6dLDG0gnQp+carwhYGsuIwPqG+XQEXpqan8bmfJflVL63v/dVbNJl6Cw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Z0YNyzEfEqbghBc4HVSuAvs2T4OpPm3cfO9GFwIP8u0=;
 b=SaphiuYCkcmvBQHSo0MFqTwkxzWQJ6APWclwEE86emh2OL4oTvHj4K/UVozXRnRo90fcymqXg6g17Ti0EgvxfKmBjSGdfC82cdgGTtYG+u43QJk0z0dFgVD0kW0WCFq96hMzrC/ifwV7SobrHn3e/90kVF5xJEkOglwSSHQ9XE4=
Authentication-Results: illinois.edu; dkim=none (message not signed)
 header.d=none;illinois.edu; dmarc=none action=none header.from=oracle.com;
Received: from CO1PR10MB4722.namprd10.prod.outlook.com (2603:10b6:303:9e::12)
 by MWHPR10MB1710.namprd10.prod.outlook.com (2603:10b6:301:9::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3933.32; Tue, 16 Mar
 2021 12:42:35 +0000
Received: from CO1PR10MB4722.namprd10.prod.outlook.com
 ([fe80::50a1:9424:e4df:af22]) by CO1PR10MB4722.namprd10.prod.outlook.com
 ([fe80::50a1:9424:e4df:af22%4]) with mapi id 15.20.3933.033; Tue, 16 Mar 2021
 12:42:35 +0000
Subject: Re: +
 kernel-crash_core-add-crashkernel=auto-for-vmcore-creation.patch added to -mm
 tree
To:     Dave Young <dyoung@redhat.com>, akpm@linux-foundation.org
Cc:     andreyknvl@google.com, bhe@redhat.com,
        christian.brauner@ubuntu.com, colin.king@canonical.com,
        corbet@lwn.net, frederic@kernel.org, gpiccoli@canonical.com,
        jpoimboe@redhat.com, keescook@chromium.org, masahiroy@kernel.org,
        mchehab+huawei@kernel.org, mike.kravetz@oracle.com,
        mingo@kernel.org, mm-commits@vger.kernel.org, paulmck@kernel.org,
        peterz@infradead.org, rdunlap@infradead.org, rostedt@goodmis.org,
        rppt@kernel.org, saeed.mirzamohammadi@oracle.com,
        samitolvanen@google.com, sboyd@kernel.org, tglx@linutronix.de,
        vgoyal@redhat.com, yifeifz2@illinois.edu
References: <20210304003559.ZchAywVJv%akpm@linux-foundation.org>
 <20210308012549.GA3065@dhcp-128-65.nay.redhat.com>
From:   John Donnelly <john.p.donnelly@oracle.com>
Message-ID: <d3bcd60c-326b-d3a2-3452-f732009449c2@oracle.com>
Date:   Tue, 16 Mar 2021 07:42:20 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.0
In-Reply-To: <20210308012549.GA3065@dhcp-128-65.nay.redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [47.220.66.60]
X-ClientProxiedBy: AM0PR03CA0010.eurprd03.prod.outlook.com
 (2603:10a6:208:14::23) To CO1PR10MB4722.namprd10.prod.outlook.com
 (2603:10b6:303:9e::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.1.106] (47.220.66.60) by AM0PR03CA0010.eurprd03.prod.outlook.com (2603:10a6:208:14::23) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3933.31 via Frontend Transport; Tue, 16 Mar 2021 12:42:26 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 7381ba88-403b-41ec-2a0c-08d8e878f97f
X-MS-TrafficTypeDiagnostic: MWHPR10MB1710:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <MWHPR10MB171083A91B7440253A1E4E0EC76B9@MWHPR10MB1710.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: DD1IU/IF8veufqTVaieXOplrU65uBpAJfWk/LDJp7g/Fzpdma5kTte9bvt8pDeSamUcgPInHaUv2B3CROgwsnFnMVZe2YNS4WNoK2CMN/3YFxRNXc8sygQj22tI6+hR1SSOJ2H56vUSWxfoFyaIEtEkbKJcjiV8W6sP6IR9VBsfG5tgqEcqcmkAc24RLl3r6ZtuE6QiF4nwfetI5Bqk31xgPNkDqWeNC9A5fAklTWphUcGbIViRMcK0zJ9M2u92342qWineaFcwTLkLj4XfbsfNS9fJvOD3kMqCxC1thwe4fVUUNRc3Mx7rinpNi3KlbY4QbpoeV75WXHFuFhRYA/oCNE+iq4KHgsxNw+JQ0GuZ6PY300FDVTIFULtaYUJFVCUA0WPXgwSWSSYn2ExpYIDKiJp4M6FldISGDxXxipTNEoDpz5THZ1lZ4FMkkWnyyaxpv+Gu8F0n5F4MnpnUV9uBq5Ym9wDcnR4dqHwUUkEx0EaM4rItrGJguXzxNwoCyuNGKRACMigpmuT3mOzeqedMnun1LGgG1o8YjUw28jvW+8tiDVuAOq4/pGlOKKSs3aJHPzQoXOjsJmNBOorzFkSt2PjfwtGxTk7Ol7Seijn3PhjYA2TGlBRecjPxQOFiDkgiBGTo/1z2nnwJwCI1gjNpP2I8pkv069HAwYQcz+MODc0AUnHX8hGZ6nFxhDMGm+0izV10fgbuqB11Q6E4CDeE/HnzCI1a7ZfrfaTiWokc=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR10MB4722.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(136003)(396003)(346002)(376002)(39860400002)(4326008)(5660300002)(31696002)(6486002)(8676002)(36756003)(2906002)(66946007)(2616005)(26005)(66556008)(6666004)(66476007)(8936002)(186003)(966005)(86362001)(16576012)(316002)(7416002)(478600001)(83380400001)(16526019)(31686004)(53546011)(956004)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?eWlHcWpMbFV0R0dvQ0UralBJVHlCY3M1Yks1TlY3VUY1KzZ6SEQwSFRrSDJL?=
 =?utf-8?B?Wlo3aFc5TGgrTmRsQ3hKcyt3eC9mQUNkbTFnWGNmRy8xVEdjSlNxUEdWdXN5?=
 =?utf-8?B?WWZKbmJEMEpnblhoZFhYN01FWVdXZHYwTWtKL2FsRWROV0Z4eDNJMUxqVS81?=
 =?utf-8?B?RHd5dTZ3SjEwV0UvNHhjNjI0amd1UFhtSGRtY2R5QUs4aEhGNFlKdkxobUx3?=
 =?utf-8?B?S3EyOVpabkRMUXU2cExBckhJR0tKRkFEbjM1L1VJanpPcHJpWTBuZG02OStN?=
 =?utf-8?B?VXgxVmN6UCtPMEMzaGhHdG1Jc0hJaHk0TlE2cmtGekhwUS9HcWplWjVtUHBG?=
 =?utf-8?B?eVR1WWllaFlLRStIWVlobTUzS3Z6ckEwU21XZ0ZENHV5NW5mMHNWaXFRdjBS?=
 =?utf-8?B?R1hRcnhWN2xTK1BjUTBhaWpqaVRYOUg0ZmZNbVZtWGUySnNFWmlOcnZiQzNK?=
 =?utf-8?B?L1YwTWFIWktwK3ZxMjFkeDBsTGpqenZhbnNIWkRQeHNzWWFEMFJFZTNyTVFh?=
 =?utf-8?B?cUVrbjRVY0RNMTZnNFpHUVdSRjdQcGt1cE94QTJMZlg5SVZBVkVFY3ltVFYw?=
 =?utf-8?B?K2NGY3F6a3hHSmxkTjQwNlhqcW43U0xjYVR0QjRxOHJlNzN6NzhQUysxM0Zz?=
 =?utf-8?B?STNLc0JjRXF1U1dPQkNGSk5qVnNZNnJKWDE2TGRSamFaTGxBSlpYT2xFMkY5?=
 =?utf-8?B?czNMaWhUcWRGUmoxWk11akN1RGJqQnpZcjBnb3FRN3V5bER1Y0JzR284b3N4?=
 =?utf-8?B?Ty9sbnJHNll5V3VwUmtseTRIWC9EVk1YZnBpYjN6aGVMeUt5eS9WWEtHTEZv?=
 =?utf-8?B?NzlucThKNlRrT3R6YSt1MXphbHcyUk9LRHRaMVptQ25vbDFrSG5iekh2NWZa?=
 =?utf-8?B?dEtBWXpsR29Oemtjbnd5UzVEYXpnOGlOeit5aWFJVHFIRkhDQlNqWDZKa09z?=
 =?utf-8?B?aUd0WUFPNGlHVk5UVVpTTndMMGR6YWJzVzZpWDFJN3ZVS0ZyQXR2SDA5dnBT?=
 =?utf-8?B?V096MXJOVW52ZENmZDRqVE1yVU9ESVZtUmM2dEJNUXhBbGJqWWdhRnVkcnBZ?=
 =?utf-8?B?VmhSd1I0MTRkT3RpajBlVUg3Y3ZLa0dwM2JwSGt2Tm52VmhZb2licHAyUml3?=
 =?utf-8?B?cVNLNUhhd0t3b2RvUkJqd243ZkJaSkwvU3NMMnI4YmR4SjFwTlVNMmI4bitZ?=
 =?utf-8?B?clA1c2l6Q2IyRUxMdmJHa3ZISkNaektXTXZJdi81VDNSZEJwRFFVeENmelBD?=
 =?utf-8?B?NExSWlEwNWZpNURaQS9nREk2MnZBUnBaRVgwWnRFVE1pMmpocEtxNE1JVFBr?=
 =?utf-8?B?cXNmc3dnYUMvbjNqNkx2SElnUlhQVVFJKzNBUHNWK3orM2NDVHE5aHBLbkcx?=
 =?utf-8?B?b051ZVRXSDFLbjhOZStzRUkzVG5WTjdBemgzd0x1UFh4L251MUc2eDJtSnNH?=
 =?utf-8?B?YkZLVzVubUsrRGl2UHZNWjcrVVFxT0VnNmxzK1Flc2J4ZktlZlpCT2Fxd2dz?=
 =?utf-8?B?TUtsanZ3YU41RHFqSVB5T3BMV0tQRmJIZ0w3WEVLNktSYnlHOUhVY21hSTRL?=
 =?utf-8?B?RzNhUFZEeWd6MS9nNFo2TDBnMTZkaTNTaHZtZVdWZ3dkTTFsU1ViRXQvKzVL?=
 =?utf-8?B?bUVWdWk2M2JYRGFWamJGTmhFeHg4Y1RWV1pWRHB4d0d5NDJyT3o4UU5uOTFa?=
 =?utf-8?B?czIvWHlBcFVuYkoyVElyNFBRVThGanNaVldGN1pNcEVHajR6dTZSRGxqTGtY?=
 =?utf-8?Q?Pg8oqq56SMy8cZJeSLSID+BnIISRlemXAJI4fR1?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7381ba88-403b-41ec-2a0c-08d8e878f97f
X-MS-Exchange-CrossTenant-AuthSource: CO1PR10MB4722.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Mar 2021 12:42:35.7085
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: fPMAqxpjqAgYCu0xGVJndivjvT+kofGvaPRHWefoKjKwQL4n0li8NuXqS1Yk+K/ZcGmz/g9RQou5g+9SUKUPQZqntoxulFKTkB+gSh/WAgI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR10MB1710
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9924 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 spamscore=0 bulkscore=0
 malwarescore=0 adultscore=0 mlxscore=0 mlxlogscore=999 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2103160087
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9924 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 suspectscore=0 adultscore=0
 spamscore=0 clxscore=1011 phishscore=0 malwarescore=0 priorityscore=1501
 bulkscore=0 mlxlogscore=999 lowpriorityscore=0 impostorscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2103160087
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

On 3/7/21 7:25 PM, Dave Young wrote:
> Hi Andrew,
> 
> Thank you for taking this :)  But seems the Acked/Tested chain should be
> corrected.
> On 03/03/21 at 04:35pm, akpm@linux-foundation.org wrote:


Hi,

Was this resolved ? Has this feature  been promoted to a build yet ?

Thank you,

John.


>>
>> The patch titled
>>       Subject: kernel/crash_core: add crashkernel=auto for vmcore creation
>> has been added to the -mm tree.  Its filename is
>>       kernel-crash_core-add-crashkernel=auto-for-vmcore-creation.patch
>>
>> This patch should soon appear at
>>      https://urldefense.com/v3/__https://ozlabs.org/*akpm/mmots/broken-out/kernel-crash_core-add-crashkernel*3Dauto-for-vmcore-creation.patch__;fiU!!GqivPVa7Brio!JMfEfDVdzTrgoMAlSaYkEtc5MAdJCoKNyorgwfpAnJXaMccPOze91zumSEfKLaUI4tqE$
>> and later at
>>      https://urldefense.com/v3/__https://ozlabs.org/*akpm/mmotm/broken-out/kernel-crash_core-add-crashkernel*3Dauto-for-vmcore-creation.patch__;fiU!!GqivPVa7Brio!JMfEfDVdzTrgoMAlSaYkEtc5MAdJCoKNyorgwfpAnJXaMccPOze91zumSEfKLb_gfDew$
>>
>> Before you just go and hit "reply", please:
>>     a) Consider who else should be cc'ed
>>     b) Prefer to cc a suitable mailing list as well
>>     c) Ideally: find the original patch on the mailing list and do a
>>        reply-to-all to that, adding suitable additional cc's
>>
>> *** Remember to use Documentation/process/submit-checklist.rst when testing your code ***
>>
>> The -mm tree is included into linux-next and is updated
>> there every 3-4 working days
>>
>> ------------------------------------------------------
>> From: Saeed Mirzamohammadi <saeed.mirzamohammadi@oracle.com>
>> Subject: kernel/crash_core: add crashkernel=auto for vmcore creation
>>
>> This adds crashkernel=auto feature to configure reserved memory for vmcore
>> creation.  CONFIG_CRASH_AUTO_STR is defined to be set for different kernel
>> distributions and different archs based on their needs.
>>
>> Link: https://urldefense.com/v3/__https://lkml.kernel.org/r/20210223174153.72802-1-saeed.mirzamohammadi@oracle.com__;!!GqivPVa7Brio!JMfEfDVdzTrgoMAlSaYkEtc5MAdJCoKNyorgwfpAnJXaMccPOze91zumSEfKLfp-wcYj$
>> Signed-off-by: Saeed Mirzamohammadi <saeed.mirzamohammadi@oracle.com>
>> Signed-off-by: John Donnelly <john.p.donnelly@oracle.com>
>> Tested-by: John Donnelly <john.p.donnelly@oracle.com>
>> ed-by: Dave Young <dyoung@redhat.com>
> 
> Seems above line is not correct, s/ed-by/Acked-by
> Otherwise there is also ack from Baoquan, and Tested-by from Kairui.
> 
>> Cc: Baoquan He <bhe@redhat.com>
>> Cc: Vivek Goyal <vgoyal@redhat.com>
>> Cc: Jonathan Corbet <corbet@lwn.net>
>> Cc: "Paul E. McKenney" <paulmck@kernel.org>
>> Cc: Randy Dunlap <rdunlap@infradead.org>
>> Cc: Thomas Gleixner <tglx@linutronix.de>
>> Cc: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
>> Cc: Mike Kravetz <mike.kravetz@oracle.com>
>> Cc: "Guilherme G. Piccoli" <gpiccoli@canonical.com>
>> Cc: Kees Cook <keescook@chromium.org>
>> Cc: "Peter Zijlstra (Intel)" <peterz@infradead.org>
>> Cc: Ingo Molnar <mingo@kernel.org>
>> Cc: "Steven Rostedt (VMware)" <rostedt@goodmis.org>
>> Cc: YiFei Zhu <yifeifz2@illinois.edu>
>> Cc: Josh Poimboeuf <jpoimboe@redhat.com>
>> Cc: Mike Rapoport <rppt@kernel.org>
>> Cc: Masahiro Yamada <masahiroy@kernel.org>
>> Cc: Sami Tolvanen <samitolvanen@google.com>
>> Cc: Frederic Weisbecker <frederic@kernel.org>
>> Cc: Christian Brauner <christian.brauner@ubuntu.com>
>> Cc: Stephen Boyd <sboyd@kernel.org>
>> Cc: Andrey Konovalov <andreyknvl@google.com>
>> Cc: Colin Ian King <colin.king@canonical.com>
>> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
>> ---
>>
>>   Documentation/admin-guide/kdump/kdump.rst       |    3 +-
>>   Documentation/admin-guide/kernel-parameters.txt |    6 ++++
>>   arch/Kconfig                                    |   20 ++++++++++++++
>>   kernel/crash_core.c                             |    7 ++++
>>   4 files changed, 35 insertions(+), 1 deletion(-)
>>
>> --- a/arch/Kconfig~kernel-crash_core-add-crashkernel=auto-for-vmcore-creation
>> +++ a/arch/Kconfig
>> @@ -14,6 +14,26 @@ menu "General architecture-dependent opt
>>   config CRASH_CORE
>>   	bool
>>   
>> +config CRASH_AUTO_STR
>> +	string "Memory reserved for crash kernel"
>> +	depends on CRASH_CORE
>> +	default "1G-64G:128M,64G-1T:256M,1T-:512M"
>> +	help
>> +	  This configures the reserved memory dependent
>> +	  on the value of System RAM. The syntax is:
>> +	  crashkernel=<range1>:<size1>[,<range2>:<size2>,...][@offset]
>> +	              range=start-[end]
>> +
>> +	  For example:
>> +	      crashkernel=512M-2G:64M,2G-:128M
>> +
>> +	  This would mean:
>> +
>> +	      1) if the RAM is smaller than 512M, then don't reserve anything
>> +	         (this is the "rescue" case)
>> +	      2) if the RAM size is between 512M and 2G (exclusive), then reserve 64M
>> +	      3) if the RAM size is larger than 2G, then reserve 128M
>> +
>>   config KEXEC_CORE
>>   	select CRASH_CORE
>>   	bool
>> --- a/Documentation/admin-guide/kdump/kdump.rst~kernel-crash_core-add-crashkernel=auto-for-vmcore-creation
>> +++ a/Documentation/admin-guide/kdump/kdump.rst
>> @@ -285,7 +285,8 @@ This would mean:
>>       2) if the RAM size is between 512M and 2G (exclusive), then reserve 64M
>>       3) if the RAM size is larger than 2G, then reserve 128M
>>   
>> -
>> +Or you can use crashkernel=auto to choose the crash kernel memory size
>> +based on the recommended configuration set for each arch.
>>   
>>   Boot into System Kernel
>>   =======================
>> --- a/Documentation/admin-guide/kernel-parameters.txt~kernel-crash_core-add-crashkernel=auto-for-vmcore-creation
>> +++ a/Documentation/admin-guide/kernel-parameters.txt
>> @@ -753,6 +753,12 @@
>>   			a memory unit (amount[KMG]). See also
>>   			Documentation/admin-guide/kdump/kdump.rst for an example.
>>   
>> +	crashkernel=auto
>> +			[KNL] This parameter will set the reserved memory for
>> +			the crash kernel based on the value of the CRASH_AUTO_STR
>> +			that is the best effort estimation for each arch. See also
>> +			arch/Kconfig for further details.
>> +
>>   	crashkernel=size[KMG],high
>>   			[KNL, X86-64] range could be above 4G. Allow kernel
>>   			to allocate physical memory region from top, so could
>> --- a/kernel/crash_core.c~kernel-crash_core-add-crashkernel=auto-for-vmcore-creation
>> +++ a/kernel/crash_core.c
>> @@ -7,6 +7,7 @@
>>   #include <linux/crash_core.h>
>>   #include <linux/utsname.h>
>>   #include <linux/vmalloc.h>
>> +#include <linux/kexec.h>
>>   
>>   #include <asm/page.h>
>>   #include <asm/sections.h>
>> @@ -250,6 +251,12 @@ static int __init __parse_crashkernel(ch
>>   	if (suffix)
>>   		return parse_crashkernel_suffix(ck_cmdline, crash_size,
>>   				suffix);
>> +#ifdef CONFIG_CRASH_AUTO_STR
>> +	if (strncmp(ck_cmdline, "auto", 4) == 0) {
>> +		ck_cmdline = CONFIG_CRASH_AUTO_STR;
>> +		pr_info("Using crashkernel=auto, the size chosen is a best effort estimation.\n");
>> +	}
>> +#endif
>>   	/*
>>   	 * if the commandline contains a ':', then that's the extended
>>   	 * syntax -- if not, it must be the classic syntax
>> _
>>
>> Patches currently in -mm which might be from saeed.mirzamohammadi@oracle.com are
>>
>> kernel-crash_core-add-crashkernel=auto-for-vmcore-creation.patch
>>
> 
> Thanks
> Dave
> 

