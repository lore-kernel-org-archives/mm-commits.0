Received: from mail-qt1-f170.google.com (mail-qt1-f170.google.com [209.85.160.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E52BE2882CD
	for <mm-commits@vger.kernel.org>; Wed, 28 Jan 2026 15:29:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769614186; cv=none; b=S2hxqHj1IL8R2aInLg21cuQSUOUSzquOcct/+5EleIQOZjIt+n8FG56kWu+UO1ss4ZrwEDMs6TbWSfc71TK3pqRUNOmP3TmBekuRhSyX8ZuKfijSoPpYfK1oQB4G8E9YDwicdeWzo8rqiwtST1EYg6dHKgSs7mO+ZZ+p/h2qtl4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769614186; c=relaxed/simple;
	bh=g3AmRlixMLTqZ4wrS0BdriBjfy97yfemg4iwfDm4TEQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Vjh1aO6Fze8qSokNGTSm/YFT+FxL4PLTVo61Mz2I5oi9wmmYFfuaoRdx9S4KdffTZzy+/19EjsqRKC/kgskXuz8bMgZVPTSHKlslP0jFAyFQbyheNNnr+3fOiF0eO28fhiwOoa0vIW2jvDK4u7IioSR3kaoWJ0mOaW6nN7U9v0w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=XflQmAT7; arc=none smtp.client-ip=209.85.160.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="XflQmAT7"
Received: by mail-qt1-f170.google.com with SMTP id d75a77b69052e-503347e8715so16574411cf.2
        for <mm-commits@vger.kernel.org>; Wed, 28 Jan 2026 07:29:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1769614183; x=1770218983; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=WADkY52xhFpIWsbKCOqSG612AamsVwThqARVdW6UaNc=;
        b=XflQmAT7BClsGP0iaMwvW2SH8Io03TsAx/Vts+bOqm5z0G+XRtAkE5E4H3W+q8OCo+
         ZvuLV6t4Wr5qJs2nvD8IgZ6d5m8Oec2EqSBB/cNP1Ikj8JTQXuTFpNpWsCcV5O0DX9vK
         59pGIfVY8zgBafV9dw06T0gv3YOFjq5v7HH5KpoiZHXJ3RITIQhYt9Rw51Z6TYUoLh/V
         gARi04NSHFLnu9pGcIpMlWLEhf20R10e/Dj6Q/jLJq+coPsxHLyph0CGxPgCjfwsoCm7
         D8rbJ+3HOZdxm9idLasI7eYccu/zz00H+pDhOYLWGLX4UzkQl+9svvQ01wScRVSKJQXU
         kH2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769614183; x=1770218983;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=WADkY52xhFpIWsbKCOqSG612AamsVwThqARVdW6UaNc=;
        b=qUUhxOT/uiMshwqkahAl4a0ZgNTWhaZSf5vBtgSOUsHlC3IIMZHxQfnWAAPjz3ePnV
         +soMp/hfo12lP4K58ZWt/Sx5Z6pJbZULi1S051FrUvuTcba1TusS2AxXLO/wUjMd168Q
         DO3RDD8pTD5ZdA0qKxzTSfNJ41jkEcFG1QZAJ29lem+Ag5z/tqNgBSKondMITROgKTdS
         mr4UfQV9UloUzPYHbXduvPos2+++MWx+95eUKffKAX4+jgpEhLx5K1+Ltne1VcJZcBqq
         1NJXXALTbLy9L/gFoJGmgpbH24VM4h6TEQTCcllA5kkGOipYUV3F0A4WbP35TqiDs/xJ
         AAwg==
X-Forwarded-Encrypted: i=1; AJvYcCURDZszRck80vn79w/OZtqI3GvvHbwJaZ/QKiFwLmfxq3vseaeORFy+LXEUIpPUlwkvtksN3SrwL9Ja@vger.kernel.org
X-Gm-Message-State: AOJu0YwVKVAilT1SaO86ZjlcTs8HfDMJCcTohuG+VCkzcN1OZjiPQuwZ
	yrpHA36ev8TfHefDIwhk7UYjckXMSsApUjXgQUDRiwCH9+3EVGkKpCeQ2cGuEw6F
X-Gm-Gg: AZuq6aISrQ+HCZkgKDmGXgoUySZh7JI35j7XbnHOrl5bEIkAO2MLadgk/VuJT+M0U2O
	5J/OUudDAQdechQ8wYwh0FTR/OwsNQVN+AdeE2jNIl5WlWKvIgUsyMoZ9SZqT68vrCalkznR5lo
	7tgxw6WA+/ioPJX3LbdWeUC6ip0oTwckCm0Af/9ruWyungEJynPNgAIo2XV5MYu9r0CUfu6QX7v
	YuAZjTMUuhg/DwfoGtTl+Qrl0UPJU6LUoyeVLWUO/2Ca3I19/AlpE8eYX8QJz655AG5DJsHs2s3
	ao3ZepDFJqwPc/1+8dInu2XPgByBJop3+2cFe1gPNOmFqZ83Z3yeL03GFNE5zzsoOxCUkB0jxUd
	5qqNgWxhGMWzhfKHOW7ELxD+nptFPQ0KXwDvMELNXhFPMoL3QxH02nkQM56N+mVRhLwvWZW4XMZ
	vIhh0=
X-Received: by 2002:a05:7022:672a:b0:11b:baa5:f4d1 with SMTP id a92af1059eb24-124a005f62bmr2788054c88.6.1769608316122;
        Wed, 28 Jan 2026 05:51:56 -0800 (PST)
Received: from debian ([74.48.213.230])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-2b7a14bb02csm2614616eec.0.2026.01.28.05.51.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Jan 2026 05:51:55 -0800 (PST)
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
Date: Wed, 28 Jan 2026 08:51:40 -0500
Message-ID: <20260128135143.1777381-1-realwujing@gmail.com>
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
>
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

v8 Link: https://lore.kernel.org/all/20260128115358.1757147-1-realwujing@gmail.com/

Thanks!

Best regards,
Qiliang
