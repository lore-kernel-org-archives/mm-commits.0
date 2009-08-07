From: akpm@linux-foundation.org
Subject: + mtd-make-onenand-genericc-more-generic-fix.patch added to -mm tree
Date: Thu, 06 Aug 2009 23:07:44 -0700
Message-ID: <200908070607.n7767i6s000316@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56826 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753962AbZHGGId (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 7 Aug 2009 02:08:33 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: lethal@linux-sh.org, damm@igel.co.jp, dwmw2@infradead.org, kmpark@infradead.org, randy.dunlap@oracle.com, tony@atomide.com


The patch titled
     mtd: onenand: select MTD_PARTITIONS
has been added to the -mm tree.  Its filename is
     mtd-make-onenand-genericc-more-generic-fix.patch

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
Subject: mtd: onenand: select MTD_PARTITIONS
From: Paul Mundt <lethal@linux-sh.org>

All of the onenand drivers depend on mtd partition support being compiled
in, so just select it.  Fixes up build breakage:

drivers/built-in.o: In function `generic_onenand_remove':
generic.c:(.devexit.text+0x80): undefined reference to `del_mtd_partitions'

Reported-by: Randy Dunlap <randy.dunlap@oracle.com>
Acked-by: Randy Dunlap <randy.dunlap@oracle.com>
Signed-off-by: Paul Mundt <lethal@linux-sh.org>
Cc: Magnus Damm <damm@igel.co.jp>
Cc: David Woodhouse <dwmw2@infradead.org>
Cc: Tony Lindgren <tony@atomide.com>
Cc: Kyungmin Park <kmpark@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/mtd/onenand/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/mtd/onenand/Kconfig~mtd-make-onenand-genericc-more-generic-fix drivers/mtd/onenand/Kconfig
--- a/drivers/mtd/onenand/Kconfig~mtd-make-onenand-genericc-more-generic-fix
+++ a/drivers/mtd/onenand/Kconfig
@@ -5,6 +5,7 @@
 menuconfig MTD_ONENAND
 	tristate "OneNAND Device Support"
 	depends on MTD
+	select MTD_PARTITIONS
 	help
 	  This enables support for accessing all type of OneNAND flash
 	  devices. For further information see
@@ -65,7 +66,6 @@ config MTD_ONENAND_2X_PROGRAM
 
 config MTD_ONENAND_SIM
 	tristate "OneNAND simulator support"
-	depends on MTD_PARTITIONS
 	help
 	  The simulator may simulate various OneNAND flash chips for the
 	  OneNAND MTD layer.
_

Patches currently in -mm which might be from lethal@linux-sh.org are

linux-next.patch
mtd-make-onenand-genericc-more-generic.patch
mtd-make-onenand-genericc-more-generic-fix.patch
arches-drop-superfluous-casts-in-nr_free_pages-callers.patch
mmc-make-the-configuration-memory-resource-optional.patch
tmio_mmc-optionally-support-using-platform-clock.patch
sh-switch-migo-r-to-use-the-tmio-mmc-driver-instead-of-spi.patch
fdpic-ignore-the-loaders-pt_gnu_stack-when-calculating-the-stack-size.patch
flat-use-is_err_value-helper-macro.patch

