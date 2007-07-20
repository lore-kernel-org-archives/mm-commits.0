From: akpm@linux-foundation.org
Subject: - user-namespace-fix-copy_user_ns-return-value.patch removed from -mm tree
Date: Thu, 19 Jul 2007 23:43:14 -0700
Message-ID: <200707200643.l6K6hEbR011953@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:35333 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753466AbXGTGna (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 20 Jul 2007 02:43:30 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: serue@us.ibm.com, clg@fr.ibm.com, sukadev@us.ibm.com, xemul@openvz.org, mm-commits@vger.kernel.org


The patch titled
     user namespace: fix copy_user_ns return value
has been removed from the -mm tree.  Its filename was
     user-namespace-fix-copy_user_ns-return-value.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: user namespace: fix copy_user_ns return value
From: "Serge E. Hallyn" <serue@us.ibm.com>

When a CONFIG_USER_NS=n and a user tries to unshare some namespace other
than the user namespace, the dummy copy_user_ns returns NULL rather than
the old_ns.  This value then gets assigned to task->nsproxy->user_ns, so
that a subsequent setuid, which uses task->nsproxy->user_ns, causes a NULL
pointer deref.

Fix this by returning old_ns.

I believe this is a bug both in -mm and mainline.

Signed-off-by: Serge E. Hallyn <serue@us.ibm.com>
Cc: Sukadev Bhattiprolu <sukadev@us.ibm.com>
Cc: Pavel Emelianov <xemul@openvz.org>
Cc: Cedric Le Goater <clg@fr.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/user_namespace.h |    2 +-
 1 files changed, 1 insertion(+), 1 deletion(-)

diff -puN include/linux/user_namespace.h~user-namespace-fix-copy_user_ns-return-value include/linux/user_namespace.h
--- a/include/linux/user_namespace.h~user-namespace-fix-copy_user_ns-return-value
+++ a/include/linux/user_namespace.h
@@ -49,7 +49,7 @@ static inline struct user_namespace *cop
 	if (flags & CLONE_NEWUSER)
 		return ERR_PTR(-EINVAL);
 
-	return NULL;
+	return old_ns;
 }
 
 static inline void put_user_ns(struct user_namespace *ns)
_

Patches currently in -mm which might be from serue@us.ibm.com are

origin.patch
security-convert-lsm-into-a-static-interface.patch
security-convert-lsm-into-a-static-interface-fix.patch
implement-file-posix-capabilities.patch
implement-file-posix-capabilities-fix.patch
file-capabilities-introduce-cap_setfcap.patch
file-capabilities-get_file_caps-cleanups.patch
file-caps-update-selinux-xattr-hooks.patch
file-capabilities-clear-caps-cleanup.patch
file-capabilities-clear-caps-cleanup-fix.patch
file-capabilities-change-xattr-format-v2.patch
file-capabilities-change-fe-to-a-bool.patch
file-caps-clean-up-for-linux-capabilityh.patch
capabilityh-remove-include-of-currenth.patch
cpuset-zero-malloc-revert-the-old-cpuset-fix.patch
containersv10-basic-container-framework.patch
containersv10-basic-container-framework-fix.patch
containersv10-example-cpu-accounting-subsystem.patch
containersv10-example-cpu-accounting-subsystem-fix.patch
containersv10-add-tasks-file-interface.patch
containersv10-add-tasks-file-interface-fix.patch
containersv10-add-fork-exit-hooks.patch
containersv10-add-fork-exit-hooks-fix.patch
containersv10-add-container_clone-interface.patch
containersv10-add-container_clone-interface-fix.patch
containersv10-add-procfs-interface.patch
containersv10-add-procfs-interface-fix.patch
containersv10-make-cpusets-a-client-of-containers.patch
containersv10-share-css_group-arrays-between-tasks-with-same-container-memberships.patch
containersv10-share-css_group-arrays-between-tasks-with-same-container-memberships-fix.patch
containersv10-share-css_group-arrays-between-tasks-with-same-container-memberships-cpuset-zero-malloc-fix-for-new-containers.patch
containersv10-simple-debug-info-subsystem.patch
containersv10-simple-debug-info-subsystem-fix.patch
containersv10-simple-debug-info-subsystem-fix-2.patch
containersv10-support-for-automatic-userspace-release-agents.patch
containers-implement-subsys-post_clone.patch
containers-implement-namespace-tracking-subsystem-v3.patch
pid-namespaces-round-up-the-api.patch
