From: akpm@linux-foundation.org
Subject: + pidns-deny-clone_parentclone_newpid-combination.patch added to -mm tree
Date: Wed, 29 Jul 2009 15:15:04 -0700
Message-ID: <200907292215.n6TMF41w004399@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34744 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752555AbZG2WQA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 29 Jul 2009 18:16:00 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: sukadev@linux.vnet.ibm.com, oleg@redhat.com, orenl@cs.columbia.edu, roland@redhat.com, serue@us.ibm.com, sukadev@us.ibm.com


The patch titled
     pidns: deny CLONE_PARENT|CLONE_NEWPID combination
has been added to the -mm tree.  Its filename is
     pidns-deny-clone_parentclone_newpid-combination.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

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

fork-disable-clone_parent-for-init.patch
pidns-deny-clone_parentclone_newpid-combination.patch

