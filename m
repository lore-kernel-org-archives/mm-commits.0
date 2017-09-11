From: akpm@linux-foundation.org
Subject: [merged]
 include-warn-for-inconsistent-endian-config-definition.patch removed from
 -mm tree
Date: Mon, 11 Sep 2017 12:41:22 -0700
Message-ID: <20170911194122.z-u-xcyMk%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:49910 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751027AbdIKTlY (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 11 Sep 2017 15:41:24 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: arnd@arndb.de, babu.moger@oracle.com, davem@davemloft.net, deller@gmx.de, geert@linux-m68k.org, gregkh@linuxfoundation.org, jcmvbkbc@gmail.com, jejb@parisc-linux.org, jonas@southpole.se, mingo@elte.hu, mm-commits@vger.kernel.org, monstr@monstr.eu, mpe@ellerman.id.au, peterz@infradead.org, shorne@gmail.com, stefan.kristiansson@saunalahti.fi, viro@zeniv.linux.org.uk, ysato@users.sourceforge.jp


The patch titled
     Subject: include: warn for inconsistent endian config definition
has been removed from the -mm tree.  Its filename was
     include-warn-for-inconsistent-endian-config-definition.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Babu Moger <babu.moger@oracle.com>
Subject: include: warn for inconsistent endian config definition

We have seen some generic code use config parameter CONFIG_CPU_BIG_ENDIAN
to decide the endianness.

Here are the few examples.
include/asm-generic/qrwlock.h
drivers/of/base.c
drivers/of/fdt.c
drivers/tty/serial/earlycon.c
drivers/tty/serial/serial_core.c

Display warning if CPU_BIG_ENDIAN is not defined on big endian
architecture and also warn if it defined on little endian architectures.

Here is our original discussion
https://lkml.org/lkml/2017/5/24/620

Link: http://lkml.kernel.org/r/1499358861-179979-4-git-send-email-babu.moger@oracle.com
Signed-off-by: Babu Moger <babu.moger@oracle.com>
Suggested-by: Arnd Bergmann <arnd@arndb.de>
Acked-by: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: "James E.J. Bottomley" <jejb@parisc-linux.org>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: David S. Miller <davem@davemloft.net>
Cc: Greg KH <gregkh@linuxfoundation.org>
Cc: Helge Deller <deller@gmx.de>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Jonas Bonn <jonas@southpole.se>
Cc: Max Filippov <jcmvbkbc@gmail.com>
Cc: Michael Ellerman <mpe@ellerman.id.au> (powerpc)
Cc: Michal Simek <monstr@monstr.eu>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stafford Horne <shorne@gmail.com>
Cc: Stefan Kristiansson <stefan.kristiansson@saunalahti.fi>
Cc: Yoshinori Sato <ysato@users.sourceforge.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/byteorder/big_endian.h    |    4 ++++
 include/linux/byteorder/little_endian.h |    4 ++++
 2 files changed, 8 insertions(+)

diff -puN include/linux/byteorder/big_endian.h~include-warn-for-inconsistent-endian-config-definition include/linux/byteorder/big_endian.h
--- a/include/linux/byteorder/big_endian.h~include-warn-for-inconsistent-endian-config-definition
+++ a/include/linux/byteorder/big_endian.h
@@ -3,5 +3,9 @@
 
 #include <uapi/linux/byteorder/big_endian.h>
 
+#ifndef CONFIG_CPU_BIG_ENDIAN
+#warning inconsistent configuration, needs CONFIG_CPU_BIG_ENDIAN
+#endif
+
 #include <linux/byteorder/generic.h>
 #endif /* _LINUX_BYTEORDER_BIG_ENDIAN_H */
diff -puN include/linux/byteorder/little_endian.h~include-warn-for-inconsistent-endian-config-definition include/linux/byteorder/little_endian.h
--- a/include/linux/byteorder/little_endian.h~include-warn-for-inconsistent-endian-config-definition
+++ a/include/linux/byteorder/little_endian.h
@@ -3,5 +3,9 @@
 
 #include <uapi/linux/byteorder/little_endian.h>
 
+#ifdef CONFIG_CPU_BIG_ENDIAN
+#warning inconsistent configuration, CONFIG_CPU_BIG_ENDIAN is set
+#endif
+
 #include <linux/byteorder/generic.h>
 #endif /* _LINUX_BYTEORDER_LITTLE_ENDIAN_H */
_

Patches currently in -mm which might be from babu.moger@oracle.com are


