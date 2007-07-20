From: akpm@linux-foundation.org
Subject: + geode-setup-correct-chipset-access-functions-fix.patch added to -mm tree
Date: Fri, 20 Jul 2007 11:22:26 -0700
Message-ID: <200707201822.l6KIMQQr009878@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:50788 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753251AbXGTSeX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 20 Jul 2007 14:34:23 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: npiggin@suse.de, ak@suse.de, alan@lxorguk.ukuu.org.uk, dilinger@debian.org, jordan.crouse@amd.com, takada@mbf.nifty.com


The patch titled
     geode setup correct chipset access functions fix
has been added to the -mm tree.  Its filename is
     geode-setup-correct-chipset-access-functions-fix.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: geode setup correct chipset access functions fix
From: Nick Piggin <npiggin@suse.de>

Should probably be reworked not to require this, but get it building.

Cc: TAKADA Yoshihito <takada@mbf.nifty.com>
Cc: Jordan Crouse <jordan.crouse@amd.com>
Cc: Andres Salomon <dilinger@debian.org>
Cc: Andi Kleen <ak@suse.de>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-x86_64/processor-cyrix.h |   30 +++++++++++++++++++++++++
 1 files changed, 30 insertions(+)

diff -puN /dev/null include/asm-x86_64/processor-cyrix.h
--- /dev/null
+++ a/include/asm-x86_64/processor-cyrix.h
@@ -0,0 +1,30 @@
+/*
+ * NSC/Cyrix CPU indexed register access. Must be inlined instead of
+ * macros to ensure correct access ordering
+ * Access order is always 0x22 (=offset), 0x23 (=value)
+ *
+ * When using the old macros a line like
+ *   setCx86(CX86_CCR2, getCx86(CX86_CCR2) | 0x88);
+ * gets expanded to:
+ *  do {
+ *    outb((CX86_CCR2), 0x22);
+ *    outb((({
+ *        outb((CX86_CCR2), 0x22);
+ *        inb(0x23);
+ *    }) | 0x88), 0x23);
+ *  } while (0);
+ *
+ * which in fact violates the access order (= 0x22, 0x22, 0x23, 0x23).
+ */
+
+static inline u8 getCx86(u8 reg)
+{
+	outb(reg, 0x22);
+	return inb(0x23);
+}
+
+static inline void setCx86(u8 reg, u8 data)
+{
+	outb(reg, 0x22);
+	outb(data, 0x23);
+}
_

Patches currently in -mm which might be from npiggin@suse.de are

origin.patch
x86_64-wbinvd-macro-fix.patch
fix-some-conversion-overflows.patch
geode-setup-correct-chipset-access-functions-fix.patch
mm-revert-kernel_ds-buffered-write-optimisation.patch
revert-81b0c8713385ce1b1b9058e916edcf9561ad76d6.patch
revert-6527c2bdf1f833cc18e8f42bd97973d583e4aa83.patch
mm-clean-up-buffered-write-code.patch
mm-debug-write-deadlocks.patch
mm-trim-more-holes.patch
mm-buffered-write-cleanup.patch
mm-write-iovec-cleanup.patch
mm-fix-pagecache-write-deadlocks.patch
mm-buffered-write-iterator.patch
fs-fix-data-loss-on-error.patch
fs-introduce-write_begin-write_end-and-perform_write-aops.patch
introduce-write_begin-write_end-aops-important-fix.patch
mm-restore-kernel_ds-optimisations.patch
implement-simple-fs-aops.patch
block_dev-convert-to-new-aops.patch
ext2-convert-to-new-aops.patch
ext3-convert-to-new-aops.patch
ext3-convert-to-new-aops-fix.patch
ext4-convert-to-new-aops.patch
ext4-convert-to-new-aops-fix.patch
xfs-convert-to-new-aops.patch
fs-new-cont-helpers.patch
fat-convert-to-new-aops.patch
hfs-convert-to-new-aops.patch
hfsplus-convert-to-new-aops.patch
hpfs-convert-to-new-aops.patch
bfs-convert-to-new-aops.patch
qnx4-convert-to-new-aops.patch
reiserfs-use-generic-write.patch
reiserfs-convert-to-new-aops.patch
reiserfs-convert-to-new-aops-fix.patch
reiserfs-use-generic_cont_expand_simple.patch
with-reiserfs-no-longer-using-the-weird-generic_cont_expand-remove-it-completely.patch
nfs-convert-to-new-aops.patch
smb-convert-to-new-aops.patch
fuse-convert-to-new-aops.patch
hostfs-convert-to-new-aops.patch
hostfs-convert-to-new-aops-fix.patch
jffs2-convert-to-new-aops.patch
ufs-convert-to-new-aops.patch
udf-convert-to-new-aops.patch
udf-convert-to-new-aops-fix.patch
sysv-convert-to-new-aops.patch
minix-convert-to-new-aops.patch
jfs-convert-to-new-aops.patch
fs-adfs-convert-to-new-aops.patch
fs-affs-convert-to-new-aops.patch
affs-convert-to-new-aops-fix.patch
ocfs2-convert-to-new-aops.patch
fs-remove-some-aop_truncated_page.patch
fs-reiserfs-cleanups.patch
fs-introduce-write_begin-write_end-and-perform_write-aops-revoke.patch
reiser4-fix-for-new-aops-patches.patch
