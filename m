From: akpm@linux-foundation.org
Subject: + kexec-add-dmesg-log-symbols-to-proc-vmcoreinfo-lists.patch added to -mm tree
Date: Tue, 27 Jan 2009 00:12:33 -0800
Message-ID: <200901270812.n0R8CXs9014924@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45586 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753855AbZA0IM4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 27 Jan 2009 03:12:56 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: nhorman@tuxdriver.com, horms@verge.net.au, vgoyal@redhat.com


The patch titled
     kexec: add dmesg log symbols to /proc/vmcoreinfo lists
has been added to the -mm tree.  Its filename is
     kexec-add-dmesg-log-symbols-to-proc-vmcoreinfo-lists.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: kexec: add dmesg log symbols to /proc/vmcoreinfo lists
From: Neil Horman <nhorman@tuxdriver.com>

It would be nice to be able to extract the dmesg log from a vmcore file
without needing to keep the debug symbols for the running kernel handy all
the time.  We have a facility to do this in /proc/vmcore.  This patch adds
the log_buf and log_end symbols to the vmcoreinfo area so that tools (like
makedumpfile) can easily extract the dmesg logs from a vmcore image.

Signed-off-by: Neil Horman <nhorman@tuxdriver.com>
Cc: Simon Horman <horms@verge.net.au>
Acked-by: Vivek Goyal <vgoyal@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/kernel.h |    2 ++
 kernel/kexec.c         |    3 +++
 kernel/printk.c        |    8 ++++++++
 3 files changed, 13 insertions(+)

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
@@ -253,6 +254,7 @@ static inline int printk_ratelimit(void)
 static inline bool printk_timed_ratelimit(unsigned long *caller_jiffies, \
 					  unsigned int interval_msec)	\
 		{ return false; }
+#define log_buf_kexec_setup() do {} while(0)
 #endif
 
 extern int printk_needs_cpu(int cpu);
diff -puN kernel/kexec.c~kexec-add-dmesg-log-symbols-to-proc-vmcoreinfo-lists kernel/kexec.c
--- a/kernel/kexec.c~kexec-add-dmesg-log-symbols-to-proc-vmcoreinfo-lists
+++ a/kernel/kexec.c
@@ -1409,6 +1409,9 @@ static int __init crash_save_vmcoreinfo_
 	VMCOREINFO_OFFSET(list_head, prev);
 	VMCOREINFO_OFFSET(vm_struct, addr);
 	VMCOREINFO_LENGTH(zone.free_area, MAX_ORDER);
+#ifdef CONFIG_PRINTK
+	log_buf_kexec_setup();
+#endif
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
 
@@ -136,6 +137,13 @@ static char *log_buf = __log_buf;
 static int log_buf_len = __LOG_BUF_LEN;
 static unsigned logged_chars; /* Number of chars produced since last read+clear operation */
 
+void log_buf_kexec_setup(void)
+{
+	VMCOREINFO_SYMBOL(log_buf);
+	VMCOREINFO_SYMBOL(log_end);
+}
+
+
 static int __init log_buf_len_setup(char *str)
 {
 	unsigned size = memparse(str, &str);
_

Patches currently in -mm which might be from nhorman@tuxdriver.com are

linux-next.patch
kexec-add-dmesg-log-symbols-to-proc-vmcoreinfo-lists.patch
kexec-add-dmesg-log-symbols-to-proc-vmcoreinfo-lists-fix.patch

