From: akpm@linux-foundation.org
Subject: [merged] pidns-deny-clone_parentclone_newpid-combination.patch removed from -mm tree
Date: Thu, 24 Sep 2009 12:36:41 -0700
Message-ID: <200909241936.n8OJafnX003050@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51334 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753666AbZIXTr2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 24 Sep 2009 15:47:28 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: sukadev@linux.vnet.ibm.com, oleg@redhat.com, orenl@cs.columbia.edu, roland@redhat.com, serue@us.ibm.com, sukadev@us.ibm.com, mm-commits@vger.kernel.org


The patch titled
     pidns: deny CLONE_PARENT|CLONE_NEWPID combination
has been removed from the -mm tree.  Its filename was
     pidns-deny-clone_parentclone_newpid-combination.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: pidns: deny CLONE_PARENT|CLONE_NEWPID combination
From: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>

CLONE_PARENT was used to implement an older threading model.  For
consistency with the CLONE_THREAD check in copy_pid_ns(), disable
CLONE_PARENT with CLONE_NEWPID, at least until the required semantics of
pid namespaces are clear.

Signed-off-by: Sukadev Bhattiprolu <sukadev@us.ibm.com>
Acked-by: Roland McGrath <roland@redhat.com>
Acked-by: Serge Hallyn <serue@us.ibm.com>
Cc: Oren Laadan <orenl@cs.columbia.edu>
Cc: Oleg Nesterov <oleg@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/pid_namespace.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN kernel/pid_namespace.c~pidns-deny-clone_parentclone_newpid-combination kernel/pid_namespace.c
--- a/kernel/pid_namespace.c~pidns-deny-clone_parentclone_newpid-combination
+++ a/kernel/pid_namespace.c
@@ -118,7 +118,7 @@ struct pid_namespace *copy_pid_ns(unsign
 {
 	if (!(flags & CLONE_NEWPID))
 		return get_pid_ns(old_ns);
-	if (flags & CLONE_THREAD)
+	if (flags & (CLONE_THREAD|CLONE_PARENT))
 		return ERR_PTR(-EINVAL);
 	return create_pid_namespace(old_ns);
 }
_

Patches currently in -mm which might be from sukadev@linux.vnet.ibm.com are

origin.patch

