From: akpm@linux-foundation.org
Subject: - git-wireless-fixup.patch removed from -mm tree
Date: Tue, 20 Feb 2007 12:07:17 -0800
Message-ID: <200702202007.l1KK7HVP018151@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:46779 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965250AbXBTUHU (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Tue, 20 Feb 2007 15:07:20 -0500
Received: from shell0.pdx.osdl.net (fw.osdl.org [65.172.181.6])
	by smtp.osdl.org (8.12.8/8.12.8) with ESMTP id l1KK7IhB021754
	(version=TLSv1/SSLv3 cipher=EDH-RSA-DES-CBC3-SHA bits=168 verify=NO)
	for <mm-commits@vger.kernel.org>; Tue, 20 Feb 2007 12:07:18 -0800
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, mm-commits@vger.kernel.org


The patch titled
     git-wireless-fixup
has been removed from the -mm tree.  Its filename was
     git-wireless-fixup.patch

This patch was dropped because it is obsolete

------------------------------------------------------
Subject: git-wireless-fixup
From: Andrew Morton <akpm@linux-foundation.org>

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 net/ieee80211/softmac/ieee80211softmac_module.c |    8 +-------
 net/ieee80211/softmac/ieee80211softmac_wx.c     |    6 ------
 2 files changed, 1 insertion(+), 13 deletions(-)

diff -puN net/ieee80211/softmac/ieee80211softmac_module.c~git-wireless-fixup net/ieee80211/softmac/ieee80211softmac_module.c
--- a/net/ieee80211/softmac/ieee80211softmac_module.c~git-wireless-fixup
+++ a/net/ieee80211/softmac/ieee80211softmac_module.c
@@ -265,18 +265,12 @@ void ieee80211softmac_init_bss(struct ie
 	/* Change the default txrate to the highest possible value.
 	 * The txrate machine will lower it, if it is too high.
 	 */
-<<<<<<< HEAD/net/ieee80211/softmac/ieee80211softmac_module.c
 	/* FIXME: We don't correctly handle backing down to lower
 	   rates, so 801.11g devices start off at 11M for now. People
 	   can manually change it if they really need to, but 11M is
 	   more reliable. Note similar logic in
 	   ieee80211softmac_wx_set_rate() */
-	if (ieee->modulation & IEEE80211_CCK_MODULATION) {
-=======
-	if (ieee->modulation & IEEE80211_OFDM_MODULATION)
-		txrates->user_rate = IEEE80211_OFDM_RATE_24MB;
-	else
->>>>>>> /net/ieee80211/softmac/ieee80211softmac_module.c
+	if (ieee->modulation & IEEE80211_CCK_MODULATION)
 		txrates->user_rate = IEEE80211_CCK_RATE_11MB;
 
 	txrates->default_rate = IEEE80211_CCK_RATE_1MB;
diff -puN net/ieee80211/softmac/ieee80211softmac_wx.c~git-wireless-fixup net/ieee80211/softmac/ieee80211softmac_wx.c
--- a/net/ieee80211/softmac/ieee80211softmac_wx.c~git-wireless-fixup
+++ a/net/ieee80211/softmac/ieee80211softmac_wx.c
@@ -177,18 +177,12 @@ ieee80211softmac_wx_set_rate(struct net_
 	int err = -EINVAL;
 
 	if (in_rate == -1) {
-<<<<<<< HEAD/net/ieee80211/softmac/ieee80211softmac_wx.c
 		/* FIXME: We don't correctly handle backing down to lower
 		   rates, so 801.11g devices start off at 11M for now. People
 		   can manually change it if they really need to, but 11M is
 		   more reliable. Note similar logic in
 		   ieee80211softmac_wx_set_rate() */
 		if (ieee->modulation & IEEE80211_CCK_MODULATION)
-=======
-		if (ieee->modulation & IEEE80211_OFDM_MODULATION)
-			in_rate = 24000000;
-		else
->>>>>>> /net/ieee80211/softmac/ieee80211softmac_wx.c
 			in_rate = 11000000;
 	}
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
xfs-warning-fix.patch
rework-reserved-major-handling.patch
make-aout-executables-work-again-fix.patch
sony-laptop-fix-uninitialised-variable.patch
git-drm.patch
git-dvb.patch
pvrusb-warning-fix.patch
git-input.patch
setstream-param-for-psmouse-tweak.patch
git-libata-all.patch
dmaengine-uninline-large-functions.patch
git-mips-fixup.patch
Fabric7-VIOC-driver-fixes.patch
revert-drivers-net-tulip-dmfe-support-basic-carrier-detection.patch
dmfe-add-support-for-suspend-resume-fix.patch
sis900-warning-fixes.patch
git-parisc.patch
git-parisc-fixup.patch
git-pciseg.patch
git-s390.patch
revert-md-avoid-possible-bug_on-in-md-bitmap-handling-for-git-block.patch
git-block-fixup.patch
git-unionfs.patch
git-unionfs-fixup.patch
git-wireless-fixup.patch
after-before-x86_64-mm-mmconfig-share.patch
xen-paravirt-core-xen-implementation-fix.patch
mincore-warning-fix.patch
smaps-add-clear_refs-file-to-clear-reference-fix.patch
fix-rmmod-read-write-races-in-proc-entries-fix.patch
kprobes-list-all-active-probes-in-the-system.patch
reduce-size-of-task_struct-on-64-bit-machines-fix.patch
mm-shrink-parent-dentries-when-shrinking-slab.patch
add-epoll-compat-code-to-kernel-compatc-tidy.patch
genalloc-warning-fixes.patch
call-cpu_chain-with-cpu_down_failed-if-cpu_down_prepare-failed-vs-reduce-size-of-task_struct-on-64-bit-machines.patch
utrace-vs-reduce-size-of-task_struct-on-64-bit-machines.patch
local_t-mips-extension-shrink-duplicated-mips-32-64-bits-functions-from-localh-fix.patch
linux-kernel-markers-kconfig-menus-fix-4.patch
fb-sm501-framebuffer-driver-5-fix.patch
