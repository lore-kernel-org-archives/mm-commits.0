Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 091C2C2BB9A
	for <mm-commits@archiver.kernel.org>; Tue, 15 Dec 2020 19:09:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B99A422B2D
	for <mm-commits@archiver.kernel.org>; Tue, 15 Dec 2020 19:09:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731770AbgLOTJf (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 15 Dec 2020 14:09:35 -0500
Received: from mga07.intel.com ([134.134.136.100]:14277 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731800AbgLOTJe (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 15 Dec 2020 14:09:34 -0500
IronPort-SDR: vo8PXlpPV3gYwzBU7Fng7Bfas5X5ie9UssdzPo/6/1coRcMxtqnp4G6+1QkwmGL9Fo30hBWeD1
 ABcMh3mmYBAQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9836"; a="239034885"
X-IronPort-AV: E=Sophos;i="5.78,422,1599548400"; 
   d="scan'208";a="239034885"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Dec 2020 11:07:46 -0800
IronPort-SDR: 2R7qno6uaUVqcZsV2isIIHY5z2yXvnV5wP5VbcKQPY9aSpW8qFHW8ISmNJ7e6oV49hEGLzXzNs
 tlv3nIRLiYJg==
X-IronPort-AV: E=Sophos;i="5.78,422,1599548400"; 
   d="scan'208";a="556432183"
Received: from smile.fi.intel.com (HELO smile) ([10.237.68.40])
  by fmsmga006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Dec 2020 11:07:40 -0800
Received: from andy by smile with local (Exim 4.94)
        (envelope-from <andriy.shevchenko@linux.intel.com>)
        id 1kpFge-00Ea78-IL; Tue, 15 Dec 2020 21:08:40 +0200
Date:   Tue, 15 Dec 2020 21:08:40 +0200
From:   Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To:     Christian =?iso-8859-1?Q?K=F6nig?= <christian.koenig@amd.com>
Cc:     Andrew Morton <akpm@linux-foundation.org>, airlied@linux.ie,
        alexander.shishkin@linux.intel.com, bgolaszewski@baylibre.com,
        bp@alien8.de, bp@suse.de, cl@linux.com, daniel.vetter@ffwll.ch,
        daniel@ffwll.ch, gustavo@padovan.org, iamjoonsoo.kim@lge.com,
        james.morse@arm.com, jasowang@redhat.com, linus.walleij@linaro.org,
        linux-mm@kvack.org, maarten.lankhorst@linux.intel.com,
        mchehab@kernel.org, mm-commits@vger.kernel.org, mripard@kernel.org,
        mst@redhat.com, penberg@kernel.org, perex@perex.cz,
        rientjes@google.com, rric@kernel.org, sumit.semwal@linaro.org,
        tiwai@suse.com, tiwai@suse.de, tony.luck@intel.com,
        torvalds@linux-foundation.org, tzimmermann@suse.de, vbabka@suse.cz
Subject: Re: [patch 012/200] mm: slab: clarify krealloc()'s behavior with
 __GFP_ZERO
Message-ID: <20201215190840.GU4077@smile.fi.intel.com>
References: <20201215030350.xC0HoDUgG%akpm@linux-foundation.org>
 <2172e342-e73f-a759-fce5-8b94daafd506@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <2172e342-e73f-a759-fce5-8b94daafd506@amd.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

On Tue, Dec 15, 2020 at 03:30:44PM +0100, Christian König wrote:
> Am 15.12.20 um 04:03 schrieb Andrew Morton:

...

> Question: Can the fact that __GFP_ZERO is effectively ignored cause an
> information leak if new size is larger than old size and the array is
> somehow copied to user space?
> 
> I think the answer is no, but just wanted to double check. Maybe we should
> note that here.

kmalloc()/kmalloc_array()/etc has the same. Should it be mentioned there as well?

-- 
With Best Regards,
Andy Shevchenko


