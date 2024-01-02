Received: from mail-pl1-f182.google.com (mail-pl1-f182.google.com [209.85.214.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88F4320F5
	for <mm-commits@vger.kernel.org>; Tue,  2 Jan 2024 01:21:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chromium.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="ObG84riL"
Received: by mail-pl1-f182.google.com with SMTP id d9443c01a7336-1d4ab4e65aeso8186455ad.0
        for <mm-commits@vger.kernel.org>; Mon, 01 Jan 2024 17:21:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1704158512; x=1704763312; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=5TWIE9ZNOyJT85YfgIOnkx9t6JFsJhxtfeXMh8QNWIA=;
        b=ObG84riLyMV0T4FrJb6e3i4uSwYK8Kuj96GxtKeKxHQ5jdh9VNT5oxRvJPlWmapjVi
         uFiC7aHwmWEEY67RUOOxRXBl0zlx9lmZ+jr2LVaYN4vbc7vvMaTfPjh8cqvsjBOIKT4J
         CRKuvor1tHdCuuxReTNl1i0MEW6H0AAOEUi+E=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1704158512; x=1704763312;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=5TWIE9ZNOyJT85YfgIOnkx9t6JFsJhxtfeXMh8QNWIA=;
        b=QXQ5pOctul1nTHH0UZFM9sDyURu3O49VIMK4Xi0oZFf7TCiWb0y0nUfz/KVJ2r/fsh
         qxkBf0zjrpKOWskWsjAChLeqvuXKHs/5fbRs0+1uai6AJcdTU6fx6mTZXjPOLJIylYvQ
         3fvN938VRnN0BOFBKc+lapc06jkjFG+t30trCqIhmplLS6UFBIoVtpuNBM59jr9WhxN2
         qxAOIThQAItn1VJFFO0njhhe/sNQFYR+zWQ1RgdB9kQv26y6axEgRWCYPRoJcMD+ZTTs
         7ZB8XS8A6tYudpjTflm30CdPzM4+ifcuHNqbRPZzGSnfj3Qd9P2a2ZFn1wdENXIIiXo5
         XSRg==
X-Gm-Message-State: AOJu0YyOiSVtleC07h038tpWg/NwbK7Xu2qZgFuiTOp2wOP3zzNpJ+CH
	FkoF7UkHFKiWMJMNpbF6Dp8nIsqH9ZsC
X-Google-Smtp-Source: AGHT+IFDyy3QzFVN2FwxJXlanC/vfYsKqhVVdg6I/mRT6b4HMHRol0HvyrNqDfoZLR+rtDajjEU/Lw==
X-Received: by 2002:a17:902:7588:b0:1d4:11b1:11b7 with SMTP id j8-20020a170902758800b001d411b111b7mr16081337pll.62.1704158511832;
        Mon, 01 Jan 2024 17:21:51 -0800 (PST)
Received: from google.com (KD124209171220.ppp-bb.dion.ne.jp. [124.209.171.220])
        by smtp.gmail.com with ESMTPSA id l13-20020a170903120d00b001d4c8eabb82sm75787plh.223.2024.01.01.17.21.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Jan 2024 17:21:51 -0800 (PST)
Date: Tue, 2 Jan 2024 10:21:46 +0900
From: Sergey Senozhatsky <senozhatsky@chromium.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: mm-commits@vger.kernel.org, zhouchengming@bytedance.com,
	yosryahmed@google.com, v-songbaohua@oppo.com,
	vitaly.wool@konsulko.com, sjenning@redhat.com,
	senozhatsky@chromium.org, nphamcs@gmail.com, minchan@kernel.org,
	hannes@cmpxchg.org, ddstreet@ieee.org, chrisl@kernel.org,
	21cnbao@gmail.com
Subject: Re: +
 mm-zsmalloc-return-enospc-rather-than-einval-in-zs_malloc-while-size-is-too-large.patch
 added to mm-unstable branch
Message-ID: <20240102012146.GC21409@google.com>
References: <20231228191226.51357C433C8@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231228191226.51357C433C8@smtp.kernel.org>

On (23/12/28 11:12), Andrew Morton wrote:
> This is the case the "compressed" data is larger than the original data,
> it is better to return -ENOSPC which can help zswap record a poor compr
> rather than an invalid request.  Then we get more friendly counting for
> reject_compress_poor in debugfs.
> 
>  bool zswap_store(struct folio *folio)
>  {
>  	...
>  	ret = zpool_malloc(zpool, dlen, gfp, &handle);
>  	if (ret == -ENOSPC) {
>  		zswap_reject_compress_poor++;
>  		goto put_dstmem;
>  	}
>  	if (ret) {
>  		zswap_reject_alloc_fail++;
>  		goto put_dstmem;
>  	}
>  	...
>  }
> 
> Also, zbud_alloc() and z3fold_alloc() are returning ENOSPC in the same
> case, eg
> 
>  static int z3fold_alloc(struct z3fold_pool *pool, size_t size, gfp_t gfp,
>  			unsigned long *handle)
>  {
>  	...
>  	if (!size || (gfp & __GFP_HIGHMEM))
>  		return -EINVAL;
> 
>  	if (size > PAGE_SIZE)
>  		return -ENOSPC;
>  	...
>  }
> 
> Link: https://lkml.kernel.org/r/20231228061802.25280-1-v-songbaohua@oppo.com
> Signed-off-by: Barry Song <v-songbaohua@oppo.com>
> Reviewed-by: Chengming Zhou <zhouchengming@bytedance.com>
> Cc: Chris Li <chrisl@kernel.org>
> Cc: Dan Streetman <ddstreet@ieee.org>
> Cc: Johannes Weiner <hannes@cmpxchg.org>
> Cc: Minchan Kim <minchan@kernel.org>
> Cc: Nhat Pham <nphamcs@gmail.com>
> Cc: Sergey Senozhatsky <senozhatsky@chromium.org>
> Cc: Seth Jennings <sjenning@redhat.com>
> Cc: Vitaly Wool <vitaly.wool@konsulko.com>
> Cc: Yosry Ahmed <yosryahmed@google.com>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>

Acked-by: Sergey Senozhatsky <senozhatsky@chromium.org>
