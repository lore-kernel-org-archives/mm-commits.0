From: akpm@linux-foundation.org
Subject: [folded-merged]
 mm-madvise-enable-softhard-offline-of-hugetlb-pages-at-pgd-level-fix.patch
 removed from -mm tree
Date: Thu, 06 Jul 2017 15:16:54 -0700
Message-ID: <595eb6d6.l0Qwvr270kmwtAqt%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:33060 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752327AbdGFWQy (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 6 Jul 2017 18:16:54 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: arnd@arndb.de, mhocko@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: include/linux/hugetlb.h: make hstate_is_gigantic() inline
has been removed from the -mm tree.  Its filename was
     mm-madvise-enable-softhard-offline-of-hugetlb-pages-at-pgd-level-fix.patch

This patch was dropped because it was folded into mm-madvise-enable-softhard-offline-of-hugetlb-pages-at-pgd-level.patch

------------------------------------------------------
From: Arnd Bergmann <arnd@arndb.de>
Subject: include/linux/hugetlb.h: make hstate_is_gigantic() inline

Ignoring the argument of both alloc_huge_page_node() and
hstate_is_gigantic() causes a harmless warning:

mm/memory-failure.c: In function 'new_page':
mm/memory-failure.c:1493:18: error: unused variable 'hstate' [-Werror=unused-variable]

Turning one into an inline function makes the compiler see that the
variable is not meant to be unused.

Fixes: d81a077951f8 ("mm/madvise: enable (soft|hard) offline of HugeTLB pages at PGD level")
Fixes: 39b80148ffd7 ("mm/follow_page_mask: add support for hugepage directory entry")
Link: http://lkml.kernel.org/r/20170522124748.3911296-1-arnd@arndb.de
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: Michal Hocko <mhocko@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/hugetlb.h |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff -puN include/linux/hugetlb.h~mm-madvise-enable-softhard-offline-of-hugetlb-pages-at-pgd-level-fix include/linux/hugetlb.h
--- a/include/linux/hugetlb.h~mm-madvise-enable-softhard-offline-of-hugetlb-pages-at-pgd-level-fix
+++ a/include/linux/hugetlb.h
@@ -522,7 +522,11 @@ struct hstate {};
 #define vma_mmu_pagesize(v) PAGE_SIZE
 #define huge_page_order(h) 0
 #define huge_page_shift(h) PAGE_SHIFT
-#define hstate_is_gigantic(h) 0
+static inline bool hstate_is_gigantic(struct hstate *h)
+{
+	return false;
+}
+
 static inline unsigned int pages_per_huge_page(struct hstate *h)
 {
 	return 1;
_

Patches currently in -mm which might be from arnd@arndb.de are

mm-madvise-enable-softhard-offline-of-hugetlb-pages-at-pgd-level.patch

