Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2FB75C4361B
	for <mm-commits@archiver.kernel.org>; Wed, 16 Dec 2020 18:09:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EDE1C25998
	for <mm-commits@archiver.kernel.org>; Wed, 16 Dec 2020 18:09:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729402AbgLPSJd (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 16 Dec 2020 13:09:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46072 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729395AbgLPSJd (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 16 Dec 2020 13:09:33 -0500
Received: from mail-qv1-xf2d.google.com (mail-qv1-xf2d.google.com [IPv6:2607:f8b0:4864:20::f2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 00285C061794
        for <mm-commits@vger.kernel.org>; Wed, 16 Dec 2020 10:08:52 -0800 (PST)
Received: by mail-qv1-xf2d.google.com with SMTP id l14so11850414qvh.2
        for <mm-commits@vger.kernel.org>; Wed, 16 Dec 2020 10:08:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=9RuRINEpy6taTrli4Abb9av9pTwORzMZWlBEpd7n9iI=;
        b=fWxXBYwjnor2vNhTVKiXmqivKAo17rMoF2gMLgk8lmsTgtGz3fZyF3HFDsBgVPQg+h
         Ue2MmlCuF9rVpXFix1ti15uJuqaer6hUxf3JxsHqWh5S8t6pnFOKRNWVxnu7/BPb0MY0
         Gmoy1YwKQHMYegUsvOYdtQX2OLXCiNsOn+B5UixMgaiHXyaSiyAh7+ZEoSpzHUNEJCn4
         HiPclSq5a9OI8D+aunn5kCf563bvjENEwWIFX9yUYLnhCKqaliUf6gF0JO55Y2SGKEft
         TrcCV/TCpps256CrxnJl41MOX+YflAfQxct4LLKtN5tiMlxoD4IxY+cIgcOrDVFT1D/m
         L4Iw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=9RuRINEpy6taTrli4Abb9av9pTwORzMZWlBEpd7n9iI=;
        b=PkI0uVyooau2MRLS4l+LKGH4lNpRw8sERsjVs6poLZxSd+bXD0ynjAhB1piXhT/Cxv
         oE5IOdhQwDK3rOTG3LtejFcA6W+2vo1hwSFLSyhjmB00cSdTDtQjJvEBdFy7q+r+ZIXU
         ViUa+i88V66UFKV3Yv7lmnNO8iybcOklHdwrNZ2VJYWvKV1ytfMbidvSKlt2NPPVka9D
         hkTR+SI3S2BoIchVnC6QcoWsUfNcD2KtptU9Ayq4aAPfWA3GQHRNf3kRHc7vAtX7PL5H
         uSf/ezBCLh5kgHN9IudyiOpSk1DJEI2pCnLxH6PrDkFONy/fR4nUR3o4RPsGrGAqfLZv
         mDzw==
X-Gm-Message-State: AOAM530F6UiQzki1YCjnu+DzBvzG5pISPe78UVX825XGd1jgqKNgOq0i
        a9TEOp9Kv6MUiuD5Yn5AESQCjA==
X-Google-Smtp-Source: ABdhPJy40VwKx1K25jBs/v9w7SsyuBlT+iI9Fu8KXWDK4dDn11JlfEQuMrfqbyNfXnbnVg9jLvtfIQ==
X-Received: by 2002:a0c:eed3:: with SMTP id h19mr44640441qvs.18.1608142132233;
        Wed, 16 Dec 2020 10:08:52 -0800 (PST)
Received: from ziepe.ca (hlfxns017vw-142-162-115-133.dhcp-dynamic.fibreop.ns.bellaliant.net. [142.162.115.133])
        by smtp.gmail.com with ESMTPSA id x13sm1377952qtf.89.2020.12.16.10.08.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Dec 2020 10:08:51 -0800 (PST)
Received: from jgg by mlx with local (Exim 4.94)
        (envelope-from <jgg@ziepe.ca>)
        id 1kpbEI-00BhOP-Jv; Wed, 16 Dec 2020 14:08:50 -0400
Date:   Wed, 16 Dec 2020 14:08:50 -0400
From:   Jason Gunthorpe <jgg@ziepe.ca>
To:     Jann Horn <jannh@google.com>
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        John Hubbard <jhubbard@nvidia.com>,
        Linux-MM <linux-mm@kvack.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        mm-commits@vger.kernel.org,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Michel Lespinasse <walken@google.com>
Subject: Re: [patch 94/95] mmap locking API: don't check locking if the mm
 isn't live yet
Message-ID: <20201216180850.GH5487@ziepe.ca>
References: <20201215204156.f05ec694b907845bcfab5c44@linux-foundation.org>
 <20201216044730.ADFV7TjN3%akpm@linux-foundation.org>
 <CAG48ez2bZvS9dHr+3U65KY+Mpcy_Az_x10x9GHdfqWM=rrF-Yw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAG48ez2bZvS9dHr+3U65KY+Mpcy_Az_x10x9GHdfqWM=rrF-Yw@mail.gmail.com>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

On Wed, Dec 16, 2020 at 06:07:48AM +0100, Jann Horn wrote:
> On Wed, Dec 16, 2020 at 5:47 AM Andrew Morton <akpm@linux-foundation.org> wrote:
> > In preparation for adding a mmap_assert_locked() check in
> > __get_user_pages(), teach the mmap_assert_*locked() helpers that it's fine
> > to operate on an mm without locking in the middle of execve() as long as
> > it hasn't been installed on a process yet.
> >
> > Existing code paths that do this are (reverse callgraph):
> >
> >   get_user_pages_remote
> >     get_arg_page
> >       copy_strings
> >       copy_string_kernel
> >       remove_arg_zero
> >     tomoyo_dump_page
> >       tomoyo_print_bprm
> >       tomoyo_scan_bprm
> >       tomoyo_environ
> 
> Sorry, can you please kill both this patch and the following one
> ("mm/gup: assert that the mmap lock is held in __get_user_pages()")
> from the mm tree?
> 
> I'll send new stuff (a new iteration of
> https://lore.kernel.org/linux-mm/20201016225713.1971256-1-jannh@google.com/
> "[PATCH resend v3 0/2] Broad write-locking of nascent mm in execve",
> followed by a resend of "mm/gup: assert that the mmap lock is held in
> __get_user_pages()") when it's ready.

I'm glad you are still working on it, I think finally being able to
add lockdep to get_user_pages will be a help. I've fixed a number of
wrongly locked get_user_pages users :(

Thanks,
Jason
