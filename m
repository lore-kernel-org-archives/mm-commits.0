Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4AC10ECAAA1
	for <mm-commits@archiver.kernel.org>; Fri,  9 Sep 2022 16:43:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229548AbiIIQm6 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 9 Sep 2022 12:42:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54484 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229517AbiIIQm5 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 9 Sep 2022 12:42:57 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C2B0D1440AD
        for <mm-commits@vger.kernel.org>; Fri,  9 Sep 2022 09:42:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1662741776;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=wyWjKxkoCm05fJ9EbPtXRMxs66ZBgCbANHGvRWA+yqs=;
        b=W/jutXxOMQxS7cTY5/0hzhl74pYMhyyvFlSZDCSws3cGQW2jLRPGqWOPMmx7QMcDRxjVdw
        +pReWpbol75CN39lgaiNqOUPtaLFVeSkfDYsfrpnTCHzJ/el6yQhNo8mHa63kKRWMid0tE
        +QsJjpj20IpRiiikOnvZneQ7UO8qCDg=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-653-QhDdeH5nPP--_LdyWzZxRg-1; Fri, 09 Sep 2022 12:42:54 -0400
X-MC-Unique: QhDdeH5nPP--_LdyWzZxRg-1
Received: by mail-wm1-f70.google.com with SMTP id bg2-20020a05600c3c8200b003b33080cff8so1339874wmb.0
        for <mm-commits@vger.kernel.org>; Fri, 09 Sep 2022 09:42:54 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:subject:organization:from
         :references:cc:to:content-language:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date;
        bh=wyWjKxkoCm05fJ9EbPtXRMxs66ZBgCbANHGvRWA+yqs=;
        b=EqhQtACgbvA3vZw4xzJ4Px8odUO3BMbApGzI8ZJdz/aYUwwdfNit6SVSzPeB91WPDu
         WZqmLGOKizHRhvbVjU/IRkkqGk7+Hcf1sCr17gRF3Rx4SZZ7StwUVUsyg5lb1NJyCAmN
         Gc5XfD6f/UCX0tdqNg3Nkw9a35leHA4VL8WR9Wd4QB4dOh/o3J8KeC880akbxxukmBIO
         gqQF40UNgdnjj+BAlv2/NsbEtMdFEvGyo+47eMWnBAq45MYi4lYgsXZ0iuvMAE3Qo/o8
         PM16MpuRa3Of9EoOEdoqKAYqDSsWiWSyMV/CPOi/SAWwda7EjBgI8RMiAgU/qqAvQVtO
         8B9A==
X-Gm-Message-State: ACgBeo03sGtlxzRtEFKfM9I+2vwZCkKkqKpKySk5cAZkpbPuAO60frA1
        T6JcQX9Luhw1TMsUeXg3x+Ief2Nx1DgSIxwSIX0+clbqHX6JJGzpt0OUbtcxaj5jdf8FmW/f5GX
        iRuCU9SLUXxNbh0N9y+THrg==
X-Received: by 2002:a05:6000:1883:b0:228:5fa8:202e with SMTP id a3-20020a056000188300b002285fa8202emr8775065wri.519.1662741772361;
        Fri, 09 Sep 2022 09:42:52 -0700 (PDT)
X-Google-Smtp-Source: AA6agR566QErEVXDyW5dFN4Szlkx72F/oBEaS1aBTjIr0bwCiDZ0e1+NgiKSPoPoAUSJR5GVgipLow==
X-Received: by 2002:a05:6000:1883:b0:228:5fa8:202e with SMTP id a3-20020a056000188300b002285fa8202emr8775046wri.519.1662741771934;
        Fri, 09 Sep 2022 09:42:51 -0700 (PDT)
Received: from ?IPV6:2003:cb:c704:6300:1fe0:42e1:62c5:91b6? (p200300cbc70463001fe042e162c591b6.dip0.t-ipconnect.de. [2003:cb:c704:6300:1fe0:42e1:62c5:91b6])
        by smtp.gmail.com with ESMTPSA id r5-20020a1c4405000000b003a2e92edeccsm959330wma.46.2022.09.09.09.42.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 09 Sep 2022 09:42:51 -0700 (PDT)
