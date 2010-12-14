From: akpm@linux-foundation.org
Subject: + mlock-do-not-hold-mmap_sem-for-extended-periods-of-time-fix.patch added to -mm tree
Date: Mon, 13 Dec 2010 16:57:22 -0800
Message-ID: <201012140057.oBE0vMrr022504@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41038 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758844Ab0LNA5u (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 13 Dec 2010 19:57:50 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, dhowells@redhat.com, hpa@zytor.com, hughd@google.com, kosaki.motohiro@jp.fujitsu.com, mingo@elte.hu, npiggin@kernel.dk, peterz@infradead.org, riel@redhat.com, tglx@linutronix.de, walken@google.com


The patch titled
     mlock-do-not-hold-mmap_sem-for-extended-periods-of-time-fix
has been added to the -mm tree.  Its filename is
     mlock-do-not-hold-mmap_sem-for-extended-periods-of-time-fix.patch

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
Subject: mlock-do-not-hold-mmap_sem-for-extended-periods-of-time-fix
From: Andrew Morton <akpm@linux-foundation.org>

remove ref to rwsem_is_contended()

Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: David Howells <dhowells@redhat.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Michel Lespinasse <walken@google.com>
Cc: Nick Piggin <npiggin@kernel.dk>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Rik van Riel <riel@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory.c |    5 -----
 1 file changed, 5 deletions(-)

diff -puN mm/memory.c~mlock-do-not-hold-mmap_sem-for-extended-periods-of-time-fix mm/memory.c
--- a/mm/memory.c~mlock-do-not-hold-mmap_sem-for-extended-periods-of-time-fix
+++ a/mm/memory.c
@@ -1528,11 +1528,6 @@ int __get_user_pages(struct task_struct 
 			i++;
 			start += PAGE_SIZE;
 			nr_pages--;
-			if (nonblocking && rwsem_is_contended(&mm->mmap_sem)) {
-				up_read(&mm->mmap_sem);
-				*nonblocking = 0;
-				return i;
-			}
 		} while (nr_pages && start < vma->vm_end);
 	} while (nr_pages);
 	return i;
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

linux-next.patch
next-remove-localversion.patch
i-need-old-gcc.patch
aesni-nfg.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
mm-install_special_mapping-skips-security_file_mmap-check-fix.patch
mm-vmap-area-cache.patch
arch-x86-kernel-apic-io_apicc-fix-warning.patch
drivers-gpu-drm-radeon-atomc-fix-warning.patch
headers_check-better-search-for-functions-in-headers-fix.patch
headers_check-better-search-for-functions-in-headers-fix-checkpatch-fixes.patch
leds-route-kbd-leds-through-the-generic-leds-layer.patch
atmel_serial-fix-rts-high-after-initialization-in-rs485-mode-fix.patch
drivers-message-fusion-mptsasc-fix-warning.patch
mm.patch
mm-vmstat-use-a-single-setter-function-and-callback-for-adjusting-percpu-thresholds-fix.patch
writeback-check-skipped-pages-on-wb_sync_all-update-fix.patch
writeback-make-nr_to_write-a-per-file-limit-fix.patch
sync_inode_metadata-fix-comment.patch
fs-mpagec-consolidate-code-checkpatch-fixes.patch
mm-vmscan-reclaim-order-0-and-use-compaction-instead-of-lumpy-reclaim-fix.patch
mm-migration-allow-migration-to-operate-asynchronously-and-avoid-synchronous-compaction-in-the-faster-path-fix.patch
mm-deactivate-invalidated-pages-fix.patch
mlock-do-not-hold-mmap_sem-for-extended-periods-of-time-fix.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
hpet-factor-timer-allocate-from-open.patch
include-linux-kernelh-abs-fix-handling-of-32-bit-unsigneds-on-64-bit.patch
include-linux-kernelh-abs-fix-handling-of-32-bit-unsigneds-on-64-bit-fix.patch
fs-select-fix-information-leak-to-userspace-fix.patch
drivers-telephony-ixjc-fix-warning.patch
memcg-document-cgroup-dirty-memory-interfaces-fix.patch
fs-proc-basec-kernel-latencytopc-convert-sprintf_symbol-to-%ps-checkpatch-fixes.patch
exec_domain-establish-a-linux32-domain-on-config_compat-systems.patch
user_ns-improve-the-user_ns-on-the-slab-packaging-fix.patch
pps-add-async-pps-event-handler-fix.patch
journal_add_journal_head-debug.patch
slab-leaks3-default-y.patch
put_bh-debug.patch
getblk-handle-2tb-devices.patch
memblock-add-input-size-checking-to-memblock_find_region.patch
memblock-add-input-size-checking-to-memblock_find_region-fix.patch

