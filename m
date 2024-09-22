Received: from mail-yw1-f182.google.com (mail-yw1-f182.google.com [209.85.128.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 389511C36;
	Sun, 22 Sep 2024 09:32:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726997573; cv=none; b=fBunyWrakAskA0GXMpdNQRIcDHECzUsSC6mmjTR2ljS+a9PaU2BVG0Z2JBBoFgOIOwY0kUWCHB1rzhLyelb7kSYsv9V/JPgJtc1yvZrCP6qPbwM2d0r7Xg4E4zRQvFq3tXnFk5pDf/ujMDLK7DXlittBwFb2tRvQKUljbn5O3c8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726997573; c=relaxed/simple;
	bh=FwM5SLYTSi9zZ21MKeWYUErueYlIE1NAdEhm4NtmbZw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Ray5UcfsKnY3efwO5+v+/GFiGoyBkLiNfBxXWzfkS942bQkYW1hJpDBm2j/X54tc281YdTPdB/FaaCnLC8786wLyT4I6W8bkO/iSjWh6KN1bV42uXYU4CLqUturgB+7ViHUDC4Sv1woxG4ofQhdwKpcgoi5/Hs5/hHX8MZtmaY8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-m68k.org; spf=pass smtp.mailfrom=gmail.com; arc=none smtp.client-ip=209.85.128.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-m68k.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-yw1-f182.google.com with SMTP id 00721157ae682-6ddccc408e1so24905997b3.3;
        Sun, 22 Sep 2024 02:32:50 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1726997570; x=1727602370;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=4U4EZ4JLzi68rbsVMoW06gkG9VmyNL5CYaj+GPKCLP4=;
        b=sluUSlGa1Kl5WK9L+H7+mCXCWt+/LtzMw4hAO3akxOj4/ZE2gHjPkGclllbEa8SFKh
         Gms/Oa/PF02BL3LINhjDEcBN3/WP0GWIDqFKKtcGEdniWXEArNMk/xnt5weQ2n8ozCUm
         5gTH5OA3Smz3FrL8uphkulBDoE0tJXxe2giJ8JKJfAkyOETWvfV3ezHfz1EyNWTNw6Ea
         ZvR8rL2ygZBNfHO5K4VDbtLUSDdOJhRY2aN5JCcGZEtx1lDGNoS9Fgty9BgoWY3MZ65C
         aJxcZoTGFMIEZOP8g6wc/OWpjD6PncZ1zoxl8T7/Qs3RjOWOG0cNXszS2GwmVlvh94aV
         PRqg==
X-Forwarded-Encrypted: i=1; AJvYcCVVAz03aSMUR8YTiMmp8IaHj0XsPeKmydpDKdc6M46Qhz8glKsrDuCDbKDYy6kYNAZpvWVgzkMBIpEiN04=@vger.kernel.org, AJvYcCXZd4HNdK+taegcS8aOuA+1JWl38ryA/yjo87XjU9LN5dwdGxMwlCK/8tDCcwLkFNYIzIwGgmPjfFRjkw==@vger.kernel.org
X-Gm-Message-State: AOJu0YyJR7/VZXC8SwmTL232EiCsQ86/svlt5xuPF/M26D2k42pDqyDk
	l5lCc+Ut+BMgQFnmvk6yDriut/mKPoD0klyvvaHCgCWDX9QEFEXksOylx9dZCs4=
X-Google-Smtp-Source: AGHT+IHwJzeiaSvG9R/690lywFaral/yf37tFSfPBYdGnzU/gDGlbqqgRyPBEDrJkgPiIOmziO4Kew==
X-Received: by 2002:a05:690c:490f:b0:6db:de34:8049 with SMTP id 00721157ae682-6dfeed31d6emr76452597b3.16.1726997569775;
        Sun, 22 Sep 2024 02:32:49 -0700 (PDT)
Received: from mail-yw1-f182.google.com (mail-yw1-f182.google.com. [209.85.128.182])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-6ddfa73bccesm15479647b3.72.2024.09.22.02.32.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 22 Sep 2024 02:32:48 -0700 (PDT)
Received: by mail-yw1-f182.google.com with SMTP id 00721157ae682-68518bc1407so30226277b3.2;
        Sun, 22 Sep 2024 02:32:48 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCUS/UdA9VbFUUr68HalrWZaAU9BzTCo7BMXfeYdez4WnhFb9h6S5v0lQLbDVMl1d5wc8KebPTH9yBb9hw==@vger.kernel.org, AJvYcCViSFw+xsXw0Bqn3psuESzjAkJHSKlutWFI+PtmpzzhY5Bol+J7USinFJZ1nZ72/XS8WdI55Ko61KJQwXI=@vger.kernel.org
X-Received: by 2002:a05:690c:39a:b0:683:37a8:cd77 with SMTP id
 00721157ae682-6dfeeed10aemr64671227b3.29.1726997568516; Sun, 22 Sep 2024
 02:32:48 -0700 (PDT)
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240920023317.f20c9ecbb2a2f4bf382d831c@linux-foundation.org>
In-Reply-To: <20240920023317.f20c9ecbb2a2f4bf382d831c@linux-foundation.org>
From: Geert Uytterhoeven <geert@linux-m68k.org>
Date: Sun, 22 Sep 2024 11:32:35 +0200
X-Gmail-Original-Message-ID: <CAMuHMdW-4_WvazciLPedP6R6XnEnHqsEh+3s7M5159zcmHit9w@mail.gmail.com>
Message-ID: <CAMuHMdW-4_WvazciLPedP6R6XnEnHqsEh+3s7M5159zcmHit9w@mail.gmail.com>
Subject: Re: [GIT PULL] MM updates for 6.12-rc1
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, linux-mm@kvack.org, 
	mm-commits@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Huang Ying <ying.huang@intel.com>, Thomas Gleixner <tglx@linutronix.de>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Andrew,

On Fri, Sep 20, 2024 at 11:34=E2=80=AFAM Andrew Morton
<akpm@linux-foundation.org> wrote:
> Linus, please merge this cycle's batch of MM updates, thanks.
>
> Conflicts which I'm seeing, along with their linux-next resolutions are
> as follows:

[...]

> kernel/resource.c, vs ea72ce5da228 ("x86/kaslr: Expose and use the end
> of the physical memory address space"):
> https://lkml.kernel.org/r/20240909100043.60668995@canb.auug.org.au

[...]

> A build fix for m68k is needed, vs ea72ce5da228 ("x86/kaslr: Expose and
> use the end of the physical memory address space").  See
> https://lkml.kernel.org/r/87ttenvw0i.fsf@yhuang6-desk2.ccr.corp.intel.com

Which is not sufficient, as kisskb reports for m68k:

    kernel/resource.c: In function =E2=80=98gfr_start=E2=80=99:
    ./include/linux/minmax.h:93:30: error: conversion from =E2=80=98long lo=
ng
unsigned int=E2=80=99 to =E2=80=98resource_size_t=E2=80=99 {aka =E2=80=98un=
signed int=E2=80=99} changes value
from =E2=80=9818446744073709551615=E2=80=99 to =E2=80=984294967295=E2=80=99=
 [-Werror=3Doverflow]

Due to

    #define PHYSMEM_END  (-1ULL)

not being correct on 32-bit without LPAE.
Presumably this should just take into account the actual size of
phys_addr_t. My head is too hazy after Vienna to send a patch now ;-)

I bisected this to 99185c10d5d9214d ("resource, kunit: add test case
for region_intersects()"),  but apparently the offending definition
was modified later in commits ea72ce5da22806d5 ("x86/kaslr:
Expose and use the end of the physical memory address space")
and 617a814f14b89142 ("Merge tag 'mm-stable-2024-09-20-02-31' of
git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm").

> The following changes since commit 431c1646e1f86b949fa3685efc50b660a364c2=
b6:

[...]

> "resource: Fix region_intersects() vs add_memory_driver_managed()" from
> Huang Ying.  Fix a bug in region_intersects() for systems with CXL memory=
.

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
