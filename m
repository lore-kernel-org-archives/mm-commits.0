Received: from mail-lf1-f52.google.com (mail-lf1-f52.google.com [209.85.167.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41F8322EE0
	for <mm-commits@vger.kernel.org>; Wed, 17 Jan 2024 17:47:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705513668; cv=none; b=ZUiUaaxFabF3222RY/VzPMkUfz5QXpJiuvc63EeDzUYo10O5Q0FzLCPr+/z1DjE94Ka+KahrmA1BJDuBctCueoAdwoa74ztWFxemjtzAAfXpS/o/+bh9OQBKfo1g8YwKoXLodh8BFm1BLsXQA3sVmG6Dgzjh3uxjMhM0IcQfNe4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705513668; c=relaxed/simple;
	bh=Q7VkRe0LP/PygPAmL4zwGugP73KCwoHeN/ndiardtLA=;
	h=Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Google-Smtp-Source:X-Received:MIME-Version:
	 References:In-Reply-To:From:Date:Message-ID:Subject:To:Cc:
	 Content-Type:Content-Transfer-Encoding; b=J/ki5yMMcY3+J50Lq1T4Dpjp9RL9sRD2MzO0YLC2UXWFri/KRCytw2NA3qlhfQRpoGnPwSZXcU/3tM2j0dtwB3sovUSTyP/ZQCCAnEdZgLp3pd9D8cYUkvyj/XqE/snMC+ikMhOwPFFmp+r8hGIz4bBJDuuFLHaPW4ATq/vXJ9E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=g3w6JSUF; arc=none smtp.client-ip=209.85.167.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="g3w6JSUF"
Received: by mail-lf1-f52.google.com with SMTP id 2adb3069b0e04-50e766937ddso12900107e87.3
        for <mm-commits@vger.kernel.org>; Wed, 17 Jan 2024 09:47:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1705513665; x=1706118465; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=6PU/+8w7zaQkoPcSpoD/jqCAVzjSBUkrtIpJF4zAwLE=;
        b=g3w6JSUFwctjhjSLOMW9h7az5daKL9GtPh5TB+wShcyRxzMEje3HWYw0xBC5LqUPfa
         9lF5s0y/zo9PqEFtM2Ro3LnXDMQAHMF2Y+uniwv2y2dAB2zZQESwcRDPSfJjxJ6R1Zq+
         AgzDoevDIr3zUBXngJbGtN98BERPjRozkuXzQvC7X66eZ+6DZnvuL3dlGvsxNLREob6x
         jvfz5tOG3oSelGPiJ/86aU0wrtWgW+Ftewsgxqe6dnZvObb72hkFa2NwAZnjfrDjYVUR
         h152UGAShty/1ohFl6nD7qFU0ROFKuQgjitXVPFZvkUKwjYyD5US2921dUdbY211Q5iN
         aysw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1705513665; x=1706118465;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=6PU/+8w7zaQkoPcSpoD/jqCAVzjSBUkrtIpJF4zAwLE=;
        b=rnFAChJnNviIkwDIPDZZm8QlspoHKI13O6jjlt5DA2tF1o0AOrSva+kH7eEsrKODll
         9lBlPgu+g60H8Nn8wo2FBs1/KHxQQsrqqsXmI9Tl4oQAYmuwtnD60yLmpxPVAaFZOapJ
         Pbi65L+tq9VrMKEzo9Yd/nGcLHDHC076EoWCqIpmk1b8mqnGO1OUToQsh9wPKWLevf5M
         Y5gU3p6NDmsY0JPWqSCsv3A4wSjQfv5LMSDB+IDSRKcpyVkfKu9cA0VNGaE9qsOxcNu2
         7WoGuewooxPldMFxKasrCBwL51/9XIDMTG6rLuFrZdh2pxZpn1B+UZSVq6kUThixgKdl
         qLpw==
X-Gm-Message-State: AOJu0YxsBV72SeJ2e0LR7oyGabBF6GLAdj19UBdX/16Bt1PtTZRzRgRH
	BV9p0v2Z2DNQQwfSiStU6h4X/otGaVt0g8wn56I=
X-Google-Smtp-Source: AGHT+IEKANzhwzxe2Tz063jRV8zIM29qTiI1SVIlGKBZVZtSrybO5G0e4/pFt9muGu01YbrhmL6Xm9AVJ1tuRrQPYGo=
X-Received: by 2002:ac2:5f8f:0:b0:50e:d636:6be8 with SMTP id
 r15-20020ac25f8f000000b0050ed6366be8mr4213942lfe.48.1705513664823; Wed, 17
 Jan 2024 09:47:44 -0800 (PST)
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240110160755.3E20BC433C7@smtp.kernel.org> <ZZ7e3xbIKfVa3yqd@yury-ThinkPad>
 <ZagEHj9v9n9M80YW@gmail.com>
In-Reply-To: <ZagEHj9v9n9M80YW@gmail.com>
From: Yury Norov <yury.norov@gmail.com>
Date: Wed, 17 Jan 2024 09:47:33 -0800
Message-ID: <CAAH8bW9-=uRZdb_BgH12T0twDA3mns6=Z1xdwsqw1T3gLyPSPQ@mail.gmail.com>
Subject: Re: + lib-group_cpus-rework-group_cpus_evenly.patch added to
 mm-nonmm-unstable branch
To: Breno Leitao <leitao@debian.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, mm-commits@vger.kernel.org, 
	tglx@linutronix.de, ming.lei@redhat.com, linux@rasmusvillemoes.dk, 
	andriy.shevchenko@linux.intel.com, Nathan Chancellor <nathan@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Jan 17, 2024 at 8:45=E2=80=AFAM Breno Leitao <leitao@debian.org> wr=
ote:
>
> Hello Yury,
>
> On Wed, Jan 10, 2024 at 10:15:59AM -0800, Yury Norov wrote:
> > diff --git a/lib/group_cpus.c b/lib/group_cpus.c
> > index 3a0db0f51f09..c9c95b21e6c6 100644
> > --- a/lib/group_cpus.c
> > +++ b/lib/group_cpus.c
> > @@ -353,8 +353,8 @@ struct cpumask *group_cpus_evenly(unsigned int numg=
rps)
> >  {
> >       cpumask_var_t *node_to_cpumask __free(free_node_to_cpumask) =3D a=
lloc_node_to_cpumask();
> >       struct cpumask *masks __free(kfree) =3D kcalloc(numgrps, sizeof(*=
masks), GFP_KERNEL);
> > -     cpumask_var_t npresmsk __free(free_cpumask_var);
> > -     unsigned int curgrp, nr_present, nr_others;
> > +     cpumask_var_t npresmsk __free(free_cpumask_var) =3D NULL;
>
> I am testing the akpm's mm-everything branch, and I am seeing this
> compilation error when compiling with clang.
>
>         lib/group_cpus.c: In function =E2=80=98group_cpus_evenly=E2=80=99=
:
>         ./include/linux/stddef.h:8:14: error: invalid initializer
>          #define NULL ((void *)0)
>                       ^
>         lib/group_cpus.c:356:52: note: in expansion of macro =E2=80=98NUL=
L=E2=80=99
>           cpumask_var_t npresmsk __free(free_cpumask_var) =3D NULL;
>                                                             ^~~~
> It seems related to this patch. Are you aware of it?
>
> Reverting one of the change above "solves" the error:
>
>         diff --git a/lib/group_cpus.c b/lib/group_cpus.c
>         index c9c95b21e6c6..7644bd99085d 100644
>         --- a/lib/group_cpus.c
>         +++ b/lib/group_cpus.c
>         @@ -353,7 +353,7 @@ struct cpumask *group_cpus_evenly(unsigned in=
t numgrps)
>          {
>                 cpumask_var_t *node_to_cpumask __free(free_node_to_cpumas=
k) =3D alloc_node_to_cpumask();
>                 struct cpumask *masks __free(kfree) =3D kcalloc(numgrps, =
sizeof(*masks), GFP_KERNEL);
>         -       cpumask_var_t npresmsk __free(free_cpumask_var) =3D NULL;
>         +       cpumask_var_t npresmsk __free(free_cpumask_var);
>                 int curgrp, nr_present, nr_others;
>
>                 if (!masks || !node_to_cpumask || !alloc_cpumask_var(&npr=
esmsk, GFP_KERNEL))

Hi Guys,

+ Nathan

Thanks for the reports.

The problem is that cpumask_var_t, depending on OFFSTACK config, may
be declared as
a pointer or as an array, So simply assigning it to NULL as I did in
this problem patch wouldn't
work if OFFSTACK is off. On the other hand, __free() machinery
requires a variable to be
initialized at declaration.

Sorry for this mess, and please allow me a couple days to figure out a
better solution. Either it
would be a macro for initialization, or something else. - I need to experim=
ent.

As a side note, the idea of having different types for the same
variable depending on some
config is not the best, and we'd better avoid it.

Thanks,
Yury
