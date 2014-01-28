From: akpm@linux-foundation.org
Subject: [merged] splice-fix-unexpected-size-truncation.patch removed from -mm tree
Date: Tue, 28 Jan 2014 11:09:45 -0800
Message-ID: <52e80079.OzAYPnBqE8Txm8X6%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45538 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755562AbaA1TJp (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 28 Jan 2014 14:09:45 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, axboe@kernel.dk, xiaoguangrong@linux.vnet.ibm.com

Subject: [merged] splice-fix-unexpected-size-truncation.patch removed from -mm tree
To: xiaoguangrong@linux.vnet.ibm.com,axboe@kernel.dk,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Tue, 28 Jan 2014 11:09:45 -0800


The patch titled
     Subject: splice: fix unexpected size truncation
has been removed from the -mm tree.  Its filename was
     splice-fix-unexpected-size-truncation.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
Subject: splice: fix unexpected size truncation

@splice_desc.total_len is 32 bit(unsigned int) which is used to store the
size passed from userspace which is 64 bit(size_t) so that the size is
unexpectedly truncated

That means vmsplice can not work if the size passed from userspace is >=
4G, for example, we noticed in vmsplice, splice-reader does not do
anything and splice-writer is waiting for available buffer forever if the
size is 4G

Fix it by extending @splice_desc.total_len to 64 bits as well

Signed-off-by: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
Cc: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/splice.h |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN include/linux/splice.h~splice-fix-unexpected-size-truncation include/linux/splice.h
--- a/include/linux/splice.h~splice-fix-unexpected-size-truncation
+++ a/include/linux/splice.h
@@ -24,7 +24,8 @@
  * Passed to the actors
  */
 struct splice_desc {
-	unsigned int len, total_len;	/* current and remaining length */
+	size_t total_len;		/* remaining length */
+	unsigned int len;		/* current length */
 	unsigned int flags;		/* splice flags */
 	/*
 	 * actor() private data
_

Patches currently in -mm which might be from xiaoguangrong@linux.vnet.ibm.com are

origin.patch

