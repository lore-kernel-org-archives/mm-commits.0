Received: from mail-pj1-f50.google.com (mail-pj1-f50.google.com [209.85.216.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CFA0F326922
	for <mm-commits@vger.kernel.org>; Thu, 29 Jan 2026 22:13:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.216.50
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769724787; cv=pass; b=lPgq9hSCGu/YG4C/M1UPZqY51Bl3JoCykv+0pnogRLM3cg8QvnbYgieN0C5oZyypg8mNEGdIwCyxrWIBT59MEY7mQP6jJhBmPysEoIgpp/G6V27Sha/iXTp93SOJwgsNKbWlbYcfhdjhvGOws8SPMWoJ1CQQ2+aaQMwoiMU7raY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769724787; c=relaxed/simple;
	bh=X6TtmoAyVY2MGvdbYZvc3762hVQwPWUCU74JQXjBH9k=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=k+YAcAlfOT+iZcidm4reJ9823+3NQT41Yi1PNGzOXImoKvFl2+8Yd+wpknhD1D9ywqjITCJe+gUGBlf1sRpiUIevEdbbKM1QCj9LskZkU7RFqFJ8IngGrM21nZWPKK/38Scy+Uv7usnGDOHDQiSrTsI6X/ZZYwdTan56pFLhMP8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=b02onhOr; arc=pass smtp.client-ip=209.85.216.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="b02onhOr"
Received: by mail-pj1-f50.google.com with SMTP id 98e67ed59e1d1-3540266d356so876932a91.0
        for <mm-commits@vger.kernel.org>; Thu, 29 Jan 2026 14:13:05 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1769724785; cv=none;
        d=google.com; s=arc-20240605;
        b=B4Otx8TmfKquOVGmTYhbl3DSDOlzmxtm9Y4tEC5kLOB8eo15fdogMhqeZkaOvXehQt
         L5OUAY4ZTH4dE3lnykaongIjPXFW00AeMY8TGwlmzMNqrI9Uav66kFbBRGXelAmIcuBv
         p9d8EQqjMMjf6UqBrCnOYzhDcCIiMuG0pn+pQ4FVHouiNFnOURoT2i8qhHnBmj8wKHr8
         wufsGXdRMUtY6Jd1p+hA81Sh2hWC06HSvGIrQEHYCAZ/uGg/e/kcZ6VhaFycQHKvUjQU
         KrKK5HCxdGUcm9vDQACheMX7qsEPcmDLMXivfDfOtHAr2feRKRD8tBTfAEzzh3XLblI/
         iLhg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=z1nBp37qmsnlCFlqK6lF3t88pdL41dsBdFbvRYv4Yk0=;
        fh=PUSpXdoXMIq6onXTgUG2douwWi54f67ml0kAxs1sdtc=;
        b=RVrDJnGLycgMN9mJAAUKF5jrKvUDRYEd0jd/5BCM5cNm6AHIXQCUywQXjLlDZCReMm
         l2Kjtw1i22ePTAkZSZJ6vBJj7Zzb3RNOu/dlGvBek3UoYOR7WHb1RKfViIRB/D8PAq+d
         pG7OXJNKftUZZFfykHJkEzQDkLIRSynsM5XqJx/+QiJ+GgFuDq9IDFdK62Pe4zk60NvY
         hEieDAsB7VStWx5IGoLjG22IEnqzhklP/amL0a8CIinlxrkh1UDY687pExbUJryHzTk7
         Eq+FcULU2HfKrzqyyLAggzC37n5BHfOk6aRuWiTSstUi/8ua/rJNeLikvAhF2jhsH67W
         2BYQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1769724785; x=1770329585; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=z1nBp37qmsnlCFlqK6lF3t88pdL41dsBdFbvRYv4Yk0=;
        b=b02onhOrDmIrflr4da9qH4T4QLTQi3FyOVOLQ1+J5tIyVaw+6V3xuM5xnvtjVmE7ax
         jLjMDjJuzgjfDevbieNHDNJLMaHfxY6RV8GMqjcd2xIn3FmU+iY/gSjjGldIgHK7vGUS
         nBpaPIBMPcMwuQlwTTNnkT8kAzy4PEfN6c6ICIzqFBwYbrzsZOm4Iv4zj41FLTQQt2EX
         /XVNuWyUCcf+4p9YtBdJYIpGLFahPDPzmmBlrrmx0en1K1o9/wZw9n8OdRIXab1NRYLt
         3h5uRjtGYAiBEAbtzM7ee1s9SvsjUsnC/XuggtZX7OTEOwtlo47HT5QvZKEFalOnlkV4
         Whew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769724785; x=1770329585;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=z1nBp37qmsnlCFlqK6lF3t88pdL41dsBdFbvRYv4Yk0=;
        b=GgF31PxVq+j+6CU5E1Mek3ts3XUXKNiSW11jNaunq+6nPhHr/4Qrk0EMJGPgi/U9OT
         AZE/Fd/B1/pmnlOQNK1tiUtbHuei2yBR7uXZGR0T1bbBUzGw0pz4lGHtqakbKWGt0iY8
         oEqE1xfsEUVTyaBFXr4r1HbAuRkndWi79BHxHAT7hiF7+uz2cZIzF6kwplwNM3whvJvb
         Wr9uYPM7O63qRncMIc2xhY/koH/8CKKkplwao0lEGb5l3kpHcSh5BuG1y+Oba0THODSE
         NG4cPRMcf0yuk5EkMBzUtvmZq15ibYXXA6WsfR635c5lFCi56Xqs3w8uvIiDVWx2y9T4
         mWQA==
X-Gm-Message-State: AOJu0YxZ/yeVyvy8g9rBdbaR4kQbJUW8bF8aPyrGWHweDaV8eaqOCxVU
	uVDXmk7BeRjVUwF4P8j/Im+6UBUxBGvqvwSUHTL8rnK2TGcSKGRIYYd7lpE6UuU5j/U1tapQeWv
	VTAXc0KxrqMJKU/VwqUI+3n6PU1ULIeQ39A==
X-Gm-Gg: AZuq6aKgkbe11GBYDZ97Ntvr/21UKXAArq5t/4Twxyh7W/AsRQA7rSK+CxUFab7fBu2
	7AF7Xqn+MXBSF6f42wvBgQtw2VDzatZeIU3ZorkWFjaRftmZftjI27o8+Fyu+90gMA8O5QWJ6vc
	0BFxzC5l2Qx15nxR4WQSIvYFSjU0FCgcqAhzraO8QmUns1Vz3M2EqU/eJKtCOZWR9mG+UKzp0zt
	QsTm0peOZjNmKjw2/9qCjffPaeeOiA9/rDA6MbR7zH2v+mI4/z0VUB6O2gzBaVwhS4lcSMGpPnf
	yB3nMnS1XRA=
X-Received: by 2002:a17:90b:56ce:b0:341:ae23:85fd with SMTP id
 98e67ed59e1d1-3543b315807mr754283a91.11.1769724785101; Thu, 29 Jan 2026
 14:13:05 -0800 (PST)
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260129215650.3B361C4CEF7@smtp.kernel.org>
In-Reply-To: <20260129215650.3B361C4CEF7@smtp.kernel.org>
From: Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date: Thu, 29 Jan 2026 14:12:52 -0800
X-Gm-Features: AZwV_QgFuTJz8Ge68RW3caJMvNBSM9bfI6AXNYkBa0joMwgYa1caEW2vBwzOg1k
Message-ID: <CAEf4BzYCeubZrfnX=CZuL0g42MiS9FvsyenemfiSyf1e1WtZ_Q@mail.gmail.com>
Subject: Re: + procfs-avoid-fetching-build-id-while-holding-vma-lock-fix.patch
 added to mm-nonmm-unstable branch
To: Andrew Morton <akpm@linux-foundation.org>
Cc: mm-commits@vger.kernel.org, surenb@google.com, mykyta.yatsenko5@gmail.com, 
	Liam.Howlett@oracle.com, andrii@kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Jan 29, 2026 at 1:56=E2=80=AFPM Andrew Morton <akpm@linux-foundatio=
n.org> wrote:
>
>
> The patch titled
>      Subject: procfs-avoid-fetching-build-id-while-holding-vma-lock-fix
> has been added to the -mm mm-nonmm-unstable branch.  Its filename is
>      procfs-avoid-fetching-build-id-while-holding-vma-lock-fix.patch
>
> This patch will shortly appear at
>      https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree=
/patches/procfs-avoid-fetching-build-id-while-holding-vma-lock-fix.patch
>
> This patch will later appear in the mm-nonmm-unstable branch at
>     git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
>
> Before you just go and hit "reply", please:
>    a) Consider who else should be cc'ed
>    b) Prefer to cc a suitable mailing list as well
>    c) Ideally: find the original patch on the mailing list and do a
>       reply-to-all to that, adding suitable additional cc's
>
> *** Remember to use Documentation/process/submit-checklist.rst when testi=
ng your code ***
>
> The -mm tree is included into linux-next via various
> branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
> and is updated there most days
>
> ------------------------------------------------------
> From: Andrew Morton <akpm@linux-foundation.org>
> Subject: procfs-avoid-fetching-build-id-while-holding-vma-lock-fix
> Date: Thu Jan 29 01:54:41 PM PST 2026
>
> fix kerneldoc, per Mykyta Yatsenko
>
> Cc: Andrii Nakryiko <andrii@kernel.org>
> Cc: Liam R. Howlett <Liam.Howlett@Oracle.com>
> Cc: Suren Baghdasaryan <surenb@google.com>
> Cc: Mykyta Yatsenko <mykyta.yatsenko5@gmail.com>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> ---
>
>  lib/buildid.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> --- a/lib/buildid.c~procfs-avoid-fetching-build-id-while-holding-vma-lock=
-fix
> +++ a/lib/buildid.c
> @@ -315,7 +315,7 @@ out:
>         return ret;
>  }
>
> -/*
> +/**
>   * Parse build ID of ELF file mapped to vma
>   * @vma:      vma object

there was also @vma -> @file rename as pointed out by Yonghong.

>   * @build_id: buffer to store build id, at least BUILD_ID_SIZE long
> _
>
> Patches currently in -mm which might be from akpm@linux-foundation.org ar=
e
>
> mm-add-wq_percpu-to-alloc_workqueue-users-fix.patch
> mm-add-wq_percpu-to-alloc_workqueue-users-fix-fix.patch
> sparc-mm-export-symbols-for-lazy_mmu_mode-kunit-tests-fix.patch
> mm-vma-document-possible-vma-vm_refcnt-values-and-reference-comment-fix.p=
atch
> mm-vma-introduce-helper-struct-thread-through-exclusive-lock-fns-fix.patc=
h
> mm-pagewalk-use-min-to-simplify-the-code-fix.patch
> mm-relocate-the-page-table-ceiling-and-floor-definitions-fix.patch
> mm-update-shmem__file_-functions-to-use-vma_flags_t-fix.patch
> procfs-avoid-fetching-build-id-while-holding-vma-lock-fix.patch
>
