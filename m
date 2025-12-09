Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06246305958
	for <mm-commits@vger.kernel.org>; Tue,  9 Dec 2025 19:33:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765308808; cv=none; b=MnROzfTnZpY2TAWl3yXJjPUJPmx6HlJ+G0vR9pd3RMNSm6zSPxQFDkAv7Tt9G5mUAsNCLI3t5UbVYpOmp8r9MOruWE7PGGHq4svi6Ke8uryN0ATY0ZvFqkbHRD7u2UEYEkTqGRMJpDdzYmqhu51nPPV6bOT/2BC4Tcqz9P6IEWc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765308808; c=relaxed/simple;
	bh=ZndmE8a9Z6s37H4wa7qxiKqkDKp5nNwokAsyHm9XwU8=;
	h=Date:To:From:Subject:Message-Id; b=qoVZvcJyhN4mDElK9PHZJvXSVoeNi4KXkca0W7gDQ/NLfStiu48vRkE4f7kfJYEwAZHhFSgoIfuXeGP0M6VbzL0ZyjJoCh2/tSDLQCThpJujgTaP9HDyi0/1zBXoL6x7Cwl84rtrzZ1IVyprpUiHqCmgz/4kHaUw6Jrv3nUWKqU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=dMq8utL4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="dMq8utL4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 82095C4CEF5;
	Tue,  9 Dec 2025 19:33:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1765308807;
	bh=ZndmE8a9Z6s37H4wa7qxiKqkDKp5nNwokAsyHm9XwU8=;
	h=Date:To:From:Subject:From;
	b=dMq8utL4rjRZN/++5uBJ6biUR9T+mXUgPGJYB2FzgTcGjcrnY3j3dhyo1Nqg+kSWu
	 pGo1uSFIsfXR4p30M6bDZoXcBlYK3qAKcO7dWNmivtxKwnFnKPrJcOvWqWTlVpOib/
	 4VP1OhpM5Oxo16BjVaA7dlUoIO37vxrLPiVI1P4Q=
Date: Tue, 09 Dec 2025 11:33:27 -0800
To: mm-commits@vger.kernel.org,piaojun@huawei.com,mark@fasheh.com,junxiao.bi@oracle.com,joseph.qi@linux.alibaba.com,jlbec@evilplan.org,heming.zhao@suse.com,gechangwei@live.cn,david.hunter.linux@gmail.com,albinbabuvarghese20@gmail.com,eraykrdg1@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] ocfs2-add-ocfs2_emergency_state-helper-and-apply-to-setattr.patch removed from -mm tree
Message-Id: <20251209193327.82095C4CEF5@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: ocfs2: add ocfs2_emergency_state helper and apply to setattr
has been removed from the -mm tree.  Its filename was
     ocfs2-add-ocfs2_emergency_state-helper-and-apply-to-setattr.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Ahmet Eray Karadag <eraykrdg1@gmail.com>
Subject: ocfs2: add ocfs2_emergency_state helper and apply to setattr
Date: Wed, 3 Dec 2025 06:34:25 +0300

Patch series "ocfs2: Refactor read-only checks to use
ocfs2_emergency_state", v4.

Following the fix for the `make_bad_inode` validation failure (syzbot ID:
b93b65ee321c97861072), this separate series introduces a new helper
function, `ocfs2_emergency_state()`, to improve and centralize read-only
and error state checking.

This is modeled after the `ext4_emergency_state()` pattern, providing a
single, unified location for checking all filesystem-level emergency
conditions.  This makes the code cleaner and ensures that any future
checks (e.g., for fatal error states) can be added in one place.

This series is structured as follows:

1.  The first patch introduces the `ocfs2_emergency_state()` helper
    (currently checking for -EROFS) and applies it to `ocfs2_setattr`
    to provide a "fail-fast" mechanism, as suggested by Albin
    Babu Varghese.
2.  The second patch completes the refactoring by converting all
    remaining read-only checks throughout OCFS2 to use this new helper.


This patch (of 2):

To centralize error checking, follow the pattern of other filesystems like
ext4 (which uses `ext4_emergency_state()`), and prepare for future
enhancements, this patch introduces a new helper function:
`ocfs2_emergency_state()`.

The purpose of this helper is to provide a single, unified location for
checking all filesystem-level emergency conditions.  In this initial
implementation, the function only checks for the existing hard and soft
read-only modes, returning -EROFS if either is set.

This provides a foundation where future checks (e.g., for fatal error
states returning -EIO, or shutdown states) can be easily added in one
place.

This patch also adds this new check to the beginning of `ocfs2_setattr()`.
This ensures that operations like `ftruncate` (which triggered the
original BUG) fail-fast with -EROFS when the filesystem is already in a
read-only state.

Link: https://lkml.kernel.org/r/cover.1764728893.git.eraykrdg1@gmail.com
Link: https://lkml.kernel.org/r/e9e975bcaaff8dbc155b70fbc1b2798a2e36e96f.1764728893.git.eraykrdg1@gmail.com
Co-developed-by: Albin Babu Varghese <albinbabuvarghese20@gmail.com>
Signed-off-by: Albin Babu Varghese <albinbabuvarghese20@gmail.com>
Signed-off-by: Ahmet Eray Karadag <eraykrdg1@gmail.com>
Suggested-by: Heming Zhao <heming.zhao@suse.com>
Reviewed-by: Heming Zhao <heming.zhao@suse.com>
Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: Mark Fasheh <mark@fasheh.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Changwei Ge <gechangwei@live.cn>
Cc: Jun Piao <piaojun@huawei.com>
Cc: David Hunter <david.hunter.linux@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/file.c  |    6 ++++++
 fs/ocfs2/ocfs2.h |   18 ++++++++++++++++++
 2 files changed, 24 insertions(+)

--- a/fs/ocfs2/file.c~ocfs2-add-ocfs2_emergency_state-helper-and-apply-to-setattr
+++ a/fs/ocfs2/file.c
@@ -1136,6 +1136,12 @@ int ocfs2_setattr(struct mnt_idmap *idma
 				attr->ia_valid & ATTR_GID ?
 					from_kgid(&init_user_ns, attr->ia_gid) : 0);
 
+	status = ocfs2_emergency_state(osb);
+	if (unlikely(status)) {
+		mlog_errno(status);
+		goto bail;
+	}
+
 	/* ensuring we don't even attempt to truncate a symlink */
 	if (S_ISLNK(inode->i_mode))
 		attr->ia_valid &= ~ATTR_SIZE;
--- a/fs/ocfs2/ocfs2.h~ocfs2-add-ocfs2_emergency_state-helper-and-apply-to-setattr
+++ a/fs/ocfs2/ocfs2.h
@@ -680,6 +680,24 @@ static inline int ocfs2_is_soft_readonly
 	return ret;
 }
 
+static inline int ocfs2_is_readonly(struct ocfs2_super *osb)
+{
+	int ret;
+	spin_lock(&osb->osb_lock);
+	ret = osb->osb_flags & (OCFS2_OSB_SOFT_RO | OCFS2_OSB_HARD_RO);
+	spin_unlock(&osb->osb_lock);
+
+	return ret;
+}
+
+static inline int ocfs2_emergency_state(struct ocfs2_super *osb)
+{
+	if (ocfs2_is_readonly(osb))
+		return -EROFS;
+
+	return 0;
+}
+
 static inline int ocfs2_clusterinfo_valid(struct ocfs2_super *osb)
 {
 	return (osb->s_feature_incompat &
_

Patches currently in -mm which might be from eraykrdg1@gmail.com are


