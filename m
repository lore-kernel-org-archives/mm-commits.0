From: akpm@linux-foundation.org
Subject: + disable-kgdb-on-ppc.patch added to -mm tree
Date: Fri, 28 Sep 2007 10:42:16 -0700
Message-ID: <200709281742.l8SHgG7v009793@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:47900 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751904AbXI1Rmj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 28 Sep 2007 13:42:39 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: kamalesh@linux.vnet.ibm.com


The patch titled
     disable kgdb on ppc
has been added to the -mm tree.  Its filename is
     disable-kgdb-on-ppc.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: disable kgdb on ppc
From: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>

Signed-off-by : Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/Kconfig.kgdb |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN lib/Kconfig.kgdb~disable-kgdb-on-ppc lib/Kconfig.kgdb
--- a/lib/Kconfig.kgdb~disable-kgdb-on-ppc
+++ a/lib/Kconfig.kgdb
@@ -14,7 +14,7 @@ config KGDB
 	bool "KGDB: kernel debugging with remote gdb"
 	select WANT_EXTRA_DEBUG_INFORMATION
 	select KGDB_ARCH_HAS_SHADOW_INFO if X86_64
-	depends on DEBUG_KERNEL && (ARM || X86 || MIPS || (SUPERH && !SUPERH64) || IA64 || PPC)
+	depends on DEBUG_KERNEL && (ARM || X86 || MIPS || (SUPERH && !SUPERH64) || IA64)
 	help
 	  If you say Y here, it will be possible to remotely debug the
 	  kernel using gdb.  Documentation of kernel debugger is available
_

Patches currently in -mm which might be from kamalesh@linux.vnet.ibm.com are

git-net.patch
git-nfsd.patch
disable-kgdb-on-ppc.patch
memoryless-nodes-fixup-uses-of-node_online_map-in-generic-code-fix.patch
i386-and-x86_64-randomize-brk-2.patch
use-extended-crashkernel-command-line-on-ia64-fix.patch
