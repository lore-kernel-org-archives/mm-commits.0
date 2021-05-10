Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_RED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8E2CDC433B4
	for <mm-commits@archiver.kernel.org>; Mon, 10 May 2021 04:21:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5AC4961437
	for <mm-commits@archiver.kernel.org>; Mon, 10 May 2021 04:21:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229932AbhEJEWZ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 10 May 2021 00:22:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:60274 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229931AbhEJEWW (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 10 May 2021 00:22:22 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6CA6761400;
        Mon, 10 May 2021 04:21:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1620620478;
        bh=1L6KZxy6N587qeLMJDeRU4hMawngnJXkwoTdPVq+KVA=;
        h=Date:From:To:Subject:From;
        b=jdWyzHas1ikClA7ZkILC4bttx5zpT6Uv+4xb3qRdRw/A4Se41i/CaDmN2RQh1OVN1
         KKYtcnsz5KxLDxUtuj8AlPHgHnatNqek77iJ8fayvCBtWnPMZXMNFMtlo0x+/eRKN3
         xN7H8udUjpT7Y/axgzkJWeV1jO+7pj6tX7TC4l4o=
Date:   Sun, 09 May 2021 21:21:16 -0700
From:   akpm@linux-foundation.org
To:     aarcange@redhat.com, arnd@arndb.de, chris@zankel.net,
        dave.hansen@intel.com, david@redhat.com, deller@gmx.de,
        eike-kernel@sf-tec.de, hughd@google.com, ink@jurassic.park.msu.ru,
        James.Bottomley@HansenPartnership.com, jannh@google.com,
        jcmvbkbc@gmail.com, jgg@ziepe.ca, kirill.shutemov@linux.intel.com,
        linuxram@us.ibm.com, mattst88@gmail.com, mhocko@suse.com,
        mike.kravetz@oracle.com, minchan@kernel.org,
        mm-commits@vger.kernel.org, mst@redhat.com, osalvador@suse.de,
        peterx@redhat.com, riel@surriel.com, rth@twiddle.net,
        shuah@kernel.org, tsbogend@alpha.franken.de, vbabka@suse.cz,
        willy@infradead.org
Subject:  +
 mm-make-variable-names-for-populate_vma_page_range-consistent.patch added
 to -mm tree
Message-ID: <20210510042116.3u7d5xr7K%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: make variable names for populate_vma_page_range() consistent
has been added to the -mm tree.  Its filename is
     mm-make-variable-names-for-populate_vma_page_range-consistent.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-make-variable-names-for-populate_vma_page_range-consistent.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-make-variable-names-for-populate_vma_page_range-consistent.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: David Hildenbrand <david@redhat.com>
Subject: mm: make variable names for populate_vma_page_range() consistent

Patch series "mm/madvise: introduce MADV_POPULATE_(READ|WRITE) to prefault page tables", v2.

Excessive details on MADV_POPULATE_(READ|WRITE) can be found in patch #2.


This patch (of 5):

Let's make the variable names in the function declaration match the
variable names used in the definition.

Link: https://lkml.kernel.org/r/20210419135443.12822-1-david@redhat.com
Link: https://lkml.kernel.org/r/20210419135443.12822-2-david@redhat.com
Signed-off-by: David Hildenbrand <david@redhat.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Peter Xu <peterx@redhat.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Chris Zankel <chris@zankel.net>
Cc: Dave Hansen <dave.hansen@intel.com>
Cc: Helge Deller <deller@gmx.de>
Cc: Hugh Dickins <hughd@google.com>
Cc: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
Cc: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
Cc: Jann Horn <jannh@google.com>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Matt Turner <mattst88@gmail.com>
Cc: Max Filippov <jcmvbkbc@gmail.com>
Cc: Michael S. Tsirkin <mst@redhat.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Ram Pai <linuxram@us.ibm.com>
Cc: Richard Henderson <rth@twiddle.net>
Cc: Rik van Riel <riel@surriel.com>
Cc: Rolf Eike Beer <eike-kernel@sf-tec.de>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/internal.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/internal.h~mm-make-variable-names-for-populate_vma_page_range-consistent
+++ a/mm/internal.h
@@ -344,7 +344,7 @@ void __vma_unlink_list(struct mm_struct
 
 #ifdef CONFIG_MMU
 extern long populate_vma_page_range(struct vm_area_struct *vma,
-		unsigned long start, unsigned long end, int *nonblocking);
+		unsigned long start, unsigned long end, int *locked);
 extern void munlock_vma_pages_range(struct vm_area_struct *vma,
 			unsigned long start, unsigned long end);
 static inline void munlock_vma_pages_all(struct vm_area_struct *vma)
_

Patches currently in -mm which might be from david@redhat.com are

perf-map_executable-does-not-indicate-vm_mayexec.patch
binfmt-remove-in-tree-usage-of-map_executable.patch
mm-ignore-map_executable-in-ksys_mmap_pgoff.patch
mm-make-variable-names-for-populate_vma_page_range-consistent.patch
mm-madvise-introduce-madv_populate_readwrite-to-prefault-page-tables.patch
maintainers-add-tools-testing-selftests-vm-to-memory-management.patch
selftests-vm-add-protection_keys_32-protection_keys_64-to-gitignore.patch
selftests-vm-add-test-for-madv_populate_readwrite.patch

