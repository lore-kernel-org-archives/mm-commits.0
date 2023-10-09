Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ABEDCE95A8E
	for <mm-commits@archiver.kernel.org>; Mon,  9 Oct 2023 07:59:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345460AbjJIH74 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 9 Oct 2023 03:59:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41086 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345459AbjJIH7z (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 9 Oct 2023 03:59:55 -0400
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 077D58F
        for <mm-commits@vger.kernel.org>; Mon,  9 Oct 2023 00:59:54 -0700 (PDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 44E9D1FB;
        Mon,  9 Oct 2023 01:00:34 -0700 (PDT)
Received: from [10.57.66.97] (unknown [10.57.66.97])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 64F653F762;
        Mon,  9 Oct 2023 00:59:51 -0700 (PDT)
Message-ID: <316054fd-0acb-4277-b9da-d21f0dae2d29@arm.com>
Date:   Mon, 9 Oct 2023 08:59:50 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: +
 mm-non-pmd-mappable-large-folios-for-folio_add_new_anon_rmap.patch added to
 mm-unstable branch
Content-Language: en-GB
To:     Yu Zhao <yuzhao@google.com>
Cc:     David Hildenbrand <david@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
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
From:   Ryan Roberts <ryan.roberts@arm.com>
In-Reply-To: <CAOUHufYEKx5_zxRJkeqrmnStFjR+pVQdpZ40ATSTaxLA_iRPGw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

On 06/10/2023 16:24, Yu Zhao wrote:
> On Fri, Oct 6, 2023 at 2:53 AM Ryan Roberts <ryan.roberts@arm.com> wrote:
>>
>> On 05/10/2023 20:23, Yu Zhao wrote:
>>> On Thu, Oct 5, 2023 at 2:12 AM David Hildenbrand <david@redhat.com> wrote:
>>>>
>>>> On 29.09.23 21:08, Andrew Morton wrote:
>>>>>
>>>>> The patch titled
>>>>>       Subject: mm: non-pmd-mappable, large folios for folio_add_new_anon_rmap()
>>>>> has been added to the -mm mm-unstable branch.  Its filename is
>>>>>       mm-non-pmd-mappable-large-folios-for-folio_add_new_anon_rmap.patch
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
> From my POV, there have been some random changes between each version
> of your patchset:
> 1. v3 *introduced* a boot parameter `flexthp_unhinted_max`, which
>    *disappeared* in later versions.
> 2. v4 *introduced* a random constant ANON_FOLIO_MAX_ORDER_UNHINTED,
>    which *disappeared* in v6.
> 3. v5 is really close to what I think can be merged -- my only
>    objection is to ANON_FOLIO_MAX_ORDER_UNHINTED, I've never heard
>    *a good reason* why that random constant should sit in core mm.
> 4. v6 *introduced* a sysfs ABI -- we had a couple of alignment meetings
>    about how it might look but there was *never a consensus*.

A couple of points; It was my understanding that the preferred way of working
was to turn up with real code, that could be used as context for discussion.
That's the approach I've been taking. If this is not how I should be doing it,
then perhaps you could point me to the preferred approach?

For me, none of these changes are "random"; they are all attempts to solve the
problem of internal fragmentation when the HW-preferred order is "too big" to
have any reasonable confidence that we won't be wasting loads of memory. And
1,2,3 was trying to do this without introducing any ABI, as per your preference.
The reasons for their removal (and moving on to another approach) was due to the
feedback that you linked below.

I appreciate in hindsight, that you have found this meandering frustrating. But
if nothing else, it has been beneficial to help me understand the expected
standards - hopefully I'm learning.

> 
> FWICT, you haven't made up your mind. So I'm not convinced this series
> is close to being ready to introduce an ABI. This is NOT a NAK, just a
> ton of concerns with your current approach.
> 
> And I'm not sure how I could be more clear on how we can move forward
> progress [1][2][3]. Some suggestions would also help.

I appreciate the feedback you have given so far, and as far as I'm concerned,
I've listened to it; the changes you enumerated above are a direct results of
your feedback in the links below. And I do hope you continue to provide feedback
and help guide me towards a better solution.

But, there are questions I asked in the previous email which you did not answer.
If you are able to answer them, that would help me be better aligned with your
thinking. Namely:

  - You said the priorities are wrong and there are many pending work items I
    should be looking at first - what were you referring to here?
  - If you want a compile time option for testing, what is preventing you doing
    testing by merging in the patches? What is the benefit of it being upstream?

I see that both you and David have now responded directly to the series - thanks
to both of you. I will read and respond to that shortly, and let's continue the
conversation!


Thanks,
Ryan


> 
> [1] v3 https://lore.kernel.org/linux-mm/CAOUHufaDfJwF_-zb6zV5COG-KaaGcSyrNmbaEzaWz2UjcGGgHQ@mail.gmail.com/
> [2] v4 https://lore.kernel.org/linux-mm/CAOUHufackQzy+yXOzaej+G6DNYK-k9GAUHAK6Vq79BFHr7KwAQ@mail.gmail.com/
> [3] v5 https://lore.kernel.org/linux-mm/CAOUHufbUGwc2XvZOBmTCzMsOHxP-eLB60EdysKYzrkRMScOyMg@mail.gmail.com/

