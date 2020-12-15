Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-23.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_IN_DEF_DKIM_WL autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 47555C2BB9A
	for <mm-commits@archiver.kernel.org>; Tue, 15 Dec 2020 16:59:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 03AEB2251E
	for <mm-commits@archiver.kernel.org>; Tue, 15 Dec 2020 16:59:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725963AbgLOQ7g (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 15 Dec 2020 11:59:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35234 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725850AbgLOQqE (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 15 Dec 2020 11:46:04 -0500
Received: from mail-qk1-x743.google.com (mail-qk1-x743.google.com [IPv6:2607:f8b0:4864:20::743])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9FB98C06179C
        for <mm-commits@vger.kernel.org>; Tue, 15 Dec 2020 08:45:23 -0800 (PST)
Received: by mail-qk1-x743.google.com with SMTP id 186so19734314qkj.3
        for <mm-commits@vger.kernel.org>; Tue, 15 Dec 2020 08:45:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=N/q+ByUcpVov4gCppPe+7tP1OnQHYaIilZ9yllaV98k=;
        b=dgzyAjUigVEX1+1Os5QxYLm2CxmBx7+42ov+UxQXvJzcGSWpSq/mEwxW9ux4QDbU/c
         gmifYgxBI4jBdKbEfVPtwwIqsoXFzXuxzBmzAK5eKsMC8Fm2WvH9jCFJI8VFepn98kaU
         se4MaOpSRaaDLNG4mOm+d9bMy8z3YUeQkXD8rLo/tkZerx4gEx4cU64VJAULuHerbFpt
         wZzIf8lFewyre82nm+WbokkW43Pd/ueobwfZwe3X6l3+wogEnDLiNzJhx+QbUIjxrGOA
         2lK+LGSdrgyCxgRCYcNJ2Pm0nTxVwYFUPiU9h7YlvKu3vtcP0cPCI2ewvcsAw1uSYYJi
         OfhQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=N/q+ByUcpVov4gCppPe+7tP1OnQHYaIilZ9yllaV98k=;
        b=uSKqQW/eEJze52JYEFn7w11SgDyb7XwQpf6PJS4stkQRA+ao0aBCGzasnXKAb0I+IH
         HTo3ibsfMfAbP8j/jnONl4Ict9XeWXSz3JByND1Fx2FRUU8HyWOZ9clLnNbqSGonMQCx
         BIhyTih5Vsckavr8T/Ko2zusIHlQEdxjlwh8cI6V7htR6MHiRT4URaaAKC9kTtQru02p
         OKBzpNCy+URUZ8CP2SigKj7rTLrmXfe/ClPaJj9B/AEDuCngEmlMyAfVAphLpTYPe5WY
         RH9YT+DBiLH9NH+inYYMQSX9PYcp3iBf8LRa94OFno7MC75Trp/zAWWZ/1ldxztsYiNo
         pTGA==
X-Gm-Message-State: AOAM532+xteT6A15KVnqszvRYmqZF5Dz4Qa0hGjxtbOnPjtUsUNoQmon
        efXd9fsYthLD8vO7a2+MCfxZ+KCBDbpmIoYQUDYmfA==
X-Google-Smtp-Source: ABdhPJzqESqE2xoMuOLoLSRp00Z4C58v1gPdcHBdTT8gsiqUgWS5T5paTQQxTMmiii0rbNJqiGwYyRpivP5AsCz+bsI=
X-Received: by 2002:a37:7981:: with SMTP id u123mr41564207qkc.392.1608050722470;
 Tue, 15 Dec 2020 08:45:22 -0800 (PST)
MIME-Version: 1.0
References: <20201214190237.a17b70ae14f129e2dca3d204@linux-foundation.org> <20201215030433.7QkafHjX1%akpm@linux-foundation.org>
In-Reply-To: <20201215030433.7QkafHjX1%akpm@linux-foundation.org>
From:   Alexander Potapenko <glider@google.com>
Date:   Tue, 15 Dec 2020 17:45:10 +0100
Message-ID: <CAG_fn=XB04sOCu0Uhhq9Lb0fYwY4M0gpk_gnd43_rdqD0=Ur3w@mail.gmail.com>
Subject: Re: [patch 022/200] mm/slab: rerform init_on_free earlier
To:     Andrew Morton <akpm@linux-foundation.org>
Cc:     Alexander Popov <alex.popov@linux.com>,
        Christoph Lameter <cl@linux.com>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Linux Memory Management List <linux-mm@kvack.org>,
        mm-commits@vger.kernel.org, Pekka Enberg <penberg@kernel.org>,
        David Rientjes <rientjes@google.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

On Tue, Dec 15, 2020 at 4:04 AM Andrew Morton <akpm@linux-foundation.org> w=
rote:
>
> From: Alexander Popov <alex.popov@linux.com>
> Subject: mm/slab: rerform init_on_free earlier

Nit: s/rerform/perform

>
> Currently in CONFIG_SLAB init_on_free happens too late, and heap objects
> go to the heap quarantine not being erased.
>
> Lets move init_on_free clearing before calling kasan_slab_free().  In tha=
t
> case heap quarantine will store erased objects, similarly to CONFIG_SLUB=
=3Dy
> behavior.
>
> Link: https://lkml.kernel.org/r/20201210183729.1261524-1-alex.popov@linux=
.com
> Signed-off-by: Alexander Popov <alex.popov@linux.com>
> Reviewed-by: Alexander Potapenko <glider@google.com>
> Acked-by: David Rientjes <rientjes@google.com>
> Acked-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>
> Cc: Christoph Lameter <cl@linux.com>
> Cc: Pekka Enberg <penberg@kernel.org>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> ---
>
>  mm/slab.c |    5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
>
> --- a/mm/slab.c~mm-slab-perform-init_on_free-earlier
> +++ a/mm/slab.c
> @@ -3417,6 +3417,9 @@ free_done:
>  static __always_inline void __cache_free(struct kmem_cache *cachep, void=
 *objp,
>                                          unsigned long caller)
>  {
> +       if (unlikely(slab_want_init_on_free(cachep)))
> +               memset(objp, 0, cachep->object_size);
> +
>         /* Put the object into the quarantine, don't touch it for now. */
>         if (kasan_slab_free(cachep, objp, _RET_IP_))
>                 return;
> @@ -3435,8 +3438,6 @@ void ___cache_free(struct kmem_cache *ca
>         struct array_cache *ac =3D cpu_cache_get(cachep);
>
>         check_irq_off();
> -       if (unlikely(slab_want_init_on_free(cachep)))
> -               memset(objp, 0, cachep->object_size);
>         kmemleak_free_recursive(objp, cachep->flags);
>         objp =3D cache_free_debugcheck(cachep, objp, caller);
>         memcg_slab_free_hook(cachep, &objp, 1);
> _



--=20
Alexander Potapenko
Software Engineer

Google Germany GmbH
Erika-Mann-Stra=C3=9Fe, 33
80636 M=C3=BCnchen

Gesch=C3=A4ftsf=C3=BChrer: Paul Manicle, Halimah DeLaine Prado
Registergericht und -nummer: Hamburg, HRB 86891
Sitz der Gesellschaft: Hamburg
