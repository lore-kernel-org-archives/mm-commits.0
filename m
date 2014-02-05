From: akpm@linux-foundation.org
Subject: [to-be-updated]
 hfsplus-implement-replay-journal-functionality-fix.patch removed from -mm
 tree
Date: Wed, 05 Feb 2014 15:49:25 -0800
Message-ID: <52f2ce05.ai2jDmmk8BRXYFCo%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:39236 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751525AbaBEXtZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 5 Feb 2014 18:49:25 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, viro@zeniv.linux.org.uk, htl10@users.sourceforge.net, hch@infradead.org, slava@dubeyko.com

Subject: [to-be-updated] hfsplus-implement-replay-journal-functionality-fix.patch removed from -mm tree
To: slava@dubeyko.com,hch@infradead.org,htl10@users.sourceforge.net,viro@zeniv.linux.org.uk,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Wed, 05 Feb 2014 15:49:25 -0800


The patch titled
     Subject: hfsplus: remove unnecessary duplication of cleanup in hfsplus_replay_journal() method
has been removed from the -mm tree.  Its filename was
     hfsplus-implement-replay-journal-functionality-fix.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Vyacheslav Dubeyko <slava@dubeyko.com>
Subject: hfsplus: remove unnecessary duplication of cleanup in hfsplus_replay_journal() method

Remove unnecessary duplication of cleanup in hfsplus_replay_journal()
method.

Signed-off-by: Vyacheslav Dubeyko <slava@dubeyko.com>
Cc: Hin-Tak Leung <htl10@users.sourceforge.net>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Christoph Hellwig <hch@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/hfsplus/journal.c |    7 -------
 1 file changed, 7 deletions(-)

diff -puN fs/hfsplus/journal.c~hfsplus-implement-replay-journal-functionality-fix fs/hfsplus/journal.c
--- a/fs/hfsplus/journal.c~hfsplus-implement-replay-journal-functionality-fix
+++ a/fs/hfsplus/journal.c
@@ -947,13 +947,6 @@ static int hfsplus_replay_journal(struct
 		err = -EIO;
 	}
 
-	if (unlikely(err))
-		goto failed_journal_replay;
-
-	mutex_unlock(&jnl->jnl_lock);
-	hfsplus_deinit_block_list_desc(&desc);
-	return 0;
