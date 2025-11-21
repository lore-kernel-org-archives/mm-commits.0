Received: from mail-pf1-f181.google.com (mail-pf1-f181.google.com [209.85.210.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77D4A2E2661
	for <mm-commits@vger.kernel.org>; Fri, 21 Nov 2025 04:10:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763698204; cv=none; b=F+m5OlQB5CF94JEtIY4EF1nse8O7HkQk2aLUG8ORhxN6mq/npQ+UmX20DTF3s31n0X1+ZGkKFVbDLxjq5ppF3CdoVNqCGPB0/MHm5M10iLNI6CIEHZfZ0QhRiuse8l/iqXLgh2riKM/0ayO+1DTTFNK29ssM5u1n4FaZZUGNi5g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763698204; c=relaxed/simple;
	bh=igzj+hunkm17x0zft85QXX1bt9TlV+dETXQW3Yxco9Y=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=MfW45LgZ0rkL//9fqZ3tQ8c3UGktEa6c5tG9jr2lTprN3BCEzv7nMPF0A2KxJsIDasb0YAtvzV/t5EwLZU29VhGdySPM66kboc8xbQjhJBeTWrhP3Z9cqfziNIrlWJewf0YMGglWEELZJFxdksVGBgpHgGqSFs8wpjHr87ABiUU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org; spf=pass smtp.mailfrom=chromium.org; dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b=BA/q95sp; arc=none smtp.client-ip=209.85.210.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chromium.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="BA/q95sp"
Received: by mail-pf1-f181.google.com with SMTP id d2e1a72fcca58-7b7828bf7bcso1914260b3a.2
        for <mm-commits@vger.kernel.org>; Thu, 20 Nov 2025 20:10:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1763698202; x=1764303002; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=1dxDyBV+U7fs3f/Sqic90QJlfT2oMFoHVh+9oFo4S9g=;
        b=BA/q95spb+GhTk63QcXRqbJ+Rl5r6nT7XWUfZPmN1CEcMyZdnuaQTcPyvHJXR0gXgf
         1zW1tOT6DbAK3ImqRXF/XXJ35o6VqTFOTg+Q2lwdDvG0VNOpqwaN2iZJmUMkvyxSQNfH
         Nl1omLFT18UM6yyA1wVJFqSRF1g7BgTJI9I8s=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763698202; x=1764303002;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=1dxDyBV+U7fs3f/Sqic90QJlfT2oMFoHVh+9oFo4S9g=;
        b=MlrYGz4KsOxyPdQH60ySHvW93YRCC/AK2Q4PoovZKscDdNEE0BCfZupQ/qDh8cjt3V
         4cQytIogmCH3nd+EuUBwTfCwOqh/55Ym1N1Px4JVYQ40czBNtWkV3w+KBFBda2LEMzjW
         /I+LX3HIUR1PyA3eJIRrQVd7B6PJxCklSkyJC96W3BWkdoqAGHvrJI2PfzjPSM7PTiBI
         tWirkxE3tJCNexkyWJnB2wvnxH16ajT9QUwJyjvMobT70JUFSLCW1sXVaQ0GdY2iXolH
         Bf2U2zESCwcGC3kduDMpLd0x84z6ckguLyidK+9w2DFauRWao7abh+55R2QmbRqS2yfw
         nGzg==
X-Gm-Message-State: AOJu0YzV+oVXf1oucxQMUJ7XRkpRqi+4Hy3hIH6zd4DTgS0PSSIEa6lE
	QG4bCgiUzYfwalcL5ER7fi2O+n9EFE6JOKaO1v5610ILvusthqzUKtxz5mR4XrZ1kwbB/wbo2py
	ZNRA=
X-Gm-Gg: ASbGncsQ2lBm5Tna9QxujY2SCUD4nacDvzbeqO9UOGlH09thaaYFeDC0L8wrB0RwIH0
	PUrENH2DOkAutOVSVsgDG3N4btwQZtH3BYJLUpJa/POzht11N/rXx3H33FPLYdsU9VyHAdaVav5
	ov4nAeYr0RwVNqe3cM4fDXX0fOnPNY5LzN0f4Xd5CMrmdWO7OCnfrj54xiM+hyG3Yot/7LndHL8
	TJagcbAnj5ppBvSvO+j77U09GM+BeYLz3h2QPmrGyOQ7uROagieWJNpH8fb1/qVxCc/ynFUrnQz
	oVAAdvQ6oFXc8N9qxrUX7guLIOvcSPVVfKCv1mHwDWmpDAgI0+M3E6Q+/rRkQpWHxb34V/ZS+PL
	ReDtw9xqxA6D6Wg5F5gGKKHqM4MmJs69iWTZfWCvtFwJsjfXBIMFmQ0mpyiBsDYZx6VekbXHcIS
	LA57EQhhawVCuHhg==
X-Google-Smtp-Source: AGHT+IGaF2nFuOuqU3lEm6WzvKdZ0an/9xJQt17BK1S70gl76Gnj0AuE6LJ1mrJP9gsJU15t/Gb+Rg==
X-Received: by 2002:a05:6a20:9183:b0:35f:5fc4:d884 with SMTP id adf61e73a8af0-3614ed3e118mr1541574637.34.1763698201668;
        Thu, 20 Nov 2025 20:10:01 -0800 (PST)
Received: from google.com ([2401:fa00:8f:203:b321:53f:aff8:76e2])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7c3f0243b2fsm4326601b3a.32.2025.11.20.20.09.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 20 Nov 2025 20:10:01 -0800 (PST)
Date: Fri, 21 Nov 2025 13:09:57 +0900
From: Sergey Senozhatsky <senozhatsky@chromium.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: mm-commits@vger.kernel.org, senozhatsky@chromium.org, 
	richardycc@google.com, minchan@kernel.org, bgeffon@google.com, ywen.chen@foxmail.com
Subject: Re: +
 zram-fix-the-issue-that-the-write-back-limits-might-overflow.patch added to
 mm-new branch
Message-ID: <4vkxx5jmdqtsdxrcqgpjts4ckeitglhyaigs2lxkcrmvibcqs3@cjcodwllr5xw>
References: <20251120002407.557DFC4CEF5@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251120002407.557DFC4CEF5@smtp.kernel.org>

On (25/11/19 16:24), Andrew Morton wrote:
> When the page size exceeds 4KB, if bd_wb_limit is set to a value that is
> not aligned with the page size, it will cause a numerical wrap-around
> issue for bd_wb_limit.  For example, when the page size is set to 16KB and
> bd_wb_limit is set to 3, after one write-back operation, the value of
> bd_wb_limit will become -1.  More seriously, since bd_wb_limit is an
> unsigned number, its value may become as large as 2^64 - 1.
> 
> The core reason for this problem is that the unit of bd_wb_limit is 4KB. 
> For example, when a write-back occurs on a system with a page size of
> 16KB, 4 needs to be subtracted from bd_wb_limit.  This operation takes
> place in the zram_account_writeback_submit function.
> 
> This patch fixes the issue by limiting bd_wb_limit to be an integer
> multiple of PAGE_SIZE / 4096.
> 
> Link: https://lkml.kernel.org/r/tencent_5936CFE72BAB2BA76887BB69DCC1B5E67C05@qq.com
> Fixes: 1d69a3f8ae77e ("zram: idle writeback fixes and cleanup")
> Signed-off-by: Yuwen Chen <ywen.chen@foxmail.com>
> Cc: Brian Geffon <bgeffon@google.com>
> Cc: Minchan Kim <minchan@kernel.org>
> Cc: Richard Chang <richardycc@google.com>
> Cc: Sergey Senozhatsky <senozhatsky@chromium.org>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>

Acked-by: Sergey Senozhatsky <senozhatsky@chromium.org>
