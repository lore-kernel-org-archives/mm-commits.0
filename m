Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5F591CF8B
	for <mm-commits@vger.kernel.org>; Sat, 21 Dec 2024 23:34:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734824096; cv=none; b=IZeXiR6OB8LOrO4MA00627XJoWOC/buTmwZc1R1ceckaaoQMX7vmGAvLNGYwyCVNFC7txT0FQgC+T6PRKTD5GAWC/MJzndNylulozKiBB4d5u2I0xfo0Ex4ty6fMyl8KjjxUNnrpKQefSkVMhQztDz7PMJfu5yI9s5CuZksFJHU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734824096; c=relaxed/simple;
	bh=qvCX51AWvY1c/NxP6bkn/g91Zc5beiKw9MPF4a4vcMc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=RkMbjfIcNnzRUpYt6eiUJ9tQsvrPwXUBRer5yGbVkg3EJYq8j4XAYOAxOeDW+f1glJN4VJSVTFM/Kz3+rARLx8+/nhVaqnn40TAHk2ZuAdZ9r9rLrN8VE2XwkWX3G7QT8VWlbaRNtL9u9mAa1GeVxPcd/VyiAwr3ooy6epIaN8I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mJStIwC+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mJStIwC+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 54668C4CED6
	for <mm-commits@vger.kernel.org>; Sat, 21 Dec 2024 23:34:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734824096;
	bh=qvCX51AWvY1c/NxP6bkn/g91Zc5beiKw9MPF4a4vcMc=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=mJStIwC+YFG0U2lTvJqGRekmc2cNcNWsbG6Uanw5T0xj/QYoch/VmB8GVgvLsCUFb
	 9y/t314CtK9m5RBMG8J66+4CPpjWQE16TrlD9MbKK7I+NfNChXjagLWjRbovj3ppjM
	 bH32/gZaOKtVEszBb2tP61/FznR95Xu//AuHIWmaMOsPUEP68nrq6lKqfSN2sHSBny
	 TM76TmfK/v4TuafbbQcJcVB1jtLaP8yvCONxQLAKDYv/rzQh9c8GPycCXMj3qRPtMR
	 YWXgSCiFJqw4FGdPs28iXRIRf3vbI1XORVcjq9OuFTX8EI0rCHGu34rFnd3VJ9Tfkw
	 MeVq0vwRLyDpA==
Received: by mail-lf1-f46.google.com with SMTP id 2adb3069b0e04-53e3778bffdso3414467e87.0
        for <mm-commits@vger.kernel.org>; Sat, 21 Dec 2024 15:34:56 -0800 (PST)
X-Gm-Message-State: AOJu0YxIPBXsl7YBw2xEtXMZTIuFXS4dagTqU/fE4XlokZ/BTlEiQnRE
	t9QaID8t0m3ceMnoAhXWJjKA+v5K6aC2AaE5HoS1l8Wyi8bF0GRqN5PvRF7W2iLcJ3Ab/AG2wco
	NUjgSZmESx6wLa5UJQISny9BnRck=
X-Google-Smtp-Source: AGHT+IHi4E+n7xUTDQGPcX1+Mg84JGLM8cpkrZSxkW2+OltTVgHXnEK0UizEGNFCax3UAyyqAJJncyZBPXdXcmajrO8=
X-Received: by 2002:a05:6512:3194:b0:540:1c67:c7d2 with SMTP id
 2adb3069b0e04-54229582557mr2501038e87.35.1734824094999; Sat, 21 Dec 2024
 15:34:54 -0800 (PST)
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20241206011354.74EC7C4CED1@smtp.kernel.org>
In-Reply-To: <20241206011354.74EC7C4CED1@smtp.kernel.org>
From: Masahiro Yamada <masahiroy@kernel.org>
Date: Sun, 22 Dec 2024 08:34:18 +0900
X-Gmail-Original-Message-ID: <CAK7LNAQTmYWGXGBp-6Htds1anEa=aCnHTZZKEZSj67w6YS=UZw@mail.gmail.com>
Message-ID: <CAK7LNAQTmYWGXGBp-6Htds1anEa=aCnHTZZKEZSj67w6YS=UZw@mail.gmail.com>
Subject: Re: + kbuild-drop-support-for-include-asm-arch-in-headers_checkpl.patch
 added to mm-nonmm-unstable branch
