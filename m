Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 697E5C001B0
	for <mm-commits@archiver.kernel.org>; Fri, 11 Aug 2023 05:22:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230001AbjHKFW4 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 11 Aug 2023 01:22:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42000 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229518AbjHKFW4 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 11 Aug 2023 01:22:56 -0400
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A15199B
        for <mm-commits@vger.kernel.org>; Thu, 10 Aug 2023 22:22:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1691731375; x=1723267375;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=tOI801xDOrnn6qEeevHwKrXnmldsvJ8TWnAQsqvv1KA=;
  b=NzvEBycJwr++nhfZ19HeB/HiQfnBCW8dvrP2PWrWX4KbJXFX3heeAVHb
   f0dw/bjVyg8KR5oF02nU9yGaDTHD971xvGPCY4/EhZmu+sPYHnzIw+Pwy
   N/2jVAadcYHQr7GIgQC3XiOaSJ/K9oRMnsmxf5MCQnE6/R0/eNTp4ptkq
   +cuqJl6ZQWSqiIm4KHcLQpGd1q0CT7C90OSF4LpYibh4rJRprG/4Y9Bla
   Z7qaVeK2JN03vFObAEon80Y2NTUrdcGT01zBpM6muaqe0QTZrkVx7dcaP
   M17ZkhOsle8q1iy6YY8uwHTd1jKAXKmDc3oXahxeKCtZQZ+7W4woplxLU
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10798"; a="361736234"
X-IronPort-AV: E=Sophos;i="6.01,164,1684825200"; 
   d="scan'208";a="361736234"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Aug 2023 22:21:05 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10798"; a="846674158"
