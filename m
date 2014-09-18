From: akpm@linux-foundation.org
Subject: + fs-reiserfs-journalc-fix-sparse-context-imbalance-warning.patch added to -mm tree
Date: Thu, 18 Sep 2014 12:05:10 -0700
Message-ID: <541b2ce6.w/wsq2g9UPYS1TFy%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40281 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751008AbaIRTFL (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 18 Sep 2014 15:05:11 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: fabf@skynet.be, jeffm@suse.com, mm-commits@vger.kernel.org


The patch titled
     Subject: fs/reiserfs/journal.c: fix sparse context imbalance warning
has been added to the -mm tree.  Its filename is
     fs-reiserfs-journalc-fix-sparse-context-imbalance-warning.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/fs-reiserfs-journalc-fix-sparse-context-imbalance-warning.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/fs-reiserfs-journalc-fix-sparse-context-imbalance-warning.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
fs-reiserfs-journalc-fix-sparse-context-imbalance-warning.patch
linux-next.patch

