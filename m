Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1EAF2E94101
	for <mm-commits@archiver.kernel.org>; Fri,  6 Oct 2023 19:09:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233308AbjJFTJr (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 6 Oct 2023 15:09:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56804 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232789AbjJFTJq (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 6 Oct 2023 15:09:46 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BFA5683
        for <mm-commits@vger.kernel.org>; Fri,  6 Oct 2023 12:08:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1696619339;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=PnNApfaqAhSOWIAWMyK+YQ2IM1aqpKNIPPC5vxu7MmM=;
        b=dw77lULbSB77dpgoJdmoXqKHoliTnEsmYJ8Y7DhuryaSkN/Ks1/FJEVeHZxXjKsaHRGcMy
        0vhdZJb50Nd8QVT9TObKFIoJFqTsnzhS4VMvmD5CJNF5DUeBaM7c4Wqjs6z8QQXZrLWfbc
        My3/j1aHjMz4C8prDEBy1tejJksLQ5E=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-271-P2djhX3_M-GVH0LPIFezCw-1; Fri, 06 Oct 2023 15:08:57 -0400
X-MC-Unique: P2djhX3_M-GVH0LPIFezCw-1
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-4065ca278b3so15085525e9.3
        for <mm-commits@vger.kernel.org>; Fri, 06 Oct 2023 12:08:56 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1696619336; x=1697224136;
        h=content-transfer-encoding:in-reply-to:organization:from:references
         :cc:to:content-language:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=PnNApfaqAhSOWIAWMyK+YQ2IM1aqpKNIPPC5vxu7MmM=;
        b=vAuJAGNSpMoairbmEPcZg6DNeBROY4K+70dtqldRCvDaxSfph4OURNK18M9GnS+u7s
         sEKf8bYzVL3b5a4sw74b5GcjB6CmDNrgJPG4A/9/D6c2INTGDB7cvIL0iuZQhwf9ye8o
         FjfpX2pNgSgDSjBW1ZrCxFb61wO/0G46RBjQH+Tu1nMTkbpHCbciBiaHym4VOtL4z/6O
         xCKsk0P3mCT428rrEfjo/3XYWAh9xl/Nmq0r8fMubkG6lrbjmnIqM6YE4MV+eL0dJFJm
         em2NtLr3OeC0kTalWz0dDDLeq5mF4FBOdXpeGApqbboRLXBRUyOrgGgOf2z0cOpSk8eB
         4kog==
X-Gm-Message-State: AOJu0Yzl8sfEfVFu7HtprXFwXUEnMvd794McRYODrtOSORnl687t8VUC
        oEC6y51uXibg1PkXfaE//q5vPpXCisnw5isGswyw6LFIardy5d0oLAW758xjgEVz6ckExcG610A
        jZeyMTIf2Ea+e7JQfL/h3uw==
X-Received: by 2002:a7b:cd8e:0:b0:406:45c1:a657 with SMTP id y14-20020a7bcd8e000000b0040645c1a657mr8067123wmj.6.1696619335923;
        Fri, 06 Oct 2023 12:08:55 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHYBi9zdDbk/h+psn8GtHITiVV2xYefyIq6hyxHC0WhhMBSDhwExcsvRkDyiQbY4hf1XdD5lw==
X-Received: by 2002:a7b:cd8e:0:b0:406:45c1:a657 with SMTP id y14-20020a7bcd8e000000b0040645c1a657mr8067104wmj.6.1696619335368;
        Fri, 06 Oct 2023 12:08:55 -0700 (PDT)
Received: from ?IPV6:2003:cb:c715:ee00:4e24:cf8e:3de0:8819? (p200300cbc715ee004e24cf8e3de08819.dip0.t-ipconnect.de. [2003:cb:c715:ee00:4e24:cf8e:3de0:8819])
        by smtp.gmail.com with ESMTPSA id a11-20020adff7cb000000b00326f0ca3566sm2247660wrq.50.2023.10.06.12.08.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 06 Oct 2023 12:08:55 -0700 (PDT)
Message-ID: <0866e743-5837-610b-6a6a-0564e7fc7023@redhat.com>
Date:   Fri, 6 Oct 2023 21:08:53 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
Subject: Re: +
 mm-non-pmd-mappable-large-folios-for-folio_add_new_anon_rmap.patch added to
 mm-unstable branch
Content-Language: en-US
To:     Yu Zhao <yuzhao@google.com>, Ryan Roberts <ryan.roberts@arm.com>
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        mm-commits@vger.kernel.org, ziy@nvidia.com, ying.huang@intel.com,
        willy@infradead.org, vbabka@suse.cz, shy828301@gmail.com,
        rientjes@google.com, mcgrof@kernel.org,
        kirill.shutemov@linux.intel.com, jhubbard@nvidia.com,
        itaru.kitayama@gmail.com, hughd@google.com, fengwei.yin@intel.com,
        catalin.marinas@arm.com, anshuman.khandual@arm.com
References: <20230929190832.CBFFBC433C7@smtp.kernel.org>
 <63426190-5865-970f-773f-cce33a8209d1@redhat.com>
 <CAOUHufabXCBdrybKUzYVvHQExocj=XiNT8mYDxejt18vhMYr_A@mail.gmail.com>
 <137d2fc4-de8b-4dda-a51d-31ce6b29a3d0@arm.com>
 <CAOUHufYEKx5_zxRJkeqrmnStFjR+pVQdpZ40ATSTaxLA_iRPGw@mail.gmail.com>
From:   David Hildenbrand <david@redhat.com>
Organization: Red Hat
In-Reply-To: <CAOUHufYEKx5_zxRJkeqrmnStFjR+pVQdpZ40ATSTaxLA_iRPGw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

On 06.10.23 17:24, Yu Zhao wrote:
> On Fri, Oct 6, 2023 at 2:53 AM Ryan Roberts <ryan.roberts@arm.com> wrote:
>>
>> On 05/10/2023 20:23, Yu Zhao wrote:
>>> On Thu, Oct 5, 2023 at 2:12 AM David Hildenbrand <david@redhat.com> wrote:
>>>>
>>>> On 29.09.23 21:08, Andrew Morton wrote:
>>>>>
>>>>> The patch titled
>>>>>        Subject: mm: non-pmd-mappable, large folios for folio_add_new_anon_rmap()
>>>>> has been added to the -mm mm-unstable branch.  Its filename is
>>>>>        mm-non-pmd-mappable-large-folios-for-folio_add_new_anon_rmap.patch
>>>>>
>>>>
>>>> Andrew, please don't move these patches to stable before we have a
>>>> couple of acks from people involved in the discussions.
>>>>
>>>> I'm confident that we'll get them into 6.8.
>>>
>>> I am not :)
>>
>> I don't find that comment particularly helpful; Are you implying a NAK? If so,
>> some rationale and actionable suggestions would help.
> 
>  From my POV, there have been some random changes between each version
> of your patchset:

There have been significant changes, which is one reason why I would 
prefer this to actually get reviewed and ack'ed ;)

Sorry for stepping on the brake pedal ...

-- 
Cheers,

David / dhildenb

