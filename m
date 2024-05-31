Received: from mail-pl1-f179.google.com (mail-pl1-f179.google.com [209.85.214.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D6A5EEAB
	for <mm-commits@vger.kernel.org>; Fri, 31 May 2024 01:18:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717118312; cv=none; b=kb8ITvDzMO51d76sPwKv6OnA2+TgFzQoOcEVoytuSmlAqgtfVPD5bJ28jKoFEf/xEq6ciOQhoYLWAYrPi906jPx9dCCITtjpFt/ZE9MCXbJePjHSDkmvRn/o1A+ZZk/OBmFvFxJ2pyhTGusIw8H8wmirIxgYdy8CVMfQql3u3sY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717118312; c=relaxed/simple;
	bh=mbIVrRBWaA9f9S6NeAJN9A/iWnrZ9tfyUy3q4CvKJhs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=H59AeT54Y2fZm3QLM//sAyH0Ol9AJfCo4MoGWK0UR5MIVXMcJA5Rn/5vuiv0NYC5iB/quCulqyt26E2YHc6BmeX8Rj7cw7EAEvE+KMvc0WfNGrxPdYtqC7CQ19G8Xi1yChNBY2JCrRkw5gzrTJcVsE603SYtbgaXi3tAC625do8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=TBFjQajL; arc=none smtp.client-ip=209.85.214.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="TBFjQajL"
Received: by mail-pl1-f179.google.com with SMTP id d9443c01a7336-1f44b45d6abso10434425ad.0
        for <mm-commits@vger.kernel.org>; Thu, 30 May 2024 18:18:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1717118310; x=1717723110; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=LSGeaJ1Oc7ZXMpZIWdFGVG2/y37o2POYmtqt80gQkws=;
        b=TBFjQajLTHHx7pqhCekss9LgQibxFad3V96TaTqZ6n6Y5GohwkJdHHtJ/sjl+ZFDGN
         HQ5leWBdC4GkSUYCvLuNpG+42iU1+LOINPAkzOaAahRNimiimKbq6N9+vyPw5/+idqVB
         ehrFUcN04Qj4XIYYcIRyRpZRQUccY+YjQgYKjMF29hcQwwjhV26cEBtBiYLRxm2BdLRp
         je79JcL6FBhzOrd0LhDUPatN+QANQuadoJPUF4PVyThDz3qnUH7H7S0iN/M6rdedTHlr
         32eeqgjpTKyMgBKfohIrYAE3oylplEdBZsEZ2Y1LzDA09NAlNtSLntEaIb1WCnfNC1C4
         gX9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1717118310; x=1717723110;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=LSGeaJ1Oc7ZXMpZIWdFGVG2/y37o2POYmtqt80gQkws=;
        b=NfmMz/hMEawSGArI1EDbEL+CMvvjdARFlasf+Vi0U6nyo63pACqKb5RHoWDTuKZiHV
         3w5MLaMzVPZSGUgDDVIzZPE5GgZhSQlooCwfeOlVYPcB2nWmId9Gs9gk4hsiWWdV3RHh
         cUrLKQBGTgrvKlrqXw6OsYXfwO21IzwppAmShz6c8WEWQ6bHxNMBURbpm9qGDMY8EPD5
         LRd7i4ZAxaBPwwVOz1fxwSD2QpL7WbLPmiw0Ey+LMFssK30fQQOBodxBKQKyqPICBoS/
         6bQHoQCY7yfKJQcQha1vR5jviLJWL5BBB6oL5dW1g+9wHKQvcJxlWnt5y0UpNhJU3cbv
         nA0Q==
X-Forwarded-Encrypted: i=1; AJvYcCX7/OtY7hBp65hu3uod09+GyGqMYVYBIhIYCOdgCYkjJHClSoRVsoY2E9kUdk6oIVV9oK7b81rPu9DH0A708g4gTrPOAMmCUzmfIA==
X-Gm-Message-State: AOJu0YxJO20fbB6v1iGXYboxynB/8xXuMDgHOzqnfo7AIeVpDiHkNbb7
	uNs13lCfomA7+9ETVcUS1s3WYsQmSrEui0BXBROG4vnnWTSZvD7DMpNgsA==
X-Google-Smtp-Source: AGHT+IGjsYM3BvJ17Yz9iTTvE/7i0W6pnppdevq7AbtPQLxrm+6sKx3Wd9fy+tZq2s3QydK2bkjC9g==
X-Received: by 2002:a17:902:e5c3:b0:1f4:f1c1:646b with SMTP id d9443c01a7336-1f6370200d2mr5585155ad.33.1717118310313;
        Thu, 30 May 2024 18:18:30 -0700 (PDT)
Received: from localhost ([216.228.127.129])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-1f632416d7asm4273865ad.286.2024.05.30.18.18.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 May 2024 18:18:29 -0700 (PDT)
Date: Thu, 30 May 2024 18:18:27 -0700
From: Yury Norov <yury.norov@gmail.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Andrew Morton <akpm@linux-foundation.org>, mm-commits@vger.kernel.org,
	yoann.congal@smile.fr, Vincent Guittot <vincent.guittot@linaro.org>,
	Randy Dunlap <rdunlap@infradead.org>,
	Petr Mladek <pmladek@suse.com>, Nhat Pham <nphamcs@gmail.com>,
	Masahiro Yamada <masahiroy@kernel.org>,
	"Gustavo A. R. Silva" <gustavoars@kernel.org>,
	"David S . Miller" <davem@davemloft.net>,
	Alexander Lobakin <aleksander.lobakin@intel.com>
Subject: Re: + gcc-disable-warray-bounds-for-gcc-9.patch added to
 mm-hotfixes-unstable branch
Message-ID: <ZlklY6LkIhn98S6Q@yury-ThinkPad>
References: <20240524030008.78A1AC2BD10@smtp.kernel.org>
 <0ab2702f-8245-4f02-beb7-dcc7d79d5416@app.fastmail.com>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0ab2702f-8245-4f02-beb7-dcc7d79d5416@app.fastmail.com>

Hi Arnd,

On Wed, May 29, 2024 at 04:39:45PM +0200, Arnd Bergmann wrote:
> On Fri, May 24, 2024, at 05:00, Andrew Morton wrote:
> > ------------------------------------------------------
> > From: Yury Norov <yury.norov@gmail.com>
> > Subject: gcc: disable '-Warray-bounds' for gcc-9
> > Date: Wed, 22 May 2024 15:58:30 -0700
> >
> > '-Warray-bounds' is already disabled for gcc-10+.  Now that we've merged
> > bitmap_{read,write), I see the following error when building the kernel
> > with gcc-9.4 (Ubuntu 20.04.4 LTS) for x86_64 allmodconfig:
> >
> > drivers/pinctrl/pinctrl-cy8c95x0.c: In function 
> > `cy8c95x0_read_regs_mask.isra.0':
> > include/linux/bitmap.h:756:18: error: array subscript [1, 
> > 288230376151711744] is outside array bounds of `long unsigned int[1]' 
> > [-Werror=array-bounds]
> >   756 |  value_high = map[index + 1] & BITMAP_LAST_WORD_MASK(start + 
> > nbits);
> >       |               ~~~^~~~~~~~~~~
> >
> > The immediate reason is that the commit b44759705f7d ("bitmap: make
> > bitmap_{get,set}_value8() use bitmap_{read,write}()") switched the
> > bitmap_get_value8() to an alias of bitmap_read(); the same for 'set'.
> >
> > Now; the code that triggers Warray-bounds, calls the function like this:
> >
> >   #define MAX_BANK 8
> >   #define BANK_SZ 8
> >   #define MAX_LINE        (MAX_BANK * BANK_SZ)
> >   DECLARE_BITMAP(tval, MAX_LINE); // 64-bit map: unsigned long tval[1]
> >
> >   read_val |= bitmap_get_value8(tval, i * BANK_SZ) & ~bits;
> >
> > bitmap_read() is implemented such that it may conditionally dereference a
> > pointer beyond the boundary like this:
> >
> > 	unsigned long offset = start % BITS_PER_LONG;
> >         unsigned long space = BITS_PER_LONG - offset;
> >
> >         if (space >= nbits)
> >                 return (map[index] >> offset) & BITMAP_LAST_WORD_MASK(nbits);
> >
> >         value_low = map[index] & BITMAP_FIRST_WORD_MASK(start);
> >         value_high = map[index + 1] & BITMAP_LAST_WORD_MASK(start + nbits);
> >         return (value_low >> offset) | (value_high << space);
> >
> > In case of bitmap_get_value8(), it's impossible to violate the boundary
> > because 'space >= nbits' is never the true for byte-aligned 8-bit access. 
> > So, this is clearly a false-positive.
> >
> > The same type of false-positives break my allmodconfig build in many
> > places.  gcc-8, is clear, however.
> 
> I'm not too happy about this one,

Neither me

> I think this is mixing up
> a couple of independent issues, and makes it harder to
> ever enable the warning again.
> 
> The bitmap.h code looks suspicious to me, and if gcc is
> unable to analyze this as a false positive, it probably
> also can't optimize it correctly,

In the b44759705f7d Alexander says:

  bloat-o-meter shows no difference in vmlinux and -2 bytes for
  gpio-pca953x.ko, which says the optimization didn't suffer due to
  that change. The converted helpers have the value width embedded
  and always compile-time constant and that helps a lot.

Bloat-o-meter itself is not a measure of how effective the code is,
but it's a good hit that code generation before/after is at least
on par. Have you an evidence that the patch makes code generation
worse?

> so it may be better
> to either not have this as an inline function at all,
> or find an implementation that gcc can optimize better.

The functions look bulky but it boild to one or at max two words fetch
plus shifts. Inlining helps to generate better code, particularly in
the bitmap_get/set_value8 case because masks and offsets generation is
done at compile time.

We had quite a few cycles back then... Alexander, can you please
share on code generation, particularly inline vs outline versions?

> In the meantime, I would suggest reverting b44759705f7d
> ("bitmap: make bitmap_{get,set}_value8() use
> bitmap_{read,write}()"), until the implementation is
> improved to work without a warning.

I think there's nothing to improve. This is clearly a false-positive
GCC warning, and it should be fixed on GCC side.

> The other problem I see is that the warning is
> disabled globally even when building with W=123,
> and I think we should change it to always warn at
> least with W=1 regardless of the compiler version.
> It's also likely that the other false-positive
> warnings only happen when sanitizers are enabled,
> so we could turn it on by default without sanitizers
> and move it to W=1 with sanitizers.

Interesting. If sanitizers are involved, we should do like you said.
But this is a matter of a different patch, I think.

Thanks,
Yury
