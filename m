Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6F28146A6F
	for <mm-commits@vger.kernel.org>; Wed, 22 May 2024 22:13:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716416012; cv=none; b=N8FDSFDg9todlzj5E6/gMVaeXYPl2esOWUFCaaHhkNICk23xFQ3WS7Xp+RFhnlWriHHGCjJgNmPTJ9q95QvLDu3rq2gALg5s06hYsZOGOH/IqwLqOuTF2kHnLfeL6xbNfaV/axN5fRkxJhNxd8cnzgjG0GBjPU/t6qBErKxuCFY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716416012; c=relaxed/simple;
	bh=nvI2wBUjhIVgAE258GGuiJzE2JE+uYXOyXbJGLLwAnk=;
	h=Date:To:From:Subject:Message-Id; b=Yuk855ewbgWKdx5PdE/oKYwNsEuOsA8nxAkYFVaOw1TkfwqD+o8ZHCsCAGyU1JVeX2YU0o8nKIfNWjfkIfAJbKx30wOiW9fnTDOo16ykzTJbSoKghrqbTPVCrCg45ZKZzQR4txm8C01EDlTYQIdq1sPL2U6DQ/SwkZhQ/ZJ7Kak=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=DQ3PGSjM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="DQ3PGSjM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F1FFC3277B;
	Wed, 22 May 2024 22:13:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1716416012;
	bh=nvI2wBUjhIVgAE258GGuiJzE2JE+uYXOyXbJGLLwAnk=;
	h=Date:To:From:Subject:From;
	b=DQ3PGSjMdKHi04oNlyYZ6kHoIBcR+xkJ9BkRYTbKU6ETs5VEip80mKfZZbL5yR7ZV
	 DjCPVrduxpZ4jJdOTaZ/rhQQVqWOVJ8x8snCNd/wuVeUZGS6/nVyK16t297YTf54FD
	 w7K3MizovdFFwgE9In+WWJ98mnx1RJjD8cAF+Yo4=
Date: Wed, 22 May 2024 15:13:31 -0700
To: mm-commits@vger.kernel.org,piaojun@huawei.com,mark@fasheh.com,llfamsec@gmail.com,junxiao.bi@oracle.com,joseph.qi@linux.alibaba.com,jlbec@evilplan.org,ghe@suse.com,gechangwei@live.cn,mengferry@linux.alibaba.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + ocfs2-strict-bound-check-before-memcmp-in-ocfs2_xattr_find_entry.patch added to mm-nonmm-unstable branch
Message-Id: <20240522221332.7F1FFC3277B@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: ocfs2: strict bound check before memcmp in ocfs2_xattr_find_entry()
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     ocfs2-strict-bound-check-before-memcmp-in-ocfs2_xattr_find_entry.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/ocfs2-strict-bound-check-before-memcmp-in-ocfs2_xattr_find_entry.patch

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
From: Ferry Meng <mengferry@linux.alibaba.com>
Subject: ocfs2: strict bound check before memcmp in ocfs2_xattr_find_entry()
Date: Mon, 20 May 2024 10:40:24 +0800

xattr in ocfs2 maybe 'non-indexed', which saved with additional space
requested.  It's better to check if the memory is out of bound before
memcmp, although this possibility mainly comes from crafted poisonous
images.

Link: https://lkml.kernel.org/r/20240520024024.1976129-2-joseph.qi@linux.alibaba.com
Signed-off-by: Ferry Meng <mengferry@linux.alibaba.com>
Signed-off-by-by: Joseph Qi <joseph.qi@linux.alibaba.com>
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

ocfs2-add-bounds-checking-to-ocfs2_xattr_find_entry.patch
ocfs2-strict-bound-check-before-memcmp-in-ocfs2_xattr_find_entry.patch

