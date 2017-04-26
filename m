From: akpm@linux-foundation.org
Subject: + mm-hwpoison-call-shake_page-unconditionally.patch added to -mm
 tree
Date: Wed, 26 Apr 2017 15:30:48 -0700
Message-ID: <59011f98.+gfcWkZwWNv/JYyq%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:59268 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1031643AbdDZWav (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 26 Apr 2017 18:30:51 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: n-horiguchi@ah.jp.nec.com, gong.chen@linux.intel.com, lkp@intel.com, xiaolong.ye@intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: hwpoison: call shake_page() unconditionally
has been added to the -mm tree.  Its filename is
     mm-hwpoison-call-shake_page-unconditionally.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-hwpoison-call-shake_page-unconditionally.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-hwpoison-call-shake_page-unconditionally.patch

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
@@ -1140,22 +1143,14 @@ int memory_failure(unsigned long pfn, in
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

Patches currently in -mm which might be from n-horiguchi@ah.jp.nec.com are

mm-hwpoison-call-shake_page-unconditionally.patch
mm-hwpoison-call-shake_page-after-try_to_unmap-for-mlocked-page.patch

