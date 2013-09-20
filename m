From: akpm@linux-foundation.org
Subject: + ocfs2-skip-locks-in-the-blocked-list.patch added to -mm tree
Date: Fri, 20 Sep 2013 13:50:14 -0700
Message-ID: <523cb506.GuF62omSr6+vasDn%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:36930 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754562Ab3ITUuP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 20 Sep 2013 16:50:15 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, mfasheh@suse.com, jlbec@evilplan.org, xuejiufei@huawei.com

Subject: + ocfs2-skip-locks-in-the-blocked-list.patch added to -mm tree
To: xuejiufei@huawei.com,jlbec@evilplan.org,mfasheh@suse.com
From: akpm@linux-foundation.org
Date: Fri, 20 Sep 2013 13:50:14 -0700


The patch titled
     Subject: ocfs2: skip locks in the blocked list
has been added to the -mm tree.  Its filename is
     ocfs2-skip-locks-in-the-blocked-list.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/ocfs2-skip-locks-in-the-blocked-list.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/ocfs2-skip-locks-in-the-blocked-list.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Xue jiufei <xuejiufei@huawei.com>
Subject: ocfs2: skip locks in the blocked list

A parallel umount on 4 nodes triggered a bug in
dlm_process_recovery_date().  Here's the situation:

Receiving MIG_LOCKRES message, A node processes the locks in migratable
lockres.  It copys lvb from migratable lockres when processing the first
valid lock.

If there is a lock in the blocked list with the EX level, it triggers the
BUG.  Since valid lvbs are set when locks are granted with EX or PR
levels, locks in the blocked list cannot have valid lvbs.  Therefore I
think we should skip the locks in the blocked list.

Signed-off-by: Xuejiufei <xuejiufei@huawei.com>
Signed-off-by: Joel Becker <jlbec@evilplan.org>
Cc: Mark Fasheh <mfasheh@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/dlm/dlmrecovery.c |    7 +++++++
 1 file changed, 7 insertions(+)

diff -puN fs/ocfs2/dlm/dlmrecovery.c~ocfs2-skip-locks-in-the-blocked-list fs/ocfs2/dlm/dlmrecovery.c
--- a/fs/ocfs2/dlm/dlmrecovery.c~ocfs2-skip-locks-in-the-blocked-list
+++ a/fs/ocfs2/dlm/dlmrecovery.c
@@ -1886,6 +1886,13 @@ static int dlm_process_recovery_data(str
 		if (ml->type == LKM_NLMODE)
 			goto skip_lvb;
 
+		/*
+		 * If the lock is in the blocked list it can't have a valid lvb,
+		 * so skip it
+		 */
+		if (ml->list == DLM_BLOCKED_LIST)
+			goto skip_lvb;
+
 		if (!dlm_lvb_is_empty(mres->lvb)) {
 			if (lksb->flags & DLM_LKSB_PUT_LVB) {
 				/* other node was trying to update
_

Patches currently in -mm which might be from xuejiufei@huawei.com are

ocfs2-skip-locks-in-the-blocked-list.patch
ocfs2-delay-migration-when-the-lockres-is-in-migration-state.patch
linux-next.patch

