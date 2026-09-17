Received: from mail-ed1-f43.google.com (mail-ed1-f43.google.com [209.85.208.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4C2D4F93C0
	for <mm-commits@vger.kernel.org>; Thu, 17 Sep 2026 16:57:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.208.43
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789664260; cv=pass; b=Db7kRDPJEgEIoHZGq4od9DgLN1YPfDnMfZ+79S4pLPCUI3TgZOTCHJ81kzY9MSDD2vtnFqYxrTLoWU84czrapY+sQHkzyHkbcMJThzr25zEqV1lDsgYrCYgVjivkZaECCZEpbKn1xuG0pJH/DMjPkiFSm0ikwW1eAjN27w5F3Kg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789664260; c=relaxed/simple;
	bh=iNzpN1txXc1JHWNcoq+sEvXRNg6MC4FVypvY8t5sWBs=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=srM/ZbgHca1vn5Mn9uYqp/skv+NpQlMm/5kzjtGd02Hw8/yNNoCYmTlfZBGVAd1PinQ/0wJL22ZMBaPJEx9p21mBZQlQS5RJ3lccyNpyAoCQIxnHrrEByapeyq7Jo+Z1XmwFJXxiFTSmTwmA6k5dE+zOknXR9YOuKh14A8lQwTg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=sGpQDR8w; arc=pass smtp.client-ip=209.85.208.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="sGpQDR8w"
Received: by mail-ed1-f43.google.com with SMTP id 4fb4d7f45d1cf-6a5f95a879cso185a12.0
        for <mm-commits@vger.kernel.org>; Thu, 17 Sep 2026 09:57:38 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1789664257; cv=none;
        d=google.com; s=arc-20260327;
        b=iAbRmitYOqfOMEnwJ4iUgOPN2c+qbi2EKNEJaQ2BmhI7eyGoYXWw4AsLQ8wAoeGkWW
         GRMcJ98BDbSuD7y8gG8S6IxOzGUJQH1aSk/FAfq2ndOYpejyPZIEWujfiXJLOuz6akDw
         Eo9QCjkMkAe8Q3FSW0q0RO/HDaYpkZY449Xiz2A4KjDbwOnvTqrqJuGEnWhtBFC1dPw1
         AdP7NiwM8eqAJAUF7iCjFLM3WUF0fNrm/93QN7LmM3u2+gmx0JIOJS8huO404vbGizM3
         uryQp3haHpINMf7vU7YVlq9EevlQ6/79sLSHb37wmSWBIe9xKG+zfh3uFYxcLY9viaij
         8s9g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=2P1jqMeXt2U4DYONaAJvtCjY2qdlqYJMUv9Wm8If7S4=;
        fh=GYMuxFoe4nQHa9ePYaN0C2lYSJzDL9cuJdtWTD4lg+k=;
        b=nOybzmKqKpWSAQMN6+3aQSztNAM1scj9+8JTbbLjWa5K6yPBYs+ivzKglzAWY6mtmS
         216xJhXTc9+on/477TpEIa+5/u26b99HdAzSjaWRxjUwg78K/H1/xHFWD67FAViCLHq2
         KWOwm2d0mQ9toMd+Xa8iswUKg7mNh8diVSPqkPoEKq6HrhPaHQZUt1baoO9ZyyKSw/2/
         srX4QuhgR5h7PwzVGRmqIW4WdBlc+e2SD3YoaynfohLZ+WhhsQTrcH0LOWI6tMU6U6Sz
         iqErInC7BxMCsOSxToUiVQG/jyVVcuFIfmyJeaWXHFyKT6OwfgUYuB4+tZQBTtDiD6JU
         aI2g==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1789664257; x=1790269057; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=2P1jqMeXt2U4DYONaAJvtCjY2qdlqYJMUv9Wm8If7S4=;
        b=sGpQDR8w7msxHKa8j8BhV2wbC0mD16EScfJ9qRGvRGxY5wzmAKVPnIvi9bcvb2nQuT
         jtbf2ogsyfDH0qe6zXdMkWcLxAz9rjm0gohbVaw9F/423/vKTOqdAfup7WJuzOCpLvjs
         JpCFRNdi91X2CPrE5z0lICzsrknzJ2eV4G9+eJjJWIDw4X74k3a7fZBbg21ca67+rvaA
         z62KM3NnmT9pyH1g93wghOM7+aikmprJfJGzAJVcnCxhKzjUO0lUk2L80XGF77BOUF6Y
         qBmd/CncZ0kDT73CWwvuoxV/j6hDBPDZOFmO1Kv7O3wQN2CeFSYNzgjbM1KhE9lkz52N
         O1CQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789664257; x=1790269057;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=2P1jqMeXt2U4DYONaAJvtCjY2qdlqYJMUv9Wm8If7S4=;
        b=eYlLXdMU2447rwYCVhE8BCtlnupnV4/doj9tWYGbS7je34+0lUq2qhh4shynBZUqsi
         P/duQR48vY1Gj+yKtEkUdDwN8G5ebWaY7FmeJedRg7BQL2BJn3OwWBP+wFHtljM5qVSg
         TosVxi3g1t4FCwpkvlfwEKwuu1J/u1hb8JaIM3vE85ADk7XBl7UuISSuXwrMHBcp0vuo
         6FdQumAvCdFbROORV2grQBhfCaGoVB8lyIKMR3DYPwyUZooiriHJCTZUL4atMU70bFU5
         IxsalunQ5GSPSA1ajHnRKSdM2ZHc4PUXpAl2OuBnQFtGk65jFOKj7XzF1LUhovuczlLY
         KttA==
X-Forwarded-Encrypted: i=1; AKwUvBz5GCXrC5A6Bsv9cBUDh3HZFOCvNKVa+m/JTT8cL115s2ya+ejNKrNbKmWi3Ru9Tds+denzpNkio8IX@vger.kernel.org
X-Gm-Message-State: AFuF++lpSbdQyfyfjx9F9yzleA1qNun4bGVB0LBikj3Udd+aSvNyDcXJ
	ZmLLqW1ZRPOfW52dQvRa7iZeb+Xu6yCVoQVqBbRDbbq+1sy8jtXRrMl3ASCcnATyAz+Z+BPGm7R
	WDG5Hze3+6aW5GqlXgABTqBCZyXSkqQiHnQIs7J/8
X-Gm-Gg: AYBFou1pnH8NkW9e5rcHZ0wymcBq7JqBDGgRwzJDshAZLBjrnQf5UB2+Je9Fn3AH83r
	3irC11o8MgNnB8Gp2gs8vYvyHVgKm+olIZ4dFtE9E2blOdgqljgOtiTi1Le1tBZg9RsFcoxDkJ6
	91d6uM36RQ1+o329LHyKLitxSri7vY7naCO84R7VQqGpSWfVXbm/Tzkf/20wABL2+/1Op8jl4FH
	YiqtDbq6uBCpUAg4D+CMktDV8hdigFS+xX6e/cpYTT9sZ86z2nOWBpqHsN4O3t/fJ8asFYpUEvZ
	8WJ7dmENC0D1aSjJ/5L0QsOfnACkByfTKgMzzaVNxEm9BscxzbNxEfBMrM6L0ewObSG7NUv67cK
	g97lMKysMpnw=
X-Received: by 2002:a05:6402:c151:b0:6a9:ce23:5f4 with SMTP id
 4fb4d7f45d1cf-6aa48510e82mr21938a12.5.1789664256309; Thu, 17 Sep 2026
 09:57:36 -0700 (PDT)
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <202609171758.049ApqPm-lkp@intel.com> <20260917092237.5ba48bf16e8406e3753eacaf@linux-foundation.org>
In-Reply-To: <20260917092237.5ba48bf16e8406e3753eacaf@linux-foundation.org>
From: Suren Baghdasaryan <surenb@google.com>
Date: Thu, 17 Sep 2026 09:57:21 -0700
X-Gm-Features: AcwNN1U_1b5b73_yN2I2uC_S9n8-m7i3yxOik92aYxPTqmmXK_UGvDhMK1qoGRY
Message-ID: <CAJuCfpG+iqRwjHtH-ZjEpMxWaXkNDTurFjGQbgL4P3RK-3k5SQ@mail.gmail.com>
Subject: Re: [akpm-mm:mm-new] BUILD REGRESSION 892f5b3b07e5b07f2f29c87750ff94fa58dcab73
To: Andrew Morton <akpm@linux-foundation.org>
Cc: kernel test robot <lkp@intel.com>, David Hildenbrand <david@kernel.org>, 
	Linux Memory Management List <linux-mm@kvack.org>, mm-commits@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Sep 17, 2026 at 9:22=E2=80=AFAM Andrew Morton <akpm@linux-foundatio=
n.org> wrote:
>
> On Thu, 17 Sep 2026 18:00:02 +0800 kernel test robot <lkp@intel.com> wrot=
e:
>
> > tree/branch: https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.gi=
t mm-new
> > branch HEAD: 892f5b3b07e5b07f2f29c87750ff94fa58dcab73  mm/swap, PM: hib=
ernate: atomically replace hibernation pin
> >
> > Error/Warning (recently discovered and may have been fixed):
> >
> >     https://lore.kernel.org/oe-kbuild-all/202609171159.oaB1OaSG-lkp@int=
el.com
> >
> >     fs/proc/task_mmu.c:3448:3: error: call to undeclared function 'drop=
_rcu'; ISO C99 and later do not support implicit function declarations [-Wi=
mplicit-function-declaration]
> >     fs/proc/task_mmu.c:3450:3: error: call to undeclared function 'reac=
quire_rcu'; ISO C99 and later do not support implicit function declarations=
 [-Wimplicit-function-declaration]
>
> argh, we already fixed this five times.
>
> Confirmed with x86_64 and
> https://download.01.org/0day-ci/archive/20260917/202609171159.oaB1OaSG-lk=
p@intel.com/config
>
> Suren, I'll drop the series.  Please check this (and the 'lock_ctx_mm'
> defined but not used failure) when preparing the planned respin

Yep, I was planning to send the fixed series today anyway. Thanks!

>
>
