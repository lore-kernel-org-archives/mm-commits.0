From: akpm@linux-foundation.org
Subject: - fujitsu-laptop-depends-on-input.patch removed from -mm tree
Date: Wed, 02 Jul 2008 00:46:41 -0700
Message-ID: <200807020746.m627kf7t005587@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55300 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751401AbYGBHrq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 2 Jul 2008 03:47:46 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: randy.dunlap@oracle.com, jwoithe@physics.adelaide.edu.au, lenb@kernel.org, mm-commits@vger.kernel.org


The patch titled
     fujitsu-laptop: depends on INPUT
has been removed from the -mm tree.  Its filename was
     fujitsu-laptop-depends-on-input.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: fujitsu-laptop: depends on INPUT
From: Randy Dunlap <randy.dunlap@oracle.com>

fujitsu-laptop uses input_* functions, so it should depend on INPUT.

drivers/built-in.o: In function `acpi_fujitsu_add':
fujitsu-laptop.c:(.text+0xaaec7): undefined reference to `input_allocate_device'
fujitsu-laptop.c:(.text+0xaaf39): undefined reference to `input_register_device'
fujitsu-laptop.c:(.text+0xab025): undefined reference to `input_free_device'
drivers/built-in.o: In function `acpi_fujitsu_notify':
fujitsu-laptop.c:(.text+0xab0d8): undefined reference to `input_event'
fujitsu-laptop.c:(.text+0xab0e5): undefined reference to `input_event'
fujitsu-laptop.c:(.text+0xab0f5): undefined reference to `input_event'
fujitsu-laptop.c:(.text+0xab102): undefined reference to `input_event'
drivers/built-in.o: In function `acpi_fujitsu_hotkey_notify':
fujitsu-laptop.c:(.text+0xab261): undefined reference to `input_event'
drivers/built-in.o:fujitsu-laptop.c:(.text+0xab26e): more undefined references to `input_event' follow
drivers/built-in.o: In function `acpi_fujitsu_hotkey_add':
fujitsu-laptop.c:(.text+0xab49c): undefined reference to `input_allocate_device'
fujitsu-laptop.c:(.text+0xab51a): undefined reference to `input_register_device'
fujitsu-laptop.c:(.text+0xab5e4): undefined reference to `input_free_device'
make[1]: *** [.tmp_vmlinux1] Error 1

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Acked-by: Jonathan Woithe <jwoithe@physics.adelaide.edu.au>
Cc: Len Brown <lenb@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/misc/Kconfig |    1 +
 1 file changed, 1 insertion(+)

diff -puN drivers/misc/Kconfig~fujitsu-laptop-depends-on-input drivers/misc/Kconfig
--- a/drivers/misc/Kconfig~fujitsu-laptop-depends-on-input
+++ a/drivers/misc/Kconfig
@@ -179,6 +179,7 @@ config FUJITSU_LAPTOP
         tristate "Fujitsu Laptop Extras"
         depends on X86
         depends on ACPI
+        depends on INPUT
         depends on BACKLIGHT_CLASS_DEVICE
         ---help---
 	  This is a driver for laptops built by Fujitsu:
_

Patches currently in -mm which might be from randy.dunlap@oracle.com are

origin.patch
doc-kernel-parameterstxt-fix-stale-references.patch
cpusets-document-proc-status-cpus-and-mems-allowed-lists.patch
linux-next.patch
documentation-build-source-files-in-documentation-sub-dir.patch
documentation-build-source-files-in-documentation-sub-dir-disable.patch
git-kbuild-next.patch
bluetooth-hci_bcsp-fix-bitrev-kconfig.patch
8390-split-8390-support-into-a-pausing-and-a-non-pausing-driver-core.patch
8390-split-8390-support-into-a-pausing-and-a-non-pausing-driver-core-fix.patch
8390-split-8390-support-into-a-pausing-and-a-non-pausing-driver-core-fix-fix.patch
e100-fix-printk-format-warning.patch
e1000e-make-e1000e-default-to-the-same-kconfig-setting-as-e1000.patch
netfilter-conntrack_helper-needs-to-include-rculisth.patch
git-scsi-misc-fix-scsi_dh-build-errors.patch
lkdtm-fix-for-config_scsi=n.patch
git-unionfs.patch
vmallocinfo-add-numa-information.patch
vmallocinfo-add-numa-information-fix.patch
pm-remove-obsolete-piece-of-pm-documentation-rev-2.patch
flag-parameters-signalfd-fix.patch
flag-parameters-eventfd-fix.patch
kallsyms-unify-32-and-64-bit-code.patch
procfs-guide-drop-pointless-nbsp-entities.patch
bsdacct-stir-up-comments-around-acct_process.patch
documentation-cleanup-trivial-misspelling-punctuation-and-grammar-corrections.patch
profile-likely-unlikely-macros.patch

