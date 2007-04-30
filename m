From: akpm@linux-foundation.org
Subject: - tty-in-tiocsctty-when-we-steal-a-tty-hang-it-up-fix.patch removed from -mm tree
Date: Mon, 30 Apr 2007 12:40:22 -0700
Message-ID: <200704301940.l3UJeMLp013146@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:36110 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1946739AbXD3Tk1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 30 Apr 2007 15:40:27 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hugh@veritas.com, ebiederm@xmission.com, mm-commits@vger.kernel.org


The patch titled
     init hangs on tty_mutex
has been removed from the -mm tree.  Its filename was
     tty-in-tiocsctty-when-we-steal-a-tty-hang-it-up-fix.patch

This patch was dropped because it was folded into tty-in-tiocsctty-when-we-steal-a-tty-hang-it-up.patch

------------------------------------------------------
Subject: init hangs on tty_mutex
From: Hugh Dickins <hugh@veritas.com>

I get a hang at startup or shutdown: tiocsctty() holds tty_mutex, and
now with Eric's tty-in-tiocsctty-when-we-steal-a-tty-hang-it-up.patch
it can end up calling con_close(), which tries to take tty_mutex.
So best revert that in hot-fixes, until Eric provides a better.

Signed-off-by: Hugh Dickins <hugh@veritas.com>
Acked-by: Eric W. Biederman <ebiederm@xmission.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/tty_io.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff -puN drivers/char/tty_io.c~tty-in-tiocsctty-when-we-steal-a-tty-hang-it-up-fix drivers/char/tty_io.c
--- a/drivers/char/tty_io.c~tty-in-tiocsctty-when-we-steal-a-tty-hang-it-up-fix
+++ a/drivers/char/tty_io.c
@@ -2980,7 +2980,9 @@ static int tiocsctty(struct tty_struct *
 			/*
 			 * Steal it away
 			 */
-			tty_vhangup(tty);
+			read_lock(&tasklist_lock);
+			session_clear_tty(tty->session);
+			read_unlock(&tasklist_lock);
 		} else {
 			ret = -EPERM;
 			goto unlock;
_

Patches currently in -mm which might be from hugh@veritas.com are

ia64-race-flushing-icache-in-do_no_page-path.patch
git-drm.patch
scsi-fix-config_scsi_wait_scan=m.patch
mm-more-rmap-checking.patch
mm-make-read_cache_page-synchronous.patch
fs-buffer-dont-pageuptodate-without-page-locked.patch
add-__gfp_movable-for-callers-to-flag-allocations-from-high-memory-that-may-be-migrated.patch
i386-add-ptep_test_and_clear_dirtyyoung.patch
i386-use-pte_update_defer-in-ptep_test_and_clear_dirtyyoung.patch
smaps-extract-pmd-walker-from-smaps-code.patch
smaps-add-pages-referenced-count-to-smaps.patch
smaps-add-clear_refs-file-to-clear-reference.patch
slub-core.patch
mm-madvise-avoid-exclusive-mmap_sem.patch
lazy-freeing-of-memory-through-madv_free.patch
lazy-freeing-of-memory-through-madv_free-vs-mm-madvise-avoid-exclusive-mmap_sem.patch
restore-madv_dontneed-to-its-original-linux-behaviour.patch
tty-in-tiocsctty-when-we-steal-a-tty-hang-it-up.patch
tty-in-tiocsctty-when-we-steal-a-tty-hang-it-up-fix.patch
ext2-reservations.patch
ext2-balloc-use-io_error-label.patch
add-__gfp_movable-for-callers-to-flag-allocations-from-high-memory-that-may-be-migrated-swap-prefetch.patch
