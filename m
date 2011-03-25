From: akpm@linux-foundation.org
Subject: [merged] taskstats-use-appropriate-printk-priority-level.patch removed from -mm tree
Date: Fri, 25 Mar 2011 00:27:03 -0700
Message-ID: <201103250726.p2P7Qvo0026199@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57808 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933960Ab1CYH06 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 25 Mar 2011 03:26:58 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: msb@chromium.org, mm-commits@vger.kernel.org


The patch titled
     taskstats: use appropriate printk priority level
has been removed from the -mm tree.  Its filename was
     taskstats-use-appropriate-printk-priority-level.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: taskstats: use appropriate printk priority level
From: Mandeep Singh Baines <msb@chromium.org>

printk()s without a priority level default to KERN_WARNING.  To reduce
noise at KERN_WARNING, this patch set the priority level appriopriately
for unleveled printks()s.  This should be useful to folks that look at
dmesg warnings closely.

Signed-off-by: Mandeep Singh Baines <msb@chromium.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/taskstats.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN kernel/taskstats.c~taskstats-use-appropriate-printk-priority-level kernel/taskstats.c
--- a/kernel/taskstats.c~taskstats-use-appropriate-printk-priority-level
+++ a/kernel/taskstats.c
@@ -685,7 +685,7 @@ static int __init taskstats_init(void)
 		goto err_cgroup_ops;
 
 	family_registered = 1;
-	printk("registered taskstats version %d\n", TASKSTATS_GENL_VERSION);
+	pr_info("registered taskstats version %d\n", TASKSTATS_GENL_VERSION);
 	return 0;
 err_cgroup_ops:
 	genl_unregister_ops(&family, &taskstats_ops);
_

Patches currently in -mm which might be from msb@chromium.org are

origin.patch

