From: akpm@linux-foundation.org
Subject: - x86_64-restore-restore-nohpet-cmdline.patch removed from -mm tree
Date: Fri, 24 Aug 2007 14:47:40 -0700
Message-ID: <200708242147.l7OLleSn016266@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:49901 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757049AbXHXVss (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 24 Aug 2007 17:48:48 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: chrisw@sous-sol.org, ak@suse.de, johnstul@us.ibm.com, mingo@elte.hu, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     x86_64: restore restore nohpet cmdline
has been removed from the -mm tree.  Its filename was
     x86_64-restore-restore-nohpet-cmdline.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
Subject: x86_64: restore restore nohpet cmdline
From: Chris Wright <chrisw@sous-sol.org>

Lost when merged with i386.  Happy to drop, but I suspect Andi would rather
not break existing users (I noticed because it was part of my testing).  If
dropped, Documentation needs updating.

Signed-off-by: Chris Wright <chrisw@sous-sol.org>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Andi Kleen <ak@suse.de>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: john stultz <johnstul@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/i386/kernel/hpet.c |    7 +++++++
 1 files changed, 7 insertions(+)

diff -puN arch/i386/kernel/hpet.c~x86_64-restore-restore-nohpet-cmdline arch/i386/kernel/hpet.c
--- a/arch/i386/kernel/hpet.c~x86_64-restore-restore-nohpet-cmdline
+++ a/arch/i386/kernel/hpet.c
@@ -49,6 +49,13 @@ static int __init hpet_setup(char* str)
 }
 __setup("hpet=", hpet_setup);
 
+static int __init disable_hpet(char *str)
+{
+	boot_hpet_disable = 1;
+	return 1;
+}
+__setup("nohpet", disable_hpet);
+
 static inline int is_hpet_capable(void)
 {
 	return (!boot_hpet_disable && hpet_address);
_

Patches currently in -mm which might be from chrisw@sous-sol.org are

origin.patch
x86_64-restore-restore-nohpet-cmdline.patch
x86_64-prep-idle-loop-for-dynticks.patch
x86_64-enable-high-resolution-timers-and-dynticks.patch
security-convert-lsm-into-a-static-interface.patch
security-convert-lsm-into-a-static-interface-fix.patch
security-convert-lsm-into-a-static-interface-fix-2.patch
security-convert-lsm-into-a-static-interface-fix-2-fix.patch
security-convert-lsm-into-a-static-interface-fix-unionfs.patch
implement-file-posix-capabilities.patch
implement-file-posix-capabilities-fix.patch
file-capabilities-introduce-cap_setfcap.patch
file-capabilities-get_file_caps-cleanups.patch
file-caps-update-selinux-xattr-hooks.patch
file-capabilities-clear-caps-cleanup.patch
file-capabilities-clear-caps-cleanup-fix.patch
file-capabilities-change-xattr-format-v2.patch
file-capabilities-change-fe-to-a-bool.patch
file-caps-clean-up-for-linux-capabilityh.patch
capabilityh-remove-include-of-currenth.patch
file-capabilities-clear-fcaps-on-inode-change.patch
security-cleanups.patch
use-erestart_restartblock-if-poll-is-interrupted-by-a-signal.patch
whitespace-fixes-capability-syscalls.patch
