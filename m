Received: from mail-lj1-f170.google.com (mail-lj1-f170.google.com [209.85.208.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6EC016CDCA
	for <mm-commits@vger.kernel.org>; Sun, 19 May 2024 18:57:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716145038; cv=none; b=RUq9nMndTFfNVG028m/iPak3imKXJ/geg5CHlJsp3fZnXVNavRK1Btmx8rgYFBCSDwMKJuFB8OZaTn1TaqyB++kVdsetPdDec4WV/0buTaDKx8u+RHVJrrEpfyLEdwmQTyVdkkOF0cRJRbQKsaORjSYcsSW5kTvrGFozhXSPNzg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716145038; c=relaxed/simple;
	bh=HCDGXHWYGuug0vB2TJuSEuYHOYHvebMr845YY7RWV9w=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=FarDUV0CAznRNneeneSvjG2yClhMfBp0mUxIyXi3+C9Wm1kNm1Oe1e15v/uw0OSjN+99kqar3Ho/rtAQ6tHbkbHK1aseKBUOa59R5pfH5qb+AvSOyviXzUXXMhtoxlNUUTVUkN7Ff7gxeG8N/k6qNyaA+4kEWLXfbb+t52mZO/0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=g4bJwjuN; arc=none smtp.client-ip=209.85.208.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="g4bJwjuN"
Received: by mail-lj1-f170.google.com with SMTP id 38308e7fff4ca-2e538a264e0so46113101fa.1
        for <mm-commits@vger.kernel.org>; Sun, 19 May 2024 11:57:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1716145034; x=1716749834; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=iY9tQ/lw2tptEzAdBZnuUzlK61qi/54gCaWIsbKgyvQ=;
        b=g4bJwjuNFJYggPHc/tnVDnRyOSAQd6kmv3lOrR9uWycyVyM2R/2vjwaEBlWmK74/pT
         ozZTma1BomNUJXfUkj9L9Apbitg5bD5RsyIbCME0WCjj0vFWo2Qme1Usq6heznj6h6eH
         2/6xid94L887c1rJ5Ihs/Lxf4/iIpBbuckltM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1716145034; x=1716749834;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=iY9tQ/lw2tptEzAdBZnuUzlK61qi/54gCaWIsbKgyvQ=;
        b=D0fV0PJjqq/r29M702GyXeHtZTmaoarDk8taOdf9CEirT40BOeuZNLrdYDpBtktV+m
         tAQnycARnGRXwkOYNJ/5JFEEVQprYCVCLGU97A3qpUZw5JxuT3ImltuBaJkX80LoBkUe
         JU4TDTeERP9gL8mjcWwgVVJyE4gpjmGFB/h36s7EQUH1oOMUXkgEUxHjRtKwV1VVlQ7y
         pvXfsTCifVy5F3ceg3dD48LW/2U8KpGGQTiYxyx36Tsgbt4gjvKZueE3Fwbt2AgHbWMa
         p4BzLuvqsMb2Z0YzQQNUFnYLVxCVrDPvoLFArW+1bqOxPNGsGmnrdrflT+WPw+KpixN8
         uQFQ==
X-Forwarded-Encrypted: i=1; AJvYcCXZrHN9FD+PgF769eOT4ENJtsdVUDZlczLiKPY56Fa78m/uZtl8xFbJwXi87s+IeQeLrR9lmfU68ea3pXkoUu5YsrOfkYlx71629A==
X-Gm-Message-State: AOJu0YyBPmaIRDJuMhn+Nuqua+NxAuzxsrDUH3Gy4TFv6GDeCofyI8IM
	ggylXnTOSaHmamp+zde+Lei/CwodtyKWtJJT4Rm6EMP8j9WAO+ytjpWZbS/rSHwHfWtEUaU6oSO
	06/Tm8g==
X-Google-Smtp-Source: AGHT+IEmlMjl9Qrn4dWxHC4JkHDJX3nxoVtOIpgLSkXMuGWl/4ch0u2X/iv06PbTmwuJ50s9jNGHhA==
X-Received: by 2002:a2e:7d09:0:b0:2e2:1647:f671 with SMTP id 38308e7fff4ca-2e5205c817emr230464271fa.47.1716145034177;
        Sun, 19 May 2024 11:57:14 -0700 (PDT)
Received: from mail-lf1-f43.google.com (mail-lf1-f43.google.com. [209.85.167.43])
        by smtp.gmail.com with ESMTPSA id 38308e7fff4ca-2e4d0ef22a7sm31296161fa.69.2024.05.19.11.57.13
        for <mm-commits@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 19 May 2024 11:57:13 -0700 (PDT)
Received: by mail-lf1-f43.google.com with SMTP id 2adb3069b0e04-5238b7d0494so2769176e87.3
        for <mm-commits@vger.kernel.org>; Sun, 19 May 2024 11:57:13 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCV3C47+jDA0q7c+fpcRUK3XePJj54CDO7OxKQdP/ZVw2+gRi769+WNw5li4vc3YyZjuNYYeQy3e8a8OHfeIw9Y2URzzB9tafyntcQ==
X-Received: by 2002:a05:6512:3b0d:b0:521:5583:483c with SMTP id
 2adb3069b0e04-5221016b3e6mr28495387e87.54.1716145033039; Sun, 19 May 2024
 11:57:13 -0700 (PDT)
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240517192239.9285edd85f8ef893bb508a61@linux-foundation.org>
 <CAHk-=whEAquncw0wb59-XVAHmVh4CWSfwuWh4bTJjJzvx0=PzQ@mail.gmail.com> <20240519113639.db3fe5f80d25be4e7666751e@linux-foundation.org>
In-Reply-To: <20240519113639.db3fe5f80d25be4e7666751e@linux-foundation.org>
From: Linus Torvalds <torvalds@linuxfoundation.org>
Date: Sun, 19 May 2024 11:56:56 -0700
X-Gmail-Original-Message-ID: <CAHk-=wiy+25i1VZhDaV-b_m4aXGNELuVok9Prv4=oYqiun--rg@mail.gmail.com>
Message-ID: <CAHk-=wiy+25i1VZhDaV-b_m4aXGNELuVok9Prv4=oYqiun--rg@mail.gmail.com>
Subject: Re: [GIT PULL] MM updates for 6.10-rc1
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org, mm-commits@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On Sun, 19 May 2024 at 11:36, Andrew Morton <akpm@linux-foundation.org> wrote:
>
> This is me advancing the master branch once per week until we hit -rc4.

Yeah. You really shouldn't do that with a merge commit.

If what you want to do is just advance the master branch, you should
just rebase on top (if rebasing is what you want to do).

Instead you seem to merge _and_ then rebase. So you do the worst of both worlds.

You don't get the history cleanup of rebasing, and you don't get the
history preservation of merging. You do both, and it's wrong.

> I don't understand why these merges were visible to this pull.  I sent:
>
> : The following changes since commit 5d1bc760583f225032f91bd88853f4c26acaf4e0:

No. That is NOT how git works.

You claiming to send only the changes after a commit doesn't magically
make the history that precedes that commit go away.

With git, when you send a branch, you send the WHOLE HISTORY. That is
fundamentally how git works. You trying to change the "from this
commit forwards" doesn't actually change anything at all, it only
changes the wording in the pull request itself.

You can't just do a pull request and try to say "only send changes
since this commit".

Git is *not* the broken sh*t that you have used before that is just a
queue of patches. Every single commit carries the whole history that
leads up to it.

And that is fundamental (and is fundamentally why patch-queue based
stuff is broken garbage), because proper history is what makes merging
work and scale. It's pretty much what makes git not CVS, or the horror
that is darcs and "patch algebra".

So when you do a pull request, the whole history is always visible.
You can't make it not visible.

> This has worked OK before,

Your previous histories haven't had those broken merges in them, so
your previous pulls haven't had them either.

I don't know what you have changed in your setup, but your "advance
the master branch once per week" process is completely broken.

The problem isn't the pull request. The source of the problem is
something in your "advance" scripting.

               Linus
