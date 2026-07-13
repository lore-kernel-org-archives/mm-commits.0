Received: from mail-qt1-f170.google.com (mail-qt1-f170.google.com [209.85.160.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED61F26F2B0
	for <mm-commits@vger.kernel.org>; Mon, 13 Jul 2026 17:15:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.170
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783962936; cv=pass; b=DVW60VBE4dsLSXNSIO0lr77uZBLLFdem/xoFVaDeu2hSfnXnQrkhk6fgxB1YhW4rDrxIov29AKdkL3Lp793nvmxB2ovJ6ecY7gRPahoUNal0Lvvpz8uQT0lp7pjSpPY/v9ua/dpQZExwQSWe5TOkepKuHdH0TdjO7i3GlgFC0xM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783962936; c=relaxed/simple;
	bh=kvADKfFp/IZbZct31ztc7jD+j2mkpZhpin5cMq3zYGI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=AJ4qclCcrTveLn29TH/hUY5auyvRbLCuO7OSPypqZFeemioHLj6qdGng0gWpM03QJMW2MHerjfDxaRtjbPA3psc/1A7aCbJKwqfwq2rdSD/nyBTT9hMncqkhp+pLwJGfddY0tudkLSCAHpmNXx42M1Y1VgEvci6AH8hZa2jSOb4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=E3VLVQfL; arc=pass smtp.client-ip=209.85.160.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="E3VLVQfL"
Received: by mail-qt1-f170.google.com with SMTP id d75a77b69052e-51c10ed63c0so9911cf.1
        for <mm-commits@vger.kernel.org>; Mon, 13 Jul 2026 10:15:33 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1783962933; cv=none;
        d=google.com; s=arc-20260327;
        b=BoHaKmh+UeVzfy+JYEHNXyGCfjefKmusJd/1C+MlLJMFnXTdLZbmNfZDzB8YBkQPGY
         CRvqeJzFaUCEBYL8Ys9uZhO0ArhHLsGzeR+YQQC1XtRiyvFe/eYUUCzlSTEUK8uZ5uGB
         WOgsbKoPrgMukGOP0u9gRKjWr4ZCcW6iKVaIbMKOERZcyglhRoLU5aTP+5lip+073aYc
         Fz6lQ5HchXzytLZzUXNZtI02UhulGfIoVKm3vcGqATZFDU6j208na7JeXlC45da0Edmn
         Ms5P8DRQKre4R0r4q5kp2wWh6bzuZQ/roO7Jo29yU9ngz57XB6LyrWNxKDp6zVQFU5s2
         JMqw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=mxVrxa7HxzqTiw7ir6NHv4olNuo0XGTjz/0zgJXDsGk=;
        fh=qs7InL0Z3lCo5auPtWc7EpVAibwglqRSHLcIA3uWf4Q=;
        b=MlPNrEis5sWEe1dZNvNIy2f2X5lClQsH7dR+jlKb18p0d+zT0wfIp5z1TEa2tGqy+Z
         TVHoNkIzikxUsrs0D1VpP3sqankoxZzB0HepvfUEHpYdTdXLXxjzMSzb3Sq78m2r+BLz
         URBs3oSw8o8VHORkJ0wUQenB3xfKsewK8Bs71uN1Tm5jkMwh186zjYdVw+TrASYqi6kC
         49PZj/xMtocSpSViNqwD4Jlr7Pk03ipREIyvzwmErPkyUAir7jyQa4mEG81Bk6SpSSTX
         9DZMWBaZ2S15+JSWhdD0zZhcA7X5agpKUw4/+OaYi8zN7LocZNPzfO+2Bzn7udlqRSh5
         2Gvg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1783962933; x=1784567733; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=mxVrxa7HxzqTiw7ir6NHv4olNuo0XGTjz/0zgJXDsGk=;
        b=E3VLVQfL3akjUu3GljtHvHzx+NYP+s4E0/GMC6ZzcTSiMOZo+FCSyvuBUFHzfUbVHe
         6/R0nlxgxctOIHExWTwSfWkbMRb46OADXq//DeC8Re1MWugUP6CxW2M9hD7BGWvHI8PZ
         9Ml9K2YtI90ohMA66r6vDycUGJES05bQWI21OfbCF4YPMMybZaKt4SP8qLb8W7kIFQ9G
         8cB77E4+LLSNuTkF//hJYj/9lS5NfTNAwmIqpKNdlxqubiUXeuE1nH+jyaBRWLdRFTcp
         99Yd3WraJUcWcBgByoBa82MrelPCX13UoyHYrjEVX2Tg35hm+8UPuTCdLTb6PU5QASEK
         g1ig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783962933; x=1784567733;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=mxVrxa7HxzqTiw7ir6NHv4olNuo0XGTjz/0zgJXDsGk=;
        b=XsE9MI4cwbMmiTWg+1jfpmNIb8qdSEI/WHdEUprSe4cZ8a/d6dylgVRE7So2T9saOs
         6hu9KC7zNw+QBWP+PvB38YzUKL8D/2enS4SB9vBc3+KcsUgMh34vYORcbYutRMEFMIXI
         PyUCiCVz3+iT0D6pIYBlUxFdgfZQG54lBTE66cvM1LMA8Jgh97g1qhrQCd2BP4RHelJ6
         RgTntYrU10yl5TVGMwH27FVrlJaE+IUfWvlsx+T0MoorrfP/oWYhIj4ENxNBZnzmWJB+
         e9H21JS7+9X3B2BbfAGTg7zpQmwWvfTdMlDhwXkhuwEXS145Sp8zQkI7pc/NYx0AInjk
         G3Sg==
X-Forwarded-Encrypted: i=1; AHgh+RoBRx1NST32ttdTQEjtgcagCYV8r9+n9Hr5Ks+mgSVUTqZk9wvBSaUq+/XlZK1Ra9vnaAc6t9m0ORwQ@vger.kernel.org
X-Gm-Message-State: AOJu0YwaXgOr2FFsxwKN68iKEbHAfLkA8MJKcqlBoHpQB35zpdTrAJqi
	1i8TA26TXbTJsbUibLl+YlKMJNElK72okKXI8CwUzyLNgBTYqCBL5WrssA0ogMkO3CmSidZ7dHl
	i+7HJx0p28Jej8t3Ilm+y/jhr4yhW9XG3A4KNywxx
X-Gm-Gg: AfdE7ckGD9vZmUh39xwsUBB69mg3nTcwlfvzUewiTAjQIjAPqUniJW0mTQ/gu6mPQEg
	K7TUFsLRQw85lYqBvao1RN1+8tgKY9wsjZLmh1K1QkUC0vv5PRnCdjy1lxVZyBznB7JR1vbV1Ql
	mO/GPpPVikHdxWuC+M8bYpB3/kqlQT42T7nlHcEt5oecZo83iJEO4CtRZwsq5wRl/ie8ezW4iNq
	YXom+y6C7jZRdbLJJjn4tE509YWDqGHWmFY7ycpzt+Aeup3rwvOZLwtbuGZTQAltUi8TsEB2tlk
	SmEuFg==
X-Received: by 2002:a05:622a:90b:b0:51c:97f:83a9 with SMTP id
 d75a77b69052e-51d71546a4bmr4450771cf.1.1783962932086; Mon, 13 Jul 2026
 10:15:32 -0700 (PDT)
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <202607091820.qbjlGhKK-lkp@intel.com> <CAJuCfpHjUij9kkD6QiWxYvsYD3iKga9rzJZWnN9vCf3bhp-dXA@mail.gmail.com>
 <CAL41Mv6UNWWdv3a2g2+tKuy+EX=8FJZSCcEAyHYyuUybYK4NMg@mail.gmail.com> <CAJuCfpEpFDUNjgsHiETmxTLyVfHdCKEk8sR2fQtixBR8JOYRoA@mail.gmail.com>
In-Reply-To: <CAJuCfpEpFDUNjgsHiETmxTLyVfHdCKEk8sR2fQtixBR8JOYRoA@mail.gmail.com>
From: Suren Baghdasaryan <surenb@google.com>
Date: Mon, 13 Jul 2026 10:15:20 -0700
X-Gm-Features: AUfX_myZvy1Z8rlEHgfTq9Uyko36CQ_cIKDIOFd8bUwroWjufDnlrmXdmhg81mI
Message-ID: <CAJuCfpGmHY5_4G01DNodJA8byCkJUET00Lr8Ap0P6+XMV1=7jw@mail.gmail.com>
Subject: Re: [akpm-mm:mm-new 344/369] mm/alloc_tag.c:356:58: error: implicit
 declaration of function 'compat_ptr'
To: Abhishek Bapat <abhishekbapat@google.com>
Cc: kernel test robot <lkp@intel.com>, oe-kbuild-all@lists.linux.dev, 
	David Hildenbrand <david@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, 
	Linux Memory Management List <linux-mm@kvack.org>, mm-commits@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Jul 13, 2026 at 10:13=E2=80=AFAM Suren Baghdasaryan <surenb@google.=
com> wrote:
>
> On Mon, Jul 13, 2026 at 9:43=E2=80=AFAM Abhishek Bapat <abhishekbapat@goo=
gle.com> wrote:
> >
> > Hi everyone,
> >
> > I can send a fixup patch for this error if needed. Could someone guide
> > me on whether I should amend the original patch-set and send a v9
> > patchset or if there's another way to handle this without sending a v9
> > patchset?
>
> I think Andrew already fixed it up (I saw an email flying by but I'll
> double-check).

Here: https://lore.kernel.org/all/20260709171454.58E851F000E9@smtp.kernel.o=
rg/

>
> >
> > Thanks,
> > Abhishek.
> >
> > On Thu, Jul 9, 2026 at 7:45=E2=80=AFAM Suren Baghdasaryan <surenb@googl=
e.com> wrote:
> > >
> > > On Thu, Jul 9, 2026 at 3:00=E2=80=AFAM kernel test robot <lkp@intel.c=
om> wrote:
> > > >
> > > > tree:   https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git=
 mm-new
> > > > head:   59e34180e138a293260301c139cf7ee800978533
> > > > commit: 27ace96bf8195484c9e9e1a08eb5af5a4e81f9f0 [344/369] alloc_ta=
g: add ioctl to /proc/allocinfo
> > > > config: sparc64-randconfig-001-20260709 (https://download.01.org/0d=
ay-ci/archive/20260709/202607091820.qbjlGhKK-lkp@intel.com/config)
> > > > compiler: sparc64-linux-gcc (GCC) 15.2.0
> > > > reproduce (this is a W=3D1 build): (https://download.01.org/0day-ci=
/archive/20260709/202607091820.qbjlGhKK-lkp@intel.com/reproduce)
> > > >
> > > > If you fix the issue in a separate patch/commit (i.e. not just a ne=
w version of
> > > > the same patch/commit), kindly add following tags
> > > > | Reported-by: kernel test robot <lkp@intel.com>
> > > > | Closes: https://lore.kernel.org/oe-kbuild-all/202607091820.qbjlGh=
KK-lkp@intel.com/
> > > >
> > > > All errors (new ones prefixed by >>):
> > > >
> > > >    mm/alloc_tag.c: In function 'allocinfo_compat_ioctl':
> > > > >> mm/alloc_tag.c:356:58: error: implicit declaration of function '=
compat_ptr' [-Wimplicit-function-declaration]
> > > >      356 |         return allocinfo_ioctl(file, cmd, (unsigned long=
)compat_ptr(arg));
> > > >          |                                                         =
 ^~~~~~~~~~
> > > >
> > > >
> > > > vim +/compat_ptr +356 mm/alloc_tag.c
> > >
> > > Missing #include <linux/compat.h>
> > > After adding it the error goes away.
> > >
> > > >
> > > >    351
> > > >    352  #ifdef CONFIG_COMPAT
> > > >    353  static long allocinfo_compat_ioctl(struct file *file, unsig=
ned int cmd,
> > > >    354                                     unsigned long arg)
> > > >    355  {
> > > >  > 356          return allocinfo_ioctl(file, cmd, (unsigned long)co=
mpat_ptr(arg));
> > > >    357  }
> > > >    358  #endif
> > > >    359
> > > >
> > > > --
> > > > 0-DAY CI Kernel Test Service
> > > > https://github.com/intel/lkp-tests/wiki
