From: akpm@linux-foundation.org
Subject: - telephony-phonedev-panics-if-unregistering-device-not-registered.patch removed from -mm tree
Date: Mon, 05 Nov 2007 21:52:32 -0800
Message-ID: <200711060552.lA65qWQ6007325@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:44095 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753737AbXKFFxD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 6 Nov 2007 00:53:03 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mattilinnanvuori@yahoo.com, mm-commits@vger.kernel.org


The patch titled
     telephony: phonedev panics if unregistering device not registered [Bug 9266]
has been removed from the -mm tree.  Its filename was
     telephony-phonedev-panics-if-unregistering-device-not-registered.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

origin.patch
