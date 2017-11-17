From: akpm@linux-foundation.org
Subject: [folded-merged]
 mm-compaction-persistently-skip-hugetlbfs-pageblocks-fix.patch removed from -mm tree
Date: Fri, 17 Nov 2017 15:10:08 -0800
Message-ID: <5a0f6c50.l3sxM4JuWeC8IWoS%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:53474 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S965626AbdKQXKJ (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 17 Nov 2017 18:10:09 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rientjes@google.com, mhocko@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: mm, compaction: persistently skip hugetlbfs pageblocks fix
has been removed from the -mm tree.  Its filename was
     mm-compaction-persistently-skip-hugetlbfs-pageblocks-fix.patch

This patch was dropped because it was folded into mm-compaction-persistently-skip-hugetlbfs-pageblocks.patch

------------------------------------------------------
From: David Rientjes <rientjes@google.com>
Subject: mm, compaction: persistently skip hugetlbfs pageblocks fix

Fix build:

mm/compaction.c: In function `isolate_freepages_block':
mm/compaction.c:469:4: error: implicit declaration of function `pageblock_skip_persistent' [-Werror=implicit-function-declaration]
    if (pageblock_skip_persistent(page, order)) {
    ^
mm/compaction.c:470:5: error: implicit declaration of function `set_pageblock_skip' [-Werror=implicit-function-declaration]
     set_pageblock_skip(page);
     ^

CMA doesn't guarantee pageblock skip will get reset when migration and
freeing scanners meet, and pageblock skip is a CONFIG_COMPACTION only
feature, so disable it when CONFIG_COMPACTION=n.

Link: http://lkml.kernel.org/r/alpine.DEB.2.10.1708201734390.117182@chino.kir.corp.google.com
Signed-off-by: David Rientjes <rientjes@google.com>
Tested-by: Michal Hocko <mhocko@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/pageblock-flags.h |   11 +++++++++++
 mm/compaction.c                 |    8 +++++++-
 2 files changed, 18 insertions(+), 1 deletion(-)

diff -puN include/linux/pageblock-flags.h~mm-compaction-persistently-skip-hugetlbfs-pageblocks-fix include/linux/pageblock-flags.h
--- a/include/linux/pageblock-flags.h~mm-compaction-persistently-skip-hugetlbfs-pageblocks-fix
+++ a/include/linux/pageblock-flags.h
@@ -96,6 +96,17 @@ void set_pfnblock_flags_mask(struct page
 #define set_pageblock_skip(page) \
 			set_pageblock_flags_group(page, 1, PB_migrate_skip,  \
 							PB_migrate_skip)
+#else
+static inline bool get_pageblock_skip(struct page *page)
+{
+	return false;
+}
+static inline void clear_pageblock_skip(struct page *page)
+{
+}
+static inline void set_pageblock_skip(struct page *page)
+{
+}
 #endif /* CONFIG_COMPACTION */
 
 #endif	/* PAGEBLOCK_FLAGS_H */
diff -puN mm/compaction.c~mm-compaction-persistently-skip-hugetlbfs-pageblocks-fix mm/compaction.c
--- a/mm/compaction.c~mm-compaction-persistently-skip-hugetlbfs-pageblocks-fix
+++ a/mm/compaction.c
@@ -323,7 +323,13 @@ static inline bool isolation_suitable(st
 	return true;
 }
 
-static void update_pageblock_skip(struct compact_control *cc,
+static inline bool pageblock_skip_persistent(struct page *page,
+					     unsigned int order)
+{
+	return false;
+}
+
+static inline void update_pageblock_skip(struct compact_control *cc,
 			struct page *page, unsigned long nr_isolated,
 			bool migrate_scanner)
 {
_

Patches currently in -mm which might be from rientjes@google.com are

mm-compaction-kcompactd-should-not-ignore-pageblock-skip.patch
mm-compaction-persistently-skip-hugetlbfs-pageblocks.patch

