From: Andrew Morton <akpm@linux-foundation.org>
Subject: +
 linux-pipe_fs_ih-fix-kernel-doc-warnings-after-wait-was-split.patch added
 to -mm tree
Date: Sun, 09 Feb 2020 20:00:47 -0800
Message-ID: <20200210040047.pRU1vr6s9%akpm@linux-foundation.org>
References: <20200203173311.6269a8be06a05e5a4aa08a93@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:36222 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727029AbgBJEAs (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sun, 9 Feb 2020 23:00:48 -0500
In-Reply-To: <20200203173311.6269a8be06a05e5a4aa08a93@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, rdunlap@infradead.org


The patch titled
     Subject: linux/pipe_fs_i.h: fix kernel-doc warnings after @wait was split
has been added to the -mm tree.  Its filename is
     linux-pipe_fs_ih-fix-kernel-doc-warnings-after-wait-was-split.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/linux-pipe_fs_ih-fix-kernel-doc-warnings-after-wait-was-split.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/linux-pipe_fs_ih-fix-kernel-doc-warnings-after-wait-was-split.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

linux-pipe_fs_ih-fix-kernel-doc-warnings-after-wait-was-split.patch
