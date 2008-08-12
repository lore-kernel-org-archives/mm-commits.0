From: akpm@linux-foundation.org
Subject: + kexec-jump-in-sync-with-hibernation-implementation.patch added to -mm tree
Date: Tue, 12 Aug 2008 16:15:49 -0700
Message-ID: <200808122315.m7CNFnDK018745@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44371 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752034AbYHLXQl (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 12 Aug 2008 19:16:41 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ying.huang@intel.com, ebiederm@xmission.com, mingo@elte.hu, pavel@ucw.cz, rjw@sisk.pl, vgoyal@redhat.com


The patch titled
     kexec jump: in sync with hibernation implementation
has been added to the -mm tree.  Its filename is
     kexec-jump-in-sync-with-hibernation-implementation.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
kexec-jump-clean-up-ifdef-and-comments.patch
kexec-jump-rename-kexec_control_code_size-to-kexec_control_page_size.patch
kexec-jump-check-code-size-in-control-page.patch
kexec-jump-remove-duplication-of-kexec_restart_prepare.patch
kexec-jump-in-sync-with-hibernation-implementation.patch
kexec-jump-__ftrace_enabled_save-restore.patch
kexec-jump-fix-for-ftrace.patch

