Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.4 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 42F8CC433EF
	for <mm-commits@archiver.kernel.org>; Fri, 10 Sep 2021 12:02:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 25623611BF
	for <mm-commits@archiver.kernel.org>; Fri, 10 Sep 2021 12:02:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233000AbhIJMDs (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 10 Sep 2021 08:03:48 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:39267 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232873AbhIJMDr (ORCPT
        <rfc822;mm-commits@vger.kernel.org>);
        Fri, 10 Sep 2021 08:03:47 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1631275356;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=iWvPmFJHWrTlqeQKg0WJIhQRDa/OXRfQkCvoOjfDvyU=;
        b=FqjZyVbxUC5BJ9hl8MF4a3xquLchYpoAYn31Cahfhzmia9DG9+9CNLA8hgpdcCdADF3SWt
        GCr7tPCFcLIQs4Kq9Sn3VogPSaEUdYUvUtpE1OCbnbKoJR63PhJYOgTzoXcIUGFsrvkSly
        2ohY7u9hQfqUwR3pYrpTeBRbBvzZU0c=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-467-R7t_I2Z3O_K3AnREBEU_qw-1; Fri, 10 Sep 2021 08:02:35 -0400
X-MC-Unique: R7t_I2Z3O_K3AnREBEU_qw-1
Received: by mail-wm1-f72.google.com with SMTP id a144-20020a1c7f96000000b002fee1aceb6dso733441wmd.0
        for <mm-commits@vger.kernel.org>; Fri, 10 Sep 2021 05:02:35 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:organization
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=iWvPmFJHWrTlqeQKg0WJIhQRDa/OXRfQkCvoOjfDvyU=;
        b=6+SY18BvwIwtGHp2nXkRyutAPXlA5ioCC04ghzXVBqhKIDH5//QHyGnrBnx9e45d5c
         MnByzQI+8J7q1spzL9sqL9WIXNlLOwGk/mf5+3jsF4zFne17IrEDefFtXlcDObMvDQ3w
         MGDLhgIxnGW9IPcrVzY4jGl8qaeo3EJMmD4oV8fk5zRehRXtrmT9SzJfvDSSa5/n9I+l
         aKQw2+L8A1JvsTqrQoFLgI+0zt3MeJxJVjN4tKDCbesfE4KUdkRR2BxJ6tvhNgjTuN2K
         9vUhHKzPcxSewHR/YOgV9A9+cVvPt+1A0/m3VITf1NnTQ0wnsi2S5u8AueNfzBseaNWs
         KaXg==
X-Gm-Message-State: AOAM5333THb8NDpBi0L8xrrWMRlD9Eicu0SkmW+pfioWYPg0BQw4WKDb
        B9rnD6q2q6yZTqxPlTXBDUnHkISzzWltOTRrkosh7zIB5ZVqUi+mXNSj2iWD9x5Hm4pKoqeKmSY
        8OjQr22eMtZW9wMVfV8S18A==
X-Received: by 2002:a05:6000:22d:: with SMTP id l13mr9271501wrz.410.1631275354067;
        Fri, 10 Sep 2021 05:02:34 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzd3qcB6kC9qWP9tPtuHubmv7UT+qXoQljya60b6zYbxh0B1+EDeOuZj9otYChgIELZe0IRyA==
X-Received: by 2002:a05:6000:22d:: with SMTP id l13mr9271461wrz.410.1631275353843;
        Fri, 10 Sep 2021 05:02:33 -0700 (PDT)
Received: from [192.168.3.132] (p5b0c600c.dip0.t-ipconnect.de. [91.12.96.12])
        by smtp.gmail.com with ESMTPSA id x21sm4078642wmi.15.2021.09.10.05.02.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 10 Sep 2021 05:02:33 -0700 (PDT)
Subject: Re: [patch 079/147] fs/proc/kcore.c: add mmap interface
To:     Mike Rapoport <rppt@kernel.org>
Cc:     Andrew Morton <akpm@linux-foundation.org>, adobriyan@gmail.com,
        chenying.kernel@bytedance.com, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, songmuchun@bytedance.com,
        torvalds@linux-foundation.org, zhouchengming@bytedance.com,
        zhoufeng.zf@bytedance.com
References: <20210908025730.S88ylmikU%akpm@linux-foundation.org>
 <303e9a27-7495-1c94-64a1-a1149a39f0a9@redhat.com>
 <YTtIxZA3Arv6G93V@kernel.org>
From:   David Hildenbrand <david@redhat.com>
Organization: Red Hat
Message-ID: <1c028f97-fbf2-acf8-9b7f-be0449246aab@redhat.com>
Date:   Fri, 10 Sep 2021 14:02:32 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <YTtIxZA3Arv6G93V@kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

On 10.09.21 14:00, Mike Rapoport wrote:
> On Fri, Sep 10, 2021 at 12:08:17PM +0200, David Hildenbrand wrote:
>> On 08.09.21 04:57, Andrew Morton wrote:
>>> +
>>> +	if (vma->vm_flags & (VM_WRITE | VM_EXEC)) {
>>> +		ret = -EPERM;
>>> +		goto out;
>>> +	}
>>> +
>>> +	vma->vm_flags &= ~(VM_MAYWRITE | VM_MAYEXEC);
>>> +	vma->vm_flags |= VM_MIXEDMAP;
>>> +	vma->vm_ops = &kcore_mmap_ops;
>>> +
>>
>> This breaks all my efforts to sanitize /proc/kore access for virtio-mem.
>>
>> Is there still a way to nack this?
> 
> Already done:
> 
> https://lore.kernel.org/mm-commits/CAHk-=wgQ+8kmczLLKCY7yDsGHQBRcZESKd1dNaKbrjUgbWeb3A@mail.gmail.com
> 
> and down the same thread.
>   

Yeah, spotted Linus' reply just after I sent my reply.

... afterwards I thought about the implications fpr secretmem and 
ordinary memory hotunplug and was happy that we dodged this bullet. :)

-- 
Thanks,

David / dhildenb

