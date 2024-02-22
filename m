Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B43AB137931
	for <mm-commits@vger.kernel.org>; Thu, 22 Feb 2024 23:39:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708645177; cv=none; b=Eua0AsdfU3PMnlGmbtxo/HPCUQv/8qllPMr/QuQYPpnaaiHRRipsHtQEOq25jZmVCAU6tjMhcF6f98enGZB+qNVx8DAuwhCo41bJW1TH87+22ohddnn3GXaomq/ageW5ySj6xIJG4Y1srCD3j1Zh8pvQKzan7gPnhdLZYi2P9zQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708645177; c=relaxed/simple;
	bh=eYmv44wQ5lF8FoKhRx5zHNY49s7xCuzf4BbydVI6vxA=;
	h=Date:To:From:Subject:Message-Id; b=BEdWNcgul+R8EBLKsqB7obFGZ5lks3ZjdzQh+RyhOCAKGSyi5hPY14AJD1/4KrxLmsyxZQDxJxyxlPqxNn6Xla9iCTX/X9MN57JA6HB7SxjRrs4HRBL/jHiJNxMKHCwXKOUXGzc6f8os6+/sTHcFjszUk25r8Y4jWKbF4tJLVIw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=WWMZ4ajV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="WWMZ4ajV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 272C1C433C7;
	Thu, 22 Feb 2024 23:39:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1708645177;
	bh=eYmv44wQ5lF8FoKhRx5zHNY49s7xCuzf4BbydVI6vxA=;
	h=Date:To:From:Subject:From;
	b=WWMZ4ajVQUx06AQscCNWkdJrbPkGoacKM4g0raCMTByaHJcmlyNnn3Hdimn9/Z6Os
	 bGS6+w5ww/ts0tGGrTnITZ8lUk6AD6nuBt2NIln+LSv3qIlZSwXczLOV7x6B4sKuyG
	 46GQlzXhIgJw88pS+bTk3rn7y1IGitaXTKugUsBU=
Date: Thu, 22 Feb 2024 15:39:36 -0800
To: mm-commits@vger.kernel.org,mcgrof@kernel.org,manfred@colorfullife.com,keescook@chromium.org,joel.granados@gmail.com,ebiederm@xmission.com,dave@stgolabs.net,brauner@kernel.org,legion@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] sysctl-allow-change-system-v-ipc-sysctls-inside-ipc-namespace.patch removed from -mm tree
Message-Id: <20240222233937.272C1C433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: sysctl: allow change system v ipc sysctls inside ipc namespace
has been removed from the -mm tree.  Its filename was
     sysctl-allow-change-system-v-ipc-sysctls-inside-ipc-namespace.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


