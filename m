From: akpm@linux-foundation.org
Subject: - uml-replace-one-element-array-with-zero-element-array.patch removed from -mm tree
Date: Mon, 07 May 2007 17:06:33 -0700
Message-ID: <200705080006.l4806XG5009200@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:56248 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S967387AbXEHAGv (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 7 May 2007 20:06:51 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: blaisorblade@yahoo.it, jdike@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     uml: Replace one-element array with zero-element array
has been removed from the -mm tree.  Its filename was
     uml-replace-one-element-array-with-zero-element-array.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: uml: Replace one-element array with zero-element array
From: Paolo 'Blaisorblade' Giarrusso <blaisorblade@yahoo.it>

To look at users I did:
$ find arch/um/ include/asm-um -name '*.[ch]'|xargs grep -r 'net_kern\.h'
+-l|xargs grep '\<user\>'

Most users just cast user to the appropriate pointer, the remaining ones are
fixed here.  In net_kern.c, I'm almost sure that save trick is not needed
anymore, but I've not verified it.

Signed-off-by: Paolo 'Blaisorblade' Giarrusso <blaisorblade@yahoo.it>
Signed-off-by: Jeff Dike <jdike@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/um/drivers/net_kern.c |   14 +++-----------
 arch/um/include/net_kern.h |    2 +-
 2 files changed, 4 insertions(+), 12 deletions(-)

diff -puN arch/um/drivers/net_kern.c~uml-replace-one-element-array-with-zero-element-array arch/um/drivers/net_kern.c
--- a/arch/um/drivers/net_kern.c~uml-replace-one-element-array-with-zero-element-array
+++ a/arch/um/drivers/net_kern.c
@@ -347,10 +347,9 @@ static void eth_configure(int n, void *i
 	struct uml_net *device;
 	struct net_device *dev;
 	struct uml_net_private *lp;
-	int save, err, size;
+	int err, size;
 
-	size = transport->private_size + sizeof(struct uml_net_private) +
-		sizeof(((struct uml_net_private *) 0)->user);
+	size = transport->private_size + sizeof(struct uml_net_private);
 
 	device = kzalloc(sizeof(*device), GFP_KERNEL);
 	if (device == NULL) {
@@ -409,12 +408,6 @@ static void eth_configure(int n, void *i
 	 */
 	(*transport->kern->init)(dev, init);
 
-	/* lp.user is the first four bytes of the transport data, which
-	 * has already been initialized.  This structure assignment will
-	 * overwrite that, so we make sure that .user gets overwritten with
-	 * what it already has.
-	 */
-	save = lp->user[0];
 	*lp = ((struct uml_net_private)
 		{ .list  		= LIST_HEAD_INIT(lp->list),
 		  .dev 			= dev,
@@ -428,8 +421,7 @@ static void eth_configure(int n, void *i
 		  .write 		= transport->kern->write,
 		  .add_address 		= transport->user->add_address,
 		  .delete_address  	= transport->user->delete_address,
-		  .set_mtu 		= transport->user->set_mtu,
-		  .user  		= { save } });
+		  .set_mtu 		= transport->user->set_mtu });
 
 	init_timer(&lp->tl);
 	spin_lock_init(&lp->lock);
diff -puN arch/um/include/net_kern.h~uml-replace-one-element-array-with-zero-element-array arch/um/include/net_kern.h
--- a/arch/um/include/net_kern.h~uml-replace-one-element-array-with-zero-element-array
+++ a/arch/um/include/net_kern.h
@@ -40,7 +40,7 @@ struct uml_net_private {
 	void (*add_address)(unsigned char *, unsigned char *, void *);
 	void (*delete_address)(unsigned char *, unsigned char *, void *);
 	int (*set_mtu)(int mtu, void *);
-	int user[1];
+	char user[0];
 };
 
 struct net_kern_info {
_

Patches currently in -mm which might be from blaisorblade@yahoo.it are

origin.patch
uml-make-hostfs_setattr-support-operations-on-unlinked-open-files.patch
uml-hostfs-style-fixes.patch
uml-an-idle-system-should-have-zero-load-average.patch
remove-tas.patch
x86-create-asm-cmpxchgh.patch
uml-network-and-pcap-cleanup.patch
uml-pcap-devices-should-get-macs-from-command-line.patch
