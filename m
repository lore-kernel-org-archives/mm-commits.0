Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D79C818645
	for <mm-commits@vger.kernel.org>; Sat,  6 Jul 2024 06:30:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720247413; cv=none; b=GUJEDkIGXhYggLU4Am0fnpZr73xfaV4EAZzuZy5dUv9Ky8IOlaXoFmdgg7gcKumbsfNn2ODcln1OyI7t7DxmQuZNAQCIG6t0GEG+3Ge0w9usZInBIfJWUECW76RXCw377IN59LIMNXwPfejZvOtJ2DZRnjzxDXjPAklBU/PgHrc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720247413; c=relaxed/simple;
	bh=R4Yv356+3rHTp4fQnM6lvrRCPiCIkg4BnxYMOrkrN74=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Pke4MKMpVgvE9MliOsPY2NyYbPsMUxPitWG4XucxW6HPlgDWp7re7BoJHNelY9ysDKFLSOV8bZw2mvNoz3W0EdCvbBZIYml45oJcH4SONj62AePGJiVzf4yFsJryTYNIG8WhAhWDLpHyL7BBZ3u8IBaUFhxVq9wHGcfCu25pf6Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ig9cRxy1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ig9cRxy1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5FA7BC2BD10
	for <mm-commits@vger.kernel.org>; Sat,  6 Jul 2024 06:30:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1720247413;
	bh=R4Yv356+3rHTp4fQnM6lvrRCPiCIkg4BnxYMOrkrN74=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=ig9cRxy166FTkV7hsn31Wdxuv9tktWTABmKSY7D6pzfSwc5Jl3hrzaadbOv0JQVbl
	 U4NNXYnNOhNNXT9tafK+kvsJHZTasXEILj1yzu+6Ml5AZgGtsAPVmCYF6gGkwgdi0x
	 PiLdTVmcKA1gILu79feNLpF4wB81pojKkEMMjrnkHwBRhgmS9gUf3XXUjTKJxKGfG1
	 lEx87H7YCzmqP6GBK9ABwsyYiHjC/sFy+w6k4LGdxJoLg8b+FwAv5Whg2SlsgG57uF
	 FWVYK2rGhyKhf99FoMFDpeINtSpfz+uLeOqx2tvzTJkX9we3pOzGKAqcnTD5VoohfT
	 ZFDI484kV6WsQ==
Received: by mail-lf1-f46.google.com with SMTP id 2adb3069b0e04-52ea929ea56so1262016e87.0
        for <mm-commits@vger.kernel.org>; Fri, 05 Jul 2024 23:30:13 -0700 (PDT)
X-Gm-Message-State: AOJu0YzRoE2LbggixnCj+oh0emUFy3k2rJ43oWlUWMV80T9nLXhe6471
	/U+DPv24VzZJxEKEtw7KhGlnzJkrnd0/ORYaVceqrxHIDDceOyYkvvNkosffdkayHdm7PcCQVmL
	uhO64VN92rTRruXlBxFO1GBHyrJE=
X-Google-Smtp-Source: AGHT+IFK668UcV224M6YEkb4+P2DWHaYus/TbPG+6S/XpUWaTMrIOvIdgw58H8irQfd4B1dPKaMos9Wi/YSOO/045gE=
X-Received: by 2002:a05:6512:4884:b0:52c:f55d:44a3 with SMTP id
 2adb3069b0e04-52ea0622628mr5661773e87.19.1720247412086; Fri, 05 Jul 2024
 23:30:12 -0700 (PDT)
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240703183352.91BFAC2BD10@smtp.kernel.org>
In-Reply-To: <20240703183352.91BFAC2BD10@smtp.kernel.org>
From: Masahiro Yamada <masahiroy@kernel.org>
Date: Sat, 6 Jul 2024 15:29:35 +0900
X-Gmail-Original-Message-ID: <CAK7LNATU=p1VNF=K+cDdCMkHnspX+sFyTMoob1C7LAxcYUBXfQ@mail.gmail.com>
Message-ID: <CAK7LNATU=p1VNF=K+cDdCMkHnspX+sFyTMoob1C7LAxcYUBXfQ@mail.gmail.com>
Subject: Re: [nacked] mm-use-zonelist_zone-to-get-zone.patch removed from -mm tree
To: Andrew Morton <akpm@linux-foundation.org>
Cc: mm-commits@vger.kernel.org, rppt@kernel.org, nicolas@fjasle.eu, 
	nathan@kernel.org, richard.weiyang@gmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Jul 4, 2024 at 3:33=E2=80=AFAM Andrew Morton <akpm@linux-foundation=
.org> wrote:
>
>
> The quilt patch titled
>      Subject: mm: use zonelist_zone() to get zone
> has been removed from the -mm tree.  Its filename was
>      mm-use-zonelist_zone-to-get-zone.patch
>
> This patch was dropped because it was nacked
>
> ------------------------------------------------------
> From: Wei Yang <richard.weiyang@gmail.com>
> Subject: mm: use zonelist_zone() to get zone
> Date: Tue, 2 Jul 2024 23:40:06 +0000
>
> Instead of accessing zoneref->zone directly, use zonelist_zone() like
> other places for consistency.
>
> No functional change.
>
> Link: https://lkml.kernel.org/r/20240702234008.19101-1-richard.weiyang@gm=
ail.com
> Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
> Cc: Mike Rapoport (IBM) <rppt@kernel.org>
> Cc: Masahiro Yamada <masahiroy@kernel.org>
> Cc: Nathan Chancellor <nathan@kernel.org>
> Cc: Nicolas Schier <nicolas@fjasle.eu>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>


FWIW, I did not NACK this patch, as it is independent.




> ---
>
>  include/linux/mmzone.h |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> --- a/include/linux/mmzone.h~mm-use-zonelist_zone-to-get-zone
> +++ a/include/linux/mmzone.h
> @@ -1690,7 +1690,7 @@ static inline struct zoneref *first_zone
>                         zone =3D zonelist_zone(z))
>
>  #define for_next_zone_zonelist_nodemask(zone, z, highidx, nodemask) \
> -       for (zone =3D z->zone;    \
> +       for (zone =3D zonelist_zone(z);   \
>                 zone;                                                   \
>                 z =3D next_zones_zonelist(++z, highidx, nodemask),       =
 \
>                         zone =3D zonelist_zone(z))
> _
>
> Patches currently in -mm which might be from richard.weiyang@gmail.com ar=
e
>
> kernel-forkc-get-totalram_pages-from-memblock-to-calculate-max_threads.pa=
tch
> kernel-forkc-put-set_max_threads-task_struct_whitelist-in-__init-section.=
patch
> mm-page_alloc-remove-prefetchw-on-freeing-page-to-buddy-system.patch
> modpost-meminit-is-not-in-init-section-when-config_memory_hotplug-set.pat=
ch
> mm-page_alloc-put-__free_pages_core-in-__meminit-section.patch
>


--=20
Best Regards
Masahiro Yamada
