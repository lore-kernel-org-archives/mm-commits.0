From: akpm@linux-foundation.org
Subject: + afs-write-back-dirty-data-on-unmount.patch added to -mm tree
Date: Tue, 15 May 2007 09:55:05 -0700
Message-ID: <200705151655.l4FGt41w012789@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:41738 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756438AbXEORDn (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 15 May 2007 13:03:43 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dhowells@redhat.com


The patch titled
     AFS: write back dirty data on unmount
has been added to the -mm tree.  Its filename is
     afs-write-back-dirty-data-on-unmount.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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

nommu-add-ioremap_page_range.patch
afs-write-back-dirty-data-on-unmount.patch
nommu-present-backing-device-capabilities-for-mtd.patch
nommu-add-support-for-direct-mapping-through-mtdconcat.patch
nommu-generalise-the-handling-of-mtd-specific-superblocks.patch
nommu-make-it-possible-for-romfs-to-use-mtd-devices.patch
romfs-printk-format-warnings.patch
af_rxrpc-af_rxrpc-depends-on-ipv4.patch
af_rxrpc-make-call-state-names-available-if-config_proc_fs=n.patch
remove-slab_ctor_constructor.patch
split-usermodehelper-setup-from-execution.patch
mutex-subsystem-synchro-test-module.patch
