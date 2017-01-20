From: akpm@linux-foundation.org
Subject: + fs-add-i_blocksize-fix.patch added to -mm tree
Date: Fri, 20 Jan 2017 14:53:26 -0800
Message-ID: <588294e6.ZfLS2+gdn8VMVmAz%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:37450 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752321AbdATWx2 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 20 Jan 2017 17:53:28 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: geliangtang@gmail.com, ross.zwisler@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: truncate: use i_blocksize()
has been added to the -mm tree.  Its filename is
     fs-add-i_blocksize-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/fs-add-i_blocksize-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/fs-add-i_blocksize-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Geliang Tang <geliangtang@gmail.com>
Subject: truncate: use i_blocksize()

Since i_blocksize() helper has been defined in fs.h, use it instead
of open-coding.

Link: http://lkml.kernel.org/r/9c8b2cd83c8f5653805d43debde9fa8817e02fc4.1484895804.git.geliangtang@gmail.com
Signed-off-by: Geliang Tang <geliangtang@gmail.com>
Reviewed-by: Ross Zwisler <ross.zwisler@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/truncate.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/truncate.c~fs-add-i_blocksize-fix mm/truncate.c
--- a/mm/truncate.c~fs-add-i_blocksize-fix
+++ a/mm/truncate.c
@@ -785,7 +785,7 @@ EXPORT_SYMBOL(truncate_setsize);
  */
 void pagecache_isize_extended(struct inode *inode, loff_t from, loff_t to)
 {
-	int bsize = 1 << inode->i_blkbits;
+	int bsize = i_blocksize(inode);
 	loff_t rounded_from;
 	struct page *page;
 	pgoff_t index;
_

Patches currently in -mm which might be from geliangtang@gmail.com are

mm-vmallocc-use-rb_entry_safe.patch
writeback-use-rb_entry.patch
proc-use-rb_entry.patch
timerqueue-use-rb_entry_safe.patch
fs-add-i_blocksize-fix.patch

