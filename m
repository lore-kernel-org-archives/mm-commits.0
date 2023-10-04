Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2F40BE7C4F1
	for <mm-commits@archiver.kernel.org>; Wed,  4 Oct 2023 20:23:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244920AbjJDUXG (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 4 Oct 2023 16:23:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38756 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244973AbjJDUWb (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 4 Oct 2023 16:22:31 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 69E7DFA;
        Wed,  4 Oct 2023 13:22:08 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B8E00C433C7;
        Wed,  4 Oct 2023 20:22:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1696450928;
        bh=LPJhwn9uQhjNCYjO63MC0kPB0tVPWq0Km8yI3xGFldM=;
        h=Date:To:From:Subject:From;
        b=M4srvr3fY8VgcNgwU4yYxuH6fIVk/H0lWUKhfkiJaDOhHw9jQ8F7oIh7Wn+7MN3fB
         JVuFsi/95OHAzOpnkFtcPkGfjU6tXX9brDp43OSsjWKiNMHJGk0L/Rs4UB0hU6QNec
         o+VskZ3l1Nbwl3H+Kd8G2zBsUc87wSaYXjZ4CKvg=
Date:   Wed, 04 Oct 2023 13:22:06 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        tsbogend@alpha.franken.de, stable@vger.kernel.org,
        songmuchun@bytedance.com, rppt@kernel.org, mike.kravetz@oracle.com,
        david@redhat.com, ziy@nvidia.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mips-use-nth_page-in-place-of-direct-struct-page-manipulation.patch removed from -mm tree
Message-Id: <20231004202207.B8E00C433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mips: use nth_page() in place of direct struct page manipulation
has been removed from the -mm tree.  Its filename was
     mips-use-nth_page-in-place-of-direct-struct-page-manipulation.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Zi Yan <ziy@nvidia.com>
Subject: mips: use nth_page() in place of direct struct page manipulation
Date: Wed, 13 Sep 2023 16:12:48 -0400

__flush_dcache_pages() is called during hugetlb migration via
migrate_pages() -> migrate_hugetlbs() -> unmap_and_move_huge_page() ->
move_to_new_folio() -> flush_dcache_folio().  And with hugetlb and without
sparsemem vmemmap, struct page is not guaranteed to be contiguous beyond a
section.  Use nth_page() instead.

Without the fix, a wrong address might be used for data cache page flush.
No bug is reported. The fix comes from code inspection.

Link: https://lkml.kernel.org/r/20230913201248.452081-6-zi.yan@sent.com
Fixes: 15fa3e8e3269 ("mips: implement the new page table range API")
Signed-off-by: Zi Yan <ziy@nvidia.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Mike Rapoport (IBM) <rppt@kernel.org>
Cc: Muchun Song <songmuchun@bytedance.com>
Cc: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/mips/mm/cache.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/mips/mm/cache.c~mips-use-nth_page-in-place-of-direct-struct-page-manipulation
+++ a/arch/mips/mm/cache.c
@@ -117,7 +117,7 @@ void __flush_dcache_pages(struct page *p
 	 * get faulted into the tlb (and thus flushed) anyways.
 	 */
 	for (i = 0; i < nr; i++) {
-		addr = (unsigned long)kmap_local_page(page + i);
+		addr = (unsigned long)kmap_local_page(nth_page(page, i));
 		flush_data_cache_page(addr);
 		kunmap_local((void *)addr);
 	}
_

Patches currently in -mm which might be from ziy@nvidia.com are


