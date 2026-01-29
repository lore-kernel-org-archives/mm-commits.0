Received: from mail-ej1-f47.google.com (mail-ej1-f47.google.com [209.85.218.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23E072D23A5
	for <mm-commits@vger.kernel.org>; Thu, 29 Jan 2026 16:18:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769703511; cv=none; b=ZjMu/0d38V0srBAXH+JyV45DmfDwyVzLKQm3nDaQxR10P4il4v8uf9gPz41WziLEnClFobdDmFCsq9IyPJ86e40BNK25NWDtQi9/JclFggS4JgnK2bU07yhalck6dE2g1GteUxbn7HQkBmH+GQ0Z3idxF3PfOy1etH0IBjaZWCo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769703511; c=relaxed/simple;
	bh=FyxdE3i0S0sOMCiAqRnDE/JGv8BUQ7rwgYssZ0u2i1s=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=qok2OgxRwA7Xud6uGC0hNoJ9DnFWYLR3VxDTF+XXiSDnsKLU5wHAUvlJa41Oyb/MRUIJuyqTZg6Ie5Yr7Dxv7ZthwEHDtA08Yf9tXa9O8u6lnDjw/P7Xn266IDuJxya+whvSVGjmHpmFpZT+hUe27QkV5FfOfng6J5L+3HfOZ5s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org; spf=pass smtp.mailfrom=chromium.org; dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b=dMfWCh07; arc=none smtp.client-ip=209.85.218.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chromium.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="dMfWCh07"
Received: by mail-ej1-f47.google.com with SMTP id a640c23a62f3a-b8849dc12f6so188591366b.1
        for <mm-commits@vger.kernel.org>; Thu, 29 Jan 2026 08:18:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1769703505; x=1770308305; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=KB9Cy4FVJg8wm+puQzne477B0+DW4cZTlodUY8Maklc=;
        b=dMfWCh07lXvvCISekKZ9AKMQWtByDHhzWyst2TXfuncJr0fd8S0ieoATYO61VpGfRt
         6xIncAU8de+nfskU63fLyvP81kAT3eeL+I7HYLMefrb8InnCRTb+UBF0ogh3X7k+rDuG
         cAlf4FXSehxIHWZT7dnNafW8d+u0um079fOWI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769703505; x=1770308305;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=KB9Cy4FVJg8wm+puQzne477B0+DW4cZTlodUY8Maklc=;
        b=oxiTKRApONqq15QlNKr8VrN0kOxTN8z0GwEP4OkNEtMga8ppYztNPnhJFditFn/6wK
         EAbL8at5z8xxiKJMS7sb9DTigMs9Hk3QEfhcbz5vaIM9Y85//Ngc/jAVETFwAbJ/XNo6
         ddopI5P1XIrJ29BByJjeK2MpQtYLLgBBOEDLpeK06LaVA6Q4gEx7rQH5m6kzwuZMeGwl
         wte7hdu3I2M4hIQTYTxgvIVGVVIJC8Vlatt84XRWFNNeeFHNTnHSDXaas3kpXNhJJAOW
         4fqZdJgZ8eJ3oA4qfThChq3F8L7iWV/c6P/hcwI/K+Bwsvi082QNisGf6o7J2d3Ur4+o
         Perw==
X-Forwarded-Encrypted: i=1; AJvYcCX4ogkRj5/SKrAUCLlMeuu6pkL7VUxmvJyU4SbQAqk3yA/PTs35bppKZLPCU3oEUuR+x+SCJGDxkNlW@vger.kernel.org
X-Gm-Message-State: AOJu0YwuAbRL8N2lusZkCk86Q6mkdDFmVhu2dslz2A+w9sQ0jCs7M+Qh
	7WUchVFz5O097NPhaISODL/wMHS2vKe8qBk5BpAvltwV0dWlx17m9ctSQaKxcTsk090WrxlYHI5
	/NZKFAQ==
X-Gm-Gg: AZuq6aKKwbCmFo4cRu1JrgU5IhXEVKbDKN9PISfGqPYSble49SueWKZXDZxhiFfmoY2
	t+AjA+j/xNobeZXqdywg8kiHFAmEstzO/tfR9gBd2FwKeeJQw5opgz1VFvdLaijHHD+b7Egz6GF
	kcamYbxg7KK/+8gDr7LpxM31k8jwfoSN+HcJ/HCCj2Tj0XoHcaEf2S0X9ceZat9FQEm6ZZKB1iT
	kmHO4OBc2MCsQRtLYY5nzxsmkl8ZcSKqMXG+5JWGA5yuPiCJF3j8rbWiO/VNL/p598OLUdF7z6M
	jJlpb0x4bERUp2BBkZnxvu4Pmf49pbwWth4JVoX+MoCywGlpu6HsT0ZtXM4O5XjZw4uANAmtbQ+
	3bm36d5ejShMz+tT4ztYqXIl8J7nf+ZxS9C+GcKtQC8BU0cUryAgKpiz/SANwRdHXKGuWZ14AFQ
	x0/pwpawHS6fTAclCZQHUQ4v6T5VgKXQWR3apbaW7BX2/x16OuwA==
X-Received: by 2002:a17:907:8693:b0:b87:298a:da9c with SMTP id a640c23a62f3a-b8dab135deemr223674266b.6.1769703504587;
        Thu, 29 Jan 2026 08:18:24 -0800 (PST)
Received: from mail-wm1-f52.google.com (mail-wm1-f52.google.com. [209.85.128.52])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b8de289bdf4sm119281366b.44.2026.01.29.08.18.21
        for <mm-commits@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 29 Jan 2026 08:18:21 -0800 (PST)
Received: by mail-wm1-f52.google.com with SMTP id 5b1f17b1804b1-47ee3a63300so11891645e9.2
        for <mm-commits@vger.kernel.org>; Thu, 29 Jan 2026 08:18:21 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCWwDiFtfcvUQxDfJreT5o2IAVVmngQc4jAdgieqreaCEm7YpQRzpDBuXEvSiB6Kq8os7rgyqBb4554m@vger.kernel.org
X-Received: by 2002:a05:600c:a44:b0:47e:e2ec:995b with SMTP id
 5b1f17b1804b1-48069c2098cmr117091455e9.9.1769703501228; Thu, 29 Jan 2026
 08:18:21 -0800 (PST)
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260129022629.2201331-1-realwujing@gmail.com>
In-Reply-To: <20260129022629.2201331-1-realwujing@gmail.com>
From: Doug Anderson <dianders@chromium.org>
Date: Thu, 29 Jan 2026 08:18:09 -0800
X-Gmail-Original-Message-ID: <CAD=FV=VpV19wB5uGUCRDnCO_SktL3Svnh3V+NT5oNji70Ff3pw@mail.gmail.com>
X-Gm-Features: AZwV_Qi6iIvkb9CRih937uKay1QnRrNoDBbLHqezMGvplj5D710QE3pctSSd19g
Message-ID: <CAD=FV=VpV19wB5uGUCRDnCO_SktL3Svnh3V+NT5oNji70Ff3pw@mail.gmail.com>
Subject: Re: [PATCH v9] watchdog/hardlockup: simplify perf event probe and
 remove per-cpu dependency
To: Qiliang Yuan <realwujing@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>, Li Huafei <lihuafei1@huawei.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Jinchao Wang <wangjinchao600@gmail.com>, 
	Yicong Yang <yangyicong@hisilicon.com>, Thorsten Blum <thorsten.blum@linux.dev>, 
	linux-watchdog@vger.kernel.org, mm-commits@vger.kernel.org, 
	Shouxin Sun <sunshx@chinatelecom.cn>, Junnan Zhang <zhangjn11@chinatelecom.cn>, 
	Qiliang Yuan <yuanql9@chinatelecom.cn>, Song Liu <song@kernel.org>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi,

On Wed, Jan 28, 2026 at 6:26=E2=80=AFPM Qiliang Yuan <realwujing@gmail.com>=
 wrote:
>
> Simplify the hardlockup detector's probe path and remove its implicit
> dependency on pinned per-cpu execution.
>
> Refactor hardlockup_detector_event_create() to be stateless. Return
> the created perf_event pointer to the caller instead of directly
> modifying the per-cpu 'watchdog_ev' variable. This allows the probe
> path to safely manage a temporary event without the risk of leaving
> stale pointers should task migration occur.
>
> Signed-off-by: Shouxin Sun <sunshx@chinatelecom.cn>
> Signed-off-by: Junnan Zhang <zhangjn11@chinatelecom.cn>
> Signed-off-by: Qiliang Yuan <yuanql9@chinatelecom.cn>
> Signed-off-by: Qiliang Yuan <realwujing@gmail.com>
> Cc: Douglas Anderson <dianders@chromium.org>
> Cc: Song Liu <song@kernel.org>
> Cc: Jinchao Wang <wangjinchao600@gmail.com>
> ---
> v9:
> - remove unused `#include <linux/cpu.h>`
> v8:
> - Add Signed-off-by with work email.
> v7:
> - Update Signed-off-by to match author email.
> - Remove redundant cpu_hotplug_disable() in probe path.
> v6:
> - Change title to "simplify/cleanup" and remove "Fixes" tag since the iss=
ue
>   is not reproducible on mainline.
> - Rewrite commit message in imperative mood.
> - Clarify that mainline is safe while this improves robustness.
> v5:
> - Refine description: clarify that the retry path uses worker threads
>   without PF_PERCPU_THREAD (though mainline is safe due to system_percpu_=
wq).
> v4:
> - Add cpu_hotplug_disable() in watchdog_hardlockup_probe() to stabilize
>   the probe CPU.
> - Update description to explain the relevance of 4.19 logs.
> v3:
> - Refactor hardlockup_detector_event_create() to be stateless by returnin=
g
>   the event pointer instead of directly assigning to per-cpu variables.
> - Restore PMU cycle fallback and unify the enable/probe paths.
> v2:
> - Add Cc: stable@vger.kernel.org.
> v1:
> - Avoid 'watchdog_ev' in probe path by manually creating and releasing a
>   local perf event.
>
>  kernel/watchdog_perf.c | 50 +++++++++++++++++++++++-------------------
>  1 file changed, 28 insertions(+), 22 deletions(-)

Since I previously gave you my Reviewed-by tag and the changes you
made were minor (and exactly what I requested when I gave you my tag),
you should have kept my Reviewed-by tag in your v9. In general,
knowing whether to keep someone's Reviewed-by or Tested-by tag when
sending a new version is a bit of a judgement call, but in this case
it should have been pretty clear. Generally, if you remove someone's
tag that was given before it's good to mention "after the cut" why you
removed it. If you are unsure about keeping a tag but still decide to
keep it, you can still call attention to that fact "after the cut".

In any case:

Reviewed-by: Douglas Anderson <dianders@chromium.org>

No need to send a v10 adding that tag unless other changes are needed.
Andrew will add it when landing.

-Doug
