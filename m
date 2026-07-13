Received: from mail-pl1-f176.google.com (mail-pl1-f176.google.com [209.85.214.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C39FA2D3225
	for <mm-commits@vger.kernel.org>; Mon, 13 Jul 2026 17:20:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.214.176
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783963257; cv=pass; b=CGrXeI30/xRC+wjzC7V0piiSFTWf1kYHE9Ff/zXk0VQ2cVdmsyrm/PwB3Yrghmy50bU5zE5yebbE5d1WQJ1zC2GfWKQrlbSJ/vdIBevAkPMZmmpc2IjVNhkBrCCwtBMsWGVqg2wOwUe6EXIcGjbxQdSUuRY3ZxIh2K2P1jQnkj0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783963257; c=relaxed/simple;
	bh=j+VWBP3JZZ9bvegeAImxD3t0lnkJPKxClSYTCXu3Qcg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=kBtBO78RL1EDsHGtuH0f/lZZQ7P4ujy8ZJOwpQIuPx2njAyp8gmdvb+EpgOq0UU/nwk70wlco6qor54KNzWdKUwd/aRj75yOM8QiIrs7NOja1l+US61VJGKc2v1BxWiBsN93cpBDl+7wXK+TZeR7wZ0l6KDnptW0MEqIi5PpeFE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=I1J1EvuX; arc=pass smtp.client-ip=209.85.214.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="I1J1EvuX"
Received: by mail-pl1-f176.google.com with SMTP id d9443c01a7336-2cab97c86bdso4405ad.1
        for <mm-commits@vger.kernel.org>; Mon, 13 Jul 2026 10:20:55 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1783963255; cv=none;
        d=google.com; s=arc-20260327;
        b=ouS2vWy22f5UBXpZPE7CeAIcM3QZkRAqHcPcX4mhplana9X6yaE3He8E912NHs0MAp
         LjyYmlnIsSa+jWlmQwRbtSQ38bn2Ci9+jPbomAWmPZK9/FEwIFDgsZCNcKhDQxDJ3WBC
         LYfaKnNCSSYYmRVhjhfJnyW8vyFB6RxtREMytZIJDsy8A33zXp//3EUlfCDEM8co1/sl
         ZDtwk54urOqSI50yNePVMzJG6GBXQQ3jpBXF1hV2jzO1DhQDMrgm6qegB1r8kjk1USzw
         icxWrTHt1O9jop86P4gS+bq+ph/i7KZj4G6bpfrkCBJwel3CBuCBVpNr7x43iKVsjTo7
         PNiA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=3Up4enbVP5XhzSIUsHA2kSerHZ2dcsLiJ/grrTWqZXk=;
        fh=jsgBeFgR5nSYluir5+jlM+Qkp/b7rJtv6z/wy2aHVF4=;
        b=eRXdV2z0ryRLJW5Sw1A1VGQQTUDysu71iXSh9Gn+H+DjSzUjeB+bh+aT0ocejtBsyN
         TPPjwqXkyyRbSr1jNfTHkeA6Zk5FG3e6yxZlDD2AT2cVkAoOiopIqXjIv+cmSjsCEDtz
         0rZIwhuT9LA8alJB0/hUFuMzVTvrrB+Jbvrdf64x3ngwA8OTvT7KpMzcnWZnzFD/wARi
         jASNgyByMf7OCgp0nlqyJBcXjnCil2oqqdCKCJGuLSzUr45q6hjLkFkUx5M+u/BEjand
         LJ5Qg7yDYDXAneJEZn+CScmNhNLrz/2agEnNdqSAbhdFn56DF6jWIDD59jXavopfMYwU
         OqEA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1783963255; x=1784568055; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=3Up4enbVP5XhzSIUsHA2kSerHZ2dcsLiJ/grrTWqZXk=;
        b=I1J1EvuXXYmmQTm+4nFL+i5YdAHZDRVtL3OZCR/To+ivZqhYlmIVwRfTOxI3JXE+Am
         ET09HN1LYSyUQumedKFA+TqV0DUZSQ/8SrT2I38chmtjYPlSPNUk5LFUS5Xqt3SdPPSm
         SlToKW5xw8P/1lXeTE0nifBcEmtMfiq+szIw7cRJsD1RvHmmn6W8YwleI8QZyxGB4GVf
         iiKu4LcXfYdvnK2gQPjQN5PaVGC1rmscFWmg21WyOutG8dzqVpr6OD06/RZTM8Naqh20
         jeT1iBSjSi0N8IBlqjClG4VpVD2dUgw7wR/pzxhd1lbLz3gRzcaInyFyfHNfslAK6tHR
         YKEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783963255; x=1784568055;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=3Up4enbVP5XhzSIUsHA2kSerHZ2dcsLiJ/grrTWqZXk=;
        b=Wm2PrWsmiGjVwY3iRLb64AXi8QGB6kNds9RF8YvRts1G49MmMzjPVUUwd9g71wbOxr
         oi3PgsH5o4HBsyqddEZubWCbO77E4jQ82zrIuLoF7gWR93odndHw9WZaaq1F01kVSlqy
         orFGwfzavkimxNJRNMUTpD+NYJUc1U9DUsLpZwlHoHwOdhuI55On0fkVyAYV7fO0/kQu
         ekDxzaEbkcU2sNmljktDMyZWKWKn0fCBqUWylqgbPGLmjYGddwBH5sveZA8y3uVtytUp
         3GhFu2Upn49VuRPxUwIEX4V3v077RoVitg3c51nvgDWX4fnz1y6KAQ2szxxhJcR3t9Cp
         YvVA==
X-Forwarded-Encrypted: i=1; AHgh+RoHBLt+aOzCBRBjtCShArwchLU4NgB02r++7nOKkrvLpUNJ2o2Om5Ab8hQgSpDDdzTvVMMKtj5vVfS9@vger.kernel.org
X-Gm-Message-State: AOJu0Yx8wN3fjFivFPKh4YIJKU1EY8BBCei/L+l4OsuiMLXgIVUGOLsa
	MwFp879CzKMclvzRQgmFBvwJ2IwV7fBH+fpFTQtFpVPu12lp/VbBmpZmpdeE2GotKsZRnviskUB
	pU383e+c3dfRE7x7/2dQqvKdNtd4GrVlT0h+APahr
X-Gm-Gg: AfdE7cmZNQGS1COZP2e1lH2s82bh7ZA5hntJ4TY2Ll7CpM3Ir+pf7wd3GGg/cBxeDi6
	S+4qw4cg5v7/iSwJJUZHWZo4acg8HOPl340d5j3Xr0wIDSpvdskB7C7SrHBMa1szo1evDrF2Yv+
	EqYsKcAGbJ3fPMaYhI1bxgtzKCS4Bt2eUs2LHE7qOIOboIM9o0Nf7CGqPOiPoA25j/En16KtKwi
	6Itp8xb0jFcFt7NWLbdjNNURjZ/PPxT9gM6vB7X0uNg2AK5DM1aSoS7Im2aFjNHddvG/jsrCet8
	O/WVwli/rWUaeKmlJ9QTEVnM
X-Received: by 2002:a17:903:3850:b0:2c7:a13a:7fe6 with SMTP id
 d9443c01a7336-2cee1be4f23mr1770825ad.10.1783963254512; Mon, 13 Jul 2026
 10:20:54 -0700 (PDT)
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <202607091820.qbjlGhKK-lkp@intel.com> <CAJuCfpHjUij9kkD6QiWxYvsYD3iKga9rzJZWnN9vCf3bhp-dXA@mail.gmail.com>
 <CAL41Mv6UNWWdv3a2g2+tKuy+EX=8FJZSCcEAyHYyuUybYK4NMg@mail.gmail.com>
 <CAJuCfpEpFDUNjgsHiETmxTLyVfHdCKEk8sR2fQtixBR8JOYRoA@mail.gmail.com> <CAJuCfpGmHY5_4G01DNodJA8byCkJUET00Lr8Ap0P6+XMV1=7jw@mail.gmail.com>
In-Reply-To: <CAJuCfpGmHY5_4G01DNodJA8byCkJUET00Lr8Ap0P6+XMV1=7jw@mail.gmail.com>
From: Abhishek Bapat <abhishekbapat@google.com>
Date: Mon, 13 Jul 2026 10:20:42 -0700
X-Gm-Features: AVVi8CdocdmQKkxGo8IOucf6phPMN-TtFmhTpXYtX5usitAxYi5eJViaBHUqH20
Message-ID: <CAL41Mv5X4tNvRcP1u9kEe6LKMTYpeS93E4oCBE_3N-iUgVLO=Q@mail.gmail.com>
Subject: Re: [akpm-mm:mm-new 344/369] mm/alloc_tag.c:356:58: error: implicit
 declaration of function 'compat_ptr'
To: Suren Baghdasaryan <surenb@google.com>
Cc: kernel test robot <lkp@intel.com>, oe-kbuild-all@lists.linux.dev, 
	David Hildenbrand <david@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, 
	Linux Memory Management List <linux-mm@kvack.org>, mm-commits@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Jul 13, 2026 at 10:15=E2=80=AFAM Suren Baghdasaryan <surenb@google.=
com> wrote:
>
> On Mon, Jul 13, 2026 at 10:13=E2=80=AFAM Suren Baghdasaryan <surenb@googl=
e.com> wrote:
> >
> > On Mon, Jul 13, 2026 at 9:43=E2=80=AFAM Abhishek Bapat <abhishekbapat@g=
oogle.com> wrote:
> > >
> > > Hi everyone,
> > >
> > > I can send a fixup patch for this error if needed. Could someone guid=
e
> > > me on whether I should amend the original patch-set and send a v9
> > > patchset or if there's another way to handle this without sending a v=
9
> > > patchset?
> >
> > I think Andrew already fixed it up (I saw an email flying by but I'll
> > double-check).
>
> Here: https://lore.kernel.org/all/20260709171454.58E851F000E9@smtp.kernel=
.org/
>
Ahh I see. Sounds good, thanks Andrew!
> >
> > >
> > > Thanks,
> > > Abhishek.
> > >
> > > On Thu, Jul 9, 2026 at 7:45=E2=80=AFAM Suren Baghdasaryan <surenb@goo=
gle.com> wrote:
> > > >
> > > > On Thu, Jul 9, 2026 at 3:00=E2=80=AFAM kernel test robot <lkp@intel=
.com> wrote:
> > > > >
> > > > > tree:   https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.g=
it mm-new
> > > > > head:   59e34180e138a293260301c139cf7ee800978533
> > > > > commit: 27ace96bf8195484c9e9e1a08eb5af5a4e81f9f0 [344/369] alloc_=
tag: add ioctl to /proc/allocinfo
> > > > > config: sparc64-randconfig-001-20260709 (https://download.01.org/=
0day-ci/archive/20260709/202607091820.qbjlGhKK-lkp@intel.com/config)
> > > > > compiler: sparc64-linux-gcc (GCC) 15.2.0
> > > > > reproduce (this is a W=3D1 build): (https://download.01.org/0day-=
ci/archive/20260709/202607091820.qbjlGhKK-lkp@intel.com/reproduce)
> > > > >
> > > > > If you fix the issue in a separate patch/commit (i.e. not just a =
new version of
> > > > > the same patch/commit), kindly add following tags
> > > > > | Reported-by: kernel test robot <lkp@intel.com>
> > > > > | Closes: https://lore.kernel.org/oe-kbuild-all/202607091820.qbjl=
GhKK-lkp@intel.com/
> > > > >
> > > > > All errors (new ones prefixed by >>):
> > > > >
> > > > >    mm/alloc_tag.c: In function 'allocinfo_compat_ioctl':
> > > > > >> mm/alloc_tag.c:356:58: error: implicit declaration of function=
 'compat_ptr' [-Wimplicit-function-declaration]
> > > > >      356 |         return allocinfo_ioctl(file, cmd, (unsigned lo=
ng)compat_ptr(arg));
> > > > >          |                                                       =
   ^~~~~~~~~~
> > > > >
> > > > >
> > > > > vim +/compat_ptr +356 mm/alloc_tag.c
> > > >
> > > > Missing #include <linux/compat.h>
> > > > After adding it the error goes away.
> > > >
> > > > >
> > > > >    351
> > > > >    352  #ifdef CONFIG_COMPAT
> > > > >    353  static long allocinfo_compat_ioctl(struct file *file, uns=
igned int cmd,
> > > > >    354                                     unsigned long arg)
> > > > >    355  {
> > > > >  > 356          return allocinfo_ioctl(file, cmd, (unsigned long)=
compat_ptr(arg));
> > > > >    357  }
> > > > >    358  #endif
> > > > >    359
> > > > >
> > > > > --
> > > > > 0-DAY CI Kernel Test Service
> > > > > https://github.com/intel/lkp-tests/wiki
