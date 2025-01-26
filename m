Received: from mail-pl1-f178.google.com (mail-pl1-f178.google.com [209.85.214.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DFF2915E5B8;
	Sun, 26 Jan 2025 20:58:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737925097; cv=none; b=QUpYqNxSAsouhN14gIEpasUv2wjBv7aW1HPp63jVMHGFjiEa0N25XkWzTqlSBIqEEwriE05c17W8U2G7TiN9JZeW5B1zEM3xjVLz7nAYay1Xeczu5viy3hdw6r96SFKvRPiMH8IoZt/zwqOSQZQxTx4fz0rZZ1H59g2/umh5e8Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737925097; c=relaxed/simple;
	bh=SH30FRKF2my5//BhgfsmgwHUjniJHT2lfsFmdYF0UE4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=esi6nzqyCcLCHODYHJMSd0+w/+wqVPlx/6QZYzyUzqNzdg3zqIfKeRSIgtcVcggsBhiZchp8jjF3akMzOiKI2VbN3+Nx1LrhvGocA78g/ivaBJm95SZcQKT8G0ij1Q5OiEI4EMzaVFft1enUv3V1YYykP+JmITD07/lRm1CezpI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Lj8OJSTt; arc=none smtp.client-ip=209.85.214.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Lj8OJSTt"
Received: by mail-pl1-f178.google.com with SMTP id d9443c01a7336-215607278acso6491215ad.1;
        Sun, 26 Jan 2025 12:58:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1737925095; x=1738529895; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=SH30FRKF2my5//BhgfsmgwHUjniJHT2lfsFmdYF0UE4=;
        b=Lj8OJSTtPZgEfgsdhTtIhY4+7Lc7t9pLkWwAGcDstSqRu36Aj/dhR6ouHP0ah5GIiC
         AfrwNY87Y45bn3UiuLjbFeDZ7kH+Lwhn9T8uug4/AXGee8GOymnFwsRq/Mb+vNDiU6Um
         3Neg+eYwCjCNZO3AYK5PBEL78/jdTnp7xvjChhtDnQwRA5Mx0jRijlGtQPumpdNYVtsn
         RjWKQdfHWzDt8sl4quucnhFVaAzwnaYL/L8VjPeHThrvcsu1bUOdbkGCIwudZRKQVyOz
         KzJRnOcHN7nbHgS16os6GFOGjYfY2Q5fp440mqi7a/niZTIi/PcazxpaALyQ96Ir655h
         vE0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737925095; x=1738529895;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=SH30FRKF2my5//BhgfsmgwHUjniJHT2lfsFmdYF0UE4=;
        b=aUwNw/BD1RGaP9l3spPLl4kWI0cYem0h1g2NUz5Jwyd2MIYKpvuShLBFxtUxkhWz0n
         9Nt/y+OhyUh8z0hLtwFIEAHGvpvE0k98xZfZ+1F/hJy0dKukFFF29hHcQKbO2NTUxqpV
         0Qf9Iju/3zN4B0/oiV+yvtq8wms/S8vBSitBWtHTFnv04gQSSAYgRIP3fLXw/qw79nKG
         cUkkrjiYPH6CD7NnOSVH84J7Xd7UBqnkAQhCZu5FtN2WHrVoR5+sbPZAPHayGXNz9Sej
         hnUmpvzpko4ig6cjXRRTVFbg3jBYop2Bu4o5BbH5zM/YceaSO714ZPbOOnW7OtIT3MFG
         5FQA==
X-Forwarded-Encrypted: i=1; AJvYcCUcFb5P3ZLMEPtrLlaa/8BSfN8EyHgQjT+n9JqJj/SMogxU0pw/2s5ScjiWW2vtSZH159yCNk8gThDdvYc=@vger.kernel.org, AJvYcCX/IzTXrg1VR0D9cr9ujDRPI4xe6ZRUB+CyAXJTBvEcBuNNkkZxGvDCqCmbfYvArAoVbJK2Ua+6xAHfMQ==@vger.kernel.org
X-Gm-Message-State: AOJu0Yyg/+OKlrGpYeNyQFwLjf0OAO51w+edAhfOJe2M/UfLgYKdEYnA
	uiE2QPmfr97isNNYM+w2I+e4LmEFFZyOCXPi/VBnUptELrOenpMOAw3IAmeTajFS3/Do50fqxK/
	PvjNSVQPIKnpvV7Sdr9D8n9KMbTY=
X-Gm-Gg: ASbGncvQefcUFsr/1Wzma5sp1tQKWtie1lvFmbF1K6kuPpHigBt1SMPOVYXgwz9G5/h
	ZYx3QU0sEY/7yqGOGCNEib/7IJWl4eUwGUfbcVP2uF78/ojfOyu4b2FWZWH05/w==
X-Google-Smtp-Source: AGHT+IG/vRGaRaTJ+zsuCCNFo+7BpIUlNDGNx2rj4kjF/hFZvoZaoWDi0Ly9PERSIG+joLNwRvVRBoGa+LUTASF6qTo=
X-Received: by 2002:a17:902:f548:b0:215:3862:603a with SMTP id
 d9443c01a7336-21c355854e8mr226197805ad.10.1737925095127; Sun, 26 Jan 2025
 12:58:15 -0800 (PST)
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250124162248.60104eec848619a187242392@linux-foundation.org>
 <CAHk-=whddBhfi5DUi370W3pYs+z3r2E7KYuHjwR=a1eRig5Gxg@mail.gmail.com>
 <CAFULd4ZWS4Cxv0CELosQHJh9vTqOJFdr+Fk9NMgSREr_dFG05A@mail.gmail.com>
 <CAFULd4a-2F_zKMeR0Yjo2WhRLmyoOQ1VdR2qdV34BrM-b_cQCQ@mail.gmail.com> <CAHk-=whgufZwjAuL1PBs1gjSMK95TEhGj1SiMbNvkysWBcEPMw@mail.gmail.com>
In-Reply-To: <CAHk-=whgufZwjAuL1PBs1gjSMK95TEhGj1SiMbNvkysWBcEPMw@mail.gmail.com>
From: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Date: Sun, 26 Jan 2025 21:58:03 +0100
X-Gm-Features: AWEUYZn_6Xwv8Mwydbd5euhKjcL71JUKc9YTwdE7OqRnBjZOzci5i2lBe7HEhKY
Message-ID: <CANiq72=fj0MHiwy5i=FWZxfP_=XsFpjojywF91N6ygdumtQbwQ@mail.gmail.com>
Subject: Re: [GIT PULL] MM updates for 6.14-rc1
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Uros Bizjak <ubizjak@gmail.com>, Miguel Ojeda <ojeda@kernel.org>, 
	Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org, mm-commits@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sun, Jan 26, 2025 at 7:30=E2=80=AFPM Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> That seems to be a reasonable assumption. I guess some crazy setup
> *could* install a bindgen that uses a different llvm version than
> rustc itself, but that sounds pretty damn broken.

Tangential to the issue, but a note on this: we have a few warnings in
that `rust_is_available.sh` script for things that "do not look
great", such as bindgen's libclang !=3D Clang when `CC` is Clang, and we
could have a warning for the case you mention, i.e. bindgen's libclang
!=3D rustc's LLVM.

However, currently some kernel developers use toolchains from upstream
Rust (e.g. from `rustup`) instead of their distributions, so that
could be annoying for them (since their bindgen may be picking
libclang from their distribution).

But eventually when things stabilize more it could make sense, if most
developers stop using those, as a by-default warning.

Cheers,
Miguel
