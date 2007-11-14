From: akpm@linux-foundation.org
Subject: + iget-stop-bfs-from-using-iget-and-read_inode-try-fix.patch added to -mm tree
Date: Tue, 13 Nov 2007 21:24:39 -0800
Message-ID: <200711140524.lAE5Odo5023016@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:46027 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751020AbXKNFaH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 14 Nov 2007 00:30:07 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: kamalesh@linux.vnet.ibm.com


The patch titled
     Build Fail - fs/bfs/inode.c
has been added to the -mm tree.  Its filename is
     iget-stop-bfs-from-using-iget-and-read_inode-try-fix.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Build Fail - fs/bfs/inode.c
From: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>

fs/bfs/inode.c: In function `bfs_iget':
fs/bfs/inode.c:37: error: `ino' redeclared as different kind of symbol
fs/bfs/inode.c:35: error: previous definition of `ino' was here
fs/bfs/inode.c:37: error: `inode' undeclared (first use in this function)
fs/bfs/inode.c:37: error: (Each undeclared identifier is reported onlyonce
fs/bfs/inode.c:37: error: for each function it appears in.)

Signed-off-by: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/bfs/inode.c |    1 -
 1 file changed, 1 deletion(-)

diff -puN fs/bfs/inode.c~iget-stop-bfs-from-using-iget-and-read_inode-try-fix fs/bfs/inode.c
--- a/fs/bfs/inode.c~iget-stop-bfs-from-using-iget-and-read_inode-try-fix
+++ a/fs/bfs/inode.c
@@ -34,7 +34,6 @@ void dump_imap(const char *prefix, struc
 
 struct inode *bfs_iget(struct super_block *sb, unsigned long ino)
 {
-	unsigned long ino = inode->i_ino;
 	struct bfs_inode *di;
 	struct inode *inode;
 	struct buffer_head *bh;
_

Patches currently in -mm which might be from kamalesh@linux.vnet.ibm.com are

chipsfb-uses-depends-on-pci.patch
export-acpi_check_resource_conflict.patch
fix-gregkh-driver-kobject-clean-up-rpadlpar-horrid-sysfs-abuse.patch
config_highpte-vs-sub-page-page-tables-fix.patch
nfsd-fix-wrong-mnt_writer-count-in-rename-fix.patch
iget-stop-bfs-from-using-iget-and-read_inode-try-fix.patch
add-dma-engine-driver-for-freescale-mpc85xx-processors-fix.patch