To: Andrew Morton <akpm@linux-foundation.org>
Cc: mm-commits@vger.kernel.org, yury.norov@gmail.com, oleg@redhat.com, 
	nicolas@fjasle.eu, nathan@kernel.org, lukas.bulwahn@gmail.com, 
	linux@rasmusvillemoes.dk, joe@perches.com, dwaipayanray1@gmail.com, 
	arnd@arndb.de, apw@canonical.com, geert+renesas@glider.be
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Andrew,

This has been landed in Linus' tree.
(d67393f4d28ef0544eaf382f1123dcaf56495dc9)

Please drop the patch from your tree.


Masahiro



On Fri, Dec 6, 2024 at 10:13=E2=80=AFAM Andrew Morton <akpm@linux-foundatio=
n.org> wrote:
>
>
> The patch titled
>      Subject: kbuild: drop support for include/asm-<arch> in headers_chec=
k.pl
> has been added to the -mm mm-nonmm-unstable branch.  Its filename is
>      kbuild-drop-support-for-include-asm-arch-in-headers_checkpl.patch
>
> This patch will shortly appear at
>      https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree=
/patches/kbuild-drop-support-for-include-asm-arch-in-headers_checkpl.patch
>
> This patch will later appear in the mm-nonmm-unstable branch at
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
> From: Geert Uytterhoeven <geert+renesas@glider.be>
> Subject: kbuild: drop support for include/asm-<arch> in headers_check.pl
> Date: Thu, 5 Dec 2024 14:20:43 +0100
>
> "include/asm-<arch>" was replaced by "arch/<arch>/include/asm" a long tim=
e
> ago.  All assembler header files are now included using "#include
> <asm/*>", so there is no longer a need to rewrite paths.
>
> Link: https://lkml.kernel.org/r/19fb5b49396239d28020015ba2640d77dacdb6c2.=
1733404444.git.geert+renesas@glider.be
> Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
> Cc: Andy Whitcroft <apw@canonical.com>
> Cc: Arnd Bergmann <arnd@arndb.de>
> Cc: Dwaipayan Ray <dwaipayanray1@gmail.com>
> Cc: Joe Perches <joe@perches.com>
> Cc: Lukas Bulwahn <lukas.bulwahn@gmail.com>
> Cc: Masahiro Yamada <masahiroy@kernel.org>
> Cc: Nathan Chancellor <nathan@kernel.org>
> Cc: Nicolas Schier <nicolas@fjasle.eu>
> Cc: Oleg Nesterov <oleg@redhat.com>
> Cc: Rasmus Villemoes <linux@rasmusvillemoes.dk>
> Cc: Yury Norov <yury.norov@gmail.com>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> ---
>
>  usr/include/headers_check.pl |    4 ----
>  1 file changed, 4 deletions(-)
>
> --- a/usr/include/headers_check.pl~kbuild-drop-support-for-include-asm-ar=
ch-in-headers_checkpl
> +++ a/usr/include/headers_check.pl
> @@ -55,10 +55,6 @@ sub check_include
>                 my $found;
>                 $found =3D stat($dir . "/" . $inc);
>                 if (!$found) {
> -                       $inc =3D~ s#asm/#asm-$arch/#;
> -                       $found =3D stat($dir . "/" . $inc);
> -               }
> -               if (!$found) {
>                         printf STDERR "$filename:$lineno: included file '=
$inc' is not exported\n";
>                         $ret =3D 1;
>                 }
> _
>
> Patches currently in -mm which might be from geert+renesas@glider.be are
>
> checkpatch-update-reference-to-include-asm-arch.patch
> kbuild-drop-support-for-include-asm-arch-in-headers_checkpl.patch
> include-update-references-to-include-asm-arch.patch
>


--=20
Best Regards
Masahiro Yamada
