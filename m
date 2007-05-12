From: akpm@linux-foundation.org
Subject: - let-sysv68_partition-default-to-yes-on-vme-only.patch removed from -mm tree
Date: Fri, 11 May 2007 22:33:16 -0700
Message-ID: <200705120533.l4C5XGQX002094@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:39293 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752314AbXELFda (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 12 May 2007 01:33:30 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: geert@linux-m68k.org, phdm@macqel.be, mm-commits@vger.kernel.org


The patch titled
     Let SYSV68_PARTITION default to yes on VME only
has been removed from the -mm tree.  Its filename was
     let-sysv68_partition-default-to-yes-on-vme-only.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Let SYSV68_PARTITION default to yes on VME only
From: Geert Uytterhoeven <geert@linux-m68k.org>

Don't enable SYSV68 partition table support on all m68k boxes by default,
only on Motorola VME boards.

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Philippe De Muyter <phdm@macqel.be>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/partitions/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/partitions/Kconfig~let-sysv68_partition-default-to-yes-on-vme-only fs/partitions/Kconfig
--- a/fs/partitions/Kconfig~let-sysv68_partition-default-to-yes-on-vme-only
+++ a/fs/partitions/Kconfig
@@ -239,7 +239,7 @@ config EFI_PARTITION
 
 config SYSV68_PARTITION
 	bool "SYSV68 partition table support" if PARTITION_ADVANCED
-	default y if M68K
+	default y if VME
 	help
 	  Say Y here if you would like to be able to read the hard disk
 	  partition table format used by Motorola Delta machines (using
_

Patches currently in -mm which might be from geert@linux-m68k.org are

origin.patch
git-dvb.patch
