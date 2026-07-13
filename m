Received: from mail-qt1-f179.google.com (mail-qt1-f179.google.com [209.85.160.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D2E3224F3
	for <mm-commits@vger.kernel.org>; Mon, 13 Jul 2026 17:13:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.179
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783962835; cv=pass; b=ohugW4qwSW/K7ftHmEnKsO4acOh+2PbLMtwegqKCLKdlnsfx1q38J0Iz/V+lqe0wt1T4vYBE1Zb5p9kHEJOqOQ/1FxuqZAtH+yEHkMSQLHGB8afD6NPcSU4TM162GP5GNO8auEK7s1+RDk5v4SugLkR2xSk4NA/j39anONPL55A=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783962835; c=relaxed/simple;
	bh=TjQ6oSrJqIbqwiPcXyVFyD/2FyLsA5eQvC5UyOCv/XA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=eZljAmrvPWyYnUTcm4yiEgmmGNVQqxrsC5ESfjl+rE7eQ/uyDCxvVodhA+Sr3FRjhR22uGg+4jeb6XtEk1C6d7nWeMbzqNgIwxB6q6A8pwWUOVoAyZ3Om6NGnnmkhR/ZpYH8wzWoCEK+4Lh7u6R60Jr8FDl+Z6JvPZvTXWSyxLA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=cRfCZtfn; arc=pass smtp.client-ip=209.85.160.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="cRfCZtfn"
Received: by mail-qt1-f179.google.com with SMTP id d75a77b69052e-51c10e86e52so9991cf.1
        for <mm-commits@vger.kernel.org>; Mon, 13 Jul 2026 10:13:54 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1783962833; cv=none;
        d=google.com; s=arc-20260327;
        b=I5TJOq/X1ZDNh7p6YdosQOudC2jp065S1qAVwdGvgqrynyTL2s+KdPNbbvlubV7F+W
         EZ1xE/TYkVS9CUY/RKC07RDWHMfPblblJ6wB+fTOOqfQKb9RbY6FkP/RlA74/9KFlNwj
         feIhZW4tEtZjqvGBKzY4q8rB/BmJjIplNdm1gB7Anbu5CyARVj5L0TXqaojU8NhjAC5E
         YXgCUjX4ekzBs+1l9Rdi4LFPk3vKfLZdDgiYpvYZ3Ju49hBmxaGHvzRvod5WbQw0VaVI
         N7iWFlca+newclQj3jIlVtQTEMKmEm/fJxzsfIcLPCKr2kizugxALFlYqptmvMi2VNt+
         vkcQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=DD5wqd94WlUPEbfxha2Dsl5QwxgMVxPOf/Hd4g6KPFg=;
        fh=dN6WBv/+Yfe4HLrAyU3YFSIcYz2V3S1GcdBk2P2sJRo=;
        b=RzKR6Zu5R4J4t9kxR7uFvpmtBCQJIflZGAnmaGU7MwybL9rRsroVCGI+nfE3BLuON7
         PPtVbOrOeYzDtgu2+gRRF87F0Ev5x3+v0toxloKADSDpdmXfFVYliNDebPEU/nl1aOI3
         JR6cRhS7YIPoHlV8OlKIFJPJQqRYlCRXG1m7wmLA5ePyQPTnRtbjDEP2Zc1cu2KF4b/V
         xCGLbXc5ORzIdsusp4ZnxKWf3m68f8Kiitvy+5Tn+igEON2rKmW6e05SfU8zWf08WwSC
         HHrX0KNKV1WgL2J/dMg98b0mBha5d8EZ7okS0HEMryvWPQ2bamyv7h7js8oH9QAGpYlk
         sywQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1783962833; x=1784567633; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=DD5wqd94WlUPEbfxha2Dsl5QwxgMVxPOf/Hd4g6KPFg=;
        b=cRfCZtfnF/+9Tm9jYHr3QgqRbCNpOtTrs6XlpNrqzItokSkI7Q4wHJkjxWA7A9QSNJ
         pXCpLwvjiigp4q+iVYaA9c2aMev6K8bEUeWvff6TJbJjIN9jUKXX8/pxER86yTvlgWjz
         xGfYsytDzmAFnAm8zLPB2RZklPxkfQgfY2NFq4DI7nUsBXIQw/tBaQ2i5ZWJEQfmhJ/c
         jQYnEabGaxsYV1z2YlXmf+tsqiWWvO0NCeNyyseTVOcu9ghJw/XuObM2aBakRsk0l1oe
         YvTBPf+iF5c9vOZW74MdcCrGYp8u7n/RmvebFwX1pUs4hcWxJJl1WKnJ0AG2+2wov7ev
         +WOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783962833; x=1784567633;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=DD5wqd94WlUPEbfxha2Dsl5QwxgMVxPOf/Hd4g6KPFg=;
        b=E8zdDbQ0F0yZdrm4lDh/dMfVqo+CUb+XXsE39YrsH14mIUh3/OC5KjC7mYG7MHVVud
         mnuS5BRo4WGn2Od/T6MTNFYe4S0/GV//7P+LvgdDB8jMygnJfQZbU4eB2clFcAfthJO1
         egDqsWBXbMCtRPIsOjtHmPdESccc99ZSYUzRbFRVtLKFHS12Qamsh62I/ydbt+uKQ4W5
         4SfDOxsjvbTj0Gu7lEU+TFrWCgrQxXHregKBcrqeAWBEaI3yUfXPVKZ9T7pz1sTOmYgH
         xvQ2bfAQdFPs3OW0gtO6uylsb7dUP5d8WvsxrgNvlFCfuHjhBgn6GW21sAs0y9qIVKb7
         gQJQ==
X-Forwarded-Encrypted: i=1; AHgh+Rq8om26FR+olZ7g21S1ODlvcLvt0h+KGhkF2x98E4qb7WHcy6FNC14I75r8/L6wsIckmoNOrb3vQ0Jl@vger.kernel.org
X-Gm-Message-State: AOJu0YzO20fLK5RwiODnmPQidVanRvepY1+4HCsvc7mXPWF1NBPE2SWQ
	dJpJPk/I2uMsq9+aaxvOMYnuQp94vqipd8xOpsNJY71kaxd+5qQBWx1fHmtV5Gm5M6K5TChhLR6
	PY945bXTPYr0cl/8xXDb8SrqzBd/kJqHGz4ifcN3E
X-Gm-Gg: AfdE7cm2NFTrzNta7hka3EIXgmzxa6yy+nIW3mZN1GKKS9R1yaS+P2H3lH35Xw5vkMi
	ywIniMrlIMkji+NlG0kCqIjKAIwKIN9mO4DXCTHbSyTwjZR3yG4O+TqzzwvNnyyn6JAH7kniHAn
	hFmQSaaKeYqyqFb/AUnZN6H86lt8YeA/JXD1PF13iMkhDahCFdUbmm1mpAV47fSyZUozQRqdB9I
	C3XfrjiWESCCORBVsuaarXSopLeB15cEaakjpxwoja8BzLrZ2oNWN+n0BrVUPaG9k7bFsg=
X-Received: by 2002:a05:622a:5811:b0:516:d25f:f038 with SMTP id
 d75a77b69052e-51d7bcdc629mr5265721cf.10.1783962832725; Mon, 13 Jul 2026
 10:13:52 -0700 (PDT)
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <202607091820.qbjlGhKK-lkp@intel.com> <CAJuCfpHjUij9kkD6QiWxYvsYD3iKga9rzJZWnN9vCf3bhp-dXA@mail.gmail.com>
 <CAL41Mv6UNWWdv3a2g2+tKuy+EX=8FJZSCcEAyHYyuUybYK4NMg@mail.gmail.com>
In-Reply-To: <CAL41Mv6UNWWdv3a2g2+tKuy+EX=8FJZSCcEAyHYyuUybYK4NMg@mail.gmail.com>
From: Suren Baghdasaryan <surenb@google.com>
Date: Mon, 13 Jul 2026 10:13:41 -0700
X-Gm-Features: AUfX_mxwf8jEAJ4-Emw6NQ7o3A5xX_dOnGVyXZPm3JwYCxoc_8oz7g9QKalCMCc
Message-ID: <CAJuCfpEpFDUNjgsHiETmxTLyVfHdCKEk8sR2fQtixBR8JOYRoA@mail.gmail.com>
Subject: Re: [akpm-mm:mm-new 344/369] mm/alloc_tag.c:356:58: error: implicit
 declaration of function 'compat_ptr'
To: Abhishek Bapat <abhishekbapat@google.com>
Cc: kernel test robot <lkp@intel.com>, oe-kbuild-all@lists.linux.dev, 
	David Hildenbrand <david@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, 
	Linux Memory Management List <linux-mm@kvack.org>, mm-commits@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Jul 13, 2026 at 9:43=E2=80=AFAM Abhishek Bapat <abhishekbapat@googl=
e.com> wrote:
>
> Hi everyone,
>
> I can send a fixup patch for this error if needed. Could someone guide
> me on whether I should amend the original patch-set and send a v9
> patchset or if there's another way to handle this without sending a v9
> patchset?

I think Andrew already fixed it up (I saw an email flying by but I'll
double-check).

>
> Thanks,
> Abhishek.
>
> On Thu, Jul 9, 2026 at 7:45=E2=80=AFAM Suren Baghdasaryan <surenb@google.=
com> wrote:
> >
> > On Thu, Jul 9, 2026 at 3:00=E2=80=AFAM kernel test robot <lkp@intel.com=
> wrote:
> > >
> > > tree:   https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git m=
m-new
> > > head:   59e34180e138a293260301c139cf7ee800978533
> > > commit: 27ace96bf8195484c9e9e1a08eb5af5a4e81f9f0 [344/369] alloc_tag:=
 add ioctl to /proc/allocinfo
> > > config: sparc64-randconfig-001-20260709 (https://download.01.org/0day=
-ci/archive/20260709/202607091820.qbjlGhKK-lkp@intel.com/config)
> > > compiler: sparc64-linux-gcc (GCC) 15.2.0
> > > reproduce (this is a W=3D1 build): (https://download.01.org/0day-ci/a=
rchive/20260709/202607091820.qbjlGhKK-lkp@intel.com/reproduce)
> > >
> > > If you fix the issue in a separate patch/commit (i.e. not just a new =
version of
> > > the same patch/commit), kindly add following tags
> > > | Reported-by: kernel test robot <lkp@intel.com>
> > > | Closes: https://lore.kernel.org/oe-kbuild-all/202607091820.qbjlGhKK=
-lkp@intel.com/
> > >
> > > All errors (new ones prefixed by >>):
> > >
> > >    mm/alloc_tag.c: In function 'allocinfo_compat_ioctl':
> > > >> mm/alloc_tag.c:356:58: error: implicit declaration of function 'co=
mpat_ptr' [-Wimplicit-function-declaration]
> > >      356 |         return allocinfo_ioctl(file, cmd, (unsigned long)c=
ompat_ptr(arg));
> > >          |                                                          ^=
~~~~~~~~~
> > >
> > >
> > > vim +/compat_ptr +356 mm/alloc_tag.c
> >
> > Missing #include <linux/compat.h>
> > After adding it the error goes away.
> >
> > >
> > >    351
> > >    352  #ifdef CONFIG_COMPAT
> > >    353  static long allocinfo_compat_ioctl(struct file *file, unsigne=
d int cmd,
> > >    354                                     unsigned long arg)
> > >    355  {
> > >  > 356          return allocinfo_ioctl(file, cmd, (unsigned long)comp=
at_ptr(arg));
> > >    357  }
> > >    358  #endif
> > >    359
> > >
> > > --
> > > 0-DAY CI Kernel Test Service
> > > https://github.com/intel/lkp-tests/wiki
