Received: from mail-lj1-f169.google.com (mail-lj1-f169.google.com [209.85.208.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E4E01DFEB
	for <mm-commits@vger.kernel.org>; Sun, 19 May 2024 15:33:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716132786; cv=none; b=Vv1THRhbdQF7TlogNYH8kVd7jS1AToBOa0pA7Uy/CpT3bLePKJKddZGocqVob75xMm8xS76oCP939aM1DxEzR3SK4TFCXsPyPoHz3T7w4LBzJKOttapc8vDrUdJxvm6zgiVbN227WcW6NB3AKMuPyMRX8Qtv08+aALvGNNuQE/I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716132786; c=relaxed/simple;
	bh=W1zr+c9KPmDePWUwRbBn2agwLQGITDaLC8ySFgxeN5E=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=CPX4lr/bnpXpMIdCxZSHe4l5KUBlcjM0ZhfuxoyEGnFVpT7KkP6t8aaXp4QcBaAN44QyG7TaJz+lsz16vwZFTkzt60m+U95/qVbPyYJqdo/5yZRq4V6kM5G8h0wi0X3FcSWfW6ICzWhDbQvZ6x+YRya7X4gBrkt96mSvQXy1teM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fr1q0gqS; arc=none smtp.client-ip=209.85.208.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fr1q0gqS"
Received: by mail-lj1-f169.google.com with SMTP id 38308e7fff4ca-2e428242a38so47430391fa.2
        for <mm-commits@vger.kernel.org>; Sun, 19 May 2024 08:33:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1716132782; x=1716737582; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=MDJiaiU5rkttwfgCtw/KvgAida8xU4nH18aWOxHr77A=;
        b=fr1q0gqSLreOjDw5XCyHdcGtGbhgQ9H0WGB3OXtweItSLgkwbNRBZOYfat145YIvjI
         U5oqMZhn4ElQKSXOmsPGDiYctdmOpIB9TFvHd+mf17y0l0JDHwgcwmk0Bpf+muYjiEBK
         0z7xmzo6Byy+aMQCyc71oxErMW6e2EvQmR35k=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1716132782; x=1716737582;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=MDJiaiU5rkttwfgCtw/KvgAida8xU4nH18aWOxHr77A=;
        b=CzICVFjhqM/4JSUkmPgT67Hk/74LyEMNrEPhQPDFAi9AjElKwhLtEF2iIh/lssLWHY
         tXH+E7z453YhLeVN7wq+NJMFxwV+6+v8j8qDUwjEa+hE8WHTQXUGUUm2LHiuZU76+3kg
         VaqijlkoWz5fZHaKBX7yE91+PEry3Q5AemR2peYCfppbdHOUy/Ytkw8qC6LZy1YEHisl
         j1r6jR+E4g5Vs36PxsdL4gXYTbpnkTS5MuusgsO+jjsvrgHvkhr7EX6G9nFNQizHgBpK
         mQWMp/YRF+sQkRF4mLQi35Y0ASOB5q4+JUkl6sIYv6YYRz77tgNZz3HJ+eBImguOI/xE
         VkUg==
X-Forwarded-Encrypted: i=1; AJvYcCVEyz6fILm39l92CkJP1O8E3+fGGGkReE/Z+y/UD5IjuvwXzWW1LIRgTd4zJJu8H574RxPpkpx4ZOfaKxQ7Jsig85mnvrJ9w9FOvQ==
X-Gm-Message-State: AOJu0YzXFBIdaycVTum16LHxT0uUKeFpTeSLjMLLGHES20gRbeD2GMsg
	TuF+zYSwmYbcnAUtDmJcAGINgIOENHEfb2tREo+k/hvqsazj2hWmO/VEBwpGQ5Ih/NPO4QnRCJ5
	DIUUI5A==
X-Google-Smtp-Source: AGHT+IH3iKRtoaJ6DdhhCmBooGApowhKvkTRjEvpuTIHp6WN04uKFAzpONTjJpI80hJ2pwTUZ98A+A==
X-Received: by 2002:a05:651c:149:b0:2e2:9842:a9d3 with SMTP id 38308e7fff4ca-2e52039dc3emr219772521fa.46.1716132782049;
        Sun, 19 May 2024 08:33:02 -0700 (PDT)
Received: from mail-lf1-f54.google.com (mail-lf1-f54.google.com. [209.85.167.54])
        by smtp.gmail.com with ESMTPSA id 38308e7fff4ca-2e4d162005bsm31144091fa.113.2024.05.19.08.33.01
        for <mm-commits@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 19 May 2024 08:33:01 -0700 (PDT)
Received: by mail-lf1-f54.google.com with SMTP id 2adb3069b0e04-51fdc9af005so4093223e87.3
        for <mm-commits@vger.kernel.org>; Sun, 19 May 2024 08:33:01 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCXkXV06Xl0IePkP0B0tw34KETPFNZwQnc0i88kff/5nkjIjlCe05FHkuv73VFqhdOZy/s/oejD/NcnNotaZCsxNvCJ9Z8Xpi/9gGw==
X-Received: by 2002:a05:6512:444:b0:51f:3e0c:ace3 with SMTP id
 2adb3069b0e04-5220fd7c6bdmr22793661e87.16.1716132780601; Sun, 19 May 2024
 08:33:00 -0700 (PDT)
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240517192239.9285edd85f8ef893bb508a61@linux-foundation.org>
In-Reply-To: <20240517192239.9285edd85f8ef893bb508a61@linux-foundation.org>
From: Linus Torvalds <torvalds@linuxfoundation.org>
Date: Sun, 19 May 2024 08:32:44 -0700
X-Gmail-Original-Message-ID: <CAHk-=whEAquncw0wb59-XVAHmVh4CWSfwuWh4bTJjJzvx0=PzQ@mail.gmail.com>
Message-ID: <CAHk-=whEAquncw0wb59-XVAHmVh4CWSfwuWh4bTJjJzvx0=PzQ@mail.gmail.com>
Subject: Re: [GIT PULL] MM updates for 6.10-rc1
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org, mm-commits@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On Fri, 17 May 2024 at 19:22, Andrew Morton <akpm@linux-foundation.org> wrote:
>
> include/linux/slab.h
>         https://lkml.kernel.org/r/20240429114302.7af809e8@canb.auug.org.au

This is not only a merge conflict, your tree is actively buggy.

You have introduced changes like this:

  -static inline __alloc_size(1, 2) void *kvcalloc(size_t n, size_t
size, gfp_t flags)
  -{
  - return kvmalloc_array(n, size, flags | __GFP_ZERO);
  -}
  +#define kvcalloc(_n, _size, _flags) kvmalloc_array(_n, _size,
_flags|__GFP_ZERO)

and that's just completely wrong. Note the "_flags|__GFP_ZERO": yes,
the bitwise or is fairly low down in the operator precedence rules,
and it probably work sin practice because most cases will just pass in
a simple expression for the flags, but it's still *horribly* wrong.

I'm going to take this pull and fix up the cases I find, but I'm not
happy with this kind of trivial C preprocessor misuse.

I also note that you have *SEVEN* pointless merges that have no
explanation for them. I'm happy that you use git, but that means that
you also need to either

 (a) not do merges at all and treat it as a patch queue

 (b) do merges _properly_ and not throw them around like some madman

And doing them properly means not only writing good commit messages,
but actually having good reasons for them. As it is, we have

  5d1bc760583f ("merge mm-hotfixes-stable into mm-nonmm-stable to pick
up needed changes")
  640958fde130 ("Merge branch 'master' into mm-stable")
  4e2e36129225 ("Merge branch 'master' into mm-stable")
  1dd4505cf4c8 ("Merge branch 'master' into mm-stable")
  71919308943d ("Merge branch 'master' into mm-stable")
  b228ab57e51b ("Merge branch 'master' into mm-stable")
  5e2806112864 ("Merge branch 'master' into mm-stable")

and those one-liners are all the explanation there are for the merges,
and NONE OF THOSE MERGES ARE VALID IN THE FIRST PLACE!

They shouldn't have been merges! You literally have no new code on the
other side. You should have just fast-forwarded to the new state,
since your side didn't contain anything relevant any more.

So the merges are doubly wrong. They have no explanation, but part of
the reason that they have no explanation is probably exactly the fact
that there *IS* no explanation for them.

There is one fundamental rule of merges: if you can't explain why
you'd need to merge, DON'T DO IT.

There are lots of smaller rules too. See

    Documentation/maintainer/rebasing-and-merging.rst

for at least some of them.

                 Linus

          Linus
