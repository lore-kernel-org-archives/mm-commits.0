From: akpm@linux-foundation.org
Subject: [merged] kernel-remove-reference-to-feature-removal-scheduletxt.patch removed from -mm tree
Date: Tue, 18 Dec 2012 12:02:42 -0800
Message-ID: <20121218200243.18E5E20004E@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-fa0-f74.google.com ([209.85.161.74]:59806 "EHLO
	mail-fa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751357Ab2LRUCp (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 18 Dec 2012 15:02:45 -0500
Received: by mail-fa0-f74.google.com with SMTP id t1so63042fae.5
        for <mm-commits@vger.kernel.org>; Tue, 18 Dec 2012 12:02:44 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: boyu.mt@taobao.com, mm-commits@vger.kernel.org


The patch titled
     Subject: kernel: remove reference to feature-removal-schedule.txt
has been removed from the -mm tree.  Its filename was
     kernel-remove-reference-to-feature-removal-scheduletxt.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Tao Ma <boyu.mt@taobao.com>
Subject: kernel: remove reference to feature-removal-schedule.txt

In 9c0ece069, Linus removed feature-removal-schedule.txt from Documentation,
but there is still some reference to this file. So remove them.

Signed-off-by: Tao Ma <boyu.mt@taobao.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/cgroup.c |    1 -
 kernel/module.c |    3 ---
 2 files changed, 4 deletions(-)

diff -puN kernel/cgroup.c~kernel-remove-reference-to-feature-removal-scheduletxt kernel/cgroup.c
--- a/kernel/cgroup.c~kernel-remove-reference-to-feature-removal-scheduletxt
+++ a/kernel/cgroup.c
@@ -1333,7 +1333,6 @@ static int cgroup_remount(struct super_b
 	if (ret)
 		goto out_unlock;
 
-	/* See feature-removal-schedule.txt */
 	if (opts.subsys_mask != root->actual_subsys_mask || opts.release_agent)
 		pr_warning("cgroup: option changes via remount are deprecated (pid=%d comm=%s)\n",
 			   task_tgid_nr(current), current->comm);
diff -puN kernel/module.c~kernel-remove-reference-to-feature-removal-scheduletxt kernel/module.c
--- a/kernel/module.c~kernel-remove-reference-to-feature-removal-scheduletxt
+++ a/kernel/module.c
@@ -372,9 +372,6 @@ static bool check_symbol(const struct sy
 			printk(KERN_WARNING "Symbol %s is being used "
 			       "by a non-GPL module, which will not "
 			       "be allowed in the future\n", fsa->name);
-			printk(KERN_WARNING "Please see the file "
-			       "Documentation/feature-removal-schedule.txt "
-			       "in the kernel source tree for more details.\n");
 		}
 	}
 
_

Patches currently in -mm which might be from boyu.mt@taobao.com are

origin.patch

