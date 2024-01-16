Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C93BC1DA35
	for <mm-commits@vger.kernel.org>; Tue, 16 Jan 2024 20:09:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705435747; cv=none; b=SD1Pl1pP9TSWk3CsI029/NIGdf1RLaJlXbXMK56PW4sDWn3x7lLsDSq4rAgNequfq+qBRnmiSZuBkeTOxjxuY3C6+abLhmk2Axl1Qdomni+gzAFioowiDBPL0oxwr/MRL9bcCErcZup6OZ1N7VdDLo+oRuQ+UqjuB9gMal5xTPo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705435747; c=relaxed/simple;
	bh=CKAs7OI8Rpams7OjhLKq0DxNO2gsVCk9Qwh7vae31Mg=;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id; b=cbz1qG74cHHDJBOe3qBPd/rTe2KqmUOOWEgDdopIihL20efWKdJMdaxSI0+RSG5LvHvq+MqtdmTqSMsa0djc9ZBH+MQSiZGD9diGzv+osLBFfVfAO7cWkd48JyxVGBGj+eTd8smrjNcovr/rgRWSvvprmS9hzLFhlGkF5NgSkJM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Okbr4Ozr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Okbr4Ozr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F264AC433C7;
	Tue, 16 Jan 2024 20:09:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1705435747;
	bh=CKAs7OI8Rpams7OjhLKq0DxNO2gsVCk9Qwh7vae31Mg=;
	h=Date:To:From:Subject:From;
	b=Okbr4OzrVlZdlWwapsBjtYXNbTdWW0SMXhpInUe+8fdt3WgZHOEplWs75tQewka41
	 c6qk8LJBc6ApkxL2q/HggNcQrMnBhUN5hJkpKBc2QCKCnpum26Xwe/kZAhaDsEclfd
	 WPIeDCQ9fMXliLSyvgbaFPSY+A8EsmtAqeFgk2Yw=
Date: Tue, 16 Jan 2024 12:09:04 -0800
To: mm-commits@vger.kernel.org,mcgrof@kernel.org,manfred@colorfullife.com,keescook@chromium.org,joel.granados@gmail.com,ebiederm@xmission.com,dave@stgolabs.net,brauner@kernel.org,legion@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + sysctl-allow-change-system-v-ipc-sysctls-inside-ipc-namespace.patch added to mm-nonmm-unstable branch
Message-Id: <20240116200906.F264AC433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: sysctl: allow change system v ipc sysctls inside ipc namespace
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     sysctl-allow-change-system-v-ipc-sysctls-inside-ipc-namespace.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/sysctl-allow-change-system-v-ipc-sysctls-inside-ipc-namespace.patch

This patch will later appear in the mm-nonmm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Alexey Gladkov <legion@kernel.org>
Subject: sysctl: allow change system v ipc sysctls inside ipc namespace
Date: Mon, 15 Jan 2024 15:46:41 +0000

Patch series "Allow to change ipc/mq sysctls inside ipc namespace", v3.

Right now ipc and mq limits count as per ipc namespace, but only real root
can change them.  By default, the current values of these limits are such
that it can only be reduced.  Since only root can change the values, it is
impossible to reduce these limits in the rootless container.

We can allow limit changes within ipc namespace because mq parameters are
limited by RLIMIT_MSGQUEUE and ipc parameters are not limited to anything
other than cgroups.


This patch (of 3):

Rootless containers are not allowed to modify kernel IPC parameters.

All default limits are set to such high values that in fact there are no
limits at all.  All limits are not inherited and are initialized to
default values when a new ipc_namespace is created.

For new ipc_namespace:

size_t       ipc_ns.shm_ctlmax = SHMMAX; // (ULONG_MAX - (1UL << 24))
size_t       ipc_ns.shm_ctlall = SHMALL; // (ULONG_MAX - (1UL << 24))
int          ipc_ns.shm_ctlmni = IPCMNI; // (1 << 15)
int          ipc_ns.shm_rmid_forced = 0;
unsigned int ipc_ns.msg_ctlmax = MSGMAX; // 8192
unsigned int ipc_ns.msg_ctlmni = MSGMNI; // 32000
unsigned int ipc_ns.msg_ctlmnb = MSGMNB; // 16384

The shm_tot (total amount of shared pages) has also ceased to be global,
it is located in ipc_namespace and is not inherited from anywhere.

