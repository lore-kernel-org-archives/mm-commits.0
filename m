From: akpm@linux-foundation.org
Subject: + prevent-ssb-compilation-on-s390-part-2.patch added to -mm tree
Date: Wed, 01 Aug 2007 15:46:24 -0700
Message-ID: <200708012246.l71MkO13021335@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:43530 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754489AbXHAWrn (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 1 Aug 2007 18:47:43 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: heiko.carstens@de.ibm.com, linville@tuxdriver.com, mb@bu3sch.de, schwidefsky@de.ibm.com


The patch titled
     prevent SSB compilation on s390
has been added to the -mm tree.  Its filename is
     prevent-ssb-compilation-on-s390-part-2.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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

origin.patch
fix-warn_on-on-bitfield-ops-for-all-other-archs.patch
git-wireless.patch
avoid-ssb-compililation-on-s390.patch
prevent-ssb-compilation-on-s390-part-2.patch
during-vm-oom-condition-kill-all-threads-in-process-group.patch
