Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5C964E92FF9
	for <mm-commits@archiver.kernel.org>; Fri,  6 Oct 2023 08:53:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231215AbjJFIxM (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 6 Oct 2023 04:53:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33952 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231287AbjJFIxL (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 6 Oct 2023 04:53:11 -0400
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 83CE193
        for <mm-commits@vger.kernel.org>; Fri,  6 Oct 2023 01:53:09 -0700 (PDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 48FD1C15;
        Fri,  6 Oct 2023 01:53:48 -0700 (PDT)
Received: from [10.57.67.92] (unknown [10.57.67.92])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 0AF9D3F5A1;
        Fri,  6 Oct 2023 01:53:05 -0700 (PDT)
Message-ID: <137d2fc4-de8b-4dda-a51d-31ce6b29a3d0@arm.com>
Date:   Fri, 6 Oct 2023 09:53:04 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: +
 mm-non-pmd-mappable-large-folios-for-folio_add_new_anon_rmap.patch added to
 mm-unstable branch
To:     Yu Zhao <yuzhao@google.com>, David Hildenbrand <david@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>
Cc:     mm-commits@vger.kernel.org, ziy@nvidia.com, ying.huang@intel.com,
        willy@infradead.org, vbabka@suse.cz, shy828301@gmail.com,
        rientjes@google.com, mcgrof@kernel.org,
        kirill.shutemov@linux.intel.com, jhubbard@nvidia.com,
        itaru.kitayama@gmail.com, hughd@google.com, fengwei.yin@intel.com,
        catalin.marinas@arm.com, anshuman.khandual@arm.com
References: <20230929190832.CBFFBC433C7@smtp.kernel.org>
 <63426190-5865-970f-773f-cce33a8209d1@redhat.com>
 <CAOUHufabXCBdrybKUzYVvHQExocj=XiNT8mYDxejt18vhMYr_A@mail.gmail.com>
Content-Language: en-GB
From:   Ryan Roberts <ryan.roberts@arm.com>
In-Reply-To: <CAOUHufabXCBdrybKUzYVvHQExocj=XiNT8mYDxejt18vhMYr_A@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

On 05/10/2023 20:23, Yu Zhao wrote:
> On Thu, Oct 5, 2023 at 2:12 AM David Hildenbrand <david@redhat.com> wrote:
>>
>> On 29.09.23 21:08, Andrew Morton wrote:
>>>
>>> The patch titled
>>>       Subject: mm: non-pmd-mappable, large folios for folio_add_new_anon_rmap()
>>> has been added to the -mm mm-unstable branch.  Its filename is
>>>       mm-non-pmd-mappable-large-folios-for-folio_add_new_anon_rmap.patch
>>>
>>
>> Andrew, please don't move these patches to stable before we have a
>> couple of acks from people involved in the discussions.
>>
>> I'm confident that we'll get them into 6.8.
> 
> I am not :)

I don't find that comment particularly helpful; Are you implying a NAK? If so,
some rationale and actionable suggestions would help.

> 
> As I repeated, the priorities seem wrong to me. There are many pending
> work items that don't involve any ABI changes

Are you referring to the prerequisite list [1]? If so, then its my understanding
that these work items are all in progress:

  - David is working on "shared vs exclusive mappings"
  - Zi Yan has posted an RFC for compaction
  - Yin Fengwei's mlock series is now in mm-stable
  - Yin Fengwei's madvise series is in 6.6
  - I've reworked and posted a series for deferred_split_folio; although I've
    deprioritied it because you said it wasn't really a pre-requisite.
  - numa balancing depends on David's "shared vs exclusive mappings" work
  - I've started looking at "large folios in swap cache" in the background,
    because I'm seeing some slow down with large folios, but we also agreed that
    wasn't a prerequisite

Or if that's not what you are referring to, then perhaps you are referring to
your comments against v5, which I thought were addressed in v6:

  - Removal of the hardcoded order policy [2]; which is removed and replaced by
    the flexibility of user-selectable orders (this has proven very useful for
    my testing)

, and IMO, we should
> focus on them before we even start discussing ABI changes.

I don't see why the prerequisites can't be done in parallel. I don't see any
dependency between them and the ABI.


> 
> I've been quiet  because I don't think opinion based discussions are
> essential to nailing down ABIs. 

We had 2 mm alignment meetings focussing on this topic, where the resounding
conclusion that I heard was that at minimum, we need a way to enable/disable
this at runtime. I'll admit that what I've posted goes a bit further than that,
but I was hoping we could argue about that in the context of the patch set. But
I definitely think we have moved on from the "we don't need any user ABI for
now" position.

As I suggested, I prefer a Kconfig
> option as the first step so that people can play with it. After we
> have collected field data, then we'd be better at coming up with
> suitable ABIs.

If you want to make it a compile time option only, and use it for testing, then
why do you need it upstream at all? Why not just take the patches and apply
them? Then we could use your data to help guide the upstreaming (I have asked
this before, but never saw a response [3]). Personally though, I would rather
not let perfection get in the way of good enough - I can see real world wins
with this and would prefer to start getting it into mainline incrementally,
sooner rather than later.

Thanks,
Ryan


[1] https://lore.kernel.org/linux-mm/f8d47176-03a8-99bf-a813-b5942830fd73@arm.com/
[2]
https://lore.kernel.org/linux-mm/CAOUHufbUGwc2XvZOBmTCzMsOHxP-eLB60EdysKYzrkRMScOyMg@mail.gmail.com/
[3] https://lore.kernel.org/linux-mm/e80cd2e6-6f7c-4337-a170-152926863290@arm.com/
