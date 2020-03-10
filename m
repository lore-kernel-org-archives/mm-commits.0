From: Andrew Morton <akpm@linux-foundation.org>
Subject: +
 ocfs2-dlm-replace-zero-length-array-with-flexible-array-member.patch added
 to -mm tree
Date: Mon, 09 Mar 2020 19:54:00 -0700
Message-ID: <20200310025400.URhk7jn_S%akpm@linux-foundation.org>
References: <20200305222751.6d781a3f2802d79510941e4e@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:45928 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726156AbgCJCyC (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 9 Mar 2020 22:54:02 -0400
In-Reply-To: <20200305222751.6d781a3f2802d79510941e4e@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: gechangwei@live.cn, ghe@suse.com, gustavo@embeddedor.com, jlbec@evilplan.org, joseph.qi@linux.alibaba.com, junxiao.bi@oracle.com, mark@fasheh.com, mm-commits@vger.kernel.org, piaojun@huawei.com


The patch titled
     Subject: ocfs2: dlm: replace zero-length array with flexible-array member
has been added to the -mm tree.  Its filename is
     ocfs2-dlm-replace-zero-length-array-with-flexible-array-member.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/ocfs2-dlm-replace-zero-length-array-with-flexible-array-member.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/ocfs2-dlm-replace-zero-length-array-with-flexible-array-member.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Subject: ocfs2: dlm: replace zero-length array with flexible-array member

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

[1] https://urldefense.com/v3/__https://gcc.gnu.org/onlinedocs/gcc/Zero-Length.html__;!!GqivPVa7Brio!OVOYL_CouISa5L1Lw-20EEFQntw6cKMx-j8UdY4z78uYgzKBUFcfpn50GaurvbV5v7YiUA$
[2] https://urldefense.com/v3/__https://github.com/KSPP/linux/issues/21__;!!GqivPVa7Brio!OVOYL_CouISa5L1Lw-20EEFQntw6cKMx-j8UdY4z78uYgzKBUFcfpn50GaurvbXs8Eh8eg$
[3] commit 76497732932f ("cxgb3/l2t: Fix undefined behaviour")

Link: http://lkml.kernel.org/r/20200309202016.GA8210@embeddedor
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

 fs/ocfs2/dlm/dlmcommon.h |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/fs/ocfs2/dlm/dlmcommon.h~ocfs2-dlm-replace-zero-length-array-with-flexible-array-member
+++ a/fs/ocfs2/dlm/dlmcommon.h
@@ -564,7 +564,7 @@ struct dlm_migratable_lockres
 	// 48 bytes
 	u8 lvb[DLM_LVB_LEN];
 	// 112 bytes
-	struct dlm_migratable_lock ml[0];  // 16 bytes each, begins at byte 112
+	struct dlm_migratable_lock ml[];  // 16 bytes each, begins at byte 112
 };
 #define DLM_MIG_LOCKRES_MAX_LEN  \
 	(sizeof(struct dlm_migratable_lockres) + \
@@ -601,7 +601,7 @@ struct dlm_convert_lock
 
 	u8 name[O2NM_MAX_NAME_LEN];
 
-	s8 lvb[0];
+	s8 lvb[];
 };
 #define DLM_CONVERT_LOCK_MAX_LEN  (sizeof(struct dlm_convert_lock)+DLM_LVB_LEN)
 
@@ -616,7 +616,7 @@ struct dlm_unlock_lock
 
 	u8 name[O2NM_MAX_NAME_LEN];
 
-	s8 lvb[0];
+	s8 lvb[];
 };
 #define DLM_UNLOCK_LOCK_MAX_LEN  (sizeof(struct dlm_unlock_lock)+DLM_LVB_LEN)
 
@@ -632,7 +632,7 @@ struct dlm_proxy_ast
 
 	u8 name[O2NM_MAX_NAME_LEN];
 
-	s8 lvb[0];
+	s8 lvb[];
 };
 #define DLM_PROXY_AST_MAX_LEN  (sizeof(struct dlm_proxy_ast)+DLM_LVB_LEN)
 
_

Patches currently in -mm which might be from gustavo@embeddedor.com are

ocfs2-replace-zero-length-array-with-flexible-array-member.patch
ocfs2-cluster-replace-zero-length-array-with-flexible-array-member.patch
ocfs2-dlm-replace-zero-length-array-with-flexible-array-member.patch
ocfs2-ocfs2_fsh-replace-zero-length-array-with-flexible-array-member.patch
lib-bch-replace-zero-length-array-with-flexible-array-member.patch
lib-ts_bm-replace-zero-length-array-with-flexible-array-member.patch
lib-ts_fsm-replace-zero-length-array-with-flexible-array-member.patch
lib-ts_kmp-replace-zero-length-array-with-flexible-array-member.patch
gcov-gcc_4_7-replace-zero-length-array-with-flexible-array-member.patch
gcov-gcc_3_4-replace-zero-length-array-with-flexible-array-member.patch
gcov-fs-replace-zero-length-array-with-flexible-array-member.patch
