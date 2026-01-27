Received: from mail-ed1-f47.google.com (mail-ed1-f47.google.com [209.85.208.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23797283FFB
	for <mm-commits@vger.kernel.org>; Tue, 27 Jan 2026 21:37:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769549867; cv=none; b=L8d5Y7nT+MBGyiVMmYHIaAQcBxwam4MFVybIU/dtgWid+m7jAtMZsH4wTsJzTFZHf0Js8LgsUTTtpXrTm8Ua3hnP61p7KXaxneqnOtYWNIEUCqHrEkK5F232X7gdfLV9baTpetgyQI3XO0d6nOkDfn27J/9OzYMlA6LyDPl6ZlM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769549867; c=relaxed/simple;
	bh=k24rl2pwV9S8wdx5Q4EogcGa3+wRhwsfuFNfVIXD2zU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=HFPpvCQJPmTt5BbsXvccXgtgRijBi3mf7xzPAYZEacSyaIhHlwnC5A4Q3vAiE+dl9aF/7/6ED48DJf4b5m6sKD1lsaZ+caZ/6S8yG24T+tY2vokjiHJmmSF72LPjbcu0qdsmF69sEjQXhK7ei6cNdec62tN/3ZGM19/b2U8qu/s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org; spf=pass smtp.mailfrom=chromium.org; dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b=MDa8iGtn; arc=none smtp.client-ip=209.85.208.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chromium.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="MDa8iGtn"
Received: by mail-ed1-f47.google.com with SMTP id 4fb4d7f45d1cf-64b791b5584so9159230a12.0
        for <mm-commits@vger.kernel.org>; Tue, 27 Jan 2026 13:37:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1769549862; x=1770154662; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=RxlQ2VzYf/wW3fAaLmPPug/KF1BdVRcmQSMFTpedgt8=;
        b=MDa8iGtn+BFB5NWhX5JY9J4tHEGcIcWD8pjpYgikefJ7lFYRFsWzvxCDwEUfHKL9UB
         kGf2qqitQ6hYcQ88RU/qNClUT5fF5/5P2YwnDDbFluqEqINecC3GnwxST5u5q2UJ0Q7z
         wl9huOTUJLTaulEWuj7SdgKR3K6KEQbg3j8Bk=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769549862; x=1770154662;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=RxlQ2VzYf/wW3fAaLmPPug/KF1BdVRcmQSMFTpedgt8=;
        b=vOF984LjgvbRFoHdkYzMiRPDMPibne7Ry9HIF+1LIuwhTgK7PVY/KuG7j/mn0+O7JV
         INydl3vM2YUB99nY+GW37Roja3eDwYI8k+Lm9bPPolAWtQ0U0Fu0VoBitZmGqOR64Rqu
         mvpnEHC3mh1snlxRh0AjRIrSrCPt/QefzgplViNdNQ2urBoJFcCV8fZ3Gm6MMBdHIEEn
         dkA/IrodVYQT++b6GXA7xJ7AwWzI1YPDKK3cVdyG5DrHhKdue1P+dIxo4o2FrU2tzvPh
         RE6P/isSTE19VXTbwAqiwcbWTwaGqFdOrwIXI1ieiITerSJxO1M8zhkbN7obmVfQCftq
         BJIw==
X-Forwarded-Encrypted: i=1; AJvYcCUl5fsabasdCnTJ4EHLiWD+9FXRUcKNWBQcolRrBncGXXnAsO15/O8SWzLx4HNZMCO44YJkLOduIv9E@vger.kernel.org
X-Gm-Message-State: AOJu0YzzBJkdZRcWcIaRyumthiZFZcoYnxVxrlfe/nJ5qH8rjIB/j6K0
	JDWAVHCJeT8+2D8TExfOqnWhiEI2P7/DT2sbM4C2pfzVZg0jxCEWpy0FJYqXqkEcCLk5xa0cKov
	RhnZaEQT7
X-Gm-Gg: AZuq6aIhQsI8ygGSUV6CYluFg0QspPdfuc0zwPCa/5oLB/qIzyq6mvh/kZ8qS5aG5pW
	EFwRfTTPK/EjcbAcpbLC9kv0oTjNX757MwlSHhOrDf32PprNUcYhNMk6/MOIFos2aUHz3JfA3dM
	VaLEIMlgAzcD6Hsa4VD7McN1ysVm2kToOD58mvMPZzOPZ/W0CEHkrwvLmYQcsvuf+wWoWB2D/Av
	1ux7/CwiH2i+ihWvr19ZUjl0lxoxEJhm4ZuPU9ms1O5qD2ZH1EfcIDCSHL+p46+BxYJeAdoyXSv
	/Hd220bUYrAr9nD4K1Em2UR1DX53P3Oy+XnE1Sn46H15Mof35g3i93KYwwunhMS6Z75h6Pg9m8W
	NzjsxO0b9HZd1Ke8UFmD7IOUY6intae9EmkFQ6WxdnL+akcq6QFs+6TsL4GOSOsqSzAbzDwCCyo
	I2DpGhc2kYsCm6pDOJqH6rzUssbkJ00WI8PJ0Jh5se27jaWw+GLp+agI1brt5m
X-Received: by 2002:a05:6402:4504:b0:640:a9b1:870b with SMTP id 4fb4d7f45d1cf-658a6053beemr1939459a12.14.1769549862133;
        Tue, 27 Jan 2026 13:37:42 -0800 (PST)
Received: from mail-wm1-f41.google.com (mail-wm1-f41.google.com. [209.85.128.41])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-658b4691dbfsm431207a12.20.2026.01.27.13.37.40
        for <mm-commits@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 27 Jan 2026 13:37:40 -0800 (PST)
Received: by mail-wm1-f41.google.com with SMTP id 5b1f17b1804b1-47ee07570deso47523625e9.1
        for <mm-commits@vger.kernel.org>; Tue, 27 Jan 2026 13:37:40 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCWMs1aqVigqLBdF3FsawPhVbCFDr6+LfKLclnyVzQKNeDHNJ5B61zvMuICJG1pR9TSfG12lnTsUDJOD@vger.kernel.org
X-Received: by 2002:a05:600c:4fd4:b0:47e:e807:a05a with SMTP id
 5b1f17b1804b1-48069c98d9fmr34891525e9.33.1769549859984; Tue, 27 Jan 2026
 13:37:39 -0800 (PST)
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAD=FV=WVtFAPZ3=6pPnOV=vbMhFwfH9LaZ5oNgAKtcj5hA0q2Q@mail.gmail.com>
 <20260127021711.1180952-1-realwujing@gmail.com>
In-Reply-To: <20260127021711.1180952-1-realwujing@gmail.com>
From: Doug Anderson <dianders@chromium.org>
Date: Tue, 27 Jan 2026 13:37:28 -0800
X-Gmail-Original-Message-ID: <CAD=FV=U6sM71UuPbYZRWV87=p1ZO8-gpv3yzK8eMEv3dRNVgdA@mail.gmail.com>
X-Gm-Features: AZwV_QiU8gpalCQDsUTyyF4ZWe7CLPzTE1Lpz8wLHzb0knYx6-2dFCpdGvU65rM
Message-ID: <CAD=FV=U6sM71UuPbYZRWV87=p1ZO8-gpv3yzK8eMEv3dRNVgdA@mail.gmail.com>
Subject: Re: [PATCH v4] watchdog/hardlockup: Fix UAF in perf event cleanup due
 to migration race
To: Qiliang Yuan <realwujing@gmail.com>
Cc: akpm@linux-foundation.org, lihuafei1@huawei.com, 
	linux-kernel@vger.kernel.org, mingo@kernel.org, mm-commits@vger.kernel.org, 
	song@kernel.org, stable@vger.kernel.org, sunshx@chinatelecom.cn, 
	thorsten.blum@linux.dev, wangjinchao600@gmail.com, yangyicong@hisilicon.com, 
	yuanql9@chinatelecom.cn, zhangjn11@chinatelecom.cn
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi,

On Mon, Jan 26, 2026 at 6:17=E2=80=AFPM Qiliang Yuan <realwujing@gmail.com>=
 wrote:
>
> Hi Doug,
>
> Thanks for your insightful follow-up! It's great to have the openEuler vs=
. Mainline
> timing differences clarified=E2=80=94it definitely explains why we hit th=
is so reliably
> in our downstream environment.
>
> On Mon, Jan 26, 2026 at 5:14 PM Doug Anderson <dianders@chromium.org> wro=
te:
> > OK, so I think the answer is: you haven't actually seen the problem
> > (or the WARN_ON) on a mainline kernel, only on the openEuler 4.19
> > kernel...
> >
> > ...actually, I looked and now think the problem doesn't exist on a
> > mainline kernel. Specificaly, when we run lockup_detector_retry_init()
> > we call schedule_work() to do the work. That schedules work on the
> > "system_percpu_wq". While the work ends up being queued with
> > "WORK_CPU_UNBOUND", I believe that we still end up running on a thread
> > that's bound to just one CPU in the end. This is presumably why
> > nobody has reported that "WARN_ON(!is_percpu_thread())" actually
> > hitting on mainline.
>
> You are right that in the latest mainline, schedule_work() has been updat=
ed
> to use 'system_percpu_wq'. However, in many LTS kernels (including 4.19),
> schedule_work() still submits to 'system_wq', which lacks the per-cpu
> guarantee.

Really, it matters what schedule_work() does on anyone who happens to
have commit 930d8f8dbab9 ("watchdog/perf: adapt the watchdog_perf
interface for async model")... While I can sympathize with supporting
older kernels and doing backports, we have to focus on supporting the
mainline kernel here. If we're claiming that we're fixing a bug (and
even your newest CL says it's fixing a UAF and has a Fixes tag) then
the bug has to actually be there.


> More importantly, even on 'system_percpu_wq', the worker threads do not
> carry the PF_PERCPU_THREAD flag. is_percpu_thread() specifically checks
> (current->flags & PF_PERCPU_THREAD), which is reserved for kthreads
> specifically pinned via kthread_create_on_cpu().

I think we need to keep the focus on mainline or at least the kernel
as of commit 930d8f8dbab9. The grep for "PF_PERCPU_THREAD" has no hits
in either. In both cases, it is:

return (current->flags & PF_NO_SETAFFINITY) &&
    (current->nr_cpus_allowed  =3D=3D 1);


> Therefore, the
> WARN_ON(!is_percpu_thread()) in hardlockup_detector_event_create() is
> still violated in the retry path even on mainline.

To ask directly: have you seen this WARN_ON in mainline, or is this
all speculative?

I'm going to assert that the WARN_ON is _not_ seen on mainline and
wasn't there as of commit 930d8f8dbab9. Specifically, the same set of
patches that added the "retry" for the hardlockup detector had the
WARN_ON(). It feels highly unlikely the WARN_ON was firing at that
point in time. You can see the whole series of patches at:

https://lore.kernel.org/linux-arm-kernel/20220903093415.15850-1-lecopzer.ch=
en@mediatek.com/

...yes, I ended up rebasing them and included them when I landed the
buddy lockup detector where they landed, but they should have been
equivalent to Lecopzer's patches.


> The UAF risk stems from the fact that preemption is enabled during the
> probe. If the worker thread (even if on a per-cpu wq) is preempted or
> if the logic assumes the task cannot migrate (which is_percpu_thread
> usually guarantees), we have a logical gap. By making the probe path
> stateless and using cpu_hotplug_disable(), we eliminate this dependency
> entirely.
>
> > If that's the case, we'd definitely want to at least change the
> > description and presumably _remove_ the Fixes tag? I actually still
> > think the code looks nicer after your CL and (maybe?) we could even
> > remove the whole schedule_work() for running this code? Maybe it was
> > only added to deal with this exact problem? ...but the CL description
> > would definitely need to be updated.
>
> The schedule_work() in lockup_detector_retry_init() (added by 930d8f8dbab=
9)
> is necessary for platforms where the PMU or other dependencies aren't rea=
dy
> during early init.
>
> I agree that the commit description should be updated to clarify that
> while the issue was caught in a downstream kernel with shifted init timin=
gs,
> it identifies a latent race condition in the mainline retry path.
>
> Regarding the 'Fixes' tag, since 930d8f8dbab9 introduced the asynchronous
> retry path which calls the probe logic from a non-percpu-thread context,
> it still seems like the appropriate target for the "root cause" of the
> vulnerability.
>
> I'll refactor the commit message in V5 to better reflect this context
> and remove the emphasis on ToT being "broken" out-of-the-box (since early
> init is indeed safe there).
>
> How does that sound to you?

I'm still not convinced that there was ever a UAF in mainline nor that
this actually "Fixes" anything in mainline. I do agree that the code
is better by not having it write the per-cpu variable at probe time,
but unless you can say that you've actually tested _on mainline_ and
demonstrated that the WARN_ON() is truly hitting _on mainline_ by
providing a printout of it happening _on mainline_ or somehow shown
the UAF actually happening _on mainline_ then we simply can't claim
that this is a Fix. Although I supposed I'd also be OK with doing any
of the above on any pure upstream kernel after commit 930d8f8dbab9, as
well.

-Doug
