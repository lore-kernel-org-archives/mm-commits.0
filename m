From: akpm@linux-foundation.org
Subject: [merged]
 linux-pipe_fs_ih-fix-kernel-doc-warnings-after-wait-was-split.patch removed
 from -mm tree
Date: Thu, 13 Feb 2020 18:15:16 -0800
Message-ID: <20200214021516.BxrJ2Nu1K%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:55070 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728154AbgBNCPS (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 13 Feb 2020 21:15:18 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, rdunlap@infradead.org


The patch titled
     Subject: linux/pipe_fs_i.h: fix kernel-doc warnings after @wait was split
has been removed from the -mm tree.  Its filename was
     linux-pipe_fs_ih-fix-kernel-doc-warnings-after-wait-was-split.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Randy Dunlap <rdunlap@infradead.org>
Subject: linux/pipe_fs_i.h: fix kernel-doc warnings after @wait was split

Fix kernel-doc warnings in struct pipe_inode_info after @wait was split
into @rd_wait and @wr_wait.

../include/linux/pipe_fs_i.h:66: warning: Function parameter or member 'rd_wait' not described in 'pipe_inode_info'
../include/linux/pipe_fs_i.h:66: warning: Function parameter or member 'wr_wait' not described in 'pipe_inode_info'

Link: http://lkml.kernel.org/r/0956ab21-9b9a-4d1e-fe43-b853d1602781@infradead.org
Fixes: 0ddad21d3e99 ("pipe: use exclusive waits when reading or writing")
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/pipe_fs_i.h |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/include/linux/pipe_fs_i.h~linux-pipe_fs_ih-fix-kernel-doc-warnings-after-wait-was-split
+++ a/include/linux/pipe_fs_i.h
@@ -29,7 +29,8 @@ struct pipe_buffer {
 /**
  *	struct pipe_inode_info - a linux kernel pipe
  *	@mutex: mutex protecting the whole thing
- *	@wait: reader/writer wait point in case of empty/full pipe
+ *	@rd_wait: reader wait point in case of empty pipe
+ *	@wr_wait: writer wait point in case of full pipe
  *	@head: The point of buffer production
  *	@tail: The point of buffer consumption
  *	@max_usage: The maximum number of slots that may be used in the ring
_

Patches currently in -mm which might be from rdunlap@infradead.org are
