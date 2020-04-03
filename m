From: akpm@linux-foundation.org
Subject: [merged]
 ocfs2-ocfs2_fsh-replace-zero-length-array-with-flexible-array-member.patch
 removed from -mm tree
Date: Fri, 03 Apr 2020 13:35:32 -0700
Message-ID: <20200403203532.deNgufZBe%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:58288 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727867AbgDCUfd (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 3 Apr 2020 16:35:33 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: gechangwei@live.cn, ghe@suse.com, gustavo@embeddedor.com, jlbec@evilplan.org, joseph.qi@linux.alibaba.com, junxiao.bi@oracle.com, mark@fasheh.com, mm-commits@vger.kernel.org, piaojun@huawei.com


The patch titled
     Subject: ocfs2: ocfs2_fs.h: replace zero-length array with flexible-array member
has been removed from the -mm tree.  Its filename was
     ocfs2-ocfs2_fsh-replace-zero-length-array-with-flexible-array-member.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Subject: ocfs2: ocfs2_fs.h: replace zero-length array with flexible-array member

The current codebase makes use of the zero-length array language extension
to the C90 standard, but the preferred mechanism to declare
variable-length types such as these ones is a flexible array member[1][2],
introduced in C99:

struct foo {
        int stuff;
        struct boo array[];
};

By making use of the mechanism above, we will get a compiler warning in
case the flexible array does not occur last in the structure, which will
help us prevent some kind of undefined behavior bugs from being
inadvertently introduced[3] to the codebase from now on.

Also, notice that, dynamic memory allocations won't be affected by this
change:

"Flexible array members have incomplete type, and so the sizeof operator
may not be applied.  As a quirk of the original implementation of
zero-length arrays, sizeof evaluates to zero."[1]

This issue was found with the help of Coccinelle.

[1] https://urldefense.com/v3/__https://gcc.gnu.org/onlinedocs/gcc/Zero-Length.html__;!!GqivPVa7Brio!OKPotRhYhHbCG2kibo8Q6_6CuKaa28d_74h1svxyR6rbshrK2L_BdrQpNbvJWBWb40QCkg$
[2] https://urldefense.com/v3/__https://github.com/KSPP/linux/issues/21__;!!GqivPVa7Brio!OKPotRhYhHbCG2kibo8Q6_6CuKaa28d_74h1svxyR6rbshrK2L_BdrQpNbvJWBUhNn9M6g$
[3] commit 76497732932f ("cxgb3/l2t: Fix undefined behaviour")

Link: http://lkml.kernel.org/r/20200309202155.GA8432@embeddedor
Signed-off-by: Gustavo A. R. Silva <gustavo@embeddedor.com>
Acked-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: Mark Fasheh <mark@fasheh.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Changwei Ge <gechangwei@live.cn>
Cc: Gang He <ghe@suse.com>
Cc: Jun Piao <piaojun@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/ocfs2_fs.h |   18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

--- a/fs/ocfs2/ocfs2_fs.h~ocfs2-ocfs2_fsh-replace-zero-length-array-with-flexible-array-member
+++ a/fs/ocfs2/ocfs2_fs.h
@@ -470,7 +470,7 @@ struct ocfs2_extent_list {
 	__le16 l_reserved1;
 	__le64 l_reserved2;		/* Pad to
 					   sizeof(ocfs2_extent_rec) */
-/*10*/	struct ocfs2_extent_rec l_recs[0];	/* Extent records */
+/*10*/	struct ocfs2_extent_rec l_recs[];	/* Extent records */
 };
 
 /*
@@ -484,7 +484,7 @@ struct ocfs2_chain_list {
 	__le16 cl_count;		/* Total chains in this list */
 	__le16 cl_next_free_rec;	/* Next unused chain slot */
 	__le64 cl_reserved1;
-/*10*/	struct ocfs2_chain_rec cl_recs[0];	/* Chain records */
+/*10*/	struct ocfs2_chain_rec cl_recs[];	/* Chain records */
 };
 
 /*
@@ -496,7 +496,7 @@ struct ocfs2_truncate_log {
 /*00*/	__le16 tl_count;		/* Total records in this log */
 	__le16 tl_used;			/* Number of records in use */
 	__le32 tl_reserved1;
-/*08*/	struct ocfs2_truncate_rec tl_recs[0];	/* Truncate records */
+/*08*/	struct ocfs2_truncate_rec tl_recs[];	/* Truncate records */
 };
 
 /*
@@ -640,7 +640,7 @@ struct ocfs2_local_alloc
 	__le16 la_size;		/* Size of included bitmap, in bytes */
 	__le16 la_reserved1;
 	__le64 la_reserved2;
-/*10*/	__u8   la_bitmap[0];
+/*10*/	__u8   la_bitmap[];
 };
 
 /*
@@ -653,7 +653,7 @@ struct ocfs2_inline_data
 				 * for data, starting at id_data */
 	__le16	id_reserved0;
 	__le32	id_reserved1;
-	__u8	id_data[0];	/* Start of user data */
+	__u8	id_data[];	/* Start of user data */
 };
 
 /*
@@ -798,7 +798,7 @@ struct ocfs2_dx_entry_list {
 					 * possible in de_entries */
 	__le16		de_num_used;	/* Current number of
 					 * de_entries entries */
-	struct	ocfs2_dx_entry		de_entries[0];	/* Indexed dir entries
+	struct	ocfs2_dx_entry		de_entries[];	/* Indexed dir entries
 							 * in a packed array of
 							 * length de_num_used */
 };
@@ -935,7 +935,7 @@ struct ocfs2_refcount_list {
 	__le16 rl_used;		/* Current number of used records */
 	__le32 rl_reserved2;
 	__le64 rl_reserved1;	/* Pad to sizeof(ocfs2_refcount_record) */
-/*10*/	struct ocfs2_refcount_rec rl_recs[0];	/* Refcount records */
+/*10*/	struct ocfs2_refcount_rec rl_recs[];	/* Refcount records */
 };
 
 
@@ -1021,7 +1021,7 @@ struct ocfs2_xattr_header {
 						    buckets.  A block uses
 						    xb_check and sets
 						    this field to zero.) */
-	struct ocfs2_xattr_entry xh_entries[0]; /* xattr entry list. */
+	struct ocfs2_xattr_entry xh_entries[]; /* xattr entry list. */
 };
 
 /*
@@ -1207,7 +1207,7 @@ struct ocfs2_local_disk_dqinfo {
 /* Header of one chunk of a quota file */
 struct ocfs2_local_disk_chunk {
 	__le32 dqc_free;	/* Number of free entries in the bitmap */
-	__u8 dqc_bitmap[0];	/* Bitmap of entries in the corresponding
+	__u8 dqc_bitmap[];	/* Bitmap of entries in the corresponding
 				 * chunk of quota file */
 };
 
_

Patches currently in -mm which might be from gustavo@embeddedor.com are

lib-bch-replace-zero-length-array-with-flexible-array-member.patch
lib-ts_bm-replace-zero-length-array-with-flexible-array-member.patch
lib-ts_fsm-replace-zero-length-array-with-flexible-array-member.patch
lib-ts_kmp-replace-zero-length-array-with-flexible-array-member.patch
gcov-gcc_4_7-replace-zero-length-array-with-flexible-array-member.patch
gcov-gcc_3_4-replace-zero-length-array-with-flexible-array-member.patch
gcov-fs-replace-zero-length-array-with-flexible-array-member.patch
