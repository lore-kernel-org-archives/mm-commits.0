Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-22.4 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 51921C433EF
	for <mm-commits@archiver.kernel.org>; Fri, 10 Sep 2021 10:08:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2B8186103D
	for <mm-commits@archiver.kernel.org>; Fri, 10 Sep 2021 10:08:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232129AbhIJKJd (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 10 Sep 2021 06:09:33 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:24904 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232120AbhIJKJc (ORCPT
        <rfc822;mm-commits@vger.kernel.org>);
        Fri, 10 Sep 2021 06:09:32 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1631268501;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=fjR/7421N8zHcYISmkhC7alm/BqHmxIBm/Chp9uKxh8=;
        b=R7Fwh+NfCozWuO8iBb+EDwMBA4qHY69I6ETAk+V3XPSkT6Sn3ayz1S3+j53JYrzyueqr/r
        xIrGLEMRqYRw9kBM10CiH0evDCuUu7AH20qossHza2Oz96ywrrcfDQAZS51UOUBoiiKXFn
        xBL4CnReKTLN1ZSTERY0F4kfiyopnmA=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-479-Z8kiWJLpNkO7CGfNG5m2mA-1; Fri, 10 Sep 2021 06:08:20 -0400
X-MC-Unique: Z8kiWJLpNkO7CGfNG5m2mA-1
Received: by mail-wm1-f69.google.com with SMTP id x10-20020a7bc20a000000b002f8cf761457so441273wmi.1
        for <mm-commits@vger.kernel.org>; Fri, 10 Sep 2021 03:08:20 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:references:from:organization
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=fjR/7421N8zHcYISmkhC7alm/BqHmxIBm/Chp9uKxh8=;
        b=B0jWN2Y23ZEsmTA/fw057hQC6x8sRmyl57r/m9Qv/FuNrP0pWp1gFdGFa4TmGN+6NM
         cbtkLYrS5k7ZxvkaXZNJL7JER9gGKEiEatXyamq1nEek1e1kcHiqh95Agiz+rRzCSdqf
         Qlff6tDf9lclkp1pmcPjzPZzs1hAOrvhQML20aDTKc+4IxmcUcFZZ3s/rsFKZzyjImmt
         uQXHaS1yiRbSnh+uYfDwI/+RqKT9zshdulcCS+/JVP3vlJhbdsRQ7QUdK7mr+F5ZMXJj
         c1WbbgNYkLEHp6dU6L2cUkwIGYcJ8SILyil/uf8zkjGyHr3w5QPKJHTeda/RbXlWzT4c
         n+lA==
X-Gm-Message-State: AOAM532Ufw82yBxxI8W5UQ43DpzFfSQRZtQaepN6flqz+KRTXCxQP5Iz
        iyJ2wCmqLvIGsqbfl3tckoS9haKSxAFFSBsstbV5wL/uJNkym4ts4kuqaCUGKEcXfYW0+eve74j
        GaW+1nPnxbu9PlBq9/GZyXA==
X-Received: by 2002:a5d:56cf:: with SMTP id m15mr8695713wrw.240.1631268499106;
        Fri, 10 Sep 2021 03:08:19 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJy1xfkEjK0ikzplwxR6Udi78msdZgXTK7TNv+7B8BsWTw1PFo/oYyPM7Kk8zg1wHYe7gzYGBA==
X-Received: by 2002:a5d:56cf:: with SMTP id m15mr8695701wrw.240.1631268498912;
        Fri, 10 Sep 2021 03:08:18 -0700 (PDT)
Received: from [192.168.3.132] (p5b0c600c.dip0.t-ipconnect.de. [91.12.96.12])
        by smtp.gmail.com with ESMTPSA id n13sm3505848wmq.3.2021.09.10.03.08.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 10 Sep 2021 03:08:18 -0700 (PDT)
Subject: Re: [patch 079/147] fs/proc/kcore.c: add mmap interface
To:     Andrew Morton <akpm@linux-foundation.org>, adobriyan@gmail.com,
        chenying.kernel@bytedance.com, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, rppt@kernel.org,
        songmuchun@bytedance.com, torvalds@linux-foundation.org,
        zhouchengming@bytedance.com, zhoufeng.zf@bytedance.com
References: <20210908025730.S88ylmikU%akpm@linux-foundation.org>
From:   David Hildenbrand <david@redhat.com>
Organization: Red Hat
Message-ID: <303e9a27-7495-1c94-64a1-a1149a39f0a9@redhat.com>
Date:   Fri, 10 Sep 2021 12:08:17 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210908025730.S88ylmikU%akpm@linux-foundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

On 08.09.21 04:57, Andrew Morton wrote:
> From: Feng Zhou <zhoufeng.zf@bytedance.com>
> Subject: fs/proc/kcore.c: add mmap interface
> 
> When we do the kernel monitor, use the DRGN
> (https://github.com/osandov/drgn) access to kernel data structures, found
> that the system calls a lot.  DRGN is implemented by reading /proc/kcore.
> After looking at the kcore code, it is found that kcore does not implement
> mmap, resulting in frequent context switching triggered by read.
> Therefore, we want to add mmap interface to optimize performance.  Since
> vmalloc and module areas will change with allocation and release,
> consistency cannot be guaranteed, so mmap interface only maps KCORE_TEXT
> and KCORE_RAM.
> 
> The test results:
> 1. the default version of kcore
> real 11.00
> user 8.53
> sys 3.59
> 
> % time     seconds  usecs/call     calls    errors syscall
> ------ ----------- ----------- --------- --------- ----------------
> 99.64  128.578319          12  11168701           pread64
> ...
> ------ ----------- ----------- --------- --------- ----------------
> 100.00  129.042853              11193748       966 total
> 
> 2. added kcore for the mmap interface
> real 6.44
> user 7.32
> sys 0.24
> 
> % time     seconds  usecs/call     calls    errors syscall
> ------ ----------- ----------- --------- --------- ----------------
> 32.94    0.130120          24      5317       315 futex
> 11.66    0.046077          21      2231         1 lstat
>   9.23    0.036449         177       206           mmap
> ...
> ------ ----------- ----------- --------- --------- ----------------
> 100.00    0.395077                 25435       971 total
> 
> The test results show that the number of system calls and time
> consumption are significantly reduced.
> 
> Link: https://lkml.kernel.org/r/20210704062208.7898-1-zhoufeng.zf@bytedance.com
> Co-developed-by: Ying Chen <chenying.kernel@bytedance.com>
> Signed-off-by: Ying Chen <chenying.kernel@bytedance.com>
> Signed-off-by: Feng Zhou <zhoufeng.zf@bytedance.com>
> Cc: Alexey Dobriyan <adobriyan@gmail.com>
> Cc: Mike Rapoport <rppt@kernel.org>
> Cc: Muchun Song <songmuchun@bytedance.com>
> Cc: Chengming Zhou <zhouchengming@bytedance.com>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> ---
> 
>   fs/proc/kcore.c |   73 ++++++++++++++++++++++++++++++++++++++++++++++
>   1 file changed, 73 insertions(+)
> 
> --- a/fs/proc/kcore.c~fs-proc-kcorec-add-mmap-interface
> +++ a/fs/proc/kcore.c
> @@ -614,11 +614,84 @@ static int release_kcore(struct inode *i
>   	return 0;
>   }
>   
> +static vm_fault_t mmap_kcore_fault(struct vm_fault *vmf)
> +{
> +	return VM_FAULT_SIGBUS;
> +}
> +
> +static const struct vm_operations_struct kcore_mmap_ops = {
> +	.fault = mmap_kcore_fault,
> +};
> +
> +static int mmap_kcore(struct file *file, struct vm_area_struct *vma)
> +{
> +	size_t size = vma->vm_end - vma->vm_start;
> +	u64 start, end, pfn;
> +	int nphdr;
> +	size_t data_offset;
> +	size_t phdrs_len, notes_len;
> +	struct kcore_list *m = NULL;
> +	int ret = 0;
> +
> +	down_read(&kclist_lock);
> +
> +	get_kcore_size(&nphdr, &phdrs_len, &notes_len, &data_offset);
> +
> +	data_offset &= PAGE_MASK;
> +	start = (u64)vma->vm_pgoff << PAGE_SHIFT;
> +	if (start < data_offset) {
> +		ret = -EINVAL;
> +		goto out;
> +	}
> +	start = kc_offset_to_vaddr(start - data_offset);
> +	end   = start + size;
> +
> +	list_for_each_entry(m, &kclist_head, list) {
> +		if (start >= m->addr && end <= m->addr + m->size)
> +			break;
> +	}
> +
> +	if (&m->list == &kclist_head) {
> +		ret = -EINVAL;
> +		goto out;
> +	}
> +
> +	if (vma->vm_flags & (VM_WRITE | VM_EXEC)) {
> +		ret = -EPERM;
> +		goto out;
> +	}
> +
> +	vma->vm_flags &= ~(VM_MAYWRITE | VM_MAYEXEC);
> +	vma->vm_flags |= VM_MIXEDMAP;
> +	vma->vm_ops = &kcore_mmap_ops;
> +

This breaks all my efforts to sanitize /proc/kore access for virtio-mem.

Is there still a way to nack this?

Sorry I didn't spot this any sooner.


-- 
Thanks,

David / dhildenb

