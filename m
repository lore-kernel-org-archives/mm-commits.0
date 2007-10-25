From: akpm@linux-foundation.org
Subject: + permit-silencing-of-__deprecated-warnings.patch added to -mm tree
Date: Thu, 25 Oct 2007 01:13:54 -0700
Message-ID: <200710250813.l9P8DsqN014657@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:54972 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756785AbXJYITP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 25 Oct 2007 04:19:15 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jeff@garzik.org, jgarzik@redhat.com


The patch titled
     Permit silencing of __deprecated warnings
has been added to the -mm tree.  Its filename is
     permit-silencing-of-__deprecated-warnings.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Permit silencing of __deprecated warnings
From: Jeff Garzik <jeff@garzik.org>

The __deprecated marker is quite useful in highlighting the remnants of
old APIs that want removing.

However, it is quite normal for one or more years to pass, before the
(usually ancient, bitrotten) code in question is either updated or
deleted.

Thus, like __must_check, add a Kconfig option that permits the silencing
of this compiler warning.

This change mimics the ifdef-ery and Kconfig defaults of MUST_CHECK as
closely as possible.

Signed-off-by: Jeff Garzik <jgarzik@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/compiler.h |    6 ++++++
 lib/Kconfig.debug        |    8 ++++++++
 2 files changed, 14 insertions(+)

diff -puN include/linux/compiler.h~permit-silencing-of-__deprecated-warnings include/linux/compiler.h
--- a/include/linux/compiler.h~permit-silencing-of-__deprecated-warnings
+++ a/include/linux/compiler.h
@@ -101,6 +101,12 @@ extern void __chk_io_ptr(const volatile 
 #undef __must_check
 #define __must_check
 #endif
+#ifndef CONFIG_ENABLE_WARN_DEPRECATED
+#undef __deprecated
+#undef __deprecated_for_modules
+#define __deprecated
+#define __deprecated_for_modules
+#endif
 
 /*
  * Allow us to avoid 'defined but not used' warnings on functions and data,
diff -puN lib/Kconfig.debug~permit-silencing-of-__deprecated-warnings lib/Kconfig.debug
--- a/lib/Kconfig.debug~permit-silencing-of-__deprecated-warnings
+++ a/lib/Kconfig.debug
@@ -9,6 +9,14 @@ config PRINTK_TIME
 	  operations.  This is useful for identifying long delays
 	  in kernel startup.
 
+config ENABLE_WARN_DEPRECATED
+	bool "Enable __deprecated logic"
+	default y
+	help
+	  Enable the __deprecated logic in the kernel build.
+	  Disable this to suppress the "warning: 'foo' is deprecated
+	  (declared at kernel/power/somefile.c:1234)" messages.
+
 config ENABLE_MUST_CHECK
 	bool "Enable __must_check logic"
 	default y
_

Patches currently in -mm which might be from jeff@garzik.org are

lguest-build-fix.patch
remove-bogus-default-y-for-dmar-and-net_dma.patch
acpi-sbs-fix-retval-warning.patch
git-jg-misc.patch
git-libata-all.patch
drivers-ata-libata-ehc-fix-printk-warning.patch
scsi-expose-an-support-to-user-space.patch
libata-expose-an-to-user-space.patch
ide-add-helper-__ide_setup_pci_device.patch
drivers-ide-pci-sc1200c-remove-pointless-hwif-lookup-loop.patch
drivers-ide-pci-sc1200c-remove-pointless-hwif-lookup-loop-checkpatch-fixes.patch
drivers-ide-pci-sc1200c-fix-suspend-resume-buglets-and-warnings.patch
forcedeth-power-down-phy-when-interface-is-down.patch
forcedeth-fix-mac-address-detection-on-network-card-regression-in-2623.patch
ucc_geth-fix-build-break-introduced-by-commit-09f75cd7bf13720738e6a196cc0107ce9a5bd5a0-checkpatch-fixes.patch
update-smc91x-driver-with-arm-versatile-board-info.patch
scsi-use-notifier-chain-for-asynchronous-event.patch
hptiop-fix-type-mismatch-warning.patch
ips-remove-ips_ha-members-that-duplicate-struct-pci_dev-members.patch
ips-trim-trailing-whitespace.patch
ips-trim-trailing-whitespace-checkpatch-fixes.patch
ips-pci-api-cleanups.patch
ips-handle-scsi_add_host-failure-and-other-err-cleanups.patch
git-wireless.patch
mac80211-fix-warning-created-by-bit.patch
x86-fix-config_smp-warning-in-processorc.patch
x86-fix-config_smp-warning-in-processorc-fix.patch
fix-versus-precedence-in-various-places.patch
fix-versus-precedence-in-various-places-checkpatch-fixes.patch
riscom8-fix-smp-brokenness.patch
riscom8-fix-smp-brokenness-fix.patch
sound-oss-pss-set_io_base-always-returns-success-mark-it-void.patch
sound-oss-pss-set_io_base-always-returns-success-mark-it-void-checkpatch-fixes.patch
sound-oss-sb_commonc-fix-casting-warning.patch
permit-silencing-of-__deprecated-warnings.patch
remove-warnings-for-longstanding-conditions.patch
isdn-capidrv-fix-casting-warning.patch
isdn-sc-fix-longstanding-warning.patch
