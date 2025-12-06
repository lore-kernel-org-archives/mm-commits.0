Received: from mail-ej1-f44.google.com (mail-ej1-f44.google.com [209.85.218.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E2C01E86E
	for <mm-commits@vger.kernel.org>; Sat,  6 Dec 2025 03:44:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764992654; cv=none; b=LjCZJfLjqEDXFXyu3y74aeVaw0kXJPd/Jt9Q7pjrwc0tRyf3qutrKH+ejuOjY316EBrGSKTmjHp5Ur+cm1ToMMlzT12Gs6wesgC8ehXDSuwSHIgcXwBmXJ+vLzq71rI/loF0ZbZQM7vR6O2xZ29gV76KjFF9UUWdUnOhorWA/lY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764992654; c=relaxed/simple;
	bh=WN2dAGwIlN2QpswGvylYdKYxYU2u+uZRo++Fn2WGTrQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=E1DU5fPpGekJFG4A0MkptuXIzbfbY0jvJrf6qlCVhDs2IGrz8nSK6PXraZwtQYHKGX0jgEPB+jprET4STPw0aNkBPrkqNQmITfzbpODFssqDRJAZUifWqz2dOlhJ3sH+L2oymzdKxive21Sz6NcI8hsaaudCwRj1vPWqSuqgcz4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=fwXAXLjl; arc=none smtp.client-ip=209.85.218.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="fwXAXLjl"
Received: by mail-ej1-f44.google.com with SMTP id a640c23a62f3a-b7636c96b9aso371988266b.2
        for <mm-commits@vger.kernel.org>; Fri, 05 Dec 2025 19:44:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1764992650; x=1765597450; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=B5yKXImvbgtz2yovFNQUHLcbnuea9LQbWcCyrFf1PMk=;
        b=fwXAXLjld14G8t1XnGWPOJBxwXPE7eKShk0WJRsz341Tfy24jtuJmNvqTlMtIxdEZw
         gbxHCNHvlAZpl/lu2rPUUpIkS1MLrwbo7iL9+wqJQm8NABcN84ROT5ADWy22WlLJSbLW
         XEZmO2aDoLZyshLqYgiNOY701wEtl7gbDmU80=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764992650; x=1765597450;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=B5yKXImvbgtz2yovFNQUHLcbnuea9LQbWcCyrFf1PMk=;
        b=f4eEQc3i5d4Z7WpAeWrvEWJl+XT2q9qFdB2/4g4ZV9DNPqUFdYtTLWIvyqJ4dMk/9g
         aii3toEWSQgqoZD5xx8bGtVvxfX9S3kqBWqek2IjcAaB8jtoHXiby3KW/f/P6VBBbH+/
         jlNIlcVTRBVuzbBVmEnHr/lMuqXPMKrA9PqyEyNQmkwP4QKQXxJ0bAlz4kx2bqVTs7hA
         XKkK0Wv9Tmpm74UFk7xLbdjiZrVFZZvkgG7ZpCZ1hoe/K3QAuRMXY4UzElehKsWRbiha
         ZYnIb+bvwPUH2yQdLSz/kUWfDvw59NTPpPjs+VMSygj18p+LoaFSHQEaZA0xQyBy6PNH
         cpVw==
X-Forwarded-Encrypted: i=1; AJvYcCVwaGq53ckrtR82ZFODjioGRIajAgEN2gHwd7GDKm4zGslwE8ozmMSIMcswdEtwyqo8IwJeznEXapNj@vger.kernel.org
X-Gm-Message-State: AOJu0Ywqg4w7czhaxNeTPc8xwOXUty/rfjZXA+JGjZFHXNkuMXwY9Q0Z
	512df/DJQqAgK/jZZO/k8RSsf23D0YvrnKoeCfXU30y0iid709Or3rjR9s2JQ1EIZGStleVceSx
	utCvUEQilvg==
X-Gm-Gg: ASbGncsMFIsbEhE8beIt7XPjD8xQ4bBiHGQFIgCoyYFVt/wGW0TMan2w/cFhrGhtm2u
	ILCskpfFd5rNTgoTneCfqm9fyMZ7sQhDdq/u43tdYdr+u9Z+Nsq9Pj0sdMUoWUxErx7zA3xog+5
	pyHZYUHxhIZR9oT6umuuCGNJqmvMwNtLzDeg5gRZYQlMvCDWBamvngLIrLQwGLw0LvsaZIEPkK4
	wynpDYuMEsdoyE0Zw7vYT239VQxi13zkWqmebD1haMN3xuSH8J9eUJ0UJ8f9gzwXC9t3g6vPzo5
	0cekpGqpGQSxYxEVmj3bYVrSwHysPWn3LxXQw/jwSA9Le5UsoGY8Q80WlsN/BMfERNiSoNJvg/c
	qUMgy1Lg4Bhp9TO/XyC/7WijztW9vTToGosde7OlLTgiwjaaXO6j64PxFOEU6RWW8idmYAN+4hU
	Qp5kkSbrSIyS3VCoTKZFTSWrOsnjU8boH0pauoJHHdyMQITqz9F9Cf7j4SDCMi
X-Google-Smtp-Source: AGHT+IGzUwOuKfBrtetTURE7TQYgdOlxogkIr2T3wQBfIyKmxQOzaPyuuZM1dY7szHm04gB1ZE9FmQ==
X-Received: by 2002:a17:907:2d25:b0:b65:b9fb:e4a7 with SMTP id a640c23a62f3a-b7a2428bdd3mr112526866b.9.1764992650223;
        Fri, 05 Dec 2025 19:44:10 -0800 (PST)
Received: from mail-ej1-f49.google.com (mail-ej1-f49.google.com. [209.85.218.49])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b79f4a60f50sm505857166b.70.2025.12.05.19.44.09
        for <mm-commits@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 05 Dec 2025 19:44:09 -0800 (PST)
Received: by mail-ej1-f49.google.com with SMTP id a640c23a62f3a-b7636c96b9aso371987166b.2
        for <mm-commits@vger.kernel.org>; Fri, 05 Dec 2025 19:44:09 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCUoDLGDkUAQtZ4CR3luljAKSRFg9xaX937qbgM3bfNQE2qvlQIOdW1bNdTpCm6l03AJbdBD4cIEVU7L@vger.kernel.org
X-Received: by 2002:a17:907:5c6:b0:b72:fd32:a463 with SMTP id
 a640c23a62f3a-b7a242bff7cmr135251366b.23.1764992649368; Fri, 05 Dec 2025
 19:44:09 -0800 (PST)
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251203212918.82f1c9d3947940aeae263878@linux-foundation.org>
 <CAHk-=wj1aw7p-JkWdcJOkQQ279qgppG7_1kxFQAqaak7fEQAjw@mail.gmail.com> <20251206025434.GA1422789@nvidia.com>
In-Reply-To: <20251206025434.GA1422789@nvidia.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Fri, 5 Dec 2025 19:43:52 -0800
X-Gmail-Original-Message-ID: <CAHk-=wj681NMt4ofHWVDzbcb2CjyAZWnVYX=9eJ5tmYjEONNBA@mail.gmail.com>
X-Gm-Features: AQt7F2ryDYxuiAxHRVl65vEABcWsri0dTWnBJNGoQshzjLrlHPuL2xKoXV2N73c
Message-ID: <CAHk-=wj681NMt4ofHWVDzbcb2CjyAZWnVYX=9eJ5tmYjEONNBA@mail.gmail.com>
Subject: Re: [GIT PULL] MM updates for 6.19-rc1
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Ankit Agrawal <ankita@nvidia.com>, 
	Alex Williamson <alex@shazbot.org>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	mm-commits@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On Fri, 5 Dec 2025 at 18:54, Jason Gunthorpe <jgg@nvidia.com> wrote:
>
> Reverting it now works well enough too. Let's see if Ankit can prepare
> a new revision and perhaps Alex can forward it next week or very early
> rc1 after LPC.

So adding that memory poisoning logic at mmap time looks crazy to me.
The mmap has *nothing* to do with memory poisoning. The memory is
there whether it is mapped or not, and admittedly it's harder to
_access_ when not mapped, but it still has nothing to do with mmap.

As far as I can tell, that memory poisoning logic should be
added/removed when the device is registered or unregistered, and there
is nothing about mmap that should have any effect what-so-ever.

                     Linus
