From: akpm@linux-foundation.org
Subject: - cisco_ioctl-initialise-header_cache_update.patch removed from -mm tree
Date: Fri, 02 Mar 2007 16:39:08 -0800
Message-ID: <200703030039.l230d8tp023926@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:49962 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2992802AbXCCAjO (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 2 Mar 2007 19:39:14 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, davem@davemloft.net, khc@pm.waw.pl, shemminger@linux-foundation.org, mm-commits@vger.kernel.org


The patch titled
     cisco_ioctl(): initialise header_cache_update
has been removed from the -mm tree.  Its filename was
     cisco_ioctl-initialise-header_cache_update.patch

This patch was dropped because it is obsolete

------------------------------------------------------
Subject: cisco_ioctl(): initialise header_cache_update
From: Andrew Morton <akpm@linux-foundation.org>

Fix http://bugzilla.kernel.org/show_bug.cgi?id=8107: we weren't initialising
the header_cache_update field.

(akpm: this isn't really needed at this time, because, as shemminger points
out, "there is no ioctl to take it out of this mode.  So it is a one way
door".  This device never calls hdlc->detach??)

Cc: Krzysztof Halasa <khc@pm.waw.pl>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Stephen Hemminger <shemminger@linux-foundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/wan/hdlc_cisco.c |    1 +
 1 files changed, 1 insertion(+)

diff -puN drivers/net/wan/hdlc_cisco.c~cisco_ioctl-initialise-header_cache_update drivers/net/wan/hdlc_cisco.c
--- a/drivers/net/wan/hdlc_cisco.c~cisco_ioctl-initialise-header_cache_update
+++ a/drivers/net/wan/hdlc_cisco.c
@@ -366,6 +366,7 @@ static int cisco_ioctl(struct net_device
 		dev->hard_start_xmit = hdlc->xmit;
 		dev->hard_header = cisco_hard_header;
 		dev->hard_header_cache = NULL;
+		dev->header_cache_update = NULL;
 		dev->type = ARPHRD_CISCO;
 		dev->flags = IFF_POINTOPOINT | IFF_NOARP;
 		dev->addr_len = 0;
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
cyclades-return-closing_wait.patch
md-fix-for-raid6-reshape-fix.patch
slab-introduce-krealloc-fix.patch
make-aout-executables-work-again-fix.patch
sony-laptop-fix-uninitialised-variable.patch
git-alsa-oops-fix.patch
git-drm.patch
git-dvb.patch
git-dvb-fixup.patch
pvrusb-warning-fix.patch
git-input.patch
setstream-param-for-psmouse-tweak.patch
git-kvm.patch
git-kvm-fixup.patch
git-leds-fixup.patch
git-leds-make-it-compile.patch
ide-ide-fix-pmac-breakage-fix.patch
git-md-accel-fixup.patch
nommu-present-backing-device-capabilities-for-mtd-fix.patch
git-ubi.patch
git-netdev-all.patch
revert-drivers-net-tulip-dmfe-support-basic-carrier-detection.patch
dmfe-add-support-for-suspend-resume-fix.patch
sis900-warning-fixes.patch
cisco_ioctl-initialise-header_cache_update.patch
bonding-replace-system-timer-with-work-queue-tidy.patch
rm9000-serial-driver-tidy.patch
git-pciseg.patch
revert-md-avoid-possible-bug_on-in-md-bitmap-handling-for-git-block.patch
git-block-fixup.patch
git-block-another-md-fix.patch
git-unionfs.patch
usbatm-create-sysfs-link-device-from-atm-class-device-tidy.patch
revert-x86_64-mm-change-sysenter_setup-to-__cpuinit-improve-__init-__initdata.patch
after-before-x86_64-mm-mmconfig-share.patch
linux-sysdevh-needs-to-include-linux-moduleh-up-fix.patch
linux-sysdevh-needs-to-include-linux-moduleh-up-fix-2.patch
safer-nr_node_ids-and-nr_node_ids-determination-and-initial-up-fix.patch
safer-nr_node_ids-and-nr_node_ids-determination-and-initial-tweak.patch
smaps-add-clear_refs-file-to-clear-reference-fix.patch
driver_bfin_serial_core-update.patch
fix-rmmod-read-write-races-in-proc-entries-fix.patch
reduce-size-of-task_struct-on-64-bit-machines.patch
mm-shrink-parent-dentries-when-shrinking-slab.patch
merge-sys_clone-sys_unshare-nsproxy-and-namespace-fix.patch
merge-sys_clone-sys_unshare-nsproxy-and-namespace-fix-2.patch
call-cpu_chain-with-cpu_down_failed-if-cpu_down_prepare-failed-vs-reduce-size-of-task_struct-on-64-bit-machines.patch
speedup-divides-by-cpu_power-in-scheduler-up-fix.patch
lutimesat-compat-syscall-and-wire-up-on-x86_64-tidy.patch
utrace-prep.patch
utrace-prep-2.patch
revert-utrace-prep-2.patch
utrace-vs-reduce-size-of-task_struct-on-64-bit-machines.patch
local_t-mips-extension-shrink-duplicated-mips-32-64-bits-functions-from-localh-fix.patch
linux-kernel-markers-kconfig-menus-fix-4.patch
fbdev-hecuba-framebuffer-driver-fix.patch
