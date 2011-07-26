From: akpm@linux-foundation.org
Subject: [merged] notifiers-sys-move-reboot-notifiers-into-rebooth.patch removed from -mm tree
Date: Tue, 26 Jul 2011 00:55:27 -0700
Message-ID: <201107260754.p6Q7sUiU003358@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51650 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753186Ab1GZHzh (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 26 Jul 2011 03:55:37 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: amwang@redhat.com, davem@davemloft.net, greg@kroah.com, rjw@sisk.pl, mm-commits@vger.kernel.org


The patch titled
     notifiers: sys: move reboot notifiers into reboot.h
has been removed from the -mm tree.  Its filename was
     notifiers-sys-move-reboot-notifiers-into-rebooth.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: notifiers: sys: move reboot notifiers into reboot.h
From: Amerigo Wang <amwang@redhat.com>

It is not necessary to share the same notifier.h.
This patch already moves register_reboot_notifier()
and unregister_reboot_notifier() from kernel/notifier.c to
kernel/sys.c.

[amwang@redhat.com: make allyesconfig succeed on ppc64]
Signed-off-by: WANG Cong <amwang@redhat.com>
Cc: David Miller <davem@davemloft.net>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: WANG Cong <amwang@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/kernel/rtas.c       |    1 
 arch/powerpc/kernel/rtas_flash.c |    1 
 include/linux/notifier.h         |    5 ----
 include/linux/reboot.h           |    5 ++++
 kernel/notifier.c                |   31 ----------------------------
 kernel/sys.c                     |   32 ++++++++++++++++++++++++++++-
 6 files changed, 39 insertions(+), 36 deletions(-)

diff -puN arch/powerpc/kernel/rtas.c~notifiers-sys-move-reboot-notifiers-into-rebooth arch/powerpc/kernel/rtas.c
--- a/arch/powerpc/kernel/rtas.c~notifiers-sys-move-reboot-notifiers-into-rebooth
+++ a/arch/powerpc/kernel/rtas.c
@@ -24,6 +24,7 @@
 #include <linux/cpumask.h>
 #include <linux/memblock.h>
 #include <linux/slab.h>
+#include <linux/reboot.h>
 
 #include <asm/prom.h>
 #include <asm/rtas.h>
diff -puN arch/powerpc/kernel/rtas_flash.c~notifiers-sys-move-reboot-notifiers-into-rebooth arch/powerpc/kernel/rtas_flash.c
--- a/arch/powerpc/kernel/rtas_flash.c~notifiers-sys-move-reboot-notifiers-into-rebooth
+++ a/arch/powerpc/kernel/rtas_flash.c
@@ -17,6 +17,7 @@
 #include <linux/init.h>
 #include <linux/slab.h>
 #include <linux/proc_fs.h>
+#include <linux/reboot.h>
 #include <asm/delay.h>
 #include <asm/uaccess.h>
 #include <asm/rtas.h>
diff -puN include/linux/notifier.h~notifiers-sys-move-reboot-notifiers-into-rebooth include/linux/notifier.h
--- a/include/linux/notifier.h~notifiers-sys-move-reboot-notifiers-into-rebooth
+++ a/include/linux/notifier.h
@@ -189,10 +189,7 @@ static inline int notifier_to_errno(int 
 
 /* netdevice notifiers are defined in include/linux/netdevice.h */
 
-#define SYS_DOWN	0x0001	/* Notify of system down */
-#define SYS_RESTART	SYS_DOWN
-#define SYS_HALT	0x0002	/* Notify of system halt */
-#define SYS_POWER_OFF	0x0003	/* Notify of system power off */
+/* reboot notifiers are defined in include/linux/reboot.h. */
 
 #define NETLINK_URELEASE	0x0001	/* Unicast netlink socket released */
 
diff -puN include/linux/reboot.h~notifiers-sys-move-reboot-notifiers-into-rebooth include/linux/reboot.h
--- a/include/linux/reboot.h~notifiers-sys-move-reboot-notifiers-into-rebooth
+++ a/include/linux/reboot.h
@@ -39,6 +39,11 @@
 
 #include <linux/notifier.h>
 
+#define SYS_DOWN	0x0001	/* Notify of system down */
+#define SYS_RESTART	SYS_DOWN
+#define SYS_HALT	0x0002	/* Notify of system halt */
+#define SYS_POWER_OFF	0x0003	/* Notify of system power off */
+
 extern int register_reboot_notifier(struct notifier_block *);
 extern int unregister_reboot_notifier(struct notifier_block *);
 
diff -puN kernel/notifier.c~notifiers-sys-move-reboot-notifiers-into-rebooth kernel/notifier.c
--- a/kernel/notifier.c~notifiers-sys-move-reboot-notifiers-into-rebooth
+++ a/kernel/notifier.c
@@ -525,37 +525,6 @@ void srcu_init_notifier_head(struct srcu
 }
 EXPORT_SYMBOL_GPL(srcu_init_notifier_head);
 
-/**
- *	register_reboot_notifier - Register function to be called at reboot time
- *	@nb: Info about notifier function to be called
- *
- *	Registers a function with the list of functions
- *	to be called at reboot time.
- *
- *	Currently always returns zero, as blocking_notifier_chain_register()
- *	always returns zero.
- */
-int register_reboot_notifier(struct notifier_block *nb)
-{
-	return blocking_notifier_chain_register(&reboot_notifier_list, nb);
-}
-EXPORT_SYMBOL(register_reboot_notifier);
-
-/**
- *	unregister_reboot_notifier - Unregister previously registered reboot notifier
- *	@nb: Hook to be unregistered
- *
- *	Unregisters a previously registered reboot
- *	notifier function.
- *
- *	Returns zero on success, or %-ENOENT on failure.
- */
-int unregister_reboot_notifier(struct notifier_block *nb)
-{
-	return blocking_notifier_chain_unregister(&reboot_notifier_list, nb);
-}
-EXPORT_SYMBOL(unregister_reboot_notifier);
-
 static ATOMIC_NOTIFIER_HEAD(die_chain);
 
 int notrace __kprobes notify_die(enum die_val val, const char *str,
diff -puN kernel/sys.c~notifiers-sys-move-reboot-notifiers-into-rebooth kernel/sys.c
--- a/kernel/sys.c~notifiers-sys-move-reboot-notifiers-into-rebooth
+++ a/kernel/sys.c
@@ -8,7 +8,6 @@
 #include <linux/mm.h>
 #include <linux/utsname.h>
 #include <linux/mman.h>
-#include <linux/notifier.h>
 #include <linux/reboot.h>
 #include <linux/prctl.h>
 #include <linux/highuid.h>
@@ -320,6 +319,37 @@ void kernel_restart_prepare(char *cmd)
 }
 
 /**
+ *	register_reboot_notifier - Register function to be called at reboot time
+ *	@nb: Info about notifier function to be called
+ *
+ *	Registers a function with the list of functions
+ *	to be called at reboot time.
+ *
+ *	Currently always returns zero, as blocking_notifier_chain_register()
+ *	always returns zero.
+ */
+int register_reboot_notifier(struct notifier_block *nb)
+{
+	return blocking_notifier_chain_register(&reboot_notifier_list, nb);
+}
+EXPORT_SYMBOL(register_reboot_notifier);
+
+/**
+ *	unregister_reboot_notifier - Unregister previously registered reboot notifier
+ *	@nb: Hook to be unregistered
+ *
+ *	Unregisters a previously registered reboot
+ *	notifier function.
+ *
+ *	Returns zero on success, or %-ENOENT on failure.
+ */
+int unregister_reboot_notifier(struct notifier_block *nb)
+{
+	return blocking_notifier_chain_unregister(&reboot_notifier_list, nb);
+}
+EXPORT_SYMBOL(unregister_reboot_notifier);
+
+/**
  *	kernel_restart - reboot the system
  *	@cmd: pointer to buffer containing command to execute for restart
  *		or %NULL
_

Patches currently in -mm which might be from amwang@redhat.com are

origin.patch
linux-next.patch

