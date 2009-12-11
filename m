From: akpm@linux-foundation.org
Subject: + ipc-hard_msgmax-should-be-higher-not-lower-on-64bit.patch added to -mm tree
Date: Fri, 11 Dec 2009 14:05:13 -0800
Message-ID: <200912112205.nBBM5Dbu024112@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36200 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758722AbZLKWGD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 11 Dec 2009 17:06:03 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: amwang@redhat.com, clg@fr.ibm.com, serue@us.ibm.com


The patch titled
     ipc: HARD_MSGMAX should be higher not lower on 64bit
has been added to the -mm tree.  Its filename is
     ipc-hard_msgmax-should-be-higher-not-lower-on-64bit.patch

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
Subject: ipc: HARD_MSGMAX should be higher not lower on 64bit
From: Amerigo Wang <amwang@redhat.com>

We have HARD_MSGMAX lower on 64bit than on 32bit, since usually 64bit
machines have more memory than 32bit machines.

Making it higher on 64bit seems reasonable, and keep the original number
on 32bit.

Acked-by: Serge E. Hallyn <serue@us.ibm.com>
Cc: Cedric Le Goater <clg@fr.ibm.com>
Signed-off-by: WANG Cong <amwang@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/ipc_namespace.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN include/linux/ipc_namespace.h~ipc-hard_msgmax-should-be-higher-not-lower-on-64bit include/linux/ipc_namespace.h
--- a/include/linux/ipc_namespace.h~ipc-hard_msgmax-should-be-higher-not-lower-on-64bit
+++ a/include/linux/ipc_namespace.h
@@ -87,7 +87,7 @@ extern int mq_init_ns(struct ipc_namespa
 /* default values */
 #define DFLT_QUEUESMAX 256     /* max number of message queues */
 #define DFLT_MSGMAX    10      /* max number of messages in each queue */
-#define HARD_MSGMAX    (131072/sizeof(void *))
+#define HARD_MSGMAX    (32768*sizeof(void *)/4)
 #define DFLT_MSGSIZEMAX 8192   /* max message size */
 #else
 static inline int mq_init_ns(struct ipc_namespace *ns) { return 0; }
_

Patches currently in -mm which might be from amwang@redhat.com are

origin.patch
hfs-fix-a-potential-buffer-overflow.patch
linux-next.patch
xtensa-use-generic-sys_pipe.patch
sysctl_max_map_count-should-be-non-negative.patch
rwsem-spinlock-remove-useless-function-exports.patch
rwsem-fix-rwsem_is_locked-bugs.patch
rwsem-fix-rwsem_is_locked-bugs-fix.patch
kallsyms-remove-deprecated-print_fn_descriptor_symbol.patch
ipc-remove-unreachable-code-in-semc.patch
ipc-remove-unreachable-code-in-semc-fix.patch
ipc-hard_msgmax-should-be-higher-not-lower-on-64bit.patch
kexec-premit-reduction-of-the-reserved-memory-size.patch
kexec-premit-reduction-of-the-reserved-memory-size-fix.patch

