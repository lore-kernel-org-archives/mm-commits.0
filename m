From: Andrew Morton <akpm@linux-foundation.org>
Subject: [patch 008/155] ocfs2: use OCFS2_SEC_BITS in macro
Date: Wed, 01 Apr 2020 21:03:28 -0700
Message-ID: <20200402040328.5Cvg8OFC2%akpm@linux-foundation.org>
References: <20200401210155.09e3b9742e1c6e732f5a7250@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:47472 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726136AbgDBED3 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 2 Apr 2020 00:03:29 -0400
In-Reply-To: <20200401210155.09e3b9742e1c6e732f5a7250@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, alex.shi@linux.alibaba.com, gechangwei@live.cn, ghe@suse.com, jlbec@evilplan.org, joseph.qi@linux.alibaba.com, junxiao.bi@oracle.com, linux-mm@kvack.org, mark@fasheh.com, mm-commits@vger.kernel.org, piaojun@huawei.com, torvalds@linux-foundation.org

From: Alex Shi <alex.shi@linux.alibaba.com>
Subject: ocfs2: use OCFS2_SEC_BITS in macro

This macro should be used.

Link: http://lkml.kernel.org/r/1579577840-251956-1-git-send-email-alex.shi@linux.alibaba.com
Signed-off-by: Alex Shi <alex.shi@linux.alibaba.com>
Acked-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: Mark Fasheh <mark@fasheh.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Changwei Ge <gechangwei@live.cn>
Cc: Gang He <ghe@suse.com>
Cc: Jun Piao <piaojun@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/dlmglue.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/ocfs2/dlmglue.c~ocfs2-use-ocfs2_sec_bits-in-macro
+++ a/fs/ocfs2/dlmglue.c
@@ -2133,7 +2133,7 @@ static void ocfs2_downconvert_on_unlock(
 }
 
 #define OCFS2_SEC_BITS   34
-#define OCFS2_SEC_SHIFT  (64 - 34)
+#define OCFS2_SEC_SHIFT  (64 - OCFS2_SEC_BITS)
 #define OCFS2_NSEC_MASK  ((1ULL << OCFS2_SEC_SHIFT) - 1)
 
 /* LVB only has room for 64 bits of time here so we pack it for
_
