From: akpm@linux-foundation.org
Subject: + uml-fix-build-for-config_tcp.patch added to -mm tree
Date: Wed, 31 Oct 2007 13:36:38 -0700
Message-ID: <200710312036.l9VKacBo026975@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:37559 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754290AbXJaUhM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 31 Oct 2007 16:37:12 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jdike@addtoit.com, jdike@linux.intel.com


The patch titled
     uml: fix build for !CONFIG_TCP
has been added to the -mm tree.  Its filename is
     uml-fix-build-for-config_tcp.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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

git-kvm.patch
arch-um-drivers-ubd_kernc-a-warning-fix.patch
uml-fix-spurious-irq-testing.patch
uml-remove-last-include-of-libc-asm-pageh.patch
uml-fix-build-for-config_tcp.patch
uml-fix-build-for-config_printk.patch
uml-implement-get_wchan.patch
uml-get-rid-of-asmlinkage.patch
uml-get-rid-of-asmlinkage-checkpatch-fixes.patch
iget-stop-hostfs-from-using-iget-and-read_inode.patch
iget-stop-hostfs-from-using-iget-and-read_inode-checkpatch-fixes.patch
