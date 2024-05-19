Received: from mail-yb1-f181.google.com (mail-yb1-f181.google.com [209.85.219.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2D7247A60
	for <mm-commits@vger.kernel.org>; Sun, 19 May 2024 21:16:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716153395; cv=none; b=Zs0CLcrviUjQL7kYj+b2w4tMyoR3t598W8+o7U44I18p40/MUN/BESxwIMpHr8Mzo+pULreErpuoG4FvK9VffyTrsIWbh84nNmDbu9imW+KBHPcawiMKFMZeidLDTHlcd8rTN3Ev8gOH+kDg4TpILHVVjFakLElyZHSg6+l5nxA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716153395; c=relaxed/simple;
	bh=aepYcjZoe1VltFPIAkhmsPx3W+z0i3qcRSlTsZdDdn8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=H1WRdLiF8La0IwZbiK9E+Pe8Q+x1ZlRnce0sx+Wxlmj7u6XeIT3tAIk4s7/64/tU0jaRrBl4hjhA6Xj+Aikas3uK26Av7xwA1Ejj/CdeAeePnOPzXKyz8zztV97ofXPKRUeESNcGXV6u6wbv2bof5a35A90Tve7jNmGpBBYMAQc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=MoZtzqpf; arc=none smtp.client-ip=209.85.219.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="MoZtzqpf"
Received: by mail-yb1-f181.google.com with SMTP id 3f1490d57ef6-de8b66d1726so1321327276.0
        for <mm-commits@vger.kernel.org>; Sun, 19 May 2024 14:16:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1716153392; x=1716758192; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=aepYcjZoe1VltFPIAkhmsPx3W+z0i3qcRSlTsZdDdn8=;
        b=MoZtzqpfixF+7cdaaXVyiaK7tJUR1oO/CzN4Vv1V4Gbr2/3g/s9akEo1Y/uXyh1/Ir
         1PXijxtlI54UevJFw6jZy99ZevEPSMzMkXWEOpmWtfbhXSIfz1jYmipHZ07CdgYKEx+J
         non5EQ+Yla0qIabmfSML6LLa6ew8W3XL33F5X4atQvILoqfTEmYpYAHzxYFu8I3w4s0k
         O0pRiOf17gNKDhbdTBoOsJ+apjkxL/T+INGka1rWC17AWTzZ8WJXIAy1MVAq5CZsuezo
         gsm4RNIKMDp8djpN/kfrMVJW8Z24jPvqIjYeA4VD80ZA3VtydCit9SL9supAHn7yZtZ6
         XmBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1716153392; x=1716758192;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=aepYcjZoe1VltFPIAkhmsPx3W+z0i3qcRSlTsZdDdn8=;
        b=iMM7nIFM28XsJLf8yzI9X99WltmYKW6a589N6HC4Qxcaxi46IG+EKJJIBwgjAGEjQI
         UIq/gt0LUSAu/5vrAltUIu2+1GOT3m8D22oKzlBpdQ5QGUXjgvEKbNrY2XO3E8RHXUgL
         b5VdiGBmh7aqofO2BNAo+4UGTKt0T/fK9bohMappJJndznRkVPu6tCz+xJUdc7Plu5Gl
         TJjPOc0+v4fmzyO8svZTC9zxuuFba8HPJMG6bpaGqbDkULltlo2np7qm2qToycZnPrSM
         6uRgWZzhBJmzsEMXHJHHx+8EIiZWywxeZ8yQgQPezr4Rp7H/2JWdkkAa0kx5So5yEcti
         /Vvg==
X-Forwarded-Encrypted: i=1; AJvYcCWipETzCyg9H3+xoD5XValAcg9/j5/9WWRmWJ/6Y8bcPSfgmZKSqwVGwheUqKpd3TudRay75Sp3Wzj1+yosl4DZOFv1zWv8Za+H+Q==
X-Gm-Message-State: AOJu0Yz+hVRT5lkvQ0fvXpb667OfvW6GGPiX6OdBqWjjy1d0eZ21vA9h
	tCyAxtBTIoJ1dKG6K2GzBRHJ5juwfDQTEV48sQ6/zFddV2tSa5SixuxAHbEDRwI+6RlGktVEf1h
	gdAu+NvXo0VRU10NVdCLBzVRzt4w/3NaDBfOt
X-Google-Smtp-Source: AGHT+IE69gHLeUIav2qwSBHMXCXDWEAkZ0MCjYZT0jU6CvB7u6z5f78gziAFXfnbpZDqnwxL4OABn3LeV4aQD7rNGBg=
X-Received: by 2002:a25:5103:0:b0:dd1:6cad:8fd3 with SMTP id
 3f1490d57ef6-df49062935bmr3300167276.27.1716153392254; Sun, 19 May 2024
 14:16:32 -0700 (PDT)
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240517192239.9285edd85f8ef893bb508a61@linux-foundation.org>
 <CAHk-=whEAquncw0wb59-XVAHmVh4CWSfwuWh4bTJjJzvx0=PzQ@mail.gmail.com>
 <CAHk-=whSiUg7dggHaBLULuF6_GB6NORLDByog0p=Qo+0ewmZSA@mail.gmail.com> <5qcafqbnrox7r5m4kghgykahtp2pusmhwfxqzrmhgvavxxsdux@ao2tce7nppey>
In-Reply-To: <5qcafqbnrox7r5m4kghgykahtp2pusmhwfxqzrmhgvavxxsdux@ao2tce7nppey>
From: Suren Baghdasaryan <surenb@google.com>
Date: Sun, 19 May 2024 14:16:21 -0700
Message-ID: <CAJuCfpHA1TA0DqO31yVW18uPVh8zXMHyvxxokyBV4vFqt4-q1Q@mail.gmail.com>
Subject: Re: [GIT PULL] MM updates for 6.10-rc1
To: Kent Overstreet <kent.overstreet@linux.dev>
Cc: Linus Torvalds <torvalds@linuxfoundation.org>, Andrew Morton <akpm@linux-foundation.org>, 
	linux-mm@kvack.org, mm-commits@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sun, May 19, 2024 at 11:02=E2=80=AFAM Kent Overstreet
<kent.overstreet@linux.dev> wrote:
>
> On Sun, May 19, 2024 at 09:48:49AM -0700, Linus Torvalds wrote:
> > On Sun, 19 May 2024 at 08:32, Linus Torvalds
> > <torvalds@linuxfoundation.org> wrote:
> > >
> > > I'm going to take this pull and fix up the cases I find, but I'm not
> > > happy with this kind of trivial C preprocessor misuse.
> >
> > I did some other maco handling cleanup too and tried to regularize
> > some of this all, and it seems to work for me. But somebody should
> > double-check, and it's possible these patterns should all be
> > regularized further with a few helper macros for the whole "add
> > __GFP_ZERO to argument list" or similar.
>
> I just double checked slab.h, gfp.h and percpu.h, and scanned through
> the diff vs. 6.9 for include/linux/ - looks like you got everything.

Sorry about that. Yeah, I could not find any other place that was not
fixed. Thanks for noticing and fixing them!

>
> I think we can slim down the API surface of slab.h some more too, we're
> now exposing three different ways of saying "trace/track this allocation
> here": _trace, _track_caller and _noprof vs. normal; I think after a
> cycle we can see if the old variants are still needed or can be
> consolidated somehow.
>
