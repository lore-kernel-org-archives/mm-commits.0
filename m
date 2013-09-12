From: akpm@linux-foundation.org
Subject: [merged]
 drivers-firmware-google-gsmic-replace-strict_strtoul-with-kstrtoul.patch
 removed from -mm tree
Date: Thu, 12 Sep 2013 12:46:03 -0700
Message-ID: <523219fb.nF4Jn8Nwp9HTtyng%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58701 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756432Ab3ILTqE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 12 Sep 2013 15:46:04 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, teg@jklm.no, mikew@google.com, matt.fleming@intel.com, jg1.han@samsung.com

Subject: [merged] drivers-firmware-google-gsmic-replace-strict_strtoul-with-kstrtoul.patch removed from -mm tree
To: jg1.han@samsung.com,matt.fleming@intel.com,mikew@google.com,teg@jklm.no,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Thu, 12 Sep 2013 12:46:03 -0700


The patch titled
     Subject: drivers/firmware/google/gsmi.c: replace strict_strtoul() with kstrtoul()
has been removed from the -mm tree.  Its filename was
     drivers-firmware-google-gsmic-replace-strict_strtoul-with-kstrtoul.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jingoo Han <jg1.han@samsung.com>
Subject: drivers/firmware/google/gsmi.c: replace strict_strtoul() with kstrtoul()

The use of strict_strtoul() is not preferred, because strict_strtoul() is
obsolete.  Thus, kstrtoul() should be used.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
Cc: Matt Fleming <matt.fleming@intel.com>
Cc: Tom Gundersen <teg@jklm.no>
Cc: Mike Waychison <mikew@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/firmware/google/gsmi.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/firmware/google/gsmi.c~drivers-firmware-google-gsmic-replace-strict_strtoul-with-kstrtoul drivers/firmware/google/gsmi.c
--- a/drivers/firmware/google/gsmi.c~drivers-firmware-google-gsmic-replace-strict_strtoul-with-kstrtoul
+++ a/drivers/firmware/google/gsmi.c
@@ -525,7 +525,7 @@ static ssize_t gsmi_clear_eventlog_store
 		u32 data_type;
 	} param;
 
-	rc = strict_strtoul(buf, 0, &val);
+	rc = kstrtoul(buf, 0, &val);
 	if (rc)
 		return rc;
 
_

Patches currently in -mm which might be from jg1.han@samsung.com are

origin.patch
kernel-replace-strict_strto-with-kstrto.patch

