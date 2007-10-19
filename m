From: akpm@linux-foundation.org
Subject: - x86-msr-driver-misc-cpuinit-annotations.patch removed from -mm tree
Date: Thu, 18 Oct 2007 20:45:03 -0700
Message-ID: <200710190345.l9J3j3fo013196@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:55773 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934495AbXJSD4e (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 18 Oct 2007 23:56:34 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: satyam@infradead.org, ak@suse.de, hpa@zytor.com, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     x86 msr driver: Misc cpuinit annotations
has been removed from the -mm tree.  Its filename was
     x86-msr-driver-misc-cpuinit-annotations.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: x86 msr driver: Misc cpuinit annotations
From: Satyam Sharma <satyam@infradead.org>

msr_class_cpu_callback() can be marked __cpuinit, being the notifier callback
for a __cpuinitdata notifier_block.  So can be marked msr_device_create() too,
called only from the newly-__cpuinit msr_class_cpu_callback() or from
__init-marked msr_init().

Signed-off-by: Satyam Sharma <satyam@infradead.org>
Cc: Andi Kleen <ak@suse.de>
Acked-by: H. Peter Anvin <hpa@zytor.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/kernel/msr.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN arch/x86/kernel/msr.c~x86-msr-driver-misc-cpuinit-annotations arch/x86/kernel/msr.c
--- a/arch/x86/kernel/msr.c~x86-msr-driver-misc-cpuinit-annotations
+++ a/arch/x86/kernel/msr.c
@@ -133,7 +133,7 @@ static const struct file_operations msr_
 	.open = msr_open,
 };
 
-static int msr_device_create(int cpu)
+static int __cpuinit msr_device_create(int cpu)
 {
 	struct device *dev;
 
_

Patches currently in -mm which might be from satyam@infradead.org are

origin.patch
git-watchdog.patch
