Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D5201C433FE
	for <mm-commits@archiver.kernel.org>; Fri,  3 Sep 2021 05:11:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BC058610CE
	for <mm-commits@archiver.kernel.org>; Fri,  3 Sep 2021 05:11:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233764AbhICFMX (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 3 Sep 2021 01:12:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:34214 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236553AbhICFMU (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 3 Sep 2021 01:12:20 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4761560FDC;
        Fri,  3 Sep 2021 05:11:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1630645880;
        bh=EdGYyIVteppmS4PO2G0EKWwiWcwvczCgrv965hZ04q8=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=LIxkOhM8Ba4z2wGvi4AvWr0ZHvX0XXGVK5QpKTp43RPEIvZyU7S1JbdZWV15v8TqO
         BHTgseKAOKZZdNmlaEk/DsKkpm6YZ9mOLnrzs2nO5ugEdqh8D7QVteNftj+iOAiZFp
         jSIinsgyifW1rJbpbgPeQKevOWSYvVjdrgrKkCFxw7ZtDkXF+ipxJ3djR0VaQt0qw3
         CK6vJwEAxnkG8rfG4WhhdoAiybfFuc/W7fMcHrphwEE8jgx37u+khCtQgHNtpMcZAO
         xwQbiu68CuHJcsiXYGhkh5eNzM42VkFSUlmTd3+MnYJUIK55bU73OaNA7lI3q7vMmZ
         d6qANAC1+uA9g==
Subject: Re: [patch 119/212] lazy tlb: shoot lazies, a non-refcounting lazy
 tlb option
To:     Nicholas Piggin <npiggin@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Cc:     Anton Blanchard <anton@ozlabs.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Linux-MM <linux-mm@kvack.org>, mm-commits@vger.kernel.org,
        Paul Mackerras <paulus@ozlabs.org>,
        Randy Dunlap <rdunlap@infradead.org>
References: <20210902215620._WXglfIJy%akpm@linux-foundation.org>
 <18b7e206-9ee6-4afe-b662-9dcbdf55a9db@www.fastmail.com>
 <CAHk-=wjC05YZycowZkmvjZACNEm3rUhLTneN+Vaz9Ebp1+++Gw@mail.gmail.com>
 <20210902155330.a643b03dc6991cde53133edf@linux-foundation.org>
 <1630629747.odrw4rffkd.astroid@bobo.none>
From:   Andy Lutomirski <luto@kernel.org>
Message-ID: <e0166f2c-f742-635b-6b40-eef1a955f8c4@kernel.org>
Date:   Thu, 2 Sep 2021 22:11:19 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <1630629747.odrw4rffkd.astroid@bobo.none>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

On 9/2/21 5:46 PM, Nicholas Piggin wrote:
> Excerpts from Andrew Morton's message of September 3, 2021 8:53 am:
>> On Thu, 2 Sep 2021 15:50:03 -0700 Linus Torvalds <torvalds@linux-foundation.org> wrote:
>>
>>> On Thu, Sep 2, 2021 at 3:29 PM Andy Lutomirski <luto@kernel.org> wrote:
>>>>
>>>> This pile is:
>>>>
>>>> Nacked-by: Andy Lutomirski <luto@kernel.org>
>>>
>>> Can you specify exactly the range you want me to drop?
>>>
>>> I assume it's the four patches 117-120, ie
>>>
>>>   lazy tlb: introduce lazy mm refcount helper functions
>>>   lazy tlb: allow lazy tlb mm refcounting to be configurable
>>>   lazy tlb: shoot lazies, a non-refcounting lazy tlb option
>>>   powerpc/64s: enable MMU_LAZY_TLB_SHOOTDOWN
>>>
>>> but I just want to double-check before I do surgery on that series.
>>
>> Yes, those 4.
>>
>> Sorry, I missed that email thread...
>>
> 
> That's not reasonable. Andy has had complete misunderstandings about the
> series which seems to stem from x86's horrible hacks that have gone in
> has confused him.

The horrible hacks in question are almost exclusively in core code.
Here's a brief summary of the situation.

There's a messy interaction between mmget()/mmdrop() and membarrier.
membarrier currently depends on some mmget() and mmdrop() calls to be
full barriers.  You make membarrier keep working by putting an ifdef'd
smp_mb() in the core scheduler.  I clean up the code to make it work
independently of smp_mb() and therefore save the cost of the
unconditional barrier for non-membarrier-using programs.

Your series adds an option MMU_LAZY_TLB_REFCOUNT=n for architectures to
opt out of lazy TLB refcounting.  This is simply wrong.  Right now, the
core scheduler provides current->active_mm and guarantees that
current->active_mm always points to a live (possibly mm_users == 0 but
definitely not freed) mm_struct.  With MMU_LAZY_TLB_REFCOUNT=n,
current->active_mm still exists, is still updated, but may point to
freed memory.  I consider this unacceptable.  A comment says "This can
be disabled if the architecture ensures no CPUs are using an mm as a
"lazy tlb" beyond its final refcount" -- that's nice, but saying "well,
if you this, you have to make sure you don't accidentally dereference
that juicy dangling pointer we give you" is, in my book, a poor
justification.

I have no particular objection to the actual shoot lazies part, except
insofar as I think we can do even better (e.g. my patch).  But 90% of
the complexity of my WIP series is cleaning up the mess so that we can
have a maintainable lazy mm mechanism instead of expanding the current
hard-to-maintain part into three separate possible modes.

Maybe I'm holding my own patches to an excessively high standard.



> 
> My series doesn't affect x86 at all and it's no reason why Andy's series
> to improve x86 can't be merged later. But that half finished series he 
> keeps threatening with has been sitting there for almost a year now and 
> it's gone nowhere, while there have been no unresolved technical 
> objections to mine, it works, it's simple and small.

My series barely touches x86.  The only "hack" is that x86 may have a
CPU that has ->mm == NULL, ->active_mm != NULL, CR3 pointing to the init
pgd, and mm_cpumask clear.  I don't see why this is a problem other than
being somewhat unusual.  But x86 bare metal, like every architecture
that can only flush the TLB using an IPI, can very efficiently shoot
lazies, since it shoots the lazies anyway when tearing down pagetables,
but actually enabling the config option with this series applied will
result in ->active_mm pointing to freed memory.  Ick.

> 
> I've kept trying to offer to help Andy with reviewing his stuff or fix 
> the horrible x86 hacks, but nothing.

I haven't finished it yet.  Sorry.
