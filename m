From: akpm@linux-foundation.org
Subject: - bluetooth-hci_bcsp-fix-bitrev-kconfig.patch removed from -mm tree
Date: Wed, 16 Jul 2008 14:35:19 -0700
Message-ID: <200807162135.m6GLZJmJ014075@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41736 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756949AbYGPVgw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 16 Jul 2008 17:36:52 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: randy.dunlap@oracle.com, hidave.darkstar@gmail.com, marcel@holtmann.org, mm-commits@vger.kernel.org


The patch titled
     bluetooth/hci_bcsp: fix bitrev Kconfig
has been removed from the -mm tree.  Its filename was
     bluetooth-hci_bcsp-fix-bitrev-kconfig.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: bluetooth/hci_bcsp: fix bitrev Kconfig
From: Randy Dunlap <randy.dunlap@oracle.com>

Fix bluetooth hci_bcsp Kconfig to avoid build errors:

drivers/built-in.o: In function `bcsp_prepare_pkt':
hci_bcsp.c:(.text+0x7e9ac): undefined reference to `bitrev16'
drivers/built-in.o: In function `bcsp_recv':
hci_bcsp.c:(.text+0x7f276): undefined reference to `bitrev16'
hci_bcsp.c:(.text+0x7f293): undefined reference to `bitrev16'
make[1]: *** [.tmp_vmlinux1] Error 1

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Dave Young <hidave.darkstar@gmail.com>
Acked-by: Marcel Holtmann <marcel@holtmann.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/bluetooth/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/bluetooth/Kconfig~bluetooth-hci_bcsp-fix-bitrev-kconfig drivers/bluetooth/Kconfig
--- a/drivers/bluetooth/Kconfig~bluetooth-hci_bcsp-fix-bitrev-kconfig
+++ a/drivers/bluetooth/Kconfig
@@ -71,7 +71,7 @@ config BT_HCIUART_H4
 config BT_HCIUART_BCSP
 	bool "BCSP protocol support"
 	depends on BT_HCIUART
-	select CONFIG_BITREVERSE
+	select BITREVERSE
 	help
 	  BCSP (BlueCore Serial Protocol) is serial protocol for communication 
 	  between Bluetooth device and host. This protocol is required for non
_

Patches currently in -mm which might be from randy.dunlap@oracle.com are

origin.patch
linux-next.patch
acpi-utmisc-use-warn_on-instead-of-warn_on_slowpath.patch
documentation-build-source-files-in-documentation-sub-dir.patch
documentation-build-source-files-in-documentation-sub-dir-disable.patch
e1000e-make-e1000e-default-to-the-same-kconfig-setting-as-e1000.patch
firmware-fix-memmap-printk-format-warnings.patch
netfilter-conntrack_helper-needs-to-include-rculisth.patch
lkdtm-fix-for-config_scsi=n.patch
git-unionfs.patch
vmallocinfo-add-numa-information.patch
vmallocinfo-add-numa-information-fix.patch
pm-remove-obsolete-piece-of-pm-documentation-rev-2.patch
init-versionc-silenced-sparse-warning-by-declaring-the-version-string.patch
init-versionc-define-version_string-only-if-config_kallsyms-is-not-defined.patch
flag-parameters-signalfd-fix.patch
flag-parameters-eventfd-fix.patch
kallsyms-unify-32-and-64-bit-code.patch
procfs-guide-drop-pointless-nbsp-entities.patch
bsdacct-stir-up-comments-around-acct_process.patch
documentation-cleanup-trivial-misspelling-punctuation-and-grammar-corrections.patch
profile-likely-unlikely-macros.patch

