From: akpm@linux-foundation.org
Subject: [merged]
 include-linux-crash_dumph-add-vmcore_cleanup-prototype.patch removed from
 -mm tree
Date: Tue, 08 Apr 2014 14:23:17 -0700
Message-ID: <534468c5.Fw61U0oqMgp1O/gR%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56964 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756121AbaDHVXR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 Apr 2014 17:23:17 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, josh@joshtriplett.org, benh@kernel.crashing.org, rashika.kheria@gmail.com

Subject: [merged] include-linux-crash_dumph-add-vmcore_cleanup-prototype.patch removed from -mm tree
To: rashika.kheria@gmail.com,benh@kernel.crashing.org,josh@joshtriplett.org,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Tue, 08 Apr 2014 14:23:17 -0700


The patch titled
     Subject: include/linux/crash_dump.h: add vmcore_cleanup() prototype
has been removed from the -mm tree.  Its filename was
     include-linux-crash_dumph-add-vmcore_cleanup-prototype.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Rashika Kheria <rashika.kheria@gmail.com>
Subject: include/linux/crash_dump.h: add vmcore_cleanup() prototype

Eliminate the following warning in proc/vmcore.c:
fs/proc/vmcore.c:1088:6: warning: no previous prototype for `vmcore_cleanup' [-Wmissing-prototypes]

[akpm@linux-foundation.org: clean up powerpc, remove unneeded EXPORT_SYMBOL]
Signed-off-by: Rashika Kheria <rashika.kheria@gmail.com>
Reviewed-by: Josh Triplett <josh@joshtriplett.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/include/asm/fadump.h |    1 -
 fs/proc/vmcore.c                  |    1 -
 include/linux/crash_dump.h        |    1 +
 3 files changed, 1 insertion(+), 2 deletions(-)

diff -puN arch/powerpc/include/asm/fadump.h~include-linux-crash_dumph-add-vmcore_cleanup-prototype arch/powerpc/include/asm/fadump.h
--- a/arch/powerpc/include/asm/fadump.h~include-linux-crash_dumph-add-vmcore_cleanup-prototype
+++ a/arch/powerpc/include/asm/fadump.h
@@ -210,7 +210,6 @@ extern int is_fadump_active(void);
 extern void crash_fadump(struct pt_regs *, const char *);
 extern void fadump_cleanup(void);
 
-extern void vmcore_cleanup(void);
 #else	/* CONFIG_FA_DUMP */
 static inline int is_fadump_active(void) { return 0; }
 static inline void crash_fadump(struct pt_regs *regs, const char *str) { }
diff -puN fs/proc/vmcore.c~include-linux-crash_dumph-add-vmcore_cleanup-prototype fs/proc/vmcore.c
--- a/fs/proc/vmcore.c~include-linux-crash_dumph-add-vmcore_cleanup-prototype
+++ a/fs/proc/vmcore.c
@@ -1118,4 +1118,3 @@ void vmcore_cleanup(void)
 	}
 	free_elfcorebuf();
 }
-EXPORT_SYMBOL_GPL(vmcore_cleanup);
diff -puN include/linux/crash_dump.h~include-linux-crash_dumph-add-vmcore_cleanup-prototype include/linux/crash_dump.h
--- a/include/linux/crash_dump.h~include-linux-crash_dumph-add-vmcore_cleanup-prototype
+++ a/include/linux/crash_dump.h
@@ -25,6 +25,7 @@ extern int __weak remap_oldmem_pfn_range
 
 extern ssize_t copy_oldmem_page(unsigned long, char *, size_t,
 						unsigned long, int);
+void vmcore_cleanup(void);
 
 /* Architecture code defines this if there are other possible ELF
  * machine types, e.g. on bi-arch capable hardware. */
_

Patches currently in -mm which might be from rashika.kheria@gmail.com are

origin.patch

