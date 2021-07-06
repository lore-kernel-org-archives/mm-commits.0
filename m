Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 85A45C07E99
	for <mm-commits@archiver.kernel.org>; Tue,  6 Jul 2021 01:24:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4F1E96197E
	for <mm-commits@archiver.kernel.org>; Tue,  6 Jul 2021 01:24:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229740AbhGFB0t (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 5 Jul 2021 21:26:49 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:45318 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229733AbhGFB0t (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 5 Jul 2021 21:26:49 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1625534650;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=YvZBRUsopGooyKZXDbaAcSKCsLR31fbe6LlHCtiGnAg=;
        b=OUNKiitvXKBZ+O2BMH+AF5us83l2GfHRltNWvh6KLCAbC6rXiXZ2hNrnk+Om1NnUXcEiJR
        Uv3t1K4MctIw23J3RtjTCJcqKxTSwD1Js9gP5MN0IVDKKNr4oCV9tRncUbiReIN4X6HySd
        KIFD3pzR/IjsmHimyhup2LUDDjjQlNk=
Received: from mail-qv1-f72.google.com (mail-qv1-f72.google.com
 [209.85.219.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-52-FSv2zInNNxCmduLaeA5buQ-1; Mon, 05 Jul 2021 21:24:09 -0400
X-MC-Unique: FSv2zInNNxCmduLaeA5buQ-1
Received: by mail-qv1-f72.google.com with SMTP id b3-20020ad451830000b02902a94b1b914dso2872433qvp.6
        for <mm-commits@vger.kernel.org>; Mon, 05 Jul 2021 18:24:09 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=YvZBRUsopGooyKZXDbaAcSKCsLR31fbe6LlHCtiGnAg=;
        b=SHkTmk9eW7DAbMW3OTUs/KmbbV1Pb51x8i/CNRfO705CwmZ9Cjs6kIWEHTX0mGEfwN
         FsFRaCSCV33MqQFimxkKx+Ixvk40uZM9Fc0tJ24Qf2YHW9oTu7UkjGFMI3nXcoJ8ttD6
         MqMVFgxDHZO/NRVT7qZjLtekjFoCC+HZxTEsM/qlaxOqEfJmdFKkIlozqg1F2sGlWU61
         Xw46RNrMsab7v/8FDoNsUNTGQeeYnVGZezS0VfASpVn8fcAA1YYKP842epywr61lF8v+
         RBXvPQCXVvEpYQQP4jkofHOl/1yU4YscguhSYYrXXbO/5zSQJBa179fJQsL2TJ3x2IVH
         FI3Q==
X-Gm-Message-State: AOAM533gyLGz24BBnfQNvmr71N8vo9dvW5YTtG7qkQTV4wEuVoQzxHPW
        dzHl9wAsAERPVqwb7spMY/gvOoT1k5h5UPReAUD72BIHRY/tAaubFK03HF2XqZt3tWqk3gyBAkk
        gYfySd8cF8spEuGIqASFdnw==
X-Received: by 2002:a05:620a:10aa:: with SMTP id h10mr16699659qkk.377.1625534649347;
        Mon, 05 Jul 2021 18:24:09 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJx/eQpyZLHFvCEa2LsJAhfmrABQfRdFHK4D+g9Ktz7ssugyDWpaVhtqdGRSq+x59+YIDPgT+g==
X-Received: by 2002:a05:620a:10aa:: with SMTP id h10mr16699630qkk.377.1625534649021;
        Mon, 05 Jul 2021 18:24:09 -0700 (PDT)
Received: from t490s (bras-base-toroon474qw-grc-65-184-144-111-238.dsl.bell.ca. [184.144.111.238])
        by smtp.gmail.com with ESMTPSA id g1sm6028001qkm.58.2021.07.05.18.24.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 Jul 2021 18:24:08 -0700 (PDT)
Date:   Mon, 5 Jul 2021 21:24:07 -0400
From:   Peter Xu <peterx@redhat.com>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Evgeniy Stepanov <eugenis@google.com>,
        Kostya Kortchinsky <kostyak@google.com>,
        Linux-MM <linux-mm@kvack.org>, mm-commits@vger.kernel.org,
        Peter Collingbourne <pcc@google.com>
Subject: Re: [patch 128/192] mm: improve mprotect(R|W) efficiency on pages
 referenced once
Message-ID: <YOOwt8VPlB/FtczT@t490s>
References: <20210628193256.008961950a714730751c1423@linux-foundation.org>
 <20210629023959.4ZAFiI8oZ%akpm@linux-foundation.org>
 <CAHk-=wj4KCujAH_oPh40Bkp48amM4MXr+8AcbZ=qd5LF4Q+TDg@mail.gmail.com>
 <YNu23Fu2HJhUEN5g@t490s>
 <YNvLUbrzkM+IOJlf@t490s>
 <CAHk-=wgt_666dOxYycGegSeUtLebUv0hVrcgXwXE9b-2_V=HXw@mail.gmail.com>
 <YNye5LNFaNFEPfhA@t490s>
 <CAHk-=wjzwwJgSOWhnGC52cmkKAiKFVPKYg3zNnsQbdTRPsMN2w@mail.gmail.com>
 <YN0Z8FwG25V29V96@t490s>
 <CAHk-=wh1ga4=Q38Uz-SCQGVWv6ZTu0QjkXqR2ysLS0hbbkNvrg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CAHk-=wh1ga4=Q38Uz-SCQGVWv6ZTu0QjkXqR2ysLS0hbbkNvrg@mail.gmail.com>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

(sorry for a very late reply)

On Thu, Jul 01, 2021 at 11:29:50AM -0700, Linus Torvalds wrote:
> On Wed, Jun 30, 2021 at 6:27 PM Peter Xu <peterx@redhat.com> wrote:
> >
> > On Wed, Jun 30, 2021 at 11:03:25AM -0700, Linus Torvalds wrote:
> > >
> > > What about that page_count() test, for example: it has a comment, it
> > > looks obvious, but it's very different from what do_wp_page() does. So
> > > what happens if we have a page-out at the same time that turns that
> > > page into a swap cache page, and increments the page count? What about
> > > that race? Do we end up with a writable page that is shared with a
> > > swap cache entry? Is that ok? Why isn't it ok in the page fault case?
> >
> > That looks fine to me: when the race happens we must have checked page_count==1
> > first and granted the write bit, then add_to_swap_cache() happens after the
> > page_count==1 check (as it takes another refcount, so >2 otherwise).  Then it
> > also means unmap mappings should happen even after that point.  If my above
> > understanding is correct, our newly installed pte will be zapped safely soon,
> > but of course after we release the pgtable lock in change_pte_range().
> 
> So if this is fine, then maybe we should just remove the page lock in
> the do_wp_page() path (and remove the PageKSM check while at it)?

I could be wrong, but I thought the page lock in do_wp_page() is more for the
PageKsm() race (e.g., to make sure we don't grant write to a page that is
becoming a ksm page in parallel).

> 
> If it's not required by mprotect() to say "I can make the page
> writable directly", then it really shouldn't be required by the page
> fault path either.
> 
> Which I'd love to do, and was really itching to do (it's a nasty
> lock), but I worried about it..
> 
> I'd hate to have mprotect do one thing, and page faulting do another
> thing, and not have some logic to why they have to be different.

Agreed; perhaps no need to be identical - I think the mprotect path can be even
stricter than the fault page, as it's a fast-path only. It should never apply
the write bit when the page fault path won't.  So I think the original patch
does need a justification on why it didn't handle ksm page while do_wp_page
handled it.

Thanks,

-- 
Peter Xu

