From: akpm@linux-foundation.org
Subject: + drivers-char-miscc-misc_register-do-not-loop-on-misc_list-unconditionally.patch added to -mm tree
Date: Wed, 19 Dec 2012 15:12:50 -0800
Message-ID: <20121219231251.865ED100048@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vb0-f74.google.com ([209.85.212.74]:54710 "EHLO
	mail-vb0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751948Ab2LSXMx (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 19 Dec 2012 18:12:53 -0500
Received: by mail-vb0-f74.google.com with SMTP id s24so299102vbi.5
        for <mm-commits@vger.kernel.org>; Wed, 19 Dec 2012 15:12:52 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dae@velatum.com, arnd@arndb.de, greg@kroah.com


The patch titled
     Subject: drivers/char/misc.c:misc_register(): do not loop on misc_list unconditionally
has been added to the -mm tree.  Its filename is
     drivers-char-miscc-misc_register-do-not-loop-on-misc_list-unconditionally.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: "Dae S. Kim" <dae@velatum.com>
Subject: drivers/char/misc.c:misc_register(): do not loop on misc_list unconditionally

If the minor number is assigned dynamically, there is no need to search
for misc->minor in misc_list, since misc->minor == MISC_DYNAMIC_MINOR.

Signed-off-by: Dae S. Kim <dae@velatum.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/misc.c |   13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff -puN drivers/char/misc.c~drivers-char-miscc-misc_register-do-not-loop-on-misc_list-unconditionally drivers/char/misc.c
--- a/drivers/char/misc.c~drivers-char-miscc-misc_register-do-not-loop-on-misc_list-unconditionally
+++ a/drivers/char/misc.c
@@ -190,12 +190,6 @@ int misc_register(struct miscdevice * mi
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
@@ -205,6 +199,13 @@ int misc_register(struct miscdevice * mi
 		}
 		misc->minor = DYNAMIC_MINORS - i - 1;
 		set_bit(i, misc_minors);
+	} else {
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

drivers-char-miscc-misc_register-do-not-loop-on-misc_list-unconditionally.patch
drivers-char-miscc-misc_register-do-not-loop-on-misc_list-unconditionally-fix.patch

