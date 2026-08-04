Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B0B8429CEC;
	Tue,  4 Aug 2026 04:05:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785816303; cv=none; b=LW2yVOJ/N88lJtfyMWSOO+pfHVTr+KF7Ue9Mc47CmjR52SCM5eJmvvvCq1ns+cDmAyNGbRKIrHgWougn4lLV0FvAfsS9I6AnQoNxml+VkVJftwTjweu7SR2w6cXV0DzPyvCq+ko6QFWiMGABtRjPRpyeoY/iwoTnTSt4fzs7Bf8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785816303; c=relaxed/simple;
	bh=27+yEA0ZNptuAPzl3UoqDQPIAGXEKV8oVMNTt3CugU0=;
	h=Date:To:From:Subject:Message-Id; b=ph+b2qIcZ3MF64LvPJS5MTANLnA4FEj3/ZEunn+g7l2HQEObL5SByKbkL3TnXpfmRP3J16QYB7WWEBEudrPZkiHLjxzOcXNgLOicmCt5UETeKLg8v8xJxcsWFDE961Fq/d8PeInSzs8UJ/7l8R9TyF8ciBjI3xumB57UOzLzaSE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=KM6tykRI; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="KM6tykRI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ADE941F00A3A;
	Tue,  4 Aug 2026 04:05:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1785816301;
	bh=cumtXLsU6jUvbUxZNomgzC5XyscIUzwyJwBePremtAs=;
	h=Date:To:From:Subject;
	b=KM6tykRIA9bmBZkJXjyXuADzPmREvcF1s0BfOfNjwZsEpC4pGgqPLVbRTr3pJHK+m
	 ndmp6mN9UwaXyhtsGDtYetW5/Llt3g8R2Uy405UPkPQ6MBIMbN6EaRXXVQ+/vacUE2
	 IuIjydJWsjKo2d2/sQ1UjRx92j9zZVhzcWhufBKw=
Date: Mon, 03 Aug 2026 21:05:01 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,piaojun@huawei.com,mark@fasheh.com,junxiao.bi@oracle.com,joseph.qi@linux.alibaba.com,jlbec@evilplan.org,heming.zhao@suse.com,gechangwei@live.cn,hexlabsecurity@proton.me,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] ocfs2-validate-lengths-in-dlm_mig_lockres_handler.patch removed from -mm tree
Message-Id: <20260804040501.ADE941F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: ocfs2: validate lengths in dlm_mig_lockres_handler
has been removed from the -mm tree.  Its filename was
     ocfs2-validate-lengths-in-dlm_mig_lockres_handler.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


