From: akpm@linux-foundation.org
Subject: + ncpfs-inode-fix-mismatch-printk-formats-and-arguments.patch
 added to -mm tree
Date: Mon, 10 Feb 2014 16:16:15 -0800
Message-ID: <52f96bcf.104mO0VrEGd4Kew5%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:59983 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753083AbaBKAQQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 10 Feb 2014 19:16:16 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, petr@vandrovec.name, joe@perches.com

Subject: + ncpfs-inode-fix-mismatch-printk-formats-and-arguments.patch added to -mm tree
To: joe@perches.com,petr@vandrovec.name
From: akpm@linux-foundation.org
Date: Mon, 10 Feb 2014 16:16:15 -0800


The patch titled
     Subject: ncpfs/inode.c: fix mismatch printk formats and arguments
has been added to the -mm tree.  Its filename is
     ncpfs-inode-fix-mismatch-printk-formats-and-arguments.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/ncpfs-inode-fix-mismatch-printk-formats-and-arguments.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/ncpfs-inode-fix-mismatch-printk-formats-and-arguments.patch

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
@@ -682,7 +682,7 @@ static int ncp_fill_super(struct super_b
 	ncp_unlock_server(server);
 	if (error < 0)
 		goto out_rxbuf;
-	ncp_dbg(1, "NCP_SBP(sb) = %x\n", (int) NCP_SBP(sb));
+	ncp_dbg(1, "NCP_SBP(sb) = %p\n", NCP_SBP(sb));
 
 	error = -EMSGSIZE;	/* -EREMOTESIDEINCOMPATIBLE */
 #ifdef CONFIG_NCPFS_PACKET_SIGNING
@@ -985,7 +985,7 @@ int ncp_notify_change(struct dentry *den
 	if ((attr->ia_valid & ATTR_SIZE) != 0) {
 		int written;
 
-		ncp_dbg(1, "trying to change size to %ld\n", attr->ia_size);
+		ncp_dbg(1, "trying to change size to %llu\n", attr->ia_size);
 
 		if ((result = ncp_make_open(inode, O_WRONLY)) < 0) {
 			result = -EACCES;
_

Patches currently in -mm which might be from joe@perches.com are

get_maintainer-fix-detection-of-git-repository.patch
checkpatch-fix-detection-of-git-repository.patch
mm-utilc-add-kstrimdup.patch
checkpatch-add-test-for-long-udelay.patch
checkpatch-dont-warn-on-some-function-pointer-return-styles.patch
ncpfs-add-pr_fmt-and-convert-printks-to-pr_level.patch
ncpfs-convert-dprintk-ddprintk-to-ncp_dbg.patch
ncpfs-convert-dprintk-ddprintk-to-ncp_dbg-fix.patch
ncpfs-convert-pprintk-to-ncp_vdbg.patch
ncpfs-remove-now-unused-printk-macro.patch
ncpfs-inode-fix-mismatch-printk-formats-and-arguments.patch
linux-next.patch

