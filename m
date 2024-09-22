Received: from mail-ed1-f42.google.com (mail-ed1-f42.google.com [209.85.208.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B16CF2581
	for <mm-commits@vger.kernel.org>; Sun, 22 Sep 2024 16:35:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727022904; cv=none; b=I5POpDqYT2pnPwf8oVCgwkwq/gV4HcevjXfGHJJh7cdQjwOqnsVkeNoDhVxIBb65LdBzhz8nGXOemZzj/LvF9Suh/M+k8ZAuyOP1APQvjEmdEjni5KmPoVg5XiAmzjp9VrSv+fHynFG2Rm0a6q631OOch9b24bqPygvdrQmGd3Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727022904; c=relaxed/simple;
	bh=1YPOfHesH5RVdRJUP5Wt8b62Owi5WSCj403l9mws6B0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=RoT+VGeAwY7B6SEl0tJ7dlOgamem8jJ60ML8gLzoXkYc7WAL1rZvW/BzPwzaHN8315/CLmfvPShJTVjFMHALtTHeF9lIOKpWm6FQQ50PfTf0ec/YrCETcdYZPqiNTpc46zMEmR0uyG0B9LVNjT2KwaW6xMSTZd3IfWrr7vu+pW4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=LBIRjcZM; arc=none smtp.client-ip=209.85.208.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="LBIRjcZM"
Received: by mail-ed1-f42.google.com with SMTP id 4fb4d7f45d1cf-5c42f406e29so5262015a12.2
        for <mm-commits@vger.kernel.org>; Sun, 22 Sep 2024 09:35:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1727022901; x=1727627701; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=PYdVIYLjBwZlAOZe7nqVykViMDFKAIlIkbyf3hUinq0=;
        b=LBIRjcZMWKXxO/lHPEI2VtAXjR2bTflL64qD6mToW5C77xzbyXz7cfQh5m8dT5GkKf
         bHj4SkAqnGpdsKx/DjEMjW9+xlkTM0LHIHZFgS5X+5dfAugftDY3LLb603ceKbQmRRVD
         pPnbMUAKcsa/vNXtXGqUuwY96/qYtVk4r7M9A=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1727022901; x=1727627701;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=PYdVIYLjBwZlAOZe7nqVykViMDFKAIlIkbyf3hUinq0=;
        b=DS1qGW0YNJqrAHILY2qNzHmZiyE9xOYKp5eROAB3GCNAvVkoOpXlgUMJqXdONDrdOC
         +A9wUSR2O+blJqd3hMYfVuf9yOBIbOuFmrIsneDcKGDQUP9xXF0kjPAHPuwlFP2MajgS
         AHgrTDNSdfEF0xQVE7etSfRaEBdLUBgbMyooG6ZBmB0Z06aXszvuW5OKWnVwF793qjNA
         cGNbRJ9ZPhduGk34Nl8UGAdv9ybSHIbQYNq9KWiq0JF9UjgwuELP1xAQfnEuHkB9bSQx
         41dk56dbk4+tOlViBtsBXvVeamuf5XtXlkliCfd5slKl6Mg/2fL1dAGiTzKq4Ca44lxH
         R89w==
X-Forwarded-Encrypted: i=1; AJvYcCURtsqsrqHnDt6jMki5ZG07cstl8Ag0UjBjBnP0i8UBoh4Da2vg4Agbe2ODxRzy3YnadfaC8b4GId1H@vger.kernel.org
X-Gm-Message-State: AOJu0YxZJVmNI6396k8Zb21fHWg/52QUd3o5VM48X7OoplvKsPPiXfUD
	naa2PHOifGozfnJLUyk5RoV8+TcKlT7RKo1PUuVUt969u31/Esou7dGeGqEhgmNprUCRaw1AKDr
	P5/4=
X-Google-Smtp-Source: AGHT+IHm1Wh5ewWK56FmorJmpvCPVhR34q/mF0EG9+FYfrtdiL+D1IN6zg92IIu8aG+G5z+Wr5s4kQ==
X-Received: by 2002:a05:6402:1ec5:b0:5be:cdaf:1c09 with SMTP id 4fb4d7f45d1cf-5c464a5acbemr7239394a12.28.1727022900769;
        Sun, 22 Sep 2024 09:35:00 -0700 (PDT)
Received: from mail-ej1-f48.google.com (mail-ej1-f48.google.com. [209.85.218.48])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-5c42bc8952esm9301966a12.96.2024.09.22.09.34.59
        for <mm-commits@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 22 Sep 2024 09:35:00 -0700 (PDT)
Received: by mail-ej1-f48.google.com with SMTP id a640c23a62f3a-a8d0d0aea3cso488895866b.3
        for <mm-commits@vger.kernel.org>; Sun, 22 Sep 2024 09:34:59 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCWtdOlJs0moqR9fngLlT77wO2LldpK0aZNhosJLKxy5vfkVtqpqO/hMSQA02x2Mpa4OQDdnjVMMugAY@vger.kernel.org
X-Received: by 2002:a17:907:9444:b0:a8d:29b7:ecf3 with SMTP id
 a640c23a62f3a-a90d4fdec7dmr1048951666b.13.1727022899627; Sun, 22 Sep 2024
 09:34:59 -0700 (PDT)
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240920023317.f20c9ecbb2a2f4bf382d831c@linux-foundation.org> <CAMuHMdW-4_WvazciLPedP6R6XnEnHqsEh+3s7M5159zcmHit9w@mail.gmail.com>
In-Reply-To: <CAMuHMdW-4_WvazciLPedP6R6XnEnHqsEh+3s7M5159zcmHit9w@mail.gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Sun, 22 Sep 2024 09:34:42 -0700
X-Gmail-Original-Message-ID: <CAHk-=wjUiO3qUVR6ydhGjby3yf_KQO5+m7Hfb4H09kXXPogZ7g@mail.gmail.com>
Message-ID: <CAHk-=wjUiO3qUVR6ydhGjby3yf_KQO5+m7Hfb4H09kXXPogZ7g@mail.gmail.com>
Subject: Re: [GIT PULL] MM updates for 6.12-rc1
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org, 
	mm-commits@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Huang Ying <ying.huang@intel.com>, Thomas Gleixner <tglx@linutronix.de>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sun, 22 Sept 2024 at 02:32, Geert Uytterhoeven <geert@linux-m68k.org> wr=
ote:
>
>     kernel/resource.c: In function =E2=80=98gfr_start=E2=80=99:
>     ./include/linux/minmax.h:93:30: error: conversion from =E2=80=98long =
long
> unsigned int=E2=80=99 to =E2=80=98resource_size_t=E2=80=99 {aka =E2=80=98=
unsigned int=E2=80=99} changes value
> from =E2=80=9818446744073709551615=E2=80=99 to =E2=80=984294967295=E2=80=
=99 [-Werror=3Doverflow]
>
> Due to
>
>     #define PHYSMEM_END  (-1ULL)
>
> not being correct on 32-bit without LPAE.

Hmm. Can you check if making it be

      #define PHYSMEM_END  ((phys_addr_t)-1)

fixes things for you?

That said, it would probably be even better if we got rid of these
games entirely, and m68k just defined MAX_PHYSMEM_BITS instead. Maybe
as a config option, since I assume it's going to be either 24 or 32
depending on CPU (or are there other choices? I used to know the old
m68k, but...)

                Linus
