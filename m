From: akpm@linux-foundation.org
Subject: + driver-core-add-newlines-to-debugging-enabled-disabled-messages.patch added to -mm tree
Date: Tue, 02 Dec 2008 15:50:59 -0800
Message-ID: <200812022351.mB2NoxCc019755@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55057 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753185AbYLBXve (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 2 Dec 2008 18:51:34 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: marcel@holtmann.org, greg@kroah.com


The patch titled
     driver core: add newlines to debugging enabled/disabled messages
has been added to the -mm tree.  Its filename is
     driver-core-add-newlines-to-debugging-enabled-disabled-messages.patch

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
Subject: driver core: add newlines to debugging enabled/disabled messages
From: Marcel Holtmann <marcel@holtmann.org>

Both messages are missing the newline and thus dmesg output gets
scrambled.

Signed-off-by: Marcel Holtmann <marcel@holtmann.org>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/dynamic_printk.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN lib/dynamic_printk.c~driver-core-add-newlines-to-debugging-enabled-disabled-messages lib/dynamic_printk.c
--- a/lib/dynamic_printk.c~driver-core-add-newlines-to-debugging-enabled-disabled-messages
+++ a/lib/dynamic_printk.c
@@ -289,7 +289,7 @@ static ssize_t pr_debug_write(struct fil
 					dynamic_enabled = DYNAMIC_ENABLED_SOME;
 					err = 0;
 					printk(KERN_DEBUG
-					       "debugging enabled for module %s",
+					       "debugging enabled for module %s\n",
 					       elem->name);
 				} else if (!value && (elem->enable == 1)) {
 					elem->enable = 0;
@@ -309,7 +309,7 @@ static ssize_t pr_debug_write(struct fil
 					err = 0;
 					printk(KERN_DEBUG
 					       "debugging disabled for module "
-					       "%s", elem->name);
+					       "%s\n", elem->name);
 				}
 			}
 		}
_

Patches currently in -mm which might be from marcel@holtmann.org are

linux-next.patch
driver-core-add-newlines-to-debugging-enabled-disabled-messages.patch

