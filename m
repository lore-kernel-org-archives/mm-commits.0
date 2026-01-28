Received: from mail-dl1-f52.google.com (mail-dl1-f52.google.com [74.125.82.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13BCD2C0F97
	for <mm-commits@vger.kernel.org>; Wed, 28 Jan 2026 02:38:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.82.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769567885; cv=none; b=OEQHXOqTlN1hI03EkGFOePgxJy0T/Mo7QU/gWgXvuTB8HC9GZ4FOaP4L4jlseM/jXgdxY9L5xBwpthZFPAZ3gsoS9H+FSt8wm/VovQuKwshyXivIwHxbYpvh2Jlo53wgkKyn5Cg448w899wtHTf0MHNCmdwnLNg5/ZTBPfHGlzU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769567885; c=relaxed/simple;
	bh=TwSoeihKpQAs0Xculcg+xL4TrpYrf6SpB9Q3RJkipQg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mJRVXvh8hCzxVWYsoXP2OpDRYStRd2sR7+tiss+dM5XHnAwsKLYkQQYeD7dcE5ddZUd0eGp2zLI110eenLD7UxjaVX69e+MA1aRgYqKipeVmAhg0L8BkXnleZP3lwV/yFAT9cmL/DHKfew5p6frlmxvI68PbVxsc1n3MNuAcUoA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=RRVaoeKu; arc=none smtp.client-ip=74.125.82.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="RRVaoeKu"
Received: by mail-dl1-f52.google.com with SMTP id a92af1059eb24-1248d27f293so2351867c88.0
        for <mm-commits@vger.kernel.org>; Tue, 27 Jan 2026 18:38:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1769567883; x=1770172683; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=r6cfmUDBf1+qLRNX7vc1byRXhiT1ATCL/TBU1o+0kLY=;
        b=RRVaoeKu9NC5OoiU9WiyZ0cGih/jVa0ZZkrQ3nIFrhVB2RD4c8UZ3Ggy35CYqksb7y
         6evDHYXQlVHI9wwhM5c0WG3go/ShPWJSAlajY4CIBSY31Y5uFuh8iZTV60JY6j5ZpCOS
         JvPMSDTPJygx7b9J4NsR1C3tE8/VVcd+GcGNloJhxTgwVhX22/qcDuSzXyVYmeDqgewi
         yAqu7mMsgBxVc12Le2ccw3rhrnY7ea4tdsl7tZy8f1Jm8AkGcJ+rZXZw/t39j3/so5bT
         wfhmJObVSmG8EZSICJStdIZJpJnuGVBnOCYNOtNi7S9lOQF7bZfqnLCRgTAmBpnLC1qD
         GkpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769567883; x=1770172683;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=r6cfmUDBf1+qLRNX7vc1byRXhiT1ATCL/TBU1o+0kLY=;
        b=FvPKbcnmAsaCMfFhL4ThmlTHJJQnRNP0thPzgCL9l79s0qTUSGERWeg41xouhGxEHJ
         +DkJy5WsHUNP6tGh2lJntr0HMbPLeCswP7No9D6pLqR/Cpkg76Lt5E/yY37bZ9+aAnNX
         Fyni0LW6uEEuLIF4bU52vkxOd9jViFOg8AcvUaso1PR72SG6SngldNbw9K2EW6wtvSM1
         D2cTcS5QwrB22MRf3UaWE4BbSI5abXkSsCyZz41ArgffGdaDEmCh6V7CKhcSpUv/exXU
         /rZPnQbyF37u9npunT8RjQ8EvAo9/6qY4jyA2ZsqQKXLXrRZafUqVT7HFR3S2YyRPmbW
         7v6g==
X-Forwarded-Encrypted: i=1; AJvYcCUoFZXmoibQadGIzUyQBQZ05VHxfCinHxsCwGI/xyR4HFK2lMF6XpCg4JlCw4E4yfo8SpRlEJRm0AqJ@vger.kernel.org
X-Gm-Message-State: AOJu0YzFVQCKsyLQkjbCCstBI7kqiXzy0Q+ET9CHgzsLHcHvodxr5DxV
	FZChsG11V6kIHcftf0x1xzD69Rwykm/3vNpV5q0Vkb2uwHcfQ+w9N2se
X-Gm-Gg: AZuq6aIXnK/LCayy1vH9oxNFb7rJd/NtGqqVQHOU1h10vlq4TnFWp+P5WUQ30HNMCZB
	s/RgwAycnYEaaxLDZ+qUOuH2xga7Qxyk8YCsadDkk0CwOmTi3ccsiwvVGhTlTdVwX2EvNwAJcUe
	+AIXcwkLS3BhTi6skfV3WEPmKmtlrMtydV6EbXuUVbI+Xt1QA76RSslYHKOtVPNmpkRA7IbKl4w
	+0fIxs3+cLK64wrqXZsETCMYXH/kCiJ5m3bFIuS5VGdINhEckdHjSbHQKiKLfGDDIx0YFNzAlr3
	9DWYE96+q69hy/mREPKHa48CSIobWlj8InLKmklfJd+qHZB0ReDtEGEXgTM7c8pzfvKDcQeOJ3N
	NRx/noHytJO507VkrNJQSmHo9HdhfbPrTdsMaBLjJpluFgktpZ7Sgk0AbDqjvpDAFicmUtKHUNR
	DWWqU=
X-Received: by 2002:a05:7022:f96:b0:119:e56b:c75c with SMTP id a92af1059eb24-124a00deeb4mr2362361c88.33.1769567882811;
        Tue, 27 Jan 2026 18:38:02 -0800 (PST)
Received: from debian ([74.48.213.230])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-124a9de948esm781862c88.9.2026.01.27.18.37.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Jan 2026 18:38:02 -0800 (PST)
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
Date: Tue, 27 Jan 2026 21:37:52 -0500
Message-ID: <20260128023757.1693269-1-realwujing@gmail.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <CAD=FV=U6sM71UuPbYZRWV87=p1ZO8-gpv3yzK8eMEv3dRNVgdA@mail.gmail.com>
References: <CAD=FV=U6sM71UuPbYZRWV87=p1ZO8-gpv3yzK8eMEv3dRNVgdA@mail.gmail.com>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi Doug,

Thanks for your detailed feedback and for the patient explanation regarding the 
mainline workqueue behavior.

On Tue, 27 Jan 2026 13:37:28 Doug Anderson <dianders@chromium.org> wrote:
> Really, it matters what schedule_work() does on anyone who happens to have
> commit 930d8f8dbab9 ("watchdog/perf: adapt the watchdog_perf interface
> for async model")... we have to focus on supporting the mainline kernel here.

I completely agree that the focus must be on the mainline kernel. I've since
checked and confirmed that in mainline, schedule_work() is redirected to
system_percpu_wq (via include/linux/workqueue.h), which provides the
necessary CPU affinity.

> To ask directly: have you seen this WARN_ON in mainline, or is this
> all speculative?

To be direct: no, I haven't seen this WARN_ON on a pure mainline kernel. As
you suspected, the issue was identified in a downstream 4.19-based kernel
with different initialization timings and workqueue behavior. My assumption
that it would also affect mainline was indeed speculative and based on an
incomplete understanding of include/linux/sched.h's is_percpu_thread()
implementation on modern kernels.

> I'm still not convinced that there was ever a UAF in mainline nor that
> this actually "Fixes" anything in mainline. I do agree that the code
> is better by not having it write the per-cpu variable at probe time

Since the risk is not currently manifested in mainline, I have refactored
the patch as a "cleanup and robustness improvement" as you suggested. This
removes the fragile implicit dependency on the caller's context and makes
the probe stateless.

I have sent v6 with these changes. Please ignore v5 and review v6 instead.

v6 changes:
- Renamed the title to "simplify perf event probe and remove per-cpu dependency".
- Removed the "Fixes:" tag and "Cc: stable".
- Rewrote the commit record in the imperative mood.
- Updated the description to clarify that it addresses code brittleness
  rather than a confirmed mainline bug.

v6 link: https://lore.kernel.org/all/20260127025814.1200345-1-realwujing@gmail.com/

Best regards,
Qiliang
