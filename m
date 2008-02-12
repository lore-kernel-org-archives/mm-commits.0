From: akpm@linux-foundation.org
Subject: - softlockup-debug.patch removed from -mm tree
Date: Tue, 12 Feb 2008 12:48:54 -0800
Message-ID: <200802122057.m1CKvqc5021824@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:60805 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753188AbYBLU6L (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 12 Feb 2008 15:58:11 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dmitry.adamushko@gmail.com, mingo@elte.hu, mm-commits@vger.kernel.org


The patch titled
     softlockup debug
has been removed from the -mm tree.  Its filename was
     softlockup-debug.patch

This patch was dropped because it is obsolete

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: softlockup debug
From: "Dmitry Adamushko" <dmitry.adamushko@gmail.com>

Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/softlockup.c |    2 ++
 1 file changed, 2 insertions(+)

diff -puN kernel/softlockup.c~softlockup-debug kernel/softlockup.c
--- a/kernel/softlockup.c~softlockup-debug
+++ a/kernel/softlockup.c
@@ -289,6 +290,7 @@ cpu_callback(struct notifier_block *nfb,
 	case CPU_DEAD_FROZEN:
 		p = per_cpu(watchdog_task, hotcpu);
 		per_cpu(watchdog_task, hotcpu) = NULL;
+		printk(KERN_ERR "kthread_stop(watchdog on cpu: %d)\n", hotcpu);
 		kthread_stop(p);
 		break;
 #endif /* CONFIG_HOTPLUG_CPU */
_

Patches currently in -mm which might be from dmitry.adamushko@gmail.com are

origin.patch
softlockup-workaround.patch
softlockup-debug.patch
softlockup-debug2.patch
