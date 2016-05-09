From: akpm@linux-foundation.org
Subject: + kgdb-depends-on-vt.patch added to -mm tree
Date: Mon, 09 May 2016 13:54:25 -0700
Message-ID: <5730f901.A5UbHhAqdEuFtGaB%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:54615 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753032AbcEIUy0 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 9 May 2016 16:54:26 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jslaby@suse.cz, jason.wessel@windriver.com, jim.epost@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: kgdb: depends on VT
has been added to the -mm tree.  Its filename is
     kgdb-depends-on-vt.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/kgdb-depends-on-vt.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/kgdb-depends-on-vt.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

mn10300-let-exit_fpu-accept-a-task.patch
exit_thread-remove-empty-bodies.patch
exit_thread-accept-a-task-parameter-to-be-exited.patch
fork-free-thread-in-copy_process-on-failure.patch
maintainers-remove-linux-listsopenriscnet.patch
kgdb-depends-on-vt.patch

