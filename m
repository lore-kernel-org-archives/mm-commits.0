From: akpm@linux-foundation.org
Subject: + memcg-add-page_cgroup_ino-helper-fix.patch added to -mm tree
Date: Wed, 22 Jul 2015 12:57:34 -0700
Message-ID: <55aff5ae.j6gnJaos4lUP3GFt%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:46817 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751654AbbGVT5f (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 22 Jul 2015 15:57:35 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vdavydov@parallels.com, andreslc@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: memcg-add-page_cgroup_ino-helper-fix
has been added to the -mm tree.  Its filename is
     memcg-add-page_cgroup_ino-helper-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/memcg-add-page_cgroup_ino-helper-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/memcg-add-page_cgroup_ino-helper-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Vladimir Davydov <vdavydov@parallels.com>
Subject: memcg-add-page_cgroup_ino-helper-fix

Cc: Andres Lagar-Cavilla <andreslc@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memcontrol.h |    2 +-
 mm/memcontrol.c            |    7 ++++++-
 2 files changed, 7 insertions(+), 2 deletions(-)

diff -puN include/linux/memcontrol.h~memcg-add-page_cgroup_ino-helper-fix include/linux/memcontrol.h
--- a/include/linux/memcontrol.h~memcg-add-page_cgroup_ino-helper-fix
+++ a/include/linux/memcontrol.h
@@ -345,7 +345,7 @@ static inline bool mm_match_cgroup(struc
 }
 
 struct cgroup_subsys_state *mem_cgroup_css_from_page(struct page *page);
-unsigned long page_cgroup_ino(struct page *page);
+ino_t page_cgroup_ino(struct page *page);
 
 static inline bool mem_cgroup_disabled(void)
 {
diff -puN mm/memcontrol.c~memcg-add-page_cgroup_ino-helper-fix mm/memcontrol.c
--- a/mm/memcontrol.c~memcg-add-page_cgroup_ino-helper-fix
+++ a/mm/memcontrol.c
@@ -448,8 +448,13 @@ struct cgroup_subsys_state *mem_cgroup_c
  * Look up the closest online ancestor of the memory cgroup @page is charged to
  * and return its inode number or 0 if @page is not charged to any cgroup. It
  * is safe to call this function without holding a reference to @page.
+ *
+ * Note, this function is inherently racy, because there is nothing to prevent
+ * the cgroup inode from getting torn down and potentially reallocated a moment
+ * after page_cgroup_ino() returns, so it only should be used by callers that
+ * do not care (such as procfs interfaces).
  */
-unsigned long page_cgroup_ino(struct page *page)
+ino_t page_cgroup_ino(struct page *page)
 {
 	struct mem_cgroup *memcg;
 	unsigned long ino = 0;
_

Patches currently in -mm which might be from vdavydov@parallels.com are

memcg-export-struct-mem_cgroup.patch
memcg-export-struct-mem_cgroup-fix.patch
memcg-export-struct-mem_cgroup-fix-2.patch
memcg-get-rid-of-mem_cgroup_root_css-for-config_memcg.patch
memcg-get-rid-of-extern-for-functions-in-memcontrolh.patch
memcg-restructure-mem_cgroup_can_attach.patch
memcg-tcp_kmem-check-for-cg_proto-in-sock_update_memcg.patch
memcg-add-page_cgroup_ino-helper.patch
memcg-add-page_cgroup_ino-helper-fix.patch
hwpoison-use-page_cgroup_ino-for-filtering-by-memcg.patch
memcg-zap-try_get_mem_cgroup_from_page.patch
proc-add-kpagecgroup-file.patch
mmu-notifier-add-clear_young-callback.patch
mmu-notifier-add-clear_young-callback-fix.patch
proc-add-kpageidle-file.patch
proc-add-kpageidle-file-fix.patch
proc-export-idle-flag-via-kpageflags.patch
proc-add-cond_resched-to-proc-kpage-read-write-loop.patch
mm-vmscan-fix-the-page-state-calculation-in-too_many_isolated.patch
mm-swap-zswap-maybe_preload-refactoring.patch

