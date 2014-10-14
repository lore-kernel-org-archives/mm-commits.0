From: akpm@linux-foundation.org
Subject: [merged]
 fs-reiserfs-journalc-fix-sparse-context-imbalance-warning.patch removed
 from -mm tree
Date: Tue, 14 Oct 2014 11:21:10 -0700
Message-ID: <543d6996./7o8PB6qo9No1Sot%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:44381 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754840AbaJNSVJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 14 Oct 2014 14:21:09 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: fabf@skynet.be, jeffm@suse.com, mm-commits@vger.kernel.org


The patch titled
     Subject: fs/reiserfs/journal.c: fix sparse context imbalance warning
has been removed from the -mm tree.  Its filename was
     fs-reiserfs-journalc-fix-sparse-context-imbalance-warning.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Fabian Frederick <fabf@skynet.be>
Subject: fs/reiserfs/journal.c: fix sparse context imbalance warning

Merge conditional unlock/lock in the same condition to avoid sparse
warning: fs/reiserfs/journal.c:703:36: warning: context imbalance in
'add_to_chunk' - unexpected unlock

Signed-off-by: Fabian Frederick <fabf@skynet.be>
Cc: Jeff Mahoney <jeffm@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/reiserfs/journal.c |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff -puN fs/reiserfs/journal.c~fs-reiserfs-journalc-fix-sparse-context-imbalance-warning fs/reiserfs/journal.c
--- a/fs/reiserfs/journal.c~fs-reiserfs-journalc-fix-sparse-context-imbalance-warning
+++ a/fs/reiserfs/journal.c
@@ -699,11 +699,13 @@ static int add_to_chunk(struct buffer_ch
 	chunk->bh[chunk->nr++] = bh;
 	if (chunk->nr >= CHUNK_SIZE) {
 		ret = 1;
-		if (lock)
+		if (lock) {
 			spin_unlock(lock);
-		fn(chunk);
-		if (lock)
+			fn(chunk);
 			spin_lock(lock);
+		} else {
+			fn(chunk);
+		}
 	}
 	return ret;
 }
_

Patches currently in -mm which might be from fabf@skynet.be are

origin.patch
fs-cifs-remove-obsolete-__constant.patch
fs-cifs-filec-replace-countsize-kzalloc-by-kcalloc.patch
fs-cifs-smb2filec-replace-countsize-kzalloc-by-kcalloc.patch
kernel-posix-timersc-code-clean-up.patch
kernel-posix-timersc-code-clean-up-checkpatch-fixes.patch
fs-ext4-fsyncc-generic_file_fsync-call-based-on-barrier-flag.patch
linux-next.patch

