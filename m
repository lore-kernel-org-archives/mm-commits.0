Received: from mail-yw1-f173.google.com (mail-yw1-f173.google.com [209.85.128.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7044D37E2F1
	for <mm-commits@vger.kernel.org>; Mon,  9 Mar 2026 10:38:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.128.173
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773052705; cv=pass; b=YT2HZu5npjhxmGjSOCCuowwE5CF9IObjvfvhCmzxSuH8qCQFJFkkLX1Wi8jlVQq6ouv7QhEg1KL1UQvMddxOVtos5p1fEkxi68Ei3WaSgTc+HKNWlZiL4m5YCHnuF65Ha6rbncVLyrI4BIXv9KEtJEex5gJ2BTJOwDv34Y0cYZ0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773052705; c=relaxed/simple;
	bh=zGQuc34+ynNDoCTXArYQlWm9klqKQ2W0kK6j2oLNx+Q=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=d+UB9Gx0ZSWRJMZsBSnxu5gBaeLSpSKOKGWP+XNWgwvPI0syMotPQVW/veGFt+PHcp/d25BgDxk0gNAxEwb0V+gIxz8ueWt4FsNBkh2uiTYcgrQUHx+/WDYLwd9FbUJKjtN88CMXKQAapSttwzstuzb11/X6k20Rmayu40tpCMk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Ob0cqTaM; arc=pass smtp.client-ip=209.85.128.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Ob0cqTaM"
Received: by mail-yw1-f173.google.com with SMTP id 00721157ae682-79901821bb0so4180787b3.2
        for <mm-commits@vger.kernel.org>; Mon, 09 Mar 2026 03:38:24 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1773052703; cv=none;
        d=google.com; s=arc-20240605;
        b=DNAAwl5HB61aHnjFzImafMVpMnMvBCPlGJv4+PCeVtEYVdBVOaITKczhk56kW9oV7x
         3PK+yr4PzGieT4smyj/9EFPZas13a1Vw0WVdUngEY7n+Z23r2GZjl9u2NrGWEVHTVR/8
         jURFJ8pxBgm6+5aVxox++4ZMJ7e780MMYrdlQr/oJf2Tr8sJ3OaFlIr8TMu2ZrWt3pMy
         APIrVu0Xylt5BfNKEQsghzukcXLSpp9lzXo4H/7wkPmOSE9p4Bw0bIJ3gq/1VA/b23GX
         hoNwdYrLxi3RCEY1aUeB/SYjgEEqlqIMn8+oattMRg3GSgCVjlbK/KNGlVHdMVWQ4Z7O
         DaqA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=Pd/QwTFnDfoORdcPMrJQXvD9uG10tJG+M7oMPLvF7XI=;
        fh=eJIl4qgZJgZc4I0yKyYbioXXlaL6mAMxkbA6faZ+nxc=;
        b=LZsCxAoZh7hhBR5Fat9s+1Ak9yurhi39Wpm2nSAdskR7rVr2ZNP+hsZAcqtF0gLGn/
         CuWsEzC/6ysTQ2tYnJdfzXyHt7PkMdGhrfECGSohUbcGG9dut3bV828CinjDZ1TEekmW
         kMAPkffaVHvElKcI7H95lW1xEUhik7ucYTvSydbXUrRF3MOZO2VdoJxNv0EWk+zzc11/
         kpL59SeviYEQPl6UrJB6seVGRGdQqTyc7+/kb7q9u2rhbVZg63qTlA34Ml4lJXUfDpnR
         wIFpSTrrgVc+mlr0QjlBxqddoiVQrzLk3+sRQ1Wj4cmMnE2Nui98VGLPCuQxacOE1h4l
         BKkg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1773052703; x=1773657503; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Pd/QwTFnDfoORdcPMrJQXvD9uG10tJG+M7oMPLvF7XI=;
        b=Ob0cqTaM09uVsKogdZ/rjHfrDQPPWMwQVUeh7I7s5NoAKBRcO8X1L7XzD0u3lba7Gw
         JhXt1et1VPGMzYlitoNQCkEazk4vasMQc4TQOn2p0ZNisnzsvx4Xs1gfy6Fxaf9tyNjb
         dqBB2UIEsNMwsu1QvfhtIOBQYs7L0DtaqIvIhEpCmvCAJfDkV/gkKfwDisZvC3iW+4OC
         rafsT0/WIhgmedqXMpKw9eYztRmOMIQWKNotP+qtiadhApSa72T9TqIUjwhr+9OTlC0L
         vQrBziNOSM9Qs/uKEoicgsCToiqsmAQYZ7zJXSSkX0v7SxRfD/AJHpt8m66lAdokuR1V
         A9Gw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1773052703; x=1773657503;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=Pd/QwTFnDfoORdcPMrJQXvD9uG10tJG+M7oMPLvF7XI=;
        b=WDu07l+rZxirkaV6d4d4H6o1w+lk3FmvKdcuBZG941OSd5xchw1owbULkbhANYcwN2
         YAIv1RDsD11BGESYwcOwLdexFH6D29ZjC0tcKt4KT4xEC34cBUSK+lHDJiSPMsL9g0gq
         d0WN4ycjnBNfsoQ95AwGNVdxgFAoPB3elyI+iFodpV4QBgUapVy2sAN4JInSDlmTKboa
         jC7anoZm2d3roWlbF5ybD0F7t0olDH9crP6WsNkX35p/W3Zdis7aihfAQ08eyC1xOKru
         qxzb+n6n6Ab8TEE2+i1iH/Gc7ooyzECJu2yPiTJhgRcmmhquqtjpnjiHYZ43mRSG1yAk
         WSZw==
X-Forwarded-Encrypted: i=1; AJvYcCXOrdk2bfbgmh2TB2SbVHj7x79tC55RUHbYbPPkoD39lVsy0Ixpmxbq8Pu6ztp/YMLjst1Z0mqS8PvN@vger.kernel.org
X-Gm-Message-State: AOJu0Yyx7q4SWgNjYnzGa1m3j5TDwSMSNHn2rfSC8in5GzF3DyNPxMfW
	EkSfMSQHI4QV6VzWw2Jq8Qj8+bS/O79U0Qwtd/vYNO6WP4AZdVr4kI3CCwIPWnUtTLXzf+w7fzw
	RTAR7TY1ifRkez1p6aNZo4Rlz044T2T4=
X-Gm-Gg: ATEYQzwppi8Jnf0emagulQvjbua19YZOvOXJYGE8LD6cDOhZxY6+m3TqORWxk8jNgpz
	wNMVDtrVPsv5La28CzZrte9/R3/ozI9n8IQ2/4y7joynWa6S6uxhWYIzN6PEYVW5FllKFkY1YL8
	FU6hgjeYd8TOmtsthkJl0rzhsmrkX4bHvmR/Z0BnQDzKHeAfOyz5yTw5Of1KiYlmAz/bgqICzAr
	25MtZg/6E2x+KCO1BlZ22pVZSW/eNgeUcaQ/6klWuprUuYHYNKfj9GnI6yvlSE9VsW8FCz1JozT
	OlP76rh6mkoOT/piHMsV5ubC6DRs1gvlDegcNVpXFT/QgZUS9BGYuLtpBAivD2OWEgu1U1d1
X-Received: by 2002:a05:690c:d88:b0:797:d7a8:c540 with SMTP id
 00721157ae682-798dd6b3e9cmr104166207b3.26.1773052703456; Mon, 09 Mar 2026
 03:38:23 -0700 (PDT)
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260308213116.7E884C116C6@smtp.kernel.org> <aa6ZrCZoEYgsPXka@redhat.com>
In-Reply-To: <aa6ZrCZoEYgsPXka@redhat.com>
From: Deepanshu Kartikey <kartikey406@gmail.com>
Date: Mon, 9 Mar 2026 16:08:11 +0530
X-Gm-Features: AaiRm51hNj-AFGnKqhLbYe8DDZ9RYDSgKSF5XQQrbdVnMc7oHyeFGGWqPOokc7c
Message-ID: <CADhLXY6zH2A88dSDeTdsQJ77dEOPX5fkHu7PvhKL1beXGxs6Tw@mail.gmail.com>
Subject: Re: + kernel-fork-validate-exit_signal-in-clone-syscall.patch added
 to mm-nonmm-unstable branch
To: Oleg Nesterov <oleg@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, mm-commits@vger.kernel.org, 
	vschneid@redhat.com, vincent.guittot@linaro.org, surenb@google.com, 
	stable@vger.kernel.org, rppt@kernel.org, rostedt@goodmis.org, 
	peterz@infradead.org, mingo@redhat.com, mhocko@suse.com, mgorman@suse.de, 
	lorenzo.stoakes@oracle.com, liam.howlett@oracle.com, kees@kernel.org, 
	juri.lelli@redhat.com, dietmar.eggemann@arm.com, david@kernel.org, 
	bsegall@google.com, brauner@kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Mar 9, 2026 at 3:28=E2=80=AFPM Oleg Nesterov <oleg@redhat.com> wrot=
e:
>
> On 03/08, Andrew Morton wrote:
> >
> > From: Deepanshu Kartikey <kartikey406@gmail.com>
> > Subject: kernel/fork: validate exit_signal in clone() syscall
> > Date: Sat, 7 Mar 2026 12:12:02 +0530
> >
> > When a child process exits, it sends exit_signal to its parent via
> > do_notify_parent().  The clone() syscall constructs exit_signal as:
> >
> >   (lower_32_bits(clone_flags) & CSIGNAL)
> >
> > CSIGNAL is 0xff, so values in the range 65-255 are possible.  However,
> > valid_signal() only accepts signals up to _NSIG (64 on x86_64), causing=
 a
> > WARN_ON in do_notify_parent() when the process exits:
> >
> >   WARNING: kernel/signal.c:2174 do_notify_parent+0xc7e/0xd70
>
> Aaah. Thanks Deepanshu! My bad, please see below.
>
> > The comment above kernel_clone() states that callers are expected to
> > validate exit_signal.
>
> Yes, and man 2 clone says:
>
>       The termination signal is specified in the low byte of flags (clone=
()) or in cl_args.exit_signal (clone3()).
>       If no signal (i.e., zero) is specified, then the parent process is =
not signaled when the child terminates.
>
> it doesn't document that nonzero non-valid signal acts as .exit_signal =
=3D=3D 0.
>
> > --- a/kernel/fork.c~kernel-fork-validate-exit_signal-in-clone-syscall
> > +++ a/kernel/fork.c
> > @@ -2800,7 +2800,8 @@ SYSCALL_DEFINE5(clone, unsigned long, cl
> >               .stack          =3D newsp,
> >               .tls            =3D tls,
> >       };
> > -
> > +     if (!valid_signal(args.exit_signal))
> > +             return -EINVAL;
> >       return kernel_clone(&args);
>
> Well, kernel_clone() has more users which doesn't validate .exit_signal,
> say sys_ia32_clone().
>
> we need to move the valid_signal() check from copy_clone_args_from_user()
> to kernel_clone() or copy_process()...
>
> So. This should fix my
>
>         [PATCH] do_notify_parent: sanitize the valid_signal() checks
>         https://lore.kernel.org/all/aZsfg0Y055yuAvsq@redhat.com/
>
> do_notify_parent-sanitize-the-valid_signal-checks.patch in -mm tree.
>
> Somehow I was very sure that copy_process() paths already have the valid_=
signal()
> check but my memory fooled me.
>
> But this is a user visible change which can cause other bug reports...
> Perhaps we should revert do_notify_parent-sanitize-the-valid_signal-check=
s.patch
> and this patch?
>
> Even if I think that the new valid_signal() check "fixes" the undocumente=
d
> behaviour, unlikely there is a sane application which passes non-valid ex=
it
> signal to sys_clone(). But who knows...
>
> Oleg.
>

Hi Oleg,

Thank you for the review.

You are correct that fixing only the clone() syscall is incomplete.
sys_ia32_clone() and other kernel_clone() callers would remain
unprotected. I will send a v2 with the valid_signal() check moved
to kernel_clone() to cover all callers.

Regarding your do_notify_parent patch =E2=80=94 since v2 will fix the root
cause at kernel_clone(), your patch in the -mm tree can be dropped.

Regards,
Deepanshu Kartikey
