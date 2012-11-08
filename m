From: akpm@linux-foundation.org
Subject: + kernel-remove-reference-to-feature-removal-scheduletxt.patch added to -mm tree
Date: Thu, 08 Nov 2012 12:14:45 -0800
Message-ID: <20121108201446.8816420004E@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-wg0-f74.google.com ([74.125.82.74]:44963 "EHLO
	mail-wg0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756614Ab2KHUOs (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 8 Nov 2012 15:14:48 -0500
Received: by mail-wg0-f74.google.com with SMTP id dt11so207031wgb.1
        for <mm-commits@vger.kernel.org>; Thu, 08 Nov 2012 12:14:47 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: boyu.mt@taobao.com


The patch titled
     Subject: kernel: remove reference to feature-removal-schedule.txt
has been added to the -mm tree.  Its filename is
     kernel-remove-reference-to-feature-removal-scheduletxt.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
@@ -1330,7 +1330,6 @@ static int cgroup_remount(struct super_b
 	if (ret)
 		goto out_unlock;
 
-	/* See feature-removal-schedule.txt */
 	if (opts.subsys_mask != root->actual_subsys_mask || opts.release_agent)
 		pr_warning("cgroup: option changes via remount are deprecated (pid=%d comm=%s)\n",
 			   task_tgid_nr(current), current->comm);
diff -puN kernel/module.c~kernel-remove-reference-to-feature-removal-scheduletxt kernel/module.c
--- a/kernel/module.c~kernel-remove-reference-to-feature-removal-scheduletxt
+++ a/kernel/module.c
@@ -375,9 +375,6 @@ static bool check_symbol(const struct sy
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

documentation-remove-reference-to-feature-removal-scheduletxt.patch
kernel-remove-reference-to-feature-removal-scheduletxt.patch
sound-remove-reference-to-feature-removal-scheduletxt.patch
drivers-remove-reference-to-feature-removal-scheduletxt.patch

