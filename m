From: akpm@google.com
Subject: + scsi-scsi_isci-needs-to-select-scsi_sas_host_smp-fixes-build-error.patch added to -mm tree
Date: Fri, 23 Sep 2011 15:51:43 -0700
Message-ID: <201109232251.p8NMphnZ005822@hpaq7.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp-out.google.com ([74.125.121.67]:24702 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752413Ab1IWWvt (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 23 Sep 2011 18:51:49 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rdunlap@xenotime.net, James.Bottomley@HansenPartnership.com


The patch titled
     Subject: scsi: SCSI_ISCI needs to select SCSI_SAS_HOST_SMP, fixes build error
has been added to the -mm tree.  Its filename is
     scsi-scsi_isci-needs-to-select-scsi_sas_host_smp-fixes-build-error.patch

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
From: Randy Dunlap <rdunlap@xenotime.net>
Subject: scsi: SCSI_ISCI needs to select SCSI_SAS_HOST_SMP, fixes build error

SCSI_ISCI needs to select SCSI_SAS_HOST_SMP to ensure that all
needed symbols are available to it.

Fixes this build error:
ERROR: "try_test_sas_gpio_gp_bit" [drivers/scsi/isci/isci.ko] undefined!

Signed-off-by: Randy Dunlap <rdunlap@xenotime.net>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
Signed-off-by: Andrew Morton <akpm@google.com>
---

 drivers/scsi/Kconfig |    1 +
 1 file changed, 1 insertion(+)

diff -puN drivers/scsi/Kconfig~scsi-scsi_isci-needs-to-select-scsi_sas_host_smp-fixes-build-error drivers/scsi/Kconfig
--- a/drivers/scsi/Kconfig~scsi-scsi_isci-needs-to-select-scsi_sas_host_smp-fixes-build-error
+++ a/drivers/scsi/Kconfig
@@ -847,6 +847,7 @@ config SCSI_ISCI
 	# (temporary): known alpha quality driver
 	depends on EXPERIMENTAL
 	select SCSI_SAS_LIBSAS
+	select SCSI_SAS_HOST_SMP
 	---help---
 	  This driver supports the 6Gb/s SAS capabilities of the storage
 	  control unit found in the Intel(R) C600 series chipset.
_
Subject: Subject: scsi: SCSI_ISCI needs to select SCSI_SAS_HOST_SMP, fixes build error

Patches currently in -mm which might be from rdunlap@xenotime.net are

origin.patch
scsi-fix-qla2xxx-printk-format-warning.patch
linux-next.patch
drm-fix-kconfig-unmet-dependency-warning.patch
drivers-scsi-megaraidc-fix-sparse-warnings.patch
scsi-scsi_isci-needs-to-select-scsi_sas_host_smp-fixes-build-error.patch
cross-memory-attach-update.patch
consolidate-config_debug_strict_user_copy_checks-fix.patch
dynamic_debug-fix-undefined-reference-to-__netdev_printk.patch
leds-route-kbd-leds-through-the-generic-leds-layer.patch
ipc-introduce-shm_rmid_forced-sysctl-testing.patch
init-add-root=partuuid=uuid-partnroff=%d-support.patch
mutex-subsystem-synchro-test-module.patch
mutex-subsystem-synchro-test-module-fix.patch

