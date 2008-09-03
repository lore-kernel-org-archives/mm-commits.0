From: akpm@linux-foundation.org
Subject: - acer-wmi-remove-debugfs-entries-upon-unloading.patch removed from -mm tree
Date: Wed, 03 Sep 2008 09:11:06 -0700
Message-ID: <200809031611.m83GB66n023747@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55736 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751398AbYICQLN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 3 Sep 2008 12:11:13 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: russ.dill@gmail.com, Russ.Dill@gmail.com, ak@linux.intel.com, carlos@strangeworlds.co.uk, mm-commits@vger.kernel.org


The patch titled
     acer-wmi: remove debugfs entries upon unloading
has been removed from the -mm tree.  Its filename was
     acer-wmi-remove-debugfs-entries-upon-unloading.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: acer-wmi: remove debugfs entries upon unloading
From: Russ Dill <russ.dill@gmail.com>

The exit function neglects to remove debugfs entries, leading to a BUG
on reload.

[akpm@linux-foundation.org: cleanups]
Signed-off-by: Russ Dill <Russ.Dill@gmail.com>
Acked-by: Carlos Corbacho <carlos@strangeworlds.co.uk>
Cc: Andi Kleen <ak@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/misc/acer-wmi.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN drivers/misc/acer-wmi.c~acer-wmi-remove-debugfs-entries-upon-unloading drivers/misc/acer-wmi.c
--- a/drivers/misc/acer-wmi.c~acer-wmi-remove-debugfs-entries-upon-unloading
+++ a/drivers/misc/acer-wmi.c
@@ -1189,7 +1189,7 @@ static int create_debugfs(void)
 	return 0;
 
 error_debugfs:
-		remove_debugfs();
+	remove_debugfs();
 	return -ENOMEM;
 }
 
@@ -1272,6 +1272,7 @@ error_platform_register:
 static void __exit acer_wmi_exit(void)
 {
 	remove_sysfs(acer_platform_device);
+	remove_debugfs();
 	platform_device_del(acer_platform_device);
 	platform_driver_unregister(&acer_platform_driver);
 
_

Patches currently in -mm which might be from russ.dill@gmail.com are

origin.patch

