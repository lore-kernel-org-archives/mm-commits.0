From: Andrew Morton <akpm@linux-foundation.org>
Subject: +
 =?US-ASCII?Q?test=5Ffirmware-remove-unnecessary-test=5Ffw=5Fmutex-in-te?=
 =?US-ASCII?Q?st=5Fdev=5Fconfig=5Fshow=5Fxxx.patch?= added to -mm tree
Date: Wed, 15 Apr 2020 10:44:32 -0700
Message-ID: <20200415174432.s1yvVQuPF%akpm@linux-foundation.org>
References: <20200412004155.1a8f4e081b4e03ef5903abb5@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:60750 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2411454AbgDORod (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 15 Apr 2020 13:44:33 -0400
In-Reply-To: <20200412004155.1a8f4e081b4e03ef5903abb5@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: gregkh@linuxfoundation.org, keescook@chromium.org, mcgrof@kernel.org, mm-commits@vger.kernel.org, scott.branden@broadcom.com


The patch titled
     Subject: test_firmware: remove unnecessary test_fw_mutex in test_dev_config_show_xxx
has been added to the -mm tree.  Its filename is
     test_firmware-remove-unnecessary-test_fw_mutex-in-test_dev_config_show_xxx.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/test_firmware-remove-unnecessary-test_fw_mutex-in-test_dev_config_show_xxx.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/test_firmware-remove-unnecessary-test_fw_mutex-in-test_dev_config_show_xxx.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Scott Branden <scott.branden@broadcom.com>
Subject: test_firmware: remove unnecessary test_fw_mutex in test_dev_config_show_xxx

Remove unnecessary use of test_fw_mutex in test_dev_config_show_xxx
functions that show simple bool, int, and u8.

Link: http://lkml.kernel.org/r/20200415002517.4328-1-scott.branden@broadcom.com
Signed-off-by: Scott Branden <scott.branden@broadcom.com>
Reviewed-by: Kees Cook <keescook@chromium.org>
Cc: Luis Chamberlain <mcgrof@kernel.org>
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
