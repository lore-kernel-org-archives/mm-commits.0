Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B7FDCC77B7C
	for <mm-commits@archiver.kernel.org>; Sat,  6 May 2023 01:04:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229644AbjEFBER (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 5 May 2023 21:04:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43574 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229441AbjEFBEQ (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 5 May 2023 21:04:16 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2CDB559DA
        for <mm-commits@vger.kernel.org>; Fri,  5 May 2023 18:04:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B4C92641C5
        for <mm-commits@vger.kernel.org>; Sat,  6 May 2023 01:04:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D8B48C433D2;
        Sat,  6 May 2023 01:04:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1683335054;
        bh=XGAPVfFt+muRo93LgjXQZQgo7U+CT9NLGbHgDigwI0I=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=2S0ryvoZFcsOjfmeMMw5xcLVnaa7PK/1ROJpY4DVRKuIFgW1rr48z0hHShZE+xCJo
         WzZ7rLeBttBWSA10E7TWLkhhZXg1RA6ka6rfNTWEFyNcFl7/YUmyzeoj6UOZKQ93q3
         6d64N6qpllM1GJJnmNHIZce3VL0k/kXNwzoLpoEs=
Date:   Fri, 5 May 2023 18:04:13 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     Matthew Wilcox <willy@infradead.org>
Cc:     mm-commits@vger.kernel.org, marc.dionne@auristor.com, jack@suse.cz,
        dhowells@redhat.com, hch@lst.de
Subject: Re: [merged mm-hotfixes-stable]
 filemap-fix-the-conditional-folio_put-in-filemap_fault.patch removed from
 -mm tree
Message-Id: <20230505180413.0c40660fbbc06fc260b18dc5@linux-foundation.org>
In-Reply-To: <ZFWUbBQ4YFFh1HjJ@casper.infradead.org>
References: <20230505224305.B7761C433D2@smtp.kernel.org>
        <ZFWL1QyYs8asYDzR@casper.infradead.org>
        <20230505163727.b4d285010a8df10e027208f9@linux-foundation.org>
        <ZFWUbBQ4YFFh1HjJ@casper.infradead.org>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

On Sat, 6 May 2023 00:42:36 +0100 Matthew Wilcox <willy@infradead.org> wrote:

> On Fri, May 05, 2023 at 04:37:27PM -0700, Andrew Morton wrote:
> > On Sat, 6 May 2023 00:05:57 +0100 Matthew Wilcox <willy@infradead.org> wrote:
> > 
> > > On Fri, May 05, 2023 at 03:43:05PM -0700, Andrew Morton wrote:
> > > > 
> > > > The quilt patch titled
> > > >      Subject: filemap: fix the conditional folio_put in filemap_fault
> > > > has been removed from the -mm tree.  Its filename was
> > > >      filemap-fix-the-conditional-folio_put-in-filemap_fault.patch
> > > > 
> > > > This patch was dropped because it was merged into the mm-hotfixes-stable branch
> > > > of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
> > > 
> > > I thought i nacked this?
> > 
> > This? https://lkml.kernel.org/r/ZFMn0zGC58KtQw6N@casper.infradead.org
> > 
> > I interpret that as "doh, never mind"?
> 
> This patch is what I want to see merged:
>
> ...
>
> --- a/mm/filemap.c
> +++ b/mm/filemap.c
> @@ -3378,7 +3378,7 @@ vm_fault_t filemap_fault(struct vm_fault *vmf)
>  	 * re-find the vma and come back and find our hopefully still populated
>  	 * page.
>  	 */
> -	if (folio)
> +	if (!IS_ERR(folio))
>  		folio_put(folio);
>  	if (mapping_locked)
>  		filemap_invalidate_unlock_shared(mapping);

Oh.  And hch preferred the label approach.  I'll stick with the patch
as-is.  Please send an alteration if you feel sufficiently strongly
about it.

