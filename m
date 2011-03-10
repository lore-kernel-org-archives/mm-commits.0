From: akpm@linux-foundation.org
Subject: [folded] mutex-subsystem-synchro-test-module-add-missing-header-file.patch removed from -mm tree
Date: Thu, 10 Mar 2011 15:05:42 -0800
Message-ID: <201103102340.p2ANee9U003212@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51223 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753682Ab1CJXlV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 10 Mar 2011 18:41:21 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: randy.dunlap@oracle.com, dhowells@redhat.com, mm-commits@vger.kernel.org


The patch titled
     synchro-test: add missing header file
has been removed from the -mm tree.  Its filename was
     mutex-subsystem-synchro-test-module-add-missing-header-file.patch

This patch was dropped because it was folded into mutex-subsystem-synchro-test-module.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: synchro-test: add missing header file
From: Randy Dunlap <randy.dunlap@oracle.com>

Fix build errors, add <sched.h> header file:

kernel/synchro-test.c: In function 'sched':
kernel/synchro-test.c:220: error: implicit declaration of function 'schedule'
kernel/synchro-test.c: In function 'mutexer':
kernel/synchro-test.c:227: error: implicit declaration of function 'daemonize'
kernel/synchro-test.c:228: error: implicit declaration of function 'set_user_nice'
kernel/synchro-test.c:241: error: dereferencing pointer to incomplete type
kernel/synchro-test.c: In function 'semaphorer':
kernel/synchro-test.c:263: error: dereferencing pointer to incomplete type
kernel/synchro-test.c: In function 'reader':
kernel/synchro-test.c:287: error: dereferencing pointer to incomplete type
kernel/synchro-test.c: In function 'writer':
kernel/synchro-test.c:311: error: dereferencing pointer to incomplete type
kernel/synchro-test.c: In function 'downgrader':
kernel/synchro-test.c:340: error: dereferencing pointer to incomplete type

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Acked-by: David Howells <dhowells@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/synchro-test.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN kernel/synchro-test.c~mutex-subsystem-synchro-test-module-add-missing-header-file kernel/synchro-test.c
--- a/kernel/synchro-test.c~mutex-subsystem-synchro-test-module-add-missing-header-file
+++ a/kernel/synchro-test.c
@@ -21,6 +21,7 @@
 #include <linux/module.h>
 #include <linux/poll.h>
 #include <linux/moduleparam.h>
+#include <linux/sched.h>
 #include <linux/stat.h>
 #include <linux/init.h>
 #include <asm/atomic.h>
_

Patches currently in -mm which might be from randy.dunlap@oracle.com are

linux-next.patch
leds-route-kbd-leds-through-the-generic-leds-layer.patch
backlight-apple_bl-depends-on-acpi.patch
mm-debug-pagealloc-fix-kconfig-dependency-warning.patch
st-spear-pcie-gadget-suppport.patch
st-spear-pcie-gadget-documentation-for-support-of-multiple-device.patch
printk-allow-setting-default_message_level-via-kconfig.patch
documentation-codingstyle-flesh-out-if-else-examples.patch
memcg-remove-direct-page_cgroup-to-page-pointer-fix-fix.patch
mutex-subsystem-synchro-test-module.patch

