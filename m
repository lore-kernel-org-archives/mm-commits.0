Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A54A233721;
	Fri,  3 Jul 2026 01:47:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783043228; cv=none; b=PUREu87//tAFptaaRyVdMYGqnPJCahjTS9FTptEnPp9rsEINdUWsBb6yS3sIO2YaEEcxmEDifqbmqZq1RTF372j+qR8oBwr0LABsyuKkRpckZPJnoFRUr3UYNzPmBrW6OyRe+LKfoi5XBa/kloqiEjXBmgZiRhuqCQg295WPF+8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783043228; c=relaxed/simple;
	bh=85bL5EhufkK8E/+zvpSd1INtd01eMnchbkxwYvSLNPc=;
	h=Date:To:From:Subject:Message-Id; b=TsJ7cWW2LGbQorGcxyNf+v/LGtwPed6EI0C/9vRJ+Wv1WswD/Jw1Msa6RCxNMPbT94I5zHm5wD8oRv3IQDOcqg31jAPvBVNkksfKrzDSTC5WkVSm0zg+/IwjtgSG9Nd63WLwfc6zmVrMUqU+ZdPtnHsJUTtVNVA3reiuLOCsHj8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Cnd+AMmr; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Cnd+AMmr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 037291F00A3A;
	Fri,  3 Jul 2026 01:47:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1783043227;
	bh=EKb0Yg6YMSVtW3/6aW9IZAyttrAjzdvMbJKcxVIeODg=;
	h=Date:To:From:Subject;
	b=Cnd+AMmrQffLp3y7OJzh81nr8kC3QnDHJGtOm1Chvsd7Ti8bdvMtNBKkTmTgAKHIu
	 /Sc71Fn/lO5YRajRMHbVIHfPnfWiOsGgjnq0usOpS9vjMJaSSbFjx2FrYIRaOZSazl
	 C6+jUoxnmUJVgmEb/T0urYWuNA15GaCpDp2kVZZg=
Date: Thu, 02 Jul 2026 18:47:06 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,piaojun@huawei.com,mark@fasheh.com,junxiao.bi@oracle.com,joseph.qi@linux.alibaba.com,jlbec@evilplan.org,heming.zhao@suse.com,gechangwei@live.cn,hexlabsecurity@proton.me,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + ocfs2-validate-lengths-in-dlm_mig_lockres_handler.patch added to mm-new branch
Message-Id: <20260703014707.037291F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: ocfs2: validate lengths in dlm_mig_lockres_handler
has been added to the -mm mm-new branch.  Its filename is
     ocfs2-validate-lengths-in-dlm_mig_lockres_handler.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/ocfs2-validate-lengths-in-dlm_mig_lockres_handler.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

If a few days of testing in mm-new is successful, the patch will me moved
into mm.git's mm-unstable branch, which is included in linux-next

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
From: Bryam Vargas <hexlabsecurity@proton.me>
Subject: ocfs2: validate lengths in dlm_mig_lockres_handler
Date: Mon, 29 Jun 2026 00:01:44 -0500

A node receiving a DLM_MIG_LOCKRES message trusts several fields of the
peer-supplied dlm_migratable_lockres without validation.  num_locks and
lockname_len are bounded only on the sending side, and the message is
never checked to actually carry num_locks migratable_lock entries.  As a
result dlm_process_recovery_data() walks mres->ml[0..num_locks) past the
kmalloc(data_len) copy of the message (an out-of-bounds read that ends in
a BUG_ON panic), and dlm_init_lockres() copies lockname_len bytes into the
fixed 32-byte o2dlm_lockname slab object (a heap out-of-bounds write). 
Both are reachable by any node in the domain.

Validate these fields right after dlm_grab(), before anything uses them --
including the not-joined error path, which already prints mres->lockname
with the unbounded lockname_len as a %.*s precision.  Reject the message
unless lockname_len <= DLM_LOCKID_NAME_MAX, num_locks <=
DLM_MAX_MIGRATABLE_LOCKS (the bound the sender already asserts), and the
payload is large enough to hold the claimed locks.  Conforming recovery
and migration messages are unaffected.

Link: https://lore.kernel.org/20260629-b4-disp-94fb6521-v1-2-6953bcc0421f@proton.me
Fixes: 6714d8e86bf4 ("[PATCH] OCFS2: The Second Oracle Cluster Filesystem")
Signed-off-by: Bryam Vargas <hexlabsecurity@proton.me>
Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: Mark Fasheh <mark@fasheh.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Changwei Ge <gechangwei@live.cn>
Cc: Jun Piao <piaojun@huawei.com>
Cc: Heming Zhao <heming.zhao@suse.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/dlm/dlmrecovery.c |    9 +++++++++
 1 file changed, 9 insertions(+)

--- a/fs/ocfs2/dlm/dlmrecovery.c~ocfs2-validate-lengths-in-dlm_mig_lockres_handler
+++ a/fs/ocfs2/dlm/dlmrecovery.c
@@ -1357,6 +1357,15 @@ int dlm_mig_lockres_handler(struct o2net
 	if (!dlm_grab(dlm))
 		return -EINVAL;
 
+	if (mres->lockname_len > DLM_LOCKID_NAME_MAX ||
+	    mres->num_locks > DLM_MAX_MIGRATABLE_LOCKS ||
+	    be16_to_cpu(msg->data_len) < struct_size(mres, ml, mres->num_locks)) {
+		mlog(ML_ERROR, "%s: invalid lockres migration message from %u\n",
+		     dlm->name, mres->master);
+		dlm_put(dlm);
+		return -EINVAL;
+	}
+
 	if (!dlm_joined(dlm)) {
 		mlog(ML_ERROR, "Domain %s not joined! "
 			  "lockres %.*s, master %u\n",
_

Patches currently in -mm which might be from hexlabsecurity@proton.me are

ocfs2-bound-namelen-in-dlm_migrate_request_handler.patch
ocfs2-validate-lengths-in-dlm_mig_lockres_handler.patch

