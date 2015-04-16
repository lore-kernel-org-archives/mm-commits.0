From: akpm@linux-foundation.org
Subject: [merged] s390-remove-use-of-seq_printf-return-value.patch removed from -mm tree
Date: Thu, 16 Apr 2015 09:55:32 -0700
Message-ID: <552fe984.XP4Im4ku9Yb4i3l4%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:43198 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750753AbbDPQuD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 16 Apr 2015 12:50:03 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe@perches.com, gerald.schaefer@de.ibm.com, heiko.carstens@de.ibm.com, oberpar@linux.vnet.ibm.com, schwidefsky@de.ibm.com, sebott@linux.vnet.ibm.com, mm-commits@vger.kernel.org


The patch titled
     Subject: s390: remove use of seq_printf return value
has been removed from the -mm tree.  Its filename was
     s390-remove-use-of-seq_printf-return-value.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Joe Perches <joe@perches.com>
Subject: s390: remove use of seq_printf return value

The seq_printf return value, because it's frequently misused,
will eventually be converted to void.

See: commit 1f33c41c03da ("seq_file: Rename seq_overflow() to
     seq_has_overflowed() and make public")

Signed-off-by: Joe Perches <joe@perches.com>
Acked-by: Sebastian Ott <sebott@linux.vnet.ibm.com>
Cc: Gerald Schaefer <gerald.schaefer@de.ibm.com>
Cc: Peter Oberparleiter <oberpar@linux.vnet.ibm.com>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/s390/pci/pci_debug.c    |    6 ++++--
 drivers/s390/cio/blacklist.c |   12 +++++++-----
 2 files changed, 11 insertions(+), 7 deletions(-)

diff -puN arch/s390/pci/pci_debug.c~s390-remove-use-of-seq_printf-return-value arch/s390/pci/pci_debug.c
--- a/arch/s390/pci/pci_debug.c~s390-remove-use-of-seq_printf-return-value
+++ a/arch/s390/pci/pci_debug.c
@@ -45,8 +45,10 @@ static int pci_perf_show(struct seq_file
 
 	if (!zdev)
 		return 0;
-	if (!zdev->fmb)
-		return seq_printf(m, "FMB statistics disabled\n");
+	if (!zdev->fmb) {
+		seq_puts(m, "FMB statistics disabled\n");
+		return 0;
+	}
 
 	/* header */
 	seq_printf(m, "FMB @ %p\n", zdev->fmb);
diff -puN drivers/s390/cio/blacklist.c~s390-remove-use-of-seq_printf-return-value drivers/s390/cio/blacklist.c
--- a/drivers/s390/cio/blacklist.c~s390-remove-use-of-seq_printf-return-value
+++ a/drivers/s390/cio/blacklist.c
@@ -330,18 +330,20 @@ cio_ignore_proc_seq_show(struct seq_file
 	if (!iter->in_range) {
 		/* First device in range. */
 		if ((iter->devno == __MAX_SUBCHANNEL) ||
-		    !is_blacklisted(iter->ssid, iter->devno + 1))
+		    !is_blacklisted(iter->ssid, iter->devno + 1)) {
 			/* Singular device. */
-			return seq_printf(s, "0.%x.%04x\n",
-					  iter->ssid, iter->devno);
+			seq_printf(s, "0.%x.%04x\n", iter->ssid, iter->devno);
+			return 0;
+		}
 		iter->in_range = 1;
-		return seq_printf(s, "0.%x.%04x-", iter->ssid, iter->devno);
+		seq_printf(s, "0.%x.%04x-", iter->ssid, iter->devno);
+		return 0;
 	}
 	if ((iter->devno == __MAX_SUBCHANNEL) ||
 	    !is_blacklisted(iter->ssid, iter->devno + 1)) {
 		/* Last device in range. */
 		iter->in_range = 0;
-		return seq_printf(s, "0.%x.%04x\n", iter->ssid, iter->devno);
+		seq_printf(s, "0.%x.%04x\n", iter->ssid, iter->devno);
 	}
 	return 0;
 }
_

Patches currently in -mm which might be from joe@perches.com are

origin.patch
ocfs2-neaten-do_error-ocfs2_error-and-ocfs2_abort.patch
lib-vsprintfc-even-faster-decimal-conversion.patch
mm-utilc-add-kstrimdup.patch
checkpatch-improve-no-space-is-necessary-after-a-cast-test.patch
checkpatch-add-spell-checking-of-email-subject-line.patch
checkpatch-spell-check-reudce.patch
checkpatch-add-optional-codespell-dictionary-to-find-more-typos.patch
checkpatch-match-more-world-writable-permissions.patch
checkpatch-match-more-world-writable-permissions-fix.patch
checkpatch-improve-return-negative-errno-check.patch
checkpatch-add-test-for-repeated-const-uses.patch
checkpatch-dont-ask-for-asm-fileh-to-linux-fileh-unconditionally.patch
checkpatch-submittingpatches-suggest-line-wrapping-commit-messages-at-75-columns.patch
checkpatch-add-define-foo-string-long-line-exception.patch
checkpatch-add-uart_ops-to-normally-const-structs.patch
checkpatch-add-prefer-array_size-test.patch
checkpatch-improve-operator-spacing-check.patch
checkpatch-add-a-test-for-const-with-__read_mostly-uses.patch
checkpatchpl-new-instances-of-enosys-are-errors.patch
errnoh-improve-enosyss-comment.patch
checkpatch-fix-fix-use-with-a-patch-of-multiple-files.patch
checkpatch-avoid-spaces-required-around-that-false-positive.patch
rtc-use-more-standard-kernel-logging-styles.patch
adfs-returning-correct-return-values.patch
linux-next.patch
proc-show-locks-in-proc-pid-fdinfo-x.patch
proc-show-locks-in-proc-pid-fdinfo-x-v2.patch

