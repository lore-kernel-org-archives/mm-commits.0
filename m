From: akpm@linux-foundation.org
Subject: [folded-merged] hfsplus-rework-processing-of-hfs_btree_write-returned-error-fix.patch removed from -mm tree
Date: Tue, 18 Dec 2012 14:43:09 -0800
Message-ID: <20121218224309.81647100047@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ye0-f202.google.com ([209.85.213.202]:41856 "EHLO
	mail-ye0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751228Ab2LRWnK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 18 Dec 2012 17:43:10 -0500
Received: by mail-ye0-f202.google.com with SMTP id l7so148380yen.5
        for <mm-commits@vger.kernel.org>; Tue, 18 Dec 2012 14:43:10 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, hch@infradead.org, htl10@users.sourceforge.net, slava@dubeyko.com, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     Subject: hfsplus-rework-processing-of-hfs_btree_write-returned-error-fix
has been removed from the -mm tree.  Its filename was
     hfsplus-rework-processing-of-hfs_btree_write-returned-error-fix.patch

This patch was dropped because it was folded into hfsplus-rework-processing-of-hfs_btree_write-returned-error.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: hfsplus-rework-processing-of-hfs_btree_write-returned-error-fix

reduce scope of `err', print errno on error

Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Hin-Tak Leung <htl10@users.sourceforge.net>
Cc: Vyacheslav Dubeyko <slava@dubeyko.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/hfsplus/super.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN fs/hfsplus/super.c~hfsplus-rework-processing-of-hfs_btree_write-returned-error-fix fs/hfsplus/super.c
--- a/fs/hfsplus/super.c~hfsplus-rework-processing-of-hfs_btree_write-returned-error-fix
+++ a/fs/hfsplus/super.c
@@ -100,7 +100,6 @@ static int hfsplus_system_write_inode(st
 	struct hfsplus_vh *vhdr = sbi->s_vhdr;
 	struct hfsplus_fork_raw *fork;
 	struct hfs_btree *tree = NULL;
-	int err;
 
 	switch (inode->i_ino) {
 	case HFSPLUS_EXT_CNID:
@@ -131,9 +130,10 @@ static int hfsplus_system_write_inode(st
 	}
 	hfsplus_inode_write_fork(inode, fork);
 	if (tree) {
-		err = hfs_btree_write(tree);
+		int err = hfs_btree_write(tree);
 		if (err) {
-			printk(KERN_ERR "hfs: unable to write b-tree\n");
+			printk(KERN_ERR "hfs: unable to write b-tree: %d\n",
+				err);
 			dprint(DBG_INODE, "hfsplus_system_write_inode: %lu\n",
 				inode->i_ino);
 			return err;
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
arch-x86-platform-iris-irisc-register-a-platform-device-and-a-platform-driver.patch
irq-tsk-comm-is-an-array.patch
memory-hotplug-document-and-enable-config_movable_node.patch
memcg-kmem-accounting-basic-infrastructure.patch
slub-slub-specific-propagation-changes.patch
mm-mprotectc-coding-style-cleanups.patch
mm-hugetlb-create-hugetlb-cgroup-file-in-hugetlb_init.patch
mm-avoid-possible-deadlock-caused-by-too_many_isolated.patch
linux-next.patch
linux-next-rejects.patch
linux-next-git-rejects.patch
make-my-i386-build-work.patch
i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
sgi-xp-handle-non-fatal-traps-fix.patch
arch-x86-tools-insn_sanityc-identify-source-of-messages.patch
fb-rework-locking-to-fix-lock-ordering-on-takeover-fix.patch
fb-rework-locking-to-fix-lock-ordering-on-takeover-fix-2.patch
block-remove-deadlock-in-disk_clear_events.patch
block-prevent-race-cleanup.patch
mm.patch
drop_caches-add-some-documentation-and-info-messsge-checkpatch-fixes.patch
swap-add-a-simple-detector-for-inappropriate-swapin-readahead-fix.patch
memcg-debugging-facility-to-access-dangling-memcgs-fix.patch
scripts-pnmtologo-fix-for-plain-pbm-checkpatch-fixes.patch
drivers-firmware-dmi_scanc-check-dmi-version-when-get-system-uuid-fix.patch
drivers-firmware-dmi_scanc-fetch-dmi-version-from-smbios-if-it-exists-checkpatch-fixes.patch
binfmt_elfc-use-get_random_int-to-fix-entropy-depleting.patch
hfsplus-add-osx-prefix-for-handling-namespace-of-mac-os-x-extended-attributes.patch
hfsplus-rework-processing-of-hfs_btree_write-returned-error.patch
ipc-add-sysctl-to-specify-desired-next-object-id-checkpatch-fixes.patch
ipc-message-queue-receive-cleanup-checkpatch-fixes.patch
ipc-convert-prepare_copy-from-macro-to-function-fix.patch
dma-debug-new-interfaces-to-debug-dma-mapping-errors-fix-fix.patch
fs-notify-add-procfs-fdinfo-helper-v7-fix.patch
journal_add_journal_head-debug.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mutex-subsystem-synchro-test-module-fix.patch
slab-leaks3-default-y.patch
put_bh-debug.patch

