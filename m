Received: from mail-pl1-f175.google.com (mail-pl1-f175.google.com [209.85.214.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1752D13D521
	for <mm-commits@vger.kernel.org>; Thu, 15 Jan 2026 03:25:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768447547; cv=none; b=cEKzGmzgOOftjnBUvZjsO0ITtNVMNu3wkjVHs6hwVpe+GI4PTWQtV/mSA+F5AR1wYwRqpLm251aQ30Mt22YA1Ygjw/tCecUgowkXQmxnUAEQNSw8YiQAH4ZShnWh8P+hDoJzPfA2rcW6lYRWsSse0DtKkscRVgrPO/4GqM7up/8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768447547; c=relaxed/simple;
	bh=k6YEIxZVf0uYJ9jYWD/TLbIqXMsPjmneDkyjAlrXTSk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=n7wB35SkDM8yEf1WgZ+DvVZ86yWSwGooyCgi08p6R4FHis5CB/D2EtUBnDAUzWGZi5sGgh97ClATfEXSkxhtvYXjM2u8LssVtWhYKCU1KfT+bD80+eElw/5udgXbs+pbWeuEv5IUkU6oOPzuU0hrcij+ibQ0q9L7teqm3/JYfJQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org; spf=pass smtp.mailfrom=chromium.org; dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b=KYkKpNt8; arc=none smtp.client-ip=209.85.214.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chromium.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="KYkKpNt8"
Received: by mail-pl1-f175.google.com with SMTP id d9443c01a7336-2a09757004cso3423745ad.3
        for <mm-commits@vger.kernel.org>; Wed, 14 Jan 2026 19:25:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1768447545; x=1769052345; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=aLiaNR3Ix81EnXRtLlVQbl+BmoadOQ1oFy7YU2+wgdA=;
        b=KYkKpNt8IxhQGlts0PKhPwG/IaDnZFlp/yWojd79EeNCecyWOsKd+QdPCzJN7mZGgM
         5qZ4WU1q4ma6j1islvSEbFrAjrusOXcmv97xg266RL/c0M9I8pL7K9ycapp+MauQhbL2
         pGbD2FoaQyaT5g9Wbbe2LlPG7W2yinS+Veu2E=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768447545; x=1769052345;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=aLiaNR3Ix81EnXRtLlVQbl+BmoadOQ1oFy7YU2+wgdA=;
        b=n8y5gm0OnfaaVG9OygqLgAck66Zj3XOW/EQy2DRrKOA0W6r0zSgLs7anLwgIoIu1Tk
         2HponjUYCGhZxsywluFdKu31TOybuW0ydozmgIAg5OmY0l+Jnxh3zCC6wlLWDFeJJtJa
         Mb6i781LfGffboFcuB5UI6katWiHtgjdKgp5JyET37tgI4n9W83ESVBUDjNqN6vXU4Ut
         +GvsSJhkU0f/yRb7Z9klZmwBEn/MGh2Gzye+zX7XsTSSLkBiKWlNYFehJ4G0szB2jcoF
         sWuu1FpOM4N2yg6lrwvQhpPyiRXF95Xzx+sXsSqBxjsUgufYSUysfrp7MO3Cd3ZQijLv
         Q0eA==
X-Gm-Message-State: AOJu0YxpxTv4Yq0sBlkxjH8K5ywGG+/CdBBhjwC+9VE2cOpefNi7Y+2E
	a5EssDLqUrdZW9uVJ1Rj339USkXn+lioN81nA7ZeUruErVKVW2JE3nCMUo+Yp0lkKQ==
X-Gm-Gg: AY/fxX7UIg//Tre5SUg+6VstFAgI+uR3aSj1sjPPYRn1gtreBWrePRu/VyDc7Gc16rc
	9btbGstgyOG5bsqGuDwd8PHaL/xzU+MLzAoEVH/Wi1p6WZNKiKNoqNH1Oi68aoq7YMEqjIY7bLi
	SqVQVUGnJity+ByLS9zY4DVnbInp9M1h94uiZR0E5yr0dH+c0sXkPMaEYl2/8/qOySEXG2JwpmH
	7FrZL66cniYcry/yWhhwoiwP234ik8un0aCoqCRMvbex2HBzvBxPw4U+0cd9ziMU/Int1wnmG7i
	2EdM4PqDvAZjj9WwgFpBtmJXi5HEwDzB48lK9xIU3kYaSi4GTWA305Cs8NDrxpajkNBSEBHSE4N
	atC1dBwMmt1CFHeSoGFUcxpt/6DKSv7C9dXqfCGrEtxTCvIhVGPuNSd/sekIY9HmbF0uKQK8SvN
	QrA2hntqqLmvS8A9NFLz1BAhrnKK3MagxKCkc24REqlM4B9o5z/x8=
X-Received: by 2002:a17:902:f688:b0:295:745a:8016 with SMTP id d9443c01a7336-2a59bb1803bmr44051615ad.11.1768447545415;
        Wed, 14 Jan 2026 19:25:45 -0800 (PST)
Received: from google.com ([2a00:79e0:2031:6:36c2:991a:5236:1fe5])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-c4cca06b16fsm24707575a12.31.2026.01.14.19.25.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Jan 2026 19:25:44 -0800 (PST)
Date: Thu, 15 Jan 2026 12:25:39 +0900
From: Sergey Senozhatsky <senozhatsky@chromium.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: mm-commits@vger.kernel.org, stevensd@google.com, richardycc@google.com, 
	minchan@google.com, bgeffon@google.com, senozhatsky@chromium.org
Subject: Re: + zram-use-u32-for-entry-ac_time-tracking.patch added to mm-new
 branch
Message-ID: <aajymtsa6wesyjvh73uacvm76mi3qhn3nzqrtie3xu67y2sevx@5ntik7xg5n7d>
References: <20251216022727.578BFC4CEF5@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251216022727.578BFC4CEF5@smtp.kernel.org>

On (25/12/15 18:27), Andrew Morton wrote:
[..]
>  static inline u32 zram_get_priority(struct zram *zram, u32 index)
>  {
> -	u32 prio = zram->table[index].flags >> ZRAM_COMP_PRIORITY_BIT1;
> +	u32 prio = zram->table[index].attr.flags >> ZRAM_COMP_PRIORITY_BIT1;
>  
>  	return prio & ZRAM_COMP_PRIORITY_MASK;
>  }
> @@ -225,7 +224,7 @@ static void zram_accessed(struct zram *z
>  	zram_clear_flag(zram, index, ZRAM_IDLE);
>  	zram_clear_flag(zram, index, ZRAM_PP_SLOT);
>  #ifdef CONFIG_ZRAM_TRACK_ENTRY_ACTIME
> -	zram->table[index].ac_time = ktime_get_boottime();
> +	zram->table[index].attr.ac_time = (u32)ktime_get_boottime_seconds();
>  #endif
>  }

Andrew, I sent a fixup patch for the previous patch in that series [1].
This chunk is not needed anymore, as this get_boottime conversion
simply should have never happened in the first place.

Apologies for inconvenience.

[1] https://lore.kernel.org/linux-kernel/20260115031922.3813659-1-senozhatsky@chromium.org
