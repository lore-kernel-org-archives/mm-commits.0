From: akpm@linux-foundation.org
Subject: - fix-kevents-childs-priority-greediness.patch removed from -mm tree
Date: Tue, 08 May 2007 19:48:31 -0700
Message-ID: <200705090248.l492mV3D009120@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:54702 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S967076AbXEICtV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 May 2007 22:49:21 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jengelh@linux01.gwdg.de, chrisw@sous-sol.org, jengelh@gmx.de, mm-commits@vger.kernel.org


The patch titled
     Fix kevent's childs priority greediness
has been removed from the -mm tree.  Its filename was
     fix-kevents-childs-priority-greediness.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Fix kevent's childs priority greediness
From: Jan Engelhardt <jengelh@linux01.gwdg.de>

Fix kevent's childs priority greediness.  Such tasks were always scheduled
at nice level -5 and, at that time, udev stole us the CPU time with -5.

Already posted at http://lkml.org/lkml/2005/1/10/85

[akpm@linux-foundation.org: add comment]
Signed-off-by: Jan Engelhardt <jengelh@gmx.de>
Cc: Chris Wright <chrisw@sous-sol.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/kmod.c |    6 ++++++
 1 file changed, 6 insertions(+)

diff -puN kernel/kmod.c~fix-kevents-childs-priority-greediness kernel/kmod.c
--- a/kernel/kmod.c~fix-kevents-childs-priority-greediness
+++ a/kernel/kmod.c
@@ -165,6 +165,12 @@ static int ____call_usermodehelper(void 
 	/* We can run anywhere, unlike our parent keventd(). */
 	set_cpus_allowed(current, CPU_MASK_ALL);
 
+	/*
+	 * Our parent is keventd, which runs with elevated scheduling priority.
+	 * Avoid propagating that into the userspace child.
+	 */
+	set_user_nice(current, 0);
+
 	retval = -EPERM;
 	if (current->fs->root)
 		retval = kernel_execve(sub_info->path,
_

Patches currently in -mm which might be from jengelh@linux01.gwdg.de are

origin.patch
git-dvb.patch
git-watchdog.patch
use-menuconfig-objects-acpi.patch
use-menuconfig-objects-libata.patch
use-menuconfig-objects-block-layer.patch
use-menuconfig-objects-connector.patch
use-menuconfig-objects-crypto.patch
use-menuconfig-objects-crypto-hw.patch
use-menuconfig-objects-dccp.patch
use-menuconfig-objects-i2o.patch
use-menuconfig-objects-ide.patch
use-menuconfig-objects-ipvs.patch
use-menuconfig-objects-sctp.patch
use-menuconfig-objects-tipc.patch
use-menuconfig-objects-arcnet.patch
use-menuconfig-objects-phy.patch
use-menuconfig-objects-toeknring.patch
use-menuconfig-objects-netdev.patch
use-menuconfig-objects-oldcd.patch
use-menuconfig-objects-parport.patch
use-menuconfig-objects-pcmcia.patch
use-menuconfig-objects-pnp.patch
use-menuconfig-objects-w1.patch
