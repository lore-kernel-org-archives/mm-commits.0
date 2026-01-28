Received: from mail-ej1-f42.google.com (mail-ej1-f42.google.com [209.85.218.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A720231A23
	for <mm-commits@vger.kernel.org>; Wed, 28 Jan 2026 04:08:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769573297; cv=none; b=Nps+o/YZMQdH9S37zGhzZd237E+7QAulKAkKe1LiMrnsB0ZMuM5fogeSFIglUfeh8a9WN3Fd6epfbylb7QhZlZ2DTbFS+0WCWmZVokp/HePRoYBTaonDCqMf2vPZARgfyTzwPp2DO26WiHvVgx2C8nTAB7u53kIo/KWkp10TTBU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769573297; c=relaxed/simple;
	bh=IKS3rm5HaKGj1cSZc9Q9841iwotUmP6mNanLxQbk4Us=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=fQaVd3y3xSkhq9oAJYqCAF+EoSV+wneVlreQh1uHYU7r9kzhfxByD30c9MfGhSajIPIX1YhGHH/eXtNhqtrx+OIP6CippIXNAq5k5PCHMiE6FLFH5T2o0xzj3+S/1mj9vvGKumMu2ybF4eZn/m7jPqeixlFMfLBRdqMQ+JjPCt0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org; spf=pass smtp.mailfrom=chromium.org; dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b=VKkmHZa7; arc=none smtp.client-ip=209.85.218.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chromium.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="VKkmHZa7"
Received: by mail-ej1-f42.google.com with SMTP id a640c23a62f3a-b8845cb580bso1135522266b.3
        for <mm-commits@vger.kernel.org>; Tue, 27 Jan 2026 20:08:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1769573293; x=1770178093; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=E+SBx2bhyAxpOr0xPAhvkbF9K+DXCdj305biHMr2LWg=;
        b=VKkmHZa7+qD/9ioUm7My3/ECcIJ40G98857Nv9A9zAQJQm1wZ946afSlImRZ5ElmSx
         LGXEoqLoSCKxk/2+7mx/MnPT9LIs3iKjTIZpsQDalRNY3RF10UD0bVfKs2EZw3KKdjTi
         tSHPwUYxbUvLxpkfp1p1+Avs7Mm0S3n/o/BPU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769573293; x=1770178093;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=E+SBx2bhyAxpOr0xPAhvkbF9K+DXCdj305biHMr2LWg=;
        b=ci4aOui8TkaubsoioHeYuRzuwpisM9mQBarP/XrKYwDCbkKE/Gx9HNhldF5bNd2uLu
         uw51/C23BVJ2dOHRYRyurRHl5DPsfeUE1h9pMZDQ+lof0Iyb43lPRPalZlgzVyCGfbyC
         u/KRriUGiJtOv7GhAK5UTHam00H0YTjPY4ELfUlIc+eD1xBdUFUiIUJ1zH/kQLq00esd
         XFEi1PEp9Qwre9PLMMR/bcNRcY9owjRBXKpWxFcUnWe6BW7LkqDLmpyc9wc7iPjo4+KG
         HNFuygdhxrMf4Qpydf+0QsxCOGYCYFjYLTGwKVWVt4XuTRTvgatqgzmemoVxUpXjRPha
         fysQ==
X-Forwarded-Encrypted: i=1; AJvYcCUCRFspP2BdYjOQ5VfFl8gyCpVLQ282Osofb+nWWJct17QUjObjJ0CP5Oa2yfJzdVZTz6g3s9wE0geo@vger.kernel.org
X-Gm-Message-State: AOJu0YxoPAacRZ5SCs2xazRvr+DHvs/EFyuxemDj0Nw6wE7qXXuUB72O
	wfWqZYP742MEv6aNnRl1X21V4bQxnXEWDKX+jsm8UMDw+W66KvuspKdqhUKt+dg08yRoU+yYVsC
	9f6TzmeXP
X-Gm-Gg: AZuq6aI6opbUVY2ILaO1AP7QjG73hFsgntR4raazIJxXy9yAY/4w1OeIZSVqgyx3fPf
	FGhYRLzcPX3AlumIsYsX7DzxmvqRN7EXIDEOBlc/ND2B3ki6GaU+DMiKzKnLRJd0j3JMp9ZvjV0
	axVKUYd6ow7g5bLOweVNMIlP6aQ/WYxKFkN9Wl6S7hg3R+MlSiS/CSGsmMlIPfbkaYA3+m1e23s
	VwcASdFoFEIrv5YTvWcSoS4xAeZYbD2xH9oJbjgsV3lxFZByvBTR1BsjEyrH2Vq/NgGzBYOhIeh
	8rS+qYOR+b8XpgcfvaomuadfjnnrmiKBJ/hcQtWhZigI9OKJ+WncMm1VHq+UG4e5/XK8evdLyE1
	jAArobB/gJda7twj0aO64ScUCkCDB4uL8NJ4lgaKiLZqca82jkcn79y9okARxULCDqmEixS3mAO
	dYd/ZfTWyNPjFK6W/N3hXTp/3f7cgfRTDk+bKMnypEEPeFsZU5lA==
X-Received: by 2002:a17:907:9622:b0:b87:117f:b6f1 with SMTP id a640c23a62f3a-b8dab152abbmr280806466b.2.1769573292850;
        Tue, 27 Jan 2026 20:08:12 -0800 (PST)
Received: from mail-wr1-f52.google.com (mail-wr1-f52.google.com. [209.85.221.52])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b8dbffb7263sm62788266b.28.2026.01.27.20.08.11
        for <mm-commits@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 27 Jan 2026 20:08:12 -0800 (PST)
Received: by mail-wr1-f52.google.com with SMTP id ffacd0b85a97d-42fb0fc5aa9so3704451f8f.1
        for <mm-commits@vger.kernel.org>; Tue, 27 Jan 2026 20:08:11 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCURcZZWSYMqp7fkhTpcF8A1Ty2dEgJaBFqiCnnAZT76mS+rHprJ2loZZ8Szlsxdki1Nkv7n78QoRNV0@vger.kernel.org
X-Received: by 2002:a05:6000:25c6:b0:429:b751:7935 with SMTP id
 ffacd0b85a97d-435dd1d7c61mr4787319f8f.56.1769573291404; Tue, 27 Jan 2026
 20:08:11 -0800 (PST)
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260128023136.1691973-1-realwujing@gmail.com>
In-Reply-To: <20260128023136.1691973-1-realwujing@gmail.com>
From: Doug Anderson <dianders@chromium.org>
Date: Tue, 27 Jan 2026 20:08:00 -0800
X-Gmail-Original-Message-ID: <CAD=FV=XX0dJ2jEaQ21M4Kas6pbJL0SSCxYhr8-1kqSTEiJP_UA@mail.gmail.com>
X-Gm-Features: AZwV_QgdeU-M1S25dbD0bfuUkv4_GToYEVkAE_Sry3IUpeS5khRlkZo5Q_oaJ0E
Message-ID: <CAD=FV=XX0dJ2jEaQ21M4Kas6pbJL0SSCxYhr8-1kqSTEiJP_UA@mail.gmail.com>
Subject: Re: [PATCH v6] watchdog/hardlockup: simplify perf event probe and
 remove per-cpu dependency
To: Qiliang Yuan <realwujing@gmail.com>
Cc: Li Huafei <lihuafei1@huawei.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Ingo Molnar <mingo@kernel.org>, Jinchao Wang <wangjinchao600@gmail.com>, 
	Yicong Yang <yangyicong@hisilicon.com>, Thorsten Blum <thorsten.blum@linux.dev>, 
	linux-watchdog@vger.kernel.org, mm-commits@vger.kernel.org, 
	Shouxin Sun <sunshx@chinatelecom.cn>, Junnan Zhang <zhangjn11@chinatelecom.cn>, 
	Qiliang Yuan <yuanql9@chinatelecom.cn>, Song Liu <song@kernel.org>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi,

On Tue, Jan 27, 2026 at 6:32=E2=80=AFPM Qiliang Yuan <realwujing@gmail.com>=
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
> Use cpu_hotplug_disable() during the probe to ensure the target CPU
> remains stable throughout the availability check.
>
> Signed-off-by: Shouxin Sun <sunshx@chinatelecom.cn>
> Signed-off-by: Junnan Zhang <zhangjn11@chinatelecom.cn>
> Signed-off-by: Qiliang Yuan <yuanql9@chinatelecom.cn>
> Cc: Song Liu <song@kernel.org>
> Cc: Douglas Anderson <dianders@chromium.org>
> Cc: Jinchao Wang <wangjinchao600@gmail.com>

One last note is that your Signed-off-by tags don't match. When I
apply your patch, I see:

Author:     Qiliang Yuan <realwujing@gmail.com>

...but your Signed-off-by is your "@chinatelecom.cn" address. That's
generally not okay. You need to do something to make those match. My
guess is that locally you're using git-send-email and everything looks
good on your end, but then you use your gmail account to login to a
SMTP server to send your patch. Gmail silently rewrites your patch to
be sent from the Gmail address you logged in with.

You'll need to work on your email setup to fix that. Andrew can
correct me if I'm wrong, but I think he can't really commit your patch
until you've resent it with that fix.


> @@ -263,19 +259,35 @@ bool __weak __init arch_perf_nmi_is_available(void)
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
> +        * The requested CPU is arbitrary; preemption is not disabled, so
> +        * raw_smp_processor_id() is used. Surround with cpu_hotplug_disa=
ble()
> +        * to ensure the arbitrarily chosen CPU remains online during the=
 check.
> +        * The event is released immediately.
> +        */
> +       cpu_hotplug_disable();

Given our newest understanding, the cpu_hotplug_disable() isn't truly
needed anymore, but I'm still good keeping it. Perhaps we can
eventually make the caller not need to queue the work on the system
workqueue.

With your Signed-off-by fixed, I'd be happy with:

Reviewed-by: Douglas Anderson <dianders@chromium.org>

NOTE: I am not currently set up to test this patch (either through the
main probe path or the retry path) so I haven't personally validated
it. That being said, the code looks right to me. :-P

-Doug
