From: akpm@linux-foundation.org
Subject: - x86-fix-crash-on-cpu-hotplug-on-pat-incapable-machines.patch removed from -mm tree
Date: Mon, 19 May 2008 02:18:45 -0700
Message-ID: <200805190918.m4J9IjPK025364@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58292 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753587AbYESJTQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 19 May 2008 05:19:16 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: avi@qumranet.com, mm-commits@vger.kernel.org


The patch titled
     x86: fix crash on cpu hotplug on pat-incapable machines
has been removed from the -mm tree.  Its filename was
     x86-fix-crash-on-cpu-hotplug-on-pat-incapable-machines.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: x86: fix crash on cpu hotplug on pat-incapable machines
From: Avi Kivity <avi@qumranet.com>

pat_disable() is __init, which means it goes away after booting is
complete.  Unfortunately it is used by the hotplug code if the machine is
not pat-capable, causing a crash.

Fix by marking pat_disable() as __cpuinit.

Signed-off-by: Avi Kivity <avi@qumranet.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/mm/pat.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN arch/x86/mm/pat.c~x86-fix-crash-on-cpu-hotplug-on-pat-incapable-machines arch/x86/mm/pat.c
--- a/arch/x86/mm/pat.c~x86-fix-crash-on-cpu-hotplug-on-pat-incapable-machines
+++ a/arch/x86/mm/pat.c
@@ -28,7 +28,7 @@
 #ifdef CONFIG_X86_PAT
 int __read_mostly pat_wc_enabled = 1;
 
-void __init pat_disable(char *reason)
+void __cpuinit pat_disable(char *reason)
 {
 	pat_wc_enabled = 0;
 	printk(KERN_INFO "%s\n", reason);
_

Patches currently in -mm which might be from avi@qumranet.com are

linux-next.patch

