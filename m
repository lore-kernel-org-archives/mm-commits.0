From: akpm@linux-foundation.org
Subject: + hfsplus-implement-replay-journal-functionality-fix.patch added
 to -mm tree
Date: Wed, 05 Feb 2014 12:47:32 -0800
Message-ID: <52f2a364.OlauaX7sPKXH7GPe%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38201 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753841AbaBEUrd (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 5 Feb 2014 15:47:33 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, viro@zeniv.linux.org.uk, htl10@users.sourceforge.net, hch@infradead.org, slava@dubeyko.com

Subject: + hfsplus-implement-replay-journal-functionality-fix.patch added to -mm tree
To: slava@dubeyko.com,hch@infradead.org,htl10@users.sourceforge.net,viro@zeniv.linux.org.uk
From: akpm@linux-foundation.org
Date: Wed, 05 Feb 2014 12:47:32 -0800


The patch titled
     Subject: hfsplus: remove unnecessary duplication of cleanup in hfsplus_replay_journal() method
has been added to the -mm tree.  Its filename is
     hfsplus-implement-replay-journal-functionality-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/hfsplus-implement-replay-journal-functionality-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/hfsplus-implement-replay-journal-functionality-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
