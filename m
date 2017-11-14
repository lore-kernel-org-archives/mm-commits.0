From: akpm@linux-foundation.org
Subject: [alternative-merged]
 lib-test-module-for-find__bit-functions-fix.patch removed from -mm tree
Date: Mon, 13 Nov 2017 17:04:03 -0800
Message-ID: <5a0a4103.anpQCGBAXdWADYgX%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:33848 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751161AbdKNBEF (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 13 Nov 2017 20:04:05 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, courbet@google.com, rdunlap@infradead.org, ynorov@caviumnetworks.com, mm-commits@vger.kernel.org


The patch titled
     Subject: lib-test-module-for-find__bit-functions-fix
has been removed from the -mm tree.  Its filename was
     lib-test-module-for-find__bit-functions-fix.patch

This patch was dropped because an alternative patch was merged

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: lib-test-module-for-find__bit-functions-fix

fix printk warnings reported by Randy

Cc: Clement Courbet <courbet@google.com>
Cc: Yury Norov <ynorov@caviumnetworks.com>
Cc: Randy Dunlap <rdunlap@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/test_find_bit.c |   11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff -puN lib/test_find_bit.c~lib-test-module-for-find__bit-functions-fix lib/test_find_bit.c
--- a/lib/test_find_bit.c~lib-test-module-for-find__bit-functions-fix
+++ a/lib/test_find_bit.c
@@ -51,7 +51,8 @@ static int __init test_find_first_bit(vo
 		__clear_bit(i, bitmap);
 	}
 	cycles = get_cycles() - cycles;
-	pr_err("find_first_bit:\t\t%ld cycles,\t%ld iterations\n", cycles, cnt);
+	pr_err("find_first_bit:\t\t%ld cycles,\t%ld iterations\n",
+		(long)cycles, cnt);
 
 	return 0;
 }
@@ -65,7 +66,8 @@ static int __init test_find_next_bit(con
 	for (cnt = i = 0; i < BITMAP_LEN; cnt++)
 		i = find_next_bit(bitmap, BITMAP_LEN, i) + 1;
 	cycles = get_cycles() - cycles;
-	pr_err("find_next_bit:\t\t%ld cycles,\t%ld iterations\n", cycles, cnt);
+	pr_err("find_next_bit:\t\t%ld cycles,\t%ld iterations\n",
+		(long)cycles, cnt);
 
 	return 0;
 }
@@ -80,7 +82,7 @@ static int __init test_find_next_zero_bi
 		i = find_next_zero_bit(bitmap, len, i) + 1;
 	cycles = get_cycles() - cycles;
 	pr_err("find_next_zero_bit:\t%ld cycles,\t%ld iterations\n",
-								cycles, cnt);
+		(long)cycles, cnt);
 
 	return 0;
 }
@@ -99,7 +101,8 @@ static int __init test_find_last_bit(con
 		len = l;
 	} while (len);
 	cycles = get_cycles() - cycles;
-	pr_err("find_last_bit:\t\t%ld cycles,\t%ld iterations\n", cycles, cnt);
+	pr_err("find_last_bit:\t\t%ld cycles,\t%ld iterations\n",
+		(long)cycles, cnt);
 
 	return 0;
 }
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

i-need-old-gcc.patch
arm-arch-arm-include-asm-pageh-needs-personalityh.patch
ocfs2-old-mle-put-and-release-after-the-function-dlm_add_migration_mle-called-fix.patch
mm.patch
slab-slub-slob-convert-slab_flags_t-to-32-bit-fix.patch
include-linux-sched-mmh-uninline-mmdrop_async-etc.patch
mm-swap-skip-swapcache-only-if-swapped-page-has-no-other-reference-checkpatch-fixes.patch
mm-drop-migrate-type-checks-from-has_unmovable_pages-fix.patch
mm-swap-fix-race-conditions-in-swap_slots-cache-init-fix.patch
mm-swap-fix-race-conditions-in-swap_slots-cache-init-fix-fix.patch
f2fs-simplify-page-iteration-loops-fix.patch
mm-consolidate-page-table-accounting-fix-fix.patch
mm-stop-zeroing-memory-during-allocation-in-vmemmap-fix.patch
mm-batch-radix-tree-operations-when-truncating-pages-fix-fix.patch
support-resetting-warn_once-checkpatch-fixes.patch
support-resetting-warn_once-for-all-architectures-v2-fix.patch
support-resetting-warn_once-for-all-architectures-v2-fix-fix.patch
support-resetting-warn_once-for-all-architectures-v2-fix-fix-fix.patch
kernel-reboot-add-devm_register_reboot_notifier-fix.patch
watchdog-core-make-use-of-devm_register_reboot_notifier-fix.patch
sysvipc-unteach-ids-next_id-for-checkpoint_restore-checkpatch-fixes.patch
sysvipc-make-get_maxid-o1-again-checkpatch-fixes.patch
linux-next-rejects.patch
linux-next-git-rejects.patch
tools-objtool-makefile-dont-assume-sync-checksh-is-executable.patch
net-sched-sch_redc-work-around-gcc-444-anon-union-initializer-issue.patch
kernel-forkc-export-kernel_thread-to-modules.patch
slab-leaks3-default-y.patch

