From: akpm@linux-foundation.org
Subject: [merged] printk-allocate-kernel-log-buffer-earlier-v2.patch removed from -mm tree
Date: Wed, 25 May 2011 13:31:42 -0700
Message-ID: <201105252030.p4PKU6S2014934@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37826 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932580Ab1EYUtT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 25 May 2011 16:49:19 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: travis@sgi.com, hpa@zytor.com, steiner@sgi.com, tglx@linutronix.de, yhlu.kernel@gmail.com, mm-commits@vger.kernel.org


The patch titled
     printk: allocate kernel log buffer earlier
has been removed from the -mm tree.  Its filename was
     printk-allocate-kernel-log-buffer-earlier-v2.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: printk: allocate kernel log buffer earlier
From: Mike Travis <travis@sgi.com>

On larger systems, because of the numerous ACPI, Bootmem and EFI messages,
the static log buffer overflows before the larger one specified by the
log_buf_len param is allocated.  Minimize the overflow by allocating the
new log buffer as soon as possible.

On kernels without memblock, a later call to setup_log_buf from
kernel/init.c is the fallback.

[akpm@linux-foundation.org: coding-style fixes]
[akpm@linux-foundation.org: fix CONFIG_PRINTK=n build]
Signed-off-by: Mike Travis <travis@sgi.com>
Cc: Yinghai Lu <yhlu.kernel@gmail.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Jack Steiner <steiner@sgi.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/kernel/setup.c |    2 
 include/linux/printk.h  |    7 +++
 init/main.c             |    1 
 kernel/printk.c         |   87 +++++++++++++++++++++++++-------------
 4 files changed, 68 insertions(+), 29 deletions(-)

diff -puN arch/x86/kernel/setup.c~printk-allocate-kernel-log-buffer-earlier-v2 arch/x86/kernel/setup.c
--- a/arch/x86/kernel/setup.c~printk-allocate-kernel-log-buffer-earlier-v2
+++ a/arch/x86/kernel/setup.c
@@ -946,6 +946,8 @@ void __init setup_arch(char **cmdline_p)
 	if (init_ohci1394_dma_early)
 		init_ohci1394_dma_on_all_controllers();
 #endif
+	/* Allocate bigger log buffer */
+	setup_log_buf(1);
 
 	reserve_initrd();
 
diff -puN include/linux/printk.h~printk-allocate-kernel-log-buffer-earlier-v2 include/linux/printk.h
--- a/include/linux/printk.h~printk-allocate-kernel-log-buffer-earlier-v2
+++ a/include/linux/printk.h
@@ -1,6 +1,8 @@
 #ifndef __KERNEL_PRINTK__
 #define __KERNEL_PRINTK__
 
+#include <linux/init.h>
+
 extern const char linux_banner[];
 extern const char linux_proc_banner[];
 
@@ -113,6 +115,7 @@ extern int dmesg_restrict;
 extern int kptr_restrict;
 
 void log_buf_kexec_setup(void);
+void __init setup_log_buf(int early);
 #else
 static inline __attribute__ ((format (printf, 1, 0)))
 int vprintk(const char *s, va_list args)
@@ -137,6 +140,10 @@ static inline bool printk_timed_ratelimi
 static inline void log_buf_kexec_setup(void)
 {
 }
+
+static inline void setup_log_buf(int early)
+{
+}
 #endif
 
 extern void dump_stack(void) __cold;
diff -puN init/main.c~printk-allocate-kernel-log-buffer-earlier-v2 init/main.c
--- a/init/main.c~printk-allocate-kernel-log-buffer-earlier-v2
+++ a/init/main.c
@@ -504,6 +504,7 @@ asmlinkage void __init start_kernel(void
 	 * These use large bootmem allocations and must precede
 	 * kmem_cache_init()
 	 */
+	setup_log_buf(0);
 	pidhash_init();
 	vfs_caches_init_early();
 	sort_main_extable();
diff -puN kernel/printk.c~printk-allocate-kernel-log-buffer-earlier-v2 kernel/printk.c
--- a/kernel/printk.c~printk-allocate-kernel-log-buffer-earlier-v2
+++ a/kernel/printk.c
@@ -31,6 +31,7 @@
 #include <linux/smp.h>
 #include <linux/security.h>
 #include <linux/bootmem.h>
+#include <linux/memblock.h>
 #include <linux/syscalls.h>
 #include <linux/kexec.h>
 #include <linux/kdb.h>
@@ -167,46 +168,74 @@ void log_buf_kexec_setup(void)
 }
 #endif
 
