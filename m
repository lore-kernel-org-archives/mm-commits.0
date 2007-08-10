From: akpm@linux-foundation.org
Subject: - fix-compilation-with-gcc-42-fix.patch removed from -mm tree
Date: Fri, 10 Aug 2007 12:46:08 -0700
Message-ID: <200708101946.l7AJk8Zt005340@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:36723 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S936432AbXHJTrG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 10 Aug 2007 15:47:06 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, ananth@in.ibm.com, anil.s.keshavamurthy@intel.com, lenb@kernel.org, peterc@gelato.unsw.edu.au, prasanna@in.ibm.com, tony.luck@intel.com, mm-commits@vger.kernel.org


The patch titled
     fix-compilation-with-gcc-42-fix
has been removed from the -mm tree.  Its filename was
     fix-compilation-with-gcc-42-fix.patch

This patch was dropped because it was folded into fix-compilation-with-gcc-42.patch

------------------------------------------------------
Subject: fix-compilation-with-gcc-42-fix
From: Andrew Morton <akpm@linux-foundation.org>

i386 allmodconfig:

ERROR: "jprobe_return" [net/ipv4/tcp_probe.ko] undefined!
ERROR: "jprobe_return" [net/dccp/dccp_probe.ko] undefined!
ERROR: "jprobe_return" [drivers/misc/lkdtm.ko] undefined!

Cc: "Luck, Tony" <tony.luck@intel.com>
Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
Cc: Anil S Keshavamurthy <anil.s.keshavamurthy@intel.com>
Cc: Len Brown <lenb@kernel.org>
Cc: Peter Chubb <peterc@gelato.unsw.edu.au>
Cc: Prasanna S Panchamukhi <prasanna@in.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/kprobes.c |    3 +++
 1 file changed, 3 insertions(+)

diff -puN kernel/kprobes.c~fix-compilation-with-gcc-42-fix kernel/kprobes.c
--- a/kernel/kprobes.c~fix-compilation-with-gcc-42-fix
+++ a/kernel/kprobes.c
@@ -1063,6 +1063,9 @@ EXPORT_SYMBOL_GPL(register_kprobe);
 EXPORT_SYMBOL_GPL(unregister_kprobe);
 EXPORT_SYMBOL_GPL(register_jprobe);
 EXPORT_SYMBOL_GPL(unregister_jprobe);
+#ifdef CONFIG_KPROBES
+EXPORT_SYMBOL_GPL(jprobe_return);
+#endif
 
 #ifdef CONFIG_KPROBES
 EXPORT_SYMBOL_GPL(register_kretprobe);
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

fbcon-kill-compile-warning.patch
fix-serial-buffer-memory-leak.patch
mtdchar-build-fix.patch
fix-compilation-with-gcc-42.patch
fix-compilation-with-gcc-42-fix.patch
