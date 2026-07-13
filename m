Received: from mail-pl1-f169.google.com (mail-pl1-f169.google.com [209.85.214.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D9A8331A53
	for <mm-commits@vger.kernel.org>; Mon, 13 Jul 2026 16:43:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.214.169
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783961015; cv=pass; b=gKFzKhQWdX8lXDAcK3alg5I4dhAd5UKeL7hQq3Qz/xQtJorrqDq9uQa+INxOALbWE2xAzUSBVTsNYiVdAWL5c2EjTOkxFbtmtBZq8lTaGAcxMzpzdQeOc4656hTgb3XV7a8IsQ29tdXgdVQKCMKJGq8c0o47NASD8TcO+XIrgxU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783961015; c=relaxed/simple;
	bh=wVPz/aitjsQlMx1oF4wx/aef8cPPl1j11BPR0oV/Ggs=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=GLg08M+RIHOING2IPpndQbriV9q2nDs/YO7TL2RygQ7ZL6rpXT9cDc686PjppF5rv4imayeeFqQcHAx7rh4KmoCbNVg83cv3F0lDRp2QXoJlCN+W1ePgTHbGKYlMH1KklSaZJ6jP4iUGzgEwhp1TX1W2GbuzpFpDlGYtiUM003w=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=fInkZzKP; arc=pass smtp.client-ip=209.85.214.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="fInkZzKP"
Received: by mail-pl1-f169.google.com with SMTP id d9443c01a7336-2ccdf36f63dso2155ad.0
        for <mm-commits@vger.kernel.org>; Mon, 13 Jul 2026 09:43:33 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1783961013; cv=none;
        d=google.com; s=arc-20260327;
        b=kUNBkHntaZ7bY+31mswQMe+mIIb9KC3+lLk6Ja23XeXc7KulHaY5v6yjJV2EZT9lTJ
         jmyIRR16INoemjC5w1iO8rwH6LwzNJFhiXt/XymQSr+Gd187SXKfE6vLZmdYIjowFJgU
         KIX86TEoQQcepUnWuP0bD42cHVJM4bdhShkikV/xMoILROPDO/KwiTlR5Jdudr/Ma5eV
         7pc5f/1IuV48f72XD6x4RbzE6hnWtEDTalHiKpnUsa0ZDCSiuCpZhPDX/+6KioJcJwsj
         apkAmcPKo3hFZVb++40MdNlmcPhbG+Lv7baeh29vRkVgMNA2cYf1r4RS3vnbMuusBkzW
         /5kQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=g7RBjI+3c4wbCLyC30m5N44VxvHGqMYoVlsOrdbCo2A=;
        fh=EpUKyOj6OKlW/T51eZI22kEu3MTyVtkUXR+cDz/CGQA=;
        b=UzIRSLriHn62L1VA7COC/FN/yRagDTJiwLYlGjSHMWewSsHm2PXD3WgT3kNqR5Q0Fu
         I6OBQY4dbcXNL2xrv85EpcCiR5vkOPpDI7odxXqBe/UDh52QkWKkUjKV4Rjwu0S9wLrs
         gw2efLkMhtSN/bgfim/IWTsJeeGf3wZH+MS6fo3rpVu6QP7ceImCJxzOIBjftNJGlKAh
         yRN8mC01NpEoOPKf+u1opp62oMnY059cKdpqRoajV7/4ggr29Scrh85L/9BOdVaYhVD6
         xTrXFsRfS7/oGIJX7M24hnmNEJ+teq0Qe1+fHgDT9lttmXw2KM9+ElhYG1DDqgW5L0ef
         LeAA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1783961013; x=1784565813; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=g7RBjI+3c4wbCLyC30m5N44VxvHGqMYoVlsOrdbCo2A=;
        b=fInkZzKPWzX6bQlgKUh36d8UEQiL8TIVMV2iQRZU5aDFplvCyrRJRPJsBWCf/Y4fb6
         R5zPIY0EMwZujPN9MhAL741n3nELUKhosyBFdOmXMA1MHLc0AnLWU8U6atZWDYp4+dhx
         c0gUKKBiNRzBm9BzMZsXvaXMKBpLVVkRgaMazdC3r+IAp4uJHZCnv8muVVbnNk8HRSTO
         sSGIb0/FvvJyM0sd56JpOu/sxR0b0V7pSEKPB7uILRTaWScJBC3k3sSCV3q0QfQE/3bZ
         SBWjfSZSKrZZ4lK/DYzNb6jBM/Y+v8h+dh130GxCbSfnXUwQiLh/U1pHQQbEOMDWznCe
         rGPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783961013; x=1784565813;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=g7RBjI+3c4wbCLyC30m5N44VxvHGqMYoVlsOrdbCo2A=;
        b=c+DXDxt4g/RcIv3KYaoX03DPAvwFDFeUMNy3tPvwtiVR125jPURJwpn+OygLECu43C
         RTzhS73tqAyJiZihS1PDtY3liPhFB+HjTq7nwz8xcxB1WQSJvr4GHHwgEG8DmSmGRE6O
         WNSD1zLZKtLZuPSKSiAgs3E57hL9a9hL1BEiKkeWZOH7Xy/By/Ajamng2vXm0J2Sq7mi
         lg9k6CfsJdw3G87n8dIMpOJs2ZECRIH7bvi/GiEhQ9bE7kqr3p3T+LWZ7ploFYGUS5LP
         c5negfwCErJ2KCFEF8PselGJbMyO9cgpMh6LyaItn6PhXLycsS0EZdOcEiNKoAKIh8Y+
         lzSg==
X-Forwarded-Encrypted: i=1; AHgh+RqPy+pfAL8YPoHvlYPWUZH2pa4Qt1e+aJefsfAcOmVY35uIO5W6oXIAQkK0iWrFURIy+fS/mgM3SX4t@vger.kernel.org
X-Gm-Message-State: AOJu0YxGkTemEYY6Y0IJiqIkAGC7NdGwgfNAISl+jrI4CN95C68HgbGl
	xu8SAQ39tmTJyhVjxbNsm9fQYf3KQ1FeBrsHRHwNMIGfNEVfCrXdCG7QA9urRbs2aDWh2HqHjfE
	2eJNgIN64JZ6O/AOftUVMahOnqPWvzE2LOTvSvKTz
X-Gm-Gg: AfdE7cmZRFD/fMVewId5ahZqnV7oSIQ/uLMJdj/u37nSYTmBqETtwO33Yob6Qyo5dCu
	5x047OHzfvhTkd1MgNs/XurFywSFhG54AC4ufBjPW6pkaZIa/b67iNSr9KDEHwbhUHayHJ+pOaj
	GF8e1Wuri0N62UJ2/uWXNlGrELvjG8wb3FCCDc/i7oah1d/bfGbSh2De17CJMu9Q4np8X+50LuM
	wITrv3yLGzr2aIh28N6NamoAPsw78IwLt9euqP0shBxGd9lyGyvxyRu7WWvjyXJAVGscR79BXsT
	LiWGVR/XeKFh70h2RK9LK906WUlm9p/eA428kA==
X-Received: by 2002:a17:903:3884:b0:2c7:df7a:859a with SMTP id
 d9443c01a7336-2cee1c0873emr1602925ad.15.1783961012878; Mon, 13 Jul 2026
 09:43:32 -0700 (PDT)
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <202607091820.qbjlGhKK-lkp@intel.com> <CAJuCfpHjUij9kkD6QiWxYvsYD3iKga9rzJZWnN9vCf3bhp-dXA@mail.gmail.com>
In-Reply-To: <CAJuCfpHjUij9kkD6QiWxYvsYD3iKga9rzJZWnN9vCf3bhp-dXA@mail.gmail.com>
From: Abhishek Bapat <abhishekbapat@google.com>
Date: Mon, 13 Jul 2026 09:43:18 -0700
X-Gm-Features: AVVi8Cdf0fJO40B3Qj_RdzqPZ1-qc6aBPc0lKEpRA9NJUP0hxR9kO-yh2KYqMwk
Message-ID: <CAL41Mv6UNWWdv3a2g2+tKuy+EX=8FJZSCcEAyHYyuUybYK4NMg@mail.gmail.com>
Subject: Re: [akpm-mm:mm-new 344/369] mm/alloc_tag.c:356:58: error: implicit
 declaration of function 'compat_ptr'
To: Suren Baghdasaryan <surenb@google.com>
Cc: kernel test robot <lkp@intel.com>, oe-kbuild-all@lists.linux.dev, 
	David Hildenbrand <david@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, 
	Linux Memory Management List <linux-mm@kvack.org>, mm-commits@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi everyone,

I can send a fixup patch for this error if needed. Could someone guide
me on whether I should amend the original patch-set and send a v9
patchset or if there's another way to handle this without sending a v9
patchset?

Thanks,
Abhishek.

On Thu, Jul 9, 2026 at 7:45=E2=80=AFAM Suren Baghdasaryan <surenb@google.co=
m> wrote:
>
> On Thu, Jul 9, 2026 at 3:00=E2=80=AFAM kernel test robot <lkp@intel.com> =
wrote:
> >
> > tree:   https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-=
new
> > head:   59e34180e138a293260301c139cf7ee800978533
> > commit: 27ace96bf8195484c9e9e1a08eb5af5a4e81f9f0 [344/369] alloc_tag: a=
dd ioctl to /proc/allocinfo
> > config: sparc64-randconfig-001-20260709 (https://download.01.org/0day-c=
i/archive/20260709/202607091820.qbjlGhKK-lkp@intel.com/config)
> > compiler: sparc64-linux-gcc (GCC) 15.2.0
> > reproduce (this is a W=3D1 build): (https://download.01.org/0day-ci/arc=
hive/20260709/202607091820.qbjlGhKK-lkp@intel.com/reproduce)
> >
> > If you fix the issue in a separate patch/commit (i.e. not just a new ve=
rsion of
> > the same patch/commit), kindly add following tags
> > | Reported-by: kernel test robot <lkp@intel.com>
> > | Closes: https://lore.kernel.org/oe-kbuild-all/202607091820.qbjlGhKK-l=
kp@intel.com/
> >
> > All errors (new ones prefixed by >>):
> >
> >    mm/alloc_tag.c: In function 'allocinfo_compat_ioctl':
> > >> mm/alloc_tag.c:356:58: error: implicit declaration of function 'comp=
at_ptr' [-Wimplicit-function-declaration]
> >      356 |         return allocinfo_ioctl(file, cmd, (unsigned long)com=
pat_ptr(arg));
> >          |                                                          ^~~=
~~~~~~~
> >
> >
> > vim +/compat_ptr +356 mm/alloc_tag.c
>
> Missing #include <linux/compat.h>
> After adding it the error goes away.
>
> >
> >    351
> >    352  #ifdef CONFIG_COMPAT
> >    353  static long allocinfo_compat_ioctl(struct file *file, unsigned =
int cmd,
> >    354                                     unsigned long arg)
> >    355  {
> >  > 356          return allocinfo_ioctl(file, cmd, (unsigned long)compat=
_ptr(arg));
> >    357  }
> >    358  #endif
> >    359
> >
> > --
> > 0-DAY CI Kernel Test Service
> > https://github.com/intel/lkp-tests/wiki
