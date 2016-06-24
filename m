From: akpm@linux-foundation.org
Subject: [patch 35/41] ocfs2: disable BUG assertions in reading blocks
Date: Fri, 24 Jun 2016 14:50:13 -0700
Message-ID: <576dab15.EkEUZTA51ow3NYCD%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:41102 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751487AbcFXVuO (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 24 Jun 2016 17:50:14 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, ghe@suse.com, jlbec@evilplan.org, joseph.qi@huawei.com, junxiao.bi@oracle.com, mfasheh@suse.de

From: Gang He <ghe@suse.com>
Subject: ocfs2: disable BUG assertions in reading blocks

According to some high-load testing, these two BUG assertions were
encountered, this led system panic.  Actually, there were some discussions
about removing these two BUG() assertions, it would not bring any side
effect.

Then, I did the the following changes,

1) use the existing macro CATCH_BH_JBD_RACES to wrap BUG() in the
   ocfs2_read_blocks_sync function like before.

2) disable the macro CATCH_BH_JBD_RACES in Makefile by default.

Link: http://lkml.kernel.org/r/1466574294-26863-1-git-send-email-ghe@suse.com
Signed-off-by: Gang He <ghe@suse.com>
Cc: Mark Fasheh <mfasheh@suse.de>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Joseph Qi <joseph.qi@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/Makefile         |    2 --
 fs/ocfs2/buffer_head_io.c |    5 +++++
 2 files changed, 5 insertions(+), 2 deletions(-)

diff -puN fs/ocfs2/Makefile~ocfs2-disable-bug-assertions-in-reading-blocks fs/ocfs2/Makefile
--- a/fs/ocfs2/Makefile~ocfs2-disable-bug-assertions-in-reading-blocks
+++ a/fs/ocfs2/Makefile
@@ -1,7 +1,5 @@
 ccflags-y := -Ifs/ocfs2
 
-ccflags-y += -DCATCH_BH_JBD_RACES
