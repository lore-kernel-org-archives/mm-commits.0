From: akpm@linux-foundation.org
Subject: + make-jbd-journalc__journal_abort_hard-static.patch added to -mm tree
Date: Wed, 24 Oct 2007 20:59:02 -0700
Message-ID: <200710250359.l9P3x2rh030698@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:43597 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757365AbXJYD7Q (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 24 Oct 2007 23:59:16 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: bunk@kernel.org


The patch titled
     make jbd/journal.c:__journal_abort_hard() static
has been added to the -mm tree.  Its filename is
     make-jbd-journalc__journal_abort_hard-static.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: make jbd/journal.c:__journal_abort_hard() static
From: Adrian Bunk <bunk@kernel.org>

__journal_abort_hard() can now become static.

Signed-off-by: Adrian Bunk <bunk@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/jbd/journal.c    |    2 +-
 include/linux/jbd.h |    1 -
 2 files changed, 1 insertion(+), 2 deletions(-)

diff -puN fs/jbd/journal.c~make-jbd-journalc__journal_abort_hard-static fs/jbd/journal.c
--- a/fs/jbd/journal.c~make-jbd-journalc__journal_abort_hard-static
+++ a/fs/jbd/journal.c
@@ -1457,7 +1457,7 @@ static const char *journal_dev_name(jour
  * Aborts hard --- we mark the abort as occurred, but do _nothing_ else,
  * and don't attempt to make any other journal updates.
  */
-void __journal_abort_hard(journal_t *journal)
+static void __journal_abort_hard(journal_t *journal)
 {
 	transaction_t *transaction;
 	char b[BDEVNAME_SIZE];
diff -puN include/linux/jbd.h~make-jbd-journalc__journal_abort_hard-static include/linux/jbd.h
--- a/include/linux/jbd.h~make-jbd-journalc__journal_abort_hard-static
+++ a/include/linux/jbd.h
@@ -922,7 +922,6 @@ extern int	   journal_recover    (journa
 extern int	   journal_wipe       (journal_t *, int);
 extern int	   journal_skip_recovery	(journal_t *);
 extern void	   journal_update_superblock	(journal_t *, int);
-extern void	   __journal_abort_hard	(journal_t *);
 extern void	   journal_abort      (journal_t *, int);
 extern int	   journal_errno      (journal_t *);
 extern void	   journal_ack_err    (journal_t *);
_

Patches currently in -mm which might be from bunk@kernel.org are

ipmi-fix-comparison-in-demangle_device_id.patch
git-dvb.patch
git-hwmon.patch
git-nfs-make-nfs_wb_page_priority-static.patch
git-sh64.patch
fuse-fuse_file_alloc-fix-null-dereferences.patch
ext4-return-after-ext4_error-in-case-of-failures.patch
make-jbd-journalc__journal_abort_hard-static.patch
memory-controller-add-per-container-lru-and-reclaim-v7.patch
memory-controller-add-switch-to-control-what-type-of-pages-to-limit-v7.patch
reiser4.patch
