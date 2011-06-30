From: akpm@linux-foundation.org
Subject: + drivers-net-wireless-rtlwifi-rtl8192de-phyc-fix-udelay-usage.patch added to -mm tree
Date: Thu, 30 Jun 2011 13:23:06 -0700
Message-ID: <201106302100.p5UL0fF6012922@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43467 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751913Ab1F3VB2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 30 Jun 2011 17:01:28 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, Larry.Finger@lwfinger.net, chaoming_li@realsil.com.cn, linville@tuxdriver.com


The patch titled
     drivers/net/wireless/rtlwifi/rtl8192de/phy.c: fix udelay() usage
has been added to the -mm tree.  Its filename is
     drivers-net-wireless-rtlwifi-rtl8192de-phyc-fix-udelay-usage.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: drivers/net/wireless/rtlwifi/rtl8192de/phy.c: fix udelay() usage
From: Andrew Morton <akpm@linux-foundation.org>

ERROR: "__bad_udelay" [drivers/net/wireless/rtlwifi/rtl8192de/rtl8192de.ko] undefined!

Cc: Chaoming_Li <chaoming_li@realsil.com.cn>
Cc: Larry Finger <Larry.Finger@lwfinger.net>
Cc: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/wireless/rtlwifi/rtl8192de/phy.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff -puN drivers/net/wireless/rtlwifi/rtl8192de/phy.c~drivers-net-wireless-rtlwifi-rtl8192de-phyc-fix-udelay-usage drivers/net/wireless/rtlwifi/rtl8192de/phy.c
--- a/drivers/net/wireless/rtlwifi/rtl8192de/phy.c~drivers-net-wireless-rtlwifi-rtl8192de-phyc-fix-udelay-usage
+++ a/drivers/net/wireless/rtlwifi/rtl8192de/phy.c
@@ -1684,7 +1684,7 @@ static u8 _rtl92d_phy_patha_iqk(struct i
 	RTPRINT(rtlpriv, FINIT, INIT_IQK,
 		("Delay %d ms for One shot, path A LOK & IQK.\n",
 		IQK_DELAY_TIME));
-	udelay(IQK_DELAY_TIME * 1000);
+	mdelay(IQK_DELAY_TIME);
 	/* Check failed */
 	regeac = rtl_get_bbreg(hw, 0xeac, BMASKDWORD);
 	RTPRINT(rtlpriv, FINIT, INIT_IQK, ("0xeac = 0x%x\n", regeac));
@@ -1755,7 +1755,7 @@ static u8 _rtl92d_phy_patha_iqk_5g_norma
 		RTPRINT(rtlpriv, FINIT, INIT_IQK,
 			("Delay %d ms for One shot, path A LOK & IQK.\n",
 			IQK_DELAY_TIME));
-		udelay(IQK_DELAY_TIME * 1000 * 10);
+		mdelay(IQK_DELAY_TIME * 10);
 		/* Check failed */
 		regeac = rtl_get_bbreg(hw, 0xeac, BMASKDWORD);
 		RTPRINT(rtlpriv, FINIT, INIT_IQK, ("0xeac = 0x%x\n", regeac));
@@ -1808,7 +1808,7 @@ static u8 _rtl92d_phy_pathb_iqk(struct i
 	RTPRINT(rtlpriv, FINIT, INIT_IQK,
 		("Delay %d ms for One shot, path B LOK & IQK.\n",
 		IQK_DELAY_TIME));
-	udelay(IQK_DELAY_TIME * 1000);
+	mdelay(IQK_DELAY_TIME);
 	/* Check failed */
 	regeac = rtl_get_bbreg(hw, 0xeac, BMASKDWORD);
 	RTPRINT(rtlpriv, FINIT, INIT_IQK, ("0xeac = 0x%x\n", regeac));
@@ -1875,7 +1875,7 @@ static u8 _rtl92d_phy_pathb_iqk_5g_norma
 		/* delay x ms */
 		RTPRINT(rtlpriv, FINIT, INIT_IQK,
 			("Delay %d ms for One shot, path B LOK & IQK.\n", 10));
-		udelay(IQK_DELAY_TIME * 1000 * 10);
+		mdelay(IQK_DELAY_TIME * 10);
 
 		/* Check failed */
 		regeac = rtl_get_bbreg(hw, 0xeac, BMASKDWORD);
@@ -2206,7 +2206,7 @@ static void _rtl92d_phy_iq_calibrate_5g_
 	 * PHY_REG.txt , and radio_a, radio_b.txt */
 
 	RTPRINT(rtlpriv, FINIT, INIT_IQK, ("IQK for 5G NORMAL:Start!!!\n"));
-	udelay(IQK_DELAY_TIME * 1000 * 20);
+	mdelay(IQK_DELAY_TIME * 20);
 	if (t == 0) {
 		bbvalue = rtl_get_bbreg(hw, RFPGA0_RFMOD, BMASKDWORD);
 		RTPRINT(rtlpriv, FINIT, INIT_IQK, ("==>0x%08x\n", bbvalue));
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
memcg-fix-reclaimable-lru-check-in-memcg-checkpatch-fixes.patch
memcg-fix-reclaimable-lru-check-in-memcg-fix.patch
memcg-fix-numa-scan-information-update-to-be-triggered-by-memory-event-fix.patch
mm-preallocate-page-before-lock_page-at-filemap-cow-fix.patch
linux-next.patch
documentation-docbook-media-makefile-unbork.patch
drivers-staging-makefile-cs5535_gpio-went-away.patch
i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
cris-fix-a-build-error-in-kernel-forkc-checkpatch-fixes.patch
arch-x86-include-asm-delayh-fix-udelay-and-ndelay-for-8-bit-args.patch
pci-enumerate-the-pci-device-only-removed-out-pci-hierarchy-of-os-when-re-scanning-pci-fix.patch
drivers-staging-speakup-devsynthc-fix-buffer-size-is-not-provably-correct-error.patch
drivers-staging-gma500-psb_intel_displayc-fix-build.patch
drivers-staging-dt3155v4l-dt3155v4lc-needs-slabh.patch
drivers-staging-solo6x10-corec-needs-slabh.patch
drivers-staging-solo6x10-p2mc-needs-slabh.patch
staging-more-missing-slabh-inclusions.patch
slab-use-numa_no_node.patch
mm.patch
mm-extend-memory-hotplug-api-to-allow-memory-hotplug-in-virtual-machines-fix.patch
pagewalk-add-locking-rule-comments-fix.patch
mm-memoryc-remove-zap_block_size.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
hpet-factor-timer-allocate-from-open.patch
drivers-misc-add-support-the-fsa9480-usb-switch-fix.patch
leds-route-kbd-leds-through-the-generic-leds-layer.patch
checkpatch-suggest-using-min_t-or-max_t-v2.patch
checkpatch-add-a-prefer-__aligned-check.patch
lib-hexdumpc-make-hex2bin-return-the-updated-src-address.patch
fs-binfmt_miscc-use-kernels-hex_to_bin-method-fix.patch
fs-binfmt_miscc-use-kernels-hex_to_bin-method-fix-fix.patch
init-skip-calibration-delay-if-previously-done-fix.patch
init-skip-calibration-delay-if-previously-done-fix-fix.patch
init-skip-calibration-delay-if-previously-done-4.patch
drivers-rtc-add-support-for-qualcomm-pmic8xxx-rtc-fix.patch
cpusets-randomize-node-rotor-used-in-cpuset_mem_spread_node.patch
cpusets-randomize-node-rotor-used-in-cpuset_mem_spread_node-fix-2.patch
cpusets-randomize-node-rotor-used-in-cpuset_mem_spread_node-cpusets-initialize-spread-rotor-lazily-fix.patch
h8300-m68k-xtensa-__fd_isset-should-return-0-1.patch
proc-pid-fdinfo-add-cloexec-information-fix.patch
ipc-introduce-shm_rmid_forced-sysctl-fix.patch
ipc-introduce-shm_rmid_forced-sysctl-fix-2.patch
ipc-introduce-shm_rmid_forced-sysctl-cleanup.patch
ipc-introduce-shm_rmid_forced-sysctl-comments-fix.patch
ipc-introduce-shm_rmid_forced-sysctl-testing.patch
scatterlist-new-helper-functions.patch
scatterlist-new-helper-functions-update-fix.patch
kexec-remove-kmsg_dump_kexec.patch
ramoops-use-module-parameters-instead-of-platform-data-if-not-available-checkpatch-fixes.patch
journal_add_journal_head-debug.patch
mutex-subsystem-synchro-test-module-fix.patch
slab-leaks3-default-y.patch
put_bh-debug.patch
memblock-add-input-size-checking-to-memblock_find_region.patch
memblock-add-input-size-checking-to-memblock_find_region-fix.patch
drivers-net-wireless-rtlwifi-rtl8192de-phyc-fix-udelay-usage.patch

