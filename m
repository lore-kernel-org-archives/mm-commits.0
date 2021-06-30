Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CCE6EC11F66
	for <mm-commits@archiver.kernel.org>; Wed, 30 Jun 2021 18:03:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B5B216147E
	for <mm-commits@archiver.kernel.org>; Wed, 30 Jun 2021 18:03:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232409AbhF3SGR (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 30 Jun 2021 14:06:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46780 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229991AbhF3SGQ (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 30 Jun 2021 14:06:16 -0400
Received: from mail-lf1-x12a.google.com (mail-lf1-x12a.google.com [IPv6:2a00:1450:4864:20::12a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 37810C061756
        for <mm-commits@vger.kernel.org>; Wed, 30 Jun 2021 11:03:46 -0700 (PDT)
Received: by mail-lf1-x12a.google.com with SMTP id d16so6734548lfn.3
        for <mm-commits@vger.kernel.org>; Wed, 30 Jun 2021 11:03:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=SV+Dg+ywBv21qRTVUPeFzNQ3owUTMn2wPuzSXJcfrnc=;
        b=DP70WG1Ul1F/XWK8yRLIF+7S9RKvQQ4sz8PjwB6TqphigPX0xW+/zu7PnH7kQ3AqrF
         O+h40UwFwzNO4PSBsr4QPbGvmS92+YXp6gnzQNqSHD+5aucIDsqxVnDOo3awVAfoEiRd
         dzojwP9CnK1TqTLCSmUvkmZJstjUJDfTbH21Y=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=SV+Dg+ywBv21qRTVUPeFzNQ3owUTMn2wPuzSXJcfrnc=;
        b=RVYnrzzu9ZKXA7Og54cSbUaIYgA1d2bNVI+5YjVQUqpifQRmA8SUa2dxV+gqrTNOnC
         Pci1jwwfP75/R8kXT20fazI6a9P5mEN59aEfKnuFw9D8TBVIoculfNS/fI9FbcBWF4GQ
         p/7Mn+07sJwXArMgAHRzdopi75xGQh9R2vuR1gUq5xl16yJpZtofv2/E8U4hZb+lzAYJ
         1yQY0nffesASAG8LRO0+cMip2rtRSKgaBLRi1PBryXvHlxq0rZpdlb8qdSmvrYFf7tOU
         Y4VrRZM/4PRiGwAnGsN4gy0T0Ft20YhlFzZndKOCHENO3BjRXYxmTIu975ey4RA6RLFf
         XaLw==
X-Gm-Message-State: AOAM5322NUE8Cqu5PK5E52KNtfymSrYiEQ3slIC8uIfVw0WZjYQxRTS3
        TM0PQ2XFW0Ma/9zMCvLuOSPpTCLRdh6Th7T1HU8=
X-Google-Smtp-Source: ABdhPJxKOIzCDu/R1vM1a6Mglv+TCjZ8/T1jS+43+aDU7uQxgYnyj/j1ATixZPJOrzrQK4bRatLmNA==
X-Received: by 2002:a05:6512:114a:: with SMTP id m10mr26768474lfg.402.1625076224150;
        Wed, 30 Jun 2021 11:03:44 -0700 (PDT)
Received: from mail-lf1-f50.google.com (mail-lf1-f50.google.com. [209.85.167.50])
        by smtp.gmail.com with ESMTPSA id x34sm1321016lfu.61.2021.06.30.11.03.43
        for <mm-commits@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 30 Jun 2021 11:03:43 -0700 (PDT)
Received: by mail-lf1-f50.google.com with SMTP id q18so6711955lfc.7
        for <mm-commits@vger.kernel.org>; Wed, 30 Jun 2021 11:03:43 -0700 (PDT)
X-Received: by 2002:a05:6512:15a2:: with SMTP id bp34mr26994369lfb.40.1625076222794;
 Wed, 30 Jun 2021 11:03:42 -0700 (PDT)
MIME-Version: 1.0
References: <20210628193256.008961950a714730751c1423@linux-foundation.org>
 <20210629023959.4ZAFiI8oZ%akpm@linux-foundation.org> <CAHk-=wj4KCujAH_oPh40Bkp48amM4MXr+8AcbZ=qd5LF4Q+TDg@mail.gmail.com>
 <YNu23Fu2HJhUEN5g@t490s> <YNvLUbrzkM+IOJlf@t490s> <CAHk-=wgt_666dOxYycGegSeUtLebUv0hVrcgXwXE9b-2_V=HXw@mail.gmail.com>
 <YNye5LNFaNFEPfhA@t490s>
In-Reply-To: <YNye5LNFaNFEPfhA@t490s>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Wed, 30 Jun 2021 11:03:25 -0700
X-Gmail-Original-Message-ID: <CAHk-=wjzwwJgSOWhnGC52cmkKAiKFVPKYg3zNnsQbdTRPsMN2w@mail.gmail.com>
Message-ID: <CAHk-=wjzwwJgSOWhnGC52cmkKAiKFVPKYg3zNnsQbdTRPsMN2w@mail.gmail.com>
Subject: Re: [patch 128/192] mm: improve mprotect(R|W) efficiency on pages
 referenced once
To:     Peter Xu <peterx@redhat.com>
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Evgeniy Stepanov <eugenis@google.com>, kostyak@google.com,
        Linux-MM <linux-mm@kvack.org>, mm-commits@vger.kernel.org,
        Peter Collingbourne <pcc@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

On Wed, Jun 30, 2021 at 9:42 AM Peter Xu <peterx@redhat.com> wrote:
>
> Yes I still fully agree it's very un-obvious.  So far the best thing I can come
> up with is something like below (patch attached too but not yet tested). I
> moved VM_WRITE out so hopefully it'll be very clear; then I also rearranged the
> checks so the final outcome looks like below:
>
> static bool may_avoid_write_fault(pte_t pte, struct vm_area_struct *vma,
>                                   unsigned long cp_flags)
> {
>         /*
>          * It is unclear whether this optimization can be done safely for NUMA
>          * pages.
>          */
>         if (cp_flags & MM_CP_PROT_NUMA)
>                 return false;

Please just put that VM_WRITE test first. It's the one that really
*matters*. There's no "it's unclear if" about that part. Just handle
the obvious and important check first.

Yeah, yeah, they both return false, so order doesn't matter from a
semantic standpoint, but from a clarity standpoint just do the clear
and unambiguous and security-relevant test first.

The rest of the tests are implementation details, the VM_WRITE test is
fundamental behavior. It's the one that made me worry about this patch
in the first place.

>         /*
>          * Don't do this optimization for clean pages as we need to be notified
>          * of the transition from clean to dirty.
>          */
>         if (!pte_dirty(pte))
>                 return false;
>
>         /* Same for softdirty. */
>         if (!pte_soft_dirty(pte) && (vma->vm_flags & VM_SOFTDIRTY))
>                 return false;
>
>         /*
>          * For userfaultfd the user program needs to monitor write faults so we
>          * can't do this optimization.
>          */
>         if (pte_uffd_wp(pte))
>                 return false;

So all of these are a bit special.

Why? Because if I look at the actual page fault path, these are not
the tests there.

I'd really like to have some obvious situation where we keep this
"make it writable" in sync with what would actually happen on a write
fault when it's not writable.

And it's not at all obvious to me for these cases.

The do_wp_page() code doesn't even use pte_uffd_wp(). It uses
userfaultfd_pte_wp(vma, pte), and I don't even know why. Yes, I can
see the code (it additionally tests the VM_UFFD_WP flag in the vma),
but a number of other paths then only do that pte_uffd_wp() test.

I get the feeling that we really should try to match what the
do_wp_page() path does, though.

Which brings up another issue: the do_wp_page() path treats PageKsm()
pages differently. And it locks the page before double-checking the
page count.

Why does mprotect() not need to do the same thing? I think this has
come up before, and "change_protection()" can get called with the
mmap_sem held just for reading - see userfaultfd - so it has all the
same issues as a page fault does, afaik.

>         /*
>          * MM_CP_DIRTY_ACCT indicates that we can always make the page writable
>          * regardless of the number of references.  Time to set the write bit.
>          */
>         if (cp_flags & MM_CP_DIRTY_ACCT)
>                 return true;
>
>         /*
>          * Othewise it means !MM_CP_DIRTY_ACCT.  We can only apply write bit
>          * early if it's anonymous page and we exclusively own it.
>          */
>         if (vma_is_anonymous(vma) && (page_count(pte_page(pte)) == 1))
>                 return true;
>
>         /* Don't play any trick */
>         return false;
> }
>
> The logic should be the same as before, it's just that we'll do an extra check
> on VM_WRITE for MM_CP_DIRTY_ACCT but assuming it's ok.

See above. I don't think the logic before was all that clear either.

The one case that is clear is that if it's a shared mapping, and
MM_CP_DIRTY_ACCT is set, and it was already dirty (and softdirty),
then it's ok.,

That's the old code.  I don't like how the old code was written
(because I think that MM_CP_DIRTY_ACCT bit wasx too subtle), but I
think the old code was at least correct.

The new code, it just worries me. It adds all those new cases for when
we can make the page writable early - that's the whole point of the
patch, after all - but my point here is that it's not at all obvious
that those new cases are actually correct.

MAYBE it's all correct. I'm not saying it's wrong. I'm just saying
it's not _obvious_ that it's correct.

What about that page_count() test, for example: it has a comment, it
looks obvious, but it's very different from what do_wp_page() does. So
what happens if we have a page-out at the same time that turns that
page into a swap cache page, and increments the page count? What about
that race? Do we end up with a writable page that is shared with a
swap cache entry? Is that ok? Why isn't it ok in the page fault case?

See why this patch worries me so much?

                       Linus
