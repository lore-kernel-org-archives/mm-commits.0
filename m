Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 316C3139B
	for <mm-commits@vger.kernel.org>; Sat, 12 Jul 2025 08:15:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752308126; cv=none; b=YqS2aG8UX0etEAGON7cJNGN81NeD7Z+g15HfShM4TYQclyscxzQeIbAalNRyBRcl42GVdqFvigPPdtOZCoLx3eUaNr/m88uUe45Qe4f1OFkyzGhnHzbPfwuU3owZd0mD7O3Y8qylWhh2EpnSAGqzWASQFN9Q8q8RqU+/SEIicDg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752308126; c=relaxed/simple;
	bh=lgD+9psZVjFafc0yTcnrjxEtJlaKXl972gL8cKlNnPE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=tU3gm7WrsPchuLRwAvoghX/yMTZwiKRKEvlSW9s84gje/DEhzjtr3hWf0P70BC8sXaZwMQdXtvyptqm/QIgG7bz+o3HB8s9sRcyBEESqLBr0YmkJn8jqguxyzmwIAREDEwDtBlfY0whoGWWRWsg0C4t4rt8tOYcXI8ppJov+4RE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=BxBdPF8R; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="BxBdPF8R"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD427C4CEEF
	for <mm-commits@vger.kernel.org>; Sat, 12 Jul 2025 08:15:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1752308125;
	bh=lgD+9psZVjFafc0yTcnrjxEtJlaKXl972gL8cKlNnPE=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=BxBdPF8ReTHCB7XdZgs2X8tGCbHNLR0CEeitsvQ6dKUo6+4f9KBl8J3nFWM96DAtj
	 GY01jag7ro/1d0eeb1rrU8uIyvEyAMzboxjNgpFLgJr4Zv/8JpBooMlrL50FYSLqcd
	 tfgpbhgyUrjlMSbMT2JJLuPxksip8H4Fz5Oijtd1a+pyhkS0ahHE+osREzSvcHphZ/
	 zsyYr+1gQbM4thODsVssJZqSOSFKkMiYTlB/+isHLl9kqQdtLJXRiEDBSr3uXeHEEi
	 6oGkHuQnpSS5yDHkxWb7XbviXkjog1A5/qpmPGGYtrvP+VlhYBk/2C1mQv2zdGnckv
	 v+Jg9uZLUvrSg==
Received: by mail-oo1-f42.google.com with SMTP id 006d021491bc7-610cbca60cdso1617386eaf.0
        for <mm-commits@vger.kernel.org>; Sat, 12 Jul 2025 01:15:25 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCVEr8oyBi+JhNzjTC+xkFxwh9c4ikclsK6vFmwLjgAbMTzNpEpcoelfDyd6Shx9vjXQqBnw4+ydMspg@vger.kernel.org
X-Gm-Message-State: AOJu0YyQbl4qyAy7SbaxzTWJRQzjUHxyrFesvZdKpagZXIlKnXkDMTrP
	rnzMgCfDIHdsrElCoC4WlIEZUGqpqV7sfHI7BJYlBWMMEYi3RmZABalP9a8Dk5D8b7Ej5xTjmDK
	44VBekh1KsuAsvcqRQ0+NbNcXWA2ubc8=
X-Google-Smtp-Source: AGHT+IGoX/ETb2c1umug5o5ASXdi04oUABEgPQSY/+dsj5K0hQK8RPnaxLsy42sL/1parUhlQSL+LCjQt1lUH3HBx48=
X-Received: by 2002:a05:6820:2715:b0:613:c3e6:10f5 with SMTP id
 006d021491bc7-613e5fc625bmr4417730eaf.5.1752308125063; Sat, 12 Jul 2025
 01:15:25 -0700 (PDT)
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250710215352.A170CC4CEE3@smtp.kernel.org> <CAJZ5v0jEr1kCdQ2C7waM75oFYiPNeqt4fv90mK3=YSgPqgWstw@mail.gmail.com>
 <20250711160617.077fa359b09a337daf9defc8@linux-foundation.org>
In-Reply-To: <20250711160617.077fa359b09a337daf9defc8@linux-foundation.org>
From: "Rafael J. Wysocki" <rafael@kernel.org>
Date: Sat, 12 Jul 2025 10:15:14 +0200
X-Gmail-Original-Message-ID: <CAJZ5v0gfiM=E3ZoV73cKpYE3oVjQT831UUOa0KQxUjp7j9bLRA@mail.gmail.com>
X-Gm-Features: Ac12FXx2Fn_cMZmAkdI59S8sVq8JYVpzZPQhrxagWHfpLApql4UbllVnFHg58f0
Message-ID: <CAJZ5v0gfiM=E3ZoV73cKpYE3oVjQT831UUOa0KQxUjp7j9bLRA@mail.gmail.com>
Subject: Re: + kexec_core-drop-redundant-pm_restore_gfp_mask-call.patch added
 to mm-nonmm-unstable branch
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "Rafael J. Wysocki" <rafael@kernel.org>, mm-commits@vger.kernel.org, 
	rafael.j.wysocki@intel.com, mario.limonciello@amd.com, dyoung@redhat.com, 
	dwmw2@infradead.org, bhe@redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, Jul 12, 2025 at 1:06=E2=80=AFAM Andrew Morton <akpm@linux-foundatio=
n.org> wrote:
>
> On Fri, 11 Jul 2025 10:35:31 +0200 "Rafael J. Wysocki" <rafael@kernel.org=
> wrote:
>
> > On Thu, Jul 10, 2025 at 11:53=E2=80=AFPM Andrew Morton
> > <akpm@linux-foundation.org> wrote:
> > >
> > >
> > > The patch titled
> > >      Subject: kexec_core: Drop redundant pm_restore_gfp_mask() call
> > > has been added to the -mm mm-nonmm-unstable branch.  Its filename is
> > >      kexec_core-drop-redundant-pm_restore_gfp_mask-call.patch
> >
> > This patch depends on
> >
> > https://lore.kernel.org/linux-pm/aHCsUAhqRz5zJH2t@MiWiFi-R3L-srv/
>
> I noticed ;)
>
> > so you need to queue up both or let me queue them up.
>
> Well what's your preference?  This was unknowable from the emails as-sent=
...

Yes, sorry.

I can take care of these patches.  They should not clash with other
changes in kernel_kexec() and they are related to PM.
