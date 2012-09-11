From: akpm@linux-foundation.org
Subject: [merged] cciss-use-check_signature-fix.patch removed from -mm tree
Date: Tue, 11 Sep 2012 12:33:09 -0700
Message-ID: <20120911193309.C9A4C1E0043@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gh0-f202.google.com ([209.85.160.202]:62302 "EHLO
	mail-gh0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751504Ab2IKTdL (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 11 Sep 2012 15:33:11 -0400
Received: by ghbz15 with SMTP id z15so95958ghb.1
        for <mm-commits@vger.kernel.org>; Tue, 11 Sep 2012 12:33:10 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akinobu.mita@gmail.com, axboe@kernel.dk, mike.miller@hp.com, scameron@beardog.cce.hp.com, wfg@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: cciss: select CONFIG_CHECK_SIGNATURE
has been removed from the -mm tree.  Its filename was
     cciss-use-check_signature-fix.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Akinobu Mita <akinobu.mita@gmail.com>
Subject: cciss: select CONFIG_CHECK_SIGNATURE

The patch cciss-use-check_signature.patch in -mm tree introduced
a build error:

drivers/built-in.o: In function `CISS_signature_present':
drivers/block/cciss.c:4270: undefined reference to `check_signature'

Add missing CONFIG_CHECK_SIGNATURE to fix this issue.

Reported-by: Fengguang Wu <wfg@linux.intel.com>
Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Cc: Fengguang Wu <wfg@linux.intel.com>
Cc: Mike Miller <mike.miller@hp.com>
Cc: Jens Axboe <axboe@kernel.dk>
Acked-by: "Stephen M. Cameron" <scameron@beardog.cce.hp.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/Kconfig |    1 +
 1 file changed, 1 insertion(+)

diff -puN drivers/block/Kconfig~cciss-use-check_signature-fix drivers/block/Kconfig
--- a/drivers/block/Kconfig~cciss-use-check_signature-fix
+++ a/drivers/block/Kconfig
@@ -131,6 +131,7 @@ config BLK_CPQ_DA
 config BLK_CPQ_CISS_DA
 	tristate "Compaq Smart Array 5xxx support"
 	depends on PCI
+	select CHECK_SIGNATURE
 	help
 	  This is the driver for Compaq Smart Array 5xxx controllers.
 	  Everyone using these boards should say Y here.
_

Patches currently in -mm which might be from akinobu.mita@gmail.com are

linux-next.patch
cciss-cleanup-bitops-usage.patch
cciss-use-check_signature.patch

