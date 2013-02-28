From: akpm@linux-foundation.org
Subject: [merged] drivers-char-miscc-misc_register-do-not-loop-on-misc_list-unconditionally.patch removed from -mm tree
Date: Thu, 28 Feb 2013 12:16:35 -0800
Message-ID: <20130228201635.B261C31C0A0@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ye0-f201.google.com ([209.85.213.201]:57707 "EHLO
	mail-ye0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759169Ab3B1UQh (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 28 Feb 2013 15:16:37 -0500
Received: by mail-ye0-f201.google.com with SMTP id m12so245307yen.4
        for <mm-commits@vger.kernel.org>; Thu, 28 Feb 2013 12:16:37 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dae@velatum.com, arnd@arndb.de, greg@kroah.com, mm-commits@vger.kernel.org


The patch titled
     Subject: drivers/char/misc.c:misc_register(): do not loop on misc_list unconditionally
has been removed from the -mm tree.  Its filename was
     drivers-char-miscc-misc_register-do-not-loop-on-misc_list-unconditionally.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: "Dae S. Kim" <dae@velatum.com>
Subject: drivers/char/misc.c:misc_register(): do not loop on misc_list unconditionally

If the minor number is assigned dynamically, there is no need to search
for misc->minor in misc_list, since misc->minor == MISC_DYNAMIC_MINOR.

[akpm@linux-foundation.org: reduce scope of local `c']
Signed-off-by: Dae S. Kim <dae@velatum.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/misc.c |   16 +++++++++-------
 1 file changed, 9 insertions(+), 7 deletions(-)

diff -puN drivers/char/misc.c~drivers-char-miscc-misc_register-do-not-loop-on-misc_list-unconditionally drivers/char/misc.c
--- a/drivers/char/misc.c~drivers-char-miscc-misc_register-do-not-loop-on-misc_list-unconditionally
+++ a/drivers/char/misc.c
@@ -183,19 +183,12 @@ static const struct file_operations misc
  
 int misc_register(struct miscdevice * misc)
 {
-	struct miscdevice *c;
 	dev_t dev;
 	int err = 0;
 
 	INIT_LIST_HEAD(&misc->list);
 
 	mutex_lock(&misc_mtx);
-	list_for_each_entry(c, &misc_list, list) {
-		if (c->minor == misc->minor) {
-			mutex_unlock(&misc_mtx);
-			return -EBUSY;
-		}
-	}
 
 	if (misc->minor == MISC_DYNAMIC_MINOR) {
 		int i = find_first_zero_bit(misc_minors, DYNAMIC_MINORS);
@@ -205,6 +198,15 @@ int misc_register(struct miscdevice * mi
 		}
 		misc->minor = DYNAMIC_MINORS - i - 1;
 		set_bit(i, misc_minors);
+	} else {
+		struct miscdevice *c;
+
+		list_for_each_entry(c, &misc_list, list) {
+			if (c->minor == misc->minor) {
+				mutex_unlock(&misc_mtx);
+				return -EBUSY;
+			}
+		}
 	}
 
 	dev = MKDEV(MISC_MAJOR, misc->minor);
_

Patches currently in -mm which might be from dae@velatum.com are

origin.patch

