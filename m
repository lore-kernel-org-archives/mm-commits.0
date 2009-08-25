From: akpm@linux-foundation.org
Subject: [merged] char-impi-adding-__init-macro-fix-of-__exit-macro-location-in-ipmi_poweroffc.patch removed from -mm tree
Date: Tue, 25 Aug 2009 11:45:30 -0700
Message-ID: <200908251845.n7PIjUZt013781@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59998 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755449AbZHYSqG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 25 Aug 2009 14:46:06 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: peterhuewe@gmx.de, jkosina@suse.cz, minyard@acm.org, mm-commits@vger.kernel.org


The patch titled
     char/impi: add __init macro/ fix of __exit macro location in ipmi_poweroff.c
has been removed from the -mm tree.  Its filename was
     char-impi-adding-__init-macro-fix-of-__exit-macro-location-in-ipmi_poweroffc.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: char/impi: add __init macro/ fix of __exit macro location in ipmi_poweroff.c
From: Peter Huewe <peterhuewe@gmx.de>

Add the __init to the module_init function of
drivers/char/ipmi/ipmy_poweroff.c and corrects the location of __exit for
the cleanup function.

Signed-off-by: Peter Huewe <peterhuewe@gmx.de>
Cc: Corey Minyard <minyard@acm.org>
Cc: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/ipmi/ipmi_poweroff.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/char/ipmi/ipmi_poweroff.c~char-impi-adding-__init-macro-fix-of-__exit-macro-location-in-ipmi_poweroffc drivers/char/ipmi/ipmi_poweroff.c
--- a/drivers/char/ipmi/ipmi_poweroff.c~char-impi-adding-__init-macro-fix-of-__exit-macro-location-in-ipmi_poweroffc
+++ a/drivers/char/ipmi/ipmi_poweroff.c
@@ -691,7 +691,7 @@ static struct ctl_table_header *ipmi_tab
 /*
  * Startup and shutdown functions.
  */
-static int ipmi_poweroff_init(void)
+static int __init ipmi_poweroff_init(void)
 {
 	int rv;
 
@@ -725,7 +725,7 @@ static int ipmi_poweroff_init(void)
 }
 
 #ifdef MODULE
-static __exit void ipmi_poweroff_cleanup(void)
+static void __exit ipmi_poweroff_cleanup(void)
 {
 	int rv;
 
_

Patches currently in -mm which might be from peterhuewe@gmx.de are

linux-next.patch
scsi-add-__init-__exit-macros-to-ibmvstgtc.patch

