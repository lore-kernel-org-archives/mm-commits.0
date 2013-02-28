From: akpm@linux-foundation.org
Subject: [folded-dropped] lockdep-check-that-no-locks-held-at-freeze-time-fix.patch removed from -mm tree
Date: Wed, 27 Feb 2013 16:40:56 -0800
Message-ID: <20130228004057.449E55A408F@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gg0-f201.google.com ([209.85.161.201]:64159 "EHLO
	mail-gg0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751737Ab3B1Ak6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 27 Feb 2013 19:40:58 -0500
Received: by mail-gg0-f201.google.com with SMTP id l2so138953ggn.4
        for <mm-commits@vger.kernel.org>; Wed, 27 Feb 2013 16:40:58 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, benchan@chromium.org, mingo@redhat.com, msb@chromium.org, oleg@redhat.com, rjw@sisk.pl, tj@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: lockdep-check-that-no-locks-held-at-freeze-time-fix
has been removed from the -mm tree.  Its filename was
     lockdep-check-that-no-locks-held-at-freeze-time-fix.patch

This patch was dropped because it was folded into lockdep-check-that-no-locks-held-at-freeze-time.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: lockdep-check-that-no-locks-held-at-freeze-time-fix

ERROR: "debug_check_no_locks_held" [net/sunrpc/sunrpc.ko] undefined!
ERROR: "debug_check_no_locks_held" [net/core/pktgen.ko] undefined!
ERROR: "debug_check_no_locks_held" [fs/xfs/xfs.ko] undefined!
ERROR: "debug_check_no_locks_held" [fs/nfs/nfsv4.ko] undefined!
ERROR: "debug_check_no_locks_held" [fs/nfs/nfsv3.ko] undefined!
ERROR: "debug_check_no_locks_held" [fs/nfs/nfs.ko] undefined!
ERROR: "debug_check_no_locks_held" [fs/lockd/lockd.ko] undefined!
ERROR: "debug_check_no_locks_held" [fs/jfs/jfs.ko] undefined!
ERROR: "debug_check_no_locks_held" [fs/jffs2/jffs2.ko] undefined!
ERROR: "debug_check_no_locks_held" [fs/jbd2/jbd2.ko] undefined!
ERROR: "debug_check_no_locks_held" [fs/gfs2/gfs2.ko] undefined!
ERROR: "debug_check_no_locks_held" [drivers/w1/wire.ko] undefined!
ERROR: "debug_check_no_locks_held" [drivers/usb/atm/ueagle-atm.ko] undefined!
ERROR: "debug_check_no_locks_held" [drivers/net/irda/stir4200.ko] undefined!
ERROR: "debug_check_no_locks_held" [drivers/block/pktcdvd.ko] undefined!

testing fail :(

Cc: Ben Chan <benchan@chromium.org>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Mandeep Singh Baines <msb@chromium.org>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Rafael J. Wysocki <rjw@sisk.pl>
Cc: Tejun Heo <tj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/lockdep.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN kernel/lockdep.c~lockdep-check-that-no-locks-held-at-freeze-time-fix kernel/lockdep.c
--- a/kernel/lockdep.c~lockdep-check-that-no-locks-held-at-freeze-time-fix
+++ a/kernel/lockdep.c
@@ -4111,6 +4111,7 @@ void debug_check_no_locks_held(void)
 	if (unlikely(current->lockdep_depth > 0))
 		print_held_locks_bug();
 }
+EXPORT_SYMBOL_GPL(debug_check_no_locks_held);
 
 void debug_show_all_locks(void)
 {
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
mm-use-vm_unmapped_area-on-parisc-architecture.patch
backlight-add-new-lp8788-backlight-driver.patch
hfsplus-add-osx-prefix-for-handling-namespace-of-mac-os-x-extended-attributes.patch
fs-proc-clean-up-printks.patch
fs-proc-vmcorec-put-if-tests-in-the-top-of-the-while-loop-to-reduce-duplication.patch
lockdep-check-that-no-locks-held-at-freeze-time.patch
fs-seq_filec-seq_lseek-fix-switch-statement-indenting.patch
fs-seq_filec-seq_lseek-fix-switch-statement-indenting-checkpatch-fixes.patch
idr-remove-length-restriction-from-idr_layer-bitmap-checkpatch-fixes.patch
drivers-char-miscc-misc_register-do-not-loop-on-misc_list-unconditionally-fix.patch
ensure-that-the-gpt-header-is-at-least-the-size-of-the-structure-fix.patch
dma-debug-new-interfaces-to-debug-dma-mapping-errors-fix-fix.patch
selftests-add-tests-for-efivarfs-fix.patch
selftests-add-tests-for-efivarfs-fix-fix.patch
tools-testing-selftests-makefile-rearrange-targets.patch
selftests-add-a-simple-doc-fix.patch
hlist-drop-the-node-parameter-from-iterators-fix-fix-fix-fix.patch
hlist-drop-the-node-parameter-from-iterators-fix-fix-fix-fix-fix.patch
hlist-drop-the-node-parameter-from-iterators-checkpatch-fixes.patch
hlist-drop-the-node-parameter-from-iterators-fix.patch
hlist-drop-the-node-parameter-from-iterators-fix-fix.patch
hlist-drop-the-node-parameter-from-iterators-fix-fix-fix.patch
hlist-drop-the-node-parameter-from-iterators-fix-fix-fix-fix-fix-fix.patch
hlist-drop-the-node-parameter-from-iterators-mlx4-fix.patch
hlist-drop-the-node-parameter-from-iterators-mlx4-fix-fix.patch
hlist-drop-the-node-parameter-from-iterators-mlx4-fix-fix-fix.patch

