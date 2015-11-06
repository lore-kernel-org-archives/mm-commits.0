From: akpm@linux-foundation.org
Subject: [merged]
 mm-vmscan-make-inactive_anon-file_is_low-return-bool.patch removed from -mm tree
Date: Fri, 06 Nov 2015 12:08:24 -0800
Message-ID: <563d08b8.S0XE01PBuTmpLiF/%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48703 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966348AbbKFUIY (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 6 Nov 2015 15:08:24 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bywxiaobai@163.com, hannes@cmpxchg.org, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/vmscan: make inactive_anon/file_is_low return bool
has been removed from the -mm tree.  Its filename was
     mm-vmscan-make-inactive_anon-file_is_low-return-bool.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Yaowei Bai <bywxiaobai@163.com>
Subject: mm/vmscan: make inactive_anon/file_is_low return bool

Make inactive_anon/file_is_low return bool due to these particular
functions only using either one or zero as their return value.

No functional change.

Signed-off-by: Yaowei Bai <bywxiaobai@163.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
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

mm-oom_kill-introduce-is_sysrq_oom-helper.patch
fs-kdev_t-remove-unused-huge_valid_dev-function.patch
fs-kdev_t-old-new_valid_dev-can-be-boolean.patch
fs-vfs-remove-unnecessary-new_valid_dev-check.patch
fs-btrfs-remove-unnecessary-new_valid_dev-check.patch
fs-exofs-remove-unnecessary-new_valid_dev-check.patch
fs-ext2-remove-unnecessary-new_valid_dev-check.patch
fs-f2fs-remove-unnecessary-new_valid_dev-check.patch
fs-hpfs-remove-unnecessary-new_valid_dev-check.patch
fs-jfs-remove-unnecessary-new_valid_dev-check.patch
fs-ncpfs-remove-unnecessary-new_valid_dev-check.patch
fs-nilfs2-remove-unnecessary-new_valid_dev-check.patch
fs-reiserfs-remove-unnecessary-new_valid_dev-check.patch
fs-stat-remove-unnecessary-new_valid_dev-check.patch
fs-ubifs-remove-unnecessary-new_valid_dev-check.patch

