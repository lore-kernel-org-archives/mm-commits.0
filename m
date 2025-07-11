Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3E9420A5EB
	for <mm-commits@vger.kernel.org>; Fri, 11 Jul 2025 08:35:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752222945; cv=none; b=UMyMflAMcpuqtxgZyQPqsJNQroxCmOzxKBFsityHNtRcgR/Pp0rsN97ig74RATpsXalCC1itGNmHFHD0y3KZFWHsTemQm6QXKmpVZ5vgpB0jnfzZWPoXQQQ+/6U7jt2c3IL9fd6f+4Abcv7cPepFt5SFWIKVefklDhNmToCgJmE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752222945; c=relaxed/simple;
	bh=ttTZqyffybVSEO10cYKxbBRwwmMTybc7GR4B38ModQs=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=S03h3jpxlTrstSE2vzpJbMBKGMHts/OpRQOeN8xk+NpQVazRA7cnbWSEUGMslRQKXNxCRY7ZGfSI3ztJSAdCIf20nLed4kaWXVHBc0aTsTaNGQEjHK0OTNv3JU8v8mWa+90OT8D/9uitfY8cSKhra5G+kotmF2rItffrSxQz57c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hP9M5ocd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hP9M5ocd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B825C4CEF7
	for <mm-commits@vger.kernel.org>; Fri, 11 Jul 2025 08:35:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1752222944;
	bh=ttTZqyffybVSEO10cYKxbBRwwmMTybc7GR4B38ModQs=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=hP9M5ocd/zzXb23c77iavvDWtyQJMbAMGg9BjV4vwp7s4eHUAuUnsUg9d0WEt7UL+
	 INQarRWo6+qP0YngfLQt/CE5RvfkmjJ0eS1I7xt2pEUER3i7oAb0S8uCg4TiO1SwAx
	 jN/Q/Z+CDfoSd5u0ADDyhpSB7nH1Q87/b21NHMRQNxeTqcDfDylkdO8oCeBVZoEFrD
	 jDQkk2i65378U13o6eitWz9YJBfQ7RJp+F8Q62Zdg2euU3MH10Fat+M1d0K/7AETLu
	 3aSIRfoTbbN8O8lNw+6FhZmpgmYLkafTEQiLZHXk/PHbEfu1hjn8OU0Cjqq4G3dziD
	 DZxQ095T2jmsw==
Received: by mail-oi1-f178.google.com with SMTP id 5614622812f47-40a7322f081so589749b6e.3
        for <mm-commits@vger.kernel.org>; Fri, 11 Jul 2025 01:35:44 -0700 (PDT)
X-Gm-Message-State: AOJu0YzHb8oG/fBGnin81XMNwh4E80reTs1V+XX1eoqgzshSWM0VCzNJ
	FmeglCkm+YW1HhDLeQzm3XUoqOgErmqPaz9t8sgFOiCllADSA+IToK3D5bnrVEDi00CWdw6ES3t
	hY9k4VVP/JxmVRkAk+O7QmBW1Sn/FmMc=
X-Google-Smtp-Source: AGHT+IGxFXINXCSpJY08j0HjlG8FOZHM+Cg1JSL7gsPsFsRLVLqR13BBWRVr+GLbotSdAc2pijSbuugW/aGY8AeIVYo=
X-Received: by 2002:a05:6808:1a14:b0:406:5a47:a081 with SMTP id
 5614622812f47-4150dc288e1mr1936965b6e.13.1752222943779; Fri, 11 Jul 2025
 01:35:43 -0700 (PDT)
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250710215352.A170CC4CEE3@smtp.kernel.org>
In-Reply-To: <20250710215352.A170CC4CEE3@smtp.kernel.org>
From: "Rafael J. Wysocki" <rafael@kernel.org>
Date: Fri, 11 Jul 2025 10:35:31 +0200
X-Gmail-Original-Message-ID: <CAJZ5v0jEr1kCdQ2C7waM75oFYiPNeqt4fv90mK3=YSgPqgWstw@mail.gmail.com>
X-Gm-Features: Ac12FXxMF_iWF6bEchrx9Hao0wNWZSLn7T9C51u7iVomgVF4VqFAPVT5k8wthBE
Message-ID: <CAJZ5v0jEr1kCdQ2C7waM75oFYiPNeqt4fv90mK3=YSgPqgWstw@mail.gmail.com>
Subject: Re: + kexec_core-drop-redundant-pm_restore_gfp_mask-call.patch added
 to mm-nonmm-unstable branch
To: Andrew Morton <akpm@linux-foundation.org>
Cc: mm-commits@vger.kernel.org, rafael.j.wysocki@intel.com, 
	mario.limonciello@amd.com, dyoung@redhat.com, dwmw2@infradead.org, 
	bhe@redhat.com, rafael@kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Jul 10, 2025 at 11:53=E2=80=AFPM Andrew Morton
<akpm@linux-foundation.org> wrote:
>
>
> The patch titled
>      Subject: kexec_core: Drop redundant pm_restore_gfp_mask() call
> has been added to the -mm mm-nonmm-unstable branch.  Its filename is
>      kexec_core-drop-redundant-pm_restore_gfp_mask-call.patch

This patch depends on

https://lore.kernel.org/linux-pm/aHCsUAhqRz5zJH2t@MiWiFi-R3L-srv/

so you need to queue up both or let me queue them up.

Thanks!

> This patch will shortly appear at
>      https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree=
/patches/kexec_core-drop-redundant-pm_restore_gfp_mask-call.patch
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
> From: "Rafael J. Wysocki" <rafael@kernel.org>
> Subject: kexec_core: Drop redundant pm_restore_gfp_mask() call
> Date: Thu, 10 Jul 2025 15:12:20 +0200
>
>
> Drop the direct pm_restore_gfp_mask() call from the KEXEC_JUMP flow in
> kernel_kexec() because it is redundant.  Namely, dpm_resume_end()
> called beforehand in the same code path invokes that function and
> it is sufficient to invoke it once.
>
> Link: https://lkml.kernel.org/r/1949230.tdWV9SEqCh@rjwysocki.net
> Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> Cc: Dave Young <dyoung@redhat.com>
> Cc: Baoquan He <bhe@redhat.com>
> Cc: David Woodhouse <dwmw2@infradead.org>
> Cc: Mario Limonciello <mario.limonciello@amd.com>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> ---
>
>  kernel/kexec_core.c |    1 -
>  1 file changed, 1 deletion(-)
>
> --- a/kernel/kexec_core.c~kexec_core-drop-redundant-pm_restore_gfp_mask-c=
all
> +++ a/kernel/kexec_core.c
> @@ -1136,7 +1136,6 @@ int kernel_kexec(void)
>   Resume_devices:
>                 dpm_resume_end(PMSG_RESTORE);
>   Resume_console:
> -               pm_restore_gfp_mask();
>                 console_resume_all();
>                 thaw_processes();
>   Restore_console:
> _
>
> Patches currently in -mm which might be from rafael@kernel.org are
>
> kexec_core-drop-redundant-pm_restore_gfp_mask-call.patch
>
