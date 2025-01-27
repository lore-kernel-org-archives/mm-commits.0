Received: from mail-ed1-f44.google.com (mail-ed1-f44.google.com [209.85.208.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F0D41FDA
	for <mm-commits@vger.kernel.org>; Mon, 27 Jan 2025 00:08:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737936529; cv=none; b=AsZ6ipb08VKMjbfr+bRsyUhOsY6cUwnEfawSDwEu7feW0dfaet3+56G0rlLPt/5d28zSybonbHdCldprvrunB0suxPP8BkSDPQlHTWzfon24wYPA+RD2u7Sq9tuMcDHcBmW7+gx1hyCVaUOGezL3sZbKSyQOkmOE2JD44IJIZzw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737936529; c=relaxed/simple;
	bh=Sk/TEy7pvV2ROcPBEpXjJARZ0lR8wxQBk8+o3T4YWis=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ZD4N9fe9zHKBgW8lGHVzt6Gt1z1A+cQdrYn5ZXDjWaAaiD5nOc/VkcbbLmCeIIymG9HA1B9VUzHm4u0Hci42j/TOHgT+fqKotBMTjCM90nAFAMqCRCqSDSV3IbEBllRlIJy2EGbxJpuezuGirQK62P1rlxb14Nb57bFoek1dPhM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=hXJUUV7J; arc=none smtp.client-ip=209.85.208.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="hXJUUV7J"
Received: by mail-ed1-f44.google.com with SMTP id 4fb4d7f45d1cf-5da12292b67so6435992a12.3
        for <mm-commits@vger.kernel.org>; Sun, 26 Jan 2025 16:08:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1737936525; x=1738541325; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=k6OF3+vySxnUkmergH/+kbakIWlWANHYDNwh50U2rJ4=;
        b=hXJUUV7JaWBVgTML8L2T2QwA8wGukPqw+YP9ty8mFf0EGpHfEfhM1MAcxEoC5Pn+M8
         rsS9omzIXSDlF8M+OtoLXUu+UIz6/ja+rclVrMqjdXT8zAqXrktFh3fqWwhaIHsOoFpq
         cikMuapSD2g6qg6DQyHc/zmTWyIdm8lVfNvDc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737936525; x=1738541325;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=k6OF3+vySxnUkmergH/+kbakIWlWANHYDNwh50U2rJ4=;
        b=GheSFh0WCYMItQM4wXL1ob8Gk8v5V+20y5ujQz67P3Rb1gEWQdvGmLhIpfWo/dn8q6
         Zj32tfuNrp+l8nM02YEgyRwB4FkQ0Gq4VfEKGPg05X2qgTPnKjt3ScRheoNBsbEQKb25
         9ra6fR/8Fztkx9u5UjIE0qHsLUl3dvT5uuIDA+8qKb53zk4SC52z34tlScYkEzvttoWF
         v1qEvwFPl+4b5hRUdsdMfvqWRy8GlQhrkb2mk28m41k9k4oYEKSkc33jkJ1Qb3wxmbIG
         PGARxL41J9GvexxgsE+H8cx6nz1PPVeO/h/mydax9DcfedK2x0soJu1dHvIg5YEPFWqy
         DpHg==
X-Forwarded-Encrypted: i=1; AJvYcCW25yJP7GvcXFTgY0rjnwHbwIV0i8DUvEPFQmRWtwNFpkQl4d+we9aVnqwuL4di/etBxnvueb7t1lUL@vger.kernel.org
X-Gm-Message-State: AOJu0YyZ4rqPM3+pdymhIJStC74djLLywUqlTHg/ySLLEGARBtUArSIH
	Wgo5qDx+zJ+Y0HO656cPCV00LPD1uXC0enQ6wmMCv1+F7f6RfBgIMs9lfj18q71sbxrbBm+PX1t
	M8dk=
X-Gm-Gg: ASbGncusFQeLB5ldXas29lkJrgc+qaJFAcky9iPah/3E/gbveb0lPGyOUddDilEN8v8
	pIx2s/JpgQU6SjJTB9bDQhO2y75fTIDIo+SdznQJ8tNKaNsxe0F7zCZy6kr47bo6HdfMbwh2muv
	tpttMKwXpaVVC8TL4SQf0y3dKMgfavncCIw6A1i8WuGU/ZlwEj0zBBwfpOJk92WvSsPelMJ/8aF
	5/HmBrtzgxm+F+ZV4jAE/3jmbt8+1J8afGUg7FOsWF1m3zoLzJBllu3mVBKb24f8Zeki/ynSYMS
	3fmcBvh1Qlfq+1HcgD9BppyAcT2WvHdtKH5UjjtNBlu0x/yJZwZi3ejlAmUJa3rr4Q==
X-Google-Smtp-Source: AGHT+IHQFs6peU5sPWCMJSn7B6VMG85/cHUAyEDV++4tF0iQgb0d/zAETSmhJufHnGxSHzBR9kzwnA==
X-Received: by 2002:a05:6402:3595:b0:5db:f4fc:8a08 with SMTP id 4fb4d7f45d1cf-5dbf4fc8bf6mr51948798a12.6.1737936525370;
        Sun, 26 Jan 2025 16:08:45 -0800 (PST)
Received: from mail-ed1-f52.google.com (mail-ed1-f52.google.com. [209.85.208.52])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ab675e12d83sm490703166b.37.2025.01.26.16.08.43
        for <mm-commits@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 26 Jan 2025 16:08:44 -0800 (PST)
Received: by mail-ed1-f52.google.com with SMTP id 4fb4d7f45d1cf-5da12292b67so6435959a12.3
        for <mm-commits@vger.kernel.org>; Sun, 26 Jan 2025 16:08:43 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCUXUulkYRb6SgFribCOIdMlHU3i8JLTbUrTi7fLIALcnyhgo8qsYL1V5yZjZCuOddj488cVxsaloDi9@vger.kernel.org
X-Received: by 2002:aa7:c505:0:b0:5db:e7eb:1b4c with SMTP id
 4fb4d7f45d1cf-5dbe7eb1df7mr41371775a12.10.1737936523125; Sun, 26 Jan 2025
 16:08:43 -0800 (PST)
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
 <CAHk-=wjmThGBZCxmBTypng2NEczY7cdJi2Dotf7ygun=hu_EGQ@mail.gmail.com> <CAFULd4aDuPA3rig9BzD_P1Y62S0Y5Yv_8AxpjtwTddv4OPNoHg@mail.gmail.com>
In-Reply-To: <CAFULd4aDuPA3rig9BzD_P1Y62S0Y5Yv_8AxpjtwTddv4OPNoHg@mail.gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Sun, 26 Jan 2025 16:08:26 -0800
X-Gmail-Original-Message-ID: <CAHk-=wg_e8=SasMy7j3oHpkWXSE1gDsUoXC8p=+N=9zd5VE1Jg@mail.gmail.com>
X-Gm-Features: AWEUYZkgThD06LP6JnpPwSeEU-gztJJXCL1K6rChtIyUORLCFXJrOgAryyPNQRQ
Message-ID: <CAHk-=wg_e8=SasMy7j3oHpkWXSE1gDsUoXC8p=+N=9zd5VE1Jg@mail.gmail.com>
Subject: Re: [GIT PULL] MM updates for 6.14-rc1
To: Uros Bizjak <ubizjak@gmail.com>
Cc: Miguel Ojeda <ojeda@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org, 
	mm-commits@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On Sun, 26 Jan 2025 at 15:27, Uros Bizjak <ubizjak@gmail.com> wrote:
>
> The detection is put in include/linux/compiler.h where we can
> consolidate checks for both compilers:

No. Please. We have compiler-specific header files for a reason.
Exactly so that we do *not* need to have disgusting tests like

  #if ((defined(__GNUC__) && __GNUC__ >= 14) ||        \
       (defined(__clang__) && __clang_major__ >= 19)) &&    \
      !defined(__CHECKER__)

and instead it should just be

  #define CC_HAS_TYPEOF_UNQUAL (__clang_major__ >= 19)

in compiler-clang.h, and

  #define CC_HAS_TYPEOF_UNQUAL (__GNUC__ >= 14)

in compiler-gcc.h.

And then in the actual compiler.h, we could do

  #define USE_TYPEOF_UNQUAL (CC_HAS_TYPEOF_UNQUAL && !defined(__CHECKER__))

and now the places that then want to use __typeof_unqual__ have a very
straightforward way to check if they should do so.

             Linus
