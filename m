Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DB226C11F65
	for <mm-commits@archiver.kernel.org>; Tue, 29 Jun 2021 02:36:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B762361D0A
	for <mm-commits@archiver.kernel.org>; Tue, 29 Jun 2021 02:36:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231912AbhF2CjF (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 28 Jun 2021 22:39:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:59786 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231854AbhF2CjF (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 28 Jun 2021 22:39:05 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5293561D07;
        Tue, 29 Jun 2021 02:36:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1624934197;
        bh=WyaXe0aOdp3GITuCOKvGL5pSWCAOzxS2xQVLTLUGQ8M=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=R42KA3Di93ul3wHNlEupMGM/BubiougFqu9GRt30ETW4Q1ErlysFlASHuF9+6bWRd
         QzeJUuPL595mcmpDg+dYiDrnap05MHOS9XkxYtinEzJLlezqh3B3dtV0/78Ei1lnCi
         V20y9dmTmUrPEeCrqaafqE0+XhD3ocw5RJwzV7S8=
Date:   Mon, 28 Jun 2021 19:36:36 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     aarcange@redhat.com, akpm@linux-foundation.org, hughd@google.com,
        jack@suse.cz, jannh@google.com, jgg@nvidia.com,
        jhubbard@nvidia.com, kirill@shutemov.name, ktkhai@virtuozzo.com,
        linux-mm@kvack.org, mhocko@suse.com, mm-commits@vger.kernel.org,
        oleg@redhat.com, peterx@redhat.com, torvalds@linux-foundation.org,
        willy@infradead.org
Subject:  [patch 064/192] mm: gup: allow FOLL_PIN to scale in SMP
Message-ID: <20210629023636.D4uJabEva%akpm@linux-foundation.org>
In-Reply-To: <20210628193256.008961950a714730751c1423@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Andrea Arcangeli <aarcange@redhat.com>
Subject: mm: gup: allow FOLL_PIN to scale in SMP

has_pinned cannot be written by each pin-fast or it won't scale in SMP. 
This isn't "false sharing" strictly speaking (it's more like "true
non-sharing"), but it creates the same SMP scalability bottleneck of
"false sharing".

To verify the improvement, below test is done on 40 cpus host with
Intel(R) Xeon(R) CPU E5-2630 v4 @ 2.20GHz (must be with
CONFIG_GUP_TEST=y):

  $ sudo chrt -f 1 ./gup_test -a  -m 512 -j 40

Where we can get (average value for 40 threads):

  Old kernel: 477729.97 (+- 3.79%)
  New kernel:  89144.65 (+-11.76%)

On a similar condition with 256 cpus, this commits increases the SMP
scalability of pin_user_pages_fast() executed by different threads of the
same process by more than 4000%.

[peterx@redhat.com: rewrite commit message, add parentheses against "(A & B)"]
Link: https://lkml.kernel.org/r/20210507150553.208763-3-peterx@redhat.com
Signed-off-by: Andrea Arcangeli <aarcange@redhat.com>
Signed-off-by: Peter Xu <peterx@redhat.com>
Reviewed-by: John Hubbard <jhubbard@nvidia.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Jan Kara <jack@suse.cz>
Cc: Jann Horn <jannh@google.com>
Cc: Jason Gunthorpe <jgg@nvidia.com>
Cc: Kirill Shutemov <kirill@shutemov.name>
Cc: Kirill Tkhai <ktkhai@virtuozzo.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Oleg Nesterov <oleg@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/gup.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/mm/gup.c~mm-gup-allow-foll_pin-to-scale-in-smp
+++ a/mm/gup.c
@@ -1320,7 +1320,7 @@ static __always_inline long __get_user_p
 		BUG_ON(*locked != 1);
 	}
 
-	if (flags & FOLL_PIN)
+	if ((flags & FOLL_PIN) && !atomic_read(&mm->has_pinned))
 		atomic_set(&mm->has_pinned, 1);
 
 	/*
@@ -2641,7 +2641,7 @@ static int internal_get_user_pages_fast(
 				       FOLL_FAST_ONLY)))
 		return -EINVAL;
 
-	if (gup_flags & FOLL_PIN)
+	if ((gup_flags & FOLL_PIN) && !atomic_read(&current->mm->has_pinned))
 		atomic_set(&current->mm->has_pinned, 1);
 
 	if (!(gup_flags & FOLL_FAST_ONLY))
_
