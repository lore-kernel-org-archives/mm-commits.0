From: akpm@linux-foundation.org
Subject: [merged]
 mm-vmscan-make-inactive_anon_is_low_global-return-directly.patch removed
 from -mm tree
Date: Fri, 06 Nov 2015 12:08:12 -0800
Message-ID: <563d08ac.c26XlQp6eOyJHCFv%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48735 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1033520AbbKFUIN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 6 Nov 2015 15:08:13 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bywxiaobai@163.com, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/vmscan: make inactive_anon_is_low_global return directly
has been removed from the -mm tree.  Its filename was
     mm-vmscan-make-inactive_anon_is_low_global-return-directly.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Yaowei Bai <bywxiaobai@163.com>
Subject: mm/vmscan: make inactive_anon_is_low_global return directly

Delete unnecessary if to let inactive_anon_is_low_global return
directly.

No functional changes.

Signed-off-by: Yaowei Bai <bywxiaobai@163.com>
Acked-by: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |    5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff -puN mm/vmscan.c~mm-vmscan-make-inactive_anon_is_low_global-return-directly mm/vmscan.c
--- a/mm/vmscan.c~mm-vmscan-make-inactive_anon_is_low_global-return-directly
+++ a/mm/vmscan.c
@@ -1866,10 +1866,7 @@ static int inactive_anon_is_low_global(s
 	active = zone_page_state(zone, NR_ACTIVE_ANON);
 	inactive = zone_page_state(zone, NR_INACTIVE_ANON);
 
-	if (inactive * zone->inactive_ratio < active)
-		return 1;
-
-	return 0;
+	return inactive * zone->inactive_ratio < active;
 }
 
 /**
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

