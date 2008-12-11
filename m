From: akpm@linux-foundation.org
Subject: - driver-core-add-newlines-to-debugging-enabled-disabled-messages.patch removed from -mm tree
Date: Thu, 11 Dec 2008 11:15:07 -0800
Message-ID: <200812111915.mBBJF7iZ008231@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56537 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755003AbYLKTPn (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 11 Dec 2008 14:15:43 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: marcel@holtmann.org, greg@kroah.com, mm-commits@vger.kernel.org


The patch titled
     driver core: add newlines to debugging enabled/disabled messages
has been removed from the -mm tree.  Its filename was
     driver-core-add-newlines-to-debugging-enabled-disabled-messages.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

