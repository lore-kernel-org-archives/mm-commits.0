Received: from mail-pl1-f176.google.com (mail-pl1-f176.google.com [209.85.214.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87EAA17C223
	for <mm-commits@vger.kernel.org>; Fri, 31 May 2024 19:48:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717184897; cv=none; b=VId15Ff/LakeWnCz7fQvEzGXCJO/6Q86N7xKVz/AtCQrLNPigchwoGBQEbokja7Z5mZzswhL6ps9GY6wm11jgMwZSTydCw/6+6yJXvn5SIjZcwjbm7DMEOBW63nkvJQFjgiX2PyJ5swAweb+gn2XpkegpNXY8EHEAYIWp5ytdFc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717184897; c=relaxed/simple;
	bh=99NrswdRgWy/lXod2Qmcupgjoafhas/g2RveaQT4+ZQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=iNnlSrMPIP+Kq7BEVBDYCJUwNngNpwTL69pCmDWpQe8k438bnlaRqnZVtBL5i1AnfgQa4bCxH7WE2BMEQdkF3kPpx3bKZxS5FH+NOlh5XUGzrGkd3MwTG7etYJIzWTGH49t3M8SeCN0Otmx5qOtaSc9Kdw3dYADSv0WOfamxkJE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=SWnDmM0B; arc=none smtp.client-ip=209.85.214.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="SWnDmM0B"
Received: by mail-pl1-f176.google.com with SMTP id d9443c01a7336-1f44b4404dfso21682295ad.0
        for <mm-commits@vger.kernel.org>; Fri, 31 May 2024 12:48:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1717184895; x=1717789695; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=kMUfRlTkOBaBLQQELZe980nJMQVeFJKdXyeCyLEM3ZA=;
        b=SWnDmM0BtxpwttYX/vMZvLnLF8GzbYwA9K0uG30iJp9YRysnW1yNfqOkKhWZyuP9p1
         mzpl4VujtMCTfjjPFZkCu58JWO9ojtlEov/MVhZ4Y60ijPhOXkV7wbIxfWW9yZ8Udw/C
         CqO+gHQL26eiYHN7nRWBzD+0Jh+6yRAdfyEYPfOE/vXZdcJ7bH+SpJBcH2DcQq5kRu1p
         MtMKUpZA3owSMM5uVZp83Ik8fFKJy8R2TNMzLIYnAHdq+eiSeHlUBEmtFejk8Bbmv+DF
         FYX+/0UpaZUCw4kTYwDfGS8gPuiHVteo9XnKATpj4aph9CqaQlz67EbwOiim2o1tfpTu
         6H1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1717184895; x=1717789695;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=kMUfRlTkOBaBLQQELZe980nJMQVeFJKdXyeCyLEM3ZA=;
        b=cDilK2MMBBU0qC97kE0UQiL+jkK0kaBR+kwkHrQeQ1Cd74bz0zNj0/iCGnoOK9Ym60
         rRGhySdWFBsYah0r82EjjUVh07fClh2QbGlRC+uUA97mHfFRrXh0PaG/Kgzw0wTtNM+Y
         pxZPJnV2XDW4s8JiuWP4ina+5XiMsBE6LAnQNdxIoLZcl5y+bHt94gYzsEkPTeufkd9r
         t2B2cjQxgs5xXlvtgvZxZdvgNObzysumjYMJERUm+HVeaFCB9OwyHe767sCdM5rvAcCZ
         DeZS9Ru+OJgHWSgn7PptyVyTTj+I/QGMSbuAzD43bcRbFcMJgItAoTCMbkkuuBAhvD8D
         rkAw==
X-Forwarded-Encrypted: i=1; AJvYcCV4hcGQz027k1zdXt1hs/Pzwp7rgT3ECdzdfKZQqqdBHtpqcZLGh57ZyUXbUAnevQWJDFG5rB5Esnh3XAVspTSgaqtAMCKPBpHfcQ==
X-Gm-Message-State: AOJu0YzQA+TheTkGUJ+XB7jyONCJHWSzYa6CvINfVARpKrLf5DQfLgiC
	AAw1CbMupZY20jSEt8zB524el/pF2XPNDJhDXd1Bn2TpmcuURnj6
X-Google-Smtp-Source: AGHT+IEOqe5HG/DEJDOuzCzvZdrUUYAO3RZctxcCPeR77cnHMGw1HKl7z6Ui8KdrhN2Jg2dYilm03w==
X-Received: by 2002:a17:902:ec87:b0:1f6:33db:2cc1 with SMTP id d9443c01a7336-1f63700df39mr32955065ad.23.1717184894657;
        Fri, 31 May 2024 12:48:14 -0700 (PDT)
Received: from localhost ([216.228.127.129])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-1f63232dcd0sm20394875ad.52.2024.05.31.12.48.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 31 May 2024 12:48:13 -0700 (PDT)
Date: Fri, 31 May 2024 12:48:11 -0700
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
Message-ID: <Zlope0VfuIMMJTfq@yury-ThinkPad>
References: <20240524030008.78A1AC2BD10@smtp.kernel.org>
 <0ab2702f-8245-4f02-beb7-dcc7d79d5416@app.fastmail.com>
 <ZlklY6LkIhn98S6Q@yury-ThinkPad>
 <01d0db40-e02c-4204-abd3-62e6348e4bbd@app.fastmail.com>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <01d0db40-e02c-4204-abd3-62e6348e4bbd@app.fastmail.com>

On Fri, May 31, 2024 at 03:29:28PM +0200, Arnd Bergmann wrote:
>  "Alexander Lobakin" <aleksander.lobakin@intel.com>
> Subject: Re: + gcc-disable-warray-bounds-for-gcc-9.patch added to mm-hotfixes-unstable
>  branch
> Content-Type: text/plain
> Status: RO
> Content-Length: 3582
> Lines: 85
> 
> On Fri, May 31, 2024, at 03:18, Yury Norov wrote:
> > On Wed, May 29, 2024 at 04:39:45PM +0200, Arnd Bergmann wrote:
> >> On Fri, May 24, 2024, at 05:00, Andrew Morton wrote:
> >
> >> I think this is mixing up
> >> a couple of independent issues, and makes it harder to
> >> ever enable the warning again.
> >> 
> >> The bitmap.h code looks suspicious to me, and if gcc is
> >> unable to analyze this as a false positive, it probably
> >> also can't optimize it correctly,
> >
> > In the b44759705f7d Alexander says:
> >
> >   bloat-o-meter shows no difference in vmlinux and -2 bytes for
> >   gpio-pca953x.ko, which says the optimization didn't suffer due to
> >   that change. The converted helpers have the value width embedded
> >   and always compile-time constant and that helps a lot.
> >
> > Bloat-o-meter itself is not a measure of how effective the code is,
> > but it's a good hit that code generation before/after is at least
> > on par. Have you an evidence that the patch makes code generation
> > worse?
> 
> So far, it's only a suspicion based on the gcc warning:
> this is in the same category as some other warnings that
> depend on gcc analyzing code across function boundaries.
> Another example is -Wmaybe-uninitialized.
> 
> It's usually good at this, but if the code gets too
> complex it fails to track the state correctly, resulting
> both in missed optimizations and false-postiive warnings.
> 
> This often happens in combination with sanitizers, as they
> add more complexity and turn off some optimization steps
> that are required here.
>
> >> so it may be better
> >> to either not have this as an inline function at all,
> >> or find an implementation that gcc can optimize better.
> >
> > The functions look bulky but it boild to one or at max two words fetch
> > plus shifts. Inlining helps to generate better code, particularly in
> > the bitmap_get/set_value8 case because masks and offsets generation is
> > done at compile time.
> >
> > We had quite a few cycles back then... Alexander, can you please
> > share on code generation, particularly inline vs outline versions?
> 
> Right, maybe all we need here is marking it __always_inline
> then. Something I've seen before is functions that
> are meant to become trivial after inlining, but that
> (before inlining) appear to have too many statements for
> gcc to consider them candidates. It may then try to generate
> a specialized version of the function that optimizes for
> certain constant arguments, but is then confused about which
> arguments are constant or not.
> 
> Do you still see gcc-9 false-positive warnings with the
> trivial patch below?

KASAN was not enabled. I disabled all CONFIG_*SAN and CONFIG_KFENCE,
but the warning is still there. __always_inline doesn't improve as well.

Thanks,
Yury
 
> 
>      Arnd
> 
> diff --git a/include/linux/bitmap.h b/include/linux/bitmap.h
> index 8c4768c44a01..08df806df3d2 100644
> --- a/include/linux/bitmap.h
> +++ b/include/linux/bitmap.h
> @@ -737,7 +737,7 @@ static inline void bitmap_from_u64(unsigned long *dst, u64 mask)
>   * @map memory region. For @nbits = 0 and @nbits > BITS_PER_LONG the return
>   * value is undefined.
>   */
> -static inline unsigned long bitmap_read(const unsigned long *map,
> +static __always_inline unsigned long bitmap_read(const unsigned long *map,
>                                         unsigned long start,
>                                         unsigned long nbits)
>  {
> @@ -772,7 +772,7 @@ static inline unsigned long bitmap_read(const unsigned long *map,
>   *
>   * For @nbits == 0 and @nbits > BITS_PER_LONG no writes are performed.
>   */
> -static inline void bitmap_write(unsigned
