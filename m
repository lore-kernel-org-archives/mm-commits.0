Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 65B1DC2BB48
	for <mm-commits@archiver.kernel.org>; Tue, 15 Dec 2020 23:59:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2D32022D02
	for <mm-commits@archiver.kernel.org>; Tue, 15 Dec 2020 23:59:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725902AbgLOX6x (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 15 Dec 2020 18:58:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40470 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731029AbgLOXQs (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 15 Dec 2020 18:16:48 -0500
Received: from mail-pj1-x1042.google.com (mail-pj1-x1042.google.com [IPv6:2607:f8b0:4864:20::1042])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 52080C061793
        for <mm-commits@vger.kernel.org>; Tue, 15 Dec 2020 15:16:30 -0800 (PST)
Received: by mail-pj1-x1042.google.com with SMTP id lb18so429397pjb.5
        for <mm-commits@vger.kernel.org>; Tue, 15 Dec 2020 15:16:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=OyvP8h6tlfvl5OvgCWRuW+T23xEkKxwciQjbYXT3ya4=;
        b=pmCs79dPbeEx3EqsjoYRrthJ8aEWw4cxuCVOWsFnS2UYR33r5Uxu9QExwMF7FQ4eAM
         1od+YjdlomNQURD+djyOOU7U+mU91lDU21xN5D70LI5xr78lXt3reYNo3m/kYtgYJ008
         B/f3j+UDsX1o6wYf1Ue4r6SqXE/zjkZ7ODN1/5Zkn+xxl82eDUgA9U8unOjJAJwcI95M
         P9TXvOsstDAXkHxteZipqnwqUb4OAZ9a9ynSaEHrEBEIWpU7nCwmJb9NpoouFFixubE0
         p/saUaztaV8o1uHQY6RaaFqURyQvn9PAmX2mgT7sOmBnw2xEBLfbmh/Rlz+Ik7AeRM2E
         BIkg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=OyvP8h6tlfvl5OvgCWRuW+T23xEkKxwciQjbYXT3ya4=;
        b=n7drM6t8l1fNzOZLpY/C0ii3ZDSQeMm8+LbkFQbajPP5WaqbKTMD4enZ34V3jipGmb
         PcCgidN5pi3BZO9iI8917wClE+7PuFkjRsAwuJXXr0FIKGNyjBGxG3iUJFdYwyg9gEIT
         KeuuR9pSkn989AI/lQOnK6YJG43gHuxX+PWG46WQmiCn5YrUppBt0bldllGXpLceblH6
         LBGWkUGh7izK+hJouDN7HhCaJyj+mujPNWmbTe8VSDWJLY9rFR4dTYdPkBM/IdvTYWG2
         Tu5jM/T4kC1WBUe+wQRLsCUzLyBU2zpenzQMQE3pRMzfjLV/zb9rfGaBoT182G2Ehbfy
         yvLQ==
X-Gm-Message-State: AOAM53295E7695eXUmNo/E4r94ct2Coi9qjYi8KrVkqokjwLtu+T780i
        S0pKVtHVrYx4/VbI/GlZmQ3bXgsJZASxw5s78vLw4w==
X-Google-Smtp-Source: ABdhPJzx0gmr0JM4THeGZksXd68WWEWbfl89nokVvEBHGrLpBqbRJN9wR60VTub+NFWlwhlZZf6FrOSVz34TWOvPni0=
X-Received: by 2002:a17:902:8e86:b029:d9:e12a:8888 with SMTP id
 bg6-20020a1709028e86b02900d9e12a8888mr29501315plb.51.1608074189580; Tue, 15
 Dec 2020 15:16:29 -0800 (PST)
MIME-Version: 1.0
References: <20201214190237.a17b70ae14f129e2dca3d204@linux-foundation.org>
 <20201215030730.NC3CU98e4%akpm@linux-foundation.org> <CAHk-=wgrnTkgP+RVV6SMr+Hv05KR0pUQxrb+-d_Wo3mKD0WeeA@mail.gmail.com>
In-Reply-To: <CAHk-=wgrnTkgP+RVV6SMr+Hv05KR0pUQxrb+-d_Wo3mKD0WeeA@mail.gmail.com>
From:   Kalesh Singh <kaleshsingh@google.com>
Date:   Tue, 15 Dec 2020 18:16:18 -0500
Message-ID: <CAC_TJvfc9OLRuB0ZDzEjjKp7pnvRjS84Nhha0NL5zZQKt9k8TA@mail.gmail.com>
Subject: Re: [patch 075/200] mm: speedup mremap on 1GB or larger regions
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        Mina Almasry <almasrymina@google.com>,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>,
        Anshuman Khandual <anshuman.khandual@arm.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Brian Geffon <bgeffon@google.com>,
        Borislav Petkov <bp@alien8.de>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Christian Brauner <christian.brauner@ubuntu.com>,
        Dave Hansen <dave.hansen@intel.com>,
        Frederic Weisbecker <frederic@kernel.org>,
        Gavin Shan <gshan@redhat.com>,
        Hassan Naveed <hnaveed@wavecomp.com>,
        Peter Anvin <hpa@zytor.com>,
        John Hubbard <jhubbard@nvidia.com>, Jia He <justin.he@arm.com>,
        Kees Cook <keescook@chromium.org>,
        "Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>,
        Krzysztof Kozlowski <krzk@kernel.org>,
        Linux-MM <linux-mm@kvack.org>, Ram Pai <linuxram@us.ibm.com>,
        kernel test robot <lkp@intel.com>,
        Lokesh Gidra <lokeshgidra@google.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Masahiro Yamada <masahiroy@kernel.org>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Minchan Kim <minchan@google.com>,
        Ingo Molnar <mingo@redhat.com>, mm-commits@vger.kernel.org,
        Peter Zijlstra <peterz@infradead.org>,
        Ralph Campbell <rcampbell@nvidia.com>,
        Mike Rapoport <rppt@kernel.org>,
        Sami Tolvanen <samitolvanen@google.com>,
        Sandipan Das <sandipan@linux.ibm.com>,
        Shuah Khan <shuah@kernel.org>,
        SeongJae Park <sjpark@amazon.de>,
        Steven Price <steven.price@arm.com>,
        Suren Baghdasaryan <surenb@google.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Will Deacon <will@kernel.org>, Zi Yan <ziy@nvidia.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

On Tue, Dec 15, 2020 at 2:59 PM Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> On Mon, Dec 14, 2020 at 7:07 PM Andrew Morton <akpm@linux-foundation.org> wrote:
> >
> > From: Kalesh Singh <kaleshsingh@google.com>
> > Subject: mm: speedup mremap on 1GB or larger regions
> >
> > Android needs to move large memory regions for garbage collection.  The GC
> > requires moving physical pages of multi-gigabyte heap using mremap.
> > During this move, the application threads have to be paused for
> > correctness.  It is critical to keep this pause as short as possible to
> > avoid jitters during user interaction.
>
> It would have been good to add a pointer to the PMD case we did earlier..
>
> Also, a few comments on the actual performance in practice would be
> nice. Does this actually *trigger* on Android in practice?
>
> I can well imagine the PMD case triggering easily, but are there
> real-life Android loads that really do gigabyte heaps? That sounds a
> bit odd to me.
>
> So I don't have any complaints about the patch, but I just wonder how
> _realistic_ this actually is, particularly the alleged 13x improvement
> in timing...
>
Hi Linus,

The new GC for Android requires moving the Java heap pages to a
separate location during a stop-the-world pause (when application
threads are paused). Once this is done, with the help of userfaultfd,
the heap can be concurrently compacted while application threads are
making progress.

Given that Android apps are highly susceptible to response time, we
need this pause to be as small as possible (not more than a few
microseconds). The dominating factor during this pause is the mremap
operation and therefore this optimization is essential.

As of today, the Java heaps on Android are up to 1GB in virtual memory
size. However, the new GC algorithm makes it multi-gigabyte. Even
though the heap consumption in terms of physical memory is not going
to be more than a few hundred MBs, the physical pages will be
scattered across the entire virtual memory range. Therefore, this
optimization will reduce the number of iterations required to finish
the mremap operation.

Example scenario:
Let's say that our heap is 8GB in virtual memory size and 128MB (a
realistic heap occupancy) in physical memory size at the time of a
mremap operation. That means we have 32K 4KB physical pages in there.

A) Worst case scenario: every 4KB physical page is mapped to a unique PMD entry
1) With only the PMD optimization the loop will make 32K iterations.
2) With the PUD optimization the loop will make 8 iterations.

B) Best case scenario: all pages are compacted in one corner of the heap, then
1) With only the PMD optimization the loop will make 64 iterations.
2) With the PUD optimization the loop will make only 1 iteration.

Even in the best case we are reducing the number of iterations by 64x.
The optimization will be useful even if not all of the virtual address
range is mapped.

Thanks,
Kalesh

>              Linus
