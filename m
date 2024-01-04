Received: from mail-pl1-f196.google.com (mail-pl1-f196.google.com [209.85.214.196])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6BBD11FB4
	for <mm-commits@vger.kernel.org>; Thu,  4 Jan 2024 02:25:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bytedance.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.b="KwrquGGn"
Received: by mail-pl1-f196.google.com with SMTP id d9443c01a7336-1d410fce119so113905ad.1
        for <mm-commits@vger.kernel.org>; Wed, 03 Jan 2024 18:25:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1704335149; x=1704939949; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:cc:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=li2E+muEN9dxSaWkZtdPLtk/Fnh2a/D4Z8Uj5AR92aE=;
        b=KwrquGGnoMo42O+MWNhqyRZDGD8BBPIFRXm4L41NVXIuLf4UfgnAERCAp88YZclmo5
         DgMn+zUrbwJA6pjJSwrPGcwfF9MI4Sn5KxsDecmkzxnSNO7417b+aD/bTixyAUWKn1hh
         oAvM9HTVAaEVeGk+WEzp13wXOPuv1iA6OVvu3sgnudiYwlbIwpvIr7oAcVcRVEj9zZqg
         Mzd4N4s3XOCEv6KTpyyHCUYIklN6UTvALtngP3ykOs3VLcjWigL37hOnQiih9iwfhRwZ
         Qa3jQ9kNSjFh2K8Uc0m+GM/d2AfJPw6oefPx18KgW3IethhftP2DBMcnYO4SUJ8sH/po
         /ViA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1704335149; x=1704939949;
        h=content-transfer-encoding:in-reply-to:cc:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=li2E+muEN9dxSaWkZtdPLtk/Fnh2a/D4Z8Uj5AR92aE=;
        b=edBdJjRLnQPyMnKw7xaY7x2cuQ730s1un6EGliaZXez3J12SHNpHWqN08RPcHFFOfs
         UJUG5UBrVNvTI9/L2pV7v4ZbwKOgTnqDQJ8u+J6+SQXknW8gLQ/eUKvuIxE0DyvhY2pB
         79b/WqLvOs2PyYhJj9XVw5+tPpB/LA1WMsKpR8rgdZ7teh0TlQvi3sSpBuhCfeIf1odm
         lweo6S/6u/IQf88cNoAA1MFhGG9EKSukk7CQONc19zZWFhjyk5oB5546Yic/Sioadxtk
         /6pOw9KLVVNJ/SESsAHiDsPQZtAP0O5JLBm+aqduLx2KrZ1hoiZ7tQYJxrvTVlP6+p+Q
         O0ag==
X-Gm-Message-State: AOJu0YyG1Hjve6y+hf/snADW2LFP2HS7XgS2aOG+jYnHahsVdBaeiLWC
	5Xc48j06GAKwvW/fIVbWBh9HgWxeBpUfBw==
X-Google-Smtp-Source: AGHT+IGT2RQljpK8z8tmfMhh7i5G+KfrGJ4qEqvtS/3SVmvNreu9p4zBrwV+zFaYVCW2FE36mT2/gA==
X-Received: by 2002:a05:6a20:8698:b0:194:db35:767 with SMTP id k24-20020a056a20869800b00194db350767mr32275315pze.2.1704335149552;
        Wed, 03 Jan 2024 18:25:49 -0800 (PST)
Received: from [10.84.155.44] ([203.208.167.146])
        by smtp.gmail.com with ESMTPSA id ix9-20020a170902f80900b001cff026df52sm24538433plb.221.2024.01.03.18.25.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 03 Jan 2024 18:25:49 -0800 (PST)
Message-ID: <1160e8c6-e00f-4a43-8b75-f3e48fd140bc@bytedance.com>
Date: Thu, 4 Jan 2024 10:25:45 +0800
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: +
 mm-shrinker-use-kvzalloc_node-from-expand_one_shrinker_info.patch added to
 mm-hotfixes-unstable branch
Content-Language: en-US
To: penguin-kernel@I-love.SAKURA.ne.jp,
 Andrew Morton <akpm@linux-foundation.org>
References: <20240103181745.7C1E6C433C7@smtp.kernel.org>
From: Qi Zheng <zhengqi.arch@bytedance.com>
Cc: mm-commits@vger.kernel.org, songmuchun@bytedance.com
In-Reply-To: <20240103181745.7C1E6C433C7@smtp.kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 2024/1/4 02:17, Andrew Morton wrote:
> The patch titled
>       Subject: mm: shrinker: use kvzalloc_node() from expand_one_shrinker_info()
> has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
>       mm-shrinker-use-kvzalloc_node-from-expand_one_shrinker_info.patch
> 
> This patch will shortly appear at
>       https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-shrinker-use-kvzalloc_node-from-expand_one_shrinker_info.patch
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
> Subject: mm: shrinker: use kvzalloc_node() from expand_one_shrinker_info()
> Date: Wed, 3 Jan 2024 10:52:22 +0900
> 
> syzbot is reporting uninit-value at shrinker_alloc(), for commit
> 307bececcd12 ("mm: shrinker: add a secondary array for
> shrinker_info::{map, nr_deferred}") which assumed that the ->unit was
> allocated with __GFP_ZERO forgot to replace kvmalloc_node() in
> expand_one_shrinker_info() with kvzalloc_node().
> 
> Link: https://lkml.kernel.org/r/9226cc0a-10e0-4489-80c5-58c3b5b4359c@I-love.SAKURA.ne.jp

Very strange, the above link is still invalid, and this v2 still cannot
be found in LKML or linux-mm. It can only be found in mm-commits.

And I cannot receive emails from Tetsuo, including the one below, but
I can receive emails from Andrew normally.

https://lore.kernel.org/all/c3cdc9b3-a06f-4be7-af3b-44abb8d72c7d@I-love.SAKURA.ne.jp/

But anyway, this patch LGTM, thanks.

> Reported-by: syzbot <syzbot+1e0ed05798af62917464@syzkaller.appspotmail.com>
> Closes: https://syzkaller.appspot.com/bug?extid=1e0ed05798af62917464
> Fixes: 307bececcd12 ("mm: shrinker: add a secondary array for shrinker_info::{map, nr_deferred}")
> Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
> Cc: Qi Zheng <zhengqi.arch@bytedance.com>
> Cc: Muchun Song <songmuchun@bytedance.com>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> ---
> 
>   mm/shrinker.c |    2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> --- a/mm/shrinker.c~mm-shrinker-use-kvzalloc_node-from-expand_one_shrinker_info
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
> mm-shrinker-use-kvzalloc_node-from-expand_one_shrinker_info.patch
> 
