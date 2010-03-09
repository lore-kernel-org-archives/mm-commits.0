From: akpm@linux-foundation.org
Subject: [merged] splice-comparing-unsigned-int-0.patch removed from -mm tree
Date: Tue, 09 Mar 2010 11:06:16 -0800
Message-ID: <201003091906.o29J6Gwr031244@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44156 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755829Ab0CITHV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 9 Mar 2010 14:07:21 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: error27@gmail.com, jens.axboe@oracle.com, laijs@cn.fujitsu.com, zanussi@comcast.net, mm-commits@vger.kernel.org


The patch titled
     splice: comparing unsigned int < 0
has been removed from the -mm tree.  Its filename was
     splice-comparing-unsigned-int-0.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: splice: comparing unsigned int < 0
From: Dan Carpenter <error27@gmail.com>

"ret" needs to be signed or the error handling for splice_to_pipe() won't
work correctly.

Signed-off-by: Dan Carpenter <error27@gmail.com>
Cc: Tom Zanussi <zanussi@comcast.net>
Cc: Jens Axboe <jens.axboe@oracle.com>
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/relay.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff -puN kernel/relay.c~splice-comparing-unsigned-int-0 kernel/relay.c
--- a/kernel/relay.c~splice-comparing-unsigned-int-0
+++ a/kernel/relay.c
@@ -1215,14 +1215,14 @@ static void relay_page_release(struct sp
 /*
  *	subbuf_splice_actor - splice up to one subbuf's worth of data
  */
-static int subbuf_splice_actor(struct file *in,
+static ssize_t subbuf_splice_actor(struct file *in,
 			       loff_t *ppos,
 			       struct pipe_inode_info *pipe,
 			       size_t len,
 			       unsigned int flags,
 			       int *nonpad_ret)
 {
-	unsigned int pidx, poff, total_len, subbuf_pages, nr_pages, ret;
+	unsigned int pidx, poff, total_len, subbuf_pages, nr_pages;
 	struct rchan_buf *rbuf = in->private_data;
 	unsigned int subbuf_size = rbuf->chan->subbuf_size;
 	uint64_t pos = (uint64_t) *ppos;
@@ -1241,6 +1241,7 @@ static int subbuf_splice_actor(struct fi
 		.ops = &relay_pipe_buf_ops,
 		.spd_release = relay_page_release,
 	};
+	ssize_t ret;
 
 	if (rbuf->subbufs_produced == rbuf->subbufs_consumed)
 		return 0;
_

Patches currently in -mm which might be from error27@gmail.com are

linux-next.patch
acpica-fix-acpi_ex_release_mutex-comment.patch
scsi-remove-superfluous-null-pointer-check-from-scsi_kill_request.patch

