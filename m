Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B9F0DC7EE2E
	for <mm-commits@archiver.kernel.org>; Mon, 12 Jun 2023 20:17:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229604AbjFLUR4 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 12 Jun 2023 16:17:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48418 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229513AbjFLURz (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 12 Jun 2023 16:17:55 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 70B18DB
        for <mm-commits@vger.kernel.org>; Mon, 12 Jun 2023 13:17:54 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0C85261638
        for <mm-commits@vger.kernel.org>; Mon, 12 Jun 2023 20:17:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4FEB8C433EF;
        Mon, 12 Jun 2023 20:17:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1686601073;
        bh=a5QLtaV6K2k+ohXg4pDEIdJJhy4WsI8e7FtFIO654VE=;
        h=Date:To:From:Subject:From;
        b=EI/1/JN2/GM2Ch0ovdOhlNJQwTRGEW8B1QLql5BHZUsToovYp4CI8ogj5hpIYkU91
         xOxEGdSVOHFmSngS3pcZ4yfsVu6AkqTy5YT5REZAnEin5nK5OJnZbaGUeHB2u2ZOWe
         lKOZumZ6uiTbMY+sTwqaAmDgAnFjIhIIndit2d3k=
Date:   Mon, 12 Jun 2023 13:17:52 -0700
To:     mm-commits@vger.kernel.org, yuzhao@google.com, willy@infradead.org,
        viro@zeniv.linux.org.uk, vincenzo.frascino@arm.com,
        urezki@gmail.com, sj@kernel.org, shakeelb@google.com,
        ryabinin.a.a@gmail.com, rppt@kernel.org, roman.gushchin@linux.dev,
        pasha.tatashin@soleen.com, oleksandr_tyshchenko@epam.com,
        naoya.horiguchi@nec.com, namhyung@kernel.org,
        muchun.song@linux.dev, mike.kravetz@oracle.com, mhocko@kernel.org,
        mark.rutland@arm.com, lstoakes@gmail.com, lkp@intel.com,
        linmiaohe@huawei.com, kirill.shutemov@linux.intel.com,
        jolsa@kernel.org, jglisse@redhat.com, jgg@ziepe.ca,
        irogers@google.com, hch@infradead.org, hannes@cmpxchg.org,
        glider@google.com, dvyukov@google.com, dimitri.sivanich@hpe.com,
        daniel@ffwll.ch, brauner@kernel.org, andreyknvl@gmail.com,
        alex.williamson@redhat.com, alexander.shishkin@linux.intel.com,
        airlied@gmail.com, adrian.hunter@intel.com, ryan.roberts@arm.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-ptdump-should-use-ptep_get_lockless.patch added to mm-unstable branch
Message-Id: <20230612201753.4FEB8C433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: ptdump should use ptep_get_lockless()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-ptdump-should-use-ptep_get_lockless.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-ptdump-should-use-ptep_get_lockless.patch

This patch will later appear in the mm-unstable branch at
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
From: Ryan Roberts <ryan.roberts@arm.com>
Subject: mm: ptdump should use ptep_get_lockless()
Date: Mon, 12 Jun 2023 16:15:43 +0100

Patch series "Encapsulate PTE contents from non-arch code", v3.

A series to improve the encapsulation of pte entries by disallowing
non-arch code from directly dereferencing pte_t pointers.

This means that by default, the accesses change from a C dereference to a
READ_ONCE().  This is technically the correct thing to do since where
pgtables are modified by HW (for access/dirty) they are volatile and
therefore we should always ensure READ_ONCE() semantics.

But more importantly, by always using the helper, it can be overridden by
the architecture to fully encapsulate the contents of the pte.  Arch code
is deliberately not converted, as the arch code knows best.  It is
intended that arch code (arm64) will override the default with its own
implementation that can (e.g.) hide certain bits from the core code, or
determine young/dirty status by mixing in state from another source.


This patch (of 3):

The page table dumper uses walk_page_range_novma() to walk the page
tables, which does not lock the PTL before calling the pte_entry()
callback.  Therefore, the page table dumper's callback must use
ptep_get_lockless() rather than ptep_get() to ensure that the pte it reads
is not torn or otherwise corrupt when racing with writers.

Link: https://lkml.kernel.org/r/20230612151545.3317766-1-ryan.roberts@arm.com
Link: https://lkml.kernel.org/r/20230612151545.3317766-2-ryan.roberts@arm.com
Signed-off-by: Ryan Roberts <ryan.roberts@arm.com>
Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc: Alex Williamson <alex.williamson@redhat.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
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
Cc: Jérôme Glisse <jglisse@redhat.com>
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
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Naoya Horiguchi <naoya.horiguchi@nec.com>
Cc: Oleksandr Tyshchenko <oleksandr_tyshchenko@epam.com>
Cc: Pavel Tatashin <pasha.tatashin@soleen.com>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: SeongJae Park <sj@kernel.org>
Cc: Shakeel Butt <shakeelb@google.com>
Cc: Uladzislau Rezki (Sony) <urezki@gmail.com>
Cc: Vincenzo Frascino <vincenzo.frascino@arm.com>
Cc: Yu Zhao <yuzhao@google.com>
Cc: kernel test robot <lkp@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/ptdump.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/ptdump.c~mm-ptdump-should-use-ptep_get_lockless
+++ a/mm/ptdump.c
@@ -119,7 +119,7 @@ static int ptdump_pte_entry(pte_t *pte,
 			    unsigned long next, struct mm_walk *walk)
 {
 	struct ptdump_state *st = walk->private;
-	pte_t val = ptep_get(pte);
+	pte_t val = ptep_get_lockless(pte);
 
 	if (st->effective_prot)
 		st->effective_prot(st, 4, pte_val(val));
_

Patches currently in -mm which might be from ryan.roberts@arm.com are

mm-ptdump-should-use-ptep_get_lockless.patch
mm-move-ptep_get-and-pmdp_get-helpers.patch
mm-ptep_get-conversion.patch

