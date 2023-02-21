Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 76FABC636D7
	for <mm-commits@archiver.kernel.org>; Tue, 21 Feb 2023 23:19:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230191AbjBUXTz (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 21 Feb 2023 18:19:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39502 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229567AbjBUXTy (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 21 Feb 2023 18:19:54 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 65F822A145
        for <mm-commits@vger.kernel.org>; Tue, 21 Feb 2023 15:19:46 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 17C81B810D6
        for <mm-commits@vger.kernel.org>; Tue, 21 Feb 2023 23:19:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA8B5C433EF;
        Tue, 21 Feb 2023 23:19:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1677021583;
        bh=bNTdxRWkfJOYeCCBvOb2gbfKu26Aidnr1cgVohX+ddY=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=LsLC7jtE2aoLdwA+xAB6tHeIfd1hhnNQfVAVh7CEFjF+LIQob5a1IyryHKJRaOIWF
         3RnKDihZ/i+RiDAJXpq0MYFOD5T6BtbkcJDgQWCjfQ5jSp+8PgRqyp3sLBUdUmc062
         2cVRYIDAyZVM+yLupLSCg0DGaaFOh3kdPsxLyvOg=
Date:   Tue, 21 Feb 2023 15:19:42 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     Andreas Gruenbacher <agruenba@redhat.com>
Cc:     mm-commits@vger.kernel.org, Matthew Wilcox <willy@infradead.org>
Subject: Re: [merged mm-stable]
 gfs2-convert-gfs2_write_cache_jdata-to-use-filemap_get_folios_tag.patch
 removed from -mm tree
Message-Id: <20230221151942.80ba3e3f10887b031a7ca5b5@linux-foundation.org>
In-Reply-To: <CAHc6FU4_rzr9U0cs8efjmy6Wn0NP7K1wkcoZtsz8r+Ng06r7Xg@mail.gmail.com>
References: <20230203063724.26745C4339B@smtp.kernel.org>
        <20230203105401.3362277-1-agruenba@redhat.com>
        <CAHc6FU4_rzr9U0cs8efjmy6Wn0NP7K1wkcoZtsz8r+Ng06r7Xg@mail.gmail.com>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

On Tue, 21 Feb 2023 23:52:02 +0100 Andreas Gruenbacher <agruenba@redhat.com> wrote:

> Hi again,
> 
> the following conflict on mm-stable still hasn't been fixed.
>
> ...
>
> > --- a/fs/gfs2/log.c
> > +++ b/fs/gfs2/log.c
> > @@ -80,11 +80,11 @@ void gfs2_remove_from_ail(struct gfs2_bufdata *bd)
> >         brelse(bd->bd_bh);
> >  }
> >
> > -static int __gfs2_writepage(struct page *page, struct writeback_control *wbc,
> > -                      void *data)
> > +static int __gfs2_writepage(struct folio *folio, struct writeback_control *wbc,
> > +                           void *data)
> >  {
> >         struct address_space *mapping = data;
> > -       int ret = mapping->a_ops->writepage(page, wbc);
> > +       int ret = mapping->a_ops->writepage(&folio->page, wbc);
> >         mapping_set_error(mapping, ret);
> >         return ret;
> >  }

Ah.  When you said "conflict" I expected an actual patch reject.

Thanks, I'll put something together for Linus.
