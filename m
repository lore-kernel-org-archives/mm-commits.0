Received: from mail-ua1-f41.google.com (mail-ua1-f41.google.com [209.85.222.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C0A459150
	for <mm-commits@vger.kernel.org>; Sat, 23 Mar 2024 22:40:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711233651; cv=none; b=u3FuWg4rtiM3XiwXqVe4OPkEblcnLre8zi3TdYG+wcp9vfqCeZ5Chagkza5zYwxPQT5g2UizZYWrTQEylKJJOnjFhoT7cFzJ75Ouzi8RYjbSZuyVWEmxzMcPvVKMzWVGuArBdHoIzLKmXrPUbw5DiNl0iq5ZSKrHA9nkLlVoHvo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711233651; c=relaxed/simple;
	bh=2QIXB00aeEjkGy9iJ1iYLrMOKsK4QSfRinGMFrA+dF8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=KZ97m8IDGRp4wSppnsAR1X8ztV1PZmY7v3d/dEZ42g7qhW9Qu/puyXhRit1imugw0dui+GJ0FhjzZ0D4IhRHh9Ji3kjFYJ9j8el0HW9fAhfu8O2evvvzI4F1idCWYUTzRlHN0a6dTcxOomA8UtBmQY/U2y6f1HQFVHNEgDDuASI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=AlaxcrvY; arc=none smtp.client-ip=209.85.222.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="AlaxcrvY"
Received: by mail-ua1-f41.google.com with SMTP id a1e0cc1a2514c-7e1114ce24fso37032241.0
        for <mm-commits@vger.kernel.org>; Sat, 23 Mar 2024 15:40:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1711233648; x=1711838448; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=j41+aEx3yIl5rp9ZaJeukfF49u+B/Lb69fJNIEcn9S4=;
        b=AlaxcrvYeQOcrmWxO2EJfWTgSgMAIlNm9vf61azWWlhfgbQZrCOoUXqfSHeiwiNV9e
         I2i2Rafw3rZCnZ5n03EX98rvk9purhlMlzbioyRapbydo06+VdmA+AYr6NHtfkZ/WSG3
         DrRdL7LchbGseZZERp7esrHBuGDJFFPZRXYDaJyWkIYSW93AUBMR+zeQSGN5JSRtXqH3
         igN4NW6NVpmOnzx4nxFY6KRC+QCtHhyRKjAkxsVdKAoc7QJSh/0xNAyzVkMe4lTFX6lX
         zdeIwQSXNHKneX1tqhvGVkC7jAbxptK55SaBjuoKHVrXTqxFh9qdDvvG7gTVqvbCqyw+
         vsbw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1711233648; x=1711838448;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=j41+aEx3yIl5rp9ZaJeukfF49u+B/Lb69fJNIEcn9S4=;
        b=UQfBzktmxdrmztOBHVkMI2F2TP5ewi+lvRATdAK+tLlgwrMFN0AROqju7/LLE1NuyB
         EbjdBFBbfPNOtDd2KOvYQvULrlm/HeN6O+qt8tXu6rgJRFzFsL7yMGhHbycV67lDTjUU
         AjGvm+x05ZHINT+Vv3CXxykUr1xixC1wJ93v991Zjq5tYWAbl2EEVO1h10qu32RXVfzW
         blMqqM1ikpA3D452y5gbmoHxNWUpZoRwx3fWMJaGaQmgM8FHWLaSnlCJTA8dro6YCuuV
         68TM4KuTdK1OK/+RwmVstk1ui0RAwNF5bcTsVplJO5/3SxY/b7I49aMEznK+gc0Uz0om
         SNmw==
X-Forwarded-Encrypted: i=1; AJvYcCXuMQ23GCS57OKvB8fuTyVr9qrWfLmgQBxLzK5eFUifACnUg3ThXO9j4a/LfSl0D2TYUC7Jdf7rCxRQFBwjwPhpjEx5U4OmwpBAqw==
X-Gm-Message-State: AOJu0YxfhbKmdpz2Da7yuhIcWDImwrdDblqR9O5qEXp7nq1p6O4vMlPq
	FsUQEWGhUiEXnqDndpxhEhKjVyAv8SgkfLd6WtY+oJ71BJy24eAWx1BrpXMvycW4LGn0u2das29
	VBwFvkm0H+FyjBhJLVUccjN9BAl8=
X-Google-Smtp-Source: AGHT+IFzvQkBpV0i1YvRY7jd2FuLS5EJXlmDNwcgwxg5yg+DKW7UXNvGTzgM+z046pGj9TuIiNzxQGJ2Vf1HuGsZshQ=
X-Received: by 2002:a05:6102:1997:b0:476:c13f:5e1a with SMTP id
 jm23-20020a056102199700b00476c13f5e1amr2898129vsb.6.1711233648327; Sat, 23
 Mar 2024 15:40:48 -0700 (PDT)
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <ea9e38e6f49786ecb88f810a45c65238a2ec5641.camel@perches.com>
 <20240323041401.6335-1-21cnbao@gmail.com> <b92d6a4f17a17cc8586fea9fa72396c22d748d35.camel@perches.com>
In-Reply-To: <b92d6a4f17a17cc8586fea9fa72396c22d748d35.camel@perches.com>
From: Barry Song <21cnbao@gmail.com>
Date: Sun, 24 Mar 2024 11:40:37 +1300
Message-ID: <CAGsJ_4x+je5Tg9a92WXonaGqULQY56-KcijnWdO720qaefuWzw@mail.gmail.com>
Subject: Re: + scripts-checkpatch-check-unused-parameters-for-function-like-macro.patch
 added to mm-nonmm-unstable branch
To: Joe Perches <joe@perches.com>, mac.xxn@outlook.com
Cc: akpm@linux-foundation.org, apw@canonical.com, broonie@kernel.org, 
	chenhuacai@loongson.cn, chris@zankel.net, corbet@lwn.net, 
	dwaipayanray1@gmail.com, herbert@gondor.apana.org.au, jcmvbkbc@gmail.com, 
	linux@roeck-us.net, lukas.bulwahn@gmail.com, mm-commits@vger.kernel.org, 
	sfr@canb.auug.org.au, v-songbaohua@oppo.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, Mar 23, 2024 at 7:16=E2=80=AFPM Joe Perches <joe@perches.com> wrote=
:
>
> On Sat, 2024-03-23 at 17:14 +1300, Barry Song wrote:
> > > > The patch titled
> > > >      Subject: scripts: checkpatch: check unused parameters for func=
tion-like macro
> > > > has been added to the -mm mm-nonmm-unstable branch.  Its filename i=
s
> > > >      scripts-checkpatch-check-unused-parameters-for-function-like-m=
acro.patch
> > >
> > > Conceptually I don't disagree but I wonder what the false
> > > positive rate is.
> >
> > Hi Joe,
> >
> > If your concern is whether this script might produce inaccurate reports=
, I'm confident that
> > the false positive rate is 0%. Xining, please correct me if I'm mistake=
n.
>
> I presume it's low but non-zero.
>
> I think the false positives are going to be
> in some cases where a type is used as a macro
> argument in #ifdef/#else blocks
>
> #ifdef CONFIG_<FOO>
>
> #define foo(bar, baz, ...)              \
> static inline func##bar(baz, ...)       \
> {                                       \
>         bar baz =3D ...                   \
>         ...                             \
> }
>
> #else
>
> #define foo(bar, baz, ...)
>
> #endif
>
> where it's not reasonably possible to use a
> static inline.

I do find some exceptions such as include/uapi/linux/const.h

#ifdef __ASSEMBLY__
#define _AC(X,Y)        X
#define _AT(T,X)        X
#else
#define __AC(X,Y)       (X##Y)
#define _AC(X,Y)        __AC(X,Y)
#define _AT(T,X)        ((T)(X))
#endif


And include/video/trident.h

#if TRIDENTFB_DEBUG
#define debug(f, a...)  printk("%s:" f,  __func__ , ## a);
#else
#define debug(f, a...)
#endif


I'll check if Xining has some approach to detect this kind of ifdef/else/en=
dif,
and remove those false positives.
