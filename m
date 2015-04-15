From: akpm@linux-foundation.org
Subject: [merged] ocfs2-fix-a-typing-error-in-ocfs2_direct_io_write.patch
 removed from -mm tree
Date: Wed, 15 Apr 2015 12:08:06 -0700
Message-ID: <552eb716.r07TopL6neAJIqI7%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:47819 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932249AbbDOTIG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 15 Apr 2015 15:08:06 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joseph.qi@huawei.com, jlbec@evilplan.org, mfasheh@suse.com, mm-commits@vger.kernel.org


The patch titled
     Subject: ocfs2: fix a typing error in ocfs2_direct_IO_write
has been removed from the -mm tree.  Its filename was
     ocfs2-fix-a-typing-error-in-ocfs2_direct_io_write.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

origin.patch
ocfs2-avoid-access-invalid-address-when-read-o2dlm-debug-messages.patch

