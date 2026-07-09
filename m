Received: from mail-ed1-f43.google.com (mail-ed1-f43.google.com [209.85.208.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16A8929994B
	for <mm-commits@vger.kernel.org>; Thu,  9 Jul 2026 14:45:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.208.43
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783608317; cv=pass; b=XDIFtkNTnPiF3DUi/88YBhZsebjwp71qdhf9uGJvKJrQBPIvj34sP4+Kvh4I1kgUwNgbPgmhygDcviE442+4R59mLM88Z23r8/UCPNxCMVLVGipSuQRdk2vz892r31S0rdUVzjZBSkeKZyXIDy7C/v84h7Hsf+7OZJLwbkl+PC8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783608317; c=relaxed/simple;
	bh=51QJHitYo0D2EhVGNC7I9TulMG+PQspEKqbVmVaR7k4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=HZ1E4upwVTbi1hRt7rPB1R7HwWkOhwmDPxDhm5fL6xzT6cd8MtcLxUi3eE85tU0TDzQWflUKqfIjNPGOl16tXYaM7XxiH/n+ugiIsJWuIwnvs8UZhr61uJNKiY/quMY6AQfSoYF6+sajTIYFBcn9T22nTBdxJtKNdYfOdfIyR3Q=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=IX/iaUlB; arc=pass smtp.client-ip=209.85.208.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="IX/iaUlB"
Received: by mail-ed1-f43.google.com with SMTP id 4fb4d7f45d1cf-698b78c05b0so11608a12.1
        for <mm-commits@vger.kernel.org>; Thu, 09 Jul 2026 07:45:15 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1783608314; cv=none;
        d=google.com; s=arc-20260327;
        b=mWZKD159P8sEDSH3blH1r8ZUUIRK9S5Yxnvf6xdxijOI+8NDH35zX/CHDspob6dlAx
         Qt4f38vW7yur+aZldBt8DGU5z4IubM+TrW9KwjIbEyPJLYa/wZ3wT+jbi3Qy2wOa7LKw
         mciJMQEWftxfE5rz9MKk346O4rwW+vkP/1Y4YGGPb/BYQA7U2MVk4g0VcRWDNC25jtDZ
         1v/n/ojib6gkIue5CYn6w16tXkMzM//w19t/FRMFuzZtKOsjpRt5nJXNt8KtXaGNsa4/
         b3aS7DWiIGcKj86YQhERhc5LIrfx08tXG5AUHaPfYRbKX3vmZpDWgpnpUsIs1bg5lNs1
         Suiw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=Zd5VoNhWPJ5FEzML0KqVlaL2mS6uuL6nYiz9sQZLNME=;
        fh=51ddqTJ3e8TNImbb5xysqPnH7MoX5+YVaKJGOK1elZk=;
        b=nlAXn98rgnOCw6ZkCplXBQwrs0cUCG520fPAgsp/4eVGHqU0YPdqJHRn37dKeoStZC
         OUH7AYoCGvkyP5EzMYoLiOlj3vTcBl3+2NrjSiAR1ynpfRz7gbAcWSCsEX5UiIqMv+th
         rzGodnVEsjTq8y2QYKPLXE2GiIF38yjjnX3jTogjxv9piYhNa/soqXza2RZYegkTQTp3
         6jR1hKE3kpFwpq6Cfs9brOBXf/Qltp9K4rlf68LUdFUjTOMaRQV2PyIU2hM+K8J+OFrl
         sKcmcu5Fx5NN4jJD6/dCh5BtVIlaLP/INgluQ5i2hsgYvOum0xhseu5cAF617vied3ud
         gH4A==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1783608314; x=1784213114; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=Zd5VoNhWPJ5FEzML0KqVlaL2mS6uuL6nYiz9sQZLNME=;
        b=IX/iaUlBKiN70UXHCBEne/wqAFRLZopL94gHdpbmJXsa4u4LfpZNaUEbgKArBk636a
         mqb0urZ/TwYekAI8tsY/roWASX8fDU+8kYzyzg32cXc/XRciWdMszvp5tqKKjBVwUAzC
         QJrGHEr7ieI6kCBe2Z4V/yFILTvS0gbSQ0BFW3AbLa/Iv7kUgIUYBtbNc4eRPzKjNCnn
         EYFZK7F0nihhoKgT+oHZ/ZGvZU5TrUqYYJGEnOGj9X1OEwVfg/l9eZ+81Smp0Co75BjK
         idl01jLqe55cyuChnUe+7let7QicYDSoYq7NNMzX5xie6d++GOQPsEsnWhIy/1hXn+Vu
         eEfw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783608314; x=1784213114;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Zd5VoNhWPJ5FEzML0KqVlaL2mS6uuL6nYiz9sQZLNME=;
        b=L0X/sdJ32IX+yd6n+dXzqLv8VBjP9YsWg5IkDg+tA99k3cN/HI7epNojwW762PxHxv
         E0KCF57E2a7z+LYBGj+ubK8QBfKbOO0F3I06meVwWt4L5vc9bcJpkGnxfSfMBh/39C4q
         58alUtZV6Tcvy2w7VtZg8MozS6bfZTHg8RB9al5EUilG5JnjBPHIPn4b0qtiOkiHMVoT
         E2zqu42HmT9XXvI8A2bz1iDoOhhtNl0tTqxhI1cpSqOa6kQVl4Si0R96Mx32+5i5+HI5
         qDi7c6NOYvBzX/CMesK/v8p0TRy665odpZkRILSCeWVhglxZA1BGh4NV/nFW9xaqekBU
         JQ+Q==
X-Forwarded-Encrypted: i=1; AHgh+Rr6Shd0J4faCjtwCf29UxIXaW1tDy0BxQJRd0w4CK/5M/FYKjk3j0dPZ2xNDamjjjb/UpTFahZXsz7x@vger.kernel.org
X-Gm-Message-State: AOJu0YzsQEnFV2FXG6FlpNTkB3pVNfeiL1bNVw9uG6FodoBNQo33pPn0
	nc2JBV84mJ7TwGI5HkH2N8GfK1RCMjh3IgfORG9rhZ6JJkF2JwEOCXRNBanZa+cvmlJBX8GgpuT
	udDQTC1/sexbIriart/2VZ6qPHONpfGgdSrOU7AkF
X-Gm-Gg: AfdE7cncMAblnVeapflmdDMI9AcxaE0AVtY1edc92wPZTDM88kJ4LnSUhUyz7/Ky7gu
	SfAVQZOnAtAQFr0Eg6NHCJmErCyUyqOBhL+GoqSEGasyCeY8RZimG04Ptvg6EX81NNJNDhwLtmk
	UA+1K6xc4ct5jw2vSnRFlQGf0OoN8yzTVTQC5G5yUiHawoQRkyDUhLUEB9vGF4ZqWNEECZ/iDpK
	qptpz7jYAdPJOKfP8TsLYEXGyZJpNpzfc7rEkvhIhP8OEyKaYJCz/NCCL+TflH3Ta+03W1C0Idu
	93eRBjWvMPQCP7flbXuoRpQIMSA=
X-Received: by 2002:aa7:d50f:0:b0:69a:fb2d:e84b with SMTP id
 4fb4d7f45d1cf-69c0702dbf7mr41178a12.9.1783608313884; Thu, 09 Jul 2026
 07:45:13 -0700 (PDT)
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <202607091820.qbjlGhKK-lkp@intel.com>
In-Reply-To: <202607091820.qbjlGhKK-lkp@intel.com>
From: Suren Baghdasaryan <surenb@google.com>
Date: Thu, 9 Jul 2026 07:44:59 -0700
X-Gm-Features: AUfX_mxdaahI1V6-jyyKE3lUbvW_nBZksjAKzczctwG_EjEihAxbOStFVHjycmM
Message-ID: <CAJuCfpHjUij9kkD6QiWxYvsYD3iKga9rzJZWnN9vCf3bhp-dXA@mail.gmail.com>
Subject: Re: [akpm-mm:mm-new 344/369] mm/alloc_tag.c:356:58: error: implicit
 declaration of function 'compat_ptr'
To: kernel test robot <lkp@intel.com>
Cc: oe-kbuild-all@lists.linux.dev, David Hildenbrand <david@kernel.org>, 
	Andrew Morton <akpm@linux-foundation.org>, 
	Linux Memory Management List <linux-mm@kvack.org>, mm-commits@vger.kernel.org, 
	Abhishek Bapat <abhishekbapat@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Jul 9, 2026 at 3:00=E2=80=AFAM kernel test robot <lkp@intel.com> wr=
ote:
>
> tree:   https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-ne=
w
> head:   59e34180e138a293260301c139cf7ee800978533
> commit: 27ace96bf8195484c9e9e1a08eb5af5a4e81f9f0 [344/369] alloc_tag: add=
 ioctl to /proc/allocinfo
> config: sparc64-randconfig-001-20260709 (https://download.01.org/0day-ci/=
archive/20260709/202607091820.qbjlGhKK-lkp@intel.com/config)
> compiler: sparc64-linux-gcc (GCC) 15.2.0
> reproduce (this is a W=3D1 build): (https://download.01.org/0day-ci/archi=
ve/20260709/202607091820.qbjlGhKK-lkp@intel.com/reproduce)
>
> If you fix the issue in a separate patch/commit (i.e. not just a new vers=
ion of
> the same patch/commit), kindly add following tags
> | Reported-by: kernel test robot <lkp@intel.com>
> | Closes: https://lore.kernel.org/oe-kbuild-all/202607091820.qbjlGhKK-lkp=
@intel.com/
>
> All errors (new ones prefixed by >>):
>
>    mm/alloc_tag.c: In function 'allocinfo_compat_ioctl':
> >> mm/alloc_tag.c:356:58: error: implicit declaration of function 'compat=
_ptr' [-Wimplicit-function-declaration]
>      356 |         return allocinfo_ioctl(file, cmd, (unsigned long)compa=
t_ptr(arg));
>          |                                                          ^~~~~=
~~~~~
>
>
> vim +/compat_ptr +356 mm/alloc_tag.c

Missing #include <linux/compat.h>
After adding it the error goes away.

>
>    351
>    352  #ifdef CONFIG_COMPAT
>    353  static long allocinfo_compat_ioctl(struct file *file, unsigned in=
t cmd,
>    354                                     unsigned long arg)
>    355  {
>  > 356          return allocinfo_ioctl(file, cmd, (unsigned long)compat_p=
tr(arg));
>    357  }
>    358  #endif
>    359
>
> --
> 0-DAY CI Kernel Test Service
> https://github.com/intel/lkp-tests/wiki
