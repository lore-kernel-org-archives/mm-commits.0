Received: from mail-vs1-f54.google.com (mail-vs1-f54.google.com [209.85.217.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40B2E46BF
	for <mm-commits@vger.kernel.org>; Sat, 29 Jun 2024 07:52:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.217.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719647540; cv=none; b=YiaWsKAkKrZYE6rc1rzSodIaqTVRDXiFb4/kZpH+6pMBvFO9dUWwdeIeBZuWNGlXI35ntpMHeUgKdFcGOMmGXu1EbTXc2Tj7FM4zJHIuBN0n3r6lbPuuXC8fJqH0F+xywR7UqlHkc5S0vRNKuTZLuuAcERvm0DpHGn5thCj1CD0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719647540; c=relaxed/simple;
	bh=5EtjJdMu+u+VAFl/ut5dvT0B4Ca4BIfkVFF+KRTCRDg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=lVKfPZ06Ab/d+lurSSC5203RrMwmO3Jrnw4Uq4URUUF2O9rd1L/TZp3QkRs/3HP0YgMJny+NxF0V5vKvOkUgVlKkTAsAKvEC/YQ0nxw43qJBAAyo1F1Vqqdp//VbzYQyqeyjddVg23ZrP/4sCUHoyD6rU7oiIE3ZOC/4yFxdUvA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org; spf=pass smtp.mailfrom=gmail.com; arc=none smtp.client-ip=209.85.217.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-vs1-f54.google.com with SMTP id ada2fe7eead31-48f42bfb6c4so673863137.1
        for <mm-commits@vger.kernel.org>; Sat, 29 Jun 2024 00:52:16 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1719647536; x=1720252336;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ROlZPVHv3cvQ+F+b+CQ8YQpUyZeN6wU5ronmxxh7OTU=;
        b=BGkuLEF+9+68jNwIW3IHik9+E3eFBTy6bL3E9MTATDxsrClICB0ATfxENo0I1maiBE
         hzarwoi+9wHHiQbgKkg62fj+9ulidS4KVn9iHSX7e1sRO6YWiQiRRyFMywEJSGNpEj1t
         yvlBoOXwpjItnQxU0SIkf+ZopQEisWAnmOemkfdKTKTuVvm+AJkpcRwI4hzwn2DxuwcP
         /9/FO/rkvnMN8IBuFOBSyc3edJ0O2d99Fj3Mjvc71WEMWdfTVAohtx6pbWBnoPQs5C/x
         zUI7HtZocrLdB1sHbe7uSx9HXWkuXsPvKpQyDa3y3eBmZSTquryqKJBPC2W9xzo/Vw+i
         9mpQ==
X-Gm-Message-State: AOJu0YwfOEslKopJYRFBMaBqCqsVurqRxOoT379yJek0IDklfPhdM7yU
	W0ks6kV+l4Nw8Ks2uDVC7zLaDdwbGMfpUQURz2KRBblEblV8QOshTxKwZ/f3tyrgnxdua/Lrx5Q
	iuQe7XkVs0oAJ9oRJrl4yO+Zyrxc=
X-Google-Smtp-Source: AGHT+IGYvzqQsh/DfYd5G3w/Sd2ficv0lr6u9KpvAxGrrcxtJb1JRDMa5B5wcj+WMp/9feAeN6K77CSn15UrTkxSJIM=
X-Received: by 2002:a67:e291:0:b0:48c:45e3:16e0 with SMTP id
 ada2fe7eead31-48f9e890cc1mr2413041137.9.1719647535944; Sat, 29 Jun 2024
 00:52:15 -0700 (PDT)
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240625050128.597AFC32782@smtp.kernel.org>
In-Reply-To: <20240625050128.597AFC32782@smtp.kernel.org>
From: Barry Song <baohua@kernel.org>
Date: Sat, 29 Jun 2024 19:52:04 +1200
Message-ID: <CAGsJ_4zt+zuO9HJs-cVhybd8E7mTgML7MjwJgYDBdWdDM9Wo+Q@mail.gmail.com>
Subject: Re: [merged mm-stable] mm-zswap-add-zswap_never_enabled.patch removed
 from -mm tree
To: Andrew Morton <akpm@linux-foundation.org>
Cc: mm-commits@vger.kernel.org, willy@infradead.org, nphamcs@gmail.com, 
	hannes@cmpxchg.org, david@redhat.com, chrisl@kernel.org, 
	chengming.zhou@linux.dev, yosryahmed@google.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Jun 25, 2024 at 5:01=E2=80=AFPM Andrew Morton <akpm@linux-foundatio=
n.org> wrote:
>
>
> The quilt patch titled
>      Subject: mm: zswap: add zswap_never_enabled()
> has been removed from the -mm tree.  Its filename was
>      mm-zswap-add-zswap_never_enabled.patch
>
> This patch was dropped because it was merged into the mm-stable branch
> of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
>
> ------------------------------------------------------
> From: Yosry Ahmed <yosryahmed@google.com>
> Subject: mm: zswap: add zswap_never_enabled()
> Date: Tue, 11 Jun 2024 02:45:15 +0000
>
> Add zswap_never_enabled() to skip the xarray lookup in zswap_load() if
> zswap was never enabled on the system.  It is implemented using static
> branches for efficiency, as enabling zswap should be a rare event.  This
> could shave some cycles off zswap_load() when CONFIG_ZSWAP is used but
> zswap is never enabled.
>
> However, the real motivation behind this patch is two-fold:
> - Incoming large folio swapin work will need to fallback to order-0
>   folios if zswap was ever enabled, because any part of the folio could b=
e
>   in zswap, until proper handling of large folios with zswap is added.
>
> - A warning and recovery attempt will be added in a following change in
>   case the above was not done incorrectly.  Zswap will fail the read if
>   the folio is large and it was ever enabled.
>
> Expose zswap_never_enabled() in the header for the swapin work to use
> it later.
>
> [yosryahmed@google.com: expose zswap_never_enabled() in the header]
>   Link: https://lkml.kernel.org/r/Zmjf0Dr8s9xSW41X@google.com
> Link: https://lkml.kernel.org/r/20240611024516.1375191-2-yosryahmed@googl=
e.com
> Signed-off-by: Yosry Ahmed <yosryahmed@google.com>
> Reviewed-by: Nhat Pham <nphamcs@gmail.com>
> Cc: Barry Song <baohua@kernel.org>
> Cc: Chengming Zhou <chengming.zhou@linux.dev>
> Cc: Chris Li <chrisl@kernel.org>
> Cc: David Hildenbrand <david@redhat.com>
> Cc: Johannes Weiner <hannes@cmpxchg.org>
> Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> ---
>
>  include/linux/zswap.h |    6 ++++++
>  mm/zswap.c            |   10 ++++++++++
>  2 files changed, 16 insertions(+)
>
> --- a/include/linux/zswap.h~mm-zswap-add-zswap_never_enabled
> +++ a/include/linux/zswap.h
> @@ -36,6 +36,7 @@ void zswap_memcg_offline_cleanup(struct
>  void zswap_lruvec_state_init(struct lruvec *lruvec);
>  void zswap_folio_swapin(struct folio *folio);
>  bool zswap_is_enabled(void);
> +bool zswap_never_enabled(void);
>  #else
>
>  struct zswap_lruvec_state {};
> @@ -64,6 +65,11 @@ static inline bool zswap_is_enabled(void
>  {
>         return false;
>  }
> +
> +static inline bool zswap_never_enabled(void)
> +{
> +       return false;

Hi Yosry & Andrew,

Sorry for reporting the error too late. It should be "return true".

As it has been in mm-stable, do we still have a way to fix it?


> +}
>
>  #endif
>
> --- a/mm/zswap.c~mm-zswap-add-zswap_never_enabled
> +++ a/mm/zswap.c
> @@ -83,6 +83,7 @@ static bool zswap_pool_reached_full;
>  static int zswap_setup(void);
>
>  /* Enable/disable zswap */
> +static DEFINE_STATIC_KEY_MAYBE(CONFIG_ZSWAP_DEFAULT_ON, zswap_ever_enabl=
ed);
>  static bool zswap_enabled =3D IS_ENABLED(CONFIG_ZSWAP_DEFAULT_ON);
>  static int zswap_enabled_param_set(const char *,
>                                    const struct kernel_param *);
> @@ -136,6 +137,11 @@ bool zswap_is_enabled(void)
>         return zswap_enabled;
>  }
>
> +bool zswap_never_enabled(void)
> +{
> +       return !static_branch_maybe(CONFIG_ZSWAP_DEFAULT_ON, &zswap_ever_=
enabled);
> +}
> +
>  /*********************************
>  * data structures
>  **********************************/
> @@ -1557,6 +1563,9 @@ bool zswap_load(struct folio *folio)
>
>         VM_WARN_ON_ONCE(!folio_test_locked(folio));
>
> +       if (zswap_never_enabled())
> +               return false;
> +
>         /*
>          * When reading into the swapcache, invalidate our entry. The
>          * swapcache can be the authoritative owner of the page and
> @@ -1735,6 +1744,7 @@ static int zswap_setup(void)
>                         zpool_get_type(pool->zpools[0]));
>                 list_add(&pool->list, &zswap_pools);
>                 zswap_has_pool =3D true;
> +               static_branch_enable(&zswap_ever_enabled);
>         } else {
>                 pr_err("pool creation failed\n");
>                 zswap_enabled =3D false;
> _
>
> Patches currently in -mm which might be from yosryahmed@google.com are
>
>
