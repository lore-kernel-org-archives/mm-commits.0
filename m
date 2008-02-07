From: akpm@linux-foundation.org
Subject: - make-jbd-journalc__journal_abort_hard-static.patch removed from -mm tree
Date: Wed, 06 Feb 2008 16:30:38 -0800
Message-ID: <200802070030.m170UJ7u007377@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:55987 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934991AbYBGAnk (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 6 Feb 2008 19:43:40 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bunk@kernel.org, mm-commits@vger.kernel.org


The patch titled
     make jbd/journal.c:__journal_abort_hard() static
has been removed from the -mm tree.  Its filename was
     make-jbd-journalc__journal_abort_hard-static.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

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
@@ -924,7 +924,6 @@ extern int	   journal_recover    (journa
 extern int	   journal_wipe       (journal_t *, int);
 extern int	   journal_skip_recovery	(journal_t *);
 extern void	   journal_update_superblock	(journal_t *, int);
-extern void	   __journal_abort_hard	(journal_t *);
 extern void	   journal_abort      (journal_t *, int);
 extern int	   journal_errno      (journal_t *);
 extern void	   journal_ack_err    (journal_t *);
_

Patches currently in -mm which might be from bunk@kernel.org are

origin.patch
git-acpi.patch
powerpc-vdso_do_func_patch3264-must-be-__init.patch
powerpc-free_property-mustnt-be-__init.patch
hvc_rtas_init-must-be-__init.patch
git-dvb.patch
git-gfs2-nmw.patch
git-mtd.patch
git-ocfs2.patch
if-0-pci_cleanup_aer_correct_error_status.patch
git-scsi-misc.patch
scsi-aic94xx-cleanups.patch
scsi-qlogicptic-section-fixes.patch
usb-make-usb_storage_onetouch-available-with-pm.patch
make-b43_mac_enablesuspend-static.patch
git-xtensa.patch
move-edactxt-two-levels-up.patch
kernel-cgroupc-remove-dead-code.patch
kernel-cgroupc-make-2-functions-static.patch
memory-controller-add-per-container-lru-and-reclaim-v7.patch
memory-controller-add-switch-to-control-what-type-of-pages-to-limit-v7.patch
fix-m32r-__xchg.patch
kill-udffs_dateversion.patch
the-scheduled-time-option-removal.patch
reiser4.patch
