From: akpm@linux-foundation.org
Subject: [merged] ttyh-make-function-static.patch removed from -mm tree
Date: Thu, 21 Jan 2010 13:27:20 -0800
Message-ID: <201001212127.o0LLRKFM030635@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38795 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755322Ab0AUV1f (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 21 Jan 2010 16:27:35 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: randy.dunlap@oracle.com, alan@lxorguk.ukuu.org.uk, mm-commits@vger.kernel.org


The patch titled
     tty.h: make tty_port_get() static inline
has been removed from the -mm tree.  Its filename was
     ttyh-make-function-static.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: tty.h: make tty_port_get() static inline
From: Randy Dunlap <randy.dunlap@oracle.com>

I get a few dozen of these warnings when using
  gcc (GCC) 4.4.1 20090725 (Red Hat 4.4.1-2):

In file included from mmotm-2010-0113-1217/init/do_mounts.c:5:
mmotm-2010-0113-1217/include/linux/tty.h: In function 'tty_port_get':
mmotm-2010-0113-1217/include/linux/tty.h:469: warning: '______f' is static but declared in inline function 'tty_port_get' which is not static

so make the function static inline.

[akpm@linux-foundation.org: may as well convert tty_port_users() also]
Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/tty.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN include/linux/tty.h~ttyh-make-function-static include/linux/tty.h
--- a/include/linux/tty.h~ttyh-make-function-static
+++ a/include/linux/tty.h
@@ -464,7 +464,7 @@ extern int tty_port_alloc_xmit_buf(struc
 extern void tty_port_free_xmit_buf(struct tty_port *port);
 extern void tty_port_put(struct tty_port *port);
 
-extern inline struct tty_port *tty_port_get(struct tty_port *port)
+static inline struct tty_port *tty_port_get(struct tty_port *port)
 {
 	if (port)
 		kref_get(&port->kref);
@@ -486,7 +486,7 @@ extern void tty_port_close(struct tty_po
 				struct tty_struct *tty, struct file *filp);
 extern int tty_port_open(struct tty_port *port,
 				struct tty_struct *tty, struct file *filp);
-extern inline int tty_port_users(struct tty_port *port)
+static inline int tty_port_users(struct tty_port *port)
 {
 	return port->count + port->blocked_open;
 }
_

Patches currently in -mm which might be from randy.dunlap@oracle.com are

origin.patch
linux-next.patch
mfgpt-move-clocksource-menu.patch
xen-add-kconfig-menu.patch
gpio-add-driver-for-max7300-i2c-gpio-extender.patch
cgroups-subsystem-module-unloading-fix.patch
memcg-move-charges-of-anonymous-swap-fix.patch
memcg-improve-performance-in-moving-swap-charge-fix.patch
cgroup-implement-eventfd-based-generic-api-for-notifications-kconfig-fix.patch
reiser4-export-remove_from_page_cache-fix.patch
mutex-subsystem-synchro-test-module-add-missing-header-file.patch

