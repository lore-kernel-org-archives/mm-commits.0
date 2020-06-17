From: akpm@linux-foundation.org
Subject: + ocfs2-fix-value-of-ocfs2_invalid_slot.patch added to -mm
 tree
Date: Wed, 17 Jun 2020 14:02:16 -0700
Message-ID: <20200617210216.k6zl_%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:42576 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726840AbgFQVCR (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 17 Jun 2020 17:02:17 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, piaojun@huawei.com, mark@fasheh.com, joseph.qi@linux.alibaba.com, jlbec@evilplan.org, ghe@suse.com, gechangwei@live.cn, junxiao.bi@oracle.com


The patch titled
     Subject: ocfs2: fix value of OCFS2_INVALID_SLOT
has been added to the -mm tree.  Its filename is
     ocfs2-fix-value-of-ocfs2_invalid_slot.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/ocfs2-fix-value-of-ocfs2_invalid_slot.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/ocfs2-fix-value-of-ocfs2_invalid_slot.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Junxiao Bi <junxiao.bi@oracle.com>
Subject: ocfs2: fix value of OCFS2_INVALID_SLOT

In the ocfs2 disk layout, slot number is 16 bits, but in ocfs2
implementation, slot number is 32 bits.  Usually this will not cause any
issue, because slot number is converted from u16 to u32, but
OCFS2_INVALID_SLOT was defined as -1, when an invalid slot number from
disk was obtained, its value was (u16)-1, and it was converted to u32. 
Then the following checking in get_local_system_inode will be always
skipped:

 static struct inode **get_local_system_inode(struct ocfs2_super *osb,
                                               int type,
                                               u32 slot)
 {
 	BUG_ON(slot == OCFS2_INVALID_SLOT);
	...
 }

Link: http://lkml.kernel.org/r/20200616183829.87211-5-junxiao.bi@oracle.com
Signed-off-by: Junxiao Bi <junxiao.bi@oracle.com>
Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: Mark Fasheh <mark@fasheh.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Changwei Ge <gechangwei@live.cn>
Cc: Gang He <ghe@suse.com>
Cc: Jun Piao <piaojun@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/ocfs2_fs.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/ocfs2/ocfs2_fs.h~ocfs2-fix-value-of-ocfs2_invalid_slot
+++ a/fs/ocfs2/ocfs2_fs.h
@@ -290,7 +290,7 @@
 #define OCFS2_MAX_SLOTS			255
 
 /* Slot map indicator for an empty slot */
-#define OCFS2_INVALID_SLOT		-1
+#define OCFS2_INVALID_SLOT		((u16)-1)
 
 #define OCFS2_VOL_UUID_LEN		16
 #define OCFS2_MAX_VOL_LABEL_LEN		64
_

Patches currently in -mm which might be from junxiao.bi@oracle.com are

ocfs2-avoid-inode-removed-while-nfsd-access-it.patch
ocfs2-load-global_inode_alloc.patch
ocfs2-fix-panic-on-nfs-server-over-ocfs2.patch
ocfs2-fix-value-of-ocfs2_invalid_slot.patch
