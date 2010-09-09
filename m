From: akpm@linux-foundation.org
Subject: + drivers-acpi-fanc-fix-more-unbalanced-code-block.patch added to -mm tree
Date: Thu, 09 Sep 2010 16:59:52 -0700
Message-ID: <201009092359.o89NxqUJ015307@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57599 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754119Ab0IIX7y (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 9 Sep 2010 19:59:54 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: luis.henrix@gmail.com, len.brown@intel.com, liang.li@windriver.com


The patch titled
     drivers/acpi/fan.c: fix more unbalanced code block
has been added to the -mm tree.  Its filename is
     drivers-acpi-fanc-fix-more-unbalanced-code-block.patch

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
Subject: drivers/acpi/fan.c: fix more unbalanced code block
From: Luis Henriques <luis.henrix@gmail.com>

commit 934231de706d2 ("ACPI: fan: fix unbalanced code block") fixes an
unbalanced CONFIG_ACPI_PROCFS code block during module initialisation. 
This patch fixes similar issue but for the module exit.

Signed-off-by: Luis Henriques <luis.henrix@gmail.com>
Cc: Liang Li <liang.li@windriver.com>
Cc: Len Brown <len.brown@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/acpi/fan.c |    2 ++
 1 file changed, 2 insertions(+)

diff -puN drivers/acpi/fan.c~drivers-acpi-fanc-fix-more-unbalanced-code-block drivers/acpi/fan.c
--- a/drivers/acpi/fan.c~drivers-acpi-fanc-fix-more-unbalanced-code-block
+++ a/drivers/acpi/fan.c
@@ -369,7 +369,9 @@ static void __exit acpi_fan_exit(void)
 
 	acpi_bus_unregister_driver(&acpi_fan_driver);
 
+#ifdef CONFIG_ACPI_PROCFS
 	remove_proc_entry(ACPI_FAN_CLASS, acpi_root_dir);
+#endif
 
 	return;
 }
_

Patches currently in -mm which might be from luis.henrix@gmail.com are

drivers-acpi-fanc-fix-more-unbalanced-code-block.patch

