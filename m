Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E11A77318B
	for <mm-commits@vger.kernel.org>; Thu, 14 Mar 2024 16:17:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710433073; cv=none; b=YEvUCexlvLA7jRvCzM4ZbpZGmC01Wuzkx/IgJzU2z9XKKLzx4plJYMjZXpVCJhBQjRHvK4iTG02QbJBWwQGGFEstbOWXgN28qFrI0ls/3CWlkqPKbnRULVzqF6ajINBYi1JP8YC0lyz6KiRsKDVGV6MpHC+ODgG4iKp7kuJ2GXY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710433073; c=relaxed/simple;
	bh=qKWRMKUC8e/lnkT2gQEVyeytguSkjudxvEFJJQYXYeQ=;
	h=Date:To:From:Subject:Message-Id; b=H2QDx729c2WtthVIQu+OIxhnuj/6Q6lrsYy7T1LRKkdS8Lek05d3gXziMmrmBpYYjcoiDho2A1tyB6frhdx75iWCw6VQ/5to7iaHx97WIYENnBJTczLaySYduV7qbYv2Hx1SoKFJhAUXKpo99MNYEomFrsLqRT5sp6ri6ZR/1XU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Z1+4cRu9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Z1+4cRu9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F1D6C433F1;
	Thu, 14 Mar 2024 16:17:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1710433072;
	bh=qKWRMKUC8e/lnkT2gQEVyeytguSkjudxvEFJJQYXYeQ=;
	h=Date:To:From:Subject:From;
	b=Z1+4cRu9Hm7g5TYcaPjpefJ4YKF37UR/4LYf2vIAOBa+RSs4QIlVbSwGTbtYhJNZp
	 ygKgEprrTzDmnLF2h48vosrgYCbfE6RWmOm/VBKZOzuNdPmU1t9nQc+neV7j14CNoG
	 CPGQ30FnJ9vohS3BLHRaPbnYm0QOxVwWbfMYw8GQ=
Date: Thu, 14 Mar 2024 09:17:51 -0700
To: mm-commits@vger.kernel.org,piaojun@huawei.com,mark@fasheh.com,junxiao.bi@oracle.com,joseph.qi@linux.alibaba.com,jlbec@evilplan.org,ghe@suse.com,gechangwei@live.cn,glass.su@suse.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] ocfs2-enable-ocfs2_listxattr-for-special-files.patch removed from -mm tree
Message-Id: <20240314161752.5F1D6C433F1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: ocfs2: enable ocfs2_listxattr for special files
has been removed from the -mm tree.  Its filename was
     ocfs2-enable-ocfs2_listxattr-for-special-files.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


