From: akpm@linux-foundation.org
Subject: [folded] edac-add-edac_device_alloc_index-cleanup.patch removed from -mm tree
Date: Wed, 17 Jun 2009 15:54:31 -0700
Message-ID: <200906172254.n5HMsVPE014143@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53645 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756592AbZFQWyf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 17 Jun 2009 18:54:35 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, benh@kernel.crashing.org, galak@gate.crashing.org, michael@ellerman.id.au, norsk5@yahoo.com, paulus@samba.org, qingtao.cao@windriver.com, mm-commits@vger.kernel.org


The patch titled
     edac-add-edac_device_alloc_index-cleanup
has been removed from the -mm tree.  Its filename was
     edac-add-edac_device_alloc_index-cleanup.patch

This patch was dropped because it was folded into edac-add-edac_device_alloc_index.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: edac-add-edac_device_alloc_index-cleanup
From: Andrew Morton <akpm@linux-foundation.org>

keep things neat.  Also avoids having global identifier device_index
shadowed by local identifier device_index.

Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Doug Thompson <norsk5@yahoo.com>
Cc: Harry Ciao <qingtao.cao@windriver.com>
Cc: Kumar Gala <galak@gate.crashing.org>
Cc: Michael Ellerman <michael@ellerman.id.au>
Cc: Paul Mackerras <paulus@samba.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/edac/edac_device.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN drivers/edac/edac_device.c~edac-add-edac_device_alloc_index-cleanup drivers/edac/edac_device.c
--- a/drivers/edac/edac_device.c~edac-add-edac_device_alloc_index-cleanup
+++ a/drivers/edac/edac_device.c
@@ -37,7 +37,6 @@
  */
 static DEFINE_MUTEX(device_ctls_mutex);
 static LIST_HEAD(edac_device_list);
-static atomic_t device_indexes = ATOMIC_INIT(0);
 
 #ifdef CONFIG_EDAC_DEBUG
 static void edac_device_dump_device(struct edac_device_ctl_info *edac_dev)
@@ -499,6 +498,8 @@ void edac_device_reset_delay_period(stru
  */
 int edac_device_alloc_index(void)
 {
+	static atomic_t device_indexes = ATOMIC_INIT(0);
+
 	return atomic_inc_return(&device_indexes) - 1;
 }
 EXPORT_SYMBOL_GPL(edac_device_alloc_index);
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
documentation-vm-makefile-dont-try-to-build-slqbinfo.patch
maintainers-fbdev-is-orphaned.patch
gpio-pca953x-get-platform_data-from-openfirmware.patch
documentation-changes-perl-is-needed-to-build-the-kernel.patch
cgroups-forbid-noprefix-if-mounting-more-than-just-cpuset-subsystem.patch
drivers-char-memc-memory_open-cleanup-lookup-minor-device-number-from-devlist.patch
edac-add-cpc925-memory-controller-driver.patch
edac-add-edac_device_alloc_index.patch
edac-add-edac_device_alloc_index-cleanup.patch
edac-kconfig-fix-the-meaning-of-edac-abbreviation-fix.patch
kexec-sysrq-simplify-sysrq-c-handler.patch
gru-support-for-asynchronous-gru-instructions-fix.patch
lib-add-lib-gcdc-fix.patch
lib-add-lib-gcdc-fix-fix.patch

