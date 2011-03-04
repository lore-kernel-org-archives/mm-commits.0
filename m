From: akpm@linux-foundation.org
Subject: + userns-add-a-user-namespace-owner-of-ipc-ns-dont-define-init_user_ns-in-ipc_namespaceh.patch added to -mm tree
Date: Fri, 04 Mar 2011 15:49:50 -0800
Message-ID: <201103042349.p24NnoBf011104@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51397 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760148Ab1CDXuD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 4 Mar 2011 18:50:03 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: serge.hallyn@canonical.com, daniel.lezcano@free.fr, dhowells@redhat.com, ebiederm@xmission.com, jmorris@namei.org


The patch titled
     userns: don't define init_user_ns in ipc_namespace.h
has been added to the -mm tree.  Its filename is
     userns-add-a-user-namespace-owner-of-ipc-ns-dont-define-init_user_ns-in-ipc_namespaceh.patch

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
Subject: userns: don't define init_user_ns in ipc_namespace.h
From: "Serge E. Hallyn" <serge.hallyn@canonical.com>

It shouldn't be needed since ipc/msgutil.c includes security.h
which includes fs.h, which forward declares it.

Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Daniel Lezcano <daniel.lezcano@free.fr>
Cc: David Howells <dhowells@redhat.com>
Cc: James Morris <jmorris@namei.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/ipc_namespace.h |    1 -
 1 file changed, 1 deletion(-)

diff -puN include/linux/ipc_namespace.h~userns-add-a-user-namespace-owner-of-ipc-ns-dont-define-init_user_ns-in-ipc_namespaceh include/linux/ipc_namespace.h
--- a/include/linux/ipc_namespace.h~userns-add-a-user-namespace-owner-of-ipc-ns-dont-define-init_user_ns-in-ipc_namespaceh
+++ a/include/linux/ipc_namespace.h
@@ -16,7 +16,6 @@
 #define IPCNS_CALLBACK_PRI 0
 
 struct user_namespace;
-extern struct user_namespace init_user_ns;
 
 struct ipc_ids {
 	int in_use;
_

Patches currently in -mm which might be from serge.hallyn@canonical.com are

sys_unshare-remove-the-dead-clone_thread-sighand-vm-code.patch
cgroup-remove-the-ns_cgroup.patch
userns-add-a-user_namespace-as-creator-owner-of-uts_namespace.patch
userns-security-make-capabilities-relative-to-the-user-namespace.patch
userns-security-make-capabilities-relative-to-the-user-namespace-fix.patch
userns-security-make-capabilities-relative-to-the-user-namespace-fix-fix.patch
userns-security-make-capabilities-relative-to-the-user-namespace-remove-unneeded-extra-argument-in-selinuxs-task_has_capability.patch
userns-allow-sethostname-in-a-container.patch
userns-allow-killing-tasks-in-your-own-or-child-userns.patch
userns-allow-ptrace-from-non-init-user-namespaces.patch
userns-user-namespaces-convert-all-capable-checks-in-kernel-sysc.patch
userns-add-a-user-namespace-owner-of-ipc-ns.patch
userns-add-a-user-namespace-owner-of-ipc-ns-dont-define-init_user_ns-in-ipc_namespaceh.patch
userns-user-namespaces-convert-several-capable-calls.patch
userns-user-namespaces-convert-several-capable-calls-checkpatch-fixes.patch
userns-userns-check-user-namespace-for-task-file-uid-equivalence-checks.patch
userns-userns-check-user-namespace-for-task-file-uid-equivalence-checks-checkpatch-fixes.patch
userns-rename-is_owner_or_cap-to-inode_owner_or_capable.patch
userns-rename-is_owner_or_cap-to-inode_owner_or_capable-fix.patch
userns-rename-is_owner_or_cap-to-inode_owner_or_capable-fix-fix.patch
userns-make-has_capability-into-real-functions.patch

