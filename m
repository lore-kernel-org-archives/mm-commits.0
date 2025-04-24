Received: from mail-wr1-f44.google.com (mail-wr1-f44.google.com [209.85.221.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B00E445BE3
	for <mm-commits@vger.kernel.org>; Thu, 24 Apr 2025 06:00:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745474460; cv=none; b=Zl/Ksweka16mLG1Qr1F3sQLCyehxGhzCkmFrkQ90EvEhdc9GoXssQM4RSoaOaWdli0J8IYbO18AUDPtzhpaM14feNnDieS7Jv85QRrOXvNmyHsN9NsnxqUjTqohzilbMLovmYlFXJC+/mvUYYH/0KYSCnT/abLM2pJKmL+G5C4g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745474460; c=relaxed/simple;
	bh=7WVwpwdNe/8qyw8P5iZgRMPVV4Bw4+UYqggQb5wMP1w=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=cMpAlOGys5WIEKgkAk9QSO+RxrU/aIv+mzrgwsJlH186xoNwyhIYzg1M8fa8EaE2hgqzV79JGOwS5EGuytot0lm2XKRr/+px+9Qs6XkKskkpqYTckguzvTOjSpJUkKk4El4M9NAYhCV6sZzjrgmiYmcSSnbzS/YOCg8pLztIKi4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=ARbM90+Q; arc=none smtp.client-ip=209.85.221.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="ARbM90+Q"
Received: by mail-wr1-f44.google.com with SMTP id ffacd0b85a97d-391342fc0b5so424006f8f.3
        for <mm-commits@vger.kernel.org>; Wed, 23 Apr 2025 23:00:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1745474457; x=1746079257; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=yohzxh+ZLIdl5c44ys0HJY+ZOuGVlbe3hr/zRx+SGgY=;
        b=ARbM90+QrvVraywfQ7xraWfisEzNBH1tvzzXLoqtwM9kAyWUsz9ZaNALmqrwnsnGWt
         iSzDhTVS56DlnknftFmw6i38oLs4uZ2xmSttpsliumprvTB8ooe4hv9wMmSY4HuNcXPj
         30v4is+RcEkwRVZ12CQPIg0dlXBTxrxIXgmxOREOeLtq7rSZveiUiI7xDhEyOcrNw7i/
         X9eNwtvOR2sOAQs36jZWsUiYa5O9zbNv1PUsyv4uSo7fHApvAApre7vjMRaQXzC6nh3D
         TECRVyv6maP6zU+m7hySf49+HBzqa6pxbSnJMQrVeo34F03k06eu/0Gy5bL/9aOUi2+s
         JrvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745474457; x=1746079257;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=yohzxh+ZLIdl5c44ys0HJY+ZOuGVlbe3hr/zRx+SGgY=;
        b=qmJI5QVYR6fL3W24pBsg9LFDgUHcVpiCYJ8mMyULYacOpZeVYnhns6J7UHg2S6WbcV
         EVbafDOnP2Qo+/VoqKrobWAePl0UxBcE4qVt7vzDkkNJzBD7S7qqxJIxOvpWSkNDpitJ
         TQXsOfZy4S7Fn25FPIM30vS4lTbo+wXPU2LHGFP4MrLG1NZy2+vpyJCwx1QrUjDq9zZb
         3bjAoYaF/G90EtIE382q2pjn9tDL8IMLdp5ix+wwYxEVN9hpwnkUuEjzU3FrNDYZ8L76
         PcXDao15KExMNQu5V023SH5xRciFWewb6Cee2i4RJ7GmyXFsIxLw8SBLQ5VXZjW8Ea0k
         mE8Q==
X-Forwarded-Encrypted: i=1; AJvYcCUg65UPZeOuF/0EOI4ZzcLXvFbMfjJh++tROJKocw1JdMymcUqqWx/WeURfqGjDn664CPToZ1RW2+xr@vger.kernel.org
X-Gm-Message-State: AOJu0YzAXCa2/JtO9l5ZPQhpw5kJLOhCHi48aqEMRIV/t+m0TNFP96bf
	LGqvRUUXU6h0Vb2xO6jTcCIBIDnhpy+/hG28CPiY4rH5VzS5oF7BrdDgXPV2p+Y=
X-Gm-Gg: ASbGncucGyP9n5E1U6G8B01mLtOrQSPKKI+NMB4obq0Ivbxguu8Y+h8q+MUE9iCvlRr
	tOxc/iVfyYPxdC6yVfhq0pZqMvrVzrDUIC5ja9JtYli0Z6FcUFfGKD6eDc+37UGaGbusA3wvH4i
	L1ExsHTmd1I8YTSP3yjUTXfk6cfj7s1b/ZBP3o3gTdTYuKDakf+NOS+T1lgjMAc0YzC0IhHsKEK
	r1JNDHa8di3+6QKCI11LK90tLEGFmQuYIq7O/RzUAks0n03NkQ1W7tv8ngAoGWQUEw6fjG8v66l
	uRrkLIztv9xjGgELbfsvRLm0YUoFR0sM2jupBk9S1r01Cw==
X-Google-Smtp-Source: AGHT+IEi8c7F4XzPhsW/Q0v0Lr1RVRLOVN+Nxu+QwjidcKYC/LC37iIbktREWhuHInM8v6UvQE7P+g==
X-Received: by 2002:a05:6000:4008:b0:399:6dd9:9f40 with SMTP id ffacd0b85a97d-3a06cf4b575mr903302f8f.9.1745474456784;
        Wed, 23 Apr 2025 23:00:56 -0700 (PDT)
Received: from localhost ([196.207.164.177])
        by smtp.gmail.com with UTF8SMTPSA id ffacd0b85a97d-3a06d4a7fa9sm919590f8f.5.2025.04.23.23.00.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Apr 2025 23:00:56 -0700 (PDT)
Date: Thu, 24 Apr 2025 09:00:52 +0300
From: Dan Carpenter <dan.carpenter@linaro.org>
To: SeongJae Park <sj@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, mm-commits@vger.kernel.org,
	suhui@nfschina.com,
	Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
	Justin Stitt <justinstitt@google.com>, Kees Cook <kees@kernel.org>
Subject: Re: [withdrawn]
 mm-damon-sysfs-schemes-using-kmalloc_array-and-size_add.patch removed from
 -mm tree
Message-ID: <73691a8c-f5b5-4ae0-b3e9-55ac6f74b265@stanley.mountain>
References: <20250423222109.CB628C4CEE2@smtp.kernel.org>
 <20250423224056.46106-1-sj@kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250423224056.46106-1-sj@kernel.org>

Let me add Justin to the CC list because there could be a way to make
this work with a compiler extension.

On Wed, Apr 23, 2025 at 03:40:56PM -0700, SeongJae Park wrote:
> Hi Andrew,
> 
> On Wed, 23 Apr 2025 15:21:09 -0700 Andrew Morton <akpm@linux-foundation.org> wrote:
> 
> > 
> > The quilt patch titled
> >      Subject: mm/damon/sysfs-schemes: use kmalloc_array() and size_add()
> > has been removed from the -mm tree.  Its filename was
> >      mm-damon-sysfs-schemes-using-kmalloc_array-and-size_add.patch
> > 
> > This patch was dropped because it was withdrawn
> > 
> > ------------------------------------------------------
> > From: Su Hui <suhui@nfschina.com>
> > Subject: mm/damon/sysfs-schemes: use kmalloc_array() and size_add()
> > Date: Mon, 21 Apr 2025 14:24:24 +0800
> > 
> > It's safer to use kmalloc_array() and size_add() because it can prevent
> > possible overflow problem.
> > 
> > Link: https://lkml.kernel.org/r/20250421062423.740605-1-suhui@nfschina.com
> > Signed-off-by: Su Hui <suhui@nfschina.com>
> > Reviewed-by: SeongJae Park <sj@kernel.org>
> > Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> 
> Dan did mention "No need to change"[1], but I think that means this patch needs
> no additional change, and hence nobody really asked withdrawal of this patch.
> 
> Cc-ing Dan and Christophe to make it clear.  Please let me know if I'm
> misunderstanindg something.
> 
> [1] https://lore.kernel.org/all/fd372c23-1bf7-4c93-a51d-ba5dad255b04@stanley.mountain/

The patch isn't necessary.

I don't really think it makes the code more readable.  Personally, I feel
like writing "size * sizeof(char)" is ugly.  I'd prefer to just have:

	path = kmalloc(PATH_MAX, GFP_KERNEL);

It would be nice to not have any math in allocations but it's probably
not workable right now.  There are just too many:

$ git grep -w 'kmalloc' | grep '\+' | wc -l
489
$ git grep -w 'kmalloc' | grep ' \* ' | wc -l
494

But here is an idea.  I had discussed with Justin that it would be great
if we had a safe_math() macro which does saturation math instead of
wrapping.  The problem is that if you have complicated math then
size_add/mul() is a pain.

	bytes = size_mul(size_add(count, 1), sizeof(*path))

Terrible.  But we could create a macro:

	bytes = safe_math(sizeof(*path) * (count + 1));

Look how much nicer that is!  This is very doable but the problem is that
compiler features have to be ten years old before we can count on them to
be there on everyone's systems.  It's too discouraging to even think
about.

But for kmalloc() we could just hide the safe_math() macro inside
the define:

#define kmalloc(size, gfp) __kmalloc(safe_math(size), (gfp))

We could enable this right away and people without the new compiler
wouldn't be affected.

regards,
dan carpenter

