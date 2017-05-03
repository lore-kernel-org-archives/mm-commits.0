From: akpm@linux-foundation.org
Subject: [patch 092/102] mm: hwpoison: call shake_page()
 unconditionally
Date: Wed, 03 May 2017 14:56:19 -0700
Message-ID: <20170503215619.y-eUHu_NM%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:52958 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751821AbdECV5f (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 3 May 2017 17:57:35 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, gong.chen@linux.intel.com, lkp@intel.com, mm-commits@vger.kernel.org, n-horiguchi@ah.jp.nec.com, torvalds@linux-foundation.org, xiaolong.ye@intel.com

From: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Subject: mm: hwpoison: call shake_page() unconditionally

shake_page() is called before going into core error handling code in order
to ensure that the error page is flushed from lru_cache lists where pages
stay during transferring among LRU lists.

But currently it's not fully functional because when the page is linked to
lru_cache by calling activate_page(), its PageLRU flag is set and
shake_page() is skipped.  The result is to fail error handling with "still
referenced by 1 users" message.

When the page is linked to lru_cache by isolate_lru_page(), its PageLRU is
clear, so that's fine.

This patch makes shake_page() unconditionally called to avoild the failure.

Fixes: 23a003bfd23ea9ea0b7756b920e51f64b284b468 ("mm/madvise: pass return code of memory_failure() to userspace")
Link: http://lkml.kernel.org/r/20170417055948.GM31394@yexl-desktop
Link: http://lkml.kernel.org/r/1493197841-23986-2-git-send-email-n-horiguchi@ah.jp.nec.com
Signed-off-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Reported-by: kernel test robot <lkp@intel.com>
Cc: Xiaolong Ye <xiaolong.ye@intel.com>
Cc: Chen Gong <gong.chen@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hwpoison-inject.c |    3 +--
 mm/memory-failure.c  |   27 +++++++++++----------------
 2 files changed, 12 insertions(+), 18 deletions(-)

diff -puN mm/hwpoison-inject.c~mm-hwpoison-call-shake_page-unconditionally mm/hwpoison-inject.c
--- a/mm/hwpoison-inject.c~mm-hwpoison-call-shake_page-unconditionally
+++ a/mm/hwpoison-inject.c
@@ -34,8 +34,7 @@ static int hwpoison_inject(void *data, u
 	if (!hwpoison_filter_enable)
 		goto inject;
 
-	if (!PageLRU(hpage) && !PageHuge(p))
-		shake_page(hpage, 0);
+	shake_page(hpage, 0);
 	/*
 	 * This implies unable to support non-LRU pages.
 	 */
diff -puN mm/memory-failure.c~mm-hwpoison-call-shake_page-unconditionally mm/memory-failure.c
--- a/mm/memory-failure.c~mm-hwpoison-call-shake_page-unconditionally
+++ a/mm/memory-failure.c
@@ -220,6 +220,9 @@ static int kill_proc(struct task_struct
  */
 void shake_page(struct page *p, int access)
 {
+	if (PageHuge(p))
+		return;
+
 	if (!PageSlab(p)) {
 		lru_add_drain_all();
 		if (PageLRU(p))
@@ -1137,22 +1140,14 @@ int memory_failure(unsigned long pfn, in
 	 * The check (unnecessarily) ignores LRU pages being isolated and
 	 * walked by the page reclaim code, however that's not a big loss.
 	 */
-	if (!PageHuge(p)) {
-		if (!PageLRU(p))
-			shake_page(p, 0);
-		if (!PageLRU(p)) {
-			/*
-			 * shake_page could have turned it free.
-			 */
-			if (is_free_buddy_page(p)) {
-				if (flags & MF_COUNT_INCREASED)
-					action_result(pfn, MF_MSG_BUDDY, MF_DELAYED);
-				else
-					action_result(pfn, MF_MSG_BUDDY_2ND,
-						      MF_DELAYED);
-				return 0;
-			}
-		}
+	shake_page(p, 0);
+	/* shake_page could have turned it free. */
+	if (!PageLRU(p) && is_free_buddy_page(p)) {
+		if (flags & MF_COUNT_INCREASED)
+			action_result(pfn, MF_MSG_BUDDY, MF_DELAYED);
+		else
+			action_result(pfn, MF_MSG_BUDDY_2ND, MF_DELAYED);
+		return 0;
 	}
 
 	lock_page(hpage);
_
