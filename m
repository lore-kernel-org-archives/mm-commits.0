Received: from mail-qt1-f169.google.com (mail-qt1-f169.google.com [209.85.160.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85AD0261B6D
	for <mm-commits@vger.kernel.org>; Wed, 28 Jan 2026 15:11:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769613104; cv=none; b=Kbd4ALnf3EUo+GAvC213JUKFBP2io9SoQYFZ51Bb0z4wL0a46AQgVMR7ISTrbl6f/AD43cmLk8Z0Lrs1Dd+xjRLAykX1JbvpPLjQxsDvlfTZ+S3FQm2DEyEPj+/AnBTG95vSKEAEmlst4mMaEW0sqbYxLX42ENNWr7Vjtc9AJf4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769613104; c=relaxed/simple;
	bh=uMb0+6hrAqyTAxCgTOBma+V9UGLo8wqxbLjyFwatDo4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZZVXC0KWjNllMzF0/Bg/9kTZlTHbNp+krUcHYkHBcpvHUOcASTcM6zXro+xxHc/wsr61+AGv5xnDsBOJ0TCl9DjfYM3cfBbuTrPyB7OkgprrbulIYPx1FRheQ/sZuTilFv8TxY0vq7zRJCoJ6aX/abivTPNWdN3MYJkHRG8l7hs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ax2uV15r; arc=none smtp.client-ip=209.85.160.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ax2uV15r"
Received: by mail-qt1-f169.google.com with SMTP id d75a77b69052e-5014db8e268so109495211cf.1
        for <mm-commits@vger.kernel.org>; Wed, 28 Jan 2026 07:11:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1769613102; x=1770217902; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=eZiqzZAKTrzELIcyvdKxAtY7K6R+zYGAN6Fj59XN2kA=;
        b=ax2uV15r48zZ2+FJF1pw0cN531guAn03JHP2W5CPTPF7DsTBQHhHfqadT0G78YF7hu
         Esz5B9dKYBjd5WpSVtak/KPsH+cucRS9PUrQC3wABl+lzr0ibaxx9yc3wkhpy7Eg91lx
         KeRI1I9K32BAR4pFoTyAv8qtQ7vu6Smh9cyf3t6awectwAQzGDVdbP0me3ZGThekr501
         3KI7zUIAxOYqSJIRR8vx2c8QCX4JGVzZeAVk9xsuDK4buSbrCrRtIcwj5M7Vxxre3w/l
         /6LpGQM01GV3IQX/SPGagnzv0TZew4D/fO5o+obTxS/l1ontS66my67wCNpb9QbrbF1f
         wqbg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769613102; x=1770217902;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=eZiqzZAKTrzELIcyvdKxAtY7K6R+zYGAN6Fj59XN2kA=;
        b=urlEGoW3wZ4AanvuBhxEFsLg4Vd8E/NSA2YoztSD6zLikxcOKxcAf8S98vhiDobw+K
         8mDCxyVHBsLdrL8XA5qzR/uABTJhO48hY/MN3XVgoc8K2Mlu3evRFvpfgLN82Me/daOD
         LymTA2s14rov+b66FgdMZBWKgHepGJ3ZH6vr0/Z8LlL4q/mQdt0olfCu+dAZykTOFKbc
         Q8lkksayo6UprU3oxy5VfHeiHu9CokwxwA/DxN0LCqJx5am3fgXKftl8oeT9klDQlKcp
         U1LKQb6QF2nkTTpxJQt6IO51VW89dqH2+jpflAUpqzGZWwtvbfNm4LDX13HSaMvyYC79
         UUYA==
X-Forwarded-Encrypted: i=1; AJvYcCUc0hybRV0rivh5tJcAYc3lttIXOXuJONxy+C783Nr7jm4jPvRQYplV29ilhz9ZWtBbG7l1h8KuwavF@vger.kernel.org
X-Gm-Message-State: AOJu0Yy+b1M+8DH0lntya2/rU5zcOpl41Ep4z6X6Ns0xcg4sEiDyEW1e
	qvsBkDIxrVrrL9xpUV10QcxZ9tdH8b52tFzju8EjZpeeKTcKogul1Q/vV93EvbUy
X-Gm-Gg: AZuq6aJcwjsX0d/O8SsuAqrrVG+kz/vwgepUN+3OKtXxslkxLs7snTF8XkkI8GPBWOQ
	3dZRS2hJ8Nev2O485MW/PE25w0rYbNoRVXRVuWws53/1Bjd8xSzlOeClyYQ6DOaYPt7KtI+/j8V
	A3UpKdd/W+YV8Z2jc+JMHIxjyqIkLA/QiRjL4EcLsoSpQYFIwPk4T2wpakmXu8xNXQ59BbOPb4B
	QITUCRcqd8hVJpgwPAr4KYo52tQs2a+vivqcm5LE//FJo/Py2FWqyNGEeh2JeGbQf2x/+7g6aUU
	XBbFlXco/mVjdSBFUmUoxVh84yHryx/0W9yQ78E8Mr+R4E69+VRp0687ZjbXPYfzsq0TuTppsl0
	tKpvVfNyEE4z5SYREuxZgYlMYoaHrLstpT2hot5nzkR796zJo0gq4lepkAViHs9PNnNaAQOF0QC
	RR5xo=
X-Received: by 2002:a05:7022:68b:b0:11a:4ffb:9849 with SMTP id a92af1059eb24-124a007c94dmr3573082c88.21.1769605603152;
        Wed, 28 Jan 2026 05:06:43 -0800 (PST)
Received: from debian ([74.48.213.230])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-124a9de7febsm2126691c88.10.2026.01.28.05.06.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Jan 2026 05:06:42 -0800 (PST)
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
Date: Wed, 28 Jan 2026 08:06:29 -0500
Message-ID: <20260128130634.1769702-1-realwujing@gmail.com>
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

Just a quick follow-up to my previous reply. I've just sent out v8 which 
addresses the Signed-off-by issues and some final cleanups.

On Tue, Jan 27, 2026 at 8:08 PM Doug Anderson <dianders@chromium.org> wrote:
> One last note is that your Signed-off-by tags don't match. When I
> apply your patch, I see:
>
> Author:     Qiliang Yuan <realwujing@gmail.com>
>
> ...but your Signed-off-by is your "@chinatelecom.cn" address. That's
> generally not okay. You need to do something to make those match.

Regarding the Signed-off-by tags, I've included both in v8:
- Signed-off-by: Qiliang Yuan <realwujing@gmail.com> (Personal email)
- Signed-off-by: Qiliang Yuan <yuanql9@chinatelecom.cn> (Work email)

My work email often has trouble receiving external mailing list replies, 
so I've included both to ensure I don't miss any feedback and to 
properly attribute the work. The v8 version should have everything 
matching correctly now.

I've already sent v8 twice today, but for some reason, they are still not visible on lore.kernel.org.
Here are the Message-IDs from those three attempts for your reference:
- <20260128115358.1757147-1-realwujing@gmail.com>
- <20260128122330.1761777-1-realwujing@gmail.com>
- <20260128125639.1767682-1-realwujing@gmail.com>

Therefore, I cannot provide a lore link for v8 yet. You may use the v7 version from lore as well, 
I have already added "Signed-off-by: Qiliang Yuan <realwujing@gmail.com>" to match the author's identity in v7, 
but please help to include "Signed-off-by: Qiliang Yuan <yuanql9@chinatelecom.cn>".

Thanks!

Best regards,
Qiliang
