Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87B452D0C9B;
	Mon, 27 Oct 2025 02:31:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761532295; cv=none; b=oAIOCEC8cPBC2ty3F93nh9HE0pfpRPDnPr/1ggepTgG9MZcSEL9H7zHLwO/ucPxY6TRyCyvZlCm1OG12u1GcYGCEIYkVJtkSTzz3qX4O6lvfKuH04A9In82E1lX0fo+1xeXIPhSdyiTxbjur/SdP3KxUrPTUjxIn7pq+ObnXooM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761532295; c=relaxed/simple;
	bh=gfjCLDjPpdK1r04ZLOu7wnXZELlC/69H8vw3z+BQxMc=;
	h=Date:From:To:Subject:In-Reply-To:References:Message-ID:
	 MIME-Version:Content-Type; b=ca81QLQHwGQcUY0NFq7T+xtUPIuXBpjCX4YxNTko0h82sNxNQZTgWw9DQFuoMs7dKcng3EtDfhJfY222EPZqMdifgI6PJqndqmc4FU7O/OkHEgZUOgkatf+WHYKkxPKzUiatJo+GoTD6fpVxVCVlXz3JU/bFTZi59GW7UZTThlU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jY/aEZ6q; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jY/aEZ6q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E4186C4CEE7;
	Mon, 27 Oct 2025 02:31:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761532295;
	bh=gfjCLDjPpdK1r04ZLOu7wnXZELlC/69H8vw3z+BQxMc=;
	h=Date:From:To:Subject:In-Reply-To:References:From;
	b=jY/aEZ6q/e2RXlXXizf4Bof10iVTbb//X+udvG+O69ahwigo/JA/KaDvhI/Eqjqas
	 wfjrL1sYKzNPmdJJSasZSlJ72+uAeTQnklNDw87l3es5LJIJWHqtJYuJF1iQjovVqH
	 Pjk5slpdMAK+WH5bWI8wcPEK6OVR6HMautqeQQkI5gEhq09JWGGevLpptPJlWFw0rL
	 0QoGY9w7Dd/pTrkgnH85GgVeSJK8ifVilcjCTnKKiEK8+tWVdAB4v171e9DCzfm3Gs
	 rYmTMbA+MvsTcDSpD6Lo9QoNSJGCN1D284PA8a3jXkKvbzSwf7F8cqvpmDsTZETKcK
	 4uwZGyHMPwifA==
Date: Sun, 26 Oct 2025 19:31:31 -0700
From: Kees Cook <kees@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>, mm-commits@vger.kernel.org,
 stable@vger.kernel.org, gustavoars@kernel.org, david.hunter.linux@gmail.com,
 arnd@arndb.de, hannelotta@gmail.com, akpm@linux-foundation.org
Subject: =?US-ASCII?Q?Re=3A_+_headers-add-check-for-c-standard-versi?=
 =?US-ASCII?Q?on=2Epatch_added_to_mm-hotfixes-unstable_branch?=
User-Agent: K-9 Mail for Android
In-Reply-To: <20251026235632.6E245C4CEE7@smtp.kernel.org>
References: <20251026235632.6E245C4CEE7@smtp.kernel.org>
Message-ID: <4FFB0358-0312-45AA-84BD-9249D8CE9C41@kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable



