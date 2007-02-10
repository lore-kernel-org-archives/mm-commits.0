From: akpm@linux-foundation.org
Subject: + scsi-schedule-returns-in-state-task_running.patch added to -mm tree
Date: Fri, 09 Feb 2007 16:12:35 -0800
Message-ID: <200702100012.l1A0CZfP030606@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:56558 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946779AbXBJAMi (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 9 Feb 2007 19:12:38 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, James.Bottomley@steeleye.com


The patch titled
     scsi: schedule() returns in state TASK_RUNNING
has been added to the -mm tree.  Its filename is
     scsi-schedule-returns-in-state-task_running.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: scsi: schedule() returns in state TASK_RUNNING
From: Andrew Morton <akpm@linux-foundation.org>

Hence we don't need to set it here.

Cc: James Bottomley <James.Bottomley@steeleye.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/scsi/scsi_error.c |    1 -
 1 files changed, 1 deletion(-)

diff -puN drivers/scsi/scsi_error.c~scsi-schedule-returns-in-state-task_running drivers/scsi/scsi_error.c
--- a/drivers/scsi/scsi_error.c~scsi-schedule-returns-in-state-task_running
+++ a/drivers/scsi/scsi_error.c
@@ -1542,7 +1542,6 @@ int scsi_error_handler(void *data)
 				printk("Error handler scsi_eh_%d sleeping\n",
 					shost->host_no));
 			schedule();
-			set_current_state(TASK_INTERRUPTIBLE);
 			continue;
 		}
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
acpi-bay-driver-warning-fix.patch
git-cifs-fix.patch
fix-warning-in-device_add_attrs.patch
git-drm.patch
git-dvb.patch
kthread-api-conversion-for-dvb_frontend-and-av7110-fix.patch
git-infiniband.patch
git-libata-all.patch
sis-warning-fixes.patch
git-libata-all-lib-iomapc-fix-for-config_pci=n.patch
git-md-accel-fixes.patch
git-md-accel-warning-fixes.patch
git-md-accel-fix.patch
git-netdev-all.patch
revert-drivers-net-tulip-dmfe-support-basic-carrier-detection.patch
git-net.patch
git-backlight-acpi-fix.patch
git-backlight-asus-fix.patch
git-backlight-sony-fix.patch
git-sh.patch
git-scsi-misc.patch
git-scsi-misc-fixup.patch
revert-md-avoid-possible-bug_on-in-md-bitmap-handling-for-git-block.patch
git-block.patch
revert-x86_64-mm-msr-on-cpu.patch
x86_64-survive-having-no-irq-mapping-for-a-vector-fix.patch
mm-vm_insert_pfn-tidy.patch
swiotlb-uninlinings.patch
kprobes-list-all-active-probes-in-the-system-tidy.patch
mm-shrink-parent-dentries-when-shrinking-slab.patch
knfsd-sunrpc-teach-svc_sendto-to-deal-with-ipv6-addresses-tidy.patch
knfsd-sunrpc-support-ipv6-addresses-in-rpc-servers-udp-receive-path-tidy.patch
revert-x86_64-mm-putreg-check.patch
fix-utrace-utrace-ptrace-compat.patch
deprecate-sa_interrupt-and-friends.patch
git-gccbug-fixup.patch
scsi-schedule-returns-in-state-task_running.patch
