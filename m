Received: from mail-wr1-f43.google.com (mail-wr1-f43.google.com [209.85.221.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2588B629
	for <mm-commits@vger.kernel.org>; Sun, 17 Nov 2024 00:17:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731802650; cv=none; b=rbmjV4kc+6DLD5JAipzMWGMkQ4hVtiW1uhvcl0GmNUQJKFerWLDloZ7oo/Oqm7ZCiCnagCiTy0tZMX1ccf+ep1n/yU1+DDbP9YsbLHK1iOVBagD6uOJ+v4EzZ53bStsijENzIGF9CZ9GQa3hGwHPOjnw2fxjvvKjKDe/qcdE86w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731802650; c=relaxed/simple;
	bh=1Nqxs9q3mTk8yYp9yleEw57lik/PJU6/xEBFJRFNcEg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=XpdM7pFdeQwAeZGzmfunyZzrdobLQ8dnCMo1K2tyotkMAvtxPS0U0SNEh6QRuR9nXlHjufOoNyAvJf+YNo4j0+X/pr14JnSDqeI2cWb7R6xWEha92BrncaOELY/GWuznb3p7oXoCukGs3lyBT7PzoREY0ZhDDVdvoWUlBYbtVZc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Vf7CYpr8; arc=none smtp.client-ip=209.85.221.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Vf7CYpr8"
Received: by mail-wr1-f43.google.com with SMTP id ffacd0b85a97d-3822429c615so1012285f8f.1
        for <mm-commits@vger.kernel.org>; Sat, 16 Nov 2024 16:17:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1731802645; x=1732407445; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=j+vJsz7FXCzpM7ZnAh9+lq2u44q1RCsUt4nJBaoI93s=;
        b=Vf7CYpr8uFXHAXf5ri5H7078lRU9GNFhSOQTiwbc+J3xMBJgq72Gj/6VawEiPJAwpj
         UP5D6lfBzb05S0vI3O3SWFqcqDdB8dT7aLzgdf7cDxUhacSc34pUvdv7BNyC2XU1TbCL
         FCLZr5EN2sThx34qPnzkWHQPLoKRjNHtEElJ8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1731802645; x=1732407445;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=j+vJsz7FXCzpM7ZnAh9+lq2u44q1RCsUt4nJBaoI93s=;
        b=Od/fcMfa33T2OUIDN6cfg+27FUMf2X6ndFYp3FZLCjbDYh+Ow17vRTVRTRQQeVIO9L
         16GGkh5O/wWi8jia4WDP7C6TjBjR3kEa+zKjLfRsg0H2D9vafuKrGmIheV8TF/dxi1hM
         cTDQEScCCZ3g7TBlTwnIhet2kzP/uTS8nTiYg5Po19OX/pA4ClHPgNZO4mTNux9WTn9v
         vuc+wdgvAxhdxWg59LnlfpBVEEj1OgeyuMrBVdCDvUQryKyHMO0YpWee5fN3Sq96XX9S
         6oXCcpmSlB8dfz4q/FJ6eJpGVpXXOhGbianpH90ratXd/gafhFIdjcunAUS+2PL4GWwu
         uD9A==
X-Forwarded-Encrypted: i=1; AJvYcCUbCCzDSe6qw5OVIUdIv+gIeGtOPM1CMhKgL/wV32qMsW2O4OfXdIx0fe6INq+DegxtE/YiMveaiSGy@vger.kernel.org
X-Gm-Message-State: AOJu0Yw1SxM6NXpAk0YuoyBUfE5nXRlPUcbZImVUqpl7pKN43la/VoMg
	ewMhCA0tUbLG6ySs8cDUYzKCa2LmuJKpt3jQO6XTCDSc+LSYD3tpJy3oN9QB1oaSEV/QpTvu5iY
	aQ5Y=
X-Google-Smtp-Source: AGHT+IHz75b7hNQRg4nOOlpaqBGR83MFKWlRW2gzcIkYWJzpedTZmZBBdlgC/7lFcMiXZqOMrKJzVA==
X-Received: by 2002:a05:6000:4289:b0:381:eb8a:b81b with SMTP id ffacd0b85a97d-38225a83ba1mr7842796f8f.33.1731802645503;
        Sat, 16 Nov 2024 16:17:25 -0800 (PST)
Received: from mail-wr1-f41.google.com (mail-wr1-f41.google.com. [209.85.221.41])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-aa20e043bbcsm356974566b.152.2024.11.16.16.17.24
        for <mm-commits@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 16 Nov 2024 16:17:25 -0800 (PST)
Received: by mail-wr1-f41.google.com with SMTP id ffacd0b85a97d-37d4ac91d97so899289f8f.2
        for <mm-commits@vger.kernel.org>; Sat, 16 Nov 2024 16:17:24 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCXwuSdeiq4WSbXXsW/jjykzxgnSU3hmIpGVqGSvqS+euSs89eLN8NsPX82pCW1ymHSJ4l+s+fNrYgY2@vger.kernel.org
X-Received: by 2002:a05:6000:1fa3:b0:382:5af:e996 with SMTP id
 ffacd0b85a97d-38225ab7a3bmr7775914f8f.46.1731802644402; Sat, 16 Nov 2024
 16:17:24 -0800 (PST)
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20241116153556.767f1aeed6ac628a09efe346@linux-foundation.org>
In-Reply-To: <20241116153556.767f1aeed6ac628a09efe346@linux-foundation.org>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Sat, 16 Nov 2024 16:17:08 -0800
X-Gmail-Original-Message-ID: <CAHk-=wji0ErHJjX-ZE4fdQ02nxcqQa5pwV==1sHC3p91wxUXAA@mail.gmail.com>
Message-ID: <CAHk-=wji0ErHJjX-ZE4fdQ02nxcqQa5pwV==1sHC3p91wxUXAA@mail.gmail.com>
Subject: Re: [GIT PULL] hotfixes for 6.12
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org, mm-commits@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, 16 Nov 2024 at 15:36, Andrew Morton <akpm@linux-foundation.org> wro=
te:
>
> Motiejus Jak=C3=85`tys (1):

Ugh. I've pulled this, but you have something *seriously* wrong with
your locale settings.

That should be "Motiejus Jak=C5=A1tys", not the garbage line noise you have=
.

Please make sure that *all* your tools are using proper UTF-8 and
Unicode. When you do

  $ echo $LANG

you should get something like "en_US.UTF-8". If you have something
like "en_US.ISO-8859-1" you need to set your machine on fire, and
throw it out the window from the 43rd floor.

I can see the original at

   https://lore.kernel.org/all/20120315030631.GA28296@pierce/

and it has a proper UTF-8 encoding:

   From: =3D?UTF-8?q?Motiejus=3D20Jak=3DC5=3DA1tys?=3D <motiejus@jakstys.lt=
>

that you have broken somewhere in your toolchain.

I have no idea where that breakage happened, but it looks like
something treated '\xC5\xA1' as two Latin1 aka ISO-8859-1 characters,
rather than as one UTF-8 encoded Unicode character.

That something isn't "git", so it's probably some effed up script of
yours, or the fact that you have some 16th century locale setting.

Please fix whatever horrid breakage you have, and get with the 21st
century. Latin1 and broken locales just aren't ok any more. You are
mangling peoples names horribly.

And yes, your email was marked as

    Content-Type: text/plain; charset=3DISO-8859-1

but that's only the tip of the iceberg. The name is incorrect in your
git branch.  You really have some totally broken setup.

              Linus
