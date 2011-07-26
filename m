From: akpm@linux-foundation.org
Subject: [merged] notifiers-vt-move-vt-notifiers-into-vth.patch removed from -mm tree
Date: Tue, 26 Jul 2011 00:55:32 -0700
Message-ID: <201107260754.p6Q7sZhG003367@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46951 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751246Ab1GZIDK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 26 Jul 2011 04:03:10 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: amwang@redhat.com, davem@davemloft.net, greg@kroah.com, rjw@sisk.pl, mm-commits@vger.kernel.org


The patch titled
     notifiers: vt: move vt notifiers into vt.h
has been removed from the -mm tree.  Its filename was
     notifiers-vt-move-vt-notifiers-into-vth.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: notifiers: vt: move vt notifiers into vt.h
From: Amerigo Wang <amwang@redhat.com>

It is not necessary to share the same notifier.h.

Signed-off-by: WANG Cong <amwang@redhat.com>
Cc: David Miller <davem@davemloft.net>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/notifier.h |    9 ++-------
 include/linux/vt.h       |    7 +++++++
 2 files changed, 9 insertions(+), 7 deletions(-)

diff -puN include/linux/notifier.h~notifiers-vt-move-vt-notifiers-into-vth include/linux/notifier.h
--- a/include/linux/notifier.h~notifiers-vt-move-vt-notifiers-into-vth
+++ a/include/linux/notifier.h
@@ -193,6 +193,8 @@ static inline int notifier_to_errno(int 
 
 /* Hibernation and suspend events are defined in include/linux/suspend.h. */
 
+/* Virtual Terminal events are defined in include/linux/vt.h. */
+
 #define NETLINK_URELEASE	0x0001	/* Unicast netlink socket released */
 
 /* Console keyboard events.
@@ -206,12 +208,5 @@ static inline int notifier_to_errno(int 
 
 extern struct blocking_notifier_head reboot_notifier_list;
 
-/* Virtual Terminal events. */
-#define VT_ALLOCATE		0x0001 /* Console got allocated */
-#define VT_DEALLOCATE		0x0002 /* Console will be deallocated */
-#define VT_WRITE		0x0003 /* A char got output */
-#define VT_UPDATE		0x0004 /* A bigger update occurred */
-#define VT_PREWRITE		0x0005 /* A char is about to be written to the console */
-
 #endif /* __KERNEL__ */
 #endif /* _LINUX_NOTIFIER_H */
diff -puN include/linux/vt.h~notifiers-vt-move-vt-notifiers-into-vth include/linux/vt.h
--- a/include/linux/vt.h~notifiers-vt-move-vt-notifiers-into-vth
+++ a/include/linux/vt.h
@@ -86,6 +86,13 @@ struct vt_setactivate {
 
 #ifdef __KERNEL__
 
+/* Virtual Terminal events. */
+#define VT_ALLOCATE		0x0001 /* Console got allocated */
+#define VT_DEALLOCATE		0x0002 /* Console will be deallocated */
+#define VT_WRITE		0x0003 /* A char got output */
+#define VT_UPDATE		0x0004 /* A bigger update occurred */
+#define VT_PREWRITE		0x0005 /* A char is about to be written to the console */
+
 #ifdef CONFIG_VT_CONSOLE
 
 extern int vt_kmsg_redirect(int new);
_

Patches currently in -mm which might be from amwang@redhat.com are

origin.patch
linux-next.patch

