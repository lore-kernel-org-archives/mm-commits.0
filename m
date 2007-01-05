From: akpm@osdl.org
Subject: + uml-network-driver-locking-and-code-cleanup.patch added to -mm tree
Date: Fri, 05 Jan 2007 12:13:17 -0800
Message-ID: <200701052013.l05KDHNC031069@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:57143 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750723AbXAEUNY (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 5 Jan 2007 15:13:24 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jdike@addtoit.com, blaisorblade@yahoo.it


The patch titled
     uml: network driver locking and code cleanup
has been added to the -mm tree.  Its filename is
     uml-network-driver-locking-and-code-cleanup.patch

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: uml: network driver locking and code cleanup
From: Jeff Dike <jdike@addtoit.com>

Add some missing locking to walks of the transports and opened lists.

Delete some dead code.

Comment the lack of some locking.

Signed-off-by: Jeff Dike <jdike@addtoit.com>
Cc: Paolo 'Blaisorblade' Giarrusso <blaisorblade@yahoo.it>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 arch/um/drivers/net_kern.c |   42 +++++++++++++++--------------------
 1 files changed, 18 insertions(+), 24 deletions(-)

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

x86_64-i386-kernel-mode-faults-pollute-current-thead.patch
uml-console-locking-fixes.patch
uml-return-hotplug-errors-to-host.patch
uml-console-whitespace-and-comment-tidying.patch
uml-lock-the-irqs_to_free-list.patch
uml-add-locking-to-network-transport-registration.patch
uml-network-driver-whitespace-and-style-fixes.patch
uml-watchdog-driver-locking.patch
uml-watchdog-driver-formatting.patch
uml-audio-driver-locking.patch
uml-audio-driver-formatting.patch
uml-mconsole-locking.patch
uml-make-two-variables-static.patch
uml-port-driver-formatting.patch
uml-kill-a-compilation-warning.patch
uml-network-driver-locking-and-code-cleanup.patch
uml-use-list_head-where-possible.patch
uml-locking-commentary-in-the-random-driver.patch
uml-mostly-const-a-structure.patch
uml-chan_userh-formatting-fices.patch
uml-console-locking-commentary-and-code-cleanup.patch
uml-fix-previous-console-locking.patch
uml-locking-comments-in-iomem-driver.patch
uml-memc-and-physmemc-formatting-fixes.patch
uml-fix-prototypes.patch
rewrite-unnecessary-duplicated-code-to-use-field_sizeof.patch
