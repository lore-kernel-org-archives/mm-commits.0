Received: from mail-ed1-f44.google.com (mail-ed1-f44.google.com [209.85.208.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08490246773
	for <mm-commits@vger.kernel.org>; Tue, 10 Jun 2025 17:28:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749576488; cv=none; b=PNnXmp90fi8q8/ifOV/vp00ldMc6hDSKHzJJ9HvOEGPiYCKUgvMDYSChXL4xwCR3Q2R6+a2zdwjesrPM0X7vWcade2P9ZqCMcIg+iMdN2jgM0HR+bJB06J5WeYCTD2GNaPkjuWNlP5Mup4HibBNVODh6U7pPV2uQl4cKAErR7GI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749576488; c=relaxed/simple;
	bh=PVZyBqjGIVhV1fw7dIcdJqjMZ05mClHZkbxF2OooV18=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=EDtEi4cTvxudHqq/oltLzw4DLz9Gj16EfPqcbL4I9ESmLxtfzsp9ePR6Iu0agmEUi0UM7IYYQC2EUQnjAXDXZD/tygYZc/JfRXR6lXcUMvmoAXS/OIjherqA16AaVslsccw4jgu/+cLxcCVWfRmkaqXYHRueqhsN8ZKq2ppMs9k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=FNV2fJsm; arc=none smtp.client-ip=209.85.208.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="FNV2fJsm"
Received: by mail-ed1-f44.google.com with SMTP id 4fb4d7f45d1cf-605b9488c28so9162695a12.2
        for <mm-commits@vger.kernel.org>; Tue, 10 Jun 2025 10:28:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1749576484; x=1750181284; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=ggkXFJJM4tmqklVbhKHNnaysMh0I0jQ20WCMlBH6Csw=;
        b=FNV2fJsmtE9kRlIfsqwRRA+0lXQVAw8X6FbLRBEXpGwAL9fr5X1iiCLuZSrg7pBtHU
         qgt929zbYGx0MiMCFWljo09FmYBfm5iGHSvgSP9UEIHnc1TKzg01wv7TI91ZeS5gVpaw
         LEMhttdfBt4QkZe/bBrjGcZS5riIPYodp8r8c=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749576484; x=1750181284;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ggkXFJJM4tmqklVbhKHNnaysMh0I0jQ20WCMlBH6Csw=;
        b=todysExJR9qErDK5XEUwtN6JVIimIZm7zYuiJZG4HufpCR+f+wyBgYpPxgCYDXztpD
         gSc69oCpCORl77eav6QebutxMN5CqzhQH/7ubmaB5OpSUjlhVeD6GY8HilSHiJcIcGIK
         yZFSlvX+C6UVgZj3k6ryBWIXrnHHadAEcDeWhUhfovSXyCo0Nc+izxjJ/cl0Wky5Vtz0
         GzL/o8U+KIhMpHrfXh6tWVLJbWxS15JaH0FNYJf+/LzA2hRHVDUmezUXxklS0dMJAR3+
         AVrZfyiRmEe2WMXAFSkzp3NxQ/P5bMWTI6P6FWr4xwSy4GJXXkMoqFuwjlObzHOR3W4g
         Vw/g==
X-Forwarded-Encrypted: i=1; AJvYcCW/NvHe7O4+1eTQlYNHVyIKTk8+OSPhVmR5CCcP125ieAplHhGO1sYI9NT3MsMnTYA5kqkdUM7oyb4c@vger.kernel.org
X-Gm-Message-State: AOJu0Yw3Iwmf9B3dzata9Is97CwRIryaGh+0VgGpvs4Cabs5AIxfmSV9
	gv3yaF9fUwAmOoW3Nhtb0YQOALNVfqEMl+JoAn+nPloevZveexpFu9YjjZalOhp4um+1UJYPlpM
	W245hYDk=
X-Gm-Gg: ASbGnctxFimrUQmD26TAwuIk/Qaz8/XfNfSIAq/iVywaxMRi4oJQVNhgWyULZsb2+/W
	cSyfQiS1SRXcmnk5dgaVXhXosTphGmxbtUIygG5eo13OuL18wg84oYu9G781ZvyXwj2W5ADsbD5
	PpSCEJQAuAVL1vlDHXgpoZ33y4TqUi3RYlv12WK5gKiiwV44cVD3YNjdiCjluv4Jha8Y8u3X7nR
	SjhARec1noctA8fnf7UBpcmNMgVId4IuHn15U/+Xnpxmqao3VAu4xuj19pbutaKDXGjdaUGK6eX
	kBWwVZUGBJ4m8mSeboFEoQ4eFwF+aRU+W+Y4IfXZvFvSJELM36ErJzzvHkSi0q7sNhzKM5DSekj
	ZEAmcmhND3EozZ5JKpcGO7eXCNlXOQllW9IfA
X-Google-Smtp-Source: AGHT+IG7XfPaZqKmoX2Er2nw6nSG5eHleywwF3i2e6cK8j2kNt8mk1dTudAFM4M/YK3G8ZTqsycVLA==
X-Received: by 2002:a05:6402:278c:b0:5ff:ef06:1c52 with SMTP id 4fb4d7f45d1cf-60846840633mr111863a12.3.1749576484096;
        Tue, 10 Jun 2025 10:28:04 -0700 (PDT)
Received: from mail-ed1-f52.google.com (mail-ed1-f52.google.com. [209.85.208.52])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-607f162352asm3046486a12.71.2025.06.10.10.28.03
        for <mm-commits@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 10 Jun 2025 10:28:03 -0700 (PDT)
Received: by mail-ed1-f52.google.com with SMTP id 4fb4d7f45d1cf-605b9488c28so9162642a12.2
        for <mm-commits@vger.kernel.org>; Tue, 10 Jun 2025 10:28:03 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCWr6D3/GT3pVUUymHFlRFjvvoE0jBQQgChVPOUSNPIeUDR4Khpcz6A0eY6HgBzb7buomwFeM/rGaziQ@vger.kernel.org
X-Received: by 2002:a17:907:7f07:b0:ade:f72:435 with SMTP id
 a640c23a62f3a-ade897cf7fbmr24618766b.36.1749576482668; Tue, 10 Jun 2025
 10:28:02 -0700 (PDT)
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250601151222.60ead71e7d8492a18c711a05@linux-foundation.org>
 <CAMuHMdU1NdNjx3f1V9j2FACWwC5faPKCXChtW6Z=i2JyXquFuA@mail.gmail.com>
 <20250610085416.062b4bc386dde2ea475369f5@linux-foundation.org> <CAMuHMdXyJhaFUbKX2Hhoa2y4hVK+0NhvL4hNL_8RnVOxaCkq=g@mail.gmail.com>
In-Reply-To: <CAMuHMdXyJhaFUbKX2Hhoa2y4hVK+0NhvL4hNL_8RnVOxaCkq=g@mail.gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Tue, 10 Jun 2025 10:27:46 -0700
X-Gmail-Original-Message-ID: <CAHk-=wgXTJo5G7e1cQxetFLbqbTUfP7Nfzt7-C89FjUHo1J9cA@mail.gmail.com>
X-Gm-Features: AX0GCFuSBnImfaPnnRPaw-kRRNGK3RROtak9Ct6XSRJ9KKoJNMvO8fbVvKrYfaM
Message-ID: <CAHk-=wgXTJo5G7e1cQxetFLbqbTUfP7Nfzt7-C89FjUHo1J9cA@mail.gmail.com>
Subject: Re: [GIT PULL] Additional MM updates for 6.16-rc1
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, SeongJae Park <sj@kernel.org>, 
	Honggyu Kim <honggyu.kim@sk.com>, linux-mm@kvack.org, mm-commits@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On Tue, 10 Jun 2025 at 09:41, Geert Uytterhoeven <geert@linux-m68k.org> wrote:
>
> Just revert the commit?

Yes. We don't do "default y" for random features.

EVERY SINGLE DEVELOPER thinks that *their* feature is so important
that everybody else should enable it.

And if that feature wasn't enabled before, they are completely wrong
99% of the time.

There is a very real reason why 'default' defaults to 'n'.

So we do *not* use "default y" for features that aren't universal.

The only time we should use 'default y' is if some old feature that
used to be unconditional gets split up into a new Kconfig variable and
not using 'default y' means that people *lose* functionality.

Or if the feature is some critical security thing, or is some hardware
thing that has become so universal that you find it on basically every
single machine.

Or if that feature cures cancer or brings world peace.

Then you can enable it by default.

I have reverted that 'default y' thing, because I see no reason to
believe that DAEMON cures cancer.

               Linus
