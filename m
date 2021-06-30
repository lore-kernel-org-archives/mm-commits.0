Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A4541C11F67
	for <mm-commits@archiver.kernel.org>; Wed, 30 Jun 2021 00:12:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 84B7E61D0B
	for <mm-commits@archiver.kernel.org>; Wed, 30 Jun 2021 00:12:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235548AbhF3AOq (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 29 Jun 2021 20:14:46 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:33958 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233056AbhF3AOp (ORCPT
        <rfc822;mm-commits@vger.kernel.org>);
        Tue, 29 Jun 2021 20:14:45 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1625011936;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=ZLJF9xDpvbchJ65JpLXFXZqwOW+LXIZ7K0GDx0getA0=;
        b=E0VX+qPc11XH5zv/MtXMif8DVIljOZ42f1C4pqWsYYrL5Tye+otbVoCjAeVaQYBlOR7ub0
        T2/sL282h7aI+yLFpyjfzQKlgzD6qkfBKIQlmnHcv11XPeRHcxTTwexll5oRWEwJ75FW4B
        oV+qwn8TSZWmRBX9i1Sc5oQGubtq3rQ=
Received: from mail-qt1-f198.google.com (mail-qt1-f198.google.com
 [209.85.160.198]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-108-EvCO-zPvMbmj71BXpc7V1g-1; Tue, 29 Jun 2021 20:12:15 -0400
X-MC-Unique: EvCO-zPvMbmj71BXpc7V1g-1
Received: by mail-qt1-f198.google.com with SMTP id l14-20020ac84a8e0000b0290250ca4407e3so133619qtq.0
        for <mm-commits@vger.kernel.org>; Tue, 29 Jun 2021 17:12:14 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=ZLJF9xDpvbchJ65JpLXFXZqwOW+LXIZ7K0GDx0getA0=;
        b=DcXyvSjirrXxkrIeLVfOdxR0H+jh9edIY5MdHKYKU9Kfga631eIBGto57DY37pFNcZ
         gQ4ciBuQDefiERkrKCBDrDeOorItgkoHDYOVej4o2o2PX2Glh7ql0YQ3bJ3srHwK+kLE
         tEMN938+RFU1wB5qVym+LFeFRBk+oKz21eryCOrKEM1UdpMfvYCMZYltUhRJoPQZB2+H
         VnFuvXY5OTTAcSBq6CZ/y19B31FfB7fH/Lm+QMtv0KZbt+my63QQk2NT+xd0TVxBzV8v
         aXX3T3GfoiHpikA0ifiatUXE++Xvur2mibcT8EziXfnRqERi9MMUjJHXWlfWnXsCtPD/
         qmeA==
X-Gm-Message-State: AOAM530SwkqP3qHw/nkwyHQvtSO3peZh2S+RguCRG9LVtTDonPPDal6a
        mRYXn3jmNQr9jI6+j6y93t9Q3/pAjmGA76EzLQwdjVXH+sI3qNy7UVdY5IiQHO642oHR9Gx8JVm
        EkVzMDZsbsumzGNzpdibBwA==
X-Received: by 2002:a0c:f682:: with SMTP id p2mr3415784qvn.17.1625011934669;
        Tue, 29 Jun 2021 17:12:14 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJz3Xw02u5+7/ZI8Ut6KPgtn1Xl4oTAPeAdeQy3o+QKzOzszcVMi3eGNJtTSkXmDaMpifPEpwQ==
X-Received: by 2002:a0c:f682:: with SMTP id p2mr3415768qvn.17.1625011934502;
        Tue, 29 Jun 2021 17:12:14 -0700 (PDT)
Received: from t490s (bras-base-toroon474qw-grc-65-184-144-111-238.dsl.bell.ca. [184.144.111.238])
        by smtp.gmail.com with ESMTPSA id k8sm11370228qkj.46.2021.06.29.17.12.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 29 Jun 2021 17:12:13 -0700 (PDT)
Date:   Tue, 29 Jun 2021 20:12:12 -0400
From:   Peter Xu <peterx@redhat.com>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Evgeniy Stepanov <eugenis@google.com>, kostyak@google.com,
        Linux-MM <linux-mm@kvack.org>, mm-commits@vger.kernel.org,
        Peter Collingbourne <pcc@google.com>
Subject: Re: [patch 128/192] mm: improve mprotect(R|W) efficiency on pages
 referenced once
Message-ID: <YNu23Fu2HJhUEN5g@t490s>
References: <20210628193256.008961950a714730751c1423@linux-foundation.org>
 <20210629023959.4ZAFiI8oZ%akpm@linux-foundation.org>
 <CAHk-=wj4KCujAH_oPh40Bkp48amM4MXr+8AcbZ=qd5LF4Q+TDg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CAHk-=wj4KCujAH_oPh40Bkp48amM4MXr+8AcbZ=qd5LF4Q+TDg@mail.gmail.com>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

On Tue, Jun 29, 2021 at 10:50:12AM -0700, Linus Torvalds wrote:
> On Mon, Jun 28, 2021 at 7:40 PM Andrew Morton <akpm@linux-foundation.org> wrote:
> >
> >
> > -                       /* Avoid taking write faults for known dirty pages */
> > -                       if (dirty_accountable && pte_dirty(ptent) &&
> > -                                       (pte_soft_dirty(ptent) ||
> > -                                        !(vma->vm_flags & VM_SOFTDIRTY))) {
> > +                       if (may_avoid_write_fault(ptent, vma, cp_flags))
> >                                 ptent = pte_mkwrite(ptent);
> > -                       }
> 
> Hmm. I don't think this is correct.
> 
> As fat as I can tell, may_avoid_write_fault() doesn't even check if
> the vma is writable!
> 
> Am I misreading it? Because I think you just made even a shared mmap
> with "mprotect(PROT_READ)" turn the pte's writable.
> 
> Which is a "slight" security issue.
> 
> Maybe the new code is fine, and I'm missing something. The old code
> looks strange too, which makes me think that the MM_CP_DIRTY_ACCT test
> ends up saving us and depend on VM_WRITE. But it's very much not
> obvious.

vma_wants_writenotify() checks first VM_WRITE|VM_SHARED, otherwise
MM_CP_DIRTY_ACCT will not be set.  While for anonymous vmas the newly
introduced may_avoid_write_fault() checks VM_WRITE explicitly.

Agreed even if it's checked it's not straightforward.  Maybe it'll be a bonus
to have a comment above may_avoid_write_fault() about it in a follow up.

> 
> And even if I _am_ missing something, I really would like a very
> obvious and direct test for "this vma is writable", ie maybe a
> 
>         if (!(vma->vm_flags & VM_WRITE))
>                 return false;
> 
> at the very top of the function.

Yes looks okay too; I think using MM_CP_DIRTY_ACCT flag has a slight advantage
in that it checks VM_WRITE only once before calling change_protection(), rather
than doing the check for every pte even if we know it'll have the same result.
However it indeed hides the facts deeper..

> 
> And no, "pte_dirty()" is not a reason to make something writable, it
> might have started out as a writable mapping, and we dirtied the page,
> and we made it read-only. The page stays dirty, but it shouldn't
> become writable just because of that.

I think the dirty bit checks are only to make sure we don't need those extra
write faults.  It should definitely be based on the fact that VM_WRITE being
set already.

Thanks,

-- 
Peter Xu

