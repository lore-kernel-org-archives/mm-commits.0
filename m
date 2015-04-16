From: akpm@linux-foundation.org
Subject: [merged] cris-remove-use-of-seq_printf-return-value.patch removed from -mm tree
Date: Thu, 16 Apr 2015 09:55:28 -0700
Message-ID: <552fe980.bkDE/BfKvoPd3roi%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:43190 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754048AbbDPQt7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 16 Apr 2015 12:49:59 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe@perches.com, jesper.nilsson@axis.com, mm-commits@vger.kernel.org


The patch titled
     Subject: cris: remove use of seq_printf return value
has been removed from the -mm tree.  Its filename was
     cris-remove-use-of-seq_printf-return-value.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Joe Perches <joe@perches.com>
Subject: cris: remove use of seq_printf return value

The seq_printf return value, because it's frequently misused,
will eventually be converted to void.

See: commit 1f33c41c03da ("seq_file: Rename seq_overflow() to
     seq_has_overflowed() and make public")

Signed-off-by: Joe Perches <joe@perches.com>
Acked-by: Jesper Nilsson <jesper.nilsson@axis.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/cris/arch-v10/kernel/setup.c |   58 ++++++++++++++-------------
 arch/cris/arch-v32/kernel/setup.c |   60 ++++++++++++++--------------
 2 files changed, 61 insertions(+), 57 deletions(-)

diff -puN arch/cris/arch-v10/kernel/setup.c~cris-remove-use-of-seq_printf-return-value arch/cris/arch-v10/kernel/setup.c
--- a/arch/cris/arch-v10/kernel/setup.c~cris-remove-use-of-seq_printf-return-value
+++ a/arch/cris/arch-v10/kernel/setup.c
@@ -63,35 +63,37 @@ int show_cpuinfo(struct seq_file *m, voi
 	else
 		info = &cpu_info[revision];
 
-	return seq_printf(m,
-		       "processor\t: 0\n" 
-		       "cpu\t\t: CRIS\n"
-		       "cpu revision\t: %lu\n"
-		       "cpu model\t: %s\n"
-		       "cache size\t: %d kB\n"
-		       "fpu\t\t: %s\n"
-		       "mmu\t\t: %s\n"
-		       "mmu DMA bug\t: %s\n"
-		       "ethernet\t: %s Mbps\n"
-		       "token ring\t: %s\n"
-		       "scsi\t\t: %s\n"
-		       "ata\t\t: %s\n"
-		       "usb\t\t: %s\n"
-		       "bogomips\t: %lu.%02lu\n",
+	seq_printf(m,
+		   "processor\t: 0\n"
+		   "cpu\t\t: CRIS\n"
+		   "cpu revision\t: %lu\n"
+		   "cpu model\t: %s\n"
+		   "cache size\t: %d kB\n"
+		   "fpu\t\t: %s\n"
+		   "mmu\t\t: %s\n"
+		   "mmu DMA bug\t: %s\n"
+		   "ethernet\t: %s Mbps\n"
+		   "token ring\t: %s\n"
+		   "scsi\t\t: %s\n"
+		   "ata\t\t: %s\n"
+		   "usb\t\t: %s\n"
+		   "bogomips\t: %lu.%02lu\n",
 
-		       revision,
-		       info->model,
-		       info->cache,
-		       info->flags & HAS_FPU ? "yes" : "no",
-		       info->flags & HAS_MMU ? "yes" : "no",
-		       info->flags & HAS_MMU_BUG ? "yes" : "no",
-		       info->flags & HAS_ETHERNET100 ? "10/100" : "10",
-		       info->flags & HAS_TOKENRING ? "4/16 Mbps" : "no",
-		       info->flags & HAS_SCSI ? "yes" : "no",
-		       info->flags & HAS_ATA ? "yes" : "no",
-		       info->flags & HAS_USB ? "yes" : "no",
-		       (loops_per_jiffy * HZ + 500) / 500000,
-		       ((loops_per_jiffy * HZ + 500) / 5000) % 100);
+		   revision,
+		   info->model,
+		   info->cache,
+		   info->flags & HAS_FPU ? "yes" : "no",
+		   info->flags & HAS_MMU ? "yes" : "no",
+		   info->flags & HAS_MMU_BUG ? "yes" : "no",
+		   info->flags & HAS_ETHERNET100 ? "10/100" : "10",
+		   info->flags & HAS_TOKENRING ? "4/16 Mbps" : "no",
+		   info->flags & HAS_SCSI ? "yes" : "no",
+		   info->flags & HAS_ATA ? "yes" : "no",
+		   info->flags & HAS_USB ? "yes" : "no",
+		   (loops_per_jiffy * HZ + 500) / 500000,
+		   ((loops_per_jiffy * HZ + 500) / 5000) % 100);
+
+	return 0;
 }
 
 #endif /* CONFIG_PROC_FS */
diff -puN arch/cris/arch-v32/kernel/setup.c~cris-remove-use-of-seq_printf-return-value arch/cris/arch-v32/kernel/setup.c
--- a/arch/cris/arch-v32/kernel/setup.c~cris-remove-use-of-seq_printf-return-value
+++ a/arch/cris/arch-v32/kernel/setup.c
@@ -77,36 +77,38 @@ int show_cpuinfo(struct seq_file *m, voi
 		}
 	}
 
