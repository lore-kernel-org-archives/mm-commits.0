Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7E221C11F65
	for <mm-commits@archiver.kernel.org>; Wed, 30 Jun 2021 16:42:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6023E61456
	for <mm-commits@archiver.kernel.org>; Wed, 30 Jun 2021 16:42:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229529AbhF3Qov (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 30 Jun 2021 12:44:51 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:31293 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229510AbhF3Qov (ORCPT
        <rfc822;mm-commits@vger.kernel.org>);
        Wed, 30 Jun 2021 12:44:51 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1625071341;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=OiRC9BHMkJ2ZNbqNUXk2pt3f/O9/0fqo5vSlAuOz4M0=;
        b=EceJAWMnUK2kGwAj4zCJZnpPvJXrfhGTSqshYd/I+QyrVQxrTj4Zest82L6aCoBok14wQC
        ovS9+azvoUtv0nHetqWzOQRu20tyjlQRX2L3Mm/8r846UGKoPHkjbpxSD0f0btCoKxExUj
        NmFM1A8mRe8vwUzD90M+lc/HT9doW1s=
Received: from mail-qt1-f198.google.com (mail-qt1-f198.google.com
 [209.85.160.198]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-264-hPS_1tDCMkOuWdlu3gxgoA-1; Wed, 30 Jun 2021 12:42:15 -0400
X-MC-Unique: hPS_1tDCMkOuWdlu3gxgoA-1
Received: by mail-qt1-f198.google.com with SMTP id e9-20020ac859890000b0290250be770d0fso1443186qte.15
        for <mm-commits@vger.kernel.org>; Wed, 30 Jun 2021 09:42:15 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=OiRC9BHMkJ2ZNbqNUXk2pt3f/O9/0fqo5vSlAuOz4M0=;
        b=nl/E49O0ppE+ALzEy9y1rrfvet0APYhtEs5/nvg23ZoFTcrRM/RRNknSIbz5Q4rpLl
         Z/s6P5MP7PREsWI3BPftB/N54gTwGkDqkLxua77mGR77w2Edb5sZX6I9zYTJWe9f4w2R
         Szdu/+jkAz7tCLsUpF3/pQxQNBVMAtNYXjeeBnJF3gZL4XdKA0XZI9wi805ai3UazA7U
         qc2mTrIVYsdmVpxUFWoN/yorEBzO0ORCRFMeRf+WXvtIGXIzsoEccp3/sgnkbGso819b
         yq23eKbat4Fry6TEEnuX4EbuwVwk/+EJ2SJ5+07eoUCQR+esfMHgq84oJczAAiffefMd
         V8DA==
X-Gm-Message-State: AOAM533YoJ53tI73IBwIQasQUaHLnPXBdnJxbhr543arjNNK5w9gmnBs
        icZRR39OpmWEBZVyr5Lglt6cmrTtaXHiuBj/91TYA/zUxfVkfQNce02ru3oLJfhwk4S4yIewC/i
        ZaBKo2ZlmATOx8QMmViE6Ew==
X-Received: by 2002:a05:620a:158c:: with SMTP id d12mr37295578qkk.42.1625071335121;
        Wed, 30 Jun 2021 09:42:15 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxDUr2MbbPQiUMcyscroHP0d5MO1KINriCL0gsYMHAWki3m1ggZtTBGGu0HBd0gImstEVx/kQ==
X-Received: by 2002:a05:620a:158c:: with SMTP id d12mr37295546qkk.42.1625071334818;
        Wed, 30 Jun 2021 09:42:14 -0700 (PDT)
Received: from t490s (bras-base-toroon474qw-grc-65-184-144-111-238.dsl.bell.ca. [184.144.111.238])
        by smtp.gmail.com with ESMTPSA id j15sm5365994qki.23.2021.06.30.09.42.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 30 Jun 2021 09:42:13 -0700 (PDT)
Date:   Wed, 30 Jun 2021 12:42:12 -0400
From:   Peter Xu <peterx@redhat.com>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Evgeniy Stepanov <eugenis@google.com>, kostyak@google.com,
        Linux-MM <linux-mm@kvack.org>, mm-commits@vger.kernel.org,
        Peter Collingbourne <pcc@google.com>
Subject: Re: [patch 128/192] mm: improve mprotect(R|W) efficiency on pages
 referenced once
Message-ID: <YNye5LNFaNFEPfhA@t490s>
References: <20210628193256.008961950a714730751c1423@linux-foundation.org>
 <20210629023959.4ZAFiI8oZ%akpm@linux-foundation.org>
 <CAHk-=wj4KCujAH_oPh40Bkp48amM4MXr+8AcbZ=qd5LF4Q+TDg@mail.gmail.com>
 <YNu23Fu2HJhUEN5g@t490s>
 <YNvLUbrzkM+IOJlf@t490s>
 <CAHk-=wgt_666dOxYycGegSeUtLebUv0hVrcgXwXE9b-2_V=HXw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="12N2WSkLxi7kcQDE"
Content-Disposition: inline
In-Reply-To: <CAHk-=wgt_666dOxYycGegSeUtLebUv0hVrcgXwXE9b-2_V=HXw@mail.gmail.com>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


--12N2WSkLxi7kcQDE
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline

On Tue, Jun 29, 2021 at 07:25:42PM -0700, Linus Torvalds wrote:
> On Tue, Jun 29, 2021 at 6:39 PM Peter Xu <peterx@redhat.com> wrote:
> >
> > And since MM_CP_DIRTY_ACCT implies "VM_WRITE|VM_SHARED" all set, above should
> > be a slightly faster version of below:
> 
> That's way too subtle, particularly since the MM_CP_DIRTY_ACCT logic
> comes from another file entirely.
> 
> I don't think it's even faster, considering that presumably the
> anonymous mapping case is the common one, and that's the one that
> needs all the extra tests, it's likely better to _not_ test that very
> subtle flag at all, and just doing the straightforward and obvious
> tests that are understandable _locally_.
> 
> So I claim that it's
> 
>  (a) not an optimization at all
> 
>  (b) completely locally unintuitive and unreadable
> 
> > Again, I think in all cases some more comment should be good indeed..
> 
> I really want more than a comment. I want that MM_CP_DIRTY_ACCT bit
> testing gone.

My understanding is that MM_CP_DIRTY_ACCT contains all check results from
vma_wants_writenotify(), so if we drop it we'd need to have something like that
to be checked within change_pte_range(), which is again slower (I have totally
no idea how slow to check vma->vm_flags & VM_WRITE, but moving the whole
vma_wants_writenotify here is definitely even slower).

> 
> The only point where it makes sense to check MM_CP_DIRTY_ACCT is
> within the context of "is the page already dirty".
> 
> So I think the logic should be something along the lines of
> 
>  - first:
> 
>          if (!(vma->vm_flags & VM_WRITE))
>                 return false;
> 
>    because that logic is set in stone, and true regardless of anything
> else. If the vma isn't writable, we're not going to set the write bit.
> End of story.
> 
>  - then, check the vma_is_anonumous() case:
> 
>         if (vma_is_anonymous(vma))
>                 return page_count(pte_page(pte)) == 1;
> 
>      because if it's a writable mapping, and anonymous, then we can
> mark it writable if we're the exclusive owners of that page.

Shouldn't we still at least checks [soft-]dirty bits and uffd-wp bits to make
sure it's either not dirty tracked or uffd wr-protected?  Say, IMHO it's
possible that soft-dirty tracking enabled on this anonymous vma range, then we
still depend on the write bit removed to set the soft-dirty later in the fault
handler.

> 
>  - and THEN we can handle the "ok, shared mapping, now let's start
> thinking about dirty accounting" cases.
> 
> Make it obvious and correct. This is not a sequence where you should
> try to (incorrectly) optimize away individual instructions.

Yes I still fully agree it's very un-obvious.  So far the best thing I can come
up with is something like below (patch attached too but not yet tested). I
moved VM_WRITE out so hopefully it'll be very clear; then I also rearranged the
checks so the final outcome looks like below:

static bool may_avoid_write_fault(pte_t pte, struct vm_area_struct *vma,
				  unsigned long cp_flags)
{
	/*
	 * It is unclear whether this optimization can be done safely for NUMA
	 * pages.
	 */
	if (cp_flags & MM_CP_PROT_NUMA)
		return false;

	/*
	 * Never apply write bit if VM_WRITE not set.  Note that this is
	 * actually checked for VM_SHARED when MM_CP_DIRTY_ACCT is set, so
	 * logically we only need to check it for !MM_CP_DIRTY_ACCT, but just
	 * make it even more obvious.
	 */
	if (!(vma->vm_flags & VM_WRITE))
		return false;

	/*
	 * Don't do this optimization for clean pages as we need to be notified
	 * of the transition from clean to dirty.
	 */
	if (!pte_dirty(pte))
		return false;

	/* Same for softdirty. */
	if (!pte_soft_dirty(pte) && (vma->vm_flags & VM_SOFTDIRTY))
		return false;

	/*
	 * For userfaultfd the user program needs to monitor write faults so we
	 * can't do this optimization.
	 */
	if (pte_uffd_wp(pte))
		return false;

	/*
	 * MM_CP_DIRTY_ACCT indicates that we can always make the page writable
	 * regardless of the number of references.  Time to set the write bit.
	 */
	if (cp_flags & MM_CP_DIRTY_ACCT)
		return true;

	/*
	 * Othewise it means !MM_CP_DIRTY_ACCT.  We can only apply write bit
	 * early if it's anonymous page and we exclusively own it.
	 */
	if (vma_is_anonymous(vma) && (page_count(pte_page(pte)) == 1))
		return true;

	/* Don't play any trick */
	return false;
}

The logic should be the same as before, it's just that we'll do an extra check
on VM_WRITE for MM_CP_DIRTY_ACCT but assuming it's ok.

Another side note is that I still think the VM_SOFTDIRTY check is wrong in
may_avoid_write_fault() and even in the old code (I mentioned it previously
when reviewing the patch), as !VM_SOFTDIRTY should mean soft dirty tracking
enabled while VM_SOFTDIRTY means disabled.  So I wonder whether it should be:

-       if (!pte_soft_dirty(pte) && (vma->vm_flags & VM_SOFTDIRTY))
+       if (!pte_soft_dirty(pte) && !(vma->vm_flags & VM_SOFTDIRTY))

However I didn't touch it up there as it may need more justifications (I feel
it's okay in the old code, as vma_wants_writenotify actually checks it too and
in the right way; however after the anonymous fast path it seems to prone to
error if it's anonymous; I'll check later).

Thanks,

-- 
Peter Xu

--12N2WSkLxi7kcQDE
Content-Type: text/plain; charset=utf-8
Content-Disposition: attachment;
	filename="0001-mm-mprotect-Optimize-layout-of-may_avoid_write_fault.patch"

From 4fb32ad7c949d5ec6b6ea364d3388b50bf674c9c Mon Sep 17 00:00:00 2001
From: Peter Xu <peterx@redhat.com>
Date: Wed, 30 Jun 2021 12:20:12 -0400
Subject: [PATCH] mm/mprotect: Optimize layout of may_avoid_write_fault()

Firstly move VM_WRITE check to be outside of !MM_CP_DIRTY_ACCT chunk, so as to
make it clear that we won't accidentally set the write bit to !VM_WRITE vmas.

The old logic is hard to read in that it was written in reversed logic.  Put
things backward by moving the soft-dirty and uffd-wp checks earlier.  Make the
NUMA check even earlier than those as it's a cheap check and straightforward.

Make the only "return true" case to be either the MM_CP_DIRTY_ACCT (which
stands for the VM_SHARED cases when write bit can be applied), or the special
anonymous page when we exclusively own it.

Signed-off-by: Peter Xu <peterx@redhat.com>
---
 mm/mprotect.c | 39 +++++++++++++++++++++++++--------------
 1 file changed, 25 insertions(+), 14 deletions(-)

diff --git a/mm/mprotect.c b/mm/mprotect.c
index 4cb240fd9936..3977bfd55f62 100644
--- a/mm/mprotect.c
+++ b/mm/mprotect.c
@@ -40,17 +40,20 @@ static bool may_avoid_write_fault(pte_t pte, struct vm_area_struct *vma,
 				  unsigned long cp_flags)
 {
 	/*
-	 * The dirty accountable bit indicates that we can always make the page
-	 * writable regardless of the number of references.
+	 * It is unclear whether this optimization can be done safely for NUMA
+	 * pages.
 	 */
-	if (!(cp_flags & MM_CP_DIRTY_ACCT)) {
-		/* Otherwise, we must have exclusive access to the page. */
-		if (!(vma_is_anonymous(vma) && (vma->vm_flags & VM_WRITE)))
-			return false;
+	if (cp_flags & MM_CP_PROT_NUMA)
+		return false;
 
-		if (page_count(pte_page(pte)) != 1)
-			return false;
-	}
+	/*
+	 * Never apply write bit if VM_WRITE not set.  Note that this is
+	 * actually checked for VM_SHARED when MM_CP_DIRTY_ACCT is set, so
+	 * logically we only need to check it for !MM_CP_DIRTY_ACCT, but just
+	 * make it even more obvious.
+	 */
+	if (!(vma->vm_flags & VM_WRITE))
+		return false;
 
 	/*
 	 * Don't do this optimization for clean pages as we need to be notified
@@ -71,13 +74,21 @@ static bool may_avoid_write_fault(pte_t pte, struct vm_area_struct *vma,
 		return false;
 
 	/*
-	 * It is unclear whether this optimization can be done safely for NUMA
-	 * pages.
+	 * MM_CP_DIRTY_ACCT indicates that we can always make the page writable
+	 * regardless of the number of references.  Time to set the write bit.
 	 */
-	if (cp_flags & MM_CP_PROT_NUMA)
-		return false;
+	if (cp_flags & MM_CP_DIRTY_ACCT)
+		return true;
+
+	/*
+	 * Othewise it means !MM_CP_DIRTY_ACCT.  We can only apply write bit
+	 * early if it's anonymous page and we exclusively own it.
+	 */
+	if (vma_is_anonymous(vma) && (page_count(pte_page(pte)) == 1))
+		return true;
 
-	return true;
+	/* Don't play any trick */
+	return false;
 }
 
 static unsigned long change_pte_range(struct vm_area_struct *vma, pmd_t *pmd,
-- 
2.31.1


--12N2WSkLxi7kcQDE--

