Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 62A32C11F66
	for <mm-commits@archiver.kernel.org>; Thu,  1 Jul 2021 01:27:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3BFFF61469
	for <mm-commits@archiver.kernel.org>; Thu,  1 Jul 2021 01:27:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235587AbhGAB3r (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 30 Jun 2021 21:29:47 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:40763 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234174AbhGAB3q (ORCPT
        <rfc822;mm-commits@vger.kernel.org>);
        Wed, 30 Jun 2021 21:29:46 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1625102836;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=/uWrCscmneLUA/uUagLIMnMUSuE67Udd5X7J38UaYls=;
        b=Wz/FIhvnaM3x0By9VvRQEhMtmABohRSIr7D437yC2yz8NVFj/7p5TCsTCFRxBaHKpnHIEf
        KD8yhICsTKco+2QiyoiM7LzV7P2zcJQ0o5EwWD+wq6fGyyObbqchwqlGPI8jBrg1IZowa6
        YNrfneONvOVFNUM3e3qntFI0c9aPcH8=
Received: from mail-qt1-f199.google.com (mail-qt1-f199.google.com
 [209.85.160.199]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-414-But9ij2CMri71G9QRUphUA-1; Wed, 30 Jun 2021 21:27:15 -0400
X-MC-Unique: But9ij2CMri71G9QRUphUA-1
Received: by mail-qt1-f199.google.com with SMTP id c17-20020ac87dd10000b0290250fd339409so2336704qte.6
        for <mm-commits@vger.kernel.org>; Wed, 30 Jun 2021 18:27:15 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=/uWrCscmneLUA/uUagLIMnMUSuE67Udd5X7J38UaYls=;
        b=n8bxEwgToinT5r24BnTjyEciekcDmDWtRKMqGkQvTF1rHpJFWHTBETdSrWIG9MLFNv
         xFHD4hsKmU83RR1/e9lj+G5KSRPpjd+HBXj2HYstJ48de/Fwf6yqWbZVtEGIZPOER2U0
         rndUAyLDwYFFOpqiuuopkD7X3b44shX32XOeTuBsPdphbxBkOAOWb13mwzT9XRcotvhJ
         6JuBa4eTsMM09kajVtvBaumUHRnhxAVWUT7cEmD7gBXQ8c9ciHZrOhG7m6fF4jXf04sa
         vdinjManhO6MXudDalgInFDDVcRZW2qabvBqe2coxXFaj+GL6DprdqmsvUAe2Fxr5Qqi
         7c4A==
X-Gm-Message-State: AOAM533WgtHeR6TaKRiAnh8/8uMYZ/ok2hkgwfdowNLylz4XB4GBaD4l
        iC+aTcsgyUgJ+NvGas83A+nyFej7GaubycO4kJrSecjboNDCwnKHq0AaOfjQiYR9j8CPGZJNwfW
        nRBVflPtk2l5O/B1VkQJpDQ==
X-Received: by 2002:a0c:e982:: with SMTP id z2mr20956983qvn.58.1625102835084;
        Wed, 30 Jun 2021 18:27:15 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwhD+K5l86WgL84gNPcdWrYBIR7rSeytw6ACMHJpQ8tfnt+V9EL4/etqvemogAs4vPbPzWfGQ==
X-Received: by 2002:a0c:e982:: with SMTP id z2mr20956958qvn.58.1625102834806;
        Wed, 30 Jun 2021 18:27:14 -0700 (PDT)
Received: from t490s (bras-base-toroon474qw-grc-65-184-144-111-238.dsl.bell.ca. [184.144.111.238])
        by smtp.gmail.com with ESMTPSA id v5sm2740736qtp.25.2021.06.30.18.27.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 30 Jun 2021 18:27:13 -0700 (PDT)
Date:   Wed, 30 Jun 2021 21:27:12 -0400
From:   Peter Xu <peterx@redhat.com>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Evgeniy Stepanov <eugenis@google.com>, kostyak@google.com,
        Linux-MM <linux-mm@kvack.org>, mm-commits@vger.kernel.org,
        Peter Collingbourne <pcc@google.com>
Subject: Re: [patch 128/192] mm: improve mprotect(R|W) efficiency on pages
 referenced once
Message-ID: <YN0Z8FwG25V29V96@t490s>
References: <20210628193256.008961950a714730751c1423@linux-foundation.org>
 <20210629023959.4ZAFiI8oZ%akpm@linux-foundation.org>
 <CAHk-=wj4KCujAH_oPh40Bkp48amM4MXr+8AcbZ=qd5LF4Q+TDg@mail.gmail.com>
 <YNu23Fu2HJhUEN5g@t490s>
 <YNvLUbrzkM+IOJlf@t490s>
 <CAHk-=wgt_666dOxYycGegSeUtLebUv0hVrcgXwXE9b-2_V=HXw@mail.gmail.com>
 <YNye5LNFaNFEPfhA@t490s>
 <CAHk-=wjzwwJgSOWhnGC52cmkKAiKFVPKYg3zNnsQbdTRPsMN2w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CAHk-=wjzwwJgSOWhnGC52cmkKAiKFVPKYg3zNnsQbdTRPsMN2w@mail.gmail.com>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

On Wed, Jun 30, 2021 at 11:03:25AM -0700, Linus Torvalds wrote:
> On Wed, Jun 30, 2021 at 9:42 AM Peter Xu <peterx@redhat.com> wrote:
> >
> > Yes I still fully agree it's very un-obvious.  So far the best thing I can come
> > up with is something like below (patch attached too but not yet tested). I
> > moved VM_WRITE out so hopefully it'll be very clear; then I also rearranged the
> > checks so the final outcome looks like below:
> >
> > static bool may_avoid_write_fault(pte_t pte, struct vm_area_struct *vma,
> >                                   unsigned long cp_flags)
> > {
> >         /*
> >          * It is unclear whether this optimization can be done safely for NUMA
> >          * pages.
> >          */
> >         if (cp_flags & MM_CP_PROT_NUMA)
> >                 return false;
> 
> Please just put that VM_WRITE test first. It's the one that really
> *matters*. There's no "it's unclear if" about that part. Just handle
> the obvious and important check first.
> 
> Yeah, yeah, they both return false, so order doesn't matter from a
> semantic standpoint, but from a clarity standpoint just do the clear
> and unambiguous and security-relevant test first.
> 
> The rest of the tests are implementation details, the VM_WRITE test is
> fundamental behavior. It's the one that made me worry about this patch
> in the first place.

Sure.

> 
> >         /*
> >          * Don't do this optimization for clean pages as we need to be notified
> >          * of the transition from clean to dirty.
> >          */
> >         if (!pte_dirty(pte))
> >                 return false;
> >
> >         /* Same for softdirty. */
> >         if (!pte_soft_dirty(pte) && (vma->vm_flags & VM_SOFTDIRTY))
> >                 return false;
> >
> >         /*
> >          * For userfaultfd the user program needs to monitor write faults so we
> >          * can't do this optimization.
> >          */
> >         if (pte_uffd_wp(pte))
> >                 return false;
> 
> So all of these are a bit special.
> 
> Why? Because if I look at the actual page fault path, these are not
> the tests there.
> 
> I'd really like to have some obvious situation where we keep this
> "make it writable" in sync with what would actually happen on a write
> fault when it's not writable.
> 
> And it's not at all obvious to me for these cases.
> 
> The do_wp_page() code doesn't even use pte_uffd_wp(). It uses
> userfaultfd_pte_wp(vma, pte), and I don't even know why. Yes, I can
> see the code (it additionally tests the VM_UFFD_WP flag in the vma),
> but a number of other paths then only do that pte_uffd_wp() test.

The vma check is a safety net to make sure it's not the case e.g. when the vma
has already unregistered from uffd-wp while there's uffd-wp bit left over.
E.g., currently UFFDIO_UNREGISTER is lazy on removing uffd-wp bits that applied
to ptes, so even vma is unregistered there could still have pte_uffd_wp() being
true for some ptes.  That vma check makes sure when it happens the uffd-wp bit
will be auto-removed.

> 
> I get the feeling that we really should try to match what the
> do_wp_page() path does, though.

Makes sense.

> 
> Which brings up another issue: the do_wp_page() path treats PageKsm()
> pages differently. And it locks the page before double-checking the
> page count.
> 
> Why does mprotect() not need to do the same thing? I think this has
> come up before, and "change_protection()" can get called with the
> mmap_sem held just for reading - see userfaultfd - so it has all the
> same issues as a page fault does, afaik.

Good point..  I overlooked ksm when reviewing the patch, while I should really
have looked at do_wp_page() as you suggested (hmm.. the truth is I wasn't even
aware of this patch and never planned to try to review it, until it breaks the
uffd-wp anonymous tests in its initial versions when I was testing mmots...).

Maybe something like this (to be squashed into the previously attached patch):

---8<---
diff --git a/mm/mprotect.c b/mm/mprotect.c
index 3977bfd55f62..7aab30ac9c9f 100644
--- a/mm/mprotect.c
+++ b/mm/mprotect.c
@@ -39,12 +39,8 @@
 static bool may_avoid_write_fault(pte_t pte, struct vm_area_struct *vma,
                                  unsigned long cp_flags)
 {
-       /*
-        * It is unclear whether this optimization can be done safely for NUMA
-        * pages.
-        */
-       if (cp_flags & MM_CP_PROT_NUMA)
-               return false;
+       struct page *page;
+       bool ret = false;

        /*
         * Never apply write bit if VM_WRITE not set.  Note that this is
@@ -55,6 +51,13 @@ static bool may_avoid_write_fault(pte_t pte, struct vm_area_struct *vma,
        if (!(vma->vm_flags & VM_WRITE))
                return false;

+       /*
+        * It is unclear whether this optimization can be done safely for NUMA
+        * pages.
+        */
+       if (cp_flags & MM_CP_PROT_NUMA)
+               return false;
+
        /*
         * Don't do this optimization for clean pages as we need to be notified
         * of the transition from clean to dirty.
@@ -80,15 +83,22 @@ static bool may_avoid_write_fault(pte_t pte, struct vm_area_struct *vma,
        if (cp_flags & MM_CP_DIRTY_ACCT)
                return true;

+       page = pte_page(pte);
+       /* Best effort to take page lock, don't play trick if failed */
+       if (!trylock_page(page))
+               return false;
+       /* KSM pages needs COW; leave them be */
+       if (PageKsm(page))
+               goto unlock_fail;
        /*
-        * Othewise it means !MM_CP_DIRTY_ACCT.  We can only apply write bit
-        * early if it's anonymous page and we exclusively own it.
+        * Othewise it means !MM_CP_DIRTY_ACCT and !KSM.  We can only apply
+        * write bit early if it's anonymous page and we exclusively own it.
         */
-       if (vma_is_anonymous(vma) && (page_count(pte_page(pte)) == 1))
-               return true;
-
-       /* Don't play any trick */
-       return false;
+       if (vma_is_anonymous(vma) && (page_count(page) == 1))
+               ret = true;
+unlock_fail:
+       unlock_page(page);
+       return ret;
 }

 static unsigned long change_pte_range(struct vm_area_struct *vma, pmd_t *pmd,
---8<---

I hope I didn't overlook something else..

Today when I was looking at ksm code, I found that I got lost on why we say
"PageKsm() doesn't necessarily raise the page refcount", as in do_wp_page().  I
was looking at replace_page() where, afaict, we still do proper refcounting for
the stable nodes with "get_page(kpage)".

I know I must missed something but I can't quickly tell.  In all cases with
above PageKsm check I think it'll be safe, and it's definitely clear that page
lock will stablize PageKsm()'s return value, like do_wp_page().

> 
> >         /*
> >          * MM_CP_DIRTY_ACCT indicates that we can always make the page writable
> >          * regardless of the number of references.  Time to set the write bit.
> >          */
> >         if (cp_flags & MM_CP_DIRTY_ACCT)
> >                 return true;
> >
> >         /*
> >          * Othewise it means !MM_CP_DIRTY_ACCT.  We can only apply write bit
> >          * early if it's anonymous page and we exclusively own it.
> >          */
> >         if (vma_is_anonymous(vma) && (page_count(pte_page(pte)) == 1))
> >                 return true;
> >
> >         /* Don't play any trick */
> >         return false;
> > }
> >
> > The logic should be the same as before, it's just that we'll do an extra check
> > on VM_WRITE for MM_CP_DIRTY_ACCT but assuming it's ok.
> 
> See above. I don't think the logic before was all that clear either.
> 
> The one case that is clear is that if it's a shared mapping, and
> MM_CP_DIRTY_ACCT is set, and it was already dirty (and softdirty),
> then it's ok.,
> 
> That's the old code.  I don't like how the old code was written
> (because I think that MM_CP_DIRTY_ACCT bit wasx too subtle), but I
> think the old code was at least correct.
> 
> The new code, it just worries me. It adds all those new cases for when
> we can make the page writable early - that's the whole point of the
> patch, after all - but my point here is that it's not at all obvious
> that those new cases are actually correct.

Yes agreed the MM_CP_DIRTY_ACCT bit is very subtle and not easy to get.  It's
just that I don't have a good idea to make it better, yet..

> 
> MAYBE it's all correct. I'm not saying it's wrong. I'm just saying
> it's not _obvious_ that it's correct.
> 
> What about that page_count() test, for example: it has a comment, it
> looks obvious, but it's very different from what do_wp_page() does. So
> what happens if we have a page-out at the same time that turns that
> page into a swap cache page, and increments the page count? What about
> that race? Do we end up with a writable page that is shared with a
> swap cache entry? Is that ok? Why isn't it ok in the page fault case?

That looks fine to me: when the race happens we must have checked page_count==1
first and granted the write bit, then add_to_swap_cache() happens after the
page_count==1 check (as it takes another refcount, so >2 otherwise).  Then it
also means unmap mappings should happen even after that point.  If my above
understanding is correct, our newly installed pte will be zapped safely soon,
but of course after we release the pgtable lock in change_pte_range().

Thanks,

-- 
Peter Xu

