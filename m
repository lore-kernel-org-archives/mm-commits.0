From: akpm@linux-foundation.org
Subject: [folded-merged] proc-add-kpageidle-file-fix.patch removed from
 -mm tree
Date: Wed, 09 Sep 2015 15:05:44 -0700
Message-ID: <55f0ad38.YSNCgAcU66r2A2eA%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:55662 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752780AbbIIWFo (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 9 Sep 2015 18:05:44 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vdavydov@parallels.com, andreslc@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: proc-add-kpageidle-file-fix
has been removed from the -mm tree.  Its filename was
     proc-add-kpageidle-file-fix.patch

This patch was dropped because it was folded into proc-add-kpageidle-file.patch

------------------------------------------------------
From: Vladimir Davydov <vdavydov@parallels.com>
Subject: proc-add-kpageidle-file-fix

Cc: Andres Lagar-Cavilla <andreslc@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/page.c |   10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff -puN fs/proc/page.c~proc-add-kpageidle-file-fix fs/proc/page.c
--- a/fs/proc/page.c~proc-add-kpageidle-file-fix
+++ a/fs/proc/page.c
@@ -353,7 +353,11 @@ static int kpageidle_clear_pte_refs_one(
 
 static void kpageidle_clear_pte_refs(struct page *page)
 {
-	struct rmap_walk_control rwc = {
+	/*
+	 * Since rwc.arg is unused, rwc is effectively immutable, so we
+	 * can make it static const to save some cycles and stack.
+	 */
+	static const struct rmap_walk_control rwc = {
 		.rmap_one = kpageidle_clear_pte_refs_one,
 		.anon_lock = page_lock_anon_vma_read,
 	};
@@ -367,7 +371,7 @@ static void kpageidle_clear_pte_refs(str
 	if (need_lock && !trylock_page(page))
 		return;
 
-	rmap_walk(page, &rwc);
+	rmap_walk(page, (struct rmap_walk_control *)&rwc);
 
 	if (need_lock)
 		unlock_page(page);
@@ -456,7 +460,7 @@ static ssize_t kpageidle_write(struct fi
 			}
 			in++;
 		}
-		if (idle_bitmap >> bit & 1) {
+		if ((idle_bitmap >> bit) & 1) {
 			page = kpageidle_get_page(pfn);
 			if (page) {
 				kpageidle_clear_pte_refs(page);
_

Patches currently in -mm which might be from vdavydov@parallels.com are

memcg-add-page_cgroup_ino-helper.patch
hwpoison-use-page_cgroup_ino-for-filtering-by-memcg.patch
memcg-zap-try_get_mem_cgroup_from_page.patch
proc-add-kpagecgroup-file.patch
mmu-notifier-add-clear_young-callback.patch
proc-add-kpageidle-file.patch
proc-add-kpageidle-file-fix-2.patch
proc-add-kpageidle-file-fix-3.patch
proc-add-kpageidle-file-fix-4.patch
proc-add-kpageidle-file-fix-5.patch
proc-add-kpageidle-file-fix-6.patch
proc-add-kpageidle-file-fix-6-fix-2.patch
proc-export-idle-flag-via-kpageflags.patch
proc-add-cond_resched-to-proc-kpage-read-write-loop.patch

