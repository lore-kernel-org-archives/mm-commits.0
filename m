From: akpm@linux-foundation.org
Subject: + use-extended-crashkernel-command-line-on-ia64-fix.patch added to -mm tree
Date: Mon, 24 Sep 2007 09:34:30 -0700
Message-ID: <200709241634.l8OGYUld006680@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:45000 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760322AbXIXQfP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 24 Sep 2007 12:35:15 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: kamalesh@linux.vnet.ibm.com, bwalle@suse.de, ebiederm@xmission.com, tony.luck@intel.com, vgoyal@in.ibm.com


The patch titled
     use-extended-crashkernel-command-line-on-ia64 fix
has been added to the -mm tree.  Its filename is
     use-extended-crashkernel-command-line-on-ia64-fix.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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

fix-3-gregkh-driver-kobject-remove-the-static-array-for-the-name.patch
git-net-fix-macec.patch
memoryless-nodes-fixup-uses-of-node_online_map-in-generic-code-fix.patch
use-extended-crashkernel-command-line-on-ia64-fix.patch
