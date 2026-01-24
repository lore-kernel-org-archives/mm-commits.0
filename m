Received: from mail-dy1-f170.google.com (mail-dy1-f170.google.com [74.125.82.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13C7A1B81CA
	for <mm-commits@vger.kernel.org>; Sat, 24 Jan 2026 06:57:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.82.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769237848; cv=none; b=ufiRojrh9x4HZJEuQpdAx5kte89iTfKQHEw4lBr+vFAog+J70tt6tctAsGcdS2eLwZBK1FMSCqS+4egkdY1P6r0ISzakKLMfNinQC2xUFhrqX0/RKhs864FDRry9AMrSfHqG4D5oo1yDKPU6Bp9N2RtW6wf8OzS2Lr8C77RQdwk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769237848; c=relaxed/simple;
	bh=cC6e1KioY41c91yijmGbSSfZ61Ovdtzrqxzxhm4vNOc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aJMvG2+OeCK2CBYRSyGVjtMYB6ISL/Tq9SKRlwgqSsY7VLVonwMcDsMPmg469NgXOoGShn88M1z89znhuV+tsgmtG6bbHXgX1kQVHhBth9CFwCPHL0gYBvGry2lPP1bjVq4dGiwOyan7qsV7Wbov2bV9/6+a/dxzycGtkqa2E6w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Cl/IPlre; arc=none smtp.client-ip=74.125.82.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Cl/IPlre"
Received: by mail-dy1-f170.google.com with SMTP id 5a478bee46e88-2b4520f6b32so4688157eec.0
        for <mm-commits@vger.kernel.org>; Fri, 23 Jan 2026 22:57:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1769237846; x=1769842646; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=9zUgdI+AQs7RFvCShWYLUQ2AaO9+6oR78cTHkGs6KEk=;
        b=Cl/IPlre8xHPIRfyps4l4tcTCHh3y09WS04WUM3o8GqmAQkgUl2ARQrqE3ITu1oBK1
         xZwrKlTlWQbWM8LofeXevhQeStf2vMl4qsNUt4z5QamzP1Bv/RXyUakpV2BpQ7t7d5yO
         N61UsKR0SlgD6e9Gd7373afiOcH6sm5vBRz4V3nD2ZxY/9QiEqn3+VZXjJu2KvZvqLs2
         8w4KDb3xBi4ok+qqy65zIupoBchINi8q0aIfNH5CIS6JBgJ09d9Hic1IN8eSsyjuCImF
         uVClqdZFNq9htSZaZhveATPIRWa8LVN894tYagtu1FbMMK1I+rL9U46SMRmK1zbB8GPc
         0kAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769237846; x=1769842646;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=9zUgdI+AQs7RFvCShWYLUQ2AaO9+6oR78cTHkGs6KEk=;
        b=L+OvABfejYPP95hpIakkW975Vluyse3gIuJjJ+ea2zb2SB6eUXoAvHoM9tHzXJKhJU
         Fpn5xgwJI3KiwJA08/uTnEEnXehzOreXnk2ITgvcx03xiorsvcqLMQ45yiFKsNFcaKhm
         zS0HgnOZm4CvkiBAGzDrBSk2bvE3zAxdUoHElzhX+hEPL5cx0bKAApGV1OFUU2KDABgc
         qOXJmoYnYW0Ev707UoZWBc3fN8mx2J/50QCBnbyJtvNkTMhyHgWvojoqT/IK/vRfvTor
         fKKgR5kOLobJwE54T6XC7q8vGw+8mmwyWjJF57Csd3i5f/Y6bcwS1iUPTrngzLBM2RzV
         Wbwg==
X-Forwarded-Encrypted: i=1; AJvYcCW3Lk8IweeiX3C7E7JqWpV7gg9L/g6X1KzT0ROBYge/sgj6Y/9zRYjN/3fIgJKnOTvi1aMZAllue46g@vger.kernel.org
X-Gm-Message-State: AOJu0YyCRRKpohI4S7oAJWFlO1An6iK3VccVgUKg9GI8K0Q90drchtny
	sfob7fli/TTbInrEXKMJix3Buxjw3VG9gEMaquSNqDU6P2zrkySM96kx
X-Gm-Gg: AZuq6aIuoiHO9z8WmVlimXav7nLEfAjuTfumgBbfXX4EmlCM2TqIuWMyJ3xARwJEzPx
	qcdlmJL1EP6fIbcYEC0AvvYZx4wlyRl9tV2++yiUk/ca622W1DXGAeQhGZaWAZzLw8G/EWQbsTH
	UdWdmzY9CSn+ifvdKoShbqvxxC04GZespQOnEWIMqrKp48I/Ya8grli97jvTtVbrffTOLy/Lt4n
	TTGvuHJdY3d5pUpA/ysv+OnoxlcVH2w/Ka9Anfe/9b+gC0RNX9J1zyrFMPKX4UssfS9EXKnDuqd
	0oWGdCl2GnFikC4DEW4tvM8SqC4TgCeAvgWD2pQjOlG/5dbbMVDPIdW5RhWqlBImMggI4vemvKP
	aSIBbXrjD9haX110NRR4VhgB+DMeVlsfDWwuPh2M7ogW7/0AAP+txicYr/CS9F60+Ia+x3ZV8Zr
	Wg7gs=
X-Received: by 2002:a05:7300:e60d:b0:2b1:7910:b0f9 with SMTP id 5a478bee46e88-2b739bd0c1fmr2553928eec.42.1769237846080;
        Fri, 23 Jan 2026 22:57:26 -0800 (PST)
Received: from debian ([74.48.213.230])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-2b73a6c47d5sm5852866eec.10.2026.01.23.22.57.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 23 Jan 2026 22:57:25 -0800 (PST)
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
Date: Sat, 24 Jan 2026 01:57:19 -0500
Message-ID: <20260124065719.805144-1-realwujing@gmail.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <CAD=FV=WHWrKS_LVjod6nhnPdEk9_ZqeubGpft3PJOUJNMbBxfg@mail.gmail.com>
References: <CAD=FV=WHWrKS_LVjod6nhnPdEk9_ZqeubGpft3PJOUJNMbBxfg@mail.gmail.com>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Thanks for the detailed review!

> Wait a second... The above function hasn't existed for 2.5 years. It
> was removed in commit d9b3629ade8e ("watchdog/hardlockup: have the
> perf hardlockup use __weak functions more cleanly"). All that's left
> in the ToT kernel referencing that function is an old comment...
>
> Oh, and I guess I can see below that your stack traces are on 4.19,
> which is ancient! Things have changed a bit in the meantime. Are you
> certain that the problem still reproduces on ToT?

The function hardlockup_detector_perf_init() was renamed to
watchdog_hardlockup_probe() in commit d9b3629ade8e ("watchdog/hardlockup:
have the perf hardlockup use __weak functions more cleanly").
Additionally, the source file was moved from kernel/watchdog_hld.c to
kernel/watchdog_perf.c in commit 6ea0d04211a7. The v3 commit message
inadvertently retained legacy terminology from the 4.19 kernel; this will
be updated in V4 to reflect current ToT naming.

The core logic remains the same: the race condition persists despite the
renaming and cleanup of the __weak function logic.

Regarding ToT reproducibility: while the KASAN report originated from
4.19, the underlying logic is still problematic in ToT. In
watchdog_hardlockup_probe(), the call to
hardlockup_detector_event_create() still writes to the per-cpu
watchdog_ev. Task migration between event creation and the subsequent
perf_event_release_kernel() leaves a stale pointer in the watchdog_ev of
the original CPU.

> Probably want a "Fixes" tag? If I had to guess, maybe?
>
> Fixes: 930d8f8dbab9 ("watchdog/perf: adapt the watchdog_perf interface
> for async model")

Commit 930d8f8dbab9 introduced the async initialization which allows
preemption/migration during the probe phase. This tag will be included in
V4.

> I'm still a bit confused why this warning didn't trigger previously.
> Do you know why?

In 4.19, hardlockup_detector_event_create() did not include the
WARN_ON(!is_percpu_thread()) check, which was added in later versions. In
ToT, this warning is expected to trigger if watchdog_hardlockup_probe()
is called from a non-per-cpu-bound thread (such as kernel_init). This
further justifies refactoring the creation logic to be CPU-agnostic for
probing.

> I guess it's implied by the "Allow migration during the check", but I
> might even word it more strongly and say something like "The cpu we
> use here is arbitrary, so we don't disable preemption and use
> raw_smp_processor_id() to get a CPU."
>
> I guess that should be OK. Hopefully the arbitrary CPU that you pick
> doesn't go offline during this function. I don't know "perf" well, but
> I could imagine that it might be upset if you tried to create a perf
> event for a CPU that has gone offline. I guess you could be paranoid
> and surround this with cpu_hotplug_disable() / cpu_hotplug_enable()?

The point is well-taken. While unlikely during early boot, adding
cpu_hotplug_disable() ensures robustness.

V4 will be submitted with the following changes:
1. Clarified commit message (retaining 4.19 logs while explaining the
   renaming to watchdog_hardlockup_probe).
2. Inclusion of the "Fixes" tag.
3. Addition of cpu_hotplug_disable() around the probe.
4. Refined comments.

Best regards,
Qiliang
