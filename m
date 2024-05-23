Received: from mail-lj1-f179.google.com (mail-lj1-f179.google.com [209.85.208.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84A67127B77
	for <mm-commits@vger.kernel.org>; Thu, 23 May 2024 21:01:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716498069; cv=none; b=r/Dh1E9FgOLLjwbyDeG5LRF7YLZnHXwKMN0CxABr3MUYyMwVKLK/87PIRD5nHdiuMxQKHbdbjOKwxFLw7P/zmWAvHfwikFUaKfASDgBhgy0QgYbL78MIsIs3o6sBdEOk2NiEH4TOOVNvE8zmjxyQbhHxTIQsrbTLQzqYwvR3h84=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716498069; c=relaxed/simple;
	bh=cTpeq0V0c0RegFOfrL3pmUYXe4kgmxkEsxqvzisJSeU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=W1Yh3GsqfCbl4bTuqtVPB/KmzW5CS/HNaY9mEVFzAVPI9oo3mHZmpFxBvo84QOdWOT9/7bDoxj/sKqyx5HqjtShRcU/Req2MEEJGfgEhye1yeOhlOktxjJoP2j2YFEdBUIEiNsXHyvgGEsx+ToKXWG+E+rJVaM+OipaoDAVCE34=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=JZr5ud/x; arc=none smtp.client-ip=209.85.208.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="JZr5ud/x"
Received: by mail-lj1-f179.google.com with SMTP id 38308e7fff4ca-2e73441edf7so48749561fa.1
        for <mm-commits@vger.kernel.org>; Thu, 23 May 2024 14:01:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1716498065; x=1717102865; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ew8tvdSYCoWTVotPZYufmvoRW75ZEutEayZHcrfivNg=;
        b=JZr5ud/xS1simKe4+LqkehkHxN8WIkHK9pwjircHmljO6gWai8zC5aLOW1PBfNaYT3
         lQxwsFjCqlnGeWHrZbnNDUZPOkUAPcUGr+F1jTrxALvpotz+0prODJkgIvWuEXKlYTuP
         +jQ6NW2mMiJv9jIRSYEK9j56s9v1kz7f36MSq6a/lhLoHEkTT75I1bZFADWlTe9m56iH
         ECKX0S8XH6oJqH0NW/JgBO4yGYop9QP8FCEhOelrXLUoX4YDMvXdQ7R0akpEmlPt3uKD
         3Sxwmz8amo0piWD1pgA8qZXW4X8u/7w6Z1laBwsgXlDtVm6dbPEpMAKtGGNIIROUa5Rp
         7XQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1716498065; x=1717102865;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ew8tvdSYCoWTVotPZYufmvoRW75ZEutEayZHcrfivNg=;
        b=gYkVFZbMStTVvIKnGg+i5ibbEyF9s1m7Eti/qdq/mrwBrEuUN0jGuOjfW2WS+gNtHj
         JXEAZfUnziNk+BDYNgGvuz0ZgJrwuXB8PJrQZJjtDCHfmVlQC2nLL5QRHBWRLKg/JiaO
         k4467DgtSuBcSJXwqloai3EDTUXpBExP8MKD1AhsAWw6JLmaL7LEuqWA62aLtDjH4cf8
         +Ty/dMaIc6h6ZNfuZlbKpHvFTdY/50B3i+3VwD8FZ9jzwZvSCcHXqJBlnGKD+zpwLiPt
         qv29LoepfDA47ZiYRm1TW1D7MOs7TV3E4m5PzJE+XDSB8H776jsMcm/CTO3AMBaQoahc
         oaYw==
X-Forwarded-Encrypted: i=1; AJvYcCX/eGklwbnALtNIcG9Zz0aLhooYihNd3evEPQE8rR2/OHtgN6Q26KOg7Pyr4MY2mcKrI2ERY0+xQ19GWwKJAEru0+pzSAPWyCErVw==
X-Gm-Message-State: AOJu0YxPL6KC/A37kikkjWGJYP7niiidT/BIPVrzsCJhn1t8l5lIZ4N5
	+JB2NPdCGQ2vDUry7nz1FIt9quztd49hhkiSsccPDVI2ld1wsBL1MAbgwFruw4ESzW4HD93PmAn
	grHgoyNNmklBrs71uU242V3PWFhs7eF4UruA=
X-Google-Smtp-Source: AGHT+IExxxME6bX2kIByTQjGyYo4LWcxGtZH7SF5Bb3tqW/wykfGjZ6zoarXkCzmyWDca7cohU6/LfiCclD7cjtsnDY=
X-Received: by 2002:a2e:9b8f:0:b0:2e2:42d2:c609 with SMTP id
 38308e7fff4ca-2e95b099eacmr1328741fa.15.1716498065292; Thu, 23 May 2024
 14:01:05 -0700 (PDT)
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240523190751.543B0C2BD10@smtp.kernel.org> <20240523204358.GE15163@redhat.com>
In-Reply-To: <20240523204358.GE15163@redhat.com>
From: Uros Bizjak <ubizjak@gmail.com>
Date: Thu, 23 May 2024 23:00:53 +0200
Message-ID: <CAFULd4bmZNMVefC75oQN9G-DtKV=r+Q=skBVNsxVaTTxHSmbHw@mail.gmail.com>
Subject: Re: + fork-use-this_cpu_try_cmpxchg-in-try_release_thread_stack_to_cache.patch
 added to mm-nonmm-unstable branch
To: Oleg Nesterov <oleg@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, mm-commits@vger.kernel.org, 
	keescook@chromium.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, May 23, 2024 at 10:45=E2=80=AFPM Oleg Nesterov <oleg@redhat.com> wr=
ote:
>
> > From: Uros Bizjak <ubizjak@gmail.com>
> > Subject: fork: use this_cpu_try_cmpxchg() in try_release_thread_stack_t=
o_cache()
> > Date: Thu, 23 May 2024 09:35:14 +0200
> >
> > Use this_cpu_try_cmpxchg() instead of this_cpu_cmpxchg (*ptr, old, new)=
 =3D=3D
> > old in try_release_thread_stack_to_cache.  x86 CMPXCHG instruction retu=
rns
> > success in ZF flag, so this change saves a compare after cmpxchg (and
> > related move instruction in front of cmpxchg).
> >
> > No functional change intended.
>
> Sorry, cosmetic nit...
>
> > @@ -205,7 +205,9 @@ static bool try_release_thread_stack_to_
> >       unsigned int i;
> >
> >       for (i =3D 0; i < NR_CACHED_STACKS; i++) {
> > -             if (this_cpu_cmpxchg(cached_stacks[i], NULL, vm) !=3D NUL=
L)
> > +             struct vm_struct *tmp =3D NULL;
> > +
> > +             if (!this_cpu_try_cmpxchg(cached_stacks[i], &tmp, vm))
> >                       continue;
> >               return true;
> >       }
>
> Why not
>
>         static bool try_release_thread_stack_to_cache(struct vm_struct *v=
m)
>         {
>                 unsigned int i;
>
>                 for (i =3D 0; i < NR_CACHED_STACKS; i++) {
>                         struct vm_struct *tmp =3D NULL;
>
>                         if (this_cpu_try_cmpxchg(cached_stacks[i], &tmp, =
vm))
>                                 return true;
>                 }
>                 return false;
>         }
>
> ?
>
> To me this "continue" just adds the unnecessary confusion with or without
> this patch, but I won't insist.

To ease review, I was trying to make the patch as simple as possible
(almost mechanical), because the logic around cmpxchg() and
try_cmpxchg() is somehow hard to follow (e.g. cmpxchg() returns the
previous value at location when it succeeds, the "tmp" variable is
only updated when try_cmpxchg() fails). Any additional change would
just unnecessarily complicate the patch.

Uros.
