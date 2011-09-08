From: akpm@linux-foundation.org
Subject: + dynamic_debug-fix-undefined-reference-to-__netdev_printk.patch added to -mm tree
Date: Thu, 08 Sep 2011 16:56:27 -0700
Message-ID: <201109082356.p88NuRFR016110@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38991 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756301Ab1IHX4k (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 8 Sep 2011 19:56:40 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jbaron@redhat.com, arnd@arndb.de, greg@kroah.com, rdunlap@xenotime.net


The patch titled
     dynamic_debug: fix undefined reference to `__netdev_printk'
has been added to the -mm tree.  Its filename is
     dynamic_debug-fix-undefined-reference-to-__netdev_printk.patch

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
Subject: dynamic_debug: fix undefined reference to `__netdev_printk'
From: Jason Baron <jbaron@redhat.com>

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
@@ -503,6 +503,8 @@ int __dynamic_dev_dbg(struct _ddebug *de
 }
 EXPORT_SYMBOL(__dynamic_dev_dbg);
 
+#ifdef CONFIG_NET
+
 int __dynamic_netdev_dbg(struct _ddebug *descriptor,
 		      const struct net_device *dev, const char *fmt, ...)
 {
@@ -524,6 +526,8 @@ int __dynamic_netdev_dbg(struct _ddebug 
 }
 EXPORT_SYMBOL(__dynamic_netdev_dbg);
 
+#endif
+
 static __initdata char ddebug_setup_string[1024];
 static __init int ddebug_setup_query(char *str)
 {
_

Patches currently in -mm which might be from jbaron@redhat.com are

linux-next.patch
dynamic_debug-consolidate-repetitive-struct-_ddebug-descriptor-definitions.patch
dynamic_debug-consolidate-repetitive-struct-_ddebug-descriptor-definitions-fix.patch
dynamic_debug-remove-num_enabled-accounting.patch
dynamic_debug-use-a-single-printk-to-emit-messages.patch
dynamic_debug-use-a-single-printk-to-emit-messages-fix.patch
dynamic_debug-fix-undefined-reference-to-__netdev_printk.patch
epoll-limit-paths.patch

