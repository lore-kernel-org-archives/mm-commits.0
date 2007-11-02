From: akpm@linux-foundation.org
Subject: + telephony-phonedev-panics-if-unregistering-device-not-registered.patch added to -mm tree
Date: Fri, 02 Nov 2007 10:45:19 -0700
Message-ID: <200711021745.lA2HjJVS003701@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:44667 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756039AbXKBRpV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 2 Nov 2007 13:45:21 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mattilinnanvuori@yahoo.com


The patch titled
     telephony: phonedev panics if unregistering device not registered [Bug 9266]
has been added to the -mm tree.  Its filename is
     telephony-phonedev-panics-if-unregistering-device-not-registered.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: telephony: phonedev panics if unregistering device not registered [Bug 9266]
From: Matti Linnanvuori <mattilinnanvuori@yahoo.com>

Remove panic from phonedev.  See
http://bugzilla.kernel.org/show_bug.cgi?id=9266 for details.

Signed-off-by: Matti Linnanvuori <mattilinnanvuori@yahoo.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/telephony/phonedev.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff -puN drivers/telephony/phonedev.c~telephony-phonedev-panics-if-unregistering-device-not-registered drivers/telephony/phonedev.c
--- a/drivers/telephony/phonedev.c~telephony-phonedev-panics-if-unregistering-device-not-registered
+++ a/drivers/telephony/phonedev.c
@@ -120,9 +120,8 @@ int phone_register_device(struct phone_d
 void phone_unregister_device(struct phone_device *pfd)
 {
 	mutex_lock(&phone_lock);
-	if (phone_device[pfd->minor] != pfd)
-		panic("phone: bad unregister");
-	phone_device[pfd->minor] = NULL;
+	if (likely(phone_device[pfd->minor] == pfd))
+		phone_device[pfd->minor] = NULL;
 	mutex_unlock(&phone_lock);
 }
 
_

Patches currently in -mm which might be from mattilinnanvuori@yahoo.com are

telephony-phonedev-panics-if-unregistering-device-not-registered.patch
