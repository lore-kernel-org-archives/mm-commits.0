From: akpm@linux-foundation.org
Subject: + proc-add-kpageidle-file-fix.patch added to -mm tree
Date: Wed, 22 Jul 2015 12:47:40 -0700
Message-ID: <55aff35c.AlIz0VcMreyo5+QM%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:46798 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752024AbbGVTrk (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 22 Jul 2015 15:47:40 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vdavydov@parallels.com, andreslc@google.com, mm-commits@vger.kernel.org


The patch titled
     
has been added to the -mm tree.  Its filename is
     proc-add-kpageidle-file-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/proc-add-kpageidle-file-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/proc-add-kpageidle-file-fix.patch

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

memcg-export-struct-mem_cgroup.patch
memcg-export-struct-mem_cgroup-fix.patch
memcg-export-struct-mem_cgroup-fix-2.patch
memcg-get-rid-of-mem_cgroup_root_css-for-config_memcg.patch
memcg-get-rid-of-extern-for-functions-in-memcontrolh.patch
memcg-restructure-mem_cgroup_can_attach.patch
memcg-tcp_kmem-check-for-cg_proto-in-sock_update_memcg.patch
memcg-add-page_cgroup_ino-helper.patch
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

