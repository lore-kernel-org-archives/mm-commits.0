Received: from mail-lf1-f46.google.com (mail-lf1-f46.google.com [209.85.167.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B50B3F8C4
	for <mm-commits@vger.kernel.org>; Wed, 10 Jan 2024 09:44:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="AePBWAUD"
Received: by mail-lf1-f46.google.com with SMTP id 2adb3069b0e04-50eac018059so4862090e87.0
        for <mm-commits@vger.kernel.org>; Wed, 10 Jan 2024 01:44:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1704879867; x=1705484667; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Z/GyLdTtM/OnXSNZXFAQn8x+qjf9pxe1G7VU4q+zLu4=;
        b=AePBWAUDji633z8uqIntwK/lwk4tbOkwMod438hJMFp9ctlybjafM7oINFW8fcAMCy
         wn+zE1bpTfX50H5/3tSozX48ejz9ipSvbHo69pXNQpTKvyvW9wQyGRQFXM8tMsfvR/ao
         mhq2Ca852o/WS5Rv24kNUs3q9uroo465Qip3lOf31K0l8bGiFCDWnEL1N3pa8sKNqHby
         tGGne3CrqN1ymvwSa3F5gT1Ea8qIz3aQJhB3+SZSk0KbR1z5o7Gs7W6CTKca17E2Y0LY
         ULy4Z1AVGBAW202DLqZI+xPlLDdszubi1PMUcXRREE3YZnIOdjWJ0hqINvC55+NRpjBi
         mCTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1704879867; x=1705484667;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Z/GyLdTtM/OnXSNZXFAQn8x+qjf9pxe1G7VU4q+zLu4=;
        b=NnysqdFE+OnJPrQo0iSr8vNyQGIxDLleI26vPfdgIYmjNrzRh+a9WGum+nOL+UVSd1
         KXHF2ZEpeN+bT9YG4RZPivOwx9I4A1B2Oug0l5dg7a5e1UXSfsPSM311m0rbHIJzoQe6
         ReTnD2Qo/uME7LfbFKXKKlz4Bp62UxsZ+vQ5XhiSj8ihNX1hpXvRayLYf2odFWwYU00y
         PtZTrb/AGkUmMcX67sFMZ1CFqZaM5+EPKBfCt2hQXhJ/53J7sxPSR5jAXlBlqeDOTXe+
         MwOc4yQNVz/khALilaBn6qE4eKNGXB8IeBbcu2ES8hzbD+PCpmF36j4gSzO7YzLvpWNH
         0D7Q==
X-Gm-Message-State: AOJu0Yxuad5A+4ZxojrwEmoiuMX9ZynqwfeeoLuWlIN4gqECTOnckbyx
	B8RQyW0ZnyZN/tr8o+L0bdddgSUHuT/YavsTwim+W3A5/Ifx
X-Google-Smtp-Source: AGHT+IHr8s4tDXvq0TvI+5AiTouqmWth496mePjRpyBNbf/mSbI1EAkny+vGVcHXe8nkMiCz0EcBfMhtyiRD+Al4kEY=
X-Received: by 2002:ac2:4948:0:b0:50e:d157:ffbc with SMTP id
 o8-20020ac24948000000b0050ed157ffbcmr270644lfi.109.1704879867260; Wed, 10 Jan
 2024 01:44:27 -0800 (PST)
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240110043220.633ADC433C7@smtp.kernel.org>
In-Reply-To: <20240110043220.633ADC433C7@smtp.kernel.org>
From: Yosry Ahmed <yosryahmed@google.com>
Date: Wed, 10 Jan 2024 01:43:49 -0800
Message-ID: <CAJD7tkbUrBCnPYmw9_euwOzJ4UcHpNvHSMRHBULR-NgjDWcMaQ@mail.gmail.com>
Subject: Re: + mm-zswap-switch-maintainers-to-recently-active-developers-and-reviewers.patch
 added to mm-hotfixes-unstable branch
To: Andrew Morton <akpm@linux-foundation.org>
Cc: mm-commits@vger.kernel.org, vitaly.wool@konsulko.com, sjenning@redhat.com, 
	nphamcs@gmail.com, ddstreet@ieee.org, hannes@cmpxchg.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Jan 9, 2024 at 8:32=E2=80=AFPM Andrew Morton <akpm@linux-foundation=
.org> wrote:
>
>
> The patch titled
>      Subject: mm: zswap: switch maintainers to recently active developers=
 and reviewers
> has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
>      mm-zswap-switch-maintainers-to-recently-active-developers-and-review=
ers.patch
>
> This patch will shortly appear at
>      https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree=
/patches/mm-zswap-switch-maintainers-to-recently-active-developers-and-revi=
ewers.patch
>
> This patch will later appear in the mm-hotfixes-unstable branch at
>     git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
>
> Before you just go and hit "reply", please:
>    a) Consider who else should be cc'ed
>    b) Prefer to cc a suitable mailing list as well
>    c) Ideally: find the original patch on the mailing list and do a
>       reply-to-all to that, adding suitable additional cc's
>
> *** Remember to use Documentation/process/submit-checklist.rst when testi=
ng your code ***
>
> The -mm tree is included into linux-next via the mm-everything
> branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
> and is updated there every 2-3 working days
>
> ------------------------------------------------------
> From: Johannes Weiner <hannes@cmpxchg.org>
> Subject: mm: zswap: switch maintainers to recently active developers and =
reviewers
> Date: Tue, 9 Jan 2024 14:02:00 -0500
>
> Yosry, Nhat and I have been doing most of the recent development and
> reviewing of changes in this space.
>
> Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
> Acked-by: Nhat Pham <nphamcs@gmail.com>

Acked-by: Yosry Ahmed <yosryahmed@google.com>
