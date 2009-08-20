From: akpm@linux-foundation.org
Subject: + hpilo-add-locking-comment.patch added to -mm tree
Date: Thu, 20 Aug 2009 14:44:15 -0700
Message-ID: <200908202144.n7KLiFqG014342@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35805 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752853AbZHTVor (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 20 Aug 2009 17:44:47 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: david.altobelli@hp.com, greg@kroah.com


The patch titled
     hpilo: add locking comment
has been added to the -mm tree.  Its filename is
     hpilo-add-locking-comment.patch

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
Subject: hpilo: add locking comment
From: David Altobelli <david.altobelli@hp.com>

Add explanation about lock nesting and purpose of each lock in hpilo.

Signed-off-by: David Altobelli <david.altobelli@hp.com>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/misc/hpilo.h |   13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

diff -puN drivers/misc/hpilo.h~hpilo-add-locking-comment drivers/misc/hpilo.h
--- a/drivers/misc/hpilo.h~hpilo-add-locking-comment
+++ a/drivers/misc/hpilo.h
@@ -44,9 +44,20 @@ struct ilo_hwinfo {
 
 	struct pci_dev *ilo_dev;
 
+	/*
+	 * open_lock      serializes ccb_cnt during open and close
+	 * [ irq disabled ]
+	 * -> alloc_lock  used when adding/removing/searching ccb_alloc,
+	 *                which represents all ccbs open on the device
+	 * --> fifo_lock  controls access to fifo queues shared with hw
+	 *
+	 * Locks must be taken in this order, but open_lock and alloc_lock
+	 * are optional, they do not need to be held in order to take a
+	 * lower level lock.
+	 */
+	spinlock_t open_lock;
 	spinlock_t alloc_lock;
 	spinlock_t fifo_lock;
-	spinlock_t open_lock;
 
 	struct cdev cdev;
 };
_

Patches currently in -mm which might be from david.altobelli@hp.com are

linux-next.patch
hpilo-add-locking-comment.patch

