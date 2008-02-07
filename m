From: akpm@linux-foundation.org
Subject: - partition-use-default_sgi_partition-for-sgi_partion-default.patch removed from -mm tree
Date: Wed, 06 Feb 2008 16:24:50 -0800
Message-ID: <200802070024.m170OV5T006616@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:49787 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1764259AbYBGAoN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 6 Feb 2008 19:44:13 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: tsbogend@alpha.franken.de, mm-commits@vger.kernel.org


The patch titled
     partition: use DEFAULT_SGI_PARTITION for SGI_PARTION default
has been removed from the -mm tree.  Its filename was
     partition-use-default_sgi_partition-for-sgi_partion-default.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: partition: use DEFAULT_SGI_PARTITION for SGI_PARTION default
From: Thomas Bogendoerfer <tsbogend@alpha.franken.de>

Use DEFAULT_SGI_PARTITION for SGI_PARTION default

Signed-off-by: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/partitions/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/partitions/Kconfig~partition-use-default_sgi_partition-for-sgi_partion-default fs/partitions/Kconfig
--- a/fs/partitions/Kconfig~partition-use-default_sgi_partition-for-sgi_partion-default
+++ a/fs/partitions/Kconfig
@@ -198,7 +198,7 @@ config LDM_DEBUG
 
 config SGI_PARTITION
 	bool "SGI partition support" if PARTITION_ADVANCED
-	default y if (SGI_IP22 || SGI_IP27 || ((MACH_JAZZ || SNI_RM) && !CPU_LITTLE_ENDIAN))
+	default y if DEFAULT_SGI_PARTITION
 	help
 	  Say Y here if you would like to be able to read the hard disk
 	  partition table format used by SGI machines.
_

Patches currently in -mm which might be from tsbogend@alpha.franken.de are

origin.patch
git-scsi-misc.patch
git-watchdog.patch
