Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6E04CC4361B
	for <mm-commits@archiver.kernel.org>; Thu, 17 Dec 2020 12:04:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3040A238E8
	for <mm-commits@archiver.kernel.org>; Thu, 17 Dec 2020 12:04:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727336AbgLQMED (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 17 Dec 2020 07:04:03 -0500
Received: from mga07.intel.com ([134.134.136.100]:60444 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726155AbgLQMED (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 17 Dec 2020 07:04:03 -0500
IronPort-SDR: xZJjfOZCAXuP/Re7oQMWCi4Xr5b8JkL57Fzajbj8RQjHP8fiNY4tTdiKWuma2VDuXNBarFUCqN
 j4dnNzOY+Vcg==
X-IronPort-AV: E=McAfee;i="6000,8403,9837"; a="239327536"
X-IronPort-AV: E=Sophos;i="5.78,427,1599548400"; 
   d="scan'208";a="239327536"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Dec 2020 04:01:59 -0800
IronPort-SDR: L7XrsWPv9JxaN9xmMmPdvpjGsr7zebuNLV2Y99+fMTn4NCU1nFJTsV7Y4c0ZXPZQwi0Q7pDFw7
 nq4xOTFOMm8g==
X-IronPort-AV: E=Sophos;i="5.78,427,1599548400"; 
   d="scan'208";a="387487451"
Received: from smile.fi.intel.com (HELO smile) ([10.237.68.40])
  by fmsmga002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Dec 2020 04:01:57 -0800
Received: from andy by smile with local (Exim 4.94)
        (envelope-from <andriy.shevchenko@linux.intel.com>)
        id 1kprzm-00F0AE-R0; Thu, 17 Dec 2020 14:02:58 +0200
Date:   Thu, 17 Dec 2020 14:02:58 +0200
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
Message-ID: <20201217120258.GP4077@smile.fi.intel.com>
References: <20201215204156.f05ec694b907845bcfab5c44@linux-foundation.org>
 <20201216044316.LYocMD9yH%akpm@linux-foundation.org>
 <CAHk-=wgkA+jbWhDTdOTYAjhYZgBt1jZmxtAMrQUFHmaZGMOV+Q@mail.gmail.com>
 <CABVgOSk3bwm_E_dhS=G7qsBHd4oXHZkpYeNOx=CtLQUapy0GTQ@mail.gmail.com>
 <20201216104142.GY4077@smile.fi.intel.com>
 <CABVgOS=6Kt9owiH0dJZ7b7_hC4LUb=DpOfNmYrmEYg1HGpcYPA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CABVgOS=6Kt9owiH0dJZ7b7_hC4LUb=DpOfNmYrmEYg1HGpcYPA@mail.gmail.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

On Thu, Dec 17, 2020 at 05:21:00PM +0800, David Gow wrote:
> On Wed, Dec 16, 2020 at 6:41 PM Andy Shevchenko
> <andriy.shevchenko@linux.intel.com> wrote:
> > On Wed, Dec 16, 2020 at 02:53:10PM +0800, David Gow wrote:
> > > On Wed, Dec 16, 2020 at 2:02 PM Linus Torvalds
> > > <torvalds@linux-foundation.org> wrote:

...

> > > > Don't send me any more rename patches until your tools can actually do renames.
> >
> > > My other thought is that this sort of patchset really makes more sense
> > > to push through the kselftest/kunit branch anyway, as all of the
> > > changes were really more KUnit related than anything else. Does it
> > > make sense to re-submit this that way?
> >
> > I think it makes sense because this is driven by rules set up by kselftest/kunit.
> > My main concern here is to have cmdline_kunit in the tree (it is a new file).
> > Renaming is up to you, I just wanted to be consistent with names and KUnit
> > documentation.
> 
> It looks like the cmdline_kunit changes have been merged now, so it's
> a relief that those weren't held up: I agree that they're the more
> important changes.

Yes, they are in, thanks Linus!

> I do think renaming things to match the new convention is a good idea
> (so thanks again for doing that), but it's not exactly an urgent fix.
> My preference is that these get added to one of the kunit branches in
> the kselftest repo, so they can be picked up when convenient. This
> should just be the first three patches in this series:
> https://lore.kernel.org/linux-kselftest/20201112180732.75589-1-andriy.shevchenko@linux.intel.com/
> 
> I'd expect those to still apply pretty cleanly, but I haven't actually
> checked yet.

They won't apply after v5.11-rc1 due to cmdline_kunit entry. I can rebase after
rc1 and send it to KUnit/kselftest mailing lists.

Andrew, please drop these patches from your quilt and thanks for carrying them.

-- 
With Best Regards,
Andy Shevchenko


