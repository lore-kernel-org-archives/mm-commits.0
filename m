From: akpm@linux-foundation.org
Subject: +
 fs-befs-linuxvfsc-befs_get_block-remove-unneeded-initialization-to-null.patch added to -mm tree
Date: Tue, 10 May 2016 15:35:14 -0700
Message-ID: <57326222.6oXm+O0C/gbolNs0%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:60033 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751384AbcEJWfQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 10 May 2016 18:35:16 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: salah.triki@acm.org, mm-commits@vger.kernel.org


The patch titled
     Subject: fs/befs/linuxvfs.c:befs_get_block(): remove unneeded initialization to NULL
has been added to the -mm tree.  Its filename is
     fs-befs-linuxvfsc-befs_get_block-remove-unneeded-initialization-to-null.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/fs-befs-linuxvfsc-befs_get_block-remove-unneeded-initialization-to-null.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/fs-befs-linuxvfsc-befs_get_block-remove-unneeded-initialization-to-null.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Salah Triki <salah.triki@acm.org>
Subject: fs/befs/linuxvfs.c:befs_get_block(): remove unneeded initialization to NULL

inode is reinitialized by befs_iget() so no need to init it
with NULL in the beginning of befs_lookup()

Link: http://lkml.kernel.org/r/03d7e46890aef94078130bed97c4f8f8ae9ea2b2.1462842886.git.salah.triki@acm.org
Signed-off-by: Salah Triki <salah.triki@acm.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/befs/linuxvfs.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/befs/linuxvfs.c~fs-befs-linuxvfsc-befs_get_block-remove-unneeded-initialization-to-null fs/befs/linuxvfs.c
--- a/fs/befs/linuxvfs.c~fs-befs-linuxvfsc-befs_get_block-remove-unneeded-initialization-to-null
+++ a/fs/befs/linuxvfs.c
@@ -155,7 +155,7 @@ befs_get_block(struct inode *inode, sect
 static struct dentry *
 befs_lookup(struct inode *dir, struct dentry *dentry, unsigned int flags)
 {
-	struct inode *inode = NULL;
+	struct inode *inode;
 	struct super_block *sb = dir->i_sb;
 	befs_data_stream *ds = &BEFS_I(dir)->i_data.ds;
 	befs_off_t offset;
_

Patches currently in -mm which might be from salah.triki@acm.org are

fs-befs-datastreamc-befs_read_datastream-remove-unneeded-initialization-to-null.patch
fs-befs-datastreamc-befs_read_lsymlink-remove-unneeded-initialization-to-null.patch
fs-befs-datastreamc-befs_find_brun_dblindirect-remove-unneeded-initializations-to-null.patch
fs-befs-linuxvfsc-befs_get_block-remove-unneeded-initialization-to-null.patch
fs-befs-linuxvfsc-befs_iget-remove-unneeded-initialization-to-null.patch
fs-befs-linuxvfsc-befs_iget-remove-unneeded-raw_inode-initialization-to-null.patch
fs-befs-linuxvfsc-befs_iget-remove-unneeded-befs_nio-initialization-to-null.patch

