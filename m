Received: from mail-wm1-f54.google.com (mail-wm1-f54.google.com [209.85.128.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 664212D876B
	for <mm-commits@vger.kernel.org>; Thu,  4 Dec 2025 15:09:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764860943; cv=none; b=DOONL+3YxDu7aBC4FfonGX4/Vdu1BzA7kvPy41n0rK5iT2QXWKCdP7SVhvpVmzSem1ylY/2Ctbr+pRf306EZKbtf3NMLrZeq/BgihbISfgdT27Nrs/FvBomA5dKNd4iHmSw2yd6q4yuK0AEvgVLhpCql11IDawwLcWVuQleq+iA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764860943; c=relaxed/simple;
	bh=5v9szWJGeDjjmm5BmESzhqY5NC+TLr6VLOtjJwfkMBc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=m5djIQUsCbSpg//eLVztEhVOp0EWUU96JZvRN/iwONaAGC8RGcyA4dTWeAxmABLTErfqwkRMxp0qelofmkkoGox/+Fyy4LZ9qvVt5oTZnAjnuX9gFTHfHWl2sWVOoGdjuGk9Veqp+UwGvGgZZG7MvDRsZ6MEwXyzj0BgNaWlHvQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=TrqS/EOY; arc=none smtp.client-ip=209.85.128.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="TrqS/EOY"
Received: by mail-wm1-f54.google.com with SMTP id 5b1f17b1804b1-47795f6f5c0so7391605e9.1
        for <mm-commits@vger.kernel.org>; Thu, 04 Dec 2025 07:09:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1764860940; x=1765465740; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=SuUcWJogoj5Zy6UaFHm38nZ24EUypEOSoXHBrVrDbNA=;
        b=TrqS/EOYmJ7VRiFbcnv06bQKPhFw9RJJnIK3rMWTtmrtpetjix7grmJu23fFm6BQRd
         9AvFWIZDAG8/BdgyBYB5pNMlRKWdOB0pNTb31HcTFJA/ZYPEQCoiLal1ISovIQ49HP2l
         wSwNFuNa4AX5/Lw8onu7uGjhVWsmHwkfdzFo7iqMT06F5KAH1LqYyiKDZdSdFJtbjJXv
         wJWijpKiTwSfKQ85iW8U2tJo8wW6i5UKXfPlWTrlPLVvpSFuC5DIi0w5/8Z1GXw6UpAZ
         EqcxU41KUKiFZP2LdNIO6ACohM7NMpG9C6oxXUEHtK3/Amd/oBw8ACWuGkyRlR5CBcb5
         30Zg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764860940; x=1765465740;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=SuUcWJogoj5Zy6UaFHm38nZ24EUypEOSoXHBrVrDbNA=;
        b=S1M/CB7TmjYJNlE2JyeVbZUSd3m7N8Q04K2zKm1y0GFUwq52mj2Q17Ou1IcV05Lndb
         ch1aEKMOQ7w0hyMNeoEQGeuqycecMX+aUzdB1r+QJIe1aiyWto0jASTk8LbggQMif0Ku
         ch7QfBP8nXXYQx4uoqNqbc4OuPkLOf6xkdi23O/nWX+9AwTx3HZXEzYLDuNLuVwQzSht
         bWwDgKC3pQNrlOHi5VDPhOunEWIPncl7dj8l5uoXov3FrNnBQGtr7/1fJudVc/jhtWbS
         CN483Gt8Rm526pjJay5skxLH18bRfuzyq9w5b/r2qLq99QoX+QxgfZ9k0tPXdDuHvxMV
         UAEQ==
X-Forwarded-Encrypted: i=1; AJvYcCV+Y677VTi2+3PaEVDYCeyOuBijRTjz7n28BN7sJsQ2LkrWK7usgOrVKiRCR4HdyRShJtpjh9jGTiDe@vger.kernel.org
X-Gm-Message-State: AOJu0YzDfaMXEBh0LiEfkSgybRT1mcmrUfLi7MrrrvPRMj3I/qx2f6zq
	oFkemQbxJSZHz3MuTuoehq9tTjVohFSsKXZkgFPkUuORybCZocrMrRIrMFnBj5ImJi9ukWazdGs
	kO4q5yBMvceU3sveal0D1kkqk9yo1Zjg=
X-Gm-Gg: ASbGncutJXHwXZ8SVSiE1wydAkj2G211Y98psryNH6lxG6BMq5eep/nld74NbH8hyDK
	k3vDjAvRbJep8ybxXHwVMffNEtT0SMx0m8QE57mjReLyFz4wvBFbrYL9zXqQh/rj3XD1FZXF5fj
	bKeaBevKKAHFIGPO1/cnx29ezK3NKLkzhfHqpqiV6jpkFjmceVIfYh+fs6L42hpJ0d4/1YS/unG
	Zqk9Dfl3x3fGu3GE7533oRaN3Z4mtrZLpnrnIF/Axr2W6bNaMEO6STwX/2ubdH/xSKK0GlAg6Gt
	fIEDB4dAUqEjEGCsKmrHFoT+V+QS
X-Google-Smtp-Source: AGHT+IG8ZNIqkG+ruavtPJNLq/7WMSVxHMUln0iX3Nef6xsc00ik27GsBe6pzlL0EJfSOb1mXAdcaDwF7df//rfefjc=
X-Received: by 2002:a05:600c:4443:b0:477:7f4a:44ba with SMTP id
 5b1f17b1804b1-4792aee3a05mr61970655e9.4.1764860939413; Thu, 04 Dec 2025
 07:08:59 -0800 (PST)
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251128185523.B995CC4CEFB@smtp.kernel.org> <CA+fCnZeKm4uZuv2hhnSE0RrBvjw26eZFNXC6S+SPDMD0O1vvvA@mail.gmail.com>
 <2f817f0ba6bc68d5e70309858d946597d64bac8b@linux.dev>
In-Reply-To: <2f817f0ba6bc68d5e70309858d946597d64bac8b@linux.dev>
From: Andrey Konovalov <andreyknvl@gmail.com>
Date: Thu, 4 Dec 2025 16:08:48 +0100
X-Gm-Features: AWmQ_bmRB-ksejN_0Sq4l24XGjc90aU-UQEIYgag1iEv7qWtJahCQTEp5QO-pZ4
Message-ID: <CA+fCnZeizRWUFs2k_7wbhJ5v+LdD8H77C0vrP6jp52qp0G_6zw@mail.gmail.com>
Subject: Re: + mm-kasan-fix-incorrect-unpoisoning-in-vrealloc-for-kasan.patch
 added to mm-hotfixes-unstable branch
To: Jiayuan Chen <jiayuan.chen@linux.dev>
Cc: Kees Cook <kees@kernel.org>, mm-commits@vger.kernel.org, vincenzo.frascino@arm.com, 
	urezki@gmail.com, stable@vger.kernel.org, ryabinin.a.a@gmail.com, 
	glider@google.com, dvyukov@google.com, dakr@kernel.org, 
	kasan-dev <kasan-dev@googlegroups.com>, 
	Maciej Wieczor-Retman <maciej.wieczor-retman@intel.com>, Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Dec 4, 2025 at 2:00=E2=80=AFPM Jiayuan Chen <jiayuan.chen@linux.dev=
> wrote:
>
> December 3, 2025 at 23:18, "Andrey Konovalov" <andreyknvl@gmail.com mailt=
o:andreyknvl@gmail.com?to=3D%22Andrey%20Konovalov%22%20%3Candreyknvl%40gmai=
l.com%3E > wrote:
>
>
> >
>
> > >  ------------------------------------------------------
> > >  From: Jiayuan Chen <jiayuan.chen@linux.dev>
> > >  Subject: mm/kasan: fix incorrect unpoisoning in vrealloc for KASAN
> > >  Date: Fri, 28 Nov 2025 19:15:14 +0800
> > >
> > Hi Jiayuan,
> >
> > Please CC kasan-dev@googlegroups.com when sending KASAN patches.
> >
>
> Sorry about that. I missed it.
>
> > >
> > > Syzkaller reported a memory out-of-bounds bug [1]. This patch fixes t=
wo
> > >  issues:
> > >
> > >  1. In vrealloc, we were missing the KASAN_VMALLOC_VM_ALLOC flag when
> > >  unpoisoning the extended region. This flag is required to correctly
> > >  associate the allocation with KASAN's vmalloc tracking.
> > >
> > >  Note: In contrast, vzalloc (via __vmalloc_node_range_noprof) explici=
tly
> > >  sets KASAN_VMALLOC_VM_ALLOC and calls kasan_unpoison_vmalloc() with =
it.
> > >  vrealloc must behave consistently =E2=80=94 especially when reusing =
existing
> > >  vmalloc regions =E2=80=94 to ensure KASAN can track allocations corr=
ectly.
> > >
> > >  2. When vrealloc reuses an existing vmalloc region (without allocati=
ng new
> > >  pages), KASAN previously generated a new tag, which broke tag-based
> > >  memory access tracking. We now add a 'reuse_tag' parameter to
> > >  __kasan_unpoison_vmalloc() to preserve the original tag in such case=
s.
> > >
> > I think we actually could assign a new tag to detect accesses through
> > the old pointer. Just gotta retag the whole region with this tag. But
> > this is a separate thing; filed
> > https://bugzilla.kernel.org/show_bug.cgi?id=3D220829 for this.
> >
>
> Thank you for your advice. I tested the following modification, and it wo=
rks.
>
>         if (size <=3D alloced_size) {
> -               kasan_unpoison_vmalloc(p + old_size, size - old_size,
> -                                      KASAN_VMALLOC_PROT_NORMAL);
> +               p =3D kasan_unpoison_vmalloc(p, size,
> +                                          KASAN_VMALLOC_PROT_NORMAL | KA=
SAN_VMALLOC_VM_ALLOC);
>                 /*
>                  * No need to zero memory here, as unused memory will hav=
e
>                  * already been zeroed at initial allocation time or duri=
ng
>                  * realloc shrink time.
>                  */
>                 vm->requested_size =3D size;
>                 return (void *)p;
>         }
>
>
> > >
> [...]
> > Would be good to have tests for vrealloc too. Filed
> > https://bugzilla.kernel.org/show_bug.cgi?id=3D220830 for this.
> >
>
> Thanks, I will add test for vrealloc in kasan_test_c.c.

Awesome!

But as mentioned in the other thread, let's first implement a
standalone fix for the original issue (that can be backported) and all
these extra additions can come as separate patches on top.

Thank you!
