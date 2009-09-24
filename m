From: akpm@linux-foundation.org
Subject: [merged] libfs-return-error-code-on-failed-attr-set.patch removed from -mm tree
Date: Thu, 24 Sep 2009 12:38:26 -0700
Message-ID: <200909241938.n8OJcQnv006630@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47838 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754546AbZIXTi6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 24 Sep 2009 15:38:58 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: fengguang.wu@intel.com, hch@lst.de, npiggin@suse.de, tytso@mit.edu, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     libfs: return error code on failed attr set
has been removed from the -mm tree.  Its filename was
     libfs-return-error-code-on-failed-attr-set.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: libfs: return error code on failed attr set
From: Wu Fengguang <fengguang.wu@intel.com>

Currently all simple_attr.set handlers return 0 on success and negative
codes on error.  Fix simple_attr_write() to return these error codes.

Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
Cc: Theodore Ts'o <tytso@mit.edu>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Nick Piggin <npiggin@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/libfs.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff -puN fs/libfs.c~libfs-return-error-code-on-failed-attr-set fs/libfs.c
--- a/fs/libfs.c~libfs-return-error-code-on-failed-attr-set
+++ a/fs/libfs.c
@@ -739,10 +739,11 @@ ssize_t simple_attr_write(struct file *f
 	if (copy_from_user(attr->set_buf, buf, size))
 		goto out;
 
-	ret = len; /* claim we got the whole input */
 	attr->set_buf[size] = '\0';
 	val = simple_strtol(attr->set_buf, NULL, 0);
-	attr->set(attr->data, val);
+	ret = attr->set(attr->data, val);
+	if (ret == 0)
+		ret = len; /* on success, claim we got the whole input */
 out:
 	mutex_unlock(&attr->mutex);
 	return ret;
_

Patches currently in -mm which might be from fengguang.wu@intel.com are

origin.patch
linux-next.patch
readahead-add-blk_run_backing_dev.patch
mm-vsmcan-check-shrink_active_list-sc-isolate_pages-return-value.patch
dev-mem-remove-redundant-test-on-len.patch
dev-mem-introduce-size_inside_page.patch
dev-mem-cleanup-unxlate_dev_mem_ptr-calls.patch
dev-mem-cleanup-unxlate_dev_mem_ptr-calls-fix.patch
dev-mem-cleanup-unxlate_dev_mem_ptr-calls-fix-fix.patch
dev-mem-make-size_inside_page-logic-straight.patch
dev-mem-remove-the-written-variable-in-write_kmem.patch
dev-mem-remove-the-written-variable-in-write_kmem-fix.patch
dev-mem-remove-redundant-parameter-from-do_write_kmem.patch

