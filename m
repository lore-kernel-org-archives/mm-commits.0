From: akpm@linux-foundation.org
Subject: + notifiers-vt-move-vt-notifiers-into-vth.patch added to -mm tree
Date: Wed, 29 Jun 2011 15:23:26 -0700
Message-ID: <201106292223.p5TMNQ8M015832@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33371 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753125Ab1F2WXv (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 29 Jun 2011 18:23:51 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: amwang@redhat.com, davem@davemloft.net, greg@kroah.com, rjw@sisk.pl


The patch titled
     notifiers: vt: move vt notifiers into vt.h
has been added to the -mm tree.  Its filename is
     notifiers-vt-move-vt-notifiers-into-vth.patch

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

linux-next.patch
notifiers-cpu-move-cpu-notifiers-into-cpuh.patch
notifiers-net-move-netdevice-notifiers-into-netdeviceh.patch
notifiers-sys-move-reboot-notifiers-into-rebooth.patch
notifiers-pm-move-pm-notifiers-into-suspendh.patch
notifiers-vt-move-vt-notifiers-into-vth.patch

