Received: from mail-ed1-f50.google.com (mail-ed1-f50.google.com [209.85.208.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00D2727E1D7
	for <mm-commits@vger.kernel.org>; Wed, 28 Jan 2026 17:45:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769622354; cv=none; b=ZO2sWEnt6yRcDgsn3aTR41g0RqjeHvjeLzswzoeo35QJUidQK28qs4RP7DdLasvsu1stzNmH1FwhFqeclJ9353ghlQm7eonFaAhsVvO0LN61Y5mvsvp6uB3qeedJg6HO5ehC7ofzIBxS9HYNi2JFojaAHmK3MI/FRZh5dAEOmHE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769622354; c=relaxed/simple;
	bh=/DSD2/sPyL8FmcHgyMED94jzTeSwMun6lVd6lxWucrk=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=OkJVDRNK11Z+jZe8j1oWBYmtG55UMGp5HWRboUYNjRmPjPpPswfo4uXeOixMRyR9JFfR3U1cl+1HXK6vymUWhlNXqFjOIuZ0qnv7k7PKYlV9P8it2zmMH5QhJFQVp6+6T+Pe9Bgz3TmNqJ3+GMFId/EMASDVa92fQgEZ2PgVzYo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org; spf=pass smtp.mailfrom=chromium.org; dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b=McmDtG5/; arc=none smtp.client-ip=209.85.208.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chromium.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="McmDtG5/"
Received: by mail-ed1-f50.google.com with SMTP id 4fb4d7f45d1cf-65378ba2ff7so195309a12.2
        for <mm-commits@vger.kernel.org>; Wed, 28 Jan 2026 09:45:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1769622350; x=1770227150; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=xnoeltQBlPZ0H7ua38KhvkZ21OQ9tEi8rtpciY4lEe8=;
        b=McmDtG5/gcNScalTCOdzIX/N0zbsujx2ir67BzUjMYc9cDOsbEZsHNtxiGQrE2s3nN
         v3Mld3OC1z2xpXs8ZnSwUc1nofVxXyqc4/RIE1l3bgNL8LhX4Uyhvpg+TNdyf1dFnQ15
         qEzujoQdSliBQ48fncEHn7KIjjwIZbZTzRir8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769622350; x=1770227150;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=xnoeltQBlPZ0H7ua38KhvkZ21OQ9tEi8rtpciY4lEe8=;
        b=MeVwWjTcfFfYFIKP9NQVF1/H+ioD8103zDWm9b19Vy3f6Rs9SobxM60VLgr/LzecX9
         Qq5AtBbvvAo9BlzTEmdqDKIiTJw5/+RWwwDF4v68I9Gq+ATzOYZGnnkxMOvav/O+lbGf
         NwQvIx0FAZHo6j5nQZ0PgOPcYrAjhkLWTAYU68sh6hzT6idXD1klZfuR4PRGc06iez/m
         d04D8nvLO3GZuXUKuCGDEDE21o2Wbmi/cRAIL1RLT2QhsIOMIuIhMpPTVCwcU7iSlMpr
         3Ctmz92JxBpR2daApRWh63Ln/18SXy89xeLuNCdMcp/HlQOJcAzTEDiUHWSfNsdu3Ooj
         +i4w==
X-Forwarded-Encrypted: i=1; AJvYcCUw3jfWkN/biQeJLpIi2fSyavmebtHo8a2uOYDjOrcuOg++Zkg3q25gF0lAz3GzFaFkSZMN5m1u3+Ak@vger.kernel.org
X-Gm-Message-State: AOJu0YxjzQaleBouKJlZFcFnb31QVqdWMIljvOvCC4I89u8AlkkAs6i1
	W5JOaY3tiLmQ7irGSzap8uLJLeVqcsdIa8ARhHIJDMVhBMmhmAKMybD3NVZqAbmGDw4sxcvmiWh
	l6DfFUv0N
X-Gm-Gg: AZuq6aIxS6XaKhZXKgS3bBTcG4VfGgi/Gi7IftVF9ImcaGfTUTC+KgOnWY7JnriY5N4
	D78wE1l+fx7bAFk7O2QjvDUArr/aSwrmvc6jfXJiuOATukwhnuchfHo4Y6o6DvITEbt2+fkk1vt
	aC5Au9UXQNFoAtrE00PPsaXMv9b1A8XdTR86DDuq+/N6z5VJJ/5OOmCb3kQhycI85rNvSyW/5t6
	1YMZA+NORFoYRFVBbW1QL85Bpeygoi6Jvv2gMaTBPl//OBYKKlck+Lt0QQASwZgbAinNttnXYt+
	i3yQv4fCHPpHtHghAl1OmUdR9QDeA1W/mT5furU7kFiAHPq4l+hbF8JnndkLbx2cWuWpqNpA1I9
	oXvBozmXHXjAA5sKDb5fCW/qfG+WKGxDuTO38wYrQRc4q1V5uZbPLUGT3FGFmtbbRUcRTJwJ9Mf
	luvC2j7tBAojvh5G+NT4yRyaeFe8s99qs79QnZR1XFIB0C0skEdg==
X-Received: by 2002:a05:6402:1d50:b0:64b:6e44:217 with SMTP id 4fb4d7f45d1cf-658a5f8e7cdmr3758948a12.0.1769622349616;
        Wed, 28 Jan 2026 09:45:49 -0800 (PST)
Received: from mail-wr1-f50.google.com (mail-wr1-f50.google.com. [209.85.221.50])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-658b44530bbsm1693830a12.13.2026.01.28.09.45.47
        for <mm-commits@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 28 Jan 2026 09:45:48 -0800 (PST)
Received: by mail-wr1-f50.google.com with SMTP id ffacd0b85a97d-42fb0fc5aa9so96842f8f.1
        for <mm-commits@vger.kernel.org>; Wed, 28 Jan 2026 09:45:47 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCVodYP0ukO2UqJXTDFNtVY6Gg4qQxBxHRuLQqu4mKs+FLoPFfQnoeZuolXuT9Jneez0jtTAwiTPwb18@vger.kernel.org
X-Received: by 2002:a05:6000:290f:b0:431:32f:3159 with SMTP id
 ffacd0b85a97d-435dd0515ccmr8337100f8f.7.1769622347483; Wed, 28 Jan 2026
 09:45:47 -0800 (PST)
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260128115358.1757147-1-realwujing@gmail.com>
In-Reply-To: <20260128115358.1757147-1-realwujing@gmail.com>
From: Doug Anderson <dianders@chromium.org>
Date: Wed, 28 Jan 2026 09:45:36 -0800
X-Gmail-Original-Message-ID: <CAD=FV=VrFw42KRfR=ysP=MSWnukQGnwGwoAu310TG3KUU9cp3w@mail.gmail.com>
X-Gm-Features: AZwV_QhlaVCDV7ybg4oJPu9aF6t-TzoOyVFwOrBGKKCD7DAAb9Htu1_9kAyr3ws
Message-ID: <CAD=FV=VrFw42KRfR=ysP=MSWnukQGnwGwoAu310TG3KUU9cp3w@mail.gmail.com>
Subject: Re: [PATCH v8] watchdog/hardlockup: simplify perf event probe and
 remove per-cpu dependency
To: Qiliang Yuan <realwujing@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>, Li Huafei <lihuafei1@huawei.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Jinchao Wang <wangjinchao600@gmail.com>, 
	Thorsten Blum <thorsten.blum@linux.dev>, Yicong Yang <yangyicong@hisilicon.com>, 
	linux-watchdog@vger.kernel.org, mm-commits@vger.kernel.org, 
	Shouxin Sun <sunshx@chinatelecom.cn>, Junnan Zhang <zhangjn11@chinatelecom.cn>, 
	Qiliang Yuan <yuanql9@chinatelecom.cn>, Song Liu <song@kernel.org>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi,

On Wed, Jan 28, 2026 at 5:29=E2=80=AFAM Qiliang Yuan <realwujing@gmail.com>=
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
> v8:
> - Add Signed-off-by with work email.
> - v7 link: https://lore.kernel.org/all/20260128060833.1715622-1-realwujin=
g@gmail.com/
> v7:
> - Update Signed-off-by to match author email.
> - Remove redundant cpu_hotplug_disable() in probe path.
> - v6 link: https://lore.kernel.org/all/20260128023136.1691973-1-realwujin=
g@gmail.com/
> v6:
> - Change title to "simplify/cleanup" and remove "Fixes" tag since the iss=
ue
>   is not reproducible on mainline.
> - Rewrite commit message in imperative mood.
> - Clarify that mainline is safe while this improves robustness.
> - v5 link: https://lore.kernel.org/all/20260127022238.1182079-1-realwujin=
g@gmail.com/
> v5:
> - Refine description: clarify that the retry path uses worker threads
>   without PF_PERCPU_THREAD (though mainline is safe due to system_percpu_=
wq).
> - v4 link: https://lore.kernel.org/all/20260124070814.806828-1-realwujing=
@gmail.com/
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
>  kernel/watchdog_perf.c | 51 ++++++++++++++++++++++++------------------
>  1 file changed, 29 insertions(+), 22 deletions(-)
>
> diff --git a/kernel/watchdog_perf.c b/kernel/watchdog_perf.c
> index d3ca70e3c256..4a798443033b 100644
> --- a/kernel/watchdog_perf.c
> +++ b/kernel/watchdog_perf.c
> @@ -17,6 +17,7 @@
>  #include <linux/atomic.h>
>  #include <linux/module.h>
>  #include <linux/sched/debug.h>
> +#include <linux/cpu.h>

IIRC, the above include was added for the call to
cpu_hotplug_disable(), which has now been removed. The #include can be
removed now, right?

In any case:

Reviewed-by: Douglas Anderson <dianders@chromium.org>
