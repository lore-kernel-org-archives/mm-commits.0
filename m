Received: from mail-ed1-f47.google.com (mail-ed1-f47.google.com [209.85.208.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B114B27A133
	for <mm-commits@vger.kernel.org>; Sat, 24 Jan 2026 23:36:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769297780; cv=none; b=V5bqvyGOcsImi45K7HRQgrbza+bCONIMo15OGgQNiQDkQBoTim+tsVtfsj/DC1QrrBuh6zX27G+cRaqTudKKIy95ccE3qL/4VlEcccxl8hEsqHw57vWRotdamCv/+N1dbMKj8e/Im+wdIvRurdZmaTo0ZdAJzCgUxT4sAdeT93A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769297780; c=relaxed/simple;
	bh=F7IdeJxEuwyJhlT1kgnXqGZv2HwcrsfzSvPn/0f4rt4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=FunouD+7+VJ35tZsjKOXidL99K/jzlwHX2UkJ3GuzTLNBS3b7klTFukWSd2k9M4hidAGZd4O5zi758uLfI1ZnKzFdWOFhXmrgELiVFwGNxsA5wB8shfwXbhSVFNeTC9XLzqT5itc/5e/ssRlRQGiadtHpG2t88oulJONuhHapxY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org; spf=pass smtp.mailfrom=chromium.org; dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b=jvmrkmAk; arc=none smtp.client-ip=209.85.208.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chromium.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="jvmrkmAk"
Received: by mail-ed1-f47.google.com with SMTP id 4fb4d7f45d1cf-652fdd043f9so6067076a12.1
        for <mm-commits@vger.kernel.org>; Sat, 24 Jan 2026 15:36:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1769297775; x=1769902575; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=F7IdeJxEuwyJhlT1kgnXqGZv2HwcrsfzSvPn/0f4rt4=;
        b=jvmrkmAk52rWWd0yhAPgJfJ6VMS8bkfnl+cVBJ4wJ53EDKKSx8TG+xsGDJ7KH9oEaO
         7SJKE+wq2dYfWCO47z6sW6ko/XPDF8zXn4VvNzo9RsloSd3QHFH91m7wOEaNLZNdKJ2l
         +gsQmm+tuT4xAiPtbGI3MObJ+gz5a2eZIRLE0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769297775; x=1769902575;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=F7IdeJxEuwyJhlT1kgnXqGZv2HwcrsfzSvPn/0f4rt4=;
        b=IlhMsLVUCRJsoi/Lh3o3TGQ5w5jQLhyW40E4aoHA7NWv/w/AVq2xHbeloh+elop3N0
         06Hgnr8J9vTnGtw02TCOui0QH5O7kCjGz7mqmTrHT5uXADkchrW8x0L3ROQuHL18o3vQ
         FhPZ8faatV3io+zZN7Taakgnqp5mku1XI17+Ql/jAra2hiS4uA/a2E8PkmtiVA8UkNB+
         FZctPf64Mw8kR/voNEEyrHmnT9SsBnxTCDFY4vRVyz3fYifYp2DbGW2NSyVQq8F9drUu
         HEmnai6AxpmTsdjsyEsvE5dCv15wIYBmLCC272488UPSK3gfUtfIKLf8tidh7ty750PM
         7tkw==
X-Forwarded-Encrypted: i=1; AJvYcCV0bO5gotGpcB8neKJ8vxZfim1+Mo36rLv3SeiTIYV1SqBKx5s+2QORtv/xIaa+aB7/xo1HyXhOiLlF@vger.kernel.org
X-Gm-Message-State: AOJu0Yw0sGC5hwmU1/MNeOgTanqxUv8ico92fKczvBK30bkxVvxZ0QB4
	2YOYc8QG2zE+0QErG/5GIT6mXfmYLJ1WkRidFdgv0H30VuNtFVh6+joPOx557LvQL0KP4fqY2SB
	HLxX0xw==
X-Gm-Gg: AZuq6aKfyIcZF7j1Mcflhspmmx75WAB1/Qqet5Xs76dXmHd2CQWkt0OyChfAdaP0FGr
	d4IYI8ddYLU2gEk3pJNfVMEoX1bfx/PQ+sMabjxPz7LUtXARgSBBTpQEwAPFUKv9UzcUrypa2/e
	zE6f3iaY5smRMJVbFZ0DPby2Q760h3s/mSVMqdwYPyHXriAZgEWIzHyo6HPHY5/2tBg1C7WeLMC
	k8fQdA+WnW+EvUzOFikaiXT4VxVrCXQw11Yj6Gz4ZCVFx1dOBoONSdgqhRGmjW/wu9R0ro3nVZM
	YN2muqQqDyeXqEM945M/bALYmulqDLzIcGOH0Olni+Sdy2FT3epP4T9iLGn9t4SMFEEzjYaxbo/
	NpAT7Y04tEtA/rTvFz+9WNM1JPztjsXo/LLLnOEA6g8IyuNdac5iqwX9lyrSgqiJ/If5KTYCTH4
	bCTpQyu9NF7OYtjdXxRUcGQv3r+qMv1dN9DirGr7tasgxsiVgQsQ==
X-Received: by 2002:a17:906:6a23:b0:b8a:f3c0:c14 with SMTP id a640c23a62f3a-b8d4f70e1a1mr5978466b.38.1769297775443;
        Sat, 24 Jan 2026 15:36:15 -0800 (PST)
Received: from mail-wr1-f42.google.com (mail-wr1-f42.google.com. [209.85.221.42])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b885b3da4b7sm352214666b.10.2026.01.24.15.36.13
        for <mm-commits@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 24 Jan 2026 15:36:13 -0800 (PST)
Received: by mail-wr1-f42.google.com with SMTP id ffacd0b85a97d-42fb6ce71c7so3153288f8f.1
        for <mm-commits@vger.kernel.org>; Sat, 24 Jan 2026 15:36:13 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCUVQbjHaGLL51ceegTuLTmxjbRRNVbw1N/i8uJBgrlohgzIggsAExqD4+tJVk9lMDo4Fy0qxydrlziY@vger.kernel.org
X-Received: by 2002:a5d:5f93:0:b0:435:982d:97ee with SMTP id
 ffacd0b85a97d-435ca1afeb0mr132288f8f.57.1769297772964; Sat, 24 Jan 2026
 15:36:12 -0800 (PST)
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAD=FV=WHWrKS_LVjod6nhnPdEk9_ZqeubGpft3PJOUJNMbBxfg@mail.gmail.com>
 <20260124065719.805144-1-realwujing@gmail.com>
In-Reply-To: <20260124065719.805144-1-realwujing@gmail.com>
From: Doug Anderson <dianders@chromium.org>
Date: Sat, 24 Jan 2026 15:36:01 -0800
X-Gmail-Original-Message-ID: <CAD=FV=Vmk1jA+dAgJNVDMtxrhhrPxgnXkNxiqJXWBvgUcZZUxQ@mail.gmail.com>
X-Gm-Features: AZwV_QjwSccMhlpIM9-YrAxACDjpiR1Rl3L9SfoYHyhRS2AZtl7vffA2Ud_GyTI
Message-ID: <CAD=FV=Vmk1jA+dAgJNVDMtxrhhrPxgnXkNxiqJXWBvgUcZZUxQ@mail.gmail.com>
Subject: Re: [PATCH v3] watchdog/hardlockup: Fix UAF in perf event cleanup due
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

On Fri, Jan 23, 2026 at 10:57=E2=80=AFPM Qiliang Yuan <realwujing@gmail.com=
> wrote:
>
> Thanks for the detailed review!
>
> > Wait a second... The above function hasn't existed for 2.5 years. It
> > was removed in commit d9b3629ade8e ("watchdog/hardlockup: have the
> > perf hardlockup use __weak functions more cleanly"). All that's left
> > in the ToT kernel referencing that function is an old comment...
> >
> > Oh, and I guess I can see below that your stack traces are on 4.19,
> > which is ancient! Things have changed a bit in the meantime. Are you
> > certain that the problem still reproduces on ToT?
>
> The function hardlockup_detector_perf_init() was renamed to
> watchdog_hardlockup_probe() in commit d9b3629ade8e ("watchdog/hardlockup:
> have the perf hardlockup use __weak functions more cleanly").
> Additionally, the source file was moved from kernel/watchdog_hld.c to
> kernel/watchdog_perf.c in commit 6ea0d04211a7. The v3 commit message
> inadvertently retained legacy terminology from the 4.19 kernel; this will
> be updated in V4 to reflect current ToT naming.
>
> The core logic remains the same: the race condition persists despite the
> renaming and cleanup of the __weak function logic.
>
> Regarding ToT reproducibility: while the KASAN report originated from
> 4.19, the underlying logic is still problematic in ToT. In
> watchdog_hardlockup_probe(), the call to
> hardlockup_detector_event_create() still writes to the per-cpu
> watchdog_ev. Task migration between event creation and the subsequent
> perf_event_release_kernel() leaves a stale pointer in the watchdog_ev of
> the original CPU.
>
> > Probably want a "Fixes" tag? If I had to guess, maybe?
> >
> > Fixes: 930d8f8dbab9 ("watchdog/perf: adapt the watchdog_perf interface
> > for async model")
>
> Commit 930d8f8dbab9 introduced the async initialization which allows
> preemption/migration during the probe phase. This tag will be included in
> V4.

The part that doesn't make a lot of sense to me, though, is that v4.19
also doesn't have commit 930d8f8dbab9 ("watchdog/perf: adapt the
watchdog_perf interface for async model"), which is where we are
saying the problem was introduced.

...so in v4.19 I think:
* hardlockup_detector_perf_init() is only called from watchdog_nmi_probe()
* watchdog_nmi_probe() is only called from lockup_detector_init()
* lockup_detector_init() is only called from kernel_init_freeable()
right before smp_init()

Thus I'm super confused about how you could have seen the problem on
v4.19. Maybe your v4.19 kernel has some backported patches that makes
this possible?

While I'm not saying that the v4 patch you just posted is incorrect,
I'm just trying to make sure that:

1. We actually understand the problem you were seeing.

2. We are identifying the correct "Fixes" commit.


> > I'm still a bit confused why this warning didn't trigger previously.
> > Do you know why?
>
> In 4.19, hardlockup_detector_event_create() did not include the
> WARN_ON(!is_percpu_thread()) check, which was added in later versions. In
> ToT, this warning is expected to trigger if watchdog_hardlockup_probe()
> is called from a non-per-cpu-bound thread (such as kernel_init). This
> further justifies refactoring the creation logic to be CPU-agnostic for
> probing.

OK, fair enough. ...but I'm a bit curious why nobody else saw this
WARN_ON(). I'm also curious if you have tested the hardlockup detector
on newer kernels, or if all of your work has been done on 4.19. If all
your work has been done on 4.19, do we need to find someone to test
your patch on a newer kernel and make sure it works OK? If you've
tested on a newer kernel, did the hardlockup detector init from the
kernel's early-init code, or the retry code?

-Doug
