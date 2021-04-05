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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2338CC433ED
	for <mm-commits@archiver.kernel.org>; Mon,  5 Apr 2021 22:48:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E212261399
	for <mm-commits@archiver.kernel.org>; Mon,  5 Apr 2021 22:48:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236209AbhDEWtB (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 5 Apr 2021 18:49:01 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:39076 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236203AbhDEWtA (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 5 Apr 2021 18:49:00 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 135MjWDU182615;
        Mon, 5 Apr 2021 22:47:42 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=E3k7j9GT+lMSIscnu6/7p6xTYBYxkY5TpHDpfVZojZE=;
 b=cHfAsH+E31WkK/pjnxUn77HWH63KSbY/N+Ht4IgsQHPTq7csEhzYs3byXMg5r/NbmgNi
 NCEX1W7xAVjJps3QUMma8tegc7TiFcV37dVdi9psvjXuBJI5gaY8xcAWiupQhWeScgBN
 1zLrqejSQ2jxwEZwTouX2L/yutOUevObzsvPucy92tLMAfai+qKFni61mH5ctiw2EBLf
 teSb2sBjrgonyk1dImGyVuWpgAf95NwQNZoRTWZlLBLaTpqUcCQk8ioJXlCbtAIPOEPw
 4OYxn0XcuWWdaHIDUTFjYtUnRqmPhxtOh4Nd+/ueAwI8jJXNzvpA0ZHKSCRFAT8NSrWg LA== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 37q3f2bjy4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 05 Apr 2021 22:47:41 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 135Mexkk194659;
        Mon, 5 Apr 2021 22:47:41 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2045.outbound.protection.outlook.com [104.47.66.45])
        by userp3020.oracle.com with ESMTP id 37q2ptg2rc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 05 Apr 2021 22:47:41 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=L4uZUu1ZGqRB9S6qp8zy/FvLff7A4nard0tpMLjR0xH0lZyYNpgYHCrPqfI7EUvlJBUTsucNmuFKdIn/sLFSLyIKZFI1t6Ind+hOqVLBlp/TAE6Te/Pou8Qp2PxfiZMYIMccCj/X3NwXm0EiIb2Od9jMnvoegXF2jq2WCxAPhCgIseXudCCSai3tEPWuiPG72Q+m5nDfYkhQFonc18UMMDZlGWtRXPburcEPsaYSuFiZ/mhpHod2L9zKBXX451CJhg8dU5nYQkI91Q2t52o2dA8qd6imzm73sPHp2KfoqVoP7M13A/iGPVe7KXOSDDBp+eZkEeZL3QFudnGkxe9laQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=E3k7j9GT+lMSIscnu6/7p6xTYBYxkY5TpHDpfVZojZE=;
 b=k2q2AaGRr+d60Chbr5nmiLuc+X58kmVQiNquZCvmVSjUIz+JXJanOksaIipC50uWOhJ15hn2V+1caz4cCvS8G753JIWVuGvsHOOJIuD2J1mcUPwaGkbppuKFqkuL7T6oUgsUe9MX50KGIYHQKtQUu/Tk7Je94mbGEsXvQvL421CEkhq6S5YcATb8xHuT2mw+seFMafWdETB8wr96mn6C1Gsr4391FanN4XBOQiOmEwvuL2nGdhvYh+CUR5RTV8PJyuAxaXc2hTD8ASPPGDstUZEmFeZLeM3WwaCIRYvHF9/DssDNak3UPeahWkpJt5k7kvsHX71M4WupjV4VBMX83Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=E3k7j9GT+lMSIscnu6/7p6xTYBYxkY5TpHDpfVZojZE=;
 b=OEwjC/j/NJ602DKX+1q5FbTfNpz1ZrvwX6LZNIIZi93dbJ6zqEK1yqHO7Hirup9JHdYumgjaGwyAyIbX8Y7J6sS31h6ieh2LNVy0zfh0u9LvKsC03M8mE1QQUWRjjdxNbqT025QsB1Wn5dgm6MCUrRS/+xRMfKTbjVEpwAUX3PY=
Received: from CO1PR10MB4722.namprd10.prod.outlook.com (2603:10b6:303:9e::12)
 by CO1PR10MB4609.namprd10.prod.outlook.com (2603:10b6:303:91::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3999.29; Mon, 5 Apr
 2021 22:47:38 +0000
Received: from CO1PR10MB4722.namprd10.prod.outlook.com
 ([fe80::754c:590f:64cf:4087]) by CO1PR10MB4722.namprd10.prod.outlook.com
 ([fe80::754c:590f:64cf:4087%4]) with mapi id 15.20.3999.032; Mon, 5 Apr 2021
 22:47:38 +0000
Subject: Re: +
 kernel-crash_core-add-crashkernel=auto-for-vmcore-creation.patch added to -mm
 tree
To:     akpm@linux-foundation.org, andreyknvl@google.com, bhe@redhat.com,
        christian.brauner@ubuntu.com, colin.king@canonical.com,
        corbet@lwn.net, dyoung@redhat.com, frederic@kernel.org,
        gpiccoli@canonical.com, jpoimboe@redhat.com, keescook@chromium.org,
        masahiroy@kernel.org, mchehab+huawei@kernel.org,
        mike.kravetz@oracle.com, mingo@kernel.org,
        mm-commits@vger.kernel.org, paulmck@kernel.org,
        peterz@infradead.org, rdunlap@infradead.org, rostedt@goodmis.org,
        rppt@kernel.org, saeed.mirzamohammadi@oracle.com,
        samitolvanen@google.com, sboyd@kernel.org, tglx@linutronix.de,
        vgoyal@redhat.com, yifeifz2@illinois.edu,
        John Donnelly <john.p.donnelly@oracle.com>
References: <20210304003559.ZchAywVJv%akpm@linux-foundation.org>
From:   john.p.donnelly@oracle.com
Message-ID: <7a906327-a2f3-14b4-d59f-26e4273ed1f7@oracle.com>
Date:   Mon, 5 Apr 2021 17:47:21 -0500
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.8.0
In-Reply-To: <20210304003559.ZchAywVJv%akpm@linux-foundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [47.220.66.60]
X-ClientProxiedBy: LO4P123CA0168.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:18a::11) To CO1PR10MB4722.namprd10.prod.outlook.com
 (2603:10b6:303:9e::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from dhcp-10-175-19-247.vpn.oracle.com (47.220.66.60) by LO4P123CA0168.GBRP123.PROD.OUTLOOK.COM (2603:10a6:600:18a::11) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3999.28 via Frontend Transport; Mon, 5 Apr 2021 22:47:28 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 51f23c0b-f7c3-463d-db14-08d8f884cfe4
X-MS-TrafficTypeDiagnostic: CO1PR10MB4609:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <CO1PR10MB460906929F7E3156A69EADB6C7779@CO1PR10MB4609.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ZlxzF1oa0ugtOaj8OY69HpoubBgdLuwYFy87ciN0UcAdoLHyQsS43U0TsM9qgq/Xc+Py2yoQ8qE5o/w995lfYeAvnXmzHmrQoOspVPqk2GDuBY2UxA9ZPeaj1bUPVLIjGjoNRtTqUu+wkS/6khZ9WV7oMALovn54EbmZAXraahPB5mZ/H8H9e2SP76t6nC+XDewDEFDNxkxJQ9FV+fYPFdRbAVbEcUhmmCOSYlixvGIXKLAYIFcllk2PilTTQzrhaf9onclwpwAlrt0argjjoyefNsvW9CX9MO+7gfdJsr82mUvFqzd2K56wyEJarEUxCcICC2ZjiJY2i4zj6DLLzNqZmaYrcP0x5htY0j0C6O5XfiAjT0quVgv/Y7sXdjGCwKq6khOxuh7TQskcQBuweMWeownnnB3K722Tx9ydgDdDRxy3RD9aWryCCH3V99Sa/RSQ9i981xRaNMoDeObbyJIm8lwn5ZDIwaULReOXSzCCHGPWgIyG4hiJ4JSal0WwoEsppzELLpfGdjwZ6PsqIbObZ+85JCKmiA8MrPmvjX6WALWAEA2iUd2oQeH8gNzYPGyTgpjryIFXG05nhvoCIOH/uq9WQV1c2TY/snrdN3c3vW9qa2xBDVh2h5XK72awT5C4I98fST5TPEcTtofgDADy6L/NQUmGVBzI6KBjpYoG8NFyJUHYHM6VbeAcHDB3EYfr1xi/Fx96U5QwRIChVC4anIVpLOXG1wNVSiqkdTJ+G8KSgCShQPg9CIw8VIewnstxxFzRB12TCe5aGFkK9NnhPnDGBwbVhXi/9irJ7V8=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR10MB4722.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(136003)(346002)(396003)(366004)(376002)(921005)(956004)(16526019)(186003)(2616005)(31686004)(316002)(36756003)(26005)(9686003)(6862004)(2906002)(5660300002)(478600001)(37006003)(83380400001)(86362001)(6666004)(31696002)(66556008)(66476007)(66946007)(7696005)(966005)(7416002)(8936002)(38100700001)(53546011)(6486002)(8676002)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?QW96N1ZvN2t4QWw2YzFzUmtRbnBNQmxrajE3TjIvSHR3YVpYeDVMMmZpVGFi?=
 =?utf-8?B?N3lqeVZSY3hBekRvYzVlUVZuWUpDWnlUd1pOTGsvRnNseHVlQXV1N09jMzlD?=
 =?utf-8?B?NVJFb0NyVTZVVWZ3Szh3K2o4aEoxRExVeVpybFRlcG9iWnR6QVVWdVlLWE95?=
 =?utf-8?B?aDhJTU95bnNYOHlyK0dFSUNlcnlCZHhHaVBTVXdsWVZUbVhkTDhpVVhMclB4?=
 =?utf-8?B?aUF3T1IwOWg4Zys5TkR1L09sRHEvTGVaNXVTVEJuaGwrck1NdW9TRWRpMnhQ?=
 =?utf-8?B?a0dkRTFmN1pSdDROYkkrNHJ0NFVrWk93bXY0aDZpc1dtcGZsTkNwQU1IQUZN?=
 =?utf-8?B?UGlRRlN3cXJUdXRSSlBVUlFBd3ZrVXVaRzM2dkpxN2NJWkFUSHlDUjFXN1lt?=
 =?utf-8?B?eUtRSm5tU3E5WlhzaE1SV0YzNWpjc3IwdFRBaENpNkdxMUJ1elJsRCtFUk5w?=
 =?utf-8?B?VjNKRnRNSFh0S0lwRXdDdUJtUXZHSGFlSy94c0UwT09iazc2TXpHRE1PejJz?=
 =?utf-8?B?TVdUc1AybXRPQThOUWptdmgwZ2lyYkRQWTV1Q1BsWWQraTR4UkNjUzFPVHVH?=
 =?utf-8?B?bkZnZVUwQTAwZUJCRHplVjdTU0gzLzVtMEFhcHFidmtHcDFPSW14SExYRytV?=
 =?utf-8?B?NFF5Q21yOUk1L2RWTmxsQXlaZnZUdWVwa1hGU1RPZGhjUnNxWW1TajhXcFJJ?=
 =?utf-8?B?RzRTSC9zTU9XakZ5bEhTOGRCc2ZycU5hTW1pSC92MVFXMnRLYVhTeUpHbHVl?=
 =?utf-8?B?b0VOMWdObHA2ZTVDS2RiNlRsY2tzRlZXOUVFTU51WXpyWi9pT2YrNUZ2NUxw?=
 =?utf-8?B?TC9xU1VvV0ZWZVNGR3BhaGgvQkdLb1hTV25tQXA3cERvajErS2hHVUVLTmFa?=
 =?utf-8?B?S1AySUM0OGNqbTE0NlJteUlCS3hSdWJjaGJQWmpLcXQ0UjVLVmtSdTZwTXQv?=
 =?utf-8?B?SmpERGpncmkyMHZvODlEVUlrbFQwYUpETnYzU2NUTXdONnhBdjBpMkhhTjhV?=
 =?utf-8?B?UlRiYi9kTHVLNGkxRlpmKzZyMkRWNVRjWGFCSTdrY1NETUlZZktsSnNzY1Az?=
 =?utf-8?B?UEhPNm1oUlh5azVRUTMvQlJyOGd5R1RnSkNiYnNxdHliUDNUckozcVN4SnJY?=
 =?utf-8?B?dnRtS1h4WnhBanUzRW93UGNyVUFISVFKSE1kZ0w3cUtvanJSbDJwamRHOGk4?=
 =?utf-8?B?MHEwZlpoc2lvNzRlZkNaMUQ4anUzalBxdlR4dzdscVFuditzTE0yNDBHb3BU?=
 =?utf-8?B?YjNidTFqTU9JaU1wamRiSWJneXlRbzhaRVNUaGVucTNqSTU1REdpVzFrdmJJ?=
 =?utf-8?B?V2pmR2pWak11MW9GVVF4RnNHOW92Mk1YRjkzR2lYZ0Z2em0wUDNEZWp5aWha?=
 =?utf-8?B?RFFwL3pmZnBsV052OTEzNFEyVnF5ZjY3aUZlcE80dHZJSWovNHdla0tQR0Nz?=
 =?utf-8?B?UDBzWkR3S28rajJGUm95M0tyVnUzck5tbWY1YXI4SXQ2Y215djEvT0pZdWtz?=
 =?utf-8?B?QmNudWFqNm8weTRvNzRqN2tDVlFNVCtQbk1CTU9pQmVQaWhVcytMMDFVK0xj?=
 =?utf-8?B?LytGcHhEK3B0MlpLYkFDR0I2N29adXRjaCtLUHY4ZCtrbDBPb2gyUmdxU3Er?=
 =?utf-8?B?eXlFOUxMVW5xS3VMS3MxeEc2OHNFYUVwTFp5dmNYeFBBV3hPaWRLVGVkUitx?=
 =?utf-8?B?MEdsR25jYnpwTUNqakZqSCsrRm1KaEZJWVlRRjg4TDhKeDNWYk9JTmN6ZVlO?=
 =?utf-8?Q?ro7x2gLgmXD+bRMnfFwyRnu8+vtYZbSNvi6iRVc?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 51f23c0b-f7c3-463d-db14-08d8f884cfe4
X-MS-Exchange-CrossTenant-AuthSource: CO1PR10MB4722.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Apr 2021 22:47:38.3285
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: qaZ6xjsf567nP9+60zMntPZ0WCkRccT+stqLn2/dHN9dCXD3btR2W0vU3Y5GAP1drZIaFClBVd6fsZVnxX9lIs9gM5/Q5Aah5Os92njvmU8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR10MB4609
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9945 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 suspectscore=0
 malwarescore=0 phishscore=0 bulkscore=0 mlxscore=0 spamscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104030000 definitions=main-2104050150
X-Proofpoint-GUID: ObCwr3qn9NtNKRx_dsZYsIQ7cPPFyi2L
X-Proofpoint-ORIG-GUID: ObCwr3qn9NtNKRx_dsZYsIQ7cPPFyi2L
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9945 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxscore=0 suspectscore=0
 spamscore=0 impostorscore=0 mlxlogscore=999 malwarescore=0 adultscore=0
 lowpriorityscore=0 clxscore=1015 priorityscore=1501 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104030000
 definitions=main-2104050150
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

On 3/3/21 6:35 PM, akpm@linux-foundation.org wrote:
> 
> The patch titled
>       Subject: kernel/crash_core: add crashkernel=auto for vmcore creation
> has been added to the -mm tree.  Its filename is
>       kernel-crash_core-add-crashkernel=auto-for-vmcore-creation.patch
> 
> This patch should soon appear at
>      https://urldefense.com/v3/__https://ozlabs.org/*akpm/mmots/broken-out/kernel-crash_core-add-crashkernel*3Dauto-for-vmcore-creation.patch__;fiU!!GqivPVa7Brio!MLHY1w_3hV0y52rhRxKhKOowN74en2d227vz_f7srC7CflpUH-pI6n994y5xz_jryw2c$
> and later at
>      https://urldefense.com/v3/__https://ozlabs.org/*akpm/mmotm/broken-out/kernel-crash_core-add-crashkernel*3Dauto-for-vmcore-creation.patch__;fiU!!GqivPVa7Brio!MLHY1w_3hV0y52rhRxKhKOowN74en2d227vz_f7srC7CflpUH-pI6n994y5xz4Skx6yF$
> 
> Before you just go and hit "reply", please:
>     a) Consider who else should be cc'ed
>     b) Prefer to cc a suitable mailing list as well
>     c) Ideally: find the original patch on the mailing list and do a
>        reply-to-all to that, adding suitable additional cc's
> 
> *** Remember to use Documentation/process/submit-checklist.rst when testing your code ***
> 
> The -mm tree is included into linux-next and is updated
> there every 3-4 working days
> 
> ------------------------------------------------------
> From: Saeed Mirzamohammadi <saeed.mirzamohammadi@oracle.com>
> Subject: kernel/crash_core: add crashkernel=auto for vmcore creation
> 
> This adds crashkernel=auto feature to configure reserved memory for vmcore
> creation.  CONFIG_CRASH_AUTO_STR is defined to be set for different kernel
> distributions and different archs based on their needs.
> 
> Link: https://urldefense.com/v3/__https://lkml.kernel.org/r/20210223174153.72802-1-saeed.mirzamohammadi@oracle.com__;!!GqivPVa7Brio!MLHY1w_3hV0y52rhRxKhKOowN74en2d227vz_f7srC7CflpUH-pI6n994y5xz1KwmmHx$
> Signed-off-by: Saeed Mirzamohammadi <saeed.mirzamohammadi@oracle.com>
> Signed-off-by: John Donnelly <john.p.donnelly@oracle.com>
> Tested-by: John Donnelly <john.p.donnelly@oracle.com>
> ed-by: Dave Young <dyoung@redhat.com>
> Cc: Baoquan He <bhe@redhat.com>
> Cc: Vivek Goyal <vgoyal@redhat.com>
> Cc: Jonathan Corbet <corbet@lwn.net>
> Cc: "Paul E. McKenney" <paulmck@kernel.org>
> Cc: Randy Dunlap <rdunlap@infradead.org>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
> Cc: Mike Kravetz <mike.kravetz@oracle.com>
> Cc: "Guilherme G. Piccoli" <gpiccoli@canonical.com>
> Cc: Kees Cook <keescook@chromium.org>
> Cc: "Peter Zijlstra (Intel)" <peterz@infradead.org>
> Cc: Ingo Molnar <mingo@kernel.org>
> Cc: "Steven Rostedt (VMware)" <rostedt@goodmis.org>
> Cc: YiFei Zhu <yifeifz2@illinois.edu>
> Cc: Josh Poimboeuf <jpoimboe@redhat.com>
> Cc: Mike Rapoport <rppt@kernel.org>
> Cc: Masahiro Yamada <masahiroy@kernel.org>
> Cc: Sami Tolvanen <samitolvanen@google.com>
> Cc: Frederic Weisbecker <frederic@kernel.org>
> Cc: Christian Brauner <christian.brauner@ubuntu.com>
> Cc: Stephen Boyd <sboyd@kernel.org>
> Cc: Andrey Konovalov <andreyknvl@google.com>
> Cc: Colin Ian King <colin.king@canonical.com>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> ---
> 
>   Documentation/admin-guide/kdump/kdump.rst       |    3 +-
>   Documentation/admin-guide/kernel-parameters.txt |    6 ++++
>   arch/Kconfig                                    |   20 ++++++++++++++
>   kernel/crash_core.c                             |    7 ++++
>   4 files changed, 35 insertions(+), 1 deletion(-)
> 
> --- a/arch/Kconfig~kernel-crash_core-add-crashkernel=auto-for-vmcore-creation
> +++ a/arch/Kconfig
> @@ -14,6 +14,26 @@ menu "General architecture-dependent opt
>   config CRASH_CORE
>   	bool
>   
> +config CRASH_AUTO_STR
> +	string "Memory reserved for crash kernel"
> +	depends on CRASH_CORE
> +	default "1G-64G:128M,64G-1T:256M,1T-:512M"
> +	help
> +	  This configures the reserved memory dependent
> +	  on the value of System RAM. The syntax is:
> +	  crashkernel=<range1>:<size1>[,<range2>:<size2>,...][@offset]
> +	              range=start-[end]
> +
> +	  For example:
> +	      crashkernel=512M-2G:64M,2G-:128M
> +
> +	  This would mean:
> +
> +	      1) if the RAM is smaller than 512M, then don't reserve anything
> +	         (this is the "rescue" case)
> +	      2) if the RAM size is between 512M and 2G (exclusive), then reserve 64M
> +	      3) if the RAM size is larger than 2G, then reserve 128M
> +
>   config KEXEC_CORE
>   	select CRASH_CORE
>   	bool
> --- a/Documentation/admin-guide/kdump/kdump.rst~kernel-crash_core-add-crashkernel=auto-for-vmcore-creation
> +++ a/Documentation/admin-guide/kdump/kdump.rst
> @@ -285,7 +285,8 @@ This would mean:
>       2) if the RAM size is between 512M and 2G (exclusive), then reserve 64M
>       3) if the RAM size is larger than 2G, then reserve 128M
>   
> -
> +Or you can use crashkernel=auto to choose the crash kernel memory size
> +based on the recommended configuration set for each arch.
>   
>   Boot into System Kernel
>   =======================
> --- a/Documentation/admin-guide/kernel-parameters.txt~kernel-crash_core-add-crashkernel=auto-for-vmcore-creation
> +++ a/Documentation/admin-guide/kernel-parameters.txt
> @@ -753,6 +753,12 @@
>   			a memory unit (amount[KMG]). See also
>   			Documentation/admin-guide/kdump/kdump.rst for an example.
>   
> +	crashkernel=auto
> +			[KNL] This parameter will set the reserved memory for
> +			the crash kernel based on the value of the CRASH_AUTO_STR
> +			that is the best effort estimation for each arch. See also
> +			arch/Kconfig for further details.
> +
>   	crashkernel=size[KMG],high
>   			[KNL, X86-64] range could be above 4G. Allow kernel
>   			to allocate physical memory region from top, so could
> --- a/kernel/crash_core.c~kernel-crash_core-add-crashkernel=auto-for-vmcore-creation
> +++ a/kernel/crash_core.c
> @@ -7,6 +7,7 @@
>   #include <linux/crash_core.h>
>   #include <linux/utsname.h>
>   #include <linux/vmalloc.h>
> +#include <linux/kexec.h>
>   
>   #include <asm/page.h>
>   #include <asm/sections.h>
> @@ -250,6 +251,12 @@ static int __init __parse_crashkernel(ch
>   	if (suffix)
>   		return parse_crashkernel_suffix(ck_cmdline, crash_size,
>   				suffix);
> +#ifdef CONFIG_CRASH_AUTO_STR
> +	if (strncmp(ck_cmdline, "auto", 4) == 0) {
> +		ck_cmdline = CONFIG_CRASH_AUTO_STR;
> +		pr_info("Using crashkernel=auto, the size chosen is a best effort estimation.\n");
> +	}
> +#endif
>   	/*
>   	 * if the commandline contains a ':', then that's the extended
>   	 * syntax -- if not, it must be the classic syntax
> _
> 
> Patches currently in -mm which might be from saeed.mirzamohammadi@oracle.com are
> 
> kernel-crash_core-add-crashkernel=auto-for-vmcore-creation.patch
> 


Hi,

When  will this appear in a build ?

Thank you,

John.

