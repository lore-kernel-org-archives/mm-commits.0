From: akpm@linux-foundation.org
Subject: +
 drivers-firmware-google-gsmic-replace-strict_strtoul-with-kstrtoul.patch
 added to -mm tree
Date: Fri, 19 Jul 2013 15:00:07 -0700
Message-ID: <51e9b6e7.IeEnP4mEmafAdKAl%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:52180 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751915Ab3GSWAI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 19 Jul 2013 18:00:08 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, teg@jklm.no, mikew@google.com, matt.fleming@intel.com, jg1.han@samsung.com

Subject: + drivers-firmware-google-gsmic-replace-strict_strtoul-with-kstrtoul.patch added to -mm tree
To: jg1.han@samsung.com,matt.fleming@intel.com,mikew@google.com,teg@jklm.no
From: akpm@linux-foundation.org
Date: Fri, 19 Jul 2013 15:00:07 -0700


The patch titled
     Subject: drivers/firmware/google/gsmi.c: replace strict_strtoul() with kstrtoul()
has been added to the -mm tree.  Its filename is
     drivers-firmware-google-gsmic-replace-strict_strtoul-with-kstrtoul.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/drivers-firmware-google-gsmic-replace-strict_strtoul-with-kstrtoul.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/drivers-firmware-google-gsmic-replace-strict_strtoul-with-kstrtoul.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

block-replace-strict_strtoul-with-kstrtoul.patch
drivers-firmware-google-gsmic-replace-strict_strtoul-with-kstrtoul.patch
linux-next.patch

