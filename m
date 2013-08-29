From: akpm@linux-foundation.org
Subject: [merged]
 fs-ocfs2-superc-use-bigger-nodestr-to-accomodate-32-bit-node-numbers.patch
 removed from -mm tree
Date: Thu, 29 Aug 2013 12:43:05 -0700
Message-ID: <521fa449.a0WhKRegtoknB219%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:36298 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756935Ab3H2TnG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 29 Aug 2013 15:43:06 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, rgoldwyn@suse.com, mfasheh@suse.com, jlbec@evilplan.org, rgoldwyn@suse.de

Subject: [merged] fs-ocfs2-superc-use-bigger-nodestr-to-accomodate-32-bit-node-numbers.patch removed from -mm tree
To: rgoldwyn@suse.de,jlbec@evilplan.org,mfasheh@suse.com,rgoldwyn@suse.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Thu, 29 Aug 2013 12:43:05 -0700


The patch titled
     Subject: fs/ocfs2/super.c: Use bigger nodestr to accomodate 32-bit node numbers
has been removed from the -mm tree.  Its filename was
     fs-ocfs2-superc-use-bigger-nodestr-to-accomodate-32-bit-node-numbers.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Goldwyn Rodrigues <rgoldwyn@suse.de>
Subject: fs/ocfs2/super.c: Use bigger nodestr to accomodate 32-bit node numbers

While using pacemaker/corosync, the node numbers are generated using IP
address as opposed to serial node number generation.  This may not fit in
a 8-byte string.  Use a bigger string to print the complete node number.

Signed-off-by: Goldwyn Rodrigues <rgoldwyn@suse.com>
Cc: Mark Fasheh <mfasheh@suse.com>
Cc: Joel Becker <jlbec@evilplan.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/super.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/ocfs2/super.c~fs-ocfs2-superc-use-bigger-nodestr-to-accomodate-32-bit-node-numbers fs/ocfs2/super.c
--- a/fs/ocfs2/super.c~fs-ocfs2-superc-use-bigger-nodestr-to-accomodate-32-bit-node-numbers
+++ a/fs/ocfs2/super.c
@@ -1022,7 +1022,7 @@ static int ocfs2_fill_super(struct super
 	struct inode *inode = NULL;
 	struct ocfs2_super *osb = NULL;
 	struct buffer_head *bh = NULL;
-	char nodestr[8];
+	char nodestr[12];
 	struct ocfs2_blockcheck_stats stats;
 
 	trace_ocfs2_fill_super(sb, data, silent);
_

Patches currently in -mm which might be from rgoldwyn@suse.de are

origin.patch

