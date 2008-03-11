From: akpm@linux-foundation.org
Subject: - memstick-add-memstick_suspend-resume_host-methods.patch removed from -mm tree
Date: Mon, 10 Mar 2008 20:21:45 -0700
Message-ID: <200803110321.m2B3Lj4p019742@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51341 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752062AbYCKDWR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 10 Mar 2008 23:22:17 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: oakad@yahoo.com, mm-commits@vger.kernel.org


The patch titled
     memstick: add memstick_suspend/resume_host methods
has been removed from the -mm tree.  Its filename was
     memstick-add-memstick_suspend-resume_host-methods.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: memstick: add memstick_suspend/resume_host methods
From: Alex Dubov <oakad@yahoo.com>

Bus driver may need to be informed that host is being suspended/resumed.

Signed-off-by: Alex Dubov <oakad@yahoo.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/memstick/core/memstick.c |   25 +++++++++++++++++++++++++
 drivers/memstick/host/tifm_ms.c  |    8 ++++----
 include/linux/memstick.h         |    2 ++
 3 files changed, 31 insertions(+), 4 deletions(-)

diff -puN drivers/memstick/core/memstick.c~memstick-add-memstick_suspend-resume_host-methods drivers/memstick/core/memstick.c
--- a/drivers/memstick/core/memstick.c~memstick-add-memstick_suspend-resume_host-methods
+++ a/drivers/memstick/core/memstick.c
@@ -561,6 +561,31 @@ void memstick_free_host(struct memstick_
 }
 EXPORT_SYMBOL(memstick_free_host);
 
+/**
+ * memstick_suspend_host - notify bus driver of host suspension
+ * @host - host to use
+ */
+void memstick_suspend_host(struct memstick_host *host)
+{
+	mutex_lock(&host->lock);
+	host->set_param(host, MEMSTICK_POWER, MEMSTICK_POWER_OFF);
+	mutex_unlock(&host->lock);
+}
+EXPORT_SYMBOL(memstick_suspend_host);
+
+/**
+ * memstick_resume_host - notify bus driver of host resumption
+ * @host - host to use
+ */
+void memstick_resume_host(struct memstick_host *host)
+{
+	mutex_lock(&host->lock);
+	host->set_param(host, MEMSTICK_POWER, MEMSTICK_POWER_ON);
+	mutex_unlock(&host->lock);
+	memstick_detect_change(host);
+}
+EXPORT_SYMBOL(memstick_resume_host);
+
 int memstick_register_driver(struct memstick_driver *drv)
 {
 	drv->driver.bus = &memstick_bus_type;
diff -puN drivers/memstick/host/tifm_ms.c~memstick-add-memstick_suspend-resume_host-methods drivers/memstick/host/tifm_ms.c
--- a/drivers/memstick/host/tifm_ms.c~memstick-add-memstick_suspend-resume_host-methods
+++ a/drivers/memstick/host/tifm_ms.c
@@ -627,17 +627,17 @@ static void tifm_ms_remove(struct tifm_d
 
 static int tifm_ms_suspend(struct tifm_dev *sock, pm_message_t state)
 {
+	struct memstick_host *msh = tifm_get_drvdata(sock);
+
+	memstick_suspend_host(msh);
 	return 0;
 }
 
 static int tifm_ms_resume(struct tifm_dev *sock)
 {
 	struct memstick_host *msh = tifm_get_drvdata(sock);
-	struct tifm_ms *host = memstick_priv(msh);
-
-	tifm_ms_initialize_host(host);
-	memstick_detect_change(msh);
 
+	memstick_resume_host(msh);
 	return 0;
 }
 
diff -puN include/linux/memstick.h~memstick-add-memstick_suspend-resume_host-methods include/linux/memstick.h
--- a/include/linux/memstick.h~memstick-add-memstick_suspend-resume_host-methods
+++ a/include/linux/memstick.h
@@ -312,6 +312,8 @@ int memstick_add_host(struct memstick_ho
 void memstick_remove_host(struct memstick_host *host);
 void memstick_free_host(struct memstick_host *host);
 void memstick_detect_change(struct memstick_host *host);
+void memstick_suspend_host(struct memstick_host *host);
+void memstick_resume_host(struct memstick_host *host);
 
 void memstick_init_req_sg(struct memstick_request *mrq, unsigned char tpc,
 			  struct scatterlist *sg);
_

Patches currently in -mm which might be from oakad@yahoo.com are

origin.patch
fix-gregkh-driver-net-convert-the-phy_device-file-to-use-bus_find_device_by_name.patch

