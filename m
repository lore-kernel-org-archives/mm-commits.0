From: akpm@linux-foundation.org
Subject: + befs-check-return-of-sb_min_blocksize.patch added to -mm tree
Date: Tue, 14 Jun 2016 16:10:28 -0700
Message-ID: <57608ee4.jrQ6wjHe/x0g72tG%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56572 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751289AbcFNXK3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 14 Jun 2016 19:10:29 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: luisbg@osg.samsung.com, mm-commits@vger.kernel.org


The patch titled
     Subject: befs: check return of sb_min_blocksize
has been added to the -mm tree.  Its filename is
     befs-check-return-of-sb_min_blocksize.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/befs-check-return-of-sb_min_blocksize.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/befs-check-return-of-sb_min_blocksize.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Luis de Bethencourt <luisbg@osg.samsung.com>
Subject: befs: check return of sb_min_blocksize

Confirm sb_min_blocksize() succeeded before continuing.

Link: http://lkml.kernel.org/r/1465700235-22881-1-git-send-email-luisbg@osg.samsung.com
Signed-off-by: Luis de Bethencourt <luisbg@osg.samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/befs/linuxvfs.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff -puN fs/befs/linuxvfs.c~befs-check-return-of-sb_min_blocksize fs/befs/linuxvfs.c
--- a/fs/befs/linuxvfs.c~befs-check-return-of-sb_min_blocksize
+++ a/fs/befs/linuxvfs.c
@@ -756,6 +756,7 @@ befs_fill_super(struct super_block *sb,
 	long ret = -EINVAL;
 	const unsigned long sb_block = 0;
 	const off_t x86_sb_off = 512;
+	int blocksize;
 
 	save_mount_options(sb, data);
 
@@ -788,7 +789,11 @@ befs_fill_super(struct super_block *sb,
 	 * least 1k to get the second 512 bytes of the volume.
 	 * -WD 10-26-01
 	 */ 
-	sb_min_blocksize(sb, 1024);
+	blocksize = sb_min_blocksize(sb, 1024);
+	if (!blocksize) {
+		befs_error(sb, "unable to set blocksize");
+		goto unacquire_priv_sbp;
+	}
 
 	if (!(bh = sb_bread(sb, sb_block))) {
 		if (!silent)
_

Patches currently in -mm which might be from luisbg@osg.samsung.com are

befs-check-return-of-sb_min_blocksize.patch
befs-fix-function-name-in-documentation.patch
befs-remove-unused-functions.patch

