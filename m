Received: from mail-yw1-f170.google.com (mail-yw1-f170.google.com [209.85.128.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 589D512B63;
	Mon, 23 Sep 2024 08:09:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727078984; cv=none; b=RjC1GwCnW6S5/Xq5vx1EliG3neznpwyovRC4zFOCaRiWCdmmy+zBO8562UNaIWXozxDaCfm6gs+poD9aCBlMrCjZxRaNL0MlKjyGXUyoJ1GGBzsyyriZunp3/4cPUqnoF4cxEDuE+qbwxdVT/WX1DniwSNenQ8cI6KDuhD+YjDk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727078984; c=relaxed/simple;
	bh=2oCoAamTl23tvB7DpmO/hzKdR4ddgZhgnAs4YN6S9/Y=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=B4SmUxz46kXvrwCOZNLuzEOY0nZmX4InbJ6QE1aEax+tFt4J3TKjkdGww9mc29KRwB8zVhK0e4jK4FPTDIw9vZRysLcqbMLYduQvbM6aqTmB7lbCkN39ec9PvuNPxnAVMXxjAnWo2Tc8dJNK/iNIhK2z3wZkRa4xY7vYCUehNXk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-m68k.org; spf=pass smtp.mailfrom=gmail.com; arc=none smtp.client-ip=209.85.128.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-m68k.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-yw1-f170.google.com with SMTP id 00721157ae682-6ddceaaa9ddso33077187b3.1;
        Mon, 23 Sep 2024 01:09:42 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1727078980; x=1727683780;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=wVY9Ax26xUoEWznErAID4sAsODNFBa3xi8aRIp4xJOM=;
        b=VFGNJzeMBr2wDFaY3Ft3SY++hDJZfkgUMAfwXRQCr0tItskXnFnXRxzgZIIp/OoAhg
         Zxb7TO7pEvmltPQIdZh+3FrnySrPT0qIvqu6H4yRTAJRUW0Y39yUwjQwUGoKn98hqlH/
         3tEICR/yiGtqTDAzN4+XUkoG8TByYkqzxA9YvvoT+Css/ppMR3x2nrE0Xn88OskKPL6M
         DYHAjhVPuSxNJ4CwRzCGlHWGEUTVttRrK6KtO0HF77Q90TarKPw7mVLFZ3mPRvHWPZCf
         89S2Pd5jCANJqM5jbdof9Zo8KRpUEamh0knQcdYTqeqgUkWiSplBpWpVJfgGNbiRzZOh
         u5xA==
X-Forwarded-Encrypted: i=1; AJvYcCVBjinRctOly3HXiSF7rwDmUmRqs0jJfQNnE2TBGJ66AxCAZ3TIjoF21YaHfDQ8l9+GYBrzKJ7K7hWFOpw=@vger.kernel.org, AJvYcCVSbOuBYCxAgpsaXThKxQPKjcZ4pRdbOr80ejNoUnagMr6oU/nXy+gdX2jHIOZZDgBVBTlTI8T2VpgS9w==@vger.kernel.org
X-Gm-Message-State: AOJu0YyWFRWn71XwxEoCigk0aITNTGFpU2zfSwh0lZamgNLjlZvCmv4T
	2cgbZpJk8e3BViUWh5gdA0Pis47AUQpcwrLnULhikyCT9SyeV/n8A9Qo9U7u
X-Google-Smtp-Source: AGHT+IGPXcalhm2A5oNYJ6gWuWSG6lr3aQlrZFkkp5/cbMPU3DKyCQr7gwmSZH/bHcDIaFKrAmN78w==
X-Received: by 2002:a05:690c:4711:b0:6db:cd39:4dae with SMTP id 00721157ae682-6dfeeed0d14mr59808827b3.33.1727078980355;
        Mon, 23 Sep 2024 01:09:40 -0700 (PDT)
Received: from mail-yw1-f175.google.com (mail-yw1-f175.google.com. [209.85.128.175])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-6dde9fec28esm22865747b3.42.2024.09.23.01.09.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 23 Sep 2024 01:09:40 -0700 (PDT)
Received: by mail-yw1-f175.google.com with SMTP id 00721157ae682-6b747f2e2b7so30238847b3.3;
        Mon, 23 Sep 2024 01:09:40 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCUfT4JUuEH3wGDyZXMl8gQg58Nv4Xg+setItgqXampNHX8nLerGyW7bSnSWp2JH/OMT/aFBJEPaCH/g1XQ=@vger.kernel.org, AJvYcCW/Wek+nS3PFEra8yW8wT+0vqbf/9c/uQn8SpofyFZsOlgunX2XnUlVsjyfkFnxZSQc62hgaG350gelDg==@vger.kernel.org
X-Received: by 2002:a05:690c:b8e:b0:6d3:4c37:d652 with SMTP id
 00721157ae682-6dfeed618admr92197177b3.24.1727078979858; Mon, 23 Sep 2024
 01:09:39 -0700 (PDT)
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240920023317.f20c9ecbb2a2f4bf382d831c@linux-foundation.org>
 <CAMuHMdW-4_WvazciLPedP6R6XnEnHqsEh+3s7M5159zcmHit9w@mail.gmail.com> <CAHk-=wjUiO3qUVR6ydhGjby3yf_KQO5+m7Hfb4H09kXXPogZ7g@mail.gmail.com>
In-Reply-To: <CAHk-=wjUiO3qUVR6ydhGjby3yf_KQO5+m7Hfb4H09kXXPogZ7g@mail.gmail.com>
From: Geert Uytterhoeven <geert@linux-m68k.org>
Date: Mon, 23 Sep 2024 10:09:28 +0200
X-Gmail-Original-Message-ID: <CAMuHMdU3mfA_SuPqw8ZjkECnP456R=K49fg2yHdOznrSzvTjAg@mail.gmail.com>
Message-ID: <CAMuHMdU3mfA_SuPqw8ZjkECnP456R=K49fg2yHdOznrSzvTjAg@mail.gmail.com>
Subject: Re: [GIT PULL] MM updates for 6.12-rc1
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org, 
	mm-commits@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Huang Ying <ying.huang@intel.com>, Thomas Gleixner <tglx@linutronix.de>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Linus,

On Sun, Sep 22, 2024 at 6:35=E2=80=AFPM Linus Torvalds
<torvalds@linux-foundation.org> wrote:
> On Sun, 22 Sept 2024 at 02:32, Geert Uytterhoeven <geert@linux-m68k.org> =
wrote:
> >     kernel/resource.c: In function =E2=80=98gfr_start=E2=80=99:
> >     ./include/linux/minmax.h:93:30: error: conversion from =E2=80=98lon=
g long
> > unsigned int=E2=80=99 to =E2=80=98resource_size_t=E2=80=99 {aka =E2=80=
=98unsigned int=E2=80=99} changes value
> > from =E2=80=9818446744073709551615=E2=80=99 to =E2=80=984294967295=E2=
=80=99 [-Werror=3Doverflow]
> >
> > Due to
> >
> >     #define PHYSMEM_END  (-1ULL)
> >
> > not being correct on 32-bit without LPAE.
>
> Hmm. Can you check if making it be
>
>       #define PHYSMEM_END  ((phys_addr_t)-1)
>
> fixes things for you?

That fixes the warning/error, as expected.

> That said, it would probably be even better if we got rid of these
> games entirely, and m68k just defined MAX_PHYSMEM_BITS instead. Maybe
> as a config option, since I assume it's going to be either 24 or 32
> depending on CPU (or are there other choices? I used to know the old
> m68k, but...)

Indeed, on 68000 and 68008 it could be 24 resp. 20 ;-)
But all systems with a MMU (and even MC68328 without MMU) do support
a 32-bit external address space, so 32 seems fine.

BTW, other 32-bit architectures are suffering from the same issue
(kisskb shows mips, xtensa, parisc, powerpc failures).

BTW2, the following may not work with the default PHYSMEM_END due
to integer overflow, on both 32-bit and 64-bit:

mm/sparse.c:    unsigned long max_sparsemem_pfn =3D (PHYSMEM_END + 1) >>
PAGE_SHIFT;

Gr{oetje,eeting}s,

                        Geert

--=20
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k=
.org

In personal conversations with technical people, I call myself a hacker. Bu=
t
when I'm talking to journalists I just say "programmer" or something like t=
hat.
                                -- Linus Torvalds
