Received: from mail-pf1-f181.google.com (mail-pf1-f181.google.com [209.85.210.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9B07155A50
	for <mm-commits@vger.kernel.org>; Wed, 24 Apr 2024 22:54:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713999258; cv=none; b=O927wvjGBzK9ko5M4DMyqklNnSbTgZPeI/WboTf2/BAcgnbLfrb8Z3dEX/WybXR2MarfmQnceB+Y1gKDAHAmk4sCtn8h26tqhQP+fCv2lpO0Bgd5vKpRY+pz0iOBY7yIr1UPnVhWSsj4IhUc5bhgX6juFofqteF6N7fP/lJdLdQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713999258; c=relaxed/simple;
	bh=rKfsp3SnGDJAyRfeFqKI3xdR1C7fPz50yEYuUJIMJ5A=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=K8ba58lUJQp3d3TGFY1IzEzrdnn8nPFaqERIYTRjrN/eW+OddQ9juw57qTaEngPjQTE7iK+RFpwzB950qMnIW6844mA496Dk8jtnqC7VqcH5Y8mNpUW+X0J6lcBzKZkEX9u/olREvTyPnfGDyakCmdQ4uv9B5O46Cw6F/9vGJZw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org; spf=pass smtp.mailfrom=chromium.org; dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b=VZMUpETk; arc=none smtp.client-ip=209.85.210.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chromium.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="VZMUpETk"
Received: by mail-pf1-f181.google.com with SMTP id d2e1a72fcca58-6eddff25e4eso378142b3a.3
        for <mm-commits@vger.kernel.org>; Wed, 24 Apr 2024 15:54:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1713999256; x=1714604056; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=L0rRZ7Mv7ktnv1VMBHOaA8zGgYy6/5Y0fn3RX3TjkZk=;
        b=VZMUpETkj2dR4Xk4BE0u3Go9M1upwbPzOg6VGXXvPZ3CuYlN1Eo5+U8WuQKJ+Ol44+
         lmRLGlMLPMARl5nsFRTrEIv2nZ85IwEQDp21/K5/pdYHY0GEbeP+VYy4/tFUSvZ3vKM2
         prWx0jrEfHC/ja1M0KX5lUKJ6VaMhDcAuzYzY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713999256; x=1714604056;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=L0rRZ7Mv7ktnv1VMBHOaA8zGgYy6/5Y0fn3RX3TjkZk=;
        b=Uc3UIdMmsdBjzyITtBRtNfOqq+kuFGO7xW8BWucgpMANq8L7HcenEF70FxCs9M6LUp
         h40cA9BGe0LXItImFOwjXxG+JuQIq2GpJ2TIAaodXEntyY2UaQzoGc7aGYjZPYZ2VfC6
         GKDOyUHoTP6c6A79JVfcDX5REkDFZeOItNuYo1Gbd58zNuONmhJYlcFWp458qPL3cvL3
         1x7oQQtjT3Z7BSCx59NKIhrfvX0C6wFJI1IhUxWBgOLn/u7BRd0H0IZhdNOhGL9lqeCx
         YEdHuuSZmrjHQQTYs+qMJ4THO3hy842GqlKCDOWbo7ORw5ebYsPN7SG2lHW9ku9fOejB
         u1hw==
X-Gm-Message-State: AOJu0YwFwsznSpsq5aYQeHaZ1vCM6Pbq2P7+Yh0xPz10eHhLDQ2hdgdq
	420zj+dHJ7OffBuEozLTaKK69bV1+ScmLltgyEbIrKlq2DnjWFgNhgbAagYHKg==
X-Google-Smtp-Source: AGHT+IFbKw0r3vQeZHwvymUh4oSqWA6oq6kCqMuIc8N9ne37J8Bh8LDrQfGV71C29073/kKozu6/vw==
X-Received: by 2002:a05:6a00:398d:b0:6eb:3c34:34bd with SMTP id fi13-20020a056a00398d00b006eb3c3434bdmr4776276pfb.3.1713999256075;
        Wed, 24 Apr 2024 15:54:16 -0700 (PDT)
Received: from www.outflux.net ([198.0.35.241])
        by smtp.gmail.com with ESMTPSA id l10-20020a056a00140a00b006ed0d0307aasm11932205pfu.70.2024.04.24.15.54.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Apr 2024 15:54:15 -0700 (PDT)
Date: Wed, 24 Apr 2024 15:54:15 -0700
From: Kees Cook <keescook@chromium.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: mm-commits@vger.kernel.org, viro@zeniv.linux.org.uk, jack@suse.cz,
	ebiederm@xmission.com, brauner@kernel.org, jcmvbkbc@gmail.com
Subject: Re: + binfmt_elf_fdpic-fix-proc-pid-auxv.patch added to
 mm-nonmm-unstable branch
Message-ID: <202404241553.CECB480282@keescook>
References: <20240422220133.65EC9C113CC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240422220133.65EC9C113CC@smtp.kernel.org>

Hi!

Oops, sorry, I've been behind on the execve/binfmt tree reviews. I'll
put this in my tree for -next now. Thanks for the poke!

-Kees

On Mon, Apr 22, 2024 at 03:01:32PM -0700, Andrew Morton wrote:
> 
> The patch titled
>      Subject: binfmt_elf_fdpic: fix /proc/<pid>/auxv
> has been added to the -mm mm-nonmm-unstable branch.  Its filename is
>      binfmt_elf_fdpic-fix-proc-pid-auxv.patch
> 
> This patch will shortly appear at
>      https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/binfmt_elf_fdpic-fix-proc-pid-auxv.patch
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
> *** Remember to use Documentation/process/submit-checklist.rst when testing your code ***
> 
> The -mm tree is included into linux-next via the mm-everything
> branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
> and is updated there every 2-3 working days
> 
> ------------------------------------------------------
> From: Max Filippov <jcmvbkbc@gmail.com>
> Subject: binfmt_elf_fdpic: fix /proc/<pid>/auxv
> Date: Fri, 22 Mar 2024 12:54:18 -0700
> 
> Althought FDPIC linux kernel provides /proc/<pid>/auxv files they are
> empty because there's no code that initializes mm->saved_auxv in the FDPIC
> ELF loader.
> 
> Synchronize FDPIC ELF aux vector setup with ELF.  Replace entry-by-entry
> aux vector copying to userspace with initialization of mm->saved_auxv
> first and then copying it to userspace as a whole.
> 
> Link: https://lkml.kernel.org/r/20240322195418.2160164-1-jcmvbkbc@gmail.com
> Signed-off-by: Max Filippov <jcmvbkbc@gmail.com>
> Cc: Al Viro <viro@ZenIV.linux.org.uk>
> Cc: Christian Brauner <brauner@kernel.org>
> Cc: Eric Biederman <ebiederm@xmission.com>
> Cc: Jan Kara <jack@suse.cz>
> Cc: Kees Cook <keescook@chromium.org>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> ---
> 
>  fs/binfmt_elf_fdpic.c |   90 +++++++++++++++++++---------------------
>  1 file changed, 43 insertions(+), 47 deletions(-)
> 
> --- a/fs/binfmt_elf_fdpic.c~binfmt_elf_fdpic-fix-proc-pid-auxv
> +++ a/fs/binfmt_elf_fdpic.c
> @@ -505,8 +505,9 @@ static int create_elf_fdpic_tables(struc
>  	char *k_platform, *k_base_platform;
>  	char __user *u_platform, *u_base_platform, *p;
>  	int loop;
> -	int nr;	/* reset for each csp adjustment */
>  	unsigned long flags = 0;
> +	int ei_index;
> +	elf_addr_t *elf_info;
>  
>  #ifdef CONFIG_MMU
>  	/* In some cases (e.g. Hyper-Threading), we want to avoid L1 evictions
> @@ -601,44 +602,24 @@ static int create_elf_fdpic_tables(struc
>  	csp -= sp & 15UL;
>  	sp -= sp & 15UL;
>  
> -	/* put the ELF interpreter info on the stack */
> -#define NEW_AUX_ENT(id, val)						\
> -	do {								\
> -		struct { unsigned long _id, _val; } __user *ent, v;	\
> -									\
> -		ent = (void __user *) csp;				\
> -		v._id = (id);						\
> -		v._val = (val);						\
> -		if (copy_to_user(ent + nr, &v, sizeof(v)))		\
> -			return -EFAULT;					\
> -		nr++;							\
> +	/* Create the ELF interpreter info */
> +	elf_info = (elf_addr_t *)mm->saved_auxv;
> +	/* update AT_VECTOR_SIZE_BASE if the number of NEW_AUX_ENT() changes */
> +#define NEW_AUX_ENT(id, val) \
> +	do { \
> +		*elf_info++ = id; \
> +		*elf_info++ = val; \
>  	} while (0)
>  
> -	nr = 0;
> -	csp -= 2 * sizeof(unsigned long);
> -	NEW_AUX_ENT(AT_NULL, 0);
> -	if (k_platform) {
> -		nr = 0;
> -		csp -= 2 * sizeof(unsigned long);
> -		NEW_AUX_ENT(AT_PLATFORM,
> -			    (elf_addr_t) (unsigned long) u_platform);
> -	}
> -
> -	if (k_base_platform) {
> -		nr = 0;
> -		csp -= 2 * sizeof(unsigned long);
> -		NEW_AUX_ENT(AT_BASE_PLATFORM,
> -			    (elf_addr_t) (unsigned long) u_base_platform);
> -	}
> -
> -	if (bprm->have_execfd) {
> -		nr = 0;
> -		csp -= 2 * sizeof(unsigned long);
> -		NEW_AUX_ENT(AT_EXECFD, bprm->execfd);
> -	}
> -
> -	nr = 0;
> -	csp -= DLINFO_ITEMS * 2 * sizeof(unsigned long);
> +#ifdef ARCH_DLINFO
> +	/*
> +	 * ARCH_DLINFO must come first so PPC can do its special alignment of
> +	 * AUXV.
> +	 * update AT_VECTOR_SIZE_ARCH if the number of NEW_AUX_ENT() in
> +	 * ARCH_DLINFO changes
> +	 */
> +	ARCH_DLINFO;
> +#endif
>  	NEW_AUX_ENT(AT_HWCAP,	ELF_HWCAP);
>  #ifdef ELF_HWCAP2
>  	NEW_AUX_ENT(AT_HWCAP2,	ELF_HWCAP2);
> @@ -659,17 +640,32 @@ static int create_elf_fdpic_tables(struc
>  	NEW_AUX_ENT(AT_EGID,	(elf_addr_t) from_kgid_munged(cred->user_ns, cred->egid));
>  	NEW_AUX_ENT(AT_SECURE,	bprm->secureexec);
>  	NEW_AUX_ENT(AT_EXECFN,	bprm->exec);
> -
> -#ifdef ARCH_DLINFO
> -	nr = 0;
> -	csp -= AT_VECTOR_SIZE_ARCH * 2 * sizeof(unsigned long);
> -
> -	/* ARCH_DLINFO must come last so platform specific code can enforce
> -	 * special alignment requirements on the AUXV if necessary (eg. PPC).
> -	 */
> -	ARCH_DLINFO;
> -#endif
> +	if (k_platform) {
> +		NEW_AUX_ENT(AT_PLATFORM,
> +			    (elf_addr_t)(unsigned long)u_platform);
> +	}
> +	if (k_base_platform) {
> +		NEW_AUX_ENT(AT_BASE_PLATFORM,
> +			    (elf_addr_t)(unsigned long)u_base_platform);
> +	}
> +	if (bprm->have_execfd) {
> +		NEW_AUX_ENT(AT_EXECFD, bprm->execfd);
> +	}
>  #undef NEW_AUX_ENT
> +	/* AT_NULL is zero; clear the rest too */
> +	memset(elf_info, 0, (char *)mm->saved_auxv +
> +	       sizeof(mm->saved_auxv) - (char *)elf_info);
> +
> +	/* And advance past the AT_NULL entry.  */
> +	elf_info += 2;
> +
> +	ei_index = elf_info - (elf_addr_t *)mm->saved_auxv;
> +	csp -= ei_index * sizeof(elf_addr_t);
> +
> +	/* Put the elf_info on the stack in the right place.  */
> +	if (copy_to_user((void __user *)csp, mm->saved_auxv,
> +			 ei_index * sizeof(elf_addr_t)))
> +		return -EFAULT;
>  
>  	/* allocate room for argv[] and envv[] */
>  	csp -= (bprm->envc + 1) * sizeof(elf_caddr_t);
> _
> 
> Patches currently in -mm which might be from jcmvbkbc@gmail.com are
> 
> binfmt_elf_fdpic-fix-proc-pid-auxv.patch
> 

-- 
Kees Cook