On October 26, 2025 4:56:30 PM PDT, Andrew Morton <akpm@linux-foundation=
=2Eorg> wrote:
>
>The patch titled
>     Subject: headers: add check for C standard version
>has been added to the -mm mm-hotfixes-unstable branch=2E  Its filename is
>     headers-add-check-for-c-standard-version=2Epatch
>
>This patch will shortly appear at
>     https://git=2Ekernel=2Eorg/pub/scm/linux/kernel/git/akpm/25-new=2Egi=
t/tree/patches/headers-add-check-for-c-standard-version=2Epatch
>
>This patch will later appear in the mm-hotfixes-unstable branch at
>    git://git=2Ekernel=2Eorg/pub/scm/linux/kernel/git/akpm/mm
>
>Before you just go and hit "reply", please:
>   a) Consider who else should be cc'ed
>   b) Prefer to cc a suitable mailing list as well
>   c) Ideally: find the original patch on the mailing list and do a
>      reply-to-all to that, adding suitable additional cc's
>
>*** Remember to use Documentation/process/submit-checklist=2Erst when tes=
ting your code ***
>
>The -mm tree is included into linux-next via the mm-everything
>branch at git://git=2Ekernel=2Eorg/pub/scm/linux/kernel/git/akpm/mm
>and is updated there every 2-3 working days
>
>------------------------------------------------------
>From: Hanne-Lotta M=EF=BF=BD=EF=BF=BDenp=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=
=BD <hannelotta@gmail=2Ecom>
>Subject: headers: add check for C standard version
>Date: Sun, 26 Oct 2025 21:58:46 +0200
>
>Compiling the kernel with GCC 15 results in errors, as with GCC 15 the
>default language version for C compilation has been changed from
>-std=3Dgnu17 to -std=3Dgnu23 - unless the language version has been chang=
ed
>using
>
>    KBUILD_CFLAGS +=3D -std=3Dgnu17
>
>or earlier=2E
>
>C23 includes new keywords 'bool', 'true' and 'false', which cause
>compilation errors in Linux headers:
>
>    =2E/include/linux/types=2Eh:30:33: error: `bool' cannot be defined
>        via `typedef'
>
>    =2E/include/linux/stddef=2Eh:11:9: error: cannot use keyword `false'
>        as enumeration constant
>
>Add check for C Standard's version in the header files to be able to
>compile the kernel with C23=2E

What? These are internal headers, not UAPI=2E We build Linux with -std=3Dg=
nu11=2E Let's not add meaningless version checks=2E

-Kees

>
>Link: https://lkml=2Ekernel=2Eorg/r/20251026195846=2E69740-1-hannelotta@g=
mail=2Ecom
>Signed-off-by: Hanne-Lotta M=EF=BF=BD=EF=BF=BDenp=EF=BF=BD=EF=BF=BD=EF=BF=
=BD=EF=BF=BD <hannelotta@gmail=2Ecom>
>Cc: David Hunter <david=2Ehunter=2Elinux@gmail=2Ecom>
>Cc: "Gustavo A=2E R=2E Silva" <gustavoars@kernel=2Eorg>
>Cc: Kees Cook <kees@kernel=2Eorg>
>Cc: Arnd Bergmann <arnd@arndb=2Ede>
>Cc: <stable@vger=2Ekernel=2Eorg>
>Signed-off-by: Andrew Morton <akpm@linux-foundation=2Eorg>
>---
>
> include/linux/stddef=2Eh |    2 ++
> include/linux/types=2Eh  |    2 ++
> 2 files changed, 4 insertions(+)
>
>--- a/include/linux/stddef=2Eh~headers-add-check-for-c-standard-version
>+++ a/include/linux/stddef=2Eh
>@@ -7,10 +7,12 @@
> #undef NULL
> #define NULL ((void *)0)
>=20
>+#if !defined(__STDC_VERSION__) || __STDC_VERSION__ < 202311L
> enum {
> 	false	=3D 0,
> 	true	=3D 1
> };
>+#endif
>=20
> #undef offsetof
> #define offsetof(TYPE, MEMBER)	__builtin_offsetof(TYPE, MEMBER)
>--- a/include/linux/types=2Eh~headers-add-check-for-c-standard-version
>+++ a/include/linux/types=2Eh
>@@ -32,7 +32,9 @@ typedef __kernel_timer_t	timer_t;
> typedef __kernel_clockid_t	clockid_t;
> typedef __kernel_mqd_t		mqd_t;
>=20
>+#if !defined(__STDC_VERSION__) || __STDC_VERSION__ < 202311L
> typedef _Bool			bool;
>+#endif
>=20
> typedef __kernel_uid32_t	uid_t;
> typedef __kernel_gid32_t	gid_t;
>_
>
>Patches currently in -mm which might be from hannelotta@gmail=2Ecom are
>
>headers-add-check-for-c-standard-version=2Epatch
>

--=20
Kees Cook
