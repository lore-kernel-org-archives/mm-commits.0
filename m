From: akpm@linux-foundation.org
Subject: [merged] ocfs2-use-magich.patch removed from -mm tree
Date: Fri, 07 Jul 2017 12:07:36 -0700
Message-ID: <20170707190736.T7unpYbI0%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:60654 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751757AbdGGTHm (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 7 Jul 2017 15:07:42 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: fabf@skynet.be, jiangqi903@gmail.com, jlbec@evilplan.org, junxiao.bi@oracle.com, mfasheh@versity.com, mm-commits@vger.kernel.org


The patch titled
     Subject: ocfs2: use magic.h
has been removed from the -mm tree.  Its filename was
     ocfs2-use-magich.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Fabian Frederick <fabf@skynet.be>
Subject: ocfs2: use magic.h

Filesystems generally use SUPER_MAGIC values from magic.h instead of a
local definition.

Link: http://lkml.kernel.org/r/20170521154217.27917-1-fabf@skynet.be
Signed-off-by: Fabian Frederick <fabf@skynet.be>
Reviewed-by: Mark Fasheh <mfasheh@versity.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Joseph Qi <jiangqi903@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/ocfs2_fs.h        |    5 ++---
 include/uapi/linux/magic.h |    1 +
 2 files changed, 3 insertions(+), 3 deletions(-)

diff -puN fs/ocfs2/ocfs2_fs.h~ocfs2-use-magich fs/ocfs2/ocfs2_fs.h
--- a/fs/ocfs2/ocfs2_fs.h~ocfs2-use-magich
+++ a/fs/ocfs2/ocfs2_fs.h
@@ -25,6 +25,8 @@
 #ifndef _OCFS2_FS_H
 #define _OCFS2_FS_H
 
+#include <linux/magic.h>
+
 /* Version */
 #define OCFS2_MAJOR_REV_LEVEL		0
 #define OCFS2_MINOR_REV_LEVEL          	90
@@ -56,9 +58,6 @@
 #define OCFS2_MIN_BLOCKSIZE		512
 #define OCFS2_MAX_BLOCKSIZE		OCFS2_MIN_CLUSTERSIZE
 
-/* Filesystem magic number */
-#define OCFS2_SUPER_MAGIC		0x7461636f
