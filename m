Received: from mail-ed1-f42.google.com (mail-ed1-f42.google.com [209.85.208.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC383282F1E
	for <mm-commits@vger.kernel.org>; Fri, 21 Aug 2026 02:05:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787277922; cv=none; b=HipdKZ4DGxd9CUCqLoA4Q6S3hnFu2hH5m/zvUNmFFlztaaQ7zqEszdepSbKr1dWYmi85mRBvx3suxRfFok5YHUa/bgSwzqarLPsr3uFqBPyuYU77/DkM89aCbby/kcwRO0ATCAB9g2KNGKBQQxTyO0qJ8jQSead4vkOW8XqOJS4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787277922; c=relaxed/simple;
	bh=VkDIFxnNcvfI7Vu1l9huOaU+ZFOxKvBssjpg/dMffUM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=bP7B8Zg4Ov/CsMAdfh7k8NZq0sUq3lWCiuBUyjPYAo2QFXRkplCdMoPeaLZzcobRlXe4cHVNdzE8UfBBLTZ5iohYXutnusFqHUHt5eouvTNKara+BFPjQxvqgKCcpP8BdUDUiV+T+5zYNSvPVmiCF9yXqVi3+Cd/PKo7w4kHxzw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Ndsk8F6j; arc=none smtp.client-ip=209.85.208.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Ndsk8F6j"
Received: by mail-ed1-f42.google.com with SMTP id 4fb4d7f45d1cf-6a41191c9a9so1193648a12.3
        for <mm-commits@vger.kernel.org>; Thu, 20 Aug 2026 19:05:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1787277918; x=1787882718; darn=vger.kernel.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=ilqWqTcp2QIIegN8Wykudvyua68HMB1s5p79u7p9ot0=;
        b=Ndsk8F6jonJ6bGTmIfR1aWY+7mCaSL1bxqWHrWVez3LHle0NgZ7RodsSMnuotCM0XO
         OXW3gp287aLQikRtPV/izppq08FiH6hy/FJFozSVZ4GAZxJPdEbdbCuRXD2w/NtMnzCV
         PZdQLKBd9Lz/f46uRS0ikoZTbo4hAWBK4lCu0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787277918; x=1787882718;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=ilqWqTcp2QIIegN8Wykudvyua68HMB1s5p79u7p9ot0=;
        b=LRqFqIxetzIKoI8TzjFb3kr5aNfK0zZpC/a1mfLHde9jfL7ZDuOKqu8yeZwEf4ZSK8
         tSltNZGz9zET3L2egRX/pOc/9AylGyCt1ldGH6mTwnwAxlyzuJ1P99J1PLABhtAR5vZq
         3/4cUk1HBzaASoPx0ON8FCJyx4sUwvOURZZjzUCWwg1D3behzJkLFsbIsIb4/KNP4bxH
         f45IcOddbk8nKbEx1GAkceXnx8fs5+YZ5c9LGqQhohOnArgJ0GPQ9kQRkhhfCWqPrf5/
         bcplZW3+Fo4b1MVB1F+NPZlPcqJQcolaLnbQdZAJ/GsC4dAKEH9mbAb1Grx3anRldm75
         o4zg==
X-Forwarded-Encrypted: i=1; AHgh+Rp2U+lkpwazzTMieA3H0GSIogDqj4bxQflWw2/F+Nzw6hjOm+7xGWd2sLJbBOqkufNPyaUrGimTiYL3@vger.kernel.org
X-Gm-Message-State: AFuF++lc3/ZLip0n5iWoQ/W0B9OJaFAe4BOmZ/BzFG7KA3fRP1USnQIm
	RsgJST5dL3dCNa7HX7LnrUpINka7+DVg9DoRHt4DyGBpPylNgmD4OqxnwMMZaSJLyTaHwTg90wU
	wChp9MYa9dA==
X-Gm-Gg: AR+sD10rtGsTaBlPYf55nPuGgzuwDtyZtxq5uR6tpQTLHHRQUDfAG9wGU4X8DXKh3LC
	MXL2aJWRHw5eDTLM49qZrK/yHGjmLEzKKQuDOrpijc6ZZckyprpXvX8cBw2gEsDRrMJmtky88HS
	yIwWDtgy6N+noDQFsulrPmyIg7eStQthu3xFZJueacnsfeEKU9GkLQqhYFcZzkx0bDNtQcZa0/T
	EZlX7qSr+eTorwJyYPd2dVSIP1oI5MiBy4nTUzy57l46jsgEim3F5ET0n8ZE/B2eWVh8Hrl+Cu1
	ohUkoypUVEFTaSUiyUlyWhWBE227CURd9eFHzB797JwnbzvXgHrMvNKXUyjnOzdkIaZhgaz2NIc
	JPSfWG0NtLuiiGqbzcqF0kSJ0fCmtp24PaTcXFZp+U3olujhC1RosvvVcm1rBCWM5oO7LuC5jM8
	Bz2h+D4VuqECb4aE6b4X5hbHiOiLKa1abIFd0NSpA3bUiX9dnoH1MApXsQm5+O24k6km7/fk31G
	MSLlNmioIILFOiwfuoMx742plQpqoNEtijMdQ==
X-Received: by 2002:a05:6402:a0cd:b0:698:ac8a:9a21 with SMTP id 4fb4d7f45d1cf-6a42f185778mr2728038a12.8.1787277918127;
        Thu, 20 Aug 2026 19:05:18 -0700 (PDT)
Received: from mail-ed1-f41.google.com (mail-ed1-f41.google.com. [209.85.208.41])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-6a3ff1563c5sm4086264a12.14.2026.08.20.19.05.17
        for <mm-commits@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 20 Aug 2026 19:05:17 -0700 (PDT)
Received: by mail-ed1-f41.google.com with SMTP id 4fb4d7f45d1cf-6a374bea882so1154269a12.1
        for <mm-commits@vger.kernel.org>; Thu, 20 Aug 2026 19:05:17 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AHgh+RrCwBlMJk2MbwwV044V6b85+LW/qH7XUfHSZYwnT64kH/64lMpOo2yCa8mY2Pzf1soPX0JbMwV2EgGx@vger.kernel.org
X-Received: by 2002:a05:6402:24c4:b0:698:ecf:d18a with SMTP id
 4fb4d7f45d1cf-6a42f1be3d5mr2627931a12.9.1787277917155; Thu, 20 Aug 2026
 19:05:17 -0700 (PDT)
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260818220711.d5d577cb135b213ae11549c9@linux-foundation.org>
In-Reply-To: <20260818220711.d5d577cb135b213ae11549c9@linux-foundation.org>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 20 Aug 2026 19:04:59 -0700
X-Gmail-Original-Message-ID: <CAHk-=wipdFaYVXO6egyacqXiTfUEQWjqsOSjxjbhZ0FK_MjRTA@mail.gmail.com>
X-Gm-Features: AcwNN1Vv4YswxSOrIw8YhWVa3VKcmfREmzL5hnmqA7uUN5u66DG9Dsgsk0KbPg4
Message-ID: <CAHk-=wipdFaYVXO6egyacqXiTfUEQWjqsOSjxjbhZ0FK_MjRTA@mail.gmail.com>
Subject: Re: [GIT PULL] MM updates for 7.3-rc1
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org, mm-commits@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On Tue, 18 Aug 2026 at 22:07, Andrew Morton <akpm@linux-foundation.org> wrote:
>
> I don't enjoy typing up those patch series summaries, so I haven't been
> doing them well.  This time I recruited Gemini to draft many of the
> bullets and then I did a review/edit pass.  I think the result is
> better(?).

So I fixed up some stuff. I suspect you did the same thing last merge
window too, it had a similar feel to it.

And I detest the silly use of present tense prose for bug fixes etc
("Do ABC, fixing X").

Or the unnecessary use of filler words.

Or saying "This 5 patch series".

Things like that should not matter in a merge message.

You say what changed or what was fixed, not "Five patches to doing ABC
fixing XYZ".

If somebody cares about there being five patches, they'd be looking
at the patches themselves. The merge message should be about
higher-level concepts.

(Or - and if people really care about the delineation of patch series
- maybe it should be visible in the *history* with explicit
no-fastforward merges around the individual series)

I didn't do a *lot* of editing, but let's take a entirely random example:

 - The 2 patch series "selftests/damon: fix memcg_path staging handling"
   from Cheng Nie fixes a bug in _damon_sysfs.py for damos_filter
   memcg_path setup, and adds a test case for it in sysfs.py.

and I edited it to state the basics without present tense:

 - "selftests/damon: fix memcg_path staging handling" (Cheng Nie)

   Fix a bug in _damon_sysfs.py for damos_filter memcg_path setup, and
   add a test case for it in sysfs.py.

iow, straight and to the point. Not "Patch X optimizes abc", just "Optimize abc"

But I guess it's a matter of taste. But if you use Gemini, you could
try to tell it to not use filler words, and use imperative mood. Don't
say "So-and-so did X, fixing Y", just state what was done.

             Linus
