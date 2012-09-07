From: akpm@linux-foundation.org
Subject: + cciss-use-check_signature-fix.patch added to -mm tree
Date: Fri, 07 Sep 2012 14:49:25 -0700
Message-ID: <20120907214926.9199C5C00FC@hpza9.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-lb0-f202.google.com ([209.85.217.202]:43470 "EHLO
	mail-lb0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751250Ab2IGVt3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 7 Sep 2012 17:49:29 -0400
Received: by lbbge1 with SMTP id ge1so7886lbb.1
        for <mm-commits@vger.kernel.org>; Fri, 07 Sep 2012 14:49:28 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akinobu.mita@gmail.com, axboe@kernel.dk, mike.miller@hp.com, scameron@beardog.cce.hp.com, wfg@linux.intel.com


The patch titled
     Subject: cciss: select CONFIG_CHECK_SIGNATURE
has been added to the -mm tree.  Its filename is
     cciss-use-check_signature-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
cciss-use-check_signature-fix.patch

