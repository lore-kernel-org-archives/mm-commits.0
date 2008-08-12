From: akpm@linux-foundation.org
Subject: - drivers-net-atl1e-atl1e_mainc-uninline-atl1e_setup_mac_ctrl.patch removed from -mm tree
Date: Tue, 12 Aug 2008 13:33:45 -0700
Message-ID: <200808122033.m7CKXjaY011821@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47018 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751835AbYHLUfA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 12 Aug 2008 16:35:00 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bunk@kernel.org, jeff@garzik.org, mm-commits@vger.kernel.org


The patch titled
     drivers/net/atl1e/atl1e_main.c: uninline atl1e_setup_mac_ctrl()
has been removed from the -mm tree.  Its filename was
     drivers-net-atl1e-atl1e_mainc-uninline-atl1e_setup_mac_ctrl.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: drivers/net/atl1e/atl1e_main.c: uninline atl1e_setup_mac_ctrl()
From: Adrian Bunk <bunk@kernel.org>

There doesn't seem to be a compelling reason why atl1e_setup_mac_ctrl()
is marked as "inline":

It's not used in any place where speed would matter much, and as long as
it has only one caller non-ancient gcc versions anyway inline it
automatically.

This patch fixes the following compile error with gcc 3.4:

atl1e_main.c: In function `atl1e_check_link':
atl1e_main.c:50: sorry, unimplemented: inlining failed in call to
atl1e_main.c:196: sorry, unimplemented: called from here

Reported-by: Adrian Bunk <bunk@kernel.org>
Signed-off-by: Adrian Bunk <bunk@kernel.org>
Cc: Jeff Garzik <jeff@garzik.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/atl1e/atl1e_main.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/net/atl1e/atl1e_main.c~drivers-net-atl1e-atl1e_mainc-uninline-atl1e_setup_mac_ctrl drivers/net/atl1e/atl1e_main.c
--- a/drivers/net/atl1e/atl1e_main.c~drivers-net-atl1e-atl1e_mainc-uninline-atl1e_setup_mac_ctrl
+++ a/drivers/net/atl1e/atl1e_main.c
@@ -47,7 +47,7 @@ MODULE_DESCRIPTION("Atheros 1000M Ethern
 MODULE_LICENSE("GPL");
 MODULE_VERSION(DRV_VERSION);
 
-static inline void atl1e_setup_mac_ctrl(struct atl1e_adapter *adapter);
+static void atl1e_setup_mac_ctrl(struct atl1e_adapter *adapter);
 
 static const u16
 atl1e_rx_page_vld_regs[AT_MAX_RECEIVE_QUEUE][AT_PAGE_NUM_PER_QUEUE] =
@@ -1037,7 +1037,7 @@ static inline void atl1e_configure_dma(s
 	return;
 }
 
-static inline void atl1e_setup_mac_ctrl(struct atl1e_adapter *adapter)
+static void atl1e_setup_mac_ctrl(struct atl1e_adapter *adapter)
 {
 	u32 value;
 	struct atl1e_hw *hw = &adapter->hw;
_

Patches currently in -mm which might be from bunk@kernel.org are

origin.patch
feature-removal-scheduletxt-remove-the-ncr53c9x-entry.patch
linux-next.patch
m32r-remove-the-unused-nohighmem-option.patch
m32r-dont-offer-config_isa.patch
m32r-export-empty_zero_page.patch
m32r-export-__ndelay.patch
m32r-kernel-cleanups.patch
the-overdue-eepro100-removal.patch
ntfs-update-homepage.patch
parisc-lib-make-code-static.patch
drivers-parisc-make-code-static.patch
if-0-ses_match_host.patch
scsi-remove-the-unused-scsi_qlogic_fc_firmware-option.patch
drivers-scsi-a2091c-make-2-functions-static.patch
drivers-scsi-a3000c-make-2-functions-static.patch
fs_mbcache-dont-needlessly-make-it-built-in.patch
git-xtensa.patch
asm-h8300-mdh-remove-cvs-keyword.patch
alpha-miata-remove-dead-url.patch
uml-remove-the-dead-tty_log-code.patch
include-linux-kernelh-userspace-header-cleanup.patch
maintainers-remove-hga-framebuffer-driver-entry.patch
include-linux-mounth-remove-cvs-keyword.patch
kernel-dmac-remove-a-cvs-keyword.patch
binfmt_somc-add-module_license.patch
make-probe_serial_gsc-static.patch
pnp-remove-printk-with-outdated-version.patch
telephony-remove-cvs-keywords.patch
reiserfs-procfsc-remove-cvs-keywords.patch
quota-remove-cvs-keywords.patch
make-ptrace_untrace-static.patch
fs-partitions-acornc-remove-dead-code.patch
parport-remove-cvs-keywords.patch
make-mm-rmapc-anon_vma_cachep-static.patch
drivers-firmware-iscsi_ibftc-make-3-functions-static.patch
ipc-semc-make-free_un-static.patch
acpi-use-bcd2bin-bin2bcd.patch
alpha-use-bcd2bin-bin2bcd.patch
arm-use-bcd2bin-bin2bcd.patch
cris-use-bcd2bin-bin2bcd.patch
drivers-rtc-use-bcd2bin-bin2bcd.patch
rtc-use-bcd2bin-bin2bcd.patch
ia64-use-bcd2bin-bin2bcd.patch
ide-cd-use-bcd2bin-bin2bcd.patch
mips-use-bcd2bin-bin2bcd.patch
mn10300-use-bcd2bin-bin2bcd.patch
powerpc-use-bcd2bin-bin2bcd.patch
i2c-use-bcd2bin-bin2bcd.patch
drivers-scsi-sr_vendorc-use-bcd2bin.patch
sparc64-use-bcd2bin-bin2bcd.patch
remove-the-obsolete-bcdbin-binbcd-macros.patch
include-linux-bcdh-remove-comments.patch
reiser4.patch

