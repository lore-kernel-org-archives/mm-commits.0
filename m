From: akpm@linux-foundation.org
Subject: + git-netdev-all-ipw2200-fix.patch added to -mm tree
Date: Mon, 05 Mar 2007 01:39:27 -0800
Message-ID: <200703050941.l259f5DW015093@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:38580 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932579AbXCEJlH (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Mon, 5 Mar 2007 04:41:07 -0500
Received: from shell0.pdx.osdl.net (fw.osdl.org [65.172.181.6])
	by smtp.osdl.org (8.12.8/8.12.8) with ESMTP id l259f5q8017071
	(version=TLSv1/SSLv3 cipher=EDH-RSA-DES-CBC3-SHA bits=168 verify=NO)
	for <mm-commits@vger.kernel.org>; Mon, 5 Mar 2007 01:41:06 -0800
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org


The patch titled
     git-netdev-all: ipw2200 fix
has been added to the -mm tree.  Its filename is
     git-netdev-all-ipw2200-fix.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: git-netdev-all: ipw2200 fix
From: Andrew Morton <akpm@linux-foundation.org>

drivers/net/wireless/ipw2200.c: In function 'show_channels':
drivers/net/wireless/ipw2200.c:1855: warning: implicit declaration of function 'ipw_get_geo'
drivers/net/wireless/ipw2200.c:1855: warning: initialization makes pointer from integer without a cast


Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/wireless/ipw2200.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/net/wireless/ipw2200.c~git-netdev-all-ipw2200-fix drivers/net/wireless/ipw2200.c
--- a/drivers/net/wireless/ipw2200.c~git-netdev-all-ipw2200-fix
+++ a/drivers/net/wireless/ipw2200.c
@@ -1852,7 +1852,7 @@ static ssize_t show_channels(struct devi
 			     char *buf)
 {
 	struct ipw_priv *priv = dev_get_drvdata(d);
-	const struct ieee80211_geo *geo = ipw_get_geo(priv->ieee);
+	const struct ieee80211_geo *geo = ieee80211_get_geo(priv->ieee);
 	int len = 0, i;
 
 	len = sprintf(&buf[len],
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
cyclades-return-closing_wait.patch
slab-introduce-krealloc-fix.patch
make-aout-executables-work-again-fix.patch
sony-laptop-fix-uninitialised-variable.patch
git-alsa-oops-fix.patch
git-drm.patch
git-dvb.patch
ia64-kexec-use-efi_loader_data-for-elf-core-header-tidy.patch
git-input.patch
setstream-param-for-psmouse-tweak.patch
git-md-accel-fixup.patch
nommu-present-backing-device-capabilities-for-mtd-fix.patch
git-ubi.patch
git-netdev-all.patch
git-netdev-all-ipw2200-fix.patch
revert-drivers-net-tulip-dmfe-support-basic-carrier-detection.patch
dmfe-add-support-for-suspend-resume-fix.patch
sis900-warning-fixes.patch
div64_64-common-code-fix.patch
bonding-replace-system-timer-with-work-queue-tidy.patch
git-parisc.patch
rm9000-serial-driver-tidy.patch
cleanup-the-includes-of-linux-pcih-fix.patch
git-pciseg.patch
revert-md-avoid-possible-bug_on-in-md-bitmap-handling-for-git-block.patch
git-block-fixup.patch
git-block-another-md-fix.patch
git-unionfs.patch
usbatm-create-sysfs-link-device-from-atm-class-device-tidy.patch
git-wireless-fixup.patch
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
mm-only-free-swap-space-of-reactivated-pages-debug.patch
