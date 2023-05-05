Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4FB51C77B75
	for <mm-commits@archiver.kernel.org>; Fri,  5 May 2023 23:42:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231349AbjEEXmm (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 5 May 2023 19:42:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44150 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229879AbjEEXml (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 5 May 2023 19:42:41 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 21B4B6180
        for <mm-commits@vger.kernel.org>; Fri,  5 May 2023 16:42:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=rrzjSHTTKzlJfHdnh10uGqICijoOHC1AkIJX4NGE/u8=; b=vMDDCrizf3yXGU7dSll7xjYiTw
        vbWGtAfgY9fZ/DzGQ9QKjOnmLkEFTorTR0+nVa2ZynaoJYcjtBfFKf5TicfCN7Ffw2jnIwm1EzrMp
        XgyRAhqpFoufzedHr0nVxoYaA1y8Q/MgTgA1yrevjIiTSL4ho8b8/9UB+pi4/63rDH3RvnVXhNwOn
        lcCBw/qSFmvwDFcWxxp8OI7E2O1zpMvyghgdJkfHtBMGidLbLNr+9YmhD4sqAPs1RngkEU1w1XJ9c
        ofkl1ZV8GcwDdkZZzEE5283LdiPd8VKPVp+zy5La1yRb+J//MkfLpMKLrDCPfI8uvu7asVG5Zd3gQ
        P9RvNRzQ==;
Received: from willy by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1pv54O-00Bz0h-IG; Fri, 05 May 2023 23:42:36 +0000
Date:   Sat, 6 May 2023 00:42:36 +0100
From:   Matthew Wilcox <willy@infradead.org>
To:     Andrew Morton <akpm@linux-foundation.org>
Cc:     mm-commits@vger.kernel.org, marc.dionne@auristor.com, jack@suse.cz,
        dhowells@redhat.com, hch@lst.de
Subject: Re: [merged mm-hotfixes-stable]
 filemap-fix-the-conditional-folio_put-in-filemap_fault.patch removed from
 -mm tree
Message-ID: <ZFWUbBQ4YFFh1HjJ@casper.infradead.org>
References: <20230505224305.B7761C433D2@smtp.kernel.org>
 <ZFWL1QyYs8asYDzR@casper.infradead.org>
 <20230505163727.b4d285010a8df10e027208f9@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230505163727.b4d285010a8df10e027208f9@linux-foundation.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

On Fri, May 05, 2023 at 04:37:27PM -0700, Andrew Morton wrote:
> On Sat, 6 May 2023 00:05:57 +0100 Matthew Wilcox <willy@infradead.org> wrote:
> 
> > On Fri, May 05, 2023 at 03:43:05PM -0700, Andrew Morton wrote:
> > > 
> > > The quilt patch titled
> > >      Subject: filemap: fix the conditional folio_put in filemap_fault
> > > has been removed from the -mm tree.  Its filename was
> > >      filemap-fix-the-conditional-folio_put-in-filemap_fault.patch
> > > 
> > > This patch was dropped because it was merged into the mm-hotfixes-stable branch
> > > of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
> > 
> > I thought i nacked this?
> 
> This? https://lkml.kernel.org/r/ZFMn0zGC58KtQw6N@casper.infradead.org
> 
> I interpret that as "doh, never mind"?

This patch is what I want to see merged:

diff --git a/mm/filemap.c b/mm/filemap.c
index a34abfe8c654..b4c9bd368b7e 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -3378,7 +3378,7 @@ vm_fault_t filemap_fault(struct vm_fault *vmf)
 	 * re-find the vma and come back and find our hopefully still populated
 	 * page.
 	 */
-	if (folio)
+	if (!IS_ERR(folio))
 		folio_put(folio);
 	if (mapping_locked)
 		filemap_invalidate_unlock_shared(mapping);
