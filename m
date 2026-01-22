Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C6284218B6
	for <mm-commits@vger.kernel.org>; Thu, 22 Jan 2026 16:06:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769098013; cv=none; b=UQZg2NDfLvwPUfGd0sGPIokW9e4djN2wERY0IYEOvk3OcOoxUcoLuqbGG0pkZXC1JoNflo8ik550SekNdlATaN5YZATOHN0fMcT3xVoZb1TGVGa4wCkrUU96+Np9Lnsy7c1ZrxBPO7wR2qpTaDOJUxowbm2hskEFPvq72Pdtia4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769098013; c=relaxed/simple;
	bh=okS564Nb42D2wJsFhs+XwKYvx95Ou6eJW5w50wfGHVU=;
	h=Date:To:From:Subject:Message-Id; b=CAEsNenBotf8KDRevIcJ/fUNxfAgpppAZDzgU3XnqgZSLBri6PhuQbL4bpWY3wyCtrOb0k+9e2p1tGujVraiaK9+6DPVNpiP6xoGZCDxgl5vvZ3zpHQ7XGWQkx6vkbFgDCC172sUaqURvJltY3UGlmuGst4kGRVZyb2bWBtnZvI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=vR6S946I; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="vR6S946I"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB359C116C6;
	Thu, 22 Jan 2026 16:06:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1769098011;
	bh=okS564Nb42D2wJsFhs+XwKYvx95Ou6eJW5w50wfGHVU=;
	h=Date:To:From:Subject:From;
	b=vR6S946I6/84BFw+txIZV4kJqyQIyzZ7fkAJQZoIsiiPkqv87WL5B0JpfMXw1p2tF
	 H3k1alYGJjCxIwNOm8QPHz0g3r0ZGoVZPMJ4jAugLdvPT8BzHrITU0Yi2zdHnf8KHL
	 RTLMGtF5Rz6Er2v1n3eIzLerdM2oq/KtwC3VDVmc=
Date: Thu, 22 Jan 2026 08:06:51 -0800
To: mm-commits@vger.kernel.org,serge@hallyn.com,legion@kernel.org,ebiederm@xmission.com,omosnace@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + ipc-dont-audit-capability-check-in-ipc_permissions.patch added to mm-nonmm-unstable branch
Message-Id: <20260122160651.DB359C116C6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: ipc: don't audit capability check in ipc_permissions()
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     ipc-dont-audit-capability-check-in-ipc_permissions.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/ipc-dont-audit-capability-check-in-ipc_permissions.patch

This patch will later appear in the mm-nonmm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

------------------------------------------------------
From: Ondrej Mosnacek <omosnace@redhat.com>
Subject: ipc: don't audit capability check in ipc_permissions()
Date: Thu, 22 Jan 2026 15:13:03 +0100

The IPC sysctls implement the ctl_table_root::permissions hook and they
override the file access mode based on the CAP_CHECKPOINT_RESTORE
capability, which is being checked regardless of whether any access is
actually denied or not, so if an LSM denies the capability, an audit
record may be logged even when access is in fact granted.

It wouldn't be viable to restructure the sysctl permission logic to only
check the capability when the access would be actually denied if it's not
granted.  Thus, do the same as in net_ctl_permissions() (net/sysctl_net.c)
- switch from ns_capable() to ns_capable_noaudit(), so that the check
never emits an audit record.

Link: https://lkml.kernel.org/r/20260122141303.241133-1-omosnace@redhat.com
Fixes: 0889f44e2810 ("ipc: Check permissions for checkpoint_restart sysctls at open time")
Signed-off-by: Ondrej Mosnacek <omosnace@redhat.com>
Acked-by: Alexey Gladkov <legion@kernel.org>
Cc: Eric Biederman <ebiederm@xmission.com>
Cc: Serge Hallyn <serge@hallyn.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/capability.h |    6 ++++++
 ipc/ipc_sysctl.c           |    2 +-
 2 files changed, 7 insertions(+), 1 deletion(-)

--- a/include/linux/capability.h~ipc-dont-audit-capability-check-in-ipc_permissions
+++ a/include/linux/capability.h
@@ -203,6 +203,12 @@ static inline bool checkpoint_restore_ns
 		ns_capable(ns, CAP_SYS_ADMIN);
 }
 
+static inline bool checkpoint_restore_ns_capable_noaudit(struct user_namespace *ns)
+{
+	return ns_capable_noaudit(ns, CAP_CHECKPOINT_RESTORE) ||
+		ns_capable_noaudit(ns, CAP_SYS_ADMIN);
+}
+
 /* audit system wants to get cap info from files as well */
 int get_vfs_caps_from_disk(struct mnt_idmap *idmap,
 			   const struct dentry *dentry,
--- a/ipc/ipc_sysctl.c~ipc-dont-audit-capability-check-in-ipc_permissions
+++ a/ipc/ipc_sysctl.c
@@ -214,7 +214,7 @@ static int ipc_permissions(struct ctl_ta
 	if (((table->data == &ns->ids[IPC_SEM_IDS].next_id) ||
 	     (table->data == &ns->ids[IPC_MSG_IDS].next_id) ||
 	     (table->data == &ns->ids[IPC_SHM_IDS].next_id)) &&
-	    checkpoint_restore_ns_capable(ns->user_ns))
+	    checkpoint_restore_ns_capable_noaudit(ns->user_ns))
 		mode = 0666;
 	else
 #endif
_

Patches currently in -mm which might be from omosnace@redhat.com are

ipc-dont-audit-capability-check-in-ipc_permissions.patch

