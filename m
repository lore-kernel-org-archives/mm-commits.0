From: akpm@linux-foundation.org
Subject: - afs-write-back-dirty-data-on-unmount.patch removed from -mm tree
Date: Fri, 18 May 2007 00:05:51 -0700
Message-ID: <200705180705.l4I75oo2010127@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:48864 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755929AbXERHHi (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 18 May 2007 03:07:38 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dhowells@redhat.com, mm-commits@vger.kernel.org


The patch titled
     AFS: write back dirty data on unmount
has been removed from the -mm tree.  Its filename was
     afs-write-back-dirty-data-on-unmount.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: AFS: write back dirty data on unmount
From: David Howells <dhowells@redhat.com>

Fix AFS to write back dirty on unmounting.  This didn't happen because
afs_super_ops.drop_inode was pointing to generic_delete_inode.  Now this
pointer is left set to NULL so that the default behaviour occurs instead.

Signed-off-by: David Howells <dhowells@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/afs/super.c |    1 -
 1 file changed, 1 deletion(-)

diff -puN fs/afs/super.c~afs-write-back-dirty-data-on-unmount fs/afs/super.c
--- a/fs/afs/super.c~afs-write-back-dirty-data-on-unmount
+++ a/fs/afs/super.c
@@ -47,7 +47,6 @@ struct file_system_type afs_fs_type = {
 static const struct super_operations afs_super_ops = {
 	.statfs		= afs_statfs,
 	.alloc_inode	= afs_alloc_inode,
-	.drop_inode	= generic_delete_inode,
 	.write_inode	= afs_write_inode,
 	.destroy_inode	= afs_destroy_inode,
 	.clear_inode	= afs_clear_inode,
_

Patches currently in -mm which might be from dhowells@redhat.com are

origin.patch
revert-cancel_delayed_work-use-del_timer-instead-of-del_timer_sync.patch
nommu-present-backing-device-capabilities-for-mtd.patch
nommu-add-support-for-direct-mapping-through-mtdconcat.patch
nommu-generalise-the-handling-of-mtd-specific-superblocks.patch
nommu-make-it-possible-for-romfs-to-use-mtd-devices.patch
romfs-printk-format-warnings.patch
af_rxrpc-af_rxrpc-depends-on-ipv4.patch
af_rxrpc-make-call-state-names-available-if-config_proc_fs=n.patch
split-usermodehelper-setup-from-execution.patch
mutex-subsystem-synchro-test-module.patch
