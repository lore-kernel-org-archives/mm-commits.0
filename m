Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92C3333E5
	for <mm-commits@vger.kernel.org>; Tue, 12 Mar 2024 15:41:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710258100; cv=none; b=rtsZHbb8WghcRL3D0lHbn+HkyQWLUIQ9yuJXYDgp3xnzcdgRjWhXAOTpoCNSpZtvmLr7AundWZpdtA2Gl5eiuoq0bYS4xO3T3o/c3Zx9Fq+V5mzjrbvv35KRYVnbMwFiao7AgVPJBxAqlM739piXX+rZMWZfLDQo3TC7N9nWrcg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710258100; c=relaxed/simple;
	bh=t1vvqcsnQjGKcxRLQcCFJNwzTInp45OazDVx7yBvZ9I=;
	h=Date:To:From:Subject:Message-Id; b=aGMyfVEVGcRO68+9J9+I7mCxhRmHCpgnwVkMVX6ABpR3e9PHcYffzCeFAHXQh5++qOYMKevjc4P6JUYRJmeshzmbo8IaKBMwynDvvKgZU2BjHwWIwzS9DeYCTR0PCAsmJnoqEXOzGwfWrngk5Ni3aGTVZSaNvB0jB3p3a9y/Ksg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ojyaYcwd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ojyaYcwd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0FE78C433C7;
	Tue, 12 Mar 2024 15:41:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1710258100;
	bh=t1vvqcsnQjGKcxRLQcCFJNwzTInp45OazDVx7yBvZ9I=;
	h=Date:To:From:Subject:From;
	b=ojyaYcwd9UXJSq7jCjnRB+wzJZ8TsIUvSt52fx6LTNfnYipkmbiU/maVR+vm3aRwS
	 58YFU93Uj7Ii7QxaPpYDY2anV7PaEJU69/D465XnfnvzrC7bGJ9bqWrfvs6MfHj0jk
	 Iqn0xTIQ0l9OcdHVwyXtSgi9XV4YhPKpASjR57vc=
Date: Tue, 12 Mar 2024 08:41:39 -0700
To: mm-commits@vger.kernel.org,piaojun@huawei.com,mark@fasheh.com,junxiao.bi@oracle.com,joseph.qi@linux.alibaba.com,jlbec@evilplan.org,ghe@suse.com,gechangwei@live.cn,glass.su@suse.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + ocfs2-enable-ocfs2_listxattr-for-special-files.patch added to mm-nonmm-unstable branch
Message-Id: <20240312154140.0FE78C433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: ocfs2: enable ocfs2_listxattr for special files
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     ocfs2-enable-ocfs2_listxattr-for-special-files.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/ocfs2-enable-ocfs2_listxattr-for-special-files.patch

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
From: Su Yue <glass.su@suse.com>
Subject: ocfs2: enable ocfs2_listxattr for special files
Date: Tue, 12 Mar 2024 12:29:08 +0800

For special files in S_IFBLK/S_IFCHR/S_IFIFO type, we already have
ocfs2_setattr and ocfs2_getattr enabled.  It's confusing for user space if
it can use setattr/getattr to control one attribute appointed but can not
list attributes using listxattr for above type files:

$ mknod /mnt/b b 0 0
$ setfattr -h -n trusted.name -v 0xbabe /mnt/b
$ getfattr -n trusted.name  /mnt/b
getfattr: Removing leading '/' from absolute path names
trusted.name=0sur4=

$ getfattr -m trusted  /mnt/b
$

Fix it by enabling ocfs2_listxattr for ocfs2_special_file_iops.  After the
commit, fstests/generic/062 will pass.

Link: https://lkml.kernel.org/r/20240312042908.8889-1-l@damenly.org
Signed-off-by: Su Yue <glass.su@suse.com>
Acked-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: Mark Fasheh <mark@fasheh.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Changwei Ge <gechangwei@live.cn>
Cc: Gang He <ghe@suse.com>
Cc: Jun Piao <piaojun@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/file.c |    1 +
 1 file changed, 1 insertion(+)

--- a/fs/ocfs2/file.c~ocfs2-enable-ocfs2_listxattr-for-special-files
+++ a/fs/ocfs2/file.c
@@ -2763,6 +2763,7 @@ const struct inode_operations ocfs2_file
 const struct inode_operations ocfs2_special_file_iops = {
 	.setattr	= ocfs2_setattr,
 	.getattr	= ocfs2_getattr,
+	.listxattr	= ocfs2_listxattr,
 	.permission	= ocfs2_permission,
 	.get_inode_acl	= ocfs2_iop_get_acl,
 	.set_acl	= ocfs2_iop_set_acl,
_

Patches currently in -mm which might be from glass.su@suse.com are

ocfs2-enable-ocfs2_listxattr-for-special-files.patch

