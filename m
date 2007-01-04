From: akpm@osdl.org
Subject: + ipmi-fix-some-rcu-problems-update.patch added to -mm tree
Date: Thu, 04 Jan 2007 10:59:14 -0800
Message-ID: <200701041859.l04IxEiq027924@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp0.osdl.org ([65.172.181.24]:43919 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932122AbXADS7W (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 4 Jan 2007 13:59:22 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: minyard@acm.org


The patch titled
     IPMI: Fix some RCU problems (update)
has been added to the -mm tree.  Its filename is
     ipmi-fix-some-rcu-problems-update.patch

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: IPMI: Fix some RCU problems (update)
From: Corey Minyard <minyard@acm.org>

Andrew asked that the open-coded barriers be commented, so here it
is.  I also realized that one of the read barriers was in an area
where the protecting mutex was held, so no read barrier was needed.

Signed-off-by: Corey Minyard <minyard@acm.org>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/char/ipmi/ipmi_msghandler.c |   16 +++++++++++++---
 1 files changed, 13 insertions(+), 3 deletions(-)

diff -puN drivers/char/ipmi/ipmi_msghandler.c~ipmi-fix-some-rcu-problems-update drivers/char/ipmi/ipmi_msghandler.c
--- a/drivers/char/ipmi/ipmi_msghandler.c~ipmi-fix-some-rcu-problems-update
+++ a/drivers/char/ipmi/ipmi_msghandler.c
@@ -839,7 +839,6 @@ int ipmi_create_user(unsigned int       
 	goto out_kfree;
 
  found:
-	smp_rmb();
 	/* Note that each existing user holds a refcount to the interface. */
 	kref_get(&intf->refcount);
 
@@ -2762,10 +2761,15 @@ int ipmi_register_smi(struct ipmi_smi_ha
 		synchronize_rcu();
 		kref_put(&intf->refcount, intf_free);
 	} else {
-		/* After this point the interface is legal to use. */
-		smp_wmb(); /* Keep memory order straight for RCU readers. */
+		/*
+		 * Keep memory order straight for RCU readers.  Make
+		 * sure everything else is committed to memory before
+		 * setting intf_num to mark the interface valid.
+		 */
+		smp_wmb();
 		intf->intf_num = i;
 		mutex_unlock(&ipmi_interfaces_mutex);
+		/* After this point the interface is legal to use. */
 		call_smi_watchers(i, intf->si_dev);
 		mutex_unlock(&smi_watchers_mutex);
 	}
@@ -3927,6 +3931,12 @@ static void send_panic_events(char *str)
 			/* Interface was not ready yet. */
 			continue;
 
+		/*
+		 * intf_num is used as an marker to tell if the
+		 * interface is valid.  Thus we need a read barrier to
+		 * make sure data fetched before checking intf_num
+		 * won't be used.
+		 */
 		smp_rmb();
 
 		/* First job here is to figure out where to send the
_

Patches currently in -mm which might be from minyard@acm.org are

add-an-rcu-version-of-list-splicing.patch
ipmi-fix-some-rcu-problems.patch
ipmi-fix-some-rcu-problems-update.patch
