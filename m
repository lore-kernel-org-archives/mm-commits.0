Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9280FC433EF
	for <mm-commits@archiver.kernel.org>; Fri, 15 Apr 2022 22:42:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240535AbiDOWof (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 15 Apr 2022 18:44:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52860 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231616AbiDOWoe (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 15 Apr 2022 18:44:34 -0400
Received: from mail-oi1-x233.google.com (mail-oi1-x233.google.com [IPv6:2607:f8b0:4864:20::233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D7BDF9D0C8
        for <mm-commits@vger.kernel.org>; Fri, 15 Apr 2022 15:42:04 -0700 (PDT)
Received: by mail-oi1-x233.google.com with SMTP id bj24so4036135oib.11
        for <mm-commits@vger.kernel.org>; Fri, 15 Apr 2022 15:42:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:in-reply-to:message-id:references
         :mime-version;
        bh=zzQ5OGU3mS5ke4yAsRMiQLKwP6SfvwC1RfiRbaV+kCY=;
        b=QhBkd+IG+TstRMxMJL2/AnySZdWBatoirUPZtoV9uSNPiivK4/0H4GHHt6vMOA4kjH
         ItjPCnmhPCeB3b+AeeRS6Q9WDwUsQhqIT2m9kWcbczhoY/e6ZJ2h7u52KQx4z1TWgESH
         EePD38J1ZLRzvdBNz3zfXnevfoNRWNvKbL6ehgJuXER2BGGQeCIdKxK6rBaVSuXqfDsD
         XcgUvExIa9WkiOL15P7qZBhsQao5nkYdhY4hQ41jRKm/SD1lCIvJj9v5FyCplZA2WCFL
         5PL80XJ6TTNq0Ut2onCqSMmtO34Ik83z95/NzSaMNUiNnSMtRMO6C0IAiTXR83aMqwW0
         viLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:in-reply-to:message-id
         :references:mime-version;
        bh=zzQ5OGU3mS5ke4yAsRMiQLKwP6SfvwC1RfiRbaV+kCY=;
        b=DVsdu1KNRZKSQ1+gYQxFgkAPBBt81CkIRdbQqhqURwe4LZiFknqv0avxyP5MNFnluG
         /ja2riUMJl3+A3GUWg46ilj1WCzwOd6R8StC6iuqZRZn45B/WIBR6584pZ3qs6SjCn5b
         jLYjUn2n2adwnnlB63mzo/xeOODhZrUXtE8cR8+d9RDDmQKqGkiC9IV4PqU8JkMXnGq0
         +WFkCZXWDXeVIkp9Vygn2XzOfacmlHAwauqvQ+5/QuezxZM/Fh4eaPgfjxTI0LpHNEz4
         xOM1mxjNDwnamt1dAao6MP36L7XGbeZYo7HvAPHq6Vk/weu7Gk4d3wIvh5RWum7pxb5H
         52sQ==
X-Gm-Message-State: AOAM530DrAETMF8OsDerJ1RPaI264zk08z5tFoanR3YhfzoOQ3vBXrqn
        L9B/kOrmSqbR8ijMDoX69VnitQ==
X-Google-Smtp-Source: ABdhPJwi1+AXwSRrwRoX9RMryDXgxQPHmniXCrdm/+8AjHGX5hvGxaBxq/gRn0uuMl0nhjpFKjkMSg==
X-Received: by 2002:a05:6808:1828:b0:322:4891:8832 with SMTP id bh40-20020a056808182800b0032248918832mr1593488oib.172.1650062524051;
        Fri, 15 Apr 2022 15:42:04 -0700 (PDT)
Received: from ripple.attlocal.net (172-10-233-147.lightspeed.sntcca.sbcglobal.net. [172.10.233.147])
        by smtp.gmail.com with ESMTPSA id l19-20020a05687040d300b000e2f6d3afd1sm1965831oal.19.2022.04.15.15.42.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 Apr 2022 15:42:03 -0700 (PDT)
Date:   Fri, 15 Apr 2022 15:41:49 -0700 (PDT)
From:   Hugh Dickins <hughd@google.com>
X-X-Sender: hugh@ripple.attlocal.net
To:     Linus Torvalds <torvalds@linux-foundation.org>
cc:     Andrew Morton <akpm@linux-foundation.org>,
        the arch/x86 maintainers <x86@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Borislav Petkov <bp@suse.de>, patrice.chotard@foss.st.com,
        Mikulas Patocka <mpatocka@redhat.com>, markhemm@googlemail.com,
        Lukas Czerner <lczerner@redhat.com>,
        Christoph Hellwig <hch@lst.de>,
        "Darrick J. Wong" <djwong@kernel.org>,
        Chuck Lever <chuck.lever@oracle.com>,
        Hugh Dickins <hughd@google.com>, patches@lists.linux.dev,
        Linux-MM <linux-mm@kvack.org>, mm-commits@vger.kernel.org
Subject: Re: [patch 02/14] tmpfs: fix regressions from wider use of
 ZERO_PAGE
In-Reply-To: <CAHk-=wh=Mu_EYhtOmPn6AxoQZyEh-4fo2Zx3G7rBv1g7vwoKiw@mail.gmail.com>
Message-ID: <c1cf1bf-8d90-a2-87ec-9bb9a93cc6c@google.com>
References: <20220414191240.9f86d15a3e3afd848a9839a6@linux-foundation.org> <20220415021328.7D31EC385A1@smtp.kernel.org> <CAHk-=wh=Mu_EYhtOmPn6AxoQZyEh-4fo2Zx3G7rBv1g7vwoKiw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

On Fri, 15 Apr 2022, Linus Torvalds wrote:
> On Thu, Apr 14, 2022 at 7:13 PM Andrew Morton <akpm@linux-foundation.org> wrote:
> >
> > Revert shmem_file_read_iter() to using ZERO_PAGE for holes only when
> > iter_is_iovec(); in other cases, use the more natural iov_iter_zero()
> > instead of copy_page_to_iter().  We would use iov_iter_zero() throughout,
> > but the x86 clear_user() is not nearly so well optimized as copy to user
> > (dd of 1T sparse tmpfs file takes 57 seconds rather than 44 seconds).
> 
> Ugh.
> 
> I've applied this patch,

Phew, thanks.

> but honestly, the proper course of action
> should just be to improve on clear_user().

You'll find no disagreement here: we've all been saying the same.
It's just that that work is yet to be done (or yet to be accepted).

> 
> If it really is important enough that we should care about that
> performance, then we just should fix clear_user().
> 
> It's a very odd special thing right now (at least on x86-64) using
> some strange handcrafted inline asm code.
> 
> I assume that 'rep stosb' is the fastest way to clear things on modern
> CPU's that have FSRM, and then we have the usual fallbacks (ie ERMS ->
> "rep stos" except for small areas, and probably that "store zeros by
> hand" for older CPUs).
> 
> Adding PeterZ and Borislav (who seem to be the last ones to have
> worked on the copy and clear_page stuff respectively) and the x86
> maintainers in case somebody gets the urge to just fix this.

Yes, it was exactly Borislav and PeterZ whom I first approached too,
link 3 in the commit message of the patch that this one is fixing,
https://lore.kernel.org/lkml/2f5ca5e4-e250-a41c-11fb-a7f4ebc7e1c9@google.com/

Borislav wants a thorough good patch, and I don't blame him for that!

Hugh

> 
> Because memory clearing should be faster than copying, and the thing
> that makes copying fast is that FSRM and ERMS logic (the whole
> "manually unrolled copy" is hopefully mostly a thing of the past and
> we can consider it legacy)
> 
>              Linus
