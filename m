Received: from out3-smtp.messagingengine.com (out3-smtp.messagingengine.com [66.111.4.27])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13DCE14A86
	for <mm-commits@vger.kernel.org>; Fri, 22 Dec 2023 10:30:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arndb.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arndb.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=arndb.de header.i=@arndb.de header.b="vKa2pZB3";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="4rJuWUBr"
Received: from compute5.internal (compute5.nyi.internal [10.202.2.45])
	by mailout.nyi.internal (Postfix) with ESMTP id D72755C014B;
	Fri, 22 Dec 2023 05:30:05 -0500 (EST)
Received: from imap51 ([10.202.2.101])
  by compute5.internal (MEProxy); Fri, 22 Dec 2023 05:30:05 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arndb.de; h=cc
	:content-type:content-type:date:date:from:from:in-reply-to
	:in-reply-to:message-id:mime-version:references:reply-to:subject
	:subject:to:to; s=fm1; t=1703241005; x=1703327405; bh=81Rh20VAGj
	K/U2Z+b/cph9clyKq2XEqLaWlA9qwrBBg=; b=vKa2pZB340iyqniX8m0NeVXojn
	Wr8rSCbYoTMuMs+3NFxDv8Dy2O//UM2bbZqKjzIetM6O3+ruooT4fd5C8/AYb/Hs
	KP7RqXMimGtHcInS40QB4XDem/10zon27dF1qOakXlK4ORhc3LYuhfOMCAXQjeY/
	qcH9elMw2tJGxBZQKxhpz42HlmtGWf7iSxlxmjJo+BKqkojOdP14Y7IIn0NDZvKi
	Pg5Kgu4FqUGFVX60Al67v+ImoSuFRWmVWftR3IUamOf9/mrrOsMBd9GrQUDPfQbI
	9rDdQ9L6/8e7JE5c9xmh6MQXnEY2UTr1vS8SZ1yx7o3DGKCKtWLwYvl62xWQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:content-type:content-type:date:date
	:feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
	:message-id:mime-version:references:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
	fm2; t=1703241005; x=1703327405; bh=81Rh20VAGjK/U2Z+b/cph9clyKq2
	XEqLaWlA9qwrBBg=; b=4rJuWUBrh1bmh/jDpe0eZ5IEs0L1ocChLn/38iWAQdIM
	eOIOyd7W6MwCa4ACHVJ/KpGucMpxCUkYKIhs4i+uqfKyVfBbF/LCwO2Whih6eRWx
	oxLr44KH1mIUI3MZxhD+EvAGu+D9ZRaZfZYjKQfUV6HAuW1iwrnA53NsUsoDwAzW
	F+veGHf9iOrs5FhduQbwu44yTh3uDuop3lTf/z3VEfanoeKlRuYKAcTvRDZkynNR
	cVKMJPwvbFoM5H4eHXEXZKMXivUuH4Sc4A6XJlxxToNl2+FLj25BPv/AtFU2fwnJ
	DFsufaUB/KLW+kKEyWy+zN07svChPKXARUbScv/Fkw==
X-ME-Sender: <xms:LWWFZdiGKjVooEbuGMLrU9IV44-6jnHHf3ugI5G3S1M9cIxmb3xq4g>
    <xme:LWWFZSCWV7-2Oa9b63FGhxNjOsl_epd8aLIQxfLRsVcV0A-bQY3ENqeSvNyeabXDK
    uJBKQNNKsrwloZpeZc>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvkedrvddujedgudehucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepofgfggfkjghffffhvffutgesthdtredtreertdenucfhrhhomhepfdetrhhn
    ugcuuegvrhhgmhgrnhhnfdcuoegrrhhnugesrghrnhgusgdruggvqeenucggtffrrghtth
    gvrhhnpeffgeffuddtvdehffefleethfejjeegvdelffejieegueetledvtedtudelgfdu
    gfenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpegrrh
    hnugesrghrnhgusgdruggv
X-ME-Proxy: <xmx:LWWFZdEDDEYYZonnNl3MJYIExy5pHl7K72D2dfjgarvD3Jf2cHbvag>
    <xmx:LWWFZSTSGqb-wZzCSWOsTS9UTzsS83Uogihul24Ifi8pQoux2cXhiQ>
    <xmx:LWWFZayVq_-LmJsKdN3BQ8GpuMbGRvupAifeB4Hxldj2qS22HQ9_Jg>
    <xmx:LWWFZV8su7md0EMN0aHIkutT748qu-WKvLj8erN55fCINtyCVnKskQ>
Feedback-ID: i56a14606:Fastmail
Received: by mailuser.nyi.internal (Postfix, from userid 501)
	id 2CE12B6008D; Fri, 22 Dec 2023 05:30:05 -0500 (EST)
