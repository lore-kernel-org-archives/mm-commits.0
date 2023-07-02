Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E8723EB64DD
	for <mm-commits@archiver.kernel.org>; Sun,  2 Jul 2023 17:45:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229638AbjGBRp0 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 2 Jul 2023 13:45:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42792 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229679AbjGBRpZ (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 2 Jul 2023 13:45:25 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5423B183
        for <mm-commits@vger.kernel.org>; Sun,  2 Jul 2023 10:45:24 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E56EB60BEB
        for <mm-commits@vger.kernel.org>; Sun,  2 Jul 2023 17:45:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 420E9C433C8;
        Sun,  2 Jul 2023 17:45:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1688319923;
        bh=NoV9A9m0edzYILVF8gqauYyo5jOQWQxjHTNnuYqwQhQ=;
        h=Date:To:From:Subject:From;
        b=kWy8aR5dPqacvhkJt1713dD4e/mxxbrxwkcnG4XVJakSLOa/OlNsyxLeQha3rYAeD
         unm0kD8zLhonk07UZ/L/z7igwnULs3QzdRDVkh99pwO8BVINbhAS00dd9vuKhsxYsR
         R5ZKMQoE9/lQK0qQ2SqJQG7GuoKDI7x0UGig0uLA=
Date:   Sun, 02 Jul 2023 10:45:22 -0700
To:     mm-commits@vger.kernel.org, yuzhao@google.com, willy@infradead.org,
        viro@zeniv.linux.org.uk, vincenzo.frascino@arm.com,
        urezki@gmail.com, songmuchun@bytedance.com, sj@kernel.org,
        shakeelb@google.com, ryan.roberts@arm.com, ryabinin.a.a@gmail.com,
        rppt@kernel.org, roman.gushchin@linux.dev,
        pasha.tatashin@soleen.com, oleksandr_tyshchenko@epam.com,
        naoya.horiguchi@nec.com, namhyung@kernel.org,
        mike.kravetz@oracle.com, mhocko@kernel.org, mark.rutland@arm.com,
        lstoakes@gmail.com, linmiaohe@huawei.com,
        kirill.shutemov@linux.intel.com, jthoughton@google.com,
        jolsa@kernel.org, jgg@ziepe.ca, irogers@google.com,
        hch@infradead.org, hannes@cmpxchg.org, glider@google.com,
        dvyukov@google.com, dimitri.sivanich@hpe.com, daniel@ffwll.ch,
        brauner@kernel.org, andreyknvl@gmail.com,
        alex.williamson@redhat.com, alexander.shishkin@linux.intel.com,
        airlied@gmail.com, adrian.hunter@intel.com, jhubbard@nvidia.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-hugetlbc-fix-a-bug-within-a-bug-inconsistent-pte-comparison.patch added to mm-hotfixes-unstable branch
Message-Id: <20230702174523.420E9C433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/hugetlb.c: fix a bug within a BUG(): inconsistent pte comparison
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-hugetlbc-fix-a-bug-within-a-bug-inconsistent-pte-comparison.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-hugetlbc-fix-a-bug-within-a-bug-inconsistent-pte-comparison.patch

This patch will later appear in the mm-hotfixes-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: John Hubbard <jhubbard@nvidia.com>
Subject: mm/hugetlb.c: fix a bug within a BUG(): inconsistent pte comparison
Date: Fri, 30 Jun 2023 18:04:42 -0700

The following crash happens for me when running the -mm selftests (below).
Specifically, it happens while running the uffd-stress subtests:

kernel BUG at mm/hugetlb.c:7249!
invalid opcode: 0000 [#1] PREEMPT SMP NOPTI
CPU: 0 PID: 3238 Comm: uffd-stress Not tainted 6.4.0-hubbard-github+ #109
Hardware name: ASUS X299-A/PRIME X299-A, BIOS 1503 08/03/2018
RIP: 0010:huge_pte_alloc+0x12c/0x1a0
...
Call Trace:
 <TASK>
 ? __die_body+0x63/0xb0
 ? die+0x9f/0xc0
 ? do_trap+0xab/0x180
 ? huge_pte_alloc+0x12c/0x1a0
 ? do_error_trap+0xc6/0x110
 ? huge_pte_alloc+0x12c/0x1a0
 ? handle_invalid_op+0x2c/0x40
 ? huge_pte_alloc+0x12c/0x1a0
 ? exc_invalid_op+0x33/0x50
 ? asm_exc_invalid_op+0x16/0x20
 ? __pfx_put_prev_task_idle+0x10/0x10
 ? huge_pte_alloc+0x12c/0x1a0
 hugetlb_fault+0x1a3/0x1120
 ? finish_task_switch+0xb3/0x2a0
 ? lock_is_held_type+0xdb/0x150
 handle_mm_fault+0xb8a/0xd40
 ? find_vma+0x5d/0xa0
 do_user_addr_fault+0x257/0x5d0
 exc_page_fault+0x7b/0x1f0
 asm_exc_page_fault+0x22/0x30

That happens because a BUG() statement in huge_pte_alloc() attempts to
check that a pte, if present, is a hugetlb pte, but it does so in a
non-lockless-safe manner that leads to a false BUG() report.

We got here due to a couple of bugs, each of which by itself was not quite
enough to cause a problem:

First of all, before commit c33c794828f2("mm: ptep_get() conversion"), the
BUG() statement in huge_pte_alloc() was itself fragile: it relied upon
compiler behavior to only read the pte once, despite using it twice in the
same conditional.

Next, commit c33c794828f2 ("mm: ptep_get() conversion") broke that
delicate situation, by causing all direct pte reads to be done via
READ_ONCE().  And so READ_ONCE() got called twice within the same BUG()
conditional, leading to comparing (potentially, occasionally) different
versions of the pte, and thus to false BUG() reports.

Fix this by taking a single snapshot of the pte before using it in the
BUG conditional.

Now, that commit is only partially to blame here but, people doing
bisections will invariably land there, so this will help them find a fix
for a real crash.  And also, the previous behavior was unlikely to ever
expose this bug--it was fragile, yet not actually broken.

So that's why I chose this commit for the Fixes tag, rather than the
commit that created the original BUG() statement.

Link: https://lkml.kernel.org/r/20230701010442.2041858-1-jhubbard@nvidia.com
Fixes: c33c794828f2 ("mm: ptep_get() conversion")
Signed-off-by: John Hubbard <jhubbard@nvidia.com>
Acked-by: James Houghton <jthoughton@google.com>
Acked-by: Muchun Song <songmuchun@bytedance.com>
Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Alex Williamson <alex.williamson@redhat.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc: Andrey Konovalov <andreyknvl@gmail.com>
Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Cc: Christian Brauner <brauner@kernel.org>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Daniel Vetter <daniel@ffwll.ch>
Cc: Dave Airlie <airlied@gmail.com>
Cc: Dimitri Sivanich <dimitri.sivanich@hpe.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Ian Rogers <irogers@google.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Jiri Olsa <jolsa@kernel.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Lorenzo Stoakes <lstoakes@gmail.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Mike Rapoport (IBM) <rppt@kernel.org>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Naoya Horiguchi <naoya.horiguchi@nec.com>
Cc: Oleksandr Tyshchenko <oleksandr_tyshchenko@epam.com>
Cc: Pavel Tatashin <pasha.tatashin@soleen.com>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: SeongJae Park <sj@kernel.org>
Cc: Shakeel Butt <shakeelb@google.com>
Cc: Uladzislau Rezki (Sony) <urezki@gmail.com>
Cc: Vincenzo Frascino <vincenzo.frascino@arm.com>
Cc: Yu Zhao <yuzhao@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

--- a/mm/hugetlb.c~mm-hugetlbc-fix-a-bug-within-a-bug-inconsistent-pte-comparison
+++ a/mm/hugetlb.c
@@ -7246,7 +7246,12 @@ pte_t *huge_pte_alloc(struct mm_struct *
 				pte = (pte_t *)pmd_alloc(mm, pud, addr);
 		}
 	}
-	BUG_ON(pte && pte_present(ptep_get(pte)) && !pte_huge(ptep_get(pte)));
+
+	if (pte) {
+		pte_t pteval = ptep_get_lockless(pte);
+
+		BUG_ON(pte_present(pteval) && !pte_huge(pteval));
+	}
 
 	return pte;
 }
_

Patches currently in -mm which might be from jhubbard@nvidia.com are

mm-hugetlbc-fix-a-bug-within-a-bug-inconsistent-pte-comparison.patch

