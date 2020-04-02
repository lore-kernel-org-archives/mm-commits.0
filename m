From: Andrew Morton <akpm@linux-foundation.org>
Subject: [patch 012/155] ocfs2: remove useless err
Date: Wed, 01 Apr 2020 21:03:41 -0700
Message-ID: <20200402040341.Aw3N4w_ts%akpm@linux-foundation.org>
References: <20200401210155.09e3b9742e1c6e732f5a7250@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:48002 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728332AbgDBEDn (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 2 Apr 2020 00:03:43 -0400
In-Reply-To: <20200401210155.09e3b9742e1c6e732f5a7250@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, alex.shi@linux.alibaba.com, cg.chen@huawei.com, gregkh@linuxfoundation.org, jlbec@evilplan.org, joseph.qi@linux.alibaba.com, kstewart@linuxfoundation.org, linux-mm@kvack.org, mark@fasheh.com, mm-commits@vger.kernel.org, rfontana@redhat.com, tglx@linutronix.de, torvalds@linux-foundation.org

From: Alex Shi <alex.shi@linux.alibaba.com>
Subject: ocfs2: remove useless err

We don't need 'err' in these 2 places, better to remove them.

Link: http://lkml.kernel.org/r/1579577836-251879-1-git-send-email-alex.shi@linux.alibaba.com
Signed-off-by: Alex Shi <alex.shi@linux.alibaba.com>
Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: Mark Fasheh <mark@fasheh.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Kate Stewart <kstewart@linuxfoundation.org>
Cc: ChenGang <cg.chen@huawei.com>
Cc: Richard Fontana <rfontana@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/cluster/tcp.c |    3 +--
 fs/ocfs2/dir.c         |    4 ++--
 2 files changed, 3 insertions(+), 4 deletions(-)

--- a/fs/ocfs2/cluster/tcp.c~ocfs2-remove-useless-err
+++ a/fs/ocfs2/cluster/tcp.c
@@ -1948,7 +1948,6 @@ static void o2net_accept_many(struct wor
 {
 	struct socket *sock = o2net_listen_sock;
 	int	more;
-	int	err;
 
 	/*
 	 * It is critical to note that due to interrupt moderation
@@ -1963,7 +1962,7 @@ static void o2net_accept_many(struct wor
 	 */
 
 	for (;;) {
-		err = o2net_accept_one(sock, &more);
+		o2net_accept_one(sock, &more);
 		if (!more)
 			break;
 		cond_resched();
--- a/fs/ocfs2/dir.c~ocfs2-remove-useless-err
+++ a/fs/ocfs2/dir.c
@@ -676,7 +676,7 @@ static struct buffer_head *ocfs2_find_en
 	int ra_ptr = 0;		/* Current index into readahead
 				   buffer */
 	int num = 0;
-	int nblocks, i, err;
+	int nblocks, i;
 
 	sb = dir->i_sb;
 
@@ -708,7 +708,7 @@ restart:
 				num++;
 
 				bh = NULL;
-				err = ocfs2_read_dir_block(dir, b++, &bh,
+				ocfs2_read_dir_block(dir, b++, &bh,
 							   OCFS2_BH_READAHEAD);
 				bh_use[ra_max] = bh;
 			}
_
