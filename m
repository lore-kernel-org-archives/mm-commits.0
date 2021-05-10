Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.1 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 54C89C433B4
	for <mm-commits@archiver.kernel.org>; Mon, 10 May 2021 12:27:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1EB6561466
	for <mm-commits@archiver.kernel.org>; Mon, 10 May 2021 12:27:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236048AbhEJM1w (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 10 May 2021 08:27:52 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:49124 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S243950AbhEJL5t (ORCPT
        <rfc822;mm-commits@vger.kernel.org>);
        Mon, 10 May 2021 07:57:49 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1620647804;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=+TnsE47tQgI8UnY5HPZ8So4cPyew1ZrQDuNwjYAv8VE=;
        b=OKYgbTSR8BStiVZftKc9U+1UgtoWHoKDU5+/KNa6AgSvayJzBnBLV/aGdH4xtiUf2JQHD2
        7xBGkz354Q6nMI5OwMhi8tY+X6B6TY3bGoAQEi96h+QI0zrOZs0dNGOd8Q8X1vla/XDMWc
        f55MkxUKvJ1KY7lhlN9RXK6i4R/Twfc=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-48-oysdJ2M4OgW2qe3bpgk0wg-1; Mon, 10 May 2021 07:56:43 -0400
X-MC-Unique: oysdJ2M4OgW2qe3bpgk0wg-1
Received: by mail-wr1-f71.google.com with SMTP id 67-20020adf81490000b029010756d109e6so7326416wrm.13
        for <mm-commits@vger.kernel.org>; Mon, 10 May 2021 04:56:42 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:references:from:organization:subject
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=+TnsE47tQgI8UnY5HPZ8So4cPyew1ZrQDuNwjYAv8VE=;
        b=kp3kZaY73k4fealdZMZvluYOe+Zn5sxlhZ+omdvW+Z8Amc5Q8qsWF9PjRzmbgPg1ew
         1deAeryz8OaHOmiIsd5+4TY3EQ7kj3PA/ELCeK6/tABR9U4SyEleUAFovvRHaGxCsJ+Z
         H8cuGKetBuAphLSqiejricXJT5XO2wRgVSQuaLKcZcrH6TUAGu/uTPYTbrTB3wmfdYon
         9IEeizn+MPsrt44PJ83T4e1HjcloPPouQu2efQclrwc250u8949H77e+5eT7U/0mzHX+
         cAD6GI+dIlOcALeXs/QmJeBI24o6irVIMQB/0HbAMO7gHqKhTtXGGztD5bW72VEYor5F
         mSCg==
X-Gm-Message-State: AOAM530YO9tKlBafdEZdDexB0pcKTvV9+qGhUtPvcQkp+5xMLHpm8ejs
        r2fLmTUYTx3fDlJObKsbNDU2HKUZFdYEYerhDYYKtDKRE07tAYou1/po75+WnHHr8rpoZlxyxPF
        9YGWyeNXHnwkNJHyOOZMl2w==
X-Received: by 2002:adf:a316:: with SMTP id c22mr29518531wrb.202.1620647801825;
        Mon, 10 May 2021 04:56:41 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJy+8JpuCb9hMj/upFOdeDKXm66jiAhm2ymsmvNuLP4E4sFgnjgVnI//x4VHlU+WOjAr/jYtAw==
X-Received: by 2002:adf:a316:: with SMTP id c22mr29518491wrb.202.1620647801613;
        Mon, 10 May 2021 04:56:41 -0700 (PDT)
Received: from [192.168.3.132] (p5b0c676a.dip0.t-ipconnect.de. [91.12.103.106])
        by smtp.gmail.com with ESMTPSA id t7sm22194194wrw.60.2021.05.10.04.56.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 10 May 2021 04:56:41 -0700 (PDT)
To:     Dave Young <dyoung@redhat.com>
Cc:     Baoquan He <bhe@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        andreyknvl@google.com, christian.brauner@ubuntu.com,
        colin.king@canonical.com, corbet@lwn.net, frederic@kernel.org,
        gpiccoli@canonical.com, john.p.donnelly@oracle.com,
        jpoimboe@redhat.com, keescook@chromium.org, linux-mm@kvack.org,
        masahiroy@kernel.org, mchehab+huawei@kernel.org,
        mike.kravetz@oracle.com, mingo@kernel.org,
        mm-commits@vger.kernel.org, paulmck@kernel.org,
        peterz@infradead.org, rdunlap@infradead.org, rostedt@goodmis.org,
        rppt@kernel.org, saeed.mirzamohammadi@oracle.com,
        samitolvanen@google.com, sboyd@kernel.org, tglx@linutronix.de,
        torvalds@linux-foundation.org, vgoyal@redhat.com,
        yifeifz2@illinois.edu, Michal Hocko <mhocko@kernel.org>
References: <20210507010432.IN24PudKT%akpm@linux-foundation.org>
 <889c6b90-7335-71ce-c955-3596e6ac7c5a@redhat.com>
 <20210508085133.GA2946@localhost.localdomain>
 <2d0f53d9-51ca-da57-95a3-583dc81f35ef@redhat.com>
 <20210510045338.GB2946@localhost.localdomain>
 <4a544493-0622-ac6d-f14b-fb338e33b25e@redhat.com>
 <20210510104359.GC2946@localhost.localdomain>
 <e9332e4e-57bd-9c7c-b3ba-7e3b29fad7c8@redhat.com>
 <YJkcsswrgAudo2vz@dhcp-128-65.nay.redhat.com>
From:   David Hildenbrand <david@redhat.com>
Organization: Red Hat
Subject: Re: [patch 48/91] kernel/crash_core: add crashkernel=auto for vmcore
 creation
Message-ID: <b111806c-9103-3f77-7135-f1f773d23b80@redhat.com>
Date:   Mon, 10 May 2021 13:56:39 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <YJkcsswrgAudo2vz@dhcp-128-65.nay.redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

On 10.05.21 13:44, Dave Young wrote:
> Hi David,

Hi Dave,

> On 05/10/21 at 01:01pm, David Hildenbrand wrote:
> [snip]
>> It also bugged me for quite a bit that we don't have a sane way to achieve
>> what we're doing here upstream. It somewhat feels like "this doesn't belong
>> in the kernel and is user policy" but then, the existing kernel support is
>> suboptimal.
>>
>> Maybe reserving some "maybe too big but okayish to boot the system in a sane
>> environment -- e.g., X% of system RAM and at least Y" size first and
>> shrinking it later as triggered by user space early (where we do seem to
>> have a way to pre-calculate things now) might actually be a good direction
>> to look into.
> 
> Hmm, that is also an option we considered before.  Even for your
> suggestion we still need a kernel option to set the default ratio/value.
> and the ratio/value should be another patch which expands crashkernel
> syntax.

Right.

> 
> Actually the kconfig help text in this patch is indeed misleading, it is
> not introducing crashkernel=a:b... and no need to explain about the
> crashkernel syntax, the config option is actually just some interface we
> can add any valid crashkernel settings to be used by default. So current
> patch help text describes the default value of crash auto str, instead
> of describes what crash auto str is.

Right. And I would much rather prefer either

a) handling "auto" completely in the kernel, not just setting some 
questionable default at compile time
b) passing it explicitly in via the cmdline

> 
> And crashkernel=auto makes this more flexibly. We can tune the values
> easily when upgrading.  But if we pass a fixed value in userspace we
> can not know if the value is set by distribution automatically or by user
> manually thus we can not blindly update it.

I think there are two different cases:


1. kernel space updates the value later during boot. "crashkernel=auto" 
really does the right thing, meaning

a) allocate something reasonable and safe during early boot
b) update the allocation during late boot when we know what kind of 
system we're running on

Then, we indeed care about "crashkernel=auto" in the kernel and I think 
it would be a nice thing to have. The only question is on how to make 
that a little configurable, depending on different thingies we might 
want to run in the crashkernel (assuming someone doesn't want kdump).


2. user space updates the value later during boot

IMHO we don't really car who decided on the value as we do the update 
from user space. If an admin messes with crashkernel=, the admin can 
also mess with kdump not doing any overwrites (e.g., make that 
configurable, or detect the overwrite in kdump somehow).

-- 
Thanks,

David / dhildenb

