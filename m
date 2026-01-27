Received: from mail-ej1-f41.google.com (mail-ej1-f41.google.com [209.85.218.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA42A236454
	for <mm-commits@vger.kernel.org>; Tue, 27 Jan 2026 01:15:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769476510; cv=none; b=qYO/x9B4XOeuU6uV8//f+t9SDB7CvpycnEDsAvR+FfqWZmx3Pk+Q38qVGpqOpgAiOMbVac9aXXwcKV2NxBa3mVbIxVfW4G9UetAbKPdR4fCz4Q1iQlkToPaT7cqzwQICbU75msz3b/TBxxZdt0cy5XQEegLGLX6mJ40QQzPYhk0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769476510; c=relaxed/simple;
	bh=4hWe/ZeM0/dp3df6siLGhiMwgMH8EDIhO8UEJze1og4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=bLKTdtyPItyApPOCi2Md75G0El09H/2QXB6DuoUMIBp2ZanPPhOw06gwsA/8d5RF9zzYsqVb2xIfBa/xOKbOrKpema/ZJjSHy7R/opJoWO66AmkuVulcVrj6sVwNkDjNcs9XfxVzrf0I58ke+fb0ZrqMQPId8u6CBuW4jC6i060=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org; spf=pass smtp.mailfrom=chromium.org; dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b=LyhmGZ1S; arc=none smtp.client-ip=209.85.218.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chromium.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="LyhmGZ1S"
Received: by mail-ej1-f41.google.com with SMTP id a640c23a62f3a-b8838339fc6so988129866b.0
        for <mm-commits@vger.kernel.org>; Mon, 26 Jan 2026 17:15:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1769476507; x=1770081307; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=V0WNey5zwe01UB/P+i2RgBgqNj6Zk0tMin0y60LW9DU=;
        b=LyhmGZ1SjaKcXkdPeUy3t1G4mJ6tqe2tqKiv8Ka2YmsY0n/qEtOfQu3u3atQfqJ4FY
         eb065r52Ndvk156jmTru4PZrfLZ7yGcRzCJFbigSe/JdrFDKMBTvPirZRtLp949yhoo6
         M2d+TU2u4FooR7tvfJDdnfWcFoWfoR/caZBDs=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769476507; x=1770081307;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=V0WNey5zwe01UB/P+i2RgBgqNj6Zk0tMin0y60LW9DU=;
        b=IQJ37WIAZhry0XJSexsyLOvtJWG/lQSke3o4uOAfiYZryNyI1vA0zc/2wq3tqKcm9R
         z0lT06DpgMH0w8Dh1RBA0P8QBRvzcrgzg1YXJ01iccnbDaMxeQ5EtgEewVtupxMiMMIB
         GPeLtFw/KpPeR4Glwm+PHck+IZ7wehhPvwM/GE32kX5CElcj4pU1Hv7mbiTDQIClkCgC
         E2cW1ykl39j5tROJt2IRJMsjBX9LQa8s5sbuKknwnHZer7VR+wZUVKMtWVJZdiKcG6JT
         C7ILV6ymOzd+gehbrEf8PQ3WJmI+9yn2Rg4GxTVMhbNy3K7NLm194gvKV9QrE6WBtsyf
         usMQ==
X-Forwarded-Encrypted: i=1; AJvYcCWTzNaFbDlfetuhnFF265BMeTsvQ395Fx6NGmw2/pBtrHfZ+miQPyWlVUvkXr8i10QkidrG4XDfAFHr@vger.kernel.org
X-Gm-Message-State: AOJu0Yzl2Z24VcVpiFDEUgZgfYwiOHF/fSSCaplW3sPgUnktd2iNAABw
	yumlB0MOB96JKdnV9qKFk5PKb0WBiv+tWe3l2z06w8Chf0AouGRbNTlF6FmHPjuNxbpZZabM1up
	AoI/Hmg==
X-Gm-Gg: AZuq6aJ3JDgyqAOSESemDeAnlAKFKjdBbBXCuvMtQCs5RvBbjPlIBl4wjioKv9uVKFK
	qb4uvxMfmSZaj4M8BSGZ5WKkHfqI7qhCNIBEFQn5hsHrpc70xsv2cqXamZ9YvSzJIavV0imil0g
	QF+f4XCK+fY1YnaG3JoqXF3n053N3RcstC+b9RqoArFRDN/Xm1a8Oa+XnLkxRMdhEeVNXkVRkRR
	vyu5z7cTXWtTpQfi4i2gHz5TpZgf2MAHrqgK+j+p40iPHxkUR34vqyoagr8U76nPE0KR8vOuHJU
	bsOMVtIe3Lts3VJL9wy3jZl27o7OH1b5Ur+xq8l+dkSb4fS3bod2s3KT7a9P0yv9b2jS7Mkw/2u
	hQBikRcVcnNof89E0QNqbLozvMcCMC/zdKVoGxw25VZ3ekM6FOeGR1SvgIThj4KC29m6qvkRMsu
	LSMoJe+0h44Xrt4+iGkgmfSWlFco+WOLNGX4osrLdy6RZqk8DPDA==
X-Received: by 2002:a17:907:7205:b0:b87:2abc:4a2a with SMTP id a640c23a62f3a-b8ceed5a231mr469464466b.1.1769476506511;
        Mon, 26 Jan 2026 17:15:06 -0800 (PST)
Received: from mail-wr1-f50.google.com (mail-wr1-f50.google.com. [209.85.221.50])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b885b411de7sm715589966b.19.2026.01.26.17.15.05
        for <mm-commits@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 26 Jan 2026 17:15:05 -0800 (PST)
Received: by mail-wr1-f50.google.com with SMTP id ffacd0b85a97d-43246af170aso2891750f8f.0
        for <mm-commits@vger.kernel.org>; Mon, 26 Jan 2026 17:15:05 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCVSghUbnFiqC/eNj9MEmKqoFEZs6FlewhL7zcfl+NSdKetzTWU/KDOJrwCFDNZAdpZa40tU02TfWlwh@vger.kernel.org
X-Received: by 2002:a5d:64e9:0:b0:430:2773:84d6 with SMTP id
 ffacd0b85a97d-435c9d1a409mr9683879f8f.24.1769476505162; Mon, 26 Jan 2026
 17:15:05 -0800 (PST)
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAD=FV=Vmk1jA+dAgJNVDMtxrhhrPxgnXkNxiqJXWBvgUcZZUxQ@mail.gmail.com>
 <20260126033012.934143-1-realwujing@gmail.com>
In-Reply-To: <20260126033012.934143-1-realwujing@gmail.com>
From: Doug Anderson <dianders@chromium.org>
Date: Mon, 26 Jan 2026 17:14:53 -0800
X-Gmail-Original-Message-ID: <CAD=FV=WVtFAPZ3=6pPnOV=vbMhFwfH9LaZ5oNgAKtcj5hA0q2Q@mail.gmail.com>
X-Gm-Features: AZwV_QjgByfA3hEAUN30WElxUvkskpDfD8rbwB8NvDK5sJAq06ev73kRykPD3JE
Message-ID: <CAD=FV=WVtFAPZ3=6pPnOV=vbMhFwfH9LaZ5oNgAKtcj5hA0q2Q@mail.gmail.com>
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

On Sun, Jan 25, 2026 at 7:30=E2=80=AFPM Qiliang Yuan <realwujing@gmail.com>=
 wrote:
>
> Hi Doug,
>
> Thanks for your further questions and for digging into the 4.19 vs ToT
> differences.
>
> On Sat, 24 Jan 2026 15:36:01 Doug Anderson <dianders@chromium.org> wrote:
> > The part that doesn't make a lot of sense to me, though, is that v4.19
> > also doesn't have commit 930d8f8dbab9 ("watchdog/perf: adapt the
> > watchdog_perf interface for async model"), which is where we are
> > saying the problem was introduced.
> >
> > ...so in v4.19 I think:
> > * hardlockup_detector_perf_init() is only called from watchdog_nmi_prob=
e()
> > * watchdog_nmi_probe() is only called from lockup_detector_init()
> > * lockup_detector_init() is only called from kernel_init_freeable()
> > right before smp_init()
> >
> > Thus I'm super confused about how you could have seen the problem on
> > v4.19. Maybe your v4.19 kernel has some backported patches that makes
> > this possible?
>
> You caught it! Here is the context for the differences:
>
> 1. Mainline (ToT):
>    - `lockup_detector_init()` is always called before `smp_init()`
>      (pre-SMP phase).
>    - Risk source: The asynchronous retry path (`lockup_detector_delay_ini=
t`)
>      introduced by 930d8f8dbab9, which runs in a workqueue (post-SMP)
>      context and triggers the UAF.
>
> 2. openEuler (4.19/5.10):
>    - Local `euler inclusion` patches moved `lockup_detector_init()` after
>      `do_basic_setup()` (post-SMP phase).
>    - Risk source: The initial probe occurs directly in a post-SMP
>      environment, exposing the race condition.
>
> For openEuler (4.19/5.10) kernel, the call stack looks like this:
>   kernel_init()
>   -> kernel_init_freeable()
>     -> lockup_detector_init()       <-- Called after smp_init()
>       -> watchdog_nmi_probe()
>         -> hardlockup_detector_perf_init()
>           -> hardlockup_detector_event_create()
>
> In mainline (ToT), the initial probe (safe) call stack is:
>   kernel_init()
>   -> kernel_init_freeable()
>     -> lockup_detector_init()       <-- Called before smp_init()
>       -> watchdog_hardlockup_probe()
>         -> hardlockup_detector_event_create()
>
> However, the asynchronous retry mechanism (commit 930d8f8dbab9) executes =
the
> probe logic in a post-SMP, preemptible context.
>
> For the mainline (ToT) retry path (at risk), the call stack is:
>   kworker thread
>   -> process_one_work()
>     -> lockup_detector_delay_init()
>       -> watchdog_hardlockup_probe()
>         -> hardlockup_detector_event_create()
>
> Thus, `930d8f8dbab9` remains the correct "Fixes" target for ToT.

OK, at least I'm not crazy! That does indeed explain why things seemed
so wonky...


> > OK, fair enough. ...but I'm a bit curious why nobody else saw this
> > WARN_ON(). I'm also curious if you have tested the hardlockup detector
> > on newer kernels, or if all of your work has been done on 4.19. If all
> > your work has been done on 4.19, do we need to find someone to test
> > your patch on a newer kernel and make sure it works OK? If you've
> > tested on a newer kernel, did the hardlockup detector init from the
> > kernel's early-init code, or the retry code?
>
> In newer kernels, when the probe fails initially and falls
> back to the retry workqueue (or even during early init if preemption is
> enabled), the `WARN_ON(!is_percpu_thread())` in
> `hardlockup_detector_event_create()` does indeed trigger because
> `watchdog_hardlockup_probe()` is called from a non-bound context.
>
> I have verified this patch on the openEuler 4.19 kernel. During our stres=
s
> testing, where we start dozens of VMs simultaneously to create high resou=
rce
> contention, the UAF was consistently reproducible without this fix and is=
 now
> confirmed resolved.
>
> The v4 patch addresses this by refactoring the creation logic to be state=
less
> and adding `cpu_hotplug_disable()` to ensure the probed CPU stays alive.

OK, so I think the answer is: you haven't actually seen the problem
(or the WARN_ON) on a mainline kernel, only on the openEuler 4.19
kernel...

...actually, I looked and now think the problem doesn't exist on a
mainline kernel. Specificaly, when we run lockup_detector_retry_init()
we call schedule_work() to do the work. That schedules work on the
"system_percpu_wq". While the work ends up being queued with
"WORK_CPU_UNBOUND", I believe that we still end up running on a thread
that's bound to just one CPU in the end.  This is presumably why
nobody has reported that "WARN_ON(!is_percpu_thread())" actually
hitting on mainline.

Given the above, it sounds to me like the problem you're having is
with a downstream kernel and upstream is actually fine. Did I
understand that correctly?

If that's the case, we'd definitely want to at least change the
description and presumably _remove_ the Fixes tag? I actually still
think the code looks nicer after your CL and (maybe?) we could even
remove the whole schedule_work() for running this code? Maybe it was
only added to deal with this exact problem? ...but the CL description
would definitely need to be updated.


> I'll wait for your further thoughts on v4:
> https://lore.kernel.org/all/20260124070814.806828-1-realwujing@gmail.com/

Sure. In the very least the CL description would need to be updated
(assuming my understanding is correct), but for now let's avoid
forking the conversation and resolve things here?

-Doug
