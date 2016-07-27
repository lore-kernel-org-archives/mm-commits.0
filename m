From: akpm@linux-foundation.org
Subject: + pnpbios-add-header-file-to-fix-build-errors.patch added to -mm
 tree
Date: Wed, 27 Jul 2016 13:10:49 -0700
Message-ID: <57991549.yEEVshUkXY2n5LJ/%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42857 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757365AbcG0UKu (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 27 Jul 2016 16:10:50 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rdunlap@infradead.org, gregkh@linuxfoundation.org, mcgrof@suse.com, rafael.j.wysocki@intel.com, mm-commits@vger.kernel.org


The patch titled
     From: Randy Dunlap <rdunlap@infradead.org>
has been added to the -mm tree.  Its filename is
     pnpbios-add-header-file-to-fix-build-errors.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/pnpbios-add-header-file-to-fix-build-errors.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/pnpbios-add-header-file-to-fix-build-errors.patch

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

Fix build errors due to missing header file:

../drivers/pnp/pnpbios/core.c: In function 'pnp_dock_event':
../drivers/pnp/pnpbios/core.c:141:2: error: implicit declaration of function 'call_usermodehelper' [-Werror=implicit-function-declaration]
  value = call_usermodehelper(argv [0], argv, envp, UMH_WAIT_EXEC);
  ^
../drivers/pnp/pnpbios/core.c:141:52: error: 'UMH_WAIT_EXEC' undeclared (first use in this function)
  value = call_usermodehelper(argv [0], argv, envp, UMH_WAIT_EXEC);
                                                    ^
Link: http://lkml.kernel.org/r/ae7a56b8-27a4-05c3-44f7-e1140bfd7acd@infradead.org
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Cc: Rafael Wysocki <rafael.j.wysocki@intel.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: "Luis R. Rodriguez" <mcgrof@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/pnp/pnpbios/core.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN drivers/pnp/pnpbios/core.c~pnpbios-add-header-file-to-fix-build-errors drivers/pnp/pnpbios/core.c
--- a/drivers/pnp/pnpbios/core.c~pnpbios-add-header-file-to-fix-build-errors
+++ a/drivers/pnp/pnpbios/core.c
@@ -60,6 +60,7 @@
 #include <linux/delay.h>
 #include <linux/acpi.h>
 #include <linux/freezer.h>
+#include <linux/kmod.h>
 #include <linux/kthread.h>
 
 #include <asm/page.h>
_

Patches currently in -mm which might be from rdunlap@infradead.org are

pnpbios-add-header-file-to-fix-build-errors.patch

