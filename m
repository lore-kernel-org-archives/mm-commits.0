From: akpm@linux-foundation.org
Subject: [merged]
 =?US-ASCII?Q?test=5Ffirmware-remove-unnecessary-test=5Ffw=5Fmutex-in-te?=
 =?US-ASCII?Q?st=5Fdev=5Fconfig=5Fshow=5Fxxx.patch?= removed from -mm tree
Date: Mon, 20 Apr 2020 12:17:41 -0700
Message-ID: <20200420191741.G8uO49d8v%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:34252 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727951AbgDTTRm (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 20 Apr 2020 15:17:42 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: gregkh@linuxfoundation.org, keescook@chromium.org, mcgrof@kernel.org, mm-commits@vger.kernel.org, scott.branden@broadcom.com


The patch titled
     Subject: test_firmware: remove unnecessary test_fw_mutex in test_dev_config_show_xxx
has been removed from the -mm tree.  Its filename was
     test_firmware-remove-unnecessary-test_fw_mutex-in-test_dev_config_show_xxx.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Scott Branden <scott.branden@broadcom.com>
Subject: test_firmware: remove unnecessary test_fw_mutex in test_dev_config_show_xxx

Remove unnecessary use of test_fw_mutex in test_dev_config_show_xxx
functions that show simple bool, int, and u8.

Link: http://lkml.kernel.org/r/20200415002517.4328-1-scott.branden@broadcom.com
Signed-off-by: Scott Branden <scott.branden@broadcom.com>
Reviewed-by: Kees Cook <keescook@chromium.org>
Reviewed-by: Luis Chamberlain <mcgrof@kernel.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/test_firmware.c |   26 +++-----------------------
 1 file changed, 3 insertions(+), 23 deletions(-)

--- a/lib/test_firmware.c~test_firmware-remove-unnecessary-test_fw_mutex-in-test_dev_config_show_xxx
+++ a/lib/test_firmware.c
@@ -310,27 +310,13 @@ static int test_dev_config_update_bool(c
 	return ret;
 }
 
-static ssize_t
-test_dev_config_show_bool(char *buf,
-			  bool config)
+static ssize_t test_dev_config_show_bool(char *buf, bool val)
 {
-	bool val;
-
-	mutex_lock(&test_fw_mutex);
-	val = config;
-	mutex_unlock(&test_fw_mutex);
-
 	return snprintf(buf, PAGE_SIZE, "%d\n", val);
 }
 
-static ssize_t test_dev_config_show_int(char *buf, int cfg)
+static ssize_t test_dev_config_show_int(char *buf, int val)
 {
-	int val;
-
-	mutex_lock(&test_fw_mutex);
-	val = cfg;
-	mutex_unlock(&test_fw_mutex);
-
 	return snprintf(buf, PAGE_SIZE, "%d\n", val);
 }
 
@@ -354,14 +340,8 @@ static int test_dev_config_update_u8(con
 	return size;
 }
 
-static ssize_t test_dev_config_show_u8(char *buf, u8 cfg)
+static ssize_t test_dev_config_show_u8(char *buf, u8 val)
 {
-	u8 val;
-
-	mutex_lock(&test_fw_mutex);
-	val = cfg;
-	mutex_unlock(&test_fw_mutex);
