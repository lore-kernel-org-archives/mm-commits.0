From: akpm@linux-foundation.org
Subject: + bluetooth-hci_bcsp-fix-bitrev-kconfig.patch added to -mm tree
Date: Tue, 01 Jul 2008 01:34:53 -0700
Message-ID: <200807010834.m618Yrwj017714@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49103 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758234AbYGAIfe (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 1 Jul 2008 04:35:34 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: randy.dunlap@oracle.com, hidave.darkstar@gmail.com, marcel@holtmann.org


The patch titled
     bluetooth/hci_bcsp: fix bitrev Kconfig
has been added to the -mm tree.  Its filename is
     bluetooth-hci_bcsp-fix-bitrev-kconfig.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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

doc-kernel-parameterstxt-fix-stale-references.patch
fujitsu-laptop-depends-on-input.patch
x86-mm-init_64-fix-printk-format-warning.patch
documentation-build-source-files-in-documentation-sub-dir.patch
documentation-build-source-files-in-documentation-sub-dir-disable.patch
bluetooth-hci_bcsp-fix-bitrev-kconfig.patch
8390-split-8390-support-into-a-pausing-and-a-non-pausing-driver-core.patch
8390-split-8390-support-into-a-pausing-and-a-non-pausing-driver-core-fix.patch
8390-split-8390-support-into-a-pausing-and-a-non-pausing-driver-core-fix-fix.patch
e1000e-make-e1000e-default-to-the-same-kconfig-setting-as-e1000.patch
netfilter-conntrack_helper-needs-to-include-rculisth.patch
git-scsi-misc-fix-scsi_dh-build-errors.patch
git-unionfs.patch
iwlwifi-fix-build-for-config_input=n.patch
audit-fix-kernel-doc-parameter-notation.patch
vmallocinfo-add-numa-information.patch
vmallocinfo-add-numa-information-fix.patch
pm-remove-obsolete-piece-of-pm-documentation-rev-2.patch
flag-parameters-signalfd-fix.patch
flag-parameters-eventfd-fix.patch
kallsyms-unify-32-and-64-bit-code.patch
uio-howtotmpl-use-standard-copyright-legal-markings.patch
uio-howtotmpl-use-unique-output-names.patch
procfs-guide-drop-pointless-nbsp-entities.patch
bsdacct-stir-up-comments-around-acct_process.patch
documentation-cleanup-trivial-misspelling-punctuation-and-grammar-corrections.patch
profile-likely-unlikely-macros.patch

