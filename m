From: akpm@linux-foundation.org
Subject: [merged] ocfs2-use-swap-in-ocfs2_double_lock.patch removed from
 -mm tree
Date: Mon, 29 Jun 2015 13:36:53 -0700
Message-ID: <5591ac65.0H2t7JAAxnymwzs6%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50182 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752434AbbF2Ugy (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 29 Jun 2015 16:36:54 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: fabf@skynet.be, jlbec@evilplan.org, julia.lawall@lip6.fr, mfasheh@suse.com, mm-commits@vger.kernel.org


The patch titled
     Subject: ocfs2: use swap() in ocfs2_double_lock()
has been removed from the -mm tree.  Its filename was
     ocfs2-use-swap-in-ocfs2_double_lock.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Fabian Frederick <fabf@skynet.be>
Subject: ocfs2: use swap() in ocfs2_double_lock()

Use kernel.h macro definition.

Thanks to Julia Lawall for Coccinelle scripting support.

Signed-off-by: Fabian Frederick <fabf@skynet.be>
Cc: Julia Lawall <julia.lawall@lip6.fr>
Cc: Mark Fasheh <mfasheh@suse.com>
Cc: Joel Becker <jlbec@evilplan.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/namei.c |   11 ++---------
 1 file changed, 2 insertions(+), 9 deletions(-)

diff -puN fs/ocfs2/namei.c~ocfs2-use-swap-in-ocfs2_double_lock fs/ocfs2/namei.c
--- a/fs/ocfs2/namei.c~ocfs2-use-swap-in-ocfs2_double_lock
+++ a/fs/ocfs2/namei.c
@@ -1116,8 +1116,6 @@ static int ocfs2_double_lock(struct ocfs
 	int inode1_is_ancestor, inode2_is_ancestor;
 	struct ocfs2_inode_info *oi1 = OCFS2_I(inode1);
 	struct ocfs2_inode_info *oi2 = OCFS2_I(inode2);
-	struct buffer_head **tmpbh;
-	struct inode *tmpinode;
 
 	trace_ocfs2_double_lock((unsigned long long)oi1->ip_blkno,
 				(unsigned long long)oi2->ip_blkno);
@@ -1148,13 +1146,8 @@ static int ocfs2_double_lock(struct ocfs
 				(oi1->ip_blkno < oi2->ip_blkno &&
 				inode2_is_ancestor == 0)) {
 			/* switch id1 and id2 around */
-			tmpbh = bh2;
-			bh2 = bh1;
-			bh1 = tmpbh;
