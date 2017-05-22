From: akpm@linux-foundation.org
Subject: +
 mm-madvise-enable-softhard-offline-of-hugetlb-pages-at-pgd-level-fix.patch
 added to -mm tree
Date: Mon, 22 May 2017 14:03:41 -0700
Message-ID: <5923522d.5sxyR7RV2yaOkdHx%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42040 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933846AbdEVVDm (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 22 May 2017 17:03:42 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: arnd@arndb.de, mhocko@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: include/linux/hugetlb.h: make hstate_is_gigantic() inline
has been added to the -mm tree.  Its filename is
     mm-madvise-enable-softhard-offline-of-hugetlb-pages-at-pgd-level-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-madvise-enable-softhard-offline-of-hugetlb-pages-at-pgd-level-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-madvise-enable-softhard-offline-of-hugetlb-pages-at-pgd-level-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

mm-madvise-enable-softhard-offline-of-hugetlb-pages-at-pgd-level-fix.patch

