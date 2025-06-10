Received: from mail-vs1-f51.google.com (mail-vs1-f51.google.com [209.85.217.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B8DA1A8401;
	Tue, 10 Jun 2025 09:05:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.217.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749546358; cv=none; b=oR1Lsr2IiHf+BCOWulLy36o/2juHSXGpnLNfd9VT+kQVwoqFVIyruKD/Ng14H1/dddQKg3oCb5uqN7jt6As9jMRHuHvEhqoohELbh7suVt/CzDtubSRCmAk1Ng+tMywmaYc7nt1z/j9LK5OiN/bAhPozy5u/4ynTmy1KPpNpaU4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749546358; c=relaxed/simple;
	bh=68wNvFFW9QHKsYo8UNhuUNCZ216A1R6QggbTAdxOA7o=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=soUU9/jXl9AbmiY5xjSSCcngrhC1eh91uFmyh+/33MBsMFkhdCC1BR/NIZiQzywtYbgKAlGLFqy39LIQpIgAuzqGyCyAifa5Arwafeop4awxTkLhLXA5mGpJZLIF6AWEBndVbNCk+lnWZM832WHKqqrv6idlKWbj4hh8l/g7JjI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-m68k.org; spf=pass smtp.mailfrom=gmail.com; arc=none smtp.client-ip=209.85.217.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-m68k.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-vs1-f51.google.com with SMTP id ada2fe7eead31-4e5a73028d2so1671833137.0;
        Tue, 10 Jun 2025 02:05:54 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749546353; x=1750151153;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=jd2GJlECAu20oBTXGZhQXIVoTDAJCGdRowATqi2S6DU=;
        b=JC/nm/KIzYgcw/H1ZDKWcP3UGwyVdPTS+MpKu6BZ8Ff7wUfFcCwF5NAdaJQO8QAEVp
         A1czZ/KlL0Kt4wDLhYF7+y7Cu6Fi1Q2JRy2btpIX05is7zd49qInfu8S/yS8VnzZuOH+
         i4qIC8UFrc0mEHlqtxguicqn/NITiYuCajbcn/tUGTwpE6ZePT6ZPrOs3WbR2gmQrMVf
         yl0rHOclN22bWHg1C/kfPXNh2dBi0YRf15ZiMrAqt37vDldcWynEXUIUrOHzTTRFkieC
         /iNMYSTrdCumBkY/nfw1TkM5AikcsYmoFvlSfWnHDDu9ha4ztISfeSSpwpej06yX+7sk
         hITw==
X-Forwarded-Encrypted: i=1; AJvYcCUBhXfh8lTS+aNV3PEb6FvU6NhhbCgHifu6S/KJ5RdMJ3lox1ZrS2eLIGO9XwcFSoDqliCT0aWZUGFfTg==@vger.kernel.org, AJvYcCXezN8fhdchwH9wmK9KRkWpC1aRhrGkZB3zAy8GBOyqbqahNNZvGXx5qNEJ3dfG2z8j5xFgXQ3e4GrfBFg=@vger.kernel.org
X-Gm-Message-State: AOJu0YzmPZ/Dy1Sa2enAxO0Bd6RjdfBZ9NABpoJ8IhfhaIgm3Ov2c38q
	AYRCcW2/OucvwfM22J0/oXwrZMuySgqDs3X6jRQNoy1744CyUuOizSlX6iyAGkv7
X-Gm-Gg: ASbGnctINE1XVpmPfQOuaK4RfrRbA/Y5mtyTws+BcjZPfaDoRfD1nWVqzCVAeWg4S0r
	txKl1dfQQk9vAencxqT9TLKKhbL14U6yPIECenoyS8dWHqdaslzwdbPGVUIW3kDEjbZMo0emeP0
	n4E9aoJmcdPEiFUBkdp+fdvG9EwrAJc0GsqQj8qPUqkgoLSYSJsD1oSa2Ewttw+QktFLKARF9dr
	MAad2j+Pn/0awdvHYUbgSy77Bw2p9jWGJPaQ39JA3l3Nds4U9TZ5V1wnW/duvoYmnW2D7oGs2Qv
	PFjkGGK3Zmslsq5pI3LodFJUZ9HrBUi+CV2mMmYD0SlZuQRyRhi3gb+kX890YDX3czATGtEZ+w9
	eDOF6ZM5xvre1jaFlmMbNsTkU
X-Google-Smtp-Source: AGHT+IG6vqh7MhRYY2VnSQpd0CwGTXM+O9XMojSy/BkVHkpBhXQl/oER/Onlo/rTxagSwhRcdIhLhQ==
X-Received: by 2002:a05:6102:3e8f:b0:4e7:596e:ec10 with SMTP id ada2fe7eead31-4e772880fd9mr12695071137.1.1749546353051;
        Tue, 10 Jun 2025 02:05:53 -0700 (PDT)
Received: from mail-vs1-f51.google.com (mail-vs1-f51.google.com. [209.85.217.51])
        by smtp.gmail.com with ESMTPSA id a1e0cc1a2514c-87eeae8791esm873901241.15.2025.06.10.02.05.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 10 Jun 2025 02:05:52 -0700 (PDT)
Received: by mail-vs1-f51.google.com with SMTP id ada2fe7eead31-4e75abe99b7so1746495137.3;
        Tue, 10 Jun 2025 02:05:52 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCXheH9l4TLI9hdsMGaO4K/5+W2u++LQWHT/S1kZlnzOxj99aVQ30SYy0NSfXwSCWGb35QDey5yjNHNkrVw=@vger.kernel.org, AJvYcCXrfg7Nt8T6wUd2amK7NY0GNzVnZkRv+1DzUO9CdaXTiMoDH3D++JqBMDCo8YSPCsf1vjXOKZLyrbQ0EQ==@vger.kernel.org
X-Received: by 2002:a05:6102:3ed0:b0:4e5:a394:16cb with SMTP id
 ada2fe7eead31-4e7728ba4d0mr12079543137.7.1749546352494; Tue, 10 Jun 2025
 02:05:52 -0700 (PDT)
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250601151222.60ead71e7d8492a18c711a05@linux-foundation.org>
In-Reply-To: <20250601151222.60ead71e7d8492a18c711a05@linux-foundation.org>
From: Geert Uytterhoeven <geert@linux-m68k.org>
Date: Tue, 10 Jun 2025 11:05:40 +0200
X-Gmail-Original-Message-ID: <CAMuHMdU1NdNjx3f1V9j2FACWwC5faPKCXChtW6Z=i2JyXquFuA@mail.gmail.com>
X-Gm-Features: AX0GCFt1LL46Kri618f12QZQvjS1xahyg5UAuM3XvWnCqEwLP37r2X4sb5UOSYY
Message-ID: <CAMuHMdU1NdNjx3f1V9j2FACWwC5faPKCXChtW6Z=i2JyXquFuA@mail.gmail.com>
Subject: Re: [GIT PULL] Additional MM updates for 6.16-rc1
To: Andrew Morton <akpm@linux-foundation.org>, SeongJae Park <sj@kernel.org>, 
	Honggyu Kim <honggyu.kim@sk.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, linux-mm@kvack.org, 
	mm-commits@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Hi Andrew et al,

On Mon, 2 Jun 2025 at 17:55, Andrew Morton <akpm@linux-foundation.org> wrote:
> - The 2 patch series "mm/damon: build-enable essential DAMON components
>   by default" from SeongJae Park reworks DAMON Kconfig to make it easier
>   to enable CONFIG_DAMON.

... or, make it harder to disable it?

Given no single defconfig file in v6.15 enables CONFIG_DAMON, I find
it hard to believe defaulting DAMON to "y" is the right thing to do...
(Yes, I have read the rationale in commit 28615e6eed152f2f
("mm/damon/Kconfig: enable CONFIG_DAMON by default")).

Thanks!

Gr{oetje,eeting}s,

                        Geert


--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
