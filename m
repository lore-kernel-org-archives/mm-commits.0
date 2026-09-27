Received: from mail-qt1-f174.google.com (mail-qt1-f174.google.com [209.85.160.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 651B42EACEF
	for <mm-commits@vger.kernel.org>; Sun, 27 Sep 2026 18:43:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.174
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790534585; cv=pass; b=Ww/+U6/QKba14Lyfc0u37OlZcEXRHrqSfEfPXs8BHn/XOXk5QeDuVNRAhQsmSfIKbpJbptw5woxWg+T70RRrPGm1fN6VCAX/h08yh590DLTCmSZ2KGRsHjlXdTSGmYG7Bt+AD1QyM96pc4wL34Xrdx3g7RLYYPICQadJOAWRU3c=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790534585; c=relaxed/simple;
	bh=vvaQBnCoKOyMA7uwaqokJ5yiELZmNJnMyYF7dQXjQFE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=NpJD/2W0KJiJnZb2sqQGaFHAh4ffSwLUVRXIthMeAEzjCcEeo/aAGMQbfhixtYvHWXQ8bYxvG0ceyl3rLGjFQtiwtGjNrHCxyyRl77k1hRWXll1NHr8D+vQNfMwfJgUyhToql/UyAOTp8RcuwEVX3zTuHKV+t+HB2Y9vJqCjy60=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=uooV1+Bs; arc=pass smtp.client-ip=209.85.160.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="uooV1+Bs"
Received: by mail-qt1-f174.google.com with SMTP id d75a77b69052e-53328262efbso167691cf.0
        for <mm-commits@vger.kernel.org>; Sun, 27 Sep 2026 11:43:04 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1790534583; cv=none;
        d=google.com; s=arc-20260327;
        b=jtZFdItr1p6ygIGq5a5k6catKAyykdQD562Df+fTAnqGZqfCbtbe4s1K56K3bPr2gC
         mOwNGhCYtI/3W33OfJoik9LPcmzJMCrrxmZS4P3MgwzAgs4CY5IBMrVEWF8VegiIs2Lq
         7UMdtDqO2KTmUoFaHxlvwEbOncGWwRLry8nGL8lptkNmnAHqAvmGFHAzb5M2vqT8b33U
         NNxxCxxmywbmlh0AbF8eTj6Y/icGzUNcJWj243mUNtJt4c3v2r9DrDjO/t/RAf2kcEML
         s6v66F6N8fYdgapqBhTWO2i4v0HEsWuXR/7rDVtoZuBKhSkrSsgLh1+iC0bueVntpbKt
         LYww==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=wz8k7MO9Giwzl9skRoyGRr6OliqXNHM85ABcpkEfXSA=;
        fh=BC/LvadvnjQhNmJFFHvBP7+gehVtteccM97XKixpsYk=;
        b=sdTwcQiKPdxyUe8x08Fl65vzbWQpCPsfXw+w+1zVHiwJsgSrl2UJgSjkD3S738QesF
         IS5eohSNJffVXc1V90C8dvhYFI2I8jYZ0iV8A8I6tZAgptO+xYqCmA23rxBhHo9l81Uj
         j44fz7U2e1ktJn7XXfnKL6wNSEFrJSeLyvcDhw5jvF7A4CqCXBgH09nE/gzyboXflUzo
         uDzCt0V/cC35IQrRC8t9nRZtQZ8kx/v5DL8sxSJ7bfN4dCdBwugNSmTCB5jitIxODvc8
         yci5O/t+O7Q1G7dtWHk65bTM4BXdsFuKjCg1eebJfUrZnV28ZU6uGAQj1uMwhI5e088t
         phJw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1790534583; x=1791139383; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=wz8k7MO9Giwzl9skRoyGRr6OliqXNHM85ABcpkEfXSA=;
        b=uooV1+BseL1lIVDes3UmxlTDK7/Y11e69KBMou4JuQPbOSwYR1/N8voYTdbLv1hP90
         1g8Qw+qobD4YdYWof2Yjq6lp3qgAFY/ZCEoXI0Tu5sjEx97XOWlLBchCH9GhaD1WPaK4
         bxouSq//lpOvvhgw7ri/jChHCl1F1oNCRObPWbT5cv+XHpUz8/EVLxnd9Y5676PJeWRb
         9JSs9KHZ1pAUnanLI2d3aFzUt9dLvUXCrXlrIIO1oAoLONZdfqiJCJjzhJSRNdF8OSJw
         su6NEH/rKIqljKv50f3gn9518Rpj4y9DwMVoxh+1BuuEK0kwdKjCa7hY6ep6DovjQT7+
         T/Zg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790534583; x=1791139383;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=wz8k7MO9Giwzl9skRoyGRr6OliqXNHM85ABcpkEfXSA=;
        b=LjF+39Vf92bjAoaN2Gp93NeR3BeW+Hr8Itgqy3qCjSbBoF65xnUX4GFy2eosuf8cBB
         YK3/ex6RvBYiGQZTbGnHBU62e9sIIVCr9w5b5yCzU5ff4DCpkfvIP2LWZc24kPQOFTZk
         ZRT5Xa8+KbPPdU3J0uFg4cjM86e/dxvm0Xxq/pbUUBEIJi/tbsFMr60IMFqrZiMe6uyW
         6jOYRbe1idT03JJ8iexHCZfPtnPS+4k1gKZnBeGTbeXUPFetkqRNTdefxUgNw7e7G5sh
         eo/3Nym0PWfKHgRL3Ry7ZS1PyhMmWs6g3Ib46ZknPXYQ9PO6oN/WkBqFpjKrN0hDs0gL
         jhUw==
X-Forwarded-Encrypted: i=1; AKwUvBy8VriTXk1niDCvKrSlzFaXgSkF18Cyf0aFlL0KstCzkDDfvNkjbE0laqxW8qOvBigNIdxW6L2vV6XX@vger.kernel.org
X-Gm-Message-State: AFuF++l6nZ1uCFGUjnejuOEjea/QPlrhRjHtRAPJc3x7fHRBjqntSMdk
	TdbWIS+Jf0RU0/nRGRj1cH/WWxrmNd5WYsoEEqq18i+itRCQq6puM9r3gJOQGZC2jADv9/jHoeU
	JM8kbRf4JKp/5TgKzhBNORO+Nmy0xj9P5vpsuxFGf
X-Gm-Gg: AYBFou1JhKAwplOQDoAC4UrqFuWSXLeSL7TAxwCHmTuzHhLyMPL2VSG5mZCRjg7NuNa
	VoDF4jw/LRZNLLwpiTAB9vvlzGlYijZc00sIwDfx03qt27ZLr90z7kdx+yFiLO1Lvw4u8HA+cJY
	fQBM5SbxzqjxvL+AtajoFd1vadyz71lvs8+M9vzo/hqvaHnqmG/UIExeYA2ZwnGuXrvJ1xiIhd4
	TSr/9KkJh4Y5wCd0XsrFaRjWDuadTe12u6CIfhDEsXn8bwvns51NE3lYnP2CDahlHqkvJiLBSwX
	VCXFmJgyS/oDVbPnm/2xOdIFtAASNeVUT/kvQ5VqNzqf19xn7XprGO5cXgjdp/5IhFVmzlPeR+P
	7v8C5Q3PrL10=
X-Received: by 2002:ac8:5c95:0:b0:532:eff9:ca08 with SMTP id
 d75a77b69052e-53320176517mr17828151cf.12.1790534582640; Sun, 27 Sep 2026
 11:43:02 -0700 (PDT)
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <202609271644.eX9EFdJw-lkp@intel.com> <20260927110407.8641fb46613365094f4d32ff@linux-foundation.org>
In-Reply-To: <20260927110407.8641fb46613365094f4d32ff@linux-foundation.org>
From: Suren Baghdasaryan <surenb@google.com>
Date: Sun, 27 Sep 2026 11:42:51 -0700
X-Gm-Features: AclHuK-6Kh0494iLphiRrsts5maQH8XA-Kq7q8l8Cfb9ycF_Brcsonq-LTJ1WjQ
Message-ID: <CAJuCfpEyW=rM7T2iP3pv3fbAzH410twAmxUbMHzKDfD4gF_F-g@mail.gmail.com>
Subject: Re: [akpm-mm:mm-new] BUILD REGRESSION b4fc90c82982d98959af08b4320420bcfc01303b
To: Andrew Morton <akpm@linux-foundation.org>
Cc: kernel test robot <lkp@intel.com>, David Hildenbrand <david@kernel.org>, 
	Linux Memory Management List <linux-mm@kvack.org>, mm-commits@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sun, Sep 27, 2026 at 11:04=E2=80=AFAM Andrew Morton
<akpm@linux-foundation.org> wrote:
>
> On Sun, 27 Sep 2026 16:00:49 +0800 kernel test robot <lkp@intel.com> wrot=
e:
>
> > tree/branch: https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.gi=
t mm-new
> > branch HEAD: b4fc90c82982d98959af08b4320420bcfc01303b  mm/swap, PM: hib=
ernate: atomically replace hibernation pin
> >
> > Error/Warning (recently discovered and may have been fixed):
> >
> >     https://lore.kernel.org/oe-kbuild-all/202609160337.WJiD9BqX-lkp@int=
el.com
> >     https://lore.kernel.org/oe-kbuild-all/202609171159.oaB1OaSG-lkp@int=
el.com
> >     https://lore.kernel.org/oe-kbuild-all/202609270030.Y0QVBPmK-lkp@int=
el.com
> >
> >     aarch64-linux-ld: Unexpected GOT/PLT entries detected!
> >     aarch64-linux-ld: Unexpected run-time procedure linkages detected!
> >     arena.c:(.text+0x11fc): undefined reference to `__check_safe_pte_up=
date'
> >     fs/proc/task_mmu.c:3450:17: error: implicit declaration of function=
 'drop_rcu' [-Werror=3Dimplicit-function-declaration]
> >     fs/proc/task_mmu.c:3450:3: error: call to undeclared function 'drop=
_rcu'; ISO C99 and later do not support implicit function declarations [-Wi=
mplicit-function-declaration]
> >     fs/proc/task_mmu.c:3450:3: error: implicit declaration of function =
'drop_rcu'; did you mean 'drop_slab'? [-Werror=3Dimplicit-function-declarat=
ion]
> >     fs/proc/task_mmu.c:3452:17: error: implicit declaration of function=
 'reacquire_rcu' [-Werror=3Dimplicit-function-declaration]
> >     fs/proc/task_mmu.c:3452:3: error: call to undeclared function 'reac=
quire_rcu'; ISO C99 and later do not support implicit function declarations=
 [-Wimplicit-function-declaration]
> >     fs/proc/task_mmu.c:3452:3: error: implicit declaration of function =
'reacquire_rcu'; did you mean 'get_file_rcu'? [-Werror=3Dimplicit-function-=
declaration]
> >     gup.c:(.text+0x2b48): undefined reference to `__check_safe_pte_upda=
te'
> >     hugetlbpage.c:(.text+0x1a8): undefined reference to `__check_safe_p=
te_update'
> >     memory.c:(.text+0x3418): undefined reference to `__check_safe_pte_u=
pdate'
> >     mmu.c:(.text+0x9a8): undefined reference to `__check_safe_pte_updat=
e'
>
> Thanks.  Against "proc/task_mmu: remove unnecessary inlines in function
> definitions":

Thanks! LGTM.

>
>
> From: Andrew Morton <akpm@linux-foundation.org>
> Subject: proc-task_mmu-remove-unnecessary-inlines-in-function-definitions=
-fix
> Date: Sun Sep 27 10:59:53 AM PDT 2026
>
> fix CONFIG_NUMA=3Dy && CONFIG_PROC_PAGE_MONITOR=3Dn build
>
> show_numa_map() uses drop_rcu() and reacquire_rcu(), but those helpers ar=
e
> currently built only when CONFIG_PROC_PAGE_MONITOR is enabled.  A kernel
> with CONFIG_NUMA=3Dy and CONFIG_PROC_PAGE_MONITOR=3Dn therefore fails to =
build
> with implicit declarations for both helpers.
>
> Cc: Suren Baghdasaryan <surenb@google.com>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> ---
>
>  fs/proc/task_mmu.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> --- a/fs/proc/task_mmu.c~proc-task_mmu-remove-unnecessary-inlines-in-func=
tion-definitions-fix
> +++ a/fs/proc/task_mmu.c
> @@ -196,7 +196,7 @@ static bool fallback_to_mmap_lock(struct
>         return true;
>  }
>
> -#ifdef CONFIG_PROC_PAGE_MONITOR
> +#if defined(CONFIG_PROC_PAGE_MONITOR) || defined(CONFIG_NUMA)
>  static void drop_rcu(struct proc_maps_private *priv)
>  {
>         if (priv->lock_ctx.mmap_locked)
> _
>
