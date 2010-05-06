From: akpm@linux-foundation.org
Subject: + scsi-fix-be2iscsi-build.patch added to -mm tree
Date: Thu, 06 May 2010 15:14:31 -0700
Message-ID: <201005062214.o46MEVD6018095@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42192 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753123Ab0EFWOi (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 6 May 2010 18:14:38 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: randy.dunlap@oracle.com, James.Bottomley@HansenPartnership.com, jayamohank@serverengines.com


The patch titled
     scsi: fix be2iscsi build
has been added to the -mm tree.  Its filename is
     scsi-fix-be2iscsi-build.patch

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
Subject: scsi: fix be2iscsi build
From: Randy Dunlap <randy.dunlap@oracle.com>

be2iscsi driver should #include linux/if_ether.h since it uses
sysfs_format_mac().

It should also depend on NET since it selects SCSI_ISCSI_ATTRS,
which depends on NET.

These changes fix a build error when CONFIG_NET is not enabled:
ERROR: "sysfs_format_mac" [drivers/scsi/be2iscsi/be2iscsi.ko] undefined!

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Jayamohan Kallickal <jayamohank@serverengines.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/scsi/be2iscsi/Kconfig   |    2 +-
 drivers/scsi/be2iscsi/be_main.h |    1 +
 2 files changed, 2 insertions(+), 1 deletion(-)

diff -puN drivers/scsi/be2iscsi/Kconfig~scsi-fix-be2iscsi-build drivers/scsi/be2iscsi/Kconfig
--- a/drivers/scsi/be2iscsi/Kconfig~scsi-fix-be2iscsi-build
+++ a/drivers/scsi/be2iscsi/Kconfig
@@ -1,6 +1,6 @@
 config BE2ISCSI
 	tristate "ServerEngines' 10Gbps iSCSI - BladeEngine 2"
-	depends on PCI && SCSI
+	depends on PCI && SCSI && NET
 	select SCSI_ISCSI_ATTRS
 
 	help
diff -puN drivers/scsi/be2iscsi/be_main.h~scsi-fix-be2iscsi-build drivers/scsi/be2iscsi/be_main.h
--- a/drivers/scsi/be2iscsi/be_main.h~scsi-fix-be2iscsi-build
+++ a/drivers/scsi/be2iscsi/be_main.h
@@ -23,6 +23,7 @@
 
 #include <linux/kernel.h>
 #include <linux/pci.h>
+#include <linux/if_ether.h>
 #include <linux/in.h>
 #include <scsi/scsi.h>
 #include <scsi/scsi_cmnd.h>
_

Patches currently in -mm which might be from randy.dunlap@oracle.com are

origin.patch
linux-next.patch
virtio_9ph-include-linux-typesh.patch
dib3000mc-reduce-large-stack-usage-fix.patch
led-driver-for-the-soekris-net5501-board.patch
leds-route-kbd-leds-through-the-generic-leds-layer.patch
scsi-fix-convert-scsi_scanc-kernel-doc.patch
scsi-update-drivers-tools-url-references.patch
scsi-fix-pmcraid-build-errors.patch
scsi-fix-be2iscsi-build.patch
scsi-fix-bnx2i-build-errors.patch
mmcompaction-add-a-tunable-that-decides-when-memory-should-be-compacted-and-when-it-should-be-reclaimed.patch
lib-hexdumpc-reduce-stack-variable-size-and-cleanups.patch
xen-fix-build-when-sysrq-is-disabled.patch
documentation-submittingdrivers-resources.patch
memcg-move-charge-of-file-pages-fix-2.patch
memcg-update-documentation-v8.patch
numa-update-documentation-vm-numa-add-memoryless-node-info.patch
reiser4-export-remove_from_page_cache-fix.patch
mutex-subsystem-synchro-test-module-add-missing-header-file.patch

