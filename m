From: akpm@linux-foundation.org
Subject: - prevent-ssb-compilation-on-s390-part-2.patch removed from -mm tree
Date: Mon, 06 Aug 2007 00:53:37 -0700
Message-ID: <200708060753.l767rbgB016354@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:49561 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758609AbXHFH4v (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 6 Aug 2007 03:56:51 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: heiko.carstens@de.ibm.com, linville@tuxdriver.com, mb@bu3sch.de, schwidefsky@de.ibm.com, mm-commits@vger.kernel.org


The patch titled
     prevent SSB compilation on s390
has been removed from the -mm tree.  Its filename was
     prevent-ssb-compilation-on-s390-part-2.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: prevent SSB compilation on s390
From: Heiko Carstens <heiko.carstens@de.ibm.com>

drivers/ssb/Kconfig has already a depends on HAS_IOMEM which should prevent
SSB from being selected.  But appearantly it looks like this doesn't matter
at all if it gets selected from somewhere else.  So add an explicit depends
on HAS_IOMEM to the Broadcom driver to prevent selection on s390.

Cc: "John W. Linville" <linville@tuxdriver.com>
Cc: Michael Buesch <mb@bu3sch.de>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/Kconfig |    1 +
 1 files changed, 1 insertion(+)

diff -puN drivers/net/Kconfig~prevent-ssb-compilation-on-s390-part-2 drivers/net/Kconfig
--- a/drivers/net/Kconfig~prevent-ssb-compilation-on-s390-part-2
+++ a/drivers/net/Kconfig
@@ -1434,6 +1434,7 @@ config APRICOT
 
 config B44
 	tristate "Broadcom 440x/47xx ethernet support"
+	depends on HAS_IOMEM
 	select SSB
 	select MII
 	help
_

Patches currently in -mm which might be from heiko.carstens@de.ibm.com are

slow-down-printk-during-boot-fix-4.patch
git-wireless.patch
avoid-ssb-compililation-on-s390.patch
during-vm-oom-condition-kill-all-threads-in-process-group.patch
