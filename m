Received: from mail-dy1-f177.google.com (mail-dy1-f177.google.com [74.125.82.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ADD0E22D785
	for <mm-commits@vger.kernel.org>; Mon, 26 Jan 2026 03:30:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.82.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769398222; cv=none; b=YITeL7VirMB5Q4s1y5ojpM+gfZCrVbc6aLjrNqc3nZzQlakhBBvoO1JSV89NBSaK0SgXFLCeDkx19Ba7QkJ4wqUxdCw/1VhTuVwcRD/QCZnt3nV+RlrIwXWJQkwuw0oZESTa/MrrRpmw0NLuParG/t+sApdQ13nRdPAlkoaNQTM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769398222; c=relaxed/simple;
	bh=odnHQjFmvL9q0KAXvfxM5lKxhjvove08qebNT2N/TYU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XXQ2eXp+7kCyAPb2cJr2GQA/cjuMPSRzo+e/ECm/jwYJCkeDsFLoFuyQaahrZjzwsKUqnUiBR50fEblxIZMfsJLuSdkk2orJNDZE276JxYqEnh1KXiojWTaouT0+xChKMwJ+gV/NQTGuTyan64NEOVhUNgk8+EzirKIWsNyODHs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=SQjsEPuF; arc=none smtp.client-ip=74.125.82.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="SQjsEPuF"
Received: by mail-dy1-f177.google.com with SMTP id 5a478bee46e88-2b7070acfdcso4609283eec.0
        for <mm-commits@vger.kernel.org>; Sun, 25 Jan 2026 19:30:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1769398220; x=1770003020; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ALi30XfcHcP7oXf6VT++jD7PYo4ntaFHOPvpKBXFeRE=;
        b=SQjsEPuFoIIv7vmZ7ST28ifCdVexsZ28ScvlTDN52PrkEH5NlA2sQIOUK10k3oAJL3
         pa0k6jbiEkAgqUPf8wmr9U+BPL/DTTcKV0Ck2FHi+UzTTxlTuvkprKJNuENYnlPqv2qn
         A5N+ybjv0TCQ/eO5lXJ92ICEjxvZw6wV+v4kMVRBxhuvTG7GB7iqBadSKun+Zwqfn0vt
         Ng3CQENVMvyD9652ZpFMzEIfa0f3rS1Hh6HCeosfUMmsNDhnNoakjk44c8WyD+LrdlRT
         WVBmufytixsYpL6pONB6BKDk1PEcDlHuCFCV81DB9Bvz5zkzeYJnwDWgHu5A0gTgdjZs
         41tA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769398220; x=1770003020;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=ALi30XfcHcP7oXf6VT++jD7PYo4ntaFHOPvpKBXFeRE=;
        b=wAGCFOD8JFK9JhsSGRplXS/efHOeKHqOioCgFC0Z5CoVJrYB0q7jwtE/4t3H8ubFli
         GkqefRC9ZsAlaZzy4LoRZK+sShPdT2w+RScWkAuoWknk5/SVXdl5uYyHG7glm3np0Jsi
         bI7D3uUk6CsR6xMcgx/ZRwT45ZKqrpa+MgsYQ9Wg8pM7a2Y70sDgcS7LulAAhT/U9id6
         EkAR1ogE5n3w6qmbkzI7Dfe07zwLn6qPyY0advZQqGCzE4ihpmo0UI2FkQ2cmBnCBIUq
         9+YDQyfgHMiBtKTYAfTmDnV0ito6JdR93T800kJuEacXX0kzX+EakC+/ZiIjpVHHuJZN
         aMcw==
X-Forwarded-Encrypted: i=1; AJvYcCVsLQirkL3lRRJC394hXHQF3H+JkzHtplffSIIONkYQLDE3Tb0ZNgoSl1ReNquq89wmer7w7lcaWiSA@vger.kernel.org
X-Gm-Message-State: AOJu0Yw4zyJ9Q62aV09csx/xBWuWxWQiAKQivK9Xf5W5H+lq91DPFM1A
	OxS6rAZYAWhzp27mEV9c7raf+6MvFtOl5BBWsGRtRS5ByyWPp+H/U4y8
X-Gm-Gg: AZuq6aJTLIRJp6ig8jk/izyiI0UI8NjJd761lhMEb3NHWDd7NuK8ezr+KZ9nMphr16L
	zBtXuQuCoA1/KiBZf7Miy5CRHWSHUwIo7/h894ZN5XOE6+OeU5rLjHy9u2Hape9U7y2+MlUculb
	/9MIUmBSftZgQb3we08EzEOCDeSBVWdulNWNnPGDvb3KofBqmd9d4uJJ+axttjhWbAVqWpL7685
	wYkH3g23kWest5OnFQpUZ1JYZwFJJ2l6tc8gA9d6YF6/tkBAEKNgze1vD+m4nfMNPLt7AGGOdsA
	PLjzU4IU1OgwBBSNOJt76UvKh+kAEX9USGuz1cp0KdmUKa/D/eSHkP1MFETRTXYcHIwWBgSWLY7
	i40t26zvwfTvRXdi+8KmPepGbVj7hEF7CNQOkYKDE7ycfuKyWOKtkoRogeiukIFTtTO3gZ/MlZI
	bmX6w=
X-Received: by 2002:a05:7022:511:b0:123:345b:ba05 with SMTP id a92af1059eb24-1248ebf7011mr1465124c88.22.1769398219711;
        Sun, 25 Jan 2026 19:30:19 -0800 (PST)
Received: from debian ([74.48.213.230])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-1247d90cda6sm15429026c88.1.2026.01.25.19.30.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 25 Jan 2026 19:30:18 -0800 (PST)
From: Qiliang Yuan <realwujing@gmail.com>
To: dianders@chromium.org
Cc: akpm@linux-foundation.org,
	lihuafei1@huawei.com,
	linux-kernel@vger.kernel.org,
	mingo@kernel.org,
	mm-commits@vger.kernel.org,
	realwujing@gmail.com,
	song@kernel.org,
	stable@vger.kernel.org,
	sunshx@chinatelecom.cn,
	thorsten.blum@linux.dev,
	wangjinchao600@gmail.com,
	yangyicong@hisilicon.com,
	yuanql9@chinatelecom.cn,
	zhangjn11@chinatelecom.cn
Subject: Re: [PATCH v3] watchdog/hardlockup: Fix UAF in perf event cleanup due to migration race
Date: Sun, 25 Jan 2026 22:30:12 -0500
Message-ID: <20260126033012.934143-1-realwujing@gmail.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <CAD=FV=Vmk1jA+dAgJNVDMtxrhhrPxgnXkNxiqJXWBvgUcZZUxQ@mail.gmail.com>
References: <CAD=FV=Vmk1jA+dAgJNVDMtxrhhrPxgnXkNxiqJXWBvgUcZZUxQ@mail.gmail.com>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi Doug,

Thanks for your further questions and for digging into the 4.19 vs ToT
differences.

On Sat, 24 Jan 2026 15:36:01 Doug Anderson <dianders@chromium.org> wrote:
> The part that doesn't make a lot of sense to me, though, is that v4.19
> also doesn't have commit 930d8f8dbab9 ("watchdog/perf: adapt the
> watchdog_perf interface for async model"), which is where we are
> saying the problem was introduced.
> 
> ...so in v4.19 I think:
> * hardlockup_detector_perf_init() is only called from watchdog_nmi_probe()
> * watchdog_nmi_probe() is only called from lockup_detector_init()
> * lockup_detector_init() is only called from kernel_init_freeable()
> right before smp_init()
> 
> Thus I'm super confused about how you could have seen the problem on
> v4.19. Maybe your v4.19 kernel has some backported patches that makes
> this possible?

You caught it! Here is the context for the differences:

1. Mainline (ToT):
   - `lockup_detector_init()` is always called before `smp_init()`
     (pre-SMP phase).
   - Risk source: The asynchronous retry path (`lockup_detector_delay_init`)
     introduced by 930d8f8dbab9, which runs in a workqueue (post-SMP)
     context and triggers the UAF.

2. openEuler (4.19/5.10):
   - Local `euler inclusion` patches moved `lockup_detector_init()` after
     `do_basic_setup()` (post-SMP phase).
   - Risk source: The initial probe occurs directly in a post-SMP
     environment, exposing the race condition.

For openEuler (4.19/5.10) kernel, the call stack looks like this:
  kernel_init()
  -> kernel_init_freeable()
    -> lockup_detector_init()       <-- Called after smp_init()
      -> watchdog_nmi_probe()
        -> hardlockup_detector_perf_init()
          -> hardlockup_detector_event_create()

In mainline (ToT), the initial probe (safe) call stack is:
  kernel_init()
  -> kernel_init_freeable()
    -> lockup_detector_init()       <-- Called before smp_init()
      -> watchdog_hardlockup_probe()
        -> hardlockup_detector_event_create()

However, the asynchronous retry mechanism (commit 930d8f8dbab9) executes the
probe logic in a post-SMP, preemptible context. 

For the mainline (ToT) retry path (at risk), the call stack is:
  kworker thread
  -> process_one_work()
    -> lockup_detector_delay_init()
      -> watchdog_hardlockup_probe()
        -> hardlockup_detector_event_create()

Thus, `930d8f8dbab9` remains the correct "Fixes" target for ToT.

> OK, fair enough. ...but I'm a bit curious why nobody else saw this
> WARN_ON(). I'm also curious if you have tested the hardlockup detector
> on newer kernels, or if all of your work has been done on 4.19. If all
> your work has been done on 4.19, do we need to find someone to test
> your patch on a newer kernel and make sure it works OK? If you've
> tested on a newer kernel, did the hardlockup detector init from the
> kernel's early-init code, or the retry code?

In newer kernels, when the probe fails initially and falls
back to the retry workqueue (or even during early init if preemption is
enabled), the `WARN_ON(!is_percpu_thread())` in
`hardlockup_detector_event_create()` does indeed trigger because
`watchdog_hardlockup_probe()` is called from a non-bound context.

I have verified this patch on the openEuler 4.19 kernel. During our stress
testing, where we start dozens of VMs simultaneously to create high resource
contention, the UAF was consistently reproducible without this fix and is now
confirmed resolved.

The v4 patch addresses this by refactoring the creation logic to be stateless
and adding `cpu_hotplug_disable()` to ensure the probed CPU stays alive.

I'll wait for your further thoughts on v4:
https://lore.kernel.org/all/20260124070814.806828-1-realwujing@gmail.com/

Best regards,
Qiliang
