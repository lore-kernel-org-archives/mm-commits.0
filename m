Received: from mail-pf1-f179.google.com (mail-pf1-f179.google.com [209.85.210.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA52013DDAA
	for <mm-commits@vger.kernel.org>; Fri, 13 Dec 2024 06:28:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734071314; cv=none; b=PMg7aBETBTrH6wQgYaQyLCaz85LN5e4DsXwioK3n8ReFmUQ+4j6iFPxf/EAJzCz2VtAAs9+A++qvGyquGJiJCD0xkDYv/lWn+H5sTfDh81a/mCURpeZlzXBAZRSZKrHCSId1ev1bgHsccLkZS5AH2oUA1Qxtv2ClF3I1Tz2TNdM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734071314; c=relaxed/simple;
	bh=Fgd13FmN74kAQPbnMCmH3TYyFBKSqpjeEM0XPIYaBQo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=B0KmKX6uB5TzeAEtv8EBoMMEH/PuDiHBBdO2nDAM5RyV7o6WI/M/JfWeb4do0mOdvM80jr3G8D3FJttIXA8Ud83SaNN/JOepQHPpT9e60U6JhdYfR2YPp8XwtWXNYg9S4yO6NsiZlX3gsK9lU6/0GS5WJa1vFD6neK5ZT6EQDRA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org; spf=pass smtp.mailfrom=chromium.org; dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b=Z0FPxXIf; arc=none smtp.client-ip=209.85.210.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chromium.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="Z0FPxXIf"
Received: by mail-pf1-f179.google.com with SMTP id d2e1a72fcca58-728f1e66418so1244905b3a.2
        for <mm-commits@vger.kernel.org>; Thu, 12 Dec 2024 22:28:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1734071312; x=1734676112; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=IvBKWu2qoqmPfuSdschwVBl4URGyQtrvZsxbHOZ3Mhs=;
        b=Z0FPxXIfCJM+BIzVGBBjaGzGougKjpIybKCl3r9rowdvhPU2f+c5tVaDqC079K8HnN
         hMtl+rfjhFqIAlCm/8qOLxsrFJwoZZj8mLjFhr5ypdMumsRR7Bn1GEHcgI7h5cWDJ4J/
         vW+nOvhXfc86N+4qqOhe8dNH+nTIhfLdJr5WE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1734071312; x=1734676112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=IvBKWu2qoqmPfuSdschwVBl4URGyQtrvZsxbHOZ3Mhs=;
        b=S94v9nWuCOT4yRl0prxuEGtWqa/1PrtkqSJdeMqaThskSAsSFL5REJsikUNo7KZDqy
         Z27TWfNwJdGp/32u0+67zVgl8m1TSeefWrbqXDv0zbRevgZgCkYD2aMDyQ5vtlPinnA9
         FW18+oLB+x1QypQdA4MyIXLRonN27gVOFY17T4y3bHjgiqdUE67P6xHGYsF5YRMZWZG/
         AQb84OXsz5rFSSCFFsGxDK9kZJfd5HmzjOC+1PYLnC+vo2QK4r3MY5Zm/vP1xZkSVmRz
         Xdqv+0WxIFq/Id2gWqslmCeZ/GrzSnSZbe77WkRGMoOWXumDk/Sp6zS/GfDdHLRoU4cr
         FA1A==
X-Forwarded-Encrypted: i=1; AJvYcCWdP/LUxbywN14uuSR9NFCvyS3UgNrpytLDtG12AKQD94isl1mdh526pnt8t0C3uutUnS74f/lWJYlB@vger.kernel.org
X-Gm-Message-State: AOJu0YwTgFyCZm7DEbvzQmeMLo9YuH/VR755TegtnCd/WkAI52hFwmtQ
	cSzmkL7kawYJ9QLZHLPTHeyvVhmTPPZvKNe4QLvkEq08gqZ3cLJyo3dGSxJWLQ==
X-Gm-Gg: ASbGncu3RGeDflXHeQ5grqdK0duBj66bdYycrBFzw7xnQmS5p5wamj15y+pDZHaXdbZ
	lzOmxb/jUo7Xvapjxu/ifmRdqJ8WbfSiTjxi6jlFcy5+9hNo8/1KjQ0qj7AGH15JAd0q4Hwpdp5
	T1S2K89c4Y+JjmpGCZCTiG8lHkNeiGEZQJhkNKaxaVGFAK2SlBAe2zznfp5T4VYH0Fby58fAjKz
	YMC/0q0992fshGwut6cT0rIP1nOx62vYZ/uhtusCTPPUWOJ7r1FqUamUXtD
X-Google-Smtp-Source: AGHT+IFP423ARqQAHiFWElFb1txThPlNOzIgxZqLseCe236cx+09Ls09yOikMKD9i2Y95JGslsUmEw==
X-Received: by 2002:a05:6a00:c88:b0:725:f18a:da52 with SMTP id d2e1a72fcca58-7290c0def4bmr1933900b3a.4.1734071312117;
        Thu, 12 Dec 2024 22:28:32 -0800 (PST)
Received: from google.com ([2401:fa00:8f:203:2d7e:d20a:98ca:2039])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-725cfcf1744sm10881433b3a.185.2024.12.12.22.28.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Dec 2024 22:28:31 -0800 (PST)
Date: Fri, 13 Dec 2024 15:28:27 +0900
From: Sergey Senozhatsky <senozhatsky@chromium.org>
To: caiqingfu <baicaiaichibaicai@gmail.com>
Cc: senozhatsky@chromium.org, akpm@linux-foundation.org, 
	caiqingfu@ruijie.com.cn, minchan@kernel.org, mm-commits@vger.kernel.org
Subject: Re: [PATCH] zram: panic when use ext4 over zram
Message-ID: <ix3p5j34pjke3tf7pmt23vnjsvejcgdlycmz6nnjxtewjn6pzd@wfjkarwokcox>
References: <5qmps6mcifydwtnsynxdtipaoerjrnjlpo6gztxfdryn37bvws@fp2xqjmiews5>
 <20241213055630.163185-1-baicaiaichibaicai@gmail.com>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241213055630.163185-1-baicaiaichibaicai@gmail.com>

On (24/12/13 13:56), caiqingfu wrote:
> > > In any case, zram should ensure that its data is not damaged
> > 
> > zram cannot ensure that, it's not zram's job.  Nothing stops
> > the buggy actor from modifiying the page at any random point,
> > zram might not even be able to decompress the page in the end,
> > it's not only the zs_handle allocation slow-path case.
> 
> What I mean is that if the length after recompression is longer than before,
> writing directly to zs_obj will cause the next zs_obj to be corrupted,
> eventually leading to panic. zram must ensure that its own zs_obj will not be
> written to overflow, not page.

The data must not change.  That's the only "must" thing.  zram
cannot and must not tolerate buggy upper layer that do not respect
BLK_FEAT_STABLE_WRITES.
