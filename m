From: akpm@linux-foundation.org
Subject: + mm-compaction-persistently-skip-hugetlbfs-pageblocks-fix.patch
 added to -mm tree
Date: Mon, 21 Aug 2017 13:34:11 -0700
Message-ID: <599b43c3.yX62e04TtEeSTKSW%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:44120 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753492AbdHUUeM (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 21 Aug 2017 16:34:12 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rientjes@google.com, mhocko@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: mm, compaction: persistently skip hugetlbfs pageblocks fix
has been added to the -mm tree.  Its filename is
     mm-compaction-persistently-skip-hugetlbfs-pageblocks-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-compaction-persistently-skip-hugetlbfs-pageblocks-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-compaction-persistently-skip-hugetlbfs-pageblocks-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
@@ -322,7 +322,13 @@ static inline bool isolation_suitable(st
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

mm-oom-let-oom_reap_task-and-exit_mmap-to-run-concurrently-fix-2.patch
mm-compaction-kcompactd-should-not-ignore-pageblock-skip.patch
mm-compaction-persistently-skip-hugetlbfs-pageblocks.patch
mm-compaction-persistently-skip-hugetlbfs-pageblocks-fix.patch

