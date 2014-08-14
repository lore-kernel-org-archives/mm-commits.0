From: akpm@linux-foundation.org
Subject: + printk-dont-bother-using-log_cpu_max_buf_shift-on-smp.patch
 added to -mm tree
Date: Thu, 14 Aug 2014 14:34:57 -0700
Message-ID: <53ed2b81.TFZX9FeAyxZL1biS%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-pd0-f201.google.com ([209.85.192.201]:58157 "EHLO
	mail-pd0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932157AbaHNVe6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 14 Aug 2014 17:34:58 -0400
Received: by mail-pd0-f201.google.com with SMTP id g10so482678pdj.2
        for <mm-commits@vger.kernel.org>; Thu, 14 Aug 2014 14:34:57 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: geert@linux-m68k.org, mcgrof@suse.com, mm-commits@vger.kernel.org


The patch titled
     Subject: printk: don't bother using LOG_CPU_MAX_BUF_SHIFT on !SMP
has been added to the -mm tree.  Its filename is
     printk-dont-bother-using-log_cpu_max_buf_shift-on-smp.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/printk-dont-bother-using-log_cpu_max_buf_shift-on-smp.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/printk-dont-bother-using-log_cpu_max_buf_shift-on-smp.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
@@ -827,6 +827,7 @@ config LOG_BUF_SHIFT
 
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
@@ -858,6 +857,9 @@ static int __init log_buf_len_setup(char
 }
 early_param("log_buf_len", log_buf_len_setup);
 
+#ifdef CONFIG_SMP
+#define __LOG_CPU_MAX_BUF_LEN (1 << CONFIG_LOG_CPU_MAX_BUF_SHIFT)
+
 static void __init log_buf_add_cpu(void)
 {
 	unsigned int cpu_extra;
@@ -884,6 +886,9 @@ static void __init log_buf_add_cpu(void)
 
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
checkpatch-relax-check-for-length-of-git-commit-ids.patch
m68k-call-find_vma-with-the-mmap_sem-held-in-sys_cacheflush.patch
m68k-call-find_vma-with-the-mmap_sem-held-in-sys_cacheflush-v2.patch
printk-dont-bother-using-log_cpu_max_buf_shift-on-smp.patch
linux-next.patch

