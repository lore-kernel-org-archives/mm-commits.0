From: akpm@linux-foundation.org
Subject: + documentation-how-to-use-gdb-to-decode-oopses.patch added to -mm tree
Date: Tue, 29 May 2007 16:44:51 -0700
Message-ID: <200705292344.l4TNipX6014549@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:54595 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751672AbXE2Xoz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 29 May 2007 19:44:55 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: penberg@cs.helsinki.fi


The patch titled
     Documentation: How to use GDB to decode OOPSes
has been added to the -mm tree.  Its filename is
     documentation-how-to-use-gdb-to-decode-oopses.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Documentation: How to use GDB to decode OOPSes
From: Pekka Enberg <penberg@cs.helsinki.fi>

Adds instructions how to use GDB to figure out the exact location of
an OOPS to Documentation/BUG-HUNTING.

Signed-off-by: Pekka Enberg <penberg@cs.helsinki.fi>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/BUG-HUNTING |   24 ++++++++++++++++++++++++
 1 files changed, 24 insertions(+)

diff -puN Documentation/BUG-HUNTING~documentation-how-to-use-gdb-to-decode-oopses Documentation/BUG-HUNTING
--- a/Documentation/BUG-HUNTING~documentation-how-to-use-gdb-to-decode-oopses
+++ a/Documentation/BUG-HUNTING
@@ -191,6 +191,30 @@ e.g. crash dump output as shown by Dave 
 >        mov        0x8(%ebp), %ebx         ! %ebx = skb->sk
 >        mov        0x13c(%ebx), %eax       ! %eax = inet_sk(sk)->opt
 
+In addition, you can use GDB to figure out the exact file and line
+number of the OOPS from the vmlinux file. If you have
+CONFIG_DEBUG_INFO enabled, you can simply copy the EIP value from the
+OOPS:
+
+ EIP:    0060:[<c021e50e>]    Not tainted VLI
+
+And use GDB to translate that to human-readable form:
+
+  gdb vmlinux
+  (gdb) l *0xc021e50e
+
+If you don't have CONFIG_DEBUG_INFO enabled, you use the function
+offset from the OOPS:
+
+ EIP is at vt_ioctl+0xda8/0x1482
+
+And recompile the kernel with CONFIG_DEBUG_INFO enabled:
+
+  make vmlinux
+  gdb vmlinux
+  (gdb) p vt_ioctl
+  (gdb) l *(0x<address of vt_ioctl> + 0xda8)
+
 Another very useful option of the Kernel Hacking section in menuconfig is
 Debug memory allocations. This will help you see whether data has been
 initialised and not set before use etc. To see the values that get assigned
_

Patches currently in -mm which might be from penberg@cs.helsinki.fi are

git-unionfs.patch
documentation-how-to-use-gdb-to-decode-oopses.patch
make-proc-slabinfo-use-seq_list_xxx-helpers.patch
remove-the-deprecated-kmem_cache_t-typedef-from-slabh.patch
slub-use-ilog2-instead-of-series-of-constant-comparisons.patch
remove-useless-tolower-in-isofs.patch
revoke-special-mmap-handling.patch
revoke-special-mmap-handling-vs-fault-vs-invalidate.patch
revoke-core-code.patch
revoke-core-code-fix-zero-length-kmalloc.patch
revoke-support-for-ext2-and-ext3.patch
revoke-add-documentation.patch
revoke-wire-up-i386-system-calls.patch
slab-leaks3-default-y.patch