+/* requested log_buf_len from kernel cmdline */
+static unsigned long __initdata new_log_buf_len;
+
+/* save requested log_buf_len since it's too early to process it */
 static int __init log_buf_len_setup(char *str)
 {
 	unsigned size = memparse(str, &str);
-	unsigned long flags;
 
 	if (size)
 		size = roundup_pow_of_two(size);
-	if (size > log_buf_len) {
-		unsigned start, dest_idx, offset;
-		char *new_log_buf;
-
-		new_log_buf = alloc_bootmem(size);
-		if (!new_log_buf) {
-			printk(KERN_WARNING "log_buf_len: allocation failed\n");
-			goto out;
-		}
+	if (size > log_buf_len)
+		new_log_buf_len = size;
 
-		spin_lock_irqsave(&logbuf_lock, flags);
-		log_buf_len = size;
-		log_buf = new_log_buf;
+	return 0;
+}
+early_param("log_buf_len", log_buf_len_setup);
 
-		offset = start = min(con_start, log_start);
-		dest_idx = 0;
-		while (start != log_end) {
-			log_buf[dest_idx] = __log_buf[start & (__LOG_BUF_LEN - 1)];
-			start++;
-			dest_idx++;
-		}
-		log_start -= offset;
-		con_start -= offset;
-		log_end -= offset;
-		spin_unlock_irqrestore(&logbuf_lock, flags);
+void __init setup_log_buf(int early)
+{
+	unsigned long flags;
+	unsigned start, dest_idx, offset;
+	char *new_log_buf;
+	int free;
+
+	if (!new_log_buf_len)
+		return;
+
+	if (early) {
+		unsigned long mem;
 
-		printk(KERN_NOTICE "log_buf_len: %d\n", log_buf_len);
+		mem = memblock_alloc(new_log_buf_len, PAGE_SIZE);
+		if (mem == MEMBLOCK_ERROR)
+			return;
+		new_log_buf = __va(mem);
+	} else {
+		new_log_buf = alloc_bootmem_nopanic(new_log_buf_len);
 	}
-out:
-	return 1;
-}
 
-__setup("log_buf_len=", log_buf_len_setup);
+	if (unlikely(!new_log_buf)) {
+		pr_err("log_buf_len: %ld bytes not available\n",
+			new_log_buf_len);
+		return;
+	}
+
+	spin_lock_irqsave(&logbuf_lock, flags);
+	log_buf_len = new_log_buf_len;
+	log_buf = new_log_buf;
+	new_log_buf_len = 0;
+	free = __LOG_BUF_LEN - log_end;
+
+	offset = start = min(con_start, log_start);
+	dest_idx = 0;
+	while (start != log_end) {
+		unsigned log_idx_mask = start & (__LOG_BUF_LEN - 1);
+
+		log_buf[dest_idx] = __log_buf[log_idx_mask];
+		start++;
+		dest_idx++;
+	}
+	log_start -= offset;
+	con_start -= offset;
+	log_end -= offset;
+	spin_unlock_irqrestore(&logbuf_lock, flags);
+
+	pr_info("log_buf_len: %d\n", log_buf_len);
+	pr_info("early log buf free: %d(%d%%)\n",
+		free, (free * 100) / __LOG_BUF_LEN);
+}
 
 #ifdef CONFIG_BOOT_PRINTK_DELAY
 
_

Patches currently in -mm which might be from travis@sgi.com are

origin.patch

