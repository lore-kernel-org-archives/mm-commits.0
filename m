From: akpm@linux-foundation.org
Subject: - fs-jbd2-journalc-kmalloc-memset-conversion-to-kzalloc.patch removed from -mm tree
Date: Wed, 26 Sep 2007 18:44:33 -0700
Message-ID: <200709270144.l8R1iXYT014046@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:34290 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752571AbXI0Bu7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 26 Sep 2007 21:50:59 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: m.kozlowski@tuxland.pl, mm-commits@vger.kernel.org


The patch titled
     fs/jbd2/journal.c: kmalloc + memset conversion to kzalloc
has been removed from the -mm tree.  Its filename was
     fs-jbd2-journalc-kmalloc-memset-conversion-to-kzalloc.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: fs/jbd2/journal.c: kmalloc + memset conversion to kzalloc
From: Mariusz Kozlowski <m.kozlowski@tuxland.pl>

 fs/jbd2/journal.c | 66771 -> 66719 (-52 bytes)
 fs/jbd2/journal.o | 199193 -> 199049 (-144 bytes)

Signed-off-by: Mariusz Kozlowski <m.kozlowski@tuxland.pl>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/jbd2/journal.c |    7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff -puN fs/jbd2/journal.c~fs-jbd2-journalc-kmalloc-memset-conversion-to-kzalloc fs/jbd2/journal.c
--- a/fs/jbd2/journal.c~fs-jbd2-journalc-kmalloc-memset-conversion-to-kzalloc
+++ a/fs/jbd2/journal.c
@@ -928,17 +928,16 @@ static void journal_init_stats(journal_t
 {
 	int size;
 
-	if (proc_jbd2_stats == NULL)
+	if (!proc_jbd2_stats)
 		return;
 
 	journal->j_history_max = 100;
 	size = sizeof(struct transaction_stats_s) * journal->j_history_max;
-	journal->j_history = kmalloc(size, GFP_KERNEL);
-	if (journal->j_history == NULL) {
+	journal->j_history = kzalloc(size, GFP_KERNEL);
+	if (!journal->j_history) {
 		journal->j_history_max = 0;
 		return;
 	}
-	memset(journal->j_history, 0, size);
 	spin_lock_init(&journal->j_history_lock);
 }
 
_

Patches currently in -mm which might be from m.kozlowski@tuxland.pl are

git-alsa.patch
git-arm.patch
fs-cifs-connectc-kmalloc-memset-conversion-to-kzalloc.patch
git-powerpc.patch
git-dvb.patch
git-mmc.patch
git-mtd.patch
git-net.patch
skge-remove-broken-and-unused-phy_m_pc_mdi_xmode-macro.patch
move-a-few-definitions-to-au1000_xxs1500c-fix.patch
git-scsi-misc.patch
include-asm-frv-thread_infoh-kmalloc-memset-conversion-to-kzalloc.patch
include-asm-m32r-thread_infoh-kmalloc-memset-conversion-to-kzalloc.patch
drivers-char-consolemapc-kmalloc-memset-conversion-to-kzalloc.patch
doc-firmware_sample_firmware_classc-kmalloc-memset-conversion-to-kzalloc.patch
fs-autofs4-inodec-kmalloc-memset-conversion-to-kzalloc.patch
drivers-char-ip2-ip2mainc-kmalloc-memset-conversion-to-kzalloc.patch
add-a-rounddown_pow_of_two-routine-to-log2hpatch-fix.patch
drivers-video-pmag-ba-fbc-improve-diagnostics.patch
drivers-video-pmag-ba-fbc-improve-diagnostics-fix.patch
fs-reiser4-plugin-file-cryptcompressc-kmalloc-memset-conversion-to-kzalloc.patch
reiser4-kmalloc-memset-conversion-to-kzalloc.patch
fs-reiser4-init_superc-kmalloc-memset-conversion-to-kzalloc.patch
fs-reiser4-plugin-inode_ops_renamec-kmalloc-memset-conversion-to-kzalloc.patch
fs-reiser4-ktxnmgrdc-kmalloc-memset-conversion-to-kzalloc.patch
