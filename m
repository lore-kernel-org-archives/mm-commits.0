Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.5 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EDCE0C433F5
	for <mm-commits@archiver.kernel.org>; Fri,  3 Sep 2021 17:55:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CF16560F90
	for <mm-commits@archiver.kernel.org>; Fri,  3 Sep 2021 17:55:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350285AbhICR4f (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 3 Sep 2021 13:56:35 -0400
Received: from mail-bn8nam12on2044.outbound.protection.outlook.com ([40.107.237.44]:65422
        "EHLO NAM12-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1350338AbhICR4e (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 3 Sep 2021 13:56:34 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=M7BVNlwd2tteVoyvIkHhni8kYpx3uWc9j0FORGn6ys2H90mmXUYLpgCb14cBvk4bHAZBNvb0xLhuRWU6EUuDaeZ4uPRxzNlYE3eTT+Q7qUIPwJi9OqiwrIZuBuBYmCjYj15xHqZpmX4Y128kNkXOuEUMXGCfX5ATzjeO9/nyf5rWOWbfQSeGbzV3TBZJqTaCNC4/peaJ1ccF3CdCqh6Ne3cEgQVtvMcDBOn5Jtc/SiIZL35aUMyCn+QsPg7e8bi8SDcvk/A6S7cVpYDPLP6DC3LL8bewEhLEKnS68bpKwVgEiSRu5XRe8TpLriSRQx6QGGlcqX2yDBvq8z+m/YLiew==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=KmT3OTGKdtt8kgzuOEfRuJkCgOgVCfNYas5Obl8T+Hs=;
 b=oSAFsOuxn4fn4FPkSPKUHh7x3e/Cn+ICRaJKhAMajZsSYirW/6EvfSF1yljEYyggnAy0EmiPPJnI11LMMWSiEYJSY8PelYXas1/HSnRZnrI8s1689gN1WdLKtC1C7xqEUuTf+2JUlPkYYyjSiQH938VfyofbZpeNl+ET1ccsw5JnPd0hb8hYOjARGQf61ZSD/jQygIhng5vkQmyXLc97UZDRQQx++9DFaj8obHNUP4Q7UtYR7Gpt/YZu+7DIsI/BDQ2HgjzEOnGoJdRXdd5gWuRqvOKfmw09COTFmAvmvrq1tbxlB8BXvoZmesUHmWy+IdBl80tiAUCIM6el66OmNQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KmT3OTGKdtt8kgzuOEfRuJkCgOgVCfNYas5Obl8T+Hs=;
 b=bfatsvC0BBMoMGDyfngoixtHhB6TnRhnum/xyUtloSd23cl9E/dcBh6EN9Dgys2aDedeCmYq6+aedtgZ2a5w2xSxkZ5up5TYzOjuLf+qxwg1BeY/VKREH3Z8qVYIwdbVZFLOZporpk/8bJNuy11mwcKHbHuIwWBrHVhq0NIGW7+Um18Pj0WhBmZmNuR776uIKpmLxCKk3cNa/4TnQDXsYEp6CYsaplVjiHmtt3SQhloQegeLaGXBmIN+TANKlICfgBI8yHV82GkHQg3CQtVTbPCmt5pKhQPYeFgt1C8oxl3vQzkrRAfVUXUerX9pPKLTBK1Uu8vHw91Qn/LNYKaXxQ==
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nvidia.com;
Received: from BY5PR12MB4130.namprd12.prod.outlook.com (2603:10b6:a03:20b::16)
 by BYAPR12MB3061.namprd12.prod.outlook.com (2603:10b6:a03:a8::33) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4478.22; Fri, 3 Sep
 2021 17:55:32 +0000
Received: from BY5PR12MB4130.namprd12.prod.outlook.com
 ([fe80::18d1:be89:51d3:58c9]) by BY5PR12MB4130.namprd12.prod.outlook.com
 ([fe80::18d1:be89:51d3:58c9%6]) with mapi id 15.20.4478.020; Fri, 3 Sep 2021
 17:55:32 +0000
Subject: Re: [patch 071/212] mm: gup: fix potential pgmap refcnt leak in
 __gup_device_huge()
To:     Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Cc:     Claudio Imbrenda <imbrenda@linux.ibm.com>, Jan Kara <jack@suse.cz>,
        "Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>,
        Miaohe Lin <linmiaohe@huawei.com>,
        Linux-MM <linux-mm@kvack.org>, mm-commits@vger.kernel.org
References: <20210902144820.78957dff93d7bea620d55a89@linux-foundation.org>
 <20210902215342.RcyFEb0qQ%akpm@linux-foundation.org>
 <CAHk-=wgQTRX=5SkCmS+zfmpqubGHGJvXX_HgnPG8JSpHKHBMeg@mail.gmail.com>
From:   John Hubbard <jhubbard@nvidia.com>
Message-ID: <5327ba7e-fe70-ed72-b372-254d516fd8ea@nvidia.com>
Date:   Fri, 3 Sep 2021 10:55:31 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
In-Reply-To: <CAHk-=wgQTRX=5SkCmS+zfmpqubGHGJvXX_HgnPG8JSpHKHBMeg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR13CA0232.namprd13.prod.outlook.com
 (2603:10b6:a03:2c1::27) To BY5PR12MB4130.namprd12.prod.outlook.com
 (2603:10b6:a03:20b::16)
MIME-Version: 1.0
Received: from [10.2.52.41] (216.228.112.22) by SJ0PR13CA0232.namprd13.prod.outlook.com (2603:10b6:a03:2c1::27) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4500.4 via Frontend Transport; Fri, 3 Sep 2021 17:55:32 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 78a4b44d-f4c0-4b09-5f33-08d96f040658
X-MS-TrafficTypeDiagnostic: BYAPR12MB3061:
X-Microsoft-Antispam-PRVS: <BYAPR12MB30610BC448C9AC900D716B26A8CF9@BYAPR12MB3061.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: yYjWl6YUsNVBtLPM96tMAo4subXb9AnzuXo6zDEl4G2W5Kj55Jq/Hh/5SxOSimCQQIF7Yzx+RLRefWc5ruLIRGhtbYs8lm1Om+w/H81zwsIT4wrSa1FgbPvx7d69m8x4h4INmB2WXuKEuMWjhg4axrxceLqsCzkkS2ZYO60+DjnpRIioyzfssIex1woeuFUovWc0/TLsDRL2lV4jbJYr8SqpMtgJMO9u7tlI+H7muMl5kXEuj2eVPP25n15LaC+oqjne+x44cVLPKJC09izyH8NWxXiaZyuquQ/zdDILB/lMygRZhaJxkLkNOw3eN6O9tcvvGEsa8BG+18RZLReh0auv0UZ0kYDR+mn6JyZ+v3rKCgzGFYLMxnUFSaly/wa+qjnwlutYr0mv4WggMHaJjKDnIZIlmrhM0O7cBnx89qq5YBSrCFNXhlPR7vIuCSXakDIZxSSqAeTzhp5xjUbI74Nx2rk0i4kO9y6aQU1UNxspWbd9Q5Y+dk85qm+gSwWKJHFs/9X6a/HFq5o1SQwlJgbz4+lTuasrhTpJHAIqMSjudoDhnSb6JEJUZHxmcdbdfUPD2FaT3cTvV3Aef3OH+RrDYHRznHeWl5vymAUHJ74HkCm6UZme4lXMZX33oVeFXNEoI211Q9glnvJ0ghZ55YNOsuT7Sd10XlXilPKbZJwJIIvgFwJs7TG35zv3ncChSM7OyK40BvKA8V5RMrcz9G5bPVBQx7kGu7Xg7y1CEW+BJNibPgJOh3CUBsqpnqVxNfhimp/wf+VyrsGhQk8RxA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR12MB4130.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(376002)(136003)(366004)(39860400002)(396003)(6486002)(54906003)(110136005)(8936002)(38100700002)(2906002)(8676002)(26005)(5660300002)(186003)(4326008)(478600001)(16576012)(316002)(86362001)(31696002)(2616005)(31686004)(36756003)(53546011)(66556008)(956004)(66946007)(66476007)(14583001)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?NDdOQ1laNnVMc2F3bmtVM2J4dm5kT2lvUVVtZEJLaGFiNmRoZGxLaFd3SjJN?=
 =?utf-8?B?UmVPWk5NZ25NUklkd0tLWUl4aUdWTGtKTm1ZTWJ5b21lUXcyNjNyMGNmaHh1?=
 =?utf-8?B?T2tqcVJ3TElDWlFxbUtYdUUrWHpyeUh0cEtCSU9tRHE2MnhGcW15Y2h0M01j?=
 =?utf-8?B?TzBHRmRZYWltbE9xcG5rNW02Tm5XQkhHTmx2aHlBb3lGdlkyR3RHMXNML0xv?=
 =?utf-8?B?bFJpWlQxMkNPM1RtMEJsRmNmSG1kWThESWtZN041YlNwaUNMRFdhaERYZE1P?=
 =?utf-8?B?RXpUMmNEejRHVi9hekUxdE9vdTFqQklXb3RhbFlIY1hUREorcm9nbEZVL3JJ?=
 =?utf-8?B?VlpsVW1jVC85bllyZHE2NlJOeldQSjhoYWttVkF4VUhIV2tHc3drbFhzbUJX?=
 =?utf-8?B?K3N0K05rUGhvSzJTSDlZZ1ZJVDluR1JROXhvNzVNbVhxQ3NXRCthYjVUZEpX?=
 =?utf-8?B?UUo0dVdTZjQrMzZ3dFh5N1p0ejNvQlA1NWlvMitPS293a2tIWUJCZ3Z3ak1K?=
 =?utf-8?B?Z0JNK2xOdTdmNTlwZWFTOHNNOVdJYWhvTHdJbk9RN2plNFRsMVZTY0oxb2Iv?=
 =?utf-8?B?T09ZY08zazNiNzBDOTNQZytkcHdCSDZUcUZ4bzNrdXozMTFVbks3VU0wcGZI?=
 =?utf-8?B?NnhaUDhKcVA4K2hLSlIzQkFDOXFkV1ZBckRoNWU1TlR1dFdCbzBQSitSd1Bk?=
 =?utf-8?B?YXFHOW1QM3FZdllvVDZYellkcko1REtwTnVCbngrY2Z3OENvdFVaVm92OVVT?=
 =?utf-8?B?a0MzcWJwTEtJWnFMZUlXczBMMjB0S1g4dFk4L3VQaW1lQ0VBMzNOOUg5Yk5H?=
 =?utf-8?B?Uk9laDVoeHZLRnp1NWlkTHpCenMrc3RzUENYR201TGV1eUhuWFFYUHNEWmpN?=
 =?utf-8?B?WGdUVTdIc00vajVnazdVNVdXd1d1R242ck1Zc1BIRG1aWVVuM0xYTU40V3d1?=
 =?utf-8?B?SldhVVFHTDZScFpZR0RWT1QzVmpPa3Q5M2llYW45WC9vc291cWpRa095QzIx?=
 =?utf-8?B?clhxRUkrTUdrc0hYQ1RFbHRXRWlNc3pvZWoxemIrN3h4RTdZMWZKNjhETVNK?=
 =?utf-8?B?cWZtd2s5MU5MbGpXRk5saFk0NzV5K1FaNTkxVkxScGxOZ1FIajFEMWVlemYr?=
 =?utf-8?B?cnNHSWdxU1Z2aXpieFozaEV2Q1hpWXRwZUlVeUpuZmhHald6NUh2RmVVclF5?=
 =?utf-8?B?dC9RUzdGRGFVNStBYko4UkpXMjJNbVdzc3BYTlBkTERCUXJPakhobnVFZmIw?=
 =?utf-8?B?anIvaC84TkZzenM5blVCS2haYlY5TmVWOVdNOWR4OXlTSmpCdk1GbzdUZCsy?=
 =?utf-8?B?eHhFTDBkRE9sSDNWSzBld0FGaHpTRkc2VHpMUnNvOWkwUmtQbGpJN3ZOUTZw?=
 =?utf-8?B?cTlwSGYzb08yblBkWHFvWFdPWHNyOUhXZ3I5MnVOaUtrRStQNk93bitSWkRv?=
 =?utf-8?B?Q2ptQURlbHFhNG9VSTVCN0J2Q0dFdUZaall6NWpUZnQyTUl4blcwbU9Ub0Zo?=
 =?utf-8?B?ei9UZW9JWHNoMitGV21MOTlDQUI2Ym5ob1BNeFErWUdhUENiSkkrLzIyMTVq?=
 =?utf-8?B?QlFaRmpEbjA3Y2hGamNJbUpzayt4TlI5NG9LL0dTcWVTMGtKWkFqNUVrRWhV?=
 =?utf-8?B?QkQ2NXBnZU5mNG9GZ1hjTWhtdzYxZVRyMjJ3NG00UmQ4K1UxRk5aaUFjaERl?=
 =?utf-8?B?TnRIcTRFMjRJNVBwY1hyVTdTdDFidnBDWXFreEcvZGNGT2VndW1XalpjZklR?=
 =?utf-8?Q?80AyQypVy1EFBzB0ioUXa4PvU92Tk6OGCIdmPnw?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 78a4b44d-f4c0-4b09-5f33-08d96f040658
X-MS-Exchange-CrossTenant-AuthSource: BY5PR12MB4130.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Sep 2021 17:55:32.8056
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: y5RHSTqV2YU/Lszmgy+dUxh+ksKTNSUiqmLPuyAX8ZZBV+l5qLqqB79mhj4MOIW2DFSKFKwpemyCm53GQ3/g9g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR12MB3061
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

On 9/3/21 9:35 AM, Linus Torvalds wrote:
> On Thu, Sep 2, 2021 at 2:53 PM Andrew Morton <akpm@linux-foundation.org> wrote:
>>
>> +       int ret = 1;
> ..
>> +                       ret = 0;
>> +                       break;
> ..
>> +                       ret = 0;
>> +                       break;
> ..
>> +       return ret;
> 
> Hmm. I think "ret" is unnecessary, and this could just have been
> 
>          return addr == end;
> 
> at the end to check that we did it all.
> 
> No?
> 

Yes, definitely.

So, to be extra clear even though this is tiny and trivial: this incremental
change, on top of the current patch, looks good to me:

diff --git a/mm/gup.c b/mm/gup.c
index 7a406d79bd2e..74142c621556 100644
--- a/mm/gup.c
+++ b/mm/gup.c
@@ -2241,7 +2241,6 @@ static int __gup_device_huge(unsigned long pfn, unsigned long addr,
  {
  	int nr_start = *nr;
  	struct dev_pagemap *pgmap = NULL;
-	int ret = 1;

  	do {
  		struct page *page = pfn_to_page(pfn);
@@ -2249,14 +2248,12 @@ static int __gup_device_huge(unsigned long pfn, unsigned long addr,
  		pgmap = get_dev_pagemap(pfn, pgmap);
  		if (unlikely(!pgmap)) {
  			undo_dev_pagemap(nr, nr_start, flags, pages);
-			ret = 0;
  			break;
  		}
  		SetPageReferenced(page);
  		pages[*nr] = page;
  		if (unlikely(!try_grab_page(page, flags))) {
  			undo_dev_pagemap(nr, nr_start, flags, pages);
-			ret = 0;
  			break;
  		}
  		(*nr)++;
@@ -2264,7 +2261,7 @@ static int __gup_device_huge(unsigned long pfn, unsigned long addr,
  	} while (addr += PAGE_SIZE, addr != end);

  	put_dev_pagemap(pgmap);
-	return ret;
+	return addr == end;
  }

  static int __gup_device_huge_pmd(pmd_t orig, pmd_t *pmdp, unsigned long addr,



thanks,
-- 
John Hubbard
NVIDIA
