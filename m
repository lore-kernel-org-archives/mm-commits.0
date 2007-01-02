From: akpm@osdl.org
Subject: + uml-add-locking-to-network-transport-registration.patch added to -mm tree
Date: Tue, 02 Jan 2007 13:32:04 -0800
Message-ID: <200701022132.l02LW5pO030398@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:34309 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754984AbXABVfT (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Tue, 2 Jan 2007 16:35:19 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jdike@addtoit.com, blaisorblade@yahoo.it


The patch titled
     uml: add locking to network transport registration
has been added to the -mm tree.  Its filename is
     uml-add-locking-to-network-transport-registration.patch

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: uml: add locking to network transport registration
From: Jeff Dike <jdike@addtoit.com>

The registration of host network transports needed some locking.  The
transport list itself is locked, but calls to the registration routines are
not.  This is compensated for by checking that a transport structure is not
yet on any list.

I also took the opportunity to const all fields in the transport structure
except the list, which obviously can be modified.

Signed-off-by: Jeff Dike <jdike@addtoit.com>
Cc: Paolo 'Blaisorblade' Giarrusso <blaisorblade@yahoo.it>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 arch/um/drivers/net_kern.c |    9 +++++----
 arch/um/include/net_kern.h |    8 ++++----
 2 files changed, 9 insertions(+), 8 deletions(-)

diff -puN arch/um/drivers/net_kern.c~uml-add-locking-to-network-transport-registration arch/um/drivers/net_kern.c
--- a/arch/um/drivers/net_kern.c~uml-add-locking-to-network-transport-registration
+++ a/arch/um/drivers/net_kern.c
@@ -498,10 +498,8 @@ struct eth_init {
 	int index;
 };
 
-/* Filled in at boot time.  Will need locking if the transports become
- * modular.
- */
-struct list_head transports = LIST_HEAD_INIT(transports);
+static DEFINE_SPINLOCK(transports_lock);
+static LIST_HEAD(transports);
 
 /* Filled in during early boot */
 struct list_head eth_cmd_line = LIST_HEAD_INIT(eth_cmd_line);
@@ -540,7 +538,10 @@ void register_transport(struct transport
 	char *mac = NULL;
 	int match;
 
+	spin_lock(&transports_lock);
+	BUG_ON(!list_empty(&new->list));
 	list_add(&new->list, &transports);
+	spin_unlock(&transports_lock);
 
 	list_for_each_safe(ele, next, &eth_cmd_line){
 		eth = list_entry(ele, struct eth_init, list);
diff -puN arch/um/include/net_kern.h~uml-add-locking-to-network-transport-registration arch/um/include/net_kern.h
--- a/arch/um/include/net_kern.h~uml-add-locking-to-network-transport-registration
+++ a/arch/um/include/net_kern.h
@@ -52,12 +52,12 @@ struct net_kern_info {
 
 struct transport {
 	struct list_head list;
-	char *name;
-	int (*setup)(char *, char **, void *);
+	const char *name;
+	int (* const setup)(char *, char **, void *);
 	const struct net_user_info *user;
 	const struct net_kern_info *kern;
-	int private_size;
-	int setup_size;
+	const int private_size;
+	const int setup_size;
 };
 
 extern struct net_device *ether_init(int);
_

Patches currently in -mm which might be from jdike@addtoit.com are

x86_64-i386-kernel-mode-faults-pollute-current-thead.patch
uml-console-locking-fixes.patch
uml-return-hotplug-errors-to-host.patch
uml-console-whitespace-and-comment-tidying.patch
uml-lock-the-irqs_to_free-list.patch
uml-add-locking-to-network-transport-registration.patch
uml-network-driver-whitespace-and-style-fixes.patch
uml-fix-prototypes.patch
rewrite-unnecessary-duplicated-code-to-use-field_sizeof.patch
