Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C0D02C4361B
	for <mm-commits@archiver.kernel.org>; Wed, 16 Dec 2020 10:42:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5CAA42335A
	for <mm-commits@archiver.kernel.org>; Wed, 16 Dec 2020 10:42:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726250AbgLPKma (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 16 Dec 2020 05:42:30 -0500
Received: from mga12.intel.com ([192.55.52.136]:14227 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726047AbgLPKm3 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 16 Dec 2020 05:42:29 -0500
IronPort-SDR: PYx6VPTky5xuzEc2VHbvMSowYImE5UtWp/jR2nRmJvHJAoJcAkRSPUTJoJFtjBk+CtGwobcy4R
 nrx4OirdCs1Q==
X-IronPort-AV: E=McAfee;i="6000,8403,9836"; a="154274366"
X-IronPort-AV: E=Sophos;i="5.78,424,1599548400"; 
   d="scan'208";a="154274366"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Dec 2020 02:40:43 -0800
IronPort-SDR: HCj74Sc9DSc8oSLED6DSYpCg+xXP3Ip0x3YLNIg/qPrEORcV5TEwJ/TiF7yFXW4UF7GW8cqyWj
 uKhSfnc/aPjg==
X-IronPort-AV: E=Sophos;i="5.78,424,1599548400"; 
   d="scan'208";a="337444957"
Received: from smile.fi.intel.com (HELO smile) ([10.237.68.40])
  by orsmga003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Dec 2020 02:40:41 -0800
Received: from andy by smile with local (Exim 4.94)
        (envelope-from <andriy.shevchenko@linux.intel.com>)
        id 1kpUFa-00EjX5-Vv; Wed, 16 Dec 2020 12:41:42 +0200
Date:   Wed, 16 Dec 2020 12:41:42 +0200
From:   Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To:     David Gow <davidgow@google.com>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Shuah Khan <skhan@linuxfoundation.org>,
        Brendan Higgins <brendanhiggins@google.com>,
        Mark Brown <broonie@kernel.org>, Linux-MM <linux-mm@kvack.org>,
        "Vaittinen, Matti" <matti.vaittinen@fi.rohmeurope.com>,
        mm-commits@vger.kernel.org, Vitor Massaru Iha <vitor@massaru.org>
Subject: Re: [patch 18/95] lib/list_kunit: follow new file name convention
 for KUnit tests
Message-ID: <20201216104142.GY4077@smile.fi.intel.com>
References: <20201215204156.f05ec694b907845bcfab5c44@linux-foundation.org>
 <20201216044316.LYocMD9yH%akpm@linux-foundation.org>
 <CAHk-=wgkA+jbWhDTdOTYAjhYZgBt1jZmxtAMrQUFHmaZGMOV+Q@mail.gmail.com>
 <CABVgOSk3bwm_E_dhS=G7qsBHd4oXHZkpYeNOx=CtLQUapy0GTQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CABVgOSk3bwm_E_dhS=G7qsBHd4oXHZkpYeNOx=CtLQUapy0GTQ@mail.gmail.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

On Wed, Dec 16, 2020 at 02:53:10PM +0800, David Gow wrote:
> On Wed, Dec 16, 2020 at 2:02 PM Linus Torvalds
> <torvalds@linux-foundation.org> wrote:

...

> > Don't send me any more rename patches until your tools can actually do renames.

> My other thought is that this sort of patchset really makes more sense
> to push through the kselftest/kunit branch anyway, as all of the
> changes were really more KUnit related than anything else. Does it
> make sense to re-submit this that way?

I think it makes sense because this is driven by rules set up by kselftest/kunit.
My main concern here is to have cmdline_kunit in the tree (it is a new file).
Renaming is up to you, I just wanted to be consistent with names and KUnit
documentation.

-- 
With Best Regards,
Andy Shevchenko


