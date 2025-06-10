Received: from mail-vs1-f44.google.com (mail-vs1-f44.google.com [209.85.217.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CDA3E242D7C;
	Tue, 10 Jun 2025 16:41:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.217.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749573720; cv=none; b=dMJ8hlpDL+Lej02Z9C93HNigIlZRWakCumFmGRVhLeVOSj5bYXFrpujeFRZJQD5qHkVn9MrjTPUEVG/bTtEgKkevpihhsVB5Az3MiIsKOoGcAVtk1Tsz28nIn1lWZo709l6NdQCVqCDY3yBi0UYxUNVisHYIOe8y4hi0NDIf7ig=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749573720; c=relaxed/simple;
	bh=TKXZrSF73Ffoq9u+yaIp1nXmlgXO4mLuNTDFNnZeKhY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ixPFFTH+3aSNdexogS0eYH+MFA+/StZ5vQol3sP0eYBS/IAfUWLw9mbLl0mYNCEOpQs9bjYr7b7Dv88C74yS4cAIjp41CH3cewVDOBooSs9m3QPpnacekc5sThyNdMjJE+9Us3rhpKzWsa+EE1rC1dVh174e3vT1KoZYHbZo5Xg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-m68k.org; spf=pass smtp.mailfrom=gmail.com; arc=none smtp.client-ip=209.85.217.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-m68k.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-vs1-f44.google.com with SMTP id ada2fe7eead31-4e58e0175ceso1712542137.2;
        Tue, 10 Jun 2025 09:41:58 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749573717; x=1750178517;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Mevv/cKvWiy0aqpNqPAghZeKSI1e+vGvSGE9NseYu64=;
        b=Xa5Md6oMlD9jJf7/qfmMdBpQC++LYzsL+BoH4WGOQuivLnR2ZJuOSTvJqJEpj2P0Je
         4bnii09fIKV1TIaGFt2WrRrrwUY8Rv44dxEi/AtHgwz8r8mh1toS4dMjGJHbGbOA7x5u
         +FGx0yZkiGzuu8jLTbWlgzIXKhXBt25roW3VnE3WutZr16OLmt6niMUp95GYVSGum9EF
         ox/lHYPZEVJbxSA/UL8NcgSPM7B6zfja4zbNLlLt/2kP8bQ+LHWssfgmave0SyDApw0S
         MIYd2cY2weADPFlGbNL8XrOy9D0lFg3q3yn4PmUMQgNYXtXDqgve8tePqo8O2bh8/v2G
         Mwnw==
X-Forwarded-Encrypted: i=1; AJvYcCWAXnn2qDoNLQbd+4Gh34N0CnPE/PExyu8HoH/G5pw9cCOZYxnjs7wm6cjurvQlFhi8HlnCkWLaMAU7jno=@vger.kernel.org, AJvYcCWX1rhifbOQn43IOcFJgnQOXdMSmPjjxHs6sp4lIx4qV3o8EdjhkML6MqoV7M73ZPrMUan7ULMGtqx7WQ==@vger.kernel.org
X-Gm-Message-State: AOJu0Yxa9LoW+Iwp0JBaQovLKCNw92RAL+AipB1JHRdnCsJh82XIcIkU
	MxKoUviUk+Q5Bf2H5aAzyo9hBlbgqy6Dg+xAifHJjONVd1j4QM9rLwDjyyYABIvI
X-Gm-Gg: ASbGnct9IU4IxbDGYgakYaIINu4owxzUikCeJDYOWQwGjREM+pKx0UutbJXEJArdwiA
	aQWACPf6aQYg6o+ztnekgUotb++TSSzMkWo/w9WUgHLuNndh4KUHclxZOtiUXKIu/nBuSBuBeln
	WEN5ZXD695AcRybWQTGZG+lJYQvTkjlNkyPwVZ/Fr9j7pUMX0hSOPID9npOs/Mh9VRqKNiE6ln2
	mMTiLmOJ/6GXu7qizXq+plxw3MeBmgVVk9ImYwyC9ulmlqjPzNQLRfpO8NjGBsegg/eWlCFQcQJ
	dUe8OHYT3RuT5tTW0CoVrXH7jmemoI6jJPgL4RvQF/sNTC/QwnhcRd3PKJd0MyGznBIvitcbv1U
	cs6MRWFFvj6Zmif9ZxbGTH8Dx
X-Google-Smtp-Source: AGHT+IFZyX2+DUE2ADWIP0NaKWbdFMfnHjU2K3tLJQjGLdEcdpoSfr99W9NUwHwXEEbd83aKf2fIWQ==
X-Received: by 2002:a05:6102:2ad1:b0:4de:d08f:6727 with SMTP id ada2fe7eead31-4e7a8354c7bmr3549189137.13.1749573716663;
        Tue, 10 Jun 2025 09:41:56 -0700 (PDT)
Received: from mail-ua1-f51.google.com (mail-ua1-f51.google.com. [209.85.222.51])
        by smtp.gmail.com with ESMTPSA id ada2fe7eead31-4e77391f3b4sm6808173137.14.2025.06.10.09.41.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 10 Jun 2025 09:41:55 -0700 (PDT)
Received: by mail-ua1-f51.google.com with SMTP id a1e0cc1a2514c-87ecdcab9ebso620868241.3;
        Tue, 10 Jun 2025 09:41:55 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCUI+8jpnveb+d09OdSEVuO0VNt1Oasl00sR+fvxQVpF17CjS2UWLTQt+Tct8pj+ZxXn3W4kNsaZD3ss0g==@vger.kernel.org, AJvYcCV/KI6Rb6buedoRmx5ChmV4BcEZd+cNpMQ0rk6Fmd7NCb6a/81rMrjzcbRgrourgyF1f5FHHtFxHVI7zf8=@vger.kernel.org
X-Received: by 2002:a05:6102:f94:b0:4e5:9d76:e8c8 with SMTP id
 ada2fe7eead31-4e7a8376abamr3151590137.18.1749573715334; Tue, 10 Jun 2025
 09:41:55 -0700 (PDT)
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250601151222.60ead71e7d8492a18c711a05@linux-foundation.org>
 <CAMuHMdU1NdNjx3f1V9j2FACWwC5faPKCXChtW6Z=i2JyXquFuA@mail.gmail.com> <20250610085416.062b4bc386dde2ea475369f5@linux-foundation.org>
In-Reply-To: <20250610085416.062b4bc386dde2ea475369f5@linux-foundation.org>
From: Geert Uytterhoeven <geert@linux-m68k.org>
Date: Tue, 10 Jun 2025 18:41:43 +0200
X-Gmail-Original-Message-ID: <CAMuHMdXyJhaFUbKX2Hhoa2y4hVK+0NhvL4hNL_8RnVOxaCkq=g@mail.gmail.com>
X-Gm-Features: AX0GCFv0TbEgZCHo1GFqBF_kwd_V8uamxZUJTDZCPQTyCqHp1Xe_Cfyn68uZtHA
Message-ID: <CAMuHMdXyJhaFUbKX2Hhoa2y4hVK+0NhvL4hNL_8RnVOxaCkq=g@mail.gmail.com>
Subject: Re: [GIT PULL] Additional MM updates for 6.16-rc1
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SeongJae Park <sj@kernel.org>, Honggyu Kim <honggyu.kim@sk.com>, 
	Linus Torvalds <torvalds@linux-foundation.org>, linux-mm@kvack.org, 
	mm-commits@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Hi Andrew,

On Tue, 10 Jun 2025 at 17:54, Andrew Morton <akpm@linux-foundation.org> wrote:
> On Tue, 10 Jun 2025 11:05:40 +0200 Geert Uytterhoeven <geert@linux-m68k.org> wrote:
> > On Mon, 2 Jun 2025 at 17:55, Andrew Morton <akpm@linux-foundation.org> wrote:
> > > - The 2 patch series "mm/damon: build-enable essential DAMON components
> > >   by default" from SeongJae Park reworks DAMON Kconfig to make it easier
> > >   to enable CONFIG_DAMON.
> >
> > ... or, make it harder to disable it?
> >
> > Given no single defconfig file in v6.15 enables CONFIG_DAMON, I find
> > it hard to believe defaulting DAMON to "y" is the right thing to do...
> > (Yes, I have read the rationale in commit 28615e6eed152f2f
> > ("mm/damon/Kconfig: enable CONFIG_DAMON by default")).
>
> So what do you recommend?  Editing all the defconfigs seems a bit lame.

Just revert the commit?
Distros are (usually) not using defconfig files anyway.
Thanks!

Gr{oetje,eeting}s,

                        Geert

-- 
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
