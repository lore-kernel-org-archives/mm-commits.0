From: akpm@linux-foundation.org
Subject: + ocfs2-use-magich.patch added to -mm tree
Date: Tue, 23 May 2017 15:59:54 -0700
Message-ID: <5924beea.4tf2IMQgiulcgxFn%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38590 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1765007AbdEWW7z (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 23 May 2017 18:59:55 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: fabf@skynet.be, jiangqi903@gmail.com, jlbec@evilplan.org, junxiao.bi@oracle.com, mfasheh@versity.com, mm-commits@vger.kernel.org


The patch titled
     Subject: ocfs2: use magic.h
has been added to the -mm tree.  Its filename is
     ocfs2-use-magich.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/ocfs2-use-magich.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/ocfs2-use-magich.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Fabian Frederick <fabf@skynet.be>
Subject: ocfs2: use magic.h

Filesystems generally use SUPER_MAGIC values from magic.h instead of a
local definition.

Link: http://lkml.kernel.org/r/20170521154217.27917-1-fabf@skynet.be
Signed-off-by: Fabian Frederick <fabf@skynet.be>
Cc: Mark Fasheh <mfasheh@versity.com>
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
