Received: from mail-ej1-f48.google.com (mail-ej1-f48.google.com [209.85.218.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9790518FDCF
	for <mm-commits@vger.kernel.org>; Mon, 17 Jun 2024 20:24:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718655844; cv=none; b=B1r4EXAFrfILI2uBuQ4YmNpjVxya7Ja1HIW0wSVdNJhYJw8QlznGPJ+bFTPuRT6uX/h+8vdex+npGfMt6Qss1/KiVtBIQSX1U/fZkPoB4pPNOlMvugJc1/n8Q+EB8Abou4fyV809MOt62DTV68JhOY2jtTk7pwwrT5getFzHmlM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718655844; c=relaxed/simple;
	bh=zkHuXWx8sTa/oNFKVsylABjyDEiMRGafzuDbOPJQ5wY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=objaOZEAi/FAT3BE/9Y8t9iEytgDvEemFx11sGn4P6yigu+yJJCRghMTN37Uvf/UZ13NC5bREWNFATmqRb0WlsjCmu9dcS4KcxBKLPIgYjWYdKIML1CrIwCMk2YptcSXG4cvkvFPRALumCw2xlqtyhUCckWuCA82dKJYyI70/w4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=E7UVGwuX; arc=none smtp.client-ip=209.85.218.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="E7UVGwuX"
Received: by mail-ej1-f48.google.com with SMTP id a640c23a62f3a-a62ef52e837so599316666b.3
        for <mm-commits@vger.kernel.org>; Mon, 17 Jun 2024 13:24:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1718655841; x=1719260641; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=htUQv2quqma4VO2V330/QazjqgtbFEOYp5UR9RkEEGk=;
        b=E7UVGwuXeO17nlxTabAgDSAmM1Zcsk3Kyqprvi04Pqvbav1VlEQZsg8OGAOrCoYVUk
         Ux94QgQ57NGMoaJQb2n/gTb39kq1psHfFgzxGrpV6C0VGdWPDRGi6+L1FB2ZUvF8QlOr
         GZWgMMgU1TJRyGlQQr+NGWcx6VT78faj1MIOg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718655841; x=1719260641;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=htUQv2quqma4VO2V330/QazjqgtbFEOYp5UR9RkEEGk=;
        b=dxxBrczEPqX3Whn9IW7ypgaGHqzS/zGPjzVtaTVwxeL2kSQO90oEu/qQ1KXuKK72c7
         e9wf5QvjmnnGl3Dz99L1S8ywODF0J7NsoPJholjKbeVZmbemDz4QRWZZQ4JjUw8pS7Kf
         Ggu+3nalC/DF8JtUJ8hCvL5nyRXh4niYMswFmiFyzQ065DpInWF5lniTcDV4E5r6BPIb
         JCll83+btgv1aBlZvb9oQhwimbTzas5Y59PaNauh6o/RFTH/3dUJRzZqAic3P0aSd0xr
         X8Yk3ErknfaM6y5lfTZXfbbtxdDcnQWHijoJ0CdEWf2A7ioURmrGkQvAZpbLK/CEk2Zn
         iS6A==
X-Forwarded-Encrypted: i=1; AJvYcCXLsLHVdWWnm7JsaJW5RWdfKiO11ca87BcCYx6/3PTd0ctbhdoN4d7x2MIKbEAMEt6xqv7fv0S1vJC2y7a95203H9y6JH63gITA+Q==
X-Gm-Message-State: AOJu0YxCLiU3ZYkupjPcvhLaVtl4U2Re4gNHo5cB7MfK/c1gdsNBv0qu
	EbOETH0kg/TMROWnwKeSUsEEGhvbkL1km9vWr9Ha+VMb3LZUcnpzoFmpauXUa1XksklYouDmWw6
	tSyBukg==
X-Google-Smtp-Source: AGHT+IEqRA0vGKmdYLAeCxSPzfTkE/Mfg9Fae4KgGQEfL0H0s3/3yznfoPMnnk4qm5SRHmhHkeeFlA==
X-Received: by 2002:a17:906:f105:b0:a6f:586b:6c2 with SMTP id a640c23a62f3a-a6f60dc4faemr688299066b.60.1718655840683;
        Mon, 17 Jun 2024 13:24:00 -0700 (PDT)
Received: from mail-ed1-f45.google.com (mail-ed1-f45.google.com. [209.85.208.45])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a6f56da3f41sm548381566b.33.2024.06.17.13.24.00
        for <mm-commits@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 17 Jun 2024 13:24:00 -0700 (PDT)
Received: by mail-ed1-f45.google.com with SMTP id 4fb4d7f45d1cf-57a30dbdb7fso8404373a12.3
        for <mm-commits@vger.kernel.org>; Mon, 17 Jun 2024 13:24:00 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCUkKbkFYd/Rbq/KRzQo5KQh7/vUjyvbLsQYVZKZGLDzsztqq5kRlZoP00WRlREN6RmHxv2XYJCHxA51nUxYbcpOLZ2BWj87jYCBsQ==
X-Received: by 2002:a50:f699:0:b0:57c:6afc:d2b0 with SMTP id
 4fb4d7f45d1cf-57cbd64969amr8464309a12.1.1718655839701; Mon, 17 Jun 2024
 13:23:59 -0700 (PDT)
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240617114712.45d4743f8bacb832dea4b5a9@linux-foundation.org>
 <CAHk-=wjiUzOHfHaWgUcByAygaG6w_BKOqbTN6EHrDHaXb_i+xA@mail.gmail.com> <ZnCZvOHqbp-itE_-@casper.infradead.org>
In-Reply-To: <ZnCZvOHqbp-itE_-@casper.infradead.org>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Mon, 17 Jun 2024 13:23:42 -0700
X-Gmail-Original-Message-ID: <CAHk-=wgEjJA7rNaDsmG_YUwr7Nw5BGP=tMaKK2=DPWm6r6hxKA@mail.gmail.com>
Message-ID: <CAHk-=wgEjJA7rNaDsmG_YUwr7Nw5BGP=tMaKK2=DPWm6r6hxKA@mail.gmail.com>
Subject: Re: [GIT PULL] hotfixes for 6.10-rc5
To: Matthew Wilcox <willy@infradead.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Rafael Aquini <aquini@redhat.com>, 
	Jiri Slaby <jirislaby@kernel.org>, Suren Baghdasaryan <surenb@google.com>, linux-mm@kvack.org, 
	mm-commits@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On Mon, 17 Jun 2024 at 13:17, Matthew Wilcox <willy@infradead.org> wrote:
>
> This patch wasn't even cc'd to linux-mm, so I never saw it.  I would
> have NAKed it based on this already being fixed.

I actually cc'd y ou partly because you were part of that earlier fix,
but also because of the implicit question:

  "So it's very possible that the

        if (IS_ENABLED(CONFIG_32BIT) || in_compat_syscall())
                return 0;

   test in __thp_get_unmapped_area() should be extended to take requested
   address randomization into account"

and whether we maybe could do better?

For x86-64, the default for min compat bits is 28 - which is
presumably plenty - but maybe we have issues elsewhere?

               Linus
