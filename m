Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 438D91DA36
	for <mm-commits@vger.kernel.org>; Tue, 16 Jan 2024 20:09:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705435750; cv=none; b=AXZq5scblq1chrNoIxybJatLlZsy+6ajTEw5ymxmzq45nLJyDmHyv9B/MmLmEEjTGGloaCtIzHSdsaO6ylOfBuIPNJ6PjAEYw/n0NSu7k+S/kNUCMArff4OrMa3uUOlhp4OBN2M7hC8rncNqqb2hH7FkRHWcC3JptOnOo36fU6Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705435750; c=relaxed/simple;
	bh=MUGre+Ntt2WmsUHV+FLRrfKzAJp2k5oYbXEjgllDI+M=;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id; b=gRlwGQWYZbM0AHwuWdgcuu51HFPSisSuZT0p84lxaaCvPy8S82moxYYACwaY1bI5TLxVS69YUIHVFemHIRjgOlpiOHXkP0H88vvgtroNQRmNRc1czagTLqtF2DAwbsBcH6Yo4kdx3eM28hKE1clIhjB941U2ACpDqCIvGMOfAfY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=l84OKv/X; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="l84OKv/X"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA5CCC433C7;
	Tue, 16 Jan 2024 20:09:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1705435750;
	bh=MUGre+Ntt2WmsUHV+FLRrfKzAJp2k5oYbXEjgllDI+M=;
	h=Date:To:From:Subject:From;
	b=l84OKv/XDdTkONrUILqJTKTvTK4bL5/9a+H7RRAUW91HmIfH6W0bs0KM6hDfjOLAW
	 gRg0SlXzBqr3wNp0OvVW3YI95+5cR76lWEbyKxR6DSggaJSJzScnUGvZey7lTJo7ny
	 HuQ91L0KdWXzTICGmJ8jjoTizAAGMMnIrZLDH0xg=
Date: Tue, 16 Jan 2024 12:09:07 -0800
To: mm-commits@vger.kernel.org,mcgrof@kernel.org,manfred@colorfullife.com,keescook@chromium.org,joel.granados@gmail.com,ebiederm@xmission.com,dave@stgolabs.net,brauner@kernel.org,legion@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + sysctl-allow-to-change-limits-for-posix-messages-queues.patch added to mm-nonmm-unstable branch
Message-Id: <20240116200909.AA5CCC433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: sysctl: allow to change limits for posix messages queues
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     sysctl-allow-to-change-limits-for-posix-messages-queues.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/sysctl-allow-to-change-limits-for-posix-messages-queues.patch

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

sysctl-allow-change-system-v-ipc-sysctls-inside-ipc-namespace.patch
docs-add-information-about-ipc-sysctls-limitations.patch
sysctl-allow-to-change-limits-for-posix-messages-queues.patch

