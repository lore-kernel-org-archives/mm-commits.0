Received: from mail-yw1-f169.google.com (mail-yw1-f169.google.com [209.85.128.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA7F4273FD
	for <mm-commits@vger.kernel.org>; Tue,  9 Jul 2024 01:14:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720487681; cv=none; b=BsSTQv367upX1x9zNB3QLmI29oUqcJLSy5yKMNhPB8S/QVpc5iyg9KtSPodG/t1Y2fCR3zN2rcPHsQqhAQbjQmlxXZGs0iTogStmbS9BoOV8ZXqdnGDgbPUN5xPnUyDNj2ZBANqAu8x6hyz4rfdX+FjHr4HiJZ/ZKZSXVVtulu0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720487681; c=relaxed/simple;
	bh=QJujyXRw4FxuktpHasOCtyGhcyk22DWMEmXST/He8j0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=NkHp+5nLkOjWkLM9qCDLmkdn7mtwvLVlLLV4l4hrYKzc2+Cdxd1/rfbStElQpXw8uBjyiIQFPHB9xmJm5nIOYagkpBi03x76YC9Lsm2gjAosjgN6xDZIHIwrSRITBXxZRlu19yc02/t22Ef7S9v88bZI58KMHpJ3gxHh8SWjXEU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=JwENRNPV; arc=none smtp.client-ip=209.85.128.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="JwENRNPV"
Received: by mail-yw1-f169.google.com with SMTP id 00721157ae682-64b5617ba47so36710077b3.3
        for <mm-commits@vger.kernel.org>; Mon, 08 Jul 2024 18:14:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1720487679; x=1721092479; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Dq0Sab+jWO3vpQmLP1dPTlei3zFXJnosfNHJB1miZzg=;
        b=JwENRNPVMbk8rSVqZZ4gOyxA56cFNFWgMqMYK+lPi7dn5djVAiJzkPJBAG7k3iiFDK
         AYD8znSF8fkEz5QoGMm322kp/F1+Pi6DvWGk/ybQtHNlF8LBAiN4c5ZChV3ELjAw3PaS
         9cPV4hlomA+nC3KaaJDod1husBPkD73dxLt5tCnpqm3Gn01e3Q020Yw6vPwuviB9/MoX
         AzVP1iGYp4fU4mbojuarKkdWNgAuqeBfFOb/WW/d8tmqn2f6NmeJBqL/X+kI7J1zUrwz
         oJVtpzhAoj3HexlROV6wgUcXNu1X9vQuKbN4ZiEeEpO6r1n50Doy3KD9vcxdEt9xIJ95
         ZmyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1720487679; x=1721092479;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Dq0Sab+jWO3vpQmLP1dPTlei3zFXJnosfNHJB1miZzg=;
        b=VoR7DjpAgipuzcu3G0m9y9RI+jWqEeG4VjdAzl66JUoUOjL5WSy60nGNiR8tf8Y1nM
         Ru9iO6oj34LprhqjrsVzBM+Gp48czd7jfQZN7JOgbtavksSzxmeUY4f7RBUPUyyPiEEQ
         JdmQsCtmcVSgmuNZMtmhAQZoJmLVWMwR6/H6ECRDPHBY9RX6AOixKj/vghs1HdoBG3TE
         5V3/roRFwuRZ4jhavjP385J4pxaDdt6IGjJLvc1x0SpXhYGV8bdWLIDhbj0n76hx4k5K
         75lYFGJ0gTC4jyIatfu6ZS1HKdNTOwTp0pFFUA9kbW4uLvfuAuTjSx3xXFBekHrlxpxU
         1Rpw==
X-Gm-Message-State: AOJu0YzgvJxochBj4PD0EzyzVFfDidgvzYrA8LDNjo1L1CVdn36h7RWJ
	0hdRdPSd7424qznecVbGfgifV3daCQM5EX8dN1Sivt/wvKH86oWfUVMjzlyUTNzUmjh/PnaPU+W
	Re1Ku5DUvR61EuglPmVs8Ijjmd9pQ5aktPGJq
X-Google-Smtp-Source: AGHT+IG32yZI4smBpVvnyWTb1K19fM8BH60GFcY7D5TFonbkWwtzgZrlVUBRAGouGzWqsalIEYoVX8iKY8YwFNShyxE=
X-Received: by 2002:a05:690c:e05:b0:651:6888:9fee with SMTP id
 00721157ae682-658eed5faccmr16477867b3.18.1720487678259; Mon, 08 Jul 2024
 18:14:38 -0700 (PDT)
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240708214255.9F454C116B1@smtp.kernel.org>
In-Reply-To: <20240708214255.9F454C116B1@smtp.kernel.org>
From: Suren Baghdasaryan <surenb@google.com>
Date: Mon, 8 Jul 2024 18:14:27 -0700
Message-ID: <CAJuCfpESwaHgqy2LH8BthPXqqCjN3H3u5mX-C5Q6zFrKHG0qHw@mail.gmail.com>
Subject: Re: + mm-memcg-alignment-memcg_data-define-condition.patch added to
 mm-unstable branch
To: Andrew Morton <akpm@linux-foundation.org>
Cc: mm-commits@vger.kernel.org, vbabka@suse.cz, pasha.tatashin@soleen.com, 
	keescook@chromium.org, hannes@cmpxchg.org, alexs@kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Jul 8, 2024 at 2:42=E2=80=AFPM Andrew Morton <akpm@linux-foundation=
.org> wrote:
>
>
> The patch titled
>      Subject: mm/memcg: alignment memcg_data define condition
> has been added to the -mm mm-unstable branch.  Its filename is
>      mm-memcg-alignment-memcg_data-define-condition.patch

FYI, just posted my objection to this change at
https://lore.kernel.org/all/CAJuCfpEjB8wvodBDB__yR8pF5F3uGMPxue-tap68RYCO0O=
-K1Q@mail.gmail.com/
It will break CONFIG_MEM_ALLOC_PROFILING=3Dy && CONFIG_MEMCG=3Dn case.

>
> This patch will shortly appear at
>      https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree=
/patches/mm-memcg-alignment-memcg_data-define-condition.patch
>
> This patch will later appear in the mm-unstable branch at
>     git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
>
> Before you just go and hit "reply", please:
>    a) Consider who else should be cc'ed
>    b) Prefer to cc a suitable mailing list as well
>    c) Ideally: find the original patch on the mailing list and do a
>       reply-to-all to that, adding suitable additional cc's
>
> *** Remember to use Documentation/process/submit-checklist.rst when testi=
ng your code ***
>
> The -mm tree is included into linux-next via the mm-everything
> branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
> and is updated there every 2-3 working days
>
> ------------------------------------------------------
> From: "Alex Shi (Tencent)" <alexs@kernel.org>
> Subject: mm/memcg: alignment memcg_data define condition
> Date: Mon, 8 Jul 2024 14:32:36 +0800
>
> commit 21c690a349ba ("mm: introduce slabobj_ext to support slab object
> extensions") changed the folio/page->memcg_data define condition from
> MEMCG to SLAB_OBJ_EXT.  The code works well, since config SLAB_OBJ_EXT is
> fold into MEMCG in init/Kconfig.
>
> But many related functions that deal with memcg_data still defined under
> MEMCG instead of SLAB_OBJ_EXT, and FOLIO_MATCH with memcg_data are define=
d
> under MEMCG too.  That looks weird and incorrect with memcg_data raw
> meaning.
>
> So let's put memcg_data under MEMCG config to alignment the definition
> with FOLIO_MATCH and its usage in functions.
>
> Link: https://lkml.kernel.org/r/20240708063236.1096395-1-alexs@kernel.org
> Signed-off-by: Alex Shi (Tencent) <alexs@kernel.org>
> Cc: Johannes Weiner <hannes@cmpxchg.org>
> Cc: Kees Cook <keescook@chromium.org>
> Cc: Pasha Tatashin <pasha.tatashin@soleen.com>
> Cc: Suren Baghdasaryan <surenb@google.com>
> Cc: Vlastimil Babka <vbabka@suse.cz>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> ---
>
>  include/linux/mm_types.h |    4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>
> --- a/include/linux/mm_types.h~mm-memcg-alignment-memcg_data-define-condi=
tion
> +++ a/include/linux/mm_types.h
> @@ -180,7 +180,7 @@ struct page {
>         /* Usage count. *DO NOT USE DIRECTLY*. See page_ref.h */
>         atomic_t _refcount;
>
> -#ifdef CONFIG_SLAB_OBJ_EXT
> +#ifdef CONFIG_MEMCG
>         unsigned long memcg_data;
>  #endif
>
> @@ -343,7 +343,7 @@ struct folio {
>                         };
>                         atomic_t _mapcount;
>                         atomic_t _refcount;
> -#ifdef CONFIG_SLAB_OBJ_EXT
> +#ifdef CONFIG_MEMCG
>                         unsigned long memcg_data;
>  #endif
>  #if defined(WANT_PAGE_VIRTUAL)
> _
>
> Patches currently in -mm which might be from alexs@kernel.org are
>
> mm-memcg-alignment-memcg_data-define-condition.patch
>
