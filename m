Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A02B53EBF1D
	for <mm-commits@vger.kernel.org>; Sun,  1 Feb 2026 00:17:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769905024; cv=none; b=ApR/hwQ4zOrJ71xvksiE4q9Css6xc0JJKUCCRK9m5mqPPqfJY49IG6WL1f4mvxtgh9dk0A7+F6BmVIVLbpuqT/kWhX9aU9lRcA7Vd0wcwL/+YZVh0DfwA8A8G3XzPR8ueFvJk0LrCqfHlagWHOgSZ2bBGmPuB8h2LtOzhxAExX0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769905024; c=relaxed/simple;
	bh=5lhgFL5Pmff1Ji/WgzE/CMDKN+NVrhDz5jXyoRFHFV8=;
	h=Date:To:From:Subject:Message-Id; b=nJPiRqc/4o3sbPuejyIxPM/yJrz2/IlMuTTEjQtYaAwc5nVodeh8hnRNSifLvTFY9jGhJ+8znUFFZhfVZjYxEsfRX6LnkL3/yXAu3PAohzXjk6GHVZ14KwsOrclVbqp1Dw9FhA0DHQTHqU3a/BzpJDPSPujMGXcKs7nf0VCXc24=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=e0e6okNm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="e0e6okNm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 77442C4CEF1;
	Sun,  1 Feb 2026 00:17:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1769905024;
	bh=5lhgFL5Pmff1Ji/WgzE/CMDKN+NVrhDz5jXyoRFHFV8=;
	h=Date:To:From:Subject:From;
	b=e0e6okNm4H98/+Pu8YzeDNl6BurbPBiDMQLU3E/C1DW3bu+teJJzdQ1tgtVHSII5X
	 q0Pim68eilBi+bUn1+eklqTSaOVvqzM5HLCPHIbdeEDGkMLlLGXbljM/iebObvcdBI
	 MrseRBExMLL3+IViqsK93bfRhoXp+c6biDxHrN/0=
Date: Sat, 31 Jan 2026 16:17:03 -0800
To: mm-commits@vger.kernel.org,serge@hallyn.com,paul@paul-moore.com,legion@kernel.org,ebiederm@xmission.com,omosnace@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] ipc-dont-audit-capability-check-in-ipc_permissions.patch removed from -mm tree
Message-Id: <20260201001704.77442C4CEF1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: ipc: don't audit capability check in ipc_permissions()
has been removed from the -mm tree.  Its filename was
     ipc-dont-audit-capability-check-in-ipc_permissions.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
Acked-by: Serge Hallyn <serge@hallyn.com>
Cc: Eric Biederman <ebiederm@xmission.com>
Cc: Paul Moore <paul@paul-moore.com>
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


