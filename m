From: akpm@linux-foundation.org
Subject: +
 fs-ocfs2-superc-use-bigger-nodestr-to-accomodate-32-bit-node-numbers.patch
 added to -mm tree
Date: Wed, 28 Aug 2013 14:48:55 -0700
Message-ID: <521e7047.Aela4XnfEYbN7cId%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:55000 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754122Ab3H1Vs4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 28 Aug 2013 17:48:56 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, rgoldwyn@suse.com, mfasheh@suse.com, jlbec@evilplan.org, rgoldwyn@suse.de

Subject: + fs-ocfs2-superc-use-bigger-nodestr-to-accomodate-32-bit-node-numbers.patch added to -mm tree
To: rgoldwyn@suse.de,jlbec@evilplan.org,mfasheh@suse.com,rgoldwyn@suse.com
From: akpm@linux-foundation.org
Date: Wed, 28 Aug 2013 14:48:55 -0700


The patch titled
     Subject: fs/ocfs2/super.c: Use bigger nodestr to accomodate 32-bit node numbers
has been added to the -mm tree.  Its filename is
     fs-ocfs2-superc-use-bigger-nodestr-to-accomodate-32-bit-node-numbers.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/fs-ocfs2-superc-use-bigger-nodestr-to-accomodate-32-bit-node-numbers.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/fs-ocfs2-superc-use-bigger-nodestr-to-accomodate-32-bit-node-numbers.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

fs-ocfs2-superc-use-bigger-nodestr-to-accomodate-32-bit-node-numbers.patch

