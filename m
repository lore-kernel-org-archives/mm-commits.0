From: akpm@linux-foundation.org
Subject: - uml-fix-build-for-config_tcp.patch removed from -mm tree
Date: Thu, 15 Nov 2007 13:11:02 -0800
Message-ID: <200711152111.lAFLB2qj015724@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:54612 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761236AbXKOVRJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 15 Nov 2007 16:17:09 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jdike@addtoit.com, jdike@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     uml: fix build for !CONFIG_TCP
has been removed from the -mm tree.  Its filename was
     uml-fix-build-for-config_tcp.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: uml: fix build for !CONFIG_TCP
From: Jeff Dike <jdike@addtoit.com>

Make UML build in the absence of CONFIG_INET by making the inetaddr_notifier
registration depend on it.

Signed-off-by: Jeff Dike <jdike@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/um/drivers/net_kern.c |   14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

diff -puN arch/um/drivers/net_kern.c~uml-fix-build-for-config_tcp arch/um/drivers/net_kern.c
--- a/arch/um/drivers/net_kern.c~uml-fix-build-for-config_tcp
+++ a/arch/um/drivers/net_kern.c
@@ -753,6 +753,7 @@ static struct mc_device net_mc = {
 	.remove		= net_remove,
 };
 
+#ifdef CONFIG_INET
 static int uml_inetaddr_event(struct notifier_block *this, unsigned long event,
 			      void *ptr)
 {
@@ -789,14 +790,13 @@ struct notifier_block uml_inetaddr_notif
 	.notifier_call		= uml_inetaddr_event,
 };
 
-static int uml_net_init(void)
+static void inet_register(void)
 {
 	struct list_head *ele;
 	struct uml_net_private *lp;
 	struct in_device *ip;
 	struct in_ifaddr *in;
 
-	mconsole_register_dev(&net_mc);
 	register_inetaddr_notifier(&uml_inetaddr_notifier);
 
 	/* Devices may have been opened already, so the uml_inetaddr_notifier
@@ -816,7 +816,17 @@ static int uml_net_init(void)
 		}
 	}
 	spin_unlock(&opened_lock);
+}
+#else
+static inline void inet_register(void)
+{
+}
+#endif
 
+static int uml_net_init(void)
+{
+	mconsole_register_dev(&net_mc);
+	inet_register();
 	return 0;
 }
 
_

Patches currently in -mm which might be from jdike@addtoit.com are

origin.patch
git-kvm.patch
uml-implement-get_wchan.patch
uml-implement-get_wchan-fix.patch
uml-get-rid-of-asmlinkage.patch
uml-get-rid-of-asmlinkage-checkpatch-fixes.patch
uml-document-new-ubd-flag.patch
uml-further-bugsc-tidying.patch
uml-further-bugsc-tidying-checkpatch-fixes.patch
uml-smp-needs-to-depend-on-broken-for-now.patch
uml-console-driver-cleanups.patch
uml-clonec-tidying.patch
uml-borrow-consth-techniques.patch
uml-delete-some-unused-headers.patch
uml-allow-lflags-on-command-line.patch
uml-tidy-kern_utilh.patch
uml-tidy-pgtableh.patch
uml-reconst-a-parameter.patch
arch-um-remove-duplicate-includes.patch
iget-stop-hostfs-from-using-iget-and-read_inode.patch
iget-stop-hostfs-from-using-iget-and-read_inode-checkpatch-fixes.patch
