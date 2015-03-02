From: akpm@linux-foundation.org
Subject: + ocfs2-fix-a-typing-error-in-ocfs2_direct_io_write.patch added
 to -mm tree
Date: Mon, 02 Mar 2015 11:07:29 -0800
Message-ID: <54f4b4f1.CDZC3s5Bj8mLZVDB%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:41837 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753590AbbCBTHa (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 2 Mar 2015 14:07:30 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joseph.qi@huawei.com, jlbec@evilplan.org, mfasheh@suse.com, mm-commits@vger.kernel.org


The patch titled
     Subject: ocfs2: fix a typing error in ocfs2_direct_IO_write
has been added to the -mm tree.  Its filename is
     ocfs2-fix-a-typing-error-in-ocfs2_direct_io_write.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/ocfs2-fix-a-typing-error-in-ocfs2_direct_io_write.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/ocfs2-fix-a-typing-error-in-ocfs2_direct_io_write.patch

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
Subject: ocfs2: fix a typing error in ocfs2_direct_IO_write

Only when direct IO succeeds we need consider zeroing out in case of
cluster not aligned.

Signed-off-by: Joseph Qi <joseph.qi@huawei.com>
Cc: Mark Fasheh <mfasheh@suse.com>
Cc: Joel Becker <jlbec@evilplan.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/aops.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/ocfs2/aops.c~ocfs2-fix-a-typing-error-in-ocfs2_direct_io_write fs/ocfs2/aops.c
--- a/fs/ocfs2/aops.c~ocfs2-fix-a-typing-error-in-ocfs2_direct_io_write
+++ a/fs/ocfs2/aops.c
@@ -771,7 +771,7 @@ static ssize_t ocfs2_direct_IO_write(str
 			if (ret < 0)
 				mlog_errno(ret);
 		}
-	} else if (written < 0 && append_write && !is_overwrite &&
+	} else if (written > 0 && append_write && !is_overwrite &&
 			!cluster_align) {
 		u32 p_cpos = 0;
 		u32 v_cpos = ocfs2_bytes_to_clusters(osb->sb, offset);
_

Patches currently in -mm which might be from joseph.qi@huawei.com are

ocfs2-make-append_dio-an-incompat-feature.patch
ocfs2-fix-a-typing-error-in-ocfs2_direct_io_write.patch
ocfs2-no-need-get-dinode-bh-when-zeroing-extend.patch
ocfs2-take-inode-lock-when-get-clusters.patch
ocfs2-do-not-use-ocfs2_zero_extend-during-direct-io.patch
ocfs2-avoid-access-invalid-address-when-read-o2dlm-debug-messages.patch
ocfs2-avoid-access-invalid-address-when-read-o2dlm-debug-messages-v3.patch

