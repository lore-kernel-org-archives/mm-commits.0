From: akpm@linux-foundation.org
Subject: + mm-uninitialized-struct-page-poisoning-sanity-checking-v4.patch added to -mm tree
Date: Thu, 15 Feb 2018 14:46:30 -0800
Message-ID: <5a860dc6.EVIoZCGW22iSmg67%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:41880 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756363AbeBOWrC (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 15 Feb 2018 17:47:02 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: pasha.tatashin@oracle.com, mhocko@suse.com, mingo@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-uninitialized-struct-page-poisoning-sanity-checking-v4
has been added to the -mm tree.  Its filename is
     mm-uninitialized-struct-page-poisoning-sanity-checking-v4.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-uninitialized-struct-page-poisoning-sanity-checking-v4.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-uninitialized-struct-page-poisoning-sanity-checking-v4.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Pavel Tatashin <pasha.tatashin@oracle.com>
Subject: mm-uninitialized-struct-page-poisoning-sanity-checking-v4

Addressed comments from Ingo Molnar and from Michal Hocko
Splitted 4th patch into three patches
Instead of using section table to save node ids, saving node id in
the first page of every section.
				
Link: http://lkml.kernel.org/r/20180215165920.8570-4-pasha.tatashin@oracle.com
Signed-off-by: Pavel Tatashin <pasha.tatashin@oracle.com>
Reviewed-by: Ingo Molnar <mingo@kernel.org>
Acked-by: Michal Hocko <mhocko@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/page-flags.h |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff -puN include/linux/page-flags.h~mm-uninitialized-struct-page-poisoning-sanity-checking-v4 include/linux/page-flags.h
--- a/include/linux/page-flags.h~mm-uninitialized-struct-page-poisoning-sanity-checking-v4
+++ a/include/linux/page-flags.h
@@ -156,7 +156,7 @@ static __always_inline int PageCompound(
 	return test_bit(PG_head, &page->flags) || PageTail(page);
 }
 
-#define	PAGE_POISON_PATTERN	~0ul
+#define	PAGE_POISON_PATTERN	-1l
 static inline int PagePoisoned(const struct page *page)
 {
 	return page->flags == PAGE_POISON_PATTERN;
@@ -187,18 +187,18 @@ static inline int PagePoisoned(const str
  */
 #define PF_POISONED_CHECK(page) ({					\
 		VM_BUG_ON_PGFLAGS(PagePoisoned(page), page);		\
-		page;})
+		page; })
 #define PF_ANY(page, enforce)	PF_POISONED_CHECK(page)
 #define PF_HEAD(page, enforce)	PF_POISONED_CHECK(compound_head(page))
 #define PF_ONLY_HEAD(page, enforce) ({					\
 		VM_BUG_ON_PGFLAGS(PageTail(page), page);		\
-		PF_POISONED_CHECK(page);})
+		PF_POISONED_CHECK(page); })
 #define PF_NO_TAIL(page, enforce) ({					\
 		VM_BUG_ON_PGFLAGS(enforce && PageTail(page), page);	\
-		PF_POISONED_CHECK(compound_head(page));})
+		PF_POISONED_CHECK(compound_head(page)); })
 #define PF_NO_COMPOUND(page, enforce) ({				\
 		VM_BUG_ON_PGFLAGS(enforce && PageCompound(page), page);	\
-		PF_POISONED_CHECK(page);})
+		PF_POISONED_CHECK(page); })
 
 /*
  * Macros to create function definitions for page flags
_

Patches currently in -mm which might be from pasha.tatashin@oracle.com are

mm-initialize-pages-on-demand-during-boot.patch
mm-initialize-pages-on-demand-during-boot-fix-3.patch
mm-memory_hotplug-enforce-block-size-aligned-range-check.patch
x86-mm-memory_hotplug-determine-block-size-based-on-the-end-of-boot-memory.patch
x86-mm-memory_hotplug-determine-block-size-based-on-the-end-of-boot-memory-v4.patch
mm-uninitialized-struct-page-poisoning-sanity-checking.patch
mm-uninitialized-struct-page-poisoning-sanity-checking-v4.patch
mm-memory_hotplug-optimize-probe-routine.patch
mm-memory_hotplug-dont-read-nid-from-struct-page-during-hotplug.patch
mm-memory_hotplug-optimize-memory-hotplug.patch
sparc64-ng4-memset-32-bits-overflow.patch

