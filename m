From: akpm@linux-foundation.org
Subject: [merged] ocfs2-skip-locks-in-the-blocked-list.patch removed from
 -mm tree
Date: Wed, 13 Nov 2013 12:37:22 -0800
Message-ID: <5283e302.CcLOsAnZ2jCZ2lMx%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42440 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751268Ab3KMUhW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 13 Nov 2013 15:37:22 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, mfasheh@suse.com, jlbec@evilplan.org, xuejiufei@huawei.com

Subject: [merged] ocfs2-skip-locks-in-the-blocked-list.patch removed from -mm tree
To: xuejiufei@huawei.com,jlbec@evilplan.org,mfasheh@suse.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Wed, 13 Nov 2013 12:37:22 -0800


The patch titled
     Subject: ocfs2: skip locks in the blocked list
has been removed from the -mm tree.  Its filename was
     ocfs2-skip-locks-in-the-blocked-list.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

origin.patch

