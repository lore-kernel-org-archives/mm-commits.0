Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 792C8C54EBC
	for <mm-commits@archiver.kernel.org>; Tue, 10 Jan 2023 14:05:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233897AbjAJOFo (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 10 Jan 2023 09:05:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57326 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233915AbjAJOFU (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 10 Jan 2023 09:05:20 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D932F50E58
        for <mm-commits@vger.kernel.org>; Tue, 10 Jan 2023 06:04:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1673359469;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=WrEOo0Soikoa5U7+b0nVUYS2F1f/bIodcqmzBgjI+rE=;
        b=jKMZfu7lHNr68KxW4AEkAOV5p0wMtVVJYuZgYUxPwBsLSUNwpQbsXxHj4/vwMTYzt0GPxz
        s7QmV9jAsmzNDvs1nOHYj8Tpw9AzF6ShlMHXnACWPD1HwAMy7dNXQTKOC5j/x9WFR0djXF
        buXsKxAda2GTIxqpyuq+knzW8bTo2Zs=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-363-tGuR0hroMsaYZ1TU8sSFlw-1; Tue, 10 Jan 2023 09:04:27 -0500
X-MC-Unique: tGuR0hroMsaYZ1TU8sSFlw-1
Received: by mail-wm1-f70.google.com with SMTP id c7-20020a1c3507000000b003d355c13ba8so6339299wma.6
        for <mm-commits@vger.kernel.org>; Tue, 10 Jan 2023 06:04:27 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:subject:organization:from
         :references:to:content-language:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=WrEOo0Soikoa5U7+b0nVUYS2F1f/bIodcqmzBgjI+rE=;
        b=dJvW/WkiOZZAQJPRHQls5n3gikJGJy0phc56W7qV5gEK+GLIRXjZq4NaXGXWVo0Vfa
         hrq1FWb+2u6/BAzkr2tQDWo40YSftoS9QBVn364mawee+wc5Z5Fzo4wLhgqjAlVgnpBv
         PXXR0mBH9gw/VqDnITpg76bovPWLLegQHGoTSk8lg758o2naGiO3PJWCCEcw8boyr6nh
         EQTF6b6ZWVnIQmayzwXCUMFvCLvXlBB1DIVfB8PANIMKoe8VeOCxHZG5pPitoNgQ0UeL
         traSWlsEmADDiuTqBCWjcgUvl8vnCJHU3OkY5FLnY/q0uM0hqnfqfzh4OcdRNrzPgrDR
         rPYw==
X-Gm-Message-State: AFqh2kqLjV3WRg4qi4Xm5nGustW/XWvbN083sokRoCRUGff6KvnFrjn/
        UAyUXE13ANExmy79PfC6mwwav7m3m22czDJ8EtmOnhlHBeRxTO5/Wdrsgq03S2S38GibyRCfLi4
        xX+XsKZ2nsto3pme77bNRJA==
X-Received: by 2002:a05:600c:5113:b0:3d3:5c21:dd99 with SMTP id o19-20020a05600c511300b003d35c21dd99mr48925023wms.18.1673359465972;
        Tue, 10 Jan 2023 06:04:25 -0800 (PST)
X-Google-Smtp-Source: AMrXdXsnMWZgSi1d823C06peVWzAcBgcYdMzvUagmPBQFmEO6YE5bZNv01vvTgfkJoSmN0g5b6Wgzw==
X-Received: by 2002:a05:600c:5113:b0:3d3:5c21:dd99 with SMTP id o19-20020a05600c511300b003d35c21dd99mr48924988wms.18.1673359465584;
        Tue, 10 Jan 2023 06:04:25 -0800 (PST)
Received: from ?IPV6:2003:cb:c708:4200:65d9:4d0d:bb61:14c8? (p200300cbc708420065d94d0dbb6114c8.dip0.t-ipconnect.de. [2003:cb:c708:4200:65d9:4d0d:bb61:14c8])
        by smtp.gmail.com with ESMTPSA id r5-20020a05600c35c500b003d98f92692fsm16628860wmq.17.2023.01.10.06.04.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 10 Jan 2023 06:04:24 -0800 (PST)
Message-ID: <01dd090b-451f-f926-a6f3-1739f0ef688b@redhat.com>
Date:   Tue, 10 Jan 2023 15:04:23 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.0
Content-Language: en-US
To:     Mirsad Todorovac <mirsad.todorovac@alu.unizg.hr>,
        Andrew Morton <akpm@linux-foundation.org>,
        mm-commits@vger.kernel.org, shuah@kernel.org
References: <20230109233601.C4082C433EF@smtp.kernel.org>
 <cb32e13b-2edd-8a4d-dfc1-779d03a1ff67@alu.unizg.hr>
 <5c273641-1a06-f595-59d7-b338f2183953@redhat.com>
 <edb402df-c0df-00d7-3bf4-884c5ba47ca9@alu.unizg.hr>
 <738e358a-5ef0-0981-ba02-8a25367b9bc9@redhat.com>
 <ac38396d-51df-fff0-5b4c-3defea67dbe3@alu.unizg.hr>
From:   David Hildenbrand <david@redhat.com>
Organization: Red Hat
Subject: Re: +
 selftests-mm-define-madv_pageout-to-fix-compilation-issues.patch added to
 mm-unstable branch
In-Reply-To: <ac38396d-51df-fff0-5b4c-3defea67dbe3@alu.unizg.hr>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

>> I included it in tools/testing/selftests/mm/madv_populate.c as well BUT that was
>> not sufficient to make it compile in all environments.
> 
> Hi, David,
> 

Hi,

> It's unobvious why, for (as you can witness from the source)
> 
> #include <linux/mman.h> includes
> #include <asm/mman.h> includes
> #include <asm-generic/mman.h> which in turn includes
> #include <asm-generic/mman-common.h>
> 
> that defines all of the
> 
> #define MADV_PAGEOUT    21              /* reclaim these pages */
> #define MADV_POPULATE_READ      22      /* populate (prefault) page tables readable */
> #define MADV_POPULATE_WRITE     23      /* populate (prefault) page tables writable */
> 
> So, everything is within the in-tree includes, so I can't tell what went wrong.
> 
> I see that "#include <linux/magic.h>" is already used.
> 
> BTW, did userfaultfd.c compile on that Debian 11.5 environment?

I don't recall, unfortunately. I think yes, everything else compiled, 
but I might be wrong, as I focused on running some specific tests on 
sparc64 (below).

Maybe __NR_userfaultfd was missing completely and simply turned 
userfaultfd.c into a simple "skip".

> 
>> commit d88825f22b8f1cad8acb429b6bf0a54c85d7b93f
>> Author: David Hildenbrand <david@redhat.com>
>> Date:   Mon Dec 5 20:37:14 2022 +0100
>>
>>       selftests/vm: madv_populate: fix missing MADV_POPULATE_(READ|WRITE) definitions
>>       The tests fail to compile in some environments (e.g., Debian 11.5 on x86).
> 
> On Debian 11 on x86_64 I had no issues (just checked). (Your fix applied.)
> 
> Only MADV_PAGEOUT is defined in /usr/include:
> 
> mtodorov@magrf:~$ grep -E '(MADV_PAGEOUT|MADV_POPULATE_READ|MADV_POPULATE_WRITE)' -r /usr/include
> /usr/include/x86_64-linux-gnu/bits/mman-linux.h:# define MADV_PAGEOUT     21    /* Reclaim these pages.  */
> /usr/include/asm-generic/mman-common.h:#define MADV_PAGEOUT     21              /* reclaim these pages */
> mtodorov@magrf:~$
> 
> However, "memfd-secret.c" and "mlock-random-test.c" fail to include <sys/capability.h>
> despite being in both /usr/include/linux/capability.h and ../../../../usr/include/sys/capability.h:
> 
> mtodorov@magrf:~/linux/kernel/linux_torvalds/tools/testing/selftests/vm$ make -k
> gcc -Wall -I /home/admin/mtodorov/linux/kernel/linux_torvalds/tools/testing/selftests/../../.. -I
> /home/admin/mtodorov/linux/kernel/linux_torvalds/tools/testing/selftests/../../../usr/include  -isystem
> /home/admin/mtodorov/linux/kernel/linux_torvalds/tools/testing/selftests/../../../usr/include -no-pie     memfd_secret.c -lrt
> -lpthread -lcap -o /home/admin/mtodorov/linux/kernel/linux_torvalds/tools/testing/selftests/vm/memfd_secret
> memfd_secret.c:16:10: fatal error: sys/capability.h: No such file or directory
>      16 | #include <sys/capability.h>
>         |          ^~~~~~~~~~~~~~~~~~
> compilation terminated.
> make: *** [../lib.mk:145: /home/admin/mtodorov/linux/kernel/linux_torvalds/tools/testing/selftests/vm/migration] Error 1
> gcc -Wall -I /home/admin/mtodorov/linux/kernel/linux_torvalds/tools/testing/selftests/../../.. -I
> /home/admin/mtodorov/linux/kernel/linux_torvalds/tools/testing/selftests/../../../usr/include  -isystem
> /home/admin/mtodorov/linux/kernel/linux_torvalds/tools/testing/selftests/../../../usr/include -no-pie     mlock-random-test.c -lrt
> -lpthread -lcap -o /home/admin/mtodorov/linux/kernel/linux_torvalds/tools/testing/selftests/vm/mlock-random-test
> mlock-random-test.c:8:10: fatal error: sys/capability.h: No such file or directory
>       8 | #include <sys/capability.h>
>         |          ^~~~~~~~~~~~~~~~~~
> compilation terminated.
> 
> usr/include/linux/capability.h is existing, but the compiler somehow fails to find it:

And I think that's the root cause.

> 
> mtodorov@magrf:~/linux/kernel/linux_torvalds/tools/testing/selftests/vm$ grep sys/capability.h *.c
> memfd_secret.c:#include <sys/capability.h>
> mlock-random-test.c:#include <sys/capability.h>
> mtodorov@magrf:~/linux/kernel/linux_torvalds/tools/testing/selftests/vm$ find /usr/include -name capability.h
> /usr/include/linux/capability.h
> mtodorov@magrf:~/linux/kernel/linux_torvalds/tools/testing/selftests/vm$
> 
>>       Let's simply conditionally define MADV_POPULATE_(READ|WRITE) if not
>>       already defined, similar to how the khugepaged.c test handles it.
>>       Link: https://lkml.kernel.org/r/20221205193716.276024-3-david@redhat.com
>>       Fixes: 39b2e5cae43d ("selftests/vm: make MADV_POPULATE_(READ|WRITE) use in-tree headers")
>>       Signed-off-by: David Hildenbrand <david@redhat.com>
>>       Cc: Shuah Khan <shuah@kernel.org>
>>       Cc: Yang Li <yang.lee@linux.alibaba.com>
>>       Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> 
> IMHO, I don't have your experience and knowledge, but from the fresh perspective,
> kernel will bring in its own selftest suite all the defines in <linux/mman.h>
> that are supported in the particular version.
> 
> AFAIK, testing with different version of kernel is not recommended.

I recall that the following was my test setup: debian 11 is the last 
debian version one can possibly (with quite some effort) get running on 
sparc64 in QEMU. I installed a custom kernel to test some sparc64 
changes and also ran some selftests (including e.g., softdirty, 
madv_populate and cow). So I was running a kernel that matched the 
source tree, just the installed header files were outdated.

> 
> Of course, we can easily test with "gcc -E" what exactly gets included.
> 
> We don't seem to have a uniform way of handling MADV_PAGEOUT and
> MADV_POPULATE(READ|WRITE) even within different C sources within
> tools/testing/selftests/vm itself, so it means that we spread the spectrum
> of systems and compilations that we will break. :-/
> 
> To repeat what is obvious, I am not an authority on the Linux kernel,
> but as I said, I have the benefit of a fresh perspective ...
> 
> There was an open source proverb that "more eyes see more" :)

The thing is: I don't lose sleeps about defines that will never change 
as long as it compiles. That's the most important part (for me) with 
these tests. Even if it would change, and I don't see how, we'd get test 
failures and could fix it up.

... and I raised that I ran into issues with what you propose. That's 
really all I am saying :)

And to repeat what I said: If we can find a cleanup for all these 
relevant "ifndef" in selftests/mm I'd be very happy. As long as it 
compiles I'm all for cleanups. It would also be acceptable to say "what 
David tested was wrong" -- but that needs clear justification.

-- 
Thanks,

David / dhildenb

