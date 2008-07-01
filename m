From: akpm@linux-foundation.org
Subject: + e100-fix-printk-format-warning.patch added to -mm tree
Date: Tue, 01 Jul 2008 01:35:25 -0700
Message-ID: <200807010835.m618ZP4w017735@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55739 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751934AbYGAIgy (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 1 Jul 2008 04:36:54 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: randy.dunlap@oracle.com, jeffrey.t.kirsher@intel.com


The patch titled
     e100: fix printk format warning
has been added to the -mm tree.  Its filename is
     e100-fix-printk-format-warning.patch

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
Subject: e100: fix printk format warning
From: Randy Dunlap <randy.dunlap@oracle.com>

Fix printk format warning:

drivers/net/e100.c:1145: warning: format '%d' expects type 'int', but argument 5 has type 'size_t'

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Acked-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/e100.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/net/e100.c~e100-fix-printk-format-warning drivers/net/e100.c
--- a/drivers/net/e100.c~e100-fix-printk-format-warning
+++ a/drivers/net/e100.c
@@ -1142,7 +1142,7 @@ static const struct firmware *e100_reque
 	/* Firmware should be precisely UCODE_SIZE (words) plus three bytes
 	   indicating the offsets for BUNDLESMALL, BUNDLEMAX, INTDELAY */
 	if (fw->size != UCODE_SIZE * 4 + 3) {
-		DPRINTK(PROBE,ERR, "Firmware \"%s\" has wrong size %d\n",
+		DPRINTK(PROBE,ERR, "Firmware \"%s\" has wrong size %zu\n",
 			fw_name, fw->size);
 		release_firmware(fw);
 		return ERR_PTR(-EINVAL);
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
e100-fix-printk-format-warning.patch

