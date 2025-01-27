Received: from mail-lf1-f42.google.com (mail-lf1-f42.google.com [209.85.167.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A17351FDE3D;
	Mon, 27 Jan 2025 07:29:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737962996; cv=none; b=ecXlKGC5GEF2FSh/KcXGGVVLS8RfORxXozYdDsQDT0sYiepdJtqofODRSHWhE8bOVtRlvvq9/8TWgl3SIVITJ8BgPErFG3uGEuGpYbxAe2TaYPQYaJg3BQYV/xP6c1tQQDQBssP8jueyCZVBHlWb4amyFAlnFdLlkwAQnXY/TUw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737962996; c=relaxed/simple;
	bh=srGNP/f+Vy+NbFw9XV0cqwaEFNYPLWTQr/qVYD3AerU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=TtgdTO5G/i81NnEJrIN1Tb0yVlfcAzcw4KJuUYYrSVuyEM0ExFV7+7LrDq66inHU50XVewzUrzNLJj3WJ16bH3rOersVy9pw1cf6GKGvjcpEp80CEvulqZ0c1M03aUQochGWSrXNCD9GRcb5E9KUVreiL66vBemWcbCnSvdLRqs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=VV2W4QJS; arc=none smtp.client-ip=209.85.167.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="VV2W4QJS"
Received: by mail-lf1-f42.google.com with SMTP id 2adb3069b0e04-53df80eeeedso4577391e87.2;
        Sun, 26 Jan 2025 23:29:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1737962993; x=1738567793; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=nlFPUNZNmTT/fqJfoPzgiLYWVcF58U28m9n95TFQH30=;
        b=VV2W4QJS2AFkAGwNHvA9f5z4kMs0L1tU1+UNGm+mcMZBYfn35go9lD7C/wMijZf4TZ
         1Y6nTaYGJHl0xo10PM2yQuuMg23ZClkZNjvB6CKZxdKYY6bx5A1R5EhyuQGWyrnXmpna
         3aOzmXfmSvuLUFVCyKp6TYP68hcE+FGcC8Watocf7+8044OCw6TNg1jzwlcMMD4OEk43
         Hu9fDG5flQcAVUwjTU4RUxTfQViOrWffAzuVgnYZ/fH2pMEvGiq1OCeVn4lMAfxUS70R
         1+8lf0CaMwntsSvWFWvuuvEQ5Ep3LzM0qTLVU7entYXRZqV8k+y+8JVihjGupi3qkFmc
         v0lg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737962993; x=1738567793;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=nlFPUNZNmTT/fqJfoPzgiLYWVcF58U28m9n95TFQH30=;
        b=Rl3PQit6d9giiDSmI8VlFXLenwEG5H0v9Wdvxg/Sj2ujVQEx0fTPROMByKI1Yjpzd4
         oUnAqyKoK3mIEHTdshvfV/qWYOaror5oHWy1M5bTguQpJASS8joK9P0PhCB3aym6qKpf
         5WRLsTsTKndyhmAsZ0dw4BQxyffVPoygmOKpnLpsapb5WvOBpkqxJY2//BQBtI8aFXr5
         5zHuGhp/LveYebK7bDZJVfYEZYImY7FZ500NjAjcNnvplorFt2EMc36fHYP74opsRvqB
         5vmVORZ84kebeQ4bQtKb1PlLcK2ZR0GarL/cg79TsyhtFgEhES0q+2oShgSD3nvkHqkZ
         akQg==
X-Forwarded-Encrypted: i=1; AJvYcCW9sbfGdG/BZ928PIKvZTZPFokwrVk0tCirIyOgtvWkAOpDzDX7pf/k8/xINXGXc2B9TbPkbl6mbPP5FQ==@vger.kernel.org, AJvYcCXPoLYPgPKqGuI/kBX5J2hZtjjOeyf1jc8yHtGoFXLmpelo5U4sjRQYll+pHQ0swqg9bxnLywUOPiDnzpY=@vger.kernel.org
X-Gm-Message-State: AOJu0YyVZqhgE1pTNtPuW9nCjEl1k20iF+ejGjQkN6iy5CKSAbm2c+99
	vSDNB4v38rvuXCr25Valj7eMyGgy0HukTHY6GLEurXEY5asiVfnuOPiWXzD0OrE4ENJw/AlTaQr
	5kNTRmCshHynlzVFake2J8oVw/zmTd6+U
X-Gm-Gg: ASbGncvEe2j0kdfz/+U33PYPzr7Cs4q1VR1QV4BBIsuZnJ8x2/n8/KRps4wqKqGCimQ
	nkc7XOfbKbApbbtnx4N8OVUQDCnYgA5WGfvgu9Jau2fKebqcExgy4I9cvLsHHiw==
X-Google-Smtp-Source: AGHT+IFKHHu8z+BRAsAe3bUUE4EvZZl7P9+RhGruUxkCv3dxXmHBoJ33tcV5plsQfKIaFhj71TSBWxSDDBy23mwr9no=
X-Received: by 2002:a05:6512:3409:b0:542:9883:266 with SMTP id
 2adb3069b0e04-5439c27fa18mr14896481e87.37.1737962992436; Sun, 26 Jan 2025
 23:29:52 -0800 (PST)
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250124162248.60104eec848619a187242392@linux-foundation.org>
 <CAHk-=whddBhfi5DUi370W3pYs+z3r2E7KYuHjwR=a1eRig5Gxg@mail.gmail.com>
 <CAFULd4ZWS4Cxv0CELosQHJh9vTqOJFdr+Fk9NMgSREr_dFG05A@mail.gmail.com>
 <CAFULd4a-2F_zKMeR0Yjo2WhRLmyoOQ1VdR2qdV34BrM-b_cQCQ@mail.gmail.com>
 <CAHk-=whgufZwjAuL1PBs1gjSMK95TEhGj1SiMbNvkysWBcEPMw@mail.gmail.com>
 <CAFULd4Z2eSJhE0qF0QEtsb-7zoOMKH=KvvrfK0M5UozLw_TYUA@mail.gmail.com>
 <CAHk-=wjmThGBZCxmBTypng2NEczY7cdJi2Dotf7ygun=hu_EGQ@mail.gmail.com>
 <CAFULd4aDuPA3rig9BzD_P1Y62S0Y5Yv_8AxpjtwTddv4OPNoHg@mail.gmail.com> <CAHk-=wg_e8=SasMy7j3oHpkWXSE1gDsUoXC8p=+N=9zd5VE1Jg@mail.gmail.com>
In-Reply-To: <CAHk-=wg_e8=SasMy7j3oHpkWXSE1gDsUoXC8p=+N=9zd5VE1Jg@mail.gmail.com>
From: Uros Bizjak <ubizjak@gmail.com>
Date: Mon, 27 Jan 2025 08:29:40 +0100
X-Gm-Features: AWEUYZlxijuhNRbQvLSAWHRwXNj1eC2FNE9fRUjz6AWjy_FntumLUPkqMLz8cfI
Message-ID: <CAFULd4b=aCfWeOHSjH_qxUn-UNOhfqc12iA_rb48-SNKVTgzkg@mail.gmail.com>
Subject: Re: [GIT PULL] MM updates for 6.14-rc1
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Miguel Ojeda <ojeda@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org, 
	mm-commits@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Jan 27, 2025 at 1:08=E2=80=AFAM Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> On Sun, 26 Jan 2025 at 15:27, Uros Bizjak <ubizjak@gmail.com> wrote:
> >
> > The detection is put in include/linux/compiler.h where we can
> > consolidate checks for both compilers:
>
> No. Please. We have compiler-specific header files for a reason.
> Exactly so that we do *not* need to have disgusting tests like
>
>   #if ((defined(__GNUC__) && __GNUC__ >=3D 14) ||        \
>        (defined(__clang__) && __clang_major__ >=3D 19)) &&    \
>       !defined(__CHECKER__)
>
> and instead it should just be
>
>   #define CC_HAS_TYPEOF_UNQUAL (__clang_major__ >=3D 19)
>
> in compiler-clang.h, and
>
>   #define CC_HAS_TYPEOF_UNQUAL (__GNUC__ >=3D 14)
>
> in compiler-gcc.h.
>
> And then in the actual compiler.h, we could do
>
>   #define USE_TYPEOF_UNQUAL (CC_HAS_TYPEOF_UNQUAL && !defined(__CHECKER__=
))
>
> and now the places that then want to use __typeof_unqual__ have a very
> straightforward way to check if they should do so.

Got it, I'll do it this way.

Thanks,
Uros.
