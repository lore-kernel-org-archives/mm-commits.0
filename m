Received: from mail-dl1-f44.google.com (mail-dl1-f44.google.com [74.125.82.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C9E53358B9
	for <mm-commits@vger.kernel.org>; Wed, 28 Jan 2026 06:13:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.82.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769580838; cv=none; b=WE44PQwjys0C1FzU4YR9fJ5vtxEsYLgcGgAqLznvetkPTVaO7RYCXuM/UTdu3BnP1t4fJplVNUrX6IYg7sDepYG0iuQZCk/c6gTd2M7d++UHUpvuIVUp7NhrtUYEdbzgNeyPe1bdosaSLrtVSQZe42zpNgR9XqEfhgJOL5WtKjQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769580838; c=relaxed/simple;
	bh=SK7oVYArSg/Xo6uvMZQi2Av7HSLvZtYpGO2JRktoHD0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZmJJDAMEl2IQLn6vmaa/y1Nl+/lS6uJHOTL+BTcKDey3rf2H7fA1JHKSRRIdg1H7bSgMXVzDHb29AbdGbNC13mXEOTiVvxfRUNQ0iHctyw8dMcTG5JsdwcYRs8zpc4RPqtK9imrzpvGjEhRMQp7CClxHydcBqNSjer0XCZRvrEU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=hV7v6c3E; arc=none smtp.client-ip=74.125.82.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="hV7v6c3E"
Received: by mail-dl1-f44.google.com with SMTP id a92af1059eb24-1233b953bebso2705675c88.1
        for <mm-commits@vger.kernel.org>; Tue, 27 Jan 2026 22:13:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1769580836; x=1770185636; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Bph7pWaNNjsaWYbFF77C3XL7A8KWqYwMiqgXEfTey6Q=;
        b=hV7v6c3ExGE4vSlzk+lcYnvZl+vIjDVj5jGLQUf5X5YxuJglmIzUsvZ3qIqd+qPyvX
         jfAN3ztwRGHzWMQHjG33OcsdmjtMGzW/EgNpVd9bdt9uOtTvBx4yeL87IrzYTQELqVuE
         /Eci+sXrf6L39PvzMdUIYZxdYshfuz6GmtXuV1MoQmaLldThhgqYJWX0YIpvSEjvNycT
         L7C41arBUUOjDSnjhonZ0PnMJQz0eUjk+9cUg0JLf4txrcbAY1SrHGOaS8MQChb4+/Q/
         nIhd+oGVomp1qkdmlQ3pU11/GhavDJbYZKO2JhKski759bCq4pg/V0t4uLOPdffi+IOx
         fGJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769580836; x=1770185636;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=Bph7pWaNNjsaWYbFF77C3XL7A8KWqYwMiqgXEfTey6Q=;
        b=ETa8gxXKVpbwj8p7dpi1BQ8f96FN1ldRP8aYZhpOJKQXilnTGx8iAEKbER5HYGxZxa
         +LY6N1l/f8es/BQYQtQEIElWQ3tSgVdjQ75EltM4uomvilq08enaZPSvThqZgU+9xcqE
         zTgSwJ0BNRji1DApnTTIUxpE5z4PCD9V3P0YT/XLsgVrVqsXYt18lQz+sq7J5ZWTIZGn
         ad1oehryHsmxxxCRkucwMfjA12fSu0Bj0cn2RKVMWNWAXfzTSQuFbyizNZLQEeKRbC9h
         NVVHUgW5zdcmM6KPNrSRjB6OQGQdC7DClcARvr+vIafIABqHxXnR/j8PUAfuG0DViEWB
         ooSg==
X-Forwarded-Encrypted: i=1; AJvYcCXFOWZ4mA2t12iDbC3mRIaMSQIUvFbmHCrLQk3Qko7irsaBupaPd04DH14g5x1NU2fCuYe2Aa3SGPLw@vger.kernel.org
X-Gm-Message-State: AOJu0Yw+PhFN6+PP0ZkruVM8Gclf1qBGxBsVQrd0DXOfuAAfH0hi49IP
	8MnneOAdlHB4C0PMnhjBOlBRkcEpY0wMdQjrxJjG7UnkaMhzB0NRsROj
X-Gm-Gg: AZuq6aKT/sBa0Q3sMQsakFKbwCn+joNW1gsayaLkxfOVF7veue+U/pfGYIPvTKL9mia
	XWnstQ5D5hVkaYKZt9D8GeIHcdSldpB44ziisiXEQh7KA6hHUWKOesLQEHe1oXuiBNldvdyfTLN
	AWONc94BNn9arMtxAjVBK1vbXRHlxmaVi9z5H+VSO6DdP3l/8p65KnsV10lwZ+8FzOFdPMtqeTP
	P847xhd7nAsSPy6giDhoFox/KCRMAeR7njL89sLj577tMZZf3NdcpVSeVkFG+hs5Eyk4M1yChoO
	tFacYLcv6IfaNG+/PC2JZ2kIGjViW0h30m+ClHpCEtzHVbdYx2Y2/92wfjeVc7iV5HtZDcj5FRo
	s4zo7rcgvRW+88Z/Nz6PMHIFZ5CR0L50obX4a3yYVPU8Bc+b+KdRIvMJBnYFuYD3zLuDqy2n6n0
	R/WMg=
X-Received: by 2002:a05:7300:7fa6:b0:2ae:5ee8:b774 with SMTP id 5a478bee46e88-2b78d8d4941mr3000680eec.9.1769580836322;
        Tue, 27 Jan 2026 22:13:56 -0800 (PST)
Received: from debian ([74.48.213.230])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-2b7a1af83c5sm1281374eec.30.2026.01.27.22.13.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Jan 2026 22:13:56 -0800 (PST)
From: Qiliang Yuan <realwujing@gmail.com>
To: dianders@chromium.org
Cc: akpm@linux-foundation.org,
	lihuafei1@huawei.com,
	linux-kernel@vger.kernel.org,
	linux-watchdog@vger.kernel.org,
	mingo@kernel.org,
	mm-commits@vger.kernel.org,
	realwujing@gmail.com,
	song@kernel.org,
	sunshx@chinatelecom.cn,
	thorsten.blum@linux.dev,
	wangjinchao600@gmail.com,
	yangyicong@hisilicon.com,
	yuanql9@chinatelecom.cn,
	zhangjn11@chinatelecom.cn
Subject: Re: [PATCH v6] watchdog/hardlockup: simplify perf event probe and remove per-cpu dependency
Date: Wed, 28 Jan 2026 01:13:44 -0500
Message-ID: <20260128061350.1716608-1-realwujing@gmail.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <CAD=FV=XX0dJ2jEaQ21M4Kas6pbJL0SSCxYhr8-1kqSTEiJP_UA@mail.gmail.com>
References: <CAD=FV=XX0dJ2jEaQ21M4Kas6pbJL0SSCxYhr8-1kqSTEiJP_UA@mail.gmail.com>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi Doug,

On Tue, Jan 27, 2026 at 8:08 PM Doug Anderson <dianders@chromium.org> wrote:
> One last note is that your Signed-off-by tags don't match. When I
> apply your patch, I see:
>
> Author:     Qiliang Yuan <realwujing@gmail.com>
>
> ...but your Signed-off-by is your "@chinatelecom.cn" address. That's
> generally not okay. You need to do something to make those match.

Thank you for pointing this out. I've updated my git configuration and 
the patch to ensure the Signed-off-by matches the Author's Gmail address.

> Given our newest understanding, the cpu_hotplug_disable() isn't truly
> needed anymore, but I'm still good keeping it.

Since the probe is now fully stateless and no longer touches per-cpu 
variables, I've opted to remove the redundant cpu_hotplug_disable() in 
v7 to make the code cleaner, as you suggested it wasn't strictly necessary.

v7 Link: https://lore.kernel.org/all/20260128060833.1715622-1-realwujing@gmail.com/

Thanks again for your detailed review and guidance!

Best regards,
Qiliang
