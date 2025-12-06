Received: from mail-ej1-f53.google.com (mail-ej1-f53.google.com [209.85.218.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A4DF25D53C
	for <mm-commits@vger.kernel.org>; Sat,  6 Dec 2025 23:40:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765064430; cv=none; b=tB1vPIPeyFm8k7UvXdM/hpyOlXnKHicZj8p6dK5Wsq/frgzUQ5lunBTlYd6rxbZnvNhC++FSysX80rjTiISmR07KGgDD9EbH9ucZsrxRbniAZ9FZS7wE244QFq+QowLaWIAxyNnh8jo/4kPDCWacxPd3bAFEMrSevnP6+Uv6nag=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765064430; c=relaxed/simple;
	bh=pZMQ00j+vpfeuiWpfJvtUa9xHuG6UA7zkFWhbYq/IoE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=FURYAexD47i21+EkC/NX/1uEq0m2qgeYwu70o3GV2KPe0IDbyPA9xKNHR6iLnK4ectDqQmrzNzWD4g2FfdMxtos/3H/czrKmBb947nqhm/wMXvxQ8B6ICba9E+AhO4ejiyplg608D2Iuf9jEMF9M+oGXpGpHdb+R7jR8hfm+Vzg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eqJUAVca; arc=none smtp.client-ip=209.85.218.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eqJUAVca"
Received: by mail-ej1-f53.google.com with SMTP id a640c23a62f3a-b76b5afdf04so497724766b.1
        for <mm-commits@vger.kernel.org>; Sat, 06 Dec 2025 15:40:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1765064426; x=1765669226; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=CgOEk/7K/w1rsAawd3rW0bpN2Y7/qQCS7eHYvBjEcC4=;
        b=eqJUAVcaPUzqdgN6kmfzk5gMBDD/xnDHNhZIV0kaNelklrsp1ckK4EdqA+pXxai8b1
         p2HJLffhsBV9GGAsw+B92vEJJ/aIMoSlR5qWg/5K+5FeqGTf3zRX5Vh8pAwik+1cEs5l
         rseACAJhRgBFPRTd5GWIniHWJY7JiJsnUUqlY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765064426; x=1765669226;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=CgOEk/7K/w1rsAawd3rW0bpN2Y7/qQCS7eHYvBjEcC4=;
        b=PZp8S4eJXc1OlnBO+yE4gFFVqKhbhhiqb5+rbUywGs3BI79PG1mdjYyJ4AAAp+aZMw
         GSNDfhjztvIzoQOfqnnE4lGq1L4uA+zWPC8ZnniMGxSIsq6nU/MvrJ2vSECMooWsYC0F
         5D5t1GfQylZd8yP+TSuwzQNV19AuKMM9oTvpA5CtoaoNIoiMvko7jJymHxMsBXUVfuvT
         hJZpgZQIbzJjWZShuIZqAwLxvJoOZh7HZBvT3bmxiM+BTOYc/VSMKTD+GLEpoRgr4C+b
         4sJqUC5UNyRvmipkAAxAde/lSO2JWgCe79pS0bTpWTLLL8cz+luS/2p1JXNR98xn7Pwa
         Hiow==
X-Forwarded-Encrypted: i=1; AJvYcCXWADN9U4OStAEYvc6ealyWkbkg307q0xVtrP5o2a00c897qrqCpJh0t2+9TMIMLPiQ0rMVNxIm9KAW@vger.kernel.org
X-Gm-Message-State: AOJu0Yx5QEfpfzJFZ6UloY8jbzKqrleCSwrEgx9KWMj/kSKkg41SiHhH
	tZxKR5+y9UgvhQC4zH0lkTbjywIasOkdRQy94RaD602Sa5z1+pqitEfxC6cWwLEXTDPDUcIq7M8
	2VEXDFiM=
X-Gm-Gg: ASbGncuUe7UAv5tlcQHOzpLg0o5OOmHWBi995puqO+ub0uEcF1dzzUUg5DiA+EewQZc
	2yhZsJEUxdTv6zkkOgxIOtSLfTEBOpTiYQhNWKoltP00meHm6LNdZ8FmDpMcZs8kR557TfQA3Rq
	cHf+6zyxxO6nQ9h0PtwYHgZ5d1lJQpMlDq3VzC/Y9g3iEYSdpaqoNmsS9ndFy0uFWvruIsDjdA/
	iVmLJGndf4ixOlvmBhVR6egZF6Lqs9AewgXkvtqVy0aFReAa5xpOjMZ73EDVpPe/7g8+3ZUrT1u
	TrsKoQNW6LHCIqp+Yxo6d78ffvwwCj414y83yny1lIOCnjXC+Mpt43GpNMN8hthp8q83n9RfSoD
	VjoduQSBGz87h5fmCfKsTOhZOhi7S4hDgBqruuTMYXhqFS6aIGR65S+oUiXACVB6vDXVdQPDLht
	nBvDMS8G0r5nIjG4VxnYok5bWB5ywpEQIh33hCXuAcoJNwuoiVNBNcS9+y/rgxFGMZzHwOLg==
X-Google-Smtp-Source: AGHT+IHkAa1xetnZVXnOybKYHF6de6QQFecuqD4xwf1IBEoDSRxvcvDuQIn6k89dEQ8CycXKt4leTw==
X-Received: by 2002:a17:907:968f:b0:b74:9833:306c with SMTP id a640c23a62f3a-b7a24857365mr428162866b.47.1765064426259;
        Sat, 06 Dec 2025 15:40:26 -0800 (PST)
Received: from mail-ed1-f47.google.com (mail-ed1-f47.google.com. [209.85.208.47])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b79f4459378sm758886266b.6.2025.12.06.15.40.25
        for <mm-commits@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 06 Dec 2025 15:40:25 -0800 (PST)
Received: by mail-ed1-f47.google.com with SMTP id 4fb4d7f45d1cf-64149f78c0dso4812019a12.3
        for <mm-commits@vger.kernel.org>; Sat, 06 Dec 2025 15:40:25 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCU2ZGwswDahvcrqXHdNfZTyHxNLhdcAx11IM+yRg5eyZNaFTN1C+lH1QVOfZxKWh/vzEmkrPCV6HJte@vger.kernel.org
X-Received: by 2002:a05:6402:440a:b0:640:6512:b9f with SMTP id
 4fb4d7f45d1cf-6491ae1bb41mr2882656a12.28.1765064424663; Sat, 06 Dec 2025
 15:40:24 -0800 (PST)
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251206111533.f1b18ce84d0854b5f6d86a8f@linux-foundation.org>
In-Reply-To: <20251206111533.f1b18ce84d0854b5f6d86a8f@linux-foundation.org>
From: Linus Torvalds <torvalds@linuxfoundation.org>
Date: Sat, 6 Dec 2025 15:40:08 -0800
X-Gmail-Original-Message-ID: <CAHk-=wgG3xqJn1=SVw-npsdwCRtyY=sYbLa7HFkmj_Q0U=vdHQ@mail.gmail.com>
X-Gm-Features: AQt7F2r81xpp64C4WIWsPJhNfCZ5WInUAH3PD60qEkniBigIkEpaAw5wIoan_Os
Message-ID: <CAHk-=wgG3xqJn1=SVw-npsdwCRtyY=sYbLa7HFkmj_Q0U=vdHQ@mail.gmail.com>
Subject: Re: [GIT PULL] non-MM updates for 6.19-rc1
To: Andrew Morton <akpm@linux-foundation.org>, Dmitry Antipov <dmantipov@yandex.ru>, 
	Joseph Qi <joseph.qi@linux.alibaba.com>, Heming Zhao <heming.zhao@suse.com>, 
	Mark Fasheh <mark@fasheh.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	mm-commits@vger.kernel.org, Pasha Tatashin <pasha.tatashin@soleen.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, 6 Dec 2025 at 11:15, Andrew Morton <akpm@linux-foundation.org> wrot=
e:
>
> Dmitry Antipov (8):
>       ocfs2: annotate flexible array members with __counted_by_le()

This causes the build to fail for me with gcc 15.2.1:

  In function =E2=80=98fortify_memset_chk=E2=80=99,
      inlined from =E2=80=98ocfs2_reflink_xattr_header=E2=80=99 at fs/ocfs2=
/xattr.c:6365:5:
  include/linux/fortify-string.h:480:25: error: call to
=E2=80=98__write_overflow_field=E2=80=99 declared with attribute warning: d=
etected
write beyond size of field (1st parameter); maybe use struct_group()?
[-Werror=3Dattribute-warning]

And the reason appears to likely be a bug this exposes, rather than a
bug in the annotation. But I really don't know the ocfs2 code at all,
so I'm going by "the error message is horrendous, but I can follow the
logic in the code, and I think the code was actually wrong".

I have "fixed" things.

And I put that "fixed' in quotes, because my fix looks sane to me, and
makes the array counting logic happy, and my fix may well be the
RightThing(tm), but somebody who actually knows the ocfs2 code needs
to check it out.

See commit c06c303832ec ("ocfs2: fix xattr array entry __counted_by
error") which simply makes the 'last' pointer point to the actual last
entry, rather than point to one _past_ the last entry.  So now the
memmove() and memset() in the "possibly remove entry" loop below might
actually work right, in addition to building cleanly.

But again: I did this without knowing anything about the code, just by
looking at the logic.

I _think_ the code used to copy one entry too much, and cleared an
entry past the end. It probably worked fine, because the code also
decrements xh_count, so even if it cleared the wrong entry, it was
past the counted end.

I'm a bit unhappy that this didn't show up in linux-next and that I
had to chase this down. I don't think my gcc version is that odd.

Anyway, it's building for me, but I really really want some ocfs2
person to take a look. Please?

               Linus
