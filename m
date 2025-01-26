Received: from mail-ej1-f52.google.com (mail-ej1-f52.google.com [209.85.218.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A3DA16F0CF
	for <mm-commits@vger.kernel.org>; Sun, 26 Jan 2025 18:30:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737916207; cv=none; b=B3D0h9Vi0IC4fD/phLmElbe8PjRzgvv27GblbzGilAI6Ung0UNQsIPxCKtU7DUMMt/eYGYuxDV4uvFvOzFet3jvzCUXXdAaTii3HbigYN/poDWQ4Z0HpqBXjl0KfPmO+4xVHmw+pEITa9oWs74/HSf0y/FE5GfdWg1EKNTCu7G0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737916207; c=relaxed/simple;
	bh=AghwpEEw3CNfdkuTexpWojIWYp3tV3xhlXQRcwkdE6g=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=bZqIl1N9iT54t0gGoLj07sWXNjw+meq2N6IvMvVYw8NRbIaGaHhafcQl/HKjdnM0IzOCmMpINcx5tsdlO0xhD5sEoXOnIaPYboh6tLqICNjth95AzuXG1uqIgjNeOVbbULKsvmc2W/s/Ruq9h8dtOLwpiOaix9xR4VWQBlKk0C0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=YbeUMEcc; arc=none smtp.client-ip=209.85.218.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="YbeUMEcc"
Received: by mail-ej1-f52.google.com with SMTP id a640c23a62f3a-aaf900cc7fbso596695066b.3
        for <mm-commits@vger.kernel.org>; Sun, 26 Jan 2025 10:30:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1737916203; x=1738521003; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=P3M+AbIbM25cnhkMyx94VOLdqhzLPile/W0OaxM5nIY=;
        b=YbeUMEccKCLXvl24M1vz1cIhWQm+1sQylEdJrkXkzNDcoOy4N4MJhPu5+++ScvRnAr
         gJsqKchx6XsOWxlQQ84Lmpd0TeA/+kg6ig6WHfoCZIHFh6cf98OF/fCvy5FQzB5erIMM
         lDe28u2cvqQg9NqZaWjn31YJEIIEV+Y709eiQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737916203; x=1738521003;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=P3M+AbIbM25cnhkMyx94VOLdqhzLPile/W0OaxM5nIY=;
        b=E0dTvIP9hYSd+/rkB2J7M1NttZKaISr/uuqNtr2D8Ni6dSpvWg9vvA1bVo8F08NWPX
         ssroC4JYxuqsy10N6qGl1KKeKJnqBvJRtj/cdriWGQP11oAtdTVQoQkWz13jISKqSxHp
         8df/9ATAnQYjh9Ze8oiccZ+c5/mdkvsX5EJ6dWxDrj6OA1DRlM7z9M7E9QMqFn96+B42
         3qO10cqNwbh0wI2DUqE/SUD2tgOuGqibhMDfGLwHF6IPBKRdNbRvfq5Xkj1srRBd5ifD
         /2BaH/CEx6aWV+7hi2gRwXeSCg+RP5MmqYZUIMabVdNWfn1WvEWcBwtc5OeSDKNFAbNq
         m6AQ==
X-Forwarded-Encrypted: i=1; AJvYcCU4nBrfTQ+ucb9dirSh3E3cds388gwFKdy/XXdnSw5MDyMqPQHcywRafDONeY7uFDBY7pw5zE4c4SEt@vger.kernel.org
X-Gm-Message-State: AOJu0Yzt/r5TtyvR8MPrQwoCSRd5B5hD5dozKMTB0fZMZD8miGM+owQL
	vRy+9eH/9muVCAr3/rh/mxZrYqw34rMHnhD6iLaJjeS6GL7U0LdSwffMGmN3iKDelbdj1bwqHOx
	28Lo=
X-Gm-Gg: ASbGnctrLJQuHUZ08I3/xHPiUlVLC+CN1Ndo4pbunxXLT8sl7Y7sY6qBuPTifBTElNl
	21vqRegFw4+zcfs4jhx/L52XapJC+yH/+6Os+9CNCXM+ppBFb4KgiZ48JxkBXZsgKEfrQ2DexA8
	PNRV1z5v3VwiXH66LNQCxZVzC6DmZVpHi8Oeey69imDV2wDu3N4RLs4u7TmmfGBVVPPvgd+o1Jb
	w/JL1hcV+7bRQzwPvhPoOXePxUCVr2cP/HgwkSo3rkVEbWKSx4qgl9MCkDGeUBayNnI2n7hAP/A
	IoBos3xbDnbdf+udUPgqKk6to6KjmKy9yU+BDCqjVjMpvsuzwhk8roU=
X-Google-Smtp-Source: AGHT+IEP9/0Hxt1hae/U/MQz2eCW2spPop1SY+3okUF1KXqLWzDF7GUZ/tfiPdGXpJt3HZshuSx81A==
X-Received: by 2002:a17:907:3f90:b0:ab3:84ac:4dbc with SMTP id a640c23a62f3a-ab38ada1518mr3567691866b.0.1737916203279;
        Sun, 26 Jan 2025 10:30:03 -0800 (PST)
Received: from mail-ed1-f54.google.com (mail-ed1-f54.google.com. [209.85.208.54])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ab675e11ecesm456605366b.26.2025.01.26.10.30.02
        for <mm-commits@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 26 Jan 2025 10:30:02 -0800 (PST)
Received: by mail-ed1-f54.google.com with SMTP id 4fb4d7f45d1cf-5d647d5df90so6141663a12.2
        for <mm-commits@vger.kernel.org>; Sun, 26 Jan 2025 10:30:02 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCU1KzZXgiW9aT2Ke+eHx4A1PamIVTiKdvMvIU6r4QkugxieNnJ0r/FryNkl53yyrxs6LwPw1C632RGX@vger.kernel.org
X-Received: by 2002:a05:6402:2682:b0:5db:f83c:2473 with SMTP id
 4fb4d7f45d1cf-5dbf83c26bdmr17337970a12.30.1737916202070; Sun, 26 Jan 2025
 10:30:02 -0800 (PST)
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250124162248.60104eec848619a187242392@linux-foundation.org>
 <CAHk-=whddBhfi5DUi370W3pYs+z3r2E7KYuHjwR=a1eRig5Gxg@mail.gmail.com>
 <CAFULd4ZWS4Cxv0CELosQHJh9vTqOJFdr+Fk9NMgSREr_dFG05A@mail.gmail.com> <CAFULd4a-2F_zKMeR0Yjo2WhRLmyoOQ1VdR2qdV34BrM-b_cQCQ@mail.gmail.com>
In-Reply-To: <CAFULd4a-2F_zKMeR0Yjo2WhRLmyoOQ1VdR2qdV34BrM-b_cQCQ@mail.gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Sun, 26 Jan 2025 10:29:45 -0800
X-Gmail-Original-Message-ID: <CAHk-=whgufZwjAuL1PBs1gjSMK95TEhGj1SiMbNvkysWBcEPMw@mail.gmail.com>
X-Gm-Features: AWEUYZmGdxihCLL9KpFnjKHSSUX1cviulL9CWrj_0RvMLbJiU4pvE2aXY5KXNGc
Message-ID: <CAHk-=whgufZwjAuL1PBs1gjSMK95TEhGj1SiMbNvkysWBcEPMw@mail.gmail.com>
Subject: Re: [GIT PULL] MM updates for 6.14-rc1
To: Uros Bizjak <ubizjak@gmail.com>, Miguel Ojeda <ojeda@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org, 
	mm-commits@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On Sun, 26 Jan 2025 at 09:22, Uros Bizjak <ubizjak@gmail.com> wrote:
>
> bindgen ChangeLog does not mention __typeof_unqual__, so I assume that
> the support depends on RUSTC_LLVM_VERSION.

That seems to be a reasonable assumption. I guess some crazy setup
*could* install a bindgen that uses a different llvm version than
rustc itself, but that sounds pretty damn broken.

Let's add Miguel to the participants. Miguel, see

   https://lore.kernel.org/all/CAHk-=whddBhfi5DUi370W3pYs+z3r2E7KYuHjwR=a1eRig5Gxg@mail.gmail.com/

for my "this doesn't work" report, and then Uros' suggested fix in

   https://lore.kernel.org/all/CAFULd4a-2F_zKMeR0Yjo2WhRLmyoOQ1VdR2qdV34BrM-b_cQCQ@mail.gmail.com/

> Does the attached incremental patch work for you?

That does seem to work, but I'd admittedly be happier if we could just
find some way to dynamically disable/enable __typeof_unqual__ based on
which compiler is used, rather than make it a config option. So that
bindgen would not see it, but a recent enough C compiler would.

We already use '__has_attribute()' for some of these things. There's a
'__has_extension()' thing that comes from clang but that gcc also
supports.

But I can't find the list of extensions that that model supports, and
I guess typeof_unqual isn't on that list if I find it.

In the absence of something _clean_ like that, can we just do it in
<linux/compiler-xyz.h> instead? IOW, not use the CONFIG_xyz tests for
this at all, but do something like

  /*
   * bindgen uses LLVM even if our C compiler is gcc, so we cannot
   * rely on CONFIG_CC_HAS_TYPEOF_UNQUAL
   */
  #if __clang_major__ >= 19
  # define CC_HAS_TYPEOF_UNQUAL 1
  #endif

in <linux/compiler-clang.h> and the gcc version check for gcc (I don't
know when __typeof_unqual__ made it)?

This does show that our whole "CC_HAS_XYZ" is kind of broken for the
Rust integration in general.

                 Linus
