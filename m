Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2ACCCC0015E
	for <mm-commits@archiver.kernel.org>; Fri, 11 Aug 2023 17:18:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236776AbjHKRSG (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 11 Aug 2023 13:18:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34928 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234215AbjHKRSF (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 11 Aug 2023 13:18:05 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D980330D2
        for <mm-commits@vger.kernel.org>; Fri, 11 Aug 2023 10:18:04 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 74E6466E15
        for <mm-commits@vger.kernel.org>; Fri, 11 Aug 2023 17:18:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ADED4C433C7;
        Fri, 11 Aug 2023 17:18:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1691774283;
        bh=ViwQMnfzL6y4JNeg9yjZQM3G4jSBoaQFmV9Nlu35TzY=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Pp86MTQNDwZjWMbdPWlJoXRDXrPUPepC3HGrnhkcqND59Xgne6g38MaZ/JdFnZ31/
         o4nfQqMvoqpEplChNb96oyapJ9d+Z8dxtvrgQs1OWby8eNjBCmBX3tk6szs8k6Wbcq
         bGpCIKnmGCmBEuYIpSKECrWkSBwuq+dzKHYivx68=
Date:   Fri, 11 Aug 2023 10:18:03 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     "Yin, Fengwei" <fengwei.yin@intel.com>
Cc:     Matthew Wilcox <willy@infradead.org>, <mm-commits@vger.kernel.org>,
        <hannes@cmpxchg.org>
Subject: Re: + zswap-make-zswap_load-take-a-folio-fix.patch added to
 mm-unstable branch
Message-Id: <20230811101803.a9efab4dfbe02b435ca1886a@linux-foundation.org>
In-Reply-To: <f860826b-3380-4afb-b5ab-7acc5ed3932f@intel.com>
References: <20230810163538.7C2AAC433C7@smtp.kernel.org>
        <ZNW0+8QiWesvJwh+@casper.infradead.org>
        <f860826b-3380-4afb-b5ab-7acc5ed3932f@intel.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

On Fri, 11 Aug 2023 13:20:44 +0800 "Yin, Fengwei" <fengwei.yin@intel.com> wrote:

> 
> 
> On 8/11/2023 12:11 PM, Matthew Wilcox wrote:
> > On Thu, Aug 10, 2023 at 09:35:37AM -0700, Andrew Morton wrote:
> >>
> >> The patch titled
> >>      Subject: zswap: don't warn if none swapcache folio is passed to zswap_load
> >> has been added to the -mm mm-unstable branch.  Its filename is
> >>      zswap-make-zswap_load-take-a-folio-fix.patch
> > 
> > Disagree that this is a fix patch.  My original patch does:
> Agree with Matthew. The warning was not introduced by Matthew's patch.
> 
> > 
> > -       VM_WARN_ON_ONCE(!PageLocked(page));
> > -       VM_WARN_ON_ONCE(!PageSwapCache(page));
> > +       VM_WARN_ON_ONCE(!folio_test_locked(folio));
> > +       VM_WARN_ON_ONCE(!folio_test_swapcache(folio));
> > 
> > so I didn't add a new assertion, merely removed a call to
> > compound_head().  I think this patch deserves to stand on its own and
> > not be folded into mine.
> > 

OK, so it seems these assertions were added by hannes's "mm: kill
frontswap"
(https://lkml.kernel.org/r/20230717160227.GA867137@cmpxchg.org).  I'm
not really sure why - they don't appear to have been moved from
elsewhere.

So I'll requeue this as a fix against mm-kill-frontswap.patch.

The same two assertions were added to zswap_store().  Are they correct?

