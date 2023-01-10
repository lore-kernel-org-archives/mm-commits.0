Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B6956C54EBC
	for <mm-commits@archiver.kernel.org>; Tue, 10 Jan 2023 11:19:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231149AbjAJLTT (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 10 Jan 2023 06:19:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58186 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238376AbjAJLSq (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 10 Jan 2023 06:18:46 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7AC342BC6
        for <mm-commits@vger.kernel.org>; Tue, 10 Jan 2023 03:18:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1673349486;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=1Iu8UZRo8lDh6iqSfhTox2lHP7+gNdJpDz92cqMggZE=;
        b=FHJOL2/rHbBaym+kiUl+p0NJomoveVEGcTwDuZpto8+XK18/jwTjQYQWRoarlf4ZmCYvNM
        NVWzx+TyleyNYHQKNWb0bpbaX54ZnCQnb4T4Nb2moMqUE7bGdS3frbgpvFlflEQDHFJ+y2
        7GeE2ZeSccheiMGqS4ttzxq6RTaGJlU=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-150-i3UhuCpAPpaLQ567yUDhDA-1; Tue, 10 Jan 2023 06:18:05 -0500
X-MC-Unique: i3UhuCpAPpaLQ567yUDhDA-1
Received: by mail-wm1-f70.google.com with SMTP id a6-20020a05600c224600b003d1f3ed49adso2433807wmm.4
        for <mm-commits@vger.kernel.org>; Tue, 10 Jan 2023 03:18:05 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:organization:from:references
         :to:content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=1Iu8UZRo8lDh6iqSfhTox2lHP7+gNdJpDz92cqMggZE=;
        b=go/VKMviflRaFFokhHsuAaBi7up3Dq/rEVoc6pE9C7rmPPaRnhbryRMFTYUCZ2z7kQ
         cF7lh1DwApoMBsMBLIlILpLYF7OD93c5K8XcapIE5kE1XInBXS8fy/acFAc78+o6hB7b
         M8UW6oC/xvk55PDalTnpSGkts1cgj+ZwsPHnlKFNJF6PvLdmCwGJcLashQK7EC/6tRl7
         KPY+q1+tcLyAgprz25lxBY45CgEq821Ei8LZRT17gOg6+LlLYpOoGHRpF+FAXN31hOKI
         6B1YkhkCHE2y1F9YtgWBDU/8vmDVS5ioW/EasJYFkybw3iyhU5w3fZ9/lePMx6m3RoRT
         KkVg==
X-Gm-Message-State: AFqh2krTENMEF8912cySmeWjGFpB/maju73Vys5gGFdGTvqa8QltpuLU
        MnGGgVMvvUkbwiFVJAdX3WkGikp0VuVbaqbcUXwui8YbPrBIvlTp+fXTO1akeC4iKaIlWRSlb/j
        jMwXb7YQ5xz8bikflxhJ/SQ==
X-Received: by 2002:a05:6000:228:b0:2bb:e8f2:5d2e with SMTP id l8-20020a056000022800b002bbe8f25d2emr5346186wrz.51.1673349484366;
        Tue, 10 Jan 2023 03:18:04 -0800 (PST)
X-Google-Smtp-Source: AMrXdXuycvzbk4YD4isFdA5fwsFHR2+llwXx4Lpm5DVRgycPL8KHikQGgD/1XStthyb4VdSYkQes8A==
X-Received: by 2002:a05:6000:228:b0:2bb:e8f2:5d2e with SMTP id l8-20020a056000022800b002bbe8f25d2emr5346163wrz.51.1673349484015;
        Tue, 10 Jan 2023 03:18:04 -0800 (PST)
Received: from ?IPV6:2003:cb:c708:4200:65d9:4d0d:bb61:14c8? (p200300cbc708420065d94d0dbb6114c8.dip0.t-ipconnect.de. [2003:cb:c708:4200:65d9:4d0d:bb61:14c8])
        by smtp.gmail.com with ESMTPSA id m13-20020adfe94d000000b002714b3d2348sm10939864wrn.25.2023.01.10.03.18.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 10 Jan 2023 03:18:03 -0800 (PST)
Message-ID: <5c273641-1a06-f595-59d7-b338f2183953@redhat.com>
Date:   Tue, 10 Jan 2023 12:18:02 +0100
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
From:   David Hildenbrand <david@redhat.com>
Organization: Red Hat
In-Reply-To: <cb32e13b-2edd-8a4d-dfc1-779d03a1ff67@alu.unizg.hr>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

On 10.01.23 12:00, Mirsad Todorovac wrote:
> Hi,
> 
> On 1/10/23 00:36, Andrew Morton wrote:
>> The patch titled
>>        Subject: selftests/mm: define MADV_PAGEOUT to fix compilation issues
>> has been added to the -mm mm-unstable branch.  Its filename is
>>        selftests-mm-define-madv_pageout-to-fix-compilation-issues.patch
>>
>> This patch will shortly appear at
>>        https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-mm-define-madv_pageout-to-fix-compilation-issues.patch
>>
>> This patch will later appear in the mm-unstable branch at
>>       git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
>>
>> Before you just go and hit "reply", please:
>>      a) Consider who else should be cc'ed
>>      b) Prefer to cc a suitable mailing list as well
>>      c) Ideally: find the original patch on the mailing list and do a
>>         reply-to-all to that, adding suitable additional cc's
>>
>> *** Remember to use Documentation/process/submit-checklist.rst when testing your code ***
>>
>> The -mm tree is included into linux-next via the mm-everything
>> branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
>> and is updated there every 2-3 working days
>>
>> ------------------------------------------------------
>> From: David Hildenbrand <david@redhat.com>
>> Subject: selftests/mm: define MADV_PAGEOUT to fix compilation issues
>> Date: Mon, 9 Jan 2023 18:12:55 +0100
>>
>> If MADV_PAGEOUT is not defined (e.g., on AlmaLinux 8), compilation will
>> fail.  Let's fix that like khugepaged.c does by conditionally defining
>> MADV_PAGEOUT.
>>
>> Link: https://lkml.kernel.org/r/20230109171255.488749-1-david@redhat.com
>> Fixes: 69c66add5663 ("selftests/vm: anon_cow: test COW handling of anonymous memory")
>> Signed-off-by: David Hildenbrand <david@redhat.com>
>> Reported-by: Mirsad Goran Todorovac <mirsad.todorovac@alu.unizg.hr>
>> Cc: Shuah Khan <shuah@kernel.org>
>> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
>> ---
>>
>>    tools/testing/selftests/mm/cow.c |    3 +++
>>    1 file changed, 3 insertions(+)
>>
>> --- a/tools/testing/selftests/mm/cow.c~selftests-mm-define-madv_pageout-to-fix-compilation-issues
>> +++ a/tools/testing/selftests/mm/cow.c
>> @@ -30,6 +30,9 @@
>>    #include "../kselftest.h"
>>    #include "vm_util.h"
>>    
>> +#ifndef MADV_PAGEOUT
>> +#define MADV_PAGEOUT 21
>> +#endif
>>    #ifndef MADV_COLLAPSE
>>    #define MADV_COLLAPSE 25
>>    #endif
>> _
>>
>> Patches currently in -mm which might be from david@redhat.com are
>>
>> mm-hugetlb-fix-pte-marker-handling-in-hugetlb_change_protection.patch
>> mm-hugetlb-fix-uffd-wp-handling-for-migration-entries-in-hugetlb_change_protection.patch
>> mm-userfaultfd-enable-writenotify-while-userfaultfd-wp-is-enabled-for-a-vma.patch
>> mm-userfaultfd-rely-on-vma-vm_page_prot-in-uffd_wp_range.patch
>> mm-userfaultfd-rely-on-vma-vm_page_prot-in-uffd_wp_range-fix.patch
>> mm-mprotect-drop-pgprot_t-parameter-from-change_protection.patch
>> mm-mprotect-drop-pgprot_t-parameter-from-change_protection-fix.patch
>> selftests-vm-cow-add-cow-tests-for-collapsing-of-pte-mapped-anon-thp.patch
>> mm-nommu-factor-out-check-for-nommu-shared-mappings-into-is_nommu_shared_mapping.patch
>> mm-nommu-dont-use-vm_mayshare-for-map_private-mappings.patch
>> drivers-misc-open-dice-dont-touch-vm_mayshare.patch
>> selftests-mm-define-madv_pageout-to-fix-compilation-issues.patch
> Please consider alternative patch instead. I am submitting it for a
> review.
> 
> It would give the referential integrity to the source of the selftest/vm
> subtree.
> 
> #ifdef ... #endif encapsulation around `#define __USE_GNU` eliminates a
> warning.
> 
> RATIONALE:
> 
> Though it is ulikely that the values of MADV_PAGEOUT,
> MADV_POPULATE_READ and MADV_COLLAPSE will change, the source integrity
> would benefit from having it changed in only one place,
> .../usr/include/asm-generic/mman-common.h, included by >
> #include <linux/mman.h>

Would that imply that we're taking the in-tree sources and not the 
installed kernel headers?

Because compilation would fail if the installed kernel headers don't 
define these.

-- 
Thanks,

David / dhildenb

