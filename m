Received: from mail-ot1-f45.google.com (mail-ot1-f45.google.com [209.85.210.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 771461C6FFD
	for <mm-commits@vger.kernel.org>; Tue, 11 Mar 2025 22:42:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741732968; cv=none; b=SKFUQMEg66L+Z76Z3fuj8bQaEYytUnk5kyBqMgTks0e+7YpOqD30Bw3AQcDhrb5CH6+yLwmGAxhmhIReew7rZDIHM7HBrtYcE162R4iWvx9vT6L2Cw0rLnpyOSKFMxfuyQbb84ofWsRrzL8TFmnhCWdEA7dTFDiXxTgNvIlxHfE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741732968; c=relaxed/simple;
	bh=l9TMy48z552sse1F7btsGhUG1n+pYc0mzkkadZ/rSZ0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=J9qY0or2LbAuqAY7ntYtix1VJ9atWI0LHYXCrdM9bzfW2OSsbBIj+vW2Pb/4YQAsHIkwm29SjrHjmsg6/R6LQGWrMYZjiPJF3hSQZn1nITilR+q5Z/rXITSaGqDulqMgXPOVL7/NR+hET/fmS1oVKP88bUWAp1sQDU9ogpn/sEE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org; spf=pass smtp.mailfrom=chromium.org; dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b=mRNt7g2/; arc=none smtp.client-ip=209.85.210.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chromium.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="mRNt7g2/"
Received: by mail-ot1-f45.google.com with SMTP id 46e09a7af769-72b7d7d9ed0so290986a34.3
        for <mm-commits@vger.kernel.org>; Tue, 11 Mar 2025 15:42:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1741732966; x=1742337766; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=CvZeAk80nOlcfI1bXse4gulQOtErFOMu9KOzkojB1jY=;
        b=mRNt7g2/q0hLyV3v7o4sP1Vrqk9rF942nfNJp1DfkE7dGUG9IU8Rmxa6u/b8SZGBAT
         KSAxMEMKHnHEXivj+AVsN/Z+pjhCRl5WT19S3sleITPtS9u0y+47PXNvYIJilVh1Mnax
         fDVat42kDBZ+hbz5GSX5g80Ps/iVqLR7CbVEU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741732966; x=1742337766;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=CvZeAk80nOlcfI1bXse4gulQOtErFOMu9KOzkojB1jY=;
        b=ikS1hM5x6bgRABJuWtfg1N6ye1zBjpF3C2SRgq1bwlKO7oMyrE40n9f5mMpTgmc3SA
         dj1LJx9Vmbo7nESa69BhF2nAPM7nLKDFlLCZXi29YvJnutyeGomT05LvvucXVerVYu0r
         GGnTg6XCc88Hs9VUfzRnPqhr9gyVcBfQIG8RBwtaj0P+7L5WhF9tvacab4MT8FVFWLKU
         X6NPi4i/1mBLmm2cULvmhHGbRemqkT3X1znziOcuobe9uX3mzwjkhbHRH5u9OMEsLJNW
         QPuzF48oL3a7uokQwSEZNBQWMqyVNrHVn/oCpBR8Ax9uOJgnguhPHpIbNgF9VCeEzVN2
         t6qw==
X-Gm-Message-State: AOJu0Yw1lAxXsj2I57v0ZGWigVjxH6G0VZI8GxFWL2ufFPNmWJhDo6C1
	DPrLY0CvxUQkWJ2XKjoLz/CvZY2bHa/Z50j3F/dms14K24TJwByIcygXvikM7FiQpuI1R/peS1M
	z1fpm7SQ3W5Bs36drQQmlXi36wUU/FkiQONiI
X-Gm-Gg: ASbGncufB+f0ttZ5cuK0ihzsrMysWHMKUk1fIiM+XDK2c2hoBSm9OAnm2DVRZP4jsRc
	S3CDNhMNRO2d9tIgkHG2JvRi/0VboMznLmzH7BU4Nr9u1bbVtYFv+bO5UdkEygVn77DwVvqD9PF
	fOoGQNHfd0jhWGEa5kKvGeheng
X-Google-Smtp-Source: AGHT+IGLcPsz9Q2jfUXTk8CzOHdh7Lid/0BD99OLaA2nVpMTLPTGM8mqlCrdPXV4S8vXAGsIb1EIyNniaY/x7HDet28=
X-Received: by 2002:a05:6870:80d3:b0:26c:641a:871c with SMTP id
 586e51a60fabf-2c2e896cfbfmr1069792fac.9.1741732966340; Tue, 11 Mar 2025
 15:42:46 -0700 (PDT)
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250311174209.D1BC2C4CEF0@smtp.kernel.org> <CABi2SkU2YnTV7caq+JqsO1baC0dbHm8ZibBPRfg+_WebmbC2Zg@mail.gmail.com>
 <20250311152210.5b37a59a7f70e884877d07eb@linux-foundation.org>
In-Reply-To: <20250311152210.5b37a59a7f70e884877d07eb@linux-foundation.org>
From: Jeff Xu <jeffxu@chromium.org>
Date: Tue, 11 Mar 2025 15:42:35 -0700
X-Gm-Features: AQ5f1JoqZjMPnUdaQVuHdAowtZ457urm1AfR4yjEoYd4qkiOIl7ISiSZQ9Zz2VQ
Message-ID: <CABi2SkWAAr2ayfDk3mqVUyd0ocB0-Gq135t-kiSs9xQ_5akgmA@mail.gmail.com>
Subject: Re: + mseal-sysmap-generic-vdso-vvar-mapping.patch added to
 mm-unstable branch
To: Andrew Morton <akpm@linux-foundation.org>
Cc: mm-commits@vger.kernel.org, thomas.weissschuh@linutronix.de, 
	svens@linux.ibm.com, lorenzo.stoakes@oracle.com, liam.howlett@oracle.com, 
	gor@linux.ibm.com, borntraeger@linux.ibm.com, agordeev@linux.ibm.com, 
	hca@linux.ibm.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Mar 11, 2025 at 3:22=E2=80=AFPM Andrew Morton <akpm@linux-foundatio=
n.org> wrote:
>
> On Tue, 11 Mar 2025 15:11:22 -0700 Jeff Xu <jeffxu@chromium.org> wrote:
>
> > > --- a/lib/vdso/datastore.c~mseal-sysmap-generic-vdso-vvar-mapping
> > > +++ a/lib/vdso/datastore.c
> > > @@ -99,7 +99,8 @@ const struct vm_special_mapping vdso_vva
> > >  struct vm_area_struct *vdso_install_vvar_mapping(struct mm_struct *m=
m, unsigned long addr)
> > >  {
> > >         return _install_special_mapping(mm, addr, VDSO_NR_PAGES * PAG=
E_SIZE,
> > > -                                       VM_READ | VM_MAYREAD | VM_IO =
| VM_DONTDUMP | VM_PFNMAP,
> > > +                                       VM_READ | VM_MAYREAD | VM_IO =
| VM_DONTDUMP |
> > > +                                       VM_PFNMAP | VM_SEALED_SYSMAP,
> > >                                         &vdso_vvar_mapping);
> > >  }
> > >
> > > _
> > >
> > > Patches currently in -mm which might be from hca@linux.ibm.com are
> > >
> > It is better to insert this patch before the architect specific change,
> > and right after
> > selftests: x86: test_mremap_vdso: skip if vdso is sealed
> >
> > So the newly added selftest (selftest: test system mappings are
> > sealed) would pass in bisect.
>
> That's what I did.  I think:
>
This is the sequence I meant:

> mseal-sysmap-kernel-config-and-header-change.patch
> selftests-x86-test_mremap_vdso-skip-if-vdso-is-msealed.patch
mseal-sysmap-generic-vdso-vvar-mapping.patch
> mseal-sysmap-enable-x86-64.patch
> mseal-sysmap-enable-arm64.patch
> mseal-sysmap-uprobe-mapping.patch
> mseal-sysmap-update-msealrst.patch
> selftest-test-system-mappings-are-sealed.patch
> mseal-sysmap-enable-s390.patch
>
