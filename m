Received: from mail-pl1-f179.google.com (mail-pl1-f179.google.com [209.85.214.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB247307AF5
	for <mm-commits@vger.kernel.org>; Thu, 11 Dec 2025 11:12:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765451551; cv=none; b=PSt6kGbG04Q8yzlupuCbMVene1rm0Y9tie6sVNaRVrVoEgZNsxPI2+tbgCncwUPu5LHX2EbDq5f1Q8cLqqIZgPEyaDi82O5dExI7t0VHu+3WUzvQXjFonsACzxqZyagXK0tXwelMFB2P8bj9MdSl4znaoXZk97Wcex0hi2OZp+M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765451551; c=relaxed/simple;
	bh=EbrKEFZPbfX/P+FZK5HkH56m/R6cQQlV2p8auwFj3hc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=iXRT836TLb7g+UQnV6IJoB9upBMlAyLG0x4rXc6CLb2K+BvpClZUjSVJTHyniBKeKIi5Sevkf3Ql+Wt/7p+kuxpFWsEJPKKDD1RcLUvmD2lzmtW3JQIHs1oJL6T8+E3/O9B5NWfOVR48jznG4KK2SK7CkLue8s5v9qNGc67TXe4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=0x0f.com; spf=pass smtp.mailfrom=0x0f.com; dkim=pass (1024-bit key) header.d=0x0f.com header.i=@0x0f.com header.b=nm7hWwqz; arc=none smtp.client-ip=209.85.214.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=0x0f.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=0x0f.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=0x0f.com header.i=@0x0f.com header.b="nm7hWwqz"
Received: by mail-pl1-f179.google.com with SMTP id d9443c01a7336-29d7b019e0eso11381035ad.2
        for <mm-commits@vger.kernel.org>; Thu, 11 Dec 2025 03:12:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=0x0f.com; s=google; t=1765451549; x=1766056349; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=EIJ+OwSCxLMLJxW00h7agSUYrvMuxXLK+9uVRG184zI=;
        b=nm7hWwqzWu4oe4UT1HLEGaUiJ1KUuJ8NqGdk0kdiZ2b+LxzaHwWpc0Pd2sdw+zc+Wi
         MdlLlbz5CTVDEk2HrddOMcfJgnIsz1JEnK3jlFmkrS9h9bbd+dDv9Bw4bIKnV+UZRn3A
         Jk9NT3t9oDrNyhnTg1w8VX8Y6GN2Lnyf0+kpA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765451549; x=1766056349;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=EIJ+OwSCxLMLJxW00h7agSUYrvMuxXLK+9uVRG184zI=;
        b=pmRzE7aeBI+doRZLFNPobg9QBVjjngr53smplFabDrMdWSSuTMCZvCSig5CV9YmaOG
         pir5eyYNUlvo2e40NsUrjrDOvXXfvowE9QWaCWXS7ABOTJnbvssYz0tlG0sZHjYmjBld
         lwOD3+A8r2ioOB11ZcOVydvgG6VIHSLgyE2VcR4rV4mI5EjauOnK/dgRlT8E7VobIhMI
         zM6kxerqiWfN4facTtHHj7tyzPTaUvGrEK7DSOwqHCwZJ1KeM7BpxhX3zCBwbo+ShbUe
         O5G48RyOoZ2OMFtmmarrHps+TPaUAHnMY05x2uBkE9oB8+ROGqIZPdWG/uRQ33bInOKr
         HcKQ==
X-Forwarded-Encrypted: i=1; AJvYcCXL9Z4NS+uS/DVXOt0KnJShmKPyFwNkG09L/tWYiMmC/r8sMK8/WVwwnfIXD5GpS4MnD/F3/XkCx/XE@vger.kernel.org
X-Gm-Message-State: AOJu0Yzf+fCyDvurvzw1x7uU6nHO/F0jE/49p04j+0SHPWT9wJTvr3U2
	4Jd+eVU5mtcaAEczDC7Vp7Ob6rFIq308v4ytoLntrQM0v/+7bV0E0dnXJHdRVExyx9u5zdL4pe6
	kojYgR0HEPuWYOUhjQJnNW11cj6uJfYHs6YkYH8jtOw==
X-Gm-Gg: AY/fxX6sMxfgniBgJAKImd4m2YSQHttrSmP0aBE0B6FDlzkD3azhyGGbYugaNDtQh/y
	Zq/Itv5ttICzzpnhe0sqcajirCqRLs2YewHTlkquOOL7YVi2dXoPCSDJFVBOrUNffvjr+2OPBbA
	rFnN7p+d5u691i+s2iLgL/cbXtbiVokbzoSrjGoMDS3KcejrwEZmZe8bKzONESdrNYLZ3C2iJOk
	ugclrzg1TJlsToLziwb/+DrGyhobFl8ukTZriAN/pDR3XcEykir2G7q2v5dnW4JPpMTi0MmqJku
	pSEFYD4=
X-Google-Smtp-Source: AGHT+IF9aDSc4ktnxrr6wArJcgJeUxtbBvszAXsjS3+/3ZAhVbAH3uoya6PbR7LZki8HenZvafT5vM0u8ov6FfkQLp4=
X-Received: by 2002:a17:903:1a23:b0:29e:a615:f509 with SMTP id
 d9443c01a7336-29ec22f0883mr70242795ad.17.1765451548879; Thu, 11 Dec 2025
 03:12:28 -0800 (PST)
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251203212918.82f1c9d3947940aeae263878@linux-foundation.org>
In-Reply-To: <20251203212918.82f1c9d3947940aeae263878@linux-foundation.org>
From: Daniel Palmer <daniel@0x0f.com>
Date: Thu, 11 Dec 2025 20:12:18 +0900
X-Gm-Features: AQt7F2pjiWEZyxvl20iOM4iIJeABt_nySwUNutYZyMkhTNqx4SiZjDgYKztpZuI
Message-ID: <CAFr9PX=_HaM3_xPtTiBn5Gw5-0xcRpawpJ02NStfdr0khF2k7g@mail.gmail.com>
Subject: Re: [GIT PULL] MM updates for 6.19-rc1
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, mm-commits@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Hi Andrew,

On Thu, 4 Dec 2025 at 14:29, Andrew Morton <akpm@linux-foundation.org> wrote:
>       mm/page_alloc: prevent reporting pcp->batch = 0

I think, maybe, the following part of this patch broke nommu.

-       new_batch = max(1, zone_batchsize(zone));
+       new_batch = zone_batchsize(zone);

Before this change on nommu zone_batchsize() returns 0 but the max()
changes it to 1. Now it'll stay as 0 and anywhere that depends on it
not being 0 won't work?

I'm seeing a deadlock on nommu:

https://lore.kernel.org/lkml/20251211102607.2538595-1-daniel@thingy.jp/

Thanks,

Daniel
