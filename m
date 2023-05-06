Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D5C30C77B7D
	for <mm-commits@archiver.kernel.org>; Sat,  6 May 2023 02:28:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229671AbjEFC2m (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 5 May 2023 22:28:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51510 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229619AbjEFC2l (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 5 May 2023 22:28:41 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2234E2120
        for <mm-commits@vger.kernel.org>; Fri,  5 May 2023 19:28:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=h+kG/+ZB8Ucgf55rKBW7L3YAlLNn8iKvHhzCjUbuy3E=; b=IMyYNQ4DAQET1Pj4dPFqLDp5wt
        blyFht8zV8ZwmahVqxXoY6S+hR8p5h2TOfJ8XYMIaumpmmttURxlzzTGAYU3qAcuFc4h0q4Ft6MYC
        pC1L6qJ+ewGPv69dncH3hF4UkHRlgW6spm5txAycrIaBCnv/GSQIDBDUX1NUsEGjlg+10odcKtMCM
        ZYmJxaFrbL6L+EMiPLsmq2yvQjH+/b0kKDi5734d7/dkVcUVBnffw6P/3rehIRl7hAI+9Z9qeDgQM
        G91D312CO/fR33/coOfvZD79Lo9r8j2C6p+cUz2zP9rEyQZsKG10cyMo/wHDar6qrJn1JzaEb+pAs
        682y/VuA==;
Received: from willy by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1pv7f2-00C5p6-5E; Sat, 06 May 2023 02:28:36 +0000
Date:   Sat, 6 May 2023 03:28:36 +0100
From:   Matthew Wilcox <willy@infradead.org>
To:     Andrew Morton <akpm@linux-foundation.org>
Cc:     mm-commits@vger.kernel.org, marc.dionne@auristor.com, jack@suse.cz,
        dhowells@redhat.com, hch@lst.de
Subject: Re: [merged mm-hotfixes-stable]
 filemap-fix-the-conditional-folio_put-in-filemap_fault.patch removed from
 -mm tree
Message-ID: <ZFW7VPuFHU565fa5@casper.infradead.org>
References: <20230505224305.B7761C433D2@smtp.kernel.org>
 <ZFWL1QyYs8asYDzR@casper.infradead.org>
 <20230505163727.b4d285010a8df10e027208f9@linux-foundation.org>
 <ZFWUbBQ4YFFh1HjJ@casper.infradead.org>
 <20230505180413.0c40660fbbc06fc260b18dc5@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230505180413.0c40660fbbc06fc260b18dc5@linux-foundation.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

On Fri, May 05, 2023 at 06:04:13PM -0700, Andrew Morton wrote:
> On Sat, 6 May 2023 00:42:36 +0100 Matthew Wilcox <willy@infradead.org> wrote:
> > This patch is what I want to see merged:
> 
> Oh.  And hch preferred the label approach.  I'll stick with the patch
> as-is.  Please send an alteration if you feel sufficiently strongly
> about it.

I'm supposed to be the maintainer.  My preference trumps Christoph's.

