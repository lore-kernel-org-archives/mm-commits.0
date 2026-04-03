Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A587A3D330B
	for <mm-commits@vger.kernel.org>; Fri,  3 Apr 2026 17:14:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775236466; cv=none; b=JrjxxCgKvn8WiRphomdqwFS0uTEr0OSVU0sgeO1zu7CYZW/CuQlwTon3CZnpimuzfY6+zI1RyhJAsyNSh9V1RslTIl1sPjvpBZoOi70iAtLVpgwtztL0JycTh0rxPat+3lujSkjPr3UfDYPJCmPxCzap1Lcsgpxh5VhiLZY56v0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775236466; c=relaxed/simple;
	bh=uWzuh81FANED/0+84U9Qby/uZ2INXDjtvpqIIdjyaYc=;
	h=Date:To:From:Subject:Message-Id; b=A+OKT83GQ/ozmhgei9v+NW0pNQxYnkrjnUdUCoR8/wJC2Qtuwi0C/vQHYt214bQ35lFtvtiQ0zrTtBmWo10k7nwDjmqFawFHy8aFBnEKD8/khzTWFnNiTX4QbR9EHJ/H3jze0Q+b1h7Y2vocpc2PjtcEUSPrjws+EYWz83Qbih4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=UeOyXgpM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="UeOyXgpM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E741C4CEF7;
	Fri,  3 Apr 2026 17:14:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1775236466;
	bh=uWzuh81FANED/0+84U9Qby/uZ2INXDjtvpqIIdjyaYc=;
	h=Date:To:From:Subject:From;
	b=UeOyXgpM1FA1jIWN8kLA5zsIVvEE6/9v87OibLG2hLbbbtSHUtAEISywG7VWQ3UPI
	 IdUxoWcPHmQjdTUcv3TSSVaYCHbWQUDq2n1aOWCixTgvDdm0mbc28WHNfjAX43pwJL
	 WtcCH7SaAV7aDLbwHJVbgmDFP+EF1hQKJOEZOtsM=
Date: Fri, 03 Apr 2026 10:14:25 -0700
To: mm-commits@vger.kernel.org,piaojun@huawei.com,mark@fasheh.com,junxiao.bi@oracle.com,jlbec@evilplan.org,heming.zhao@suse.com,gechangwei@live.cn,joseph.qi@linux.alibaba.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + ocfs2-remove-empty-extent-list-check-in-ocfs2_dx_dir_lookup_rec.patch added to mm-nonmm-unstable branch
Message-Id: <20260403171426.7E741C4CEF7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: ocfs2: remove empty extent list check in ocfs2_dx_dir_lookup_rec()
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     ocfs2-remove-empty-extent-list-check-in-ocfs2_dx_dir_lookup_rec.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/ocfs2-remove-empty-extent-list-check-in-ocfs2_dx_dir_lookup_rec.patch

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
From: Joseph Qi <joseph.qi@linux.alibaba.com>
Subject: ocfs2: remove empty extent list check in ocfs2_dx_dir_lookup_rec()
Date: Fri, 3 Apr 2026 17:08:01 +0800

The full extent list check is introduced by commit 44acc46d182f, which is
to avoid NULL pointer dereference if a dirent is not found.

Reworking the error message to not reference rec.  Instead, report
major_hash being looked up and l_next_free_rec, which naturally covers
both failure cases (empty extent list and no matching record) without
needing a separate l_next_free_rec == 0 guard.

Link: https://lkml.kernel.org/r/20260403090803.3860971-3-joseph.qi@linux.alibaba.com
Signed-off-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: Changwei Ge <gechangwei@live.cn>
Cc: Heming Zhao <heming.zhao@suse.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Jun Piao <piaojun@huawei.com>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Mark Fasheh <mark@fasheh.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/dir.c |   15 +++------------
 1 file changed, 3 insertions(+), 12 deletions(-)

--- a/fs/ocfs2/dir.c~ocfs2-remove-empty-extent-list-check-in-ocfs2_dx_dir_lookup_rec
+++ a/fs/ocfs2/dir.c
@@ -835,14 +835,6 @@ static int ocfs2_dx_dir_lookup_rec(struc
 		}
 	}
 
-	if (le16_to_cpu(el->l_next_free_rec) == 0) {
-		ret = ocfs2_error(inode->i_sb,
-				  "Inode %lu has empty extent list at depth %u\n",
-				  inode->i_ino,
-				  le16_to_cpu(el->l_tree_depth));
-		goto out;
-	}
-
 	found = 0;
 	for (i = le16_to_cpu(el->l_next_free_rec) - 1; i >= 0; i--) {
 		rec = &el->l_recs[i];
@@ -855,10 +847,9 @@ static int ocfs2_dx_dir_lookup_rec(struc
 
 	if (!found) {
 		ret = ocfs2_error(inode->i_sb,
-				  "Inode %lu has bad extent record (%u, %u, 0) in btree\n",
-				  inode->i_ino,
-				  le32_to_cpu(rec->e_cpos),
-				  ocfs2_rec_clusters(el, rec));
+				  "Inode %lu has no extent record for hash %u in btree (next_free_rec %u)\n",
+				  inode->i_ino, major_hash,
+				  le16_to_cpu(el->l_next_free_rec));
 		goto out;
 	}
 
_

Patches currently in -mm which might be from joseph.qi@linux.alibaba.com are

ocfs2-fix-out-of-bounds-write-in-ocfs2_write_end_inline.patch
ocfs2-validate-dx_root-extent-list-fields-during-block-read.patch
ocfs2-remove-empty-extent-list-check-in-ocfs2_dx_dir_lookup_rec.patch
ocfs2-validate-extent-block-list-fields-during-block-read.patch
ocfs2-remove-redundant-l_next_free_rec-check-in-__ocfs2_find_path.patch

