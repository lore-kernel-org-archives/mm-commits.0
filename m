Received: from mail-lf1-f43.google.com (mail-lf1-f43.google.com [209.85.167.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF86F18DF90
	for <mm-commits@vger.kernel.org>; Tue,  3 Sep 2024 17:53:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725386041; cv=none; b=fzm4k65eO4F1EgDuBT4HwMaVJJl/HujWxVEA7MOphIp+edGI70eVWCcu0lpQieowDHGDgKCG6tY8BjGCzxeB9YZSVp+qt4u5AVODhEcE8sfN+v92LKsqWFHp8LnWdE4h0Sne4jafaEJAX4tpFQqxJY5c+jB8+OfQkFOOL4zGUu0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725386041; c=relaxed/simple;
	bh=m+pfgB926aNdCyINxiYtptaS9sR1+Po8T4qlAiuIzfQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=XZwMLCLnjEM91bK2+EcyxWuZTmUMpjli/pW+Hwy7bQunzkfO7mZzWSGEPHp1rTPbolTtNsovZf5PON8Q6ufTb6RyyV9ghucTq3zlh5FmBLtWmhwobvn3FhglxLL+h2oYdUTb7I9EMs7VF/YukIULo9ajSiQJTbPn44HkkUFdKIk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=FvzrLjiH; arc=none smtp.client-ip=209.85.167.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="FvzrLjiH"
Received: by mail-lf1-f43.google.com with SMTP id 2adb3069b0e04-5343eeb4973so8761380e87.2
        for <mm-commits@vger.kernel.org>; Tue, 03 Sep 2024 10:53:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1725386038; x=1725990838; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=MPIfMmfxiAGOTOYrKOKeyFV2+/a3tmmFy8LnbxS/cpA=;
        b=FvzrLjiHDs5A+U6CLJLwBdv5GWEjFEyc2Ds1CZeTDSVAhMuREl1qfOj+fGMhVo54oM
         YZIW13qivB4MO64L19oGyn8mQSuGYQPouUVqTIAI5EP4oi1LwGR42Hlkanzbqv2SSA6W
         ubZ2gcp4PIWsbLZlwwYVOfIlOUhbJrNl+fFVMlJUGb0MJl6f3yYQL+NLc7kSfwvXjhKL
         DtQFo7R4vK+muUlV71/Y3WHkAChlLnvrkxcvdXmFwuJmTVHXgFqKec792rwrVeq4vX+8
         PgJCTre4EExAflc8guRF6PR5h8WACX+OMykqDxX7A0oKuCBEpMEh2F+wUc3hn4WRJUmM
         iNVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725386038; x=1725990838;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=MPIfMmfxiAGOTOYrKOKeyFV2+/a3tmmFy8LnbxS/cpA=;
        b=ePwRykqq2BHEifRpwETRyoGvFDagmNaHPIZ6OP3XXdj/cauFu95trlug2IGJ6Rq3t5
         dDxPsOGceWHTxb8pJ826U7A0CIkIou9dBXYFv7ZgtwYOURD7Np+Vy0dE7g5vB98hgluS
         0iy31tc/z1UBxsKh+qfo65qXElO6vLjjpQt8P8ZrjUiBztYWlZnUDthHgjNUMxRFVQGY
         1IS4Nvl23eF5U26WHgSXr0m2kQkkw6vb4E4eGtJoDKmzLGQ7kj6+EU855P7QVyWu9eQ1
         WbMEOcMuMeJRjA4NVjpVLQj+0QwG8RuwUNwQrrKweMWF76fdajiD8oQI9iMytQcbqXIl
         59qQ==
X-Gm-Message-State: AOJu0Yy+xKLw1sW/Dvz/K6CHc4VFjqBCS4Wp0dxWKrfe9rdpM4BlAxUS
	bLM/9Chve4IxYVJhGl1BTxCPneenn0LI/ocY7FdIlcUndkc7Lx8u6K2P03qKEgR1MLKRu2SYfL9
	gEbQlvCkK1G4/3B104DxlncivtGw0Q+fNlRF4
X-Google-Smtp-Source: AGHT+IF2t+uT18eN1K0vaLH5xqiAjw86XpOr4HdwzrTGeyad54ig2xRfXarGF2TBLwQ0tIXwymfT1tgdevI7I9LnBoA=
X-Received: by 2002:a05:6512:acb:b0:533:4505:5b2a with SMTP id
 2adb3069b0e04-53546b4a8c9mr12317296e87.28.1725386037206; Tue, 03 Sep 2024
 10:53:57 -0700 (PDT)
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240902005945.34B0FC4CEC3@smtp.kernel.org>
In-Reply-To: <20240902005945.34B0FC4CEC3@smtp.kernel.org>
From: Yosry Ahmed <yosryahmed@google.com>
Date: Tue, 3 Sep 2024 10:53:21 -0700
Message-ID: <CAJD7tkYtM8gQDX8RrT1cnkfDQ0dRv4woNY4jrwjc1oUuavbuTg@mail.gmail.com>
Subject: Re: [merged mm-hotfixes-stable] mm-memcontrol-respect-zswapwriteback-setting-from-parent-cg-too.patch
 removed from -mm tree
To: Andrew Morton <akpm@linux-foundation.org>
Cc: mm-commits@vger.kernel.org, stable@vger.kernel.org, shakeel.butt@linux.dev, 
	roman.gushchin@linux.dev, nphamcs@gmail.com, muchun.song@linux.dev, 
	mkoutny@suse.com, mhocko@kernel.org, hannes@cmpxchg.org, me@yhndnzj.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sun, Sep 1, 2024 at 5:59=E2=80=AFPM Andrew Morton <akpm@linux-foundation=
.org> wrote:
>
>
> The quilt patch titled
>      Subject: mm/memcontrol: respect zswap.writeback setting from parent =
cg too
> has been removed from the -mm tree.  Its filename was
>      mm-memcontrol-respect-zswapwriteback-setting-from-parent-cg-too.patc=
h
>
> This patch was dropped because it was merged into the mm-hotfixes-stable =
branch
> of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
>
> ------------------------------------------------------
> From: Mike Yuan <me@yhndnzj.com>
> Subject: mm/memcontrol: respect zswap.writeback setting from parent cg to=
o
> Date: Fri, 23 Aug 2024 16:27:06 +0000
>
> Currently, the behavior of zswap.writeback wrt.  the cgroup hierarchy
> seems a bit odd.  Unlike zswap.max, it doesn't honor the value from paren=
t
> cgroups.  This surfaced when people tried to globally disable zswap
> writeback, i.e.  reserve physical swap space only for hibernation [1] -
> disabling zswap.writeback only for the root cgroup results in subcgroups
> with zswap.writeback=3D1 still performing writeback.
>
> The inconsistency became more noticeable after I introduced the
> MemoryZSwapWriteback=3D systemd unit setting [2] for controlling the knob=
.
> The patch assumed that the kernel would enforce the value of parent
> cgroups.  It could probably be workarounded from systemd's side, by going
> up the slice unit tree and inheriting the value.  Yet I think it's more
> sensible to make it behave consistently with zswap.max and friends.
>
> [1] https://wiki.archlinux.org/title/Power_management/Suspend_and_hiberna=
te#Disable_zswap_writeback_to_use_the_swap_space_only_for_hibernation
> [2] https://github.com/systemd/systemd/pull/31734
>
> Link: https://lkml.kernel.org/r/20240823162506.12117-1-me@yhndnzj.com
> Fixes: 501a06fe8e4c ("zswap: memcontrol: implement zswap writeback disabl=
ing")
> Signed-off-by: Mike Yuan <me@yhndnzj.com>
> Reviewed-by: Nhat Pham <nphamcs@gmail.com>
> Acked-by: Yosry Ahmed <yosryahmed@google.com>

We wanted to CC stable here, it's too late at this point, right?

> Cc: Johannes Weiner <hannes@cmpxchg.org>
> Cc: Michal Hocko <mhocko@kernel.org>
> Cc: Michal Koutn=C3=BD <mkoutny@suse.com>
> Cc: Muchun Song <muchun.song@linux.dev>
> Cc: Roman Gushchin <roman.gushchin@linux.dev>
> Cc: Shakeel Butt <shakeel.butt@linux.dev>
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> ---
>
>  Documentation/admin-guide/cgroup-v2.rst |    7 ++++---
>  mm/memcontrol.c                         |   12 +++++++++---
>  2 files changed, 13 insertions(+), 6 deletions(-)
>
> --- a/Documentation/admin-guide/cgroup-v2.rst~mm-memcontrol-respect-zswap=
writeback-setting-from-parent-cg-too
> +++ a/Documentation/admin-guide/cgroup-v2.rst
> @@ -1717,9 +1717,10 @@ The following nested keys are defined.
>         entries fault back in or are written out to disk.
>
>    memory.zswap.writeback
> -       A read-write single value file. The default value is "1". The
> -       initial value of the root cgroup is 1, and when a new cgroup is
> -       created, it inherits the current value of its parent.
> +       A read-write single value file. The default value is "1".
> +       Note that this setting is hierarchical, i.e. the writeback would =
be
> +       implicitly disabled for child cgroups if the upper hierarchy
> +       does so.
>
>         When this is set to 0, all swapping attempts to swapping devices
>         are disabled. This included both zswap writebacks, and swapping d=
ue
> --- a/mm/memcontrol.c~mm-memcontrol-respect-zswapwriteback-setting-from-p=
arent-cg-too
> +++ a/mm/memcontrol.c
> @@ -3613,8 +3613,7 @@ mem_cgroup_css_alloc(struct cgroup_subsy
>         memcg1_soft_limit_reset(memcg);
>  #ifdef CONFIG_ZSWAP
>         memcg->zswap_max =3D PAGE_COUNTER_MAX;
> -       WRITE_ONCE(memcg->zswap_writeback,
> -               !parent || READ_ONCE(parent->zswap_writeback));
> +       WRITE_ONCE(memcg->zswap_writeback, true);
>  #endif
>         page_counter_set_high(&memcg->swap, PAGE_COUNTER_MAX);
>         if (parent) {
> @@ -5320,7 +5319,14 @@ void obj_cgroup_uncharge_zswap(struct ob
>  bool mem_cgroup_zswap_writeback_enabled(struct mem_cgroup *memcg)
>  {
>         /* if zswap is disabled, do not block pages going to the swapping=
 device */
> -       return !zswap_is_enabled() || !memcg || READ_ONCE(memcg->zswap_wr=
iteback);
> +       if (!zswap_is_enabled())
> +               return true;
> +
> +       for (; memcg; memcg =3D parent_mem_cgroup(memcg))
> +               if (!READ_ONCE(memcg->zswap_writeback))
> +                       return false;
> +
> +       return true;
>  }
>
>  static u64 zswap_current_read(struct cgroup_subsys_state *css,
> _
>
> Patches currently in -mm which might be from me@yhndnzj.com are
>
> documentation-cgroup-v2-clarify-that-zswapwriteback-is-ignored-if-zswap-i=
s-disabled.patch
> selftests-test_zswap-add-test-for-hierarchical-zswapwriteback.patch
>
