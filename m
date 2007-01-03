From: akpm@osdl.org
Subject: + ipmi-fix-some-rcu-problems.patch added to -mm tree
Date: Wed, 03 Jan 2007 13:22:36 -0800
Message-ID: <200701032122.l03LMa3T031658@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:52792 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932107AbXACVj6 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 3 Jan 2007 16:39:58 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: minyard@acm.org, paulmck@linux.vnet.ibm.com


The patch titled
     IPMI: Fix some RCU problems
has been added to the -mm tree.  Its filename is
     ipmi-fix-some-rcu-problems.patch

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: IPMI: Fix some RCU problems
From: Corey Minyard <minyard@acm.org>

Fix some RCU problem pointed out by Paul McKenney of IBM.  These are:

The wholesale move of the command receivers list into a new list was not
safe because the list will point to the new tail during a traversal, so the
traversal will never end on a reader if this happens during a read.

Memory barriers were needed to handle proper ordering of the setting of the
IPMI interface as valid.  Readers might not see proper ordering of data
otherwise.

In ipmi_smi_watcher_register(), the use of the _rcu suffix on the list is
unnecessary.

This require the list_splice_init_rcu() patch previously posted.

Signed-off-by: Corey Minyard <minyard@acm.org>
Cc: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/char/ipmi/ipmi_msghandler.c |   17 +++++++++++------
 1 files changed, 11 insertions(+), 6 deletions(-)

diff -puN drivers/char/ipmi/ipmi_msghandler.c~ipmi-fix-some-rcu-problems drivers/char/ipmi/ipmi_msghandler.c
--- a/drivers/char/ipmi/ipmi_msghandler.c~ipmi-fix-some-rcu-problems
+++ a/drivers/char/ipmi/ipmi_msghandler.c
@@ -406,13 +406,14 @@ static void clean_up_interface_data(ipmi
 	free_smi_msg_list(&intf->waiting_msgs);
 	free_recv_msg_list(&intf->waiting_events);
 
-	/* Wholesale remove all the entries from the list in the
-	 * interface and wait for RCU to know that none are in use. */
+	/*
+	 * Wholesale remove all the entries from the list in the
+	 * interface and wait for RCU to know that none are in use.
+	 */
 	mutex_lock(&intf->cmd_rcvrs_mutex);
-	list_add_rcu(&list, &intf->cmd_rcvrs);
-	list_del_rcu(&intf->cmd_rcvrs);
+	INIT_LIST_HEAD(&list);
+	list_splice_init_rcu(&intf->cmd_rcvrs, &list, synchronize_rcu);
 	mutex_unlock(&intf->cmd_rcvrs_mutex);
-	synchronize_rcu();
 
 	list_for_each_entry_safe(rcvr, rcvr2, &list, link)
 		kfree(rcvr);
@@ -451,7 +452,7 @@ int ipmi_smi_watcher_register(struct ipm
 	mutex_lock(&ipmi_interfaces_mutex);
 
 	/* Build a list of things to deliver. */
-	list_for_each_entry_rcu(intf, &ipmi_interfaces, link) {
+	list_for_each_entry(intf, &ipmi_interfaces, link) {
 		if (intf->intf_num == -1)
 			continue;
 		e = kmalloc(sizeof(*e), GFP_KERNEL);
@@ -838,6 +839,7 @@ int ipmi_create_user(unsigned int       
 	goto out_kfree;
 
  found:
+	smp_rmb();
 	/* Note that each existing user holds a refcount to the interface. */
 	kref_get(&intf->refcount);
 
@@ -2761,6 +2763,7 @@ int ipmi_register_smi(struct ipmi_smi_ha
 		kref_put(&intf->refcount, intf_free);
 	} else {
 		/* After this point the interface is legal to use. */
+		smp_wmb(); /* Keep memory order straight for RCU readers. */
 		intf->intf_num = i;
 		mutex_unlock(&ipmi_interfaces_mutex);
 		call_smi_watchers(i, intf->si_dev);
@@ -3924,6 +3927,8 @@ static void send_panic_events(char *str)
 			/* Interface was not ready yet. */
 			continue;
 
+		smp_rmb();
+
 		/* First job here is to figure out where to send the
 		   OEM events.  There's no way in IPMI to send OEM
 		   events using an event send command, so we have to
_

Patches currently in -mm which might be from minyard@acm.org are

add-an-rcu-version-of-list-splicing.patch
ipmi-fix-some-rcu-problems.patch
