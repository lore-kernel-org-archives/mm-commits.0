Received: from mail-lj1-f175.google.com (mail-lj1-f175.google.com [209.85.208.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E200B628
	for <mm-commits@vger.kernel.org>; Thu, 22 Feb 2024 00:07:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708560423; cv=none; b=Y0dBB5E1mGgRdyq9LeLe6ZeMq6ybcNB+wCoDq2whElG6eDPopQNGZ/f9X+pqGy/4I3QY/Wd08GjxI+PC6nPR5u/GlDakD6ptWeiokjN7H4Rba+DCeyUOmOG+1mmRLqNtijMtrgEDq+MAu24ag+GAOgDSlmVx+zp024YAsxY9HGU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708560423; c=relaxed/simple;
	bh=XdCJcWl5qI12fXi/a1MPLVkD/76HEQdNl48PUrhQjIE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=CZr+Cumy7ReNA1EX9kYA4hjJxZ2hQDjRF4+Yq3XIXW90SskHmpD0khJPbCiJzO9WMVveXnM+PMzK81TeS2O56gF7fZqFKeSsnvyoPxNQESzzlLN9PgR9UYTprD1xeRa9ihl8vONz8jysHSkwMs+N0YH6C2K9hXC8FDKoTsIgvF8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=fFYsWYFx; arc=none smtp.client-ip=209.85.208.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="fFYsWYFx"
Received: by mail-lj1-f175.google.com with SMTP id 38308e7fff4ca-2d10ad265d5so81010191fa.0
        for <mm-commits@vger.kernel.org>; Wed, 21 Feb 2024 16:07:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1708560420; x=1709165220; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=AOX1KrLYMvEor2fGJB3uiW1mzqOctD4Dj46lE6OI1EM=;
        b=fFYsWYFx/zPFF29VnKVJrYILQtxS/ZWmapdVBDBYNc6j6V6B1rHe/XhhWOuvKIE994
         bw4YzeE8IcOITOkG1ORKjX90+JLpzfBP4z1hHwsEzRIYNm/R9VGudfeAUl2up9Ca2wA0
         4n+4uNTFBJHkuW+BZev+T1yQogxWjLFbMYZUr5nZYqtRpAzVuWntkruZmt8n6yfqFcQ/
         707U4SA9P68Sq1h9uvSREHQ563rx0MiSxUl2uqkhOrjNNr1OcSoSKRZAWlki5tJYVBjB
         W0ur83JYn30ZrXvqITA4puOWjwe/CbhwG8WJqJkOpzzazAnHVVjqtwTmj3z9aQwnPbmQ
         nBsw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708560420; x=1709165220;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=AOX1KrLYMvEor2fGJB3uiW1mzqOctD4Dj46lE6OI1EM=;
        b=Gab4nqQtiAyzRdt3z9mVrhUZIlVwkUjNG4bKc6Bhqefen7y5sohjK6UXGRJRGchO0t
         PkgsPJ5BK09KM4z8+rBRzNhXd/J9rF61mrnK+bUufvLfAv7Y4a8Y649Arq0lDGq6dRKo
         AY65bHi9PP0lTeNzn2e1bml5xY9xFo9hjRXsEaafAnd8HT4J8tC4B/kJCaxMm8oEb2u6
         lIs3pZeJXzgafFS7KIw4HuFItr3rbXPxhbNpqVgGAfe4Z1mpti2CzjM+2CznmWi8nPm2
         n73Sc+wE6HJdzHJjXCY+5/Yv9q+Jg7woayzbqLoP2hmVZhlccr6r+dFj0zLNSiX5EFPN
         QaMQ==
X-Gm-Message-State: AOJu0YwJTJWLYO/KTuyzFyAJvcbQeaMAJ3dOjpiyqv2rG81sGA84pnOd
	ApaSKlh9zDcHCQFfZbEm4rG5iH7B5sNti/i+lYt5cBNIOHGGL+q3vSDpIc6OvbRFAaI3WnmBEMb
	Oelr4jhB+JH3zYnfuisWixzNXChMYHUcggvi3
X-Google-Smtp-Source: AGHT+IG2udJvigFty3fqAiEJeZBqSLEO1+XOU8vDKaTnHbFsPj67bjmSeOQb8odVmP7pn0/iy3hgQvRopCwjqornNag=
X-Received: by 2002:ac2:4345:0:b0:512:bb2a:c96b with SMTP id
 o5-20020ac24345000000b00512bb2ac96bmr5492555lfl.28.1708560419753; Wed, 21 Feb
 2024 16:06:59 -0800 (PST)
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240222000150.575D0C433C7@smtp.kernel.org>
In-Reply-To: <20240222000150.575D0C433C7@smtp.kernel.org>
From: Yosry Ahmed <yosryahmed@google.com>
Date: Wed, 21 Feb 2024 16:06:21 -0800
Message-ID: <CAJD7tkbp4NVz__T0LJDq1zNH8vLH4U753enSt=sicd5NmXqqGw@mail.gmail.com>
Subject: Re: [merged mm-stable] x86-mm-clarify-prev-usage-in-switch_mm_irqs_off.patch
 removed from -mm tree
To: Andrew Morton <akpm@linux-foundation.org>
Cc: mm-commits@vger.kernel.org, tglx@linutronix.de, peterz@infradead.org, 
	mingo@redhat.com, luto@kernel.org, dave.hansen@linux.intel.com, bp@alien8.de
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Feb 21, 2024 at 4:01=E2=80=AFPM Andrew Morton <akpm@linux-foundatio=
n.org> wrote:
>
>
> The quilt patch titled
>      Subject: x86/mm: clarify "prev" usage in switch_mm_irqs_off()
> has been removed from the -mm tree.  Its filename was
>      x86-mm-clarify-prev-usage-in-switch_mm_irqs_off.patch
>
> This patch was dropped because it was merged into the mm-stable branch
> of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
>
> ------------------------------------------------------
> From: Yosry Ahmed <yosryahmed@google.com>
> Subject: x86/mm: clarify "prev" usage in switch_mm_irqs_off()
> Date: Fri, 26 Jan 2024 08:06:44 +0000
>
> In the x86 implementation of switch_mm_irqs_off(), we do not use the
> "prev" argument passed in by the caller, we use exclusively use
> "real_prev", which is cpu_tlbstate.loaded_mm.  This is not obvious at the
> first sight.
>
> Furthermore, a comment describes a condition that happens when called wit=
h
> prev =3D=3D next, but this should not affect the function in any way sinc=
e
> prev is unused.  Apparently, the comment is intended to clarify why we
> don't rely on prev =3D=3D next to decide whether we need to update CR3, b=
ut
> again, it is not obvious.  The comment also references the fact that
> leave_mm() calls with prev =3D=3D NULL and tsk =3D=3D NULL, but this also
> shouldn't matter because prev is unused and tsk is only used in one
> function which has a NULL check.
>
> Clarify things by renaming (prev -> unused) and (real_prev -> prev), also
> move and rewrite the comment as an explanation for why we don't rely on
> "prev" supplied by the caller in x86 code and use our own.  Hopefully thi=
s
> makes reading the code easier.

I really wished that someone would double check my understanding and
make sure I didn't make things worse here in my attempt to clarify
them :)
