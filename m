Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A3A42D8DD9
	for <mm-commits@vger.kernel.org>; Wed,  3 Dec 2025 22:12:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764799942; cv=none; b=tL22j7gdzqRqPO47ufEhv682ZEQKD41boMFJ7hSfeqabkNa14Z4ZFNu+2JYB25j7cxYk216STUbd9MlbQxGpchn4Xmn6tlPhINr7LE0vqrUIBE+/n475tEt5ZugoEQu62kU/29J6N1gHmCvohpcQsNLpmbnsRicK0EUILXk1C4Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764799942; c=relaxed/simple;
	bh=k5ZdY1JPs+sgkj9M+LDhQAo9ke7dW/GEK9laAoDIFYU=;
	h=Date:To:From:Subject:Message-Id; b=dmNwifjosdUnXtV+z4SMvQugL/GhHnOXkGbxbc0wh7ba0RwxiXliZeoS7SAQ+MocQW0xzszihbdMXFa1z/803QiLJWbouysOdFUccme+KGjriLG4bQUgfBEEF1FBybbpE4LFAU2fnxVF/wt65CXV9YNsQZBpR69miXaCfLYe2cw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=VHhyRMDV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="VHhyRMDV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E6E9CC4CEF5;
	Wed,  3 Dec 2025 22:12:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1764799942;
	bh=k5ZdY1JPs+sgkj9M+LDhQAo9ke7dW/GEK9laAoDIFYU=;
	h=Date:To:From:Subject:From;
	b=VHhyRMDVB5/8liY/KiKLRtF6QBbRtxTGfE3jd1WlbZuPegtIgcQ+6moNWLqta3WXl
	 dcu4CvwLroDuIkHVAk6PVEQ0XmK3UDUs/ivMnV01AdDNaw9ANhl2djec3MnJtThxQs
	 PmlHg2R9hfYudoL3qsx5mQtSDnjsebRyBLXeGXfw=
Date: Wed, 03 Dec 2025 14:12:21 -0800
To: mm-commits@vger.kernel.org,piaojun@huawei.com,mark@fasheh.com,junxiao.bi@oracle.com,joseph.qi@linux.alibaba.com,jlbec@evilplan.org,heming.zhao@suse.com,gechangwei@live.cn,david.hunter.linux@gmail.com,albinbabuvarghese20@gmail.com,eraykrdg1@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + ocfs2-add-ocfs2_emergency_state-helper-and-apply-to-setattr.patch added to mm-nonmm-unstable branch
Message-Id: <20251203221221.E6E9CC4CEF5@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: ocfs2: add ocfs2_emergency_state helper and apply to setattr
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     ocfs2-add-ocfs2_emergency_state-helper-and-apply-to-setattr.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/ocfs2-add-ocfs2_emergency_state-helper-and-apply-to-setattr.patch

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

ocfs2-add-ocfs2_emergency_state-helper-and-apply-to-setattr.patch
ocfs2-convert-remaining-read-only-checks-to-ocfs2_emergency_state.patch

