Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-28.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4357FC4708F
	for <mm-commits@archiver.kernel.org>; Tue,  1 Jun 2021 19:02:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 21E6C6135D
	for <mm-commits@archiver.kernel.org>; Tue,  1 Jun 2021 19:02:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234656AbhFATE0 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 1 Jun 2021 15:04:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60482 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234539AbhFATEZ (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 1 Jun 2021 15:04:25 -0400
Received: from mail-io1-xd29.google.com (mail-io1-xd29.google.com [IPv6:2607:f8b0:4864:20::d29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 15631C061574
        for <mm-commits@vger.kernel.org>; Tue,  1 Jun 2021 12:02:44 -0700 (PDT)
Received: by mail-io1-xd29.google.com with SMTP id a8so16489975ioa.12
        for <mm-commits@vger.kernel.org>; Tue, 01 Jun 2021 12:02:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=KSrzStVdq7z5oM12WrUXHNnxUNLFdey+FnTKldaVnc4=;
        b=suopVZNzsdEmYaQ7A1IbzjNceUznpDEn7vQTRFiAPiBTsA4FmnHDg0O6og3cV1Baeo
         1zjhvkNIM2ubmkg7hQy5aStW+HDfFvoMQABPEYyHjRX3IowiSP8ERT1eeki6+cnQSOFj
         PJpHQCdu5EGwBORQ3k++3JXAa80tIf7N+z05R/p2bpH9e7UPpnZ/AWiWr+qeKANvaJgM
         327ZqZFftb/uRaXcYMSb59P3+6h0NelVw4L6xcLX3fAt1bY47B07wV6tSd0tn4UuWTYf
         UUBRXy36B9kUd/995IoNbEnIw8ATDX1QdFHph5QS+nsz2Beni/EQLp0UtVmf8Pf9BAWF
         oNiA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=KSrzStVdq7z5oM12WrUXHNnxUNLFdey+FnTKldaVnc4=;
        b=KBseL33jbfAz2hnk8bAw7GtOyAzPrcVVp1gZnCc6U/QSl0Qf64NUzxht5RjzZCiV27
         TiRK18XzSDHZX3zqcqxsg5N3foUE91qUT8a6nyTx6Qo2hJUdD/cOtS58uwHtMbRL3sAO
         uL4EEwCOBzEfP7JIqVX36bYAT0Z1EKVGSZH4wm1FV+DMturapN1+FzDteRucwn7gvdyY
         fNmgESOrR01bpsKWCWQ/VQe//oZgGWfKkldwuHYI3IHZvz1D5tIR7DQawwbc11AJU3Mo
         7Go8yUJa14BJ9olbEE+g81GPoT/1OY4qUClPjFFlIHB4CAPgp1OJlc6/DFcanXxYYrui
         2eSg==
X-Gm-Message-State: AOAM530cdXiUP8ERY//ia6FAyX5tkw4C99kLFW0zi3d+jGepBj0ozMDy
        rw9XlR1tVMz6WkQ+emWnJr9RV1HdfJF6WPGokmWwGg==
X-Google-Smtp-Source: ABdhPJzEcKOQsEhdYQmNnZOHu7msfbUoDv3/RN1FdeXSw4rQwNqa99wRm0SmaHVs8Plxm50QLEANgKjZfLlOgXeVBAo=
X-Received: by 2002:a5e:8d16:: with SMTP id m22mr1689085ioj.139.1622574163113;
 Tue, 01 Jun 2021 12:02:43 -0700 (PDT)
MIME-Version: 1.0
References: <20210601004009.GHBJsNnLk%akpm@linux-foundation.org> <YLWE9q/I/ltB41vI@t490s>
In-Reply-To: <YLWE9q/I/ltB41vI@t490s>
From:   Peter Collingbourne <pcc@google.com>
Date:   Tue, 1 Jun 2021 12:02:31 -0700
Message-ID: <CAMn1gO4gBeB3DhXi6WQMwGFxEGbO+B8SBiuwt-YPTMx74LPtYg@mail.gmail.com>
Subject: Re: + mm-improve-mprotectrw-efficiency-on-pages-referenced-once.patch
 added to -mm tree
To:     Peter Xu <peterx@redhat.com>
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Evgenii Stepanov <eugenis@google.com>,
        Kostya Kortchinsky <kostyak@google.com>,
        mm-commits@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

On Mon, May 31, 2021 at 5:53 PM Peter Xu <peterx@redhat.com> wrote:
>
> On Mon, May 31, 2021 at 05:40:09PM -0700, akpm@linux-foundation.org wrote:
> >
> > The patch titled
> >      Subject: mm: improve mprotect(R|W) efficiency on pages referenced once
> > has been added to the -mm tree.  Its filename is
> >      mm-improve-mprotectrw-efficiency-on-pages-referenced-once.patch
> >
> > This patch should soon appear at
> >     https://ozlabs.org/~akpm/mmots/broken-out/mm-improve-mprotectrw-efficiency-on-pages-referenced-once.patch
> > and later at
> >     https://ozlabs.org/~akpm/mmotm/broken-out/mm-improve-mprotectrw-efficiency-on-pages-referenced-once.patch
> >
> > Before you just go and hit "reply", please:
> >    a) Consider who else should be cc'ed
> >    b) Prefer to cc a suitable mailing list as well
> >    c) Ideally: find the original patch on the mailing list and do a
> >       reply-to-all to that, adding suitable additional cc's
> >
> > *** Remember to use Documentation/process/submit-checklist.rst when testing your code ***
> >
> > The -mm tree is included into linux-next and is updated
> > there every 3-4 working days
> >
> > ------------------------------------------------------
> > From: Peter Collingbourne <pcc@google.com>
> > Subject: mm: improve mprotect(R|W) efficiency on pages referenced once
> >
> > In the Scudo memory allocator [1] we would like to be able to detect
> > use-after-free vulnerabilities involving large allocations by issuing
> > mprotect(PROT_NONE) on the memory region used for the allocation when it
> > is deallocated.  Later on, after the memory region has been "quarantined"
> > for a sufficient period of time we would like to be able to use it for
> > another allocation by issuing mprotect(PROT_READ|PROT_WRITE).
> >
> > Before this patch, after removing the write protection, any writes to the
> > memory region would result in page faults and entering the copy-on-write
> > code path, even in the usual case where the pages are only referenced by a
> > single PTE, harming performance unnecessarily.  Make it so that any pages
> > in anonymous mappings that are only referenced by a single PTE are
> > immediately made writable during the mprotect so that we can avoid the
> > page faults.
> >
> > This program shows the critical syscall sequence that we intend to use in
> > the allocator:
> >
> >   #include <string.h>
> >   #include <sys/mman.h>
> >
> >   enum { kSize = 131072 };
> >
> >   int main(int argc, char **argv) {
> >     char *addr = (char *)mmap(0, kSize, PROT_READ | PROT_WRITE,
> >                               MAP_ANONYMOUS | MAP_PRIVATE, -1, 0);
> >     for (int i = 0; i != 100000; ++i) {
> >       memset(addr, i, kSize);
> >       mprotect((void *)addr, kSize, PROT_NONE);
> >       mprotect((void *)addr, kSize, PROT_READ | PROT_WRITE);
> >     }
> >   }
> >
> > The effect of this patch on the above program was measured on a
> > DragonBoard 845c by taking the median real time execution time of 10 runs.
> >
> > Before: 2.94s
> > After:  0.66s
> >
> > The effect was also measured using one of the microbenchmarks that we
> > normally use to benchmark the allocator [2], after modifying it to make
> > the appropriate mprotect calls [3].  With an allocation size of 131072
> > bytes to trigger the allocator's "large allocation" code path the
> > per-iteration time was measured as follows:
> >
> > Before: 27450ns
> > After:   6010ns
> >
> > This patch means that we do more work during the mprotect call itself in
> > exchange for less work when the pages are accessed.  In the worst case,
> > the pages are not accessed at all.  The effect of this patch in such cases
> > was measured using the following program:
> >
> >   #include <string.h>
> >   #include <sys/mman.h>
> >
> >   enum { kSize = 131072 };
> >
> >   int main(int argc, char **argv) {
> >     char *addr = (char *)mmap(0, kSize, PROT_READ | PROT_WRITE,
> >                               MAP_ANONYMOUS | MAP_PRIVATE, -1, 0);
> >     memset(addr, 1, kSize);
> >     for (int i = 0; i != 100000; ++i) {
> >   #ifdef PAGE_FAULT
> >       memset(addr + (i * 4096) % kSize, i, 4096);
> >   #endif
> >       mprotect((void *)addr, kSize, PROT_NONE);
> >       mprotect((void *)addr, kSize, PROT_READ | PROT_WRITE);
> >     }
> >   }
> >
> > With PAGE_FAULT undefined (0 pages touched after removing write
> > protection) the median real time execution time of 100 runs was measured
> > as follows:
> >
> > Before: 0.330260s
> > After:  0.338836s
> >
> > With PAGE_FAULT defined (1 page touched) the measurements were
> > as follows:
> >
> > Before: 0.438048s
> > After:  0.355661s
> >
> > So it seems that even with a single page fault the new approach is faster.
> >
> > I saw similar results if I adjusted the programs to use a larger mapping
> > size.  With kSize = 1048576 I get these numbers with PAGE_FAULT undefined:
> >
> > Before: 1.428988s
> > After:  1.512016s
> >
> > i.e. around 5.5%.
> >
> > And these with PAGE_FAULT defined:
> >
> > Before: 1.518559s
> > After:  1.524417s
> >
> > i.e. about the same.
> >
> > What I think we may conclude from these results is that for smaller
> > mappings the advantage of the previous approach, although measurable, is
> > wiped out by a single page fault.  I think we may expect that there should
> > be at least one access resulting in a page fault (under the previous
> > approach) after making the pages writable, since the program presumably
> > made the pages writable for a reason.
> >
> > For larger mappings we may guesstimate that the new approach wins if the
> > density of future page faults is > 0.4%.  But for the mappings that are
> > large enough for density to matter (not just the absolute number of page
> > faults) it doesn't seem like the increase in mprotect latency would be
> > very large relative to the total mprotect execution time.
> >
> > Link: https://lkml.kernel.org/r/20210527190453.1259020-1-pcc@google.com
> > Link: https://linux-review.googlesource.com/id/I98d75ef90e20330c578871c87494d64b1df3f1b8
> > Link: [1] https://source.android.com/devices/tech/debug/scudo
> > Link: [2] https://cs.android.com/android/platform/superproject/+/master:bionic/benchmarks/stdlib_benchmark.cpp;l=53;drc=e8693e78711e8f45ccd2b610e4dbe0b94d551cc9
> > Link: [3] https://github.com/pcc/llvm-project/commit/scudo-mprotect-secondary2
> > Signed-off-by: Peter Collingbourne <pcc@google.com>
> > Reviewed-by: Peter Xu <peterx@redhat.com>
> > Cc: Kostya Kortchinsky <kostyak@google.com>
> > Cc: Evgenii Stepanov <eugenis@google.com>
> > Cc: Andrea Arcangeli <aarcange@redhat.com>
> > Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> > ---
> >
> >  mm/mprotect.c |   29 ++++++++++++++++++++++++-----
> >  1 file changed, 24 insertions(+), 5 deletions(-)
> >
> > --- a/mm/mprotect.c~mm-improve-mprotectrw-efficiency-on-pages-referenced-once
> > +++ a/mm/mprotect.c
> > @@ -35,6 +35,29 @@
> >
> >  #include "internal.h"
> >
> > +static bool may_avoid_write_fault(pte_t pte, struct vm_area_struct *vma,
> > +                               unsigned long cp_flags)
> > +{
>
> Andrew,
>
> As raised in the original patch, IMHO we'd better add below:
>
>         if (cp_flags & MM_CP_PROT_NUMA)
>                 return false;
>
> Peter Collingbourne, could you confirm?

Done in v5, and added some comments as requested by Andrew on the other thread.

Peter
