From: akpm@linux-foundation.org
Subject: [merged]
 ncpfs-inode-fix-mismatch-printk-formats-and-arguments.patch removed from
 -mm tree
Date: Wed, 09 Apr 2014 10:55:45 -0700
Message-ID: <534589a1.KKm0fg33eoaqEYuk%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:36960 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933984AbaDIRzp (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 9 Apr 2014 13:55:45 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, petr@vandrovec.name, joe@perches.com

Subject: [merged] ncpfs-inode-fix-mismatch-printk-formats-and-arguments.patch removed from -mm tree
To: joe@perches.com,petr@vandrovec.name,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Wed, 09 Apr 2014 10:55:45 -0700


The patch titled
     Subject: ncpfs/inode.c: fix mismatch printk formats and arguments
has been removed from the -mm tree.  Its filename was
     ncpfs-inode-fix-mismatch-printk-formats-and-arguments.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Joe Perches <joe@perches.com>
Subject: ncpfs/inode.c: fix mismatch printk formats and arguments

Conversions to ncp_dbg showed some format/argument mismatches
so fix them.

Signed-off-by: Joe Perches <joe@perches.com>
Cc: Petr Vandrovec <petr@vandrovec.name>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ncpfs/inode.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN fs/ncpfs/inode.c~ncpfs-inode-fix-mismatch-printk-formats-and-arguments fs/ncpfs/inode.c
--- a/fs/ncpfs/inode.c~ncpfs-inode-fix-mismatch-printk-formats-and-arguments
+++ a/fs/ncpfs/inode.c
@@ -683,7 +683,7 @@ static int ncp_fill_super(struct super_b
 	ncp_unlock_server(server);
 	if (error < 0)
 		goto out_rxbuf;
-	ncp_dbg(1, "NCP_SBP(sb) = %x\n", (int) NCP_SBP(sb));
+	ncp_dbg(1, "NCP_SBP(sb) = %p\n", NCP_SBP(sb));
 
 	error = -EMSGSIZE;	/* -EREMOTESIDEINCOMPATIBLE */
 #ifdef CONFIG_NCPFS_PACKET_SIGNING
@@ -986,7 +986,7 @@ int ncp_notify_change(struct dentry *den
 	if ((attr->ia_valid & ATTR_SIZE) != 0) {
 		int written;
 
-		ncp_dbg(1, "trying to change size to %ld\n", attr->ia_size);
+		ncp_dbg(1, "trying to change size to %llu\n", attr->ia_size);
 
 		if ((result = ncp_make_open(inode, O_WRONLY)) < 0) {
 			result = -EACCES;
_

Patches currently in -mm which might be from joe@perches.com are

origin.patch
mm-utilc-add-kstrimdup.patch
checkpatch-always-warn-on-missing-blank-line-after-variable-declaration-block.patch
checkpatch-reduce-false-positives-for-missing-blank-line-after-declarations-test.patch
checkpatch-reduce-false-positives-for-missing-blank-line-after-declarations-test-fix.patch
linux-next.patch

