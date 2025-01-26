Received: from mail-lj1-f179.google.com (mail-lj1-f179.google.com [209.85.208.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7949F25A62C;
	Sun, 26 Jan 2025 09:57:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737885459; cv=none; b=f+m/uIENYuCKcpQLLGqwf58EXb/Up09GyP8c0UGHj6FF5C6i53vB972F/XxPKg4CmkjOdxGFPJpM9vS97PW0ZQ9/Ra/vYZifIU0a2CALTMxT0dDhHnVtb3A1ud01EUz571Kvw4BIJEi3//uCTrWYlE3BAPXB1Ztrb9bOznmeVVk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737885459; c=relaxed/simple;
	bh=C3R2isyRHtjpIEKlTPhGXgTbTmSQpMLVBszlENL9VAY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=DCdDcNSWbUnqcvrKWM2MP6fqZHTf2JKQWeqMJVUh+0LtRAf3sr9KZI6wzUsMiJhbNxPV/ZNotW50z51umB/25cX8j0ZZJEuDLHrw2OejaNHJBP1JO2w3CrG/xZquHboWqq1/Vpy3FaLMTkAoCEthuMmyne9Eu9UPnXSVgEXpQGY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=B8duBcsb; arc=none smtp.client-ip=209.85.208.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="B8duBcsb"
Received: by mail-lj1-f179.google.com with SMTP id 38308e7fff4ca-30615661f98so36384011fa.2;
        Sun, 26 Jan 2025 01:57:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1737885455; x=1738490255; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=m52C/61YIn9OEkQUGcQ3KLvWBNTntkC1za8rA6NPbvw=;
        b=B8duBcsblCD8Mm5slsuLjjMt6rz5on0MfkgwbwIJbEfPm78pCln8h6sPLCRsxPBSLI
         ksx/4wv5V2XsvLL+nwv9CrfCeqEY8vzcifSPC6xJwMfHvI0c2FzJ16CprAyqtMYL1c75
         nX9BuvmdQdUfUwBmpatyA2wBxd3PoVxr18NA3pVN9IFtJY08JPPE6Byuja+i8tNLUh5H
         nSm2YJSIM0HlFOTTbTDTjRG+jfDCWluyqWZ7KYprwX8kF34Gt0J6mH66PbMbJ045S/x3
         zdWTYNSxEQwFULN2tLDHdD1+qO7DUhc+x8QiwAuwRmn0G2D3nEUp8bDf2mDvfFF29JiC
         2DoA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737885455; x=1738490255;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=m52C/61YIn9OEkQUGcQ3KLvWBNTntkC1za8rA6NPbvw=;
        b=t1vmiZXWbylX4IHLvqR+kGmbCFXG3MpGx/hP95pMtcWUZDZfv2o07dH62an0WAPK68
         O0O3vJstj5GV8ZdBam3BATUCrLS0kgYRdXNsFOqAMlfcbH1uTjkIUBQEAU3abNLAYZUQ
         Vjz28eohHI0PTZuuel5O8KZjPWFuKJC5tSi5/FEfPco2xuuRr9VpiR/do+LowHVTF/o5
         xN+qtx4WmXrQ4u+BK5yVX+v7ykdj42iI2wQ6SCz1GZRt/rSHo6R39Auijqsoe0Qxtkq7
         HUajwcopFs8qA89KvECe60OrgXtoer8Y0zcwFYGp7QwVC0CWEDQL92Bi9DP5+KXdY0Wu
         DbuQ==
X-Forwarded-Encrypted: i=1; AJvYcCUIiXVijPPtpHIfZGrWdpzulfGOGkDeOE8CYFiCsPWQx0wgK/F+qvZDZi+iUbKAvUajfw3OVzqZCJNPTw==@vger.kernel.org, AJvYcCViHBRW5PfcdE53y1tNv5gd3CvTBk/Lie2+UpC9cjeAVesIerRb4oQyNl7+R3RSZRNW2rg6FUJhNgxxOXk=@vger.kernel.org
X-Gm-Message-State: AOJu0YyajHjb5B60Pm1ENqhEEh/Hv++A5yfOT3eZOxqLnIBba5E6ADZN
	eciZ7xPXYRllo0pRy/Qu0vU0mD7mTckI+DwdxBedzq8mu4pqWdBlCipFg+uwhwVsW0EKT7Xpi5b
	WAybOupXPEPgdNcf95FX3WN8HwhdCajAN
X-Gm-Gg: ASbGncuYyLeQ2ewq5HA4eOuaWPUBE+QC1EMoCS4lItqecuresf9VkFnJKkIOPbhkcvv
	3wTVBL8kME3UowVstemNrt9mQ8vwhETAlfPhvVPHOSkvClDggBEFsBPTSwaXVFA==
X-Google-Smtp-Source: AGHT+IEsWf6yst/hSD0iWh+RrerBKiVsS65yCtfdk9NKIMcL7Q34SNu8rqfREx7rNZ/2vQvC9PMFQ5u4BtSMi0lTO/0=
X-Received: by 2002:a05:651c:2320:b0:2ff:cfeb:cabd with SMTP id
 38308e7fff4ca-3072cb66563mr113665781fa.28.1737885455136; Sun, 26 Jan 2025
 01:57:35 -0800 (PST)
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250124162248.60104eec848619a187242392@linux-foundation.org> <CAHk-=whddBhfi5DUi370W3pYs+z3r2E7KYuHjwR=a1eRig5Gxg@mail.gmail.com>
In-Reply-To: <CAHk-=whddBhfi5DUi370W3pYs+z3r2E7KYuHjwR=a1eRig5Gxg@mail.gmail.com>
From: Uros Bizjak <ubizjak@gmail.com>
Date: Sun, 26 Jan 2025 10:57:23 +0100
X-Gm-Features: AWEUYZm6i3G9mY0SRPZY5PbP5yrjnyASce3n4f2gc-kuMzSOa5jYU74Tb-lCT_4
Message-ID: <CAFULd4ZWS4Cxv0CELosQHJh9vTqOJFdr+Fk9NMgSREr_dFG05A@mail.gmail.com>
Subject: Re: [GIT PULL] MM updates for 6.14-rc1
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org, 
	mm-commits@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, Jan 25, 2025 at 11:09=E2=80=AFPM Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> On Fri, 24 Jan 2025 at 16:22, Andrew Morton <akpm@linux-foundation.org> w=
rote:
> >
> > Linus, please merge the MM updates for the 6.14 development cycle,
>
> This does not build at all for me.
>
> I get
>
>     ./arch/x86/include/asm/current.h:49:9: error: call to undeclared
> function '__typeof_unqual__'; ISO C99 and later do not support
> implicit function declarations [-Wimplicit-function-declaration]
>
> when running the Rust 'bindgen', and what seems to be going on is that
> my version of *gcc* does support __typeof_unqual__, so I end up with
>
>     CONFIG_CC_HAS_TYPEOF_UNQUAL=3Dy
>
> in my kernel config, but I think that 'bindgen' that generates the
> Rust bindings is based on LLVM, and clearly does not understand

__typeof_unqual__ is available in Clang 19.1.0 in all C modes as an
extension [1] and as reported in [2], bindgen 0,70.1 seems to parse
__typeof_unqual__ okay.

[1] https://releases.llvm.org/19.1.0/tools/clang/docs/ReleaseNotes.html
[2] https://lore.kernel.org/lkml/9fa81826-8fa6-47e4-a0a2-4916e5d042a7@stanl=
ey.mountain/

Maybe configure could detect bindgen version and disable
CC_HAS_TYPEOF_UNQUAL [3] if it is too old?

[3] https://lore.kernel.org/lkml/20241208204708.3742696-3-ubizjak@gmail.com=
/

Uros.
