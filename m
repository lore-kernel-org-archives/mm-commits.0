Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 32026C11F67
	for <mm-commits@archiver.kernel.org>; Wed, 30 Jun 2021 01:39:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0933561D43
	for <mm-commits@archiver.kernel.org>; Wed, 30 Jun 2021 01:39:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231698AbhF3BmC (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 29 Jun 2021 21:42:02 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:46712 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230033AbhF3BmC (ORCPT
        <rfc822;mm-commits@vger.kernel.org>);
        Tue, 29 Jun 2021 21:42:02 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1625017173;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=SfRRElH/OVRFFfreHJ0prj1+bL496qRlGzHYuzFCC2U=;
        b=io2XFa1BbsW6Mu6HfoaeK5tGZg0yOD6I8Va9fR93+5doGclDxjju+ZhmPUVWDApKiuSKU1
        DbCwfXmWt5I8CImvCEqItHCHY0cmEaKuPIw0f0iO/yFiD/y1DNaKrFCwGv8KGOTivS9/jc
        xuZGpFkpYiCUVTLDhWaNpJvN5NmgZpQ=
Received: from mail-qv1-f69.google.com (mail-qv1-f69.google.com
 [209.85.219.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-563-V5K2CVzmOJiLfFxU-mK-0w-1; Tue, 29 Jun 2021 21:39:32 -0400
X-MC-Unique: V5K2CVzmOJiLfFxU-mK-0w-1
Received: by mail-qv1-f69.google.com with SMTP id ei5-20020ad45a050000b029027c5382c633so305756qvb.3
        for <mm-commits@vger.kernel.org>; Tue, 29 Jun 2021 18:39:32 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=SfRRElH/OVRFFfreHJ0prj1+bL496qRlGzHYuzFCC2U=;
        b=O7fTkxuzp6w27YRaYZjR8aFPtvV4tfmkx5M5EwistfV+nISwovhV3VC2TzrGG8LVRU
         7LnEvGp9Sam+c/l6OoPiXxokwoUNbzaFGtWW7CqIVX0PT6xvUNfKRkZeQ8Q3mhP+YfAe
         ZcaPda6VHsUtWfG9AuVFp6CSIlDcCJEDxpRR7iZru/tfSWykoeOL1W5vgazSwDySDJFq
         CGdlkI+2Xa1As/gDPxqSwniqB2VJpREDM7q9aWgHNPnjM/qFspBqqTEYylgkNc90LdOh
         prf074S99bPL+4AyjTxDvhMnG4BICdhAQ7TJTxRX1HYs+PhoPu+bMIXsnuxmhB4CNRQY
         T8mw==
X-Gm-Message-State: AOAM531LFCp9Z8/idIv2kVJmDKlcCl29djZWw/kaks5UZXHk/eh+7pGn
        K2gy1Ecy3UpZEZrztoqzK3d2Wyorgx17p2+7/dtnjz4oP8nXyslD9X6997YMztVgQ640n/2BsZ8
        d8zALYRGRSd8DY68nyE+KJA==
X-Received: by 2002:a37:b1c3:: with SMTP id a186mr34548483qkf.17.1625017171689;
        Tue, 29 Jun 2021 18:39:31 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzFin9uavRfX45sZNHUPPhepSFPS8/dlGO5ahrhOtBjd4gNJkcSj3hOxZZPP+HpCyFGhu4fcg==
X-Received: by 2002:a37:b1c3:: with SMTP id a186mr34548465qkf.17.1625017171411;
        Tue, 29 Jun 2021 18:39:31 -0700 (PDT)
Received: from t490s (bras-base-toroon474qw-grc-65-184-144-111-238.dsl.bell.ca. [184.144.111.238])
        by smtp.gmail.com with ESMTPSA id e6sm8002347qkg.12.2021.06.29.18.39.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 29 Jun 2021 18:39:30 -0700 (PDT)
Date:   Tue, 29 Jun 2021 21:39:29 -0400
From:   Peter Xu <peterx@redhat.com>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Evgeniy Stepanov <eugenis@google.com>, kostyak@google.com,
        Linux-MM <linux-mm@kvack.org>, mm-commits@vger.kernel.org,
        Peter Collingbourne <pcc@google.com>
Subject: Re: [patch 128/192] mm: improve mprotect(R|W) efficiency on pages
 referenced once
Message-ID: <YNvLUbrzkM+IOJlf@t490s>
References: <20210628193256.008961950a714730751c1423@linux-foundation.org>
 <20210629023959.4ZAFiI8oZ%akpm@linux-foundation.org>
 <CAHk-=wj4KCujAH_oPh40Bkp48amM4MXr+8AcbZ=qd5LF4Q+TDg@mail.gmail.com>
 <YNu23Fu2HJhUEN5g@t490s>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <YNu23Fu2HJhUEN5g@t490s>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

On Tue, Jun 29, 2021 at 08:12:12PM -0400, Peter Xu wrote:
> On Tue, Jun 29, 2021 at 10:50:12AM -0700, Linus Torvalds wrote:
> > On Mon, Jun 28, 2021 at 7:40 PM Andrew Morton <akpm@linux-foundation.org> wrote:
> > >
> > >
> > > -                       /* Avoid taking write faults for known dirty pages */
> > > -                       if (dirty_accountable && pte_dirty(ptent) &&
> > > -                                       (pte_soft_dirty(ptent) ||
> > > -                                        !(vma->vm_flags & VM_SOFTDIRTY))) {
> > > +                       if (may_avoid_write_fault(ptent, vma, cp_flags))
> > >                                 ptent = pte_mkwrite(ptent);
> > > -                       }
> > 
> > Hmm. I don't think this is correct.
> > 
> > As fat as I can tell, may_avoid_write_fault() doesn't even check if
> > the vma is writable!
> > 
> > Am I misreading it? Because I think you just made even a shared mmap
> > with "mprotect(PROT_READ)" turn the pte's writable.
> > 
> > Which is a "slight" security issue.
> > 
> > Maybe the new code is fine, and I'm missing something. The old code
> > looks strange too, which makes me think that the MM_CP_DIRTY_ACCT test
> > ends up saving us and depend on VM_WRITE. But it's very much not
> > obvious.
> 
> vma_wants_writenotify() checks first VM_WRITE|VM_SHARED, otherwise
> MM_CP_DIRTY_ACCT will not be set.  While for anonymous vmas the newly
> introduced may_avoid_write_fault() checks VM_WRITE explicitly.

Sorry, this statement is unclear.  It's not about anonymous or not, it's just
that a hidden check against VM_WRITE is there already..

Say, below chunk of the patch:

 	if (!(cp_flags & MM_CP_DIRTY_ACCT)) {
 		/* Otherwise, we must have exclusive access to the page. */
 		if (!(vma_is_anonymous(vma) && (vma->vm_flags & VM_WRITE)))
 			return false;
 
 		if (page_count(pte_page(pte)) != 1)
 			return false;
 	}

Should be the same as:

 	if (!(cp_flags & MM_CP_DIRTY_ACCT)) {
 		if (!vma_is_anonymous(vma))
 			return false;

                if (!(vma->vm_flags & VM_WRITE))
                        return false;
 
 		if (page_count(pte_page(pte)) != 1)
 			return false;
 	}

And since MM_CP_DIRTY_ACCT implies "VM_WRITE|VM_SHARED" all set, above should
be a slightly faster version of below:

        /* This just never trigger if MM_CP_DIRTY_ACCT set */
        if (!(vma->vm_flags & VM_WRITE))
                return false;
 
 	if (!(cp_flags & MM_CP_DIRTY_ACCT)) {
 		if (!vma_is_anonymous(vma))
 			return false;

 		if (page_count(pte_page(pte)) != 1)
 			return false;
 	}

It's just that we avoid checking "vma->vm_flags & VM_WRITE" when
MM_CP_DIRTY_ACCT set.

Again, I think in all cases some more comment should be good indeed..

> 
> Agreed even if it's checked it's not straightforward.  Maybe it'll be a bonus
> to have a comment above may_avoid_write_fault() about it in a follow up.
> 
> > 
> > And even if I _am_ missing something, I really would like a very
> > obvious and direct test for "this vma is writable", ie maybe a
> > 
> >         if (!(vma->vm_flags & VM_WRITE))
> >                 return false;
> > 
> > at the very top of the function.
> 
> Yes looks okay too; I think using MM_CP_DIRTY_ACCT flag has a slight advantage
> in that it checks VM_WRITE only once before calling change_protection(), rather
> than doing the check for every pte even if we know it'll have the same result.
> However it indeed hides the facts deeper..
> 
> > 
> > And no, "pte_dirty()" is not a reason to make something writable, it
> > might have started out as a writable mapping, and we dirtied the page,
> > and we made it read-only. The page stays dirty, but it shouldn't
> > become writable just because of that.
> 
> I think the dirty bit checks are only to make sure we don't need those extra
> write faults.  It should definitely be based on the fact that VM_WRITE being
> set already.
> 
> Thanks,
> 
> -- 
> Peter Xu

-- 
Peter Xu

