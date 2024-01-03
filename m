Received: from mail-pg1-f195.google.com (mail-pg1-f195.google.com [209.85.215.195])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C83954A17
	for <mm-commits@vger.kernel.org>; Wed,  3 Jan 2024 02:40:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bytedance.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.b="X7QH+xDj"
Received: by mail-pg1-f195.google.com with SMTP id 41be03b00d2f7-5cdf90e5cdeso1667894a12.1
        for <mm-commits@vger.kernel.org>; Tue, 02 Jan 2024 18:40:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1704249624; x=1704854424; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:cc:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=5Vg9FQYcEdMrQbm9pJ6YqctoNxce8IOkUFTgbjw+JTE=;
        b=X7QH+xDjbAumKLZpAlKX4ch24f1Ey1rRmIm4D6+LiCYoxUQg0B3Fb1pBBZnjO0NVIq
         1nDr5dww8AfHKTG4XPF08cV/pM8I3fuhP37uD8vm5QyxjOwuhTfZwPSqK+wONcf9/FQh
         ion4VzR3NsO++UczWBoMTGkU72ReNEii9RZtQAMmfxcmQL9VNrbFrCQbx5jLUZHBOd/n
         G19WwDldAjcNpdrsRZtRBthITL/DqSsA6hjKmrDZ1dw7EfF5OoGe6geEs4YsBpOKV2Aw
         +lMQUVc7UqD/YtWp2TSREBn9xMhBX6RqxKmnm6JD2K4pBYNs8gyO7+3A40ejVDTk4oSc
         pWLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1704249624; x=1704854424;
        h=content-transfer-encoding:in-reply-to:cc:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=5Vg9FQYcEdMrQbm9pJ6YqctoNxce8IOkUFTgbjw+JTE=;
        b=gkx5endGOlWoO3NwBUiCZKtlWlDIQKnicopt0MGADWRF8cDjRe8T/N/80JC/6HDkXI
         9EnjJ2Jnc6SIhNbUG+QcYtiGALIAaIohwGg2nCVqGKaumP84i0jA+YHDE9H9h6iswRun
         W78XIZHE7W/JXkE7G5SqPju4Btcnl6zTk8zX7sm1Ol7Gs8SVOx1cS62LnhEAbZPxFyQ5
         Qym9D/sXMfVPjUCWLHIV/wpNttMBYgyn470VsoEZy8yeMwK0Ue1JrOd/U8KFy/tWiIb9
         yvHBP+I9+IuZkcUbyLflWbhEMXmXwRdmOVOEUeLkzw0huQarM1wej66SMy+64pc9ceEm
         vihw==
X-Gm-Message-State: AOJu0YxexoNI3XdmoeOBk7Isl9d69gdVuDepp9RCBzxlAk5ZkvO8YwjQ
	Hb1a5UO9jVyN6HLA8jaH7CMKUg04QwspKnatNKGzqZuCuvvM0w==
X-Google-Smtp-Source: AGHT+IGZkyEdIQISTjWqUY1jSJ9TZgMRLUJWsgbIlz5aLfLMjIbkyCTu+h3cG/Z++e+4I2tiiMZziw==
X-Received: by 2002:a05:6a00:1c8d:b0:6da:736d:67c8 with SMTP id y13-20020a056a001c8d00b006da736d67c8mr11380943pfw.3.1704249623950;
        Tue, 02 Jan 2024 18:40:23 -0800 (PST)
Received: from [10.84.155.44] ([203.208.167.146])
        by smtp.gmail.com with ESMTPSA id w15-20020aa7858f000000b006d9ac70682bsm16959291pfn.167.2024.01.02.18.40.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 02 Jan 2024 18:40:23 -0800 (PST)
Message-ID: <99d18ba5-268f-4557-a428-95bcc5c91069@bytedance.com>
Date: Wed, 3 Jan 2024 10:40:19 +0800
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
Content-Language: en-US
To: Andrew Morton <akpm@linux-foundation.org>
References: <20240102175847.AA94EC433C8@smtp.kernel.org>
From: Qi Zheng <zhengqi.arch@bytedance.com>
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

And we don't have memcg_expand_one_shrinker_map(), maybe change the
Subject to "mm: shrinker: use kvzalloc_node() in expand_one_shrinker_info()"

> Date: Wed, 3 Jan 2024 00:46:36 +0900
> 
> syzbot is reporting uninit-value at shrinker_alloc(), for commit
> 307bececcd12 ("mm: shrinker: add a secondary array for
> shrinker_info::{map, nr_deferred}") which assumed that the ->unit was
> allocated with __GFP_ZERO forgot to replace kvmalloc_node() in
> memcg_expand_one_shrinker_map() with kvzalloc_node().

Ditto, needs to be changed to expand_one_shrinker_info().

> 
> Link: https://lkml.kernel.org/r/b1a78c6a-b3fa-46ed-810a-ce546e726d44@I-love.SAKURA.ne.jp
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
