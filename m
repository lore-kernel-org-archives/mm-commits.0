Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2272D48B37F
	for <mm-commits@vger.kernel.org>; Thu, 11 Jun 2026 18:42:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781203380; cv=none; b=Em4nZ3Ko0+Ua+mde7nQBrhTW86jSzpBIUWTT1PgEkkqekdtQZqW41kjKFSWgd5W3C9t5sMY3BEOzIVqJpoCcbdAreEI94XYpSlBJ/QG/s40sK10W7f74arnsc9KmavA6AX5WRjw+J8A9hGTDUg+oizIyeDK2VRjC/4akuYNMsI8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781203380; c=relaxed/simple;
	bh=izuEK0nKcG+ZEphTbojiXuUmq/u99aGvw94AMKviFFM=;
	h=Date:To:From:Subject:Message-Id; b=A/wWqLu8QjGEeYHi/vCHsf4hLeB7sNrBgAi0pcsE4pT3mhlKQMiwY1zzlRKe40nxwTsJZo98YcEHIjvDKtK3KcEXqyovSH3ebJ13dUXBJno6UV8lMONHF7byhjPthkhvkbmhpCDOOPijyU+ppbk9r9ZE1bB38Pxyhb7tZyNTI3k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=BTeHKYfW; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="BTeHKYfW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A84261F000E9;
	Thu, 11 Jun 2026 18:42:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1781203378;
	bh=qzXhgOa+EDOHsD6PukWHo7EYdgrKeeS6aUP8qR/tP8Q=;
	h=Date:To:From:Subject;
	b=BTeHKYfWPXL0GKsw1x5buKQ4EDinWPUDwCz2hRpZRYnmDVRZg2dqEUYngvI04IGqv
	 ETN+YNHUGDZasAEqcMD7cB+Guxjl/cAzWfQYRnUyYriu0Y+XcwAAXwSND/IRYT71sc
	 HlfIcA0gKnRf+O8j79kO1lh4veZ7GeYdzzqaT6EY=
Date: Thu, 11 Jun 2026 11:42:58 -0700
To: mm-commits@vger.kernel.org,hirofumi@mail.parknet.co.jp,m32285159@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] fs-fat-inode-replace-sprintf-with-scnprintf.patch removed from -mm tree
Message-Id: <20260611184258.A84261F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: fs: fat: inode: replace sprintf() with scnprintf()
has been removed from the -mm tree.  Its filename was
     fs-fat-inode-replace-sprintf-with-scnprintf.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Maxwell Doose <m32285159@gmail.com>
Subject: fs: fat: inode: replace sprintf() with scnprintf()
Date: Wed, 3 Jun 2026 09:52:21 -0500

The kernel documentation notes that sprintf() is deprecated and unsafe. 
Replace it with the more preferred scnprintf() to help with hardening.

Link: https://lore.kernel.org/20260603145222.59012-1-m32285159@gmail.com
Signed-off-by: Maxwell Doose <m32285159@gmail.com>
Acked-by: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/fat/inode.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/fat/inode.c~fs-fat-inode-replace-sprintf-with-scnprintf
+++ a/fs/fat/inode.c
@@ -1786,7 +1786,7 @@ int fat_fill_super(struct super_block *s
 	 */
 
 	error = -EINVAL;
-	sprintf(buf, "cp%d", sbi->options.codepage);
+	scnprintf(buf, sizeof(buf), "cp%d", sbi->options.codepage);
 	sbi->nls_disk = load_nls(buf);
 	if (!sbi->nls_disk) {
 		fat_msg(sb, KERN_ERR, "codepage %s not found", buf);
_

Patches currently in -mm which might be from m32285159@gmail.com are


