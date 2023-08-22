Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 028ADEE4993
	for <mm-commits@archiver.kernel.org>; Tue, 22 Aug 2023 19:01:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229695AbjHVTBR (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 22 Aug 2023 15:01:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60868 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229560AbjHVTBQ (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 22 Aug 2023 15:01:16 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CEDDACC
        for <mm-commits@vger.kernel.org>; Tue, 22 Aug 2023 12:01:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=hB9343VD8DIFN469ebxgo1aKb0Sv9Uhlj9LFPWzWuJA=; b=S+MJT0tYkIml0vOQk1xIK3ienh
        1/YKuIbck8+0G9Eha2FcUKrPWQjdjTuJcv0PL2/SyD9gnkTVbSCAxe11Hlv34okl/o85ZFyqmfvM+
        SriUEs9WyJHt9u+OuaFm5/6KAfTD9jXBDV8Zdk1zXRqGLK9HC09VEN/dI68OnlWbhzGQvWrvkKuFR
        IZtWf+4ZEVpBH5eGfjsJdvXaA9/cE9GK3C66EDlxhcwJWIQmNrLdUrILpU2/GAQNpZFe/Bm1OtIbc
        4B1U791jn/56Cc593wwcOKaTs1ULTRVuJgVk+lWD6alWEWX+EFgWssvX/o99w7WN9Mw+75Kxy/gkZ
        TXlgiOEw==;
Received: from willy by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1qYWco-000NEm-II; Tue, 22 Aug 2023 19:01:10 +0000
Date:   Tue, 22 Aug 2023 20:01:10 +0100
From:   Matthew Wilcox <willy@infradead.org>
To:     Mateusz Guzik <mjguzik@gmail.com>
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        mm-commits@vger.kernel.org, Liam.Howlett@oracle.com
Subject: Re: +
 maple_tree-shrink-struct-maple_tree-from-24-to-16-bytes-on-lp64.patch added
 to mm-unstable branch
Message-ID: <ZOUF9ocK0b+ZIQpd@casper.infradead.org>
References: <20230822184454.D1B73C433C7@smtp.kernel.org>
 <ZOUDI/w51dJG7hOE@casper.infradead.org>
 <CAGudoHEBb4qDyyTKAtUx8-vAd312FO9vH4bnTBPHuHttV_2HiQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAGudoHEBb4qDyyTKAtUx8-vAd312FO9vH4bnTBPHuHttV_2HiQ@mail.gmail.com>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

On Tue, Aug 22, 2023 at 08:57:46PM +0200, Mateusz Guzik wrote:
> On 8/22/23, Matthew Wilcox <willy@infradead.org> wrote:
> > On Tue, Aug 22, 2023 at 11:44:54AM -0700, Andrew Morton wrote:
> >> ------------------------------------------------------
> >> From: Mateusz Guzik <mjguzik@gmail.com>
> >> Subject: maple_tree: shrink struct maple_tree from 24 to 16 bytes on LP64
> >> Date: Tue, 22 Aug 2023 00:51:45 +0200
> >>
> >> by plugging a padding hole.
> >>
> >> Link:
> >> https://lkml.kernel.org/r/20230821225145.2169848-1-mjguzik@gmail.com
> >> Signed-off-by: Mateusz Guzik <mjguzik@gmail.com>
> >> Reviewed-by: Liam R. Howlett <Liam.Howlett@oracle.com>
> >> Cc: Matthew Wilcox <willy@infradead.org>
> >> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> >> ---
> >
> > Could we perhaps amend the commit log?
> >
> > Subject: maple_tree: Shrink struct maple_tree
> >
> > Pack the members of struct maple_tree to avoid holes on 64-bit.
> > The size shrinks from 24 to 16 bytes which will save eight bytes
> > in every structure which embeds it.
> >
> > Reviewed-by: Matthew Wilcox (Oracle) <willy@infradead.org>
> >
> 
> Is this kind of descriptiveness expected? I am only a sojourner here,
> but even then I suspect I'm going to run into a bunch of other
> trivialities of this sort.

Generally, yes, descriptiveness is expected.  I acknowledge it can
be hard to think of what to say, particularly for a one-line patch.

Specifically, the term "LP64" is rarely used; 64-bit or CONFIG_64BIT is
more common.  It's also uncommon to continue a sentence fragment from
the Subject line into the body.

> fwiw I would avoid the term 'pack' as it suggests the attribute
> "packed", perhaps:
> 
> > Reorder the members of struct maple_tree to avoid holes on 64-bit.
> > The size shrinks from 24 to 16 bytes which will save eight bytes
> > in every structure which embeds it.

Works for me!
