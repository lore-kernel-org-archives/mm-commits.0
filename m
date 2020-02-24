From: Andrew Morton <akpm@linux-foundation.org>
Subject: + ocfs2-remove-useless-err.patch added to -mm tree
Date: Mon, 24 Feb 2020 15:44:38 -0800
Message-ID: <20200224234438.CxpKQBDcS%akpm@linux-foundation.org>
References: <20200203173311.6269a8be06a05e5a4aa08a93@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:60812 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727081AbgBXXol (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 24 Feb 2020 18:44:41 -0500
In-Reply-To: <20200203173311.6269a8be06a05e5a4aa08a93@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: alex.shi@linux.alibaba.com, cg.chen@huawei.com, gregkh@linuxfoundation.org, jlbec@evilplan.org, joseph.qi@linux.alibaba.com, kstewart@linuxfoundation.org, mark@fasheh.com, mm-commits@vger.kernel.org, rfontana@redhat.com, tglx@linutronix.de


The patch titled
     Subject: ocfs2: remove useless err
has been added to the -mm tree.  Its filename is
     ocfs2-remove-useless-err.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/ocfs2-remove-useless-err.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/ocfs2-remove-useless-err.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
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

Patches currently in -mm which might be from alex.shi@linux.alibaba.com are

ocfs2-remove-fs_ocfs2_nm.patch
ocfs2-remove-unused-macros.patch
ocfs2-use-ocfs2_sec_bits-in-macro.patch
ocfs2-remove-dlm_lock_is_remote.patch
ocfs2-remove-useless-err.patch
