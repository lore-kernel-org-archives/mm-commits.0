From: akpm@linux-foundation.org
Subject: + fujitsu-laptop-depends-on-input.patch added to -mm tree
Date: Mon, 23 Jun 2008 17:01:22 -0700
Message-ID: <200806240001.m5O01M6h023130@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49459 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752804AbYFXACV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 23 Jun 2008 20:02:21 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: randy.dunlap@oracle.com, jwoithe@physics.adelaide.edu.au, lenb@kernel.org


The patch titled
     fujitsu-laptop: depends on INPUT
has been added to the -mm tree.  Its filename is
     fujitsu-laptop-depends-on-input.patch

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
Cc: <jwoithe@physics.adelaide.edu.au>
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

documentation-build-source-files-in-documentation-sub-dir.patch
documentation-build-source-files-in-documentation-sub-dir-disable.patch
8390-split-8390-support-into-a-pausing-and-a-non-pausing-driver-core.patch
8390-split-8390-support-into-a-pausing-and-a-non-pausing-driver-core-fix.patch
8390-split-8390-support-into-a-pausing-and-a-non-pausing-driver-core-fix-fix.patch
e1000e-make-e1000e-default-to-the-same-kconfig-setting-as-e1000.patch
netfilter-conntrack_helper-needs-to-include-rculisth.patch
git-scsi-misc-fix-scsi_dh-build-errors.patch
git-unionfs.patch
audit-fix-kernel-doc-parameter-notation.patch
vmallocinfo-add-numa-information.patch
vmallocinfo-add-numa-information-fix.patch
flag-parameters-signalfd-fix.patch
flag-parameters-eventfd-fix.patch
bsdacct-stir-up-comments-around-acct_process.patch
profile-likely-unlikely-macros.patch
fujitsu-laptop-depends-on-input.patch

