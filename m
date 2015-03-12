From: akpm@linux-foundation.org
Subject: +
 ocfs2-use-actual-name-length-when-find-entry-in-ocfs2_orphan_del.patch
 added to -mm tree
Date: Thu, 12 Mar 2015 16:20:13 -0700
Message-ID: <55021f2d.UqgLxJSp+7a8rhjK%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45697 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755415AbbCLXUO (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 12 Mar 2015 19:20:14 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joseph.qi@huawei.com, jiangyiwen@huawei.com, jlbec@evilplan.org, mfasheh@suse.com, mm-commits@vger.kernel.org


The patch titled
     Subject: ocfs2: use actual name length when find entry in ocfs2_orphan_del()
has been added to the -mm tree.  Its filename is
     ocfs2-use-actual-name-length-when-find-entry-in-ocfs2_orphan_del.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/ocfs2-use-actual-name-length-when-find-entry-in-ocfs2_orphan_del.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/ocfs2-use-actual-name-length-when-find-entry-in-ocfs2_orphan_del.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Joseph Qi <joseph.qi@huawei.com>
Subject: ocfs2: use actual name length when find entry in ocfs2_orphan_del()

If the namelen is 20 and name only has actual length 16, it will fail in
ocfs2_find_entry because of mismatch.  So use actual name length when find
entry.

Signed-off-by: Joseph Qi <joseph.qi@huawei.com>
Signed-off-by: Yiwen Jiang <jiangyiwen@huawei.com>
Cc: Mark Fasheh <mfasheh@suse.com>
Cc: Joel Becker <jlbec@evilplan.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/namei.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN fs/ocfs2/namei.c~ocfs2-use-actual-name-length-when-find-entry-in-ocfs2_orphan_del fs/ocfs2/namei.c
--- a/fs/ocfs2/namei.c~ocfs2-use-actual-name-length-when-find-entry-in-ocfs2_orphan_del
+++ a/fs/ocfs2/namei.c
@@ -2322,10 +2322,10 @@ int ocfs2_orphan_del(struct ocfs2_super
 
 	trace_ocfs2_orphan_del(
 	     (unsigned long long)OCFS2_I(orphan_dir_inode)->ip_blkno,
-	     name, namelen);
+	     name, strlen(name));
 
 	/* find it's spot in the orphan directory */
-	status = ocfs2_find_entry(name, namelen, orphan_dir_inode,
+	status = ocfs2_find_entry(name, strlen(name), orphan_dir_inode,
 				  &lookup);
 	if (status) {
 		mlog_errno(status);
_

Patches currently in -mm which might be from joseph.qi@huawei.com are

ocfs2-make-append_dio-an-incompat-feature.patch
ocfs2-fix-a-typing-error-in-ocfs2_direct_io_write.patch
ocfs2-no-need-get-dinode-bh-when-zeroing-extend.patch
ocfs2-take-inode-lock-when-get-clusters.patch
ocfs2-do-not-use-ocfs2_zero_extend-during-direct-io.patch
ocfs2-fix-typo-in-ocfs2_reserve_local_alloc_bits.patch
ocfs2-use-actual-name-length-when-find-entry-in-ocfs2_orphan_del.patch
ocfs2-avoid-access-invalid-address-when-read-o2dlm-debug-messages.patch
ocfs2-avoid-access-invalid-address-when-read-o2dlm-debug-messages-v3.patch

