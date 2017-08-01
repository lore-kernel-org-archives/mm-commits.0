From: akpm@linux-foundation.org
Subject: + ocfs2-dont-clear-sgid-when-inheriting-acls.patch added to -mm
 tree
Date: Tue, 01 Aug 2017 13:47:31 -0700
Message-ID: <5980e8e3.H/+n7vskWmhBuShR%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:54054 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752359AbdHAUrc (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 1 Aug 2017 16:47:32 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jack@suse.cz, jiangqi903@gmail.com, jlbec@evilplan.org, junxiao.bi@oracle.com, mfasheh@versity.com, stable@vger.kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: ocfs2: don't clear SGID when inheriting ACLs
has been added to the -mm tree.  Its filename is
     ocfs2-dont-clear-sgid-when-inheriting-acls.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/ocfs2-dont-clear-sgid-when-inheriting-acls.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/ocfs2-dont-clear-sgid-when-inheriting-acls.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Jan Kara <jack@suse.cz>
Subject: ocfs2: don't clear SGID when inheriting ACLs

When new directory 'DIR1' is created in a directory 'DIR0' with SGID bit
set, DIR1 is expected to have SGID bit set (and owning group equal to the
owning group of 'DIR0').  However when 'DIR0' also has some default ACLs
that 'DIR1' inherits, setting these ACLs will result in SGID bit on 'DIR1'
to get cleared if user is not member of the owning group.

Fix the problem by moving posix_acl_update_mode() out of ocfs2_set_acl()
into ocfs2_iop_set_acl().  That way the function will not be called when
inheriting ACLs which is what we want as it prevents SGID bit clearing and
the mode has been properly set by posix_acl_create() anyway.  Also
posix_acl_chmod() that is calling ocfs2_set_acl() takes care of updating
mode itself.

Fixes: 073931017b4 ("posix_acl: Clear SGID bit when setting file permissions")
Link: http://lkml.kernel.org/r/20170801141252.19675-3-jack@suse.cz
Signed-off-by: Jan Kara <jack@suse.cz>
Cc: Mark Fasheh <mfasheh@versity.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Joseph Qi <jiangqi903@gmail.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/acl.c |   24 ++++++++++++------------
 1 file changed, 12 insertions(+), 12 deletions(-)

diff -puN fs/ocfs2/acl.c~ocfs2-dont-clear-sgid-when-inheriting-acls fs/ocfs2/acl.c
--- a/fs/ocfs2/acl.c~ocfs2-dont-clear-sgid-when-inheriting-acls
+++ a/fs/ocfs2/acl.c
@@ -240,18 +240,6 @@ static int ocfs2_set_acl(handle_t *handl
 	switch (type) {
 	case ACL_TYPE_ACCESS:
 		name_index = OCFS2_XATTR_INDEX_POSIX_ACL_ACCESS;
-		if (acl) {
-			umode_t mode;
-
-			ret = posix_acl_update_mode(inode, &mode, &acl);
-			if (ret)
-				return ret;
-
-			ret = ocfs2_acl_set_mode(inode, di_bh,
-						 handle, mode);
-			if (ret)
-				return ret;
-		}
 		break;
 	case ACL_TYPE_DEFAULT:
 		name_index = OCFS2_XATTR_INDEX_POSIX_ACL_DEFAULT;
@@ -289,7 +277,19 @@ int ocfs2_iop_set_acl(struct inode *inod
 	had_lock = ocfs2_inode_lock_tracker(inode, &bh, 1, &oh);
 	if (had_lock < 0)
 		return had_lock;
+	if (type == ACL_TYPE_ACCESS && acl) {
+		umode_t mode;
+
+		status = posix_acl_update_mode(inode, &mode, &acl);
+		if (status)
+			goto unlock;
+
+		status = ocfs2_acl_set_mode(inode, bh, NULL, mode);
+		if (status)
+			goto unlock;
+	}
 	status = ocfs2_set_acl(NULL, inode, bh, type, acl, NULL, NULL);
+unlock:
 	ocfs2_inode_unlock_tracker(inode, 1, &oh, had_lock);
 	brelse(bh);
 	return status;
_

Patches currently in -mm which might be from jack@suse.cz are

ocfs2-make-ocfs2_set_acl-static.patch
ocfs2-dont-clear-sgid-when-inheriting-acls.patch
fscache-remove-unused-now_uncached-callback.patch
mm-make-pagevec_lookup-update-index.patch
mm-implement-find_get_pages_range.patch
fs-fix-performance-regression-in-clean_bdev_aliases.patch
ext4-use-pagevec_lookup_range-in-ext4_find_unwritten_pgoff.patch
ext4-use-pagevec_lookup_range-in-writeback-code.patch
hugetlbfs-use-pagevec_lookup_range-in-remove_inode_hugepages.patch
fs-use-pagevec_lookup_range-in-page_cache_seek_hole_data.patch
mm-use-find_get_pages_range-in-filemap_range_has_page.patch
mm-remove-nr_pages-argument-from-pagevec_lookup_range.patch

