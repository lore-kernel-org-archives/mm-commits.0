Received: from mail-ej1-f53.google.com (mail-ej1-f53.google.com [209.85.218.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB35619E802
	for <mm-commits@vger.kernel.org>; Mon, 23 Sep 2024 16:14:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727108046; cv=none; b=pbj6pFIAIoelwG35tcZEsMAOcmbQrlk1U5PeWyx1i7V1idWTLjpWlmLW4CGakjECFmVD+lPzHVqh4A4kmJLagNASJSMy3ejt+cFNusq2th3Y65JBqS7kntAvL0akM/73sm1PV1E/GcE30itulynp/PWJ+3oUmmL86VvmKEUkLus=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727108046; c=relaxed/simple;
	bh=/6RBTd3w7D71uF6wj6oQf+CvB5eOPq14lNcQDd8J2rs=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=C7aUHSRSZWjNhuLZheBIUNOiAq46BScZHkAeRXLNJ8vAcfBTw/hEuRGzNnxguynLTB4NH5q6fJtTk3iJyYWyFIYEKHfzp6QgUHbKGqA6kiNb9G+SJPgXem19+zRB8Qf/tm/7RHjjDqvsrXgSkpWih2SW+Q8OPIxTalUjN4pWRzQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=VJjI4ca2; arc=none smtp.client-ip=209.85.218.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="VJjI4ca2"
Received: by mail-ej1-f53.google.com with SMTP id a640c23a62f3a-a8d24f98215so613623466b.1
        for <mm-commits@vger.kernel.org>; Mon, 23 Sep 2024 09:14:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1727108042; x=1727712842; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=KhxyB4gnJFPivYVDIfICHwK2k4/8oKwPbaN8LTyNmkY=;
        b=VJjI4ca2w3IuZxeFk6VJdHCU7BLoIRYxiWfyYKmxACyQNoP01dMtugM05kdM0ktlaA
         oPYKIJxZ0AnoAD4SPPiiMkuxeokru6VqCfsyEIL+/yCdndUErDFdXlnHR+7snIWN+bKx
         LK5qkFjtEHyOambr4VNRnwRnY/1iBav1+iho4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1727108042; x=1727712842;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=KhxyB4gnJFPivYVDIfICHwK2k4/8oKwPbaN8LTyNmkY=;
        b=VZqDGJcdu50O7VbM1JhHCPkieHmADieqVlKlSUqLJXYoXDKthE+Zcc7guGYw94Mbcu
         Tne87gGBWypbS4m+ZyK80oaMzBqtJ120I8TLO2rVAIc57uUt67QWR7FR3ldgNmOP/MVb
         wYI9tLUw1xw48YvvdI3eWdhdyqBQoAb93xd5vYnqyAonj0ZdJ5TQl/wTzijVGG8SoJ7u
         0RtPJb4iqVtiZ3R9TCBQ+5lmNnU6UedT9jsAD9hP+4PVd8L1m/4XFCqzjWvbafzf7A8E
         1lluYMYupiRrOt8bYWuhDfPu2cethzq/WLFGUMgFAt3RbJ0dTHEAdmvoGTSoH/mtmbDk
         hOEg==
X-Forwarded-Encrypted: i=1; AJvYcCX3JVgEeHGkjG2+YLqiCkTPAqJbzZWS+xsQs5wsCUHNqm9M8jYf9bPulDQHT8mJKSskMIkRYa09XDjb@vger.kernel.org
X-Gm-Message-State: AOJu0Yx73oFC7yhF2iMGSF0BUhkDfpJwT4gFeVfPbo3mAowErQR1PjG3
	84UyQrsNxmc5xDZxoQOpFBA58vql4APw9PVjaaFDD2H3i6jGyk1S8wSHkjoTZhMzj59q4Ewk12L
	wyoI=
X-Google-Smtp-Source: AGHT+IEM4MWMTgqOQ4Jl/voya9FlAbQFiM7MgyaEHni/sROKG85X1cCjHkEv9kahPsd5fZsrXH1Giw==
X-Received: by 2002:a17:907:3f25:b0:a8a:ead3:8515 with SMTP id a640c23a62f3a-a90d514a83fmr1224969166b.65.1727108042069;
        Mon, 23 Sep 2024 09:14:02 -0700 (PDT)
Received: from mail-ej1-f51.google.com (mail-ej1-f51.google.com. [209.85.218.51])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a9061096694sm1264428066b.19.2024.09.23.09.14.01
        for <mm-commits@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 23 Sep 2024 09:14:01 -0700 (PDT)
Received: by mail-ej1-f51.google.com with SMTP id a640c23a62f3a-a8d24f98215so613619966b.1
        for <mm-commits@vger.kernel.org>; Mon, 23 Sep 2024 09:14:01 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCXUAM1TueVvbJ0rTlRdfASFZaMf70SUg4ST7O5u7WXkGCvbkTYmap10QTDEQz8h6GFgafxW16g/3K1I@vger.kernel.org
X-Received: by 2002:a17:907:36c8:b0:a8a:91f4:fd30 with SMTP id
 a640c23a62f3a-a90d51098dcmr1410438466b.56.1727108040711; Mon, 23 Sep 2024
 09:14:00 -0700 (PDT)
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240920023317.f20c9ecbb2a2f4bf382d831c@linux-foundation.org>
 <CAMuHMdW-4_WvazciLPedP6R6XnEnHqsEh+3s7M5159zcmHit9w@mail.gmail.com>
 <CAHk-=wjUiO3qUVR6ydhGjby3yf_KQO5+m7Hfb4H09kXXPogZ7g@mail.gmail.com> <CAMuHMdU3mfA_SuPqw8ZjkECnP456R=K49fg2yHdOznrSzvTjAg@mail.gmail.com>
In-Reply-To: <CAMuHMdU3mfA_SuPqw8ZjkECnP456R=K49fg2yHdOznrSzvTjAg@mail.gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Mon, 23 Sep 2024 09:13:44 -0700
X-Gmail-Original-Message-ID: <CAHk-=wh1ZaVh2Tsc9tyXM7O1sL0eArxWHiqszZLj+MWe+f3Pwg@mail.gmail.com>
Message-ID: <CAHk-=wh1ZaVh2Tsc9tyXM7O1sL0eArxWHiqszZLj+MWe+f3Pwg@mail.gmail.com>
Subject: Re: [GIT PULL] MM updates for 6.12-rc1
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org, 
	mm-commits@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Huang Ying <ying.huang@intel.com>, Thomas Gleixner <tglx@linutronix.de>
Content-Type: text/plain; charset="UTF-8"

On Mon, 23 Sept 2024 at 01:09, Geert Uytterhoeven <geert@linux-m68k.org> wrote:
>
> BTW2, the following may not work with the default PHYSMEM_END due
> to integer overflow, on both 32-bit and 64-bit:
>
> mm/sparse.c:    unsigned long max_sparsemem_pfn = (PHYSMEM_END + 1) >>
> PAGE_SHIFT;

Good point.

I've committed a truly disgusting hack, which makes the default
PHYSMEM_END in the absence of a MAX_PHYSMEM_BITS value be

 (a) always a 64-bit type (ie unsigned long long)

 (b) be the maximum value to fit in 'phys_addr_t'

 (c) _but_ with the high bit always clear in 64 bits

so it's basically either 0xffff_ffff or 0x7fff_ffff_ffff_ffff.

The disgusting macro I came up for this for this is

 # define PHYSMEM_END   (((phys_addr_t)-1)&~(1ULL<<63))

and no, I'm not proud of it. This is all horrendous.

We need to fix it properly, with the proper fix probably being to
always have a valid value for MAX_PHYSMEM_BITS (and no, 64 is not a
valid value due to the overflow issue) but the quick hack hopefully
gets the build going.

Of course, I don't have the m68k cross-environment set up, thus the
"hopefully". Let's see if this works.

               Linus
