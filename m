Received: from mail-ua1-f52.google.com (mail-ua1-f52.google.com [209.85.222.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF6671CF91
	for <mm-commits@vger.kernel.org>; Mon, 19 Feb 2024 05:22:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708320157; cv=none; b=IhZf1Oh9TuxFYUNdKNlY6rEFCuP30CLnTr9UqOPQUHTJJ65N19T+uW1fE7wZEqHRff+14k5Zh6eBrs7QW9iMQyd+EPVEDmmkZ8NELvJLxSgNklFqhwfiJGteVRHzJNM3n+OzfW8GnoEp1EKcP/bx42hcMCIITQy3UKOzQRVVzCg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708320157; c=relaxed/simple;
	bh=fOJnVFfVvWksg2wwYyceHa/FS9Vjun2tyAoCP9nW0dY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=IBXwmFDN5weBFaohwvV29oYi48s6pi96O2Tn68Sz6U85BtNfWjNuHjFMfAMVT5tmA6Ib1AMF5Y7/sGrGzN/xF5ZH1pWjwmgUIgHJM/c3g99sekJ9eS9GDyaSJO+mQ5dFyuGFORmaUYPYpMLxnmGY83Z04eGcXQiUuuS8JblAW+M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=aHXq7706; arc=none smtp.client-ip=209.85.222.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="aHXq7706"
Received: by mail-ua1-f52.google.com with SMTP id a1e0cc1a2514c-7d5c2502ea2so1109254241.1
        for <mm-commits@vger.kernel.org>; Sun, 18 Feb 2024 21:22:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1708320154; x=1708924954; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=g8JQmnCuFoDCNIGRyPM+2PCjDC7aiGoi67zceUW/I6g=;
        b=aHXq7706poNXoWoUe0xWS36UbVVFVdfouEhLeQqGa7iAudVE90CQcwz7DLoob4R2aQ
         Yc4hCUasquW1lF9EADjU8T4bfjUEMkWZSUCLStueJknqBNjhJrZg9XIkIgQbZ6OOstfw
         u7BOvOYGMW+h6tp5u0t1vkidkmzLmNhMaUdC7Vs+O9vxH+fHZvUguiZtY4tK2yYA0V1k
         HXXEErDFyI7eOrRKneglwkLX6q8M4UEhsoBZNQIiFbjuzUBjcAKZoteU7c5rEl8ulY0H
         ilGMxl/F7vb0WvEesz4YSgmH2+6W0uNGZTYVqwYjTKuwVg+4Pd3ghaDTSUHpLW3jDQo+
         VHQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708320154; x=1708924954;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=g8JQmnCuFoDCNIGRyPM+2PCjDC7aiGoi67zceUW/I6g=;
        b=arukfj7LEyti/fuy0ILGwZf8v0QRGYGQAbIuHP85/RHZqPyVnauMe99Z0y59omJcto
         d/WjKcGhiOiMYiZOBramkbd1SqTeWX/dxPwXJOpAnxP0zcIsac0fdW2P3qqS7tMCxiif
         IMACqMcVM6xD01LgmAQZa4EBPLQHxis3WPl2FElHGmWTfBD3bD18eS31KcWFf8hqWjji
         s7RKjmpHztry/WQj04KB1jMKwv50cOvJWNXcKMVDMcAMBGFG6ehqwF5RJgicf1KV9VuF
         RJqqhBf7kxx/RHPtTaIC+9ywRO8Yx+84O9Luw0VAZSwlgPCCWpfviRb6TYSYxpLbQlR+
         sc8g==
X-Forwarded-Encrypted: i=1; AJvYcCX6/NwIs3lSTk1Nv7o+k4o06/pvHfGgaA0hbkajDIaX/NbQwyWLSNdcQLxEUwQQeZZ1WtEVvbYZdoaduDvBjB3poYVDHbO3aRYs3Q==
X-Gm-Message-State: AOJu0YwyeJT6F89ManR8NCGoD9OQTdQ6mtrhqeZTc/mSKKEOCZ8sPRxP
	c1cRhdkBhO1pHEGF3hpUM5/mrs2tSXD52SpTWVVvR2f66MpHoksayzV+YGXPXIQdIEUVP9owwss
	dbaxWofdrMaNA1zWkZFy5zQLL33Q=
X-Google-Smtp-Source: AGHT+IEmtpyV266CK0vQv3CD+jdeUZaoTg/zBrkj1P2gMrSqHT5k1ixuH151/1in3X1wuISdG/TKXtnDUlS/iDmrOf0=
X-Received: by 2002:a1f:f48c:0:b0:4c6:bbd1:b87f with SMTP id
 s134-20020a1ff48c000000b004c6bbd1b87fmr3482843vkh.7.1708320153019; Sun, 18
 Feb 2024 21:22:33 -0800 (PST)
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <ZdK4x9J/hhReO6wg@gondor.apana.org.au> <20240219040317.5184-1-v-songbaohua@oppo.com>
 <ZdLW0/cLS0YT6P9E@gondor.apana.org.au>
In-Reply-To: <ZdLW0/cLS0YT6P9E@gondor.apana.org.au>
From: Barry Song <21cnbao@gmail.com>
Date: Mon, 19 Feb 2024 18:22:21 +1300
Message-ID: <CAGsJ_4y5hWbi5gvk5aP352nOH+YdVLZHi6mxNHgPghBk4YPuhA@mail.gmail.com>
Subject: Re: + crypto-introduce-acomp_is_sleepable-to-expose-if-comp-drivers-might-sleep.patch
 added to mm-unstable branch
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: akpm@linux-foundation.org, chrisl@kernel.org, davem@davemloft.net, 
	ddstreet@ieee.org, hannes@cmpxchg.org, mm-commits@vger.kernel.org, 
	nphamcs@gmail.com, sjenning@redhat.com, v-songbaohua@oppo.com, 
	vitaly.wool@konsulko.com, yosryahmed@google.com, zhouchengming@bytedance.com, 
	wangzhou1@hisilicon.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Feb 19, 2024 at 5:19=E2=80=AFPM Herbert Xu <herbert@gondor.apana.or=
g.au> wrote:
>
> On Mon, Feb 19, 2024 at 05:03:17PM +1300, Barry Song wrote:
> >
> > Not Andrew, i wrote a note in cover-letter and said zswap was
> > the direct user for this patch, so it is good to go through
> > mm. but it's also fine to go through crypto.
>
> Even if we decided to export whether an algorithm is sync or not,
> the approach taken in the patch is not the right way to do it.
>

i agree this might not be the best way, i was looking for a better
way and i couldn't find it. actually sent an email to you regarding
this and asked for your help before[1] :-)

[1] https://lore.kernel.org/linux-mm/CAGsJ_4yk=3DyrpBWvYukoDbq8288yqLLyox4o=
zg82GiUyaU+ntWQ@mail.gmail.com/

> You're exporting an internal data structure and making it available
> to everyone.
>
> > But the problem of directly using scomp is that we are losing
> > the chance to use hardware like intel/qat/qat_common/ and
> > hisilicon/zip/zip_crypto.c to offload the overhead of
> > compression/decompression as those drivers have no scomp.
> > On the other hand, acomp with acomp backend can sometimes
> > decrease cpu usage especially when PAGE_SIZE is big such
> > as 64KiB while providing higher performance.
>
> No I'm talking about using scomp only in the specific case of
> an unsleepable context.  If you think acomp offload still
> provides a sufficient benefit in that corner case, please
> provide the data to back it up.

The difficulty is that we request comp at the beginning, with
acomp api, its backend can be either scomp(if hardware has
no offload) or acomp(if hardware has no offload and algorithm
is supported by this offload). we can't dynamically switch to a
scomp api only within an atomic context. and once we are using
zsmalloc, we are always in atomic context with no exception.
so it isn't a corner case for zsmalloc. The patchset is aiming to
fix the performance for hardware not using acomp offload -
which is true for almost 99% hardware in this world.

offload should always be a good option, the only question
is here if we allow offload driver to support scomp. i think
the answer should be yes. i think it only makes sense to
compare: offload by scomp vs. offload by acomp

it doesn't make sense to compare  offload by acomp vs. CPU
compression/decompression by scomp. this is comparing
apple with pear.

I think it makes more sense to discuss dropping acomp
support in some cases of zswap after crypto opens the option
to allow offload driver support scomp. offload is much faster,
but while page size is smaller, async wait/wakeup might
cause latency. so busy-wait in offload drivers could be
better for small sizes like 4KiB.

I do agree a lot of data is needed to back up the above
discussion. but I will need Zhou's help as I don't have
hardware with an offload driver now.

Would you consider this as an incremental job after this
patchset?

>
> Thanks,
> --
> Email: Herbert Xu <herbert@gondor.apana.org.au>
> Home Page: http://gondor.apana.org.au/~herbert/
> PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

Thanks
Barry