X-IronPort-AV: E=Sophos;i="6.01,164,1684825200"; 
   d="scan'208";a="846674158"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmsmga002.fm.intel.com with ESMTP; 10 Aug 2023 22:21:04 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Thu, 10 Aug 2023 22:21:04 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Thu, 10 Aug 2023 22:21:03 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27 via Frontend Transport; Thu, 10 Aug 2023 22:21:03 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.105)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.27; Thu, 10 Aug 2023 22:21:01 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SGvrC/oxMf0yFczW2t1YB4w2LLe1IWmN+Zj5xCUA8ztnI3tuBCDEU3s9ZVGSkCzwN7QtYqzzwWUhVcb6henKZDckcBqP/20kJuA9uFKsL8wiLHaJcTcYlfhBjKp661TSZMyOaaml9Ox/JfVg63h/ovs8JR2ybjUBYWxf/GaiI33SEO3KSjS9pmjjplFQhgjOnbwiH+Iue95ezzE0OyqMMcuxNQx6hY2UTtIZ9B2bsU01L0T/Kp3hIDks75NxROq4SPZrK/Mdtbgl88M40ygd66RSKMCB5rJinm5mZh2hVFCb7XKFGvc7C+23xNz6Rl+igCDjHYHRdCK4mde6tuAlnQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=RKvkUu90ugRhEdlonNqktgUN7chvyt+fVtwLAjt6aZk=;
 b=i8w/DYqq+cffy1rIwMgj3xZVacI7Tp/wCJwwPNREar7xEvLDDBktX5IudHfVwVe7Paz8CUnq4R3O787mCSSJd5L4iDv3SBWOmGq6KBhv4iRfRClswlQB3OZIYLPPD4x9oSiWidXgAxJs/C9d42Itaj3PKjldDTOye0WsCBJCoZ+fYt/mVXUjhb90oUeAMmXRsJAMZzedSkNmHqDAghldZqFd2OM+aVLnAkYc2DykA53SE0r34YxiwQz87sTcPN4AedwbY1Hp6sT2ulJ4wPw8wEtEX+GAf2HoCHHuvWCDcPknfxY5mAbm0noUxrrurqKuSoxxlcvYAlGKOE4dt2mwBQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CO1PR11MB4820.namprd11.prod.outlook.com (2603:10b6:303:6f::8)
 by DS0PR11MB8717.namprd11.prod.outlook.com (2603:10b6:8:1ab::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6652.30; Fri, 11 Aug
 2023 05:20:55 +0000
Received: from CO1PR11MB4820.namprd11.prod.outlook.com
 ([fe80::221b:d422:710b:c9e6]) by CO1PR11MB4820.namprd11.prod.outlook.com
 ([fe80::221b:d422:710b:c9e6%3]) with mapi id 15.20.6678.020; Fri, 11 Aug 2023
 05:20:54 +0000
Message-ID: <f860826b-3380-4afb-b5ab-7acc5ed3932f@intel.com>
Date:   Fri, 11 Aug 2023 13:20:44 +0800
User-Agent: Mozilla Thunderbird
Subject: Re: + zswap-make-zswap_load-take-a-folio-fix.patch added to
 mm-unstable branch
Content-Language: en-US
To:     Matthew Wilcox <willy@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>
CC:     <mm-commits@vger.kernel.org>, <hannes@cmpxchg.org>
References: <20230810163538.7C2AAC433C7@smtp.kernel.org>
 <ZNW0+8QiWesvJwh+@casper.infradead.org>
From:   "Yin, Fengwei" <fengwei.yin@intel.com>
In-Reply-To: <ZNW0+8QiWesvJwh+@casper.infradead.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: KU1PR03CA0020.apcprd03.prod.outlook.com
 (2603:1096:802:18::32) To CO1PR11MB4820.namprd11.prod.outlook.com
 (2603:10b6:303:6f::8)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1PR11MB4820:EE_|DS0PR11MB8717:EE_
X-MS-Office365-Filtering-Correlation-Id: 05b9e259-159f-49a2-9cb9-08db9a2abc53
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: nqj1CC5DOOlNc4LmLtQQVixylLXHZU1LfZVa1jvMWYij8dpUd9Se4Qa94IIQDbFZb6sHvKB9boaQLy8NuvfCKvVwyBM25PRdl1BCK61qGrEriLFwSgxkH11Ml387HYlb809XUincYbK7J+9oZf95sjUZBIlqwrGDLCZSrUwOn1k40YKm1izZaG7T1qMFeGPczQjw4T74yvJ1uTkLrTM046a4pq44kNV1H6RAkfWBM5rdRnP6rSEYiiGkjL2f43ihRQ9OD3DJKq/r9m+ZQqCSXbF2u7QPT2NfyjLlfeN/TQRaYzf91CrDT1G+7akonMJSyhjYaWh1LOaweXwI1Q/Et2Mw3rhwK7rZbFzFjcR8xvvRaAGyhyvgKz/OtWLLpI21guOOTS3sCoeVNdZJWi2/Eu7aI/SkfpXg5yvEi0fBEUI4kl5ZWjSB+T+0gM86ZbIRhwAnAyQ77xBP1zDZ25/+PQaZXqqixRwlUzya7Khtubcfztr+1x5d316eFCK8TjLgBcIIZiEANpId3RaVYDrKrE9DlPKuKVUk3fqcJFWCTvs2q9SOLTeE6zp1QOe1aV0k3PytFS1M5LJCyy32BcdM36xURHSSXnCKm7do6MCXyyfxl2ZmJWvpx4P432Qk/Di0MY+6OGt+N2VYFgAogLNfJA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR11MB4820.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(376002)(346002)(366004)(136003)(39860400002)(396003)(451199021)(1800799006)(186006)(31686004)(8676002)(66946007)(110136005)(41300700001)(4326008)(316002)(6512007)(66476007)(6486002)(6666004)(5660300002)(66556008)(8936002)(26005)(83380400001)(6506007)(53546011)(478600001)(2616005)(38100700002)(82960400001)(31696002)(86362001)(36756003)(2906002)(4744005)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?L2wwdEZQRm0zY3pJWXB3YjgzczRBZ0huV2tuTU1xajVaV1BERjRkc21lS2Yv?=
 =?utf-8?B?OEhXTUNrL1FDVzViWHdaajhVKzNkNU4wNVEzY0p4SlZlNjMxUkQ4R04rdytj?=
 =?utf-8?B?QmZpUlo1YjduNTB1ZmJNWUc1NWRzd3l6UkNWTWhYL3RsbGNvcXlXbXRHSVdM?=
 =?utf-8?B?WS9kYkhzVFY3dEZEeEJiZkJ0QkxRa05YNXA0TUxRR1FHSTdHaUhjSkVqTG4x?=
 =?utf-8?B?K3VHT3loNy91MlI1QUhUSlVnVC9OYjU5RklLWElacjdPRWVvRzRHVk5kSEFR?=
 =?utf-8?B?K2ZKcm41WUcydjFzR3p6cWZMZ1ZYUFJHWkVOQmNRVFJoTHpYZHcxbXp5VnY2?=
 =?utf-8?B?b3A2L0NYak9YL01oYWp1QnBvWW1TQTJYbmJPb2YzeWVaS0Zjd3ZsTTlMYmtq?=
 =?utf-8?B?aGp3Z2tFd3JteDV0dUlDQVBCQ3BEMHNmdWxQSVpjaU4rUnVhelp5ZDhLQ1dW?=
 =?utf-8?B?dzNibDRUUU9rdk1NMGcyK3hCKzI3czdQbHFOaDZDQkRGa2RQc3E4U2ZJdTFx?=
 =?utf-8?B?OHFMNER0aHYxSzlDb3A0MWIwZjZ4dzlGU2g0cTJHWUtLVHM1bnliNzU4QVQ1?=
 =?utf-8?B?ZDB2VkJYVlNLRitnRXRRYWVJdy9mNTAyZjBaY005Sldoa3E0UjdReCtrR0RM?=
 =?utf-8?B?T2tVUVdTb1FFR2hJZjkrTVp3ajl3TkdvQU04S0pEVEpKajRRQmhJcnowRC8v?=
 =?utf-8?B?Z0czOVBRclZjNjI3cVRUcTNLT3hLQytCTWxVeGtrTGV3T0s1MWRocld3Vk5G?=
 =?utf-8?B?WjlzVHlFcE5mem9jc3AzWGsxV3VvbVhXTVpQQnVFQWF2bTdTZ2d4Zkh3cnM0?=
 =?utf-8?B?VlRFV1J6ZlBSZjJ1eFFUOWNaZDFoYlp5NHJ1NmhubWNEYUJTV3VSVi8xTjh0?=
 =?utf-8?B?L2hhdk81U2JXNGt5VWNzd1NDeFFadlpKNGdxOWpVbWdxZ3RkRkk5c216bldu?=
 =?utf-8?B?Vzk1WFRBNit3S2JKT1k0bHE1VWphZk1peDFtdXFDT0U2dXNaT2hmUXBrQ2l0?=
 =?utf-8?B?N3hWRmlEL3Y5Q1RJSmtBdjA3TjZiZ2ZkUko1aU5PUUJpaitpUzlRNkxSRmNI?=
 =?utf-8?B?V2JBaGxhWDNsSWYzMWVRaURGWXJxNVZxYktCN2tHVW9QYzNuZlhzOThMb3JM?=
 =?utf-8?B?bFdHSVNaRTA2bk9CY01FL2hXZExHdEtORTN1eGhwVThtU1djckZZWEVYQ0Nv?=
 =?utf-8?B?QW1udS9YTmY3anNjalUrSkh4azE0VExFb3FyWUxWZWwxVDRObFY0Mkg2TytV?=
 =?utf-8?B?QmhCSWJOY3ZlR2xvQXZDR0RYNE1URDRZeTVwL1VxR2tDNmpHTWFldEtLamhI?=
 =?utf-8?B?c2RLQkNKSXRHM0JSdU40Z2FYUW04aWxXN3k2WkNhSnZ1L3locDRwTU5qN2pz?=
 =?utf-8?B?WGxKTm1Nd2NWYktKNktYdlkxZlRlZGVjU09HY1JlUWFrVmErUEdhRkJaUU5i?=
 =?utf-8?B?d3RGUHBPZlZZN1ZPK0JaUzdERVh0Nk12clhLeHVDK2c1VnV6UmxkazUwZG5l?=
 =?utf-8?B?aG9RTDRxSFVvb25XRUQ3dzR3T3ZTOFRsOGQ3Q2s0aWo2ZEtFNHBETkl6OEdp?=
 =?utf-8?B?aHNqRnNVU3ZvZi83TTdXL3p6TlVDamlabFFBbnR4UXl0WjVUUWJMWTVzVjM4?=
 =?utf-8?B?bWdEM3lEbVVCRWtPMGJLeWkvbjBhNjFJSGNyM3JrMEZHcEZhOXNQQXFNMndJ?=
 =?utf-8?B?QUlzM1FrbmhQSVhEYW8xRm9tajdIMFhiYWs0WS9Wa1dWcmJEV1VjSDVTdDUr?=
 =?utf-8?B?MzFydW1yNWJjZ2JhSURqdEEzT0tKZTgzZzVVeWdkT2d3ZFNiK3YzQ2ZRamc3?=
 =?utf-8?B?VWJZaUxUTnlqTjBiU0JOdVpLUkkxWjhBOXZxbER4cXlXUmxHWkFmZDNDR2E2?=
 =?utf-8?B?Y3U4WSt4UlA0bS8rSTJYbDc5NUpKR0NldDR6a1B2NXpOR2JoejVsQmpmeGtV?=
 =?utf-8?B?RUUvaU5xMDJweTIrNlpxZTQ1NG9pWEYvb0RJZ1JkcndlYWhmS0dqYmUxZ0Mx?=
 =?utf-8?B?MVlvWlVCdVQ3U3hoMCtYZldUL0I5TkR2M0dtQTMzcFBKZTFxZnZJSEpzY253?=
 =?utf-8?B?UHhQMXFCSGpKNHlzSXBqQWhaNG9RWEtHcVovYmUySHJvcEpLTWVZSnl5djhj?=
 =?utf-8?B?NVB3d2xFcGZSb0s3QjhPczhTTGg3d3JoeGZUVmNza2piVEg0akNZMmg4NDdV?=
 =?utf-8?B?d1E9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 05b9e259-159f-49a2-9cb9-08db9a2abc53
X-MS-Exchange-CrossTenant-AuthSource: CO1PR11MB4820.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Aug 2023 05:20:54.6098
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: AiqOjWgxqFbEDwZKYVVOQmTdNfQWcMGL4Gw8N3ELQyI68p8dLN0GD3U3qUh+AK18cpkHVaydsSXuNAe+no1HnA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR11MB8717
X-OriginatorOrg: intel.com
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org



On 8/11/2023 12:11 PM, Matthew Wilcox wrote:
> On Thu, Aug 10, 2023 at 09:35:37AM -0700, Andrew Morton wrote:
>>
>> The patch titled
>>      Subject: zswap: don't warn if none swapcache folio is passed to zswap_load
>> has been added to the -mm mm-unstable branch.  Its filename is
>>      zswap-make-zswap_load-take-a-folio-fix.patch
> 
> Disagree that this is a fix patch.  My original patch does:
Agree with Matthew. The warning was not introduced by Matthew's patch.

> 
> -       VM_WARN_ON_ONCE(!PageLocked(page));
> -       VM_WARN_ON_ONCE(!PageSwapCache(page));
> +       VM_WARN_ON_ONCE(!folio_test_locked(folio));
> +       VM_WARN_ON_ONCE(!folio_test_swapcache(folio));
> 
> so I didn't add a new assertion, merely removed a call to
> compound_head().  I think this patch deserves to stand on its own and
> not be folded into mine.
> 
