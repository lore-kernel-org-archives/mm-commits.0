Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 777ECC46467
	for <mm-commits@archiver.kernel.org>; Tue, 10 Jan 2023 11:57:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238193AbjAJL5w (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 10 Jan 2023 06:57:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46662 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238112AbjAJL5c (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 10 Jan 2023 06:57:32 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C471E18B09
        for <mm-commits@vger.kernel.org>; Tue, 10 Jan 2023 03:56:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1673351806;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=16NrkXmZquJIVFF3AD+QUr0mEpSVSeHJSxaI1SXJxFQ=;
        b=FfFxIk2j3mTOqhGYqoyY5tQ4vQ3DqnYN/5PHlffoVpA5a34yI55QqlqsVtjAQOSILGvqG6
        uHT9CsizPbuAuwOEUk0nmR65hHnPp4Y7H4Nb5RsAwecO+pioX7PR3Ik3jg8EguFIYMPiC0
        IbLZEWmJdQH0uzOKa9Tp5gYxfDNvHkM=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-526-yVsvRFY9PIOzeNKMV7IWQA-1; Tue, 10 Jan 2023 06:56:45 -0500
X-MC-Unique: yVsvRFY9PIOzeNKMV7IWQA-1
Received: by mail-wr1-f69.google.com with SMTP id o14-20020adfa10e000000b002631c56fe26so1882071wro.1
        for <mm-commits@vger.kernel.org>; Tue, 10 Jan 2023 03:56:45 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:organization:from:references
         :to:content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=16NrkXmZquJIVFF3AD+QUr0mEpSVSeHJSxaI1SXJxFQ=;
        b=3xvDjQEnhl4ulwcOeCqmdd68IA2NjWom+WVXJ6i7URgiPx1XKzIfU3gttMZ3JGGCFY
         QdFv18i+IBsxc43AWh+79CCEJQgBeHYpvucgN2YFJN+dp0Wk37UefqwhFu9WDcsPO7+M
         SqkLTW+VOmdDSbGoDQfc/+CI+0oL02oLzhAGOPNiKdj6QluuzkYdh289fDgy+cJ7yi6P
         O1kj3xGpz7NkP7iqsl4N/cdlrts7uUMY1MWjrU4Edf/DUGdb2Jhir4aJ6fsR+lrWmC7p
         ykvdcOnc5jkFZ9Vi+BscNhzH9FLAKCkBGju4/pBQuXqMn6L2nGV2EBtKPZJIZa/S7nlB
         09Zg==
X-Gm-Message-State: AFqh2kpXEbLhM9IZw8KoH0YFYqwfVJvmhX71o+oNCm9tqFGM+0OBowlk
        Cuo07Wy1jUjhZcItxMUYlYkxDL3tg677jTKkC/YEjy7/FTNkzLKXB7J28xPogeYbN4H5Ch/f/4J
        KJgXxdY4aWR/xmJbN8RynrA==
X-Received: by 2002:a05:600c:1c97:b0:3d2:274d:be7c with SMTP id k23-20020a05600c1c9700b003d2274dbe7cmr50171662wms.19.1673351804408;
        Tue, 10 Jan 2023 03:56:44 -0800 (PST)
X-Google-Smtp-Source: AMrXdXte1vdDSfDXDsxcT4oKYLovkWEbw5zqtF8LDeIzEBDXlfX4/s+Mz+8XBpFxkC6Tomt9klgnFg==
X-Received: by 2002:a05:600c:1c97:b0:3d2:274d:be7c with SMTP id k23-20020a05600c1c9700b003d2274dbe7cmr50171651wms.19.1673351804108;
        Tue, 10 Jan 2023 03:56:44 -0800 (PST)
Received: from ?IPV6:2003:cb:c708:4200:65d9:4d0d:bb61:14c8? (p200300cbc708420065d94d0dbb6114c8.dip0.t-ipconnect.de. [2003:cb:c708:4200:65d9:4d0d:bb61:14c8])
        by smtp.gmail.com with ESMTPSA id f8-20020a0560001b0800b002423edd7e50sm10953892wrz.32.2023.01.10.03.56.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 10 Jan 2023 03:56:43 -0800 (PST)
Message-ID: <738e358a-5ef0-0981-ba02-8a25367b9bc9@redhat.com>
Date:   Tue, 10 Jan 2023 12:56:42 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.0
Subject: Re: +
 selftests-mm-define-madv_pageout-to-fix-compilation-issues.patch added to
 mm-unstable branch
Content-Language: en-US
To:     Mirsad Todorovac <mirsad.todorovac@alu.unizg.hr>,
        Andrew Morton <akpm@linux-foundation.org>,
        mm-commits@vger.kernel.org, shuah@kernel.org
References: <20230109233601.C4082C433EF@smtp.kernel.org>
 <cb32e13b-2edd-8a4d-dfc1-779d03a1ff67@alu.unizg.hr>
 <5c273641-1a06-f595-59d7-b338f2183953@redhat.com>
 <edb402df-c0df-00d7-3bf4-884c5ba47ca9@alu.unizg.hr>
From:   David Hildenbrand <david@redhat.com>
Organization: Red Hat
In-Reply-To: <edb402df-c0df-00d7-3bf4-884c5ba47ca9@alu.unizg.hr>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

On 10.01.23 12:52, Mirsad Todorovac wrote:
> 
> 
> On 1/10/23 12:18, David Hildenbrand wrote:
>> On 10.01.23 12:00, Mirsad Todorovac wrote:
>>> Hi,
>>>
>>> On 1/10/23 00:36, Andrew Morton wrote:
>>>> The patch titled
>>>>         Subject: selftests/mm: define MADV_PAGEOUT to fix compilation
>>>> issues
>>>> has been added to the -mm mm-unstable branch.  Its filename is
>>>>         selftests-mm-define-madv_pageout-to-fix-compilation-issues.patch
>>>>
>>>> This patch will shortly appear at
>>>>         
>>>> https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-mm-define-madv_pageout-to-fix-compilation-issues.patch
>>>>
>>>> This patch will later appear in the mm-unstable branch at
>>>>        git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
>>>>
>>>> Before you just go and hit "reply", please:
>>>>       a) Consider who else should be cc'ed
>>>>       b) Prefer to cc a suitable mailing list as well
>>>>       c) Ideally: find the original patch on the mailing list and do a
>>>>          reply-to-all to that, adding suitable additional cc's
>>>>
>>>> *** Remember to use Documentation/process/submit-checklist.rst when
>>>> testing your code ***
>>>>
>>>> The -mm tree is included into linux-next via the mm-everything
>>>> branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
>>>> and is updated there every 2-3 working days
>>>>
>>>> ------------------------------------------------------
>>>> From: David Hildenbrand <david@redhat.com>
>>>> Subject: selftests/mm: define MADV_PAGEOUT to fix compilation issues
>>>> Date: Mon, 9 Jan 2023 18:12:55 +0100
>>>>
>>>> If MADV_PAGEOUT is not defined (e.g., on AlmaLinux 8), compilation will
>>>> fail.  Let's fix that like khugepaged.c does by conditionally defining
>>>> MADV_PAGEOUT.
>>>>
>>>> Link: https://lkml.kernel.org/r/20230109171255.488749-1-david@redhat.com
>>>> Fixes: 69c66add5663 ("selftests/vm: anon_cow: test COW handling of
>>>> anonymous memory")
>>>> Signed-off-by: David Hildenbrand <david@redhat.com>
>>>> Reported-by: Mirsad Goran Todorovac <mirsad.todorovac@alu.unizg.hr>
>>>> Cc: Shuah Khan <shuah@kernel.org>
>>>> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
>>>> ---
>>>>
>>>>     tools/testing/selftests/mm/cow.c |    3 +++
>>>>     1 file changed, 3 insertions(+)
>>>>
>>>> ---
>>>> a/tools/testing/selftests/mm/cow.c~selftests-mm-define-madv_pageout-to-fix-compilation-issues
>>>> +++ a/tools/testing/selftests/mm/cow.c
>>>> @@ -30,6 +30,9 @@
>>>>     #include "../kselftest.h"
>>>>     #include "vm_util.h"
>>>> +#ifndef MADV_PAGEOUT
>>>> +#define MADV_PAGEOUT 21
>>>> +#endif
>>>>     #ifndef MADV_COLLAPSE
>>>>     #define MADV_COLLAPSE 25
>>>>     #endif
>>>> _
>>>>
>>>> Patches currently in -mm which might be from david@redhat.com are
>>>>
>>>> mm-hugetlb-fix-pte-marker-handling-in-hugetlb_change_protection.patch
>>>> mm-hugetlb-fix-uffd-wp-handling-for-migration-entries-in-hugetlb_change_protection.patch
>>>> mm-userfaultfd-enable-writenotify-while-userfaultfd-wp-is-enabled-for-a-vma.patch
>>>> mm-userfaultfd-rely-on-vma-vm_page_prot-in-uffd_wp_range.patch
>>>> mm-userfaultfd-rely-on-vma-vm_page_prot-in-uffd_wp_range-fix.patch
>>>> mm-mprotect-drop-pgprot_t-parameter-from-change_protection.patch
>>>> mm-mprotect-drop-pgprot_t-parameter-from-change_protection-fix.patch
>>>> selftests-vm-cow-add-cow-tests-for-collapsing-of-pte-mapped-anon-thp.patch
>>>> mm-nommu-factor-out-check-for-nommu-shared-mappings-into-is_nommu_shared_mapping.patch
>>>> mm-nommu-dont-use-vm_mayshare-for-map_private-mappings.patch
>>>> drivers-misc-open-dice-dont-touch-vm_mayshare.patch
>>>> selftests-mm-define-madv_pageout-to-fix-compilation-issues.patch
>>> Please consider alternative patch instead. I am submitting it for a
>>> review.
>>>
>>> It would give the referential integrity to the source of the selftest/vm
>>> subtree.
>>>
>>> #ifdef ... #endif encapsulation around `#define __USE_GNU` eliminates a
>>> warning.
>>>
>>> RATIONALE:
>>>
>>> Though it is ulikely that the values of MADV_PAGEOUT,
>>> MADV_POPULATE_READ and MADV_COLLAPSE will change, the source integrity
>>> would benefit from having it changed in only one place,
>>> .../usr/include/asm-generic/mman-common.h, included by >
>>> #include <linux/mman.h>
>>
>> Would that imply that we're taking the in-tree sources and not the
>> installed kernel headers?
>>
>> Because compilation would fail if the installed kernel headers don't
>> define these.
> 
> It seems that userfaultfd.c already included <linux/mman.h>,
> so nothing is lost or gained in compilation successes, except that
> things look more uniform, coherent and consistent?
> 

I included it in tools/testing/selftests/mm/madv_populate.c as well BUT that was
not sufficient to make it compile in all environments.

commit d88825f22b8f1cad8acb429b6bf0a54c85d7b93f
Author: David Hildenbrand <david@redhat.com>
Date:   Mon Dec 5 20:37:14 2022 +0100

     selftests/vm: madv_populate: fix missing MADV_POPULATE_(READ|WRITE) definitions
     
     The tests fail to compile in some environments (e.g., Debian 11.5 on x86).
     Let's simply conditionally define MADV_POPULATE_(READ|WRITE) if not
     already defined, similar to how the khugepaged.c test handles it.
     
     Link: https://lkml.kernel.org/r/20221205193716.276024-3-david@redhat.com
     Fixes: 39b2e5cae43d ("selftests/vm: make MADV_POPULATE_(READ|WRITE) use in-tree headers")
     Signed-off-by: David Hildenbrand <david@redhat.com>
     Cc: Shuah Khan <shuah@kernel.org>
     Cc: Yang Li <yang.lee@linux.alibaba.com>
     Signed-off-by: Andrew Morton <akpm@linux-foundation.org>


-- 
Thanks,

David / dhildenb

