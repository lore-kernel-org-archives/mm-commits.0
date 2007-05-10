From: akpm@linux-foundation.org
Subject: + let-sysv68_partition-default-to-yes-on-vme-only.patch added to -mm tree
Date: Wed, 09 May 2007 21:08:52 -0700
Message-ID: <200705100408.l4A48qcW011649@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:36146 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754530AbXEJEJN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 10 May 2007 00:09:13 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: geert@linux-m68k.org, phdm@macqel.be


The patch titled
     Let SYSV68_PARTITION default to yes on VME only
has been added to the -mm tree.  Its filename is
     let-sysv68_partition-default-to-yes-on-vme-only.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
git-net.patch
let-sysv68_partition-default-to-yes-on-vme-only.patch
