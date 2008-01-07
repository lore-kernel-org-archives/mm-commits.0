From: akpm@linux-foundation.org
Subject: + documentation-add-hint-about-call-traces-module-symbols-to-bug-hunting.patch added to -mm tree
Date: Mon, 07 Jan 2008 15:12:49 -0800
Message-ID: <200801072312.m07NCnYC017001@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:59321 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752539AbYAGXMx (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 7 Jan 2008 18:12:53 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: richard@rsk.demon.co.uk


The patch titled
     Documentation: add hint about call traces & module symbols to BUG-HUNTING
has been added to the -mm tree.  Its filename is
     documentation-add-hint-about-call-traces-module-symbols-to-bug-hunting.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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

documentation-add-hint-about-call-traces-module-symbols-to-bug-hunting.patch
