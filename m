Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B64A3EB64DC
	for <mm-commits@archiver.kernel.org>; Wed, 28 Jun 2023 18:20:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229647AbjF1SUT (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 28 Jun 2023 14:20:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48832 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231373AbjF1SUS (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 28 Jun 2023 14:20:18 -0400
Received: from mail-ej1-x630.google.com (mail-ej1-x630.google.com [IPv6:2a00:1450:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0BC631BCB
        for <mm-commits@vger.kernel.org>; Wed, 28 Jun 2023 11:20:17 -0700 (PDT)
Received: by mail-ej1-x630.google.com with SMTP id a640c23a62f3a-98e1c6a687fso11943366b.1
        for <mm-commits@vger.kernel.org>; Wed, 28 Jun 2023 11:20:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1687976415; x=1690568415;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=M7aFeBqA+iPIGCr/uPGvnmE94Z3FPGe+Ni0JLr6Li2k=;
        b=SYYkYomDQiTGTtBuwvaxYcVhZX52v2zwLtDVDcOQBMjgYf6btLfUNXbvSvX/+R2o6B
         AjjgONNxzozJ1TXcmYniDN9dBFItlBS/YkEXyapFPRFp7BLLmlMSvAFcPt4eAJycVJOT
         iwE753QBiga65LhckzZg6EttP3QQvH8bCF3qk=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687976415; x=1690568415;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=M7aFeBqA+iPIGCr/uPGvnmE94Z3FPGe+Ni0JLr6Li2k=;
        b=TFbfvhwJPEIn5Xly533FVlAth1l7PvU/kQzWXoAstNcNuqP64652sufHgaguTkTpdQ
         +JlzIf/OfSTRBwLRNhboh+vTVWLL+VoM3bW/KyDddpd51kjBJ5QOgtShbLxoZk84pJD4
         2HWsInYazULXAJVpmH6TAf/hGaodHid4KnP7VkOw2EyT6I29MDXnk012EyJ9wT8exjbm
         Fdn8OGUyjy5c3IpnrAOPKjTxl+jog7jIqiwyxv0VTSYyw1b65pID+V7N4JLoasR0CJjz
         XsshfjN5jvetr3hX16foELxExjRSi1UN0ZHO04z+ZHBx4TSRSDGaxuzaBm57QoQYlgh4
         ZIVQ==
X-Gm-Message-State: AC+VfDxQcjYyVbsKjzcu+88SfEN0v/uoq4/8iItcJ7Ua8ehBQ9ae3z/y
        BFNg1Pu9jiqOfXIwtLWvq/KMomLoem1hPadC1AvBfPwe
X-Google-Smtp-Source: ACHHUZ7H99KKToOsC11UWz49wvCI/kbIj418BSp9uFHhkr6xD3drEi8jGZizaUYvSBGpQw4QTZF5jw==
X-Received: by 2002:a17:907:778b:b0:992:4d30:dc4a with SMTP id ky11-20020a170907778b00b009924d30dc4amr3042396ejc.74.1687976415343;
        Wed, 28 Jun 2023 11:20:15 -0700 (PDT)
Received: from mail-ed1-f41.google.com (mail-ed1-f41.google.com. [209.85.208.41])
        by smtp.gmail.com with ESMTPSA id b19-20020a17090691d300b00991e4587530sm3236425ejx.71.2023.06.28.11.20.14
        for <mm-commits@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 28 Jun 2023 11:20:14 -0700 (PDT)
Received: by mail-ed1-f41.google.com with SMTP id 4fb4d7f45d1cf-51d9695ec29so4265149a12.1
        for <mm-commits@vger.kernel.org>; Wed, 28 Jun 2023 11:20:14 -0700 (PDT)
X-Received: by 2002:a05:6402:31f3:b0:51d:a263:ef0a with SMTP id
 dy19-20020a05640231f300b0051da263ef0amr6175439edb.24.1687976413997; Wed, 28
 Jun 2023 11:20:13 -0700 (PDT)
MIME-Version: 1.0
References: <20230626085035.e66992e96b4c6d37dad54bd9@linux-foundation.org> <CAHk-=wjyJyV=Kyb8XJcLjFEPP-RMF0J6CQfT2OXLmJdM2yEv8w@mail.gmail.com>
In-Reply-To: <CAHk-=wjyJyV=Kyb8XJcLjFEPP-RMF0J6CQfT2OXLmJdM2yEv8w@mail.gmail.com>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Wed, 28 Jun 2023 11:19:56 -0700
X-Gmail-Original-Message-ID: <CAHk-=wie=MvQzmjhKGCCbRapK3Zz-b8GFUchEDJi7SkeLAX6Pw@mail.gmail.com>
Message-ID: <CAHk-=wie=MvQzmjhKGCCbRapK3Zz-b8GFUchEDJi7SkeLAX6Pw@mail.gmail.com>
Subject: Re: [GIT PULL] MM updates for 6.5-rc1
To:     Andrew Morton <akpm@linux-foundation.org>,
        David Howells <dhowells@redhat.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>
Cc:     linux-mm@kvack.org, mm-commits@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

On Wed, 28 Jun 2023 at 10:27, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> So I think it needs to match the comment (and the try_grab_page()
> logic), and just basically
>
>         if (flags & FOLL_GET)
>                 return try_get_folio(page, refs);
>
>         if (is_zero_page(page))
>                 return page_folio(page);
>
>         folio = try_get_folio(page, refs);
>         if (!folio)
>                 return NULL;
>
> instead.

Side note: I think we should just do the "FOLL_GET" doesn't touch the
refcount either, which would make this all become just

          if (is_zero_page(page))
                  return page_folio(page);

          folio = try_get_folio(page, refs);
          if (!folio)
                  return NULL;

but then we would need to fix try_grab_page() and gup_put_folio() and
friends to match. And any other cases I haven't thought of.

Long long ago we used to have the logic that PG_reserved meant that no
refcounting was done, and that automatically handled the zero page(s).
But that was removed back in 2005... That old commit even talks about
this issue:

    A last caveat: the ZERO_PAGE is now refcounted and managed with rmap (and
    thus mapcounted and count towards shared rss).  These writes to the struct
    page could cause excessive cacheline bouncing on big systems.  There are a
    number of ways this could be addressed if it is an issue.

It's commit b5810039a54e ("[PATCH] core remove PageReserved") in case
anybody wants to do some historical archaeology.

               Linus
