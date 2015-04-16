From: akpm@linux-foundation.org
Subject: [folded-merged] kernel-forkc-avoid-division-by-zero-fix.patch
 removed from -mm tree
Date: Thu, 16 Apr 2015 12:08:50 -0700
Message-ID: <553008c2.Ov3mNcdim7izObp7%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45487 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750820AbbDPTIv (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 16 Apr 2015 15:08:51 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, linux@roeck-us.net, mingo@kernel.org, oleg@redhat.com, xypron.glpk@gmx.de, mm-commits@vger.kernel.org


The patch titled
     Subject: kernel-forkc-avoid-division-by-zero-fix
has been removed from the -mm tree.  Its filename was
     kernel-forkc-avoid-division-by-zero-fix.patch

This patch was dropped because it was folded into kernel-forkc-avoid-division-by-zero.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: kernel-forkc-avoid-division-by-zero-fix

use clamp(), per Oleg

Cc: Guenter Roeck <linux@roeck-us.net>
Cc: Heinrich Schuchardt <xypron.glpk@gmx.de>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Oleg Nesterov <oleg@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/fork.c |    8 +-------
 1 file changed, 1 insertion(+), 7 deletions(-)

diff -puN kernel/fork.c~kernel-forkc-avoid-division-by-zero-fix kernel/fork.c
--- a/kernel/fork.c~kernel-forkc-avoid-division-by-zero-fix
+++ a/kernel/fork.c
@@ -280,13 +280,7 @@ static void set_max_threads(void)
 		threads = div64_u64((u64) totalram_pages * (u64) PAGE_SIZE,
 				    (u64) THREAD_SIZE * 8UL);
 
-	if (threads > MAX_THREADS)
-		threads = MAX_THREADS;
-
-	if (threads < MIN_THREADS)
-		threads = MIN_THREADS;
-
-	max_threads = (int) threads;
+	max_threads = clamp(threads, MIN_THREADS, MAX_THREADS);
 }
 
 void __init fork_init(void)
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
lib-find__bit-reimplementation.patch
checkpatch-match-more-world-writable-permissions.patch
binfmt_misc-simplify-entry_status.patch
rtc-driver-for-conexant-digicolor-cx92755-on-chip-rtc.patch
fs-fat-remove-unnecessary-includes.patch
kernel-forkc-avoid-division-by-zero.patch
kernel-forkc-avoid-division-by-zero-fix-fix.patch
doc-sysctl-kerneltxt-document-threads-max-fix.patch
mm-rcu-protected-get_mm_exe_file.patch
affs-kstrdup-memory-handling-fix.patch
kconfig-use-macros-which-are-already-defined-fix.patch
lib-kconfig-fix-up-have_arch_bitreverse-help-text.patch
oprofile-reduce-mmap_sem-hold-for-mm-exe_file-fix.patch
tomoyo-reduce-mmap_sem-hold-for-mm-exe_file-checkpatch-fixes.patch
documentation-spi-spidev_testc-fix-warning.patch

