From: akpm@linux-foundation.org
Subject: [merged] kgdb-depends-on-vt.patch removed from -mm tree
Date: Fri, 27 May 2016 11:45:18 -0700
Message-ID: <574895be.xoHW7hq9FZaJEmnN%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42699 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752237AbcE0SpT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 27 May 2016 14:45:19 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jslaby@suse.cz, jason.wessel@windriver.com, jim.epost@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: kgdb: depends on VT
has been removed from the -mm tree.  Its filename was
     kgdb-depends-on-vt.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jiri Slaby <jslaby@suse.cz>
Subject: kgdb: depends on VT

With VT=n, the kernel build fails with:
drivers/built-in.o: In function `kgdboc_pre_exp_handler':
kgdboc.c:(.text+0x7b5aa): undefined reference to `fg_console'
kgdboc.c:(.text+0x7b5ce): undefined reference to `vc_cons'
kgdboc.c:(.text+0x7b5d5): undefined reference to `vc_cons'

kgdboc.o is built when KGDB_SERIAL_CONSOLE is set. So make
KGDB_SERIAL_CONSOLE depend on HW_CONSOLE which includes those symbols.

Link: http://lkml.kernel.org/r/1459412955-4696-1-git-send-email-jslaby@suse.cz
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
Reported-by: "Jim Davis" <jim.epost@gmail.com>
Acked-by: Jason Wessel <jason.wessel@windriver.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/Kconfig.kgdb |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN lib/Kconfig.kgdb~kgdb-depends-on-vt lib/Kconfig.kgdb
--- a/lib/Kconfig.kgdb~kgdb-depends-on-vt
+++ a/lib/Kconfig.kgdb
@@ -22,7 +22,7 @@ config KGDB_SERIAL_CONSOLE
 	tristate "KGDB: use kgdb over the serial console"
 	select CONSOLE_POLL
 	select MAGIC_SYSRQ
-	depends on TTY
+	depends on TTY && HW_CONSOLE
 	default y
 	help
 	  Share a serial console with kgdb. Sysrq-g must be used
_

Patches currently in -mm which might be from jslaby@suse.cz are


