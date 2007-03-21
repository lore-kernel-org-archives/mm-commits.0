From: akpm@linux-foundation.org
Subject: + tty-in-tiocsctty-when-we-steal-a-tty-hang-it-up-fix.patch added to -mm tree
Date: Tue, 20 Mar 2007 22:19:51 -0800
Message-ID: <200703210619.l2L6Jq6S020334@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:50310 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752033AbXCUGUC (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 21 Mar 2007 02:20:02 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hugh@veritas.com, ebiederm@xmission.com


The patch titled
     init hangs on tty_mutex
has been added to the -mm tree.  Its filename is
     tty-in-tiocsctty-when-we-steal-a-tty-hang-it-up-fix.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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

origin.patch
shmem-fix-bug-in-shmem_writepage.patch
shmem-dont-release-lock-for-hole-punching.patch
mm-more-rmap-checking.patch
mm-make-read_cache_page-synchronous.patch
fs-buffer-dont-pageuptodate-without-page-locked.patch
free-swap-space-of-reactivated-pages.patch
add-__gfp_movable-for-callers-to-flag-allocations-from-high-memory-that-may-be-migrated.patch
smaps-extract-pmd-walker-from-smaps-code.patch
smaps-add-pages-referenced-count-to-smaps.patch
smaps-add-clear_refs-file-to-clear-reference.patch
smaps-add-clear_refs-file-to-clear-reference-fix.patch
tty-in-tiocsctty-when-we-steal-a-tty-hang-it-up-fix.patch
ext2-reservations.patch
ext2-balloc-use-io_error-label.patch
add-__gfp_movable-for-callers-to-flag-allocations-from-high-memory-that-may-be-migrated-swap-prefetch.patch
mm-only-free-swap-space-of-reactivated-pages-debug.patch
