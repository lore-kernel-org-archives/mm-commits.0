From: akpm@linux-foundation.org
Subject: + ocfs2-fix-ocfs2_sync_file-if-filesystem-is-readonly.patch added to -mm tree
Date: Fri, 24 Jan 2014 14:32:32 -0800
Message-ID: <52e2ea00.c+bennU++Ecp+hOq%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45383 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751562AbaAXWcd (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 24 Jan 2014 17:32:33 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, mfasheh@suse.com, jlbec@evilplan.org, younger.liucn@gmail.com

Subject: + ocfs2-fix-ocfs2_sync_file-if-filesystem-is-readonly.patch added to -mm tree
To: younger.liucn@gmail.com,jlbec@evilplan.org,mfasheh@suse.com
From: akpm@linux-foundation.org
Date: Fri, 24 Jan 2014 14:32:32 -0800


The patch titled
     Subject: ocfs2: fix ocfs2_sync_file() if filesystem is readonly
has been added to the -mm tree.  Its filename is
     ocfs2-fix-ocfs2_sync_file-if-filesystem-is-readonly.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/ocfs2-fix-ocfs2_sync_file-if-filesystem-is-readonly.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/ocfs2-fix-ocfs2_sync_file-if-filesystem-is-readonly.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Younger Liu <younger.liucn@gmail.com>
Subject: ocfs2: fix ocfs2_sync_file() if filesystem is readonly

If filesystem is readonly, there is no need to flush drive's caches or
force any uncommitted transactions.

Signed-off-by: Younger Liu <younger.liucn@gmail.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Mark Fasheh <mfasheh@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/file.c |    3 +++
 1 file changed, 3 insertions(+)

diff -puN fs/ocfs2/file.c~ocfs2-fix-ocfs2_sync_file-if-filesystem-is-readonly fs/ocfs2/file.c
--- a/fs/ocfs2/file.c~ocfs2-fix-ocfs2_sync_file-if-filesystem-is-readonly
+++ a/fs/ocfs2/file.c
@@ -185,6 +185,9 @@ static int ocfs2_sync_file(struct file *
 			      file->f_path.dentry->d_name.name,
 			      (unsigned long long)datasync);
 
+	if (ocfs2_is_hard_readonly(osb) || ocfs2_is_soft_readonly(osb))
+		return 0;
+
 	err = filemap_write_and_wait_range(inode->i_mapping, start, end);
 	if (err)
 		return err;
_

Patches currently in -mm which might be from younger.liucn@gmail.com are

origin.patch
ocfs2-fix-ocfs2_sync_file-if-filesystem-is-readonly.patch
ocfs2-fix-ocfs2_sync_file-if-filesystem-is-readonly-fix.patch

