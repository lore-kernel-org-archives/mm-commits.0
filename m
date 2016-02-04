From: akpm@linux-foundation.org
Subject: + proc-kpageflags-return-kpf_buddy-for-tail-buddy-pages.patch
 added to -mm tree
Date: Thu, 04 Feb 2016 15:26:27 -0800
Message-ID: <56b3de23.t2QCxhpadUecaLeL%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:36511 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754564AbcBDX02 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 4 Feb 2016 18:26:28 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: n-horiguchi@ah.jp.nec.com, koct9i@gmail.com, vdavydov@virtuozzo.com, mm-commits@vger.kernel.org


The patch titled
     Subject: /proc/kpageflags: return KPF_BUDDY for "tail" buddy pages
has been added to the -mm tree.  Its filename is
     proc-kpageflags-return-kpf_buddy-for-tail-buddy-pages.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/proc-kpageflags-return-kpf_buddy-for-tail-buddy-pages.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/proc-kpageflags-return-kpf_buddy-for-tail-buddy-pages.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Subject: /proc/kpageflags: return KPF_BUDDY for "tail" buddy pages

Currently /proc/kpageflags returns nothing for "tail" buddy pages, which
is inconvenient when grasping how free pages are distributed.  This patch
sets KPF_BUDDY for such pages.

With this patch:

  $ grep MemFree /proc/meminfo ; tools/vm/page-types -b buddy
  MemFree:         3134992 kB
               flags      page-count       MB  symbolic-flags                     long-symbolic-flags
  0x0000000000000400          779272     3044  __________B_______________________________ buddy
  0x0000000000000c00            4385       17  __________BM______________________________ buddy,mmap
               total          783657     3061

783657 pages is 3134628 kB (roughly consistent with the global counter,)
so it's OK.

Signed-off-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Reviewed-by: Vladimir Davydov <vdavydov@virtuozzo.com>>
Cc: Konstantin Khlebnikov <koct9i@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/page.c             |    2 ++
 include/linux/page-flags.h |    2 ++
 mm/internal.h              |    3 ---
 mm/page_alloc.c            |    2 --
 4 files changed, 4 insertions(+), 5 deletions(-)

diff -puN fs/proc/page.c~proc-kpageflags-return-kpf_buddy-for-tail-buddy-pages fs/proc/page.c
--- a/fs/proc/page.c~proc-kpageflags-return-kpf_buddy-for-tail-buddy-pages
+++ a/fs/proc/page.c
@@ -148,6 +148,8 @@ u64 stable_page_flags(struct page *page)
 	 */
 	if (PageBuddy(page))
 		u |= 1 << KPF_BUDDY;
+	else if (page_count(page) == 0 && is_free_buddy_page(page))
+		u |= 1 << KPF_BUDDY;
 
 	if (PageBalloon(page))
 		u |= 1 << KPF_BALLOON;
diff -puN include/linux/page-flags.h~proc-kpageflags-return-kpf_buddy-for-tail-buddy-pages include/linux/page-flags.h
--- a/include/linux/page-flags.h~proc-kpageflags-return-kpf_buddy-for-tail-buddy-pages
+++ a/include/linux/page-flags.h
@@ -593,6 +593,8 @@ static inline void __ClearPageBuddy(stru
 	atomic_set(&page->_mapcount, -1);
 }
 
+extern bool is_free_buddy_page(struct page *page);
+
 #define PAGE_BALLOON_MAPCOUNT_VALUE (-256)
 
 static inline int PageBalloon(struct page *page)
diff -puN mm/internal.h~proc-kpageflags-return-kpf_buddy-for-tail-buddy-pages mm/internal.h
--- a/mm/internal.h~proc-kpageflags-return-kpf_buddy-for-tail-buddy-pages
+++ a/mm/internal.h
@@ -153,9 +153,6 @@ extern int __isolate_free_page(struct pa
 extern void __free_pages_bootmem(struct page *page, unsigned long pfn,
 					unsigned int order);
 extern void prep_compound_page(struct page *page, unsigned int order);
-#ifdef CONFIG_MEMORY_FAILURE
-extern bool is_free_buddy_page(struct page *page);
-#endif
 extern int user_min_free_kbytes;
 
 #if defined CONFIG_COMPACTION || defined CONFIG_CMA
diff -puN mm/page_alloc.c~proc-kpageflags-return-kpf_buddy-for-tail-buddy-pages mm/page_alloc.c
--- a/mm/page_alloc.c~proc-kpageflags-return-kpf_buddy-for-tail-buddy-pages
+++ a/mm/page_alloc.c
@@ -7150,7 +7150,6 @@ __offline_isolated_pages(unsigned long s
 }
 #endif
 
-#ifdef CONFIG_MEMORY_FAILURE
 bool is_free_buddy_page(struct page *page)
 {
 	struct zone *zone = page_zone(page);
@@ -7169,4 +7168,3 @@ bool is_free_buddy_page(struct page *pag
 
 	return order < MAX_ORDER;
 }
-#endif
_

Patches currently in -mm which might be from n-horiguchi@ah.jp.nec.com are

mm-madvise-pass-return-code-of-memory_failure-to-userspace.patch
mm-madvise-update-comment-on-sys_madvise.patch
proc-kpageflags-return-kpf_buddy-for-tail-buddy-pages.patch
proc-kpageflags-return-kpf_slab-for-slab-tail-pages.patch
tools-vm-page-typesc-support-swap-entry.patch

