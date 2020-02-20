From: akpm@linux-foundation.org
Subject: + ocfs2-use-ocfs2_sec_bits-in-macro.patch added to -mm tree
Date: Wed, 19 Feb 2020 16:07:33 -0800
Message-ID: <20200220000733.xYm8t%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:54776 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726647AbgBTAHe (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 19 Feb 2020 19:07:34 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, piaojun@huawei.com, mark@fasheh.com, junxiao.bi@oracle.com, joseph.qi@linux.alibaba.com, jlbec@evilplan.org, ghe@suse.com, gechangwei@live.cn, alex.shi@linux.alibaba.com


The patch titled
     Subject: ocfs2: use OCFS2_SEC_BITS in macro
has been added to the -mm tree.  Its filename is
     ocfs2-use-ocfs2_sec_bits-in-macro.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/ocfs2-use-ocfs2_sec_bits-in-macro.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/ocfs2-use-ocfs2_sec_bits-in-macro.patch

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

Patches currently in -mm which might be from alex.shi@linux.alibaba.com are

ocfs2-remove-fs_ocfs2_nm.patch
ocfs2-remove-unused-macros.patch
ocfs2-use-ocfs2_sec_bits-in-macro.patch
ocfs2-remove-dlm_lock_is_remote.patch
