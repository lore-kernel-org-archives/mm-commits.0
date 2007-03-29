From: akpm@linux-foundation.org
Subject: + uml-replace-one-element-array-with-zero-element-array.patch added to -mm tree
Date: Wed, 28 Mar 2007 17:09:23 -0700
Message-ID: <200703290009.l2T09NTt023440@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:36331 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965883AbXC2AJ1 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 28 Mar 2007 20:09:27 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: blaisorblade@yahoo.it, jdike@linux.intel.com


The patch titled
     uml: Replace one-element array with zero-element array
has been added to the -mm tree.  Its filename is
     uml-replace-one-element-array-with-zero-element-array.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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

uml-fix-static-linking.patch
uml-use-correct-register-file-size-everywhere.patch
uml-fix-i-o-hang-when-multiple-devices-are-in-use.patch
uml-fix-device-unplug-crash.patch
uml-fix-pte-bit-collision.patch
uml-irq-locking-fixes.patch
uml-fix-lvm-crash.patch
uml-fix-compilation-problems.patch
uml-hostfs-variable-renaming.patch
uml-delete-unused-code.patch
uml-formatting-fixes.patch
uml-host_info-tidying.patch
uml-mark-tt-mode-code-for-future-removal.patch
uml-print-coredump-limits.patch
uml-handle-block-device-hotplug-errors.patch
uml-driver-formatting-fixes.patch
uml-driver-formatting-fixes-fix.patch
uml-network-interface-hotplug-error-handling.patch
uml-fix-prototypes.patch
uml-move-sigio-testing-to-sigioc.patch
uml-create-archh.patch
uml-create-as-layouth.patch
uml-move-remaining-useful-contents-of-user_utilh.patch
uml-remove-user_utilh.patch
uml-add-missing-__init-declarations.patch
remove-unused-header-file-arch-um-kernel-tt-include-mode_kern-tth.patch
uml-improve-checking-and-diagnostics-of-ethernet-macs.patch
uml-eliminate-temporary-buffer-in-eth_configure.patch
uml-replace-one-element-array-with-zero-element-array.patch
fix-utrace-utrace-tracehook-um.patch
git-gccbug.patch
