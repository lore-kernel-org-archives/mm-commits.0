From: akpm@linux-foundation.org
Subject: + tpm_tis-fix-build-when-acpi-is-not-enabled.patch added to -mm tree
Date: Wed, 03 Aug 2011 12:09:20 -0700
Message-ID: <201108031909.p73J9K0R007337@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59473 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754568Ab1HCTJj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 3 Aug 2011 15:09:39 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rdunlap@xenotime.net, jmorris@namei.org, leendert@watson.ibm.com, mingo@elte.hu, sfr@canb.auug.org.au


The patch titled
     tpm_tis: fix build when ACPI is not enabled
has been added to the -mm tree.  Its filename is
     tpm_tis-fix-build-when-acpi-is-not-enabled.patch

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
Subject: tpm_tis: fix build when ACPI is not enabled
From: Randy Dunlap <rdunlap@xenotime.net>

Fix tpm_tis.c build when CONFIG_ACPI is not enabled by providing a stub
function.  Fixes many build errors/warnings:

drivers/char/tpm/tpm_tis.c:89: error: dereferencing pointer to incomplete type
drivers/char/tpm/tpm_tis.c:89: warning: type defaults to 'int' in declaration of 'type name'
drivers/char/tpm/tpm_tis.c:89: error: request for member 'list' in something not a structure or union
drivers/char/tpm/tpm_tis.c:89: warning: type defaults to 'int' in declaration of '__mptr'
drivers/char/tpm/tpm_tis.c:89: error: dereferencing pointer to incomplete type
drivers/char/tpm/tpm_tis.c:89: error: dereferencing pointer to incomplete type
drivers/char/tpm/tpm_tis.c:89: error: dereferencing pointer to incomplete type
drivers/char/tpm/tpm_tis.c:89: warning: type defaults to 'int' in declaration of 'type name'
drivers/char/tpm/tpm_tis.c:89: error: request for member 'list' in something not a structure or union
drivers/char/tpm/tpm_tis.c:89: warning: type defaults to 'int' in declaration of 'type name'
drivers/char/tpm/tpm_tis.c:89: error: dereferencing pointer to incomplete type
drivers/char/tpm/tpm_tis.c:89: error: dereferencing pointer to incomplete type
drivers/char/tpm/tpm_tis.c:89: error: dereferencing pointer to incomplete type
drivers/char/tpm/tpm_tis.c:89: warning: type defaults to 'int' in declaration of 'type name'
drivers/char/tpm/tpm_tis.c:89: error: request for member 'list' in something not a structure or union
drivers/char/tpm/tpm_tis.c:89: warning: type defaults to 'int' in declaration of '__mptr'
drivers/char/tpm/tpm_tis.c:89: error: dereferencing pointer to incomplete type
drivers/char/tpm/tpm_tis.c:89: error: dereferencing pointer to incomplete type
drivers/char/tpm/tpm_tis.c:89: error: dereferencing pointer to incomplete type
drivers/char/tpm/tpm_tis.c:89: warning: type defaults to 'int' in declaration of 'type name'
drivers/char/tpm/tpm_tis.c:89: error: request for member 'list' in something not a structure or union
drivers/char/tpm/tpm_tis.c:89: warning: type defaults to 'int' in declaration of 'type name'
drivers/char/tpm/tpm_tis.c:90: error: dereferencing pointer to incomplete type

Signed-off-by: Randy Dunlap <rdunlap@xenotime.net>
Cc: Leendert van Doorn <leendert@watson.ibm.com>
Cc: James Morris <jmorris@namei.org>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/tpm/tpm_tis.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff -puN drivers/char/tpm/tpm_tis.c~tpm_tis-fix-build-when-acpi-is-not-enabled drivers/char/tpm/tpm_tis.c
--- a/drivers/char/tpm/tpm_tis.c~tpm_tis-fix-build-when-acpi-is-not-enabled
+++ a/drivers/char/tpm/tpm_tis.c
@@ -80,7 +80,7 @@ enum tis_defaults {
 static LIST_HEAD(tis_chips);
 static DEFINE_SPINLOCK(tis_lock);
 
-#ifdef CONFIG_PNP
+#if defined(CONFIG_PNP) && defined(CONFIG_ACPI)
 static int is_itpm(struct pnp_dev *dev)
 {
 	struct acpi_device *acpi = pnp_acpi_device(dev);
@@ -93,6 +93,11 @@ static int is_itpm(struct pnp_dev *dev)
 
 	return 0;
 }
+#else
+static inline int is_itpm(struct pnp_dev *dev)
+{
+	return 0;
+}
 #endif
 
 static int check_locality(struct tpm_chip *chip, int l)
_

Patches currently in -mm which might be from rdunlap@xenotime.net are

origin.patch
fault-injection-add-ability-to-export-fault_attr-in-arbitrary-directory-fix.patch
fs-dcachec-fix-new-kernel-doc-warning.patch
init-add-root=partuuid=uuid-partnroff=%d-support.patch
init-add-root=partuuid=uuid-partnroff=%d-support-update.patch
documentation-add-pointer-to-name_to_dev_t-for-root=-values.patch
tpm_tis-fix-build-when-acpi-is-not-enabled.patch
linux-next.patch
drivers-scsi-megaraidc-fix-sparse-warnings.patch
cross-memory-attach-update.patch
tmpfs-expand-help-to-explain-value-of-tmpfs_posix_acl.patch
tmpfs-expand-help-to-explain-value-of-tmpfs_posix_acl-v3.patch
consolidate-config_debug_strict_user_copy_checks-fix.patch
leds-route-kbd-leds-through-the-generic-leds-layer.patch
ipc-introduce-shm_rmid_forced-sysctl-testing.patch
mutex-subsystem-synchro-test-module.patch
mutex-subsystem-synchro-test-module-fix.patch

