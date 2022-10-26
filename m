Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EF2EEC38A2D
	for <mm-commits@archiver.kernel.org>; Wed, 26 Oct 2022 13:18:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233403AbiJZNS1 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 26 Oct 2022 09:18:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55396 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233983AbiJZNSJ (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 26 Oct 2022 09:18:09 -0400
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D3D2A103DB2;
        Wed, 26 Oct 2022 06:17:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1666790236; x=1698326236;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=hIbMjk472qjMcR6jrGfkylFFiMP/jDat0gI5PwpO4rw=;
  b=MIjeZ4ZyFKsTzLBq4Pq6STvwJaE4Yr/xWOZYOiHgBMUNsVxbXDIhpnhs
   G2s3ENh+t8qmJtWwpcBTJ1owPgc2a6SpoqWgIk+dYNBilpVLFciHCd5jm
   tXrJi8z6lRiqde6VAs8oGOI4TBR7LiqdNH0QUIKdp/q2dDK0QrTAW0Alj
   x/lVJ/xdLJ0uwcqjkZ4ioBjABTgIxTJQr6naXR1YU2CrJSWh0/yEa0LsD
   Pt4qlEibg7AfOp1kqqkCdbM/uBv9X1ZP2g4+qjYN1NvE5s1frKRZymnXh
   1wmYEVTwr8B7s5CYGRw6zCJ8Yn8lAM94FW1DrQzdrgjSEGDtHWbuPOoNt
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10512"; a="307935495"
X-IronPort-AV: E=Sophos;i="5.95,214,1661842800"; 
   d="scan'208";a="307935495"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Oct 2022 06:17:10 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10512"; a="632000787"
X-IronPort-AV: E=Sophos;i="5.95,214,1661842800"; 
   d="scan'208";a="632000787"
Received: from smile.fi.intel.com ([10.237.72.54])
  by orsmga002.jf.intel.com with ESMTP; 26 Oct 2022 06:17:07 -0700
Received: from andy by smile.fi.intel.com with local (Exim 4.96)
        (envelope-from <andriy.shevchenko@linux.intel.com>)
        id 1ongHJ-002f4J-0g;
        Wed, 26 Oct 2022 16:17:05 +0300
Date:   Wed, 26 Oct 2022 16:17:04 +0300
From:   Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To:     "Jason A. Donenfeld" <Jason@zx2c4.com>,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>
Cc:     Kees Cook <keescook@chromium.org>, cocci@inria.fr,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Alexey Dobriyan <adobriyan@gmail.com>,
        akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        mm-commits@vger.kernel.org, masahiroy@kernel.org,
        gregkh@linuxfoundation.org, Stephen Rothwell <sfr@canb.auug.org.au>
Subject: Re: [PATCH -mm] -funsigned-char, x86: make struct
 p4_event_bind::cntr signed array
Message-ID: <Y1kzUMzFdMiHpEnF@smile.fi.intel.com>
References: <20221020000356.177CDC433C1@smtp.kernel.org>
 <Y1EZuQcO8UoN91cX@localhost.localdomain>
 <CAHmME9prEhkHqQmtDGCSFunNnxiKdE_8FHKiksyqebUN63U81Q@mail.gmail.com>
 <CAHk-=whFow9Wd6C8htoRUt5wXbwf1i_qbuArBbhXOPqYsTFvtw@mail.gmail.com>
 <CAHmME9qBZqTd0D_gr8nE+DUzCrC0fxZNZK=7u+21jbgtFgAJBg@mail.gmail.com>
 <CAHk-=wjZDC9o8iwF+bU91Hx40HjGOpMui+VoFCDJkaGCu=rG4A@mail.gmail.com>
 <202210201151.ECC19BC97A@keescook>
 <Y1iSYddi3BpP8gvf@zx2c4.com>
 <Y1ku+jfRAyezq6Nz@zx2c4.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y1ku+jfRAyezq6Nz@zx2c4.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

+Cc: Rasmus as he has done a lot regarding library stuff and optimizations and
     he knows Coccinelle (to some extent as far as I can tell).

On Wed, Oct 26, 2022 at 02:58:34PM +0200, Jason A. Donenfeld wrote:
> On Wed, Oct 26, 2022 at 03:50:25AM +0200, Jason A. Donenfeld wrote:
> > The traditional objdump comparison does work, though. It produces a good
> 
> Another thing that appears to work well is just using Coccinelle
> scripts. I've had some success just scrolling through the results of:
> 
>     @@
>     char c;
>     expression E;
>     @@
>     (
>     * E > c
>     |
>     * E >= c
>     |
>     * E < c
>     |
>     * E <= c
>     )
> 
> That also triggers on explicitly signed chars, and examining those
> reveals that quite a bit of code in the tree already does do the right
> thing, which is good.
> 
> From looking at this and objdump output, it looks like most naked-char
> usage that isn't for strings is actually already assuming it's unsigned,
> using it as a byte. I'll continue to churn, and I'm sure I'll miss a few
> things here and there, but all and all, I don't think this is looking as
> terrible as I initially feared.
> 
> I'm CC'ing the Coccinelle people to see if they have any nice ideas on
> improvements. Specifically, the thing we're trying to identify is:
> 
>   - Usage of vanilla `char`, without a `signed` or `unsigned` qualifier,
>     where:
>   - It's not being used for characters; and
>   - It's doing something that assumes it is signed, such as various
>     types of comparisons or decrements.
> 
> LWN wrote a summary of the general problem, in case that helps describe
> what would be useful: https://lwn.net/SubscriberLink/911914/f90c2ed1af23cbc4/
> 
> Any nice Cocci tricks for this?

-- 
With Best Regards,
Andy Shevchenko


