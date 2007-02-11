From: akpm@linux-foundation.org
Subject: - uml-network-driver-locking-and-code-cleanup.patch removed from -mm tree
Date: Sun, 11 Feb 2007 14:48:43 -0800
Message-ID: <200702112248.l1BMmhEe015657@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:59763 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932674AbXBKWsp (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sun, 11 Feb 2007 17:48:45 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jdike@addtoit.com, blaisorblade@yahoo.it, mm-commits@vger.kernel.org


The patch titled
     uml: network driver locking and code cleanup
has been removed from the -mm tree.  Its filename was
     uml-network-driver-locking-and-code-cleanup.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: uml: network driver locking and code cleanup
From: Jeff Dike <jdike@addtoit.com>

Add some missing locking to walks of the transports and opened lists.

Delete some dead code.

Comment the lack of some locking.

Signed-off-by: Jeff Dike <jdike@addtoit.com>
Cc: Paolo 'Blaisorblade' Giarrusso <blaisorblade@yahoo.it>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/um/drivers/net_kern.c |   42 +++++++++++++++--------------------
 1 file changed, 18 insertions(+), 24 deletions(-)

diff -puN arch/um/drivers/net_kern.c~uml-network-driver-locking-and-code-cleanup arch/um/drivers/net_kern.c
--- a/arch/um/drivers/net_kern.c~uml-network-driver-locking-and-code-cleanup
+++ a/arch/um/drivers/net_kern.c
@@ -502,7 +502,7 @@ static DEFINE_SPINLOCK(transports_lock);
 static LIST_HEAD(transports);
 
 /* Filled in during early boot */
-struct list_head eth_cmd_line = LIST_HEAD_INIT(eth_cmd_line);
+static LIST_HEAD(eth_cmd_line);
 
 static int check_transport(struct transport *transport, char *eth, int n,
 			   void **init_out, char **mac_out)
@@ -563,7 +563,9 @@ static int eth_setup_common(char *str, i
 	struct transport *transport;
 	void *init;
 	char *mac = NULL;
+	int found = 0;
 
+	spin_lock(&transports_lock);
 	list_for_each(ele, &transports){
 		transport = list_entry(ele, struct transport, list);
 	        if(!check_transport(transport, str, index, &init, &mac))
@@ -572,9 +574,12 @@ static int eth_setup_common(char *str, i
 			eth_configure(index, init, mac, transport);
 			kfree(init);
 		}
-		return 1;
+		found = 1;
+		break;
 	}
-	return 0;
+
+	spin_unlock(&transports_lock);
+	return found;
 }
 
 static int eth_setup(char *str)
@@ -610,24 +615,6 @@ __uml_help(eth_setup,
 "    Configure a network device.\n\n"
 );
 
-#if 0
-static int eth_init(void)
-{
-	struct list_head *ele, *next;
-	struct eth_init *eth;
-
-	list_for_each_safe(ele, next, &eth_cmd_line){
-		eth = list_entry(ele, struct eth_init, list);
-
-		if(eth_setup_common(eth->init, eth->index))
-			list_del(&eth->list);
-	}
-
-	return(1);
-}
-__initcall(eth_init);
-#endif
-
 static int net_config(char *str, char **error_out)
 {
 	int n, err;
@@ -729,6 +716,7 @@ static int uml_inetaddr_event(struct not
 	return NOTIFY_DONE;
 }
 
+/* uml_net_init shouldn't be called twice on two CPUs at the same time */
 struct notifier_block uml_inetaddr_notifier = {
 	.notifier_call		= uml_inetaddr_event,
 };
@@ -747,18 +735,21 @@ static int uml_net_init(void)
 	 * didn't get a chance to run for them.  This fakes it so that
 	 * addresses which have already been set up get handled properly.
 	 */
+	spin_lock(&opened_lock);
 	list_for_each(ele, &opened){
 		lp = list_entry(ele, struct uml_net_private, list);
 		ip = lp->dev->ip_ptr;
-		if(ip == NULL) continue;
+		if(ip == NULL)
+			continue;
 		in = ip->ifa_list;
 		while(in != NULL){
 			uml_inetaddr_event(NULL, NETDEV_UP, in);
 			in = in->ifa_next;
 		}
 	}
+	spin_unlock(&opened_lock);
 
-	return(0);
+	return 0;
 }
 
 __initcall(uml_net_init);
@@ -768,13 +759,16 @@ static void close_devices(void)
 	struct list_head *ele;
 	struct uml_net_private *lp;
 
+	spin_lock(&opened_lock);
 	list_for_each(ele, &opened){
 		lp = list_entry(ele, struct uml_net_private, list);
 		free_irq(lp->dev->irq, lp->dev);
 		if((lp->close != NULL) && (lp->fd >= 0))
 			(*lp->close)(lp->fd, &lp->user);
-		if(lp->remove != NULL) (*lp->remove)(&lp->user);
+		if(lp->remove != NULL)
+			(*lp->remove)(&lp->user);
 	}
+	spin_unlock(&opened_lock);
 }
 
 __uml_exitcall(close_devices);
_

Patches currently in -mm which might be from jdike@addtoit.com are

origin.patch
uml-fix-prototypes.patch
dynamic-kernel-command-line-common.patch
dynamic-kernel-command-line-um.patch
