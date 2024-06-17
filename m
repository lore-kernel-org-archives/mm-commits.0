Received: from mail-lf1-f42.google.com (mail-lf1-f42.google.com [209.85.167.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ACD6218F2DD
	for <mm-commits@vger.kernel.org>; Mon, 17 Jun 2024 20:09:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718654986; cv=none; b=b5WaN37MQ/vuNZopPLM6sLu+JNYPQ7ktgAjOo8Cu/gJorHq2WE4JJ+DtyWymzKZ+HsrpQUCwqMzFZW2ZwjImmpubnAHir2ADO5Z8rXS7cyizNqLPKEtgv2tQTnAhikJTtmRHvDbj0sEUHu/ihQapXoH5S/X6M/qUgIDtVJQOsU0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718654986; c=relaxed/simple;
	bh=lMOHT9AzaSNEukALssulLQMHUV6v697K4yD8C4n+Ca0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=FT5OYP2edBMuzriELgHCbZlmz5Xc5yj0qkoRrHtGgYYLSoQOR0nljnusGcebRYhLRarphUcKQQipFtILN8FwQAXPb4okNxywSAiZhcxIyhCHkDflx0KDqBQOXkqrMO2SBRkonNLAHoQ4O87JzFU6lU2S/j11aXJcZ4lzKrjQ0A8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ShLEzPPK; arc=none smtp.client-ip=209.85.167.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ShLEzPPK"
Received: by mail-lf1-f42.google.com with SMTP id 2adb3069b0e04-52bc27cfb14so5930294e87.0
        for <mm-commits@vger.kernel.org>; Mon, 17 Jun 2024 13:09:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1718654983; x=1719259783; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=32irAGR56mVNB9UGYg2c/DMgiXDqjQ+y0dbB2T9WACs=;
        b=ShLEzPPKEtHAou6ivJtsfQR3B07UIIet5ec5PX0atO4aD9/zoFM5rFXN5O0uype2cB
         +bkUEFd8LIQwYHuQm4OUBs43GTLJiCgYHST7/c6NFHgmJG4EiLIl8cY4QApXSg0oBiWY
         4rZFVLXhBS0/SeDx5kZd1MY3WwNsTo+TXd6lo=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718654983; x=1719259783;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=32irAGR56mVNB9UGYg2c/DMgiXDqjQ+y0dbB2T9WACs=;
        b=six4wJi0lg9rigMNHsQ+Poc5h1XetyvSiHcFKAst0vy9CTY/PiF8x+s/iV4xmThuI4
         5oU1w+QrB25TmLUuy2yS/0reE6am16DO/BUVkejk5Lsond4J1uR680lFqTEbk0TMs+O2
         bE+gv0woozco8cMcaipT7vYR/tImeas6yMptqBfLs6o0Qm8m3jD1JUjGMDEfYSivX99k
         C9HU9dY6QS0fv0qWExgHdDLXxVk91EQ5Xl9uc0CUHQ+Rqn/r1+9lHNUtN26oODcl5Eq8
         xEpO/ZEqPIon1VCNUQTv7pi6mEN68RsZ4mZh9OiLtfCpZjTKkCV2ArEBdiC4FRkFMtF6
         JeQA==
X-Forwarded-Encrypted: i=1; AJvYcCVVpoae23zLRkUryrLd9ovyAv4skYodGGnJgRwpj3+aBJjpsBH/ux1ICNYX49Rcz5JD9QV/hWlhckWN0drsK3hXxgbrsKHRPq6Ejw==
X-Gm-Message-State: AOJu0YzfEwx0mTeKQ/+d1s43n3XW7UwA1Mz0OG/pKoFBuSuk8dqEbYMu
	KInYnDrI4mdzNUOi9T16j6omNTr4G7wQrNzMvcW3B0qEf6IhwzPo3fhdL9pijo3vBfdF3quvJm4
	g8QSyPA==
X-Google-Smtp-Source: AGHT+IF4MAy1hFseUlFTl5dd/7xF5n7SW9dkHFq41UkVWB9NgJK87NLKeo9/IsKtkd6EzRhhcvz5+Q==
X-Received: by 2002:a05:6512:3f27:b0:52c:9ae0:beed with SMTP id 2adb3069b0e04-52ca6e92a3cmr10275361e87.52.1718654982779;
        Mon, 17 Jun 2024 13:09:42 -0700 (PDT)
Received: from mail-ej1-f48.google.com (mail-ej1-f48.google.com. [209.85.218.48])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a6f681ae61fsm418466866b.99.2024.06.17.13.09.41
        for <mm-commits@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 17 Jun 2024 13:09:41 -0700 (PDT)
Received: by mail-ej1-f48.google.com with SMTP id a640c23a62f3a-a6f51660223so280983566b.0
        for <mm-commits@vger.kernel.org>; Mon, 17 Jun 2024 13:09:41 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCXqdt6XSfw9yizBPac2eFmgcKX9vE8+lJnplGPw+3bKcngU+572oWHe+onFre0LwU5LodMVYe3Fg/f58doz0Rb+TqrPTUuwZZ6ycg==
X-Received: by 2002:a50:9e85:0:b0:57c:6031:8ebf with SMTP id
 4fb4d7f45d1cf-57cbd6c74c8mr7654997a12.31.1718654981431; Mon, 17 Jun 2024
 13:09:41 -0700 (PDT)
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240617114712.45d4743f8bacb832dea4b5a9@linux-foundation.org>
In-Reply-To: <20240617114712.45d4743f8bacb832dea4b5a9@linux-foundation.org>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Mon, 17 Jun 2024 13:09:15 -0700
X-Gmail-Original-Message-ID: <CAHk-=wjiUzOHfHaWgUcByAygaG6w_BKOqbTN6EHrDHaXb_i+xA@mail.gmail.com>
Message-ID: <CAHk-=wjiUzOHfHaWgUcByAygaG6w_BKOqbTN6EHrDHaXb_i+xA@mail.gmail.com>
Subject: Re: [GIT PULL] hotfixes for 6.10-rc5
To: Andrew Morton <akpm@linux-foundation.org>, Matthew Wilcox <willy@infradead.org>, 
	Rafael Aquini <aquini@redhat.com>, Jiri Slaby <jirislaby@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>
Cc: linux-mm@kvack.org, mm-commits@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On Mon, 17 Jun 2024 at 11:47, Andrew Morton <akpm@linux-foundation.org> wrote:
>
> Rafael Aquini (1):
>       mm: mmap: allow for the maximum number of bits for randomizing mmap_base by default

No.

And HELL NO!

We're not adding *another* new random incomprehensible config option
that tries to fix a random case that no normal user will understand.

Our kernel config is too damn complex as-is. We're not making it worse
like this. Anybody who cares about this kind of crazy esoteric detail
can damn well just set their Kconfig manually, instead of forcing this
kind of insane questions on other people.

This Kconfig insanity needs to stop. Why do I need to be the person who says

  "STOP ASKING POOR USERS IDIOTIC QUESTIONS THAT THEY CAN'T SANELY ANSWER"

I've pulled, but I'm reverting this commit. We are *not* going down
this path of insanity.

I'd also like to note that the reported 32-bit issue was ALREADY FIXED
months ago by commit 4ef9ad19e176 ("mm: huge_memory: don't force huge
page alignment on 32 bit")

It's possible that we should extend that - much saner - fix to also
look at the number of bits for randomization even outside of 32-bit
processes, and judge things on the number of bits we're expected to
randomize mappings on.

So it's very possible that the

        if (IS_ENABLED(CONFIG_32BIT) || in_compat_syscall())
                return 0;

test in __thp_get_unmapped_area() should be extended to take requested
address randomization into account.

But there is NO WAY this is fixed with another completely
incomprehensible Kconfig option.

So I'm really unhappy about this. The whole "add idiotic random
Kconfig options" needs to stop.

Those options are not something a normal person can understand, and as
shown by the fact that this patch was already bogus and superseded by
a much better patch from months ago, clearly said Kconfig options
WEREN'T EVEN UNDERSTOOD BY VM MAINTAINERS!

Christ. Sorry for the shouting, but dammit, people need to really
internalize the whole "we don't add crazy Kconfig options".

                    Linus
