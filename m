Received: from mail-ej1-f49.google.com (mail-ej1-f49.google.com [209.85.218.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 676973EBF18
	for <mm-commits@vger.kernel.org>; Sat, 24 Jan 2026 00:02:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769212937; cv=none; b=Y0rlzsAwe+2QCnqCz0MSoxqZK8TlndcgD9cXvcXs9bX1kHwK6tukbBdLIIkvV3NJGV/mZ8FC59ahw25MUpkgGi3h6eb5QuaAOq4BshISNCK6V9CRS7/AFU22K95Nr3fG3uKR+D4HRyBbCHhKphudcKO8m1b822hcO0iAlbDEuis=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769212937; c=relaxed/simple;
	bh=McfmxtPH9+iWC1nGp8gWsDTFhIjSA6p2id/xCPffMLo=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=SapprE30fUWwSICsJM3o9LM3NuYL/0iorV4EfkRYb3/px60urddUOUZKtW1AAlGSO6r9VLUVI1xThse2x/ttfDeuCPj/DWPUQxWyjia2NXn0+Eb8ImZVxCrNxJAQPwSgGOzqUkZRibRz4nKchIbnxtT2pGResuWqy4kajoqf708=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org; spf=pass smtp.mailfrom=chromium.org; dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b=HP5AXsrr; arc=none smtp.client-ip=209.85.218.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chromium.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="HP5AXsrr"
Received: by mail-ej1-f49.google.com with SMTP id a640c23a62f3a-b884d5c787bso433175766b.0
        for <mm-commits@vger.kernel.org>; Fri, 23 Jan 2026 16:02:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1769212929; x=1769817729; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=yuCDz9F8Ho603yGMU1x5Pa2VnQyzmdC16O9gi5uXdh8=;
        b=HP5AXsrrQbo/ew9UBFnwtPKsxVExvYL/tj2/hZ8fj1Mid7oErXNCylMl8VTuK5eTwX
         vlUzGpi2MXWhyc5ItjV7pYk9D0Nmjs6CblqeobhZIagOQ7Jr8gR2VLE/G4kvhpUNx7Lf
         wG07MRc5rTWBJfjEyRCT8krlwtcVXPVQQ92JY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769212929; x=1769817729;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=yuCDz9F8Ho603yGMU1x5Pa2VnQyzmdC16O9gi5uXdh8=;
        b=WZEPLtN5FoMgzjNE3VryMC8x/fHzcj8FbIOv8Sc0Y92ExHeixm/UDugAO2MkFwNGO/
         p/hDzCAeI1wFN8cgaYG5CixlcQVpndIdFX5+0UlKIWxEL1yiwIKs+lNqJKCt1lNonjox
         PLSLJ+FGV4cdUL9zKttGRySPnXAIy2ff/Aq+kK2Bmk6Dq1OGHx/M9npm+eIvYxWPJO6i
         eDZO973nL/+6Ttdo5kqELnEhgswGczhsF6j2Uj8o7tbU7qvV7FQ1K8HbA2PlWrqlVRAT
         GevCxPg1eX+GUuR4djN975SRYUE4NlKdAg+lBgO+i9wM8DZhZh6HWnwwM6GV+uvtBeEM
         eWNg==
X-Forwarded-Encrypted: i=1; AJvYcCVmT3DtiSQWiszRgmfD+Iuhe2xJ2E5PxLyKzj0irQ02FnWb9VbGmtOkwwzf35JJPvUk0nzWxwBAstwq@vger.kernel.org
X-Gm-Message-State: AOJu0YyWwBAYqEXoMk/NCPFE+R/HrPVzWAQS42GNvqEGEo9uzyAGduPh
	IP0ZT7WnI3uW9lFlB5xbDro0uGKfwox7jQfhxM183qfIdor3/RZG+ZJjWQGp+A2sj8XTe5lQObD
	GM2CJEugA
X-Gm-Gg: AZuq6aKQkRs0eK5L++HTjIDPX0mKwySzDTyrXkKHlGokr/Ea0/RqSDv8Z3kqR0FmkNB
	rUEZp1fd1/m7qyAa0KLAoQ98F+lMU4ZUACJOTsxokvspISY9rOwTm6TfFVDihAIsWGAq2YTSiTR
	X1N7MO7+fq0nd1192bFuI1UvsZno0r+D2Y9P74rALycqhuAzF+f3ktArJ6y+OIB4HZruok0fJ6X
	2eh1pwZZtsu9HbaujuCzSZ2FFvrkPV3bGMV4MpftXA+866O3WQ1mY58drIRe+zmajQT/quE+jp7
	31avp0ppCVTyEAWpQ/THpv0yjizWP+pQZNQ1I5g/f4OsFqCcqxSboZTX6LKhcpA37+t9l4unh/l
	nuc46gA08pvYn1scxnPHO5AwQM0H1rNCJDxosU0gNz/9Ie/BVCQCcOKce4XbL98P6y2OEdfyAiu
	WSu+tz46Od41yEEi5UJ60PvGnNuYYmoABtQ2/Rc7rjUnBn9mBXUg==
X-Received: by 2002:a17:907:da4:b0:b83:95c7:f87b with SMTP id a640c23a62f3a-b885ad28d9dmr318852166b.37.1769212928989;
        Fri, 23 Jan 2026 16:02:08 -0800 (PST)
Received: from mail-wr1-f52.google.com (mail-wr1-f52.google.com. [209.85.221.52])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b88724fd414sm73410466b.37.2026.01.23.16.02.07
        for <mm-commits@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 23 Jan 2026 16:02:08 -0800 (PST)
Received: by mail-wr1-f52.google.com with SMTP id ffacd0b85a97d-435a517be33so1666026f8f.0
        for <mm-commits@vger.kernel.org>; Fri, 23 Jan 2026 16:02:07 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCXwvcn8uWQiqk8k6zuf1G1JFkNz1suIUHFR4f0Oy9pMIwwAL1peOb6iVcJrfA7P3E34TQZdT5qppwIY@vger.kernel.org
X-Received: by 2002:a05:6000:4287:b0:432:8537:85ca with SMTP id
 ffacd0b85a97d-435b16179cbmr7571899f8f.50.1769212926845; Fri, 23 Jan 2026
 16:02:06 -0800 (PST)
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAD=FV=UGpqN3XsHWM9coRdez2mL8mz0_hsUMQttTqaD7oEvSEQ@mail.gmail.com>
 <20260123063407.248775-1-realwujing@gmail.com>
In-Reply-To: <20260123063407.248775-1-realwujing@gmail.com>
From: Doug Anderson <dianders@chromium.org>
Date: Fri, 23 Jan 2026 16:01:55 -0800
X-Gmail-Original-Message-ID: <CAD=FV=WHWrKS_LVjod6nhnPdEk9_ZqeubGpft3PJOUJNMbBxfg@mail.gmail.com>
X-Gm-Features: AZwV_Qgww6BU2s9o8UKPxUEj0exFCvl8FVpkSFp-7jScwFxXAI9t3KfOSr0cnoY
Message-ID: <CAD=FV=WHWrKS_LVjod6nhnPdEk9_ZqeubGpft3PJOUJNMbBxfg@mail.gmail.com>
Subject: Re: [PATCH v3] watchdog/hardlockup: Fix UAF in perf event cleanup due
 to migration race
To: Qiliang Yuan <realwujing@gmail.com>
Cc: akpm@linux-foundation.org, lihuafei1@huawei.com, 
	linux-kernel@vger.kernel.org, mingo@kernel.org, song@kernel.org, 
	stable@vger.kernel.org, sunshx@chinatelecom.cn, thorsten.blum@linux.dev, 
	wangjinchao600@gmail.com, yangyicong@hisilicon.com, yuanql9@chinatelecom.cn, 
	zhangjn11@chinatelecom.cn, mm-commits@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi,

On Thu, Jan 22, 2026 at 10:34=E2=80=AFPM Qiliang Yuan <realwujing@gmail.com=
> wrote:
>
> During the early initialization of the hardlockup detector, the
> hardlockup_detector_perf_init() function probes for PMU hardware availabi=
lity.
> It originally used hardlockup_detector_event_create(), which interacts wi=
th
> the per-cpu 'watchdog_ev' variable.
>
> If the initializing task migrates to another CPU during this probe phase,
> two issues arise:
> 1. The 'watchdog_ev' pointer on the original CPU is set but not cleared,
>    leaving a stale pointer to a freed perf event.
> 2. The 'watchdog_ev' pointer on the new CPU might be incorrectly cleared.
>
> This race condition was observed in console logs (captured by adding debu=
g printks):
>
> [23.038376] hardlockup_detector_perf_init 313 cur_cpu=3D2

Wait a second... The above function hasn't existed for 2.5 years. It
was removed in commit d9b3629ade8e ("watchdog/hardlockup: have the
perf hardlockup use __weak functions more cleanly"). All that's left
in the ToT kernel referencing that function is an old comment...

Oh, and I guess I can see below that your stack traces are on 4.19,
which is ancient! Things have changed a bit in the meantime. Are you
certain that the problem still reproduces on ToT?


> Signed-off-by: Shouxin Sun <sunshx@chinatelecom.cn>
> Signed-off-by: Junnan Zhang <zhangjn11@chinatelecom.cn>
> Signed-off-by: Qiliang Yuan <realwujing@gmail.com>
> Signed-off-by: Qiliang Yuan <yuanql9@chinatelecom.cn>
> Cc: Song Liu <song@kernel.org>
> Cc: Douglas Anderson <dianders@chromium.org>
> Cc: Jinchao Wang <wangjinchao600@gmail.com>
> Cc: Wang Jinchao <wangjinchao600@gmail.com>
> Cc: <stable@vger.kernel.org>

Probably want a "Fixes" tag? If I had to guess, maybe?

Fixes: 930d8f8dbab9 ("watchdog/perf: adapt the watchdog_perf interface
for async model")

Why? I think before that the init function could only be called
directly from the kernel init code and before smp_init(). After that,
a worker could call it, which is the case where preemption could have
been enabled. Does my logic sound correct?

Can you confirm that you're only seeing the problem when the retry
hits? In other words when called from lockup_detector_delay_init()?
Oh, though if you're on 4.19 then I'm not sure what to think...


> @@ -118,18 +118,11 @@ static void watchdog_overflow_callback(struct perf_=
event *event,
>         watchdog_hardlockup_check(smp_processor_id(), regs);
>  }
>
> -static int hardlockup_detector_event_create(void)
> +static struct perf_event *hardlockup_detector_event_create(unsigned int =
cpu)
>  {
> -       unsigned int cpu;
>         struct perf_event_attr *wd_attr;
>         struct perf_event *evt;
>
> -       /*
> -        * Preemption is not disabled because memory will be allocated.
> -        * Ensure CPU-locality by calling this in per-CPU kthread.
> -        */
> -       WARN_ON(!is_percpu_thread());

I'm still a bit confused why this warning didn't trigger previously.
Do you know why?


> @@ -263,19 +258,31 @@ bool __weak __init arch_perf_nmi_is_available(void)
>   */
>  int __init watchdog_hardlockup_probe(void)
>  {
> +       struct perf_event *evt;
> +       unsigned int cpu;
>         int ret;
>
>         if (!arch_perf_nmi_is_available())
>                 return -ENODEV;
>
> -       ret =3D hardlockup_detector_event_create();
> +       if (!hw_nmi_get_sample_period(watchdog_thresh))
> +               return -EINVAL;
>
> -       if (ret) {
> +       /*
> +        * Test hardware PMU availability by creating a temporary perf ev=
ent.
> +        * Allow migration during the check as any successfully created p=
er-cpu
> +        * event validates PMU support. The event is released immediately=
.

I guess it's implied by the "Allow migration during the check", but I
might even word it more strongly and say something like "The cpu we
use here is arbitrary, so we don't disable preemption and use
raw_smp_processor_id() to get a CPU."

I guess that should be OK. Hopefully the arbitrary CPU that you pick
doesn't go offline during this function. I don't know "perf" well, but
I could imagine that it might be upset if you tried to create a perf
event for a CPU that has gone offline. I guess you could be paranoid
and surround this with cpu_hotplug_disable() / cpu_hotplug_enable()?


I guess overall thoughts: the problem you're describing does seem
real, but the fact that your reports are from an ancient 4.19 kernel
make me concerned about whether you really tested all the cases on a
new kernel...

-Doug
