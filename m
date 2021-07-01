Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_RED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 49456C11F64
	for <mm-commits@archiver.kernel.org>; Thu,  1 Jul 2021 06:35:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 24EC861422
	for <mm-commits@archiver.kernel.org>; Thu,  1 Jul 2021 06:35:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234480AbhGAGiG (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 1 Jul 2021 02:38:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40954 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234210AbhGAGiF (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 1 Jul 2021 02:38:05 -0400
Received: from mail-pl1-x62f.google.com (mail-pl1-x62f.google.com [IPv6:2607:f8b0:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F0A56C061756
        for <mm-commits@vger.kernel.org>; Wed, 30 Jun 2021 23:35:35 -0700 (PDT)
Received: by mail-pl1-x62f.google.com with SMTP id v13so3077851ple.9
        for <mm-commits@vger.kernel.org>; Wed, 30 Jun 2021 23:35:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding;
        bh=rqHIANMsZa6psCFHi3SNVVtKGDOM6hpfvG19pl5xZFE=;
        b=DETYXdO0wp8KsQF/J8KcduBVDwodGLR9GhGnV77YzV4VhAdSXalwPX/KcSMnyaXoK1
         9n5veFiBxDMvGAdF8M9SDqdd03SLZBdT/pp20e0DR7/UHpGpLt5z4KnKVG9bTEItkbDd
         iMY2pebjnf0Xmz5rc7+eDFTm0/E/lTJ4gwMSuTNCZw60b8KiOTJVSCbfaomEr2YQoUuE
         t6YOlb1LX5/U6gnogYgj6Jlvu2sCzPdL5oM01eeyH1nh+nS77pSQmNcug0i0somVqP0U
         g7+1fAT61qyfMc9OkMwz4TMYgF8kv79ivPziiHSgjeFeCjear4r6BQ47RegLsw8MvWS8
         rldA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding;
        bh=rqHIANMsZa6psCFHi3SNVVtKGDOM6hpfvG19pl5xZFE=;
        b=V2ZR5vCY6rGxMpyhq7eEEGv8jHkpnsLOT6CtXLwGR7NUYP4cm4hxFwi5MUWqWiJhxl
         kksEdCIr/5F1u9w1ze1peHxLZ9ds2IQv1RFiRjxqe4UTsOnRtYuibNRDPR7xZ1VHP8g3
         dEoxEd1snqqAVrmVVXl9XZWl+mKmIo7N6brKPyF+dM+kVQOPymYY6PWClxsB3vGb3Sfk
         4FbhVkV7Huc8ZiVR4MGBqIbJCh/kIDAGshPR5lJTfGZWpyM8c4bBfEQq1GV5bcp+UiFR
         /N271TstgYQotVGiKkKepsFZ6G3qPFE4HM+1BXSeXDFzeGql+roL30ab7T4+A3e652QG
         TPHw==
X-Gm-Message-State: AOAM533YhMwJPkGUVBqfUZPhx8N/b1JrFfJb5kmIVveCqy23IQOwVPlB
        3TfKGhBzZd5KlsllKRr7ZssbVQ==
X-Google-Smtp-Source: ABdhPJxnkZoAlGLyOnC6LF38fGYrDCSiQdJhpfx/SRo9hkurkWBYdpMu6HBl1NRF2l4TXt7SIfM8tA==
X-Received: by 2002:a17:90a:bd82:: with SMTP id z2mr21567915pjr.4.1625121335507;
        Wed, 30 Jun 2021 23:35:35 -0700 (PDT)
Received: from [10.255.59.29] ([139.177.225.236])
        by smtp.gmail.com with ESMTPSA id j19sm24687739pgm.44.2021.06.30.23.35.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 30 Jun 2021 23:35:34 -0700 (PDT)
Subject: Re: [External] Re: [patch 141/192] fs/proc/kcore.c: add mmap
 interface
To:     Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Cc:     Alexey Dobriyan <adobriyan@gmail.com>,
        chenying.kernel@bytedance.com, Linux-MM <linux-mm@kvack.org>,
        mm-commits@vger.kernel.org, Mike Rapoport <rppt@kernel.org>,
        Muchun Song <songmuchun@bytedance.com>,
        zhouchengming@bytedance.com, duanxiongchun@bytedance.com
References: <20210630184624.9ca1937310b0dd5ce66b30e7@linux-foundation.org>
 <20210701015441.snfkDnNcO%akpm@linux-foundation.org>
 <CAHk-=wh8=sukFB3J-4BbBYZPLYoFgkzAjCxU95LKJ831g8SRVA@mail.gmail.com>
From:   zhoufeng <zhoufeng.zf@bytedance.com>
Message-ID: <44be9d56-7a56-5da0-9d74-7aee421732b2@bytedance.com>
Date:   Thu, 1 Jul 2021 14:35:28 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <CAHk-=wh8=sukFB3J-4BbBYZPLYoFgkzAjCxU95LKJ831g8SRVA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org



在 2021/7/1 上午11:32, Linus Torvalds 写道:
> On Wed, Jun 30, 2021 at 6:54 PM Andrew Morton <akpm@linux-foundation.org> wrote:
>> When we do the kernel monitor, use the DRGN
>> (https://github.com/osandov/drgn) access to kernel data structures, found
>> that the system calls a lot.  DRGN is implemented by reading /proc/kcore.
>> After looking at the kcore code, it is found that kcore does not implement
>> mmap, resulting in frequent context switching triggered by read.
>> Therefore, we want to add mmap interface to optimize performance.
> 
> Ok, this is funky, but I'm going to drop this patch because I think
> it's buggy as is.
> 
>   Since
> 
>> +static int mmap_kcore(struct file *file, struct vm_area_struct *vma)
>> +{
>> +       size_t size = vma->vm_end - vma->vm_start;
> 
> Ok.
> 
> But then:
> 
>> +       start = kc_offset_to_vaddr(((u64)vma->vm_pgoff << PAGE_SHIFT) -
>> +               ((data_offset >> PAGE_SHIFT) << PAGE_SHIFT));
> 
> Not only is that
> 
>          ((data_offset >> PAGE_SHIFT) << PAGE_SHIFT)
> 
> a very strange calculation (did you mean "data_offset & PAGE_MASK"?),
> but I don't see anything that protects against underflow in that
> calculation. pg_off can easily be arbitrarily small (eg zero), so that
> subtraction can underflow afaik.

Sorry, the calculations here are really confusing. The reason is that 
when DRGN read /proc/kcore for ELF file header:
phdr->p_offset = kc_vaddr_to_offset(m->addr) + data_offset;
and DRGN call mmap, use phdr->p_offset passed in, I need to subtract 
"data_offset".

> 
> So that needs a test, and return -EINVAL or whatever.
>
There's a problem with not judging "start". I will fix it in a v3.

> But even if that is fixed, this test is entirely broken:
> 
>> +       list_for_each_entry(m, &kclist_head, list) {
>> +               if (start >= m->addr && size <= m->size)
>> +                       break;
>> +       }
> 
> No, that's wrong.
> 

Yes, this is indeed wrong, I will fix it in a v3.


> You allow 'size' to be as big as 'm->size', but you do that even if
> 'start' isn't 'm->start'.
> 
> The proper check would be something like
> 
>         u64 end = start + size;
> 
>          if (start >= m->addr && end <= m->addr+m->size) ..
> 
> or similar (and that should check that "start+size" hasn't overflowed).
> 
> So I see what appears to be multiple problems, and while I hand-waved
> some fixes for them, those are very much "maybe something like this",
> and I'm going to drop this patch. Not for 5.14.
> 
>             Linus
> 
