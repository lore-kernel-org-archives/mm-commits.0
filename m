Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2D003C4332F
	for <mm-commits@archiver.kernel.org>; Wed, 19 Oct 2022 20:16:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229644AbiJSUQz (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 19 Oct 2022 16:16:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45816 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230393AbiJSUQw (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 19 Oct 2022 16:16:52 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D2B4D1956E6
        for <mm-commits@vger.kernel.org>; Wed, 19 Oct 2022 13:16:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=p4SS97zX/tDaDHTMYAJlm/Bk8+WuLvQo81UNXd0ua7M=; b=TmGT+grGDLNLFvUsQ16HnAXZjS
        XPk4epouPuaxQTJ5lTdIBcfs35jYGMHSt5jp8IveDHWAiZbLe0DgR6vnzmlPZ6ojZRjhtpkk/zzn9
        OA6e6xjKE1bwjhKzXCV3uCYHoaqRMHQakokcVu+Y8zLMOFZbxSHfjt5NtzN/nl9yTu9evubqRugdZ
        nBBjgDehnX1eUeYc7YF9TJHmgv2pZM08R2IQbAlZXKhWKkvLyc5kOE82CxEMm+9xXauWrLAzBq7Zv
        gYeoPFiIqHVdoP0EkhsrSloh01X4vUFIj1BHW42rOIT6Dcf3w1lVGTSawZYmjtzad+z2RAA458FdN
        PwHjVHeg==;
Received: from willy by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1olFUf-00BovA-1q; Wed, 19 Oct 2022 20:16:49 +0000
Date:   Wed, 19 Oct 2022 21:16:49 +0100
From:   Matthew Wilcox <willy@infradead.org>
To:     Andrew Morton <akpm@linux-foundation.org>
Cc:     mm-commits@vger.kernel.org, Liam.Howlett@oracle.com
Subject: Re: +
 mm-page_alloc-reduce-potential-fragmentation-in-make_alloc_exact.patch added
 to mm-unstable branch
Message-ID: <Y1BbMVrap+rVJ3m+@casper.infradead.org>
References: <20220601204412.3A924C385A5@smtp.kernel.org>
 <Y1BJATKCC+JnMS2E@casper.infradead.org>
 <20221019125519.9041b2bd456f868b3bdaa260@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221019125519.9041b2bd456f868b3bdaa260@linux-foundation.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

On Wed, Oct 19, 2022 at 12:55:19PM -0700, Andrew Morton wrote:
> On Wed, 19 Oct 2022 19:59:13 +0100 Matthew Wilcox <willy@infradead.org> wrote:
> 
> > On Wed, Jun 01, 2022 at 01:44:11PM -0700, Andrew Morton wrote:
> > > 
> > > The patch titled
> > >      Subject: mm/page_alloc: reduce potential fragmentation in make_alloc_exact()
> > > has been added to the -mm mm-unstable branch.  Its filename is
> > >      mm-page_alloc-reduce-potential-fragmentation-in-make_alloc_exact.patch
> > 
> > This patch doesn't seem to have made it upstream yet ... what happened?
> > I don't see it in mm-unstable any more, and I don't have an email saying
> > that it was dropped.
> 
> That was around the time I was transitioning stuff into the git-based
> workflow and I guess it got lost in the mayhem.  Thanks, I resurrected
> it.

Thanks.  We may need to get it to Linus soon.  This patch was required
to make some nommu platforms work with the maple tree as the current
code ends up fragmenting memory to the point that it can no longer run
executables.  I haven't seen any bug reports yet, but I can imagine that
nommu is much more lightly tested than many other configs.
