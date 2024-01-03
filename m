Received: from mail-pj1-f66.google.com (mail-pj1-f66.google.com [209.85.216.66])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43F97468C
	for <mm-commits@vger.kernel.org>; Wed,  3 Jan 2024 02:33:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bytedance.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.b="TFOJPHjr"
Received: by mail-pj1-f66.google.com with SMTP id 98e67ed59e1d1-28bae84fc2eso2073110a91.1
        for <mm-commits@vger.kernel.org>; Tue, 02 Jan 2024 18:33:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1704249235; x=1704854035; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:cc:content-language:from
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=ZgQWjSKKRrfX/+GGVeSp/hYfAwlfA6MilNXEOjdK1ss=;
        b=TFOJPHjrGklJ2Xms+sNxEKWtJ5INhkQUo38otIyjMYY8KHKmO2U8grlaW9gTqwOOxO
         E0yV4zX71bltocx3X4L+MTwZAzRXBUA2SotCtM+MBpJ8MOOlW5uEQbNFNZ7FcGK4t5N2
         kP+R71SSjk8wQVdVyAXqw44NdrJKERfa0q243a+T5UpHI8kLc92ASki1ZxJVmRgo9jNm
         5Lz/TG2WqOIV+Gs1aOUX2xDviLlhS4evaabZlfOO+KASQgVB5p80LaRmgoN1awmkuTgX
         koG08E2Li0Q5w/rllvx4tDS77H82AxlkIjdngXKlscHMjr9q6t81kkBqdac8UTFvwpN+
         fKNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1704249235; x=1704854035;
        h=content-transfer-encoding:in-reply-to:cc:content-language:from
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ZgQWjSKKRrfX/+GGVeSp/hYfAwlfA6MilNXEOjdK1ss=;
        b=mnV3ngnzWWCUAOVKMC6wtU32z21ubrlgvm7cx1fRwrxXA+evLXn54d23iWe7WT1Gjj
         QwPDOfizcpZLalz+rvgRlCL1/nfGZ5jO9046ZI6k5qH6Jkq7QPlFACWHkXp6sRtGUH8B
         0+qOPpJuwxH9lyBrePs40m95d9Vodrul135nshTy03EqYuf6qr3PiOXZHRUGVuOmJeWN
         Yfyg9cpatIDXLa8z//EfQg8ee6myogt1V4q28AxGpW9XxkD+A8kUaGGeeJvVRAqe4oSx
         akpqHV51FYCKWB+njPx10ncWPhSIVyIWe7k67LKBfdlNiJwOk9r7NpaZXhtGgKuzGjDP
         7dLA==
X-Gm-Message-State: AOJu0YwaEMr9EJnryTmbi10WYMYKAXSu3WXIdLfXKA9x0pva7W50mlHO
	KWUMmdNansHayvGd/dmBt/3Srjcs5aEFFQ==
X-Google-Smtp-Source: AGHT+IF/xlgdR1Zd2tqL+i0p8lyyhZsN9wh8Abq/hGyR47+0AFHPVJMM451gggQ9XjUMIolYJl80rg==
X-Received: by 2002:a17:90a:4b0f:b0:28b:9a2d:c1c5 with SMTP id g15-20020a17090a4b0f00b0028b9a2dc1c5mr27364539pjh.2.1704249235273;
        Tue, 02 Jan 2024 18:33:55 -0800 (PST)
Received: from [10.84.155.44] ([203.208.167.146])
        by smtp.gmail.com with ESMTPSA id d9-20020a17090b004900b0028a267a5a05sm330144pjt.36.2024.01.02.18.33.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 02 Jan 2024 18:33:54 -0800 (PST)
Message-ID: <35fc708f-c27c-4b37-99c2-f6c0db8db1d5@bytedance.com>
Date: Wed, 3 Jan 2024 10:33:50 +0800
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: +
 mm-shrinker-use-kvzalloc_node-from-memcg_expand_one_shrinker_map.patch added
 to mm-hotfixes-unstable branch
