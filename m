Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4653C30649D
	for <mm-commits@vger.kernel.org>; Tue,  9 Dec 2025 19:33:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765308810; cv=none; b=Tew7rFzsRO7WDAb9klTe7WNd0aCxfvdxi3dYVgKCespStfI+malZ+eRjxb/92GKP7na8UYnVnbtXYGEVX+m/A7D+EuCOrSqvw4pzFANu9ghg+K80V6rI4yaK8sd1ZDBCnOd0jfHlQSt1zh8N9IEc7EtKnTj1VG4PXkUg9jYRnpI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765308810; c=relaxed/simple;
	bh=gFjTrCNAI9r/U3kmrJOpqrcuQsoIlEkFbDhBKvVzYEg=;
	h=Date:To:From:Subject:Message-Id; b=ULZmq2BUsifq+cYjNIQxK70IhUsVMvZecHSXRqp3P4qjh1Y5hw1BQ2TIVw0OsjhTIGd5fbt22OmTXODUObxReVuRasTb1ASITy/szBfRII2YqoLazZZxsI+Y4o9OX+J9N0UfyyH6XbaSqyad5QU8UVsfqEqyP3TH8HK94LFh/iE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Fl+fkPiL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Fl+fkPiL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1BE4CC4CEF5;
	Tue,  9 Dec 2025 19:33:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1765308810;
	bh=gFjTrCNAI9r/U3kmrJOpqrcuQsoIlEkFbDhBKvVzYEg=;
	h=Date:To:From:Subject:From;
	b=Fl+fkPiLceMA7u7pPGjYY1i86vO4EPY2aAsY9bHrn7oAAONSHXzQO1ofqXK9sjWs1
	 I6wtYOFl6jjXgvQ7qf90MjrwncB0buEoUKNYqitLEMNEKGDkxaesV4ZPPPrOBXQFW3
	 jH6xTOKIbEB5OwDsdoWdqjj/fOlRqzxGkBjxBoss=
Date: Tue, 09 Dec 2025 11:33:29 -0800
To: mm-commits@vger.kernel.org,piaojun@huawei.com,mark@fasheh.com,junxiao.bi@oracle.com,joseph.qi@linux.alibaba.com,jlbec@evilplan.org,heming.zhao@suse.com,gechangwei@live.cn,gustavoars@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] ocfs2-avoid-wflex-array-member-not-at-end-warning.patch removed from -mm tree
Message-Id: <20251209193330.1BE4CC4CEF5@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: ocfs2: avoid -Wflex-array-member-not-at-end warning
has been removed from the -mm tree.  Its filename was
     ocfs2-avoid-wflex-array-member-not-at-end-warning.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


