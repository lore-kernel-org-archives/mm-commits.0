Received: from mail-wm1-f42.google.com (mail-wm1-f42.google.com [209.85.128.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B658457E70
	for <mm-commits@vger.kernel.org>; Sun, 11 Oct 2026 14:44:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791729847; cv=none; b=bMH1cYriFRvuVGEXDGDpqkldhW56CQ4lhgV/qxIyiC3E23sSFRVvJjgKh8T4a8r02UtWsNZe8orErO2qzqf4ojX30dQQGUc2FOUb89pEFBZ5Za5ENHNcij7dIOpr+TJWUCT3RvNQ3AwlzNZhQpq5M/eKS20yRoQLUvb0DQ08lAc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791729847; c=relaxed/simple;
	bh=ZtAqyVlFh0er+VF6HcaLzztD07cBhEZtfFGJRC3IRhU=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=kK30YTnNRP5oi9uMqFohZ115KH597wpe5dyBjU0Ua4wv25iGWFgGQPxJxHxXwW1KReY7sCAj0kNPWgJlzOkHOaB+iddHy93kO2e306FMcXIyi2bEm81mBOll9jAMBUuor5gnINFaaK3yTwFU+jeaFlGY4A7ETqYRjPS3ekSAsIQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=GbcdK67r; arc=none smtp.client-ip=209.85.128.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="GbcdK67r"
Received: by mail-wm1-f42.google.com with SMTP id 5b1f17b1804b1-49fbb2acc90so7664195e9.2
        for <mm-commits@vger.kernel.org>; Sun, 11 Oct 2026 07:44:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791729844; x=1792334644; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=rTeYGS4hdFxLXHg8HVJh0JGIVB6a6ZD3oXxF1vO1c4Y=;
        b=GbcdK67rtlv0TO/34dhAaEdlDaSNlJ60DIxCJjS6xA+sUXDO5v8NWeATlAdaFDEOWM
         qXHV4sBQkGvebbvsYZuNk6l5UksGOsQjrqtGueq+tNPSEAmuIwOlPdaUW/0accAbnAE5
         DodoktjwC0MEi+V9o9bWMTXfl8MTwcIF4THXUYr9iZ0dWtOsMUo46p/g4E6rwQuvjrL7
         OBBHFzUt2+sbcdAYpgNaZibFt8vnUZ83nJNxuVyB84ZYWk9tUifKAPWsfj4LDeh6ATYC
         onoTgbUif7WvDNANv2zTYesd1Spmi3HUEv1AwujqyPDrd1An8eFoqzH81y9An16zobxl
         Dcsw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791729844; x=1792334644;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=rTeYGS4hdFxLXHg8HVJh0JGIVB6a6ZD3oXxF1vO1c4Y=;
        b=Ad+zTr8RNSXLCKd1YJ+sKub+3sd8bC3W6YSp7gcZgH6cM7a91Pj3UgpVRN3VBYBec4
         3SBYFBQd9sd1pkw/r2xp0YP5S/5LS5SyPbk4okrWbe6Y4m8yWvXYXtfyC+B/7GLZeKPG
         NrorhzvSQt/EdC7vKCWIzNFx6S7bqID0CDJaEX0J8C5sTNAOzcbrwUBSLbl46KQn9Z3T
         thGLEZ+AmVI+3xE1ygnk2ztfPM84CdW1P1SAxlFsu2F7/UdHTx0jVX7NmrHMy3XzyOku
         wC2WSj0FZjp+hPVMLdMoKJft76pa1z5jCzBD//1e/1ug45VYYA0ZbgI95g0ftkLYVbFP
         NMHA==
X-Gm-Message-State: AFq9FYJVQf5oEVcEQrA3W14rEjO1DOz5yTEm6ZAWb/1iI1O99ARGkkLJ
	giCUqTL696caYNfUHiPpdJKCQEU6hFIFqZKfIq5Y7miZGIbAU2A5io2N
X-Gm-Gg: AYBFou3jFjSyfUjpjNLoxWHKL/3tPinds3suNjFfcN4mCy/Xbbe9M0EVoC6Bo877Z2z
	s6e7GoA7Cluo5IDIYgC0axansM0QX0e8VJ/LbZgCGw9u/SDpH+KdX18LZ28urcmmBCE5acbcxj6
	umu1P/wOeHTdatnPzXDBX69zXwIHQOIPT6JQLKJP9LZZHYKABk5Qrlv435WLSU1AjqRsShFxN0G
	bbtW39vcUpH8oopQikYAtqC8236q4ep2fW0W/2rKpsuoWeky4HfMfuSRALOv65S7z6cS7CS/7Ta
	5ixCGqiiWjqfKmcU+3Lga18lYtL9LOf8D/9zgyl8qeUyY6+qNffJEXVzlSCs1ZKWUvvIXZoYPRN
	GgKBg0kHEHgdJiFLBkbP8suapOM16KwixdYrwjsQH0GVynzR4cnd10ciifsRrpQ2YfKvR3GUyMU
	fdUtQFGS1aNFOZCTIlsjvo0nrS6CrSD0i9KlChJLT3nhoNrvQ2jEZrg6dtIuL93jj/lkEVAUD1b
	cCqGos+6w8AmAnIRcqPtopcN5IffWhT2kg=
X-Received: by 2002:a05:600c:c104:b0:4a1:96cd:2f67 with SMTP id 5b1f17b1804b1-4a196cd3240mr42534345e9.4.1791729843499;
        Sun, 11 Oct 2026 07:44:03 -0700 (PDT)
Received: from pumpkin (82-69-66-36.dsl.in-addr.zen.co.uk. [82.69.66.36])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4a18c85009csm169388585e9.2.2026.10.11.07.44.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 11 Oct 2026 07:44:03 -0700 (PDT)
Date: Sun, 11 Oct 2026 15:44:01 +0100
From: David Laight <david.laight.linux@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: mm-commits@vger.kernel.org, thunder.leizhen@huawei.com,
 thomas.weissschuh@linutronix.de, rostedt@goodmis.org, pmladek@suse.com,
 olsajiri@gmail.com, nsc@kernel.org, nathan@kernel.org, mcgrof@kernel.org,
 masahiroy@kernel.org, ljs@kernel.org, kees@kernel.org,
 geert@linux-m68k.org, denis.benato@linux.dev, chewi@gentoo.org,
 andrey.grodzovsky@crowdstrike.com, abelvesa@kernel.org,
 jim.cromie@gmail.com
Subject: Re: +
 kallsyms-increase-marker-density-to-16-1-to-accelerate-lookups-fix.patch
 added to mm-nonmm-unstable branch
Message-ID: <20261011154401.479c51b6@pumpkin>
In-Reply-To: <20261011002340.E44771F000FF@smtp.kernel.org>
References: <20261011002340.E44771F000FF@smtp.kernel.org>
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.38; arm-unknown-linux-gnueabihf)
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Sat, 10 Oct 2026 17:23:40 -0700
Andrew Morton <akpm@linux-foundation.org> wrote:

> The patch titled
>      Subject: kallsyms: copy constants from __KERNEL__ to user, drop the =
inclusion
> has been added to the -mm mm-nonmm-unstable branch.  Its filename is
>      kallsyms-increase-marker-density-to-16-1-to-accelerate-lookups-fix.p=
atch

There is a problem with the way this change in implemented.
Basically the kernel Makefile (etc) only builds scripts/kallsyms if it does=
n't exist.
This means that if the header file is changed you can easily end up with a =
kernel
that expects a different marker density from that in the data file.
That will lead to all sorts of strange/confusing issues.

It would be better to put the 'shift' value into the .S file.
It isn't used anywhere where that will make a performance difference.

David

>=20
> This patch will shortly appear at
>      https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree=
/patches/kallsyms-increase-marker-density-to-16-1-to-accelerate-lookups-fix=
.patch
>=20
> This patch will later appear in the mm-nonmm-unstable branch at
>     git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
>=20
> Before you just go and hit "reply", please:
>    a) Consider who else should be cc'ed
>    b) Prefer to cc a suitable mailing list as well
>    c) Ideally: find the original patch on the mailing list and do a
>       reply-to-all to that, adding suitable additional cc's
>=20
> *** Remember to use Documentation/process/submit-checklist.rst when testi=
ng your code ***
>=20
> The -mm tree is included into linux-next via various
> branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
> and is updated there most days
>=20
> ------------------------------------------------------
> From: Jim Cromie <jim.cromie@gmail.com>
> Subject: kallsyms: copy constants from __KERNEL__ to user, drop the inclu=
sion
> Date: Thu, 08 Oct 2026 17:19:12 -0600
>=20
> commit 4fafd1165b33 replaced hardcoded values which determine marker array
> size, with new values that accelerate symbol-name lookups.  These symbols
> are needed in user-space to generate the lookup tables, and in kernel to
> read the generated table.
>=20
> To avoid 2-defns problem, they were added to a kernel header (with ifdef
> guards) and included by scripts/kallsyms.c.  But that creates packaging
> problems elsewhere, so just add the 2nd defns, with an explicit comment
> about the user-kernel coupling.
>=20
> Link: https://lore.kernel.org/20261008-fix-kallsyms-v1-1-3339fdac2ab3@gma=
il.com
> Fixes: 4fafd1165b33 ("kallsyms: increase marker density to 16:1 to accele=
rate lookups")
> Signed-off-by: Jim Cromie <jim.cromie@gmail.com>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> Tested-by: Nicolas Schier <nsc@kernel.org>
> Reviewed-by: Nicolas Schier <nsc@kernel.org>
> Cc: Nathan Chancellor <nathan@kernel.org>
> Cc: Denis Benato <denis.benato@linux.dev>
> Cc: Kees Cook <kees@kernel.org>
> Cc: Thomas Wei=C3=9Fschuh <thomas.weissschuh@linutronix.de>
> Cc: James Le Cuirot <chewi@gentoo.org>
> Cc: Abel Vesa <abelvesa@kernel.org>
> Cc: Andrey Grodzovsky <andrey.grodzovsky@crowdstrike.com>
> Cc: David Laight <david.laight.linux@gmail.com>
> Cc: Geert Uytterhoeven <geert@linux-m68k.org>
> Cc: Jiri Olsa <olsajiri@gmail.com>
> Cc: Lorenzo Stoakes <ljs@kernel.org>
> Cc: Luis Chamberlain <mcgrof@kernel.org>
> Cc: Masahiro Yamada <masahiroy@kernel.org>
> Cc: Petr Mladek <pmladek@suse.com>
> Cc: Steven Rostedt <rostedt@goodmis.org>
> Cc: Zhen Lei <thunder.leizhen@huawei.com>
> ---
>=20
>  kernel/kallsyms_internal.h |   12 +++++-------
>  scripts/kallsyms.c         |    9 ++++++++-
>  2 files changed, 13 insertions(+), 8 deletions(-)
>=20
> --- a/kernel/kallsyms_internal.h~kallsyms-increase-marker-density-to-16-1=
-to-accelerate-lookups-fix
> +++ a/kernel/kallsyms_internal.h
> @@ -2,18 +2,17 @@
>  #ifndef LINUX_KALLSYMS_INTERNAL_H_
>  #define LINUX_KALLSYMS_INTERNAL_H_
> =20
> +#include <linux/types.h>
> +
>  /*
> - * Provide compile-constants for scripts/kallsyms.c
> - * so it can build the corresponding kallsyms_marker[] table.
> - * and wrap the rest in __KERNEL__
> + * These constants determine the size of the kallsyms_markers array
> + * written by scripts/kallsyms.c during the build.  The symbol values
> + * must be kept in sync.
>   */
>  #define KALLSYMS_MARKER_SHIFT 4
>  #define KALLSYMS_MARKER_SIZE  (1U << KALLSYMS_MARKER_SHIFT)
>  #define KALLSYMS_MARKER_MASK  (KALLSYMS_MARKER_SIZE - 1U)
> =20
> -#ifdef __KERNEL__
> -#include <linux/types.h>
> -
>  extern const int kallsyms_offsets[];
>  extern const u8 kallsyms_names[];
> =20
> @@ -24,6 +23,5 @@ extern const u16 kallsyms_token_index[];
> =20
>  extern const unsigned int kallsyms_markers[];
>  extern const u8 kallsyms_seqs_of_names[];
> -#endif /* __KERNEL__ */
> =20
>  #endif // LINUX_KALLSYMS_INTERNAL_H_
> --- a/scripts/kallsyms.c~kallsyms-increase-marker-density-to-16-1-to-acce=
lerate-lookups-fix
> +++ a/scripts/kallsyms.c
> @@ -29,7 +29,14 @@
> =20
>  #include <xalloc.h>
> =20
> -#include "../kernel/kallsyms_internal.h"
> +/*
> + * These constants determine the size of the marker array filled here,
> + * and they're duplicated in kernel/kallsyms.c, where they're used in
> + * get_symbol_offset().  They must be kept in agreement.
> + */
> +#define KALLSYMS_MARKER_SHIFT 4
> +#define KALLSYMS_MARKER_SIZE  (1U << KALLSYMS_MARKER_SHIFT)
> +#define KALLSYMS_MARKER_MASK  (KALLSYMS_MARKER_SIZE - 1U)
> =20
>  #define ARRAY_SIZE(arr) (sizeof(arr) / sizeof(arr[0]))
> =20
> _
>=20
> Patches currently in -mm which might be from jim.cromie@gmail.com are
>=20
> kallsyms-match-compressed-tokens-on-the-fly-during-binary-search.patch
> kallsyms-increase-marker-density-to-16-1-to-accelerate-lookups.patch
> kallsyms-increase-marker-density-to-16-1-to-accelerate-lookups-fix.patch
> kallsyms-unroll-24-bit-sequence-reconstruction-in-get_symbol_seq.patch
>=20

