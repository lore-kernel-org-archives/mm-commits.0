Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BEB40C61DA3
	for <mm-commits@archiver.kernel.org>; Tue, 21 Feb 2023 22:53:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229974AbjBUWxI (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 21 Feb 2023 17:53:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46334 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230135AbjBUWxG (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 21 Feb 2023 17:53:06 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D47FD305DE
        for <mm-commits@vger.kernel.org>; Tue, 21 Feb 2023 14:52:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1677019938;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=bE6IKh0Qcu+iI0fjbhf4Y5v51JNhOzgag84YEk0nAdw=;
        b=R8Zy+XaqDV86fweesnpSIoVuy3ErI/EdbhtD1YYxFbkAMaJre9vI7kEsELHtDrYLhiX3VW
        Wbz6ZsGokr+r0F+uTGz7BQnxj1OPHbyrBj6uBsX5b13KmAZJQC3b3kjillIJ4UGEdOYUZb
        lON9O+nglGgaTN4qEzxdiQ/RL4qgqrg=
Received: from mail-pl1-f198.google.com (mail-pl1-f198.google.com
 [209.85.214.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-496-9JxAivE1OWKfRGij7FhGig-1; Tue, 21 Feb 2023 17:52:16 -0500
X-MC-Unique: 9JxAivE1OWKfRGij7FhGig-1
Received: by mail-pl1-f198.google.com with SMTP id e4-20020a170902cf4400b00199148d00f2so2846056plg.17
        for <mm-commits@vger.kernel.org>; Tue, 21 Feb 2023 14:52:16 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1677019934;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=bE6IKh0Qcu+iI0fjbhf4Y5v51JNhOzgag84YEk0nAdw=;
        b=dqY1fJV8wXrEVn8V/Aol8clCKhDjdZFs7Z5yAUUsIhih4B2rXmifjs5xf8dUFLa1HZ
         Xc66jViNYxyue7yWSjhrZ+4ITF0+Sg22sM/J07XffTkyUoXs+Vafy42LfrHcK9Hpku6Z
         Be2mWPHw4JvA85/agHIy9V4vhBvRatrBQMmwYBjciQcnO6SQ0Q89NXs1eFgIslzkb1b7
         XxRRcb5mruiZ8f8FU3OYkwr1LkoftCLeOtnCL0tGEYJ75KzIHBxIBgbqPhFMkar6Q+tZ
         Pw6RyIGZ+NWbTto9v1zLTn+/RURh0FqqWGmHrrOyOgYDIKeP/LFmwMProkEeWudlyuye
         QKSw==
X-Gm-Message-State: AO0yUKXOgtOLMyth2K72fFFzLZnBSE94G5UZSD7SxqVYymKbJQSrTf4K
        YhiAREVunMP+e3bhqATlPYbbpwU5ZH7ExQ2+ahyUVzYQYtJ0ZKJBX5rnE79sBf8oLC8fspHuOAD
        PDWHtlWHC7irNmn35fU4sErBoVYRVh/r4TOXF3oyc2O1UVg==
X-Received: by 2002:a17:90b:3843:b0:22c:816f:3203 with SMTP id nl3-20020a17090b384300b0022c816f3203mr1199750pjb.28.1677019933927;
        Tue, 21 Feb 2023 14:52:13 -0800 (PST)
X-Google-Smtp-Source: AK7set/zVkZFQYsyNIhwUFG8kn1JEB0IWEKZTZuY7Y+R+T7Ze+eqhuC7hJp1YsKkw4QD8mKfRs4F0df9S6mv29eaLQk=
X-Received: by 2002:a17:90b:3843:b0:22c:816f:3203 with SMTP id
 nl3-20020a17090b384300b0022c816f3203mr1199746pjb.28.1677019933621; Tue, 21
 Feb 2023 14:52:13 -0800 (PST)
MIME-Version: 1.0
References: <20230203063724.26745C4339B@smtp.kernel.org> <20230203105401.3362277-1-agruenba@redhat.com>
In-Reply-To: <20230203105401.3362277-1-agruenba@redhat.com>
From:   Andreas Gruenbacher <agruenba@redhat.com>
Date:   Tue, 21 Feb 2023 23:52:02 +0100
Message-ID: <CAHc6FU4_rzr9U0cs8efjmy6Wn0NP7K1wkcoZtsz8r+Ng06r7Xg@mail.gmail.com>
Subject: Re: [merged mm-stable] gfs2-convert-gfs2_write_cache_jdata-to-use-filemap_get_folios_tag.patch
 removed from -mm tree
To:     Andrew Morton <akpm@linux-foundation.org>
Cc:     mm-commits@vger.kernel.org, Matthew Wilcox <willy@infradead.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

Hi again,

the following conflict on mm-stable still hasn't been fixed.

Thanks,
Andreas

On Fri, Feb 3, 2023 at 11:54 AM Andreas Gruenbacher <agruenba@redhat.com> wrote:
> Hi Andrew,
>
> On Fri, Feb 3, 2023 at 7:37 AM Andrew Morton <akpm@linux-foundation.org> wrote:
> > The quilt patch titled
> >      Subject: gfs2: convert gfs2_write_cache_jdata() to use filemap_get_folios_tag()
> > has been removed from the -mm tree.  Its filename was
> >      gfs2-convert-gfs2_write_cache_jdata-to-use-filemap_get_folios_tag.patch
> >
> > This patch was dropped because it was merged into the mm-stable branch
> > of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
>
> note that there now is a conflict between the following commit in v6.2-rc6:
>
> 95ecbd0f162f ("Revert "gfs2: stop using generic_writepages in gfs2_ail1_start_one"")
>
> and this commit in mm-stable:
>
> d585bdbeb79a ("fs: convert writepage_t callback to pass a folio")
>
> Trivial resolution below.
>
> Thanks,
> Andreas
>
> ---
>  fs/gfs2/log.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
>
> diff --git a/fs/gfs2/log.c b/fs/gfs2/log.c
> index 25fd21a9dec8..807daaeb4153 100644
> --- a/fs/gfs2/log.c
> +++ b/fs/gfs2/log.c
> @@ -80,11 +80,11 @@ void gfs2_remove_from_ail(struct gfs2_bufdata *bd)
>         brelse(bd->bd_bh);
>  }
>
> -static int __gfs2_writepage(struct page *page, struct writeback_control *wbc,
> -                      void *data)
> +static int __gfs2_writepage(struct folio *folio, struct writeback_control *wbc,
> +                           void *data)
>  {
>         struct address_space *mapping = data;
> -       int ret = mapping->a_ops->writepage(page, wbc);
> +       int ret = mapping->a_ops->writepage(&folio->page, wbc);
>         mapping_set_error(mapping, ret);
>         return ret;
>  }
> --
> 2.39.0
>

