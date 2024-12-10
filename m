Received: from mail-pf1-f176.google.com (mail-pf1-f176.google.com [209.85.210.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01C812080DD
	for <mm-commits@vger.kernel.org>; Tue, 10 Dec 2024 09:34:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733823254; cv=none; b=Ri28f5a+vkKYHskqT7tDoUFlSgTfIe8l/7NQjyP/jtFZq8N2qV3dpvUG/SSSc6mXIXOyx5Vlu/ywVb3XviCWjTgmuZuPPDLLdgSAF4gXTIPeCE6X8Nr9zD4ZjDIbGBPCqCIwMjhn2duYzPDBBt3T75JptJOnZah+SWmAd4EVTr8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733823254; c=relaxed/simple;
	bh=w2vKqcbyTFREuFgZd+DnaLXbKMMVS0fCjyOiVKe45UA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=MUts4WssIm9S06EFvFdSFhmgTcHA/6IdI1PvFL9e1c+J/v+VelDgSPYirmRIcXaze/7urHXxT7wFkcd6/fpAG25r1n+jc8LzTj+cpPhzvgvw+oqlWjBRNcXvkQRv2RaV6NVLqIA/wC3FnDRdvlCqa21S2E8wOCsNJw2OoWVlgPs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org; spf=pass smtp.mailfrom=chromium.org; dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b=NICBgbU4; arc=none smtp.client-ip=209.85.210.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chromium.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="NICBgbU4"
Received: by mail-pf1-f176.google.com with SMTP id d2e1a72fcca58-725ee27e905so2121768b3a.2
        for <mm-commits@vger.kernel.org>; Tue, 10 Dec 2024 01:34:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1733823252; x=1734428052; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=e1iYjHvkqXBBN1H7XHTKg2SeWmDRebOWfO3y1FaTwOA=;
        b=NICBgbU4jmJInnxinuYuj2sWy/jGp21sVEI4kIvAJsVtQjqT0vKiWRHq3zJr45KciU
         MgwQYicmHmu71mmpAVJ8Ru78fi4Rdfi4Ky+xB09n2z6KSN84J28IUFlwCyUXKMsoDo3r
         CMaLT9mzshGlaEmO2VREGOqlbwtI6aHbBaXBQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1733823252; x=1734428052;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=e1iYjHvkqXBBN1H7XHTKg2SeWmDRebOWfO3y1FaTwOA=;
        b=fqCa6bPtTQkR/FM0NWhLlyMsYTXja6D2VxDf7x65HqX3rYioWrZ69WKQEU7AzZzc3B
         5XX2uM3zH3J8S6rfNPsLUrw5DkHrMa3tJEp0GUryabaaVWEONhXt4HSCbFjrib4vCMHj
         TSDxCL3w5WziLukwchMTZhk7LuCcDnD69eES/iuyRkPe4wobqOJt6Qtz69QH25bx8IWg
         HnC7Aev6SmpzGGE+Jpd4BlyZXLPv3ZPyhfrlF5aauOgwbr8ypqGokusdAJR9IpaUEobr
         D2XHBbHxhejUPaCaubk2ks4EgpLb8o9/YGzUa8ee3gzgi5QzGZKdNvztOBu44RTvlrKw
         BbXg==
X-Forwarded-Encrypted: i=1; AJvYcCX+phDsBmWWuwVh2fJUZBBJ2FbN8CF9vhgpqpW5W3L5+WpXJe1gbEOCwR2+NNKkgTWvijtYNUhgOtGi@vger.kernel.org
X-Gm-Message-State: AOJu0YxevC+Ypu5NK/OoKPtQ+LRwHBXqbqyOksQ0hr+FJdaX41eSaUSY
	B7Id0q54GkvNiTfblXzgbkyNtAly3uDLySIjQ/P3vWytMwrGCL19ExhV3FsHbQ==
X-Gm-Gg: ASbGncudbRULkPcayrMDi/HGjQIPHyjRvGZe58/eD6pWVvHDB2gTxVuBap8bo3yQ4WY
	AvAV4Yp1D2/15mYOzP4nos5UIuhA9yDmFb7AsoZPxyHUk/vOOlRlx41junwoV4JgAVGUikiB9W0
	KmyI4baC2kh+yHypFabF/U/IyeWBJAcnkuGJm/tO6TbEPKetr38p0qANicQ84OEivh6yEhWUnZ4
	t0S7zBxJEJJjo/m7H7CEyLyjc6wzKf0mMHLLOVZyPCYjH3MvOhyLZdNYQ==
X-Google-Smtp-Source: AGHT+IHCs1lBxBq1Jqm/4c/slEmT7kUyt/ezbA5kwqicefHmont5lAEK6Zqaa2yGsbQT+a+XyeXcmw==
X-Received: by 2002:a05:6a00:a17:b0:725:e015:909d with SMTP id d2e1a72fcca58-725e01593b7mr13868449b3a.21.1733823252279;
        Tue, 10 Dec 2024 01:34:12 -0800 (PST)
Received: from google.com ([2401:fa00:8f:203:4d97:9dbf:1a3d:bc59])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-725ec054318sm3622230b3a.27.2024.12.10.01.34.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Dec 2024 01:34:11 -0800 (PST)
Date: Tue, 10 Dec 2024 18:34:07 +0900
From: Sergey Senozhatsky <senozhatsky@chromium.org>
To: caiqingfu <baicaiaichibaicai@gmail.com>
Cc: senozhatsky@chromium.org, akpm@linux-foundation.org,
	caiqingfu@ruijie.com.cn, minchan@kernel.org,
	mm-commits@vger.kernel.org
Subject: Re: [PATCH] zram: panic when use ext4 over zram
Message-ID: <20241210093407.GM16709@google.com>
References: <20241130053247.GH10431@google.com>
 <20241202100753.139305-1-baicaiaichibaicai@gmail.com>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241202100753.139305-1-baicaiaichibaicai@gmail.com>

On (24/12/02 18:07), caiqingfu wrote:
> > What's your use-case, what apps you run and what data is stored
> > on zram disk?
> 
> The steps to reproduce are as follows:
> 
> 1. force slow path,then re-build kernel
> 
> diff --git a/drivers/block/zram/zram_drv.c b/drivers/block/zram/zram_drv.c
> index 0ca6d55c9917..29ac52a4f2e7 100644
> --- a/drivers/block/zram/zram_drv.c
> +++ b/drivers/block/zram/zram_drv.c
> @@ -1683,12 +1683,14 @@ static int zram_write_page(struct zram *zram, struct page *page, u32 index)
>          * if we have a 'non-null' handle here then we are coming
>          * from the slow path and handle has already been allocated.
>          */
> +    /*
>         if (IS_ERR_VALUE(handle))
>                 handle = zs_malloc(zram->mem_pool, comp_len,
>                                 __GFP_KSWAPD_RECLAIM |
>                                 __GFP_NOWARN |
>                                 __GFP_HIGHMEM |
>                                 __GFP_MOVABLE);
> +        */
>         if (IS_ERR_VALUE(handle)) {
>                 zcomp_stream_put(zram->comps[ZRAM_PRIMARY_COMP]);
>                 atomic64_inc(&zram->stats.writestall);
> 
> 2. create an arm64 virtual machine
> 
> qemu-system-aarch64 -M virt -cpu cortex-a57 -smp 4 -m 1024 -kernel kernel-build/arch/arm64/boot/Image \ 
>     -nographic -append "console=ttyAMA0,115200 root=/dev/vda rw" \ 
>     -drive file=$(IMGFILE),format=raw -nic user,hostfwd=tcp::60022-:22
> 
> 3. after the virtual machine is started, create zram
> 
> cat /sys/class/zram-control/hot_add
> echo 524288000 > /sys/devices/virtual/block/zram0/disksize
> echo 524288000 > /sys/devices/virtual/block/zram1/disksize
> mkfs.ext4 -O ^has_journal -b 4096 -F -L TEMP -m 0 /dev/zram0
> mkdir /tmp/zram
> mount -t ext4 -o errors=continue,nosuid,nodev,noatime /dev/zram0 /tmp/zram
> mkswap /dev/zram1
> swapon /dev/zram1
> echo 100 > /proc/sys/vm/swappiness
> mkdir -p /tmp/zram/stressTest
> 
> 
> 4. build demo app and run again and again
> 

I was more curious whether you have a real-world example/app
that does it.