Message-ID: <2da116d1-6dac-ae35-b37e-27d58840e233@redhat.com>
Date:   Fri, 9 Sep 2022 18:42:50 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.0
Content-Language: en-US
To:     Peter Xu <peterx@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>
Cc:     mm-commits@vger.kernel.org, jhubbard@nvidia.com, jgg@nvidia.com,
        apopple@nvidia.com, chenwandun@huawei.com
References: <20220907233412.27BC6C433D6@smtp.kernel.org>
 <YxtJr0kyV1v6kx3N@xz-m1.local>
From:   David Hildenbrand <david@redhat.com>
Organization: Red Hat
Subject: Re: + mm-avoid-unnecessary-page-table-walk-for-__get_user_pages.patch
 added to mm-unstable branch
In-Reply-To: <YxtJr0kyV1v6kx3N@xz-m1.local>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

On 09.09.22 16:11, Peter Xu wrote:
> On Wed, Sep 07, 2022 at 04:34:11PM -0700, Andrew Morton wrote:
>>
>> The patch titled
>>       Subject: mm: avoid unnecessary page table walk for __get_user_pages
>> has been added to the -mm mm-unstable branch.  Its filename is
>>       mm-avoid-unnecessary-page-table-walk-for-__get_user_pages.patch
>>
>> This patch will shortly appear at
>>       https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-avoid-unnecessary-page-table-walk-for-__get_user_pages.patch
>>
>> This patch will later appear in the mm-unstable branch at
>>      git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
>>
>> Before you just go and hit "reply", please:
>>     a) Consider who else should be cc'ed
>>     b) Prefer to cc a suitable mailing list as well
>>     c) Ideally: find the original patch on the mailing list and do a
>>        reply-to-all to that, adding suitable additional cc's
>>
>> *** Remember to use Documentation/process/submit-checklist.rst when testing your code ***
>>
>> The -mm tree is included into linux-next via the mm-everything
>> branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
>> and is updated there every 2-3 working days
>>
>> ------------------------------------------------------
>> From: Chen Wandun <chenwandun@huawei.com>
>> Subject: mm: avoid unnecessary page table walk for __get_user_pages
>> Date: Tue, 6 Sep 2022 10:44:01 +0800
>>
>> There is no need to walk page tables and find pages if faultin_page)_
>> succeeds and __get_user_pages)_ doesn't care about populating the pages[]
>> array.  So directly go on to handle the next page.
>>
>> Link: https://lkml.kernel.org/r/20220906024401.133336-1-chenwandun@huawei.com
>> Signed-off-by: Chen Wandun <chenwandun@huawei.com>
>> Cc: David Hildenbrand <david@redhat.com>
>> Cc: Jason Gunthorpe <jgg@nvidia.com>
>> Cc: John Hubbard <jhubbard@nvidia.com>
>> Cc: Peter Xu <peterx@redhat.com>
>> Cc: Alistair Popple <apopple@nvidia.com>
>> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
>> ---
>>
>>   mm/gup.c |    5 ++++-
>>   1 file changed, 4 insertions(+), 1 deletion(-)
>>
>> --- a/mm/gup.c~mm-avoid-unnecessary-page-table-walk-for-__get_user_pages
>> +++ a/mm/gup.c
>> @@ -1175,7 +1175,10 @@ retry:
>>   					   PTR_ERR(page) == -EMLINK, locked);
>>   			switch (ret) {
>>   			case 0:
>> -				goto retry;
>> +				if (pages)
>> +					goto retry;
>> +				else
>> +					goto next_page;
>>   			case -EBUSY:
>>   			case -EAGAIN:
>>   				ret = 0;
> 
> Will this mess up the refcounts already?  afaict follow_page_mask() is the
> only place to grab the pages, and GUP should need to take refcounts on
> pages even without pages** being passed in.
> 
> Meanwhile I'd think there will be cases that require multiple entrances of
> continuous follow_page_mask() + faultin_page() sequences, that even the
> previous round of faultin_page() returned success but follow_page_mask()
> may still want one more round of faulting for some reason to finally grab
> the correct page.

Right. handle_mm_fault() returning 0 does not imply that the fault was 
fully resolved.

-- 
Thanks,

David / dhildenb

