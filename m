Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C33237404E;
	Mon, 20 Jul 2026 05:32:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784525555; cv=none; b=WQDBlWo5rRVKOkB5Nw6NVvqWub8lKBmOSzjyMuMuDJhLfa3BIPk3vy1COxFpYjco8GjQdIHMv5bBzoqOgp7EsjlZUgDylT6a9Szc5+Bvy1k/BFKS8Gy+8UgH8b/yPyH5NDmjt2mHyEuAatawv9oVcBSy/v6w4ieB8RwiW6QE6MY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784525555; c=relaxed/simple;
	bh=27CTmuMcIAadBzgNTWSiG+pCiS0amthi8yWNl1gbbyc=;
	h=Date:To:From:Subject:Message-Id; b=P/OyO65SufmZ4wSgX7unBy0IPRVwdxSfmE7nOa34pWDUBqHOot5c1vfmRzpV4CYhDLS2vypwvhLn43jruU6b7cYZK5JN/9b2oGI8TBln37ujLkmp+xTYIxGf4IiLI7s5fl1jtJnNhcLbd3nyQ05BJo5VzAWTGrHwVUXmelP02cU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=eKpaHOQS; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="eKpaHOQS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 516FE1F000E9;
	Mon, 20 Jul 2026 05:32:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1784525553;
	bh=U91lKUXVJZO3AsueWMO2iGEZd8R98flRyOJKrVdt9zg=;
	h=Date:To:From:Subject;
	b=eKpaHOQSdBN88bD5vCFpDP+mWNVbs9xWIqslmuFvl06qmzWtazTVNKd2/BRiwCvJK
	 IGUifNahBhl3JEnOFxymcbFV0pDSWqZJJI75EwSdl68quC3MHoKOvZ3vATtN9w8qTv
	 CYXILYkGRwoWWAP38tXy4weQ0wgI+QArLKGNmfAU=
Date: Sun, 19 Jul 2026 22:32:32 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,piaojun@huawei.com,mark@fasheh.com,kees@kernel.org,junxiao.bi@oracle.com,joseph.qi@linux.alibaba.com,jlbec@evilplan.org,heming.zhao@suse.com,gechangwei@live.cn,doruk@0sec.ai,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + ocfs2-validate-directory-index-entry-counts-when-reading-metadata.patch added to mm-nonmm-unstable branch
Message-Id: <20260720053233.516FE1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: ocfs2: validate directory-index entry counts when reading metadata
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     ocfs2-validate-directory-index-entry-counts-when-reading-metadata.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/ocfs2-validate-directory-index-entry-counts-when-reading-metadata.patch

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
From: Doruk Tan Ozturk <doruk@0sec.ai>
Subject: ocfs2: validate directory-index entry counts when reading metadata
Date: Mon, 13 Jul 2026 22:56:25 +0200

ocfs2_validate_dx_leaf() and ocfs2_validate_dx_root() check the ECC and
signature of an indexed-directory block before it reaches higher-level
callers, but neither validator bounds the ocfs2_dx_entry_list counts
against the capacity of the block that holds them.

ocfs2_dx_dir_search() then walks

	for (i = 0; i < le16_to_cpu(entry_list->de_num_used); i++)
		dx_entry = &entry_list->de_entries[i];

over de_num_used entries with no bounds check.  entry_list is either
dx_leaf->dl_list (from ocfs2_read_dx_leaf) or, for an inline root,
dx_root->dr_entries.  A crafted on-disk image can set de_num_used (and
de_count, which is the __counted_by_le() bound of de_entries) to 0xffff
and make the walk read far past the end of the 4KB metadata block, giving
a slab out-of-bounds read reachable from any path lookup, stat() or open()
on an indexed directory once the image is mounted.

