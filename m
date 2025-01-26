Received: from mail-lj1-f170.google.com (mail-lj1-f170.google.com [209.85.208.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C038335BA;
	Sun, 26 Jan 2025 17:22:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737912123; cv=none; b=rfWKdSVNKn0Vb8V3tYAiQ+tufpTYfz7bTfxsfUyotxpD6FckVF2OIlhzBT5jGEhYCSETQjORB/nnBIX4UYHf9IpdMYT+Reow4ZnPMteN8/+/uuvOV9RGf1Z8I5eTv45kYh1KgxhSXl+dv0pIaRsVYkm5FmPefK7sA+s1t1GgzmU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737912123; c=relaxed/simple;
	bh=zs6ULr2SHOMrcFW0jKXsZUciGnVSmGlV+R80E29pJOI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=pdd9p5aTKlhJ/dPZzevT0kNmySWznl2qxxl9KiB62Z69YQcG9FBhXwQ8+D9glAy360XRv+FIz20VqT3jcZY6lmadujqb2oqb1jT5jGT0v6yi/4Rzmd8ZWvsj+J24WCUB65TITzcvDds9uFTSBCqg9taecyLPRN5YBnKDdmA4I88=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ksXQG1eR; arc=none smtp.client-ip=209.85.208.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ksXQG1eR"
Received: by mail-lj1-f170.google.com with SMTP id 38308e7fff4ca-30738a717ffso33664211fa.0;
        Sun, 26 Jan 2025 09:22:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1737912120; x=1738516920; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=7DM9kP2MSMgmAITbtSXEnuoEUycWS4C2+ntpQx2P6pc=;
        b=ksXQG1eR2j+xBjlj8cohKpDZHzoBv356aurY0/QSImEJ/94Gm14dCSlRD3Idq7E2TP
         CsF7CspFxqZ7i7TOSbaMBidijVCoPcMfscIWO6wNLRwZ+QOoI9Mjxpgyz0q0moYFNLS2
         E9vi54ebHbIQ2sw3Onu6iSHjezNmVmJegPz8MrpzWEv+KUoJ9GSFSlFvFcR/LvEo64E4
         YCQuu9V0UkytdHf+sCMBgHAzUgWGF6rUlf8T32CS3+o2zTlN9Sg1xFlBy759eBT/0YuC
         f36YLnGa0GCX+r1+mMCKP6peX+KAb7UweLo+zSBw0ZV64yprSiWrI1LmEoyeUwETeXak
         4fHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737912120; x=1738516920;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=7DM9kP2MSMgmAITbtSXEnuoEUycWS4C2+ntpQx2P6pc=;
        b=OB7L6XIcX665cO0c88IqFbEM7i238ljGbnAf2rmBmLHEXcDGnhHfoxNQewDgHmJCmW
         fHV9HsLRzMRNb3cQ7V21WFxmf1anzZhFi848G+d3vhh3Z1D1BFlnmb4xwSBfFD+7VaIs
         XRVZshpEEM/HmfR8cmHV+Zh4Xz0zfGalO7sG2UCMuh2r5p6zx8W+hUfYjcjEj5ZDbzmW
         uf6XVgYWBALEDhl4xVGVLh8uATXy29sgXqcXOfut2BrBL1r0PuXcvZ8ed5XQHMGMxuoN
         1z6KKrqK/7+y9DWe65/vQeHxheXDmxLDAXspV7qnCWXdCK2CgUaE2AyyMNAKJ/CuMDzc
         8Gfw==
X-Forwarded-Encrypted: i=1; AJvYcCWgnTuU2f9jDCyc/dIQwowOZia/OSulpzy2vFF5RcOdj6olpS2Vthw36+ekr1MAznE3KOMp4wUuwx0SAQ==@vger.kernel.org, AJvYcCXfAMf/EYggK2SfEjsXV0zPZH2VdWbkrbFj6GKOYAWcxaOIYh2uuZm8Tq/4ufLMKkxOi33hlbCbiTRXQO0=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw5x4A8im6egBQo3KvnyeY8a0vYNOWKxIY2sh1fw6pdXSyviP0j
	aPUAxOPXWXupJKnd2IW1iFBxD0Gf9eKr+Yf386Xh4EpepqUS8fZEdugPDv2nHe5gLTtbOym/8tJ
	nVtPZxzXjW/A5LDTPn6MniRUQNk3oWPLh
X-Gm-Gg: ASbGncvstRTob17eyxLS+/FiqyCvsqvIAMdo9vXT4iS18szPJHvOkLL84aZeh6q3mGa
	akzbrX2aJ697fEW+b+t9F40X2tuoYmBRmEx+6quchP7wppluTrYdeTIIhJwR11g==
X-Google-Smtp-Source: AGHT+IFgvS9yepFhImhbGeUdFQWVr6GnpyPoIl8O9keAmyBDaGEaMLm6z/05su8Ey74t1Vo1lTWyxsDdrXET4sWNL7w=
X-Received: by 2002:a2e:8e24:0:b0:2ff:c3a2:f408 with SMTP id
 38308e7fff4ca-3072ca897b7mr108902411fa.12.1737912119834; Sun, 26 Jan 2025
 09:21:59 -0800 (PST)
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250124162248.60104eec848619a187242392@linux-foundation.org>
 <CAHk-=whddBhfi5DUi370W3pYs+z3r2E7KYuHjwR=a1eRig5Gxg@mail.gmail.com> <CAFULd4ZWS4Cxv0CELosQHJh9vTqOJFdr+Fk9NMgSREr_dFG05A@mail.gmail.com>
In-Reply-To: <CAFULd4ZWS4Cxv0CELosQHJh9vTqOJFdr+Fk9NMgSREr_dFG05A@mail.gmail.com>
From: Uros Bizjak <ubizjak@gmail.com>
Date: Sun, 26 Jan 2025 18:21:47 +0100
X-Gm-Features: AWEUYZkuEliDjT-yeR1XDZT3Al8BiU_YK0ero9EzLYRQnzOxHOErGZjiRzLIpCM
Message-ID: <CAFULd4a-2F_zKMeR0Yjo2WhRLmyoOQ1VdR2qdV34BrM-b_cQCQ@mail.gmail.com>
Subject: Re: [GIT PULL] MM updates for 6.14-rc1
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org, 
	mm-commits@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: multipart/mixed; boundary="0000000000008dd86d062c9f32bd"

--0000000000008dd86d062c9f32bd
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sun, Jan 26, 2025 at 10:57=E2=80=AFAM Uros Bizjak <ubizjak@gmail.com> wr=
ote:
>
> On Sat, Jan 25, 2025 at 11:09=E2=80=AFPM Linus Torvalds
> <torvalds@linux-foundation.org> wrote:
> >
> > On Fri, 24 Jan 2025 at 16:22, Andrew Morton <akpm@linux-foundation.org>=
 wrote:
> > >
> > > Linus, please merge the MM updates for the 6.14 development cycle,
> >
> > This does not build at all for me.
> >
> > I get
> >
> >     ./arch/x86/include/asm/current.h:49:9: error: call to undeclared
> > function '__typeof_unqual__'; ISO C99 and later do not support
> > implicit function declarations [-Wimplicit-function-declaration]
> >
> > when running the Rust 'bindgen', and what seems to be going on is that
> > my version of *gcc* does support __typeof_unqual__, so I end up with
> >
> >     CONFIG_CC_HAS_TYPEOF_UNQUAL=3Dy
> >
> > in my kernel config, but I think that 'bindgen' that generates the
> > Rust bindings is based on LLVM, and clearly does not understand
>
> __typeof_unqual__ is available in Clang 19.1.0 in all C modes as an
> extension [1] and as reported in [2], bindgen 0,70.1 seems to parse
> __typeof_unqual__ okay.
>
> [1] https://releases.llvm.org/19.1.0/tools/clang/docs/ReleaseNotes.html
> [2] https://lore.kernel.org/lkml/9fa81826-8fa6-47e4-a0a2-4916e5d042a7@sta=
nley.mountain/
>
> Maybe configure could detect bindgen version and disable
> CC_HAS_TYPEOF_UNQUAL [3] if it is too old?

bindgen ChangeLog does not mention __typeof_unqual__, so I assume that
the support depends on RUSTC_LLVM_VERSION.

Does the attached incremental patch work for you?

Uros.

--0000000000008dd86d062c9f32bd
Content-Type: text/plain; charset="US-ASCII"; name="p.diff.txt"
Content-Disposition: attachment; filename="p.diff.txt"
Content-Transfer-Encoding: base64
Content-ID: <f_m6dvy9330>
X-Attachment-Id: f_m6dvy9330

ZGlmZiAtLWdpdCBhL2luaXQvS2NvbmZpZyBiL2luaXQvS2NvbmZpZwppbmRleCBhMTUwN2I4NzE0
ZTQuLmQzNDIzNzFkZDE1ZCAxMDA2NDQKLS0tIGEvaW5pdC9LY29uZmlnCisrKyBiL2luaXQvS2Nv
bmZpZwpAQCAtODk4LDcgKzg5OCw5IEBAIGNvbmZpZyBDQ19IQVNfSU5UMTI4CiAJZGVmX2Jvb2wg
ISQoY2Mtb3B0aW9uLCQobTY0LWZsYWcpIC1EX19TSVpFT0ZfSU5UMTI4X189MCkgJiYgNjRCSVQK
IAogY29uZmlnIENDX0hBU19UWVBFT0ZfVU5RVUFMCi0JZGVmX2Jvb2wgJChzdWNjZXNzLGVjaG8g
J2ludCBmb28gKGludCBhKSB7IF9fdHlwZW9mX3VucXVhbF9fKGEpIGIgPSBhOyByZXR1cm4gYjsg
fScgfCAkKENDKSAteCBjIC0gLVMgLW8gL2Rldi9udWxsKQorCWRlZl9ib29sIHkKKwlkZXBlbmRz
IG9uICQoc3VjY2VzcyxlY2hvICdpbnQgZm9vIChpbnQgYSkgeyBfX3R5cGVvZl91bnF1YWxfXyhh
KSBiID0gYTsgcmV0dXJuIGI7IH0nIHwgJChDQykgLXggYyAtIC1TIC1vIC9kZXYvbnVsbCkKKwlk
ZXBlbmRzIG9uICFSVVNUIHx8IFJVU1RDX0xMVk1fVkVSU0lPTiA+PSAxOTAwMDAKIAogY29uZmln
IENDX0lNUExJQ0lUX0ZBTExUSFJPVUdICiAJc3RyaW5nCg==
--0000000000008dd86d062c9f32bd--
