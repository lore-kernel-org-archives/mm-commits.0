Received: from mail-pj1-f42.google.com (mail-pj1-f42.google.com [209.85.216.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EBEC719CC28
	for <mm-commits@vger.kernel.org>; Sun,  8 Mar 2026 10:28:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772965691; cv=none; b=MNE4OavMNs/nAcicviu374bqLHG/xvQIDslNdKWLY7QnUpr5+3pSqmivn05NierpxPWGnj0nlX64nx90Xat8pYn0B8dJlWw9FM8Px7ydqeqVlzrHTCt/J7tk1YIDw6Og/vDTnF4IjuMKtrhut4LIc7kdD/rOp/QXxCX177jNlrE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772965691; c=relaxed/simple;
	bh=l+HQh2wdkjd2QUjhWvZCLKn9G2YOcwXkqEkPMI/YOH0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=hXyLO/belZ3LQchyrkSGyuRto7IHzKMDjOGvH0L6PExQRmS0E4OB7AIzlisZw0VedRqWP1EsXrceJIrFaS10TAVBngLg9m1bR2HoBaBlv+9JRQCGaag1FeCubLI4twlAp4K8e6ljQNjIMRRvbfP1vSW6OFA/BHIBiDG6yBG0owE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org; spf=pass smtp.mailfrom=chromium.org; dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b=M63D9icL; arc=none smtp.client-ip=209.85.216.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chromium.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="M63D9icL"
Received: by mail-pj1-f42.google.com with SMTP id 98e67ed59e1d1-3598b95ad7dso5313333a91.2
        for <mm-commits@vger.kernel.org>; Sun, 08 Mar 2026 03:28:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1772965689; x=1773570489; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=gsIs0Sh07Iuh4Q0hY24dv4Wv3AHKQsvRnSkXLup0L0c=;
        b=M63D9icLMhgmJPCcXEya2de430ST2V8gSBLxC8EImiOn0LgDnktOW+UTuuQZ9uDNR4
         mBca3CUxxYV/W7AV+e2yXrSUkZZKxzDFH8WzGpGl/VYioAUbcrtAwbr3celG4Zgx7sJy
         pvLHCjucwl0ZLfASjVugfGJBoLAfjaYyeiNag=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772965689; x=1773570489;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=gsIs0Sh07Iuh4Q0hY24dv4Wv3AHKQsvRnSkXLup0L0c=;
        b=DSlYvUs1Kj8+fgyDC2qU/OfGBT+GLnqw6WwjTY8fpbu4slwBZ0UCsGUVK1WadwUI5J
         tjSy2YxqeX4IDdK0rIevho9lfTy2fXA4HUR3IWeAZapvAtBypWRzCOsR67WY6hFqg0G+
         qhXTNZs4N/k5kTGhrG75APOij+LR/9b1wEZNNZttvj/3sBmPSYcaIkNB403SgAsL0dvs
         KHgb/NI2FzY2Ky4mdW719urnzpWWOGDyMgRc6yw9ss8Zx/SQxr7rzHqOBO3phEN4Viwr
         FYI2ZCyAB+Wz8kZca7d9+InEIPFNuvKX94EzZA/r8eLLcmXeBP5oWoLiyS8q8gl8yTRH
         cQOw==
X-Gm-Message-State: AOJu0Yym9ICV316eZ07xm1rPiJy0vbh4Co4lv4mva1r88JxFAzzIFEpm
	u/H3uRqdS3c1xamiXivXPOOjJFJy5OOhqdqbyFZpX2lGORANVJdXG+pxmUCpiVP+xQ==
X-Gm-Gg: ATEYQzzH9d16yzGreZ9jvhjvn//Yo5XAxGB4ZxXjz8F6/h3OQJjeQpxX1/G9GdgS8or
	Yhx/yQKNOlZ8yaQCMTOh2ccx60Iao+RKcUNvfOqn039huyKgoWWA3+2tcpwIXjQFLTmd+L5uctF
	uybP7U3v8OUJi7FMt5GPUc6jEcP0kg/LBxUD1rqExhN7MDIXX3hYHDybXNBtzcWuSt4Y/+WNWFn
	E1QrQqCHssYIKEWFCuyI3C+Dr4So2dpwz8vyqoyi6FlDY/72Q9+/LQcdaAUrdOdy8+Y+ehwEXuK
	iS65PhNGmzq7uRwwp4cXIl/Na+dyMTwr5iQh/1DMsqAiFPHw4/veDcLIeL74IdYUsPprQzkvRY7
	YOa3KtRcjN2OBGP5eNWqnk/3m9qTBTvaX6v7uPA2R7cNUp/QrQ4nuD3X8XmJ6b2WgruwY37Nrwv
	t//0ngXb1g8K8BMEydxZXG7v9IALl/tU8Ync8N3qZNN8jesZ+zxjUrB+vpxFAOig==
X-Received: by 2002:a17:90b:4fcc:b0:354:a1b8:24a6 with SMTP id 98e67ed59e1d1-359be396481mr6954981a91.31.1772965689279;
        Sun, 08 Mar 2026 03:28:09 -0700 (PDT)
Received: from google.com ([2a00:79e0:2031:6:2482:9ef0:2e69:444])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-359b2d39238sm10560704a91.4.2026.03.08.03.28.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 08 Mar 2026 03:28:08 -0700 (PDT)
Date: Sun, 8 Mar 2026 19:28:04 +0900
From: Sergey Senozhatsky <senozhatsky@chromium.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: mm-commits@vger.kernel.org, minchan@kernel.org, bgeffon@google.com, 
	axboe@kernel.dk, senozhatsky@chromium.org
Subject: Re: + zram-use-gfp_kernel-for-post-processing-slot-allocation.patch
 added to mm-new branch
Message-ID: <aa1Oemm99ek7lUU0@google.com>
References: <20260306014923.BA31EC116C6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260306014923.BA31EC116C6@smtp.kernel.org>

On (26/03/05 17:49), Andrew Morton wrote:
> 
> The patch titled
>      Subject: zram: use GFP_KERNEL for post-processing slot allocation
> has been added to the -mm mm-new branch.  Its filename is
>      zram-use-gfp_kernel-for-post-processing-slot-allocation.patch
> 
> This patch will shortly appear at
>      https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/zram-use-gfp_kernel-for-post-processing-slot-allocation.patch

[..]

> 
> Post-processing slot allocation used to be performed under slot bit-lock,
> so gfp was restricted, then we switched to a sleepable slot lock but gpf
> still remained restricted.  Drop that restriction and use GFP_KERNEL
> instead.
> 
> Link: https://lkml.kernel.org/r/20260305021619.617481-1-senozhatsky@chromium.org
> Signed-off-by: Sergey Senozhatsky <senozhatsky@chromium.org>
> Acked-by: Brian Geffon <bgeffon@google.com>
> Cc: Jens Axboe <axboe@kernel.dk>
> Cc: Minchan Kim <minchan@kernel.org>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> ---
> 
>  drivers/block/zram/zram_drv.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> --- a/drivers/block/zram/zram_drv.c~zram-use-gfp_kernel-for-post-processing-slot-allocation
> +++ a/drivers/block/zram/zram_drv.c
> @@ -297,7 +297,7 @@ static bool place_pp_slot(struct zram *z
>  	struct zram_pp_slot *pps;
>  	u32 bid;
>  
> -	pps = kmalloc_obj(*pps, GFP_NOIO | __GFP_NOWARN);
> +	pps = kmalloc_obj(*pps, GFP_KERNEL | __GFP_NOWARN);
>  	if (!pps)
>  		return false;

Right... that was silly.
Andrew, can you please drop this patch?  We cannot reclaim memory
in place_pp_slot(), because it's called under slot-lock, which is
IO lock for zram.  We cannot re-enter zram under IO lock, so we have
to keep using GFP_NOIO here.
