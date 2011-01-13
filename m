From: akpm@linux-foundation.org
Subject: [folded] cramfs-generate-unique-inode-number-for-better-inode-cache-usage-checkpatch-fixes.patch removed from -mm tree
Date: Wed, 12 Jan 2011 16:30:47 -0800
Message-ID: <201101130030.p0D0UlER012631@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37133 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755542Ab1AMAa6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 12 Jan 2011 19:30:58 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, stefani@seibold.net, mm-commits@vger.kernel.org


The patch titled
     cramfs-generate-unique-inode-number-for-better-inode-cache-usage-checkpatch-fixes
has been removed from the -mm tree.  Its filename was
     cramfs-generate-unique-inode-number-for-better-inode-cache-usage-checkpatch-fixes.patch

This patch was dropped because it was folded into cramfs-generate-unique-inode-number-for-better-inode-cache-usage.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: cramfs-generate-unique-inode-number-for-better-inode-cache-usage-checkpatch-fixes
From: Andrew Morton <akpm@linux-foundation.org>

ERROR: "foo * bar" should be "foo *bar"
#44: FILE: fs/cramfs/inode.c:40:
+static unsigned long cramino(struct cramfs_inode * cino, unsigned int offset)

ERROR: "foo * bar" should be "foo *bar"
#68: FILE: fs/cramfs/inode.c:64:
+	struct cramfs_inode * cramfs_inode, unsigned int offset)

WARNING: line over 80 characters
#157: FILE: fs/cramfs/inode.c:293:
+	super.root.mode |= (S_IRUSR | S_IXUSR | S_IRGRP | S_IXGRP | S_IROTH | S_IXOTH);

WARNING: line over 80 characters
#187: FILE: fs/cramfs/inode.c:436:
+		de = cramfs_read(dir->i_sb, dir_off, sizeof(*de)+CRAMFS_MAXPATHLEN);

WARNING: line over 80 characters
#196: FILE: fs/cramfs/inode.c:467:
+			d_add(dentry, get_cramfs_inode(dir->i_sb, &entry, dir_off));

total: 2 errors, 3 warnings, 161 lines checked

./patches/cramfs-generate-unique-inode-number-for-better-inode-cache-usage.patch has style problems, please review.  If any of these errors
are false positives report them to the maintainer, see
CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: Stefani Seibold <stefani@seibold.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/cramfs/inode.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN fs/cramfs/inode.c~cramfs-generate-unique-inode-number-for-better-inode-cache-usage-checkpatch-fixes fs/cramfs/inode.c
--- a/fs/cramfs/inode.c~cramfs-generate-unique-inode-number-for-better-inode-cache-usage-checkpatch-fixes
+++ a/fs/cramfs/inode.c
@@ -37,7 +37,7 @@ static DEFINE_MUTEX(read_mutex);
 /* These macros may change in future, to provide better st_ino semantics. */
 #define OFFSET(x)	((x)->i_ino)
 
-static unsigned long cramino(struct cramfs_inode * cino, unsigned int offset)
+static unsigned long cramino(struct cramfs_inode *cino, unsigned int offset)
 {
 	if (!cino->offset)
 		return offset + 1;
@@ -61,7 +61,7 @@ static unsigned long cramino(struct cram
 }
 
 static struct inode *get_cramfs_inode(struct super_block *sb,
-	struct cramfs_inode * cramfs_inode, unsigned int offset)
+	struct cramfs_inode *cramfs_inode, unsigned int offset)
 {
 	struct inode *inode;
 	static struct timespec zerotime;
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
leds-add-output-inversion-option-to-backlight-trigger.patch
include-linux-kernelh-abs-fix-handling-of-32-bit-unsigneds-on-64-bit.patch
include-linux-unaligned-packed_structh-use-__packed.patch
ihex-fix-unused-return-value-compiler-warning.patch
kptr_restrict-for-hiding-kernel-pointers-from-unprivileged-users.patch
fs-select-fix-information-leak-to-userspace.patch
drivers-telephony-ixjc-fix-warning.patch
fs-proc-basec-kernel-latencytopc-convert-sprintf_symbol-to-%ps.patch
sysctl-remove-obsolete-comments.patch
user_ns-improve-the-user_ns-on-the-slab-packaging.patch
pps-add-parallel-port-pps-signal-generator.patch
memstick-factor-out-transfer-initiating-functionality-in-mspro_blockc.patch
aio-remove-unused-aio_run_iocbs.patch
cramfs-generate-unique-inode-number-for-better-inode-cache-usage.patch
ramoops-fix-types-remove-typecasts.patch
fs-ext4-inodec-use-pr_warn_ratelimited.patch

