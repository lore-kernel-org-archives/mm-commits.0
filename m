From: akpm@linux-foundation.org
Subject: [merged] kexec-add-dmesg-log-symbols-to-proc-vmcoreinfo-lists.patch removed from -mm tree
Date: Mon, 06 Apr 2009 12:37:07 -0700
Message-ID: <200904061937.n36Jb7xe012803@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45538 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751375AbZDFTyf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 6 Apr 2009 15:54:35 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: nhorman@tuxdriver.com, horms@verge.net.au, randy.dunlap@oracle.com, vgoyal@redhat.com, mm-commits@vger.kernel.org


The patch titled
     kexec: add dmesg log symbols to /proc/vmcoreinfo lists
has been removed from the -mm tree.  Its filename was
     kexec-add-dmesg-log-symbols-to-proc-vmcoreinfo-lists.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: kexec: add dmesg log symbols to /proc/vmcoreinfo lists
From: Neil Horman <nhorman@tuxdriver.com>

It would be nice to be able to extract the dmesg log from a vmcore file
without needing to keep the debug symbols for the running kernel handy all
the time.  We have a facility to do this in /proc/vmcore.  This patch adds
the log_buf and log_end symbols to the vmcoreinfo area so that tools (like
makedumpfile) can easily extract the dmesg logs from a vmcore image.

[akpm@linux-foundation.org: several fixes and cleanups]
[akpm@linux-foundation.org: fix unused log_buf_kexec_setup()]
[akpm@linux-foundation.org: build fix]
Signed-off-by: Neil Horman <nhorman@tuxdriver.com>
Cc: Simon Horman <horms@verge.net.au>
Acked-by: Vivek Goyal <vgoyal@redhat.com>
Cc: Neil Horman <nhorman@tuxdriver.com>
Cc: Simon Horman <horms@verge.net.au>
Cc: Vivek Goyal <vgoyal@redhat.com>
Cc: Randy Dunlap <randy.dunlap@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/kernel.h |    4 ++++
 kernel/kexec.c         |    1 +
 kernel/printk.c        |   19 +++++++++++++++++++
 3 files changed, 24 insertions(+)

diff -puN include/linux/kernel.h~kexec-add-dmesg-log-symbols-to-proc-vmcoreinfo-lists include/linux/kernel.h
--- a/include/linux/kernel.h~kexec-add-dmesg-log-symbols-to-proc-vmcoreinfo-lists
+++ a/include/linux/kernel.h
@@ -242,6 +242,7 @@ extern struct ratelimit_state printk_rat
 extern int printk_ratelimit(void);
 extern bool printk_timed_ratelimit(unsigned long *caller_jiffies,
 				   unsigned int interval_msec);
+void log_buf_kexec_setup(void);
 #else
 static inline int vprintk(const char *s, va_list args)
 	__attribute__ ((format (printf, 1, 0)));
@@ -253,6 +254,9 @@ static inline int printk_ratelimit(void)
 static inline bool printk_timed_ratelimit(unsigned long *caller_jiffies, \
 					  unsigned int interval_msec)	\
 		{ return false; }
+static inline void log_buf_kexec_setup(void)
+{
+}
 #endif
 
 extern int printk_needs_cpu(int cpu);
diff -puN kernel/kexec.c~kexec-add-dmesg-log-symbols-to-proc-vmcoreinfo-lists kernel/kexec.c
--- a/kernel/kexec.c~kexec-add-dmesg-log-symbols-to-proc-vmcoreinfo-lists
+++ a/kernel/kexec.c
@@ -1409,6 +1409,7 @@ static int __init crash_save_vmcoreinfo_
 	VMCOREINFO_OFFSET(list_head, prev);
 	VMCOREINFO_OFFSET(vm_struct, addr);
 	VMCOREINFO_LENGTH(zone.free_area, MAX_ORDER);
+	log_buf_kexec_setup();
 	VMCOREINFO_LENGTH(free_area.free_list, MIGRATE_TYPES);
 	VMCOREINFO_NUMBER(NR_FREE_PAGES);
 	VMCOREINFO_NUMBER(PG_lru);
diff -puN kernel/printk.c~kexec-add-dmesg-log-symbols-to-proc-vmcoreinfo-lists kernel/printk.c
--- a/kernel/printk.c~kexec-add-dmesg-log-symbols-to-proc-vmcoreinfo-lists
+++ a/kernel/printk.c
@@ -32,6 +32,7 @@
 #include <linux/security.h>
 #include <linux/bootmem.h>
 #include <linux/syscalls.h>
+#include <linux/kexec.h>
 
 #include <asm/uaccess.h>
 
@@ -135,6 +136,24 @@ static char *log_buf = __log_buf;
 static int log_buf_len = __LOG_BUF_LEN;
 static unsigned logged_chars; /* Number of chars produced since last read+clear operation */
 
+#ifdef CONFIG_KEXEC
+/*
+ * This appends the listed symbols to /proc/vmcoreinfo
+ *
+ * /proc/vmcoreinfo is used by various utiilties, like crash and makedumpfile to
+ * obtain access to symbols that are otherwise very difficult to locate.  These
+ * symbols are specifically used so that utilities can access and extract the
+ * dmesg log from a vmcore file after a crash.
+ */
+void log_buf_kexec_setup(void)
+{
+	VMCOREINFO_SYMBOL(log_buf);
+	VMCOREINFO_SYMBOL(log_end);
+	VMCOREINFO_SYMBOL(log_buf_len);
+	VMCOREINFO_SYMBOL(logged_chars);
+}
+#endif
+
 static int __init log_buf_len_setup(char *str)
 {
 	unsigned size = memparse(str, &str);
_

Patches currently in -mm which might be from nhorman@tuxdriver.com are

origin.patch
linux-next.patch

