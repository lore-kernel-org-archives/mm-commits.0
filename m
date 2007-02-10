From: akpm@linux-foundation.org
Subject: - kthread-api-conversion-for-dvb_frontend-and-av7110-fix.patch removed from -mm tree
Date: Fri, 09 Feb 2007 21:24:43 -0800
Message-ID: <200702100524.l1A5OhAm004590@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:36751 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752896AbXBJF0D (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sat, 10 Feb 2007 00:26:03 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, clg@fr.ibm.com, ebiederm@xmission.com, herbert@13thfloor.at, mchehab@infradead.org, o.endriss@gmx.de, mm-commits@vger.kernel.org


The patch titled
     kthread-api-conversion-for-dvb_frontend-and-av7110-fix
has been removed from the -mm tree.  Its filename was
     kthread-api-conversion-for-dvb_frontend-and-av7110-fix.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: kthread-api-conversion-for-dvb_frontend-and-av7110-fix
From: Andrew Morton <akpm@linux-foundation.org>

avoid double-up(), pointed out by Oliver.

Cc: Herbert Poetzl <herbert@13thfloor.at>
Cc: Cedric Le Goater <clg@fr.ibm.com>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Oliver Endriss <o.endriss@gmx.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/media/dvb/dvb-core/dvb_frontend.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/media/dvb/dvb-core/dvb_frontend.c~kthread-api-conversion-for-dvb_frontend-and-av7110-fix drivers/media/dvb/dvb-core/dvb_frontend.c
--- a/drivers/media/dvb/dvb-core/dvb_frontend.c~kthread-api-conversion-for-dvb_frontend-and-av7110-fix
+++ a/drivers/media/dvb/dvb-core/dvb_frontend.c
@@ -525,7 +525,7 @@ static int dvb_frontend_thread(void *dat
 
 	while (1) {
 		up(&fepriv->sem);	    /* is locked when we enter the thread... */
-
+restart:
 		timeout = wait_event_interruptible_timeout(fepriv->wait_queue,
 			dvb_frontend_should_wakeup(fe) || kthread_should_stop(),
 			fepriv->delay);
@@ -536,7 +536,7 @@ static int dvb_frontend_thread(void *dat
 		}
 
 		if (try_to_freeze())
-			continue;
+			goto restart;
 
 		if (down_interruptible(&fepriv->sem))
 			break;
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
git-acpi.patch
git-cifs-fix.patch
fix-warning-in-device_add_attrs.patch
git-drm.patch
git-dvb.patch
git-infiniband.patch
git-input.patch
git-libata-all.patch
sis-warning-fixes.patch
git-libata-all-lib-iomapc-fix-for-config_pci=n.patch
git-md-accel-fixes.patch
git-md-accel-warning-fixes.patch
git-md-accel-fix.patch
git-mips-fixup.patch
git-mtd.patch
git-netdev-all.patch
revert-drivers-net-tulip-dmfe-support-basic-carrier-detection.patch
git-backlight-sony-fix.patch
git-sh.patch
git-scsi-misc.patch
git-scsi-misc-fixup.patch
revert-md-avoid-possible-bug_on-in-md-bitmap-handling-for-git-block.patch
revert-x86_64-mm-msr-on-cpu.patch
x86_64-survive-having-no-irq-mapping-for-a-vector-fix.patch
mm-vm_insert_pfn-tidy.patch
smaps-add-clear_refs-file-to-clear-reference-fix.patch
swiotlb-uninlinings.patch
kprobes-list-all-active-probes-in-the-system-tidy.patch
mm-shrink-parent-dentries-when-shrinking-slab.patch
knfsd-sunrpc-teach-svc_sendto-to-deal-with-ipv6-addresses-tidy.patch
knfsd-sunrpc-support-ipv6-addresses-in-rpc-servers-udp-receive-path-tidy.patch
revert-x86_64-mm-putreg-check.patch
fbdev-driver-for-s3-trio-virge-update-2-fix.patch
deprecate-sa_interrupt-and-friends.patch
git-gccbug-fixup.patch
