From: akpm@linux-foundation.org
Subject: + notifiers-sys-move-reboot-notifiers-into-rebooth.patch added to -mm tree
Date: Wed, 29 Jun 2011 15:23:22 -0700
Message-ID: <201106292223.p5TMNMFB015823@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47230 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753125Ab1F2WXt (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 29 Jun 2011 18:23:49 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: amwang@redhat.com, davem@davemloft.net, greg@kroah.com, rjw@sisk.pl


The patch titled
     notifiers: sys: move reboot notifiers into reboot.h
has been added to the -mm tree.  Its filename is
     notifiers-sys-move-reboot-notifiers-into-rebooth.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: notifiers: sys: move reboot notifiers into reboot.h
From: Amerigo Wang <amwang@redhat.com>

It is not necessary to share the same notifier.h.
This patch already moves register_reboot_notifier()
and unregister_reboot_notifier() from kernel/notifier.c to
kernel/sys.c.

Signed-off-by: WANG Cong <amwang@redhat.com>
Cc: David Miller <davem@davemloft.net>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/notifier.h |    5 +----
 include/linux/reboot.h   |    5 +++++
 kernel/notifier.c        |   31 -------------------------------
 kernel/sys.c             |   32 +++++++++++++++++++++++++++++++-
 4 files changed, 37 insertions(+), 36 deletions(-)

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

linux-next.patch
notifiers-cpu-move-cpu-notifiers-into-cpuh.patch
notifiers-net-move-netdevice-notifiers-into-netdeviceh.patch
notifiers-sys-move-reboot-notifiers-into-rebooth.patch
notifiers-pm-move-pm-notifiers-into-suspendh.patch
notifiers-vt-move-vt-notifiers-into-vth.patch

