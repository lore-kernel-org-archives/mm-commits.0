From: akpm@linux-foundation.org
Subject: - use-extended-crashkernel-command-line-on-ia64-fix.patch removed from -mm tree
Date: Thu, 18 Oct 2007 21:32:38 -0700
Message-ID: <200710190432.l9J4WcKP015220@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:42745 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752017AbXJSEcy (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 19 Oct 2007 00:32:54 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kamalesh@linux.vnet.ibm.com, bwalle@suse.de, ebiederm@xmission.com, tony.luck@intel.com, vgoyal@in.ibm.com, mm-commits@vger.kernel.org


The patch titled
     use-extended-crashkernel-command-line-on-ia64 fix
has been removed from the -mm tree.  Its filename was
     use-extended-crashkernel-command-line-on-ia64-fix.patch

This patch was dropped because it was folded into use-extended-crashkernel-command-line-on-ia64.patch

------------------------------------------------------
Subject: use-extended-crashkernel-command-line-on-ia64 fix
From: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>

arch/ia64/kernel/efi.c: In function 'efi_memmap_init':
arch/ia64/kernel/efi.c:1088: error: 'total_memory' undeclared (first use in this function)
arch/ia64/kernel/efi.c:1088: error: (Each undeclared identifier is reported only once
arch/ia64/kernel/efi.c:1088: error: for each function it appears in.)
make[1]: *** [arch/ia64/kernel/efi.o] Error 1
make: *** [arch/ia64/kernel] Error 2

The use-extended-crashkernel-command-line-on-ia64.patch uses total_mem and
return total_memory.

Signed-off-by: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
Cc: Bernhard Walle <bwalle@suse.de>
Cc: "Luck, Tony" <tony.luck@intel.com>
Cc: Vivek Goyal <vgoyal@in.ibm.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/ia64/kernel/efi.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN arch/ia64/kernel/efi.c~use-extended-crashkernel-command-line-on-ia64-fix arch/ia64/kernel/efi.c
--- a/arch/ia64/kernel/efi.c~use-extended-crashkernel-command-line-on-ia64-fix
+++ a/arch/ia64/kernel/efi.c
@@ -1085,7 +1085,7 @@ efi_memmap_init(unsigned long *s, unsign
 	*s = (u64)kern_memmap;
 	*e = (u64)++k;
 
-	return total_memory;
+	return total_mem;
 }
 
 void
_

Patches currently in -mm which might be from kamalesh@linux.vnet.ibm.com are

origin.patch
use-extended-crashkernel-command-line-on-ia64.patch
use-extended-crashkernel-command-line-on-ia64-fix.patch
