From: akpm@linux-foundation.org
Subject: +
 ocfs2-clean-up-unused-page-parameter-in-ocfs2_write_end_nolock.patch added
 to -mm tree
Date: Mon, 21 Nov 2016 20:53:39 -0800
Message-ID: <5833cf53.2jSVBuBDsDS4WGua%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:52382 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755024AbcKVExl (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 21 Nov 2016 23:53:41 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: piaojun@huawei.com, jiangqi903@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: ocfs2: clean up unused 'page' parameter in ocfs2_write_end_nolock()
has been added to the -mm tree.  Its filename is
     ocfs2-clean-up-unused-page-parameter-in-ocfs2_write_end_nolock.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/ocfs2-clean-up-unused-page-parameter-in-ocfs2_write_end_nolock.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/ocfs2-clean-up-unused-page-parameter-in-ocfs2_write_end_nolock.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: piaojun <piaojun@huawei.com>
Subject: ocfs2: clean up unused 'page' parameter in ocfs2_write_end_nolock()

'page' parameter in ocfs2_write_end_nolock() is never used.

Link: http://lkml.kernel.org/r/582FD91A.5000902@huawei.com
Signed-off-by: Jun Piao <piaojun@huawei.com>
Reviewed-by: Joseph Qi <jiangqi903@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/aops.c |    7 +++----
 fs/ocfs2/aops.h |    3 +--
 fs/ocfs2/mmap.c |    3 +--
 3 files changed, 5 insertions(+), 8 deletions(-)

diff -puN fs/ocfs2/aops.c~ocfs2-clean-up-unused-page-parameter-in-ocfs2_write_end_nolock fs/ocfs2/aops.c
--- a/fs/ocfs2/aops.c~ocfs2-clean-up-unused-page-parameter-in-ocfs2_write_end_nolock
+++ a/fs/ocfs2/aops.c
@@ -1950,8 +1950,7 @@ static void ocfs2_write_end_inline(struc
 }
 
 int ocfs2_write_end_nolock(struct address_space *mapping,
-			   loff_t pos, unsigned len, unsigned copied,
-			   struct page *page, void *fsdata)
+			   loff_t pos, unsigned len, unsigned copied, void *fsdata)
 {
 	int i, ret;
 	unsigned from, to, start = pos & (PAGE_SIZE - 1);
@@ -2064,7 +2063,7 @@ static int ocfs2_write_end(struct file *
 	int ret;
 	struct inode *inode = mapping->host;
 
-	ret = ocfs2_write_end_nolock(mapping, pos, len, copied, page, fsdata);
+	ret = ocfs2_write_end_nolock(mapping, pos, len, copied, fsdata);
 
 	up_write(&OCFS2_I(inode)->ip_alloc_sem);
 	ocfs2_inode_unlock(inode, 1);
@@ -2241,7 +2240,7 @@ static int ocfs2_dio_get_block(struct in
 		dwc->dw_zero_count++;
 	}
 
-	ret = ocfs2_write_end_nolock(inode->i_mapping, pos, len, len, NULL, wc);
+	ret = ocfs2_write_end_nolock(inode->i_mapping, pos, len, len, wc);
 	BUG_ON(ret != len);
 	ret = 0;
 unlock:
diff -puN fs/ocfs2/aops.h~ocfs2-clean-up-unused-page-parameter-in-ocfs2_write_end_nolock fs/ocfs2/aops.h
--- a/fs/ocfs2/aops.h~ocfs2-clean-up-unused-page-parameter-in-ocfs2_write_end_nolock
+++ a/fs/ocfs2/aops.h
@@ -44,8 +44,7 @@ int walk_page_buffers(	handle_t *handle,
 					struct buffer_head *bh));
 
 int ocfs2_write_end_nolock(struct address_space *mapping,
-			   loff_t pos, unsigned len, unsigned copied,
-			   struct page *page, void *fsdata);
+			   loff_t pos, unsigned len, unsigned copied, void *fsdata);
 
 typedef enum {
 	OCFS2_WRITE_BUFFER = 0,
diff -puN fs/ocfs2/mmap.c~ocfs2-clean-up-unused-page-parameter-in-ocfs2_write_end_nolock fs/ocfs2/mmap.c
--- a/fs/ocfs2/mmap.c~ocfs2-clean-up-unused-page-parameter-in-ocfs2_write_end_nolock
+++ a/fs/ocfs2/mmap.c
@@ -120,8 +120,7 @@ static int __ocfs2_page_mkwrite(struct f
 		ret = VM_FAULT_NOPAGE;
 		goto out;
 	}
-	ret = ocfs2_write_end_nolock(mapping, pos, len, len, locked_page,
-				     fsdata);
+	ret = ocfs2_write_end_nolock(mapping, pos, len, len, fsdata);
 	BUG_ON(ret != len);
 	ret = VM_FAULT_LOCKED;
 out:
_

Patches currently in -mm which might be from piaojun@huawei.com are

ocfs2-dlm-clean-up-useless-bug_on-default-case-in-dlm_finalize_reco_handler.patch
ocfs2-dlm-clean-up-deadcode-in-dlm_master_request_handler.patch
ocfs2-clean-up-unused-page-parameter-in-ocfs2_write_end_nolock.patch