X-Mailer: MessagingEngine.com Webmail Interface
User-Agent: Cyrus-JMAP/3.9.0-alpha0-1364-ga51d5fd3b7-fm-20231219.001-ga51d5fd3
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Message-Id: <ce68eb27-420b-467f-8b1a-e285b94bba79@app.fastmail.com>
In-Reply-To: <20231222062640.70D05C433C9@smtp.kernel.org>
References: <20231222062640.70D05C433C9@smtp.kernel.org>
Date: Fri, 22 Dec 2023 10:29:28 +0000
From: "Arnd Bergmann" <arnd@arndb.de>
To: "Andrew Morton" <akpm@linux-foundation.org>, mm-commits@vger.kernel.org,
 "Stephen Rothwell" <sfr@canb.auug.org.au>,
 "David S . Miller" <davem@davemloft.net>,
 "Andreas Larsson" <andreas@gaisler.com>
Subject: Re: + arch-sparc-fix-up-fallout-from-enabling-wmissing-prototypes.patch added
 to mm-nonmm-unstable branch
Content-Type: text/plain

On Fri, Dec 22, 2023, at 06:26, Andrew Morton wrote:
> ------------------------------------------------------
> From: Andrew Morton <akpm@linux-foundation.org>
> Subject: sparc64: fix up fallout from enabling -Wmissing-prototypes
> Date: Thu Dec 21 04:33:25 PM PST 2023
>
> Fix sparc64 allmodconfig build errors caused by enabling
> -Wmissing-prototypes.
>
> - Symbols only used from assembly were given local prototypes
>
> - A couple of missing inclusions were added
>
> - Define some functions to be static
>
> - vmemmap_free() is only needed if CONFIG_MEMORY_HOTPLUG
>
> - add new arch/sparc/include/asm/irq_work.h for arch_irq_work_raise()
>
> - move prom_cif_init() prototype to header, fix longstanding
>   prom_cif_init() borkage.
>
> - various function declarations were moved from .c into shared .h
>
> Fixes: c6345dfa6e3e ("Makefile.extrawarn: turn on missing-prototypes globally")
> Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
> Cc: Arnd Bergmann <arnd@arndb.de>
> Cc: "David S. Miller" <davem@davemloft.net>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>

Thank you for addressing the warnings!

I don't think there are any build errors after commit 0f0d2871e78d
("arch: turn off -Werror for architectures with known warnings"),
which you have merged already.

While I did consider fixing all the warnings reported by kernelci,
I stopped once I got to configurations for rare hardware (mips and arc,
which should have clean working defconfig and allmodconfig builds)
and architectures that already had existing warnings and are not
actively taken care of.

We are currently discussing changes to the arch/sparc/ maintainership
and Andreas Larsson has already volunteered to help out there, but
we still need to set this up and hopefully get an Ack from Dave.

> a/arch/sparc/vdso/vclock_gettime.c~arch-sparc-fix-up-fallout-from-enabling-wmissing-prototypes
> +++ a/arch/sparc/vdso/vclock_gettime.c
> @@ -250,6 +250,8 @@ notrace static int do_monotonic_coarse(s
>  	return 0;
>  }
> 
> +int __vdso_clock_gettime(clockid_t clock, struct __kernel_old_timespec *ts);
> +
>  notrace int
>  __vdso_clock_gettime(clockid_t clock, struct __kernel_old_timespec *ts)

I already merged a patch in the asm-generic tree that addresses the
vdso warnings across all architectures with a common declaration in
include/vdso/gettime.h, but I had intentionally left arch/sparc and
arch/um because there is a larger issue with their 32-bit VDSO
implementation.

To fix this properly, the VDSO should be changed to add support for
clock_gettime64() and use the same prototypes as the other
architectures. I would prefer to either leave the exsiting warning
here, or at least at an explicit #warning about the missing time64
support like we have for the missing clone3() syscall on sparc and
others. Both of these should be addressed eventually for long-term
maintainability, but there are some more important patches that
Andreas and others already have for sparc.

> a/arch/sparc/kernel/asm-offsets.c~arch-sparc-fix-up-fallout-from-enabling-wmissing-prototypes
> +++ a/arch/sparc/kernel/asm-offsets.c
> @@ -19,6 +19,7 @@
>  #include <asm/hibernate.h>
> 
>  #ifdef CONFIG_SPARC32
> +int sparc32_foo(void);
>  int sparc32_foo(void)
>  {
>  	DEFINE(AOFF_thread_fork_kpsr,
> @@ -26,6 +27,7 @@ int sparc32_foo(void)
>  	return 0;
>  }
>  #else
> +int sparc64_foo(void);
>  int sparc64_foo(void)
>  {
>  #ifdef CONFIG_HIBERNATION
> @@ -45,6 +47,7 @@ int sparc64_foo(void)
>  }
>  #endif
> 
> +int foo(void);
>  int foo(void)
>  {
>  	BLANK();
> @@ -57,4 +60,3 @@ int foo(void)
>  	/* DEFINE(NUM_USER_SEGMENTS, TASK_SIZE>>28); */
>  	return 0;
>  }

These are fixed in the asm-generic tree by making the functions
'static __used', same as on other architectures, so I would suggest
dropping this hunk to avoid conflicts between the two patches.

The other changes look good to me. 

      Arnd
