From: akpm@linux-foundation.org
Subject: [merged] dynamic_debug-fix-undefined-reference-to-__netdev_printk.patch removed from -mm tree
Date: Thu, 27 Oct 2011 16:08:54 -0700
Message-ID: <201110272308.p9RN8sJK017056@wpaz37.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp-out.google.com ([74.125.121.67]:48923 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753789Ab1J0XJF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 27 Oct 2011 19:09:05 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jbaron@redhat.com, arnd@arndb.de, greg@kroah.com, rdunlap@xenotime.net, mm-commits@vger.kernel.org


The patch titled
     Subject: dynamic_debug: fix undefined reference to `__netdev_printk'
has been removed from the -mm tree.  Its filename was
     dynamic_debug-fix-undefined-reference-to-__netdev_printk.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Jason Baron <jbaron@redhat.com>
Subject: dynamic_debug: fix undefined reference to `__netdev_printk'

Dynamic debug recently added support for netdev_printk.  It uses
__netdev_printk() to support this functionality.  However, when CONFIG_NET
is not set, we get the following error:

lib/built-in.o: In function `__dynamic_netdev_dbg':
(.text+0x9fda): undefined reference to `__netdev_printk'

Fix this by making the call to netdev_printk() contingent upon CONFIG_NET.
 We could have fixed this by defining netdev_printk() to a 'no-op' in the
!CONFIG_NET case.  However, this is not consistent with how the networking
layer uses netdev_printk.  For example, CONFIG_NET is not set,
netdev_printk() does not have a 'no-op' definition defined.

Signed-off-by: Jason Baron <jbaron@redhat.com>
Acked-by: Randy Dunlap <rdunlap@xenotime.net>
Cc: Greg KH <greg@kroah.com>
Acked-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/dynamic_debug.c |    4 ++++
 1 file changed, 4 insertions(+)

diff -puN lib/dynamic_debug.c~dynamic_debug-fix-undefined-reference-to-__netdev_printk lib/dynamic_debug.c
--- a/lib/dynamic_debug.c~dynamic_debug-fix-undefined-reference-to-__netdev_printk
+++ a/lib/dynamic_debug.c
@@ -502,6 +502,8 @@ int __dynamic_dev_dbg(struct _ddebug *de
 }
 EXPORT_SYMBOL(__dynamic_dev_dbg);
 
+#ifdef CONFIG_NET
+
 int __dynamic_netdev_dbg(struct _ddebug *descriptor,
 		      const struct net_device *dev, const char *fmt, ...)
 {
@@ -523,6 +525,8 @@ int __dynamic_netdev_dbg(struct _ddebug 
 }
 EXPORT_SYMBOL(__dynamic_netdev_dbg);
 
+#endif
+
 static __initdata char ddebug_setup_string[1024];
 static __init int ddebug_setup_query(char *str)
 {
_

Patches currently in -mm which might be from jbaron@redhat.com are

origin.patch
linux-next.patch
drivers-net-ethernet-i825xx-3c505c-fix-build-with-dynamic-debug.patch
epoll-fix-spurious-lockdep-warnings.patch
epoll-limit-paths.patch

