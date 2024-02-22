Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 291DB137931
	for <mm-commits@vger.kernel.org>; Thu, 22 Feb 2024 23:39:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708645179; cv=none; b=eXJDZhy45/Rarb9Xb92ppS6EYG3HZt6tPVHukNVhf+2K++LKfXyQ2O80GZkuA0owlZJl8cb+EcsQCvuHk4RgdiK+28m9YPU4Lpd7cn39HWUxOKfmiBUoyserywyh3Evx1sDHSnyTNWMS3mVdP+GemY2KCgGLYazKF1iW+pzOxYo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708645179; c=relaxed/simple;
	bh=zTJrxqthm+yuupwQsn83ka2/2Qbat+Y/tHml4PykWcM=;
	h=Date:To:From:Subject:Message-Id; b=SSjQzpcRzapfh8Kcw3SQ0oswtK1MzJs7wcaBcInk35yZLhd6U9gXIcLmrzcHOqo5tx/6TyFQ+8eZsOqitgyHI/wbPQ77RS/zoRpsO4tRN3zBGGsM22HvHgwvvy2qYDipl2Qv2OIsCZnO93X5/omZpoEMAhg6/lgWQg75Ad+jx7A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=DSO/hgKn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="DSO/hgKn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE45DC433F1;
	Thu, 22 Feb 2024 23:39:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1708645179;
	bh=zTJrxqthm+yuupwQsn83ka2/2Qbat+Y/tHml4PykWcM=;
	h=Date:To:From:Subject:From;
	b=DSO/hgKnn/e4DVKQct34jkXf68iLgagu7gDm4hQ0H/uV7G39BGx3T2JZvwH6bJBdd
	 KU77CGMHIZMtENLMjrWM+7gaMRaqKJIdxF1VRJDEFyzCpzOEvFrukCQhss+urxzr3R
	 ocPeOzPcl7M3r49eOzeKB9ooGLiXbBMuTVXGMVLQ=
Date: Thu, 22 Feb 2024 15:39:38 -0800
To: mm-commits@vger.kernel.org,mcgrof@kernel.org,manfred@colorfullife.com,keescook@chromium.org,joel.granados@gmail.com,ebiederm@xmission.com,dave@stgolabs.net,brauner@kernel.org,legion@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] sysctl-allow-to-change-limits-for-posix-messages-queues.patch removed from -mm tree
Message-Id: <20240222233938.EE45DC433F1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: sysctl: allow to change limits for posix messages queues
has been removed from the -mm tree.  Its filename was
     sysctl-allow-to-change-limits-for-posix-messages-queues.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Alexey Gladkov <legion@kernel.org>
Subject: sysctl: allow to change limits for posix messages queues
Date: Mon, 15 Jan 2024 15:46:43 +0000

All parameters of posix messages queues (queues_max/msg_max/msgsize_max)
end up being limited by RLIMIT_MSGQUEUE.  The code in mqueue_get_inode is
where that limiting happens.

The RLIMIT_MSGQUEUE is bound to the user namespace and is counted
hierarchically.

We can allow root in the user namespace to modify the posix messages
queues parameters.

Link: https://lkml.kernel.org/r/6ad67f23d1459a4f4339f74aa73bac0ecf3995e1.1705333426.git.legion@kernel.org
Signed-off-by: Alexey Gladkov <legion@kernel.org>
Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
Link: https://lkml.kernel.org/r/7eb21211c8622e91d226e63416b1b93c079f60ee.1663756794.git.legion@kernel.org
Cc: Christian Brauner <brauner@kernel.org>
Cc: Davidlohr Bueso <dave@stgolabs.net>
Cc: Joel Granados <joel.granados@gmail.com>
Cc: Kees Cook <keescook@chromium.org>
Cc: Luis Chamberlain <mcgrof@kernel.org>
Cc: Manfred Spraul <manfred@colorfullife.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 ipc/mq_sysctl.c |   36 ++++++++++++++++++++++++++++++++++++
 1 file changed, 36 insertions(+)

--- a/ipc/mq_sysctl.c~sysctl-allow-to-change-limits-for-posix-messages-queues
+++ a/ipc/mq_sysctl.c
@@ -12,6 +12,7 @@
 #include <linux/stat.h>
 #include <linux/capability.h>
 #include <linux/slab.h>
+#include <linux/cred.h>
 
 static int msg_max_limit_min = MIN_MSGMAX;
 static int msg_max_limit_max = HARD_MSGMAX;
@@ -76,8 +77,43 @@ static int set_is_seen(struct ctl_table_
 	return &current->nsproxy->ipc_ns->mq_set == set;
 }
 
+static void mq_set_ownership(struct ctl_table_header *head,
+			     struct ctl_table *table,
+			     kuid_t *uid, kgid_t *gid)
+{
+	struct ipc_namespace *ns =
+		container_of(head->set, struct ipc_namespace, mq_set);
+
+	kuid_t ns_root_uid = make_kuid(ns->user_ns, 0);
+	kgid_t ns_root_gid = make_kgid(ns->user_ns, 0);
+
+	*uid = uid_valid(ns_root_uid) ? ns_root_uid : GLOBAL_ROOT_UID;
+	*gid = gid_valid(ns_root_gid) ? ns_root_gid : GLOBAL_ROOT_GID;
+}
+
+static int mq_permissions(struct ctl_table_header *head, struct ctl_table *table)
+{
+	int mode = table->mode;
+	kuid_t ns_root_uid;
+	kgid_t ns_root_gid;
+
+	mq_set_ownership(head, table, &ns_root_uid, &ns_root_gid);
+
+	if (uid_eq(current_euid(), ns_root_uid))
+		mode >>= 6;
+
+	else if (in_egroup_p(ns_root_gid))
+		mode >>= 3;
+
+	mode &= 7;
+
+	return (mode << 6) | (mode << 3) | mode;
+}
+
 static struct ctl_table_root set_root = {
 	.lookup = set_lookup,
+	.permissions = mq_permissions,
+	.set_ownership = mq_set_ownership,
 };
 
 bool setup_mq_sysctls(struct ipc_namespace *ns)
_

Patches currently in -mm which might be from legion@kernel.org are


