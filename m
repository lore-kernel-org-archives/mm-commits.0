Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D18EFC433FE
	for <mm-commits@archiver.kernel.org>; Tue, 18 Oct 2022 14:15:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230057AbiJROPx (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 18 Oct 2022 10:15:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41298 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229660AbiJROPw (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 18 Oct 2022 10:15:52 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0867FBC636
        for <mm-commits@vger.kernel.org>; Tue, 18 Oct 2022 07:15:51 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 5DF37CE1DE3
        for <mm-commits@vger.kernel.org>; Tue, 18 Oct 2022 14:15:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A0069C433C1;
        Tue, 18 Oct 2022 14:15:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1666102548;
        bh=x6pCyD8b/BvJJM/Iz24xDfS85ZSA0nDIfxF7/e09VeA=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=VWi/y57zxxHfPNfOBLq7vSTVrgu+oeHhqRMC0xwMvXmkP46kTNUUaZl3V1xHY7TQu
         H19kVLV/yfPmg5pF9ccIhQrdbWzexfyLN4cKINc+CNJPU5awve777akefV77yPu2da
         QWjOqexCbrx6x6IIdi57H9WkawaVCAIVpJjbeRPA=
Date:   Tue, 18 Oct 2022 07:15:47 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc:     mm-commits@vger.kernel.org, keescook@chromium.org, Jason@zx2c4.com
Subject: Re: +
 minmax-sanity-check-constant-bounds-when-clamping-checkpatch-fixes.patch
 added to mm-nonmm-unstable branch
Message-Id: <20221018071547.b22698983af2a2e43d7ba76b@linux-foundation.org>
In-Reply-To: <Y06bv9ZKBUXkI35x@smile.fi.intel.com>
References: <20221018011800.3857BC433C1@smtp.kernel.org>
        <Y06bv9ZKBUXkI35x@smile.fi.intel.com>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

On Tue, 18 Oct 2022 15:27:43 +0300 Andy Shevchenko <andriy.shevchenko@linux.intel.com> wrote:

> On Mon, Oct 17, 2022 at 06:17:59PM -0700, Andrew Morton wrote:
> 
> ...
> > +	__builtin_choose_expr(__typecheck(val, lo) && __typecheck(val, hi) &&\
> > +			      __typecheck(hi, lo) && __is_constexpr(val) &&\
> > +			      __is_constexpr(lo) && __is_constexpr(hi),	\
> > +		__clamp(val, lo, hi),					\
> > +		__clamp_once(val, lo, hi, __UNIQUE_ID(__val),		\
> >  			     __UNIQUE_ID(__lo), __UNIQUE_ID(__hi))); })
> 
> ...but this one becomes less readable. I think checkpatch is always a
> recommendation than requirement. I would leave at least the last as is, but
> formally I think the entire patch is a churn to satisfy controversial
> recommendation.

This wasn't really a checkpatch thing.  I looked at the code in an
80-col window and nearly died.  It wasn't *necessary* to make it look
so bad in 80 cols, so why do it?


