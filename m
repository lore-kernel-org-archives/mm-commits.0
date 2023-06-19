Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CD8D9EB64DB
	for <mm-commits@archiver.kernel.org>; Mon, 19 Jun 2023 23:25:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229905AbjFSXZI (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 19 Jun 2023 19:25:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44062 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229956AbjFSXX2 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 19 Jun 2023 19:23:28 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7468A1982
        for <mm-commits@vger.kernel.org>; Mon, 19 Jun 2023 16:22:41 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 127B760FDB
        for <mm-commits@vger.kernel.org>; Mon, 19 Jun 2023 23:22:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 629C2C433C8;
        Mon, 19 Jun 2023 23:22:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1687216960;
        bh=2MiNvflO3qLgF1Fdr/jKDh+JoGcMI2cgeCAkJksQB4U=;
        h=Date:To:From:Subject:From;
        b=GOei2EqeQF14szHH9+jKfp8M4IPQB3Z6uMdvMfRN022cABejn+v+m7LrNscpllI3f
         a3hMfc+4TdvdwxEnnirCMuL+ZWUBEvBgoWMfQKptyu8iXI+O2STTI05BDUrYh/QO5n
         b9RWEg0fMNe5egCCr9sX3y2TN7I3ZfvSxfvBh8X0=
Date:   Mon, 19 Jun 2023 16:22:39 -0700
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
Subject: [merged mm-stable] mm-move-ptep_get-and-pmdp_get-helpers.patch removed from -mm tree
Message-Id: <20230619232240.629C2C433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: move ptep_get() and pmdp_get() helpers
has been removed from the -mm tree.  Its filename was
     mm-move-ptep_get-and-pmdp_get-helpers.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Ryan Roberts <ryan.roberts@arm.com>
Subject: mm: move ptep_get() and pmdp_get() helpers
Date: Mon, 12 Jun 2023 16:15:44 +0100

There are many call sites that directly dereference a pte_t pointer.  This
makes it very difficult to properly encapsulate a page table in the arch
code without having to allocate shadow page tables.

We will shortly solve this by replacing all the call sites with ptep_get()
calls.  But there are call sites above the function definition in the
header file, so let's move ptep_get() to an earlier location to solve that
problem.  And move pmdp_get() at the same time to keep it close to
ptep_get().

Link: https://lkml.kernel.org/r/20230612151545.3317766-3-ryan.roberts@arm.com
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
Cc: kernel test robot <lkp@intel.com>
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
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/pgtable.h |   28 ++++++++++++++--------------
 1 file changed, 14 insertions(+), 14 deletions(-)

--- a/include/linux/pgtable.h~mm-move-ptep_get-and-pmdp_get-helpers
+++ a/include/linux/pgtable.h
@@ -212,6 +212,20 @@ static inline int pudp_set_access_flags(
 #endif /* CONFIG_TRANSPARENT_HUGEPAGE */
 #endif
 
+#ifndef ptep_get
+static inline pte_t ptep_get(pte_t *ptep)
+{
+	return READ_ONCE(*ptep);
+}
+#endif
+
+#ifndef pmdp_get
+static inline pmd_t pmdp_get(pmd_t *pmdp)
+{
+	return READ_ONCE(*pmdp);
+}
+#endif
+
 #ifndef __HAVE_ARCH_PTEP_TEST_AND_CLEAR_YOUNG
 static inline int ptep_test_and_clear_young(struct vm_area_struct *vma,
 					    unsigned long address,
@@ -317,20 +331,6 @@ static inline void ptep_clear(struct mm_
 	ptep_get_and_clear(mm, addr, ptep);
 }
 
-#ifndef ptep_get
-static inline pte_t ptep_get(pte_t *ptep)
-{
-	return READ_ONCE(*ptep);
-}
-#endif
-
-#ifndef pmdp_get
-static inline pmd_t pmdp_get(pmd_t *pmdp)
-{
-	return READ_ONCE(*pmdp);
-}
-#endif
-
 #ifdef CONFIG_GUP_GET_PXX_LOW_HIGH
 /*
  * For walking the pagetables without holding any locks.  Some architectures
_

Patches currently in -mm which might be from ryan.roberts@arm.com are


