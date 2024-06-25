Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C63F433C0
	for <mm-commits@vger.kernel.org>; Tue, 25 Jun 2024 05:25:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719293153; cv=none; b=HQtp1WbA/MHGikBLRMnHrpmez7kCFpeG8LUtz4gwOZoQ+MC+K/n02XmdbQBKztxSt5wTpDilbBq41GVoB0uSQoH2+ib5fr8vobJ8yD9EgwnodgS2ISRFnupiUYzjYweH4tSeaGogh40CHCRnGrKuEVWqdHUEfpi44m6L88brjPc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719293153; c=relaxed/simple;
	bh=UqL1rqup8Ra0lh4w34Ce0jKX1rUI1Nf+D8YAe8/zbF0=;
	h=Date:To:From:Subject:Message-Id; b=PFd2In41cd0C06UkVRp/smMwqLOubtAUSegLXUl+ZOfu+8IoSxcwtQk0UiqBr6hKjeNlORvpwjuoM/OxLaZoZVn4WeY0hl+F2N+tQwdJQVraVWaMtVwuJNGKvgDPvAok7fxDhm5xG4nkFi5f1OUzwVLsXsiu8nLL9zw++GAoeMM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=faN+cjEt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="faN+cjEt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C9D8C32782;
	Tue, 25 Jun 2024 05:25:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1719293153;
	bh=UqL1rqup8Ra0lh4w34Ce0jKX1rUI1Nf+D8YAe8/zbF0=;
	h=Date:To:From:Subject:From;
	b=faN+cjEte5ye0X0oBUnOGZ+t5ildW8YQCuu0hGywlNnC74lsEl3YVkHkfYUVu8HzZ
	 bZAVKl3wKCxnqXN6kt0iKBVTsJY0Gibcyj/ZoMMJFEpCdB3a83MYpDLINXIdAeNXHv
	 V+1iY8uRRLU7bhxRluIPlNGMjgpjQHlpu7SpZc28=
Date: Mon, 24 Jun 2024 22:25:52 -0700
To: mm-commits@vger.kernel.org,piaojun@huawei.com,mark@fasheh.com,llfamsec@gmail.com,junxiao.bi@oracle.com,joseph.qi@linux.alibaba.com,jlbec@evilplan.org,ghe@suse.com,gechangwei@live.cn,mengferry@linux.alibaba.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] ocfs2-strict-bound-check-before-memcmp-in-ocfs2_xattr_find_entry.patch removed from -mm tree
Message-Id: <20240625052553.4C9D8C32782@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: ocfs2: strict bound check before memcmp in ocfs2_xattr_find_entry()
has been removed from the -mm tree.  Its filename was
     ocfs2-strict-bound-check-before-memcmp-in-ocfs2_xattr_find_entry.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Ferry Meng <mengferry@linux.alibaba.com>
Subject: ocfs2: strict bound check before memcmp in ocfs2_xattr_find_entry()
Date: Mon, 20 May 2024 10:40:24 +0800

xattr in ocfs2 maybe 'non-indexed', which saved with additional space
requested.  It's better to check if the memory is out of bound before
memcmp, although this possibility mainly comes from crafted poisonous
images.

Link: https://lkml.kernel.org/r/20240520024024.1976129-2-joseph.qi@linux.alibaba.com
Signed-off-by: Ferry Meng <mengferry@linux.alibaba.com>
Signed-off-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Reported-by: lei lu <llfamsec@gmail.com>
Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: Changwei Ge <gechangwei@live.cn>
Cc: Gang He <ghe@suse.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Jun Piao <piaojun@huawei.com>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Mark Fasheh <mark@fasheh.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/xattr.c |   15 ++++++++++-----
 1 file changed, 10 insertions(+), 5 deletions(-)

--- a/fs/ocfs2/xattr.c~ocfs2-strict-bound-check-before-memcmp-in-ocfs2_xattr_find_entry
+++ a/fs/ocfs2/xattr.c
@@ -1068,7 +1068,7 @@ static int ocfs2_xattr_find_entry(struct
 {
 	struct ocfs2_xattr_entry *entry;
 	size_t name_len;
-	int i, cmp = 1;
+	int i, name_offset, cmp = 1;
 
 	if (name == NULL)
 		return -EINVAL;
@@ -1083,10 +1083,15 @@ static int ocfs2_xattr_find_entry(struct
 		cmp = name_index - ocfs2_xattr_get_type(entry);
 		if (!cmp)
 			cmp = name_len - entry->xe_name_len;
-		if (!cmp)
-			cmp = memcmp(name, (xs->base +
-				     le16_to_cpu(entry->xe_name_offset)),
-				     name_len);
+		if (!cmp) {
+			name_offset = le16_to_cpu(entry->xe_name_offset);
+			if ((xs->base + name_offset + name_len) > xs->end) {
+				ocfs2_error(inode->i_sb,
+					    "corrupted xattr entries");
+				return -EFSCORRUPTED;
+			}
+			cmp = memcmp(name, (xs->base + name_offset), name_len);
+		}
 		if (cmp == 0)
 			break;
 		entry += 1;
_

Patches currently in -mm which might be from mengferry@linux.alibaba.com are


