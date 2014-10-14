From: akpm@linux-foundation.org
Subject: [merged]
 printk-dont-bother-using-log_cpu_max_buf_shift-on-smp.patch removed from
 -mm tree
Date: Tue, 14 Oct 2014 11:19:05 -0700
Message-ID: <543d6919.d770Ptz1BAnGagJG%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:44101 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755348AbaJNSTE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 14 Oct 2014 14:19:04 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: geert@linux-m68k.org, mcgrof@suse.com, mm-commits@vger.kernel.org


The patch titled
     Subject: printk: don't bother using LOG_CPU_MAX_BUF_SHIFT on !SMP
has been removed from the -mm tree.  Its filename was
     printk-dont-bother-using-log_cpu_max_buf_shift-on-smp.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Geert Uytterhoeven <geert@linux-m68k.org>
Subject: printk: don't bother using LOG_CPU_MAX_BUF_SHIFT on !SMP

When configuring a uniprocessor kernel, don't bother the user with an
irrelevant LOG_CPU_MAX_BUF_SHIFT question, and don't build the unused
code.

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
Acked-by: Luis R. Rodriguez <mcgrof@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 init/Kconfig           |    1 +
 kernel/printk/printk.c |    7 ++++++-
 2 files changed, 7 insertions(+), 1 deletion(-)

diff -puN init/Kconfig~printk-dont-bother-using-log_cpu_max_buf_shift-on-smp init/Kconfig
--- a/init/Kconfig~printk-dont-bother-using-log_cpu_max_buf_shift-on-smp
+++ a/init/Kconfig
@@ -838,6 +838,7 @@ config LOG_BUF_SHIFT
 
 config LOG_CPU_MAX_BUF_SHIFT
 	int "CPU kernel log buffer size contribution (13 => 8 KB, 17 => 128KB)"
+	depends on SMP
 	range 0 21
 	default 12 if !BASE_SMALL
 	default 0 if BASE_SMALL
diff -puN kernel/printk/printk.c~printk-dont-bother-using-log_cpu_max_buf_shift-on-smp kernel/printk/printk.c
--- a/kernel/printk/printk.c~printk-dont-bother-using-log_cpu_max_buf_shift-on-smp
+++ a/kernel/printk/printk.c
@@ -267,7 +267,6 @@ static u32 clear_idx;
 #define LOG_ALIGN __alignof__(struct printk_log)
 #endif
 #define __LOG_BUF_LEN (1 << CONFIG_LOG_BUF_SHIFT)
-#define __LOG_CPU_MAX_BUF_LEN (1 << CONFIG_LOG_CPU_MAX_BUF_SHIFT)
 static char __log_buf[__LOG_BUF_LEN] __aligned(LOG_ALIGN);
 static char *log_buf = __log_buf;
 static u32 log_buf_len = __LOG_BUF_LEN;
@@ -852,6 +851,9 @@ static int __init log_buf_len_setup(char
 }
 early_param("log_buf_len", log_buf_len_setup);
 
+#ifdef CONFIG_SMP
+#define __LOG_CPU_MAX_BUF_LEN (1 << CONFIG_LOG_CPU_MAX_BUF_SHIFT)
+
 static void __init log_buf_add_cpu(void)
 {
 	unsigned int cpu_extra;
@@ -878,6 +880,9 @@ static void __init log_buf_add_cpu(void)
 
 	log_buf_len_update(cpu_extra + __LOG_BUF_LEN);
 }
+#else /* !CONFIG_SMP */
+static inline void log_buf_add_cpu(void) {}
+#endif /* CONFIG_SMP */
 
 void __init setup_log_buf(int early)
 {
_

Patches currently in -mm which might be from geert@linux-m68k.org are

origin.patch
linux-next.patch

