From: akpm@linux-foundation.org
Subject: - documentation-add-hint-about-call-traces-module-symbols-to-bug-hunting.patch removed from -mm tree
Date: Wed, 06 Feb 2008 16:25:18 -0800
Message-ID: <200802070024.m170Ox9T006674@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:60240 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933971AbYBGAoO (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 6 Feb 2008 19:44:14 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: richard@rsk.demon.co.uk, mm-commits@vger.kernel.org


The patch titled
     Documentation: add hint about call traces & module symbols to BUG-HUNTING
has been removed from the -mm tree.  Its filename was
     documentation-add-hint-about-call-traces-module-symbols-to-bug-hunting.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: Documentation: add hint about call traces & module symbols to BUG-HUNTING
From: Richard Kennedy <richard@rsk.demon.co.uk>

Here's a couple of small additions to BUG-HUNTING.

1. point out that you can list code in gdb with only one command
	(gdb) l *(<symbol> + offset)

2. give a very brief hint how to decode module symbols in call traces

Signed-off-by: Richard Kennedy <richard@rsk.demon.co.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/BUG-HUNTING |   17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff -puN Documentation/BUG-HUNTING~documentation-add-hint-about-call-traces-module-symbols-to-bug-hunting Documentation/BUG-HUNTING
--- a/Documentation/BUG-HUNTING~documentation-add-hint-about-call-traces-module-symbols-to-bug-hunting
+++ a/Documentation/BUG-HUNTING
@@ -214,6 +214,23 @@ And recompile the kernel with CONFIG_DEB
   gdb vmlinux
   (gdb) p vt_ioctl
   (gdb) l *(0x<address of vt_ioctl> + 0xda8)
+or, as one command
+  (gdb) l *(vt_ioctl + 0xda8)
+
+If you have a call trace, such as :-
+>Call Trace:
+> [<ffffffff8802c8e9>] :jbd:log_wait_commit+0xa3/0xf5
+> [<ffffffff810482d9>] autoremove_wake_function+0x0/0x2e
+> [<ffffffff8802770b>] :jbd:journal_stop+0x1be/0x1ee
+> ...
+this shows the problem in the :jbd: module. You can load that module in gdb
+and list the relevant code.
+  gdb fs/jbd/jbd.ko
+  (gdb) p log_wait_commit
+  (gdb) l *(0x<address> + 0xa3)
+or
+  (gdb) l *(log_wait_commit + 0xa3)
+
 
 Another very useful option of the Kernel Hacking section in menuconfig is
 Debug memory allocations. This will help you see whether data has been
_

Patches currently in -mm which might be from richard@rsk.demon.co.uk are

origin.patch