To: Andrew Morton <akpm@linux-foundation.org>
References: <20240102175847.AA94EC433C8@smtp.kernel.org>
From: Qi Zheng <zhengqi.arch@bytedance.com>
Content-Language: en-US
Cc: mm-commits@vger.kernel.org,
 syzbot+1e0ed05798af62917464@syzkaller.appspotmail.com,
 songmuchun@bytedance.com, penguin-kernel@I-love.SAKURA.ne.jp
In-Reply-To: <20240102175847.AA94EC433C8@smtp.kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 2024/1/3 01:58, Andrew Morton wrote:
> The patch titled
>       Subject: mm: shrinker: use kvzalloc_node() from memcg_expand_one_shrinker_map()
> has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
>       mm-shrinker-use-kvzalloc_node-from-memcg_expand_one_shrinker_map.patch
> 
> This patch will shortly appear at
>       https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-shrinker-use-kvzalloc_node-from-memcg_expand_one_shrinker_map.patch
> 
> This patch will later appear in the mm-hotfixes-unstable branch at
>      git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
> 
> Before you just go and hit "reply", please:
>     a) Consider who else should be cc'ed
>     b) Prefer to cc a suitable mailing list as well
>     c) Ideally: find the original patch on the mailing list and do a
>        reply-to-all to that, adding suitable additional cc's
> 
> *** Remember to use Documentation/process/submit-checklist.rst when testing your code ***
> 
> The -mm tree is included into linux-next via the mm-everything
> branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
> and is updated there every 2-3 working days
> 
> ------------------------------------------------------
> From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
> Subject: mm: shrinker: use kvzalloc_node() from memcg_expand_one_shrinker_map()
> Date: Wed, 3 Jan 2024 00:46:36 +0900
> 
> syzbot is reporting uninit-value at shrinker_alloc(), for commit
> 307bececcd12 ("mm: shrinker: add a secondary array for
> shrinker_info::{map, nr_deferred}") which assumed that the ->unit was
> allocated with __GFP_ZERO forgot to replace kvmalloc_node() in
> memcg_expand_one_shrinker_map() with kvzalloc_node().
> 
> Link: https://lkml.kernel.org/r/b1a78c6a-b3fa-46ed-810a-ce546e726d44@I-love.SAKURA.ne.jp

Thanks for fixing this!

Reviewed-by: Qi Zheng <zhengqi.arch@bytedance.com>

BTW, this link above seems to be inaccessible:

```
Message-ID <b1a78c6a-b3fa-46ed-810a-ce546e726d44@I-love.SAKURA.ne.jp>
not found

Perhaps try an external site:
```

And I did not find this patch in LKML.

> Fixes: 307bececcd12 ("mm: shrinker: add a secondary array for shrinker_info::{map, nr_deferred}")
> Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
> Reported-by: syzbot <syzbot+1e0ed05798af62917464@syzkaller.appspotmail.com>
> Closes: https://syzkaller.appspot.com/bug?extid=1e0ed05798af62917464
> Cc: Qi Zheng <zhengqi.arch@bytedance.com>
> Cc: Muchun Song <songmuchun@bytedance.com>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> ---
> 
>   mm/shrinker.c |    2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> --- a/mm/shrinker.c~mm-shrinker-use-kvzalloc_node-from-memcg_expand_one_shrinker_map
> +++ a/mm/shrinker.c
> @@ -126,7 +126,7 @@ static int expand_one_shrinker_info(stru
>   		if (new_nr_max <= old->map_nr_max)
>   			continue;
>   
> -		new = kvmalloc_node(sizeof(*new) + new_size, GFP_KERNEL, nid);
> +		new = kvzalloc_node(sizeof(*new) + new_size, GFP_KERNEL, nid);
>   		if (!new)
>   			return -ENOMEM;
>   
> _
> 
> Patches currently in -mm which might be from penguin-kernel@I-love.SAKURA.ne.jp are
> 
> mm-shrinker-use-kvzalloc_node-from-memcg_expand_one_shrinker_map.patch
> 
