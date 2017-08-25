From: akpm@linux-foundation.org
Subject: +
 ocfs2-re-queue-ast-or-bast-if-sending-is-failed-to-improve-the-reliability-fix.patch added to -mm tree
Date: Fri, 25 Aug 2017 13:03:55 -0700
Message-ID: <59a082ab.LBM3vqcLPjremGKo%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:46132 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932556AbdHYUD4 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 25 Aug 2017 16:03:56 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: arnd@arndb.de, ge.changwei@h3c.com, ghe@suse.com, jiangqi903@gmail.com, jlbec@evilplan.org, junxiao.bi@oracle.com, mfasheh@versity.com, mm-commits@vger.kernel.org


The patch titled
     Subject: ocfs2: remove two unused variables
has been added to the -mm tree.  Its filename is
     ocfs2-re-queue-ast-or-bast-if-sending-is-failed-to-improve-the-reliability-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/ocfs2-re-queue-ast-or-bast-if-sending-is-failed-to-improve-the-reliability-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/ocfs2-re-queue-ast-or-bast-if-sending-is-failed-to-improve-the-reliability-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Arnd Bergmann <arnd@arndb.de>
Subject: ocfs2: remove two unused variables

A reliability fix introduced two local variables but never used
them:

fs/ocfs2/dlm/dlmrecovery.c: In function 'dlm_free_dead_locks':
fs/ocfs2/dlm/dlmrecovery.c:2306:6: error: unused variable 'i' [-Werror=unused-variable]
fs/ocfs2/dlm/dlmrecovery.c:2305:20: error: unused variable 'queue' [-Werror=unused-variable]

This removes them both again.

Link: http://lkml.kernel.org/r/20170824222149.759050-1-arnd@arndb.de
Fixes: d09f2c6cf3b8 ("ocfs2: re-queue AST or BAST if sending is failed to improve the reliability")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: Changwei Ge <ge.changwei@h3c.com>
Cc: Mark Fasheh <mfasheh@versity.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Joseph Qi <jiangqi903@gmail.com>
Cc: "Gang He" <ghe@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/dlm/dlmrecovery.c |    2 --
 1 file changed, 2 deletions(-)

diff -puN fs/ocfs2/dlm/dlmrecovery.c~ocfs2-re-queue-ast-or-bast-if-sending-is-failed-to-improve-the-reliability-fix fs/ocfs2/dlm/dlmrecovery.c
--- a/fs/ocfs2/dlm/dlmrecovery.c~ocfs2-re-queue-ast-or-bast-if-sending-is-failed-to-improve-the-reliability-fix
+++ a/fs/ocfs2/dlm/dlmrecovery.c
@@ -2302,8 +2302,6 @@ static void dlm_free_dead_locks(struct d
 	struct dlm_lock *lock, *next;
 	unsigned int freed = 0;
 	int reserved_tmp = 0;
-	struct list_head *queue = NULL;
-	int i;
 
 	/* this node is the lockres master:
 	 * 1) remove any stale locks for the dead node
_

Patches currently in -mm which might be from arnd@arndb.de are

adfs-use-unsigned-types-for-memcpy-length.patch
ocfs2-re-queue-ast-or-bast-if-sending-is-failed-to-improve-the-reliability-fix.patch
mm-zone_device-new-type-of-zone_device-for-unaddressable-memory-fix.patch
fs-proc-remove-priv-argument-from-is_stack-fix.patch
fscache-fix-fscache_objlist_show-format-processing.patch
ib-mlx4-fix-sprintf-format-warning.patch
iopoll-avoid-wint-in-bool-context-warning.patch

