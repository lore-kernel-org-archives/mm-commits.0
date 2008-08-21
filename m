From: akpm@linux-foundation.org
Subject: + acer-wmi-remove-debugfs-entries-upon-unloading.patch added to -mm tree
Date: Thu, 21 Aug 2008 14:27:27 -0700
Message-ID: <200808212127.m7LLRRlR026837@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45270 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758022AbYHUV1e (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 21 Aug 2008 17:27:34 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: russ.dill@gmail.com, Russ.Dill@gmail.com, ak@linux.intel.com, carlos@strangeworlds.co.uk


The patch titled
     acer-wmi: remove debugfs entries upon unloading
has been added to the -mm tree.  Its filename is
     acer-wmi-remove-debugfs-entries-upon-unloading.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: acer-wmi: remove debugfs entries upon unloading
From: Russ Dill <russ.dill@gmail.com>

The exit function neglects to remove debugfs entries, leading to a BUG
on reload.

Signed-off-by: Russ Dill <Russ.Dill@gmail.com>
Cc: Carlos Corbacho <carlos@strangeworlds.co.uk>
Cc: Andi Kleen <ak@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/misc/acer-wmi.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN drivers/misc/acer-wmi.c~acer-wmi-remove-debugfs-entries-upon-unloading drivers/misc/acer-wmi.c
--- a/drivers/misc/acer-wmi.c~acer-wmi-remove-debugfs-entries-upon-unloading
+++ a/drivers/misc/acer-wmi.c
@@ -1267,6 +1267,7 @@ error_platform_register:
 static void __exit acer_wmi_exit(void)
 {
 	remove_sysfs(acer_platform_device);
+	remove_debugfs();
 	platform_device_del(acer_platform_device);
 	platform_driver_unregister(&acer_platform_driver);
 
_

Patches currently in -mm which might be from russ.dill@gmail.com are

acer-wmi-remove-debugfs-entries-upon-unloading.patch
acer-wmi-remove-debugfs-entries-upon-unloading-cleanup.patch

