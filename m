From: akpm@linux-foundation.org
Subject: + mm-vmscan-make-inactive_anon-file_is_low-return-bool.patch
 added to -mm tree
Date: Mon, 21 Sep 2015 14:29:19 -0700
Message-ID: <560076af.u5r8dke7ZqFXBinT%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50681 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753884AbbIUV3U (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 21 Sep 2015 17:29:20 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bywxiaobai@163.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/vmscan: make inactive_anon/file_is_low return bool
has been added to the -mm tree.  Its filename is
     mm-vmscan-make-inactive_anon-file_is_low-return-bool.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-vmscan-make-inactive_anon-file_is_low-return-bool.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-vmscan-make-inactive_anon-file_is_low-return-bool.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Yaowei Bai <bywxiaobai@163.com>
Subject: mm/vmscan: make inactive_anon/file_is_low return bool

Make inactive_anon/file_is_low return bool due to these particular
functions only using either one or zero as their return value.

No functional change.

Signed-off-by: Yaowei Bai <bywxiaobai@163.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |   14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff -puN mm/vmscan.c~mm-vmscan-make-inactive_anon-file_is_low-return-bool mm/vmscan.c
--- a/mm/vmscan.c~mm-vmscan-make-inactive_anon-file_is_low-return-bool
+++ a/mm/vmscan.c
@@ -1859,7 +1859,7 @@ static void shrink_active_list(unsigned
 }
 
 #ifdef CONFIG_SWAP
-static int inactive_anon_is_low_global(struct zone *zone)
+static bool inactive_anon_is_low_global(struct zone *zone)
 {
 	unsigned long active, inactive;
 
@@ -1876,14 +1876,14 @@ static int inactive_anon_is_low_global(s
  * Returns true if the zone does not have enough inactive anon pages,
  * meaning some active anon pages need to be deactivated.
  */
-static int inactive_anon_is_low(struct lruvec *lruvec)
+static bool inactive_anon_is_low(struct lruvec *lruvec)
 {
 	/*
 	 * If we don't have swap space, anonymous page deactivation
 	 * is pointless.
 	 */
 	if (!total_swap_pages)
-		return 0;
+		return false;
 
 	if (!mem_cgroup_disabled())
 		return mem_cgroup_inactive_anon_is_low(lruvec);
@@ -1891,9 +1891,9 @@ static int inactive_anon_is_low(struct l
 	return inactive_anon_is_low_global(lruvec_zone(lruvec));
 }
 #else
-static inline int inactive_anon_is_low(struct lruvec *lruvec)
+static inline bool inactive_anon_is_low(struct lruvec *lruvec)
 {
-	return 0;
+	return false;
 }
 #endif
 
@@ -1911,7 +1911,7 @@ static inline int inactive_anon_is_low(s
  * This uses a different ratio than the anonymous pages, because
  * the page cache uses a use-once replacement algorithm.
  */
-static int inactive_file_is_low(struct lruvec *lruvec)
+static bool inactive_file_is_low(struct lruvec *lruvec)
 {
 	unsigned long inactive;
 	unsigned long active;
@@ -1922,7 +1922,7 @@ static int inactive_file_is_low(struct l
 	return active > inactive;
 }
 
-static int inactive_list_is_low(struct lruvec *lruvec, enum lru_list lru)
+static bool inactive_list_is_low(struct lruvec *lruvec, enum lru_list lru)
 {
 	if (is_file_lru(lru))
 		return inactive_file_is_low(lruvec);
_

Patches currently in -mm which might be from bywxiaobai@163.com are

mm-page_alloc-remove-unused-parameter-in-init_currently_empty_zone.patch
mm-vmscan-make-inactive_anon_is_low_global-return-directly.patch
mm-oom_kill-introduce-is_sysrq_oom-helper.patch
mm-compaction-add-an-is_via_compact_memory-helper-function.patch
mm-vmscan-make-inactive_anon-file_is_low-return-bool.patch
mm-memcontrol-make-mem_cgroup_inactive_anon_is_low-return-bool.patch

