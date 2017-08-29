From: akpm@linux-foundation.org
Subject: + include-warn-for-inconsistent-endian-config-definition.patch
 added to -mm tree
Date: Tue, 29 Aug 2017 12:36:14 -0700
Message-ID: <59a5c22e.vXazJtsnCB0qXsVe%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40960 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751670AbdH2TgQ (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 29 Aug 2017 15:36:16 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: babu.moger@oracle.com, arnd@arndb.de, davem@davemloft.net, deller@gmx.de, geert@linux-m68k.org, gregkh@linuxfoundation.org, jcmvbkbc@gmail.com, jejb@parisc-linux.org, jonas@southpole.se, mingo@elte.hu, monstr@monstr.eu, mpe@ellerman.id.au, peterz@infradead.org, shorne@gmail.com, stefan.kristiansson@saunalahti.fi, viro@zeniv.linux.org.uk, ysato@users.sourceforge.jp, mm-commits@vger.kernel.org


The patch titled
     Subject: include: warn for inconsistent endian config definition
has been added to the -mm tree.  Its filename is
     include-warn-for-inconsistent-endian-config-definition.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/include-warn-for-inconsistent-endian-config-definition.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/include-warn-for-inconsistent-endian-config-definition.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

arch-define-cpu_big_endian-for-all-fixed-big-endian-archs.patch
arch-microblaze-add-choice-for-endianness-and-update-makefile.patch
include-warn-for-inconsistent-endian-config-definition.patch

