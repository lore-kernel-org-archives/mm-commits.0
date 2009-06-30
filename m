From: akpm@linux-foundation.org
Subject: + base-firmware_class-fix-lock-imbalance.patch added to -mm tree
Date: Tue, 30 Jun 2009 13:10:39 -0700
Message-ID: <200906302010.n5UKAdWS001746@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45678 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752863AbZF3ULG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 30 Jun 2009 16:11:06 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jirislaby@gmail.com, greg@kroah.com


The patch titled
     base: firmware_class, fix lock imbalance
has been added to the -mm tree.  Its filename is
     base-firmware_class-fix-lock-imbalance.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: base: firmware_class, fix lock imbalance
From: Jiri Slaby <jirislaby@gmail.com>

Add omitted unlock in firmware_data_read.

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/base/firmware_class.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff -puN drivers/base/firmware_class.c~base-firmware_class-fix-lock-imbalance drivers/base/firmware_class.c
--- a/drivers/base/firmware_class.c~base-firmware_class-fix-lock-imbalance
+++ a/drivers/base/firmware_class.c
@@ -217,8 +217,10 @@ firmware_data_read(struct kobject *kobj,
 		ret_count = -ENODEV;
 		goto out;
 	}
-	if (offset > fw->size)
-		return 0;
+	if (offset > fw->size) {
+		ret_count = 0;
+		goto out;
+	}
 	if (count > fw->size - offset)
 		count = fw->size - offset;
 
_

Patches currently in -mm which might be from jirislaby@gmail.com are

origin.patch
floppy-fix-lock-imbalance.patch
linux-next.patch
icom-converting-space-to-tabs.patch
base-firmware_class-fix-lock-imbalance.patch
wireless-nl80211-fix-lock-imbalance.patch
reiser4.patch

