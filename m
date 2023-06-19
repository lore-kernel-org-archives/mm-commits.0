Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6F586EB64D9
	for <mm-commits@archiver.kernel.org>; Mon, 19 Jun 2023 23:25:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229916AbjFSXZH (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 19 Jun 2023 19:25:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44550 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229905AbjFSXXZ (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 19 Jun 2023 19:23:25 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 203DE173F
        for <mm-commits@vger.kernel.org>; Mon, 19 Jun 2023 16:22:40 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B23DA60FBB
        for <mm-commits@vger.kernel.org>; Mon, 19 Jun 2023 23:22:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF2EAC433C0;
        Mon, 19 Jun 2023 23:22:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1687216959;
        bh=7ECVItypCNgA1MufX8QVNID+yYppryIFcN5lTGO8Xrc=;
        h=Date:To:From:Subject:From;
        b=fD0npGWO7z35fOTBIwVW09RSusUZtoHCP4IkjfJVAjJ1UZBvrPzUCp2Equ0iIcAWq
         1ULOwantcUl1//vg95WWtbmR8n7I7pP3eOp6+UI/Iz6HxsN1RqPhdjkuFR4kDdXnGA
         x9TB/BIlL5t1DCNdVvwhnV27ryjb6NKJcKFuD1HQ=
Date:   Mon, 19 Jun 2023 16:22:38 -0700
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
Subject: [merged mm-stable] mm-ptdump-should-use-ptep_get_lockless.patch removed from -mm tree
Message-Id: <20230619232238.EF2EAC433C0@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: ptdump should use ptep_get_lockless()
has been removed from the -mm tree.  Its filename was
     mm-ptdump-should-use-ptep_get_lockless.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


