From: akpm@linux-foundation.org
Subject: - kexec-jump-in-sync-with-hibernation-implementation.patch removed from -mm tree
Date: Mon, 18 Aug 2008 12:39:32 -0700
Message-ID: <200808181939.m7IJdWoI008331@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56164 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762698AbYHRTkL (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 18 Aug 2008 15:40:11 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ying.huang@intel.com, ebiederm@xmission.com, mingo@elte.hu, pavel@ucw.cz, rjw@sisk.pl, vgoyal@redhat.com, mm-commits@vger.kernel.org


The patch titled
     kexec jump: in sync with hibernation implementation
has been removed from the -mm tree.  Its filename was
     kexec-jump-in-sync-with-hibernation-implementation.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: kexec jump: in sync with hibernation implementation
From: Huang Ying <ying.huang@intel.com>

Add device_pm_lock() and device_pm_unlock() in kernel_kexec() in sync with
current hibernation implementation.

Signed-off-by: Huang Ying <ying.huang@intel.com>
Acked-by: Pavel Machek <pavel@ucw.cz>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Vivek Goyal <vgoyal@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/kexec.c |    2 ++
 1 file changed, 2 insertions(+)

diff -puN kernel/kexec.c~kexec-jump-in-sync-with-hibernation-implementation kernel/kexec.c
--- a/kernel/kexec.c~kexec-jump-in-sync-with-hibernation-implementation
+++ a/kernel/kexec.c
@@ -1457,6 +1457,7 @@ int kernel_kexec(void)
 		error = disable_nonboot_cpus();
 		if (error)
 			goto Resume_devices;
+		device_pm_lock();
 		local_irq_disable();
 		/* At this point, device_suspend() has been called,
 		 * but *not* device_power_down(). We *must*
@@ -1485,6 +1486,7 @@ int kernel_kexec(void)
 		device_power_up(PMSG_RESTORE);
  Enable_irqs:
 		local_irq_enable();
+		device_pm_unlock();
 		enable_nonboot_cpus();
  Resume_devices:
 		device_resume(PMSG_RESTORE);
_

Patches currently in -mm which might be from ying.huang@intel.com are

origin.patch