Commit 775c17386a6f ("ocfs2: validate dx_root extent list fields during
block read") already bounds dr_list for the non-inline dx_root, but left
the inline dr_entries path and the dx_leaf dl_list unchecked.  Add the
same read-time validation for both entry lists: de_count must equal the
capacity of the block (ocfs2_dx_entries_per_leaf()/per_root()) and
de_num_used must not exceed de_count, rejecting corrupted metadata with
-EFSCORRUPTED before ocfs2_dx_dir_search() can walk an out-of-range entry
array.

de_count is always written as exactly the block capacity when a leaf or
inline root is formatted, so the equality check does not reject any valid
image.

Found by 0sec automated security-research tooling (https://0sec.ai).

Link: https://lore.kernel.org/20260713205625.92391-1-doruk@0sec.ai
Fixes: 9b7895efac90 ("ocfs2: Add a name indexed b-tree to directory inodes")
Fixes: 4ed8a6bb083b ("ocfs2: Store dir index records inline")
Assisted-by: 0sec:claude-opus-4-8
Signed-off-by: Doruk Tan Ozturk <doruk@0sec.ai>
Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Kees Cook <kees@kernel.org>
Cc: Mark Fasheh <mark@fasheh.com>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Changwei Ge <gechangwei@live.cn>
Cc: Jun Piao <piaojun@huawei.com>
Cc: Heming Zhao <heming.zhao@suse.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/dir.c |   45 +++++++++++++++++++++++++++++++++++++++++----
 1 file changed, 41 insertions(+), 4 deletions(-)

--- a/fs/ocfs2/dir.c~ocfs2-validate-directory-index-entry-counts-when-reading-metadata
+++ a/fs/ocfs2/dir.c
@@ -625,6 +625,28 @@ static int ocfs2_validate_dx_root(struct
 					  le16_to_cpu(el->l_count));
 			goto bail;
 		}
+	} else {
+		struct ocfs2_dx_entry_list *dl_list = &dx_root->dr_entries;
+
+		if (le16_to_cpu(dl_list->de_count) !=
+		    ocfs2_dx_entries_per_root(sb)) {
+			ret = ocfs2_error(sb,
+					  "Dir Index Root # %llu has invalid de_count %u (expected %u)\n",
+					  (unsigned long long)le64_to_cpu(dx_root->dr_blkno),
+					  le16_to_cpu(dl_list->de_count),
+					  ocfs2_dx_entries_per_root(sb));
+			goto bail;
+		}
+
+		if (le16_to_cpu(dl_list->de_num_used) >
+		    le16_to_cpu(dl_list->de_count)) {
+			ret = ocfs2_error(sb,
+					  "Dir Index Root # %llu has invalid de_num_used %u (de_count %u)\n",
+					  (unsigned long long)le64_to_cpu(dx_root->dr_blkno),
+					  le16_to_cpu(dl_list->de_num_used),
+					  le16_to_cpu(dl_list->de_count));
+			goto bail;
+		}
 	}
 
 bail:
@@ -664,10 +686,25 @@ static int ocfs2_validate_dx_leaf(struct
 		return ret;
 	}
 
-	if (!OCFS2_IS_VALID_DX_LEAF(dx_leaf)) {
-		ret = ocfs2_error(sb, "Dir Index Leaf has bad signature %.*s\n",
-				  7, dx_leaf->dl_signature);
-	}
+	if (!OCFS2_IS_VALID_DX_LEAF(dx_leaf))
+		return ocfs2_error(sb, "Dir Index Leaf has bad signature %.*s\n",
+				   7, dx_leaf->dl_signature);
+
+	if (le16_to_cpu(dx_leaf->dl_list.de_count) !=
+	    ocfs2_dx_entries_per_leaf(sb))
+		return ocfs2_error(sb,
+				   "Dir Index Leaf # %llu has invalid de_count %u (expected %u)\n",
+				   (unsigned long long)le64_to_cpu(dx_leaf->dl_blkno),
+				   le16_to_cpu(dx_leaf->dl_list.de_count),
+				   ocfs2_dx_entries_per_leaf(sb));
+
+	if (le16_to_cpu(dx_leaf->dl_list.de_num_used) >
+	    le16_to_cpu(dx_leaf->dl_list.de_count))
+		return ocfs2_error(sb,
+				   "Dir Index Leaf # %llu has invalid de_num_used %u (de_count %u)\n",
+				   (unsigned long long)le64_to_cpu(dx_leaf->dl_blkno),
+				   le16_to_cpu(dx_leaf->dl_list.de_num_used),
+				   le16_to_cpu(dx_leaf->dl_list.de_count));
 
 	return ret;
 }
_

Patches currently in -mm which might be from doruk@0sec.ai are

ocfs2-validate-directory-index-entry-counts-when-reading-metadata.patch

