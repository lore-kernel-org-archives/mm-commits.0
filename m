From: akpm@linux-foundation.org
Subject: + taskstats-use-appropriate-printk-priority-level.patch added to -mm tree
Date: Thu, 27 Jan 2011 15:22:27 -0800
Message-ID: <201101272322.p0RNMR5d005787@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40427 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753799Ab1A0XW3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 27 Jan 2011 18:22:29 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: msb@chromium.org


The patch titled
     taskstats: use appropriate printk priority level
has been added to the -mm tree.  Its filename is
     taskstats-use-appropriate-printk-priority-level.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

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

fs-use-appropriate-printk-priority-level.patch
printk-allow-setting-default_message_level-via-kconfig.patch
taskstats-use-appropriate-printk-priority-level.patch

