From: akpm@linux-foundation.org
Subject: + bugh-add-empty-warn_on_slowpath-for-config_bug=n.patch added to -mm tree
Date: Tue, 01 Jul 2008 13:18:14 -0700
Message-ID: <200807012018.m61KIETC012645@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42648 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758255AbYGAUS2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 1 Jul 2008 16:18:28 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: randy.dunlap@oracle.com, andi@firstfloor.org


The patch titled
     bug.h: add empty warn_on_slowpath() for CONFIG_BUG=n
has been added to the -mm tree.  Its filename is
     bugh-add-empty-warn_on_slowpath-for-config_bug=n.patch

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
Subject: bug.h: add empty warn_on_slowpath() for CONFIG_BUG=n
From: Randy Dunlap <randy.dunlap@oracle.com>

Add an empty function for warn_on_slowpath() when CONFIG_BUG=n so that
this build error does not happen:

linux-next-20080701/drivers/acpi/utilities/utmisc.c: In function 'acpi_ut_error':
linux-next-20080701/drivers/acpi/utilities/utmisc.c:1028: error: implicit declaration of function 'warn_on_slowpath'

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Andi Kleen <andi@firstfloor.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-generic/bug.h |    5 +++++
 1 file changed, 5 insertions(+)

diff -puN include/asm-generic/bug.h~bugh-add-empty-warn_on_slowpath-for-config_bug=n include/asm-generic/bug.h
--- a/include/asm-generic/bug.h~bugh-add-empty-warn_on_slowpath-for-config_bug=n
+++ a/include/asm-generic/bug.h
@@ -81,4 +81,9 @@ extern void warn_on_slowpath(const char 
 # define WARN_ON_SMP(x)			do { } while (0)
 #endif
 
+#ifndef __ASSEMBLY__
+static inline void warn_on_slowpath(const char *file, const int line)
+{ }
+#endif
+
 #endif
_

Patches currently in -mm which might be from randy.dunlap@oracle.com are

doc-kernel-parameterstxt-fix-stale-references.patch
bugh-add-empty-warn_on_slowpath-for-config_bug=n.patch
fujitsu-laptop-depends-on-input.patch
x86-mm-init_64-fix-printk-format-warning.patch
documentation-build-source-files-in-documentation-sub-dir.patch
documentation-build-source-files-in-documentation-sub-dir-disable.patch
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