-	return seq_printf(m,
-		"processor\t: %d\n"
-		"cpu\t\t: CRIS\n"
-		"cpu revision\t: %lu\n"
-		"cpu model\t: %s\n"
-		"cache size\t: %d KB\n"
-		"fpu\t\t: %s\n"
-		"mmu\t\t: %s\n"
-		"mmu DMA bug\t: %s\n"
-		"ethernet\t: %s Mbps\n"
-		"token ring\t: %s\n"
-		"scsi\t\t: %s\n"
-		"ata\t\t: %s\n"
-		"usb\t\t: %s\n"
-		"bogomips\t: %lu.%02lu\n\n",
+	seq_printf(m,
+		   "processor\t: %d\n"
+		   "cpu\t\t: CRIS\n"
+		   "cpu revision\t: %lu\n"
+		   "cpu model\t: %s\n"
+		   "cache size\t: %d KB\n"
+		   "fpu\t\t: %s\n"
+		   "mmu\t\t: %s\n"
+		   "mmu DMA bug\t: %s\n"
+		   "ethernet\t: %s Mbps\n"
+		   "token ring\t: %s\n"
+		   "scsi\t\t: %s\n"
+		   "ata\t\t: %s\n"
+		   "usb\t\t: %s\n"
+		   "bogomips\t: %lu.%02lu\n\n",
 
-		cpu,
-		revision,
-		info->cpu_model,
-		info->cache_size,
-		info->flags & HAS_FPU ? "yes" : "no",
-		info->flags & HAS_MMU ? "yes" : "no",
-		info->flags & HAS_MMU_BUG ? "yes" : "no",
-		info->flags & HAS_ETHERNET100 ? "10/100" : "10",
-		info->flags & HAS_TOKENRING ? "4/16 Mbps" : "no",
-		info->flags & HAS_SCSI ? "yes" : "no",
-		info->flags & HAS_ATA ? "yes" : "no",
-		info->flags & HAS_USB ? "yes" : "no",
-		(loops_per_jiffy * HZ + 500) / 500000,
-		((loops_per_jiffy * HZ + 500) / 5000) % 100);
+		   cpu,
+		   revision,
+		   info->cpu_model,
+		   info->cache_size,
+		   info->flags & HAS_FPU ? "yes" : "no",
+		   info->flags & HAS_MMU ? "yes" : "no",
+		   info->flags & HAS_MMU_BUG ? "yes" : "no",
+		   info->flags & HAS_ETHERNET100 ? "10/100" : "10",
+		   info->flags & HAS_TOKENRING ? "4/16 Mbps" : "no",
+		   info->flags & HAS_SCSI ? "yes" : "no",
+		   info->flags & HAS_ATA ? "yes" : "no",
+		   info->flags & HAS_USB ? "yes" : "no",
+		   (loops_per_jiffy * HZ + 500) / 500000,
+		   ((loops_per_jiffy * HZ + 500) / 5000) % 100);
+
+	return 0;
 }
 
 #endif /* CONFIG_PROC_FS */
_

Patches currently in -mm which might be from joe@perches.com are

origin.patch
ocfs2-neaten-do_error-ocfs2_error-and-ocfs2_abort.patch
lib-vsprintfc-even-faster-decimal-conversion.patch
mm-utilc-add-kstrimdup.patch
checkpatch-improve-no-space-is-necessary-after-a-cast-test.patch
checkpatch-add-spell-checking-of-email-subject-line.patch
checkpatch-spell-check-reudce.patch
checkpatch-add-optional-codespell-dictionary-to-find-more-typos.patch
checkpatch-match-more-world-writable-permissions.patch
checkpatch-match-more-world-writable-permissions-fix.patch
checkpatch-improve-return-negative-errno-check.patch
checkpatch-add-test-for-repeated-const-uses.patch
checkpatch-dont-ask-for-asm-fileh-to-linux-fileh-unconditionally.patch
checkpatch-submittingpatches-suggest-line-wrapping-commit-messages-at-75-columns.patch
checkpatch-add-define-foo-string-long-line-exception.patch
checkpatch-add-uart_ops-to-normally-const-structs.patch
checkpatch-add-prefer-array_size-test.patch
checkpatch-improve-operator-spacing-check.patch
checkpatch-add-a-test-for-const-with-__read_mostly-uses.patch
checkpatchpl-new-instances-of-enosys-are-errors.patch
errnoh-improve-enosyss-comment.patch
checkpatch-fix-fix-use-with-a-patch-of-multiple-files.patch
checkpatch-avoid-spaces-required-around-that-false-positive.patch
rtc-use-more-standard-kernel-logging-styles.patch
adfs-returning-correct-return-values.patch
linux-next.patch
proc-show-locks-in-proc-pid-fdinfo-x.patch
proc-show-locks-in-proc-pid-fdinfo-x-v2.patch