In such conditions, it cannot be said that these limits limit anything. 
The real limiter for them is cgroups.

If we allow rootless containers to change these parameters, then it can
only be reduced.

Link: https://lkml.kernel.org/r/cover.1705333426.git.legion@kernel.org
Link: https://lkml.kernel.org/r/d2f4603305cbfed58a24755aa61d027314b73a45.1705333426.git.legion@kernel.org
Signed-off-by: Alexey Gladkov <legion@kernel.org>
Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
Link: https://lkml.kernel.org/r/e2d84d3ec0172cfff759e6065da84ce0cc2736f8.1663756794.git.legion@kernel.org
Cc: Christian Brauner <brauner@kernel.org>
Cc: Joel Granados <joel.granados@gmail.com>
Cc: Kees Cook <keescook@chromium.org>
Cc: Luis Chamberlain <mcgrof@kernel.org>
Cc: Manfred Spraul <manfred@colorfullife.com>
Cc: Davidlohr Bueso <dave@stgolabs.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 ipc/ipc_sysctl.c |   37 +++++++++++++++++++++++++++++++++++--
 1 file changed, 35 insertions(+), 2 deletions(-)

--- a/ipc/ipc_sysctl.c~sysctl-allow-change-system-v-ipc-sysctls-inside-ipc-namespace
+++ a/ipc/ipc_sysctl.c
@@ -14,6 +14,7 @@
 #include <linux/ipc_namespace.h>
 #include <linux/msg.h>
 #include <linux/slab.h>
+#include <linux/cred.h>
 #include "util.h"
 
 static int proc_ipc_dointvec_minmax_orphans(struct ctl_table *table, int write,
@@ -190,25 +191,57 @@ static int set_is_seen(struct ctl_table_
 	return &current->nsproxy->ipc_ns->ipc_set == set;
 }
 
+static void ipc_set_ownership(struct ctl_table_header *head,
+			      struct ctl_table *table,
+			      kuid_t *uid, kgid_t *gid)
+{
+	struct ipc_namespace *ns =
+		container_of(head->set, struct ipc_namespace, ipc_set);
+
+	kuid_t ns_root_uid = make_kuid(ns->user_ns, 0);
+	kgid_t ns_root_gid = make_kgid(ns->user_ns, 0);
+
+	*uid = uid_valid(ns_root_uid) ? ns_root_uid : GLOBAL_ROOT_UID;
+	*gid = gid_valid(ns_root_gid) ? ns_root_gid : GLOBAL_ROOT_GID;
+}
+
 static int ipc_permissions(struct ctl_table_header *head, struct ctl_table *table)
 {
 	int mode = table->mode;
 
 #ifdef CONFIG_CHECKPOINT_RESTORE
-	struct ipc_namespace *ns = current->nsproxy->ipc_ns;
+	struct ipc_namespace *ns =
+		container_of(head->set, struct ipc_namespace, ipc_set);
 
 	if (((table->data == &ns->ids[IPC_SEM_IDS].next_id) ||
 	     (table->data == &ns->ids[IPC_MSG_IDS].next_id) ||
 	     (table->data == &ns->ids[IPC_SHM_IDS].next_id)) &&
 	    checkpoint_restore_ns_capable(ns->user_ns))
 		mode = 0666;
+	else
 #endif
-	return mode;
+	{
+		kuid_t ns_root_uid;
+		kgid_t ns_root_gid;
+
+		ipc_set_ownership(head, table, &ns_root_uid, &ns_root_gid);
+
+		if (uid_eq(current_euid(), ns_root_uid))
+			mode >>= 6;
+
+		else if (in_egroup_p(ns_root_gid))
+			mode >>= 3;
+	}
+
+	mode &= 7;
+
+	return (mode << 6) | (mode << 3) | mode;
 }
 
 static struct ctl_table_root set_root = {
 	.lookup = set_lookup,
 	.permissions = ipc_permissions,
+	.set_ownership = ipc_set_ownership,
 };
 
 bool setup_ipc_sysctls(struct ipc_namespace *ns)
_

Patches currently in -mm which might be from legion@kernel.org are

sysctl-allow-change-system-v-ipc-sysctls-inside-ipc-namespace.patch
docs-add-information-about-ipc-sysctls-limitations.patch
sysctl-allow-to-change-limits-for-posix-messages-queues.patch

