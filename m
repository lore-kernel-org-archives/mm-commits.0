From: akpm@linux-foundation.org
Subject: +
 adfs-add-__printf-verification-fix-format-argument-mismatches.patch added
 to -mm tree
Date: Thu, 26 Jun 2014 13:31:53 -0700
Message-ID: <53ac8339.mfnrvzz0qsL5gwep%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:59668 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751312AbaFZUby (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 26 Jun 2014 16:31:54 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe@perches.com, mm-commits@vger.kernel.org


The patch titled
     Subject: adfs: add __printf verification, fix format/argument mismatches
has been added to the -mm tree.  Its filename is
     adfs-add-__printf-verification-fix-format-argument-mismatches.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/adfs-add-__printf-verification-fix-format-argument-mismatches.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/adfs-add-__printf-verification-fix-format-argument-mismatches.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Joe Perches <joe@perches.com>
Subject: adfs: add __printf verification, fix format/argument mismatches

Might as well do the right thing.

Signed-off-by: Joe Perches <joe@perches.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/adfs/adfs.h      |    1 +
 fs/adfs/dir.c       |    2 +-
 fs/adfs/dir_fplus.c |    5 ++---
 3 files changed, 4 insertions(+), 4 deletions(-)

diff -puN fs/adfs/adfs.h~adfs-add-__printf-verification-fix-format-argument-mismatches fs/adfs/adfs.h
--- a/fs/adfs/adfs.h~adfs-add-__printf-verification-fix-format-argument-mismatches
+++ a/fs/adfs/adfs.h
@@ -153,6 +153,7 @@ extern int adfs_map_lookup(struct super_
 extern unsigned int adfs_map_free(struct super_block *sb);
 
 /* Misc */
+__printf(3, 4)
 void __adfs_error(struct super_block *sb, const char *function,
 		  const char *fmt, ...);
 #define adfs_error(sb, fmt...) __adfs_error(sb, __func__, fmt)
diff -puN fs/adfs/dir.c~adfs-add-__printf-verification-fix-format-argument-mismatches fs/adfs/dir.c
--- a/fs/adfs/dir.c~adfs-add-__printf-verification-fix-format-argument-mismatches
+++ a/fs/adfs/dir.c
@@ -138,7 +138,7 @@ adfs_dir_lookup_byname(struct inode *ino
 		goto out;
 
 	if (ADFS_I(inode)->parent_id != dir.parent_id) {
-		adfs_error(sb, "parent directory changed under me! (%lx but got %lx)\n",
+		adfs_error(sb, "parent directory changed under me! (%lx but got %x)\n",
 			   ADFS_I(inode)->parent_id, dir.parent_id);
 		ret = -EIO;
 		goto free_out;
diff -puN fs/adfs/dir_fplus.c~adfs-add-__printf-verification-fix-format-argument-mismatches fs/adfs/dir_fplus.c
--- a/fs/adfs/dir_fplus.c~adfs-add-__printf-verification-fix-format-argument-mismatches
+++ a/fs/adfs/dir_fplus.c
@@ -79,9 +79,8 @@ adfs_fplus_read(struct super_block *sb,
 
 		dir->bh_fplus[blk] = sb_bread(sb, block);
 		if (!dir->bh_fplus[blk]) {
-			adfs_error(sb,	"dir object %X failed read for"
-					" offset %d, mapped block %X",
-					id, blk, block);
+			adfs_error(sb,	"dir object %x failed read for offset %d, mapped block %lX",
+				   id, blk, block);
 			goto out;
 		}
 
_

Patches currently in -mm which might be from joe@perches.com are

origin.patch
checkpatch-check-git-commit-descriptions.patch
fs-squashfs-file_directc-replace-countsize-kmalloc-by-kmalloc_array.patch
printk-make-dynamic-kernel-ring-buffer-alignment-explicit.patch
printk-move-power-of-2-practice-of-ring-buffer-size-to-a-helper.patch
printk-make-dynamic-units-clear-for-the-kernel-ring-buffer.patch
printk-allow-increasing-the-ring-buffer-depending-on-the-number-of-cpus.patch
mm-utilc-add-kstrimdup.patch
kernelh-remove-deprecated-pack_hex_byte.patch
checkpatch-attempt-to-find-unnecessary-out-of-memory-messages.patch
checkpatch-warn-on-unnecessary-else-after-return-or-break.patch
checkpatch-fix-complex-macro-false-positive-for-escaped-constant-char.patch
checkpatch-fix-function-pointers-in-blank-line-needed-after-declarations-test.patch
checkpatch-ignore-email-headers-better.patch
checkpatchpl-also-suggest-else-if-when-if-follows-brace.patch
checkpatch-add-test-for-blank-lines-after-function-struct-union-enum.patch
checkpatch-add-a-multiple-blank-lines-test.patch
checkpatch-change-blank-line-after-declaration-type-to-line_spacing.patch
checkpatch-quiet-kconfig-help-message-checking.patch
checkpatch-warn-on-unnecessary-parentheses-around-references-of-foo-bar.patch
fs-isofs-logging-clean-up.patch
sysctl-remove-now-unused-typedef-ctl_table.patch
sysctl-remove-now-unused-typedef-ctl_table-fix.patch
adfs-add-__printf-verification-fix-format-argument-mismatches.patch
fs-qnx6-convert-printk-to-pr_foo.patch
fs-qnx6-use-pr_fmt-and-__func__-in-logging.patch
fs-qnx6-update-debugging-to-current-functions.patch
linux-next.patch
pci-dma-compat-add-pci_zalloc_consistent-helper.patch
atm-use-pci_zalloc_consistent.patch
block-use-pci_zalloc_consistent.patch
crypto-use-pci_zalloc_consistent.patch
infiniband-use-pci_zalloc_consistent.patch
i810-use-pci_zalloc_consistent.patch
media-use-pci_zalloc_consistent.patch
amd-use-pci_zalloc_consistent.patch
atl1e-use-pci_zalloc_consistent.patch
enic-use-pci_zalloc_consistent.patch
sky2-use-pci_zalloc_consistent.patch
micrel-use-pci_zalloc_consistent.patch
qlogic-use-pci_zalloc_consistent.patch
irda-use-pci_zalloc_consistent.patch
ipw2100-use-pci_zalloc_consistent.patch
mwl8k-use-pci_zalloc_consistent.patch
rtl818x-use-pci_zalloc_consistent.patch
rtlwifi-use-pci_zalloc_consistent.patch
scsi-use-pci_zalloc_consistent.patch
staging-use-pci_zalloc_consistent.patch
synclink_gt-use-pci_zalloc_consistent.patch
vme-bridges-use-pci_zalloc_consistent.patch
amd-neaten-and-remove-unnecessary-oom-messages.patch

