Received: from mail-ej1-f41.google.com (mail-ej1-f41.google.com [209.85.218.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA4B244C7C
	for <mm-commits@vger.kernel.org>; Sun, 26 Jan 2025 07:34:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737876883; cv=none; b=ukWgVPWH85Ze99NvVG2WLTi97IYtnqyKSi0x63yReeYKITKasR3mMmnPtOOjgd/ZNiT3eW85+iivkxrFCbwARdQ8J6HzrTltZl6ZS4gSVUUsLR4ziXz5n19IauIi3HI5POh1yxKcshRoQjpyotgWQ3wpmDiSzlU0bkN3WV1V4bs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737876883; c=relaxed/simple;
	bh=W5kgCczG2gXfX4YHoGnhVrbtflRY0oquhv47stxfJaU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=QpYU92F8pX7GCUnt1Q5o/jvMmSJ5M6Vyn5DZzL6siqNDhwtPSk+hg45DI1DCcR/QvVm7hiNGyuwkRwJg3n4wpKXuvnRPrD9xj+iqOyiYzeSwNKlKft0ceSKlFSS/zaC90aluPFahHP1E4CA6g40TYoBLaSlthhDSH8Odtu2xvms=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=gWMa+n5E; arc=none smtp.client-ip=209.85.218.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="gWMa+n5E"
Received: by mail-ej1-f41.google.com with SMTP id a640c23a62f3a-aab925654d9so656274766b.2
        for <mm-commits@vger.kernel.org>; Sat, 25 Jan 2025 23:34:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1737876880; x=1738481680; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=3Ja6I8BfelRwDzdo4Ow2m4/tWkFmPZNsiSgMYZIwdcQ=;
        b=gWMa+n5Eih/OS2fDF2qgHljrJ1S/g17KZm6yjVCkpUHCv/cNSJiKW6qObC4HCZM5Lr
         Vri2z3TYQd8NqKSRQlHh2e5bL8azJ/Mtai++kZ+FpH2tkEWb/ZTg5YygX9XPcwozQauu
         uAIOUTmmHFMDtsdvNSoS4wucsVvmb1J6/fvH8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737876880; x=1738481680;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=3Ja6I8BfelRwDzdo4Ow2m4/tWkFmPZNsiSgMYZIwdcQ=;
        b=Ug7LgfONLLNIybPQY2JKA/m7mX6o5cnsCVPn9m5f/4Tm2c1jcgJ22BdDBjIYLgD3dh
         vfY0fRN6K+Ha+KJ95/ZFDbMRHJRU6ceteVrDWm9gYQfo+qyBpPAU++AOr23oCfnJW83U
         eMArhSBWgUi4Z2MmO1Ah9dOlhAuIcAz1GogQGAnsPlw1vJHewDzW5H/WU5pEDrDwwAq+
         K8+F0wGhFr0EOxoJI+LzmyqOeufirtnMScAyYVyVVsLPuwQOMg5RJOQWexKuyAXF4IwS
         QgJT+Jozl5JyKbkAUNV7OVlW+DdhOgI1PvLfn26bHhvauGJwlVRsBgeLbZ9feBoi2r/x
         3m1Q==
X-Forwarded-Encrypted: i=1; AJvYcCU/Pfs/lGs+Yz+7pghKuMKoJBIwcmGkRNQOK4mTyt/AGSwJzYPV9tfvtPGqMVkZtvs1Q2H5acLpRgfx@vger.kernel.org
X-Gm-Message-State: AOJu0Yx0FAEeg+NN/0TIkAb/K4K6EGEtEGzHR/Jr8o/nwupoKNpS+inm
	cJB2gZvRgoo12rXXPpXS7nEHfD1KL5zoG1qjbLOGpbhtYoOv557nePcaJ9ntdRMDB35tbmkgrOz
	/P/M=
X-Gm-Gg: ASbGncv99xcgUKJU6iAgXH8tiZUkLe50HMo8adnwtu1gSMw+f2fHO4M4sUxS6mV3POn
	pVMN2nYDxnpc7bcZNawEyvV+4AGwE7z9Y8cHZRTOQuCoIDbBfOCGYs0P1H7OhQqnPqEC+Vp3giZ
	GpzMFy0HDQs30bvW4HNe8VtJe0ggWXmG8qSZF6tbsBjop+GLA7PLC/JyAz2WIcPU5MkxzvVcgIX
	ijZRMuv+W8EjuGuKxaZ5U8+o66KaDDPA9pzgAESazmra2GLEopwOw0YsbZciOYm6e1aFFVD3efn
	wQDhsh0LLuTA3bA3sDylDl3W0VnA5kTIXAGEdlZksprnkFz7lxvufIc=
X-Google-Smtp-Source: AGHT+IHworrpdOCrgC7Ydjm953XpI1+eghCFIoZrFfiESXkZQI2NEYkYq9ogrFlbG5SXp+EYwf3U2g==
X-Received: by 2002:a17:907:1b03:b0:aaf:1183:e9be with SMTP id a640c23a62f3a-ab38b1e8f64mr3797459666b.2.1737876879770;
        Sat, 25 Jan 2025 23:34:39 -0800 (PST)
Received: from mail-ej1-f46.google.com (mail-ej1-f46.google.com. [209.85.218.46])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ab6760b7788sm383749166b.119.2025.01.25.23.34.37
        for <mm-commits@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 25 Jan 2025 23:34:38 -0800 (PST)
Received: by mail-ej1-f46.google.com with SMTP id a640c23a62f3a-aab925654d9so656270766b.2
        for <mm-commits@vger.kernel.org>; Sat, 25 Jan 2025 23:34:37 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCU67a/5CsdBYSYRTfwaWyi/XUBaIOBkrD4opi6GyaU+0SvU2ng5NNLIdYrmgHHsp4eU/OyAiUzMV0OG@vger.kernel.org
X-Received: by 2002:a17:907:3e23:b0:ab6:71ca:c5a1 with SMTP id
 a640c23a62f3a-ab671cac7a8mr1000998566b.19.1737876877211; Sat, 25 Jan 2025
 23:34:37 -0800 (PST)
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250124162248.60104eec848619a187242392@linux-foundation.org>
 <CAHk-=whddBhfi5DUi370W3pYs+z3r2E7KYuHjwR=a1eRig5Gxg@mail.gmail.com> <20250125210016.815b4260ad539b1e66298d98@linux-foundation.org>
In-Reply-To: <20250125210016.815b4260ad539b1e66298d98@linux-foundation.org>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Sat, 25 Jan 2025 23:34:21 -0800
X-Gmail-Original-Message-ID: <CAHk-=wja7+gm-9s0-ba-FnykK2j0VWyNwOH7VzWSdMERWQzb_g@mail.gmail.com>
X-Gm-Features: AWEUYZkYn7vCsOoXDpuiqh_WhIQ6juvNeXPMOdtfJ7eQi05yn5TIh_1iz6iMbyc
Message-ID: <CAHk-=wja7+gm-9s0-ba-FnykK2j0VWyNwOH7VzWSdMERWQzb_g@mail.gmail.com>
Subject: Re: [GIT PULL] MM updates for 6.14-rc1
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Uros Bizjak <ubizjak@gmail.com>, linux-mm@kvack.org, mm-commits@vger.kernel.org, 
	linux-kernel@vger.kernel.org, Stephen Rothwell <sfr@canb.auug.org.au>, 
	Dan Carpenter <dan.carpenter@linaro.org>, Anders Roxell <anders.roxell@linaro.org>, 
	Naresh Kamboju <naresh.kamboju@linaro.org>
Content-Type: text/plain; charset="UTF-8"

On Sat, 25 Jan 2025 at 21:00, Andrew Morton <akpm@linux-foundation.org> wrote:
>
> And I shall continue to scratch my head over
> Documentation/rust/quick-start.rst.

It really should be as simple as installing the proper distro
packages, and then "make allmodconfig" will enable Rust. It used to be
much more complicated. So do the pacman / apt / dnf / emerge / zypper
command line to just install the packages, and off you go.

Of course, that assumes you have a modern enough distro that it _has_
sufficiently up-to-date rust packages.

So if you are on something like Debian stable, it's simply not worth the pain.

           Linus
