Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F8181F2360
	for <mm-commits@vger.kernel.org>; Wed, 11 Dec 2024 22:00:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733954404; cv=none; b=DTmq+ByWox71CvOGOZr8Ql8C8Bz5ZdQQhCBikrYJRH/YypHXsAyfQq5N78EiSNi3MGjqbf0U+TpbeJcltDgrGzmWf3Q4w7Nbgf4YRKy3clbaxy/2MgdEsDxupgqfTVuQ7GpSPcFYlXeqB/tkHr5962rTee83vrqBdLW9iULG4AU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733954404; c=relaxed/simple;
	bh=o+5GSyYwWG0jySsqFzqP1s7HDGgWKmDGYiiQXMb6zPA=;
	h=Date:To:From:Subject:Message-Id; b=KrLwb7JaexaVPeOXiLml2uvA+uA5i84+r4s8cyzVaqjqwWkyznRE5/dzWgWK4TaMc7bep1W4LYJI6fyEDT4UpJ6cu+YKmasdzh3rhPn5iwcWcfQjVhurNMYBk33ZjA2WZ6PSdZ0hAGRyRUc3tjx/YnV9xqFOhs4XVKJOFOqj2uA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=uWsaQcrH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="uWsaQcrH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 26720C4CEDD;
	Wed, 11 Dec 2024 22:00:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1733954404;
	bh=o+5GSyYwWG0jySsqFzqP1s7HDGgWKmDGYiiQXMb6zPA=;
	h=Date:To:From:Subject:From;
	b=uWsaQcrH5OZrntF3NLkajnvOlOXr3MRsuXfkDUKaOMBvfQBoWeM+toqAlmVaQGp0N
	 H27N/MC0adMYriOcRcgTKh84HepEmzjENRayWBPlYx70aPWeBI6OKmxXwLea19r9v1
	 IiFRL0I4ht7q7EmBF3x3yuvQMmAjXoojZIYUhYeM=
Date: Wed, 11 Dec 2024 14:00:03 -0800
To: mm-commits@vger.kernel.org,rgoldwyn@suse.com,piaojun@huawei.com,mark@fasheh.com,junxiao.bi@oracle.com,joseph.qi@linux.alibaba.com,jlbec@evilplan.org,gechangwei@live.cn,sandeen@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + dlmfs-convert-to-the-new-mount-api.patch added to mm-nonmm-unstable branch
Message-Id: <20241211220004.26720C4CEDD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: dlmfs: convert to the new mount API
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     dlmfs-convert-to-the-new-mount-api.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/dlmfs-convert-to-the-new-mount-api.patch

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
From: Eric Sandeen <sandeen@redhat.com>
Subject: dlmfs: convert to the new mount API
Date: Mon, 28 Oct 2024 09:41:14 -0500

Patch series "ocfs2, dlmfs: convert to the new mount API".


This patch (of 2):

Convert dlmfs to the new mount API.

Link: https://lkml.kernel.org/r/20241028144443.609151-1-sandeen@redhat.com
Link: https://lkml.kernel.org/r/20241028144443.609151-2-sandeen@redhat.com
Signed-off-by: Eric Sandeen <sandeen@redhat.com>
Reviewed-by: Goldwyn Rodrigues <rgoldwyn@suse.com>
Tested-by: Goldwyn Rodrigues <rgoldwyn@suse.com>
Acked-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Tested-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: Mark Fasheh <mark@fasheh.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Changwei Ge <gechangwei@live.cn>
Cc: Jun Piao <piaojun@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/dlmfs/dlmfs.c |   23 ++++++++++++++++-------
 1 file changed, 16 insertions(+), 7 deletions(-)

--- a/fs/ocfs2/dlmfs/dlmfs.c~dlmfs-convert-to-the-new-mount-api
+++ a/fs/ocfs2/dlmfs/dlmfs.c
@@ -20,6 +20,7 @@
 
 #include <linux/module.h>
 #include <linux/fs.h>
+#include <linux/fs_context.h>
 #include <linux/pagemap.h>
 #include <linux/types.h>
 #include <linux/slab.h>
@@ -506,9 +507,7 @@ bail:
 	return status;
 }
 
-static int dlmfs_fill_super(struct super_block * sb,
-			    void * data,
-			    int silent)
+static int dlmfs_fill_super(struct super_block *sb, struct fs_context *fc)
 {
 	sb->s_maxbytes = MAX_LFS_FILESIZE;
 	sb->s_blocksize = PAGE_SIZE;
@@ -556,17 +555,27 @@ static const struct inode_operations dlm
 	.setattr	= dlmfs_file_setattr,
 };
 
-static struct dentry *dlmfs_mount(struct file_system_type *fs_type,
-	int flags, const char *dev_name, void *data)
+static int dlmfs_get_tree(struct fs_context *fc)
 {
-	return mount_nodev(fs_type, flags, data, dlmfs_fill_super);
+	return get_tree_nodev(fc, dlmfs_fill_super);
+}
+
+static const struct fs_context_operations dlmfs_context_ops = {
+	.get_tree       = dlmfs_get_tree,
+};
+
+static int dlmfs_init_fs_context(struct fs_context *fc)
+{
+	fc->ops = &dlmfs_context_ops;
+
+	return 0;
 }
 
 static struct file_system_type dlmfs_fs_type = {
 	.owner		= THIS_MODULE,
 	.name		= "ocfs2_dlmfs",
-	.mount		= dlmfs_mount,
 	.kill_sb	= kill_litter_super,
+	.init_fs_context = dlmfs_init_fs_context,
 };
 MODULE_ALIAS_FS("ocfs2_dlmfs");
 
_

Patches currently in -mm which might be from sandeen@redhat.com are

dlmfs-convert-to-the-new-mount-api.patch
ocfs2-convert-to-the-new-mount-api.patch

