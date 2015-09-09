From: akpm@linux-foundation.org
Subject: [folded-merged] proc-add-kpageidle-file-fix-6-fix.patch removed
 from -mm tree
Date: Wed, 09 Sep 2015 15:06:01 -0700
Message-ID: <55f0ad49.VdpZAEKr2EIR/H4n%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:55693 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753216AbbIIWGC (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 9 Sep 2015 18:06:02 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, andreslc@google.com, mhocko@kernel.org, vdavydov@parallels.com, mm-commits@vger.kernel.org


The patch titled
     Subject: proc-add-kpageidle-file-fix-6-fix
has been removed from the -mm tree.  Its filename was
     proc-add-kpageidle-file-fix-6-fix.patch

This patch was dropped because it was folded into proc-add-kpageidle-file.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: proc-add-kpageidle-file-fix-6-fix

fix build

fs/proc/page.c: In function 'kpageidle_clear_pte_refs_one':
fs/proc/page.c:330: error: implicit declaration of function 'pmdp_clear_young_notify'
fs/proc/page.c:336: error: implicit declaration of function 'ptep_clear_young_notify'
fs/proc/page.c: In function 'kpageidle_read':
fs/proc/page.c:397: error: 'KPMBITS' undeclared (first use in this function)
fs/proc/page.c:397: error: (Each undeclared identifier is reported only once
fs/proc/page.c:397: error: for each function it appears in.)
fs/proc/page.c: In function 'kpageidle_write':
fs/proc/page.c:450: error: 'KPMBITS' undeclared (first use in this function)

Cc: Andres Lagar-Cavilla <andreslc@google.com>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Vladimir Davydov <vdavydov@parallels.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/page.c |    2 ++
 1 file changed, 2 insertions(+)

diff -puN fs/proc/page.c~proc-add-kpageidle-file-fix-6-fix fs/proc/page.c
--- a/fs/proc/page.c~proc-add-kpageidle-file-fix-6-fix
+++ a/fs/proc/page.c
@@ -10,6 +10,7 @@
 #include <linux/seq_file.h>
 #include <linux/hugetlb.h>
 #include <linux/memcontrol.h>
+#include <linux/mmu_notifier.h>
 #include <linux/page_idle.h>
 #include <linux/kernel-page-flags.h>
 #include <asm/uaccess.h>
@@ -17,6 +18,7 @@
 
 #define KPMSIZE sizeof(u64)
 #define KPMMASK (KPMSIZE - 1)
+#define KPMBITS (KPMSIZE * BITS_PER_BYTE)
 
 /* /proc/kpagecount - an array exposing page counts
  *
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

proc-add-kpageidle-file.patch
proc-add-kpageidle-file-fix-6-fix-2-fix.patch
proc-add-kpageidle-file-fix-99.patch
proc-export-idle-flag-via-kpageflags-fix.patch
procfs-always-expose-proc-pid-map_files-and-make-it-readable-fix.patch
procfs-always-expose-proc-pid-map_files-and-make-it-readable-fix-fix.patch
fs-coda-fix-readlink-buffer-overflow-checkpatch-fixes.patch
kexec-split-kexec_file-syscall-code-to-kexec_filec-fix.patch
kexec-split-kexec_file-syscall-code-to-kexec_filec-fix-2.patch
kexec-split-kexec_file-syscall-code-to-kexec_filec-fix-2-fix.patch
kexec-split-kexec_file-syscall-code-to-kexec_filec-fix-2-fix-fix.patch
kexec-split-kexec_load-syscall-from-kexec-core-code-checkpatch-fixes.patch
align-crash_notes-allocation-to-make-it-be-inside-one-physical-page-fix.patch
mm-mpx-add-vm_flags_t-vm_flags-arg-to-do_mmap_pgoff-fix-checkpatch-fixes.patch

