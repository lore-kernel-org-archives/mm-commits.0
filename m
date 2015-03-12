From: akpm@linux-foundation.org
Subject: + fs-hfsplus-replace-if-bug-by-bug_on.patch added to -mm tree
Date: Thu, 12 Mar 2015 15:40:59 -0700
Message-ID: <550215fb.+voFNe4k4cQotAOG%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45045 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751009AbbCLWlA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 12 Mar 2015 18:41:00 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: fabf@skynet.be, mm-commits@vger.kernel.org


The patch titled
     Subject: fs/hfsplus: replace if/BUG by BUG_ON
has been added to the -mm tree.  Its filename is
     fs-hfsplus-replace-if-bug-by-bug_on.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/fs-hfsplus-replace-if-bug-by-bug_on.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/fs-hfsplus-replace-if-bug-by-bug_on.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Fabian Frederick <fabf@skynet.be>
Subject: fs/hfsplus: replace if/BUG by BUG_ON

Signed-off-by: Fabian Frederick <fabf@skynet.be>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/hfsplus/bfind.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff -puN fs/hfsplus/bfind.c~fs-hfsplus-replace-if-bug-by-bug_on fs/hfsplus/bfind.c
--- a/fs/hfsplus/bfind.c~fs-hfsplus-replace-if-bug-by-bug_on
+++ a/fs/hfsplus/bfind.c
@@ -118,9 +118,7 @@ int __hfs_brec_find(struct hfs_bnode *bn
 	int b, e;
 	int res;
 
-	if (!rec_found)
-		BUG();
