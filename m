From: akpm@linux-foundation.org
Subject: - vmcoreinfo-rename-vmcoreinfos-macros-returning-the-size.patch removed from -mm tree
Date: Fri, 08 Feb 2008 00:06:46 -0800
Message-ID: <200802080806.m1886RP0014454@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:49607 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761933AbYBHIUR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 8 Feb 2008 03:20:17 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: oomichi@mxs.nes.nec.co.jp, horms@verge.net.au, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     vmcoreinfo: rename vmcoreinfo's macros returning the size
has been removed from the -mm tree.  Its filename was
     vmcoreinfo-rename-vmcoreinfos-macros-returning-the-size.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: vmcoreinfo: rename vmcoreinfo's macros returning the size
From: "Ken'ichi Ohmichi" <oomichi@mxs.nes.nec.co.jp>

This patchset is for the vmcoreinfo data.

The vmcoreinfo data has the minimum debugging information only for dump
filtering.  makedumpfile (dump filtering command) gets it to distinguish
unnecessary pages, and makedumpfile creates a small dumpfile.


This patch:

VMCOREINFO_SIZE() should be renamed VMCOREINFO_STRUCT_SIZE() since it's always
returning the size of the struct with a given name. This change would allow
VMCOREINFO_TYPEDEF_SIZE() to simply become VMCOREINFO_SIZE() since it need not
be used exclusively for typedefs.

This discussion is the following:
http://www.ussg.iu.edu/hypermail/linux/kernel/0709.3/0582.html

Signed-off-by: Ken'ichi Ohmichi <oomichi@mxs.nes.nec.co.jp>
Acked-by: David Rientjes <rientjes@google.com>
Acked-by: Simon Horman <horms@verge.net.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/ia64/kernel/machine_kexec.c |    2 +-
 include/linux/kexec.h            |    6 +++---
 kernel/kexec.c                   |   14 +++++++-------
 3 files changed, 11 insertions(+), 11 deletions(-)

diff -puN arch/ia64/kernel/machine_kexec.c~vmcoreinfo-rename-vmcoreinfos-macros-returning-the-size arch/ia64/kernel/machine_kexec.c
--- a/arch/ia64/kernel/machine_kexec.c~vmcoreinfo-rename-vmcoreinfos-macros-returning-the-size
+++ a/arch/ia64/kernel/machine_kexec.c
@@ -135,7 +135,7 @@ void arch_crash_save_vmcoreinfo(void)
 
 	VMCOREINFO_SYMBOL(node_memblk);
 	VMCOREINFO_LENGTH(node_memblk, NR_NODE_MEMBLKS);
-	VMCOREINFO_SIZE(node_memblk_s);
+	VMCOREINFO_STRUCT_SIZE(node_memblk_s);
 	VMCOREINFO_OFFSET(node_memblk_s, start_paddr);
 	VMCOREINFO_OFFSET(node_memblk_s, size);
 #endif
diff -puN include/linux/kexec.h~vmcoreinfo-rename-vmcoreinfos-macros-returning-the-size include/linux/kexec.h
--- a/include/linux/kexec.h~vmcoreinfo-rename-vmcoreinfos-macros-returning-the-size
+++ a/include/linux/kexec.h
@@ -131,10 +131,10 @@ unsigned long paddr_vmcoreinfo_note(void
 	vmcoreinfo_append_str("SYMBOL(%s)=%lx\n", #name, (unsigned long)&name)
 #define VMCOREINFO_SIZE(name) \
 	vmcoreinfo_append_str("SIZE(%s)=%lu\n", #name, \
-			      (unsigned long)sizeof(struct name))
-#define VMCOREINFO_TYPEDEF_SIZE(name) \
-	vmcoreinfo_append_str("SIZE(%s)=%lu\n", #name, \
 			      (unsigned long)sizeof(name))
+#define VMCOREINFO_STRUCT_SIZE(name) \
+	vmcoreinfo_append_str("SIZE(%s)=%lu\n", #name, \
+			      (unsigned long)sizeof(struct name))
 #define VMCOREINFO_OFFSET(name, field) \
 	vmcoreinfo_append_str("OFFSET(%s.%s)=%lu\n", #name, #field, \
 			      (unsigned long)&(((struct name *)0)->field))
diff -puN kernel/kexec.c~vmcoreinfo-rename-vmcoreinfos-macros-returning-the-size kernel/kexec.c
--- a/kernel/kexec.c~vmcoreinfo-rename-vmcoreinfos-macros-returning-the-size
+++ a/kernel/kexec.c
@@ -1376,15 +1376,15 @@ static int __init crash_save_vmcoreinfo_
 #ifdef CONFIG_SPARSEMEM
 	VMCOREINFO_SYMBOL(mem_section);
 	VMCOREINFO_LENGTH(mem_section, NR_SECTION_ROOTS);
-	VMCOREINFO_SIZE(mem_section);
+	VMCOREINFO_STRUCT_SIZE(mem_section);
 	VMCOREINFO_OFFSET(mem_section, section_mem_map);
 #endif
-	VMCOREINFO_SIZE(page);
-	VMCOREINFO_SIZE(pglist_data);
-	VMCOREINFO_SIZE(zone);
-	VMCOREINFO_SIZE(free_area);
-	VMCOREINFO_SIZE(list_head);
-	VMCOREINFO_TYPEDEF_SIZE(nodemask_t);
+	VMCOREINFO_STRUCT_SIZE(page);
+	VMCOREINFO_STRUCT_SIZE(pglist_data);
+	VMCOREINFO_STRUCT_SIZE(zone);
+	VMCOREINFO_STRUCT_SIZE(free_area);
+	VMCOREINFO_STRUCT_SIZE(list_head);
+	VMCOREINFO_SIZE(nodemask_t);
 	VMCOREINFO_OFFSET(page, flags);
 	VMCOREINFO_OFFSET(page, _count);
 	VMCOREINFO_OFFSET(page, mapping);
_

Patches currently in -mm which might be from oomichi@mxs.nes.nec.co.jp are

origin.patch
