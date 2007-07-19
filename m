From: akpm@linux-foundation.org
Subject: + rtc-do-not-return-void-value.patch added to -mm tree
Date: Thu, 19 Jul 2007 16:55:20 -0700
Message-ID: <200707192355.l6JNtK6b029471@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:36749 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760508AbXGSX4G (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 19 Jul 2007 19:56:06 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: anemo@mba.ocn.ne.jp, a.zummo@towertech.it, david-b@pacbell.net


The patch titled
     rtc: do not return void value
has been added to the -mm tree.  Its filename is
     rtc-do-not-return-void-value.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: rtc: do not return void value
From: Atsushi Nemoto <anemo@mba.ocn.ne.jp>

This patch fixes these sparse warnings:

drivers/rtc/rtc-ds1742.c:265:2: warning: returning void-valued expression
drivers/rtc/rtc-ds1553.c:409:2: warning: returning void-valued expression

Signed-off-by: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
Cc: David Brownell <david-b@pacbell.net>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-ds1553.c |    2 +-
 drivers/rtc/rtc-ds1742.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/rtc/rtc-ds1553.c~rtc-do-not-return-void-value drivers/rtc/rtc-ds1553.c
--- a/drivers/rtc/rtc-ds1553.c~rtc-do-not-return-void-value
+++ a/drivers/rtc/rtc-ds1553.c
@@ -407,7 +407,7 @@ static __init int ds1553_init(void)
 
 static __exit void ds1553_exit(void)
 {
-	return platform_driver_unregister(&ds1553_rtc_driver);
+	platform_driver_unregister(&ds1553_rtc_driver);
 }
 
 module_init(ds1553_init);
diff -puN drivers/rtc/rtc-ds1742.c~rtc-do-not-return-void-value drivers/rtc/rtc-ds1742.c
--- a/drivers/rtc/rtc-ds1742.c~rtc-do-not-return-void-value
+++ a/drivers/rtc/rtc-ds1742.c
@@ -263,7 +263,7 @@ static __init int ds1742_init(void)
 
 static __exit void ds1742_exit(void)
 {
-	return platform_driver_unregister(&ds1742_rtc_driver);
+	platform_driver_unregister(&ds1742_rtc_driver);
 }
 
 module_init(ds1742_init);
_

Patches currently in -mm which might be from anemo@mba.ocn.ne.jp are

origin.patch
git-kbuild.patch
mips-make-resources-for-ds1742-static-__initdata.patch
serial_txx9-fix-modem-control-line-handling.patch
serial_txx9-cleanup-includes.patch
rtc-do-not-return-void-value.patch
