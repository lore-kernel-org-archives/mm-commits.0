From: akpm@linux-foundation.org
Subject: +
 ocfs2_direct_io_write-misses-ocfs2_is_overwrite-error-code.patch added to
 -mm tree
Date: Fri, 11 Sep 2015 14:20:59 -0700
Message-ID: <55f345bb.qQQ70D0bpeUXCnz5%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:44984 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752735AbbIKVVA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 11 Sep 2015 17:21:00 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: norton.zhu@huawei.com, jlbec@evilplan.org, mfasheh@suse.de, mm-commits@vger.kernel.org


The patch titled
     Subject: ocfs2_direct_IO_write() misses ocfs2_is_overwrite() error code
has been added to the -mm tree.  Its filename is
     ocfs2_direct_io_write-misses-ocfs2_is_overwrite-error-code.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/ocfs2_direct_io_write-misses-ocfs2_is_overwrite-error-code.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/ocfs2_direct_io_write-misses-ocfs2_is_overwrite-error-code.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: "Norton.Zhu" <norton.zhu@huawei.com>
Subject: ocfs2_direct_IO_write() misses ocfs2_is_overwrite() error code

If ocfs2_is_overwrite failed, ocfs2_direct_IO_write mays till return
success to the caller.

Signed-off-by: Norton.Zhu <norton.zhu@huawei.com>
Cc: Mark Fasheh <mfasheh@suse.de>
Cc: Joel Becker <jlbec@evilplan.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/aops.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN fs/ocfs2/aops.c~ocfs2_direct_io_write-misses-ocfs2_is_overwrite-error-code fs/ocfs2/aops.c
--- a/fs/ocfs2/aops.c~ocfs2_direct_io_write-misses-ocfs2_is_overwrite-error-code
+++ a/fs/ocfs2/aops.c
@@ -864,6 +864,7 @@ static ssize_t ocfs2_direct_IO_write(str
 		is_overwrite = ocfs2_is_overwrite(osb, inode, offset);
 		if (is_overwrite < 0) {
 			mlog_errno(is_overwrite);
+			ret = is_overwrite;
 			ocfs2_inode_unlock(inode, 1);
 			goto clean_orphan;
 		}
_

Patches currently in -mm which might be from norton.zhu@huawei.com are

ocfs2_direct_io_write-misses-ocfs2_is_overwrite-error-code.patch

