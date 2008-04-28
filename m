From: akpm@linux-foundation.org
Subject: - vfs-reduce-stack-usage-by-shrinking-struct-kiocb.patch removed from -mm tree
Date: Mon, 28 Apr 2008 09:41:27 -0700
Message-ID: <200804281641.m3SGfRLO004188@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56204 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934174AbYD1Qnc (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 28 Apr 2008 12:43:32 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vda.linux@googlemail.com, bcrl@kvack.org, dgc@sgi.com, sandeen@sandeen.net, zach.brown@oracle.com, mm-commits@vger.kernel.org


The patch titled
     vfs: reduce stack usage by shrinking struct kiocb
has been removed from the -mm tree.  Its filename was
     vfs-reduce-stack-usage-by-shrinking-struct-kiocb.patch

This patch was dropped because an updated version will be merged

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: vfs: reduce stack usage by shrinking struct kiocb
From: Denys Vlasenko <vda.linux@googlemail.com>

struct kiocb is placed on stack by, for example, do_sync_write().  Eventually
it contributes to xfs writeout path's stack usage, among others.  This is
*the* path which causes 4k stack overflows on i386 with xfs.

This patch trivially reorders fields of this structure, and makes some of them
smaller.

Reordering helps 64-bit architectures:
int, void*, int, void* - bad,
int, int, void*, void* - better.

These fields are made smaller:
ki_flags: long -> short: possible values are 0,1,2, so short is enough.
ki_nr_segs: ulong -> uint: nobody uses 4 billion element writev's
                           (and it would not work anyway)
ki_cur_seg: same

For 32bit x86, it makes this struct only 4 bytes smaller.
This isn't much, but it helps not only xfs, but all filesystems.

For 64-bit case savings are a bit more significant,
as ulong -> uint actually makes a difference, and reordering
of 64-bit fields eliminates some padding.

Only compile tested. Observed stack reductions on 32 bits:

-sock_recvmsg [vmlinux]:                        196
-sock_sendmsg [vmlinux]:                        196
+sock_recvmsg [vmlinux]:                        192
+sock_sendmsg [vmlinux]:                        192
-do_sync_write [vmlinux]:                       140
-do_sync_read [vmlinux]:                        140
+do_sync_write [vmlinux]:                       136
+do_sync_read [vmlinux]:                        136
-do_sync_readv_writev [vmlinux]:                132
+do_sync_readv_writev [vmlinux]:                128

Signed-off-by: Denys Vlasenko <vda.linux@googlemail.com>
Cc: David Chinner <dgc@sgi.com>
Cc: Benjamin LaHaise <bcrl@kvack.org>
Cc: Eric Sandeen <sandeen@sandeen.net>
Cc: Zach Brown <zach.brown@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/aio.h |   14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff -puN include/linux/aio.h~vfs-reduce-stack-usage-by-shrinking-struct-kiocb include/linux/aio.h
--- a/include/linux/aio.h~vfs-reduce-stack-usage-by-shrinking-struct-kiocb
+++ a/include/linux/aio.h
@@ -86,7 +86,8 @@ struct kioctx;
  */
 struct kiocb {
 	struct list_head	ki_run_list;
-	unsigned long		ki_flags;
+	unsigned short		ki_flags; /* range: 0..2 */
+	unsigned short		ki_opcode;
 	int			ki_users;
 	unsigned		ki_key;		/* id of this request */
 
@@ -102,23 +103,22 @@ struct kiocb {
 	} ki_obj;
 
 	__u64			ki_user_data;	/* user's data for completion */
-	wait_queue_t		ki_wait;
 	loff_t			ki_pos;
+	wait_queue_t		ki_wait;
 
 	void			*private;
 	/* State that we remember to be able to restart/retry  */
-	unsigned short		ki_opcode;
+	/*unsigned short	ki_opcode; - moved up for denser packing */
 	size_t			ki_nbytes; 	/* copy of iocb->aio_nbytes */
-	char 			__user *ki_buf;	/* remaining iocb->aio_buf */
 	size_t			ki_left; 	/* remaining bytes */
+	unsigned		ki_nr_segs;
+	unsigned		ki_cur_seg;
 	struct iovec		ki_inline_vec;	/* inline vector */
+	char 			__user *ki_buf;	/* remaining iocb->aio_buf */
  	struct iovec		*ki_iovec;
- 	unsigned long		ki_nr_segs;
- 	unsigned long		ki_cur_seg;
 
 	struct list_head	ki_list;	/* the aio core uses this
 						 * for cancellation */
