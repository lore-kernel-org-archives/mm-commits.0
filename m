Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EACD3EB64DD
	for <mm-commits@archiver.kernel.org>; Sat, 12 Aug 2023 01:46:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233713AbjHLBq0 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 11 Aug 2023 21:46:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45520 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229793AbjHLBqY (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 11 Aug 2023 21:46:24 -0400
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E378170E
        for <mm-commits@vger.kernel.org>; Fri, 11 Aug 2023 18:46:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1691804784; x=1723340784;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=xKNYKSRIVzNl8BO2tM9l+ECGMyA+v7vAKmAYj717mVg=;
  b=X+ZXqdE53BPCn2kxBTsNakwrIp8dKnWom2gCxNKV06Je4AdLcJUOkF/V
   4368S1vNMxLxcet3cpBMeWh0jox9B6jRak1vFyrzM4BJ0qR4XTJbx3/LL
   Tz+Kt26cJlALPiqyiAi7uDxaOQtM/zVgKoiFuC/TCXhhQvBHo/Xna4Hdo
   8QuIkORzevF3ieWCCug9JvefUaFvD/HGtkHi0lI2kSxYnlH//LwCNkX6w
   p80tCb2epxwdVYcw6kjFMDgMeWfr8CHUw4J1dWebFaVljqHxgQZn3qnZm
   62aXdpAdb7WR69t4ivuwujNmSOKYtaKJLQKAzVhd1fn7oS1PYwTxc83Hw
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10799"; a="375505221"
X-IronPort-AV: E=Sophos;i="6.01,167,1684825200"; 
   d="scan'208";a="375505221"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Aug 2023 18:46:23 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10799"; a="762369513"
X-IronPort-AV: E=Sophos;i="6.01,167,1684825200"; 
   d="scan'208";a="762369513"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by orsmga008.jf.intel.com with ESMTP; 11 Aug 2023 18:46:23 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Fri, 11 Aug 2023 18:46:23 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Fri, 11 Aug 2023 18:46:23 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27 via Frontend Transport; Fri, 11 Aug 2023 18:46:23 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.168)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.27; Fri, 11 Aug 2023 18:46:22 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MjgMT+J7CQ3EWNV56DdWwGuJUsz+/yQ6d/IbOW2q5qbpvdMqMjV/ms278kRT4Xk6euW8yDf7eH45DXXs05o3E3fp278AS3M0vP/KtWMiqK7OdJqFJ/F1P3utpfaK83X/UILovno8L+O+WpoMCK8F06bHfm2HS9eQokHq2d8lU8G1WaC/gLcruDykt7nC8N+4DhdhaM5Xu+iC8EV4hOPzfvJf628z+OuXD+39otfAgUQyh/ppDMTjBjQG/gkgdxDw/9R6nCJBJYgRFX8mJ3zCEfKKOdBR0KD5q0nOTYUP8s399o4LeAtrgzsUG0o+AKgZTcCT84b92C1mImy3u4e1lg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Exe7liiqRjBnVfb6naJEVDsgkpOBgAIqAcxWW4ic6Os=;
 b=icK5XFa544CSJ/gAeBYeaCFlZXnSHzTj2p7xnhHhxoo2oX7ehx1ryFJJM8YOTlARTLooZ7qggljQW/traOdzJjSYg6swVMtn2DibkYvlJT3i1vsHFqwXQ5Jq/Tw7DRq2fES/i2hs47+SpYUgoLQfpIVZLIY/uG39TeLNR4K5qM5IUz7RWiYKTaWhtTAF0eNUgNARm+t683FL0OMXTD3fXREjOPoSK3/N0ufAQdvY+4nwW0xVkxT9Z2/0zinbr+Wj0Cg2gGF1DoU0x7lRU5ODWxAjs//J5LM/w11oRKao4xZp5SfUwsKKt+pSiusMPQTL40yXh5GWO+SlIN9eKm5uUw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CO1PR11MB4820.namprd11.prod.outlook.com (2603:10b6:303:6f::8)
 by DM4PR11MB8227.namprd11.prod.outlook.com (2603:10b6:8:184::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6652.30; Sat, 12 Aug
 2023 01:46:20 +0000
Received: from CO1PR11MB4820.namprd11.prod.outlook.com
 ([fe80::221b:d422:710b:c9e6]) by CO1PR11MB4820.namprd11.prod.outlook.com
 ([fe80::221b:d422:710b:c9e6%3]) with mapi id 15.20.6678.020; Sat, 12 Aug 2023
 01:46:20 +0000
Message-ID: <9418a77b-2fcb-4d5c-b9b0-bbf7c2a47369@intel.com>
Date:   Sat, 12 Aug 2023 09:46:08 +0800
User-Agent: Mozilla Thunderbird
Subject: Re: + zswap-make-zswap_load-take-a-folio-fix.patch added to
 mm-unstable branch
Content-Language: en-US
To:     Andrew Morton <akpm@linux-foundation.org>,
        Yosry Ahmed <yosryahmed@google.com>
CC:     Matthew Wilcox <willy@infradead.org>, <mm-commits@vger.kernel.org>,
        <hannes@cmpxchg.org>
References: <20230810163538.7C2AAC433C7@smtp.kernel.org>
 <ZNW0+8QiWesvJwh+@casper.infradead.org>
 <f860826b-3380-4afb-b5ab-7acc5ed3932f@intel.com>
 <20230811101803.a9efab4dfbe02b435ca1886a@linux-foundation.org>
From:   "Yin, Fengwei" <fengwei.yin@intel.com>
In-Reply-To: <20230811101803.a9efab4dfbe02b435ca1886a@linux-foundation.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SG2PR02CA0022.apcprd02.prod.outlook.com
 (2603:1096:3:17::34) To CO1PR11MB4820.namprd11.prod.outlook.com
 (2603:10b6:303:6f::8)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1PR11MB4820:EE_|DM4PR11MB8227:EE_
X-MS-Office365-Filtering-Correlation-Id: 5674e144-b255-4d7d-20bf-08db9ad5ecdc
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: huHrwgv2MSFrBn/fehZRus5GO+ZoRlPrgE5fsz7e+jR17cxoxAGRZaCYRA/lrhz5/IuGCxTQDaZkfRvcAP51j6jnziybMPfiJL9S9oWZMLLN8k+qbVuCqp1AqOoEeuMVvcsM1OyWT2mLZQ59WbYyscQAd9ud+WX+IwJKcXf0O5G+Attkzeq4Xa1DsEQD+m5yew8krktGx9xU/RGOLLKkqiLoH54BjnDqIt9NZU2i1pKUMhdxC4fZOjXd1SFiIZj9BPC/LcqOfbVAFLrRnnDYjEAe1LGSPBr7lCDOh2jAYcLYjo8uhqMwZXm7Qky2vt8V7BYLojmW6WLsdmg8p1kMpM52vIO/r1/+5eulNlnQE+ENFDRs9A4WwuKgyySdLphikB7OMDefvzWwlPebt6fmhlkOA8jfwZpIWkRJU7DCINcqB4i7CaOjgdBTHHAYsknj6sERTa+88mGdWBv0vEzjXugmVEnCbVBZ0qjYPMDiTFTqvcvhLOTpY33btuUVt2z0Ijt24/oUxAiiPsb5rRDuon7+ybP0XfePYQtU+aP5jdcwn9FXNRdwdcAh0BIMIDy9BRhVOnzGySxjCSFQ8Hvo1uDj1BLwJHwQP/ddEFoRe6MaaTvR/Led7Y5DrVO8qzM+
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR11MB4820.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(396003)(136003)(346002)(376002)(366004)(39860400002)(1800799006)(451199021)(186006)(5660300002)(66476007)(110136005)(66946007)(38100700002)(66556008)(4326008)(31686004)(31696002)(83380400001)(478600001)(86362001)(41300700001)(8936002)(8676002)(316002)(2906002)(6486002)(82960400001)(2616005)(6666004)(6512007)(53546011)(36756003)(6506007)(26005)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?QXIxWmJ4czJxTkU2blBuSHY0SnAvY0taTmtwaUxEang4eUt1VlhkK2E4WnJv?=
 =?utf-8?B?OWpLQ3J5UmZxQ2dLcE0ySnJ6c2tQbS91K285WERoSHVQOGNpaXptbDlpTUg5?=
 =?utf-8?B?bWxYYW1OSVV2dmdSc2tSb0ppU2F0TkhraXhiaEFtUlo1eWY5eUUzVVNQaWVm?=
 =?utf-8?B?WGQyMEdYQ3h1b2htM1BIbkdEQ1VyNVo3U0tzcDRhWS93ZEoraGo0bzI4SXBH?=
 =?utf-8?B?clljVENYYWRuTGoyZE1rcWxHZnE1dEIzYmYrZW81UEh6dE0xRXBmcVVJYWVT?=
 =?utf-8?B?dkFBdjNRdW9Eb1RzVXBkTmx0YzIyUU9HaHNkMGJXWUVZUDh2TW5sWHlkUDkx?=
 =?utf-8?B?N0tMZCtlVjhoY2dQSDZzSkE0UWNEYmJOTTVPTGhqbmttL2JzS2lFV0FkVGNT?=
 =?utf-8?B?bkRLZklBWWxEVVVwb3Z0V0YxcHdHaFRaM3k0VVJLZWlyVVRBSVUzaWgzRm9k?=
 =?utf-8?B?MEFQemZBUGxtWnJ1TWRwS21ZekpUSUdXLzg5andJYVVFcGlHVDFjWWRTNVRN?=
 =?utf-8?B?OHRzUzl1cEV6TWszdzcxZURrRE9BTWdXaVp2K3ZZRmlxbHdBQjVhM1A5UjJq?=
 =?utf-8?B?OGd6eXo1elZQdVRreTdQUzFnMldmUk5sWUh1cUxuVUNqb2JzSzBTZkVrekdK?=
 =?utf-8?B?c0F0Zlg0SGVTTDlCY3prdGV5QWFzN1VYWUMyU0Y5b2NyMTFEblc5eHE5dHpF?=
 =?utf-8?B?SjBHNFZHcE9XQmpoWEFkdllEcWhLVi9LWDZrN2lNVGVuSkZqWHZXMzNjSnZx?=
 =?utf-8?B?NlIvT0dnMGg5UGNlblpZVEVBOHRYdHB6OFRweG52VitwckxGNzJhamd6L09H?=
 =?utf-8?B?ZjVVV2oxRHEySU00dDdyMzFCQ1NkZjRiVEN6V2xXSkM3a0lMNjg4QndLM3NS?=
 =?utf-8?B?LzhhdlFkUUJaSGdkVmQ0Z2JaenRFR1dBMWNPWTl3N09jbGVDV0lqeVhsQ2Vv?=
 =?utf-8?B?aEx4OVFFK2lhMjNwVmQrVlpJekVBaWRhWjN1aThmcmtsQjd1cDVFR3BYRGlS?=
 =?utf-8?B?Z0FNazNML0xka1NzeDdreVcrYXE5eG9pRzE4cDVBbzZGa3BJeUdOVnpxNFdr?=
 =?utf-8?B?bEtkWGQrUUR3ZE5CaTZSUXFJQTlBbHJjdmFZRmZTbnBWT1Ftbm9jWmdqQzY3?=
 =?utf-8?B?bXNYUlpTZldtVjlqRXdWbnYzTVp2OUZaY2tLR3EwYld3OFdoOWNrN3pYaElk?=
 =?utf-8?B?a1V6dlVwOWxTaThwYyt4YjBiTHlaenlPbXY5NmVlMlFIcFhuRXNtK3ZSWkg3?=
 =?utf-8?B?b28vc3V2Q053L1FwYzVUaEJoeHIxK0xwRjZiOFJwR205a29NN0g1UTNQa3BN?=
 =?utf-8?B?a2htbHV3NkJXRGlSakJXd3RQZUhJUjlKYnd1b2VJemJwb0p4b2NDdFFsWHV5?=
 =?utf-8?B?L3lITG9WMmMvcEFhd09QNkc5NndPRTdzaFIwU3FiN0RUcjIxUVRJTUM0Q0lF?=
 =?utf-8?B?QjBxR0IvR3VkWkxDcjNOUjlJUEVpZ1VBaGJORG5BcjR5dElhZm5iek1aeU1y?=
 =?utf-8?B?ekdHcEVtQ2FTM3V0V2xuSGJva1MwWXhCOW1yZDNmWksxZWR3MG1DdDZvc3NN?=
 =?utf-8?B?anp3b0V0eXRsVDRGMG1hN1hFM0V2OW9jQzZHVzB1L2pPcW9kNDUxQm00UW9X?=
 =?utf-8?B?ZkRtZTZITk8xR0U0eUQ1VHp4R3h2M2RiVnpyZjcxV1ZVV3MyWUdBVnQwQW9s?=
 =?utf-8?B?cW96RVN4bVFpVTBRYjZjS0pMWm5RVVU2aEhLNW83UHNBaWpOcU9wWnVlWC9m?=
 =?utf-8?B?ZDlpTEp5bVNHdGNtSTZsYVVIcEdxdzVPWDdFdFZxS3dtSzV3RTVYUVd2TElV?=
 =?utf-8?B?K0pTY2ZWMGJGdzhaN2xBamRHTy9pNFpDZUM2cjY1L2swYUYzZFgvWHlpbFVD?=
 =?utf-8?B?YnQ5Wk5wZEFicVdJd2VVRUM4WEJiZzFUajBNSlg4amIwTUNaaWtJOWFMK1pX?=
 =?utf-8?B?Rm95bEVRREFqN2VqblBxYVc2eC9TU3lQcVFMVi9PWEVQV1p6TVdkcDBSOWZz?=
 =?utf-8?B?NUdPRzN3VDhJYzc0MEM0TzAwK1RwM25UeHJvNWFRWlpCbklVNHFNVXlyTld6?=
 =?utf-8?B?a2RJNHdLbGljK3BSaEN6WVlCQU93MU9BS2lqMzZTejF3Zk1JZkwvZEd4QTlo?=
 =?utf-8?B?NjRqQ2txczVDWUZ3S1ZZWjBTblVjVy9KeEJEZHY5MHZqMEgraEtQQU5WMXg4?=
 =?utf-8?B?K2c9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 5674e144-b255-4d7d-20bf-08db9ad5ecdc
X-MS-Exchange-CrossTenant-AuthSource: CO1PR11MB4820.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Aug 2023 01:46:19.9437
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: pa4hniVEmHUWQOhawDkvpm4ua4+/kiF6YupUNdgffR1FSHb4JPja5vCV1/InT2sJLdsLQz8rZFOoiXlisTil5Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR11MB8227
X-OriginatorOrg: intel.com
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org



On 8/12/2023 1:18 AM, Andrew Morton wrote:
> On Fri, 11 Aug 2023 13:20:44 +0800 "Yin, Fengwei" <fengwei.yin@intel.com> wrote:
> 
>>
>>
>> On 8/11/2023 12:11 PM, Matthew Wilcox wrote:
>>> On Thu, Aug 10, 2023 at 09:35:37AM -0700, Andrew Morton wrote:
>>>>
>>>> The patch titled
>>>>      Subject: zswap: don't warn if none swapcache folio is passed to zswap_load
>>>> has been added to the -mm mm-unstable branch.  Its filename is
>>>>      zswap-make-zswap_load-take-a-folio-fix.patch
>>>
>>> Disagree that this is a fix patch.  My original patch does:
>> Agree with Matthew. The warning was not introduced by Matthew's patch.
>>
>>>
>>> -       VM_WARN_ON_ONCE(!PageLocked(page));
>>> -       VM_WARN_ON_ONCE(!PageSwapCache(page));
>>> +       VM_WARN_ON_ONCE(!folio_test_locked(folio));
>>> +       VM_WARN_ON_ONCE(!folio_test_swapcache(folio));
>>>
>>> so I didn't add a new assertion, merely removed a call to
>>> compound_head().  I think this patch deserves to stand on its own and
>>> not be folded into mine.
>>>
> 
> OK, so it seems these assertions were added by hannes's "mm: kill
> frontswap"
> (https://lkml.kernel.org/r/20230717160227.GA867137@cmpxchg.org).  I'm
> not really sure why - they don't appear to have been moved from
> elsewhere.
> 
> So I'll requeue this as a fix against mm-kill-frontswap.patch.
> 
> The same two assertions were added to zswap_store().  Are they correct?
My understanding is they are correct as folio needs be added to swap
successfully before hit zswap_store(). Add Yosry for confirmation. Thanks.


Regards
Yin, Fengwei

>
