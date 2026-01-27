Received: from mail-dy1-f174.google.com (mail-dy1-f174.google.com [74.125.82.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D0B73398A
	for <mm-commits@vger.kernel.org>; Tue, 27 Jan 2026 02:17:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.82.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769480240; cv=none; b=lznRiHWx68lVjHuVkfJB6LquBYqiutwgkKX+0dSJvNLoG12+yKFcjvxVCnZv2Fv21NJ5hNFr5yeqSc+awnfhLnN8Nm/B3ctpQs/4KsXtrffJhBWV4azPFZruuqjfoDRYrXECqJGpE9iZzStQ26oZtNNC95w4Yu4uAKiTql92vyg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769480240; c=relaxed/simple;
	bh=25VI4oHzP0aWx8/NOg1WDXR3gKRU4PGxsQh/AZJv+oQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=TaLdeYeVvglS7W0QiBhHPszDa432Zc6EN2OuzDTaFSklLAXiY29sWFbXO7Y+OrHg5kpOO1rzzAUU9xq3nJKgMbjRsK/XJSsXfsbsmnE9ZPIonJIhTL1USCj0MY+w/2osPqg80puqF+xcYRrv4reGfakzQ59UiliI5Maw/28GHpc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=cEraHn0i; arc=none smtp.client-ip=74.125.82.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="cEraHn0i"
Received: by mail-dy1-f174.google.com with SMTP id 5a478bee46e88-2b71515d8adso4995371eec.1
        for <mm-commits@vger.kernel.org>; Mon, 26 Jan 2026 18:17:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1769480238; x=1770085038; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7BfFqoZAmKuiZwAth/3GTp8/RM+Lu+El376s9oBouTo=;
        b=cEraHn0iMeeUSywo7mhbU/OoSTubVRHiwDmMQVgLp2bk55y0K54MCKGxf0tnUnvMZl
         Jzqqc0NWdvzQCpekIrTTVxjNHtUn842Kh6wCT2nvyU80qQEwl6Ovr67C8P3m/TRk7n54
         PaojKD+r30kN4BodvbItJD74wPK1f1mGZAo1oqpqjcvjQM7hgJxpMFrouKZbOR0SfHbg
         XOpAHkIO5aD8GyhuLd7igcjEl2oMgmaLf8xyvCfmpGf0AfxxEJMChjRfW/8zFuYVyAXL
         UJaYW3LMnLCTZNpKpX2vgpshw9eYkJ7U2UwPspiCyh1FkQal31Uk4uSGU1Jo1VInPGx/
         NJpg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769480238; x=1770085038;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=7BfFqoZAmKuiZwAth/3GTp8/RM+Lu+El376s9oBouTo=;
        b=LBciZg7MbUFAA5yEwZzk3cZX9CKAoAtc/8mQ7tJ9canfGwT8KwGMecrsArDl52Oe7/
         H2RUE0WrHX5sgNDK+9nbq9Ui6gNuWUwNjiNTx46j6NhoWWxH2mx4pLQI7TCU2Oc1Fwde
         JcTNaYbqoO3X9bCg/OD3biux+Ud8TBDi4zN2RAh3oJ8y+lMIa9+2NXjIr9QHEB8+E/eg
         XR2yxDLpSGZywUm/FouAIHRtZT0v6jdd3C/p/9S8PbGEuF8q86ShkWYp1b+aXVJYkZJN
         iu8Kytvs7iplMull4jRAcBrVFd88QeRf5BHwW6F8rwkjHN/LC/Cd5W9JnoXL6Z1USB6G
         EnZA==
X-Forwarded-Encrypted: i=1; AJvYcCVogN4busyxRnYsFU/v+qsrLrpbqgm0gdWE+9vLXgboO+IsKv8TyNTzBNIEUkk+J8mVGCGqq5dptNd2@vger.kernel.org
X-Gm-Message-State: AOJu0YzXci7sASj7Yab676Nveg3AJbLIlx3YVYdP4sFM8tWvhG6ZFUa+
	5zZDZAVYvvxsY35TVuwXZeIGfvjMY5vIS+JrwCD0cJ2/6LlPv6AgvBUt
X-Gm-Gg: AZuq6aLrE3m/S7dXIVrNGblEVkLcMq5EOKWq05yVc7i5Gf7lKIddO8amdzylvyM6TeA
	ly67/dtIGBvQInss/TREqBGJryKpOHioJyUJy/y1yMHuf2WW6PWyKLHLVd4q3JogXGLGxOt1cl8
	iUVa+2IpebXqG75QPvDkgWdNrRO/+74WQ/l6nHHU+lrbbg6chb6SH3cD3PNRXkjze4ccBOkQGDA
	jmTbjalBn4h94V/p79zQbkK7BBJnWYn7w307rVhjEuJl6Nzf3loJUYu/PYKq3InZYqWml4sjGIb
	sLr3sAEJu6hN20Ixp1gUGgq7OaWGaJhTYuMwEmDHAOQebehXXJDYVbJ1FljiNdAXOpSCuYrq/Is
	m5oc/5Gy2rwDdlqUueBwa55f4Yvqe319AzKPue2rBbJxUYTZnFnYytxvs5i/nvGG1WR2LtKAIu/
	epTpg=
X-Received: by 2002:a05:7300:e607:b0:2b0:4b5b:6820 with SMTP id 5a478bee46e88-2b78d98ec0amr146038eec.26.1769480238323;
        Mon, 26 Jan 2026 18:17:18 -0800 (PST)
Received: from debian ([74.48.213.230])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-2b73aa2b1f6sm15490271eec.32.2026.01.26.18.17.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Jan 2026 18:17:17 -0800 (PST)
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
Subject: Re: [PATCH v4] watchdog/hardlockup: Fix UAF in perf event cleanup due to migration race
Date: Mon, 26 Jan 2026 21:16:54 -0500
Message-ID: <20260127021711.1180952-1-realwujing@gmail.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <CAD=FV=WVtFAPZ3=6pPnOV=vbMhFwfH9LaZ5oNgAKtcj5hA0q2Q@mail.gmail.com>
References: <CAD=FV=WVtFAPZ3=6pPnOV=vbMhFwfH9LaZ5oNgAKtcj5hA0q2Q@mail.gmail.com>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=y
Content-Transfer-Encoding: 8bit

Hi Doug,

Thanks for your insightful follow-up! It's great to have the openEuler vs. Mainline 
timing differences clarified—it definitely explains why we hit this so reliably 
in our downstream environment.

On Mon, Jan 26, 2026 at 5:14 PM Doug Anderson <dianders@chromium.org> wrote:
> OK, so I think the answer is: you haven't actually seen the problem
> (or the WARN_ON) on a mainline kernel, only on the openEuler 4.19
> kernel...
>
> ...actually, I looked and now think the problem doesn't exist on a
> mainline kernel. Specificaly, when we run lockup_detector_retry_init()
> we call schedule_work() to do the work. That schedules work on the
> "system_percpu_wq". While the work ends up being queued with
> "WORK_CPU_UNBOUND", I believe that we still end up running on a thread
> that's bound to just one CPU in the end. This is presumably why
> nobody has reported that "WARN_ON(!is_percpu_thread())" actually
> hitting on mainline.

You are right that in the latest mainline, schedule_work() has been updated 
to use 'system_percpu_wq'. However, in many LTS kernels (including 4.19), 
schedule_work() still submits to 'system_wq', which lacks the per-cpu 
guarantee.

More importantly, even on 'system_percpu_wq', the worker threads do not 
carry the PF_PERCPU_THREAD flag. is_percpu_thread() specifically checks 
(current->flags & PF_PERCPU_THREAD), which is reserved for kthreads 
specifically pinned via kthread_create_on_cpu(). Therefore, the 
WARN_ON(!is_percpu_thread()) in hardlockup_detector_event_create() is 
still violated in the retry path even on mainline.

The UAF risk stems from the fact that preemption is enabled during the 
probe. If the worker thread (even if on a per-cpu wq) is preempted or 
if the logic assumes the task cannot migrate (which is_percpu_thread 
usually guarantees), we have a logical gap. By making the probe path 
stateless and using cpu_hotplug_disable(), we eliminate this dependency 
entirely.

> If that's the case, we'd definitely want to at least change the
> description and presumably _remove_ the Fixes tag? I actually still
> think the code looks nicer after your CL and (maybe?) we could even
> remove the whole schedule_work() for running this code? Maybe it was
> only added to deal with this exact problem? ...but the CL description
> would definitely need to be updated.

The schedule_work() in lockup_detector_retry_init() (added by 930d8f8dbab9) 
is necessary for platforms where the PMU or other dependencies aren't ready 
during early init. 

I agree that the commit description should be updated to clarify that 
while the issue was caught in a downstream kernel with shifted init timings, 
it identifies a latent race condition in the mainline retry path. 

Regarding the 'Fixes' tag, since 930d8f8dbab9 introduced the asynchronous 
retry path which calls the probe logic from a non-percpu-thread context, 
it still seems like the appropriate target for the "root cause" of the 
vulnerability.

I'll refactor the commit message in V5 to better reflect this context 
and remove the emphasis on ToT being "broken" out-of-the-box (since early 
init is indeed safe there).

How does that sound to you?

Best regards,
Qiliang
