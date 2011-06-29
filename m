From: akpm@linux-foundation.org
Subject: + notifiers-pm-move-pm-notifiers-into-suspendh.patch added to -mm tree
Date: Wed, 29 Jun 2011 15:23:24 -0700
Message-ID: <201106292223.p5TMNOiA015829@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37087 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752595Ab1F2WXs (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 29 Jun 2011 18:23:48 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: amwang@redhat.com, davem@davemloft.net, greg@kroah.com, rjw@sisk.pl


The patch titled
     notifiers: pm: move pm notifiers into suspend.h
has been added to the -mm tree.  Its filename is
     notifiers-pm-move-pm-notifiers-into-suspendh.patch

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
Subject: notifiers: pm: move pm notifiers into suspend.h
From: Amerigo Wang <amwang@redhat.com>

It is not necessary to share the same notifier.h.

Signed-off-by: WANG Cong <amwang@redhat.com>
Cc: David Miller <davem@davemloft.net>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/mmc/core/core.c  |    3 +++
 include/linux/notifier.h |   10 ++--------
 include/linux/suspend.h  |    8 ++++++++
 3 files changed, 13 insertions(+), 8 deletions(-)

diff -puN drivers/mmc/core/core.c~notifiers-pm-move-pm-notifiers-into-suspendh drivers/mmc/core/core.c
--- a/drivers/mmc/core/core.c~notifiers-pm-move-pm-notifiers-into-suspendh
+++ a/drivers/mmc/core/core.c
@@ -23,6 +23,9 @@
 #include <linux/log2.h>
 #include <linux/regulator/consumer.h>
 #include <linux/pm_runtime.h>
+#ifdef CONFIG_PM
+#include <linux/suspend.h>
+#endif
 
 #include <linux/mmc/card.h>
 #include <linux/mmc/host.h>
diff -puN include/linux/notifier.h~notifiers-pm-move-pm-notifiers-into-suspendh include/linux/notifier.h
--- a/include/linux/notifier.h~notifiers-pm-move-pm-notifiers-into-suspendh
+++ a/include/linux/notifier.h
@@ -191,15 +191,9 @@ static inline int notifier_to_errno(int 
 
 /* reboot notifiers are defined in include/linux/reboot.h. */
 
-#define NETLINK_URELEASE	0x0001	/* Unicast netlink socket released */
+/* Hibernation and suspend events are defined in include/linux/suspend.h. */
 
-/* Hibernation and suspend events */
-#define PM_HIBERNATION_PREPARE	0x0001 /* Going to hibernate */
-#define PM_POST_HIBERNATION	0x0002 /* Hibernation finished */
-#define PM_SUSPEND_PREPARE	0x0003 /* Going to suspend the system */
-#define PM_POST_SUSPEND		0x0004 /* Suspend finished */
-#define PM_RESTORE_PREPARE	0x0005 /* Going to restore a saved image */
-#define PM_POST_RESTORE		0x0006 /* Restore failed */
+#define NETLINK_URELEASE	0x0001	/* Unicast netlink socket released */
 
 /* Console keyboard events.
  * Note: KBD_KEYCODE is always sent before KBD_UNBOUND_KEYCODE, KBD_UNICODE and
diff -puN include/linux/suspend.h~notifiers-pm-move-pm-notifiers-into-suspendh include/linux/suspend.h
--- a/include/linux/suspend.h~notifiers-pm-move-pm-notifiers-into-suspendh
+++ a/include/linux/suspend.h
@@ -268,6 +268,14 @@ static inline int hibernate(void) { retu
 static inline bool system_entering_hibernation(void) { return false; }
 #endif /* CONFIG_HIBERNATION */
 
+/* Hibernation and suspend events */
+#define PM_HIBERNATION_PREPARE	0x0001 /* Going to hibernate */
+#define PM_POST_HIBERNATION	0x0002 /* Hibernation finished */
+#define PM_SUSPEND_PREPARE	0x0003 /* Going to suspend the system */
+#define PM_POST_SUSPEND		0x0004 /* Suspend finished */
+#define PM_RESTORE_PREPARE	0x0005 /* Going to restore a saved image */
+#define PM_POST_RESTORE		0x0006 /* Restore failed */
+
 #ifdef CONFIG_PM_SLEEP
 void save_processor_state(void);
 void restore_processor_state(void);
_

Patches currently in -mm which might be from amwang@redhat.com are

linux-next.patch
notifiers-cpu-move-cpu-notifiers-into-cpuh.patch
notifiers-net-move-netdevice-notifiers-into-netdeviceh.patch
notifiers-sys-move-reboot-notifiers-into-rebooth.patch
notifiers-pm-move-pm-notifiers-into-suspendh.patch
notifiers-vt-move-vt-notifiers-into-vth.patch

