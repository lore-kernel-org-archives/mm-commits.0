From: akpm@linux-foundation.org
Subject: [merged] fork-disable-clone_parent-for-init.patch removed from -mm tree
Date: Thu, 24 Sep 2009 12:36:38 -0700
Message-ID: <200909241936.n8OJacn9002905@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60877 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754078AbZIXThN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 24 Sep 2009 15:37:13 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: sukadev@linux.vnet.ibm.com, ebiederm@xmission.com, oleg@redhat.com, orenl@cs.columbia.edu, roland@redhat.com, serue@us.ibm.com, sukadev@us.ibm.com, mm-commits@vger.kernel.org


The patch titled
     fork(): disable CLONE_PARENT for init
has been removed from the -mm tree.  Its filename was
     fork-disable-clone_parent-for-init.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: fork(): disable CLONE_PARENT for init
From: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>

When global or container-init processes use CLONE_PARENT, they create a
multi-rooted process tree.  Besides siblings of global init remain as
zombies on exit since they are not reaped by their parent (swapper).  So
prevent global and container-inits from creating siblings.

Signed-off-by: Sukadev Bhattiprolu <sukadev@us.ibm.com>
Acked-by: Eric W. Biederman <ebiederm@xmission.com>
Acked-by: Roland McGrath <roland@redhat.com>
Cc: Oren Laadan <orenl@cs.columbia.edu>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Serge Hallyn <serue@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/fork.c |   10 ++++++++++
 1 file changed, 10 insertions(+)

diff -puN kernel/fork.c~fork-disable-clone_parent-for-init kernel/fork.c
--- a/kernel/fork.c~fork-disable-clone_parent-for-init
+++ a/kernel/fork.c
@@ -979,6 +979,16 @@ static struct task_struct *copy_process(
 	if ((clone_flags & CLONE_SIGHAND) && !(clone_flags & CLONE_VM))
 		return ERR_PTR(-EINVAL);
 
+	/*
+	 * Siblings of global init remain as zombies on exit since they are
+	 * not reaped by their parent (swapper). To solve this and to avoid
+	 * multi-rooted process trees, prevent global and container-inits
+	 * from creating siblings.
+	 */
+	if ((clone_flags & CLONE_PARENT) &&
+				current->signal->flags & SIGNAL_UNKILLABLE)
+		return ERR_PTR(-EINVAL);
+
 	retval = security_task_create(clone_flags);
 	if (retval)
 		goto fork_out;
_

Patches currently in -mm which might be from sukadev@linux.vnet.ibm.com are

origin.patch

