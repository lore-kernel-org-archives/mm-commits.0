From: akpm@linux-foundation.org
Subject: - w1-decrement-slave-counter-only-in-release-callback.patch removed from -mm tree
Date: Tue, 15 Jan 2008 17:38:02 -0800
Message-ID: <200801160138.m0G1c2Qo013879@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:52421 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751619AbYAPBvb (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 15 Jan 2008 20:51:31 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: johnpol@2ka.mipt.ru, henri.laakso@wapice.com, mm-commits@vger.kernel.org


The patch titled
     w1: decrement slave counter only in ->release() callback
has been removed from the -mm tree.  Its filename was
     w1-decrement-slave-counter-only-in-release-callback.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: w1: decrement slave counter only in ->release() callback
From: Evgeniy Polyakov <johnpol@2ka.mipt.ru>

Decrement the slave counter only in ->release() callback instead of both in
->release() and w1 control.

Patch is based on debug work and preliminary patch made by Henri Laakso. 
Henri noticed in debug that this counter becomes negative after w1 slave
device is physically removed.

Signed-off-by: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
Cc: Henri Laakso <henri.laakso@wapice.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/w1/w1.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff -puN drivers/w1/w1.c~w1-decrement-slave-counter-only-in-release-callback drivers/w1/w1.c
--- a/drivers/w1/w1.c~w1-decrement-slave-counter-only-in-release-callback
+++ a/drivers/w1/w1.c
@@ -869,11 +869,9 @@ void w1_search_process(struct w1_master 
 	w1_search_devices(dev, search_type, w1_slave_found);
 
 	list_for_each_entry_safe(sl, sln, &dev->slist, w1_slave_entry) {
-		if (!test_bit(W1_SLAVE_ACTIVE, (unsigned long *)&sl->flags) && !--sl->ttl) {
+		if (!test_bit(W1_SLAVE_ACTIVE, (unsigned long *)&sl->flags) && !--sl->ttl)
 			w1_slave_detach(sl);
-
-			dev->slave_count--;
-		} else if (test_bit(W1_SLAVE_ACTIVE, (unsigned long *)&sl->flags))
+		else if (test_bit(W1_SLAVE_ACTIVE, (unsigned long *)&sl->flags))
 			sl->ttl = dev->slave_ttl;
 	}
 
_

Patches currently in -mm which might be from johnpol@2ka.mipt.ru are

origin.patch
git-cryptodev.patch
ds1wm-decouple-host-irq-and-intr-active-state-settings.patch
w1-remove-unused-and-confusing-variable.patch
w1-gpio-add-gpio-w1-bus-master-driver.patch
w1-gpio-add-gpio-w1-bus-master-driver-v3.patch
