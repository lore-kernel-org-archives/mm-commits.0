From: akpm@linux-foundation.org
Subject: [merged]
 mm-print-a-warning-once-the-vm-dirtiness-settings-is-illogical.patch
 removed from -mm tree
Date: Thu, 16 Nov 2017 12:00:44 -0800
Message-ID: <20171116200044.rzulbKp4U%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:46328 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933663AbdKPUAp (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 16 Nov 2017 15:00:45 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jack@suse.cz, laoar.shao@gmail.com, mhocko@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/page-writeback.c: print a warning if the vm dirtiness settings are illogical
has been removed from the -mm tree.  Its filename was
     mm-print-a-warning-once-the-vm-dirtiness-settings-is-illogical.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Yafang Shao <laoar.shao@gmail.com>
Subject: mm/page-writeback.c: print a warning if the vm dirtiness settings are illogical

The vm direct limit setting must be set greater than vm background limit
setting.  Otherwise print a warning to help the operator to figure out
that the vm dirtiness settings is in illogical state.

Link: http://lkml.kernel.org/r/1506592464-30962-1-git-send-email-laoar.shao@gmail.com
Signed-off-by: Yafang Shao <laoar.shao@gmail.com>
Cc: Jan Kara <jack@suse.cz>
Cc: Michal Hocko <mhocko@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/sysctl/vm.txt |    7 +++++++
 mm/page-writeback.c         |    5 ++++-
 2 files changed, 11 insertions(+), 1 deletion(-)

diff -puN Documentation/sysctl/vm.txt~mm-print-a-warning-once-the-vm-dirtiness-settings-is-illogical Documentation/sysctl/vm.txt
--- a/Documentation/sysctl/vm.txt~mm-print-a-warning-once-the-vm-dirtiness-settings-is-illogical
+++ a/Documentation/sysctl/vm.txt
@@ -157,6 +157,10 @@ Note: the minimum value allowed for dirt
 value lower than this limit will be ignored and the old configuration will be
 retained.
 
+Note: the value of dirty_bytes also must be set greater than
+dirty_background_bytes or the amount of memory corresponding to
+dirty_background_ratio.
+
 ==============================================================
 
 dirty_expire_centisecs
@@ -176,6 +180,9 @@ generating disk writes will itself start
 
 The total available memory is not equal to total system memory.
 
+Note: dirty_ratio must be set greater than dirty_background_ratio or
+ratio corresponding to dirty_background_bytes.
+
 ==============================================================
 
 dirty_writeback_centisecs
diff -puN mm/page-writeback.c~mm-print-a-warning-once-the-vm-dirtiness-settings-is-illogical mm/page-writeback.c
--- a/mm/page-writeback.c~mm-print-a-warning-once-the-vm-dirtiness-settings-is-illogical
+++ a/mm/page-writeback.c
@@ -433,8 +433,11 @@ static void domain_dirty_limits(struct d
 	else
 		bg_thresh = (bg_ratio * available_memory) / PAGE_SIZE;
 
-	if (bg_thresh >= thresh)
+	if (unlikely(bg_thresh >= thresh)) {
+		pr_warn("vm direct limit must be set greater than background limit.\n");
 		bg_thresh = thresh / 2;
+	}
+
 	tsk = current;
 	if (tsk->flags & PF_LESS_THROTTLE || rt_task(tsk)) {
 		bg_thresh += bg_thresh / 4 + global_wb_domain.dirty_limit / 32;
_

Patches currently in -mm which might be from laoar.shao@gmail.com are


