Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8B4FBEB64DD
	for <mm-commits@archiver.kernel.org>; Sat, 12 Aug 2023 02:09:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229778AbjHLCJW (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 11 Aug 2023 22:09:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48606 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229670AbjHLCJV (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 11 Aug 2023 22:09:21 -0400
Received: from mail-ej1-x630.google.com (mail-ej1-x630.google.com [IPv6:2a00:1450:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8FB0A10DF
        for <mm-commits@vger.kernel.org>; Fri, 11 Aug 2023 19:09:19 -0700 (PDT)
Received: by mail-ej1-x630.google.com with SMTP id a640c23a62f3a-99bed101b70so348458066b.3
        for <mm-commits@vger.kernel.org>; Fri, 11 Aug 2023 19:09:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1691806158; x=1692410958;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=R81YUazK4xe/ie990fPz5dvIC+cV2mzkWlRQmUW6lmg=;
        b=An0B24sV0Q+ebPyzZSH/t/yeU3PA3koG9a9Xo8gotBfm9B0n8gcxUsxMI+RrM+H0XI
         k1NoyrXfGbPqtxgWwHOtWv2G0THCh9BiXDFs1V7E4xK2i00mqSpBpv9KJE3XbEQGHWgQ
         AE10u+lCyCIaXLtP2ryXJH3MAtlRDUM/FA7ysK4RAv1BR7Htr0TG7xYfZ1vS8OcrU9r9
         1MiFPZhIrsTt6uOo4eUwuUruHFfbKw7Avlh465USkB0aHk9ZY6H3xvwrNWCMnsr+KVGX
         qbhAT98o7AaL+Rh95piOWwyXwXUZlPv0yu+XoIk+hrGSEn9QVsdNi3mCmFYZFTaDSZRQ
         6gYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691806158; x=1692410958;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=R81YUazK4xe/ie990fPz5dvIC+cV2mzkWlRQmUW6lmg=;
        b=PfJnxc3RCRHL1YiuCRt4dfe4zXe1iNNUAVXEdfvWE/YQz2DMKqiEh3l91D68btnuP6
         FxxfIWRVPsbJyzWz10eIEIz8kHXFllhQVkajxg7Nj0W7brZ5e2RntIix1et/f4xgatcc
         TyijhJo0osD4w+f7wxu6I51q9/Jm/hYPQ+CYGAdJLU5NQDG6KXiDGllMoEZJVcbkWJBH
         J/nsyiYwrT9XQRdfHZ39KMVCtsFZBznenl6M6c4P8zIJbKi51eqPUJHiIS8R5KEQ96tq
         pmlWtBJHe4tzYeJdjYp7lW+QqvnZ9qLeOO0Uy032jvFX0vEAEDaaCFuAp0Ql7NqItgY2
         zudw==
X-Gm-Message-State: AOJu0Yx9zm1ycrlnyWKsNFxzcGDMl0XPQKSeiCVR9XdQFlyEesiWVUNW
        flTI4Xlq1KrRHP/J4U82dSJ5AkpxTOyNk9WWQYJsemAVqG4CSGhl595NQw==
X-Google-Smtp-Source: AGHT+IEGb3xdvIt37tY3hr68XZrOJd29MNkbrwtIZhyYZhJVzUbZP81pn0XmeEVDnJwzM8Bs+ukNfink27/t9lLWQYs=
X-Received: by 2002:a17:906:8a4d:b0:993:e691:6dd5 with SMTP id
 gx13-20020a1709068a4d00b00993e6916dd5mr3231270ejc.7.1691806157814; Fri, 11
 Aug 2023 19:09:17 -0700 (PDT)
MIME-Version: 1.0
References: <20230810163538.7C2AAC433C7@smtp.kernel.org> <ZNW0+8QiWesvJwh+@casper.infradead.org>
 <f860826b-3380-4afb-b5ab-7acc5ed3932f@intel.com> <20230811101803.a9efab4dfbe02b435ca1886a@linux-foundation.org>
 <9418a77b-2fcb-4d5c-b9b0-bbf7c2a47369@intel.com>
In-Reply-To: <9418a77b-2fcb-4d5c-b9b0-bbf7c2a47369@intel.com>
From:   Yosry Ahmed <yosryahmed@google.com>
Date:   Fri, 11 Aug 2023 19:08:41 -0700
Message-ID: <CAJD7tkbztKJDxtRGLo_FfMfHQkAdkQpt7JutqpP0w6S1Q+SQbw@mail.gmail.com>
Subject: Re: + zswap-make-zswap_load-take-a-folio-fix.patch added to
 mm-unstable branch
To:     "Yin, Fengwei" <fengwei.yin@intel.com>
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        Matthew Wilcox <willy@infradead.org>,
        mm-commits@vger.kernel.org, hannes@cmpxchg.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

On Fri, Aug 11, 2023 at 6:46=E2=80=AFPM Yin, Fengwei <fengwei.yin@intel.com=
> wrote:
>
>
>
> On 8/12/2023 1:18 AM, Andrew Morton wrote:
> > On Fri, 11 Aug 2023 13:20:44 +0800 "Yin, Fengwei" <fengwei.yin@intel.co=
m> wrote:
> >
> >>
> >>
> >> On 8/11/2023 12:11 PM, Matthew Wilcox wrote:
> >>> On Thu, Aug 10, 2023 at 09:35:37AM -0700, Andrew Morton wrote:
> >>>>
> >>>> The patch titled
> >>>>      Subject: zswap: don't warn if none swapcache folio is passed to=
 zswap_load
> >>>> has been added to the -mm mm-unstable branch.  Its filename is
> >>>>      zswap-make-zswap_load-take-a-folio-fix.patch
> >>>
> >>> Disagree that this is a fix patch.  My original patch does:
> >> Agree with Matthew. The warning was not introduced by Matthew's patch.
> >>
> >>>
> >>> -       VM_WARN_ON_ONCE(!PageLocked(page));
> >>> -       VM_WARN_ON_ONCE(!PageSwapCache(page));
> >>> +       VM_WARN_ON_ONCE(!folio_test_locked(folio));
> >>> +       VM_WARN_ON_ONCE(!folio_test_swapcache(folio));
> >>>
> >>> so I didn't add a new assertion, merely removed a call to
> >>> compound_head().  I think this patch deserves to stand on its own and
> >>> not be folded into mine.
> >>>
> >
> > OK, so it seems these assertions were added by hannes's "mm: kill
> > frontswap"
> > (https://lkml.kernel.org/r/20230717160227.GA867137@cmpxchg.org).  I'm
> > not really sure why - they don't appear to have been moved from
> > elsewhere.
> >
> > So I'll requeue this as a fix against mm-kill-frontswap.patch.
> >
> > The same two assertions were added to zswap_store().  Are they correct?
> My understanding is they are correct as folio needs be added to swap
> successfully before hit zswap_store(). Add Yosry for confirmation. Thanks=
.

The PageLocked() (or folio_test_locked()) assertions were moved from
__frontswap_store() and __frontswap_load(), so those are not new.

The PageSwapCache() checks are new. The one in zswap_load() turned out
not to be correct in the case of zram + zswap. As far as I can tell
the one in zswap_store() is correct because we always add the
page/folio to the swap cache on the swapout path (unlike the swapin
path).

>
>
> Regards
> Yin, Fengwei
>
> >
