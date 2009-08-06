From: akpm@linux-foundation.org
Subject: [merged] scsi-make-scsi-sg-v4-driver-enabled-by-default-and-remove-experimental-dependency-since-udev-depends-on-bsg.patch removed from -mm tree
Date: Thu, 06 Aug 2009 13:31:37 -0700
Message-ID: <200908062031.n76KVbNu005067@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60108 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751528AbZHFUjr (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 6 Aug 2009 16:39:47 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: john@stoffel.org, mm-commits@vger.kernel.org


The patch titled
     scsi: make SCSI SG v4 driver enabled by default and remove EXPERIMENTAL dependency, since udev depends on BSG
has been removed from the -mm tree.  Its filename was
     scsi-make-scsi-sg-v4-driver-enabled-by-default-and-remove-experimental-dependency-since-udev-depends-on-bsg.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: scsi: make SCSI SG v4 driver enabled by default and remove EXPERIMENTAL dependency, since udev depends on BSG
From: John Stoffel <john@stoffel.org>

Make Block Layer SG support v4 the default, since recent udev versions
depend on this to access serial numbers and other low level info properly.

This should be backported to older kernels as well, since most distros have
enabled this for a long time.

Signed-off-by: John Stoffel <john@stoffel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 block/Kconfig |   11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff -puN block/Kconfig~scsi-make-scsi-sg-v4-driver-enabled-by-default-and-remove-experimental-dependency-since-udev-depends-on-bsg block/Kconfig
--- a/block/Kconfig~scsi-make-scsi-sg-v4-driver-enabled-by-default-and-remove-experimental-dependency-since-udev-depends-on-bsg
+++ a/block/Kconfig
@@ -48,9 +48,9 @@ config LBDAF
 	  If unsure, say Y.
 
 config BLK_DEV_BSG
-	bool "Block layer SG support v4 (EXPERIMENTAL)"
-	depends on EXPERIMENTAL
-	---help---
+	bool "Block layer SG support v4"
+	default y
+	help
 	  Saying Y here will enable generic SG (SCSI generic) v4 support
 	  for any block device.
 
@@ -60,7 +60,10 @@ config BLK_DEV_BSG
 	  protocols (e.g. Task Management Functions and SMP in Serial
 	  Attached SCSI).
 
-	  If unsure, say N.
+	  This option is required by recent UDEV versions to properly 
+	  access device serial numbers, etc.
+
+	  If unsure, say Y.
 
 config BLK_DEV_INTEGRITY
 	bool "Block layer data integrity support"
_

Patches currently in -mm which might be from john@stoffel.org are

origin.patch

