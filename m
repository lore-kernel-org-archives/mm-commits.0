Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 51F30C0015E
	for <mm-commits@archiver.kernel.org>; Wed, 16 Aug 2023 00:58:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240864AbjHPA6N (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 15 Aug 2023 20:58:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54868 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240963AbjHPA6M (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 15 Aug 2023 20:58:12 -0400
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 69945211E
        for <mm-commits@vger.kernel.org>; Tue, 15 Aug 2023 17:58:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1692147488; x=1723683488;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=RBg/SsXS8GrIXwmLqlD0Icg0NdfsVpBFH3aX8+pvKPI=;
  b=cZofJ2jeYgm/TBI1ejGjBu8uyQe+UbpNO6yl5VL/CyaAZm0zlAgIyAiE
   gOPzK4hldoHj5ZGP+X2L/gyeOHfWy4W8AU2UwuXsL0LNSGoIRvQRyTtxN
   ZwaB+Il106hc/qoQpuMLPxQoZvwFn5jPkEhBtY7oP6FvEHchvAxoE/ft2
   /48XHI4nsQtoRuAyEQFdri3g5VexsDXkQyms8jxT3HYQO2RO0/XHY/cVa
   m+yYIX2A5yGDaMTu5WUZRcSrWw6rXoFMgiQNJOOkyoWFvrQEyNQTeHJyv
   hLxyhMMcNSC5P+wnt+wMxNWEHq6QOae9S9RIhodiJ6TPsATzIUIiLCD/V
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10803"; a="372409903"
X-IronPort-AV: E=Sophos;i="6.01,175,1684825200"; 
   d="scan'208";a="372409903"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Aug 2023 17:58:08 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10803"; a="727569122"
X-IronPort-AV: E=Sophos;i="6.01,175,1684825200"; 
   d="scan'208";a="727569122"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orsmga007.jf.intel.com with ESMTP; 15 Aug 2023 17:58:02 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Tue, 15 Aug 2023 17:57:56 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Tue, 15 Aug 2023 17:57:55 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27 via Frontend Transport; Tue, 15 Aug 2023 17:57:55 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.169)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.27; Tue, 15 Aug 2023 17:57:55 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TFGN6b1QZPFlvuVcNtktLZWygjiLu5tpn9aKKDaXkOqm9HG8zkb4Ew1PLT1JimV7R5d5buxK793WrpkePIC6DJiMr8b+KaeZeOBujBn7o3FN5EwMTTbf0xcrMlfb774Dx7fUpq6i+i8cph9tOsMhKqZCY6g3JKkFAYY3j0pstmk7HZNviXHtci4LMFgnAvbRRA/4kPNKtqINMJ7RBIBMSvGvnpTzxYPqDESX1L50HA4EfkARtMr6IDCbCLGhx0OSnwTMZICjkn+UAVx4g8rS061++nrKS9N/iNfLKSQBE6Ke6TLVzzC/TcauvDei1iLrmaasnAnsoDNbJsMlJHo0oA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=aWeIdPYQKh4IMYdkPakpiA4JkMWvG3myscJbWK/PyMQ=;
 b=aRwB6QQmBTSAU4thIg59e6F0M4/hGcTtNgiZ15Am1IlxdMIE7dsIkRHx/4TCC/SN8w5vv/kuvMXp50VAZUF151eJl3s0Gy2M0QBByuN3QUIhLMOMNCTcwPeLPNHgDjZAFuzbggJd9t+p2DQXclTBFGPOBnQR5lD+vAVel89col82w8mugA2U07nLnBtL0cod4GMTaFr1mJi+ebbu4fzGLuIb320zOatSRE5h4v6L9Ko+2f8dKTsNawWffM4JzWO/pq6k533CUAxFnEF8DZtuj2ZRLcMqALNbOwPy+HOemqkhcFfgcIvVmc8McVdUD0UuyHrYy+rtwRDupYey+pv6UA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CO1PR11MB4820.namprd11.prod.outlook.com (2603:10b6:303:6f::8)
 by MW6PR11MB8440.namprd11.prod.outlook.com (2603:10b6:303:242::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6678.26; Wed, 16 Aug
 2023 00:57:49 +0000
Received: from CO1PR11MB4820.namprd11.prod.outlook.com
 ([fe80::221b:d422:710b:c9e6]) by CO1PR11MB4820.namprd11.prod.outlook.com
 ([fe80::221b:d422:710b:c9e6%3]) with mapi id 15.20.6678.029; Wed, 16 Aug 2023
 00:57:49 +0000
Message-ID: <776ddd10-0a60-575c-2780-09511fc6a213@intel.com>
Date:   Wed, 16 Aug 2023 08:56:30 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Firefox/102.0 Thunderbird/102.11.0
Subject: Re: + mm-kill-frontswap-fix-fix.patch added to mm-unstable branch
Content-Language: en-US
To:     Johannes Weiner <hannes@cmpxchg.org>,
        Andrew Morton <akpm@linux-foundation.org>
CC:     <mm-commits@vger.kernel.org>, <willy@infradead.org>
References: <20230811171954.7F381C433C7@smtp.kernel.org>
 <20230814141039.GA5860@cmpxchg.org>
From:   Yin Fengwei <fengwei.yin@intel.com>
In-Reply-To: <20230814141039.GA5860@cmpxchg.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SGBP274CA0023.SGPP274.PROD.OUTLOOK.COM (2603:1096:4:b0::35)
 To CO1PR11MB4820.namprd11.prod.outlook.com (2603:10b6:303:6f::8)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1PR11MB4820:EE_|MW6PR11MB8440:EE_
X-MS-Office365-Filtering-Correlation-Id: c512a537-06b4-4b7a-7046-08db9df3cf9c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: tkLYNk1lEQiNKVArMDWfMoqxdHYkmEO47j8+xGs8P+NN36/e5mfUtIGyMyDwxX37QH3zjl4HUvWPlhdNOdNBRMKkvO1v4bK0+yInNeL2OKhoJCxK+J8bSgLayBzeLp0unSZ8Y9fERpS/fbAcUi5GhCoZLPazLsX+l6z+LUE97V05cKFVpLyfToO/mIfDGKocmrFIt0T4xFpAYCBsD3ypc016gy4gMjgPCQLQS6nPO6SexFIr2/O6JXBr+CfA5YEo+Q+BeQxUb59AmvSVsV4nqKKSukTWazxDPr78AVODbYMvTXXJmoEqB3HUgA9cw/PxU9UJFfs9Q+KWSNOIpn2FRqSgNj5o2JLq+2enggwYswYPNqp1WJgV3R2O9rilaxaL/6z8yflXvu3N1LoWDy8IFUlvRoYKskJOV9hCXOoDgFKB/Ub/rd6mHD606m1rKWIPjWgLWMwwOUh3yEJ+5Y0XBPXV/XYloeDbz++b6zDAp1+gi+RPgBTgfD54Iz1SJ000wVd/f6BqK5Ecvh1k//23KNFo0iOl1qz82BSWQHUkWIcbaVvnzJk262eBnbJ5DbJB8MHtMIy28/Vlx2m1WlY53NLc6+QNZEWkeNKVAiitI3vFjCTl7jO2N/M3xECl6BbbEtHeBWGbclSxSCBjF19i/w==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR11MB4820.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366004)(376002)(346002)(39860400002)(136003)(396003)(451199024)(186009)(1800799009)(478600001)(86362001)(966005)(6486002)(82960400001)(2616005)(36756003)(31686004)(31696002)(6506007)(66476007)(5660300002)(66556008)(66946007)(316002)(41300700001)(53546011)(26005)(45080400002)(6666004)(38100700002)(110136005)(83380400001)(4326008)(2906002)(8936002)(8676002)(6512007)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?dWRBZzU3VUZ0Rk9XTExSVGIvTURSZGhNV0VvUEZVdnRIUXpZbmNFWlc3SHN4?=
 =?utf-8?B?RTVHZjZzVWExQ2JLbjlPc2hiaENvSm9hTlZIdjc1RXVKQzZCdzljd2lBWFBL?=
 =?utf-8?B?NThZSi9pb3N1NjFsa3ZSVy9BdHZFN09PQytBQlJBMmpWbjJlUU5ORGhZd1R5?=
 =?utf-8?B?MUMvNWFFRE5YZG5EL3F0YmlWS2VydWpZSG9TSkNkRkcxUkQ1T2RGdXhDRVI2?=
 =?utf-8?B?R2RYZDZZdmJnTVRrT1IydGJUeFhPRDBUd0N2cUdzYzFWWkt1KzlVeTU2WlNB?=
 =?utf-8?B?YWRUMmJSYWNmMXpWUEV0a3hmdDRWMmJCOHUwajZTdnNuekpqbEFlVFNSUnAx?=
 =?utf-8?B?NmxiVkx3R0FQUWo0VkdEYkVXcGp6TlBZT3RydFJVTG10Y3NqS2dxM1RKbU5u?=
 =?utf-8?B?YmRxTmtwUnpsaFhwSHZ1RlRRclZFcS9pdVhDd3pWTGFzMURwb3d2UjdFeDQy?=
 =?utf-8?B?TmNCVHlkcjVSZGtmT1llbUdDRWY3b0ZVNHB1bTQ2R2N0d1BkOU5hZnpaTTlp?=
 =?utf-8?B?clAyaGcrVHNEMHMxV3RwWkg1WHJnR3lyRUp5eDBocWpXVXBKUm5KcVZHMm0v?=
 =?utf-8?B?UnVPYUQ0L3d0RERscjRPcGdyN3RiMndpa3pZZjdLL1R2Y1Njbk1SUlo0a3FK?=
 =?utf-8?B?K1h5V2xWZzJwcUs1eStnQ2k3bXV5dUduK3N2Z3lhMFozc0lDc0QwcWI3U3Er?=
 =?utf-8?B?Z2NOaVdocWhVZytFaW5EOGJXLzg1ZHZmbUhPTDVFUkNkNXQ2Q3BFVnVoNXlP?=
 =?utf-8?B?bkZJNnFzdnB4SlhrU2FIL1BrVnlZdzc1QkZZTFplZEZoRWQ1YWlnMTdudkx5?=
 =?utf-8?B?VS9vUGY1UldEbzZ5S29GL0N6SXJka2tSNGFMRWgzYVRDTzBvUjdIdFpPa2lQ?=
 =?utf-8?B?ZTRaUGVlQ3czZlpGSko4akZBNVgzYkh0TzFPdzd2enJtNS9zaWZqd0RlL055?=
 =?utf-8?B?QXl4UzRuZzFCUXNzT2JJUW8vU0FNMXIrRXBobVYzT3BWd3FCUFBTV21qQ0Jv?=
 =?utf-8?B?cHVicVhOOXJqajNDMTdNTDhLanh6SlNIYUpmSkpoWHpsbjY4Z2FDaGg5NjlR?=
 =?utf-8?B?TXlhZjlnOGpHdUVJZGplc0E1NWFBa2dDWkVoVDlBQkg5QXNxZE1wd2QybUtM?=
 =?utf-8?B?WGpkUXNOWERseCtiSDU2akd0b1lZR0FtK0ZmTFBKaXVzZDAwQW5lbDBlQkpI?=
 =?utf-8?B?cHhSRzNxTm9odDkrdE42NzNBandSNlRrMHVoMmlHMTdscUppYStpeG9HcnZB?=
 =?utf-8?B?bHVXbHZYNE1lUHJEY3dZNlNCMmRHVUNmbURsTzNXaURtOUZmRU5FQmJnK3E5?=
 =?utf-8?B?TjVuSXJDdW1TeE9CWnVXcERyaDV5NE1JTWJiQlQ0SExoUWxodjZId1AyQVFh?=
 =?utf-8?B?enRNc3Bvcnpjb0xEYTNrY05Wbm9KUmJDNnBvMk9LY3RSc1dLTHNuaDhTdHYw?=
 =?utf-8?B?VWtmMy9kVC8zd0xoK293TXl0RGNtQmdiWTNzdXdqWE1NM3czWEdWbWFyNFBh?=
 =?utf-8?B?dlNTd1V1OUlKay9DYk9uUGtKL2NtZmhnc1Fua0plSG1BNVhPUUhFa0FBY0lX?=
 =?utf-8?B?MnVXY0pzNWtKazlGd2xoM0RVWEhOTEFKdi9qdVd4T3Nyd3V5UW1jNnFUR3VT?=
 =?utf-8?B?blhZdTdwTWl0Z3JTUUJiQ05xTFozL2lEL2plUjIvcXJLcWhRWmZPY2hORUk4?=
 =?utf-8?B?MllLZWsxYVRPdVIyYWlqcUtIU0hPZm9CeEljNXJ6dnphS2JzcS9SM2VIdDVS?=
 =?utf-8?B?NERQQzl4WWFDeWk5eHd1d0s1VlY1TU9RTUhKZWlmY01WTW01OFkxbGpYMk85?=
 =?utf-8?B?UG9IdFA4ODVsUkdpVmQyVUNRa3duTnl1cG80amowbzRTcXNKSVFLZDJXbDU5?=
 =?utf-8?B?dmtPTUZKZmh2Q0EyeWx3ZnVyYkVRVkQrUGZESVpoakNWM25VZmg5Vm1BbFRF?=
 =?utf-8?B?ZTBmT3FqUG1rendwanZmYkxVWlVvQnhRdmRXZFNKWUg4MlBtell4Wit5Y1dD?=
 =?utf-8?B?N2pMeE9sd2NVT3YwSTZmemxUL0ROWnRYYW8rMHRVOHZJcUVGdXNtNjM3MFRB?=
 =?utf-8?B?ZmlramNtZ3JxRUc5YVBhVkthSk44eElYZlQvK1cvNlIwbytidW91dlRMcDhM?=
 =?utf-8?B?L3Z1bDhhV2sxZFRnKzRaNEllMGQ2bm0vcXNvNVpZUUsxQ2M1TmNtVzZDOW1l?=
 =?utf-8?B?c1E9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: c512a537-06b4-4b7a-7046-08db9df3cf9c
X-MS-Exchange-CrossTenant-AuthSource: CO1PR11MB4820.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Aug 2023 00:57:49.2005
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ee1f01omashOKFnTTWapyH5MibX5/YzqwnJI45BnCMjpBtaDXub4IdYTRdpsv0Bpp56tpTbE/U+MnLmLFvCxag==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW6PR11MB8440
X-OriginatorOrg: intel.com
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org



On 8/14/23 22:10, Johannes Weiner wrote:
> On Fri, Aug 11, 2023 at 10:19:53AM -0700, Andrew Morton wrote:
>> From: Yin Fengwei <fengwei.yin@intel.com>
>> Subject: zswap: don't warn if none swapcache folio is passed to zswap_load
>> Date: Thu, 10 Aug 2023 17:56:52 +0800
>>
>> With mm-unstable branch, if trigger swap activity and it's possible
>> see following warning:
>> [  178.093511][  T651] WARNING: CPU: 2 PID: 651 at mm/zswap.c:1387 zswap_load+0x67/0x570
>> [  178.095155][  T651] Modules linked in:
>> [  178.096103][  T651] CPU: 2 PID: 651 Comm: gmain Not tainted 6.5.0-rc4-00492-gad3232df3e41 #148
>> [  178.098372][  T651] Hardware name: QEMU Standard PC (i440FX + PIIX,1996), BIOS 1.14.0-2 04/01/2014
>> [  178.101114][  T651] RIP: 0010:zswap_load+0x67/0x570
>> [  178.102359][  T651] Code: a0 78 4b 85 e8 ea db ff ff 48 8b 00 a8 01 0f 84 84 04 00 00 48 89 df e8 d7 db ff ff 48 8b 00 a9 00 00 08 00 0f 85 c4
>> [  178.106376][  T651] RSP: 0018:ffffc900011b3760 EFLAGS: 00010246
>> [  178.107675][  T651] RAX: 0017ffffc0080001 RBX: ffffea0004a991c0 RCX:ffffc900011b37dc
>> [  178.109242][  T651] RDX: 0000000000000000 RSI: 0000000000000001 RDI:ffffea0004a991c0
>> [  178.110916][  T651] RBP: ffffea0004a991c0 R08: 0000000000000243 R09:00000000c9a1aafc
>> [  178.112377][  T651] R10: 00000000c9657db3 R11: 000000003c9657db R12:0000000000014b9c
>> [  178.113698][  T651] R13: ffff88813501e710 R14: ffff88810d591000 R15:0000000000000000
>> [  178.115008][  T651] FS:  00007fb21a9ff700(0000) GS:ffff88813bc80000(0000) knlGS:0000000000000000
>> [  178.116423][  T651] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
>> [  178.117421][  T651] CR2: 00005632cbfc81f6 CR3: 0000000131450002 CR4:0000000000370ee0
>> [  178.118683][  T651] DR0: 0000000000000000 DR1: 0000000000000000 DR2:0000000000000000
>> [  178.119894][  T651] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7:0000000000000400
>> [  178.121087][  T651] Call Trace:
>> [  178.121654][  T651]  <TASK>
>> [  178.122109][  T651]  ? zswap_load+0x67/0x570
>> [  178.122658][  T651]  ? __warn+0x81/0x170
>> [  178.123119][  T651]  ? zswap_load+0x67/0x570
>> [  178.123608][  T651]  ? report_bug+0x167/0x190
>> [  178.124150][  T651]  ? handle_bug+0x3c/0x70
>> [  178.124615][  T651]  ? exc_invalid_op+0x13/0x60
>> [  178.125192][  T651]  ? asm_exc_invalid_op+0x16/0x20
>> [  178.125753][  T651]  ? zswap_load+0x67/0x570
>> [  178.126231][  T651]  ? lock_acquire+0xbb/0x290
>> [  178.126745][  T651]  ? folio_add_lru+0x40/0x1c0
>> [  178.127261][  T651]  ? find_held_lock+0x2b/0x80
>> [  178.127776][  T651]  swap_readpage+0xc7/0x5c0
>> [  178.128273][  T651]  do_swap_page+0x86d/0xf50
>> [  178.128770][  T651]  ? __pte_offset_map+0x3e/0x290
>> [  178.129321][  T651]  ? __pte_offset_map+0x1c4/0x290
>> [  178.129883][  T651]  __handle_mm_fault+0x6ad/0xca0
>> [  178.130419][  T651]  handle_mm_fault+0x18b/0x410
>> [  178.130992][  T651]  do_user_addr_fault+0x1f1/0x820
>> [  178.132076][  T651]  exc_page_fault+0x63/0x1a0
>> [  178.132599][  T651]  asm_exc_page_fault+0x22/0x30
>>
>> It's possible that swap_readpage() is called with a non swapcache page in
>> do_swap_page() and triggers this warning.  So we shouldn't assume
>> zswap_load() always takes swapcache pages.
>>
>> Link: https://lkml.kernel.org/r/20230810095652.3905184-1-fengwei.yin@intel.com
>> Signed-off-by: Yin Fengwei <fengwei.yin@intel.com>
>> Cc: Johannes Weiner <hannes@cmpxchg.org>
>> Cc: Matthew Wilcox <willy@infradead.org>
>> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> 
> Looks good to me, thanks for the fix.

Thanks for reviewing.

Regards
Yin, Fengwei
