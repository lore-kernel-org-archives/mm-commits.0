Received: from mail-oa1-f44.google.com (mail-oa1-f44.google.com [209.85.160.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42A308F58
	for <mm-commits@vger.kernel.org>; Fri, 11 Oct 2024 00:47:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728607674; cv=none; b=Bb48TSw9JRBMtJakyzsJM6bb2P/BnI8WNu01BB/pLi6jNyVPMXnOC8itRcY3quBOP5ezVYz4W8fsyQLrPA8R2jNoS7fMMx1GwaR9x+ezr3VYtBtynek5D9jRKsLfMWbY8Sk0l2cdfoAClDTbPUgQTEMJKoN78eQIa2bwBg4xMco=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728607674; c=relaxed/simple;
	bh=YXZC/xILfqEZt5HVALsKvNoWNiGPKuExqB9dXzySfJE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ERIIKxubr2OH+YXvPkG1774BE2xpzcBKIOSezNRUVEy4YRzoNVeWX75fUIohwL0Qbhgd1GOx7uc2zRAEtehAJmJJJkw1V4uIToJD5qacNdBhmsmFx94Mm7I5QUfUbH7rYxbiiNQe8JaZoczNqtm9YXXgW8+JBfnwWZfadNe2vaQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org; spf=pass smtp.mailfrom=chromium.org; dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b=k1JN5rQg; arc=none smtp.client-ip=209.85.160.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chromium.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="k1JN5rQg"
Received: by mail-oa1-f44.google.com with SMTP id 586e51a60fabf-2886681064dso48756fac.0
        for <mm-commits@vger.kernel.org>; Thu, 10 Oct 2024 17:47:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1728607672; x=1729212472; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Bn1a3vfGprQ6jHE2fCMpsiG1q1d5rCJ/EvaBpPewgco=;
        b=k1JN5rQg60yFn5d9L0bMVRMK1Bfdm9NPGZxuo398267QwBbfSI1DVMKDRmCT3ezcIj
         cvfAWbkEIizssslSKa9nowgkdcnACDARZsEs5JjYb7qZ0HVC/EVORFQqlLTapl+r6rld
         brIMeEm9bHUljHnZQ+mxA+jpZFC10tYtn3Uc4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728607672; x=1729212472;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Bn1a3vfGprQ6jHE2fCMpsiG1q1d5rCJ/EvaBpPewgco=;
        b=Q2G0ymsGPVrYPbTPSbj07z2sIPlLgHFzuEmHLcZQauBPMBBFS1iO8aMGzmpW97PtxC
         1W/BrTrCgoyIyjnFBtynhLA/jIv3H717Nn2QnDk7buedZ1eEHTmfqR3rJifeCkeaZVGj
         Mx+g1JZT0pz8Fy1/iOUa0+Xotnwzu91BIASe7FZ4PqF4F/7aNn0fXtuAaF9EQK9+KbOB
         DrblkJrS1m8Ywzmm366SIALYdv4UdINNGPC+cueg3Mp9/MSpK9EV293F+rZzWI1fe4Im
         V5IJheWGrxj6KRTYl+u8zzbZgyyaGddKnLYsm2bfKyQtGBpJgkNKUu28jY7JwFVAeAx7
         dQQA==
X-Forwarded-Encrypted: i=1; AJvYcCW7YVOL1zD+ht7qxtcYndjAGtTlInLGBJ2qIIhttJyL5UWf9SdZkpK1cYgVNvLCtyEQ7S79jlNeqgHL@vger.kernel.org
X-Gm-Message-State: AOJu0YzUqtnwhg9qYGoUvGz50eF9MZNkHmk2eRqm83VXcz5kg9QUH+bO
	8PI9YoMGz2ZL9mQKzMshpJvzXj7PkcHcorkWdKIArfgl4rj0JAiGIqgzwuuF6mVzt8UUuslTF3G
	7AUSAcvVusFDRuf0dsW7sKMQd9Xx0FODG7/E3
X-Google-Smtp-Source: AGHT+IHU7+cZVcoaaSzV/HAXMhboZzCx/5kzNDi13fk6fM5x2j8qZn/lKU1dezetbrm8KEIxncCLOYVqZU3FThROGU8=
X-Received: by 2002:a05:6870:a10b:b0:27b:9f8b:7e49 with SMTP id
 586e51a60fabf-2886dffb190mr227880fac.11.1728607672281; Thu, 10 Oct 2024
 17:47:52 -0700 (PDT)
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <f3c123e0624a07e0@cvs.openbsd.org>
In-Reply-To: <f3c123e0624a07e0@cvs.openbsd.org>
From: Jeff Xu <jeffxu@chromium.org>
Date: Thu, 10 Oct 2024 17:47:40 -0700
Message-ID: <CABi2SkWb91FZYrVgcT5j9BzkrEYvPZQS3LjKdAXgMxeqGwh-aw@mail.gmail.com>
Subject: Re: + mseal-update-msealrst.patch added to mm-hotfixes-unstable branch
To: Theo de Raadt <deraadt@cvs.openbsd.org>
Cc: akpm@linux-foundation.org, corbet@lwn.net, deraadt@openbsd.org, 
	enh@google.com, gregkh@linuxfoundation.org, groeck@chromium.org, 
	jannh@google.com, jorgelo@chromium.org, keescook@chromium.org, 
	Liam.Howlett@oracle.com, lorenzo.stoakes@oracle.com, 
	mm-commits@vger.kernel.org, pedro.falcato@gmail.com, rdunlap@infradead.org, 
	sroettger@google.com, surenb@google.com, torvalds@linux-foundation.org, 
	usama.anjum@collabora.com, willy@infradead.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Theo

On Tue, Oct 8, 2024 at 12:01=E2=80=AFPM Theo de Raadt <deraadt@cvs.openbsd.=
org> wrote:
>
> >-Additional notes:
> >-=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> > As Jann Horn pointed out in [3], there are still a few ways to write
> >-to RO memory, which is, in a way, by design. Those cases are not covere=
d
> >-by mseal(). If applications want to block such cases, sandbox tools (su=
ch as
> >-seccomp, LSM, etc) might be considered.
> >+to RO memory, which is, in a way, by design. And those could be blocked
> >+by different security measures.
> >
> > Those cases are:
> >
> >-- Write to read-only memory through /proc/self/mem interface.
> >-- Write to read-only memory through ptrace (such as PTRACE_POKETEXT).
> >-- userfaultfd.
> >+   - Write to read-only memory through /proc/self/mem interface (FOLL_F=
ORCE).
> >+   - Write to read-only memory through ptrace (such as PTRACE_POKETEXT)=
.
> >+   - userfaultfd.
>
> This block of notes keeps bothering me, because I've encountered a bunch
> of people who walk away with "oh but what's the purpose of this thing the=
n
> it is useless".

Maybe if it will help if I  add "Can be blocked by" as below:

   - Write to read-only memory through /proc/self/mem interface (FOLL_FORCE=
).
      Can be blocked by CONFIG_PROC_MEM_RESTRICT_WRITE_ALL, Landlock, etc.
   - Write to read-only memory through ptrace (such as PTRACE_POKETEXT).
      Can be blocked by LSM such as Yama, Landlock, etc.
   - userfaultfd
      Can be blocked by seccomp.

Anyway, mseal is a syscall that I don't expect to be widely used by
applications, only a few places will actually need it,  and I'm
expecting those devs will do necessary work in understanding what
mseal is and if it fits their threat-model.

To this extent, I welcome dev to extend the syscall (there is a
"flags" reserved for such purpose), if they deem it is necessary to
enhance mseal  for their user-cases.

-Jeff
