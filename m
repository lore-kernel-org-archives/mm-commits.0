From: akpm@linux-foundation.org
Subject: + mlock-do-not-hold-mmap_sem-for-extended-periods-of-time-fix2.patch added to -mm tree
Date: Tue, 14 Dec 2010 15:49:12 -0800
Message-ID: <201012150022.oBF0M9F5018711@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59474 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756583Ab0LOAWn (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 14 Dec 2010 19:22:43 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, walken@google.com


The patch titled
     mlock-do-not-hold-mmap_sem-for-extended-periods-of-time-fix2
has been added to the -mm tree.  Its filename is
     mlock-do-not-hold-mmap_sem-for-extended-periods-of-time-fix2.patch

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
Subject: mlock-do-not-hold-mmap_sem-for-extended-periods-of-time-fix2
From: Andrew Morton <akpm@linux-foundation.org>

Cc: Michel Lespinasse <walken@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory.c |    3 ++-
 nommu.c     |    0 
 2 files changed, 2 insertions(+), 1 deletion(-)

diff -puN mm/internal.h~mlock-do-not-hold-mmap_sem-for-extended-periods-of-time-fix2 mm/internal.h
diff -puN mm/memory.c~mlock-do-not-hold-mmap_sem-for-extended-periods-of-time-fix2 mm/memory.c
--- a/mm/memory.c~mlock-do-not-hold-mmap_sem-for-extended-periods-of-time-fix2
+++ a/mm/memory.c
@@ -1614,7 +1614,8 @@ int get_user_pages_noio(struct task_stru
 	if (force)
 		flags |= FOLL_FORCE;
 
-	return __get_user_pages(tsk, mm, start, nr_pages, flags, pages, vmas);
+	return __get_user_pages(tsk, mm, start, nr_pages, flags, pages, vmas,
+				NULL);
 }
 EXPORT_SYMBOL(get_user_pages_noio);
 
diff -puN mm/mlock.c~mlock-do-not-hold-mmap_sem-for-extended-periods-of-time-fix2 mm/mlock.c
diff -puN mm/nommu.c~mlock-do-not-hold-mmap_sem-for-extended-periods-of-time-fix2 mm/nommu.c
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

linux-next.patch
next-remove-localversion.patch
i-need-old-gcc.patch
aesni-nfg.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
mm-install_special_mapping-skips-security_file_mmap-check-fix.patch
delayacct-fix-iotop-on-x86_64-fix.patch
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
mlock-do-not-hold-mmap_sem-for-extended-periods-of-time-fix2.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
hpet-factor-timer-allocate-from-open.patch
include-linux-kernelh-abs-fix-handling-of-32-bit-unsigneds-on-64-bit.patch
include-linux-kernelh-abs-fix-handling-of-32-bit-unsigneds-on-64-bit-fix.patch
fs-select-fix-information-leak-to-userspace-fix.patch
drivers-telephony-ixjc-fix-warning.patch
memcg-document-cgroup-dirty-memory-interfaces-fix.patch
fs-proc-basec-kernel-latencytopc-convert-sprintf_symbol-to-%ps-checkpatch-fixes.patch
exec_domain-establish-a-linux32-domain-on-config_compat-systems.patch
sysctl-remove-obsolete-comments-fix.patch
user_ns-improve-the-user_ns-on-the-slab-packaging-fix.patch
pps-add-async-pps-event-handler-fix.patch
journal_add_journal_head-debug.patch
slab-leaks3-default-y.patch
put_bh-debug.patch
memblock-add-input-size-checking-to-memblock_find_region.patch
memblock-add-input-size-checking-to-memblock_find_region-fix.patch

