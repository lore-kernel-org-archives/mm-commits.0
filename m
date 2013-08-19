From: akpm@linux-foundation.org
Subject: + rtc-rtc-nuc900-use-null-instead-of-0.patch added to -mm tree
Date: Mon, 19 Aug 2013 16:24:32 -0700
Message-ID: <5212a930.KdGoE8guIoRVztUG%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:55539 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751204Ab3HSXYd (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 19 Aug 2013 19:24:33 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, jg1.han@samsung.com

Subject: + rtc-rtc-nuc900-use-null-instead-of-0.patch added to -mm tree
To: jg1.han@samsung.com
From: akpm@linux-foundation.org
Date: Mon, 19 Aug 2013 16:24:32 -0700


The patch titled
     Subject: drivers/rtc/rtc-nuc900.c: use NULL instead of 0
has been added to the -mm tree.  Its filename is
     rtc-rtc-nuc900-use-null-instead-of-0.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/rtc-rtc-nuc900-use-null-instead-of-0.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/rtc-rtc-nuc900-use-null-instead-of-0.patch

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
Subject: drivers/rtc/rtc-nuc900.c: use NULL instead of 0

check_rtc_access_enable() returns pointer, thus NULL should be used
instead of 0 in order to fix the following sparse warning:

drivers/rtc/rtc-nuc900.c:102:16: warning: Using plain integer as NULL pointer

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-nuc900.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/rtc/rtc-nuc900.c~rtc-rtc-nuc900-use-null-instead-of-0 drivers/rtc/rtc-nuc900.c
--- a/drivers/rtc/rtc-nuc900.c~rtc-rtc-nuc900-use-null-instead-of-0
+++ a/drivers/rtc/rtc-nuc900.c
@@ -99,7 +99,7 @@ static int *check_rtc_access_enable(stru
 	if (!timeout)
 		return ERR_PTR(-EPERM);
 
-	return 0;
+	return NULL;
 }
 
 static int nuc900_rtc_bcd2bin(unsigned int timereg,
_

Patches currently in -mm which might be from jg1.han@samsung.com are

block-replace-strict_strtoul-with-kstrtoul.patch
block-blk-sysfs-replace-strict_strtoul-with-kstrtoul.patch
drivers-block-mg_diskc-make-mg_times_out-static.patch
mm-replace-strict_strtoul-with-kstrtoul.patch
drivers-firmware-google-gsmic-replace-strict_strtoul-with-kstrtoul.patch
kernel-replace-strict_strto-with-kstrto.patch
rtc-rtc-nuc900-use-null-instead-of-0.patch
documentation-replace-strict_strtoul-with-kstrtoul.patch
w1-replace-strict_strtol-with-kstrtol.patch
linux-next.patch

