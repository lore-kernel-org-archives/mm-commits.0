From: akpm@linux-foundation.org
Subject: [merged]
 mm-memcontrol-make-mem_cgroup_inactive_anon_is_low-return-bool.patch
 removed from -mm tree
Date: Fri, 06 Nov 2015 12:08:26 -0800
Message-ID: <563d08ba.RgD8+WpJaKGjquhd%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48705 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757584AbbKFUI0 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 6 Nov 2015 15:08:26 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bywxiaobai@163.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/memcontrol: make mem_cgroup_inactive_anon_is_low() return bool
has been removed from the -mm tree.  Its filename was
     mm-memcontrol-make-mem_cgroup_inactive_anon_is_low-return-bool.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Yaowei Bai <bywxiaobai@163.com>
Subject: mm/memcontrol: make mem_cgroup_inactive_anon_is_low() return bool

Make mem_cgroup_inactive_anon_is_low return bool due to this particular
function only using either one or zero as its return value.

No functional change.

Signed-off-by: Yaowei Bai <bywxiaobai@163.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memcontrol.h |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN include/linux/memcontrol.h~mm-memcontrol-make-mem_cgroup_inactive_anon_is_low-return-bool include/linux/memcontrol.h
--- a/include/linux/memcontrol.h~mm-memcontrol-make-mem_cgroup_inactive_anon_is_low-return-bool
+++ a/include/linux/memcontrol.h
@@ -382,7 +382,7 @@ unsigned long mem_cgroup_get_lru_size(st
 	return mz->lru_size[lru];
 }
 
-static inline int mem_cgroup_inactive_anon_is_low(struct lruvec *lruvec)
+static inline bool mem_cgroup_inactive_anon_is_low(struct lruvec *lruvec)
 {
 	unsigned long inactive_ratio;
 	unsigned long inactive;
@@ -585,10 +585,10 @@ static inline bool mem_cgroup_disabled(v
 	return true;
 }
 
-static inline int
+static inline bool
 mem_cgroup_inactive_anon_is_low(struct lruvec *lruvec)
 {
-	return 1;
+	return true;
 }
 
 static inline bool mem_cgroup_lruvec_online(struct lruvec *lruvec)
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

