From: akpm@linux-foundation.org
Subject: + rapidio-tsi721-make-module-parameter-variable-name-unique.patch added to -mm tree
Date: Wed, 29 Mar 2017 16:13:10 -0700
Message-ID: <58dc3f86.cpguHQ7NIxPOsxo2%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40622 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932963AbdC2XNM (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 29 Mar 2017 19:13:12 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rdunlap@infradead.org, alexandre.bounine@idt.com, fengguang.wu@intel.com, gregkh@linuxfoundation.org, jeremy.lefaure@lse.epita.fr, mporter@kernel.crashing.org, mm-commits@vger.kernel.org


The patch titled
     Subject: drivers/rapidio/devices/tsi721.c: make module parameter variable name unique
has been added to the -mm tree.  Its filename is
     rapidio-tsi721-make-module-parameter-variable-name-unique.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/rapidio-tsi721-make-module-parameter-variable-name-unique.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/rapidio-tsi721-make-module-parameter-variable-name-unique.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Randy Dunlap <rdunlap@infradead.org>
Subject: drivers/rapidio/devices/tsi721.c: make module parameter variable name unique

kbuild test robot reported a non-static variable name collision between a
staging driver and a RapidIO driver, with a generic variable name of
'dbg_level'.

Both drivers should be changed so that they don't use this generic public
variable name.  This patch fixes the RapidIO driver but does not change
the user interface (name) for the module parameter.

drivers/staging/built-in.o:(.bss+0x109d0): multiple definition of `dbg_level'
drivers/rapidio/built-in.o:(.bss+0x16c): first defined here

Link: http://lkml.kernel.org/r/ab527fc5-aa3c-4b07-5d48-eef5de703192@infradead.org
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Reported-by: kbuild test robot <fengguang.wu@intel.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Matt Porter <mporter@kernel.crashing.org>
Cc: Alexandre Bounine <alexandre.bounine@idt.com>
Cc: Jérémy Lefaure <jeremy.lefaure@lse.epita.fr>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rapidio/devices/tsi721.c |    4 ++--
 drivers/rapidio/devices/tsi721.h |    4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

diff -puN drivers/rapidio/devices/tsi721.c~rapidio-tsi721-make-module-parameter-variable-name-unique drivers/rapidio/devices/tsi721.c
--- a/drivers/rapidio/devices/tsi721.c~rapidio-tsi721-make-module-parameter-variable-name-unique
+++ a/drivers/rapidio/devices/tsi721.c
@@ -37,8 +37,8 @@
 #include "tsi721.h"
 
 #ifdef DEBUG
-u32 dbg_level;
-module_param(dbg_level, uint, S_IWUSR | S_IRUGO);
+u32 tsi_dbg_level;
+module_param_named(dbg_level, tsi_dbg_level, uint, S_IWUSR | S_IRUGO);
 MODULE_PARM_DESC(dbg_level, "Debugging output level (default 0 = none)");
 #endif
 
diff -puN drivers/rapidio/devices/tsi721.h~rapidio-tsi721-make-module-parameter-variable-name-unique drivers/rapidio/devices/tsi721.h
--- a/drivers/rapidio/devices/tsi721.h~rapidio-tsi721-make-module-parameter-variable-name-unique
+++ a/drivers/rapidio/devices/tsi721.h
@@ -40,11 +40,11 @@ enum {
 };
 
 #ifdef DEBUG
-extern u32 dbg_level;
+extern u32 tsi_dbg_level;
 
 #define tsi_debug(level, dev, fmt, arg...)				\
 	do {								\
-		if (DBG_##level & dbg_level)				\
+		if (DBG_##level & tsi_dbg_level)				\
 			dev_dbg(dev, "%s: " fmt "\n", __func__, ##arg);	\
 	} while (0)
 #else
_

Patches currently in -mm which might be from rdunlap@infradead.org are

rapidio-tsi721-make-module-parameter-variable-name-unique.patch

