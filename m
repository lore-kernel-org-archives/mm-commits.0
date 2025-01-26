Received: from mail-lj1-f180.google.com (mail-lj1-f180.google.com [209.85.208.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37EBC2AD22;
	Sun, 26 Jan 2025 20:06:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737922002; cv=none; b=H37IoyTDqWZO3vPQkhWQ/v95VcWv7zWYSQFsQedM/IM6xKKoF52/Vur51k8dAOud4MxUD8QTvAw0i0BHWq+yoqgCZ+2oeSFPtqHSoe/DniHwSZaL0WmsFxsVNX6vJD0n57mL9ERaSVlNOTSr6vimrtvjlWrPtNBDKiuh1EMyYWE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737922002; c=relaxed/simple;
	bh=/g/7UbBKkH4otqIM12xQc+pJsSe6vAP3rZ5z0XmAZcE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=hu93lFwli9ojgfgQQSKtV0kHbStskS/3zQ2WbI4MmpVva0baE5HseQ82FZFKd5afe2qbm7DHdcawWhOPjsbtZK/8BzfeKZgKS2FPIRzdIKzoVLvTJRX6ZBUVJsH9FGnQvI1HYab3bMzDGBKr4IuvYpzB2xbOS7pLoTZVE9EsUpE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ZkhDDBv9; arc=none smtp.client-ip=209.85.208.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ZkhDDBv9"
Received: by mail-lj1-f180.google.com with SMTP id 38308e7fff4ca-30615661f98so39202031fa.2;
        Sun, 26 Jan 2025 12:06:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1737921999; x=1738526799; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/g/7UbBKkH4otqIM12xQc+pJsSe6vAP3rZ5z0XmAZcE=;
        b=ZkhDDBv9XGdGdkwaPtr7BEHmbhd6GIu2YFIxBTpuI+vpt04MSDEgXvsQLcW0xpJjDb
         goUch4RELkmda9uYNUMEIKcl3emfBeIJ3g4FL0i2AGlg0xpNNcn/qSuW+Iw4kz44ONzg
         iOXys9eMV/iwqCFITbwycxbxjn/HA8aaKk1eMSu8R4Yci+OxDrDPNmCu6eLhkeYhYT1Q
         FRp54lnKLrKa7TrvIYIMRRltixX+LT6k6tMDKei84TGSP366gs3SSS+YGyC14J87+X9X
         z5JfXlXg1F9hQr5lUN3Qb1qG9kNzyPx+zbKV5HCFzoUsgrF8Lydb+bXJbk99Dl2UTwZY
         dPSQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737921999; x=1738526799;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=/g/7UbBKkH4otqIM12xQc+pJsSe6vAP3rZ5z0XmAZcE=;
        b=XVC/DIfE1XhtnGqpaS4TzVwqKSEJhXjCIgPJToLvCifSRrBpkE7Iy3EDQTKoodj7kC
         nbELKW26dWfILbe4+PQZQkte1yGJIFF8DU3J5yRyEJnFI7uJX1sJiTOcAZ8SIts8ijRe
         XNcUMnVdb5+khkQA56XYpeyvfqmsDpj4U2JfNNR8Jhz12X79fbqJ6oJHLWMhaD+U+IF5
         eqT0MfjaNO6BOJgOZIhlg5kwFwK18jw+ziPas5rvKbaE2c8adXVg742gyDQL1Cym0H/p
         G09Pnur/OnL2YSecGzmZus3udQUCxiQVCtn7cZvpxDhw61XcNs74svZGNt5NfeKzCfYz
         IDMw==
X-Forwarded-Encrypted: i=1; AJvYcCVzxDtF1vJLPGVaHd5sa+dQRSwvisD2yv+9f/zGOKx4b5LsK6TyNzVpEf09iUGm3URp5ktvQo/6+NZmUWo=@vger.kernel.org, AJvYcCXKLcOARSa/dcxbRmYe1kE0Fbr3mCvwRTS1f6ULDgu/w/RIF4NRmOhV687otAo/DsOY5hnIAx6U1EnxxQ==@vger.kernel.org
X-Gm-Message-State: AOJu0YzA2G1gFesNVBdIHARnVX/yiQqh2ZvRTbAgJBt2hrQ+7euunj20
	CQAxJ3SdzsYC9RBKwodO5Z+Wl62SjU26cp27vjGnIP4pFlj4Tm2ZE5vRRpBefaDXYVvqBK+zvac
	cgogFSRPmb4G63roRYaNL8BPW+7aIdcNM
X-Gm-Gg: ASbGnctmBXWXZTMjOXFRqq2jjC4FI6jKvKWyoxRA0WS2WqREjXB3JVhVTAvVLywAsy5
	tiom7pyXL/NRywu5WNNlPLGOe+FzzEyhxwT/xugoTw0up+1Pjw8E0t5FZ8I5ygmlHy/+b6oFD
X-Google-Smtp-Source: AGHT+IFGbUCXzXFEIzW8WsrS4hyJ4QiVpx5RS9Ksp7/iK8cP1pne9iQiXnvAB00Qoh/CpQkfo5spoa4BxCCd6MP/J0E=
X-Received: by 2002:a2e:a9a6:0:b0:300:324e:3504 with SMTP id
 38308e7fff4ca-3072cb665camr145518361fa.27.1737921999023; Sun, 26 Jan 2025
 12:06:39 -0800 (PST)
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
 <CAHk-=whgufZwjAuL1PBs1gjSMK95TEhGj1SiMbNvkysWBcEPMw@mail.gmail.com> <CAFULd4Z2eSJhE0qF0QEtsb-7zoOMKH=KvvrfK0M5UozLw_TYUA@mail.gmail.com>
In-Reply-To: <CAFULd4Z2eSJhE0qF0QEtsb-7zoOMKH=KvvrfK0M5UozLw_TYUA@mail.gmail.com>
From: Uros Bizjak <ubizjak@gmail.com>
Date: Sun, 26 Jan 2025 21:06:27 +0100
X-Gm-Features: AWEUYZloaViBCOSwTiRxX_xn0lcIm7VFeIl_bySVIzCVe-EHMXM6Z1k_BRDCkec
Message-ID: <CAFULd4YXs89moFp4GiEOacd2hQQU+kmRYXm-XqxKJQQGZ1U09w@mail.gmail.com>
Subject: Re: [GIT PULL] MM updates for 6.14-rc1
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Miguel Ojeda <ojeda@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org, 
	mm-commits@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sun, Jan 26, 2025 at 8:46=E2=80=AFPM Uros Bizjak <ubizjak@gmail.com> wro=
te:
>
> On Sun, Jan 26, 2025 at 7:30=E2=80=AFPM Linus Torvalds
> <torvalds@linux-foundation.org> wrote:
>
> > That does seem to work, but I'd admittedly be happier if we could just
> > find some way to dynamically disable/enable __typeof_unqual__ based on
> > which compiler is used, rather than make it a config option. So that
> > bindgen would not see it, but a recent enough C compiler would.
> >
> > We already use '__has_attribute()' for some of these things. There's a
> > '__has_extension()' thing that comes from clang but that gcc also
> > supports.
> >
> > But I can't find the list of extensions that that model supports, and
> > I guess typeof_unqual isn't on that list if I find it.

Sorry, I sent the previous message too fast.

Unfortunately, you are right. The following doesn't trigger #error
neither with gcc, neither with clang:

#if __has_extension (__typeof_unqual__)
# error
#endif

Uros.
