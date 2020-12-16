Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5581DC4361B
	for <mm-commits@archiver.kernel.org>; Wed, 16 Dec 2020 11:24:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0F00622D08
	for <mm-commits@archiver.kernel.org>; Wed, 16 Dec 2020 11:24:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725846AbgLPLYn (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 16 Dec 2020 06:24:43 -0500
Received: from mga01.intel.com ([192.55.52.88]:41908 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725825AbgLPLYn (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 16 Dec 2020 06:24:43 -0500
IronPort-SDR: d6VIsQm8/ZxcZu/wg1en9mRBNNSncKYqcKzTElTnpr9NTaeiodidbDUYhlbBPiwL9q4XpfsPQ4
 JMefv6f6xbQQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9836"; a="193430839"
X-IronPort-AV: E=Sophos;i="5.78,424,1599548400"; 
   d="scan'208";a="193430839"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Dec 2020 03:22:57 -0800
IronPort-SDR: SwBmQ5tLg7ZBVQM4wUZizehwFJf/df9eiAFYeevLRGvLTyFB+ooI7e3QelpBTlda8lxMtKIS1x
 0FSH5bXgADpA==
X-IronPort-AV: E=Sophos;i="5.78,424,1599548400"; 
   d="scan'208";a="384425397"
Received: from smile.fi.intel.com (HELO smile) ([10.237.68.40])
  by fmsmga004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Dec 2020 03:22:50 -0800
Received: from andy by smile with local (Exim 4.94)
        (envelope-from <andriy.shevchenko@linux.intel.com>)
        id 1kpUuN-00Ek3v-5T; Wed, 16 Dec 2020 13:23:51 +0200
Date:   Wed, 16 Dec 2020 13:23:51 +0200
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
Message-ID: <20201216112351.GZ4077@smile.fi.intel.com>
References: <20201215030350.xC0HoDUgG%akpm@linux-foundation.org>
 <2172e342-e73f-a759-fce5-8b94daafd506@amd.com>
 <20201215190840.GU4077@smile.fi.intel.com>
 <14a1a889-fc99-47df-c336-1727e8e22b42@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <14a1a889-fc99-47df-c336-1727e8e22b42@amd.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

On Wed, Dec 16, 2020 at 08:47:25AM +0100, Christian König wrote:
> Am 15.12.20 um 20:08 schrieb Andy Shevchenko:
> > On Tue, Dec 15, 2020 at 03:30:44PM +0100, Christian König wrote:
> > > Am 15.12.20 um 04:03 schrieb Andrew Morton:
> > ...
> > 
> > > Question: Can the fact that __GFP_ZERO is effectively ignored cause an
> > > information leak if new size is larger than old size and the array is
> > > somehow copied to user space?
> > > 
> > > I think the answer is no, but just wanted to double check. Maybe we should
> > > note that here.
> > kmalloc()/kmalloc_array()/etc has the same. Should it be mentioned there as well?
> 
> No, they don't. If kmalloc()/kmalloc_array() would ignore __GFP_ZERO we
> would have quite a problem.
> 
> It is only krealloc()/krealloc_array() which ignore __GFP_ZERO when they
> don't reallocate memory because newsize is smaller than oldsize. In other
> words the freed up space is not cleared in any way.

Yes, true. So, you meant that comment now a bit misleading. I agree.

-- 
With Best Regards,
Andy Shevchenko


