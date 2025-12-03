Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A53F2D6E53
	for <mm-commits@vger.kernel.org>; Wed,  3 Dec 2025 22:20:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764800445; cv=none; b=URYP3NaZ23N+oBKtRaIZ3SIE1cj1LKrNi8kK486/ha1eWyCwbIYN43qdzM1TlR/p/vkN4G8WHF5T9Ka0xG+tG+6D3YWwQdSEMDozL024o1Ma6KinNE8rljKhL4OYVx4gE22raIZ+NwlZVuoqWjktMO/OBrf4Q1mXRxxhTMKGmwM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764800445; c=relaxed/simple;
	bh=nGATh+lLr7s6xU+SW4CJcHiPV2cJpFGp0NOGwOtBkp8=;
	h=Date:To:From:Subject:Message-Id; b=EwZllHbQc/yCOTqjXW0uAHy31AsIb7ItZCvpFnT58lNngyCw/hGTP/JpR17VKkz0e7ANQXayIIOHN2SnJ9+3f1TRAds25g/EtByVB6IZhW7N+K9nt+z5vcEb1UWYwSN0RUc5Dauh7YB0BV38r/2AQYajUS+7hePOygM2MM71Pe0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=POxripGz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="POxripGz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 125B2C4CEF5;
	Wed,  3 Dec 2025 22:20:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1764800445;
	bh=nGATh+lLr7s6xU+SW4CJcHiPV2cJpFGp0NOGwOtBkp8=;
	h=Date:To:From:Subject:From;
	b=POxripGzWtX3zKIdkuCHu5ECRyAYR8VBgGR3j/lJyVFECiEzZMTM+ZDGTDLWqX+de
	 mHHOuuJgu13apikp6nRBPfBRc1r1Cmdez+Csjwo7+dOCai9+N++eCfT/IpCoNr0RlV
	 V6GxUJuLUeGKhszzqHvGULU1k9xq1BZjZT5GoMSA=
Date: Wed, 03 Dec 2025 14:20:44 -0800
To: mm-commits@vger.kernel.org,piaojun@huawei.com,mark@fasheh.com,junxiao.bi@oracle.com,joseph.qi@linux.alibaba.com,jlbec@evilplan.org,heming.zhao@suse.com,gechangwei@live.cn,gustavoars@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + ocfs2-avoid-wflex-array-member-not-at-end-warning.patch added to mm-nonmm-unstable branch
Message-Id: <20251203222045.125B2C4CEF5@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: ocfs2: avoid -Wflex-array-member-not-at-end warning
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     ocfs2-avoid-wflex-array-member-not-at-end-warning.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/ocfs2-avoid-wflex-array-member-not-at-end-warning.patch

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
From: "Gustavo A. R. Silva" <gustavoars@kernel.org>
Subject: ocfs2: avoid -Wflex-array-member-not-at-end warning
Date: Tue, 11 Nov 2025 12:01:19 +0900

-Wflex-array-member-not-at-end was introduced in GCC-14, and we are
getting ready to enable it, globally.

Use the new TRAILING_OVERLAP() helper to fix the following warning:

fs/ocfs2/xattr.c:52:41: warning: structure containing a flexible array member is not at the end of another structure [-Wflex-array-member-not-at-end]

This helper creates a union between a flexible-array member (FAM) and a
set of MEMBERS that would otherwise follow it.

This overlays the trailing MEMBER struct ocfs2_extent_rec er; onto the FAM
struct ocfs2_xattr_value_root::xr_list.l_recs[], while keeping the FAM and
the start of MEMBER aligned.

The static_assert() ensures this alignment remains, and it's intentionally
placed inmediately after the related structure --no blank line in between.

Link: https://lkml.kernel.org/r/aRKm_7aN7Smc3J5L@kspp
Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>
Reviewed-by: Heming Zhao <heming.zhao@suse.com>
Acked-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: Mark Fasheh <mark@fasheh.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Changwei Ge <gechangwei@live.cn>
Cc: Jun Piao <piaojun@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/xattr.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

--- a/fs/ocfs2/xattr.c~ocfs2-avoid-wflex-array-member-not-at-end-warning
+++ a/fs/ocfs2/xattr.c
@@ -49,9 +49,13 @@
 #include "ocfs2_trace.h"
 
 struct ocfs2_xattr_def_value_root {
-	struct ocfs2_xattr_value_root	xv;
-	struct ocfs2_extent_rec		er;
+	/* Must be last as it ends in a flexible-array member. */
+	TRAILING_OVERLAP(struct ocfs2_xattr_value_root, xv, xr_list.l_recs,
+		struct ocfs2_extent_rec		er;
+	);
 };
+static_assert(offsetof(struct ocfs2_xattr_def_value_root, xv.xr_list.l_recs) ==
+	      offsetof(struct ocfs2_xattr_def_value_root, er));
 
 struct ocfs2_xattr_bucket {
 	/* The inode these xattrs are associated with */
_

Patches currently in -mm which might be from gustavoars@kernel.org are

ocfs2-avoid-wflex-array-member-not-at-end-warning.patch

