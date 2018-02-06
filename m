From: akpm@linux-foundation.org
Subject: [patch 096/114] crash_dump: is_kdump_kernel can be boolean
Date: Tue, 06 Feb 2018 15:41:38 -0800
Message-ID: <20180206234138.UH4wwgLnf%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56512 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753537AbeBFXlj (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 6 Feb 2018 18:41:39 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, baiyaowei@cmss.chinamobile.com, mm-commits@vger.kernel.org, torvalds@linux-foundation.org

From: Yaowei Bai <baiyaowei@cmss.chinamobile.com>
Subject: crash_dump: is_kdump_kernel can be boolean

Make is_kdump_kernel return bool due to this particular function only
using either one or zero as its return value.

No functional change.

Link: http://lkml.kernel.org/r/1513308799-19232-8-git-send-email-baiyaowei@cmss.chinamobile.com
Signed-off-by: Yaowei Bai <baiyaowei@cmss.chinamobile.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/crash_dump.h |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff -puN include/linux/crash_dump.h~crash_dump-is_kdump_kernel-can-be-boolean include/linux/crash_dump.h
--- a/include/linux/crash_dump.h~crash_dump-is_kdump_kernel-can-be-boolean
+++ a/include/linux/crash_dump.h
@@ -2,13 +2,13 @@
 #ifndef LINUX_CRASH_DUMP_H
 #define LINUX_CRASH_DUMP_H
 
-#ifdef CONFIG_CRASH_DUMP
 #include <linux/kexec.h>
 #include <linux/proc_fs.h>
 #include <linux/elf.h>
 
 #include <asm/pgtable.h> /* for pgprot_t */
 
+#ifdef CONFIG_CRASH_DUMP
 #define ELFCORE_ADDR_MAX	(-1ULL)
 #define ELFCORE_ADDR_ERR	(-2ULL)
 
@@ -52,13 +52,13 @@ void vmcore_cleanup(void);
  * has passed the elf core header address on command line.
  *
  * This is not just a test if CONFIG_CRASH_DUMP is enabled or not. It will
- * return 1 if CONFIG_CRASH_DUMP=y and if kernel is booting after a panic of
- * previous kernel.
+ * return true if CONFIG_CRASH_DUMP=y and if kernel is booting after a panic
+ * of previous kernel.
  */
 
-static inline int is_kdump_kernel(void)
+static inline bool is_kdump_kernel(void)
 {
-	return (elfcorehdr_addr != ELFCORE_ADDR_MAX) ? 1 : 0;
+	return elfcorehdr_addr != ELFCORE_ADDR_MAX;
 }
 
 /* is_vmcore_usable() checks if the kernel is booting after a panic and
@@ -89,7 +89,7 @@ extern int register_oldmem_pfn_is_ram(in
 extern void unregister_oldmem_pfn_is_ram(void);
 
 #else /* !CONFIG_CRASH_DUMP */
-static inline int is_kdump_kernel(void) { return 0; }
+static inline bool is_kdump_kernel(void) { return 0; }
 #endif /* CONFIG_CRASH_DUMP */
 
 extern unsigned long saved_max_pfn;
_
