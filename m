From: akpm@linux-foundation.org
Subject: + ipc-semc-avoid-overflow-of-semop-undo-semadj-value-fix.patch
 added to -mm tree
Date: Tue, 03 Dec 2013 14:47:12 -0800
Message-ID: <529e5f70.FC5SpxQx0tt3L6ms%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:54848 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755309Ab3LCWrN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 3 Dec 2013 17:47:13 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, pmladek@suse.cz, manfred@colorfullife.com, jkosina@suse.cz, davidlohr@hp.com, akpm@linux-foundation.org

Subject: + ipc-semc-avoid-overflow-of-semop-undo-semadj-value-fix.patch added to -mm tree
To: akpm@linux-foundation.org,davidlohr@hp.com,jkosina@suse.cz,manfred@colorfullife.com,pmladek@suse.cz
From: akpm@linux-foundation.org
Date: Tue, 03 Dec 2013 14:47:12 -0800


The patch titled
     Subject: ipc-semc-avoid-overflow-of-semop-undo-semadj-value-fix
has been added to the -mm tree.  Its filename is
     ipc-semc-avoid-overflow-of-semop-undo-semadj-value-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/ipc-semc-avoid-overflow-of-semop-undo-semadj-value-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/ipc-semc-avoid-overflow-of-semop-undo-semadj-value-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: ipc-semc-avoid-overflow-of-semop-undo-semadj-value-fix

restore lessened scope of local `undo'

Cc: Davidlohr Bueso <davidlohr@hp.com>
Cc: Jiri Kosina <jkosina@suse.cz>
Cc: Manfred Spraul <manfred@colorfullife.com>
Cc: Petr Mladek <pmladek@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 ipc/sem.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN ipc/sem.c~ipc-semc-avoid-overflow-of-semop-undo-semadj-value-fix ipc/sem.c
--- a/ipc/sem.c~ipc-semc-avoid-overflow-of-semop-undo-semadj-value-fix
+++ a/ipc/sem.c
@@ -599,7 +599,7 @@ SYSCALL_DEFINE3(semget, key_t, key, int,
 static int perform_atomic_semop(struct sem_array *sma, struct sembuf *sops,
 			     int nsops, struct sem_undo *un, int pid)
 {
-	int result, undo, sem_op;
+	int result, sem_op;
 	struct sembuf *sop;
 	struct sem * curr;
 
@@ -618,7 +618,7 @@ static int perform_atomic_semop(struct s
 			goto out_of_range;
 
 		if (sop->sem_flg & SEM_UNDO) {
-			undo = un->semadj[sop->sem_num] - sem_op;
+			int undo = un->semadj[sop->sem_num] - sem_op;
 			/* Exceeding the undo range is an error. */
 			if (undo < (-SEMAEM - 1) || undo > SEMAEM)
 				goto out_of_range;
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
i-need-old-gcc.patch
procfs-also-fix-proc_reg_get_unmapped_area-for-mmu-case-fix.patch
dma-debug-enhance-dma_debug_device_change-to-check-for-mapping-errors-fix.patch
input-route-kbd-leds-through-the-generic-leds-layer-fix.patch
drivers-block-ccissc-cciss_init_one-use-proper-errnos.patch
block-blk-mq-cpuc-use-hotcpu_notifier.patch
mtd-cmdlinepart-use-cmdline-partition-parser-lib-fix-fix.patch
posix_acl-uninlining.patch
mm.patch
mm-hugetlbc-simplify-pageheadhuge-and-pagehuge.patch
mm-swapc-reorganize-put_compound_page.patch
mm-get-rid-of-unnecessary-pageblock-scanning-in-setup_zone_migrate_reserve-fix.patch
mm-memory-failure-fix-the-typo-in-me_pagecache_dirty-fix.patch
mm-add-overcommit_kbytes-sysctl-variable-checkpatch-fixes.patch
mm-add-overcommit_kbytes-sysctl-variable-fix.patch
lib-parserc-put-export_symbols-in-the-conventional-place.patch
kernel-paramsc-improve-standard-definitions-checkpatch-fixes.patch
kmod-run-usermodehelpers-only-on-cpus-allowed-for-kthreadd-v2-fix.patch
kmod-run-usermodehelpers-only-on-cpus-allowed-for-kthreadd-v2-checkpatch-fixes.patch
fs-ext3-use-rbtree-postorder-iteration-helper-instead-of-opencoding-fix.patch
ipc-semc-avoid-overflow-of-semop-undo-semadj-value-fix.patch
linux-next.patch
debugging-keep-track-of-page-owners.patch
journal_add_journal_head-debug.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mutex-subsystem-synchro-test-module.patch
slab-leaks3-default-y.patch
put_bh-debug.patch

